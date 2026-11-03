local TestBattleLayer = class('TestBattleLayer', require('src.comp.EventLayer'))

local BattleController = require('src.controller.BattleController')

function TestBattleLayer:onCreate()
    local winSize = cc.size(ex.p.width, ex.p.height)

    local bgSprite = cc.Sprite:create('ccbi-res/chapter/map31.jpg')
    bgSprite:setScaleX((winSize.width + 10) / bgSprite:getContentSize().width)
    bgSprite:setScaleY(winSize.height / bgSprite:getContentSize().height)
    bgSprite:setPosition(cc.p(
        0.5 * winSize.width,
        0.5 * winSize.height
    ))
    self:addChild(bgSprite)

    local menu = cpp.UIMenu:create()
	menu:setName("menu_main")
    menu:setPosition(cc.p(0, 0))
    self:addChild(menu)

    self._mainNode = cc.Node:create()
    self:addChild(self._mainNode)
    
    self._testBattlefieldLayer = cc.Node:create()
    self._testBattlefieldLayer:setContentSize(winSize)
    self._mainNode:addChild(self._testBattlefieldLayer, 1)
    
    -- 天气效果层
    self.layer_weather = cc.Layer:create()
    self.layer_weather:setPosition(cc.p(0, 0))
    self:addChild(self.layer_weather, 100)

    self._lastBattleReport = nil
    self._battleController = BattleController.new(self._testBattlefieldLayer)
    self._battleController:setIsPrintLog(true)
    self._battleController:addEventListener(BattleController.Event.RoundStart, function(evt)
        self._roundLabel:setString(self:_genRoundText(evt.roundNumber))
    end)
    self._battleController:addEventListener(BattleController.Event.RoundEnd, function(evt)
        -- 回合结束时你要执行的东西......
    end)
    self._battleController:addEventListener(BattleController.Event.BattleEnd, function()
        -- 战斗结束时你要执行的东西......
        self._roundLabel:setString('')
        self._btReportEditBox:setVisible(true)
        self._btSaveReportEditBox:setVisible(true)
        self._btSaveReportEditBox:setText(json.encode(self._lastBattleReport))
        self:changeWeather(WEATHER_TYPE.NIL)
    end)
    self._battleController:addEventListener(self._battleController.Event.ChangeWeather, handler(self, self.changeWeather))

    self._roundLabel = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 50)
    self._roundLabel:setScale(0.5)
    self._roundLabel:setPosition(ex.p.width * 0.5, 200)
    self._roundLabel:enableOutline(FONT_BLACK_C4B, 3)
    self:addChild(self._roundLabel)
    
    self._startBtn = self:_createTestBattleBtn()
    menu:addChild(self._startBtn)
    self._startBtn:registerScriptTapHandler(function()
        if self._battleController:isPlaying() then
            ex.MessageView:add(ex.Tools:getLang(47303))
            return
        end

        local inputReport = self._btReportEditBox:getText()
        if string.len(inputReport) > 0 then
            local btReport = json.decode(inputReport)
            self:_playBattle(btReport)
            ex.MessageView:add(ex.Tools:getLang(47718))
            return
        end
        
        local btType = tonumber(self._btTypeEditBox:getText()) or 0
        local req = Battle_pb.GReqBattleTest()
        req.type = btType
        NetManager:sendMessage(ProtocolID.GReqBattleTest, req)
    end)

    self._openTerminalBtn = self:_createOpenTerminalBtn()
    menu:addChild(self._openTerminalBtn)
    self._openTerminalBtn:registerScriptTapHandler(function()
        GlobalBattleHelper.openTerminalLayer()
    end)

    self._stopBtn = self:_createStopBattleBtn()
    menu:addChild(self._stopBtn)
    self._stopBtn:registerScriptTapHandler(function()
        if not self._battleController:isPlaying() then
            ex.MessageView:add(ex.Tools:getLang(47056))
            return
        end

        self._battleController:forceStop()
    end)

    self._battleDetailBtn = self:_createBattleDetailBtn()
    menu:addChild(self._battleDetailBtn)
    self._battleDetailBtn:registerScriptTapHandler(function()
        if self._lastBattleReport == nil then
            ex.MessageView:add(ex.Tools:getLang(47131))
            return
        end

        require("src.layer.BattleDetailCtr"):instance():openWindow(self._lastBattleReport.log)
    end)

    self._replayBtn = self:_createReplayBtn()
    menu:addChild(self._replayBtn)
    self._replayBtn:registerScriptTapHandler(function()
        if self._lastBattleReport == nil then
            ex.MessageView:add(ex.Tools:getLang(47131))
            return
        end

        self:_playBattle(self._lastBattleReport)
    end)

    local selectSpeedButton = function(btn, speed)
        btn:setScale(0.8)
        btn:selected()
        GlobalBattleHelper.getScheduler():setTimeScale(speed)
    end

    local btSpeed = cc.UserDefault:getInstance():getDoubleForKey(string.format("%s-test-battle_speed", ex.Player.role_id), 1.0)
    local btSpeedBtnTpl = 'btn_test_battle_speed_'
    local posXList   = {0.3, 0.4, 0.5, 0.6, 0.7}
    local btSpeeds   = {0.2, 0.5, 1.0, 1.5, 2.0}
    for k,v in ipairs(btSpeeds) do
        local x = posXList[k]
        local btn = self:_createSpeedAdjustBtn(tostring(v))
        btn:setPosition(cc.p(x * winSize.width, 0.8 * winSize.height - 75))
        menu:addChild(btn)

        local speedBtnName = btSpeedBtnTpl .. v

        if btSpeed == v then
            selectSpeedButton(btn, v)
        end

        btn:setEnableAction(false)
        btn:registerScriptTapHandler(function(e)
            cc.UserDefault:getInstance():setDoubleForKey(string.format("%s-test-battle_speed", ex.Player.role_id), v)
            selectSpeedButton(btn, v)
            
            for k1,v1 in ipairs(btSpeeds) do
                local subBtnName = btSpeedBtnTpl .. v1
                if subBtnName ~= speedBtnName then
                    local btn = menu:getChildByName(subBtnName)
                    btn:setScale(0.6)
                    btn:unselected()
                end
            end
        end)
    end

    self._btTypeEditBox = self:_createBTTypeEditBox()
    self._mainNode:addChild(self._btTypeEditBox)

    self._btReportEditBox = self:_createBTReportEditBox()
    self._mainNode:addChild(self._btReportEditBox)

    self._btSaveReportEditBox = self:_createBTSvaeReportEditBox()
    self._mainNode:addChild(self._btSaveReportEditBox)

    self:addEvent(EVENT.BATTLE_EVENT.TEST_BATTLE, handler(self,self.onStartBattle))
