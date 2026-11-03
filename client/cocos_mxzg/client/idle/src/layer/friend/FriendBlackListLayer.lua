local FriendBlackListLayer = class("FriendBlackListLayer", require("src.comp.EventLayer"))
local FriendBlackListCell =  require("src.layer.friend.FriendBlackListCell")
local FriendCtr = require("src.layer.friend.FriendCtr"):instance()

function FriendBlackListLayer:onCreate()
    self:createTableView()
    self:updateView()
end

function FriendBlackListLayer:updateOneKeyGived(event,data)
    if self.layer_type ~= FRIEND_LAYER_TYPE.BLACK_LIST then return end 
    
    self:updateView()
end

function FriendBlackListLayer:onExit()
    self.select_role_id = nil
    self.layer_type = nil
end

function FriendBlackListLayer:createTableView()
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

function FriendBlackListLayer:updateView()
    -- local red_dot_manager = ex.RedDotManager
    -- red_dot_manager:setSpecialVisible(RedDotType.ZCJ_DHZC_HYAN_HYTJ,true)

    self.cell_data = ex.Player.friend_data:getDataByLayerType(FRIEND_LAYER_TYPE.BLACK_LIST)
    self.table_view:reloadData()

    self.lbl_black_num:setString(string.format(ex.Tools:getLang(47106), #ex.Player.friend_data.friend_black_list, tonumber(ex.Tools:getSysCfg("blacklist_max_num"))))
end

function FriendBlackListLayer:scrollViewDidScroll(view)
end

function FriendBlackListLayer:cellSizeForTable(view, idx)
    return 552,110
end

function FriendBlackListLayer:numberOfCellsInTableView(view)
    return table.nums(self.cell_data)
end

function FriendBlackListLayer:tableCellAtIndex(view, idx)
    local cell = cc.TableViewCell:create()

    local friend_data = self.cell_data[idx + 1]
    cell.friend_id = friend_data.friend_id
    
    local cell_friend = FriendBlackListCell:createWithCCBIFile("ccbi/FriendBlackListCell.ccbi")
    cell.layer = cell_friend
    cell_friend:reset(friend_data)
    cell_friend.friend_id = friend_data.friend_id
    cell_friend:setPosition(0, 0)
    cell_friend:setAnchorPoint(0, 0)

    cell:addChild(cell_friend)

    return cell
end

function FriendBlackListLayer:tableCellTouched(view, cell)

end

return FriendBlackListLayer