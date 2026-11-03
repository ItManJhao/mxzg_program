local PROMWarOrderHallCtr = class("PROMWarOrderHallCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PROMWarOrderHallLayer = class("PROMWarOrderHallLayer", require("src.comp.EventLayerAdaptiveWidth"))

local LAYER_TYPE = {
    REWARD = 1,
    TASK = 2
}

function PROMWarOrderHallLayer:onCreate()
    self:addBlackBackground()

    self.task_layer = require("src.layer.promwarorder.PROMWarOrderTaskLayer"):createWithCCBIFile("ccbi/PROMWarOrderTaskLayer.ccbi")
    self.reward_layer = require("src.layer.promwarorder.PROMWarOrderRewardLayer"):createWithCCBIFile("ccbi/PROMWarOrderRewardLayer.ccbi")
    self:addChild(self.task_layer)
    self:addChild(self.reward_layer)

    self.task_end_time = 0
    self.task_type = 1
    self.lbl_task_time:setVisible(false)
    self.lbl_tips:setVisible(false)
    self.lbl_exp:setLocalZOrder(1)

    self.reward_layer:setPosition(0,0)
    self.task_layer:setPosition(0,0)
    self.task_layer:setVisible(false)
    self.btn_reward:setChecked(true)

    self.lbl_cur_level:setString(ex.Player.promotion_data.prom_war_order_data:getLevel())

    local level = ex.Player.promotion_data.prom_war_order_data:getLevel()
    local max_level = ex.Player.promotion_data.prom_war_order_data:getMaxLevel()
    local exp
    if level == max_level then 
        exp = cfg.promotion090trafficpermitreward.promotion090trafficpermitreward[max_level].exp
    else
        exp = cfg.promotion090trafficpermitreward.promotion090trafficpermitreward[level+ 1].exp
    end

    -- local exp = cfg.promotion090trafficpermitreward.promotion090trafficpermitreward[level+ 1].exp
    local cur_exp = ex.Player.promotion_data.prom_war_order_data:getExp()
    self.lbl_exp:setString(string.format("%s / %s",cur_exp,exp))
    -- self.lbl_exp:enableOutline(cc.c4b(0,0,0,255),)
    self.lbl_task_time:enableOutline(cc.c3b(144,35,16,255), 1)

    self:registerBtnEvent()
    self:setBtnText()
    self.cur_tag = 1
    self:createProgress()
    self:setTabRedPoint()


    self.btn_reward:setLabelText(ex.Tools:getLang(5532))
    self.btn_task:setLabelText(ex.Tools:getLang(5015))

    
    local open_data = ex.Player.promotion_data.prom_war_order_data:getOpenData()
    self.lbl_time:setString(string.format(ex.Tools:getLang(70619),
                                            os.date("%m",open_data.start_time),
                                            os.date("%d",open_data.start_time),
                                            os.date("%m",open_data.end_time),
                                            os.date("%d",open_data.end_time)))
    
    -- self:addTimer()
    self:addEvent(EVENT.WAR_ORDER_ACTIVE.UP_LEVEL,handler(self,self.onUpLevel))
    self:addEvent(EVENT.WAR_ORDER_ACTIVE.GET_TASK_REWARD,handler(self,self.onProgress))
    self:addEvent(EVENT.WAR_ORDER_ACTIVE.BUY_SPECIAL,handler(self,self.setTabRedPoint))
    self:addEvent(EVENT.WAR_ORDER_ACTIVE.ONE_KEY_GET_REWARD,handler(self,self.setTabRedPoint))
    self:addEvent(EVENT.WAR_ORDER_ACTIVE.UP_TASK_PROGRESS,handler(self,self.setTabRedPoint))
    self:addEvent(EVENT.WAR_ORDER_ACTIVE.CHANGE_TASK_TYPE,handler(self,self.onTaskType))
    self:addEvent(EVENT.WAR_ORDER_ACTIVE.REFRESH_INIT_DATA,handler(self,self.onInitData))
    if ex.Player.promotion_data.prom_war_order_data:getRemainTime() <= 86400 *3 and ex.Player.promotion_data.prom_war_order_data:getStatus() == 0 then 
        local open_data = ex.Player.promotion_data.prom_war_order_data:getOpenData()
        local y = os.date("%Y",open_data.end_time)
        local m = os.date("%m",open_data.end_time)
        local d = os.date("%d",open_data.end_time)
        local h = os.date("%H",open_data.end_time)
        local M = os.date("%M",open_data.end_time)
        ex.ConfirmCtr:openWindow(ex.Tools:getLang(72016),string.format(ex.Tools:getLang(70616),y,m,d,h),nil,nil,nil,false)
        ex.Player.promotion_data.prom_war_order_data:setStatus(1)
        local req_daily = Promotion090_pb.GReqTPermitRemind()
        NetManager:sendMessage(ProtocolID.GReqTPermitRemind,req_daily)
    end
end

function PROMWarOrderHallLayer:onInitData(event,data)
    self:addTaskTimer()
    self.reward_layer:onUpLevel()
    self.task_layer:onReward()
end

function PROMWarOrderHallLayer:onTaskType(event,task_type)
    self.task_type = task_type
    self.task_end_time = ex.Player.promotion_data.prom_war_order_data:getTaskEndTimeByType(self.task_type)
    self:upTaskTimer()
    self:addTaskTimer()
end

function PROMWarOrderHallLayer:onExit( )
    self:removeTimer()
    self:removeTaskTimer()
end

function PROMWarOrderHallLayer:removeTimer( )
    if self.timer ~= nil then 
        ex.Timer:removeTimerById(self.timer)
    end
    self.timer = nil 
end

function PROMWarOrderHallLayer:setTabRedPoint( )
    local reward = ex.Player.promotion_data.prom_war_order_data:getRewardRed()
    ex.Tools:addRedPoint(self.btn_reward,reward)
    local task_red = ex.Player.promotion_data.prom_war_order_data.task_red
    local bool = false 
    for i,v in pairs(task_red) do
        if v == true then 
            bool = v 
            break
        end
    end

    ex.Tools:addRedPoint(self.btn_task,bool)

    local level = ex.Player.promotion_data.prom_war_order_data:getLevel()
    local max_level = ex.Player.promotion_data.prom_war_order_data:getMaxLevel()
    local exp
    if level == max_level then 
        exp = cfg.promotion090trafficpermitreward.promotion090trafficpermitreward[max_level].exp
    else
        exp = cfg.promotion090trafficpermitreward.promotion090trafficpermitreward[level+ 1].exp
    end
    self.lbl_cur_level:setString(ex.Player.promotion_data.prom_war_order_data:getLevel())
    local cur_exp = ex.Player.promotion_data.prom_war_order_data:getExp()
    self.lbl_exp:setString(string.format("%s / %s",cur_exp,exp))
end

function PROMWarOrderHallLayer:onProgress(event,data)
    self:updateProgress()
    self:setTabRedPoint()
    local level = ex.Player.promotion_data.prom_war_order_data:getLevel()
    local max_level = ex.Player.promotion_data.prom_war_order_data:getMaxLevel()
    local exp
    if level == max_level then 
        exp = cfg.promotion090trafficpermitreward.promotion090trafficpermitreward[max_level].exp
    else
        exp = cfg.promotion090trafficpermitreward.promotion090trafficpermitreward[level+ 1].exp
    end
    local cur_exp = ex.Player.promotion_data.prom_war_order_data:getExp()
    self.lbl_exp:setString(string.format("%s / %s",cur_exp,exp))
end

function PROMWarOrderHallLayer:onUpLevel(event,data)
    self.lbl_cur_level:setString(ex.Player.promotion_data.prom_war_order_data:getLevel())
    self:updateProgress()
    self:setTabRedPoint()
    local level = ex.Player.promotion_data.prom_war_order_data:getLevel()
    local max_level = ex.Player.promotion_data.prom_war_order_data:getMaxLevel()
    local exp
    if level == max_level then 
        exp = cfg.promotion090trafficpermitreward.promotion090trafficpermitreward[max_level].exp
    else
        exp = cfg.promotion090trafficpermitreward.promotion090trafficpermitreward[level+ 1].exp
    end
    local cur_exp = ex.Player.promotion_data.prom_war_order_data:getExp()
    self.lbl_exp:setString(string.format("%s / %s",cur_exp,exp))
end

function PROMWarOrderHallLayer:setBtnText( )
    local str = ex.Tools:getLang(72051)
    self.btn_reward:setLabelText(str)
    str = ex.Tools:getLang(70612)
    self.btn_task:setLabelText(str)
    str = ex.Tools:getLang(70601)
    self.btn_buy_level:setLabelText(str)

    str = ex.Tools:getLang(70601)
    self.btn_buy_level:setLabelScale(1)
    -- self.btn_buy_level:setLabelColor(cc.c4b(122,71,45,255))
    self.btn_buy_level:setLabelText(str)

    -- self.lbl_btn_gift = cc.Label:createWithTTF(ex.Tools:getLang(70600), FONT_DEFAULT_NAME_BOLD, 18)
    -- self.lbl_btn_gift:setColor(cc.c4b(117,28,20,255))
    -- self.btn_gift:addChild(self.lbl_btn_gift)
    -- self.lbl_btn_gift:setPosition(self.btn_gift:getContentSize().width * 0.5 + 5, 17)
end

function PROMWarOrderHallLayer:registerBtnEvent( )
    self.btn_gift:registerScriptTapHandler(handler(self,self.onGift))
    self.btn_buy_level:registerScriptTapHandler(handler(self,self.onBuyLevel))

    self.btn_reward:registerScriptTapHandler(handler(self,self.onChangeLayer))
    self.btn_task:registerScriptTapHandler(handler(self,self.onChangeLayer))
end

function PROMWarOrderHallLayer:onChangeLayer(tag,pSender)
    if tag == self.cur_tag then return end 
    self.cur_tag = tag
    self.task_layer:setVisible(self.cur_tag == LAYER_TYPE.TASK)
    self.reward_layer:setVisible(self.cur_tag == LAYER_TYPE.REWARD)
    self.lbl_task_time:setVisible(self.cur_tag == LAYER_TYPE.TASK)
    self.lbl_tips:setVisible(self.cur_tag == LAYER_TYPE.TASK)

    if self.cur_tag == LAYER_TYPE.TASK then 
        self.task_end_time = ex.Player.promotion_data.prom_war_order_data:getTaskEndTimeByType(self.task_type)
        self:upTaskTimer()
        self:addTaskTimer()
    else
        self:removeTaskTimer()
    end
end

function PROMWarOrderHallLayer:addTaskTimer( )
    self:removeTaskTimer()
    self.task_timer = ex.Timer:addTimer(1000,function () 
        self:upTaskTimer()
    end,true)
end

function PROMWarOrderHallLayer:upTaskTimer( )
    local time = self.task_end_time - ex.Game:getServerTime()
    local d,h,m,s =  ex.Tools:formatTime(time)
    local str = ""
    if self.task_type == 1 then 
        str = string.format( ex.Tools:getLang(70620), h,m)
    else
        str = string.format( ex.Tools:getLang(70621), d,h,m)
    end
    self.lbl_task_time:setString(str)
    if time <= 0 then 
        self:removeTaskTimer()
    end
end

function PROMWarOrderHallLayer:removeTaskTimer( )
    if self.task_timer ~= nil then 
        ex.Timer:removeTimerById(self.task_timer)
    end
    self.task_timer = nil
end

function PROMWarOrderHallLayer:createProgress()
    self.progressTimer = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("prom-warorder/spr-progress.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setScaleX(1)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.spr_progress_bg:addChild(self.progressTimer)
    self.progressTimer:setPosition(self.spr_progress_bg:getContentSize().width / 2 ,self.spr_progress_bg:getContentSize().height / 2 )
    self:updateProgress()
end

function PROMWarOrderHallLayer:updateProgress()
    local exp = ex.Player.promotion_data.prom_war_order_data:getExp()
    local level = ex.Player.promotion_data.prom_war_order_data:getLevel()
    local max_level = ex.Player.promotion_data.prom_war_order_data:getMaxLevel()
    local config 
    if level == max_level then 
        config = cfg.promotion090trafficpermitreward.promotion090trafficpermitreward[max_level]
    else
        config = cfg.promotion090trafficpermitreward.promotion090trafficpermitreward[level + 1]
    end
    local total_exp = config.exp

    local percent = (exp / total_exp) * 100
    if percent > 100 then percent = 100 end
    self.progressTimer:setPercentage(percent)
end

function PROMWarOrderHallLayer:onGift(tag,pSender)
    require("src.layer.promwarorder.PROMWBuyAdvancedGiftCtr"):instance():openWindow()
end

function PROMWarOrderHallLayer:onBuyLevel(tag,pSender)
    require("src.layer.promwarorder.PROMWBuyLevelCtr"):instance():openWindow()
end

-----------------------------------------------------------------------------
function PROMWarOrderHallCtr:onCreate()
    self:setCCBIPath("ccbi/PROMWarOrderHallLayer.ccbi")
    self:setIsSingle(false)
end

function PROMWarOrderHallCtr:getLayerClass()
    return PROMWarOrderHallLayer
end

function PROMWarOrderHallCtr:getClanRankLayer()
    return self.layer
end

function PROMWarOrderHallCtr:openWindow(str_content)
    if self:isOpened() then
        return
    end

    self.str_content = str_content

    self:loadLayer()
    self:open()
    self:initData()
end

function PROMWarOrderHallCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    -- self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))
end


return PROMWarOrderHallCtr
