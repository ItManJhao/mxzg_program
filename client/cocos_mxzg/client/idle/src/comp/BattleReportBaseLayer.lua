local BattleReportBaseLayer = class("BattleReportBaseLayer",  require("src.comp.EventLayer"))

-- local music = 
-- 所有加载过的地图都会缓存在这里。由调度器释放

-- 该界面有三部分组成
-- battle_ctr ： 控制战斗
-- battle_info ： 显示双方名字阵型和功能按钮
-- self
-- 


local vec_map = {
}

function BattleReportBaseLayer:onCreate()
    -- 创造这个界面的节点
    self.creator = nil

    self.battle_type = 0    -- battletype.xlsx 表结构控制
    self.battle_layer_type = 0
    self.parent_layer_type = 0

    self.options = {}
    self.options.showedHeroPause = false

    -- 天气效果层
    self.layer_weather = cc.Layer:create()
    self.layer_weather:setPosition(cc.p(0, 0))
    self:addChild(self.layer_weather, 100)

    -- 是否覆盖父节点类型。true：切换到父节点时。会强制切换到本界面。
    self.is_conflict = true

    -- 回收类型
    self.recovery_type = RecoveryType.RT_CO_EXIST
    self.remove_keep_type = true
    self.remove_parent_keep_type = true

    self.speed_level = 3
    self.speed = cc.UserDefault:getInstance():getIntegerForKey(string.format("%s-battle_speed", ex.Player.role_id), 0)

    -- 加载需要的资源
    local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("hero/hero.plist")
	sfc:addSpriteFrames("ccbi-res/lang-1.plist")

    self:setContentSize(cc.size(ex.p.width, ex.p.height))
    self.btf_layer = cc.Node:create()
    self:addChild(self.btf_layer)

    self.battle_info = require("src.layer.battle.BattleInfoLayer"):createWithCCBIFile("ccbi/BattleInfoLayer.ccbi")
    self.battle_info:setPosition(cc.p(0, ex.MainSceneCtr:getBottomHeight()))
    self.battle_info:setSpeedHandler(handler(self, self.onSpeed))
    self.battle_info:setSkipHandler(handler(self, self.onSkip))
    self.battle_info:setCloseHandler(handler(self, self.onClose))
    self:addChild(self.battle_info, 99999)

    self.listener = cc.EventListenerTouchOneByOne:create()  --创建一个单点事件监听
    self.listener:setSwallowTouches(true)
    self.listener:registerScriptHandler(function(touch, event) 
        local touchLocation = touch:getLocation()
        touchLocation = self:getParent():convertToNodeSpace(touchLocation)
        local bBox = self:getBoundingBox()
        return cpp.Game:isInVisible(self) and cc.rectContainsPoint(bBox, touchLocation)
    end, cc.Handler.EVENT_TOUCH_BEGAN )
    self.listener:registerScriptHandler(function(touch, event) end, cc.Handler.EVENT_TOUCH_MOVED )
    self.listener:registerScriptHandler(function(touch, event) end, cc.Handler.EVENT_TOUCH_ENDED )
    local event_dispatcher = self:getEventDispatcher() 
    event_dispatcher:addEventListenerWithSceneGraphPriority(self.listener, self)

    self:addTimer("time_out", 7000, handler(self, self.timeOut))

    self.battle_ctr = require("src.controller.BattleController").new(self.btf_layer)
    self.battle_ctr:addEventListener(self.battle_ctr.Event.BattleEnd, handler(self, self.battleEnd))
    self.battle_ctr:addEventListener(self.battle_ctr.Event.RoundStart, handler(self, self.roundStart))
    self.battle_ctr:addEventListener(self.battle_ctr.Event.ChangeWeather, handler(self, self.changeWeather))
    self:updateBattleSpeed()

    self:addEvent(EVENT.BATTLE_EVENT.CHANGE_LAYER, handler(self, self.changeEvent))
end

function BattleReportBaseLayer:removeTimer()
    self:removeTimerByName("time_out")
end

function BattleReportBaseLayer:timeOut()
    if self.time_out then
        self.time_out()
    end

    local cur_type = ex.MainSceneCtr:getCurLayerType()
    if self.recovery_type == RecoveryType.RT_REMOVE_PARENT then
        ex.MainSceneCtr:removeKeepLayer(self.battle_layer_type)
        if cur_type == self.battle_layer_type then
            ex.MainSceneCtr:changeLayer(self.parent_layer_type,nil, nil, true)
        end
    end

    if self.creator then
        self.creator.battle_layer = nil
    end

    self:removeFromParent()
end

