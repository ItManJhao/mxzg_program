local ShenYuRespone = class("ShenYuRespone")

function ShenYuRespone:onShenYuInfo(data)
    dump(data)
    local isopen = ex.Player.promotion_data:checkShenYuOpen()
    if isopen then
        ex.Player.promotion_data.shenyu_data:initData(data.info)
    end
end

function ShenYuRespone:onShenYuReward(data)
    dump(data)
    ex.Player.promotion_data.shenyu_data:setMoney(data.info.moneyDrawNum)
    if #data.floors > 0 then 
        ex.Player.promotion_data.shenyu_data:setFloor(data.floors[#data.floors])
    end
    ex.EventManager:fire(EVENT.SHEN_YU.UPDATE_REWARD,data)
end

return ShenYuRespone