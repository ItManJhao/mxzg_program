--[[
    func: 彩虹圣殿网络适配器
    author:徐东浩
    time:2020-02-28 16:40:44
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local RainbowResponse = class("RainbowResponse")


function RainbowResponse:handleRainbowInfo(data)
    ex.Player.rainbow_data:receiveRainbowInfo()
    
    ex.Player.rainbow_data:refreshVSPlayerData(data.slots)
    
    ex.Player.rainbow_data:changeSelfRank(data.rank)

    ex.Player.rainbow_data:refreshBattleCD(data.rainbow_cd)
end

function RainbowResponse:handleRainbowChallenge(data)
    ex.EventManager:fire(EVENT.RAINBOW_EVENT.BATTLE_RESULT, data.report, data.my_type)

    ex.Player.rainbow_data:receiveRainbowInfo()
    
    ex.Player.rainbow_data:refreshVSPlayerData(data.slots)

    ex.Player.rainbow_data:refreshBattleCD(data.rainbow_cd)
end

function RainbowResponse:handleRainbowRecord(data)
    ex.EventManager:fire(EVENT.RAINBOW_EVENT.RECEIVE_RECORD, data.records)
end

return RainbowResponse