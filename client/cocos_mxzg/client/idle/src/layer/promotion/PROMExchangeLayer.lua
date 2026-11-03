local PROMExchangeLayer = class("PROMExchangeLayer", require("src.layer.promotion.PromotionBaseLayer"))

local string_format = string.format
local ExTimer = require("src.ex.ExTimer")


function PROMExchangeLayer:onCreateDone()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
	-- self.textlab1:setString(ex.Tools:getLang(41046))
	

	self.node_top:setPositionY(self.layer_promotion:getTopY())
	self.spr_bg2:setScaleX(ex.p.width / self.spr_bg2:getContentSize().width)
	self.spr_bg2:setScaleY(self.layer_promotion:getTopY() / self.spr_bg2:getContentSize().height)

	
	local lbl_desc = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(20)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#FFFFFF")
	:setAnchorTextShadow(true)
	:ignoreContentAdaptWithSize(false)
	:setWrapMode(1)
	:setContentSize(self:getContentSize().width * 2, 300)
	:setPosition(self.richlab:getPositionX() + 10, self.richlab:getPositionY()- 60 )
	:setAnchorPoint(ex.a.left_center)
	self:addChild(lbl_desc)

	lbl_desc:setXmlTextLua(ex.Tools:getLang(41045))

	self:addEvent(EVENT.MAIN_CITY_LEVEL_UP.ACTIVITY_REFRESH_DATA,handler(self,self.updateList))

	self:refreshData( )
	self:initDone()
end


function PROMExchangeLayer:refreshData( )
	self.hasItemNum = ex.Player:getItemNum(ItemType.IT_TIME_EXCHANGE)
	self.textlab2:setString(tostring(self.hasItemNum))
end

function PROMExchangeLayer:updateList(event,data)

	self:refreshData( )
end


function PROMExchangeLayer:updateCDTime()
	local remain_time = ex.Player.promotion_data.time_exchange_data.etime - ex.Game:getServerTime()
	
	if ex.Game:getServerTime() < ex.Player.promotion_data.time_exchange_data.stime then 
		self.textlab10:setString(ex.Tools:getLang(41052));
		return 
	end 

	if remain_time < 0 then 
		self.textlab10:setString(ex.Tools:getLang(41053));

		self:removeTimerByName("act_exchange_timer")
		return
	end 

    if remain_time > 86400 then
        self.textlab10:setString(string_format(ex.Tools:getLang(48011),
            math.floor(remain_time / 86400)))
    else
        self.textlab10:setString(string_format(ex.Tools:getLang(48010), 
            math.floor(remain_time / 3600),
            math.floor(remain_time / 60 % 60),
            math.floor(remain_time % 60)))
    end
end

function PROMExchangeLayer:initDone()
	self:addTimer("act_exchange_timer", 1000, handler(self, self.updateCDTime))
    self:updateCDTime()

	self.btn_sub:registerScriptTapHandler(handler(self, self.onBtnDone))

	self:updateAwardShow()
	self:updateCompleted()

end

function PROMExchangeLayer:updateAwardShow()


-- item1
	local index = 1
	for i,v in ipairs(ex.Player.promotion_data.time_exchange_data.list) do

		if v.seting.show_mark == 1 then 
			local node = self:getShowAwardNode(v.goods)
			if node then
				local bg_size = self['item'..index]:getContentSize()
				self['item'..index]:addChild(node)
				node:setPosition(bg_size.width * 0.5,bg_size.height * 0.5)
				node:setScale(1.2)

				local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_promotion_1")
				spr_effect:setPosition(self['item'..index]:getContentSize().width * 0.5, self['item'..index]:getContentSize().height * 0.5 + 2)
				self['item'..index]:addChild(spr_effect, 0, 10)
				
				index = index + 1		
			end
		end
	end
end

function PROMExchangeLayer:getShowAwardNode(item)

	if not item then
		return nil
	end

	local node = cc.Node:create()

	local lbl_num = cc.Label:createWithTTF(tostring(item.item_num), FONT_DEFAULT_NAME_BOLD, 18)
	:enableOutline(ex.c3b.BLACK, 1)
	node:addChild(lbl_num, 2)

	local scale = 0.7
	local spr_icon = nil
	local icon_size = nil

	if item.item_type > 20000000 and item.item_type < 30000000 then
		local star = 1
		local config = cfg.item.item[item.item_type]
		if config then
			star = config.star
		end

		-- 碎片
		spr_icon = cc.Sprite:createWithSpriteFrameName(config.icon..".png")

		icon_size = spr_icon:getContentSize()
		icon_size.width = icon_size.width * scale
		icon_size.height = icon_size.height * scale

		lbl_num:setAnchorPoint(ex.a.right_center)
		lbl_num:setPosition(icon_size.width / 2 - 5, -icon_size.height / 2 + 14)

		-- 星级
		local node_star = cc.Node:create():move(0, -icon_size.height / 2)
		node:addChild(node_star, 1)

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

		local diff = 9.0
		local start_pos = cc.p(-(star_count - 1) * diff * 0.5, 14)

		for i=1,star_count do
			local spr_star = cc.Sprite:createWithSpriteFrameName(string_format("other/star-%d.png", star_type))
			:setScale(0.5)
			:setPosition(cc.p(start_pos.x + (i - 1) * diff, start_pos.y))
			node_star:addChild(spr_star)
		end

		-- 右上角小碎片
    	local spr_ps = cc.Sprite:createWithSpriteFrameName("hero-icon/shop-sp.png")
    	:setScale(0.8 * scale)
    	spr_ps:setPosition(icon_size.width / 2 - spr_ps:getContentSize().width / 2,
    		icon_size.height / 2 - spr_ps:getContentSize().height / 2)
    	node:addChild(spr_ps, 1)
	else
		-- 物品
		spr_icon = cc.Sprite:createWithSpriteFrameName(string_format("backpack/%d.png", item.item_type))

		icon_size = spr_icon:getContentSize()
		icon_size.width = icon_size.width * scale
		icon_size.height = icon_size.height * scale

		lbl_num:setAnchorPoint(ex.a.left_center)
		lbl_num:setPosition(15, -icon_size.height / 2 + 10)
	end

	spr_icon:setScale(scale)
	spr_icon:setPosition(0, 0)
	node:addChild(spr_icon)

	return node
end

function PROMExchangeLayer:updateCompleted()

	local btn_size = self.btn_sub:getContentSize()
	btn_size.width = btn_size.width / 2
	btn_size.height = btn_size.height / 2

	local lbl_btn_txt = self.btn_sub:getChildByTag(10)
	if lbl_btn_txt then
		lbl_btn_txt:removeFromParent()
		lbl_btn_txt = nil
	end

	lbl_btn_txt = cc.Label:createWithTTF(ex.Tools:getLang(47763), FONT_DEFAULT_NAME_BOLD, 28)
	
	lbl_btn_txt:setPosition(btn_size.width, btn_size.height)
	self.btn_sub:addChild(lbl_btn_txt, 10, 10)

	-- 领取红点
	--ex.Tools:addRedPoint(self.btn_done, self.btn_done:getTag() == 1, ex.r.p92)
end

function PROMExchangeLayer:onBtnDone(tag, pSender)
	require("src.layer.TimeExchangeShopCtr"):instance():openWindow()
end



return PROMExchangeLayer