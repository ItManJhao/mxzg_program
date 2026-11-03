local RCGPrivilegeGiftLayer = class("RCGPrivilegeGiftLayer", require("src.layer.promotion.PromotionBaseLayer"))

-------------------------------------RCGPrivilegeGiftLayer----------------------------------------------------
function RCGPrivilegeGiftLayer:onCreateDone()
    self.config_list = {}
    self.select_idx = 0
    self.select_cell = nil

    self:setAutoClose(false)
    self:setSwallowTouches(false)

    local spr_banner = self:addBannerImage(ex.Player.promotion_data:getPromotionConfigByIdx(104))

    self:resetScrollView(nil, cc.size(0, 5))

    self:updateLayer()
    self:addEvent(EVENT.MAIN_CITY_RECHARGE.PRIVILEGE_GIFT, handler(self, self.updateLayer))
end

function RCGPrivilegeGiftLayer:onExit()
    
end

function RCGPrivilegeGiftLayer:updateLayer()
    local RCGPrivilegeGiftCell = require("src.layer.promotion.RCGPrivilegeGiftCell")
    local sfc = cc.SpriteFrameCache:getInstance()

    self.config_list = ex.Player.promotion_data:getPrivilegeGiftDatas()

    
    local cell_size = RCGPrivilegeGiftCell:createWithCCBIFile("ccbi/RCGPrivilegeGiftCell.ccbi"):getContentSize()
    local scale = self.scroll_view:getViewSize().width / cell_size.width
    cell_size.height = cell_size.height * scale + 5
    local height = table.nums(self.config_list) * cell_size.height
    height = math.max(height , self.scroll_view:getViewSize().height)
    self.scroll_view:getContainer():removeAllChildren()
    self.scroll_view:setContentSize(cc.size(self.scroll_view:getViewSize().width, height))
    self.scroll_view:setContentOffset(cc.p(0, self.scroll_view:getViewSize().height - height))
    
    local sort = function (a, b)
        -- if a.buy_count >= a.limit_num then
        --     if b.buy_count >= b.limit_num then
        --         return a.rank == b.rank and a.idx < b.idx or a.rank < b.rank
        --     else
        --         return false
        --     end
        -- else
        --     if b.buy_count >= b.limit_num then
        --         return true
        --     else
        --         return a.rank == b.rank and a.idx < b.idx or a.rank < b.rank
        --     end
        -- end

        local abuy = a.buy_count >= a.limit_num 
        local bbuy = b.buy_count >= b.limit_num

        if abuy == true and  a.idx == 100210 and ex.Player.god_equip_data.buy_status == 1 and ex.Player.god_equip_data.get_day == 0 then 
            abuy = false 
        end 

        if bbuy == true and  b.idx == 100210 and ex.Player.god_equip_data.buy_status == 1 and ex.Player.god_equip_data.get_day == 0 then 
            bbuy = false 
        end 


        if abuy == true  and bbuy == true  then 
            return a.rank == b.rank and a.idx < b.idx or a.rank < b.rank
        else 

            if abuy == true and bbuy == false  then 
                return false 
            elseif abuy == false and  bbuy == true then 
                return true
            else 
                return a.rank == b.rank and a.idx < b.idx or a.rank < b.rank
            end 
      
        end 


    end
    table.sort( self.config_list, sort )

    local item_size = cc.size(100, 0)
    local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")
    --for i,v in ipairs(self.config_list) do

    local height_i = 1
    for i,v in ipairs(self.config_list) do
        local cell = RCGPrivilegeGiftCell:createWithCCBIFile("ccbi/RCGPrivilegeGiftCell.ccbi")
        cell.data = v
        cell:setScale(scale)
        local nnheight = height - height_i * cell_size.height
        --cell:setPosition(0, height - height_i * cell_size.height)

        cell:setPosition(0, nnheight)
        self.scroll_view:getContainer():addChild(cell)
        height_i = height_i + 1
        cell.menu:setIsTouchInsideNode(self.scroll_view)
        cell.buy_btn:registerScriptTapHandler(handler(self, self.onBuy))
        cell.btn_enter:registerScriptTapHandler(handler(self, self.onEnter))

        cell.gift_name:setString(ex.Tools:getLang(cell.data.tag_language))
        cell.gift_desc:setXmlTextLua(ex.Tools:getLang(cell.data.item_language))
        cell.gift_desc:formatText()
        -- cell.gift_desc:setLineSpacing(-2.0)
        
        cell.time_limit_label:setString(ex.Tools:getLang(v.limit_language))
        
        local icon = tonumber(v.icon) or 1
        -- cell.gift_img:setSpriteFrame(sfc:getSpriteFrame(string.format("promotion/privilege-gift-%d.png", v.idx)))
        ex.Tools:setSpriteFrame(cell.gift_img, string.format("promotion/privilege-gift-%d.png", v.idx))
        local index = 1
        local space = 10
        -- dump(v.item, "v.item")
        local item_1 = nil
        for i,v1 in ipairs(v.item) do
            local item = ex.Player.backpack_data:createWithData(v1.item_type, v1.item_num)
            item:setScale(0.7)
            item:setPosition(130 + (index - 0.5) * item_size.width * item:getScale() + (index - 1) * space, 50)
            item:registerScriptTapHandler(handler(self, self.onItemInfo))
            cell.menu:addChild(item)

            index = index + 1

            if i == 1 then item_1 = item end
        end
        
        local buy_data = ex.Player.promotion_data:getPrivilegeGiftByIdx(v.idx)
        self:setBtnInfoByData(cell.buy_btn, cell.purchased_label, buy_data, v)

        -- 第一个添加极品标签
        if item_1 then
            local item_size = item_1:getContentSize()
            local item_1_left_top_pos = cc.p(item_1:getPositionX(), item_1:getPositionY())
            item_1_left_top_pos.x = item_1_left_top_pos.x - item_size.width * item_1:getScaleX() * 0.5
            item_1_left_top_pos.y = item_1_left_top_pos.y + item_size.height * item_1:getScaleY() * 0.5

            local spr_flag = cc.Sprite:createWithSpriteFrameName("promotion/spr-txt-19.png")
            spr_flag:setPosition(item_1_left_top_pos)
            cell:addChild(spr_flag, 10)
        end

        if v.limit_day == 0 then    -- 永久有效需要添加骨骼动画
            cell.node_corner_mark:setVisible(false)
            
            if ex.Player.promotion_data:isShowChaoZhiPrivilege(v.idx) then
                ex.Tools:setSpriteFrame(cell.buy_btn_flag, "promotion/caozhi.png")
            end
            if ex.Player.promotion_data:isShowBiMaiPrivilege(v.idx) then
                ex.Tools:setSpriteFrame(cell.buy_btn_flag, "promotion/spr-txt-18.png")
            end
            cell.buy_btn_flag:setVisible(cell.buy_btn:isVisible())
            
            local spine_anim = sp.SkeletonAnimation:create("spine/yjyx.json", "spine/yjyx.atlas", 1)
            spine_anim:setAnimation(0, "idle", true)
            spine_anim:setScale(1)
            spine_anim:setPosition(517, 107)
            cell:addChild(spine_anim, 20)
        else
            cell.buy_btn_flag:setVisible(false)
        end

        cell.spr_gift_name:setVisible(false)
        if ex.Player.promotion_data:isSpeedBattlePrivilege(v.idx) then
            cell.gift_name:setVisible(false)
            cell.spr_gift_name:setVisible(true)
            ex.Tools:setSpriteFrame(cell.spr_gift_name, "promotion/spr-txt-20.png")
            -- cell.spr_ribbon:setSpriteFrame(sfc:getSpriteFrame("promotion/spr-ribbon-6.png"))
            ex.Tools:setSpriteFrame(cell.spr_ribbon, "promotion/spr-ribbon-6.png")
        end
        if ex.Player.promotion_data:isAdvExpPrivilege(v.idx) then
            cell.gift_name:setVisible(false)
            cell.spr_gift_name:setVisible(true)
            ex.Tools:setSpriteFrame(cell.spr_gift_name, "promotion/spr-txt-21.png")
            -- cell.spr_ribbon:setSpriteFrame(sfc:getSpriteFrame("promotion/spr-ribbon-6.png"))
            ex.Tools:setSpriteFrame(cell.spr_ribbon, "promotion/spr-ribbon-6.png")
        end 

        cell.btn_enter:setVisible(false)
        -- 如果是什么神装特权
        if v.idx == 100210 and ex.Player.god_equip_data.buy_status == 1 then 
            -- 创建一个按钮
            cell.purchased_label:setVisible(false)
            ex.Player.promotion_data:checkPrivilegeGiftRedDot()

            if ex.Player.god_equip_data.get_day == 0 then 
                -- 显示领取
                
                cell.btn_enter:setVisible(true)
                cell.btn_enter:setLabelText(ex.Tools:getLang(47444))
                
                -- cell.btn_enter
                ex.Tools:addRedPoint(cell.btn_enter,true)
            else 
                cell.purchased_label:setVisible(true)
                -- 显示领取
                -- cell.btn_enter:setLabelText(ex.Tools:getLang(47677))
                ex.Tools:addRedPoint(cell.btn_enter,false)
            end 

        end 

    end