function BattleReportBaseLayer:setRecoveryType(type) self.recovery_type = type end
function BattleReportBaseLayer:setRemoveKeepType(b) self.remove_keep_type = b end
function BattleReportBaseLayer:setConflict(b) self.is_conflict = b end
function BattleReportBaseLayer:showSpeedBtn(speed, skip) self.battle_info:showSpeedBtn(speed, skip) end
function BattleReportBaseLayer:setRemoveParentKeepType(v) self.remove_parent_keep_type = v end
function BattleReportBaseLayer:setPause(p) self.options.showedHeroPause = p end

function BattleReportBaseLayer:showCloseBtn(v)
    self.battle_info:showCloseBtn(v)
end


-- 必须设置
function BattleReportBaseLayer:setMapPos(pos) self.btf_layer:setPosition(pos) end
-- 必须设置
function BattleReportBaseLayer:setMapSize(size) self.btf_layer:setContentSize(size) end

-- 设置背景图片
function BattleReportBaseLayer:setMapBg(map_name, image)
    local file = ""
    if map_name then
        file = ex.Player.battle_data:getBattleMap(map_name)
        file = file or image
        file = file or map_name
    else
        file = image
    end

    if self.node_bg then
        self.node_bg:removeFromParent()
        self.node_bg = nil
    end

    local win_size = cc.Director:getInstance():getWinSize()
    
    local spr_bg = cc.Sprite:create(file)
    if not spr_bg then
        spr_bg = cc.Sprite:createWithSpriteFrameName(file)
    end

    if not spr_bg then
        print("file not found", file)
        spr_bg = cc.Sprite:create()
    end
    
    spr_bg:setScale((win_size.width + 10) / spr_bg:getContentSize().width, win_size.height / spr_bg:getContentSize().height)
    spr_bg:setPosition(win_size.width * 0.5, win_size.height * 0.5)

    self.node_bg = cc.Node:create()
    self.node_bg:setPosition(0, 0)
    self.node_bg:addChild(spr_bg)
    self:addChild(self.node_bg, -1)
end

-- 回合开始
function BattleReportBaseLayer:roundStart(evt)
    -- local aa = 0
    self.battle_info:setRound(nil, {cur_round = evt.roundNumber, all = 15})
    
    ex.EventManager:fire(EVENT.BATTLE_EVENT.UPDATE_ROUND, self, evt)
end

-- 继续战斗
function BattleReportBaseLayer:continuePlay()
    self.battle_ctr:continuePlay()
end

-- 战斗开始
function BattleReportBaseLayer:battleStart(evt, report, vec_reward, ext)
    self:removeTimer()

    if self.recovery_type == RecoveryType.RT_REMOVE_PARENT and ex.MainSceneCtr:getCurLayer() == self.creator then
        if self.creator then
            self.creator.battle_layer = nil
        end
        
        self:retain()
        self:removeFromParentAndCleanup(false)


        ex.MainSceneCtr:addBattleLayer(self.creator, self, self.battle_layer_type, self.is_conflict and self.parent_layer_type or nil)
        
        -- self:setVisible(true)

        if self.remove_parent_keep_type then
            ex.MainSceneCtr:removeKeepLayer(self.parent_layer_type)
        end
        self:release()
    end

    self.ext = ext
    self.vec_reward = vec_reward
    self.report = report
    self.battle_ctr:play(report, self.options)

    -- 解析阵营和名字
    local data = {}
    data.name1 = report.attacker.name
    data.name2 = report.defender.name
    data.contract1 = report.attacker.formation_id or 0
    data.contract2 = report.defender.formation_id or 0
    
    local getHeroTpye = function(heros)
        local vec_type = {}
        for i,v in ipairs(heros) do
            table.insert(vec_type, v.hero_id)
        end
        return vec_type
    end
    data.vec_type = {}
    table.insert(data.vec_type, getHeroTpye(report.attacker.heros))
    table.insert(data.vec_type, getHeroTpye(report.defender.heros))
    self.battle_info:reset(data)

    self:showBattleStartAmin()
end

function BattleReportBaseLayer:showBattleStartAmin()
    -- local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_battle_start")
    -- spr_effect:setPosition(ex.p.width * 0.5, ex.p.height * 0.6)
    -- spr_effect:setScale(2)
    -- self:addChild(spr_effect, 0, 10)

    local bsSpine = sp.SkeletonAnimation:create("spine/ZDKS.json","spine/ZDKS.atlas", 1)
    bsSpine:setAnimation(0, "stand", false)
    bsSpine:setPosition(ex.p.width * 0.5, ex.p.height * 0.6)
    self:addChild(bsSpine, 0, 10)
end

