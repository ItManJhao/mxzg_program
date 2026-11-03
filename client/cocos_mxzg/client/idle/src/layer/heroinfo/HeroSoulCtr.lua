--[[
* @Description: 装备附魂
* @Author: 熊梦
* @Date: 2020-03-6 15:42:00
* ]]

local HeroSoulCtr = class("HeroSoulCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroSoulLayer = class("HeroSoulLayer", require("src.comp.EventLayerAdaptiveWidthFull"))
local UIMenuItemSkill = require("src.comp.menu.UIMenuItemSkill")
-----------------------------------------------------------------------

function HeroSoulLayer:onCreate()
	self:addBlackBackground()
	self:registerBtnEvent()

	self:iniData()

end

function HeroSoulLayer:registerBtnEvent( )
	local ctr = HeroSoulCtr:instance()
	self.btn_close:registerScriptTapHandler(handler(ctr, ctr.closeWindow))

	self:addEvent(EVENT.HERO_INFO_EVENT.SOUL, handler(self,self.updateView))

	self:addEvent(EVENT.HERO_INFO_EVENT.SOUL_RESULT, handler(self,self.openResultCtr))
	
end

function HeroSoulLayer:iniData( )
	self.hero_data = ex.Player.hero_data.promote:getSelectHero()
	self.equip = ex.Player.hero_data.equip:getHeroEquip(self.hero_data.hero_id).equip_list
	self.equips = {}
	self.hero = nil
	self.border_tag = nil

	local conf = cfg.herotype.star[self.hero_data.hero_type]
	self.lbl_hero_name:setString(ex.Tools:getLang(self.hero_data.hero_type))
	self.icon_elem:setSpriteFrame("hero-icon/elem-" .. conf.elem .. ".png")
	self.icon_elem:setPositionX(self.lbl_hero_name:getPositionX() - self.lbl_hero_name:getContentSize().width / 2 - 20)
	self:createStar()

	-- 超链接 技能预览
	local skill_preview = require("src.comp.RichTextEx"):create()
	:setFontSize(22)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
    :setWrapMode(1)
    :setAnchorPoint(cc.p(0, 0.5))

    skill_preview:setCallback(handler(self, self.openRichTextUrl))
    skill_preview:setXmlTextLua(ex.Tools:getLang(6404))
    skill_preview:setName("rich_text")
	skill_preview:setPosition(self.btn_skill_preview:getPositionX()+self.btn_skill_preview:getContentSize().width-10,-5)
    self.node_preview:addChild(skill_preview)    
	skill_preview:formatText()
	ex.Tools:setLimitWidth(skill_preview,120)


	-- 显示消耗
	local config = self:getConfig(1,1)
	for i=1,2 do
		self["btn_item_"..i]:setNormalImage(cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", config.cost[i].item_type)))
		self["btn_item_"..i].item_type = config.cost[i].item_type
		local str = ""
		str = ex.Player:getItemNum( config.cost[i].item_type) .. "/" .. config.cost[i].item_num
		self["lbl_num_"..i]:setString(str)

		if ex.Player:getItemNum( config.cost[i].item_type) < config.cost[i].item_num then
			self["lbl_num_"..i]:setColor(FONT_RED)
		else
			self["lbl_num_"..i]:setColor(FONT_WHITLE)
		end
	end

	local is_border = false
	for i=1,EquipMaxCount do
		self.equips[i] = self["btn_equip_" .. i]
		self.equips[i]:registerScriptTapHandler(handler(self,self.onClickEquip))
		self.equips[i]:setTag(i)
		self.equips[i]:setEnabled(false)
		
		local red = cc.Sprite:createWithSpriteFrameName("other/spr-reddot-1.png")
		red:setName("redPoint")
		self.equips[i]:addChild(red)
		red:setLocalZOrder(100)
		red:setPosition(self.equips[i]:getContentSize().width * 0.8, self.equips[i]:getContentSize().height * 0.8)
		red:setVisible(false)

		local node_star = cc.Node:create()
		node_star:setName("node_star")
		self.equips[i]:addChild(node_star)
		node_star:setLocalZOrder(20)
		node_star:setPosition(0, 10)

		local spr_not_equip = cc.Sprite:createWithSpriteFrameName(string.format("other/spr-equip-%s.png",i))
		self.equips[i].not_equip = spr_not_equip
		self.equips[i]:addChild(spr_not_equip)
		local size = self.equips[i]:getContentSize()
		spr_not_equip:setPosition(size.width /2 ,size.height / 2)

		local soul_level_bg = cc.Sprite:createWithSpriteFrameName("hero-soul/spr-soul-level-bg.png")
		soul_level_bg:setName("soul_level_bg")
		self.equips[i].soul_level_bg = soul_level_bg
		self.equips[i]:addChild(soul_level_bg,50)
		soul_level_bg:setPosition(45 ,size.height - 15)

		local lbl_grade_text = cc.Label:createWithTTF(ex.Tools:getLang(47301), FONT_DEFAULT_NAME_BOLD, 16)
		lbl_grade_text:setName("lbl_grade_text")
		lbl_grade_text:setPosition(soul_level_bg:getContentSize().width /2, soul_level_bg:getContentSize().height /2)
		lbl_grade_text:enableOutline(cc.c4b(114, 111, 72, 255), 2)
		soul_level_bg:addChild(lbl_grade_text)

		local spr_border = cc.Sprite:createWithSpriteFrameName("backpack/spr-select.png")
		spr_border:setPosition(size.width /2 ,size.height / 2)
		spr_border:setName("spr_border")
		spr_border:setVisible(false)
		self.equips[i]:addChild(spr_border, 90)
		local equip = self.equip[i]
		if equip ~= nil and equip.item_type ~= 0 and not is_border then 
			local config = cfg.equipmenttype.equip[equip.item_type]
			local requirement = cfg.heroequipsoulextra.heroequipsoulextra[self.equips[i]:getTag()]
			if config.star >= requirement.need_equip_star and config.rare >= requirement.need_euqip_rare then
				spr_border:setVisible(true)
				is_border = true
				self.border_tag = self.equips[i]:getTag()
			end
		end
	end

	if not is_border then
		self.lbl_warning:setVisible(true)
	else
		self.lbl_warning:setVisible(false)
	end

	self:createSpine()
	self:updateView()


end

function HeroSoulLayer:openResultCtr()
	local equip = ex.Player.hero_data.equip:getHeroEquip(self.hero_data.hero_id).equip_list[self.border_tag]
	require("src.layer.heroinfo.HeroSoulResultCtr"):instance():openWindow(equip)
end

function HeroSoulLayer:updateView()
	self.equip = ex.Player.hero_data.equip:getHeroEquip(self.hero_data.hero_id).equip_list

	self:updateHeroEquip()
	self:updateLevelSkillInfo()
end

function HeroSoulLayer:updateHeroEquip()

	for i=1,EquipMaxCount do
		local equip = self.equip[i]
		local bg = self.equips[i]:getChildByName("bg")
		local icon = self.equips[i]:getChildByName("icon")
		local node_star = self.equips[i]:getChildByName("node_star")
		local spr_border = self.equips[i]:getChildByName("spr_border")
		local soul_level_bg = self.equips[i]:getChildByName("soul_level_bg") 
	
		node_star:removeAllChildren()
		self.equips[i]:setEnabled(false)
		soul_level_bg:setVisible(false)
		if bg ~= nil then 
	 		self.equips[i]:removeChildByName("bg")
	 		bg = nil 
	 	end
		if icon ~= nil then 
	 		self.equips[i]:removeChildByName("icon")
	 		icon = nil 
	 	end
	 	if equip ~= nil and equip.item_type ~= 0 then 
	 		local config = cfg.equipmenttype.equip[equip.item_type]
			local requirement = cfg.heroequipsoulextra.heroequipsoulextra[i]
			if config.star >= requirement.need_equip_star and config.rare >= requirement.need_euqip_rare then
				self.equips[i]:setEnabled(true)
				local size = self.equips[i]:getContentSize()
				bg = cc.Sprite:createWithSpriteFrameName(string.format("other/rare-%d.png", cfg.item.item[equip.item_type].rare_mark))
				bg:setName("bg")
				local scale = cc.p(size.width / bg:getContentSize().width, size.height / bg:getContentSize().height)
				scale = math.min(scale.x, scale.y)
				bg:setScale(scale)
				bg:setPosition(size.width * 0.5, size.height * 0.5)
				self.equips[i]:addChild(bg, 9)
				
				icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", equip.item_type))
				icon:setName("icon")

				scale = cc.p(size.width / icon:getContentSize().width, size.height / icon:getContentSize().height)
				scale = math.min(scale.x, scale.y) * 0.8

				icon:setPosition(size.width * 0.5, size.height * 0.5)
				icon:setScale(scale)
				self.equips[i]:addChild(icon, 10)
				self:createEquipStar(self.equips[i],equip.item_type)
				
				if equip.soul_lv > 0 then
					soul_level_bg:getChildByName("lbl_grade_text"):setString(string.format(ex.Tools:getLang(6402),equip.soul_lv))
					soul_level_bg:setVisible(true)
				end

				self:checkBtnRedPoint(self.equips[i]:getTag(),equip.soul_lv + 1)
			end
	 	end
	end
end

function HeroSoulLayer:createStar()
	local typeData = cfg.herotype.star[self.hero_data.hero_type]
	local curStar = self.hero_data.star
	self.node_star:removeAllChildren()

	if self.hero_data.star < 10 then
		local star_type = math.floor(self.hero_data.star / 5)
		local star_count

		if self.hero_data.star % 5 == 0 then 
			if self.hero_data.star > 5 then
				star_count = 1
			else 
				star_count = 5
				star_type = 0
			end
		else
			star_count = self.hero_data.star % 5
		end

		local path = string.format("other/star-%d.png",star_type)

		if self.hero_data.star > 10 then star_count = star_count + 1 end

		for i=1,star_count do
			local sp = cc.Sprite:createWithSpriteFrameName(path)
			self.node_star:addChild(sp,star_count-i)
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
			spr_star:setPosition(spr_star_bg:getPosition())
			self.node_star:addChild(spr_star, 10)
		end
	end
end

function HeroSoulLayer:createEquipStar(parent,equip_type)
	local config = cfg.equipmenttype.equip[equip_type]
	local node_star = parent:getChildByName("node_star")
	node_star:removeAllChildren()

	local star_type = math.floor(config.star / 5)
	local star_count

	if config.star % 5 == 0 then 
		if config.star > 5 then
			star_count = 1
		else 
			star_count = 5
			star_type = 0
		end
	else
		star_count = config.star % 5
	end

	local path = string.format("other/star-%d.png",star_type)

	if config.star > 10 then star_count = star_count + 1 end

	local scale = 0.5
	for i=1,star_count do
		local sp = cc.Sprite:createWithSpriteFrameName(path)
		node_star:addChild(sp,star_count-i)
		local margin = 12
		local width = sp:getContentSize().width * scale-- + margin
		local length = (width / 2 * (star_count - 1))
		local offset = (parent:getContentSize().width - length) / 2
		local posX = offset + (width / 2) * (i - 1)
		sp:setPosition(posX,0)
		sp:setScale(scale)
	end

end

function HeroSoulLayer:createSpine()
	if self.hero ~= nil then 
		self.hero:removeFromParent()
		self.hero = nil
	end

	local fashion_id = ex.Player.hero_data.fashion:getWearByID(self.hero_data.hero_id) or 0

	if fashion_id == 0 then
		local skin = ex.Tools:getHeroSkinByStar(self.hero_data.hero_type, self.hero_data.star, self.hero_data.evolve)
		self.hero = require("src.person.Hero"):create("12323", "123213", self.hero_data.hero_type, self.hero_data.level, self.hero_data.star, skin)

	else
		self.hero = require("src.person.Hero"):create("1", "1", 1, 1, 1, fashion_id)
	end
	self.hero:setShadowVisible(false)
    self.hero:setScale(1.5 * 1.3)
    self.hero:setPosition(0, -10)
	self.hero:registerScriptTapHandler(handler(self, self.onTouchHero))
    -- self.menu:addChild(self.hero, -1)
    self.menu_hero:addChild(self.hero)
end

function HeroSoulLayer:getConfig(place,level)
	for i,v in ipairs(cfg.heroequipsoul.heroequipsoul) do
		if v.place == place then
			if v.level == level then
				return v
			end
		end
	end
end

function HeroSoulLayer:checkBtnRedPoint(border_tag,level)
	local max_level = 0
	local redPoint = self.equips[border_tag]:getChildByName("redPoint") 
	for i,v in ipairs(cfg.heroequipsoul.heroequipsoul) do
		if v.place == border_tag then
			max_level = v.level > max_level and v.level or max_level
		end
	end
	if level > max_level then
		redPoint:setVisible(false)
		return
	end
	-- 显示消耗
	local config = self:getConfig(border_tag,level)
	local item_num = 0
	for i=1,2 do
		if ex.Player:getItemNum( config.cost[i].item_type) < config.cost[i].item_num then
		else
			item_num = item_num + 1
		end
	end
	if level > max_level then
		redPoint:setVisible(false)
	else
		redPoint:setVisible(item_num == 2 and true or false)
	end			
end

function HeroSoulLayer:updateLevelSkillInfo()
	if self.border_tag == nil then return end
	self.lbl_soul_level:setString(string.format(ex.Tools:getLang(47139),self.equip[self.border_tag].soul_lv))
	-- 显示技能
	self:isMaxLevel(false)
	local skill_level = {self.equip[self.border_tag].soul_lv,self.equip[self.border_tag].soul_lv + 1}
	local max_level = 0
	for i,v in ipairs(cfg.heroequipsoul.heroequipsoul) do
		if v.place == self.border_tag then
			max_level = v.level > max_level and v.level or max_level
		end
	end
	local vec_skill = {}
	for i,v in ipairs(skill_level) do
		if v == 0 then
			table.insert( vec_skill, 0)
		elseif v == max_level and i == 1 then
			table.insert( vec_skill, self:getConfig(self.border_tag,v).skill)
			self:isMaxLevel(true)
			break
		else
			table.insert( vec_skill, self:getConfig(self.border_tag,v).skill)
		end
	end
	local skill_num = table.nums(vec_skill)
	self.skill_menu:setLocalZOrder(10)
	self.skill_menu:removeAllChildren()
	for i=1,2 do
		if i <= skill_num and skill_level[i] ~= 0 then  
			local btn_skill = UIMenuItemSkill:createWithIcon(vec_skill[i], skill_level[i], false, nil)
			btn_skill:setPosition(self["skill_node_"..i]:getPosition())
			btn_skill:createRich(vec_skill[i])
			btn_skill.lbl_name:setColor(cc.c3b(122,71,45))
			btn_skill:setScale(1.6)
			btn_skill.lbl_name:setPositionY(-22)
			self.skill_menu:addChild(btn_skill)
			btn_skill.skill_index = i
			btn_skill:setEnabled(false)

			if skill_level[i] == max_level and skill_num == 1 then
				btn_skill:setPosition(self.skill_node_3:getPosition())
			end
		end 
	end

	-- 显示消耗
	local config = self:getConfig(self.border_tag, skill_level[skill_num])
	local item_num = 0
	for i=1,2 do
		self["btn_item_"..i]:setNormalImage(cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", config.cost[i].item_type)))
		self["btn_item_"..i].item_type = config.cost[i].item_type
		local str = ""
		str = ex.Player:getItemNum( config.cost[i].item_type) .. "/" .. config.cost[i].item_num
		self["lbl_num_"..i]:setString(str)

		if ex.Player:getItemNum( config.cost[i].item_type) < config.cost[i].item_num then
			self["lbl_num_"..i]:setColor(FONT_RED)
		else
			self["lbl_num_"..i]:setColor(FONT_WHITLE)
			item_num = item_num + 1
		end
	end

end

function HeroSoulLayer:isMaxLevel(bool)
	self.spr_skill_di_bg_4:setVisible(bool)
	self.spr_skill_di_bg_5:setVisible(bool)
	self.spr_skill_di_bg_1:setVisible(not bool)

	local img = self.btn_sure:getNormalImage()
	ex.Tools:setGrayAuto(img,bool)
	self.btn_sure:setEnabled(not bool)

	local btn_lang = bool and 47635 or 6408
	self.btn_sure:setLabelText(ex.Tools:getLang(btn_lang))
end

-----------------------------------------------------------------------------
function HeroSoulLayer:onItemSrc(tag, pSender)
	ex.Tools:onClickItemSrc(pSender.item_type)
end

function HeroSoulLayer:onClickEquip(tag,pSender)
	
	self.border_tag = tag
	if self.equip[tag] ~= nil and self.equip[tag].item_type ~= 0 then
		local items = self.menu_equip:getChildren()
		for k,v in pairs(items) do
			local spr_border = v:getChildByName("spr_border")
			spr_border:setVisible(v:getTag() == tag and true or false)
		end
	end
	self:updateLevelSkillInfo()
end

function HeroSoulLayer:onItemInfo(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

-- 点击英雄动画
function HeroSoulLayer:onTouchHero()
	self.hero:attack()
end

-- 关于按钮
function HeroSoulLayer:onBtnInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(6401), ex.Tools:getLang(6409))
end

-- 附魂
function HeroSoulLayer:onSure(tag, pSender)
	if self.border_tag == nil then
		ex.MessageView:add(ex.Tools:getLang(6410))
		return
	end

	local config = self:getConfig(self.border_tag,self.equip[self.border_tag].soul_lv + 1)
	for i=1,2 do
		local aa = ex.Player:getItemNum( config.cost[i].item_type)
		local bb = config.cost[i].item_num
		if ex.Player:getItemNum( config.cost[i].item_type) < config.cost[i].item_num then
			ex.MessageView:add(ex.Tools:getLang(30503))
			return
		end
	end

	local req = Hero_pb.GReqHeroEquipSoulLvUp()
	req.hero_id = self.hero_data.hero_id
	req.place = self.border_tag
	NetManager:sendMessage(ProtocolID.GReqHeroEquipSoulLvUp, req)

	self.btn_sure:setEnabled(false)

	for i=1,EquipMaxCount do
		self.equips[i]:setEnabled(false)
	end
end

-- 重置附魂
function HeroSoulLayer:onReset(tag, pSender)
	if self.equip == nil or next(self.equip) == nil then
        return
    end 

	if self.equip[self.border_tag].soul_lv <= 0 then
		ex.MessageView:add(ex.Tools:getLang(6413))
		return
	end

	local skill_level = 1
	-- 显示消耗
	local reset_cost = self:getConfig(self.border_tag,skill_level).reset_cost
	local content_str = string.format(ex.Tools:getLang(6411), reset_cost[1].item_type,reset_cost[1].item_num)
    
    ex.ConfirmCtr:openWindow(ex.Tools:getLang(41068), content_str, function()
		local req = Hero_pb.GReqHeroEquipSoulReset()
		req.hero_id = self.hero_data.hero_id
		req.place = self.border_tag
		NetManager:sendMessage(ProtocolID.GReqHeroEquipSoulReset, req)
    end, ex.Tools:getLang(4107), ex.Tools:getLang(4106))

end

-- 技能預覽
function HeroSoulLayer:openRichTextUrl(url)
	require("src.layer.heroinfo.HeroSoulShowCtr"):instance():openWindow(self.border_tag)
end
-----------------------------------------------------------------------------
function HeroSoulCtr:onCreate()
	self:setCCBIPath("ccbi/HeroSoulLayer.ccbi")
	self:setIsSingle(false)
end

function HeroSoulCtr:getLayerClass()
	return HeroSoulLayer
end

function HeroSoulCtr:getHeroSoulLayer()
	return self.layer
end

function HeroSoulCtr:openWindow(type)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
end

return HeroSoulCtr
