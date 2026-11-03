local BattleGuideLayer = class("BattleGuideLayer", require("src.comp.EventLayer"))

function BattleGuideLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    -- ex.EventManager:fire(EVENT.BATTLE_EVENT.GUIDE_BATTLE_CREATE, data)
    -- ex.EventManager:fire(EVENT.BATTLE_EVENT.GUIDE_BATTLE_START, data)
    self:addEvent(EVENT.BATTLE_EVENT.GUIDE_BATTLE_START, handler(self, self.continuePlay))
end

function BattleGuideLayer:initData(data, map_pos, map_size)
    local battle_end = function(layer, data)
        -- ex.EventManager:fire(EVENT.BATTLE_EVENT.BATTLE_END)
        require("src.layer.guide.GuideCtr"):battlePreviewEnd()
        return false, false
    end

    -- 超时没收到战斗回调
    local time_out = function()
        ex.EventManager:fire(EVENT.BATTLE_EVENT.BATTLE_END)
    end

    self.battle_layer = self:addBattleLayer(BattleType.CHAPTER,
                                             MainSceneType.MLT_BATTLE,
                                             ex.Player.chapter_data:getChapterMap(),
                                             nil,
                                             battle_end)
    self.battle_layer:setRemoveKeepType(false)
    self.battle_layer:setPause(true)
    self.battle_layer:removeTimer()
    self.battle_layer.time_out = time_out
    if map_pos and map_size then
        self.battle_layer:setMapPos(map_pos)
        self.battle_layer:setMapSize(map_size) 
    end
    self.battle_layer.battle_info:setVisible(false)
    self.battle_layer:battleStart(nil, json.decode(cc.FileUtils:getInstance():getStringFromFile("config/battlepre.txt")), {})

    -- ex.Tools:autoPlaySceneMusic()
    ex.AudioManager:playMusic(string.format("music/battle-%d.mp3", 1))
end

function BattleGuideLayer:continuePlay()
    self.battle_layer:continuePlay()
end

return BattleGuideLayer