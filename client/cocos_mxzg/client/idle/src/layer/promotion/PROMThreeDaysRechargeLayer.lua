local PROMThreeDaysRechargeLayer = class("PROMThreeDaysRechargeLayer", require("src.layer.promotion.PromotionBaseLayer"))

local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function PROMThreeDaysRechargeLayer:onCreateDone()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
	
	self.promotion_id = 84
	self.fashion_idx = cfg.promotion084reward.promotion084reward[1].fashion_id
	self.fashion_ability = cfg.promotion084reward.promotion084reward[1].ability
	self.timer_name = "act_skin_timer"
	self.fashion_config = cfg.herofashion.herofashion[self.fashion_idx]
	self.select_label = 1
	
	self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)
	self.spr_xing_bg:setScaleX(ex.p.width / self.spr_xing_bg:getContentSize().width)
	self.spr_bg_kuang1:setScaleX(ex.p.width / self.spr_bg_kuang1:getContentSize().width)
	
	self.spr_bg:setPositionY(self.layer_promotion:getTopY())
	self.spr_xing_bg:setPositionY(self.layer_promotion:getTopY())
	self.node_top:setPositionY(self.layer_promotion:getTopY())
	self.node_left:setPositionY(self.layer_promotion:getTopY())
	self.node_right:setPositionY(self.layer_promotion:getTopY())
	self.node_cd:setPositionY(self.node_cd:getPositionY() - require("src.model.Game"):instance():getNotchHeight())
	-- self.spr_bg:setScale(ex.s.global_scale)
	-- self.node_top:setScale(ex.s.global_scale)
	self.spr_name:setScale(ex.s.global_scale)
	self.spr_bg3:setScaleX(ex.s.global_scale)
	self.node_wenzi:setScale(ex.s.global_scale)
	self.lbl_price:setScale(ex.s.global_scale)
	
	local spine_hero = require("src.person.Hero"):create("1", "1", 1, 1, ex.Tools:getHeroSkinByImageId(self.fashion_idx))
	spine_hero:setAnimation(0, "stand", true);
	spine_hero:setShadowVisible(false)
	spine_hero:setScale(2)
	self.node_hero_skin:addChild(spine_hero, 1)

	self.lbl_price:setString(string.format(ex.Tools:getLang(2705),cfg.promotion084reward.promotion084reward[1].rmb / 100))

	self.lbl_skin_name:setString(ex.Tools:getLang(self.fashion_config.fashion_name))
	self.lbl_hero_name:setString(ex.Tools:getLang(self.fashion_config.hero_type))
	-- ex.Tools:setLimitWidth(self.lbl_hero_name, 170)
	-- ex.Tools:setLimitWidth(self.lbl_skin_name, 200)
	-- ex.Tools:setLimitWidth(self.lbl_title, 150)
	-- ex.Tools:setLimitWidth(self.lbl_properties, 90)
	
	
	self.item_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()
	self.item_size = cc.size(self.item_size.width * ex.s.global_scale , self.item_size.height * ex.s.global_scale + 17 * math.max(1, ex.s.global_scale))
	self.scroll_view:setItemSize(cc.size(self.item_size.width+20, self.item_size.height + 40))
	self.scroll_view:setAlignmentCenter(true)
	-- self.scroll_view:setItemOffset(cc.p(0, 5))

	self.btn_day1:setChecked(true)

	local btn_tab_str = {5591,5023,5370}
	for i=1,3 do
		self["btn_day"..i]:setLabelText(ex.Tools:getLang(btn_tab_str[i]))
	end

	

	-- 绑定红点
	self:addRedDotNode(RedDotType.ZCJ_DHZC_PFHD_SRLC_DYT, self.btn_day1)
	self:addRedDotNode(RedDotType.ZCJ_DHZC_PFHD_SRLC_DET, self.btn_day2)
	self:addRedDotNode(RedDotType.ZCJ_DHZC_PFHD_SRLC_DST, self.btn_day3)

	self:addEvent(EVENT.THREEDAYSRECHARGE.EVENT_RECHARGE_AMOUNT, handler(self, self.updateList))
	self:addEvent(EVENT.THREEDAYSRECHARGE.RECEIVE_REWARDS, handler(self, self.updateList))

	self:initDone()
end

function PROMThreeDaysRechargeLayer:initDone()
	self:addTimer(self.timer_name, 1000, handler(self, self.updateCDTime), true)
    self:updateCDTime()
	-- 显示属性加成
	for i,v in ipairs(self.fashion_ability) do
		local value = v.value
		if v.attr ~= 101 then
			value = (value / 100).."%"
		end
		self["lbl_attr_"..i]:setString(ex.Tools:getLang(122000 + v.attr).."+"..value)
		ex.Tools:setLimitWidth(self["lbl_attr_"..i], 85)
	end
	self:onSelect(1)
	self:updateList()
end

function PROMThreeDaysRechargeLayer:onSelect(tag, pSender)
	self.select_label = tag
	-- 显示奖励
	self.scroll_view:setLoaded(false)
	local cur_data = {}
	for i,v in ipairs(cfg.promotion084reward.promotion084reward) do
		if self.select_label == v.idx then
			for p,k in ipairs(v.item) do
				table.insert( cur_data, k )
			end
		end
	end
	
	self.scroll_view.createItemFunction = function(item_data, scale)
		local item = ex.Tools:createBackpackItem(item_data.item_type, item_data.item_num)
		item.item_id = item_data.item_id
		item:registerScriptTapHandler(handler(self, self.onItemInfo))
		return item
	end

	self.scroll_view:reloadData(cur_data)	

	self:updateList()
