--[[
    func: 彩虹圣殿数据档
    author:徐东浩
    time:2020-02-28 14:28:44
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local RainbowData = class("RainbowData")

function RainbowData:ctor()
    self.rainbow_main_data_is_dirty = true
    
    self.rainbow_main_data = {
        defenders = {},
        my_rank = 0,
        rainbow_cd = 0,
    }
end

function RainbowData:receiveRainbowInfo()
    self.rainbow_main_data_is_dirty = false
end

function RainbowData:refreshVSPlayerData(defenders)
    if defenders == nil then return end

    self.rainbow_main_data.defenders = {}
    self.rainbow_main_data.defenders = defenders

    table.sort(self.rainbow_main_data.defenders, function(a, b)
        if a.type == b.type then
            return a.pos == b.pos and a.id < b.id or a.pos < b.pos
        else
            return a.type < b.type
        end
    end)

    ex.EventManager:fire(EVENT.RAINBOW_EVENT.REFRESH_VS_PLAYER)
end

function RainbowData:changeSelfRank(rank)
    self.rainbow_main_data.my_rank = rank

    ex.EventManager:fire(EVENT.RAINBOW_EVENT.REFRESH_MY_RANK)
end

function RainbowData:refreshBattleCD(cd)
    self.rainbow_main_data.rainbow_cd = cd

    ex.EventManager:fire(EVENT.RAINBOW_EVENT.REFRESH_BATTLE_CD)
end

-- rid角色是否占领位置
function RainbowData:isOccupySeat(rid)
    if rid == 0 then return false end

    for k, v in pairs(self.rainbow_main_data.defenders) do
        if v.rid == rid then
            return true
        end
    end

    return false
end

function RainbowData:countCD()
    return self.rainbow_main_data.rainbow_cd - ex.Game:getServerTime()
end

---------------------------------------------------------------------------------
-- 请求彩虹圣殿数据
function RainbowData:reqRainbowInfo()
    local req = Rainbow_pb.GReqRainbowInfo()
    NetManager:sendMessage(ProtocolID.GReqRainbowInfo, req)

    self.rainbow_main_data_is_dirty = true
end

-- 请求挑战
function RainbowData:reqChallenge(player_id, evolution)
    self.rainbow_main_data_is_dirty = true
    
    local req = Rainbow_pb.GReqRainbowChallenge()
    req.id = player_id
    req.evolution = evolution
    NetManager:sendMessage(ProtocolID.GReqRainbowChallenge, req)
end

-- 请求神位挑战数据
function RainbowData:reqRainbowRecord(id)
    local req = Rainbow_pb.GReqRainbowRecord()
    req.id = id
    NetManager:sendMessage(ProtocolID.GReqRainbowRecord, req)
end

return RainbowData