local HeroInfoUpLevelLayer = class("HeroInfoUpLevelLayer", require("src.comp.EventLayer"))

function HeroInfoUpLevelLayer:onCreate()
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/skill-icon.plist")
    sfc:addSpriteFrames("ccbi-res/hero-info-effect.plist")

	self.hero_data = ex.Player.hero_data.promote:getSelectHero()
    local is_cube_hero = ex.Player.hero_data.magicCube:isCubeHero(self.hero_data.hero_id) == true
	self.UpgradeCtr = require("src.layer.HeroUpgradeCtr"):instance()

	self.btn_up_grade:setName("btn_up_grade")
	self.btn_up_level:registerScriptTapHandler(handler(self, self.onClickUpLevel))
	self.btn_up_grade:registerScriptTapHandler(handler(self, self.onClickUpgrade))
	
	self.btn_up_level.spr = cc.Sprite:createWithSpriteFrameName("other/spr-up.png")
	self.btn_up_level:addChild(self.btn_up_level.spr)
	self.btn_up_level.spr:setPosition(50,30)

	self.btn_up_grade.spr = cc.Sprite:createWithSpriteFrameName("other/spr-up.png")
	self.btn_up_grade:addChild(self.btn_up_grade.spr)
	self.btn_up_grade.spr:setPosition(50,30)

	self.lbl_max_tips:setString(ex.Tools:getLang(5712))

	self:updateLevelView()
	self:addEvent(EVENT.BACKPACK_RES_CHANGE.CHANGE_ITEM,handler(self,self.onItemChange))
end

function HeroInfoUpLevelLayer:updateCubeHeroStatus()
    local is_cube_hero = ex.Player.hero_data.magicCube:isCubeHero(self.hero_data.hero_id)
    local grade_spr = self.btn_up_grade:getNormalImage()
    self.btn_up_grade:setEnabled(not is_cube_hero)
    ex.Tools:setGrayAuto(grade_spr,is_cube_hero)
    ex.Tools:setGrayAuto(self.btn_up_grade.spr,is_cube_hero)
    self.lbl_cube_tips:setVisible(is_cube_hero)


    self.btn_up_level:setEnabled(not is_cube_hero)
    local level_spr = self.btn_up_level:getNormalImage()
    ex.Tools:setGrayAuto(level_spr,is_cube_hero)
    ex.Tools:setGrayAuto(self.btn_up_level.spr,is_cube_hero)
end

function HeroInfoUpLevelLayer:onItemChange(event,data)
	if data == nil then
		return
	end
	
	for i,v in ipairs(data) do
		if v.type == 900001 or v.type == 900101 then 
			self:checkCanUpLevel()
			break
		end
	end
end

-- 根据参数刷新那部分的数据。参数缺省则刷新

function HeroInfoUpLevelLayer:updateLevelView(info, attr, skill, grade)
	self.hero_data = ex.Player.hero_data:getHeroDataById(self.hero_data.hero_id)
	if not self.hero_data then
		return
	end
	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/hero-info.plist")
    sfc:addSpriteFrames("ccbi-res/hero-info-lang.plist")
	sfc:addSpriteFrames("ccbi-res/skill-icon.plist")

	info = info or true
	attr = attr or true
	skill = skill or true
	grade = grade or true

	if info then
		self:updateLevelInfo()
	end

	if attr then
		self:updateLevelAttrInfo()
	end

	if skill then
		self:updateLevelSkillInfo()
	end

	if grade then
		self:updateGradeInfo()
	end
	
	local maxLevel = cfg.herostar.star[self.hero_data.star].level_limit
    local is_cube_hero = ex.Player.hero_data.magicCube:isCubeHero(self.hero_data.hero_id)
    local level_bool 
    if is_cube_hero then 
        level_bool = false 
    else 
        level_bool = self.hero_data.level < maxLevel and self.canUp and not self.btn_up_grade:isVisible()
    end 
	ex.Tools:addRedPoint(self.btn_up_level,level_bool, ex.r.p9)

	local conf = cfg.herotype.star[self.hero_data.hero_type]
	-- self.icon_occupat:setSpriteFrame("hero-info/icon-occup-" .. conf.occupation .. ".png")
	ex.Tools:setSpriteFrame(self.icon_occupat, "hero-info/icon-occup-" .. conf.occupation .. ".png")
    self:updateCubeHeroStatus()

	self:checkCanUpLevel()
end

function HeroInfoUpLevelLayer:getSkillBystage()
	local t = {}
	t[1] = 0
	for i,v in ipairs(cfg.heroupgrade.grade) do
		print(self.__cname,i)
		local pre = cfg.heroupgrade.grade[i-1]
		for j=1,4 do
			if v["skill"..j] ~= pre["skill"..j] then 
				table.insert(t,i)
			end
		end
	end
	return t
