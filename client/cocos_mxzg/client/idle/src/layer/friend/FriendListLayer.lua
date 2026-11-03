local FriendListLayer = class("FriendListLayer", require("src.comp.EventLayer"))
local FriendCell =  require("src.layer.friend.FriendCell")
local FriendSearchCtr = require("src.layer.friend.FriendSearchCtr"):instance()
local FriendCtr = require("src.layer.friend.FriendCtr"):instance()

function FriendListLayer:onCreate()
    self.cell_data = ex.Player.friend_data:getDataByLayerType(FRIEND_LAYER_TYPE.FRIEND_LIST)

    self:registerBtnEvent()
    self:createTableView()
    self:updateView()
end

function FriendListLayer:onDeleteFriend(event,data)
    print(self.__cname,event)
    self.cell_data = ex.Player.friend_data:getDataByLayerType(FRIEND_LAYER_TYPE.FRIEND_LIST)
    self:updateView()
end

function FriendListLayer:updateList(event,data)
    print(self.__cname)
    if self.layer_type ~= FRIEND_LAYER_TYPE.FRIEND_LIST then return end 
    self.cell_data = ex.Player.friend_data:getDataByLayerType(FRIEND_LAYER_TYPE.FRIEND_LIST)
    self:updateView()
end


function FriendListLayer:updateOneKeyGived(event,data)
    if self.layer_type ~= FRIEND_LAYER_TYPE.FRIEND_LIST then return end 
    print(event,self.__cname)
    self.cell_data = ex.Player.friend_data:getDataByLayerType(FRIEND_LAYER_TYPE.FRIEND_LIST)
    self:updateView()
end

function FriendListLayer:onExit()
    self.select_role_id = nil
    self.layer_type = nil
end

function FriendListLayer:registerBtnEvent()
    self.btn_gift:registerScriptTapHandler(handler(self, self.onGiftAll))
    self.btn_search:registerScriptTapHandler(handler(self, self.onSearch))
    self.btn_delete:registerScriptTapHandler(handler(self, self.onDeleteStatus))
end

function FriendListLayer:createTableView()
    -- body
    self.table_view = cpp.UITableViewEx:create(cc.size(self.spr_bg:getContentSize().width - 20, self.spr_bg:getContentSize().height - 20))
    self.table_view:setPosition(self.spr_bg:getPositionX() + 10, self.spr_bg:getPositionY() + 10)
    self.table_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.table_view:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.table_view:setBounceable(false)
    self.table_view:setDelegate()
    self.table_view:setDataSource()
    self:addChild(self.table_view)

    self.table_view:registerScriptHandler(handler(self, self.scrollViewDidScroll), cc.SCROLLVIEW_SCRIPT_SCROLL) --滚动时的回掉函数
    self.table_view:registerScriptHandler(handler(self, self.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX)    --列表项的尺寸
    self.table_view:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)     --创建列表项
    self.table_view:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW) --列表项的数量
    self.table_view:registerScriptHandler(handler(self, self.tableCellTouched), cc.TABLECELL_TOUCHED) --列表项被点击
end

function FriendListLayer:updateView(is_keep_offset)
    local offset_y = 0
    if self.table_view ~= nil and is_keep_offset ~= nil and is_keep_offset == true then
        offset_y = self.table_view:getContentOffset().y
    end

    local red_dot_manager = ex.RedDotManager
    red_dot_manager:setSpecialVisible(RedDotType.ZCJ_DHZC_HYAN_HYTJ,true)
    self.cell_data = ex.Player.friend_data:getDataByLayerType(FRIEND_LAYER_TYPE.FRIEND_LIST)
    self.table_view:reloadData()
    local friend_data = ex.Player.friend_data:getMyFriendData()
    local online_num = 0
    for k,v in pairs(friend_data) do
        if v.online_status == 1 then 
            online_num = online_num + 1
        end
    end
    if is_keep_offset then
        self.table_view:setContentOffset(cc.p(0, offset_y))
    end

    local max = ex.Tools:getSysCfg("global_friend_max")
    self.lbl_friend_num:setString(string.format( ex.Tools:getLang(47171),table.nums(friend_data),max))
    self:updateFriendNum()
end

function FriendListLayer:updateFriendNum()
    self.lbl_num:setString(ex.Player.backpack_data:getItemNum(900301))
end

function FriendListLayer:scrollViewDidScroll(view)
end

function FriendListLayer:cellSizeForTable(view, idx)
    return 552,110
end

function FriendListLayer:numberOfCellsInTableView(view)
    return table.nums(self.cell_data)
end

function FriendListLayer:tableCellAtIndex(view, idx)
    local cell = cc.TableViewCell:create()

    local friend_data = self.cell_data[idx + 1]
    cell.friend_id = friend_data.friend_id
    --  
    local cell_friend = FriendCell:createWithCCBIFile("ccbi/FriendCell.ccbi")
    cell.layer = cell_friend
    -- cell.layer:setVisibleByType(self.layer_type == LAYER_TYPE.FRIEND_LIST)
    cell_friend:reset(friend_data)
    cell_friend.friend_id = friend_data.friend_id
    cell_friend:setPosition(0, 0)
    -- cell_Friend:setScale(sel)
    cell_friend:setAnchorPoint(0, 0)
    -- local ctr = require("src.layer.friend.FriendCtr"):instance()

    cell.layer.firend_menu:setVisible(not FriendCtr:instance().delete_status)
    -- -- cell.layer.give_menu:setVisible(false)
    cell.layer.delete_menu:setVisible(FriendCtr:instance().delete_status)

    cell:addChild(cell_friend)
    cell:setContentSize(cell_friend:getContentSize())

    return cell
end

function FriendListLayer:tableCellTouched(view, cell)

end

function FriendListLayer:onGiftAll( tag,pSender )
    -- body
    print(self.__cname,"onGiftAll")
    local give_max = cfg.system.friend_reward_send_limit
    if give_max <= ex.Player.friend_data.give_count then 
        local str = ex.Tools:getLang(41143)
        ex.MessageView:add(str,0)
        return 
    end
    local friends_data = ex.Player.friend_data:getMyFriendData()
    if table.nums(friends_data) <= 0 then 
        local str = ex.Tools:getLang(4013)
        ex.MessageView:add(str)
    elseif ex.Player.friend_data:friendGiftAll() == true then 
        local str = ex.Tools:getLang(4014)
        ex.MessageView:add(str)
        self:updateView()
    else
        local str = ex.Tools:getLang(4015)
        ex.MessageView:add(str)
    end
    
end

function FriendListLayer:onSearch(tag, pSender)
    FriendSearchCtr:openWindow()
end

function FriendListLayer:onDeleteStatus(tag, pSender)
    -- body
    print(self.__cname,"onDeleteStatus")
    -- self.layer_type = FRIEND_LAYER_TYPE.FRIEND_LIST
    self.cell_data = ex.Player.friend_data:getDataByLayerType(FRIEND_LAYER_TYPE.FRIEND_LIST)
    FriendCtr:instance().delete_status = (not FriendCtr:instance().delete_status)
    -- self:showBtnByType()
    self:updateView(true)
    if not FriendCtr:instance().delete_status then 
        self.btn_delete:setLabelText(ex.Tools:getLang(29))
    else
        self.btn_delete:setLabelText(ex.Tools:getLang(47246))
    end
end


return FriendListLayer