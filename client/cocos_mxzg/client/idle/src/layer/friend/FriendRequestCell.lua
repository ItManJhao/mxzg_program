local FriendRequestCell = class("FriendRequestCell", require("src.comp.LuaLayerBase"))

function FriendRequestCell:onCreate()
	self:setAutoClose(false)
    self:setSwallowTouches(false)
    self.btn_agree:registerScriptTapHandler(handler(self, self.onAgree))
    self.btn_refuse:registerScriptTapHandler(handler(self, self.onRefuse))

    self.lbl_btn_agree = cc.Label:createWithTTF(ex.Tools:getLang(47316), FONT_DEFAULT_NAME_BOLD, 24)
    self.btn_agree:addChild(self.lbl_btn_agree)
    self.lbl_btn_agree:setPosition(self.btn_agree:getContentSize().width * 0.5, self.btn_agree:getContentSize().height * 0.5)
    self.lbl_btn_agree:enableOutline(cc.c4b(13,91,45,255), 2)

    self.lbl_btn_refuse = cc.Label:createWithTTF(ex.Tools:getLang(47548), FONT_DEFAULT_NAME_BOLD, 24)
    self.btn_refuse:addChild(self.lbl_btn_refuse)
    self.lbl_btn_refuse:setPosition(self.btn_refuse:getContentSize().width * 0.5, self.btn_refuse:getContentSize().height * 0.5)
    self.lbl_btn_refuse:enableOutline(FONT_BROWN, 2)
    self.lbl_btn_refuse:enableOutline(cc.c4b(131,43,22,255), 2)
end

function FriendRequestCell:onAgree(tag,pSender)
    local length = table.nums(ex.Player.friend_data:getMyFriendData())
    local max = ex.Tools:getSysCfg("global_friend_max")
    if length >= max then 
        ex.MessageView:add(ex.Tools:getLang(47187))
        return 
    end

	local req = Friend_pb.GReqFriendsAgree()
    req.role_id = self.data.role_id
    req.agree_status = 1
    NetManager:sendMessage(ProtocolID.GReqFriendsAgree,req)
    
    NetManager:sendMessage(ProtocolID.GReqFriendsRequestList)

    ex.Player.friend_data:delRequestList(self.data.role_id)
end

function FriendRequestCell:onRefuse(tag,pSender)
	local req = Friend_pb.GReqFriendsAgree()
    req.role_id = self.data.role_id
    req.agree_status = 2
	NetManager:sendMessage(ProtocolID.GReqFriendsAgree,req)

    NetManager:sendMessage(ProtocolID.GReqFriendsRequestList)

    ex.Player.friend_data:delRequestList(self.data.role_id)
    ex.EventManager:fire(EVENT.FRIEND_EVENT.UPDATE_FRIEND_LIST)
end

function FriendRequestCell:reset(data)
    self.data = data
    self.lbl_name:setString(data.player_name)
    self.lbl_battle:setString(data.battle)
    self.lbl_level:setString(string.format(ex.Tools:getLang(47719),data.player_level))
    
    local sfc = cc.SpriteFrameCache:getInstance()
    local frame = sfc:getSpriteFrame(string.format("head-icon/%d.png", self.data.head_id));
    if frame == nil then
        frame = sfc:getSpriteFrame("head-icon/0.png");
    end

    self.spr_photo:setSpriteFrame(frame)

    local border = sfc:getSpriteFrame(ex.Tools:getBorderIconByIdx(self.data.border_id))
    self.spr_frame:setSpriteFrame(border)

    if self.data.online_status == 0 then 
        local server_time = cpp.Game:instance():getServerTime()
        local offline_time = self.data.offline_time
        local remain = server_time - offline_time
        local str = ex.Tools:convertTimeInfo(remain)
        self.lbl_statue:setString(str)
    else
        self.lbl_statue:setString(ex.Tools:getLang(41172))
    end
end

function FriendRequestCell:getData()
    return self.data
end

return FriendRequestCell