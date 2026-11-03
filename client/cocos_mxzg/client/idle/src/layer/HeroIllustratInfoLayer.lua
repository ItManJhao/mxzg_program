local HeroIllustratInfoLayer = class("HeroIllustratInfoLayer", require("src.comp.EventLayer"))

-----------------------------------------------------------

function HeroIllustratInfoLayer:onCreate()
    self:setAutoClose(false)
	self:setSwallowTouches(false)
	
	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/skill-icon.plist")

    self.spr_bg:setScale(ex.p.width / self.spr_bg:getContentSize().width, ex.p.height / self.spr_bg:getContentSize().height)
	self.spr_bg:setPosition(ex.p.center().x - self:getPositionX(), ex.p.center().y - self:getPositionY())
	
	self.spr_pannel_bg:setContentSize(cc.size(ex.p.width, self.spr_pannel_bg:getContentSize().height))

	local notch_height = require("src.model.Game"):instance():getNotchHeight()
    self.btn_back:setPosition(self:getContentSize().width / 2 + ex.p.width / 2 / self:getScaleX() - 20 / self:getScaleX() - 60,
							  self:getContentSize().height / 2 + ex.p.height / 2 / self:getScaleY() - 100 / self:getScaleY() - 42 - notch_height)
							  
	self:setExitCallback(handler(self,self.exitCallback))

	self.cfg = ex.Player.hero_data:getCurIllustraCfg()
	self.cur_idx = ex.Player.hero_data:getIllustratIdx()

	if self.cfg == nil then return end

	if table.nums(self.cfg) <= 0 or not self.cur_idx then return end

	local hero_type = self.cfg[self.cur_idx].type
	self.max_star = self.cfg[self.cur_idx].star

	self.hero_data = cfg.herotype.star[hero_type]
	-- self.max_star = self:getMaxStar()

	self.btn_left:setPositionX(-ex.p.width * 0.5 + 50)
	self.btn_right:setPositionX(ex.p.width * 0.5 - 50)
	
	self.btn_left:setVisible(self.cfg[self.cur_idx -1] ~= nil)
	self.btn_right:setVisible(self.cfg[self.cur_idx +1] ~= nil)

	self.btn_back:registerScriptTapHandler(handler(self, self.onBack))
	self.btn_left:registerScriptTapHandler(handler(self, self.onLift))
	self.btn_right:registerScriptTapHandler(handler(self, self.onRight))

	-- self.spr_name_bg:setLocalZOrder(2)
	-- self.lbl_hero_name:setLocalZOrder(2)
	-- self.lbl_hero_name:setString(ex.Tools:getLang(hero_type))
	
    -- self:createStar()

    self:updateLevelView()
end

function HeroIllustratInfoLayer:showData(type,star,callback)

	print("HeroIllustratInfoLayer:showData", type, star, callback)

	if not type or not star or not callback then 
		return 
	end

	self.btn_left:setVisible(false)
	self.btn_right:setVisible(false)

	self.hero_data =  cfg.herotype.star[type]
	self.max_star = star 

	self.btn_back:registerScriptTapHandler(callback)
	self:updateLevelView()
end

-- function HeroIllustratInfoLayer:getMaxStar()
-- 	local star = self.max_star
-- 	-- for k,v in pairs(self.hero_data) do
--  --        star = v.star

--         while self.hero_data["to_" .. star + 1 ..  "_star"] ~= nil and self.hero_data["to_" .. star + 1 ..  "_star"] ~= "" do 
--             star = star + 1
--         end
-- 	-- end
-- 	return star
-- end

function HeroIllustratInfoLayer:onRight(tag,pSender)
	self.cur_idx = self.cur_idx + 1

	self.btn_left:setVisible(self.cfg[self.cur_idx -1] ~= nil)
	self.btn_right:setVisible(self.cfg[self.cur_idx +1] ~= nil)

	local hero_type = self.cfg[self.cur_idx].type
	self.max_star = self.cfg[self.cur_idx].star

	self.hero_data = cfg.herotype.star[hero_type]
	-- self.max_star = self:getMaxStar()
	self:updateLevelView()
end