-- 战斗结束
function BattleReportBaseLayer:battleEnd(data)
    local is_remove = true
    local is_show_reward = true

    self:changeWeather(WEATHER_TYPE.NIL)
    
    if self.end_callback then
        ex.Tools:try(function()
            is_remove, is_show_reward = self.end_callback(self, data, self.vec_reward, self.ext)
        end)
    end

    if is_show_reward then
        ex.Tools:try(function()
            self:showBattleReward(data)
        end)
    end

    if is_remove then
        if self.recovery_type == RecoveryType.RT_REMOVE_PARENT then
            local cur_layer = ex.MainSceneCtr:getCurLayerType()
            if cur_layer == self.battle_layer_type then
                ex.MainSceneCtr:removeKeepLayer(self.battle_layer_type)
                if  self.parent_layer_type ~= 0 then
                    ex.MainSceneCtr:changeLayer(self.parent_layer_type, nil,nil, true)
                end
            else
                -- ex.MainSceneCtr:removeKeepLayer(self.parent_layer_type)
                ex.MainSceneCtr:removeKeepLayer(self.battle_layer_type)
            end
        else
            if self.creator and self.creator.removeBattleLayer then
                self.creator:removeBattleLayer()
            else
                self:removeFromParent()
            end
        end
    else
    end
end

function BattleReportBaseLayer:showBattleReward(data)
    require("src.layer.chapterend.ChapterEndCtr"):instance():openWindow({
        battle_type = self.battle_type,
        is_win = data.isWin,
        vec_reward = self.vec_reward,
        detail = self.report.log,
        data = self.ext,
    })
end

-- 更换天气
function BattleReportBaseLayer:changeWeather(weather_type)
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
function BattleReportBaseLayer:_playWeatherThunder()
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
function BattleReportBaseLayer:_playWeatherThunderFadeOut()
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
function BattleReportBaseLayer:_playWeatherRain()

end

-- 执行雨天天气消失特效
function BattleReportBaseLayer:_playWeatherRainFadeOut()

end

-- 执行沙暴天气特效
function BattleReportBaseLayer:_playWeatherSand()

end

-- 执行沙暴天气消失特效
function BattleReportBaseLayer:_playWeatherSandFadeOut()

end

function BattleReportBaseLayer:initData(battle_type, map, evt_start, end_callback, map_pos, map_size)
    map_pos = map_pos or cc.p(0, ex.p.height * 0.15)
    map_size = map_size or cc.size(ex.p.width, ex.p.height * 0.7)
    
    self.battle_type = battle_type

    local image = nil
    if map == nil or map == "" then
        map = nil
        local battle_config = cfg.battletype.battletype[battle_type]
        if battle_config then
            image = "ccbi-res/chapter/" .. battle_config.map .. ".jpg"
        end
    end

    -- 地图
    self:setMapPos(map_pos)
    self:setMapSize(map_size)
    self:setMapBg(map, image)

    -- 协议回传的战报和奖励信息
    if evt_start then
        self:addEvent(evt_start, handler(self, self.battleStart))
    end

    -- 战斗结束的回调
    if end_callback then
        self.end_callback = end_callback
    end

    self.battle_info:setBattleType(self.battle_type)

    -- test
    -- self:changeWeather(WEATHER_TYPE.THUNDER)
end

function BattleReportBaseLayer:onSpeed()
    local speed = ((self.speed + 1) % 3)
    if ex.Player.battle_data:canChangeSpeed(self.battle_type, speed, true) then
        self.speed = speed
        self:updateBattleSpeed()
        cc.UserDefault:getInstance():setIntegerForKey(string.format("%s-battle_speed", ex.Player.role_id), self.speed)
    end
end

function BattleReportBaseLayer:updateBattleSpeed()
    GlobalBattleHelper.getScheduler():setTimeScale((self.speed * 0.25) + 1.5)
    ex.Tools:setSpriteFrame(self.battle_info.btn_speed:getNormalImage(), string.format("battle-scene/btn-speed-%d.png", self.speed + 1))
end

function BattleReportBaseLayer:onSkip()
    if not ex.Player.battle_data:canSkipBattle(self.battle_type, true) then
        return
    end
    self.battle_ctr:forceStop()
end

function BattleReportBaseLayer:onClose(tag,pSender)
    self.battle_ctr:forceStop()
end

function BattleReportBaseLayer:onEventLayerEnter()
    ex.Tools:autoPlaySceneMusic(0.02)
end

function BattleReportBaseLayer:onExit()
    ex.Tools:autoPlaySceneMusic(0.02)
end

function BattleReportBaseLayer:changeEvent(data, node, is_play)

    -- 没有好的方法。暂时这样
    if ex.Tools:isRelation(node, self) ~= true then
        return
    end

    is_play = (is_play ~= true) and true or false
    print("is_play", is_play)
    self.battle_ctr:setBackgroundPlay(is_play)
end

function BattleReportBaseLayer:changeLayerInEnd()
    self:changeEvent(nil, self, true)
end

-- 界面隐藏了
function BattleReportBaseLayer:changeLayerOutEnd()
    self:changeEvent(nil, self, false)
end

return BattleReportBaseLayer
