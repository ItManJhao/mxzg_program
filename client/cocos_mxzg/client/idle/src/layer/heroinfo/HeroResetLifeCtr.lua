--[[
* @Description: 英雄重生
* @Author: 周向阳
* @Date: 2020-03-6 15:42:00
* ]]

local HeroResetLifeCtr = class("HeroResetLifeCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroResetLifeLayer = class("HeroResetLifeLayer", require("src.layer.ui.UI_HeroResetLifeLayer"))
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")
------------------------------------------------
local TYPE_LAYER ={
	LEVEL_RESET = 1 ,
	STAR_RESET = 2 ,
}

function HeroResetLifeLayer:onCreate()
	self.super.onCreate(self)
	self:setName("HeroResetLifeLayer")

	self.cut_layer = 1
	self.btn_lv_reset:setChecked(true)

	self.lbl_show_1 = require("src.comp.RichTextEx"):create()
	:setFontSize(20)
	:setFontColor("#784008")
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setAnchorTextShadow(true)
	:setWrapMode(1)
	self.lbl_show_node:addChild(self.lbl_show_1)
	self.lbl_show_1:setPosition(0, 10)

	self.lbl_show_2 = require("src.comp.RichTextEx"):create()
	:setFontSize(20)
	:setFontColor("#784008")
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setAnchorTextShadow(true)
	:setWrapMode(1)
	self.lbl_show_node:addChild(self.lbl_show_2)
	self.lbl_show_2:setXmlTextLua(ex.Tools:getLang(70509))
	self.lbl_show_2:setPosition(0, -20)

	ex.Tools:setLimitWidth(self.satr_lbl_res_need_1, 80)

end

function HeroResetLifeLayer:initData(data)
	self.data = data
	if self.data.star < 6 then
		self.btn_star_reset:setVisible(false)
		self.btn_lv_reset:setPositionX(self.s:getContentSize().width / 2)
	end
	if self.data.level <= 1 then
		self.btn_lv_reset:setVisible(false)
		self.btn_star_reset:setChecked(true)
		self.cut_layer = 2
		self.btn_star_reset:setPositionX(self.s:getContentSize().width / 2)
	end
	self:addEvent(EVENT.HERO_INFO_EVENT.UPDATA_HREO_RESET_NUM,handler(self,self.updataLevelLblShow))
	self:addEvent(EVENT.HERO_INFO_EVENT.EXIT_HREO_STAR_RESET,handler(self,self.onExitReset))
	self:updataLevelLblShow()
	self:updataLayer()
end

function HeroResetLifeLayer:onExitReset()
	ex.MainSceneCtr:changeLayer(MainSceneType.HERO_LAYER)
	self:onClose()
end

function HeroResetLifeLayer:updataLevelLblShow()
	self.btn_level:setVisible(false)
	self.btn_star:setVisible(false)
	if self.cut_layer == TYPE_LAYER.LEVEL_RESET then
		self.btn_level:setVisible(true)
		self.lbl_resets_num:setVisible(false)
		self.node_res_need_1:setVisible(false)
		local config = cfg.system.hero_level_reset_cost
		local max_num = cfg.system.hero_level_reset_daily_free_times
		local num = ex.Player.hero_data.hero_reset_num
		if num and num < 3 then
			self.lbl_resets_num:setVisible(true)
			num = 0
			if ex.Player.hero_data.hero_reset_num < 3 then
				num = ex.Player.hero_data.hero_reset_num
			end
			self.lbl_resets_num:setString(string.format(ex.Tools:getLang(70510), max_num - num))
		else
			self.lbl_resets_num:setVisible(false)
			self.node_res_need_1:setVisible(true)
			
			ex.Tools:setSpriteFrame(self.spr_res_need_1, string.format("backpack/%s.png", config[1].item_type))
			self.lbl_res_need_1:setString(config[1].item_num)
		end
		if self.data.level <= 1 or ( num and max_num - num <= 0 and ex.Player:getItemNum(config[1].item_type) < config[1].item_num )  then
			self.btn_level:setEnabled(false)
			ex.Tools:setGrayAuto(self.btn_level:getNormalImage(), true)	
		end
	else
		self.btn_star:setVisible(true)
		local item_data = self:getStarResetItemNeed()
		if not item_data then
			return
		end
		ex.Tools:setSpriteFrame(self.star_spr_res_need_1, string.format("backpack/%s.png", item_data.cost[1].item_type))
		self.satr_lbl_res_need_1:setString(string.format(ex.Player:getItemNum(item_data.cost[1].item_type).."/"..item_data.cost[1].item_num))
		if ex.Player:getItemNum(item_data.cost[1].item_type) < item_data.cost[1].item_num then
			self.satr_lbl_res_need_1:setColor(cc.RED)
			self.btn_star:setEnabled(false)
			ex.Tools:setGrayAuto(self.btn_star:getNormalImage(), true)	
		end
	end
end

function HeroResetLifeLayer:updataLayer()
	self.star_item_need_node:setVisible(false)
	local hero_data = self.data	
	self.spr_reset_item_node:removeAllChildren()
	self.spr_reseted_item_node:removeAllChildren()
	self.spr_show_item_node:removeAllChildren()
	self.reward_scroll_view:removeAllChildren()
	--当前本体
	local not_reset_hero = UIMenuItemHero:createWithData(hero_data.hero_id, hero_data.hero_type, hero_data.elem, hero_data.level, hero_data.star)
	self.spr_reset_item_node:addChild(not_reset_hero)

	if self.cut_layer == TYPE_LAYER.LEVEL_RESET then	
		self.lbl_show_1:setXmlTextLua(string.format( ex.Tools:getLang(70508), ex.Tools:getLang(hero_data.hero_type)))
		self.lbl_show_2:setXmlTextLua(ex.Tools:getLang(70509))
		self.spr_reseted_item_node:addChild(self:getHeroLevelReseted())
		self.spr_show_item_node:addChild(self:getHeroLevelReseted())
		local data = self:getLvResetItem(hero_data)

		self.reward_scroll_view.createItemFunction = function(item_data, scale, index, pos)
			local item = nil
			if item_data ~= nil then
				item = ex.Tools:createBackpackItem(item_data.item_type,item_data.item_num)
				item:setScale(0.8)
				item:registerScriptTapHandler(handler(self, self.onItem))
			end
			return item
		end
		self.reward_scroll_view:reloadData(data)  
	else
		self.lbl_resets_num:setVisible(false)
		self.node_res_need_1:setVisible(false)
		self.star_item_need_node:setVisible(true)
		self.lbl_show_1:setXmlTextLua(string.format( ex.Tools:getLang(70512), ex.Tools:getLang(hero_data.hero_type)))
		self.lbl_show_2:setXmlTextLua(ex.Tools:getLang(70513))
		self.spr_reseted_item_node:addChild(self:getHeroStarReseted(cfg.herotype.star[hero_data.hero_type].star))
		self.spr_show_item_node:addChild(self:getHeroStarReseted(cfg.herotype.star[hero_data.hero_type].star))
		local star_reset_data = self:getStarResetItem(hero_data)	

		self.reward_scroll_view.createItemFunction = function(item_data, scale, index, pos)
			local item = nil
			if item_data ~= nil then
				item = ex.Tools:createBackpackItem(item_data.item_type,item_data.item_num)
				item:setScale(0.8)
				item:registerScriptTapHandler(handler(self, self.onItem))
			end
			return item
		end	
		self.reward_scroll_view:reloadData(star_reset_data)  
	end

end

--等级重置所需返还的物品
function HeroResetLifeLayer:getLvResetItem(hero_data)
	local max_grade = ex.Player.hero_data:getHeroStageByLevel(hero_data.level)
	local item_need_data = {}
	local exp = {}
	local soul = {}
	local gold = {}
	exp.item_type = 900101				--经验
	exp.item_num = 0
	soul.item_type = 900102				--进阶石
	soul.item_num = 0
	gold.item_type = 900001				--金币
	gold.item_num = 0
	table.insert( item_need_data, gold)
	table.insert( item_need_data, exp)
	table.insert( item_need_data, soul)
	

	local num = table.nums(cfg.heroupgrade.grade)
	for i=0,num-1 do
		local v = cfg.heroupgrade.grade[i]
		if max_grade > v.grade then
			gold.item_num = gold.item_num + v.gold
			soul.item_num = soul.item_num + v.soul
		end
	end

	for i,v in ipairs(cfg.herolevel.level) do
		if hero_data.level > v.level then
			exp.item_num = exp.item_num + v.exp_need
			gold.item_num = gold.item_num + v.gold_need
		end
	end
	for i = #item_need_data, 1, -1 do	
		if item_need_data[i].item_num == 0 then
			table.remove( item_need_data, i )
		end
	end
	return item_need_data
end

--星级重置所需返还的物品
function HeroResetLifeLayer:getStarResetItem(hero_data)
	local satr_reset_item_data = self:getLvResetItem(hero_data)
	local star_reset_reback_elem_chip = {}
	local star_reset_reback_hero_chip = {}
	

	local star_reset_data = self:getStarResetItemNeed()
	if not star_reset_data then
		return
	end

	star_reset_reback_elem_chip.item_type = star_reset_data.reback_elem_chip[1].item_type				--对应元素本体碎片
	star_reset_reback_elem_chip.item_num = star_reset_data.reback_elem_chip[1].item_num	

	star_reset_reback_hero_chip.item_type = star_reset_data.reback_hero_chip[1].item_type					--英雄本体碎片
	star_reset_reback_hero_chip.item_num = star_reset_data.reback_hero_chip[1].item_num

	table.insert( satr_reset_item_data, star_reset_reback_elem_chip)
	table.insert( satr_reset_item_data, star_reset_reback_hero_chip)

	for i = #satr_reset_item_data, 1, -1 do	
		if satr_reset_item_data[i].item_num == 0 then
			table.remove( satr_reset_item_data, i )
		end
	end

	
	return satr_reset_item_data
end

function HeroResetLifeLayer:onChangeLayer(tag)
	if self.cut_layer == tag then
		return
	 end
	 self.cut_layer = tag
	 self:updataLevelLblShow()
	 self:updataLayer()
end

--等级
function HeroResetLifeLayer:onLevelConfirm()
	local req = Hero_pb.GReqHeroLevelReset()
	req.hero_id = self.data.hero_id
	NetManager:sendMessage(ProtocolID.GReqHeroLevelReset, req)
	NetManager:sendMessage(ProtocolID.GReqHeroLevelResetTimes)
	
end

--星级
function HeroResetLifeLayer:onStarConfirm()
	local req = Hero_pb.GReqHeroReborn()
    req.hero_id = self.data.hero_id
    NetManager:sendMessage(ProtocolID.GReqHeroReborn, req)

end

--等级重置后的英雄
function HeroResetLifeLayer:getHeroLevelReseted()
	return	UIMenuItemHero:createWithData(self.data.hero_id, self.data.hero_type, self.data.elem, cfg.herolevel.level[1].level, self.data.star)
end
--星级重置后的英雄
function HeroResetLifeLayer:getHeroStarReseted(reseted_star)
	return	UIMenuItemHero:createWithData(self.data.hero_id, self.data.hero_type, self.data.elem, cfg.herolevel.level[1].level, reseted_star)
end

function HeroResetLifeLayer:onItem(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

function HeroResetLifeLayer:onAddItem()
	local item_data = self:getStarResetItemNeed()
	require("src.layer.BackpackSrcCtr"):instance():openWindow(item_data.cost[1].item_type)
end

function HeroResetLifeLayer:getStarResetItemNeed()
	for k,v in pairs(cfg.heroreborn.heroreborn) do
		if self.data.hero_type == v.hero and v.star <= 6 and self.data.star == v.star then 
			return clone(v)	
		end 
	end
end

-----------------------------------------------
function HeroResetLifeCtr:loadLayer()
	local tmp_layer = HeroResetLifeLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function HeroResetLifeCtr:onCreate()
	self:setIsSingle(false)
end

function HeroResetLifeCtr:openWindow(hero_data)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
    self.layer:initData(hero_data)
end

return HeroResetLifeCtr