end

function HeroInfoUpLevelLayer:checkCanUpLevel( )
	self.can_up_level = 0
	local level_limit = cfg.system.hero_level_jump_limit
	local total_gold = 0
	local total_exp = 0
	local hasGold = ex.Player:getItemNum(ItemType.IT_GOLD)
	local hasExp = ex.Player:getItemNum(ItemType.IT_HERO_EXP)
	local can = false 
	if self.hero_data.level < level_limit then 

		local can_max = cfg.system.hero_level_jump_max
		for i=1,can_max do
			local up_level = self.hero_data.level + (i - 1)
			local limit = cfg.heroupgrade.grade[self.hero_data.stage] ~= nil and (cfg.heroupgrade.grade[self.hero_data.stage].level - 1) == up_level

			local condictionData = cfg.herolevel.level[up_level]
			if not condictionData then break end

			if condictionData ~= nil and (hasGold >= (total_gold + condictionData.gold_need) and hasExp >= (total_exp + condictionData.exp_need)) then 
				self.can_up_level = i 
				total_gold = total_gold + condictionData.gold_need
				total_exp = total_exp + condictionData.exp_need
				if can == false then can = true end 
			end
			if limit then break end 
		end
	else
		local condictionData = cfg.herolevel.level[self.hero_data.level]
		total_gold = total_gold + condictionData.gold_need
		total_exp = total_exp + condictionData.exp_need
		if hasGold >= condictionData.gold_need and hasExp >= condictionData.exp_need then 
			self.can_up_level = 1
			if can == false then can = true end 
		end
	end
	print(self.__cname,self.can_up_level,total_gold,total_exp)



	local btn_up_level_str = (self.can_up_level > 0 and self.hero_data.level < cfg.system.hero_level_jump_limit ) and string.format( ex.Tools:getLang(47402),self.can_up_level) or ex.Tools:getLang(47184)
	self.btn_up_level:setLabelText(btn_up_level_str)

	if can == false then 
		local condictionData = cfg.herolevel.level[self.hero_data.level]
		total_gold = condictionData.gold_need
		total_exp = condictionData.exp_need
	end

	self.lbl_gold_need:setString(ex.StringUtil.getScientificNumber(total_gold))
	self.lbl_exp_need:setString(ex.StringUtil.getScientificNumber(total_exp))

	local color = hasGold >= total_gold and cc.WHITE or cc.RED
	self.lbl_gold_need:setColor(color)
	color = hasExp >= total_exp and cc.WHITE or cc.RED
	self.lbl_exp_need:setColor(color)
end

function HeroInfoUpLevelLayer:updateLevelInfo()

    
    local level = self.hero_data.level 
    local stage = self.hero_data.stage
    local is_cube_hero = ex.Player.hero_data.magicCube:isCubeHero(self.hero_data.hero_id)
    if is_cube_hero then 
        level = self.hero_data.tweak_cube_lv 
        stage = self.hero_data.tweak_cube_stage
    end 

	local condictionData = cfg.herolevel.level[level]
	if not condictionData then 
		self.node_need:setVisible(false)
		self.btn_up_grade:setVisible(false)
		self.btn_up_level:setVisible(false)
		return 
	end

	self.gold_need = condictionData.gold_need
	self.exp_need = condictionData.exp_need


	local gradeData = cfg.heroupgrade.grade[stage]
	if not gradeData then 
		self.btn_up_grade:setVisible(false)
		return 
	end
	local maxLevel = cfg.herostar.star[self.hero_data.star].level_limit
	self.btn_up_grade:setVisible(level < maxLevel and level == gradeData.level)
	
	if level == gradeData.level and self:getMaxStage() ~= stage then return end
	-- self.lbl_gold_need:setString(ex.StringUtil.getScientificNumber(condictionData.gold_need))
	-- self.lbl_exp_need:setString(ex.StringUtil.getScientificNumber(condictionData.exp_need))
	self.spr_gold_need:setSpriteFrame(string.format("backpack/%s.png",ItemType.IT_GOLD))
	self.spr_exp_need:setSpriteFrame(string.format("backpack/%s.png",ItemType.IT_HERO_EXP))
	self.spr_gold_need:setScale(0.5)
	self.spr_exp_need:setScale(0.5)
	local hasGold = ex.Player:getItemNum(ItemType.IT_GOLD)
	local hasExp = ex.Player:getItemNum(ItemType.IT_HERO_EXP)
	self.canUp = hasGold >= condictionData.gold_need and hasExp >= condictionData.exp_need
	-- local color = hasGold >= condictionData.gold_need and cc.WHITE or cc.RED
	-- self.lbl_gold_need:setColor(color)
	-- color = hasExp >= condictionData.exp_need and cc.WHITE or cc.RED
	-- self.lbl_exp_need:setColor(color)
