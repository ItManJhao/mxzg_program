local UpgradeSuccessLayer = class("UpgradeSuccessLayer", require("src.comp.EventLayer"))
local UpgradeSuccessCtr = class("UpgradeSuccessCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

function UpgradeSuccessLayer:onCreate()
	self:addBlackBackground()
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/hero-info-effect.plist")
	self.lbl_btn_enter = cc.Label:createWithTTF(ex.Tools:getLang(47589), FONT_DEFAULT_NAME_BOLD, 24)
	self.lbl_btn_enter:setColor(FONT_BLACK)
    self.btn_enter:addChild(self.lbl_btn_enter)
    self.lbl_btn_enter:setPosition(self.btn_enter:getContentSize().width / 2,self.btn_enter:getContentSize().height / 2)
    -- self.lbl_btn_enter:enableOutline(ex.c3b.BLACK, 1)
    self:findAttrLable()

    self.node_effect:setLocalZOrder(100)

	-- 英雄升阶特效
	local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_hero_upgrade")
    spr_effect:setPosition(self.spr_upgrade_success_tip:getPositionX() + 0, self.spr_upgrade_success_tip:getPositionY() - 16)
    self:addChild(spr_effect, 120, 15)
end

function UpgradeSuccessLayer:onExit()
	if self.unlock_data ~= nil and self.unlock_data.unlock == true then 
		local hero_data = ex.Player.hero_data.promote:getSelectHero()
		require("src.layer.HeroSkillInfoOpenCtr"):instance():openWindow(hero_data,self.unlock_data.idx)
	end
end

function UpgradeSuccessLayer:findAttrLable()
	self.attrNames = {}
	self.attrPres = {}
	self.attrCurs = {}
	for i=1,5 do
		self.attrNames[i] = self["lbl_attr_" .. i]
		self.attrPres[i] = self["lbl_pre_" .. i]
		self.attrCurs[i] = self["lbl_cur_" .. i]
		self.attrPres[i]:enableOutline(FONT_BLACK, 1)
		self.attrCurs[i]:enableOutline(FONT_BLACK, 1)
	end

	self.lbl_level:enableOutline(FONT_BLACK, 1)
	self.lbl_pre_level:enableOutline(FONT_BLACK, 1)
	self.lbl_cur_level:enableOutline(FONT_BLACK, 1)
end

function UpgradeSuccessLayer:createStar(data)
	-- local curStar = star 
	-- if star == 0 then star = 1 end
	local margin = 4
	self.node_pre_star:removeAllChildren()
	self.node_cur_star:removeAllChildren()
	-- local star_type,star_count = self:getStarTypeAndCount(star - 1)
	local maxGrade = table.nums(cfg.heroupgrade.grade) - 1 
	local maxStar = maxGrade <= data.star and maxGrade or data.star
	local pos = {}
	for i=1,maxStar do
		if i == 1 then 
			pos.x = 0
			pos.y = 0
		end
		-- local path = data.stage-1 >= i and "hero-info/spr-quality-2.png" or "hero-info/spr-quality-1.png"
		local path = i > maxStar - data.stage + 1 and "hero-info/spr-quality-2.png" or "hero-info/spr-quality-1.png"
		local sp = cc.Sprite:createWithSpriteFrameName(path)
		self.node_pre_star:addChild(sp)
		sp:setPosition(-pos.x, pos.y)
		pos.x = pos.x + sp:getContentSize().width + margin
		-- sp:setPosition(-(sp:getContentSize().width + margin) * (i - 1) , 0)
	end

	for i=1,maxStar do
		if i == 1 then 
			pos.x = 0
			pos.y = 0
		end
		local path = data.stage >= i and "hero-info/spr-quality-2.png" or "hero-info/spr-quality-1.png"
		local sp = cc.Sprite:createWithSpriteFrameName(path)
		self.node_cur_star:addChild(sp)
		sp:setPosition(pos.x,pos.y)
		pos.x = pos.x + sp:getContentSize().width + margin
		-- sp:setPosition((sp:getContentSize().width + margin) * (i - 1) , 0)
	end
end

----------------------------------------------------------

function UpgradeSuccessCtr:onCreate()
	self:setCCBIPath("ccbi/UpgradeSuccessLayer.ccbi")
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/hero-info-effect.plist")
	self:setIsSingle(false)
end

function UpgradeSuccessCtr:getLayerClass()
	return UpgradeSuccessLayer
end

function UpgradeSuccessCtr:getShopLayer()
	return self.layer
end

function UpgradeSuccessCtr:openWindow(data,unlock_data)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(data,unlock_data)
end

function UpgradeSuccessCtr:initData(data,unlock_data)
	-- self.layer.btn_up_grade:registerScriptTapHandler(handler(self, self.onClickUpgrade))
	self.layer.btn_enter:registerScriptTapHandler(handler(self, self.closeWindow))
	-- self.layer:setPosition(193,368)
	self:updateLayer(data,unlock_data)
	ex.AudioManager:playEffect("music/hero-up-star.mp3")
end

function UpgradeSuccessCtr:onClickUpgrade(tag,pSender)

end

function UpgradeSuccessCtr:updateLayer(data,unlock_data)
	self.data = data
	local layer = self.layer
	layer.unlock_data = unlock_data
	local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")
	local item = UIMenuItemHero:createWithData()
	item:reset(data)
	item:setAnchorPoint(0,0)
	item:setEnabled(false)
	layer.menu:add(item)
	item:setPosition(layer:getContentSize().width/2 - item:getContentSize().width/2,500)
	layer:createStar(data)
	-- item.lbl_name:setVisible(false)

	local hero_attr_pre = ex.Player.hero_data:getHeroAttribute(data.hero_type, data.stage - 1, data.star, data.level)
	local hero_attr_now = ex.Player.hero_data:getHeroAttribute(data.hero_type, data.stage, data.star, data.level)


	local vec_title = {}
	vec_title.bat = ex.Tools:getLang(47569)
	vec_title.atk = ex.Tools:getLang(47372)
	vec_title.hp = ex.Tools:getLang(47704)
	vec_title.def = ex.Tools:getLang(47195)
	vec_title.spd = ex.Tools:getLang(47389)

	local vec_attr = {}
	for k,v in pairs(hero_attr_now) do
		-- 属性一样。则忽略对应属性
		if hero_attr_pre[k] ~= v then
			local data = {}
			data.title = vec_title[k]
			data.pre = hero_attr_pre[k]
			data.cur = v
			table.insert(vec_attr, data)
		end
	end

	-- print("vec_attr", json.encode(vec_attr))

	-- 隐藏所有属性节点
	local node_num = 5
	for i=1,node_num do
		local lbl_attr = layer["lbl_attr_"..tostring(i)]
		if lbl_attr then
		 	lbl_attr:getParent():setVisible(false)
		end
	end

	-- if true then
	-- 	return
	-- end

	for i,v in ipairs(vec_attr) do
		local lbl_attr = layer["lbl_attr_"..tostring(i)]
		local lbl_pre = layer["lbl_pre_"..tostring(i)]
		local lbl_cur = layer["lbl_cur_"..tostring(i)]
		lbl_pre:getParent():setVisible(true)
		lbl_pre:setString(string.format("%d", v.pre))
		lbl_cur:setString(string.format("%d", v.cur))
		lbl_attr:setString(v.title)
	end

	local pre_cfg = cfg.heroupgrade.grade[data.stage - 1]
	local now_cfg = cfg.heroupgrade.grade[data.stage]
	layer.lbl_pre_level:setString(pre_cfg.level)
	layer.lbl_cur_level:setString(now_cfg.level)
	local vec_skill = ex.Player.hero_data:getHeroSkillList(data.hero_type)
	local skill 
	if unlock_data.unlock == true then 
		skill = vec_skill[unlock_data.idx]
	end
	layer.skill_node:setVisible(skill ~= nil)
	if skill ~= nil then 
		layer.skill_menu:removeAllChildren()
		local skill_level, is_evolve_skill = ex.Player.hero_data:getHeroSkillLevel(data.stage, data.star, unlock_data.idx, data.hero_type)
		local btn_skill = require("src.comp.menu.UIMenuItemSkill"):createWithIcon(skill, 1, is_evolve_skill, handler(self, self.onSkillInfo))
		btn_skill.skill_level = 1
		btn_skill.skill_index = skill
		local skill_name = btn_skill.lbl_name:getString()
		btn_skill.lbl_name:setVisible(false)

		layer.lbl_skill_name:setString(skill_name)
		layer.skill_menu:addChild(btn_skill)
		btn_skill:setPosition(0,0)
	end
	
end

function UpgradeSuccessCtr:onSkillInfo(tag, pSender)
	-- print("HeroInfoUpLevelLayer:onSkillInfo", pSender.skill_level, pSender.skill_index, self.data.hero_type)
	local skill_level_next_need_star = ex.Player.hero_data:getHeroSkillLevelNeedStar(pSender.skill_level + 1, pSender.skill_index, self.data.hero_type)
    require("src.layer.HeroSkillInfoCtr"):instance():openWindow(pSender.skill_type, pSender.skill_level, skill_level_next_need_star)
end

return UpgradeSuccessCtr