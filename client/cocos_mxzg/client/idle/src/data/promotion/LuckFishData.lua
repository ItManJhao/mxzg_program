local LuckFishData = class("LuckFishData")

function LuckFishData:ctor()
    self:initCfg()
    self._blessing_num = 0
    self._buy_limit = 0
    self._koi_nick = ""
end

function LuckFishData:onFinish(event,data)
    self:initCfg()
end

function LuckFishData:initCfg()
    self._cfg = {}
    for i,v in ipairs(cfg.promotionweekendkoipond.promotionweekendkoipond) do
        table.insert(self._cfg , v)
    end
end

function LuckFishData:setInfoData(data)
    -- self._blessing_num = data.blessing_num
    -- self._buy_limit = data.buy_limit
    -- self._koi_nick = data.koi_nick
    self:setLimitNum(data.buy_limit)
    self:setBlessingNum(data.blessing_num)
    self:setKoiNick(data.koi_nick)
    self._turns = data.turns
end

function LuckFishData:setLimitNum( num )
    self._buy_limit = num
end

function LuckFishData:setBlessingNum( num )
    self._blessing_num = num
end

function LuckFishData:setKoiNick(nick)
    self._koi_nick = nick
end

function LuckFishData:getLimitNum()
    return self._buy_limit
end

function LuckFishData:getBlessingNum()
    return self._blessing_num
end

function LuckFishData:getKoiNick()
    return self._koi_nick
end

function LuckFishData:getCfg()
    return self._cfg
end

function LuckFishData:clean( )
    self._cfg = nil
    self._blessing_num = nil 
    self._buy_limit = nil 
    self._koi_nick = nil 
    self._turns = nil
end


return LuckFishData