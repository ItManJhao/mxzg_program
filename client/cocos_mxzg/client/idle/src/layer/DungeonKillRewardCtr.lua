local DungeonKillRewardCtr = class("DungeonKillRewardCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local DungeonKillRewardLayer = class("DungeonKillRewardLayer", require("src.comp.EventLayerAdaptiveWidth"))

local DungeonKillRewardCell = class("DungeonKillRewardCell", require("src.comp.LuaLayerBase"))

local UIMenu = require("src.comp.menu.UIMenu")

function DungeonKillRewardCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.btn_done:setLabelText(" ")
    self.btn_done:setLabelSize(36)
    self.btn_done:setLabelColor(FONT_BROWN)
end

function DungeonKillRewardLayer:onCreate()
    self:addBlackBackground()

    self.table_view = nil
end

-----------------------------------------------------------------------------
function DungeonKillRewardCtr:onCreate()
    self:setCCBIPath("ccbi/DungeonKillRewardLayer.ccbi")
    self:setIsSingle(false)
end

function DungeonKillRewardCtr:getLayerClass()
    return DungeonKillRewardLayer
end

function DungeonKillRewardCtr:getDungeonKillRewardLayer()
    return self.layer
end

function DungeonKillRewardCtr:openWindow(layer_type)
    if self:isOpened() then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/rank.plist")

    self:loadLayer()
    self:open()
    self:initData()
end

function DungeonKillRewardCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    self.kill_total_num = ex.Player.dungeon_data:getMonsterKillTotalNum()

    self:updateTableView()
end

function DungeonKillRewardCtr:updateTableView()
    -- print("DungeonKillRewardCtr:updateTableView")
    if self.layer.table_view ~= nil then
        self.layer.table_view:removeFromParent()
        self.layer.table_view = nil
    end

    self.layer.table_view = cpp.UITableViewEx:create(cc.size(self.layer.spr_scroll_bg:getContentSize().width - 10, self.layer.spr_scroll_bg:getContentSize().height - 10))
    self.layer.table_view:setPosition(self.layer.spr_scroll_bg:getPositionX() - self.layer.spr_scroll_bg:getContentSize().width / 2 + 5, 
                                      self.layer.spr_scroll_bg:getPositionY() - self.layer.spr_scroll_bg:getContentSize().height / 2 + 5)
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
    -- self.layer.table_view:registerScriptHandler(handler(self, self.tableCellWillRecycle),cc.TABLECELL_WILL_RECYCLE);            --列表项将被回收
    self.layer.table_view:registerScriptHandler(handler(self, self.tableCellTouched), cc.TABLECELL_TOUCHED) --列表项被点击
    -- self.layer.table_view:registerScriptHandler(handler(self, self.tableCellHighLight),cc.TABLECELL_HIGH_LIGHT);                --列表项高亮显示
    -- self.layer.table_view:registerScriptHandler(handler(self, self.tableCellUnhighLight),cc.TABLECELL_UNHIGH_LIGHT);            --列表项取消高亮

    self.layer.table_view:reloadData()
end

function DungeonKillRewardCtr:scrollViewDidScroll(view)
end

function DungeonKillRewardCtr:cellSizeForTable(view, idx)
    return 480, 155
end

function DungeonKillRewardCtr:numberOfCellsInTableView(view)
    return table.nums(cfg.shelterkillreward.shelterkillreward)
end

function DungeonKillRewardCtr:tableCellAtIndex(view, idx)
    -- 标记层数
    local cell = cc.TableViewCell:create()
    cell:setLocalZOrder(-idx)

    local data = cfg.shelterkillreward.shelterkillreward[100000 + (idx + 1) * 100]
    if data == nil then
        return cell
    end

    -- 创建ccbi cell
    local cell_layer = DungeonKillRewardCell:createWithCCBIFile("ccbi/DungeonKillRewardCell.ccbi")
    cell_layer:setPosition(5, 0)
    cell_layer:setAnchorPoint(0, 0)
    cell:addChild(cell_layer)

    local menu_reward = UIMenu:create();
    menu_reward:setPosition(cc.p(0, 0));
    menu_reward:setName("menu_reward")
    cell_layer:addChild(menu_reward, 10);

    local is_can_reward = ex.Player.dungeon_data:canKillReward(data.idx)
    print("is_can_reward:", is_can_reward)

    cell_layer.btn_done:setTag(100000 + (idx + 1) * 100)
    cell_layer.btn_done:setEnabled(is_can_reward == 0)
    if is_can_reward ~= 0 then
        cell_layer.btn_done:getNormalImage():setGLProgram(cpp.ShaderFactory:instance():getGLProgram(2))
    end
    cell_layer.btn_done:registerScriptTapHandler(handler(self, self.onReward))
    if is_can_reward == 0 then
        cell_layer.btn_done:setLabelText(ex.Tools:getLang(47695))
    elseif is_can_reward == 1 then
        cell_layer.btn_done:setLabelText(ex.Tools:getLang(47677))
    else
        cell_layer.btn_done:setLabelText(ex.Tools:getLang(47081))
    end

    cell_layer.lbl_title:setString(string.format(ex.Tools:getLang(47194), self.kill_total_num, data.win_times))
    cell_layer.lbl_num:setString(string.format("%d", data.win_times))

    for i, v in ipairs(data.reward) do
        local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
        item:setScale(0.75)
		item:setPosition(10 + (100 + 10) * (i - 0.5), 55)
		:registerScriptTapHandler(handler(self, self.onItemInfo))
		menu_reward:addChild(item)
    end

    return cell
end

function DungeonKillRewardCtr:tableCellTouched(view, cell)

end

function DungeonKillRewardCtr:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function DungeonKillRewardCtr:onReward(tag, pSender)
    print("DungeonKillRewardCtr:onReward: ", tag, pSender)
    local data = cfg.shelterkillreward.shelterkillreward[tag]

    if data == nil then
        return
    end

    ex.Player.dungeon_data:killReward(data.idx)
end

return DungeonKillRewardCtr
