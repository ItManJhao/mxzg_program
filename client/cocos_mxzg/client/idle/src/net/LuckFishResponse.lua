local LuckFishResponse = class("LuckFishResponse")

function LuckFishResponse:onInfo(data)
    ex.Player.promotion_data.luck_fish_data:setInfoData(data)
    dump(ex.Player.promotion_data:checkLuckFishIsOpen())
end
 
function LuckFishResponse:onRecordData(data)
    ex.EventManager:fire(EVENT.LUCK_FISH.UPDATE_RECORD,data.list)
end

function LuckFishResponse:onUseBlessing(data)
    dump(data)
    ex.Player.promotion_data.luck_fish_data:setBlessingNum(data.blessing_num)
    ex.EventManager:fire(EVENT.LUCK_FISH.UPDATE_BLESSING,data)
end

function LuckFishResponse:onNick(data)
    ex.Player.promotion_data.luck_fish_data:setKoiNick(data.koi_nick)
    ex.EventManager:fire(EVENT.LUCK_FISH.UPDATE_NICK,data.koi_nick)
end

function LuckFishResponse:onBuyLimit(data)
    ex.Player.promotion_data.luck_fish_data:setLimitNum(data.buy_limit)
    ex.EventManager:fire(EVENT.LUCK_FISH.UPDATE_BUY_NUM,data.buy_limit)
end

return LuckFishResponse