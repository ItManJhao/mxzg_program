local FriendBlackListCell = class("FriendBlackListCell", require("src.comp.LuaLayerBase"))

function FriendBlackListCell:onCreate()
	self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.btn_remove:registerScriptTapHandler(handler(self, self.onRemove))
end

function FriendBlackListCell:reset(data)
    self.data = data
    self.lbl_name:setString(data.player_name)
    self.lbl_server_name:setString(ex.StringUtil.getServerName(data.server_id))
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
end

function FriendBlackListCell:getData()
    return self.data
end

function FriendBlackListCell:onRemove(tag,pSender)
    ex.Player.friend_data:blackListRemove(self.data.role_id)
end

return FriendBlackListCell