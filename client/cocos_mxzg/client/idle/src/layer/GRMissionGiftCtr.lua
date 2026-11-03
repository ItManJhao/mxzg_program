local GRMissionGiftCtr = class("GRMissionGiftCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local GRMissionGiftLayer = class("GRMissionGiftLayer", require("src.comp.EventLayerAdaptiveWidthFull"))

local GRMissionGiftPageLayer = class("GRMissionGiftPageLayer", require("src.comp.LuaLayerBase"))

local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")
local ExTimer = require("src.ex.ExTimer")

function GRMissionGiftPageLayer:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
	
	self:setIgnoreAnchorPointForPosition(false)
	self:setAnchorPoint(cc.p(0.5, 0))
end

function GRMissionGiftPageLayer:initData(data)
	self.data = data
	self.btn_buy.data = data
	self.config_buy_gem = cfg.buygem.buygem[data.idx]
	self.config_relic = cfg.promotionlimitedsetgodrelic.promotionlimitedsetgodrelic[data.idx]

	self.lbl_tip:setString(ex.Tools:getLang(self.config_relic.description_lang))
	local is_first = true
	local index = 0
	local discount = self.config_relic.value
	for i=1,4 do
		local cur_num = math.floor(discount / (math.pow(10, 4 - i)))
		discount = discount - cur_num * (math.pow(10, 4 - i))
		if cur_num > 0 or is_first == false then
			is_first = false
			local spr_num = cc.Sprite:createWithSpriteFrameName("god-relic/"..cur_num..".png")
			spr_num:setPosition(index * 42, 0)
			self.node_discount:addChild(spr_num)

			index = index + 1
		end
	end

	local spr_num = cc.Sprite:createWithSpriteFrameName("god-relic/%.png")
	spr_num:setPosition(index * 42 + 10, 0)
	self.node_discount:addChild(spr_num)

	self.lbl_limit:setString(ex.Tools:getLang(73503)..data.num)
	self.btn_buy:setLabelText(""..(self.config_buy_gem.rmb / 100)..ex.Tools:getLang(47224))

	if data.num <= 0 then
		ex.Tools:setGray(self.btn_buy:getNormalImage())
		self.btn_buy:setEnabled(false)
	end

	local total_reward_num = #self.config_buy_gem.item
	for i,v in ipairs(self.config_buy_gem.item) do
		local item = UIMenuItemBackpack:createWithData(v.item_type, v.item_num)
		item:registerScriptTapHandler(handler(self, self.onItemInfo))
		item:setScale(0.75)
		item:setPosition((item:getContentSize().width * 0.75 + 5) * (i - 0.5 - total_reward_num / 2), 40)
		self.menu_reward:addChild(item)
	end
end

function GRMissionGiftPageLayer:onItemInfo(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

-----------------------------------------------------------------------------
function GRMissionGiftLayer:onCreate()
	self:addBlackBackground()

    self.timer = ExTimer:new():bind(self):run(handler(self, self.updateCDTime), 1.0)
end

function GRMissionGiftLayer:updateCDTime()
	if self.cur_page_layer == nil then
		return
	end

	local left_time = self.cur_page_layer.data.last_time - ex.Game:getServerTime()
	if left_time < 0 then left_time = 0 end
	self.cur_page_layer.lbl_cd:setString(string.format("%02d:%02d:%02d", math.floor(left_time / 3600), math.floor(left_time % 3600 / 60), math.floor(left_time % 60)))
end

function GRMissionGiftLayer:initSpot(num)
	local width = self.btn_right:getPositionX() - self.btn_left:getPositionX()

	self.node_spot:removeAllChildren()

	if num <= 1 then
		self.btn_left:setVisible(false)
		self.btn_right:setVisible(false)
		return
	end
	self.btn_left:setVisible(true)
	self.btn_right:setVisible(true)

	for i=1,num do
		local spr_spot = cc.Sprite:createWithSpriteFrameName("god-relic/spr-spot-1.png")
		spr_spot:setTag(i)
		spr_spot:setPosition((width / num) * (i - 0.5) + self.btn_left:getPositionX(), 0)
		self.node_spot:addChild(spr_spot)
	end
end

function GRMissionGiftLayer:setSpotSelected(idx)
	local vec_child = self.node_spot:getChildren()
	for i,v in ipairs(vec_child) do
		if v:getTag() == idx then
			-- v:setSpriteFrame("god-relic/spr-spot-2.png")
			ex.Tools:setSpriteFrame(v, "god-relic/spr-spot-2.png")
		else
			-- v:setSpriteFrame("god-relic/spr-spot-1.png")
			ex.Tools:setSpriteFrame(v, "god-relic/spr-spot-1.png")
		end
	end
end

-----------------------------------------------------------------------------
function GRMissionGiftCtr:onCreate()
	self:setCCBIPath("ccbi/GRMissionGiftLayer.ccbi")
	self:setIsSingle(false)
end

function GRMissionGiftCtr:getLayerClass()
	return GRMissionGiftLayer
end

function GRMissionGiftCtr:getInfoLayer()
	return self.layer
end

function GRMissionGiftCtr:openWindow(vec_gift, is_show_new_page)
	if self:isOpened() then
		return
	end

	if #vec_gift <= 0 then
		return
	end

	self.vec_gift = vec_gift
	
	self:loadLayer()
	self:open()
	self:initData(is_show_new_page)
end

function GRMissionGiftCtr:initData(is_show_new_page)
    self.layer.btn_left:registerScriptTapHandler(handler(self, self.onLeft))
    self.layer.btn_right:registerScriptTapHandler(handler(self, self.onRight))

	-- 添加序号
	for i,v in ipairs(self.vec_gift) do
		v.page = i
	end

	-- 初始化点阵
	self.layer:initSpot(#self.vec_gift)

	-- 创建初始层
	self.cur_page = 1
	local tmp_idx = 0
	if is_show_new_page ~= nil and is_show_new_page == true then
		for i,v in ipairs(self.vec_gift) do
			local config_relic = cfg.promotionlimitedsetgodrelic.promotionlimitedsetgodrelic[v.idx]
			if config_relic.god_relic_id > tmp_idx then
				tmp_idx = config_relic.god_relic_id
				self.cur_page = v.page
			end
		end
	end

	self:changeLayer(self.cur_page)
end

function GRMissionGiftCtr:changeLayer(page)
	local data_gift = self.vec_gift[page]
	if data_gift == nil or self.layer == nil then
		return
	end

	local dir = (self.cur_page > page) and 1 or -1
	if page == 1 then
		dir = 1
	elseif page == #self.vec_gift then
		dir = -1
	end
	-- 如果有当前层，则播放动画，并移除该层
	if self.layer.cur_page_layer ~= nil then
		local tmp_layer = self.layer.cur_page_layer
		self.layer.cur_page_layer = nil
		tmp_layer:stopAllActions()
		tmp_layer:runAction(cc.Sequence:create(cc.MoveBy:create(0.2, cc.p(ex.p.width * dir, 0)),
														 cc.CallFunc:create(function()
															tmp_layer:removeFromParent()
															tmp_layer = nil
														 end),
														 nil))
	end

	-- 创建新的礼包层
	local is_run_action = (self.cur_page == page)
	self.layer.cur_page_layer = GRMissionGiftPageLayer:createWithCCBIFile("ccbi/GRMissionGiftPageLayer.ccbi")
	self.layer.cur_page_layer:initData(data_gift)
	self.layer.cur_page_layer:setAnchorPoint(cc.p(0.5, 0))
	self.layer.cur_page_layer:setPosition(self.layer:getContentSize().width / 2, 0)
	self.layer:addChild(self.layer.cur_page_layer, -1)

    self.layer.cur_page_layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.cur_page_layer.btn_buy:registerScriptTapHandler(handler(self, self.onBuy))

	if self.cur_page ~= page then
		self.layer.cur_page_layer:setPositionX(self.layer.cur_page_layer:getPositionX() + ex.p.width * dir * -1)

		self.layer.cur_page_layer:runAction(cc.MoveTo:create(0.2, cc.p(self.layer:getContentSize().width / 2, 0)))
	end

	self.cur_page = page
	self.layer:setSpotSelected(self.cur_page)
	self.layer:updateCDTime()
end

function GRMissionGiftCtr:onLeft()
	if #self.vec_gift <= 1 then
		return
	end
	if self.cur_page <= 1 then
		self:changeLayer(#self.vec_gift)
		return
	end
	self:changeLayer(self.cur_page - 1)
end

function GRMissionGiftCtr:onRight()
	if #self.vec_gift <= 1 then
		return
	end
	if self.cur_page >= #self.vec_gift then
		self:changeLayer(1)
		return
	end
	self:changeLayer(self.cur_page + 1)
end

function GRMissionGiftCtr:onBuy(tag, pSender)
	local config_relic = cfg.promotionlimitedsetgodrelic.promotionlimitedsetgodrelic[pSender.data.idx]
	if pSender.data.num <= 0 then
		return
	end
	
	if pSender.data.last_time < ex.Game:getServerTime() then
        ex.MessageView:add(ex.Tools:getLang(47740))
        return
	end

	pSender.data.num = pSender.data.num - 1
	self.layer.cur_page_layer:initData(pSender.data)
	
	-- 拉起支付页面
	ex.Player:pay(pSender.data.idx)
end

return GRMissionGiftCtr