end

function TestBattleLayer:onExit()
    self._battleController:forceStop()
end

function TestBattleLayer:onStartBattle(evt, reportData)
    self._lastBattleReport = reportData
    self:_playBattle(reportData)
end

-- 更换天气
function TestBattleLayer:changeWeather(weather_type)
    if self.layer_weather == nil then
        return
    end

    if self.layer_weather.weather_type == weather_type then
        return
    end

    if self.layer_weather.weather_type == WEATHER_TYPE.NIL then
        
    elseif self.layer_weather.weather_type == WEATHER_TYPE.THUNDER then
        self:_playWeatherThunderFadeOut()
    elseif self.layer_weather.weather_type == WEATHER_TYPE.RAIN then
        self:_playWeatherRainFadeOut()
    elseif self.layer_weather.weather_type == WEATHER_TYPE.SAND then
        self:_playWeatherSandFadeOut()
    end

    self.layer_weather.weather_type = weather_type
    -- self.layer_weather:removeAllChildren()

    if weather_type == WEATHER_TYPE.NIL then
        self.layer_weather:removeAllChildren()
        return
    elseif weather_type == WEATHER_TYPE.THUNDER then
        self:_playWeatherThunder()
    elseif weather_type == WEATHER_TYPE.RAIN then
        self:_playWeatherRain()
    elseif weather_type == WEATHER_TYPE.SAND then
        self:_playWeatherSand()
    end
end

