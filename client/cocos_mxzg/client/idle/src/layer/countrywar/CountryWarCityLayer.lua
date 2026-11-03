--[[
    func: 国战-城池界面
    author:熊梦
    time:2021-04-12 16:53:44
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local CountryWarCityLayer = class("CountryWarCityLayer", require("src.comp.EventLayer"))

CountryWarCityLayer.ctr = ctr.country_war

local INFO_SHOW = 10    -- 信息面板关闭秒数

local MAX_USER = 20  	-- 每页最大用戶數目
-------------------------------------CountryWarCityLayer----------------------------------------------------
function CountryWarCityLayer:getAsynImage()
	local vec_image = {
		{image_name = "ccbi-res/countrywar.pvr.ccz", plist_name = "ccbi-res/countrywar.plist", remove_type=2},
        {image_name = "ccbi-res/countrywar-lang.pvr.ccz", plist_name = "ccbi-res/countrywar-lang.plist", remove_type=2},
		{image_name = "ccbi-res/countrywar-map-architecture.pvr.ccz", plist_name = "ccbi-res/countrywar-map-architecture.plist", remove_type=2},
		{image_name = "ccbi-res/countrywar-city-map-1.pvr.ccz", plist_name = "ccbi-res/countrywar-city-map-1.plist", remove_type=2},
		{image_name = "ccbi-res/countrywar-city-map-2.pvr.ccz", plist_name = "ccbi-res/countrywar-city-map-2.plist", remove_type=2},
		{image_name = "ccbi-res/countrywar-city-map-3.pvr.ccz", plist_name = "ccbi-res/countrywar-city-map-3.plist", remove_type=2},
		{image_name = "ccbi-res/countrywar-city-map-4.pvr.ccz", plist_name = "ccbi-res/countrywar-city-map-4.plist", remove_type=2},
    }
	local sfc = cc.SpriteFrameCache:getInstance()
	for k,v in pairs(vec_image) do
		sfc:addSpriteFrames(v.plist_name)
	end
    return vec_image
end

function CountryWarCityLayer:onCreate()
	self:registerEvent()

	self.city_id = ctr.country_war.data:getCurrId() 						   -- 我当前所在的城市
	self.choice_idx = ctr.country_war.data:getChoiceidx()  					   -- 选择的城市的id
	self.page_idx = 1 							   							   -- 頁數
	self.architecture_data = cfg.countrywarcity.countrywarcity[self.choice_idx]-- 城市信息
	self.city_user_data = ctr.country_war.data.small_cities					   -- 城市用戶信息
	self.info_type = true													   -- 信息面板收縮狀態
	self.info_time_end = 0													   -- 信息面板自動收回去的時間
	self.occupy_time = ctr.country_war.data.occupy_time						   -- 城市占领时间
	self.architecture_data.defend_num = 0
	self.architecture_data.server_id = nil
	self.architecture_data.event_id = 0
	self.architecture_data.war_duration = 0
	self.architecture_data.isolate = false
	self.architecture_data.event_duration = 0
	self.architecture_data.shop_duration = 0

	-- 数据
	if ctr.country_war.data.cities ~= nil and next(ctr.country_war.data.cities) ~= nil and ctr.country_war.data:isOpen() then 
		local city_data = ctr.country_war.data.cities[self.choice_idx]

		self.architecture_data.defend_num = city_data.defend_num
		self.architecture_data.server_id = city_data.server_id
		self.architecture_data.event_id = city_data.event_id
		self.architecture_data.war_duration = city_data.war_duration
		self.architecture_data.isolate = city_data.isolate
		self.architecture_data.event_duration = city_data.event_duration
		self.architecture_data.shop_duration = city_data.shop_duration
	end
	 
	local max = math.max(math.ceil(#self.city_user_data / MAX_USER),1)
	self.lbl_page:setString(self.page_idx .. "/" .. max)
	local page_data = self:updataUserData(self.page_idx)

    self.map_layer = require("src.layer.countrywar.map.CountryWarCityMapLayer"):createWithCCBIFile("ccbi/CountryWarMapLayer.ccbi")
	self.map_layer:setCityid(self.choice_idx,self.architecture_data,page_data,self.occupy_time)
    self:addChild(self.map_layer, -2)

	self:iniAdaptation()						 -- 界面适配
	self:setButtonStatus()						 -- 攻城 迁移按钮状态
	self:isOlate(self.architecture_data.isolate) -- 包围
	self:startCityInfoTimer()					 -- 设置信息面板定时关闭
end

function CountryWarCityLayer:registerEvent()
    self:addEvent(EVENT.COUNTRY_WAR.UPDAT_SMALL_CITY,handler(self,self.updateMap))   	-- 跳转到城内界面
	self:addEvent(EVENT.COUNTRY_WAR.ATTACK_INFO,handler(self,self.onBattle))        	-- 攻城数据
	self:addEvent(EVENT.COUNTRY_WAR.OPEN_RANDOM_SHOP,handler(self,self.jumpRandomShop)) -- 随机商店
end

-- 界面适配
function CountryWarCityLayer:iniAdaptation()
	local notch_height = require("src.model.Game"):instance():getNotchHeight()
    self.node_right:setPosition(ex.p.width,ex.p.height - 120 * ex.s.global_scale - notch_height)

	local bottom_height = ex.MainSceneCtr:getBottomHeight()
	self.node_lower:setPositionY(bottom_height + 30)

	self.node_city_info:setPosition(self.node_lower:getPositionX(),self.node_lower:getPositionY()+240)

	self.node_upper:setPosition(ex.p.width / 2,ex.p.height - 120 * ex.s.global_scale - notch_height)

	ex.Tools:setLimitWidth(self.btn_random_shop:getLabel(),100)

end

-- 判断攻城迁移按钮状态
function CountryWarCityLayer:setButtonStatus()
	local btn = {self.btn_attack,self.btn_move}
	local is_state = {self:setButtonAttackStatus(),self:setButtonMoveStatus()}
	for i,v in ipairs(is_state) do
		ex.Tools:setGrayAuto(btn[i]:getNormalImage(), not v)
		btn[i]:setEnabled(v)
	end
end

function CountryWarCityLayer:setButtonAttackStatus()
	if not ctr.country_war.data:isOpen() then
		return false
	end
	-- can_attack : 2  不可以攻击
	if self.architecture_data.can_attack == 2 then 
		return false
	end
	
	-- 别人的大本营
	if not ctr.country_war.data:isCityMy(self.choice_idx) and self.architecture_data.type == 1 then
		return false
	end

	if self.choice_idx == self.city_id then
		return false
	end

	local connect_city_id = cfg.countrywarcityrelation.countrywarcityrelation[self.city_id].connect_city_id
	for key,value in pairs(connect_city_id) do
		if value == self.choice_idx then
			local is_friend = ctr.country_war.data:isCityFriend(value) and true or (ctr.country_war.data:isCityMy(value) and true or false)
			return not is_friend
		end
	end

	return false
end

function CountryWarCityLayer:setButtonMoveStatus( )
	if not ctr.country_war.data:isOpen() then
		return false
	end
	-- 自己被包围不可以迁移
	if ctr.country_war.data.cities[self.city_id].isolate then return false end
	-- 选择的就是自己所在的城市
	if self.choice_idx == self.city_id then return false end
	-- 别人的大本营
	if not ctr.country_war.data:isCityMy(self.choice_idx) and self.architecture_data.type == 1 then return false end
	-- 选择的城市被包围不可以迁移
	if self.architecture_data.isolate then return false end
	-- 城市已经满员不可以迁移
	if ctr.country_war.data:isFull(self.choice_idx) then return false end

	return ctr.country_war.data:isCityFriend(self.choice_idx) and true or (ctr.country_war.data:isCityMy(self.choice_idx) and true or false)
end


-- 是否被包圍
function CountryWarCityLayer:isOlate(isbool)
	self.node_olate:setVisible(isbool)
	if isbool then
		local attr = ""
		for i,v in ipairs(self.architecture_data.reduce_attr) do
			attr = attr .. string.format( ex.Tools:getLang(55565),ex.Tools:getLang(122000 + v.type),string.format("%.f%%", math.max(0, v.value / 10000) * 100))
			attr = i ~= #self.architecture_data.reduce_attr and attr .. "," or attr
		end
		self.lbl_olate:setString(ex.Tools:getLang(55564) .. attr )
	end
	ex.Tools:setLimitWidth(self.lbl_olate,590)
end

function CountryWarCityLayer:updateMap()
	if self.architecture_data.server_id ~= nil then
		if self.architecture_data.server_id ~= ctr.country_war.data.cities[self.choice_idx].server_id then
			self.page_idx = 1
		end
	end
	self.city_user_data = ctr.country_war.data.small_cities					   -- 城市用戶信息
	self.occupy_time = ctr.country_war.data.occupy_time						   -- 城市占领时间

	self.city_id = ctr.country_war.data:getCurrId()
	self.choice_idx = ctr.country_war.data:getChoiceidx()

	local max = math.max(math.ceil(#self.city_user_data / MAX_USER),1)
	self.page_idx = self.page_idx > max and max or self.page_idx
	self.lbl_page:setString(self.page_idx .. "/" .. max)
	local data = self:updataUserData(self.page_idx)

	if ctr.country_war.data.cities ~= nil and next(ctr.country_war.data.cities) ~= nil and ctr.country_war.data:isOpen() then 
		local city_data = ctr.country_war.data.cities[self.choice_idx]

		self.architecture_data.defend_num = city_data.defend_num
		self.architecture_data.server_id = city_data.server_id
		self.architecture_data.event_id = city_data.event_id
		self.architecture_data.war_duration = city_data.war_duration
		self.architecture_data.isolate = city_data.isolate
		self.architecture_data.event_duration = city_data.event_duration
		self.architecture_data.shop_duration = city_data.shop_duration
	end

	self.map_layer:UpdateCityLayer(self.architecture_data,data,self.occupy_time)
	self:isOlate(self.architecture_data.isolate) --是否孤立
	self:setCityInfo()					
	self:setButtonStatus()
end

-- 设置城池面板信息
function CountryWarCityLayer:setCityInfo() 
	local special = self.architecture_data.event_id ~= 0
	-- 正常间距39 有特殊奖励间距32
	-- 按钮间隔
	local interval = special and 32 or 39
	
	for i=2,4 do
		self["lbl_info_name_"..i]:setPositionY(self.lbl_info_name_1:getPositionY()- interval *(i - 1))
	end

	-- 所属
	self.lbl_belonging:setVisible(self.architecture_data.server_id ~= 0)
	self.lbl_belonging:setString(string.format(ex.Tools:getLang(55901),ex.StringUtil.getServerName(self.architecture_data.server_id)))
	self.lbl_belonging:setPositionY(self.lbl_info_name_1:getPositionY())
	if not ctr.country_war.data:isOpen() then
		self.lbl_belonging:setVisible(false)
	end
	-- 人数
	self.lbl_user_number:setString(self.architecture_data.defend_num.."/"..self.architecture_data.accommodate_count)
	self.lbl_user_number:setPositionY(self.lbl_info_name_2:getPositionY())
	
	if self.architecture_data.type ~= 1 then
		-- 属性
		local value = string.format("%.f%%", math.max(0, self.architecture_data.add_attr[1].value / 10000) * 100)
		local att_str = string.format(ex.Tools:getLang(55560),ex.Tools:getLang(122000+self.architecture_data.add_attr[1].type) .. "+" .. value ) 
		self.lbl_attribute:setString(att_str)
		-- 收益
		local reap_str =  string.format(ex.Tools:getLang(55562),self.architecture_data.reward_interval / 3600,self.architecture_data.score,self.architecture_data.reward[1].item_num)
		self.lbl_reap:setString(reap_str) 
	end
	-- 属性
	self.lbl_attribute:setPositionY(self.lbl_info_name_3:getPositionY())
	self.lbl_reap:setPositionY(self.lbl_info_name_4:getPositionY())
	-- 特殊奖励
	self.lbl_special_reap:setVisible(special)
	if special then
		self.lbl_special_reap:setPositionY(self.lbl_info_name_4:getPositionY() - interval)
		for k,v in pairs(cfg.countrywarrandomevent.countrywarrandomevent) do
			if v.idx == self.architecture_data.event_id then
				local config = cfg.item.item[v.reward[1].item_type]
				if not config then
					return
				end 
				local str = string.format(ex.Tools:getLang(55561), v.reward[1].item_num, v.interval / 3600, ex.Tools:getLang(config.name)) 
				self.lbl_special_reap:setString(str)
			end
		end
	end

	-- 适配

	for i=1,4 do
		ex.Tools:setLimitWidth(self["lbl_info_name_"..i],140)
	end
	ex.Tools:setLimitWidth(self.lbl_attribute,450)
	ex.Tools:setLimitWidth(self.lbl_reap,450)
	ex.Tools:setLimitWidth(self.lbl_special_reap,450)
end

-- 设置信息面板定时关闭
function CountryWarCityLayer:startCityInfoTimer()
	self:setCityInfo()
	self:addTimer("timerInfo", 1000, handler(self,self.updateCDTime), true)
end

function CountryWarCityLayer:updateCDTime(time)
	self.info_time_end = self.info_time_end + 1
	if self.info_time_end == INFO_SHOW then
		self:removeTimerByName("timerInfo")
		self:onSwitch()
	end
end 

-- 只会取20个
function CountryWarCityLayer:updataUserData(tage_idx)
	self.page_idx = tage_idx
	local data = {}
	for i,v in ipairs(self.city_user_data) do
		if #data >= MAX_USER then break end
		if i > (self.page_idx - 1) * MAX_USER then
			table.insert( data, v )
		end
	end
	return data
end

function CountryWarCityLayer:onBattle(event,data)
	if data.triggerSkill == false and data.report.defender.player_id == 0 then return end

	local vec_reward = {} 
	for k,v in pairs(data.reward) do
		local table_temp = {}
		table_temp.item_type = v.type
		table_temp.item_num =  v.num
		table.insert( vec_reward, table_temp )
	end

	if data.triggerSkill then
		require("src.layer.countrywar.CountryWarInvincibleCtr"):instance():openWindow(function()
			require("src.layer.underworldpagoda.UnderworldPagodaBattleEndCtr"):instance():openWindow(true,vec_reward)
		end)
	else
		local report = data.report
		self.battle_layer = self:addBattleLayer(BattleType.COUNTRY_WAR,
												MainSceneType.MAIN_COUNTRY_WAR_CITY,
												"",
												nil,
												function(layer, data, vec_reward, ext)
													-- require("src.layer.underworldpagoda.UnderworldPagodaBattleEndCtr"):instance():openWindow(data.isWin,vec_reward,ext)
													if ex.Player.notice_data ~= nil then
														local data = ex.Player.notice_data
														ex.Player.notice_data = nil
														ex.Player.battle_state = false
														local config = cfg.notice.notice[data.idx]
														if config == nil then
															return true, true
														end
														ex.MessageView:addNotice(data.msg, config.force, data.id, config.lamp_speed, config.click_jump, data.idx)
													end
													
													return true, true
												end)                                         
		-- 战斗
		self.battle_layer:battleStart(nil, report,vec_reward,report.log)  
		ex.Player.battle_state = true
	end
end

function CountryWarCityLayer:jumpRandomShop()
	require("src.layer.countrywar.CountryWarRandomShopCtr"):instance():openWindow()
end
--------------------------------------------------------------------功能界面---------------------------------------------
-- 翻頁 1:上一頁 2：下一頁
function CountryWarCityLayer:onNext(tag, pSender)
	local max = math.max(math.ceil(#self.city_user_data / MAX_USER),1)
	
	local tage = tag == 1 and self.page_idx - 1 or self.page_idx + 1

	if tage <= 0 or tage > max then
		return
	end

	self.lbl_page:setString(tage .. "/" .. max)

	local data = self:updataUserData(tage)
	self.map_layer:UpdateCityUser(data) 
end

-- 返回
function CountryWarCityLayer:onBack(tag, pSender)
	ex.MainSceneCtr:runCloudAnimation(0.3, function()
		ex.MainSceneCtr:changeLayer(MainSceneType.MAIN_COUNTRY_WAR)
	end)
end

-- 信息面板伸缩开关
function CountryWarCityLayer:onSwitch(tag, pSender)
	-- true：展开状态 点击了按钮就要缩回去
	-- false：收缩状态 点击展开
	self:removeTimerByName("timerInfo")
	local pos = cc.p(self.node_city_info:getPositionX(),0) 
	if self.info_type then
		pos.y = ex.MainSceneCtr:getBottomHeight() - 175
		self.info_type = false
		self.btn_switch:setScaleY(-1)
	else
		pos.y = self.node_lower:getPositionY()+240
		self.info_type = true  
		self.btn_switch:setScaleY(1)
	end
	local req = cc.Sequence:create(cc.Spawn:create(
													cc.FadeOut:create(0.1),
													cc.MoveTo:create(0.1, pos)),
								   nil)
	self.node_city_info:runAction(req)							
end

-- 攻击
function CountryWarCityLayer:onAttack(tag, pSender)
	if ctr.country_war.data:getAttackNum() < self.architecture_data.attack_cost then
		ex.MessageView:add(ex.Tools:getLang(30503))
		return
	end

	require("src.layer.HeroSelectCtr"):instance():openWindow(ex.Tools:getLang(47524),
                                                             ex.Tools:getLang(47064),
                                                             BattleType.COUNTRY_WAR,
                                                             function()
																ctr.country_war:gReqCountryWarAttackCity(self.choice_idx)
															 end)
end

-- 迁移
function CountryWarCityLayer:onMove(tag, pSender)

	if ex.Game:getServerTime()  <  self.architecture_data.war_duration then 
		if ctr.country_war.data:getMoveNum() < self.architecture_data.move_cost then
			ex.MessageView:add(ex.Tools:getLang(30503))
			return
		end
		-- 弹框
		ex.ConfirmCtr:openWindow(ex.Tools:getLang(72016), ex.Tools:getLang(55581), function()
			ctr.country_war:gReqCountryWarMoveCity(self.choice_idx)
		end)
	else
		ctr.country_war:gReqCountryWarMoveCity(self.choice_idx)
	end
end

-- 随机商店
function CountryWarCityLayer:onShop(tag, pSender)
	if ctr.country_war.data:checkOpen() then
		return
	end
	ctr.country_war:gReqCountryWarRandomShop()
end


return CountryWarCityLayer
