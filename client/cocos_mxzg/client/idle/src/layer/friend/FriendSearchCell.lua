local FriendSearchCell = class("FriendSearchCell", require("src.comp.LuaLayerBase"))

function FriendSearchCell:onCreate()
	self:setAutoClose(false)
    self:setSwallowTouches(false)
    self.btn_request:setLabelText(ex.Tools:getLang(47587))
    self.btn_request:registerScriptTapHandler(handler(self, self.onAddFriend))
end

function FriendSearchCell:onAddFriend(tag,pSender)
    if ex.Player.role_id == self.data.role_id then 
        ex.MessageView:add(ex.Tools:getLang(47279), 1)
    end

    local friend_data = ex.Player.friend_data:getFriendById(self.data.role_id)
    if friend_data then 
        ex.MessageView:add(ex.Tools:getLang(47658), 1)
        return 
    end

    ex.Player.friend_data:delSearchList(self.data.role_id)

    -- local req = ProtocolID.GReqFriendsAdd 
    local req = Friend_pb.GReqFriendsAdd()
    req.rid = self.data.role_id

    -- NetManager:sendLuaData(req)
    NetManager:sendMessage(ProtocolID.GReqFriendsAdd,req)
    self.btn_request:setEnabled(false)
    self.btn_request:setLabelText(ex.Tools:getLang(47500))
end

function FriendSearchCell:reset(data)
    self.data = data

    self.lbl_name:setString(data.player_name)
    self.lbl_battle:setString(data.battle)
    self.lbl_level:setString(string.format(ex.Tools:getLang(47719),data.player_level) )
    
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
    local is_friend = ex.Player.friend_data:getFriendById(self.data.role_id)
    -- self.lbl_tips:setVisible(is_friend ~= nil)
    self.lbl_tips:setVisible(false)
    self.btn_request:setVisible(is_friend == nil)
end

function FriendSearchCell:getData()
    return self.data
end

return FriendSearchCell