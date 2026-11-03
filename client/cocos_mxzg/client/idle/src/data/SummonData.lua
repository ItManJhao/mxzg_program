local SummonData = class("SummonData")


-- 招募完成度
function SummonData:ctor()
	self.freeTime = {}
	self.summon_list = {}
	self.award_list = {}
    self.last_summon_type = 0
    self.is_rem = false

    self.is_buy_hero_prayer = false
    self.hero_prayer_end_time = 0
end

function SummonData:clear()
	self.freeTime = {}
	self.summon_list = {}
	self.award_list = {}
end
 

function SummonData:setFreeTime(idx, time)
    time = time or 0
    local now_time = ex.Game:getServerTime()
    if now_time > time then
        time = 0
    end
	self.freeTime[idx] = time
end

function SummonData:getFreeTime(idx)
	return self.freeTime[idx]
end

function SummonData:getFree(idx)

    local data = self:getFreeTime(idx) 
    if data then 
        if data < ex.Game:getServerTime() then 
            return 0
        else 
            return 1 
        end 
    end     
    return 2 
end

-- function SummonData:setCallback(openBuyWindow, callback)
-- 	self.openBuyWindow = openBuyWindow
-- 	self.callback = callback
-- end
function SummonData:setCallback(callback)
    self.callback = callback
end

function SummonData:done(summon_type, is_confirm)
	self.last_summon_type = summon_type

	local config = cfg.lotterypoint.summon[summon_type]
	if config == nil then
		self.callback(false)
        return
    end

    --英雄背包空间不足
    if ex.Player.hero_data:getLen() + config.summon_times > ex.Player.hero_data:getCapacity() then
        ex.MessageView:add(ex.Tools:getLang(1121))
        self.callback(false)
       return
    end

    local cfg_type = config.type

    -- 如果是免费就更改状态 并且不更改背包数据
    local is_change_backpack = true
    local content = ""

    if config.summon_times == 1 then
        if self:getFree(cfg_type) == 0 then
            is_change_backpack = false
            content = ex.Tools:getLang(1105) -- 本次招募免费
        end
    end

    local need_item = config.need_item[1]
    local item_type = need_item.item_type
    local item_num = need_item.item_num


    local sendSummon = function()
    	-- 需要扣除数据
    	if is_change_backpack then
    		-- ex.Player:addItem(item_type, -item_num)
    	else
        	if config.summon_times == 1 then
        		if self:getFree(cfg_type) == 0 then
                    --self:setFree(cfg_type, 1)
                    self:setFreeTime(cfg_type, (ex.Game:getServerTime() + config.free_time ))
        		end
    		end
    	end

    	self.callback(true) -- 吞噬界面

    	-- 发送召唤协议
    	--print("summon_type", summon_type);
		local req_summon = Hero_pb.GReqHeroSummon()
		req_summon.type = summon_type
		NetManager:sendMessage(ProtocolID.GReqHeroSummon, req_summon)

		-- 发送召唤进度奖励协议
		NetManager:sendMessage(ProtocolID.GReqHeroSummonCount)
    end

    if is_change_backpack then
    	-- 背包数据不足
    	if ex.Player:getItemNum(item_type) < item_num then
            local function msgShow()
                ex.MessageView:add(string.format(ex.Tools:getLang(1108),
                    ex.Tools:getLang(cfg.item.item[item_type].name)))
                self.callback(false)
            end
            
            -- 高级卷抽不足 跳转商店
            -- if item_type == ItemType.IT_TICKET_HIGH then
            -- 	self.openBuyWindow()
            -- end

            -- 高级卷抽不足 扣钻石
            if item_type == ItemType.IT_TICKET_HIGH or item_type == ItemType.IT_MAGIC_BUTTER_TICKET then

                if ex.Player:getItemNum(item_type) > 0  then 
                    local end_times = item_num - ex.Player:getItemNum(item_type)
                    local need_gems = item_type == ItemType.IT_TICKET_HIGH and end_times * cfg.system["adv_summon_10_fixed_prize"][1].item_num or end_times * cfg.system["nha_summon_10_fixed_prize"][1].item_num
                    local item_name = ex.Tools:getLang(cfg.item.item[item_type].name)
                    local language_id = item_type == ItemType.IT_TICKET_HIGH and 41236 or 75212
                    item_type =  ItemType.IT_GEM
                    if ex.Player.gem < need_gems then
                        msgShow()
                        return
                    end
                    
                    local show_str = string.format( ex.Tools:getLang(language_id), need_gems,end_times, item_name)
                    ex.ConfirmCtr:openWindow(ex.Tools:getLang(16), show_str, sendSummon)    
                    self.callback(false)

                    return
                else

                    item_type =  ItemType.IT_GEM
                    item_num = tonumber(ex.ShopSeniorTicketTable:getConfig(config.summon_times).need_gem)
                    if ex.Player.gem < item_num then
                        msgShow()
                        return
                    end
                end 
            else
                msgShow()
                return
            end
        end

        -- ex.Tools:getLang(47771)
    	content = string.format(ex.Tools:getLang(1106),
    		item_num,
        	ex.Tools:getLang(item_type))
    end


	
	if is_confirm then
    	ex.ConfirmCtr:openWindow(ex.Tools:getLang(1107), content, sendSummon)
    else
    	sendSummon()
    end
	
