local FantasyTowerCtr = class("FantasyTowerCtr", require("src.ex.BaseCtr"))

-- function FantasyTowerCtr:addBattleLayerAuto(battle_type, keep_type, layer_type, map, evt_start, end_callback, map_pos, map_size)
--     local battle_layer = require("src.comp.BattleReportBaseLayer"):create()
--     battle_layer.parent_layer_type = keep_type
--     battle_layer.battle_layer_type = layer_type
--     battle_layer:initData(battle_type, map, evt_start, end_callback, map_pos, map_size)
--     battle_layer:setRecoveryType(RecoveryType.RT_REMOVE_PARENT)
--     battle_layer:setPosition(cc.p(ex.p.width * 0.5, ex.p.height * 0.5))
--     local cell_reward = require("src.layer.fantasytower.FantasyTowerTipRewardCell"):createWithCCBIFile("ccbi/FantasyTowerTipRewardCell.ccbi")
--     battle_layer:addChild(cell_reward)
--     cell_reward:reset()
--     ex.MainSceneCtr:addBattleLayer(self.layer, battle_layer, battle_layer.battle_layer_type, battle_layer.is_conflict and battle_layer.parent_layer_type or nil)
-- end

function FantasyTowerCtr:addBattleLayer()
    local battle_layer = ex.Tools:addBattleLayerAuto(self.layer,
                                                    BattleType.TOWER,
                                                    MainSceneType.MAINCITY_FANTASY_TOWER,
                                                    MainSceneType.MAINCITY_FANTASY_TOWER_BATTLE,
                                                    "", 
                                                    EVENT.TOWER_EVENT.TOWER_BATTLE_START,
                                                    function(layer, data, vec_reward, ext)
                                                                ex.EventManager:fire(EVENT.TOWER_EVENT.TOWER_BATTLE_END, data.isWin)
                                                                ex.Tools:autoPlaySceneMusic()


                                                                local chapter_end_ctr = require("src.layer.chapterend.ChapterEndCtr"):instance()
                                                                chapter_end_ctr:openWindowWithTower({is_win = data.isWin,
                                                                                                    vec_reward = vec_reward,
                                                                                                    detail = ext.report.log,
                                                                                                    battle_type = BattleType.TOWER,
                                                                                                    stage=ext.stage})
                                                                return true, false
                                                    end)

    local cell_reward = require("src.layer.fantasytower.FantasyTowerTipRewardCell"):createWithCCBIFile("ccbi/FantasyTowerTipRewardCell.ccbi")
    battle_layer:addChild(cell_reward)
    cell_reward:reset()
end

function FantasyTowerCtr:battle(stage)
    local req_battle = Tower_pb.GReqTowerBattle()
    req_battle.stage = stage
    NetManager:sendMessage(ProtocolID.GReqTowerBattle, req_battle)
end

return FantasyTowerCtr