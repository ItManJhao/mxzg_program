--[[
* @Description: 异界冒险-航行界面
* @Author: 熊梦
* @Date: 2020-07-30 10:30:00
* ]]
local ExoticAdventureSailingLayer = class("ExoticAdventureSailingLayer", require("src.comp.EventLayerAdaptiveWidthFull"))
local UIMenu = require("src.comp.menu.UIMenu")
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")
 
--------------------------------------------
function ExoticAdventureSailingLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:registerEvent()
    self:setContentSize(cc.size(ex.p.width, ex.p.height))

    local win_size = cc.Director:getInstance():getWinSize()
    local notch_height = require("src.model.Game"):instance():getNotchHeight()
    self.node_upper:setPositionY(win_size.height - notch_height - 70)
    self.node_lower:setPositionY(ex.MainSceneCtr:getBottomHeight()+ 20)

    self.node_left:setPositionX(win_size.width)
    self.node_right:setPositionX(0)
   
    -- self.node_upper:setScaleX(win_size.width / self.spr_bg:getContentSize().width)
    -- self.node_upper:setScaleY(win_size.height / self.spr_bg:getContentSize().height)
    -- self.node_back:setPositionY(self.node_back:getPositionY() - require("src.model.Game"):instance():getNotchHeight() + 25)
   
    -- 移动背景
    local map_pos = cc.p(0, 300)
    local map_size = cc.size(ex.p.width, 637)
    local idx = ex.Player.exotic_adventure_data.not_route
    idx = idx == 0 and 1 or idx 
    self.map_layer = require("src.layer.exoticadventure.ExoticAdventureSceneLayer"):create()
    self.map_layer:initData(nil, map_pos, map_size)
    self:addChild(self.map_layer, -1)

    local checkpoint_data = cfg.spacetimeadventure.spacetimeadventure[ex.Player.exotic_adventure_data.not_route]
    local level_data = cfg.spacetimefleet.spacetimefleet[ex.Player.exotic_adventure_data.level]
    self.lbl_num_1:setString(self:addZeroFrontNum(2,ex.Player.exotic_adventure_data.energy).."/"..self:addZeroFrontNum(2,level_data.energy))

    self.lbl_time = cpp.RichTextEx:createWithXMLLua("")
	self.lbl_time:setFontSize(36)
	self.lbl_time:setScale(0.5)
	self.lbl_time:setFontFace(FONT_DEFAULT_NAME_BOLD)
	self.lbl_time:setFontColor("#ffffff")
	self.lbl_time:setAnchorTextShadow(false)
	self.lbl_time:setAnchorPoint(cc.p(0,0.5))
    self.lbl_time:setPosition(ex.Tools:getAbsolutePosition(cc.p(60, 0), CommonUIDefine.UIDefine.ComponentOriginType.LEFT_BOTTOM, self.node_time))
    self.node_time:addChild(self.lbl_time)

    -- 土著商人时间
    self.btn_shop:setVisible(false)
    self.lbl_shop_time = cpp.RichTextEx:createWithXMLLua("")
	self.lbl_shop_time:setFontSize(36)
	self.lbl_shop_time:setScale(0.5)
	self.lbl_shop_time:setFontFace(FONT_DEFAULT_NAME_BOLD)
	self.lbl_shop_time:setFontColor("#29C732")
	self.lbl_shop_time:setAnchorTextShadow(false)
	self.lbl_shop_time:setAnchorPoint(ex.a.center)
    self.lbl_shop_time:setPosition(ex.Tools:getAbsolutePosition(cc.p(60, 10), CommonUIDefine.UIDefine.ComponentOriginType.LEFT_BOTTOM, self.node_time))
    self.btn_shop:addChild(self.lbl_shop_time)
    self:updatashop()

    -- 航线礼包时间
    self.btn_gift:setVisible(false)
    self.lbl_gift_time = cpp.RichTextEx:createWithXMLLua("")
	self.lbl_gift_time:setFontSize(36)
	self.lbl_gift_time:setScale(0.5)
	self.lbl_gift_time:setFontFace(FONT_DEFAULT_NAME_BOLD)
	self.lbl_gift_time:setFontColor("#29C732")
	self.lbl_gift_time:setAnchorTextShadow(false)
	self.lbl_gift_time:setAnchorPoint(ex.a.center)
    self.lbl_gift_time:setPosition(ex.Tools:getAbsolutePosition(cc.p(60, 10), CommonUIDefine.UIDefine.ComponentOriginType.LEFT_BOTTOM, self.node_time))
    self.btn_gift:addChild(self.lbl_gift_time)
    self:updataGift()



    self:createSailingProgress()
    self:updataSailingprogress()

    if ex.Player.exotic_adventure_data.status == 1 or ex.Player.exotic_adventure_data.end_time - ex.Game:getServerTime() < 0 then
        self.lbl_time:setXmlTextLua(ex.Tools:getLang(76576));
        ex.Player.exotic_adventure_data:sendSailingEnd()
        self.send_sailngend = true
    else
        self:updateCDTime()
        self:addTimer("colorful_timer", 1000, handler(self, self.updateCDTime), true)
    end

    -- 请求航行进度 
    ex.Player.exotic_adventure_data:sendSailingInfo()
    -- -- TEST
    -- self.progress_time = 0
    -- self:addTimer("colorful_timer3", 30, handler(self, self.updateProgress), true)
