local HeroInfoUpgradeLayer = class("HeroInfoUpgradeLayer", require("src.comp.LuaLayerBase"))
local HeroUpgradeCtr = class("HeroUpgradeCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

function HeroInfoUpgradeLayer:onCreate()
	self:addBlackBackground()
	-- self.btn_up_grade:setLabelText(ex.Tools:getLang(47754))
	self.btn_up_grade:setLabelText("")
	-- self.btn_up_grade:setLabelColor(FONT_BLACK)
	-- self.btn_up_grade:setLabelShadow(FONT_BLACK_C4B, cc.size(0, 0))
	-- self.btn_up_grade:setLabelSize(60)
	local lbl_up_grade = cc.Label:createWithTTF(ex.Tools:getLang(47754), FONT_DEFAULT_NAME_BOLD,32)
	lbl_up_grade:setColor(cc.c3b(255,255,255))
	lbl_up_grade:enableOutline(cc.c3b(78,0,213),2)
	self.btn_up_grade:addChild(lbl_up_grade)
	lbl_up_grade:setPosition(self.btn_up_grade:getContentSize().width / 2,self.btn_up_grade:getContentSize().height / 2)

	local x,y = self.lbl_gold_need:getPosition()
	self.rich_gold = cpp.RichTextEx:createWithXMLLua("")
	self.rich_gold:setFontSize(20)
	self.rich_gold:setScale(1)
	self.rich_gold:setFontFace(FONT_DEFAULT_NAME_BOLD)
	self.rich_gold:setFontColor("#FFFFFF")
	self.rich_gold:setAnchorTextShadow(false)
	self.rich_gold:setAnchorPoint(ex.a.left_center)
    self.rich_gold:setPosition(cc.p(x,y))
	self.rich_gold:setLocalZOrder(10)
	self.node_need:addChild(self.rich_gold)

	x,y = self.lbl_soul_need:getPosition()
	
	self.rich_soul = cpp.RichTextEx:createWithXMLLua("")
	self.rich_soul:setFontSize(20)
	self.rich_soul:setScale(1)
	self.rich_soul:setFontFace(FONT_DEFAULT_NAME_BOLD)
	self.rich_soul:setFontColor("#FFFFFF")
	self.rich_soul:setAnchorTextShadow(false)
	self.rich_soul:setAnchorPoint(ex.a.left_center)
    self.rich_soul:setPosition(cc.p(x,y))
	self.rich_soul:setLocalZOrder(10)
	self.node_need:addChild(self.rich_soul)

	-- self.btn_up_grade:registerScriptTapHandler(handler(self, self.onClickUpgrade))
	self.hero_data = ex.Player.hero_data.promote:getSelectHero()
	self:updateInfo()
	self:findAttrLable()
end

function HeroInfoUpgradeLayer:findAttrLable()
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

function HeroInfoUpgradeLayer:updateInfo()
	-- local condictionData = ex.HeroUpgradeTable:getConfig(self.hero_data.grade + 1)
	-- if not condictionData then return end
	-- local gradeData = ex.HeroUpgradeTable:getConfig(self.hero_data.grade)
	local gradeData = cfg.heroupgrade.grade[self.hero_data.stage]
	self.soul_need = gradeData.soul
	self.gold_need = gradeData.gold
	self.canUpgrade = false
	if not gradeData then return end
	-- if self.hero_data.level == gradeData.level then return end
	-- self.lbl_soul_need:setString(gradeData.soul)
	self.lbl_soul_need:setString("")
	local hasSoul = ex.Player:getItemNum(ItemType.IT_HERO_UP_STONE)
	self.spr_soul_need:setSpriteFrame(string.format("backpack/%s.png",ItemType.IT_HERO_UP_STONE))
	self.spr_soul_need:setScale(0.5)
	local color = hasSoul >= gradeData.soul and "#FFFFFF" or "#FF0000"
	-- self.lbl_soul_need:setColor(color)
	local str = string.format("<font color='%s'>%s</font>/%s",color,ex.Tools:convertNumToStr(hasSoul),ex.Tools:convertNumToStr(gradeData.soul))
	self.rich_soul:setXmlTextLua(str)

	-- self.lbl_gold_need:setString(gradeData.gold)
	self.lbl_gold_need:setString("")
	local hasGold = ex.Player:getItemNum(ItemType.IT_GOLD)
	self.spr_gold_need:setSpriteFrame(string.format("backpack/%s.png",ItemType.IT_GOLD))
	self.spr_gold_need:setScale(0.5)
	color = hasGold >= gradeData.gold and "#FFFFFF" or "#FF0000"
	-- self.lbl_gold_need:setColor(color)
	local str = string.format("<font color='%s'>%s</font>/%s",color,ex.Tools:convertNumToStr(hasGold),ex.Tools:convertNumToStr(gradeData.gold))
	self.rich_gold:setXmlTextLua(str)

	self.canUpgrade = self.hero_data.level == gradeData.level and hasSoul >= gradeData.soul and hasGold >= gradeData.gold
	-- self.lbl_exp_need:setString(gradeData.exp_need)
	self.btn_get:setVisible(not (hasSoul >= gradeData.soul))
	ex.Tools:addRedPoint(self.btn_up_grade,self.canUpgrade,cc.p(0.9,1))
end

function HeroInfoUpgradeLayer:createStar(data)
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
		local path = i > maxStar - data.stage and "hero-info/spr-quality-2.png" or "hero-info/spr-quality-1.png"
		-- local path = data.stage >= i and "hero-info/spr-quality-2.png" or "hero-info/spr-quality-1.png"
		local sp = cc.Sprite:createWithSpriteFrameName(path)
		self.node_pre_star:addChild(sp)

		sp:setPosition(-pos.x,pos.y)
		pos.x = pos.x + sp:getContentSize().width + margin
		-- sp:setPosition(-(sp:getContentSize().width + margin) * (i - 1) , 0)
	end

	for i=1,maxStar do
		if i == 1 then 
			pos.x = 0
			pos.y = 0
		end
		local path = data.stage + 1 >= i and "hero-info/spr-quality-2.png" or "hero-info/spr-quality-1.png"
		local sp = cc.Sprite:createWithSpriteFrameName(path)
		self.node_cur_star:addChild(sp)
		sp:setPosition(pos.x,pos.y)
		pos.x = pos.x + sp:getContentSize().width + margin
		-- sp:setPosition((sp:getContentSize().width + margin) * (i - 1) , 0)
	end
end

----------------------------------------------------------

function HeroUpgradeCtr:ctor()
	local ccbi_file = "ccbi/HeroInfoUpgradeLayer.ccbi"
	self:setCCBIPath(ccbi_file)
	self:registerCCBLoader()
	self:setIsSingle(false)
end

function HeroUpgradeCtr:loadLayer()
	local layer = HeroInfoUpgradeLayer
	local ccbi_file = self:getCCBIPath()
	self.layer = layer:create(ccbi_file)
	self:setLayer(self.layer)

    -- 创建点击事件
    self:registerTouchListen()
end


function HeroUpgradeCtr:getShopLayer()
	return self.layer
end

function HeroUpgradeCtr:openWindow(data)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(data)
end

function HeroUpgradeCtr:initData(data)
	self.layer.btn_up_grade:registerScriptTapHandler(handler(self, self.onClickUpgrade))
	self.layer.btn_get:registerScriptTapHandler(handler(self, self.onClickGet))
	-- self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	-- self.layer:setPosition(193,368)
	self:updateLayer(data)
end

function HeroUpgradeCtr:onClickUpgrade(tag,pSender)
	if self.layer.canUpgrade then 
		-- local req_hero_up_grade = cpp.ByteArray:create()
		-- req_hero_up_grade:writeInt(ProtocolID.GReqHeroUpgrade)
		-- req_hero_up_grade:writeInt64(self.layer.hero_data.hero_id)
		-- cpp.NetManager:instance():sendByteArray(req_hero_up_grade)
		local req_hero_up_grade = Hero_pb.GReqHeroUpgrade()
		req_hero_up_grade.hero_id = self.layer.hero_data.hero_id
		NetManager:sendMessage(ProtocolID.GReqHeroUpgrade,req_hero_up_grade)
		--ex.Player.backpack_data:changeBackpack(ItemType.IT_HERO_UP_STONE,-self.layer.soul_need)
		-- ex.Player:addItem(ItemType.IT_HERO_UP_STONE,-self.layer.soul_need, "0")
		self:closeWindow(nil,self.layer)
	else
		local gradeData = cfg.heroupgrade.grade[self.layer.hero_data.stage]
		local hasGold = ex.Player:getItemNum(ItemType.IT_GOLD)
		local hasSoul = ex.Player:getItemNum(ItemType.IT_HERO_UP_STONE)

		if hasGold < gradeData.gold then
			ex.Tools:showEnoughTip(ItemType.IT_GOLD, true)
			return
		elseif hasSoul < gradeData.soul then
			ex.Tools:showEnoughTip(ItemType.IT_HERO_UP_STONE, true)
			return
		end
	end
end

function HeroUpgradeCtr:onClickGet(tag,pSender)
	ex.Tools:onClickItemSrc(ItemType.IT_HERO_UP_STONE)
	self:closeWindow()
end

function HeroUpgradeCtr:updateLayer(data)
	self.data = data
	local layer = self.layer
	local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")
	local item = UIMenuItemHero:createWithData()
	item:reset(data)
	item:setAnchorPoint(0,0)
	item:setEnabled(false)
	layer.menu:add(item)
	item:setPosition(layer:getContentSize().width/2 - item:getContentSize().width/2,500)
	layer:createStar(data)

	local hero_attr_pre = ex.Player.hero_data:getHeroAttribute(data.hero_type, data.stage, data.star, data.level)
	local hero_attr_now = ex.Player.hero_data:getHeroAttribute(data.hero_type, data.stage + 1, data.star, data.level)


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

	print("vec_attr", json.encode(vec_attr))

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

	local pre_cfg = cfg.heroupgrade.grade[data.stage]
	local now_cfg = cfg.heroupgrade.grade[data.stage + 1]
	layer.lbl_pre_level:setString(pre_cfg.level)
	layer.lbl_cur_level:setString(now_cfg.level)
	local skill 
	local idx = 1

	local vec_skill = ex.Player.hero_data:getHeroSkillList(data.hero_type)
	for i=1,4 do
		local key = "skill" .. i 
		if pre_cfg[key] ~= now_cfg[key] then 
			skill = vec_skill[i]
			idx = i
			break
		end
	end

	layer.skill_node:setVisible(skill ~= nil)
	layer.spr_up:setVisible(skill == nil)
	if skill ~= nil then 
		layer.skill_menu:removeAllChildren()
		local skill_level, is_evolve_skill = ex.Player.hero_data:getHeroSkillLevel(data.stage, data.star, idx, data.hero_type)
		local btn_skill = require("src.comp.menu.UIMenuItemSkill"):createWithIcon(skill, 1, is_evolve_skill, handler(self, self.onSkillInfo))
		btn_skill.skill_level = 1
		btn_skill.skill_index = idx
		local skill_name = btn_skill.lbl_name:getString()
		btn_skill.lbl_name:setVisible(false)

		layer.lbl_skill_name:setString(skill_name)
		layer.skill_menu:addChild(btn_skill)
		btn_skill:setPosition(0,0)
	end
end

function HeroUpgradeCtr:onSkillInfo(tag, pSender)
	-- print("HeroInfoUpLevelLayer:onSkillInfo", pSender.skill_level, pSender.skill_index, self.data.hero_type)
	local skill_level_next_need_star = ex.Player.hero_data:getHeroSkillLevelNeedStar(pSender.skill_level + 1, pSender.skill_index, self.data.hero_type)
    require("src.layer.HeroSkillInfoCtr"):instance():openWindow(pSender.skill_type, pSender.skill_level, skill_level_next_need_star)
end

return HeroUpgradeCtr
