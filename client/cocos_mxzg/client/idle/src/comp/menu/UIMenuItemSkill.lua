local UIMenuItemSkill = class("UIMenuItemSkill", function (params1, params2, params3)
	return cpp.UIMenuItemImage:createWithSpriteFrameName(params1, params2, params3)
end)

function UIMenuItemSkill:ctor()

end

function UIMenuItemSkill:createWithIcon(skill_type, skill_level, is_evolve, callback)
	local pRet = UIMenuItemSkill:create("skill-icon/spr-skill-bg-1.png", nil, nil)
	-- local pRet = UIMenuItemSkill:create(str_icon, nil, nil)
	if pRet then
		pRet:initDone(skill_type, skill_level, is_evolve, callback)
		return pRet
	end
	pRet = nil
	return nil
end

function UIMenuItemSkill:initDone(skill_type, skill_level, is_evolve, callback)
	if  callback then
		self:registerScriptTapHandler(callback)
	end
	self.skill_type = skill_type
	self.skill_level = skill_level

	self:setIcon(self.skill_type)
	self:setEvolve(is_evolve)
	self:setLevel(self.skill_level)
	self:setSkillName()
end

function UIMenuItemSkill:setIcon(skill_type)
	self.skill_type = skill_type
	local sfc = cc.SpriteFrameCache:getInstance()
	local frame = sfc:getSpriteFrame(string.format("skill-icon/%d.png", skill_type))

	if not frame then
		frame = sfc:getSpriteFrame(string.format("skill-icon/%d.png", skill_type))
	end

	if frame then
		self:setNormalSpriteFrame(frame)
	end
end

function UIMenuItemSkill:setSelected(b)
	if self.spr_selected then
		self.spr_selected:removeFromParent()
		self.spr_selected = nil
	end

	if b then
		self.spr_selected = cc.Sprite:createWithSpriteFrameName("other/spr-btn-select.png")
		self.spr_selected:setPosition(cc.p(self:getContentSize().width * 0.5, self:getContentSize().height * 0.5))
		self:addChild(self.spr_selected, 10)
	end
end


function UIMenuItemSkill:setSkillName()
	if self.lbl_name then
		self.lbl_name:removeFromParent()
		self.lbl_name = nil
	end

	local str_skill_name =  ex.Player.hero_data:getSkillName(self.skill_type, math.max(1, self.skill_level)) --ex.Tools:getLang(10000000 + skill_type + skill_level - 1)
	if str_skill_name == "" then
		str_skill_name = "--"
	end
	
	local icon_size = self:getContentSize()
	self.lbl_name = cc.Label:createWithTTF(str_skill_name, FONT_DEFAULT_NAME_BOLD, 32)
	:setColor(FONT_BROWN)
	:setScale(0.5)
	:setPosition(icon_size.width - 10, 13)

	self.lbl_name:setPosition(icon_size.width * 0.5, 5);
    self:addChild(self.lbl_name)
end

function UIMenuItemSkill:setEvolve(is_evolve)
	if not is_evolve then
		return
	end
	
	self.spr_skill_icon_frame = cc.Sprite:createWithSpriteFrameName("skill-icon/spr-skill-evolve-frame.png")
    self.spr_skill_icon_frame:setPosition(cc.p(self:getContentSize().width / 2, self:getContentSize().height / 2 + 4))
	self:addChild(self.spr_skill_icon_frame)
end

function UIMenuItemSkill:resetLblName()
	self.lbl_name:setString("")
end

function UIMenuItemSkill:setNameY(y)
	if self.lbl_name then
		self.lbl_name:setPositionY(y)
	end
end



function UIMenuItemSkill:createRich(stage)
	local str = string.format(ex.Tools:getLang(47494),stage)
	local icon_size = self:getContentSize()
	self.rich_text = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(18)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#17FE17")
	:setScale(1)
	-- :setAnchorTextShadow(true)
	:ignoreContentAdaptWithSize(true)
	:setWrapMode(1)
	:setAnchorPoint(ex.a.center)
	:setAnchorTextOutline(true,cc.c3b(0,0,0))
	:setXmlTextLua(str)
	:setPosition(icon_size.width * 0.5, 55)
    self:addChild(self.rich_text)
	self.lbl_level:setVisible(self.skill_level > 0)
	self.spr_level_bg:setVisible(self.skill_level > 0)
	self.rich_text:setVisible(self.skill_level <= 0)
end

function UIMenuItemSkill:setLevel(level)
	self.skill_level = level

	self:removeLevel()

	if self.spr_level_bg == nil then
		self.spr_level_bg = cc.Sprite:createWithSpriteFrameName("hero-info/spr-skill-level-bg.png")
		self.spr_level_bg:setPosition(cc.p(10, 50))
		self:addChild(self.spr_level_bg)
	end

	local icon_size = self:getContentSize()
	self.lbl_level = cc.Label:createWithTTF(string.format("%d", level), FONT_DEFAULT_NAME_BOLD, 32)
	:setColor(FONT_BROWN)
	:setScale(0.5)
	-- :enableOutline(ex.c3b.BLACK, 1)
	:setPosition(10, 50)
	self:addChild(self.lbl_level)
	
    self.lbl_level:setVisible(level > 0)
    self.spr_level_bg:setVisible(level > 0)

	-- 变灰
	self:setGray(level <= 0)
end

function UIMenuItemSkill:removeLevel()
	if self.lbl_level then
		self.lbl_level:removeFromParent()
		self.lbl_level = nil
	end

	if self.spr_level_bg then
		self.spr_level_bg:removeFromParent()
		self.spr_level_bg = nil
	end
end

function UIMenuItemSkill:setLevelColor(color)
	-- body
	if self.lbl_level then 
		self.lbl_level:setColor(color)
	end
end

function UIMenuItemSkill:setGray(enabled)

	if enabled then 
		local spr = self:getNormalImage()
		if spr ~= nil then 
			ex.Tools:setGray(spr)
		end
	else
		local spr = self:getNormalImage()
		if spr ~= nil then 
			ex.Tools:delGray(spr)
		end
	end
	
	-- if self.spr_icon then
	-- 	self.spr_icon:setGLProgram(glp)
	-- end
end

function UIMenuItemSkill:setRecommend()
	if self.spr_recommend then
		self.spr_recommend:removeFromParent()
		self.spr_recommend = nil
	end

	self.spr_recommend = cc.Sprite:createWithSpriteFrameName("backpack/spr-ribbon-3.png")
	self.spr_recommend:setPosition(self:getContentSize().width * 0.9, self:getContentSize().height * 0.5)
	self:addChild(self.spr_recommend, 20)
end

function UIMenuItemSkill:setStudy()
	if self.spr_study then
		self.spr_study:removeFromParent()
		self.spr_study = nil
	end

	self.spr_study = cc.Sprite:createWithSpriteFrameName("backpack/spr-ribbon-4.png")
	self.spr_study:setPosition(self:getContentSize().width * 1.1 , self:getContentSize().height * 0.5)
	self:addChild(self.spr_study, 20)
end

return UIMenuItemSkill
