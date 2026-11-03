local HeroHexagramCtr = class("HeroHexagramCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local HeroHexagramLayer = class("HeroHexagramLayer", require("src.layer.ui.UI_HeroHexagramLayer"))
local HeroHexagramSkillCell = require("src.layer.herohexagram.HeroHexagramSkillCell")

------------------------------------------------
function HeroHexagramLayer:onCreate()
	self.super.onCreate(self)
	self:setName("HeroHexagramLayer")

	self:addBlackBackground()

	-- 製作小石頭浮動動畫
	self.spr_rock_1:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.MoveBy:create(2.5, cc.p(0, 20)), cc.MoveBy:create(2.1, cc.p(0, -20)))))
	self.spr_rock_2:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.MoveBy:create(2.4, cc.p(0, 20)), cc.MoveBy:create(2.4, cc.p(0, -20)))))
	self.spr_rock_3:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.MoveBy:create(2.4, cc.p(0, 20)), cc.MoveBy:create(2.1, cc.p(0, -20)))))

    self.scroll_view.createItemFunction = function(data, scale)
		local item = HeroHexagramSkillCell:create()
		item:reloadData(data)
		return item
	end

	self.lbl_title:setPosition(-135, 160)
	self.lbl_title:setAnchorPoint(cc.p(1, 0.5))
end

-----------------------------------------------
function HeroHexagramCtr:loadLayer()
    local tmp_layer = HeroHexagramLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function HeroHexagramCtr:onCreate()
	self:setIsSingle(false)
end

function HeroHexagramCtr:openWindow(hero_id)
	if self:isOpened() then
		return
	end

	self.hero_id = hero_id

	self:loadLayer()
	self:open()
    self:initData()
end

function HeroHexagramCtr:initData()
	self.layer.btn_reset:registerScriptTapHandler(handler(self, self.onReset))
	self.layer.btn_upgrade:registerScriptTapHandler(handler(self, self.onUpgrade))
	self.layer.btn_info:registerScriptTapHandler(handler(self, self.onInfo))
	self.layer.btn_left:registerScriptTapHandler(handler(self, self.onLeft))
	self.layer.btn_right:registerScriptTapHandler(handler(self, self.onRight))
	for i=1,6 do
		self.layer["btn_tab_"..i]:registerScriptTapHandler(handler(self, self.onTab))
	end
	self.layer.btn_res_need_1:registerScriptTapHandler(handler(self, self.onItemInfo))
	self.layer.btn_res_need_2:registerScriptTapHandler(handler(self, self.onItemInfo))

    self.layer:addEvent(EVENT.HERO_HEXAGRAM_EVENT.UPDATE, handler(self, self.updateLayer))
    self.layer:addEvent(EVENT.HERO_HEXAGRAM_EVENT.UPGRADE, handler(self, self.updateLayer))
    self.layer:addEvent(EVENT.HERO_HEXAGRAM_EVENT.RESET, handler(self, self.updateLayer))
	
	-- 默认选中当前国战类型的六芒星
	self.hexagram_type = -1
	self:onTab(ctr.country_war.data.type > 0 and ctr.country_war.data.type or 1)
end

