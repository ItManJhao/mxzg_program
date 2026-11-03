local BattleHeroInfoNode = class('BattleHeroInfoNode', cc.Node)

local NODE_SIZE = cc.size(140, 30)

-- common
local PROC_BG_PATH = 'hero/progress-hp-bg.png'
local PROC_BG_SCALE = 0.5
local PROC_BAR_OFFSET = 3.25

-- hp bar
local HP_BAR_PROC_GREEN_PATH = 'hero/progress-hp-green.png'
local HP_BAR_PROC_BG_OFFSET = 5

-- energy bar
local ENERGY_BAR_PROC_BLUE_PATH = 'hero/progress-hp-blue.png'
local ENERGY_BAR_PROC_BG_OFFSET = -5

-- assist icon
local ASSIST_ICON_PATH = "lang-1/spr-assist.png"

-- level label
local LEVEL_LABEL_FONT_SIZE = 30
local LEVEL_LABEL_OL_SIZE = 2

-- element
local elemResPath = function(element)
    local tpl = 'hero-icon/elem-%d.png'
    return string.format(tpl, element)
end
local ELEM_SCELE_FACTOR = 30

--[[
    initData : 英雄面板的初始化数据
    {
        level      : <int>    英雄的等级
        hp         : <int>    英雄血量
        max_hp     : <int>    英雄的最大血量
        energy     : <int>    英雄的能量值
        max_energy : <int>    英雄的最大能量值
        element    : <int>    英雄的元素标识
        isAssist   : <bool>   英雄是否为助阵英雄
    }
]]
function BattleHeroInfoNode:ctor(initData)
    self._level     = initData.level or 0
    self._hp        = initData.hp or 0
    self._maxHp     = initData.max_hp or 0
    self._energy    = initData.energy or 0
    self._maxEnergy = initData.max_energy or 0
    self._element   = initData.element or 0
    self._isAssist  = initData.isAssist or false

    self._hpBar = nil
    self._energyBar = nil
    
    self:_initHpBar()
    -- self:_initEnergyBar()
    self:_initLevelLabel()
    self:_initElemSprite()

    self:_updateHpBar()
    -- self:_updateEnergyBar()

    if self._isAssist then
        self:_initAssistIcon()
    end
end

function BattleHeroInfoNode:updateHp(percentage)
    self._hpBar:setPercentage(percentage)
end

-- function BattleHeroInfoNode:updateEnergy(percentage)
--     self._energyBar:setPercentage(percentage)
-- end

function BattleHeroInfoNode:getLevel() return self._level end
function BattleHeroInfoNode:getHp() return self._hp end
function BattleHeroInfoNode:getMaxHp() return self._maxHp end
function BattleHeroInfoNode:getEnergy() return self._energy end
function BattleHeroInfoNode:getMaxEnergy() return self._maxEnergy end
function BattleHeroInfoNode:getElement() return self._element end

function BattleHeroInfoNode:setHp(hp)
    self._hp = hp
    self:_updateHpBar()
end

function BattleHeroInfoNode:setMaxHp(maxHp)
    self._maxHp = maxHp
    self:_updateHpBar()
end

function BattleHeroInfoNode:setEnergy(energy)
    self._energy = energy
    -- self:_updateEnergyBar()
end

function BattleHeroInfoNode:setMaxEnergy(maxEnergy)
    self._maxEnergy = maxEnergy
    -- self:_updateEnergyBar()
end

function BattleHeroInfoNode:_updateHpBar()
    local percentage = 100.0 * self._hp / self._maxHp
    self._hpBar:setPercentage(percentage)
end

-- function BattleHeroInfoNode:_updateEnergyBar()
--     local percentage = 100.0 * self._energy / self._maxEnergy
--     self._energyBar:setPercentage(percentage)
-- end

function BattleHeroInfoNode:_initHpBar()
    local bg = cc.Sprite:createWithSpriteFrameName(PROC_BG_PATH)
    bg:setPositionY(HP_BAR_PROC_BG_OFFSET)
    bg:setScale(PROC_BG_SCALE)
    self:addChild(bg)

    local greenBar = cc.Sprite:createWithSpriteFrameName(HP_BAR_PROC_GREEN_PATH)
    self._hpBar = cc.ProgressTimer:create(greenBar)
    self:_initProgressTimer(self._hpBar)
    self._hpBar:setPosition(bg:getAnchorPointInPoints())
    self._hpBar:setPositionY(self._hpBar:getPositionY() + PROC_BAR_OFFSET)
    bg:addChild(self._hpBar)

    self:_updateHpBar()
end

-- function BattleHeroInfoNode:_initEnergyBar()
--     local bg = cc.Sprite:createWithSpriteFrameName(PROC_BG_PATH)
--     bg:setPositionY(ENERGY_BAR_PROC_BG_OFFSET)
--     bg:setScale(PROC_BG_SCALE)
--     self:addChild(bg)

--     local blueBar = cc.Sprite:createWithSpriteFrameName(ENERGY_BAR_PROC_BLUE_PATH)
--     self._energyBar = cc.ProgressTimer:create(blueBar)
--     self:_initProgressTimer(self._energyBar)
--     self._energyBar:setPosition(bg:getAnchorPointInPoints())
--     self._energyBar:setPositionY(self._hpBar:getPositionY() + PROC_BAR_OFFSET)
--     bg:addChild(self._energyBar)

--     self:_updateEnergyBar()
-- end

function BattleHeroInfoNode:_initLevelLabel()
    local label = cc.Label:createWithTTF(tostring(self._level), FONT_DEFAULT_NAME_BOLD, LEVEL_LABEL_FONT_SIZE)
    label:setAnchorPoint(cc.p(1.0, 0.5))
    label:enableOutline(ex.c3b.BLACK, LEVEL_LABEL_OL_SIZE)
    self:addChild(label)
    label:setPositionX(-NODE_SIZE.width/2)
end

function BattleHeroInfoNode:_initElemSprite()
    local path = elemResPath(self._element)
    local elemSprite = cc.Sprite:createWithSpriteFrameName(path)
    self:addChild(elemSprite)

    local elemSize = elemSprite:getContentSize()
    elemSprite:setScale(ELEM_SCELE_FACTOR / elemSize.width)
    elemSprite:setPositionX(-NODE_SIZE.width/2 + (elemSize.width*elemSprite:getScale()/2))
end

function BattleHeroInfoNode:_initProgressTimer(pt)
    pt:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    pt:setBarChangeRate(cc.p(1, 0))
    pt:setMidpoint(cc.p(0,0))
end

function BattleHeroInfoNode:_initAssistIcon()
    local assistSprite = cc.Sprite:createWithSpriteFrameName(ASSIST_ICON_PATH) or cc.Sprite:create()
    self:addChild(assistSprite)

    local assistSize = assistSprite:getContentSize()
    assistSprite:setScale(1.5)
    assistSprite:setPositionX(NODE_SIZE.width / 2 - 30 + (assistSize.width * assistSprite:getScale() / 2))
end

return BattleHeroInfoNode
