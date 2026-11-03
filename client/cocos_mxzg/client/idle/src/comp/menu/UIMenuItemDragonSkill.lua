local UIMenuItemDragonSkill = class("UIMenuItemDragonSkill", function (params1, params2, params3)
	return cpp.UIMenuItemLabel:create(params1, params2, params3, nil)
end)

function UIMenuItemDragonSkill:ctor()

end

function UIMenuItemDragonSkill:createWithIcon(skill_type, skill_level)
	local pRet = UIMenuItemDragonSkill:create("skill-icon/spr-skill-bg-2.png", nil, nil)
	if pRet then
		pRet:initDone(skill_type, skill_level)
		return pRet
	end
	pRet = nil
	return nil
end

function UIMenuItemDragonSkill:initDone(skill_type, skill_level)
	self:setLabelText(ex.Tools:getLang(1240))
	self:setLabelColor(cc.c3b(255,225,178))
	self:setLabelSize(48)

	local spr_frame = cc.Sprite:createWithSpriteFrameName("skill-icon/spr-skill-frame-1.png")
	spr_frame:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
	self:addChild(spr_frame, 20)

	self:setIcon(skill_type)
	self:setLevel(skill_level)
end

function UIMenuItemDragonSkill:setIcon(skill_type)
	if self.spr_icon then
		self.spr_icon:removeFromParent()
		self.spr_icon = nil
	end

	self.skill_type = skill_type

	if skill_type <= 0 then
		return
	end

	local icon_size = self:getContentSize()
	self.spr_icon = cc.Sprite:createWithSpriteFrameName(string.format("skill-icon/%d.png", skill_type))
	if self.spr_icon == nil then
		print("skill-icon "..string.format("skill-icon/%d.png", skill_type).." not found")
		self.spr_icon = cc.Sprite:createWithSpriteFrameName(string.format("skill-icon/%d.png", 0))
	end
	self.spr_icon:setScale(1.3)
	self.spr_icon:setPosition(icon_size.width / 2, icon_size.height * 0.5)
	self:addChild(self.spr_icon, 10)

	local size_icon = cc.size(self.spr_icon:getContentSize().width * self.spr_icon:getScaleX(), self.spr_icon:getContentSize().height * self.spr_icon:getScaleY())

end

function UIMenuItemDragonSkill:setLevel(skill_level)
	self.skill_level = skill_level
	
	if self.spr_level_bg == nil then
		self.spr_level_bg = cc.Sprite:createWithSpriteFrameName("win-bg/block-bg-29.png")
		self.spr_level_bg:setPosition(20, self:getContentSize().height - 20)
		self:addChild(self.spr_level_bg, 30)
	end

	if self.lbl_level == nil then
		self.lbl_level = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 40)
		self.lbl_level:setScale(0.5)
		self.lbl_level:setColor(cc.c3b(122,71,45))
		self.lbl_level:setPosition(self.spr_level_bg:getPosition())
		self:addChild(self.lbl_level, 40)
	end
	self.lbl_level:setString(tostring(skill_level))

	self.spr_level_bg:setVisible(self.skill_level > 0)
	self.lbl_level:setVisible(self.skill_level > 0)
end

function UIMenuItemDragonSkill:setLock(is_lock)
	if self.spr_lock == nil then
		self.spr_lock = cc.Sprite:createWithSpriteFrameName("dragon/spr-lock.png")
		self.spr_lock:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
		self:addChild(self.spr_lock, 100)
	end

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
