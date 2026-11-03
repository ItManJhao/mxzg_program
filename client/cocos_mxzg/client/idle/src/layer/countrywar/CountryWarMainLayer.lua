--[[
    func: 国战主界面
    author:熊梦
    time:2021-04-12 16:53:44
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local CountryWarMainLayer = class("CountryWarMainLayer", require("src.comp.EventLayer"))

CountryWarMainLayer.ctr = ctr.country_war

-------------------------------------CountryWarMainLayer----------------------------------------------------
function CountryWarMainLayer:getAsynImage()
    local vec_image = {
		{image_name = "ccbi-res/countrywar.pvr.ccz", plist_name = "ccbi-res/countrywar.plist", remove_type=2},
        {image_name = "ccbi-res/countrywar-lang.pvr.ccz", plist_name = "ccbi-res/countrywar-lang.plist", remove_type=2},
		{image_name = "ccbi-res/countrywar-map-architecture.pvr.ccz", plist_name = "ccbi-res/countrywar-map-architecture.plist", remove_type=2},
		{image_name = "ccbi-res/countrywar-map-1.pvr.ccz", plist_name = "ccbi-res/countrywar-map-1.plist", remove_type=2},
		{image_name = "ccbi-res/countrywar-map-2.pvr.ccz", plist_name = "ccbi-res/countrywar-map-2.plist", remove_type=2},
		{image_name = "ccbi-res/countrywar-map-3.pvr.ccz", plist_name = "ccbi-res/countrywar-map-3.plist", remove_type=2},
		{image_name = "ccbi-res/countrywar-map-4.pvr.ccz", plist_name = "ccbi-res/countrywar-map-4.plist", remove_type=2},
		{image_name = "ccbi-res/countrywar-map-5.pvr.ccz", plist_name = "ccbi-res/countrywar-map-5.plist", remove_type=2},
		{image_name = "ccbi-res/countrywar-map-6.pvr.ccz", plist_name = "ccbi-res/countrywar-map-6.plist", remove_type=2},
		{image_name = "ccbi-res/countrywar-map-7.pvr.ccz", plist_name = "ccbi-res/countrywar-map-7.plist", remove_type=2},
		{image_name = "ccbi-res/countrywar-map-8.pvr.ccz", plist_name = "ccbi-res/countrywar-map-8.plist", remove_type=2},
		{image_name = "ccbi-res/countrywar-map-9.pvr.ccz", plist_name = "ccbi-res/countrywar-map-9.plist", remove_type=2},
    }
	local sfc = cc.SpriteFrameCache:getInstance()
	for k,v in pairs(vec_image) do
		sfc:addSpriteFrames(v.plist_name)
	end
    return vec_image
end

-- 界面布局调整
function CountryWarMainLayer:onCreate()
	self:registerEvent()

	-- 设置选择的城市
	if ctr.country_war.data:getChoiceidx() == 0 then
		ctr.country_war.data:setChoiceidx(ctr.country_war.data:getCurrId())
	end

	self.map_layer = require("src.layer.countrywar.map.CountryWarMapLayer"):createWithCCBIFile("ccbi/CountryWarMapLayer.ccbi")
    self:addChild(self.map_layer, -2)


	-- 适配
	local notch_height = require("src.model.Game"):instance():getNotchHeight()
	local pos_y = ex.p.height - 230 * ex.s.global_scale - notch_height
	self.node_right:setPosition(ex.p.width,pos_y)
	self.node_left:setPosition(0,pos_y)

	self.node_notice:setPositionY(ex.p.height - 100 * ex.s.global_scale - notch_height)

	ex.Tools:setLimitWidth(self.btn_small_map:getLabel(), 60)
	ex.Tools:setLimitWidth(self.btn_country_war_log:getLabel(), 60)
	ex.Tools:setLimitWidth(self.btn_integral_reward:getLabel(), 60)
	ex.Tools:setLimitWidth(self.btn_war_shop:getLabel(), 60)
	ex.Tools:setLimitWidth(self.btn_big_turntable:getLabel(), 60)
	ex.Tools:setLimitWidth(self.btn_chat:getLabel(), 60)
	ex.Tools:setLimitWidth(self.btn_rank:getLabel(), 60)
	ex.Tools:setLimitWidth(self.btn_profit:getLabel(), 60)
	ex.Tools:setLimitWidth(self.btn_random_shop:getLabel(), 60)
	ex.Tools:setLimitWidth(self.btn_my_pos:getLabel(), 60)
	ex.Tools:setLimitWidth(self.btn_flag_task:getLabel(), 60)

	-- 活动结束时间
	self.lbl_end_time = cpp.RichTextEx:createWithXMLLua("")
	self.lbl_end_time:setFontSize(40)
	self.lbl_end_time:setScale(0.5)
	self.lbl_end_time:setFontFace(FONT_DEFAULT_NAME_BOLD)
	self.lbl_end_time:setFontColor("#ffffff")
	self.lbl_end_time:setAnchorTextShadow(false)
	self.lbl_end_time:setAnchorPoint(ex.a.center)
	self.lbl_end_time:setPosition(cc.p(0, 0))
	self.lbl_end_time:setLocalZOrder(10)
	self.node_notice:addChild(self.lbl_end_time)

	local bottom_height = ex.MainSceneCtr:getBottomHeight()
	self.node_item:setPosition(ex.p.width * 0.5, bottom_height + 10)

	self.node_item_1:setPositionX(-ex.p.width * 0.25);
	self.node_item_2:setPositionX(ex.p.width * 0.25);

	for i=1,2 do
		local lbl_time = cpp.RichTextEx:createWithXMLLua("")
		lbl_time = cpp.RichTextEx:createWithXMLLua("")
		lbl_time:setFontSize(30)
		lbl_time:setScale(0.5)
		lbl_time:setFontFace(FONT_DEFAULT_NAME_BOLD)
		lbl_time:setFontColor("#ffffff")
		lbl_time:setAnchorTextShadow(false)
		lbl_time:setAnchorPoint(ex.a.left_center)
		lbl_time:setPositionY(-5)
		
		self["node_item_"..i]:addChild(lbl_time)
		self["layout_time_"..i] = ex.Tools:addLayoutEx(self["node_item_"..i], UILayout.Type.HORIZONTAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.LTOR, 0, 0, 0, 1)

		self["lbl_item_time_"..i] = lbl_time
	end

	self:addTimer("item_timer", 1000, handler(self, self.updateItmeCD), true)
	self:updateItmeCD()

	ctr.country_war:gReqCountryWarCity()

	--添加按钮红点
	self:addRedDotNode(RedDotType.ZCJ_DHZC_GZ_JFJL, self.btn_integral_reward)
	self:addRedDotNode(RedDotType.ZCJ_DHZC_GZ_DZP, self.btn_big_turntable)
	self:addRedDotNode(RedDotType.ZCJ_DHZC_GZ_RWJL, self.btn_flag_task)
	self:addRedDotNode(RedDotType.ZCJ_DHZC_GZ_LQJL, self.btn_profit)

	self:isOpenTips()
	self:UpdataRed()
end

-- 红点
function CountryWarMainLayer:UpdataRed()
	ctr.country_war.data:setLotterRed()					--大转盘红点
	ctr.country_war.data:setTaskRewardRed()				--战旗红点
	ctr.country_war.data:setScoreRed()					--积分红点
end

function CountryWarMainLayer:registerEvent()
    self:addEvent(EVENT.COUNTRY_WAR.ALL_CITY,handler(self,self.updataLayer))   
	self:addEvent(EVENT.COUNTRY_WAR.OPEN_RANDOM_SHOP,handler(self,self.jumpRandomShop))  
	self:addEvent(EVENT.COUNTRY_WAR.OPEN_COUNTRY_WAR_LOG,handler(self,self.jumpCountryWarLog))  
	self:addEvent(EVENT.COUNTRY_WAR.OPEN_BIG_TURNTABLE,handler(self,self.jumpBigTurntable))  
	self:addEvent(EVENT.COUNTRY_WAR.OPEN_SMALL_MAP,handler(self,self.jumpSmallMap))  
	-- self:addEvent(EVENT.COUNTRY_WAR.OPEN_SCORE_REWARD,handler(self,self.jumpIntegralReward))  
	-- self:addEvent(EVENT.COUNTRY_WAR.OPEN_TASK_REWARD,handler(self,self.jumpFlagTask))  
end

function CountryWarMainLayer:updataLayer()
	self.map_layer:updataLayer()

	local item = {
		ctr.country_war.data:getAttackItemType(),
		ctr.country_war.data:getMoveItemType(),
	}
	local item_num = {
		ctr.country_war.data:getAttackNum(),
		ctr.country_war.data:getMoveNum(),
	}
	
	for i=1,2 do
		ex.Tools:setSpriteFrame(self["btn_icon_"..i]:getNormalImage(), string.format("backpack/%s.png", item[i]))
		self["btn_icon_"..i].item_type = item[i]
		self["lbl_item_"..i]:setString(item_num[i])
	end
	self:updateItmeCD()
end

function CountryWarMainLayer:updateItmeCD()
	if not ctr.country_war.data:isOpen() then
		local lang_id = ctr.country_war.data:getStage() ~= COUNTRY_WAR_STATE.BATTLE and 55588 or 55589
		self.lbl_end_time:setXmlTextLua(ex.Tools:getLang(lang_id))
		self.node_item_1:setVisible(false)
		self.node_item_2:setVisible(false)
		return
	end
	self:setTimeEnd(self.lbl_end_time, ctr.country_war.data.next_stage_time)
	-- dump(" ctr.country_war.data.attack_add_time", ctr.country_war.data.attack_add_time)
	self:setTimeCountdown(self.lbl_item_time_1, ctr.country_war.data.attack_add_time,  ctr.country_war.data.attack_item_num >= cfg.system["country_war_attack_item_max"])
	self:setTimeCountdown(self.lbl_item_time_2, ctr.country_war.data.move_add_time, ctr.country_war.data.move_item_num >= cfg.system["country_war_move_item_max"])
	self:updateLayout()
end

function CountryWarMainLayer:updateLayout()
	self.layout_time_1:doLayout();
	self.layout_time_2:doLayout();
	-- self.layout_bottom:doLayout();
end

function CountryWarMainLayer:setTimeEnd(lbl_time,end_time)
    local remain_time = end_time - ex.Game:getServerTime()

	if remain_time < 0 then 
		lbl_time:setXmlTextLua(ex.Tools:getLang(47727))
		ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
		return
	end
	
	if remain_time > 86400 then
		local remainder = math.fmod(remain_time, 86400)
        lbl_time:setXmlTextLua(string.format(ex.Tools:getLang(55569),
			ex.Tools:getLang(cfg.countrywartime.countrywartime[ctr.country_war.data:getRound()*3].lan_id),
			math.floor(remain_time / 86400),
			math.floor(remainder / 3600),
			math.floor(remainder / 60 % 60),
			math.floor(remain_time % 60)))
    else
        lbl_time:setXmlTextLua(string.format(ex.Tools:getLang(55568), 
			ex.Tools:getLang(cfg.countrywartime.countrywartime[ctr.country_war.data:getRound()*3].lan_id),
            math.floor(remain_time / 3600),
            math.floor(remain_time / 60 % 60),
            math.floor(remain_time % 60)))
    end

	lbl_time:formatText()
end

function CountryWarMainLayer:setTimeCountdown(lbl, time, isvisible)
	local remain_time = time - ex.Game:getServerTime()
	if remain_time <= 0 then 
		if isvisible  then
			lbl:setVisible(false)
			return
		end
        ctr.country_war:gReqCountryWarCity()
	end

    if remain_time > 86400 then
    	-- 大于1天
    	-- 剩余时间：%d天
    	lbl:setXmlTextLua(string.format(ex.Tools:getLang(55549), math.floor(remain_time / 86400)))
    else
        remain_time = math.max(0, remain_time)
    	-- 剩余时间：%d小时%d分%d秒
    	lbl:setXmlTextLua(string.format(ex.Tools:getLang(55548), 
        	math.floor(remain_time / 3600),
        	math.floor(remain_time / 60 % 60),
        	math.floor(remain_time % 60)))
	end

	lbl:formatText()
end

function CountryWarMainLayer:jumpCountryWarLog(  )
	require("src.layer.countrywar.CountryWarLogCtr"):instance():openWindow()
end

function CountryWarMainLayer:jumpIntegralReward()
	require("src.layer.countrywar.CountryWarIntegralRewardCtr"):instance():openWindow()
end

function CountryWarMainLayer:jumpBigTurntable()
	require("src.layer.countrywar.CountryWarBigTurntableCtr"):instance():openWindow()
end

function CountryWarMainLayer:jumpRandomShop()
	require("src.layer.countrywar.CountryWarRandomShopCtr"):instance():openWindow(self.map_layer)
end

function CountryWarMainLayer:jumpFlagTask()
	require("src.layer.countrywar.CountryWarTaskRewardCtr"):instance():openWindow()
end

--------------------------------------------------------------------功能界面---------------------------------------------
-- 道具
function CountryWarMainLayer:onItemInfo(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

-- 小地图
function CountryWarMainLayer:onSmallMap(tag, pSender)
	if ctr.country_war.data:checkOpen() then
		return
	end
	require("src.layer.countrywar.CountryWarSmallMapCtr"):instance():openWindow(self.map_layer)
end

-- 国战日志
function CountryWarMainLayer:onCountryWarLog(tag, pSender)
	if ctr.country_war.data:checkOpen() then
		return
	end
	ctr.country_war:gReqCountryWarServerLog()
	ctr.country_war:gReqCountryWarRoleLog()
end

-- 积分奖励请求数据
function CountryWarMainLayer:onIntegralReward(tag, pSender)
	if ctr.country_war.data:checkOpen() then
		return
	end
	ctr.country_war:gReqCountryWarScore()	
	require("src.layer.countrywar.CountryWarIntegralRewardCtr"):instance():openWindow()
end

-- 军工商城
function CountryWarMainLayer:onWarShop(tag, pSender)
	cfg.funcopen.main_shop.open(SHOP_TYPE.COUNTRY_WAR_SHOP)
end

-- 大转盘
function CountryWarMainLayer:onBigTurntable(tag, pSender)
	ctr.country_war:gReqCountryWarLotteryData()	
end

-- 外交风云
function CountryWarMainLayer:onChat(tag, pSender)
	if ctr.country_war.data:checkOpen() then
		return
	end
	local params = {}
	params.focus_type = ChatLayerType.CLT_COUNTRYWAR
    ex.JumpManager:jumpByAtom("main_chat",params)
end

-- 排行榜
function CountryWarMainLayer:onRank(tag, pSender)
	ctr.country_war:gReqCountryWarRank(28)
	require("src.layer.countrywar.CountryWarRankCtr"):instance():openWindow()	
end

-- 领取收益
function CountryWarMainLayer:onProfit(tag, pSender)
	if ctr.country_war.data:checkOpen() then
		return
	end
	if not ctr.country_war.data:getHadReward() then
		ex.MessageView:add(ex.Tools:getLang(5031))
		return
	end
	
	ctr.country_war:gReqCountryWarGetCityReward()
end

-- 随机商城
function CountryWarMainLayer:onRandomShop(tag, pSender)
	if ctr.country_war.data:checkOpen() then
		return
	end
	ctr.country_war:gReqCountryWarRandomShop()
end

-- 我的位置
function CountryWarMainLayer:onMyPos(tag, pSender)
	if ctr.country_war.data:checkOpen() then
		return
	end
	self.map_layer:onShowLastTile(ctr.country_war.data:getCurrId())	
end

-- 战旗任务
function CountryWarMainLayer:onFlagTask(tag, pSender)
	if ctr.country_war.data:checkOpen() then
		return
	end
	ctr.country_war:gReqCountryWarFlag()
	require("src.layer.countrywar.CountryWarTaskRewardCtr"):instance():openWindow()
end

-- 说明
function CountryWarMainLayer:onInfo(tag, pSender)
	ex.InfoCtr:openWindow(ex.Tools:getLang(55554), ex.Tools:getLang(55555))
end

-- 返回
function CountryWarMainLayer:onBack(tag, pSender)
	if self.callback_back then
		self.callback_back()
	else
		ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
	end
end

--每天打开一次
function CountryWarMainLayer:isOpenTips()
	--当前的时间是否是第二天 用的是惊喜盲盒的方法
	local open_time = ex.Player.promotion_data:surpriseBlindBoxTipsisOpen(cc.UserDefault:getInstance():getIntegerForKey(string.format("%sopen_country_war_time", ex.Player.role_id), -1))

	--如果是第二天设置今天弹窗没打开
	if open_time then
		cc.UserDefault:getInstance():setBoolForKey(string.format("%sis_open_country_war", ex.Player.role_id), true)
	end

	--获取今天是否已打开过弹窗 true 没打开， false打开
	local is_open = cc.UserDefault:getInstance():getBoolForKey(string.format("%sis_open_country_war", ex.Player.role_id), true)

	if is_open then
		local lang = ctr.country_war.data:getStage() ~= COUNTRY_WAR_STATE.BATTLE  and ex.Tools:getLang(55588) or ex.Tools:getLang(55589)
		if not ctr.country_war.data:isOpen() then
			require("src.layer.countrywar.CountryWarTipsCtr"):instance():openWindow(ex.Tools:getLang(55554), ex.Tools:getLang(55555), ex.Tools:getLang(55586)..lang)
			cc.UserDefault:getInstance():setBoolForKey(string.format("%sis_open_country_war", ex.Player.role_id), false)
			cc.UserDefault:getInstance():setIntegerForKey(string.format("%sopen_country_war_time", ex.Player.role_id), ex.Game:getServerTime())
		end
	end
end

return CountryWarMainLayer
