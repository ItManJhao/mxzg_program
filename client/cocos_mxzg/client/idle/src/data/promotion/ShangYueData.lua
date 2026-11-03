local ShangYueData = class("ShangYueData")

function ShangYueData:ctor()
    self.select_info = {}
    self.reward_cord = {}
    self.summon_count = 0
    self.remaining_count = 0
    self.jiayao_buy_record = {}
    self.event = ex.EventManager:add(EVENT.BACKPACK_RES_CHANGE.CHANGE_ITEM, handler(self, self.onItemChange))
end


function ShangYueData:onItemChange(event,data)    
    if not cfg.promotionskindatainfo or 
    not cfg.promotionskindatainfo.promotionskindatainfo or 
    not cfg.promotionskindatainfo.promotionskindatainfo[1] or 
    not cfg.promotionskindatainfo.promotionskindatainfo[1].need_item then 
        return   
    end

    local cost = cfg.system.promotion074_lottery_cost[1]
    local skin = cfg.promotionskindatainfo.promotionskindatainfo[1].need_item[1]

    if not data then return end 
    local b_cost = false
    local b_skin = false
    for i,v in ipairs(data) do
        if b_cost and b_skin then break end
        if v.type == cost.item_type and not b_cost then 
            self:RedPointByMainCity()
            b_cost = true
        elseif skin ~= nil and v.type == skin.item_type and not b_skin then 
            ex.Player.promotion_data:checkZhongQiuSkinRedDot()
            b_skin = true
        end 
    end
end 

function ShangYueData:initData(data)
    self.select_info = {}
    self.reward_cord = {}
    self.summon_count = 0
    self.remaining_count = 0
    -- self.jiayao_buy_record = {}
    self:setSelectInfo(data.select_info)
    --self:setRewardCord(data.lottery_reward)
    self:setSummonCount(data.lottery_count)
    self:setRemainingCount(data.lottery_best_remaining_count)
    for i,v in ipairs(data.lottery_reward) do
        self:setRewardCord(v)
    end
    self:RedPointByMainCity()
end 

function ShangYueData:setSelectInfo(data)
    self.select_info = data 
end

function ShangYueData:setRewardCord(idx)
    --self.reward_cord = data
    self.reward_cord[idx] = true
end


function ShangYueData:setSummonCount(data)
    self.summon_count = data
end

function ShangYueData:setRemainingCount(data)
    self.remaining_count = data
end

function ShangYueData:getBoxCordByIdx(idx)
    return self.reward_cord[idx] == true
end

function ShangYueData:getSummonCount()
    return self.summon_count 
end 

function ShangYueData:getRemainingCount()
    return self.remaining_count 
end 

function ShangYueData:isSelected()
    return self.select_info.key > 0 and self.select_info.value > 0
end

function ShangYueData:getSelectIndex()
    return self.select_info.value 
end 

function ShangYueData:checkBoxStatus(idx)
    local geted = self:getBoxCordByIdx(idx)
    local status = geted == true and -1 or 0
    if geted == true then 
        return status
    else 
        local box_cfg = cfg.promotion074lotterycountreward.promotion074lotterycountreward[idx]
        if not box_cfg then return false end 
        if self.summon_count >= box_cfg.count then 
            status = 0
        else 
            status = 1
        end 
    end 

    return status 
end 

function ShangYueData:RedPointByMainCity()
    local bool = false 
    local is_open = ex.Player.promotion_data:getTimeIsOpen(74)
    if is_open ~= true then 
        return false 
    end 

    for i,v in ipairs(cfg.promotion074lotterycountreward.promotion074lotterycountreward) do
        bool = self:checkBoxStatus(v.idx) == 0 
        if bool == true then 
            break 
        end 
    end

    local cost = cfg.system.promotion074_lottery_cost[1]
    local has_num = ex.Player:getItemNum(cost.item_type)


    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZQHD_BX, bool or has_num > 0)
    return bool
end 

function ShangYueData:initJiaYaoData(data)
    self.jiayao_buy_record = {}
    if data and #data then
        for k, v in ipairs(data) do
            self.jiayao_buy_record[v.key] = v.value
        end
    end

    self.jiayao_is_get_info = true
    ex.EventManager:fire(EVENT.MAIN_CITY.REFRESH_BTN_STATUS)

end

function ShangYueData:updateJiaYaoBuyRecord(data)
    for k, v in pairs(self.jiayao_buy_record) do
        if k == data.key then
            self.jiayao_buy_record[k] = data.value
            break
        end
    end
end

function ShangYueData:getJiaYaoCfg()
    --if not cfg.promotion075midfood or not cfg.promotion075midfood.promotion075midfood or #cfg.promotion075midfood.promotion075midfood == 0 then
        --return
    --end
    local goods_list = {}
    for k, v in ipairs(cfg.promotion075midfood.promotion075midfood) do
        local goods = {
            idx = v.idx,
            reward = v.reward,
            product_id = v.product_id,
            buy_limit = v.buy_limit,
            name = ex.Tools:getLang(v.gift_name),
            buy_times = self.jiayao_buy_record[v.idx] or 0
        }

        table.insert(goods_list, goods)
    end
    
    local len = #goods_list
    local index = 1
    for i = 1, len do
        local goods = goods_list[index]
        
        if goods.buy_limit <= goods.buy_times then
            local temp_goods = table.remove(goods_list, index)
            table.insert(goods_list, temp_goods)
        else
            index = index + 1
        end
    end
    return goods_list
end

function ShangYueData:getJiaYaoData()
    return ex.Player.promotion_data:getPromotionDatas(promotionPros.GReqQiShenQiInfo.id)
end

function ShangYueData:checkSlotIsOpen()
    return ex.Player.promotion_data:getTimeIsOpen(74)
end 

function ShangYueData:checkJiaYaoIsOpen()
    return ex.Player.promotion_data:getTimeIsOpen(75)
end 

function ShangYueData:clear()
    if self.event ~= nil then 
        ex.EventManager:remove(self.event)
    end 
    self.event = nil 
    self.select_info = nil
    self.reward_cord = nil
    self.summon_count = nil
    self.remaining_count = nil
    self.jiayao_buy_record = nil
    self.jiayao_is_get_info = nil
end

return ShangYueData