end

function HeroInfoUpLevelLayer:getMaxStage()
	local max = 0 
	for k,v in pairs(cfg.heroupgrade.grade) do
		if v.grade > max then max = v.grade end
	end
	return max
end

function HeroInfoUpLevelLayer:updateLevelAttrInfo()
	local max_stage = self:getMaxStage()

    local is_cube_hero = ex.Player.hero_data.magicCube:isCubeHero(self.hero_data.hero_id)
    local hero_stage = is_cube_hero and self.hero_data.tweak_cube_stage or self.hero_data.stage 

	
	local is_max_stage = hero_stage >= max_stage
	local gradeData = cfg.heroupgrade.grade[hero_stage]
	local maxLevel = cfg.herostar.star[self.hero_data.star].level_limit
	local level_str = gradeData.level
	if is_max_stage then 
		level_str = self.hero_data.star > max_stage and maxLevel or gradeData.level
	end

    local level = ex.Player.hero_data.magicCube:isCubeHero(self.hero_data.hero_id) == true and self.hero_data.tweak_cube_lv or self.hero_data.level
	local str = string.format("%s/%s",level,level_str)
	self.lbl_level:setString(str)
	if not gradeData or level >= maxLevel then 
		self.lbl_max_tips:setVisible(true)
		self.btn_up_level:setVisible(false)
		self.node_need:setVisible(false)
        if is_cube_hero then 
            self.btn_up_level:setVisible(true)
        end 
	else
		self.btn_up_level:setVisible(level < maxLevel and level_str ~= level)
		self.btn_up_grade:setVisible(not is_max_stage and level == gradeData.level)
		self.node_need:setVisible(level < maxLevel and level_str ~= level)
		self.lbl_max_tips:setVisible(level == level_str)
	end

	-- 显示英雄属性 需要删除
	-- self.hero_data:updateAbility()

	self.lbl_profession:setString(ex.Tools:getLang(47304)..ex.Tools:getLang(111000 + self.hero_data.occupation))
	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/hero-info.plist")
	local conf = cfg.herotype.star[self.hero_data.hero_type]
	ex.Tools:setSpriteFrame(self.icon_occupat, "hero-info/icon-occup-" .. conf.occupation .. ".png")

	self.lbl_attack:setString(ex.Tools:getAttrText(220, self.hero_data:getAtk()))
	self.lbl_hp:setString(ex.Tools:getAttrText(223, self.hero_data:getHp()))
	self.lbl_defense:setString(ex.Tools:getAttrText(224, self.hero_data:getDef()))
	self.lbl_speed:setString(ex.Tools:getAttrText(101, self.hero_data:getSpd()))

	ex.Player.hero_data.promote:checkHeroCanUpgrade(self.hero_data.hero_id)
	local canUpgrade = ex.Player.hero_data.promote:getHeroCanUpgrade(self.hero_data.hero_id)
    local is_cube_hero = ex.Player.hero_data.magicCube:isCubeHero(self.hero_data.hero_id) == true
    local grade_bool 
    if is_cube_hero then 
        grade_bool = false 

    else 
        grade_bool = self.hero_data.level < maxLevel and canUpgrade
    end 

	ex.Tools:addRedPoint(self.btn_up_grade,grade_bool)

	local condictionData = cfg.herolevel.level[self.hero_data.level]

	if not condictionData then 
		self.node_need:setVisible(false)
		self.btn_up_grade:setVisible(false)
		self.btn_up_level:setVisible(false)
		return 
	end
	

end