-- 执行雷暴天气特效
function TestBattleLayer:_playWeatherThunder()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/weather.plist")

    -- 固定云的数量
    local num_cloud = 20
    
    local top_y = self:getContentSize().height - ex.Game:getNotchHeight() - 200

    -- 雷电生成函数
    local callback_thunder = function()
        -- 创建雷电特效节点
        local spr_node = cc.Sprite:create()
        spr_node:setScale(math.random(10,20) / 10)
        spr_node:setPosition(cc.p(math.random(0, ex.p.width), top_y + math.random(0, 100)))
        self.layer_weather:addChild(spr_node, math.random(5000,9999))

        local str_format = string.format("weather/spr-thunder-%d-%%d.png", math.random(1, 2))
        local act_anim = ex.EffectFactory:createAnimate("ccbi-res/weather.plist", str_format, 0.06)
        spr_node:runAction(cc.Sequence:create(cc.DelayTime:create(math.random(0, 30) / 10),
                                              cc.CallFunc:create(function()
                                                  ex.AudioManager:playEffect("music/thunder-1.mp3")
                                              end),
                                              act_anim, 
                                              cc.RemoveSelf:create(), 
                                              nil))

        -- 创建雷电特效节点
        if math.random(1, 6) > 3 then
            local spr_node_2 = cc.Sprite:create()
            spr_node_2:setAnchorPoint(cc.p(0.5, 1))
            -- spr_node_2:setScale(math.random(10,20) / 10)
            spr_node_2:setScaleY(math.random(8,12) / 10)
            spr_node_2:setPosition(cc.p(math.random(0, ex.p.width), top_y + math.random(0, 100)))
            self.layer_weather:addChild(spr_node_2, math.random(5000,9999))

            local str_format = string.format("weather/spr-thunder-%d-%%d.png", 3)
            local act_anim = ex.EffectFactory:createAnimate("ccbi-res/weather.plist", str_format, 0.06)
            spr_node_2:runAction(cc.Sequence:create(cc.DelayTime:create(math.random(0, 30) / 10), 
                                                    cc.CallFunc:create(function()
                                                        ex.AudioManager:playEffect("music/thunder-2.mp3")
                                                    end),
                                                    act_anim, 
                                                    cc.RemoveSelf:create(), 
                                                    nil))
        end
    end

    -- 在屏幕顶部铺设乌云
    self.layer_weather.vec_cloud = {}
    for i=1,num_cloud do
        -- 创建乌云
        local spr_cloud = cc.Sprite:createWithSpriteFrameName("weather/spr-dark-cloud.png")
        spr_cloud:setOpacity(math.random(180, 255))
        spr_cloud:setScaleX(math.random(10,20) / 10)
        spr_cloud:setScaleY(math.random(10,20) / 10)
        spr_cloud:setPosition(cc.p(ex.p.width / num_cloud * i + math.random(0, 100) - 50, top_y + math.random(0, 100)))
        self.layer_weather:addChild(spr_cloud, math.random(1,4999))

        table.insert(self.layer_weather.vec_cloud, spr_cloud)

        -- spr_cloud:setOpacity(0)
        spr_cloud:runAction(cc.FadeTo:create(1, math.random(180, 255)))
    
        -- 创建乌云移动动作，保证每个乌云移动轨迹不重复
        local act_move_by = cc.MoveBy:create(math.random(50, 100) / 10, cc.p(math.random(0, 100) - 50, 0))
        local act_repeat = cc.RepeatForever:create(cc.Sequence:create(act_move_by, act_move_by:reverse(), nil))
        spr_cloud:runAction(act_repeat)

        if i == 1 then
            -- 创建乌云发生动作
            spr_cloud:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(1), cc.CallFunc:create(callback_thunder), nil)))
            callback_thunder()
        end
    end
end

