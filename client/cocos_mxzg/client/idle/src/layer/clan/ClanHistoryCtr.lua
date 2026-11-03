local ClanHistoryCtr = class("ClanHistoryCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ClanHistoryLayer = class("ClanHistoryLayer", require("src.comp.EventLayerAdaptiveWidth"))

local ClanHistoryCell = class("ClanHistoryCell", require("src.comp.LuaLayerBase"))
function ClanHistoryCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

end

function ClanHistoryLayer:onCreate()
    self:setAutoClose(true)
    self:setSwallowTouches(true)
    self:addBlackBackground()

    self:initDone()
    
    -- self.spr_bg:setVisible(false)
end

function ClanHistoryLayer:initDone()

end

-----------------------------------------------------------------------------
function ClanHistoryCtr:onCreate()
    self:setCCBIPath("ccbi/ClanHistoryLayer.ccbi")
    self:setIsSingle(false)
end

function ClanHistoryCtr:getLayerClass()
    return ClanHistoryLayer
end

function ClanHistoryCtr:getClanRankLayer()
    return self.layer
end

function ClanHistoryCtr:openWindow(layer_type)
    if self:isOpened() then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/clan.plist")

    self:loadLayer()
    self:open()
    self:initData()
end

function ClanHistoryCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    
    self.list = {}

    NetManager:sendMessage(ProtocolID.GReqClanMsgInfo)

    self:refreshData()

    self:registerEvent()
    self:updateTableView()
end

function ClanHistoryCtr:registerEvent()
   self.layer:addEvent(EVENT.CLAN_EVENT.CLAN_HISTORY, handler(self, self.receiveRes))
end

function ClanHistoryCtr:refreshData()
    if table.nums(ex.Player.clan_data.clan_history_list) <= 0 then
        print("clan history has no data")
        return
    end

    self.list = {}     -- 获取一个列表，关键字为天数，按照天数从小到大排序

    for i,v_i in ipairs(ex.Player.clan_data.clan_history_list) do
        local days = Maths.getDays(v_i.time)

        local is_have = false
        for j,v_j in ipairs(self.list) do
            if v_j[1][1] == days then
                is_have = true

                table.insert(self.list[j], {days, v_i})
                break;
            end
        end
        if is_have == false then
            table.insert(self.list, {})
            table.insert(self.list[table.nums(self.list)], {days, v_i})
        end
    end

    table.sort( self.list, function(a, b)
        return a[1][1] > b[1][1]
    end )
end

function ClanHistoryCtr:receiveRes(event)
    self:refreshData()

    self:updateTableView()
end

function ClanHistoryCtr:updateTableView()
    print("ClanHistoryCtr:updateTableView")
    if self.layer.table_view ~= nil then
        self.layer.table_view:removeFromParentAndCleanup(true)
        self.layer.table_view = nil
    end

    if table.nums(self.list) <= 0 then
        return
    end

    self.layer.table_view = cpp.UITableViewEx:create(cc.size(self.layer.spr_bg:getContentSize().width - 10, self.layer.spr_bg:getContentSize().height - 10))
    self.layer.table_view:setIgnoreAnchorPointForPosition(false)
    self.layer.table_view:setAnchorPoint(cc.p(0.5, 0.5))
    self.layer.table_view:setPosition(self.layer.spr_bg:getPosition())
    self.layer.table_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.layer.table_view:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.layer.table_view:setBounceable(false)
    self.layer.table_view:setDelegate()
    self.layer.table_view:setDataSource()
    self.layer.table_view:setMoveSpeed(0.7)
    self.layer:addChild(self.layer.table_view, 10)

    self.layer.table_view:registerScriptHandler(handler(self, self.scrollViewDidScroll), cc.SCROLLVIEW_SCRIPT_SCROLL) --滚动时的回掉函数
    self.layer.table_view:registerScriptHandler(handler(self, self.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX) --列表项的尺寸
    self.layer.table_view:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX) --创建列表项
    self.layer.table_view:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW) --列表项的数量
    -- self.table_view:registerScriptHandler( handler(self, self.tableCellWillRecycle),cc.TABLECELL_WILL_RECYCLE);            --列表项将被回收
    self.layer.table_view:registerScriptHandler(handler(self, self.tableCellTouched), cc.TABLECELL_TOUCHED) --列表项被点击
    -- self.table_view:registerScriptHandler( handler(self, self.tableCellHighLight),cc.TABLECELL_HIGH_LIGHT);                --列表项高亮显示
    -- self.table_view:registerScriptHandler( handler(self, self.tableCellUnhighLight),cc.TABLECELL_UNHIGH_LIGHT);            --列表项取消高亮

    self.layer.table_view:reloadData()
