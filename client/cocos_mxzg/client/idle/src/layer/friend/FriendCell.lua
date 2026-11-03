local FriendCell = class("FriendCell", require("src.comp.LuaLayerBase"))

function FriendCell:onCreate()
	self:setAutoClose(false)
    self:setSwallowTouches(false)
    self.btn_chat:setLabelText(ex.Tools:getLang(47469))
    -- self.btn_to:setLabelText(ex.Tools:getLang(47565))
    self.btn_delete:setLabelText(ex.Tools:getLang(47756))
    self.btn_chat:registerScriptTapHandler(handler(self, self.onChat))
    self.btn_gift:registerScriptTapHandler(handler(self, self.onGift))
    self.btn_delete:registerScriptTapHandler(handler(self, self.onDelete))
    self.btn_info:registerScriptTapHandler(handler(self, self.onFriendInfo))
    self.btn_info:setContentSize(cc.size(104,104))
    -- self.btn_get:registerScriptTapHandler(handler(self, self.onGet))
    -- self.btn_to:registerScriptTapHandler(handler(self, self.onTo))
end

function FriendCell:onFriendInfo(tag,pSender)
    ex.Tools:showPlayerInfo(self.data.role_id, cc.UserDefault:getInstance():getIntegerForKey("server_id"))
end

function FriendCell:onDelete(tag,pSender)
    

    local callback = function ()
        local req = Friend_pb.GReqFriendsDelete()
        req.rid = self.data.role_id
        NetManager:sendMessage(ProtocolID.GReqFriendsDelete,req)
    end
    require("src.layer.ConfirmCtr"):instance() :instance():openWindow(ex.Tools:getLang(47352),
    ex.Tools:getLang(41162),
    callback)
end

-- function FriendCell:onGet(tag,pSender)
--     print(self.__cname,"onGet")

--     if self.data.has_gift == 2 then return end
--     local player_id = self.data.role_id 
--     local req_get = Friend_pb.GReqFriendsReward()
--     req_get.rid = player_id
--     NetManager:sendMessage(ProtocolID.GReqFriendsReward, req_get)

--     local normal = self.btn_get:getNormalImage()
--     local select = self.btn_get:getSelectedImage()

--     -- local is_gray = self.data.is_reward == 1
--     -- local is_gray = self.data.has_gift == 2
--     self.data.has_gift = 2
--     local is_gray = self.data.has_gift == 2

--     ex.Tools:setGrayAuto(normal, is_gray)
--     ex.Tools:setGrayAuto(select, is_gray)
-- end

-- function FriendCell:onTo(tag,pSender)
--     print(self.__cname,"onTo")

--     if self.data.is_gived == 1 then return end

--     local normal = self.btn_to:getNormalImage()
--     local select = self.btn_to:getSelectedImage()


--     self.data.is_gived = 1
--     local is_gray = (self.data.is_gived == 1) or ex.Player.friend_data.give_count >= cfg.system.friend_reward_send_limit

--     ex.Tools:setGrayAuto(normal, is_gray)
--     ex.Tools:setGrayAuto(select, is_gray)

--     if ex.Player.friend_data.give_count >= cfg.system.friend_reward_send_limit then 
--         -- ex.MessageView:add(ex.Tools:getLang(41143))
--         return 
--     end

--     local player_id = self.data.role_id 
--     local req_get = Friend_pb.GReqFriendsGive()
--     req_get.rid = player_id
--     NetManager:sendMessage(ProtocolID.GReqFriendsGive, req_get)
-- end

-- function FriendCell:setVisibleByType(bool)
--     print(self.__cname,bool)
--     self.firend_menu:setVisible(bool)
--     self.give_menu:setVisible(not bool)
-- end

function FriendCell:onChat(tag,pSender)
    ex.Player.chat_data:insertFriendChatCache(self.data.role_id)

    local chat_ctr = require("src.layer.ChatCtr"):instance()
    chat_ctr:openWindow()
    chat_ctr:friendChat(self.data.role_id)
    require("src.layer.friend.FriendCtr"):instance():closeWindow()
end

function FriendCell:onGift(tag,pSender)
    if self.data.is_gived == 1 then return end

    local give_max = cfg.system.friend_reward_send_limit
    if ex.Player.friend_data.give_count >= give_max then 
        local str_tip = string.format(ex.Tools:getLang(41143))
        ex.MessageView:add(str_tip, 0)
        return 
    end
    ex.Player.friend_data:friendGift(self.data.role_id)

    -- ex.MessageView:add(ex.Tools:getLang(47256))
    -- self.btn_gift:setEnabled(false)

    local normal = self.btn_gift:getNormalImage()
    local select = self.btn_gift:getSelectedImage()

    ex.Tools:setGrayAuto(normal, true)
    ex.Tools:setGrayAuto(select, true)

end

function FriendCell:reset(data)
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

    -- self.btn_gift:setEnabled(not self.data.is_reward)
    local normal = self.btn_gift:getNormalImage()
    local select = self.btn_gift:getSelectedImage()

    -- local is_gray = self.data.is_reward == 1
    -- local is_gray = self.data.has_gift == 2
    local is_gray = self.data.is_gived == 1 or ex.Player.friend_data.give_count >= cfg.system.friend_reward_send_limit

    ex.Tools:setGrayAuto(normal, is_gray)
    ex.Tools:setGrayAuto(select, is_gray)
    -- self.btn_to:setEnabled(not is_gray)

    -- local normal_1 = self.btn_to:getNormalImage()
    -- local select_1 = self.btn_to:getSelectedImage()

    -- -- is_gray = self.data.has_gift == 1

    -- ex.Tools:setGrayAuto(normal_1, is_gray)
    -- ex.Tools:setGrayAuto(select_1, is_gray)

    -- is_gray = self.data.has_gift == 2
    -- local normal_2 = self.btn_get:getNormalImage()
    -- local select_2 = self.btn_get:getSelectedImage()

    -- ex.Tools:setGrayAuto(normal_2, is_gray)
    -- ex.Tools:setGrayAuto(select_2, is_gray)
    
    -- self.spr_reddot:setVisible(friend_data.is_read == 0)
    print(self.__cname,require("src.layer.friend.FriendCtr"):instance().delete_status)
end

function FriendCell:getData()
    return self.data
end

return FriendCell