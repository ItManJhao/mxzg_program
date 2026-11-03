local FloatingIslandsCtr = class("FloatingIslandsCtr", require("src.ex.BaseCtr"))


function FloatingIslandsCtr:onInit()
    self.data = require("src.layer.floatingislands.FloatingIslandsData"):create()
    -- self.data2 = "123123"
    -- self:startTimer()
end

function FloatingIslandsCtr:startTimer()
    if self.is_ctr_start_time then return end
    self.is_ctr_start_time = true
    self:addTimer("update", 30000, handler(self, self.updateStatus), true)
end    

function FloatingIslandsCtr:updateStatus()
    local server_time = ex.Game:getServerTime()
    -- ex.MessageView:add(string.format("next = %s, diff = %s", self.data.next_time, self.data.next_time - server_time))
    if self.data.next_time > 0 and self.data.next_time < server_time then  
        NetManager:sendMessage(ProtocolID.GReqFloatingIslandsTime)
    end
end

function FloatingIslandsCtr:startBattle()
    local battle_layer = ex.Tools:addBattleLayerAuto(self.layer,
                                                    BattleType.FLOATING_ISLANDS,
                                                    MainSceneType.MAINCITY_FLOATING_ISLANDS_BOSS1,
                                                    MainSceneType.MAINCITY_FLOATING_ISLANDS_BOSS_BATTLE,
                                                    "", 
                                                    EVENT.FLOATING_ISLANDS.BATTLE_BOSS_BATTLE,
                                                    function(layer, data, vec_reward, ext)
                                                        require("src.layer.chapterend.ChapterEndCtr"):instance():openWindow({
                                                            battle_type = layer.battle_type,
                                                            is_win = true,
                                                            vec_reward = layer.vec_reward,
                                                            detail = layer.report.log,
                                                            data = layer.ext,
                                                        })
                                                        return true, false
                                                    end)
end

return FloatingIslandsCtr