local HeroInfoUpStarLayer = class("HeroInfoUpStarLayer", require("src.comp.EventLayer"))

local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function HeroInfoUpStarLayer:onCreate()
	self.btn_up_star:registerScriptTapHandler(handler(self, self.onClickUpStar))

    self.scroll_view:setItemSize(cc.size(120,120))
    self.scroll_view:setItemOffset(cc.p(0, 5))
	
	self.lbl_jump:enableUnderline()
	self.lbl_jump:setUnderlineColor(cc.c4f(0.5529,0.3490,0.2274,1))
	self.lbl_jump:setUnderlineHeight(4)
	self:setSwallowTouches(false)

	self.lbl_jump:retain()
	self.lbl_jump:removeFromParent()
	local posX ,posY = self.lbl_jump:getPosition()
	self.lbl_jump:setPosition(0, 0)
	local menuItem = cc.MenuItemLabel:create(self.lbl_jump)
	menuItem:registerScriptTapHandler(handler(self, self.onClickJump))
	self.menu:addChild(menuItem)
	menuItem:setPosition(posX,posY)

    self.lbl_jump:release()


	self.hero_data = ex.Player.hero_data.promote:getSelectHero()
	-- self.select_list = ex.Player.hero_data:getCanSelectList(self.hero_data.hero_id)
	self:updateStarView()
	self:addEvent(EVENT.HERO_INFO_EVENT.HERO_UP_STAR_SELECT_EXIT,handler(self,self.updateStarSelectInfo))
	self:addEvent(EVENT.FASHION_SETTING.WEAR, handler(self, self.updateItemInfo))
end

-- function HeroInfoUpStarLayer:onSelect(event,data)
-- 	self.node_items
-- end

function HeroInfoUpStarLayer:updateStarView()
	self:createStar()
	self:updateLevel()
	self:updateItemInfo()
	self:updateAbilityInfo()
end

function HeroInfoUpStarLayer:getStarTypeAndCount(star)
	if star == 0 then return 0 ,0 end
	local star_type = math.floor(star / 5)
	local star_count

	if star % 5 == 0 then
		if star > 5 then
			star_count = 1
		else 
			star_count = 5
			star_type = 0
		end
	else
		star_count = star % 5
	end
	if star > 10 then star_count = star_count + 1 end
	return star_type,star_count
end

function HeroInfoUpStarLayer:createStar()
	local curStar = self.hero_data.star 
	local margin = 2
	self.node_cur_star:removeAllChildren()
	self.node_next_star:removeAllChildren()

	if curStar < 10 then
		local star_type,star_count = self:getStarTypeAndCount(curStar)
		for i=1,star_count do
			local sp = cc.Sprite:createWithSpriteFrameName(string.format("other/star-%d.png", star_type))
			sp:setPosition(-(sp:getContentSize().width + margin) * (i - 1) , 0)
			self.node_cur_star:addChild(sp)
		end
	else
		local spr_star_bg = cc.Sprite:createWithSpriteFrameName("backpack/spr-star-bg-2.png")
		:setPosition(cc.p(-50, 0))
		self.node_cur_star:addChild(spr_star_bg, 5)

		-- 英雄觉醒 add 熊梦 图标修改 如果加到15星需要再次修改
		if curStar == ex.Player.awaken_star then
            spr_star_bg:setSpriteFrame("backpack/spr-star-bg-4.png")
        elseif curStar > 10 then
			local spr_star = cc.Sprite:createWithSpriteFrameName("backpack/lbl-star-"..(curStar - 10)..".png")
			:setPosition(spr_star_bg:getPosition())
			self.node_cur_star:addChild(spr_star, 10)
		end
	end

	if curStar + 1 < 10 then
		star_type,star_count = self:getStarTypeAndCount(curStar+1)
		for i=1,star_count do
			local sp = cc.Sprite:createWithSpriteFrameName(string.format("other/star-%d.png", star_type))
			sp:setPosition((sp:getContentSize().width + margin) * (i - 1) , 0)
			self.node_next_star:addChild(sp)
		end
	else
		local spr_star_bg = cc.Sprite:createWithSpriteFrameName("backpack/spr-star-bg-2.png")
		:setPosition(cc.p(50, 0))
		self.node_next_star:addChild(spr_star_bg, 5)
	
		-- 英雄觉醒 add 熊梦 图标修改 如果加到15星需要再次修改
		if curStar + 1 == ex.Player.awaken_star then
            spr_star_bg:setSpriteFrame("backpack/spr-star-bg-4.png")
        elseif curStar + 1 > 10 then
			local spr_star = cc.Sprite:createWithSpriteFrameName("backpack/lbl-star-"..(curStar + 1 - 10)..".png")
			:setPosition(spr_star_bg:getPosition())
			self.node_next_star:addChild(spr_star, 10)
		end
	end
