--[[
    讨伐团报名界面
    在讨伐团报名阶段点击讨伐团入口时调用
]]

local CrusadeGroupSignUpCtr = class("CrusadeGroupSignUpCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local CrusadeGroupSignUpLayer = class("CrusadeGroupSignUpLayer", require("src.comp.EventLayerAdaptiveWidth"))

-----------------------------------------------------------------------------
function CrusadeGroupSignUpLayer:onCreate()
    self:addBlackBackground()
    self:setAutoClose(true)
    self:setSwallowTouches(true)
    ex.Tools:setLimitWidth(self.lbl_title, 150)
end

function CrusadeGroupSignUpLayer:updateLayer(data)
    self:removeTimerByName("timer")

    if not data then
        return
    end

    self:setSignUpStatus()
    self:addTimer("timer", 1000, handler(self, self.updateTime), true)
    self:updateTime()
end

function CrusadeGroupSignUpLayer:onExit()
    self:removeTimerByName("timer")
end

function CrusadeGroupSignUpLayer:updateTime()
    -- 刷新报名时间
    local stopTime = function ()
        self:removeTimerByName("timer")
        self:setTimeStatus(0)
    end

    local group_data = ctr.crusade_group.data
    if not group_data then
        stopTime()
        return
    end

    local game_data = group_data.game_data
    if not game_data then
        stopTime()
        return
    end

    if group_data.sign_up_end_time == 0 or group_data.battle_start_time == 0 or group_data.game_end_time == 0 then
        stopTime()
        return
    end

    local curtime = ex.Game:getServerTime()
    if curtime < group_data.sign_up_end_time then
        self:setTimeStatus(1, group_data.sign_up_end_time)
    elseif curtime < group_data.battle_start_time then
        self:setTimeStatus(2, group_data.battle_start_time)
    else
        self:removeTimerByName("timer")
        self:setTimeStatus(-1)
    end
end

-- 设置时间，status为0则不需要显示，-1为活动已结束，1为活动报名时间，2为报名结束处于活动等待开始时间，3为活动结束时间
function CrusadeGroupSignUpLayer:setTimeStatus(status, time)
    self.lbl_time_tips:setVisible(status > 0)
    self.lbl_time:setVisible(status > 0)
    self.lbl_sign_up_end:setString(ex.Tools:getLang(77762))
    self.lbl_sign_up_end:setVisible(status == -1)
    
    if status == 1 then
        self.lbl_time_tips:setString(ex.Tools:getLang(77953))
    elseif status == 2 then
        self.lbl_time_tips:setString(ex.Tools:getLang(77954))
    end
    
    if type(time) == "number" then
        local curtime = ex.Game:getServerTime()
        self.lbl_time:setString(ex.StringUtil.convertToTimeFormat(time - curtime, 4))
    end
end

function CrusadeGroupSignUpLayer:setSignUpStatus()
    local group_data = ctr.crusade_group.data
    if not group_data then
        return
    end
    local is_sign_up_end = group_data.stage ~= CRUSADE_GROUP_STATE.SIGN_UP

    if not group_data.sign_up_status then
        if is_sign_up_end then
            ex.Tools:setGrayAuto(self.btn_signup:getNormalImage(), true)
            self.btn_signup:setLabelText(ex.Tools:getLang(77620))
            self.btn_signup:setEnabled(false)
        else
            ex.Tools:setGrayAuto(self.btn_signup:getNormalImage(), false)
            self.btn_signup:setLabelText(ex.Tools:getLang(77619))
            self.btn_signup:setEnabled(true)
        end
    else
        ex.Tools:setGrayAuto(self.btn_signup:getNormalImage(), true)
        self.btn_signup:setLabelText(ex.Tools:getLang(77621))
        self.btn_signup:setEnabled(false)
    end
end

-----------------------------------------------------------------------------
function CrusadeGroupSignUpCtr:onCreate()
    self:setCCBIPath("ccbi/CrusadeGroupSignUpLayer.ccbi")
    self:setIsSingle(false)
end

function CrusadeGroupSignUpCtr:getLayerClass()
    return CrusadeGroupSignUpLayer
end

function CrusadeGroupSignUpCtr:openWindow()
    if self:isOpened() then
        return
    end

    self:loadLayer()
    self:open()
    self:initData()
end

function CrusadeGroupSignUpCtr:initData()
    self.layer:addEvent(EVENT.CRUSADE_GROUP.SIGN_UP, handler(self, self.handleSignUp))
    self.layer:addEvent(EVENT.CRUSADE_GROUP.STAGE_UPDATE, handler(self, self.handleStageUpdate))

    self.layer.btn_signup:registerScriptTapHandler(handler(self, self.onSignUp))
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.onClose))
    self.layer.btn_reward:registerScriptTapHandler(handler(self, self.onReward))

    self.layer.lbl_limit_tips:setString(string.format(ex.Tools:getLang(77638), ex.Tools:getSysCfg("crusade_group_enter_level")))

    self:updateLayer()
end

function CrusadeGroupSignUpCtr:updateLayer()
    local data = ctr.crusade_group.data
    self.layer:updateLayer(data)
end

-- 报名
function CrusadeGroupSignUpCtr:onSignUp(tag, pSender)
    ctr.crusade_group:requestSignUp()
end

function CrusadeGroupSignUpCtr:onClose(tag, pSender)
    self:closeWindow()
end

-- 查看职称奖励
function CrusadeGroupSignUpCtr:onReward(tag, pSender)
    require("src.layer.crusadegroup.CrusadeGroupRewardCtr"):instance():openWindow()
end

-------------------------------事件处理---------------------------------
function CrusadeGroupSignUpCtr:handleSignUp(event, data)
    self.layer:setSignUpStatus()
end

function CrusadeGroupSignUpCtr:handleStageUpdate(event, data)
    self.layer:setSignUpStatus()
end


return CrusadeGroupSignUpCtr