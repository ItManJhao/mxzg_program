local SummonHeroPrayerCtr = class("SummonHeroPrayerCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local SummonHeroPrayerLayer = class("SummonHeroPrayerLayer", require("src.comp.EventLayerAdaptiveWidth"))

function SummonHeroPrayerLayer:onCreate()
	self.select_type = 1

	self:addBlackBackground()

	self.lbl_time = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(20)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#5A3509")
	:setPosition(cc.p(self:getContentSize().width * 0.5, 50))
	self:addChild(self.lbl_time)
	-- self.lbl_time:setXmlTextLua("1823761826371263812638126378126")

	-- self.progress = require("src.comp.UIScale9SpriteEx"):create("summon-hero-prayer/prog-2.png", cc.rect(35, 20, 1, 1))
    -- self.progress:setAnchorPoint(cc.p(0.5, 0.5))
    -- self.progress:setContentSize(self.spr_prog_bg:getContentSize())
    -- self.progress:setPosition(cc.p(self.spr_prog_bg:getContentSize().width * 0.5,
	-- 								self.spr_prog_bg:getContentSize().height * 0.5))
	-- self.progress:setPercentage(0)
	self.progress = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("summon-hero-prayer/prog-2.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setPosition(self.spr_prog_bg:getContentSize().width * 0.5,
				 self.spr_prog_bg:getContentSize().height * 0.5)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
	self.spr_prog_bg:addChild(self.progress, 10)

	-- self.lbl_num:setColor(cc.c3b(255, 255, 255))
	self:updateLayer()

	self:addTimer("timer", 1000, handler(self, self.updateTimer), true)
	self:addEvent(EVENT.SUMMON.HEROPRAYER_UPDATE, handler(self, self.updateLayer))
end

function SummonHeroPrayerLayer:updateTimer()
	local time_left = math.max(0, ex.Player.summon_data.hero_prayer_end_time - ex.Game:getServerTime())
	self.lbl_time:setXmlTextLua(string.format(ex.Tools:getLang(41268), ex.Tools:formatTime3(time_left)))
	
	if ex.Player.summon_data.is_buy_hero_prayer and time_left < 0 then
		NetManager:sendMessage(ProtocolID.GReqHeroPrayerData)
	end
end

function SummonHeroPrayerLayer:onElem(tag, pSender)
	self.select_type = tag
	self.spr_select:setPosition(pSender:getPosition())
end

function SummonHeroPrayerLayer:updateLayer()
	local is_buy_hero_prayer = ex.Player.summon_data.is_buy_hero_prayer

	local point = ex.Player:getItemNum(ItemType.IT_SUMMON_HERO_PRAYER)
	local point_max = tonumber(ex.Tools:getSysCfg("adv_summon_wish_time"))

	
	self.btn_buy:setVisible(is_buy_hero_prayer == false)
	self.spr_buy_tip:setVisible(is_buy_hero_prayer == false)
	self.btn_summon:setVisible(is_buy_hero_prayer == true)

	
	ex.Tools:setSpriteFrame(self.spr_tip, is_buy_hero_prayer == true and "summon-hero-prayer/lbl-2.png" or "summon-hero-prayer/lbl-1.png")
	self.lbl_time:setVisible(is_buy_hero_prayer == true)

	self.progress:setPercentage(point / point_max * 100)

	self.lbl_num:setString(string.format("%s/%s", point, point_max))
	-- ex.Tools:setCostColor(self.lbl_num, point > point_max)

	if is_buy_hero_prayer == false then
		local config = cfg.buygem.buygem[59]
		self.btn_buy:setLabelText(string.format(ex.Tools:getLang(47580), config.rmb / 100))
	end

	self:updateTimer()
end

function SummonHeroPrayerLayer:onBuy()
	if ex.Player.summon_data.is_buy_hero_prayer then
		ex.MessageView:add(ex.Tools:getLang(47563))
		return
	end
	ex.Player:pay(59)
end

function SummonHeroPrayerLayer:onSummon()
	local point = ex.Player:getItemNum(ItemType.IT_SUMMON_HERO_PRAYER)
	local point_max = ex.Tools:getSysCfg("adv_summon_wish_time")

	if point < point_max then
		ex.MessageView:add(string.format(ex.Tools:getLang(41267), point_max - point))
		return
	end

	local req_summon = HeroPrayer_pb.GReqHeroPrayer()
	req_summon.elem = self.select_type 
	NetManager:sendMessage(ProtocolID.GReqHeroPrayer, req_summon)
end

function SummonHeroPrayerLayer:onInfo()
	require("src.layer.InfoCtr"):instance():openWindow(ex.Tools:getLang(42060),
													   ex.Tools:getLang(42061))
end


-----------------------------------------------------------------------------
function SummonHeroPrayerCtr:onCreate()
	self:setCCBIPath("ccbi/SummonHeroPrayerLayer.ccbi")
	self:setIsSingle(false)
end

function SummonHeroPrayerCtr:getLayerClass()
	return SummonHeroPrayerLayer
end

function SummonHeroPrayerCtr:getSummonHeroPrayerLayer()
	return self.layer
end

function SummonHeroPrayerCtr:openWindow()
	if self:isOpened() then
		return
	end
	self:loadLayer()
	self:open()
	self:initData()
end

function SummonHeroPrayerCtr:initData()
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	
	NetManager:sendMessage(ProtocolID.GReqHeroPrayerData)

end


return SummonHeroPrayerCtr