end

function HeroInfoUpStarLayer:updateLevel()
	-- local curStarData = ex.HeroStarTable:getConfig(self.hero_data.star)
	-- local nextStarData = ex.HeroStarTable:getConfig(self.hero_data.star + 1)
	local curStarData = cfg.herostar.star[self.hero_data.star]
	local nextStarData = cfg.herostar.star[self.hero_data.star + 1]
	if nextStarData == nil or nextStarData == "" then return end 
	self.lbl_now_max_level:setString(curStarData.level_limit)
	self.lbl_now_next_level:setString(nextStarData.level_limit)


	-- local redPoint =  ex.Player.hero_data.promote:getHeroUpStarRedPoint(self.hero_data.hero_id)
	-- self.lbl_jump:setVisible(not redPoint)
	-- self.node_need:setVisible(redPoint)

	-- if not redPoint then return end

	local cost = cfg.herostar.star[self.hero_data.star].upstar_cost--[1]

	self.node_need:setVisible(cost ~= "" and table.nums(cost) > 0 and cost[1].item_num ~= nil and cost[1].item_num > 0)
	self.lbl_jump:setVisible(cost == "" or table.nums(cost) <= 0 or cost[1].item_num == nil or cost[1].item_num <= 0)
	if cost ~= "" and table.nums(cost) > 0 then 
		cost = cost[1]
		self.lbl_gold_need:setString(cost.item_num)                  
		self.spr_gold_need:setSpriteFrame(string.format("backpack/%s.png",cost.item_type))
		self.spr_gold_need:setScale(0.5)
		local hasGold = ex.Player:getItemNum(cost.item_type)
		local color = hasGold >= cost.item_num and cc.c3b(255,255,255) or cc.c3b(255,0,0)
		self.lbl_gold_need:setColor(color)
		-- self.lbl_speed:setString()
	end
	-- self.node_need:setVisible(cost ~= "")
end