end

function SummonData:doneAgain()
	self:done(self.last_summon_type, false)
end

function SummonData:award()
	-- 发送召唤进组奖励协议
	NetManager:sendMessage(ProtocolID.GReqHeroSummonAward)
end

function SummonData:setReshrefTime( )
    local need_item = cfg.lotterypoint.summon[7].need_item[1]
    local hasNum = ex.Player:getItemNum(need_item.item_type)
    local need_num = need_item.item_num

    local is_clergy_privilege = cfg.clergyprivilege.isPrivilege(CLERGY_PRIVILEGE_TYPE.POINT_SUMMON, ex.Player.clergy_level)
    if is_clergy_privilege then 
        local clergy_config = cfg.clergyprivilege.getConfigByPrivilegeType(CLERGY_PRIVILEGE_TYPE.POINT_SUMMON)
        need_num = need_num * clergy_config.unlock_privilege.value / 10000 
    end
    
    if hasNum >= need_num then
        self.is_rem = false
    end
end

function SummonData:setRemmember( )
    --if ex.Player.total_charge >= cfg.system["point_summon_recharge_need"] then 
        self.is_rem = true
    --end 
end

function SummonData:checkBtnAwardRedDot()

    local need_item = cfg.lotterypoint.summon[7].need_item[1]
    local hasNum = ex.Player:getItemNum(need_item.item_type)
    local need_num = need_item.item_num

    local is_clergy_privilege = cfg.clergyprivilege.isPrivilege(CLERGY_PRIVILEGE_TYPE.POINT_SUMMON, ex.Player.clergy_level)
    if is_clergy_privilege then 
        local clergy_config = cfg.clergyprivilege.getConfigByPrivilegeType(CLERGY_PRIVILEGE_TYPE.POINT_SUMMON)
        need_num = need_num * clergy_config.unlock_privilege.value / 10000 
    end

    local flag = false 
    if hasNum >= need_num  then -- and ex.Player.total_charge >= cfg.system["point_summon_recharge_need"] then
        flag = true
    end

    if flag == true and  self.is_rem == true then  
        flag = false 
    end 

    return flag
end  

function SummonData:checkRedDot(idx)
    if not idx then
        return self:getFree(1) == 0 or self:getFree(3) == 0  or self:checkBtnAwardRedDot()
    end

    return self:getFree(idx) == 0
end

function SummonData:isVisibleTipSummon()
    return self:getTipSummonTime() > 0
end


function SummonData:getTipSummonTime()
    -- local day = cc.exports.GetAfterDaysForTime(ex.Player.server_create_time)
    -- local close_time = ex.Player.server_create_time + 7 * 86400 --  ex.Tools:getSysCfg("adv_ui_advertisement") * 86400

    local now_time = ex.Game:getServerTime()
    local close_day = (ex.Tools:getSysCfg("adv_ui_advertisement") or 7) + Maths.getDays(ex.Player.server_create_time) - Maths.getDays(now_time)
    -- 获取今天凌晨的时间戳
    local temp_date = os.date("*t", now_time)
    local resultTime = os.time({year=temp_date.year, month=temp_date.month, day=temp_date.day, hour=0})
    resultTime = resultTime + close_day * 86400

    return math.max(0, resultTime - now_time)
end


function SummonData:checkHeroPrayerRedDot()
    local is_visible = false
    if self.is_buy_hero_prayer and self.hero_prayer_end_time >= ex.Game:getServerTime() then
        local point = ex.Player:getItemNum(ItemType.IT_SUMMON_HERO_PRAYER)
        local point_max = ex.Tools:getSysCfg("adv_summon_wish_time")
        is_visible = point >= point_max
    end
    
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZHFZ_YXXY, is_visible)
end

return SummonData
