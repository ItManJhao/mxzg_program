GlobalBattleHelper = {}

GlobalBattleHelper.LayerZOrder = {
    HeroBase       = 35000,
    Dragon         = 39900,
    FullEffect     = 20000,
    HittingHero    = 39000,
    ActionHeroBase = 39001,
    HeroEffect     = 40000,
    LabelLayer     = 50000,
    TopEffect      = 60000,
}

local TerminalLayer = require('src.layer.TerminalLayer')

local TERMINAL_LAYER_ZORDER = 1000000

--[[
    构建战斗scheduler和action manager，方便控制速度
]]
local defaultScheduler = cc.Director:getInstance():getScheduler()
local btScheduler = cc.Scheduler:new()
btScheduler:retain()
defaultScheduler:bindScheduleUpdate(btScheduler)

local btActionManager = cc.ActionManager:new()
btActionManager:retain()
btScheduler:bindActionManagerUpdate(btActionManager)

local btGTerminalLayer = nil

local createTerminalLayer = function()
    local runningScene = display.getRunningScene()
    local sceneSize = runningScene:getContentSize()
    local terminalLayer = TerminalLayer.new()
    terminalLayer:setScrollViewSize(cc.size(
        sceneSize.width,
        0.8 * sceneSize.height
    ))
    terminalLayer:setPosition(cc.p(
        0,
        0.1 * sceneSize.height
    ))
    terminalLayer:setLocalZOrder(TERMINAL_LAYER_ZORDER)
    terminalLayer:setVisible(false)
    runningScene:addChild(terminalLayer)

    return terminalLayer
end

local getTerminalLayer = function()
    if btGTerminalLayer == nil then
        btGTerminalLayer = createTerminalLayer()
    end

    return btGTerminalLayer
end

--[[
    绑定战斗专属的全局调度器和动作管理器
]]
GlobalBattleHelper.bindScheduler = function(node)
    node:setScheduler(GlobalBattleHelper.getScheduler())
    node:setActionManager(GlobalBattleHelper.getActionManager())
end

--[[
    战斗专属的全局调度器
]]
GlobalBattleHelper.getScheduler = function()
    return btScheduler
end

--[[
    战斗专属的全局动作管理器
]]
GlobalBattleHelper.getActionManager = function()
    return btActionManager
end

GlobalBattleHelper.getSchedulerTimeScale = function()
    return btScheduler:getTimeScale()
end

GlobalBattleHelper.openTerminalLayer = function()
    if cpp.SocialPlatform:instance():isDebug() then
        getTerminalLayer():setVisible(true)
    end
end

GlobalBattleHelper.print = function(str)
    if cpp.SocialPlatform:instance():isDebug() then
        getTerminalLayer():print(str)
    end
end

GlobalBattleHelper.println = function(str)
    if cpp.SocialPlatform:instance():isDebug() then
        getTerminalLayer():println(str)
    end
end