end

function PROMThreeDaysRechargeLayer:updateList()

	 -- 第一天的价格
	local recharge = 0
	local standar_recharge = cfg.promotion084reward.promotion084reward[self.select_label].rmb
	local day_index_one = 0
	for i,v in ipairs(ex.Player.promotion_data.promotion84_record.recharge_info) do
		if v.recharge >= standar_recharge then
			day_index_one = v.day
			break
		end
	end

	if day_index_one ~= 0 then
		local day_index = {}
		local index_num = 0
		for i,v in ipairs(ex.Player.promotion_data.promotion84_record.recharge_info) do
			if index_num >= 4 then return end
			if v.recharge >= standar_recharge then
				local table_day = {}
				table_day.day = v.day
				table_day.recharge = v.recharge
				table.insert( day_index,table_day)
				index_num = index_num + 1
			end
		end
		-- 排序
		local function sort_table (a,b)
			return a.day < b.day
		end 
		table.sort( day_index, sort_table )
		if self.select_label <= #day_index then
			for i,v in ipairs(day_index) do
				if i == self.select_label then
					recharge = v.recharge
				end
			end
		else
			local subtract = day_index[#day_index].day + (self.select_label - #day_index)
			if subtract > ex.Player.promotion_data.promotion84_record.curr_day then
			
			else
				for i,v in ipairs(ex.Player.promotion_data.promotion84_record.recharge_info) do
					if v.day == subtract then
						recharge = v.recharge
					end
				end
			end
		end
	else
		if self.select_label == 1 then
			for i,v in ipairs(ex.Player.promotion_data.promotion84_record.recharge_info) do
				if v.day == ex.Player.promotion_data.promotion84_record.curr_day then
					recharge = v.recharge
				end
			end
		end
	end


	self.lbl_stored:setString(string.format(ex.Tools:getLang(2705),recharge / 100).."/"..string.format(ex.Tools:getLang(2705),standar_recharge / 100))

	if recharge >= standar_recharge then
		self.btn_price_go:setVisible(false)
		self.btn_price_buy:setVisible(true)
	else
		self.btn_price_go:setVisible(true)
		self.btn_price_buy:setVisible(false)
	end

	for i,v in ipairs(ex.Player.promotion_data.promotion84_record.reward_record) do
		self["spr_get_"..v]:setVisible(true)
		if v == self.select_label then
			self.btn_price_go:setVisible(false)
			self.btn_price_buy:setVisible(false)
		end
	end
end

function PROMThreeDaysRechargeLayer:updateCDTime()
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

function PROMThreeDaysRechargeLayer:onItemInfo(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

function PROMThreeDaysRechargeLayer:onSkinPreview(tag, pSender)
	if self.battle_layer ~= nil then
		return
	end

    local battle_end = function(layer, data)
        return true, false
    end
    local time_out = function()
        ex.EventManager:fire(EVENT.BATTLE_EVENT.BATTLE_END)
	end

	local battle_layer = self:getParent():addBattleLayerAuto(BattleType.TRIAL,
							MainSceneType.MAINCITY_LIMIT_TIME_SERVER,
							MainSceneType.MAIN_THREE_DAYS_RECHARGE,
							"",
							EVENT.TRIAL_EVENT.TRIAL_START,
							battle_end)
	battle_layer:setRecoveryType(RecoveryType.RT_CO_EXIST)
	local data = json.decode(cc.FileUtils:getInstance():getStringFromFile("config/fashion-"..self.fashion_idx..".txt"))
	local fashion_config = cfg.fashion.fashion[self.fashion_idx]
	if fashion_config then
		data.attacker.name = ex.Tools:getLang(fashion_config.atk_lang)
		data.defender.name = ex.Tools:getLang(fashion_config.def_lang)
	end
	ex.EventManager:fire(EVENT.TRIAL_EVENT.TRIAL_START, data)

    ex.AudioManager:playMusic(string.format("music/battle-%d.mp3", 1))
end

function PROMThreeDaysRechargeLayer:onInfo(tag, pSender)
	ex.InfoCtr:openWindow(ex.Tools:getLang(91901), ex.Tools:getLang(91902))
end

function PROMThreeDaysRechargeLayer:onGoBuy(tag, pSender)
	-- 回调函数
	local backToLayer =  function ( layer )
        local vec_idx = ex.Player.promotion_data:getPromotionByType(PromotionPageType.LIMIT_TIME_SERVER_ACTIVITY)
        local select_idx = ActivityPanelIdxType.BUY_THREEDAYSRECHARGE
        if layer ~= nil then
            layer:initWithTable(nil, vec_idx, 713)
        end
    end
    local params = {}
    params.backToLayer = backToLayer
    
	ex.JumpManager:jumpByAtom("act_recharge_smart", params)
end

function PROMThreeDaysRechargeLayer:onBuy(tag, pSender)

	local recharge = 0
	local standar_recharge = cfg.promotion084reward.promotion084reward[self.select_label].rmb
	for i,v in ipairs(ex.Player.promotion_data.promotion84_record.recharge_info) do
		if self.select_label == v.day then
			recharge = v.recharge
		end
	end

	if recharge < standar_recharge then
		return
	end

	-- 領取獎勵
	local req = Promotion084_pb.GReqThreeDayGet()
	req.idx = self.select_label
	NetManager:sendMessage(ProtocolID.GReqThreeDayGet, req)
end

return PROMThreeDaysRechargeLayer