function HeroIllustratInfoLayer:onLift(tag,pSender)
	self.cur_idx = self.cur_idx - 1

	self.btn_left:setVisible(self.cfg[self.cur_idx -1] ~= nil)
	self.btn_right:setVisible(self.cfg[self.cur_idx +1] ~= nil)

	local hero_type = self.cfg[self.cur_idx].type
	self.max_star = self.cfg[self.cur_idx].star

	self.hero_data = cfg.herotype.star[hero_type]
	-- self.max_star = self:getMaxStar()
	self:updateLevelView()
end

function HeroIllustratInfoLayer:onBack(tag,pSender)
	local layer = ex.MainSceneCtr:changeLayer(MainSceneType.HERO_LAYER)
	layer:changeLayer(2)
end

function HeroIllustratInfoLayer:onExit()

end

function HeroIllustratInfoLayer:createSkill()
	self.menu_skill:removeAllChildren()
	self.node_nil_skill:removeAllChildren()
	local stage = math.min(self.max_star , self:getMaxStage())

	local icon_width = 100
	local vec_skill = ex.Player.hero_data:getHeroSkillList(self.hero_data.type)
	local skill_num = table.nums(vec_skill)
	local UIMenuItemSkill = require("src.comp.menu.UIMenuItemSkill")
	local max_skill_num = 4
	local begin_x = - (max_skill_num) * icon_width * 0.5
	
	for i=1,max_skill_num do
			if i <= skill_num then  
			local skill_level, is_evolve_skill, skill_id = ex.Player.hero_data:getHeroSkillLevel(stage, self.max_star, i, self.hero_data.type)
			local btn_skill = UIMenuItemSkill:createWithIcon(skill_id, skill_level, is_evolve_skill, handler(self, self.onSkillInfo))
			btn_skill:setPosition(begin_x + icon_width * (i - 0.5), 0)
			btn_skill.lbl_name:setColor(cc.c3b(122,71,45))
			-- btn_skill.lbl_name:enableOutline(ex.c3b.BLACK, -1)
			btn_skill.lbl_name:setPositionY(-22)
			self.menu_skill:addChild(btn_skill)
			self["btn_skill"..i] = btn_skill
		else
			local btn_skill = cpp.UIMenuItemImage:createWithSpriteFrameName("hero-info/spr-new-9.png", nil, nil)
			btn_skill:setPosition(begin_x + icon_width * (i - 0.5), 0)
			btn_skill:setEnabled(false)
			self.node_nil_skill:addChild(btn_skill)
		end 
	end
end

function HeroIllustratInfoLayer:onSkillInfo(tag, pSender)
	require("src.layer.HeroSkillInfoCtr"):instance():openWindow(pSender.skill_type, pSender.skill_level)
end


function HeroIllustratInfoLayer:createStar()

	local curStar = self.max_star
	self.node_star:removeAllChildren()

	if self.max_star < 10 then
		local star_type = math.floor(self.max_star / 5)
		local star_count

		if self.max_star % 5 == 0 then 
			if self.max_star > 5 then
				star_count = 1
			else 
				star_count = 5
				star_type = 0
			end
		else
			star_count = self.max_star % 5
		end

		local path = string.format("other/star-%d.png",star_type)
		if self.max_star > 10 then star_count = star_count + 1 end
		for i=1,star_count do
			local sp = cc.Sprite:createWithSpriteFrameName(path)
			self.node_star:addChild(sp, 10)
			local margin = 12
			local width = sp:getContentSize().width + margin
			local posX = -(width / 2 * star_count) / 2 + width / 2 * (i - 0.5) 
			sp:setPosition(posX,0)
		end
	else
		local spr_star_bg = cc.Sprite:createWithSpriteFrameName("backpack/spr-star-bg-2.png")
		:setPosition(cc.p(0, 0))
		self.node_star:addChild(spr_star_bg, 5)
	
		-- 英雄觉醒 add 熊梦 图标修改 如果加到15星需要再次修改
		if curStar == ex.Player.awaken_star then
			spr_star_bg:setSpriteFrame("backpack/spr-star-bg-4.png")
		elseif curStar > 10 then
			local spr_star = cc.Sprite:createWithSpriteFrameName("backpack/lbl-star-"..(curStar - 10)..".png")
			:setPosition(spr_star_bg:getPosition())
			self.node_star:addChild(spr_star, 10)
		end
	end
end