function HeroHexagramCtr:updateLayer()
	self.hexagram_data = ex.Player.hero_data.hexagram:getHexagramData(self.hero_id, self.hexagram_type)
	if (self.hexagram_data == nil or table.nums(self.hexagram_data) <= 0) then
		self.hexagram_data = {hero_id = self.hero_id, type = self.hexagram_type, level = 0}
	end

	self.layer.lbl_name:setString(ex.Tools:getLang(57000 + self.hexagram_type).."  Lv."..self.hexagram_data.level)

	-- 圓盤特效
	self.layer.node_effect:removeAllChildren()
	ex.EffectFactory:createEffectWithNodeByNameAsyn("hero_hexagram_effect_"..self.hexagram_type, self.layer.node_effect, cc.p(0, 0), 1)
	self.layer.node_effect:setScale(1.67)

	local config = ex.Player.hero_data.hexagram:getHexagramConfig(self.hexagram_data.type, self.hexagram_data.level)
	local config_next = ex.Player.hero_data.hexagram:getHexagramConfig(self.hexagram_data.type, self.hexagram_data.level + 1)

	-- 更新屬性顯示
	for i,v in ipairs(config.attr) do
		self.layer["spr_attr_"..i]:setSpriteFrame("hero-info-2/spr-attribute-"..v.attr..".png")
		self.layer["lbl_attr_"..i]:setString(ex.Tools:getAttrText(v.attr, v.value))
		ex.Tools:setLimitWidth(self.layer["lbl_attr_"..i],200)
		if config_next ~= nil and config_next.attr[i].value ~= v.value then
			self.layer["lbl_attr_extra_"..i]:setVisible(true)
			self.layer["lbl_attr_extra_"..i]:setPositionX(self.layer["lbl_attr_"..i]:getPositionX() + self.layer["lbl_attr_"..i]:getContentSize().width + 10)
			self.layer["lbl_attr_extra_"..i]:setString("+"..ex.Tools:getAttrValue(config_next.attr[i].attr, config_next.attr[i].value))
		else
			self.layer["lbl_attr_extra_"..i]:setVisible(false)
		end
	end

	-- 更新技能顯示
	local skill_data = clone(config.skill2)
	for i,v in ipairs(config.skill) do
		table.insert(skill_data, v)
	end
	for i,v in ipairs(skill_data) do
		if v.lv <= 0 then
			v.need_level = ex.Player.hero_data.hexagram:getHexagramSkillLevelNeed(self.hexagram_type, v.id)
			v.hexagram_level = self.hexagram_data.level
		end
		v.is_effect = (ctr.country_war.data.type == self.hexagram_type)
	end
    self.layer.scroll_view:reloadData(skill_data)

	-- 共鸣魔方中的英雄六芒星无法操作
	if ex.Player.hero_data.magicCube:isHeroInCubeList(self.hero_id) then
		self.layer.node_upgrade:setVisible(false)
		self.layer.lbl_tip:setVisible(true)
	else
		self.layer.node_upgrade:setVisible(true)
		self.layer.lbl_tip:setVisible(false)

		-- 更新资源消耗及突破状态
		if table.nums(config.cost) > 0 then
			self.layer.lbl_title:setVisible(true)
			self.layer.node_res_need_1:setVisible(true)
			self.layer.node_res_need_2:setVisible(true)
			
			self.layer.btn_upgrade:setLabelText(ex.Tools:getLang(74508))

			self.layer.btn_res_need_1.item_type = config.cost[1].item_type
			self.layer.btn_res_need_1:setNormalImage(cc.Sprite:createWithSpriteFrameName("backpack/"..config.cost[1].item_type..".png"))
			self.layer.lbl_res_need_1:setString(ex.Player:getItemNum(config.cost[1].item_type).."/"..config.cost[1].item_num)
			self.layer.lbl_res_need_1:setColor(ex.Player:getItemNum(config.cost[1].item_type) >= config.cost[1].item_num and cc.c3b(254, 252, 224) or cc.c3b(233, 91, 72))
			
			self.layer.btn_res_need_2.item_type = config.cost[2].item_type
			self.layer.btn_res_need_2:setNormalImage(cc.Sprite:createWithSpriteFrameName("backpack/"..config.cost[2].item_type..".png"))
			self.layer.lbl_res_need_2:setString(ex.Player:getItemNum(config.cost[2].item_type).."/"..config.cost[2].item_num)
			self.layer.lbl_res_need_2:setColor(ex.Player:getItemNum(config.cost[2].item_type) >= config.cost[2].item_num and cc.c3b(254, 252, 224) or cc.c3b(233, 91, 72))
		else
			self.layer.lbl_title:setVisible(false)
			self.layer.node_res_need_1:setVisible(false)
			self.layer.node_res_need_2:setVisible(false)
			
			self.layer.btn_upgrade:setLabelText(ex.Tools:getLang(74509))
		end
	end

	local can_upgrade = ex.Player.hero_data.hexagram:canUpgrade(self.hero_id, self.hexagram_type) <= 0 and 
						self.hexagram_type == ctr.country_war.data.type and 
						ctr.country_war.data:getStage() == COUNTRY_WAR_STATE.BATTLE and
						table.nums(config.cost) > 0
	ex.Tools:setGrayAuto(self.layer.btn_reset:getNormalImage(), self.hexagram_data.level <= 0)
	ex.Tools:setGrayAuto(self.layer.btn_upgrade:getNormalImage(), can_upgrade == false)

	ex.Tools:addRedPoint(self.layer.btn_upgrade, ctr.country_war.data.type == self.hexagram_type and ex.Player.hero_data.hexagram:checkReddot(self.hero_id), cc.p(0.9,0.9))
end

function HeroHexagramCtr:onItemInfo(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

function HeroHexagramCtr:onInfo()
	ex.InfoCtr:openWindow(ex.Tools:getLang(57025), ex.Tools:getLang(57026))
end

function HeroHexagramCtr:onLeft()
	self:onTab((self.hexagram_type - 1 + 5) % 6 + 1)
end

function HeroHexagramCtr:onRight()
	self:onTab((self.hexagram_type - 1 + 1) % 6 + 1)
end

function HeroHexagramCtr:onTab(hexagram_type)
	if self.hexagram_type == hexagram_type then
		return
	end

	local btn_selected = self.layer["btn_tab_"..hexagram_type]
	self.layer.spr_select:setPosition(btn_selected:getPositionX() + btn_selected:getParent():getPositionX() - btn_selected:getParent():getContentSize().width / 2,
									  btn_selected:getPositionY() + btn_selected:getParent():getPositionY() - btn_selected:getParent():getContentSize().height / 2)

	self.hexagram_type = hexagram_type

	self:updateLayer()
end

function HeroHexagramCtr:onReset()
	if self.hexagram_data.level <= 0 then
		ex.MessageView:add(ex.Tools:getLang(57021))
		return
	end

	require("src.layer.herohexagram.HeroHexagramResetCtr"):instance():openWindow(self.hero_id, self.hexagram_type)
end

function HeroHexagramCtr:onUpgrade()
	if ctr.country_war.data.type ~= self.hexagram_type or ctr.country_war.data:getStage() ~= COUNTRY_WAR_STATE.BATTLE then
		ex.MessageView:add(ex.Tools:getLang(57027))
		return
	end

	-- 等级达到上限则不可强化
	if self.hexagram_data.level > 999 then
		ex.MessageView:add(ex.Tools:getLang(57022))
		return
	end

	-- 如果是升級則直接發送升級協議，否則打開強化界面
	-- 1：等级不大于当前等级；2：等级已达上限；3：材料不足
	local flag = ex.Player.hero_data.hexagram:upgrade(self.hero_id, self.hexagram_type)
	if flag > 0 then
		if flag == 2 then
			ex.MessageView:add(ex.Tools:getLang(41243))
		elseif flag == 3 then
			-- ex.MessageView:add(ex.Tools:getLang(57024))
			local config = ex.Player.hero_data.hexagram:getHexagramConfig(self.hexagram_type, (self.hexagram_data and self.hexagram_data.level or 0))
			for i,v in ipairs(config.cost) do
				if ex.Player:getItemNum(v.item_type) < v.item_num then
					ex.Tools:showEnoughTip(v.item_type, true)
					break
				end
			end
		end
		return
	end
end

return HeroHexagramCtr
