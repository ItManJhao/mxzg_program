local GodRelicCtr = class("GodRelicCtr", require("src.ex.BaseCtr"))

function GodRelicCtr:addBattleLayer(data, battle_count)
    local battle_layer = ex.Tools:addBattleLayerAuto(self.layer,
                                                    BattleType.GOD_RELIC,
                                                        MainSceneType.MAINCITY_GOD_RELIC,
                                                        MainSceneType.MAINCITY_GOD_RELIC_BATTLE,
                                                        "", 
                                                        EVENT.GOD_RELIC.BATTLE,
                                                        function(layer, _, vec_reward, ext)
                                                                local battle_count = layer.battle_count
                                                                local next_battle_report = data.battle_report[battle_count + 1]
                                                                layer.battle_count = battle_count + 1
                                                                ex.EventManager:fire(EVENT.GOD_RELIC.UPDATE)
                                                                if next_battle_report then
                                                                    ex.EventManager:fire(EVENT.GOD_RELIC.BATTLE_CONTINUE)
                                                                    ex.EventManager:fire(EVENT.GOD_RELIC.BATTLE, next_battle_report, ex.Tools:convertRewardList(data.reward), ext)
                                                                else
                                                                    ex.EventManager:fire(EVENT.GOD_RELIC.BATTLE_END)
                                                                end
                                                                return next_battle_report == nil, next_battle_report == nil
                                                        end)
    battle_layer.battle_count = battle_count
    local cell = require("src.layer.godrelic.GRConditionCell"):createWithCCBIFile("ccbi/GRConditionCell.ccbi")
    cell:setPositionX(5)
    cell:setPositionY(ex.p.height - 160 - require("src.model.Game"):instance():getNotchHeight())
    cell:reset(data, battle_layer)
    cell:setBattleLayer(battle_layer)
    battle_layer:addChild(cell)
    ex.EventManager:fire(EVENT.GOD_RELIC.BATTLE, data.battle_report[battle_count] or {}, ex.Tools:convertRewardList(data.reward), data)
end

return GodRelicCtr