function HeroInfoUpLevelLayer:updateLevelSkillInfo()
	-- 显示英雄技能
	-- dump(self.hero_data)
	self.hero_data = ex.Player.hero_data:getHeroDataById(self.hero_data.hero_id)
	local vec_skill = ex.Player.hero_data:getHeroSkillList(self.hero_data.hero_type)
	local skill_num = table.nums(vec_skill)
	-- for i=1,skill_num do
	-- 	local skill_level = ex.Player.hero_data:getHeroSkillLevel(self.hero_data.stage, self.hero_data.star, i)
	-- 	local btn_skill = self["btn_skill"..i]
	-- 	if btn_skill then
	-- 		local config = cfg.heroupgrade.grade[self.hero_data.stage]
	-- 		local disabled = config["skill" .. i] == 0
	-- 		btn_skill:setLevel(skill_level)
	-- 		btn_skill:setGray(disabled)
	-- 	end
	-- end
	local UIMenuItemSkill = require("src.comp.menu.UIMenuItemSkill")
	
	
	local icon_width = 100
	local vec_skill = ex.Player.hero_data:getHeroSkillList(self.hero_data.hero_type)
	local skill_num = table.nums(vec_skill)
	local max_skill_num = 4
	local UIMenuItemSkill = require("src.comp.menu.UIMenuItemSkill")
	local begin_x = - (max_skill_num) * icon_width * 0.5
	local skill_stage = self:getSkillBystage()
	self.skill_menu:setLocalZOrder(10)
	self.skill_menu:removeAllChildren()
	self.node_nil_skill:removeAllChildren()
    local is_cube_hero = ex.Player.hero_data.magicCube:isCubeHero(self.hero_data.hero_id)
    local stage = is_cube_hero and self.hero_data.tweak_cube_stage or self.hero_data.stage
	for i=1,4 do
		if i <= skill_num then  
			local skill_level, is_evolve_skill, skill_id = ex.Player.hero_data:getHeroSkillLevel(stage, self.hero_data.star, i, self.hero_data.hero_type, self.hero_data.evolve)
			local btn_skill = UIMenuItemSkill:createWithIcon(skill_id, skill_level, is_evolve_skill, handler(self, self.onSkillInfo))
			btn_skill:setPosition(begin_x + icon_width * (i - 0.5), 0)
			btn_skill:createRich(skill_stage[i])
			btn_skill.lbl_name:setColor(cc.c3b(122,71,45))
			-- btn_skill.lbl_name:enableOutline(ex.c3b.BLACK, -1)
			btn_skill.lbl_name:setPositionY(-22)
			self.skill_menu:addChild(btn_skill)
			self["btn_skill"..i] = btn_skill

			btn_skill.skill_index = i
		else 
			-- 创建一个imgs
			local image = cc.Sprite:createWithSpriteFrameName("hero-info/spr-new-9.png")
			image:setPosition(begin_x + icon_width * (i - 0.5), 0)
			image:setTag(500)
			--image:setScaleX(win_size.width / self.spr_banner:getContentSize().width)
			--self.btn_up_grade:getParent():addChild(image)
			self.node_nil_skill:addChild(image)
		end 
	end
end

function HeroInfoUpLevelLayer:updateGradeInfo()
	if not self.gradeArr then 
		self.gradeArr = {}
		for i=1,6 do
			self.gradeArr[i] = self["sp_grade" .. i]
		end
	end


	local maxStar = self.hero_data.star
    local is_cube_hero = ex.Player.hero_data.magicCube:isCubeHero(self.hero_data.hero_id)
    local hero_stage = is_cube_hero and self.hero_data.tweak_cube_stage or self.hero_data.stage
	for k,v in pairs(self.gradeArr) do
		v:setVisible(k<=maxStar)
		local path = hero_stage >= k and "hero-info/spr-quality-2.png" or "hero-info/spr-quality-1.png"
		v:initWithSpriteFrameName(path)
	end
end

function HeroInfoUpLevelLayer:onClickUpLevel(tag,pSender)
	if self.can_up_level > 0 then 
		local req_hero_up_level = Hero_pb.GReqHeroUpLevel()
		req_hero_up_level.hero_id = self.hero_data.hero_id
		req_hero_up_level.up_level = self.can_up_level
		NetManager:sendMessage(ProtocolID.GReqHeroUpLevel,req_hero_up_level)
	else
		local condictionData = cfg.herolevel.level[self.hero_data.level]
		local total_gold = condictionData.gold_need
		local total_exp = condictionData.exp_need

		local hasGold = ex.Player:getItemNum(ItemType.IT_GOLD)
		local hasExp = ex.Player:getItemNum(ItemType.IT_HERO_EXP)
		if hasGold < total_gold then 
			ex.Tools:showEnoughTip(ItemType.IT_GOLD, true)
			return
		elseif hasExp < total_exp then
			ex.Tools:showEnoughTip(ItemType.IT_HERO_EXP, true)
			return
		end
	end
end

function HeroInfoUpLevelLayer:onClickUpgrade(tag, pSender)

	self.UpgradeCtr:openWindow(self.hero_data)
end

function HeroInfoUpLevelLayer:onSkillInfo(tag, pSender)
	print("HeroInfoUpLevelLayer:onSkillInfo", pSender.skill_level, pSender.skill_index, self.hero_data.hero_type)
	local skill_level_next_need_star = ex.Player.hero_data:getHeroSkillLevelNeedStar(pSender.skill_level + 1, pSender.skill_index, self.hero_data.hero_type)
    require("src.layer.HeroSkillInfoCtr"):instance():openWindow(pSender.skill_type, pSender.skill_level, skill_level_next_need_star)
end

return HeroInfoUpLevelLayer