end


function ExoticAdventureSailingLayer:createSailingProgress()
    self.progressTimer_sailing = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("exotic-adventure/exotic-adventure-spr-jdt-1.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setScaleX(1)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.spr_progress_bg1:addChild(self.progressTimer_sailing)
    self.progressTimer_sailing:setPosition(self.spr_progress_bg1:getContentSize().width / 2 ,self.spr_progress_bg1:getContentSize().height / 2 )
    self:updateSailinglProgress()
end

function ExoticAdventureSailingLayer:updateSailinglProgress()
     -- 策划说总路程写死 乘300
    local checkpoint_data = cfg.spacetimeadventure.spacetimeadventure[ex.Player.exotic_adventure_data.not_route]
    local percent = tonumber(string.format("%.2f",(ex.Player.exotic_adventure_data.not_progress / (checkpoint_data.distance_traveled * 300)*100))) 
    if percent > 100 then percent = 100 end
    self.progressTimer_sailing:setPercentage(percent)   
end


function ExoticAdventureSailingLayer:updatashop()
    if  ex.Player.exotic_adventure_data.shop_end_time - ex.Game:getServerTime() > 0 then
        self.btn_shop:setVisible(true)
        self:updateShopCDTime()
        self:addTimer("colorful_shop_timer", 1000, handler(self, self.updateShopCDTime), true)
    end
end

function ExoticAdventureSailingLayer:updataGift()
    local product_id = ex.Player.exotic_adventure_data.product_id
    if product_id ~= nil and product_id ~= 0 and product_id ~= "" then
        local buy_limit = cfg.spacetimeproduct.spacetimeproduct[product_id].buy_limit
        if ex.Player.exotic_adventure_data.product_buy < buy_limit then
            self.btn_gift:setVisible(true)
            self:updateGiftCDTime()
            self:addTimer("colorful_gift_timer", 1000, handler(self, self.updateGiftCDTime), true)
        else
            self.lbl_gift_time:setXmlTextLua(ex.Tools:getLang(76576));
            self:removeTimerByName("colorful_gift_timer")
            self.btn_gift:setVisible(false)
        end
    else
        self.lbl_gift_time:setXmlTextLua(ex.Tools:getLang(76576));
        self:removeTimerByName("colorful_gift_timer")
        self.btn_gift:setVisible(false)
    end
end

function ExoticAdventureSailingLayer:updateProgressShip()
    if self.spr_effect ~= nil then
        self.spr_effect:removeFromParent()
    end
    -- 船的动画
    -- 根据耐久度来判断船的显示动画
    local level_data = cfg.spacetimefleet.spacetimefleet[ex.Player.exotic_adventure_data.level]
	self.max_durability_progress = level_data.durability
    local num = tonumber(string.format("%.1f",ex.Player.exotic_adventure_data.durability / self.max_durability_progress))
    local animation_name = "stand"
    if num <= 0.7 and num > 0.5 then
        animation_name = "stand1"
    elseif num <= 0.5 then
        animation_name = "stand2"
    end
    local win_size = cc.Director:getInstance():getWinSize()   
    self.spr_effect = sp.SkeletonAnimation:create("spine/chuan.json","spine/chuan.atlas", 1)
    self.spr_effect:setAnimation(0, animation_name, true);
	self.spr_effect:setPosition(win_size.width/2,win_size.height/2)
    self:addChild(self.spr_effect,1)

    -- 顺风航行 风的特效
    if ex.Player.exotic_adventure_data.speed_buff == 1 then
        local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_exotic_adventure_feng")
        spr_effect:setAnchorPoint(cc.p(0.5, 0))
        spr_effect:setPosition(50,-70)
        spr_effect:setScale(1.8)
        self.spr_effect:addChild(spr_effect)
    end
    
end


function ExoticAdventureSailingLayer:updateProgress()
    local checkpoint_data = cfg.spacetimeadventure.spacetimeadventure[ex.Player.exotic_adventure_data.not_route]
     -- 小地图进度
     -- 策划说总路程写死 乘300
    local progress_time = ex.Player.exotic_adventure_data.not_progress / (checkpoint_data.distance_traveled * 300)
    progress_time = math.min(progress_time, 1)

    -- self.progress_time = self.progress_time + 0.01
    -- self.progress_time = math.min(self.progress_time, 1)

    -- 曲线的4个控制点
    -- (6,5)(14.5,117)(129,23)(95,165)
    --(7,8)(30,61)(180,14)(117,105)

    local begin_x = self.spr_progress_bg:getPositionX() - self.spr_progress_bg:getContentSize().width * 0.5
    local begin_y = self.spr_progress_bg:getPositionY() - self.spr_progress_bg:getContentSize().height * 0.5
    local x = Maths.bezierat(begin_x + 7, begin_x + 30, begin_x + 180, begin_x + 117, progress_time)
    local y = Maths.bezierat(begin_y + 8, begin_y + 61, begin_y + 14, begin_y + 105, progress_time)
    self.spr_mao:setPosition(x, y)
end

function ExoticAdventureSailingLayer:updateShopCDTime()
    local remain_time = ex.Player.exotic_adventure_data.shop_end_time - ex.Game:getServerTime()

	if remain_time < 0 then 
		self.lbl_shop_time:setXmlTextLua(ex.Tools:getLang(76576));
        self:removeTimerByName("colorful_shop_timer")
        self.btn_shop:setVisible(false)
		return
	end
	
    self.lbl_shop_time:setXmlTextLua(string.format(ex.Tools:getLang(47140), 
        math.floor(remain_time / 3600),
        math.floor(remain_time / 60 % 60),
        math.floor(remain_time % 60)))
end

function ExoticAdventureSailingLayer:updateGiftCDTime()
    local remain_time = ex.Player.exotic_adventure_data.product_end_time - ex.Game:getServerTime()

	if remain_time < 0 then 
		self.lbl_gift_time:setXmlTextLua(ex.Tools:getLang(76576));
        self:removeTimerByName("colorful_gift_timer")
        self.btn_gift:setVisible(false)
		return
	end
	
    self.lbl_gift_time:setXmlTextLua(string.format(ex.Tools:getLang(47140), 
        math.floor(remain_time / 3600),
        math.floor(remain_time / 60 % 60),
        math.floor(remain_time % 60)))
end


function ExoticAdventureSailingLayer:updateCDTime()
	local remain_time = ex.Player.exotic_adventure_data.end_time - ex.Game:getServerTime()

	if remain_time < 0 then 
		self.lbl_time:setXmlTextLua(ex.Tools:getLang(76576));
        self:removeTimerByName("colorful_timer")
        ex.Player.exotic_adventure_data:sendSailingEnd()
        self.send_sailngend = true
        -- 109：什么都没发生的事件
        if ex.Player.exotic_adventure_data.event_type == 109 then
            require("src.layer.exoticadventure.ExoticAdventureGetItemsCtr"):instance():closeWindow()
        else
            require("src.layer.exoticadventure.ExoticAdventureRandomEventsCtr"):instance():closeWindow()
        end
		return
	end

	if remain_time > 86400 then
		local remainder = math.fmod( remain_time, 86400)
        self.lbl_time:setXmlTextLua(string.format(ex.Tools:getLang(76575),
			math.floor(remain_time / 86400),
			math.floor(remainder / 3600),
			math.floor(remainder / 60 % 60)))
    else
        self.lbl_time:setXmlTextLua(string.format(ex.Tools:getLang(76574), 
            math.floor(remain_time / 3600),
            math.floor(remain_time / 60 % 60),
            math.floor(remain_time % 60)))
    end
end


function ExoticAdventureSailingLayer:onExitCB()
    
end

-- 层切入时会被调用
function ExoticAdventureSailingLayer:changeLayerIn()
   
end

function ExoticAdventureSailingLayer:registerEvent()
    self:addEvent(EVENT.EXOTICADVENTURE.BACK_PACK,handler(self,self.openBackpack))
    self:addEvent(EVENT.EXOTICADVENTURE.ILLUSTRATED_BOOKS,handler(self,self.openSailingIllustrate))
    self:addEvent(EVENT.EXOTICADVENTURE.SAILING_END,handler(self,self.openSailingEnd))
    self:addEvent(EVENT.EXOTICADVENTURE.EVENT_EXPLORE,handler(self,self.openRandomEvents))
    self:addEvent(EVENT.EXOTICADVENTURE.UPDATA_SAILINGPROGRESS,handler(self,self.updataSailingprogress))

    -- 怪物事件  
    self:addEvent(EVENT.EXOTICADVENTURE.EVENT_TWO,handler(self,self.onBattle))
    self:addEvent(EVENT.EXOTICADVENTURE.EVENT_THREE,handler(self,self.onBattle))
    -- 土著商人
    self:addEvent(EVENT.EXOTICADVENTURE.EVENT_SIX,handler(self,self.updatashop))

    -- 更新程，体力，结束时间
    self:addEvent(EVENT.EXOTICADVENTURE.UPDATASAILINGINFO,handler(self,self.updataSailingInfo))

    -- 购买礼包 更新礼包 
    self:addEvent(EVENT.EXOTICADVENTURE.UPDATAGIFT,handler(self,self.updataGift))
    -- 出现礼包
    self:addEvent(EVENT.EXOTICADVENTURE.EVENT_TEN,handler(self,self.updataGift))
end

function ExoticAdventureSailingLayer:openSailingEnd()
    print("===========打开结算页面=============")
    if self.battle_layer == nil then
        require("src.layer.exoticadventure.ExoticAdventureSummaryCtr"):instance():openWindow()
    end
end

function ExoticAdventureSailingLayer:onBack(tag , pSender)
    ex.MainSceneCtr:instance():changeLayer(MainSceneType.MAINCITY_LAYER)
end

-- 舰队信息
function ExoticAdventureSailingLayer:onShioInfo(tag , pSender)
    require("src.layer.exoticadventure.ExoticAdventureShioInfoCtr"):instance():openWindow()
end

-- 货仓
function ExoticAdventureSailingLayer:onBackpack(tag , pSender)
    local req = SpaceTimeAdventure_pb.GReqCargoHoldInfo()
	NetManager:sendMessage(ProtocolID.GReqCargoHoldInfo, req)
end

-- 接收到货仓数据打开货仓
function ExoticAdventureSailingLayer:openBackpack()
    require("src.layer.exoticadventure.ExoticAdventureBackpackCtr"):instance():openWindow()
end

-- 打开图鉴
function ExoticAdventureSailingLayer:onBooks(tag , pSender)
    local req = SpaceTimeAdventure_pb.GReqSailingIllustrate()
	NetManager:sendMessage(ProtocolID.GReqSailingIllustrate, req)
end

-- 接收到图鉴数据打开图鉴
function ExoticAdventureSailingLayer:openSailingIllustrate()
    require("src.layer.exoticadventure.ExoticAdventureIllustratedBooksCtr"):instance():openWindow()
end

-- 玩法说明
function ExoticAdventureSailingLayer:onInfo()
    ex.InfoCtr:openWindow(ex.Tools:getLang(76570), ex.Tools:getLang(76571))
end

-- 打开黑市
function ExoticAdventureSailingLayer:onBlackMarket(tag , pSender)
    print("================打开黑市================")
    cfg.funcopen.main_shop.open(SHOP_TYPE.EXOTIC_ADVENTURE)
    --ex.JumpManager:jumpByAtom("main_black_market_exotic_adventure")
end

-- 探索
function ExoticAdventureSailingLayer:onExplore()
    if ex.Player.exotic_adventure_data.energy <= 0 then
        ex.MessageView:add(ex.Tools:getLang(76578))
        return
    end
    local req = SpaceTimeAdventure_pb.GReqFleetExplore()
    NetManager:sendMessage(ProtocolID.GReqFleetExplore, req)
    require("src.layer.exoticadventure.ExoticAdventureSearchCtr"):instance():openWindow()
end

-- 事件探索返回
function ExoticAdventureSailingLayer:openRandomEvents()
    local delay = cc.DelayTime:create(2)
    local sequence = cc.Sequence:create(delay,  cc.CallFunc:create(function()
        require("src.layer.exoticadventure.ExoticAdventureSearchCtr"):instance():closeWindow()
        local checkpoint_data = cfg.spacetimeadventure.spacetimeadventure[ex.Player.exotic_adventure_data.not_route]
        local level_data = cfg.spacetimefleet.spacetimefleet[ex.Player.exotic_adventure_data.level]
        self.lbl_num_1:setString(self:addZeroFrontNum(2,ex.Player.exotic_adventure_data.energy).."/"..self:addZeroFrontNum(2,level_data.energy))
        -- 109：什么都没发生的事件
        if ex.Player.exotic_adventure_data.event_type == 109 then
            require("src.layer.exoticadventure.ExoticAdventureGetItemsCtr"):instance():openWindow()
        else
            require("src.layer.exoticadventure.ExoticAdventureRandomEventsCtr"):instance():openWindow()
        end
    end))
    self:runAction(sequence)
end

function ExoticAdventureSailingLayer:updataSailingInfo()
    self:updataSailingprogress()

    -- 体力
    local checkpoint_data = cfg.spacetimeadventure.spacetimeadventure[ex.Player.exotic_adventure_data.not_route]
    local level_data = cfg.spacetimefleet.spacetimefleet[ex.Player.exotic_adventure_data.level]
    self.lbl_num_1:setString(self:addZeroFrontNum(2,ex.Player.exotic_adventure_data.energy).."/"..self:addZeroFrontNum(2,level_data.energy))

    -- 时间
    local remain_time = ex.Player.exotic_adventure_data.end_time - ex.Game:getServerTime()
    if remain_time > 86400 then
		local remainder = math.fmod( remain_time, 86400)
        self.lbl_time:setXmlTextLua(string.format(ex.Tools:getLang(76575),
			math.floor(remain_time / 86400),
			math.floor(remainder / 3600),
			math.floor(remainder / 60 % 60)))
    else
        self.lbl_time:setXmlTextLua(string.format(ex.Tools:getLang(76574), 
            math.floor(remain_time / 3600),
            math.floor(remain_time / 60 % 60),
            math.floor(remain_time % 60)))
    end
end

function ExoticAdventureSailingLayer:updataSailingprogress()
    local checkpoint_data = cfg.spacetimeadventure.spacetimeadventure[ex.Player.exotic_adventure_data.not_route]
    -- 策划说总路程写死 乘300
    self.lbl_sailing_progress:setString((string.format("%.2f",(ex.Player.exotic_adventure_data.not_progress / (checkpoint_data.distance_traveled * 300))*100)).. "%")
    self:updateSailinglProgress()
    self:updateProgress()
    self:updateProgressShip()
end

-- 
function ExoticAdventureSailingLayer:onBattle()
    local event_type = ex.Player.exotic_adventure_data.event_type
    local report = ex.Player.exotic_adventure_data.event[event_type][1].report
    local isWin = report.win_id == ex.Player.role_id

    local vec_reward_temp = {}
    vec_reward_temp.itme_list = ex.Player.exotic_adventure_data.event[event_type][1].item_list
    vec_reward_temp.buff = ex.Player.exotic_adventure_data.event[event_type][1].buff

    self.battle_layer = self:addBattleLayer(BattleType.EXOTIC_ADVENTURE,
                                            MainSceneType.EXOTIC_ADVENTURE_SAILING,
                                            "",
                                            nil,
                                            function(layer, data, vec_reward, ext)
                                                require("src.layer.exoticadventure.ExoticAdventureBattleEndCtr"):instance():openWindow(isWin,vec_reward,ext,self.send_sailngend)
                                                return true, false
                                            end)
                                        
    self.battle_layer:setScale(1.0 / self:getScaleX())
    self.battle_layer:setPosition(self:getContentSize().width * 0.5 - ex.p.width  * 0.5,
                             self:getContentSize().height * 0.5  - ex.p.height * 0.5)
                             
    self.battle_layer:battleStart(nil, report,vec_reward_temp,report.log)
end

-- 土著商人
function ExoticAdventureSailingLayer:onShop()
    require("src.layer.exoticadventure.ExoticAdventureShopCtr"):instance():openWindow()
end

-- 航线礼包
function ExoticAdventureSailingLayer:onGift()
    require("src.layer.exoticadventure.ExoticAdventureGiftPageCtr"):instance():openWindow()
end

----------------------------功能模块-----------------------------
-- 计算数字的位数
function ExoticAdventureSailingLayer:dightNum(num)
    if math.floor(num) ~= num or num < 0 then
        return -1
    elseif 0 == num then
        return 1
    else
        local tmp_dight = 0
        while num > 0 do
            num = math.floor(num/10)
            tmp_dight = tmp_dight + 1
        end
        return tmp_dight 
    end
end
    
-- 在整数数字前面加0，例：3 变成 "03"
function ExoticAdventureSailingLayer:addZeroFrontNum(dest_dight, num)
    if num == 0 then return 0 end
    
    local num_dight = self:dightNum(num)
    if -1 == num_dight then 
        return -1 
    elseif num_dight >= dest_dight then
        return tostring(num)
    else
        local str_e = ""
        for var =1, dest_dight - num_dight do
            str_e = str_e .. "0"
        end
        return str_e .. tostring(num)
    end
end

return ExoticAdventureSailingLayer
