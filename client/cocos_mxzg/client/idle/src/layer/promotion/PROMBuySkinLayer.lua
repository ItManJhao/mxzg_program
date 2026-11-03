local PROMBuySkinLayer = class("PROMBuySkinLayer", require("src.layer.promotion.PromotionBaseLayer"))

local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function PROMBuySkinLayer:onCreateDone()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/promotion-1.plist")

	
	self.promotion_id = 56
	self.fashion_idx = 1
	self.fashion_config = nil
	for k,v in pairs(cfg.fashionbuy.fashionbuy) do
		self.fashion_config = v
		break
	end
    self.timer_name = "act_skin_timer"

	self.node_reward:setLocalZOrder(100)
	self.node_top:setPositionY(self.layer_promotion:getTopY())
	self.spr_bg2 = cc.Sprite:create("ccbi-res/promotion-bg-skin-"..self.fashion_config.fashion_id..".png")
	-- self.spr_bg2 = cc.Sprite:create("ccbi-res/promotion-bg-skin-30101001.png")
	self.spr_bg2:setAnchorPoint(cc.p(0, 1))
	self.spr_bg2:setPosition(0, self.node_top:getContentSize().height)
	self.spr_bg2:setScale(ex.s.global_scale)

	self.node_top:addChild(self.spr_bg2, -1)

    self.node_cd:setPositionY(self.node_cd:getPositionY() - require("src.model.Game"):instance():getNotchHeight())
    
	-- self.spr_reward_bg:setSpriteFrame("promotion/spr-bg-"..self.fashion_config.fashion_id..".png")
	ex.Tools:setSpriteFrame(self.spr_reward_bg, "promotion/spr-bg-"..self.fashion_config.fashion_id..".png")
	-- self.spr_bg2:setScaleX(ex.p.width / self.spr_bg2:getContentSize().width)
	-- self.spr_bg2:setScaleY(self.layer_promotion:getTopY() / self.spr_bg2:getContentSize().height)

	-- ex.Tools:setSpriteFrame(self.spr_time_tip, string.format("promotion-skin/spr-skin-%s.png", self.fashion_config.fashion_id))

	
	local spine_hero = require("src.person.Hero"):create("1", "1", 1, 1, ex.Tools:getHeroSkinByImageId(self.fashion_config.fashion_id))
	spine_hero:setAnimation(0, "stand", true);
	spine_hero:setShadowVisible(false)
	spine_hero:setScale(1.6 * 1.42)
	spine_hero:setPosition(cc.p(self:getContentSize().width / 2, self:getContentSize().height * 0.48 - 60))
	self:addChild(spine_hero, 10)

	local name_buy = self.fashion_config.name_buy or "button/btn-orange-big-1.png"

	local btn_buy_color = self.fashion_config.name_color
	local btn_buy_outline = self.fashion_config.name_outline
	self.btn_buy = cpp.UIMenuItemLabel:create(name_buy, "", "", " ", nil)
		:setPosition(self:getContentSize().width / 2, self:getContentSize().height * 0.12)
		:setLabelColor(btn_buy_color and cc.c3b(btn_buy_color.r, btn_buy_color.g, btn_buy_color.b) or cc.c3b(122, 71, 45))
		:setLabelSize(56)
	self.btn_buy:registerScriptTapHandler(handler(self, self.onBuy))
	self.btn_buy:setDisabledImage(ex.Tools:setGrayAuto(cc.Sprite:createWithSpriteFrameName(name_buy), true))
	self.menu:addChild(self.btn_buy)

	if btn_buy_outline ~= nil and btn_buy_outline ~= "" and btn_buy_outline.r ~= nil then
		self.btn_buy:setLabelOutline(cc.c4b(btn_buy_outline.r, btn_buy_outline.g, btn_buy_outline.b, 255))
	end

	self:addEvent(EVENT.MAIN_CITY_LEVEL_UP.ACTIVITY_REFRESH_DATA, handler(self,self.updateList))

	self:initDone()
	self:updateList()

	NetManager:sendMessage(ProtocolID.GReqFashionBuyData)
end

