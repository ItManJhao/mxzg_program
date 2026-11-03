local HeroTalentLearnCtr = class("HeroTalentLearnCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroTalentLearnLayer = class("HeroTalentLearnLayer", require("src.comp.EventLayerAdaptiveWidth"))

local UIMenuItemSkill = require("src.comp.menu.UIMenuItemSkill")


function HeroTalentLearnLayer:onCreate()
	self:addBlackBackground()

	self.scroll_view:setItemSize(cc.size(120, 120))
	self.scroll_view:setItemOffset(cc.p(0, 20))
	self.scroll_view:setResetOffset(true)
	
	self.lbl_skill_name:setColor(cc.c3b(116, 77, 39))
	self.lbl_skill_desc:setColor(cc.c3b(116, 77, 39))
	self.lbl_cost_text:setColor(cc.c3b(116, 77, 39))
	self.lbl_item_name:setColor(cc.c3b(116, 77, 39))


	self.item = require("src.comp.menu.UIMenuItemBag"):createWithData(0, 0)
	:setPosition(205.0, 120.0)
	:setScale(0.8)
	self.item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
	self.menu:addChild(self.item)
	

	self:addEvent(EVENT.HERO_TALENT_EVENT.UPDATE_ACTIVATE_BAG, handler(self, self.updateLayer))
	-- self:addEvent(EVENT.HERO_TALENT_EVENT.ACTIVATE_DONE, function()
	-- 	HeroTalentLearnCtr:instance():closeWindow()
	-- end)
end

function HeroTalentLearnLayer:updateLayer()
	local type_config = nil
	local hero_data = ex.Player.hero_data:getHeroDataById(self.hero_id)
	if hero_data then
		type_config = cfg.herotype.star[hero_data.hero_type]
	end

	local list = ex.Player.hero_data:getTalentListByLevel(1)

	if type_config ~= nil then
		-- 对数据源进行排序, 领悟-推荐-。。。
		table.sort(list, function(a, b)
			-- 修改数据源, 是否有物品,是否是推荐技能
			a.is_has = ex.Player:getItemNum(a.upgrade_need[1].item_type) > 0
			a.is_recommend = TableEx.findValueFunction(type_config.talent_recommend, function(v) return v == a.skill_type end) ~= nil

			b.is_has = ex.Player:getItemNum(b.upgrade_need[1].item_type) > 0
			b.is_recommend = TableEx.findValueFunction(type_config.talent_recommend, function(v) return v == b.skill_type end) ~= nil

			local compX = a.is_has and 1000000000 or -a.idx
			compX = compX + (a.is_recommend and 1000000 or 0)
			
			local compY = b.is_has and 1000000000 or -b.idx
			compY = compY + (b.is_recommend and 1000000 or 0)
			return compX > compY
		end)
	end

	-- 永远选择第一个物品
	self.select_data = self.select_data or list[1]

	self.scroll_view.createItemFunction = function(data, scale)
		local btn_skill = UIMenuItemSkill:createWithIcon(data.skill_type, 1, false, handler(self, self.onSelectSkill))
		btn_skill.data = data
		btn_skill:removeLevel()
		btn_skill:setNameY(-20)

		if self.select_data and self.select_data.skill_type == data.skill_type then
			btn_skill:setSelected(true)
		end

		-- 判断可以领悟
		if data.is_has then
			btn_skill:setRecommend()
		elseif data.is_recommend then
			btn_skill:setStudy()
		end
		return btn_skill
	end
	self.scroll_view:reloadData(list)

	self:updateActivateSkill()
	self:updateItem()
end

function HeroTalentLearnLayer:updateActivateSkill()
	if self.item_skill then
		self.item_skill:removeFromParent()
		self.item_skill = nil
	end

	if self.select_data == nil then
		return
	end

	self.item_skill = UIMenuItemSkill:createWithIcon(self.select_data.skill_type, 1, false, nil)
	self.item_skill:setPosition(cc.p(110, 630))
	self.item_skill:resetLblName()
	self.item_skill:removeLevel()
	self:addChild(self.item_skill)

	self.lbl_skill_name:setString(ex.Player.hero_data:getSkillName(self.select_data.skill_type, self.select_data.level))
	self.lbl_skill_desc:setString(ex.Player.hero_data:getSkillDescription(self.select_data.skill_type, self.select_data.level))
end

function HeroTalentLearnLayer:updateItem()
	if self.select_data == nil then
		return
	end

	local item_type = self.select_data.upgrade_need[1].item_type
	local item_num = self.select_data.upgrade_need[1].item_num
	local has_num = ex.Player:getItemNum(item_type)

	self.item:refreshData(item_type, item_num)
	self.item:setNumComp(has_num, item_num)
	self.lbl_item_name:setString(ex.Tools:getLang(cfg.item.item[item_type].name))
end

function HeroTalentLearnLayer:onSelectSkill(tag, pSender)
	self.select_data = pSender.data
	print("need item_type", self.select_data.upgrade_need[1].item_type)
	ex.EventManager:fire(EVENT.HERO_TALENT_EVENT.UPDATE_ACTIVATE_BAG)
end

-----------------------------------------------------------------------------
function HeroTalentLearnCtr:onCreate()
	self:setCCBIPath("ccbi/HeroTalentLearnLayer.ccbi")
	self:setIsSingle(false)
end

function HeroTalentLearnCtr:getLayerClass()
	return HeroTalentLearnLayer
end

function HeroTalentLearnCtr:getHeroTalentLearnLayer()
	return self.layer
end

function HeroTalentLearnCtr:openWindow(hero_id, slot)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(hero_id, slot)
end

function HeroTalentLearnCtr:initData(hero_id, slot)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))
	self.layer.hero_id = hero_id
	self.layer.slot = slot

	-- 保存的是配置表数据
	self.layer.select_data = nil

	-- -- 计算推荐的技能
	-- local hero_data = ex.Player.hero_data:getHeroDataById(hero_id)
	-- if hero_data then
	-- 	local is_duplicate = false
	-- 	local type_config = cfg.herotype.star[hero_data.hero_type]
	-- 	self.layer.select_data = TableEx.findValueFunction(cfg.talent.talent, function(value)
	-- 		return value.skill_type == type_config.talent_recommend[1] and value.level == 1 and is_duplicate ~= true
	-- 	end)
	-- end

	-- self.layer.select_data = self.layer.select_data or cfg.talent.talent[1]

	self.layer:updateLayer()
end

function HeroTalentLearnCtr:onConfirm()
	local hero_id = self.layer.hero_id

	if self.layer.select_data == nil then
		return
	end

	if ex.Tools:showEnoughTipList(self.layer.select_data.upgrade_need) then
		cfg.funcopen.main_shop.open(SHOP_TYPE.TALENT)
		self:closeWindow()
		return
	end

	if ex.Player.hero_data:isTalentStudy(hero_id, self.layer.select_data.skill_type) then
		ex.MessageView:add(ex.Tools:getLang(41304))
		return
	end

	-- 发送消息
	local req_learn = HeroTalent_pb.GReqHeroTalentLearn()
	req_learn.hero_id = hero_id
	req_learn.skill_id = self.layer.select_data.skill_type
	req_learn.slot = self.layer.slot
	NetManager:sendMessage(ProtocolID.GReqHeroTalentLearn, req_learn)

	self:closeWindow()
end

return HeroTalentLearnCtr
