local RunesResponse = class("RunesResponse")

-- 符文列表
function RunesResponse:runesList(data)
    -- dump(data, "RunesResponse:runesList")

    if data.page == 1 then
        ex.Player.backpack_data.runes_list = {}
    end
    for i,v in ipairs(data.list) do
        ex.Player.backpack_data:addRunes(v)
    end

    if #data.list <= 0 then
        require("src.scene.LoadingSceneCtr"):instance():receivedProtocol(ProtocolID.GResRunesList)
        ex.Player.hero_data:initRedPoint()
        ex.EventManager:fire(EVENT.RUNES_EVENT.RUNES_INIT)
    else
        local req_runes_list = Rune_pb.GReqRunesList()
        req_runes_list.page = data.page + 1
        NetManager:sendMessage(ProtocolID.GReqRunesList, req_runes_list)
    end
end

-- 符文添加单个
function RunesResponse:addRunes(data)
    -- local data = NetManager:resLuaData(ProtocolResponse.ResRunes, byte_array)
    -- dump(data.runeData, "RunesResponse:addRunes")

    for i,v in ipairs(data.runeData) do
        ex.Player.backpack_data:addRunes(v)
    end
    ex.Player.hero_data:initRedPoint()
    ex.EventManager:fire(EVENT.RUNES_EVENT.RUNES_ADD)
    ex.EventManager:fire(EVENT.RUNES_EVENT.SELECT_SMITH_UPDATE_TABLE)
end

-- 符文删除
function RunesResponse:deleteRunes(data)
    -- local data = NetManager:resLuaData(ProtocolResponse.ResDeleteRunes, byte_array)
    
    for i,v in ipairs(data.list) do
        ex.Player.backpack_data:deleteRunesById(v)
    end
    ex.Player.hero_data:initRedPoint()
    ex.EventManager:fire(EVENT.RUNES_EVENT.RUNES_DELETE)
end

-- 给英雄装备符文
function RunesResponse:runesOnOff(data)
    -- local data = NetManager:resLuaData(ProtocolResponse.ResRunesSelect, byte_array)

    -- 如果穿戴成功，则刷新英雄符文
    ex.Player.hero_data:initRedPoint()
    ex.EventManager:fire(EVENT.RUNES_EVENT.UPDATE_HERO_RUNES)
end

-- 符文合成
function RunesResponse:runesCompose(data)
    -- 显示新符文显示弹窗
    local runes_data = ex.Player.backpack_data:getRunesById(data.rune_id)
    if runes_data == nil then
        return
    end

    local award_list = {}
    
    local tmp_data = {}
    tmp_data.item_id   = runes_data.item_id 
    tmp_data.item_type = runes_data.item_type
    tmp_data.item_num  = runes_data.item_num

    table.insert(award_list, tmp_data)

    if data.list ~= nil then
        for i,v in ipairs(data.list) do
            local tmp_data = {}
            tmp_data.item_id   = v.id 
            tmp_data.item_type = v.type
            tmp_data.item_num  = v.num

            table.insert(award_list, tmp_data)
        end
    end

    require("src.layer.ItemRewardCtr"):instance():openWindow(award_list)
    ex.Player.hero_data:initRedPoint()
    ex.EventManager:fire(EVENT.RUNES_EVENT.COMPOSE)
end

-- 符文分解
function RunesResponse:runesDiscompose(data)
    ex.Player.hero_data:initRedPoint()
end

function RunesResponse:recastRunes(data)
    ex.EventManager:fire(EVENT.RUNES_EVENT.RECAST_RUNES, data.rune_id)
    ex.EventManager:fire(EVENT.RUNES_EVENT.UPDATE_HERO_RUNES)
end

function RunesResponse:recastRunesSave(data)
    ex.EventManager:fire(EVENT.RUNES_EVENT.RECAST_RUNES, data.rune_id)
    ex.EventManager:fire(EVENT.RUNES_EVENT.UPDATE_HERO_RUNES)
end

return RunesResponse