end

function RCGPrivilegeGiftLayer:setBtnInfoByData(btn, purchased_label, buy_data, config)

    print("buy_data", buy_data.idx, buy_data.end_time)

    local cur_time = ex.Game:getServerTime()
    
    if buy_data.end_time == 0 then 
        btn:setVisible(false)
        purchased_label:setVisible(true)
        purchased_label:setString(ex.Tools:getLang(47327))
        return 
    end 

    if buy_data.end_time < cur_time then
        btn:setVisible(true)
        purchased_label:setVisible(false)
        if config.buy_type == 1 then
            
            btn:setLabelText(string.format(ex.Tools:getLang(47404), config.buyGem_config.rmb / 100))
        else
            btn:setLabelText(string.format("%g", config.cost_gem))
            
            ex.Tools:addImgToUIMenuItemLabel(btn, nil, "backpack/900002.png", 0.4, -2.0)
        end
    else
        btn:setVisible(false)
        purchased_label:setVisible(true)

        if config.buy_type ~= 4 then
            local remain_time = buy_data.end_time - cur_time
            local day = math.floor(remain_time / 86400)
            if remain_time % 86400 ~= 0 then
                day = day + 1
            end
            purchased_label:setString(string.format( ex.Tools:getLang(41065), day))
        else
            purchased_label:setString(ex.Tools:getLang(47327))
        end
    end
