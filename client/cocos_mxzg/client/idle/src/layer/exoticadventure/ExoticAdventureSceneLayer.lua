--[[
* @Description: 异界冒险-航行界面移动
* @Author: 熊梦
* @Date: 2020-07-30 18:00:00
* ]]
local ExoticAdventureSceneLayer = class("ExoticAdventureSceneLayer", require("src.comp.EventLayer"))

local BattleController = require('src.controller.BattleController')

local SCROLL_BG_OFFSET = -400

function ExoticAdventureSceneLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self._mapRollingSpeed = 120
    self._mapBgRollingSpeed = 20
    self._isRoll = false
    self._chapterMapList = {}
    self._chapterMapBgList = {}
    self._mapOriginPos = 0
    self._mapBgOriginPos = 0
    self._mapWidth = 0
    self._mapBgWidth = 0

    self:onUpdate(function(dt)
        self:_updateChapterMap(dt)
    end)
end

function ExoticAdventureSceneLayer:initData(data, map_pos, map_size)
    local battle_end = function(layer, data)
        return false, false
    end
    self:_initScrollNode()
end


function ExoticAdventureSceneLayer:_run()
    self._isRoll = true
    self:_initScrollNode()
    -- self._btController:runWithRretainedHeroes()
end

function ExoticAdventureSceneLayer:_initScrollNode()
    
    local chapterFile = string.format("ccbi-res/chapter_exoticadventure/hang/%s_F.png", ex.Player.exotic_adventure_data.not_route)
    local chapterBgFile = string.format("ccbi-res/chapter_exoticadventure/hang/%s_B.jpg", ex.Player.exotic_adventure_data.not_route)
    
    if self._currChapterFile == chapterFile then return end
    self._currChapterFile = chapterFile

    for i,v in ipairs(self._chapterMapList) do
        v:removeFromParent()
    end

    for i,v in ipairs(self._chapterMapBgList) do
        v:removeFromParent()
    end

    local chapterMap1 = self:_createChapterMapSprite(chapterFile)
    local chapterMap2 = self:_createChapterMapSprite(chapterFile)
    local chapterMap3 = self:_createChapterMapSprite(chapterFile)
    
    local bgBaseY = chapterMap1:getContentSize().height + SCROLL_BG_OFFSET
    local chapterMapBg1 = self:_createChapterMapBgSprite(chapterBgFile)
    local chapterMapBg2 = self:_createChapterMapBgSprite(chapterBgFile)

    self:addChild(chapterMapBg1, -1)
    self:addChild(chapterMapBg2, -1)

    self:addChild(chapterMap1, -1)
    self:addChild(chapterMap2, -1)
    self:addChild(chapterMap3, -1)

    self._chapterMapBgList = {chapterMapBg1, chapterMapBg2}
    self._chapterMapList = {chapterMap1, chapterMap2, chapterMap3}

    self._mapWidth = chapterMap1:getContentSize().width
    self._mapBgWidth = chapterMapBg1:getContentSize().width

    self:_updateChapterMapAlways(0)
end

function  ExoticAdventureSceneLayer:_updateChapterMap(dt)
    --if not self._isRoll then return end
    self:_updateChapterMapAlways(dt)
end

function ExoticAdventureSceneLayer:_updateChapterMapAlways(dt)
    self._mapBgOriginPos = self._mapBgOriginPos - (dt * self._mapBgRollingSpeed)
    if math.abs(self._mapBgOriginPos) >= self._mapBgWidth then
        self._mapBgOriginPos = 0
    end

    local bgNextPos = self._mapBgOriginPos
    for i,v in ipairs(self._chapterMapBgList) do
        v:setPositionX(bgNextPos)
        bgNextPos = bgNextPos + self._mapBgWidth
    end

    ----------

    self._mapOriginPos = self._mapOriginPos - (dt * self._mapRollingSpeed)
    if math.abs(self._mapOriginPos) >= self._mapWidth then
        self._mapOriginPos = 0
        self._isRoll = false
    end

    local nextPos = self._mapOriginPos
    for i,v in ipairs(self._chapterMapList) do
        v:setPositionX(nextPos)
        nextPos = nextPos + self._mapWidth
    end
end

function ExoticAdventureSceneLayer:_createChapterMapSprite(file)
    local sprite = cc.Sprite:create(file)
    if not sprite then
        sprite = cc.Sprite:createWithSpriteFrameName(file)
    end

    if not sprite then
        sprite = cc.Sprite:create('ccbi-res/chapter_exoticadventure/hang/map01_F.jpg')
    end

    if not sprite then
        sprite = cc.Sprite:create()
    end

    if sprite then
        local spriteSize = sprite:getContentSize()
        sprite:setPosition(cc.p(0,0))
        sprite:setAnchorPoint(cc.p(0, 0))
    end

    return sprite
end

function ExoticAdventureSceneLayer:_createChapterMapBgSprite(file)
    local sprite = cc.Sprite:create(file)
    if not sprite then
        sprite = cc.Sprite:createWithSpriteFrameName(file)
    end

    if not sprite then
        sprite = cc.Sprite:create('ccbi-res/chapter_exoticadventure/hang/map01_B.jpg')
    end

    if not sprite then
        sprite = cc.Sprite:create()
    end

    if sprite then
        local spriteSize = sprite:getContentSize()
        sprite:setPosition(cc.p(0, ex.p.height - spriteSize.height))
        sprite:setAnchorPoint(cc.p(0, 0))
    end

    return sprite
end

return ExoticAdventureSceneLayer
