local FriendGivedLayer = class("FriendCtr", require("src.comp.EventLayer"))
local FriendGivedCell =  require("src.layer.friend.FriendGivedCell")
local FriendCtr = require("src.layer.friend.FriendCtr"):instance()

function FriendGivedLayer:onCreate()
    -- self.cell_data = ex.Player.friend_data:getDataByLayerType(FRIEND_LAYER_TYPE.GIFT_LIST)

	self:addFont()
    self:registerBtnEvent()
    self:createTableView()
    self:updateView()

end



function FriendGivedLayer:updateOneKeyGived(event,data)
    if self.layer_type ~= FRIEND_LAYER_TYPE.GIFT_LIST then return end 
    print(event,self.__cname)
    -- self.cell_data = ex.Player.friend_data:getDataByLayerType(FRIEND_LAYER_TYPE.FRIEND_LIST)
    self:updateView()
end

function FriendGivedLayer:onExit()
    self.select_role_id = nil
    self.layer_type = nil
end

function FriendGivedLayer:addFont()
    -- self.btn_one_key_gived:setLabelText(ex.Tools:getLang(47179)) 
	self.lbl_btn_one_key_gived = cc.Label:createWithTTF(ex.Tools:getLang(47179), FONT_DEFAULT_NAME_BOLD, 24)
	self.btn_one_key_gived:addChild(self.lbl_btn_one_key_gived)
	self.lbl_btn_one_key_gived:setColor(cc.c4b(103,56,14,255))
	self.lbl_btn_one_key_gived:setPosition(self.btn_one_key_gived:getContentSize().width/2,self.btn_one_key_gived:getContentSize().height/2)
end

function FriendGivedLayer:registerBtnEvent()
    self.btn_one_key_gived:registerScriptTapHandler(handler(self, self.onOneKey))
end

function FriendGivedLayer:onOneKey(tag,pSender)
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

function FriendGivedLayer:createTableView()
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

function FriendGivedLayer:updateView()

    local red_dot_manager = ex.RedDotManager
    red_dot_manager:setSpecialVisible(RedDotType.ZCJ_DHZC_HYAN_HYTJ,true)
    self.cell_data = {}
    local data = ex.Player.friend_data:getDataByLayerType(FRIEND_LAYER_TYPE.FRIEND_LIST)
    for i,v in ipairs(data) do
        if v.has_gift == 1 then 
            table.insert(self.cell_data,v)
        end
    end
    self.table_view:reloadData()
    local friend_data = ex.Player.friend_data:getMyFriendData()
    local online_num = 0
    for k,v in pairs(friend_data) do
        if v.online_status == 1 then 
            online_num = online_num + 1
        end
    end
    local num = 0
    for i,v in pairs(friend_data) do
        if v.has_gift == 1 then 
            num = num + 1
        end
    end
    self.lbl_friend_num:setString(string.format( ex.Tools:getLang(47410),num))
    self:updateFriendNum()
end

function FriendGivedLayer:updateFriendNum()
    self.lbl_num:setString(ex.Player.backpack_data:getItemNum(900301))
end

function FriendGivedLayer:scrollViewDidScroll(view)
end

function FriendGivedLayer:cellSizeForTable(view, idx)
    return 552,110
end

function FriendGivedLayer:numberOfCellsInTableView(view)
    return table.nums(self.cell_data)
end

function FriendGivedLayer:tableCellAtIndex(view, idx)
    local cell = cc.TableViewCell:create()

    local friend_data = self.cell_data[idx + 1]
    cell.friend_id = friend_data.friend_id
    
    local cell_friend = FriendGivedCell:createWithCCBIFile("ccbi/FriendGivedCell.ccbi")
    cell.layer = cell_friend
    cell_friend:reset(friend_data)
    cell_friend.friend_id = friend_data.friend_id
    cell_friend:setPosition(0, 0)
    cell_friend:setAnchorPoint(0, 0)
    
    cell:addChild(cell_friend)

    return cell
end


function FriendGivedLayer:tableCellTouched(view, cell)

end

return FriendGivedLayer