end

function ClanHistoryCtr:scrollViewDidScroll(view)
end

function ClanHistoryCtr:cellSizeForTable(view, idx)
    local data = self.list[idx + 1]
    return 550, 50 + table.nums(data) * 30
end

function ClanHistoryCtr:numberOfCellsInTableView(view)
    return table.nums(self.list)
end

function ClanHistoryCtr:tableCellAtIndex(view, idx)
    -- 标记层数
    local cell = cc.TableViewCell:create()
    cell:setLocalZOrder(-idx)

    local data = self.list[idx + 1]
    if data == nil then
        print("clan history data is nil")
        return cell
    end

    -- 创建ccbi cell
    local cell_history = ClanHistoryCell:createWithCCBIFile("ccbi/ClanHistoryCell.ccbi")
    cell_history:setPosition(0, 0)
    cell_history:setAnchorPoint(0, 0)
    cell:addChild(cell_history)

    -- 设置cell大小
    cell_history:setContentSize(cc.size(550, 40 + table.nums(data) * 30))
    cell_history.spr_cell_bg:setContentSize(cell_history:getContentSize())

    local now = data[1][2].time;
    local time_data = os.date("*t", now)
    cell_history.lbl_date:setString(string.format("%d-%d", time_data.month, time_data.day))

    cell_history.lbl_date:setPositionY(cell_history:getContentSize().height - 15)

    for i,v in ipairs(data) do
        -- 1. 同意成员申请 2. 退出军团 3. 管理员踢掉成员 4. 成员被升职 5.降职 6.加入军团
        local tmp_data = v[2]

        -- local lbl_handle = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 42)
        -- lbl_handle:setScale(0.5)
        -- lbl_handle:setColor(FONT_BLACK)
        -- lbl_handle:setAnchorPoint(cc.p(0, 0.5))
        -- lbl_handle:setPosition(20, i * 30 - 10)
        -- cell_history:addChild(lbl_handle)

        -- add 熊梦 工会富文本
        local lbl_handle = require("src.comp.RichTextEx"):create()
        :setFontSize(20)
        :setFontFace(FONT_DEFAULT_NAME_BOLD)
        :setFontColor("#836045")
        :setAnchorPoint(cc.p(0, 0.5))
        :setAnchorTextShadow(true)
        :ignoreContentAdaptWithSize(false)
        :setWrapMode(1)
        lbl_handle:setContentSize(cc.size(550, 40 + table.nums(data) * 30))
        lbl_handle:setPosition(20, i * 30 - 10)
        cell_history:addChild(lbl_handle)

        -- data.manager_id = byte_array:readInt64()                -- 操作人的rid;
        -- data.member_id = byte_array:readInt64()                 -- 被操作人的rid;
        -- data.info_type = byte_array:readInt8()                  -- 1. 同意成员申请 2. 退出军团 3. 管理员踢掉成员 4. 成员被升职  5.降职 6. 加入军团
        -- data.member_name = byte_array:readString(NAME_LENGTH)   -- 被操作人名
        -- data.manager_name = byte_array:readString(NAME_LENGTH)  -- 操作人名
        -- data.value = byte_array:readInt8()                      -- 操作后的变量 info_type为4、5:当前职位；8：击杀的副本boss类型；9：进行捐献类型
        -- data.time = byte_array:readInt()                        -- 操作时间

        if tmp_data.info_type == 1 then
            --lbl_handle:setString(string.format("%s%s同意%s的加入申请", ex.Player.clan_data:getPosStringWithPos(tmp_data.value), tmp_data.manager_name, tmp_data.member_name))
            lbl_handle:setXmlTextLua(string.format(ex.Tools:getLang(3009), ex.Player.clan_data:getPosStringWithPos(tmp_data.value), tmp_data.manager_name, tmp_data.member_name))
            lbl_handle:formatText()
        elseif tmp_data.info_type == 2 then
            --lbl_handle:setString(string.format(ex.Tools:getLang(47141), tmp_data.manager_name))
            lbl_handle:setXmlTextLua(string.format(ex.Tools:getLang(47141), tmp_data.manager_name))
            lbl_handle:formatText()
        elseif tmp_data.info_type == 3 then
            --lbl_handle:setString(string.format(ex.Tools:getLang(47206), ex.Player.clan_data:getPosStringWithPos(tmp_data.value), tmp_data.manager_name, tmp_data.member_name))
            lbl_handle:setXmlTextLua(string.format(ex.Tools:getLang(47206), ex.Player.clan_data:getPosStringWithPos(tmp_data.value), tmp_data.manager_name, tmp_data.member_name))
            lbl_handle:formatText()
        elseif tmp_data.info_type == 4 then
            --lbl_handle:setString(string.format(ex.Tools:getLang(47132), tmp_data.manager_name, tmp_data.member_name, ex.Player.clan_data:getPosStringWithPos(tmp_data.value)))
            lbl_handle:setXmlTextLua(string.format(ex.Tools:getLang(47132),  tmp_data.manager_name, tmp_data.member_name, ex.Player.clan_data:getPosStringWithPos(tmp_data.value)))
            lbl_handle:formatText()
        elseif tmp_data.info_type == 5 then
            --lbl_handle:setString(string.format(ex.Tools:getLang(47558), tmp_data.manager_name, tmp_data.member_name, ex.Player.clan_data:getPosStringWithPos(tmp_data.value)))
            lbl_handle:setXmlTextLua(string.format(ex.Tools:getLang(47558),  tmp_data.manager_name, tmp_data.member_name, ex.Player.clan_data:getPosStringWithPos(tmp_data.value)))
            lbl_handle:formatText()
        elseif tmp_data.info_type == 6 then
            --lbl_handle:setString(string.format(ex.Tools:getLang(47263), tmp_data.member_name))
            lbl_handle:setXmlTextLua(string.format(ex.Tools:getLang(47263), tmp_data.manager_name))
            lbl_handle:formatText()
        elseif tmp_data.info_type == 7 then
            --lbl_handle:setString(string.format(ex.Tools:getLang(47285), tmp_data.manager_name))
            lbl_handle:setXmlTextLua(string.format(ex.Tools:getLang(47285), tmp_data.manager_name))
            lbl_handle:formatText()
        elseif tmp_data.info_type == 8 then
            local monster_name = ex.Tools:getLang(tmp_data.value)
            lbl_handle:setXmlTextLua(string.format(ex.Tools:getLang(47522), tmp_data.manager_name, monster_name))
            lbl_handle:formatText()
           -- lbl_handle:setString(string.format(ex.Tools:getLang(47522), tmp_data.manager_name, monster_name))
        elseif tmp_data.info_type == 9 then
            lbl_handle:setXmlTextLua(string.format(ex.Tools:getLang(47066), tmp_data.manager_name, ex.Tools:getLang(3000 + tmp_data.value)))
            lbl_handle:formatText()  
            --lbl_handle:setString(string.format(ex.Tools:getLang(47066), tmp_data.manager_name, ex.Tools:getLang(3000 + tmp_data.value)))
        elseif tmp_data.info_type == 10 then
            lbl_handle:setXmlTextLua(string.format(ex.Tools:getLang(3010), tmp_data.member_name, tmp_data.manager_name))
            lbl_handle:formatText()  
            --lbl_handle:setString(string.format(ex.Tools:getLang(47066), tmp_data.manager_name, ex.Tools:getLang(3000 + tmp_data.value)))
        end
    end

    return cell
end

function ClanHistoryCtr:tableCellTouched(view, cell)
    
end

return ClanHistoryCtr