-- 执行雷暴天气消失特效
function TestBattleLayer:_playWeatherThunderFadeOut()
    if self.layer_weather == nil or self.layer_weather.vec_cloud == nil or table.nums(self.layer_weather.vec_cloud) <= 0 then
        return
    end

    local vec_children = self.layer_weather:getChildren()
    for _,node_child in pairs(vec_children) do
        node_child:stopAllActions()

        local is_cloud = false
        for _,spr_cloud in pairs(self.layer_weather.vec_cloud) do
            if node_child == spr_cloud then
                is_cloud = true
            end
        end

        if not is_cloud then
            node_child:removeFromParent()
            node_child = nil
        end
    end

    for _,spr_cloud in pairs(self.layer_weather.vec_cloud) do
        spr_cloud:runAction(cc.Sequence:create(cc.FadeOut:create(1), cc.RemoveSelf:create(), nil))
    end

    self.layer_weather.vec_cloud = {}
end

-- 执行雨天天气特效
function TestBattleLayer:_playWeatherRain()

end

-- 执行雨天天气消失特效
function TestBattleLayer:_playWeatherRainFadeOut()

end

-- 执行沙暴天气特效
function TestBattleLayer:_playWeatherSand()

end

-- 执行沙暴天气消失特效
function TestBattleLayer:_playWeatherSandFadeOut()

end

function TestBattleLayer:_playBattle(reportData)
    if self._battleController:isPlaying() then return end

    if cpp.SocialPlatform:instance():isDebug() then dump(reportData) end
    self._btReportEditBox:setVisible(false)
    self._btSaveReportEditBox:setVisible(false)
    self._battleController:play(reportData, {
        hasEnter = false
    })
end

function TestBattleLayer:_createTestBattleBtn()
    local winSize = cc.size(ex.p.width, ex.p.height)
    
    local btn = cpp.UIMenuItemLabel:create("button/btn-orange-4.png",
                                           "button/btn-orange-4.png",
                                           ex.Tools:getLang(47182),
                                           nil)
    btn:setLabelColor(cc.c3b(255, 255, 255))
    btn:setLabelShadow(cc.c4b(177, 84, 0, 255), cc.size(0, -1), 10)
    btn:setLabelOutLine(cc.c4b(177, 84, 0, 255))
    btn:setLabelOffset(cc.p(0, 0))
    btn:setLabelSize(65)
    btn:setLabelScale(0.5)
    btn:setName("btn_test_battle")
    btn:setPosition(winSize.width * 0.5,
                    winSize.height * 0.8)
    return btn
end

function TestBattleLayer:_createStopBattleBtn()
    local winSize = cc.size(ex.p.width, ex.p.height)
    
    local btn = cpp.UIMenuItemLabel:create("button/btn-battle-1.png",
                                           "button/btn-battle-1.png",
                                           ex.Tools:getLang(47164),
                                           nil)
    btn:setLabelColor(cc.c3b(255, 255, 255))
    btn:setLabelShadow(cc.c4b(177, 84, 0, 255), cc.size(0, -1), 10)
    btn:setLabelOutLine(cc.c4b(177, 84, 0, 255))
    btn:setLabelOffset(cc.p(0, 0))
    btn:setLabelSize(65)
    btn:setLabelScale(0.5)
    btn:setName("btn_test_battle_stop")
    btn:setPosition(winSize.width * 0.5, winSize.height * 0.9)
    return btn
end

function TestBattleLayer:_createSpeedAdjustBtn(str)
    local btn = cpp.UIMenuItemLabel:create("button/btn-circle-blue-1.png",
                                           "button/btn-circle-blue-2.png",
                                           str,
                                           nil)
    btn:setLabelColor(cc.c3b(255, 255, 255))
    btn:setLabelShadow(cc.c4b(177, 84, 0, 255), cc.size(0, -1), 10)
    btn:setLabelOutLine(cc.c4b(177, 84, 0, 255))
    btn:setLabelOffset(cc.p(0, 0))
    btn:setLabelSize(65)
    btn:setLabelScale(0.5)
    btn:setName("btn_test_battle_speed_" .. str)
    btn:setScale(0.6)

    return btn
end