function HeroInfoUpStarLayer:updateItemInfo()
	local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")
	
	-- local starData = cfg.herostar.star[self.hero_data.star]
	local config_star = cfg.herostar.star[self.hero_data.star]
    local nextStar = "to_" .. self.hero_data.star + 1 .. "_star"
    local starData = cfg.herotype.star[self.hero_data.hero_type][nextStar]
    if starData == nil or starData == "" or #starData <= 0 then return end
    local margin = 12
    self.heroItem = {}

	local item_list = {}
	for k,v in pairs(starData) do
		local comsumeData = ex.Player.hero_data.promote:getComsumeHeroList(k)
		local canData = ex.Player.hero_data.promote:getCanSelectList(starData[k],k)

		local data = {}
    	data.num = string.format("%s/%s",#comsumeData,v.num) 
    	data.type = v.type == -1 and self.hero_data.hero_type or v.type 
    	data.elem = v.elem == -1 and self.hero_data.elem or v.elem
		data.star = v.star
		local can_num = #canData
		if v.replace_item ~= nil then 
			local item_nums = ex.Player:getItemNum(v.replace_item)
			can_num = can_num + item_nums
		end

		data.reddot = false
		
		for i,hero in ipairs(canData) do
			if not hero.is_lock then
				data.reddot = can_num >= v.num and #comsumeData < v.num
			end
		end
		-- data.reddot = can_num >= v.num and #comsumeData < v.num

		data.prop_type = ItemData.IT_HERO

		table.insert(item_list, data)

    	if data.type ~= 0 then 
    		local conf = cfg.herotype.star[v.type]
    		if not conf then print("hero not config by type:", data.type) end
    	end
	end
	
	if config_star.need_item and config_star.need_item ~= "" then
		for i,v in ipairs(config_star.need_item) do
			local data = clone(v)
			data.prop_type = ItemData.IT_PROP

			table.insert(item_list, data)
		end
	end

	self.heroItem = {}
	self.scroll_view.createItemFunction = function(item_data, scale, index, pos)
		local item = nil
		if item_data.prop_type == ItemData.IT_PROP then
			item = UIMenuItemBackpack:createWithData(item_data.item_type, 1)
			local item_num = ex.Player:getItemNum(item_data.item_type)
			item.lbl_num:setString(item_num.."/"..item_data.item_num)
			item.lbl_num:setColor(item_num >= item_data.item_num and cc.c3b(255,225,187) or cc.c3b(254,133,128))
			item:registerScriptTapHandler(handler(self, self.onItemInfo))
			item:setTag(index)
		else
			item = UIMenuItemHero:createWithData(0, item_data.type, item_data.elem, item_data.num, item_data.star , nil)
			item:initSelectItem(item_data)
			self.heroItem[index] = item
			item:setTag(index)
			item.data = item_data
			item:registerScriptTapHandler(handler(self, self.onClickUpStar))

			item:setRedPoint(item_data.reddot)
			if item_data.type == 0 then item:setAllIcon() end
		end

		return item
	end

	self.scroll_view:reloadData(item_list)

	-- 13-14为觉醒 觉醒文案显示其他的
	if self.hero_data.star + 1 == ex.Player.awaken_star then
		self.lbl_tips:setString(ex.Tools:getLang(6309))
	else
		self.lbl_tips:setString(ex.Tools:getLang(41108))
	end
end

function HeroInfoUpStarLayer:onItemInfo(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

function HeroInfoUpStarLayer:updateAbilityInfo()
	local nextStar = "to_" .. self.hero_data.star + 1 .. "_star"
    local starData = cfg.herotype.star[self.hero_data.hero_type][nextStar]
	if starData == nil or starData == "" or #starData <= 0 then
		self.node_upgrade_level:setVisible(false)
		self.node_upgrade_attack:setVisible(false)
		self.node_upgrade_speed:setVisible(false)
		self.node_upgrade_skill_all:setVisible(false)
		self.node_upgrade_skill:setVisible(false)
		return
	end
	
	self.node_upgrade_level:setVisible(true)
	self.node_upgrade_attack:setVisible(self.hero_data.star >= 5)
	self.node_upgrade_speed:setVisible(self.hero_data.star < 5)
	self.node_upgrade_skill_all:setVisible(self.hero_data.star == 5)
	self.node_upgrade_skill:setVisible(self.hero_data.star > 5 and self.hero_data.star < 10)

	if self.hero_data.star >= 5 then
		local config_star = cfg.herostar.star[self.hero_data.star]
		self.lbl_upgrade_attack:setString(string.format("%s%%/%s%%", config_star.attack_show, config_star.hp_show))
	end

	if self.hero_data.star < 5 then
		self.node_upgrade_level:setPosition(-270, 300)
		self.node_upgrade_speed:setPosition(10, 300)
	elseif self.hero_data.star < 6 then
		self.node_upgrade_level:setPosition(-270, 300)
		self.node_upgrade_skill_all:setPosition(10, 300)
		self.node_upgrade_attack:setPosition(-270, 260)
	elseif self.hero_data.star < 10 then
		self.node_upgrade_level:setPosition(-270, 220)
		self.node_upgrade_attack:setPosition(10, 220)

		-- 查找到升级的技能，并显示出来
		local vec_skill = ex.Player.hero_data:getHeroSkillList(self.hero_data.hero_type)
		local skill_num = table.nums(vec_skill)
		for i=1,4 do
			if i <= skill_num then  
				local skill_level_1 = ex.Player.hero_data:getHeroSkillLevelWithStarView(self.hero_data.stage, self.hero_data.star, i)
				local skill_level_2 = ex.Player.hero_data:getHeroSkillLevelWithStarView(self.hero_data.stage, self.hero_data.star + 1, i)

				if skill_level_1 ~= skill_level_2 then
					self.spr_skill_icon_1:setSpriteFrame("skill-icon/"..vec_skill[i]..".png")
					self.spr_skill_icon_2:setSpriteFrame("skill-icon/"..vec_skill[i]..".png")

					self.lbl_skill_level_1:setString(skill_level_1)
					self.lbl_skill_level_2:setString(skill_level_2)

					self.btn_skill_1:setContentSize(60, 60)
					self.btn_skill_1.skill_index = i
					self.btn_skill_1.skill_type = vec_skill[i]
					self.btn_skill_1.skill_level = skill_level_1
					self.btn_skill_1:registerScriptTapHandler(handler(self, self.onSkillInfo))
					self.btn_skill_2:setContentSize(60, 60)
					self.btn_skill_2.skill_index = i
					self.btn_skill_2.skill_type = vec_skill[i]
					self.btn_skill_2.skill_level = skill_level_2
					self.btn_skill_2:registerScriptTapHandler(handler(self, self.onSkillInfo))

					break
				end
			end
		end
	else
		self.node_upgrade_level:setPosition(-270, 300)
		self.node_upgrade_attack:setPosition(10, 300)
	end
end

function HeroInfoUpStarLayer:onSkillInfo(tag, pSender)
	if pSender == nil or pSender.skill_type == nil or pSender.skill_type == nil then
		return
	end

	-- local skill_level_next_need_star = ex.Player.hero_data:getHeroSkillLevelNeedStar(pSender.skill_level + 1, pSender.skill_index, self.hero_data.hero_type)
    require("src.layer.HeroSkillInfoCtr"):instance():openWindow(pSender.skill_type, pSender.skill_level--[[, skill_level_next_need_star]])
end

function HeroInfoUpStarLayer:updateStarSelectInfo(event)
	local config = cfg.herotype.star[self.hero_data.hero_type]
	local starCfg = config["to_" .. self.hero_data.star + 1 .. "_star"]
	if starCfg == nil or starCfg == "" or #starCfg <= 0 then return end
	for i,v in ipairs(starCfg) do
		local count = #ex.Player.hero_data.promote:getComsumeHeroList(i)

		if v.replace_item and v.replace_item > 0 and ex.Player.hero_data.promote:getSlectReplace(i) and  ex.Player.hero_data.promote:getSlectReplace(i) == true  then 
			count = count + 1
		end 

		local str = string.format("%s/%s",count,v.num)
		local node = self.heroItem[i]
		node:setSelectNum(str)

		local canData = ex.Player.hero_data.promote:getCanSelectList(starCfg[i],i)
		--local comsumeData = ex.Player.hero_data.promote:getComsumeHeroList(i)
		-- local can_num = #canData
		local can_num = 0
		for i,candata in ipairs(canData) do
			if not candata.is_lock then
				can_num = can_num + 1
			end
		end
		if v.replace_item ~= nil then 
			local item_nums = ex.Player:getItemNum(v.replace_item)
			can_num = can_num + item_nums
		end
		if node.data.reddot then
			node:setRedPoint(can_num >= v.num and count < v.num)
		end
		
	end
end

function HeroInfoUpStarLayer:onClickUpStar(tag,pSender)
	local index = pSender:getTag()

	require("src.layer.HeroUpStarSelectCtr"):instance():openWindow(index, true, index == 2 and self.hero_data.star == 5)
end

function HeroInfoUpStarLayer:onClickJump(tag,pSender)
	-- print(self.__cname,"onClickJump")
	local layer = ex.MainSceneCtr:changeLayer(MainSceneType.HERO_CREAT_LAYER)
	layer:onHeroSelect(self.hero_data.hero_type)
end

return HeroInfoUpStarLayer
