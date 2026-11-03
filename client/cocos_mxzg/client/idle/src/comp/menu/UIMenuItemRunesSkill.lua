local UIMenuItemRunesSkill = class("UIMenuItemRunesSkill", function (params1, params2, params3)
	return cpp.UIMenuItemImage:createWithSpriteFrameName(params1, params2, params3)
end)

function UIMenuItemRunesSkill:ctor()

end

function UIMenuItemRunesSkill:createWithIcon(data)
	local pRet = UIMenuItemRunesSkill:create("skill-icon/spr-skill-runes-bg-1.png", nil, nil)
	if pRet then
		pRet:initDone(data)
		return pRet
	end
	pRet = nil
	return nil
end

function UIMenuItemRunesSkill:initDone(data)
	self.data = data
	local skill_name = data.skill_id > 0 and ex.Player.hero_data:getSkillName(data.skill_id, data.level) or ""
	self:setIcon(data.skill_id, data.level)
	self:setSkillName(skill_name)
end

function UIMenuItemRunesSkill:setIcon(skill_type, skill_level)
	if self.spr_icon then
		self.spr_icon:removeFromParent()
		self.spr_icon = nil
	end

	self.skill_type = skill_type

	local icon_size = self:getContentSize()
	self.spr_icon = cc.Sprite:createWithSpriteFrameName(string.format("skill-icon/%d.png", skill_type + math.max(0, skill_level - 1)))
	if self.spr_icon == nil then
		print("skill-icon "..string.format("skill-icon/%d.png", skill_type + math.max(0, skill_level - 1)).." not found")
		self.spr_icon = cc.Sprite:createWithSpriteFrameName(string.format("skill-icon/%d.png", 0))
	end

	self.spr_icon:setPosition(icon_size.width / 2, icon_size.height * 0.5)
	self:addChild(self.spr_icon)
end

function UIMenuItemRunesSkill:setSkillName(skill_name)
	self.skill_name = skill_name

	if self.lbl_skill_name then
		self.lbl_skill_name:removeFromParent()
		self.lbl_skill_name = nil
	end
	
	local icon_size = self:getContentSize()
	self.lbl_skill_name = cc.Label:createWithTTF(string.format("%s", skill_name), FONT_DEFAULT_NAME_BOLD, 20)
	-- :setColor(cc.c4b(251,243,221,255))
	:setColor(cc.c4b(255,255,255,255))
	:setAnchorPoint(cc.p(0.5,0))
	:enableOutline(cc.c4b(68,30,3,255), 1)
	:setPosition(icon_size.width / 2, -20)
    self:addChild(self.lbl_skill_name)
end

function UIMenuItemRunesSkill:setSkillRare(rare)
	if self.spr_rare ~= nil then
		self.spr_rare:removeFromParent()
		self.spr_rare = nil
	end

	self.spr_rare = cc.Sprite:createWithSpriteFrameName("backpack/spr-ribbon-1-"..rare..".png")
	if self.spr_rare == nil then
		return
	end

	self.spr_rare:setAnchorPoint(cc.p(0.5, 1))
	self.spr_rare:setPosition(self:getContentSize().width - 12, self:getContentSize().height - 10)
	self:addChild(self.spr_rare, 10)
end

return UIMenuItemRunesSkill
