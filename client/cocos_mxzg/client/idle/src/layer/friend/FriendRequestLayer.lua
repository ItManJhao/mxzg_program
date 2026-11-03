local FriendRequestLayer = class("FriendCtr", require("src.comp.EventLayer"))
local FriendRequestCell =  require("src.layer.friend.FriendRequestCell")
local FriendCtr = require("src.layer.friend.FriendCtr"):instance()

function FriendRequestLayer:onCreate()
    self.cell_data = ex.Player.friend_data:getDataByLayerType(FRIEND_LAYER_TYPE.REQUEST_LIST)
    self.lbl_friend_num:enableOutline(cc.c4b(84,59,46,255))

    self:createTableView()
    self:updateView()
end

function FriendRequestLayer:updateOneKeyGived(event,data)
    if self.layer_type ~= FRIEND_LAYER_TYPE.FRIEND_LIST then return end 
    print(event,self.__cname)
    self.cell_data = ex.Player.friend_data:getDataByLayerType(FRIEND_LAYER_TYPE.REQUEST_LIST)
    self:updateView()
end

function FriendRequestLayer:onExit()

end

function FriendRequestLayer:onOneKey(tag,pSender)
    -- local req_get = Friend_pb.GReqFriendsGive()
    local total = 0 
    for i,v in ipairs(ex.Player.friend_data.my_friend) do
        if v.has_gift == 1 then total = total + 1 end 
    end
    print(self.__cname,"total",total)
    if total > 0 then 
        NetManager:sendMessage(ProtocolID.GReqFriendsRewardAll)
    end
end

function FriendRequestLayer:createTableView()
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

function FriendRequestLayer:updateView()
    self.cell_data = ex.Player.friend_data:getDataByLayerType(FRIEND_LAYER_TYPE.REQUEST_LIST)
    self.table_view:reloadData()

    self.lbl_friend_num:setString(string.format( ex.Tools:getLang(47462),table.nums(self.cell_data)))
end

function FriendRequestLayer:scrollViewDidScroll(view)
end

function FriendRequestLayer:cellSizeForTable(view, idx)
    return 552,110
end

function FriendRequestLayer:numberOfCellsInTableView(view)
    return table.nums(self.cell_data)
end

function FriendRequestLayer:tableCellAtIndex(view, idx)
    local cell = cc.TableViewCell:create()

    local friend_data = self.cell_data[idx + 1]
    dump(friend_data)
    cell.friend_id = friend_data.friend_id
    --  
    local cell_friend = FriendRequestCell:createWithCCBIFile("ccbi/FriendRequestCell.ccbi")
    cell.layer = cell_friend
    -- cell.layer:setVisibleByType(self.layer_type == LAYER_TYPE.FRIEND_LIST)
    cell_friend:reset(friend_data)
    cell_friend.friend_id = friend_data.friend_id
    cell_friend:setPosition(0, 0)
    -- cell_Friend:setScale(sel)
    cell_friend:setAnchorPoint(0, 0)
    -- local ctr = require("src.layer.friend.FriendCtr"):instance()

    -- cell.layer.firend_menu:setVisible(not FriendCtr:instance().delete_status)
    -- -- cell.layer.give_menu:setVisible(false)
    -- cell.layer.delete_menu:setVisible(FriendCtr:instance().delete_status)

    cell:addChild(cell_friend)

    return cell
end


function FriendRequestLayer:tableCellTouched(view, cell)

end

return FriendRequestLayer