function TestBattleLayer:_createOpenTerminalBtn()
    local winSize = cc.size(ex.p.width, ex.p.height)
    
    local btn = cpp.UIMenuItemLabel:create("button/btn-battle-1.png",
                                           "button/btn-battle-1.png",
                                           ex.Tools:getLang(47429),
                                           nil)
    btn:setLabelColor(cc.c3b(255, 255, 255))
    btn:setLabelShadow(cc.c4b(177, 84, 0, 255), cc.size(0, -1), 10)
    btn:setLabelOutLine(cc.c4b(177, 84, 0, 255))
    btn:setLabelOffset(cc.p(0, 0))
    btn:setLabelSize(65)
    btn:setLabelScale(0.5)
    btn:setName("btn_test_battle_open_terminal")
    btn:setPosition(winSize.width * 0.5, winSize.height * 0.85)
    return btn
end

function TestBattleLayer:_createBattleDetailBtn()
    local winSize = cc.size(ex.p.width, ex.p.height)
    
    local btn = cpp.UIMenuItemLabel:create("button/btn-blue-4.png",
                                           "button/btn-blue-4.png",
                                           ex.Tools:getLang(47591),
                                           nil)
    btn:setLabelColor(cc.c3b(255, 255, 255))
    btn:setLabelShadow(cc.c4b(177, 84, 0, 255), cc.size(0, -1), 10)
    btn:setLabelOutLine(cc.c4b(177, 84, 0, 255))
    btn:setLabelOffset(cc.p(0, 0))
    btn:setLabelSize(65)
    btn:setLabelScale(0.5)
    btn:setName("btn_test_battle_open_terminal")
    btn:setPosition(winSize.width * 0.2, winSize.height * 0.8)
    return btn
end

function TestBattleLayer:_createReplayBtn()
    local winSize = cc.size(ex.p.width, ex.p.height)
    
    local btn = cpp.UIMenuItemLabel:create("button/btn-blue-4.png",
                                           "button/btn-blue-4.png",
                                           ex.Tools:getLang(47426),
                                           nil)
    btn:setLabelColor(cc.c3b(255, 255, 255))
    btn:setLabelShadow(cc.c4b(177, 84, 0, 255), cc.size(0, -1), 10)
    btn:setLabelOutLine(cc.c4b(177, 84, 0, 255))
    btn:setLabelOffset(cc.p(0, 0))
    btn:setLabelSize(65)
    btn:setLabelScale(0.5)
    btn:setName("btn_test_battle_open_terminal")
    btn:setPosition(winSize.width * 0.8, winSize.height * 0.8)
    return btn
end

function TestBattleLayer:_createBTTypeEditBox()
    local winSize = cc.size(ex.p.width, ex.p.height)

    local editBox = ccui.EditBox:create(cc.size(200, 30), 'other/spr-bg-1.png', 1)

    editBox:setAnchorPoint(cc.p(0.5, 0.5))
    editBox:setFontSize(26)
    editBox:setFontColor(cc.WHITE)
    editBox:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    editBox:setPosition(cc.p(winSize.width / 2, 0.7*winSize.height))

    return editBox
end

function TestBattleLayer:_createBTReportEditBox()
    local winSize = cc.size(ex.p.width, ex.p.height)

    local editBox = ccui.EditBox:create(cc.size(500, 200), 'other/spr-bg-1.png', 1)

    editBox:setAnchorPoint(cc.p(0.5, 0.5))
    editBox:setFontSize(26)
    editBox:setFontColor(cc.WHITE)
    editBox:setInputMode(cc.EDITBOX_INPUT_MODE_ANY)
    editBox:setPosition(cc.p(winSize.width / 2, 0.5*winSize.height))

    return editBox
end

function TestBattleLayer:_createBTSvaeReportEditBox()
    local winSize = cc.size(ex.p.width, ex.p.height)

    local editBox = ccui.EditBox:create(cc.size(500, 200), 'other/spr-bg-1.png', 1)

    editBox:setAnchorPoint(cc.p(0.5, 0.5))
    editBox:setFontSize(26)
    editBox:setFontColor(cc.WHITE)
    editBox:setInputMode(cc.EDITBOX_INPUT_MODE_ANY)
    editBox:setPosition(cc.p(winSize.width / 2, 0.3*winSize.height))

    return editBox
end

function TestBattleLayer:_genRoundText(curr)
    return '回合 : ' .. tostring(curr)
end

return TestBattleLayer
