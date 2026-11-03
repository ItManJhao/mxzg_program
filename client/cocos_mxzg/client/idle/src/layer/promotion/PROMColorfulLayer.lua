local PROMColorfulLayer = class("PROMColorfulLayer", require("src.layer.promotion.PromotionBaseLayer"))


function PROMColorfulLayer:onCreateDone()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	self.promotion_id = 44
	self.global_scale = ex.p.width / 640

	self.data = {}

	self.node_bg:setScale(self.global_scale)
	self.node_bg:setPosition(0, self.layer_promotion:getTopY() - 10)

	self.lbl_time = cpp.RichTextEx:createWithXMLLua("")
	self.lbl_time:setFontSize(36)
	self.lbl_time:setScale(0.5)
	self.lbl_time:setFontFace(FONT_DEFAULT_NAME_BOLD)
	self.lbl_time:setFontColor("#ffffff")
	self.lbl_time:setAnchorTextShadow(false)
	self.lbl_time:setAnchorPoint(ex.a.right_center)
    self.lbl_time:setPosition(ex.Tools:getAbsolutePosition(cc.p(5, 0), CommonUIDefine.UIDefine.ComponentOriginType.RIGHT_TOP, self.time_node))
    self.lbl_time:setLocalZOrder(10)
	self.time_node:addChild(self.lbl_time)

	self.btn_do:setLabelText(ex.Tools:getLang(47763))
	self.btn_do:registerScriptTapHandler(handler(self, self.onBtnDone))

	self.reward_nodes = {
		{
			node = self.reward_node_1,
			bg = self.node_bg_1
		},
		{
			node = self.reward_node_2,
			bg = self.node_bg_2
		},
		{
			node = self.reward_node_3,
			bg = self.node_bg_3
		},
		{
			node = self.reward_node_4,
			bg = self.node_bg_4
		}
	}
	
	self:addEvent(EVENT.MAIN_CITY_PROMOTION.COLORFUL, handler(self, self.onEvent))

	self:refreshData( )
	self:initDone()
end

function PROMColorfulLayer:refreshData( )
	self.hasItemNum = ex.Player:getItemNum(ItemType.IT_COLORFUL)
	self.textlab2:setString(tostring(self.hasItemNum))
end

function PROMColorfulLayer:onEvent(event, data)
	self:refreshData()
end

function PROMColorfulLayer:updateCDTime()
	local remain_time = self.data.end_time - ex.Game:getServerTime()

	if ex.Game:getServerTime()  <  self.data.start_time then 
		self.lbl_time:setXmlTextLua(ex.Tools:getLang(41052));
		return 
	end 

	if remain_time < 0 then 
		self.lbl_time:setXmlTextLua(ex.Tools:getLang(41053));

		self:removeTimerByName("colorful_timer")
		return
	end

    if remain_time > 86400 then
        self.lbl_time:setXmlTextLua(string.format(ex.Tools:getLang(41130),
            math.floor(remain_time / 86400)))
    else
        self.lbl_time:setXmlTextLua(string.format(ex.Tools:getLang(41129), 
            math.floor(remain_time / 3600),
            math.floor(remain_time / 60 % 60),
            math.floor(remain_time % 60)))
    end
end

function PROMColorfulLayer:initDone()
	self.data = ex.Player.promotion_data:getPromotionDatas(self.promotion_id)
	self.data.config = ex.Player.promotion_data:getColorfulConfig() or {}

    self:updateCDTime()

	self:updateRawardShow()

	self:addTimer("colorful_timer", 1000, handler(self, self.updateCDTime), true)
end

function PROMColorfulLayer:updateRawardShow()
	local index = 1
	for i,v in ipairs(self.data.config) do
		if v.show_mark == 1 and index <= 4 then 
			local node = self:getShowAwardNode(v.item[1])
			if node ~= nil then
				self.reward_nodes[index].node:setVisible(true)

				local bg_size = self.reward_nodes[index].bg:getContentSize()
				self.reward_nodes[index].bg:addChild(node)
				node:setPosition(bg_size.width * 0.5,bg_size.height * 0.5)
				node:setScale(1.2)
	
				local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_promotion_1")
				spr_effect:setPosition(self.reward_nodes[index].bg:getContentSize().width * 0.5, self.reward_nodes[index].bg:getContentSize().height * 0.5 + 2)
				self.reward_nodes[index].bg:addChild(spr_effect, 0, 10)
				
				index = index + 1
			end
		end
	end

	if index < 4 then
		for i = index + 1, 4 do
			self.reward_nodes[index].node:setVisible(false)
		end
	end
end

function PROMColorfulLayer:getShowAwardNode(item)

	if not item then
		return nil
	end

	local node = cc.Node:create()

	local lbl_num = cc.Label:createWithTTF(tostring(item.item_num), FONT_DEFAULT_NAME_BOLD, 18)
	lbl_num:setAnchorPoint(1, 0.5)
	lbl_num:enableOutline(ex.c3b.BLACK, 1)
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
			local spr_star = cc.Sprite:createWithSpriteFrameName(string.format("other/star-%d.png", star_type))
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
		spr_icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", item.item_type))

		icon_size = spr_icon:getContentSize()
		icon_size.width = icon_size.width * scale
		icon_size.height = icon_size.height * scale

		lbl_num:setAnchorPoint(ex.a.left_center)
		lbl_num:setPosition(10, -icon_size.height / 2 + 10)
	end

	spr_icon:setScale(scale)
	spr_icon:setPosition(0, 0)
	node:addChild(spr_icon)

	return node
end

function PROMColorfulLayer:onBtnDone(tag, pSender)
	require("src.layer.ColorfulShopCtr"):instance():openWindow()
end



return PROMColorfulLayer