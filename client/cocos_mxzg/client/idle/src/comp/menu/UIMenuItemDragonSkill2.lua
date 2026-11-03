local UIMenuItemDragonSkill = class("UIMenuItemDragonSkill", require("src.layer.ui.UI_MenuItemDragonSkill"))

function UIMenuItemDragonSkill:ctor()
	self.super.ctor(self)
	self:setName("UIMenuItemDragonSkill")
	
	self.spr_icon:setVisible(false)
	self.spr_frame:setVisible(false)
	self.spr_level_bg:setVisible(false)
	self.lbl_level:setVisible(false)
	self.spr_lock:setVisible(false)
end


function UIMenuItemDragonSkill:setIcon(skill_type)
    self.spr_icon:setVisible(false)
	self.skill_type = skill_type
	if skill_type <= 0 then
		return
    end
	self.spr_icon:setVisible(true)
    ex.Tools:setSpriteFrameAsyn(self.spr_icon, string.format("skill-icon/%d.png", skill_type), "skill-icon")
end

function UIMenuItemDragonSkill:setLevel(skill_level)
	self.skill_level = skill_level

	self.lbl_level:setString(tostring(skill_level))
	self.spr_level_bg:setVisible(self.skill_level > 0)
	self.lbl_level:setVisible(self.skill_level > 0)
end

function UIMenuItemDragonSkill:setLock(is_lock)
	self.spr_lock:setVisible(is_lock)
	if is_lock then
		self:setLabelText("")
	else
		self:setLabelText(ex.Tools:getLang(1240))
		self:setLabelColor(cc.c3b(255,225,178))
		self:setLabelSize(48)
	end
	self:setEnabled(not is_lock)
end

return UIMenuItemDragonSkill