function HeroIllustratInfoLayer:updateLevelView()
	self:updateLevelInfo()
	self:updateLevelAttrInfo()
	self:updateLevelSkillInfo()
	self:updateGradeInfo()

	if self.hero ~= nil then 
		self.hero:removeFromParent()
		self.hero = nil
	end

    -- 创建一个骨骼动画
	local skin = ex.Tools:getIllustratHeroSkinByStar(self.hero_data.type,self.max_star)
	print("image_id = ", skin)
    -- self.hero = require("src.person.Hero"):create("12323", "123213", skin, 1, self.max_star,skin)
	self.hero = require("src.person.Hero"):create("12323", "123213", self.hero_data.type, 1, self.max_star,skin)
	self.hero:setShadowVisible(false)
    self.hero:setScale(1.5 * 1.42)
    self.hero:setPosition(0, -10)
	self.hero:registerScriptTapHandler(handler(self, self.onTouchHero))
    self.menu_hero:addChild(self.hero, 10)

	self.lbl_hero_name:setString(ex.Tools:getLang(self.hero_data.type))
	self.icon_elem:setPositionX(self.lbl_hero_name:getPositionX() - self.lbl_hero_name:getContentSize().width / 2 - 20)
	self:createStar()

	self.icon_elem:setSpriteFrame("hero-icon/elem-" .. self.hero_data.elem .. ".png")

	self.icon_occupat:setSpriteFrame("hero-info/icon-occup-" .. self.hero_data.occupation .. ".png")
end

function HeroIllustratInfoLayer:updateGradeInfo()
	if not self.gradeArr then 
		self.gradeArr = {}
		for i=1,6 do
			self.gradeArr[i] = self["sp_grade" .. i]
		end
	end
	local stage = math.min(self.max_star , self:getMaxStage())
	local maxStar = self.max_star
	for k,v in pairs(self.gradeArr) do
		v:setVisible(k<=maxStar)
		local path = stage >= k and "hero-info/spr-quality-2.png" or "hero-info/spr-quality-1.png"
		v:initWithSpriteFrameName(path)
	end
end

function HeroIllustratInfoLayer:updateLevelSkillInfo()
	self:createSkill()
end

function HeroIllustratInfoLayer:getMaxStage()
	local max = 0
	for i,v in ipairs(cfg.heroupgrade.grade) do
		if i > max then max = i end
	end
	return max
end

function HeroIllustratInfoLayer:updateLevelAttrInfo()
	local stage = math.min(self.max_star , self:getMaxStage())
	local gradeData = cfg.heroupgrade.grade[stage]
	local maxLevel = cfg.herostar.star[self.max_star].level_limit
	local str = string.format(ex.Tools:getLang(47671).."%s/%s",maxLevel,maxLevel)
	self.lbl_level:setString(str)
	self.lbl_max_tips:setVisible(true)
end

function HeroIllustratInfoLayer:updateLevelInfo()
	local stage = math.min(self.max_star , self:getMaxStage())
	local maxLevel = cfg.herostar.star[self.max_star].level_limit

	-- print("HeroIllustratInfoLayer:updateLevelInfo")
	local hero_ability = require("src.data.HeroAbilityData"):getAbilityData(self.hero_data.type, stage, self.max_star, maxLevel)
	-- local hero_attr = ex.Player.hero_data:getHeroAttribute(self.hero_data.type, stage, self.max_star, maxLevel)
	
	-- dump(self.hero_data, "hero_attr")
	self.lbl_profession:setString(ex.Tools:getLang(47304)..ex.Tools:getLang(111000 + self.hero_data.occupation))
	self.lbl_attack:setString(ex.Tools:getAttrText(220, hero_ability:getAtk()))
	self.lbl_hp:setString(ex.Tools:getAttrText(223, hero_ability:getHp()))
	self.lbl_defense:setString(ex.Tools:getAttrText(224, hero_ability:getDef()))
	self.lbl_speed:setString(ex.Tools:getAttrText(101, hero_ability:getSpd()))
end

function HeroIllustratInfoLayer:registerEvent()

end

function HeroIllustratInfoLayer:exitCallback()
	-- ex.Player.hero_data:setCurIllustratCfg(nil)
	-- ex.Player.hero_data:setIllustratIdx(nil)
	ex.Player.hero_data:setOpenTab(1)
end

function HeroIllustratInfoLayer:onTouchHero()
	self.hero:attack()
end

return HeroIllustratInfoLayer
