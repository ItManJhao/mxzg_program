local ClanBattleCtr = class("ClanBattleCtr", require("src.ex.BaseCtr"))

function ClanBattleCtr:addBattleLayer()
    local battle_layer =
        ex.Tools:addBattleLayerAuto(
        self.layer,
        BattleType.CLAN_MISSION,
        nil,
        MainSceneType.MAINCITY_CLAN_MISSION_BATTLE,
        "",
        EVENT.CLAN_EVENT.CLAN_MISSION_BATTLE,
        function(layer, data, vec_reward, ext)
            -- ex.EventManager:fire(EVENT.CLAN_EVENT.TOWER_BATTLE_END, data.isWin)
            ex.Tools:autoPlaySceneMusic()

            -- 通过判断win_id与自己的Id是否一致去确认是否胜利（PS:徐聪确认的，有问题找徐大爷）
            if ext.report.win_id == ex.Player.role_id then
                if ext.isAwarded then
                    ex.MessageView:add(ex.Tools:getLang(5798))
                end
            end

            require("src.layer.chapterend.ChapterEndCtr"):instance():openWindow(
                {
                    is_win = true,
                    vec_reward = vec_reward,
                    detail = ext.report.log
                }
            )

            return true, false
        end
    )
end

function ClanBattleCtr:showBattleLayer()
    local battle_layer = ex.MainSceneCtr:getKeepBuffer(MainSceneType.MAINCITY_CLAN_MISSION_BATTLE)
    if battle_layer ~= nil then
        battle_layer.parent_layer_type = MainSceneType.CLAN
        if ex.MainSceneCtr:getCurLayerType() == MainSceneType.CLAN then
            -- battle_layer:setVisible(true)
            ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_CLAN_MISSION_BATTLE, nil, nil, true)
        end
    end
end

function ClanBattleCtr:battle()
    NetManager:sendMessage(ProtocolID.GReqClanMissionEnd)
end

return ClanBattleCtr
