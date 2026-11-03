local PvpBattleCtr = class("PvpBattleCtr", require("src.ex.BaseCtr"))

function PvpBattleCtr:addBattleLayer()
    local battle_layer =
        ex.Tools:addBattleLayerAuto(
        ex.MainSceneCtr:getKeepBuffer(MainSceneType.MAINCITY_LAYER),
        BattleType.PVP_DEFENSE,
        nil,
        MainSceneType.MAINCITY_PVP_BATTLE,
        "",
        EVENT.PVP_EVENT.BATTLE_START,
        function(layer, data, vec_reward, ext)
            require("src.layer.PvpCtr"):instance().match_time = 0
            -- 判断当前主城界面是否显示
            local layer_battle = ex.MainSceneCtr:getMainSceneLayer(MainSceneType.MAINCITY_PVP_BATTLE)
            if layer_battle then
                require("src.layer.PvpCtr"):instance():openWindow()
            end
            local ctr = require("src.layer.PvpEndCtr"):instance()
            ctr:openWindow(data.isWin, ext.player_id, vec_reward or {}, ext)

            local is_clergy_privilege = cfg.clergyprivilege.isPrivilege(CLERGY_PRIVILEGE_TYPE.PVP, ex.Player.clergy_level)
            ctr:addBottomTip(ex.Tools:getLang(is_clergy_privilege and (ext.chance_status ~= 0 and 49308 or 49309) or 49307))

            NetManager:sendMessage(ProtocolID.GReqPvpPlayerRefresh)
            ex.Tools:autoPlaySceneMusic()
            return true, false
        end
    )
    ex.Tools:autoPlaySceneMusic()
end

function PvpBattleCtr:battle()
    require("src.layer.PvpCtr"):instance():openWindow()
end

return PvpBattleCtr
