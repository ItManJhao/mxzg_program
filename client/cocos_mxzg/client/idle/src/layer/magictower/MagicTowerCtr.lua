local MagicTowerCtr = class("MagicTowerCtr", require("src.ex.BaseCtr"))

function MagicTowerCtr:addBattleLayer()
    local battle_layer = ex.Tools:addBattleLayerAuto(self.layer,
                                                    BattleType.MAGIC_TOWER,
                                                    MainSceneType.MAINCITY_MAGIC_TOWER,
                                                    MainSceneType.MAINCITY_MAGIC_TOWER_BATTLE,
                                                    "",
                                                    EVENT.MAGIC_TOWER_EVENT.BATTLE_START,
                                                    function(layer, data, vec_reward, ext)
                                                                ex.EventManager:fire(EVENT.MAGIC_TOWER_EVENT.BATTLE_END, data.isWin)
                                                                ex.Tools:autoPlaySceneMusic()

                                                                local chapter_end_ctr = require("src.layer.chapterend.ChapterEndCtr"):instance()
                                                                chapter_end_ctr:openWindowWithTower({is_win = data.isWin,
                                                                                                    vec_reward = vec_reward,
                                                                                                    detail = ext.battle_report.log,
                                                                                                    battle_type = BattleType.MAGIC_TOWER,
                                                                                                    stage=ext.stage})
                                                                return true, false
                                                    end)
end

function MagicTowerCtr:addBattleLogLayer(event,data)
    local battle_layer = ex.Tools:addBattleLayerAuto(self.layer,
                                                    BattleType.MAGIC_TOWER,
                                                    MainSceneType.MAINCITY_MAGIC_TOWER,
                                                    MainSceneType.MAINCITY_MAGIC_TOWER_BATTLE,
                                                    "",
                                                    EVENT.MAGIC_TOWER_EVENT.BATTLE_START,
                                                    function(layer, data, vec_reward, ext)
                                                        if ext ~= nil then
                                                            local stage_data = ex.Player.magic_tower_data:getStageData(ext.level)
                                                            local star_num = (stage_data ~= nil and stage_data.complete_id ~= nil) and table.nums(stage_data.complete_id) or 0
                                                            require("src.layer.magictower.MagicTowerBattleEndCtr"):instance():openWindow(data.isWin, ext.level, ext.battle_report, star_num)
                                                        end
                                                        return true, false
                                                    end)
end

return MagicTowerCtr