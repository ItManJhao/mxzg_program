local GodEquipData = class("GodEquipData")

function GodEquipData:ctor()
    self.lottery_lucky_times = 0    -- 已神装探宝N次，达到一定次数一定出极品
    self.lottery_roll_num = 0       -- 已免费探宝N次
    self.lottery_new_records = {}   -- 最新消息

    self.lottery_self_records = {}  -- 个人记录
    self.lottery_server_records = {}-- 服务器记录

    self.buy_status = 0
    self.get_day = 0

end


function GodEquipData:saveGodEquipPrivilege(data )
    self.buy_status = data.buy_status
    self.get_day = data.get_day

    ex.Player.promotion_data:checkPrivilegeGiftRedDot()
end

function GodEquipData:saveGetPrivilegeReward(data )
    
    self.get_day = data.get_day

end



--检测红点
function GodEquipData:checkPlaceRed( place )
    local return_data = {}
    local equip_list = ex.Player.backpack_data.god_equip_list
    for i,v in pairs(equip_list) do
        local cur_equip_data = cfg.godequipment.godequipment[v.item_type]

        if cur_equip_data.place == place and v.hero_id ==0  then 
            table.insert( return_data, clone(v) )
        end 
    end
    return return_data
end 

-- 检测神器探宝红点
function GodEquipData:checkSummonReddot()
    local is_visible = ex.JumpManager:checkOpenConditionByAtomNoMsg("main_god_equip_summon")
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_YGZC_ZSYJ_SZTB_ZHAN, is_visible and self.lottery_roll_num > 0)
end

-----------------------------------link------------------------------------------
function GodEquipData:resLotteryInfo(res)
    self.lottery_lucky_times = res.lucky
    self.lottery_roll_num = res.roll_num
    self.lottery_new_records = res.records
    require("src.layer.artifact.ArtifactSummonCtr"):instance():updateLayer()

    self:checkSummonReddot()
end

function GodEquipData:resLotteryHistory(res)
    -- 检测非法数据
    self.lottery_self_records = {}
    for i,v in ipairs(res.role_records) do
        if v.item_type > 0 then
            table.insert(self.lottery_self_records, v)
        end
    end

    self.lottery_server_records = {}
    for i,v in ipairs(res.server_records) do
        if v.item_type > 0 then
            table.insert(self.lottery_server_records, v)
        end
    end

    require("src.layer.artifact.ArtifactSummonHistoryCtr"):instance():updateLayer()
end

function GodEquipData:lotteryDone(res)
    NetManager:sendMessage(ProtocolID.GReqScanGodEquipLottery)

    -- local vec_reward = {}
    -- for i,v in ipairs(res.list) do
    --     local data = {}
	-- 	data.item_id   = v.id 
	-- 	data.item_type = v.type
    --     data.item_num  = v.num
        
    --     if data.item_num ==  1 then
    --         data.item_num = 0
    --     end

	-- 	table.insert(vec_reward, data)
    -- end
    -- require("src.layer.ItemRewardCtr"):instance():openWindow(vec_reward, true)

    require("src.layer.artifact.ArtifactSummonCtr"):instance():updateLayer()

    ex.EventManager:fire(EVENT.HERO_INFO_EVENT.UPDATE_REDDOT)
    ex.EventManager:fire(EVENT.HERO_INFO_EVENT.HERO_UPDATE_GODEQUIP) 
end

return GodEquipData