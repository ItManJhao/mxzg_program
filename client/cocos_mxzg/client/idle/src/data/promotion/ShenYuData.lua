local ShenYuData = class("ShenYuData")

function ShenYuData:ctor( )
    self._floor = 0
    self._money = 0
    -- self:initCfg()
end

function ShenYuData:initCfg( )
    self:initFloorCfg()
    self:initRewardCfg()
end

function ShenYuData:initFloorCfg( )
    self._floor_cfg = {}
    for i,v in ipairs(cfg.promotion072floor.promotion072floor) do
        self._floor_cfg[v.floor] = v
    end
end

function ShenYuData:initRewardCfg( )
    self._reward_cfg = {}
    for i,v in ipairs(cfg.promotion072reward.promotion072reward) do
        if not self._reward_cfg[v.floor] then self._reward_cfg[v.floor] = {} end 
        table.insert(self._reward_cfg[v.floor],v)
    end

    local function sor(a,b)
        return a.idx < b.idx
    end

    for i,v in ipairs(self._reward_cfg) do
        table.sort(v,sor)
    end
end

function ShenYuData:getRewardByFloor(floor)
    return self._reward_cfg[floor]
end

function ShenYuData:getCostByFloor(floor)
    return self._floor_cfg[floor]    
end

function ShenYuData:setFloor(floor)
    self._floor = floor 
end

function ShenYuData:setMoney(num)
    self._money = num 
end

function ShenYuData:getMoney( )
    return self._money
end

function ShenYuData:getFloor( )
    return self._floor
end

function ShenYuData:initData(data)
    self._money = 0
    self._floor = 0

    self:initCfg()
    self:setFloor(data.floor)
    self:setMoney(data.moneyDrawNum)
end

function ShenYuData:clear( )
    self._floor_cfg = nil 
    self._reward_cfg = nil
    self._floor = nil
    self._money = nil
end


return ShenYuData