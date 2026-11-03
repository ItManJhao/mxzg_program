local GrowUpGiftCell = class("GrowUpGiftCell", require("src.comp.EventLayer"))

function GrowUpGiftCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	self.btn_buy:registerScriptTapHandler(handler(self, self.onBuy))

	self:addFont()
end

function GrowUpGiftCell:addFont()
	local lbl_buy = cc.Label:createWithTTF(ex.Tools:getLang(47120), FONT_DEFAULT_NAME_BOLD, 18)
	self.btn_buy:addChild(lbl_buy)
	lbl_buy:enableOutline(FONT_BROWN, 1)
	lbl_buy:setPosition(self.btn_buy:getContentSize().width/2,self.btn_buy:getContentSize().height/2)

	self.rich_text = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(24)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setAnchorPoint(cc.p(0,0.5))
	self:addChild(self.rich_text)
	self.rich_text:setPosition(30,self.lbl_count:getPositionY())
	self.rich_text:setXmlTextLua(ex.Tools:getLang(41119))
-- <font color='#794730'>累计充值<font color='#1f9317'>6</font>元权益</font>
end

function GrowUpGiftCell:reset(data)
	self.data = data
	local cost = data.pack_cost[1]
	self.spr_soul_need:setSpriteFrame(string.format("backpack/%d.png", cost.item_type))
	self.lbl_soul_need:setString(cost.item_num)

	local conf = cfg.growthgift.vip[data.idx]
	local str = string.format(ex.Tools:getLang(conf.lan),conf.need_recharge / 100)
	self.rich_text:setXmlTextLua(str)

	local charge = ex.Player.total_charge
	local vip_cfg = cfg.growthgift.vip[data.idx]

	str = string.format("(%s/%s)",charge / 100,vip_cfg.need_recharge / 100)
	self.lbl_count:setString(str)

	self.scroll_view:getContainer():removeAllChildren()
	local menu = cpp.UIMenu:create()
    :setIsTouchInsideNode(self.scroll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    :setName("menu_backpack")
    self.scroll_view:addChild(menu)

	local buy_items = self.data.gem_pack

	local size = ex.Tools:createBackpackItem(buy_items[1].item_type, buy_items[1].item_num):getContentSize()
	local beginX = size.width * 0.8 / 2
	local posY = size.height * 0.8 / 2
	local margin = 10


	for i,v in ipairs(buy_items) do
		local posX = beginX + (i - 1) * size.width * 0.8 + (i - 1) * margin
		local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
		item:setScale(0.8)
		item:setPosition(posX,posY)
		item:registerScriptTapHandler(handler(self, self.onClickItem))
		menu:addChild(item)
	end
	self.scroll_view:setTouchEnabled(#buy_items > 4)

	local is_buy = TableEx.findFunction(ex.Player.promotion_data.vip_list, function(value)
        if value == self.data.idx then
            return true
        end
    end)

    self.spr_buy:setVisible(is_buy == true)
    self.btn_buy:setVisible(not is_buy)
    self.node_need:setVisible(not is_buy)
end

function GrowUpGiftCell:onClickItem(tag,pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

function GrowUpGiftCell:onGet(tag,pSender)
	local can_get = ex.Player.total_charge >= self.data.need_recharge
	print(can_get,"onGet")
	-- ex.EventManager:fire(EVENT.PROMOTION_EVENT.JUMP_TO_CELL,103)
	if can_get then 
		local req = Promotion_pb.GReqVipDecorateBuy()
		req.idx = self.data.idx
		-- dump(req)
		NetManager:sendMessage(ProtocolID.GResVipDecorateBuy,req)
	else
		-- 二次提醒框，提醒跳转到充值页面
		-- local function tips()
		-- 	ex.EventManager:fire(EVENT.PROMOTION_EVENT.JUMP_TO_CELL,103)
		-- end
		-- ex.ConfirmCtr:openWindow("", ex.Tools:getLang(41126), tips)
		local conf = cfg.growthgift.vip[self.data.idx]
        ex.MessageView:add(string.format(ex.Tools:getLang(41127), conf.need_recharge / 100), 0)
	end
end

function GrowUpGiftCell:onBuy(tag,pSender)
	local cost = self.data.pack_cost[1]
    local need_gem = cost.item_num
    if ex.Player.gem < need_gem and ex.Player.total_charge >= self.data.need_recharge then
		-- ex.MessageView:add(ex.Tools:getLang(1109)) -- 钻石不足
		local function tips()
			ex.EventManager:fire(EVENT.PROMOTION_EVENT.JUMP_TO_CELL,103)
		end
		ex.ConfirmCtr:openWindow("", ex.Tools:getLang(41126), tips)
        return
    end

	if ex.Player.total_charge < self.data.need_recharge then
		local conf = cfg.growthgift.vip[self.data.idx]
        ex.MessageView:add(string.format(ex.Tools:getLang(41125), conf.need_recharge / 100), 0)
        return
    end

    local is_buy = TableEx.findFunction(ex.Player.promotion_data.vip_list, function(value)
        if value == self.data.idx then
            return true
        end
    end)

    if is_buy then
        ex.MessageView:add(ex.Tools:getLang(47563))
        return
    end
    
    ex.ConfirmCtr:openWindow(ex.Tools:getLang(47590), string.format(ex.Tools:getLang(47630), need_gem), handler(self, self.onBuyPrivilegeDone))
end

function GrowUpGiftCell:onBuyPrivilegeDone()
	local req_vip_buy = Promotion_pb.GReqVipRewardBuy()
	req_vip_buy.vip_level = self.data.idx
	NetManager:sendMessage(ProtocolID.GReqVipRewardBuy, req_vip_buy)
end

function GrowUpGiftCell:payNow( tag, pSender)

end

function GrowUpGiftCell:onShowInfo(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

return GrowUpGiftCell