end


function RCGPrivilegeGiftLayer:onEnter( tag, pSender)
    
    if ex.Player.god_equip_data.get_day == 0 then  
        ex.Player.god_equip_data.get_day = 1 

        NetManager:sendMessage(ProtocolID.GReqGetPrivilegeReward)
        
        self:updateLayer()
    else
        ex.MessageView:add(ex.Tools:getLang(47677))
    end 
end


function RCGPrivilegeGiftLayer:onBuy(tag, pSender)
    local cur_time = ex.Game:getServerTime()
    local idx = pSender:getParent():getParent().data.idx
    local buy_data = ex.Player.promotion_data:getPrivilegeGiftByIdx(idx)
    if buy_data ~= nil and buy_data.end_time > cur_time then    -- 不可购买
        ex.MessageView:add(ex.Tools:getLang(47563))
        return
    end
    

    if pSender:getParent():getParent().data.buy_type == 1 then 
        self.select_cell = pSender:getParent():getParent()
        self.select_cell.buy_btn:setEnabled(false)
        ex.Tools:setGray(self.select_cell.buy_btn:getNormalImage())

        ex.Player:pay(pSender:getParent():getParent().data.production_id)

    else 

        local need_gem = pSender:getParent():getParent().data.cost_gem
        if ex.Player.gem < need_gem then
            ex.MessageView:add(ex.Tools:getLang(1109))  -- 不可购买
            return
        end

        self.select_cell = pSender:getParent():getParent()
        self.select_idx = self.select_cell.data.idx
        ex.ConfirmCtr:openWindow(ex.Tools:getLang(47590), string.format(ex.Tools:getLang(47630), need_gem), handler(self, self.onBuyPrivilegeDone))


    end 

end

function RCGPrivilegeGiftLayer:onBuyPrivilegeDone(tag, pSender)
    ex.Player.promotion_data:buyPrivilegeGiftByIdx(self.select_idx)

    if self.select_cell then
        self.select_cell.buy_btn:setVisible(false)
        self.select_cell.purchased_label:setVisible(true)

        if self.select_cell.data.limit_day ~= 0 then
            local remain_time = self.select_cell.data.limit_day * 86400 - 1
            local day = math.floor(remain_time / 86400) + 1
            self.select_cell.purchased_label:setString(string.format( ex.Tools:getLang(41065), day))
        else
            self.select_cell.purchased_label:setString(ex.Tools:getLang(47327))
        end
        
        self:addTimer("timer",3000,handler(self,self.delayCheckBuyStatus),false, self.select_cell)
    end
end

function RCGPrivilegeGiftLayer:delayCheckBuyStatus(cell)
    if cell ~= nil then
        local data = cell.data
        if data ~= nil then
            local buy_data = ex.Player.promotion_data:getPrivilegeGiftByIdx(data.idx)
            self:setBtnInfoByData(cell.buy_btn, cell.purchased_label, buy_data, data)
        end
    end
    
    self:removeTimerByName("timer")
end

function RCGPrivilegeGiftLayer:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function RCGPrivilegeGiftLayer:getConfig(idx)
    if self.config_list ~= nil then
        for _,v in ipairs(self.config_list) do 
            if v.idx == idx then
                return v
            end
        end
    end

    return nil
end

return RCGPrivilegeGiftLayer