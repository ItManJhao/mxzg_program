local BattleMissionLayer = class("BattleMissionLayer", require("src.comp.EventLayer"))

function BattleMissionLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self:addEvent(EVENT.BATTLE_EVENT.BATTLE_END, handler(self, self.removeBattleTimer))
end

function BattleMissionLayer:setInfoLayer(node, y)
    self.battle_layer.battle_info:retain()
    self.battle_layer.battle_info:removeFromParentAndCleanup(false)
    node:addChild(self.battle_layer.battle_info)
    self.battle_layer.battle_info:release()
end


function BattleMissionLayer:removeBattleTimer()
    self:removeTimerByName("timer_end")
end

function BattleMissionLayer:initData(data, map_pos, map_size)
    local battle_end = function(layer, data, vec_reward, ext)
        -- ex.EventManager:fire(EVENT.BATTLE_EVENT.BATTLE_END)
        -- local act_delay_end = cc.Sequence:create(cc.DelayTime:create(0.2), cc.CallFunc:create(function()
        --     ex.EventManager:fire(EVENT.BATTLE_EVENT.BATTLE_END, data.isWin, ex.Player.chapter_data.chapter_id)
        --     -- ex.EventManager:fire(EVENT.BACKPACK_RES_CHANGE.ROLE_LEVEL, ex.Player.level)
        --     	-- ex.EventManager:fire(EVENT.BATTLE_EVENT.BATTLE_END, true, ex.Player.chapter_data.now_idx)
        -- end))
        -- act_delay_end:setTag(9996)
        -- self:getParent():stopActionByTag(9996)
        -- self:getParent():runAction(act_delay_end)

        if data.isWin then
            -- 战斗胜利。发送领取奖励
            NetManager:sendMessage(ProtocolID.GReqChapterEnd)

            self:addTimer("timer_end", 2000, function()
                NetManager:sendMessage(ProtocolID.GReqChapterEnd)
            end, true)
        else
            require("src.layer.chapterend.ChapterEndCtr"):instance():openWindow({
                is_win = false,
                detail = self.battle_layer.report.log,
            })
            ex.EventManager:fire(EVENT.BATTLE_EVENT.BATTLE_END, data.isWin, ex.Player.chapter_data.chapter_id)
        end
        return false, false
    end

    -- 超时没收到战斗回调
    local time_out = function()
        ex.EventManager:fire(EVENT.BATTLE_EVENT.BATTLE_END)
    end

    self.battle_layer = self:addBattleLayer(BattleType.CHAPTER,
                                            MainSceneType.MLT_BATTLE,
                                            ex.Player.chapter_data:getChapterMap(),
                                            EVENT.BATTLE_EVENT.BATTLE_START,
                                            battle_end)
    self.battle_layer:setRemoveKeepType(false)
    -- self.battle_layer:removeTimer()
    self.battle_layer.time_out = time_out
    if map_pos and map_size then
        self.battle_layer:setMapPos(map_pos)
        self.battle_layer:setMapSize(map_size) 
    end
    -- self.battle_layer:battleStart(nil, data.report, {})
    self.battle_layer.battle_info:setPositionY(map_pos.y - 10)
    local battle_layer = self.battle_layer
    self.battle_layer:setExitCallback(function()
        -- if tolua.isnull(self) or tolua.isnull(self.battle_layer) or tolua.isnull(self.battle_layer.battle_info) then
        --     return
        -- end
        -- print(tolua.isnull(self), tolua.isnull(self.battle_layer), tolua.isnull(self.battle_layer.battle_info))
        -- self.battle_layer.battle_info:removeFromParent()
        battle_layer.battle_info:runAction(cc.RemoveSelf:create())
    end)
end

return BattleMissionLayer