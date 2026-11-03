--[[
* @Description: 装备附魂-附魂成功界面
* @Author: 熊梦
* @Date: 2020-03-16 15:42:00
* ]]
local HeroSoulResultCtr = class("HeroSoulResultCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local HeroSoulResultLayer = class("HeroSoulResultLayer", require("src.comp.EventLayer"))

function HeroSoulResultLayer:onCreate()
	self:addBlackBackground()
end

function HeroSoulResultLayer:updateReward(equip)
	self.btn_equip:setEnabled(false)
	self.skill_icon:setEnabled(false)

	local size = self.btn_equip:getContentSize()
	local icon = ex.Tools:createBackpackItem(equip.item_type, 0)
	icon:setPosition(size.width * 0.5, size.height * 0.5)
	self.btn_equip:addChild(icon)

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/hero-soul.plist")
	
	local soul_level_bg = cc.Sprite:createWithSpriteFrameName("hero-soul/spr-soul-level-bg.png")
	soul_level_bg:setName("soul_level_bg")
	self.btn_equip.soul_level_bg = soul_level_bg
	self.btn_equip:addChild(soul_level_bg,50)
	soul_level_bg:setPosition(45 ,size.height - 15)

	local lbl_grade_text = cc.Label:createWithTTF(ex.Tools:getLang(47301), FONT_DEFAULT_NAME_BOLD, 16)
	lbl_grade_text:setName("lbl_grade_text")
	lbl_grade_text:setPosition(soul_level_bg:getContentSize().width /2, soul_level_bg:getContentSize().height /2)
	lbl_grade_text:enableOutline(cc.c4b(114, 111, 72, 255), 2)
	lbl_grade_text:setString(string.format(ex.Tools:getLang(6402),equip.soul_lv))
	soul_level_bg:addChild(lbl_grade_text)

	local spr_border = cc.Sprite:createWithSpriteFrameName("backpack/spr-select.png")
	spr_border:setPosition(size.width /2 ,size.height / 2)
	spr_border:setName("spr_border")
	spr_border:setVisible(true)
	self.btn_equip:addChild(spr_border, 90)


	local soul_skill_table = nil
	for j,k in ipairs(cfg.heroequipsoul.heroequipsoul) do
		if k.place == equip.place then
			if k.level == equip.soul_lv then
				soul_skill_table = k
				break
			end
		end
	end
			
	if soul_skill_table ~= nil then
		self.lbl_level:setString(equip.soul_lv)

		local sfc = cc.SpriteFrameCache:getInstance()
		local frame = sfc:getSpriteFrame(string.format("skill-icon/%d.png", soul_skill_table.skill))
		if not frame then
			frame = sfc:getSpriteFrame(string.format("skill-icon/%d.png", soul_skill_table.skill))
		end
		if frame then
			self.skill_icon:setNormalSpriteFrame(frame)
		end

		local str_skill_name =  ex.Player.hero_data:getSkillName(soul_skill_table.skill, math.max(1, soul_skill_table.skill_level))
		if str_skill_name == "" then
			str_skill_name = "--"
		end
		self.lbl_skill_name:setString(str_skill_name)

		self.lbl_skill_level:setPositionX(self.lbl_skill_name:getPositionX() + self.lbl_skill_name:getContentSize().width / 2 + 10)


		-- 创建一个容纳文本的可滑动节点
		local str_skill_info = ex.Player.hero_data:getSkillDescription(soul_skill_table.skill, math.max(1, soul_skill_table.level))
		local lbl_info_scroll = ex.Tools:getNodeWithScrollLabel(cc.size(300,80),16, cc.c3b(144,111,72),str_skill_info)
		lbl_info_scroll:setAnchorPoint(ex.a.left_top)
		self.node_skill_info:addChild(lbl_info_scroll)
	
	end

	ex.Tools:layerEnterAction(self)

end

-----------------------------------------------------------------------------
function HeroSoulResultCtr:onCreate()
	self:setCCBIPath("ccbi/HeroSoulResultLayer.ccbi")
	self:setIsSingle(false)
end

function HeroSoulResultCtr:getLayerClass()
	return HeroSoulResultLayer
end

function HeroSoulResultCtr:getLayer()
	return self.layer
end

function HeroSoulResultCtr:openWindow(equip)
	if self:isOpened() then
		return
	end
	
	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/hero-info-lang.plist")

	self:loadLayer()
	self:open()

	self.layer:updateReward(equip)

end

return HeroSoulResultCtr
