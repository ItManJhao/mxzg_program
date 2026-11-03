local CustomizedData = class("CustomizedData")

function CustomizedData:ctor()
    self:initCfg()
    self._custom_arr = {}
    self._buyRecord = {}

    self._showCustomizedAlready = false

    self:addEvent()
end

function CustomizedData:addEvent( )
    self._event_list = {
        ex.EventManager:add(EVENT.MAIN_CITY_ACT.ACTIVITY_CFG_INIT,handler(self,self.onFinish))
    }
end

function CustomizedData:onFinish(event,data)
    self:initCfg()
end

function CustomizedData:initCfg()
    self._cfg = {}
    
    local cfg_data = cfg.customreward.customreward
    
    for i,v in ipairs(cfg_data) do

        if not self._cfg[v.product_id] then 
            self._cfg[v.product_id] = {}
            self._cfg[v.product_id].product_id = v.product_id
        end

        if not self._cfg[v.product_id].place_reward then 
            self._cfg[v.product_id].place_reward = {}
        end

        if not self._cfg[v.product_id].place_reward[v.place] then 
            self._cfg[v.product_id].place_reward[v.place] = {}
        end

        local data = {}
        data.idx = v.idx
        data.item_type = v.reward[1].item_type
        data.item_num = v.reward[1].item_num
        table.insert(self._cfg[v.product_id].place_reward[v.place], data)
    end
end

function CustomizedData:getCustomById(id)
    return self._custom_arr[id]
end

function CustomizedData:setShowCustomizedAlready()
    self._showCustomizedAlready = true

    self:checkReddot()
end

function CustomizedData:setCustom(data)
    local dt = {}
    dt.product_id = data.custom_data.product_id
    dt.buy_count = data.custom_data.buy_count
    dt.custom_reward_id = {}
    for k,val in pairs(data.custom_data.custom_reward_id) do
        dt.custom_reward_id[k] = val
    end
    self._custom_arr[dt.product_id] = dt 

    self:checkReddot()
end

function CustomizedData:getCellCfg(id)
    return self._cfg[id]
end

function CustomizedData:getCfg()
    return self._cfg
end

function CustomizedData:checkReddot()
    if not ex.Player.promotion_data:customizedIsOpen() or self._showCustomizedAlready == true then
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_PFHD_SRDZ, false)
        return
    end

    local is_show_red = false
    for _,v in pairs(self._cfg) do
        local custom_data = self._buyRecord[v.product_id]
        local buy_count = custom_data ~= nil and custom_data.buy_count or 0
        if buy_count < cfg.buygem.buygem[v.product_id].limit_times then
            is_show_red = true
            break
        end
    end

    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_PFHD_SRDZ, is_show_red)
end

function CustomizedData:setBuyRecord(data)
    for k,v in pairs(data.buy_record) do
        local data = {}
        if not self._custom_arr[v.product_id] then self._custom_arr[v.product_id] = {} end 
        self._custom_arr[v.product_id].product_id = v.product_id
        self._custom_arr[v.product_id].buy_count = v.buy_count
        self._custom_arr[v.product_id].custom_reward_id = {}

        data.product_id = v.product_id
        data.buy_count = v.buy_count
        data.custom_reward_id = {}
        for k,val in pairs(v.custom_reward_id) do
            data.custom_reward_id[k] = val
            self._custom_arr[v.product_id].custom_reward_id[k] = val
        end
        self._buyRecord[data.product_id] = data
    end

    self:checkReddot()
end

function CustomizedData:getBuyRecordById(id)
    return self._buyRecord[id]
end

function CustomizedData:clean( )
    self._cfg = nil
    self._custom_arr = nil
    self._buyRecord = nil
    for i,v in ipairs(self._event_list) do
        ex.EventManager:remove(v)
    end
end


return CustomizedData