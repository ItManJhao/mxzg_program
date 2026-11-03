local CtrMgr = class("CtrMgr")

function CtrMgr:ctor()
    self.ctr_list = {}

    self:addCtr("fantasy_tower", require("src.layer.fantasytower.FantasyTowerCtr"))
    self:addCtr("magic_tower", require("src.layer.magictower.MagicTowerCtr"))
    self:addCtr("god_relic", require("src.layer.godrelic.GodRelicCtr"))
    self:addCtr("clan_battle", require("src.layer.clan.ClanBattleCtr"))
    self:addCtr("floating_islands", require("src.layer.floatingislands.FloatingIslandsCtr"))
    self:addCtr("pvp_battle", require("src.layer.PvpBattleCtr"))
    self:addCtr("crusade_group", require("src.layer.crusadegroup.CrusadeGroupCtr"))
    self:addCtr("country_war", require("src.layer.countrywar.CountryWarCtr"))
    self:addCtr("plane_war", require("src.layer.planewar.PlaneWarCtr"))
    self:addCtr("alice", require("src.layer.alice.AliceCtr"))
end

-- 清除ctr的定时器和数据
function CtrMgr:clearAll()
    for k,v in pairs(self.ctr_list) do
        v:_clear()
    end
    self.ctr_list = {}
end

function CtrMgr:addCtr(name, ctr)
    local ctr_obj = ctr:create()

    self[name] = ctr_obj
    table.insert(self.ctr_list, ctr_obj)
end


-- 開啟定時器
function CtrMgr:startTimer()
    for k,v in pairs(self.ctr_list) do
        if v.is_ctr_start_time ~= true then
            v.is_ctr_start_time = true
            v:startTimer()
        end
    end
end


function CtrMgr:registerResponse(response_ctr)
    for k,v in pairs(self.ctr_list) do
        if v.registerResponse ~= nil then
            v:registerResponse(response_ctr)
        end
    end
end

return CtrMgr