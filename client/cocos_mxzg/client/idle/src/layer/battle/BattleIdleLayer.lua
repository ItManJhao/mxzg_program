local BattleIdleLayer = class("BattleIdleLayer", require("src.comp.EventLayer"))

local BattleController = require('src.controller.BattleController')

local SCROLL_BG_OFFSET = -400

function BattleIdleLayer:onCreate()
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

function BattleIdleLayer:initData(data, map_pos, map_size)
    local battle_end = function(layer, data)
        return false, false
    end

    self.battle_layer = self:addBattleLayer(BattleType.IDLE,
                                            MainSceneType.MLT_BATTLE,
                                            nil,
                                            nil,
                                            battle_end)

    self.battle_layer:setRemoveKeepType(false)
    self.battle_layer:removeTimer()
    if map_pos and map_size then
        self.battle_layer:setMapPos(map_pos)
        self.battle_layer:setMapSize(map_size)
    end

    self._firstBattle = true
    self:_initScrollNode()

    -- 当前关卡ID
    self._hangBattleId = nil
    self._nowIdx = nil
    self._currChapterMonsters = nil
    self._btReportCache = {}
    
    self.battle_layer.battle_info:setVisible(false)

    self._battlefieldLayer = cc.Node:create()
    self._battlefieldLayer:setPosition(map_pos)
    self._battlefieldLayer:setContentSize(map_size)
    self.battle_layer:addChild(self._battlefieldLayer)
    
    self._btController = BattleController.new(self._battlefieldLayer, {
        enabledPlaySpeed = false
    })
    
    self._btController:setRetainPlayerHeroes(true)
    self._btController:setIsShowAttackingTips(false)
    self._btController:setEnabledHeroTalk(true)
    self._btController:setIsShowBuffTip(false)

    self._btController:addEventListener(BattleController.Event.BattleEnd, function()
        self:_run()
    end)
    self._btController:addEventListener(BattleController.Event.HeroDead, function(evt)
        self:_heroDeadHandler(evt)
    end)
    self.battle_layer.battle_ctr = self._btController
    self:addEvent(EVENT.BATTLE_EVENT.HANG_BATTLE, handler(self,self._updateReportCache))
    self:addEvent(EVENT.BATTLE_EVENT.HANG_LINE_UP, handler(self, self._updateCache))
    
    self:_playHangBattle()
end

function BattleIdleLayer:_playHangBattle()
    if self._btController:isPlaying() then return end
    if ex.Player.chapter_data.chapter_id <= 0 then return end
    self:_updateHangData()

    self._btController:standWithRretainedHeroes()

    local chapterIndex = math.random(1, #self._currChapterMonsters)
    local chapterIdx = self._currChapterMonsters[chapterIndex].idx

    local index = math.random(0, 2)
    local hangBtId = self:_genHangBattleId(index, chapterIdx)
    local btReport = self._btReportCache[hangBtId]
    
    if btReport == nil then
        local req = Battle_pb.GReqChapterReport()
        req.firstPos = index
        req.chapterIdx = chapterIdx
        NetManager:sendMessage(ProtocolID.GReqChapterReport, req)
    else
        self:_startHangBattle(btReport)
    end
end

function BattleIdleLayer:_startHangBattle(btReport)
    self._btController:play(btReport, {
        hasEnter = false
    })

    if self._firstBattle then
        self._btController:forceStop()
        self:_run()
    end

    self._firstBattle = false
end

function BattleIdleLayer:_heroDeadHandler(evt)
    local layerPos = cc.p(
        self._battlefieldLayer:getPositionX(),
        self._battlefieldLayer:getPositionY()
    )
    ex.EventManager:fire(EVENT.BATTLE_EVENT.HANG_HERO_DEAD, cc.pAdd(
        layerPos,
        evt.heroData:getPosition()
    ))
end

function BattleIdleLayer:_updateHangData()
    local nowIdx = math.max(ex.Player.chapter_data.chapter_id, 1)

    if self._nowIdx ~= nowIdx then
        self._nowIdx = nowIdx
        self:_updateCache()
    end
end

function BattleIdleLayer:_updateCache()
    if ex.Player.chapter_data.chapter_id <= 0 then return end
    
    self._currChapterMonsters = ex.Player.chapter_data:getMonsterByChapter(self._nowIdx)
    self._btReportCache = {}
end

function BattleIdleLayer:_updateReportCache(evt, btHangData)
    local btReport = btHangData.report
    local playerHeroes = btReport.attacker.heros
    
    local hangBtId = self:_genHangBattleId(btHangData.firstPos, btHangData.chapterIdx)
    self._btReportCache[hangBtId] = btReport

    if not self._btController:isPlaying() then
        self:_startHangBattle(btReport)
    end
end

function BattleIdleLayer:_genHangBattleId(index, nowIdx)
    return tostring(index) .. '.' .. tostring(nowIdx)
end

function BattleIdleLayer:_run()
    self._isRoll = true
    self:_initScrollNode()
    self._btController:runWithRretainedHeroes()
end

function BattleIdleLayer:_initScrollNode()
    local chapterFile = ex.Player.chapter_data:getChapterHangMap()
    local chapterBgFile = ex.Player.chapter_data:getChapterHangMapBackground()

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

    self.battle_layer:addChild(chapterMapBg1, -1)
    self.battle_layer:addChild(chapterMapBg2, -1)

    self.battle_layer:addChild(chapterMap1, -1)
    self.battle_layer:addChild(chapterMap2, -1)
    self.battle_layer:addChild(chapterMap3, -1)

    self._chapterMapBgList = {chapterMapBg1, chapterMapBg2}
    self._chapterMapList = {chapterMap1, chapterMap2, chapterMap3}

    self._mapWidth = chapterMap1:getContentSize().width
    self._mapBgWidth = chapterMapBg1:getContentSize().width

    self:_updateChapterMapAlways(0)
end

function  BattleIdleLayer:_updateChapterMap(dt)
    if not self._isRoll then return end

    self:_updateChapterMapAlways(dt)
end

function BattleIdleLayer:_updateChapterMapAlways(dt)
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
        self:_playHangBattle()
    end

    local nextPos = self._mapOriginPos
    for i,v in ipairs(self._chapterMapList) do
        v:setPositionX(nextPos)
        nextPos = nextPos + self._mapWidth
    end
end

function BattleIdleLayer:_createChapterMapSprite(file)
    local sprite = cc.Sprite:create(file)
    if not sprite then
        sprite = cc.Sprite:createWithSpriteFrameName(file)
    end

    if not sprite then
        sprite = cc.Sprite:create('ccbi-res/chapter/hang/map01_F.png')
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

function BattleIdleLayer:_createChapterMapBgSprite(file)
    local sprite = cc.Sprite:create(file)
    if not sprite then
        sprite = cc.Sprite:createWithSpriteFrameName(file)
    end

    if not sprite then
        sprite = cc.Sprite:create('ccbi-res/chapter/hang/map01_B.jpg')
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

return BattleIdleLayer
