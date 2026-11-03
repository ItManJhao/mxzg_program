local EventLayer = class("EventLayer",  require("src.comp.LuaLayerBase"))

function EventLayer:onEventLayerExit()
    if self.exit_callback then
        self.exit_callback()
    end
    self:removeRedDotNodeExit()
    self:removeTimerByExit()
    self:removeEvent()
    self:onExit()
end

function EventLayer:setExitCallback(callback)
    self.exit_callback = callback;
end

function EventLayer:addTimer(name,time,callFunc,loop,data)
    if not self.timerList then self.timerList = {} end
    if self.timerList[name] ~= nil then print("has timer") return end
    self.timerList[name] = ex.Timer:addTimer(time, callFunc, loop, data)
end

function EventLayer:getTimerByName(name)
    if not self.timerList then self.timerList = {} end
    return self.timerList[name]
end

function EventLayer:removeTimerByName(name)
    if not self.timerList then return end
    if not self.timerList[name] then return end
    ex.Timer:removeTimerById(self.timerList[name])
    self.timerList[name] = nil
end

function EventLayer:removeTimerByExit()
    if self.timerList then
        for k,v in pairs(self.timerList) do
            ex.Timer:removeTimerById(v)
        end
        self.timerList = nil
    end
end

function EventLayer:addEvent(event,listener)
    if not self.eventList then self.eventList = {} end
    table.insert(self.eventList,ex.EventManager:add(event,listener))
end

function EventLayer:removeEvent()
    if self.eventList then
        for k,v in pairs(self.eventList) do
            ex.EventManager:remove(v)
        end
        self.eventList = nil
    end
end

function EventLayer:addRedDotNode(type, node)
    if not self.vec_reddot_node then
        self.vec_reddot_node = {}
    end

    self.vec_reddot_node[type] = node
    ex.RedDotManager:setStickNode(type, node)
end

-- 每天只出现一次的红点
function EventLayer:addRedDotNodeOnce(type, node)
    -- key格式  "rednode-role_id-type"
    -- local key = string.format("rednode-%s-%d", ex.Player.role_id, type)
    -- local now_day = Maths.getDays(cpp.Game:instance():getServerTime())
    -- local tag = cc.UserDefault:getInstance():getIntegerForKey(key, -1)
    
    -- 存贮的时间不是今天。则显示该红点
    -- if tag ~= now_day then
    --     self:addRedDotNode(type, node)
    --     cc.UserDefault:getInstance():setIntegerForKey(key, now_day)
    -- end

    if ex.Tools:getRedDotOnceDayStatus(type, true) then
        self:addRedDotNode(type, node)
    end
end


function EventLayer:removeRedDotNodeExit()
    if not self.vec_reddot_node then
        return
    end

    for k,v in pairs(self.vec_reddot_node) do
        ex.RedDotManager:removeStickNode(k, v)
    end
end

function EventLayer:onExit()

end

function EventLayer:setKeepForever(b)
    self.is_keep_forever = b
end

--[[
    battle_type: 战斗类型
    keep_type: 战斗结束时会返回到这个界面
    layer_type: 战斗界面的类型
    map: 资源名称
    evt_start: 战报通过该事件发送过来
    end_callback: 战斗结束时，会调用该函数
    map_pos: 地图位置 - 可缺省
    map_size: 地图大小 - 可缺省
]]
function EventLayer:addBattleLayer(battle_type, keep_type, map, evt_start, end_callback, map_pos, map_size)
    if self.battle_layer then
        return self.battle_layer, false
    end

    -- 让当前的层不会被回收
    if keep_type ~= nil then
        self.keep_type = keep_type
        ex.MainSceneCtr:addKeepLayer(keep_type)
    end
    
    self.battle_layer = require("src.comp.BattleReportBaseLayer"):create()
    self.battle_layer.creator = self
    self.battle_layer:initData(battle_type, map, evt_start, end_callback, map_pos, map_size)
    self:addChild(self.battle_layer, 999)
    return self.battle_layer, true
end

--[[
    battle_type: 战斗类型
    keep_type: 战斗结束时会返回到这个界面
    layer_type: 战斗界面的类型
    map: 资源名称
    evt_start: 战报通过该事件发送过来
    end_callback: 战斗结束时，会调用该函数
    map_pos: 地图位置 - 可缺省
    map_size: 地图大小 - 可缺省
]]
function EventLayer:addBattleLayerAuto(battle_type, keep_type, layer_type, map, evt_start, end_callback, map_pos, map_size)
    -- 让当前的层不会被回收
    local battle_layer, is_life = self:addBattleLayer(battle_type, keep_type, map, evt_start, end_callback, map_pos, map_size)
    battle_layer.parent_layer_type = keep_type
    battle_layer.battle_layer_type = layer_type
    battle_layer:setRecoveryType(RecoveryType.RT_REMOVE_PARENT)
    return battle_layer, is_life
end

function EventLayer:removeBattleLayer()
    local remove_keep_type = self.battle_layer.remove_keep_type
    self.battle_layer:removeFromParent()
    self.battle_layer = nil

    if self.is_keep_forever ~= true and self.keep_type ~= nil and remove_keep_type == true then
        ex.MainSceneCtr:removeKeepLayer(self.keep_type)
    end
end

function EventLayer:resetScaleAtWidth(is_full, margin)
    local margin_width = margin or 10
    margin_width = (is_full == true and margin == nil) and 0 or margin_width
    local content_size = self:getContentSize()
    if content_size.width > ex.p.width or is_full == true then
        self:setScale((ex.p.width - margin_width * 2) / content_size.width)
    end
end

function EventLayer:addBlackBackground()
    local win_size = cc.Director:getInstance():getWinSize()
    self:removeChildByName("layer_background_black")

    local layer_color = cc.Scale9Sprite:createWithSpriteFrameName("win-bg/spr-black-1.png",cc.rect(4,4,2,2)) or cc.Sprite:create()
    -- layer_color:setScale(1.5)
    layer_color:setName("layer_background_black")
    layer_color:setIgnoreAnchorPointForPosition(false)
    layer_color:setContentSize(cc.size((win_size.width + 100) / self:getScaleX(), (win_size.height + 300) / self:getScaleY()))
    -- layer_color:setAnchorPoint(cc.p(0.5, 0.5))
    layer_color:setPosition(self:getContentSize().width * 0.5, self:getContentSize().height * 0.5)
    self:addChild(layer_color, -99)
    
    layer_color:runAction(cc.ScaleTo:create(0.2, 1))
    return layer_color
end

return EventLayer
