local PROMWarOrderRewardCell = class("HeroLayer", require("src.comp.EventLayer"))
local ITEM_SCALE = 0.8

function PROMWarOrderRewardCell:onCreate()
    self.menu = cpp.UIMenu:create()
    self:addChild(self.menu)
    self.menu:setPosition(0,0)
end

function PROMWarOrderRewardCell:setTableView(table)
    self.menu:setIsTouchInsideNode(table)
    self.menu:setSwallowsTouches(false)
end

function PROMWarOrderRewardCell:reset(data)
    if not data then return end 
    self.data = data

    self.menu:removeAllChildren()

    self.lbl_level:setString(self.data.level)
    local pos_x ,pos_y = self.base_node:getPosition() 
    local geted = ex.Player.promotion_data.prom_war_order_data:getBaseRewardById(data.level) == true
    local lock = data.level > ex.Player.promotion_data.prom_war_order_data:getLevel()
    
    if self.data.finish_reward ~= "" and table.nums(self.data.finish_reward) > 0 then 
        local base_data = self.data.finish_reward[1]
        local base_item = ex.Tools:createBackpackItem(base_data.item_type, base_data.item_num)
        self.menu:addChild(base_item)
        base_item:setPosition(pos_x,pos_y)
        base_item:registerScriptTapHandler(handler(self,self.onBase))
        base_item:setScale(ITEM_SCALE)
        base_item:setSelected(geted)
        if geted then base_item:setGrayed() end 
        local sp_lock = cc.Sprite:createWithSpriteFrameName("prom-warorder/spr-lock.png")
        base_item:addChild(sp_lock)
        sp_lock:setPositionY(base_item:getContentSize().height)
        sp_lock:setVisible(lock)
        sp_lock:setLocalZOrder(1000)
    end

    -- local item_size = base_item:getContentSize()
    local margin = 10
    -- item_size.width = item_size.width * ITEM_SCALE + margin
    -- item_size.height = item_size.height * ITEM_SCALE
    local begin_x  = self.special_node:getPositionX()
    local special_data = self.data.privilege_reward
    local geted = ex.Player.promotion_data.prom_war_order_data:getSpecialRewardById(data.level) == true
    lock = data.level > ex.Player.promotion_data.prom_war_order_data:getLevel() or not ex.Player.promotion_data.prom_war_order_data:isBuySpecial()
    if special_data ~= "" then 
        for i,v in ipairs(special_data) do
            local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
            self.menu:addChild(item)
            local item_size = item:getContentSize()
            item_size.width = item_size.width * ITEM_SCALE + margin
            item:registerScriptTapHandler(handler(self,self.onSpecial))
            item:setScale(ITEM_SCALE)
            local x = begin_x + (i - 1) * item_size.width
            item:setPosition(x,pos_y)
            item:setSelected(geted)
            if geted then item:setGrayed() end 

            local sp_lock = cc.Sprite:createWithSpriteFrameName("prom-warorder/spr-lock.png")
            item:addChild(sp_lock)
            sp_lock:setPositionY(item:getContentSize().height)
            sp_lock:setVisible(lock)
            sp_lock:setLocalZOrder(1000)
        end
    end
end

function PROMWarOrderRewardCell:onBase(tag,pSender)
    if ex.Player.promotion_data.prom_war_order_data:getLevel(self.data.level) < self.data.level then 
        ex.Tools:showItemInfo(tag, pSender)
    else
        local geted = ex.Player.promotion_data.prom_war_order_data:getBaseRewardById(self.data.level) 
        if geted == true then return end 
        --send protocol
        local req_daily = Promotion090_pb.GReqTPermitLevelReward()
        req_daily.level = self.data.level
        NetManager:sendMessage(ProtocolID.GReqTPermitLevelReward,req_daily)
    end 
end

function PROMWarOrderRewardCell:onSpecial(tag,pSender)
    local is_lock = not ex.Player.promotion_data.prom_war_order_data:isBuySpecial() 
    if is_lock or ex.Player.promotion_data.prom_war_order_data:getLevel(self.data.level) < self.data.level then 
        ex.Tools:showItemInfo(tag, pSender)
    else
        local geted = ex.Player.promotion_data.prom_war_order_data:getSpecialRewardById(self.data.level)  
        if geted == true then return end 
        --send protocol
        local req_daily = Promotion090_pb.GReqTPermitLevelReward()
        req_daily.level = self.data.level
        NetManager:sendMessage(ProtocolID.GReqTPermitLevelReward,req_daily)
    end
end


return PROMWarOrderRewardCell