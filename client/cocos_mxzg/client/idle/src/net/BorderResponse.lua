local BorderResponse = class("BorderResponse")


function BorderResponse:initBorderData(data)
    ex.Player.border_data:resetActiveList()
    for i,v in ipairs(data.units) do
        ex.Player.border_data:setActiveData(v)
    end
end

function BorderResponse:activeBorder(data)
    ex.Player.border_data:setActiveData(data.unit)
    ex.MessageView:add(ex.Tools:getLang(41149))
    ex.EventManager:fire(EVENT.BORDER_EVENT.ACTIVE_UPDATE)
end

function BorderResponse:useBorder(data)
    ex.Player.border_id = data.idx
    ex.EventManager:fire(EVENT.BORDER_EVENT.USE_UPDATE)
end

--头像
function BorderResponse:initHeadData(data)
    print("BorderResponse:initHeadData")
    -- dump_pbmsg(data)
    ex.Player.border_data:resetHeadActiveList()
    for i,v in ipairs(data.idx_list) do
        ex.Player.border_data:setHeadActiveById(v)
    end
end

function BorderResponse:activeHead(data)
    -- print("BorderResponse:activeHead")
    -- dump_pbmsg(data)
    for i,v in ipairs(data.idxs) do
        ex.Player.border_data:setHeadActiveById(v)
    end
    
    -- ex.MessageView:add(ex.Tools:getLang(41149))
    ex.EventManager:fire(EVENT.BORDER_EVENT.HEAD_ACTIVE_UPDATE)
end

function BorderResponse:useHead(data)
    -- print("BorderResponse:useHead")
    -- dump_pbmsg(data)
    ex.Player.head_id = data.idx
    ex.EventManager:fire(EVENT.BORDER_EVENT.HEAD_USE_UPDATE)
end

return BorderResponse
