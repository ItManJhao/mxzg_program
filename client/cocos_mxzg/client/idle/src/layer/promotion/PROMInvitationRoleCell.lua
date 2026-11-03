local PROMInvitationRoleCell = class("PROMInvitationRoleCell", require("src.comp.LuaLayerBase"))

local string_format = string.format
function PROMInvitationRoleCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end


function PROMInvitationRoleCell:reset(data)

    if not data then print("not data") return end

    self.name_text:setString(data.name)
    
    self.level_text:setString(string.format(ex.Tools:getLang(41013),data.level))
    
    self.power_text:setString(data.power)
    
    if data.onlime == 1 then 
        self.online_text:setString(ex.Tools:getLang(24))
    else 
        self.online_text:setString(ex.Tools:getLang(47237))
    end 

    self.head_iamge:setSpriteFrame(string.format("head-icon/%d.png", data.head_id))
    self.head_iamge:setScale(0.7)
    self.head_freme:setSpriteFrame(ex.Tools:getBorderIconByIdx(data.border_id))

end

return PROMInvitationRoleCell