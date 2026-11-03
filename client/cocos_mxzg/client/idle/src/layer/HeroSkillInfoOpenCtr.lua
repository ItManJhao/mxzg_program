local HeroSkillInfoOpenCtr = class("HeroSkillInfoOpenCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroSkillOpenInfoLayer = class("HeroSkillOpenInfoLayer", require("src.comp.EventLayer"))

function HeroSkillOpenInfoLayer:onCreate()
	self:addBlackBackground()
end

function HeroSkillOpenInfoLayer:onExit()
	-- ex.EffectCtr:removeAllEffFromLayer(self)
	-- if self.eff ~= nil then 
	-- 	self.eff:remove()
	-- 	self.eff = nil 
	-- end
end


-----------------------------------------------------------------------------
function HeroSkillInfoOpenCtr:onCreate()
	self:setCCBIPath("ccbi/HeroSkillOpenInfoLayer.ccbi")
	self:setIsSingle(false)
end

function HeroSkillInfoOpenCtr:getLayerClass()
	return HeroSkillOpenInfoLayer
end

function HeroSkillInfoOpenCtr:getLayer()
	return self.layer
end

function HeroSkillInfoOpenCtr:openWindow(hero_data, idx)
	if self:isOpened() then
		-- self:addReward(hero_data)
		return
	end

	self.callback = callback
	
	local sfc = cc.SpriteFrameCache:getInstance()
	-- sfc:addSpriteFrames("ccbi-res/summon-effect.plist")
 --    sfc:addSpriteFrames("ccbi-res/reward-layer.plist")

	self:loadLayer()
	self:open()

	self:updateReward(hero_data,idx)


end

function HeroSkillInfoOpenCtr:updateReward(hero_data,idx)


	local layer = self.layer
	local UIMenuItemSkill = require("src.comp.menu.UIMenuItemSkill")
	local vec_skill = ex.Player.hero_data:getHeroSkillList(hero_data.hero_type)
	local skill_level, is_evolve_skill, skill_id = ex.Player.hero_data:getHeroSkillLevel(hero_data.stage, hero_data.star, idx, hero_data.hero_type, hero_data.evolve)

	local btn_skill = UIMenuItemSkill:createWithIcon(skill_id, skill_level, is_evolve_skill)--, handler(self, self.onSkillInfo))
	btn_skill:setScale(1.5)
	layer.menu:addChild(btn_skill)
	btn_skill:setPosition(0,0)
	btn_skill:setLevelColor(SKILL_YELLOW)
	btn_skill.lbl_name:setVisible(false)
	layer.lbl_name:setPosition(0,-(btn_skill:getContentSize().height * 1.5 / 2 + 20))

	local str_skill_name = ex.Player.hero_data:getSkillName(skill_id) -- ex.Tools:getLang(vec_skill[idx] + 10000000)

	layer.lbl_name:setString(str_skill_name)
	layer.lbl_name:enableOutline(FONT_BLACK_C4B, 1)
	layer.lbl_tips:enableOutline(FONT_BLACK_C4B, 1)

	

	local str_info = ex.Player.hero_data:getSkillDescription(skill_id, skill_level)
	if str_info == "" then
		str_info = ex.Tools:getLang(47710)
	end

	layer.lbl_tips:setString(str_info)
	layer.lbl_tips:setPositionY(layer.lbl_name:getPositionY() - layer.lbl_name:getContentSize().height / 2 )
	layer.lbl_tips:setDimensions(360, 0)
	layer.spr_result_bg:setContentSize(layer.spr_result_bg:getContentSize().width, layer.lbl_tips:getContentSize().height + layer.spr_eff:getContentSize().height)
	layer.node:setPositionY(layer.bg_node:getPositionY() - layer.spr_eff:getContentSize().height / 2)
	

	layer.node:setLocalZOrder(10)
	local pos = layer:convertToNodeSpace(layer.menu:getAnchorPointInPoints())

	layer.spr_eff:runAction(ex.EffectFactory:createEffectByName("eff_skill_unlock_1"))
end


return HeroSkillInfoOpenCtr
