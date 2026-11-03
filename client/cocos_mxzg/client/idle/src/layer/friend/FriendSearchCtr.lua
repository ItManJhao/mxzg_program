local FriendSearchCtr = class("FriendSearchCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local FriendSearchCell =  require("src.layer.friend.FriendSearchCell")
local FriendSearchLayer = class("FriendSearchLayer", require("src.comp.EventLayerAdaptiveWidth"))

function FriendSearchLayer:onCreate()
    self:addBlackBackground()
    self.cell_data = ex.Player.friend_data:getSearchData()
    self.btn_search:setLabelSize(44)
    self.btn_search:setLabelText(ex.Tools:getLang(47633))
    self.btn_friend:setLabelText(ex.Tools:getLang(47145))
    self.btn_friend:setChecked(false)
    self:createEditBox()
    -- self.lbl_tip:setLocalZOrder(1)
    -- self.lbl_tip:setVisible(false)
    self:createTableView()
    -- self:onTest()
    self.table_view:reloadData()
    local friend_data = ex.Player.friend_data:getMyFriendData()
    local max = ex.Tools:getSysCfg("global_friend_max")
    self.lbl_friend_num:setString(string.format( ex.Tools:getLang(47171),table.nums(friend_data),max))
    self.btn_refresh:setLabelText(ex.Tools:getLang(47708))
    self.btn_refresh:setLabelColor(FONT_BROWN)
    self.btn_refresh:setLabelSize(50)
    self.btn_close:registerScriptTapHandler(handler(self, self.onClose))
    self.btn_search:registerScriptTapHandler(handler(self, self.onSearch))
    self.btn_refresh:registerScriptTapHandler(handler(self, self.onRefresh))
    self:addEvent(EVENT.FRIEND_EVENT.UPDATE_SEARCH_LIST,handler(self,self.onSearchResult))
end

function FriendSearchLayer:onSearchResult(event,data)
    print(self.__cname,event)
    -- print(debug.traceback())
    self.cell_data = ex.Player.friend_data:getSearchData()
    self.table_view:reloadData()
end

-- function FriendSearchLayer:onTest()
--     for i=1,10 do
--         table.insert(self.cell_data,i)
--     end
--     self.table_view:reloadData()
-- end

function FriendSearchLayer:onClose()
    FriendSearchCtr:instance():closeWindow()
end

function FriendSearchLayer:createEditBox()
    local bg_size =  self.spr_input_bg:getContentSize()
    local size = cc.size(bg_size.width * self.spr_input_bg:getScaleX() - 40,bg_size.height * self.spr_input_bg:getScaleY() - 5)
    local spr = ccui.Scale9Sprite:create()
	self.edit_box = ccui.EditBox:create(size,spr,spr,spr)
	self.edit_box:setPosition(self.spr_input_bg:getPositionX() + 40 ,self.spr_input_bg:getPositionY())
	-- self.selectCount:anch(cc.p(0.5,0.5))
	self.edit_box:setAnchorPoint(cc.p(0,0))
	self.edit_box:setFontName(FONT_DEFAULT_NAME_BOLD)
	self.edit_box:setFontSize(24)
	self.edit_box:setFontColor(cc.WHITE)
	self.edit_box:setPlaceHolder(ex.Tools:getLang(47542))
	self.edit_box:setReturnType(cc.KEYBOARD_RETURNTYPE_DEFAULT)
	self.edit_box:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE) 
    self.edit_box:registerScriptEditBoxHandler(handler(self,self.editboxHandle))
    self.edit_box:setMaxLength(15)
    self.edit_box:setPlaceholderFontColor(cc.c3b(123,123,123))
	self:addChild(self.edit_box)
end

function FriendSearchLayer:editboxHandle( strEventName,sender )
	if strEventName == "began" then 
		-- sender:selectedAll()
	elseif strEventName == "ended" then 

	elseif strEventName == "changed" then

	end
end

function FriendSearchLayer:updateView(from_search)
    local search_data =  ex.Player.friend_data:getSearchData()
    
    self.table_view:reloadData()
end

function FriendSearchLayer:createTableView()
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

function FriendSearchLayer:scrollViewDidScroll(view)

end

function FriendSearchLayer:cellSizeForTable(view, idx)
    return 552,110
end

function FriendSearchLayer:numberOfCellsInTableView(view)
    return table.nums(self.cell_data)
end

function FriendSearchLayer:tableCellAtIndex(view, idx)
    local cell = cc.TableViewCell:create()

    local friend_data = self.cell_data[idx + 1]
    --  
    local cell_friend = FriendSearchCell:createWithCCBIFile("ccbi/FriendSearchCell.ccbi")
    cell_friend:reset(friend_data)
    cell_friend.player_id = friend_data.role_id
    cell_friend:setPosition(0, 0)

    cell_friend:setAnchorPoint(0, 0)
    cell:addChild(cell_friend)

    return cell
end

function FriendSearchLayer:tableCellTouched(view, cell)

end

function  FriendSearchLayer:onSearch(tag,pSender)
    print(self.__cname,"onSearch")
    local str_name = self.edit_box:getText()
    print(self.__cname,str_name)
    if (string.len(str_name) <= 0) then
        ex.MessageView:add(ex.Tools:getLang(41164))
        return
    end
    
	local req_search = Friend_pb.GReqFriendsSearch()
    req_search.rName = str_name
	NetManager:sendMessage(ProtocolID.GReqFriendsSearch,req_search)    
end

function  FriendSearchLayer:onRefresh(tag,pSender)

	local req_search = Friend_pb.GReqFriendsSearch()
    req_search.rName = ""
	NetManager:sendMessage(ProtocolID.GReqFriendsSearch,req_search)    
end

-- ------------------------------------------------

function FriendSearchCtr:onCreate()
    self:setCCBIPath("ccbi/FriendSearchLayer.ccbi")

    self:setIsSingle(false)
end

function FriendSearchCtr:initData()
    self.layer.cell_data = ex.Player.friend_data:getSearchData()
    self.layer.table_view:reloadData()

    local req_search = Friend_pb.GReqFriendsSearch()
    req_search.rName = ""
	NetManager:sendMessage(ProtocolID.GReqFriendsSearch,req_search)  
end

function FriendSearchCtr:getLayerClass()
    return FriendSearchLayer
end

function FriendSearchCtr:getLayer()
    return self.layer
end

function FriendSearchCtr:openWindow()
    if self:isOpened() then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/friend.plist")
    sfc:addSpriteFrames("ccbi-res/photo.plist")

    self:loadLayer()
    self:open()
    self:initData()
end

return FriendSearchCtr