function PROMBuySkinLayer:initDone()
	self:addTimer(self.timer_name, 1000, handler(self, self.updateCDTime), true)
    self:updateCDTime()

	-- 显示属性加成
	for i,v in ipairs(self.fashion_config.ability) do
		local value = v.value
		if v.attr ~= 101 then
			value = (value / 100).."%"
		end
		self["lbl_attr_"..i]:setString(ex.Tools:getLang(122000 + v.attr).."+"..value)
	end

	-- 显示奖励
	for i,v in ipairs(self.fashion_config.reward) do
		local item = UIMenuItemBackpack:createWithData(v.item_type, v.item_num)
		item:registerScriptTapHandler(handler(self, self.onItemInfo))
		item:setPosition(-300 + i * 120, -55)
		self.menu_reward:addChild(item, 10)
	end
end

function PROMBuySkinLayer:updateList(event, data)
	-- 更新购买状态
	local reward_status = ex.Player.promotion_data.buy_skin_reward_list[1]
	if reward_status == nil or reward_status.value <= 0 then
		self.btn_buy:setEnabled(true)

		-- 显示价格及状态
		local config_buy_gem = cfg.buygem.buygem[self.fashion_config.production_id]
		if config_buy_gem ~= nil then
			self.btn_buy:setLabelText(string.format(ex.Tools:getLang(2705), (config_buy_gem.rmb / 100)))
		end
	else
		-- 显示已购买
		self.btn_buy:setLabelText(ex.Tools:getLang(47247))
		self.btn_buy:setEnabled(false)
	end
end

function PROMBuySkinLayer:updateCDTime()
	local data_time = ex.Player.promotion_data.running_promotion_data[self.promotion_id]
	if data_time == nil then
		return
	end

	local remain_time = data_time.clear_time - ex.Game:getServerTime()
	
	if ex.Game:getServerTime() < data_time.start_time then 
		self.lbl_cd:setString(ex.Tools:getLang(41052));
		return 
	end 

	if remain_time < 0 then 
		self.lbl_cd:setString(ex.Tools:getLang(41053));

		self:removeTimerByName(self.timer_name)
		return
	end 

    if remain_time > 86400 then
        self.lbl_cd:setString(string.format(ex.Tools:getLang(47461), 
            math.floor(remain_time / 86400),
			math.floor(remain_time / 3600 % 24)))
	elseif remain_time > 3600 then 
        self.lbl_cd:setString(string.format(ex.Tools:getLang(70620), 
            math.floor(remain_time / 3600),
			math.floor(remain_time / 60 % 60)))
	else
        self.lbl_cd:setString(string.format(ex.Tools:getLang(47491), 
            math.floor(remain_time / 60),
			math.floor(remain_time % 60)))
    end
end

function PROMBuySkinLayer:onItemInfo(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

function PROMBuySkinLayer:onSkinPreview(tag, pSender)
	if self.battle_layer ~= nil then
		return
	end

    local battle_end = function(layer, data)
        -- ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LIMIT_TIME_SERVER)
        return true, false
    end
    local time_out = function()
        ex.EventManager:fire(EVENT.BATTLE_EVENT.BATTLE_END)
	end

	local battle_layer = self:getParent():addBattleLayerAuto(BattleType.TRIAL,
							MainSceneType.MAINCITY_LIMIT_TIME_SERVER,
							MainSceneType.MAINCITY_TRIAL_BATTLE,
							"",
							EVENT.TRIAL_EVENT.TRIAL_START,
							battle_end)
	battle_layer:setRecoveryType(RecoveryType.RT_CO_EXIST)
	local data = json.decode(cc.FileUtils:getInstance():getStringFromFile("config/fashion-"..self.fashion_config.fashion_id..".txt"))
	local fashion_config = cfg.fashion.fashion[self.fashion_config.fashion_id]
	if fashion_config then
		data.attacker.name = ex.Tools:getLang(fashion_config.atk_lang)
		data.defender.name = ex.Tools:getLang(fashion_config.def_lang)
	end
	ex.EventManager:fire(EVENT.TRIAL_EVENT.TRIAL_START, data)

    ex.AudioManager:playMusic(string.format("music/battle-%d.mp3", 1))
end

function PROMBuySkinLayer:onBuy(tag, pSender)
	local cell = pSender:getParent():getParent()

    if not ex.Player.promotion_data:getTimeIsOpen(self.promotion_id) then
        ex.MessageView:add(ex.Tools:getLang(47324))
        return
    end
    
	local reward_status = ex.Player.promotion_data.buy_skin_reward_list[1]
	if reward_status == nil or reward_status.value <= 0 then
        ex.Player:pay(self.fashion_config.production_id)
    else
        ex.MessageView:add(ex.Tools:getLang(47397))
        return
    end
end

return PROMBuySkinLayer