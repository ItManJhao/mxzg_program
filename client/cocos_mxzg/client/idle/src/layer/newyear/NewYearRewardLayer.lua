local NewYearRewardLayer = class("HeroLayer", require("src.comp.EventLayerAdaptiveWidth"))
local ITEM_SCALE = 0.8

function NewYearRewardLayer:onCreate()
    self:setLabelText()
    self:createTableView()
    self:showViewLevel()
    self.unlock_panel:setVisible(not ex.Player.promotion_data.new_year_data:isBuySpecial())
    local red = ex.Player.promotion_data.new_year_data:getRewardRed()
    ex.Tools:addRedPoint(self.btn_one_key,red,{x = 0.95,y = 0.9})
    self.btn_one_key:registerScriptTapHandler(handler(self, self.onOneKey))
    self.btn_tips:registerScriptTapHandler(handler(self, self.onTips))
    self:addEvent(EVENT.NEW_YEAR_ACTIVE.UP_LEVEL,handler(self,self.onUpLevel))
    self:addEvent(EVENT.NEW_YEAR_ACTIVE.BUY_SPECIAL,handler(self,self.onBuySpecial))
    self:addEvent(EVENT.NEW_YEAR_ACTIVE.ONE_KEY_GET_REWARD,handler(self,self.onGetReward))
end

function NewYearRewardLayer:onTips(tag,pSender)
    require("src.layer.newyear.BuyAdvancedGiftCtr"):instance():openWindow()
end

function NewYearRewardLayer:showViewLevel( )
    local level = ex.Player.promotion_data.new_year_data:getLevel()
    local max = ex.Player.promotion_data.new_year_data:getMaxLevel()
    local conf 
    local next_level
    if max == level then
        conf = cfg.promotiontrafficpermitreward.reward[max]
        next_level = max
    else
        for i=level+1,max do
            local data = cfg.promotiontrafficpermitreward.reward[i]
            if data.show_gain == 1 then 
                conf = data 
                next_level = data.level
                break
            end
        end
    end
    self.lbl_next_level:setString(next_level)

    if not self.show_menu then 
        self.show_menu = cpp.UIMenu:create()
        self.show_node:addChild(self.show_menu)
        self.show_menu:setPosition(cc.p(0,0))
    end

    self.show_menu:removeAllChildren()

    if conf.finish_reward ~= "" and table.nums(conf.finish_reward) > 0 then 
        local base_data = conf.finish_reward[1]
        local pos_x ,pos_y = self.base_node:getPosition() 
        local base_item = ex.Tools:createBackpackItem(base_data.item_type, base_data.item_num)
        self.show_menu:addChild(base_item)
        base_item:setPosition(pos_x,pos_y)
        base_item:registerScriptTapHandler(handler(self,self.showInfo))
        base_item:setScale(ITEM_SCALE)
    end

    local margin = 10 
    local begin_x  = self.special_node:getPositionX()
    pos_y = self.special_node:getPositionY()
    if conf.privilege_reward ~= "" then 
        for i,v in ipairs(conf.privilege_reward) do
            local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
            self.show_menu:addChild(item)
            local item_size = item:getContentSize()
            item_size.width = item_size.width * ITEM_SCALE + margin
            item:registerScriptTapHandler(handler(self,self.showInfo))
            item:setScale(ITEM_SCALE)
            local x = begin_x + (i - 1) * item_size.width
            item:setPosition(x,pos_y)

            local sp_lock = cc.Sprite:createWithSpriteFrameName("new-year/spr-lock.png")
            item:addChild(sp_lock)
            sp_lock:setPositionY(item:getContentSize().height)
            sp_lock:setVisible(lock)
            sp_lock:setLocalZOrder(1000)
        end
    end
end

function NewYearRewardLayer:showInfo(tag,pSender)
    ex.Tools:showItemInfo(tag,pSender)
end

function NewYearRewardLayer:onGetReward(event,data)
    local posY = self.table_view:getContainer():getPositionY()
    self.table_view:initData(self.cell_data)
    self.table_view:setContentOffset(cc.p(0,posY))
    local red = ex.Player.promotion_data.new_year_data:getRewardRed()
    ex.Tools:addRedPoint(self.btn_one_key,red,{x = 0.95,y = 0.9})
end

function NewYearRewardLayer:onBuySpecial(event,data)
    local posY = self.table_view:getContainer():getPositionY()
    self.table_view:initData(self.cell_data)
    self.table_view:setContentOffset(cc.p(0,posY))
    local red = ex.Player.promotion_data.new_year_data:getRewardRed()
    ex.Tools:addRedPoint(self.btn_one_key,red,{x = 0.95,y = 0.9})
    self.unlock_panel:setVisible(not ex.Player.promotion_data.new_year_data:isBuySpecial())
    self:showViewLevel()
end

function NewYearRewardLayer:onOneKey(tag,pSender)
    local can  = ex.Player.promotion_data.new_year_data:canOneKeyReward()
    if not can then return end 
    local req_daily = Promotion053_pb.GReqTrafficPermitAllReward()
	NetManager:sendMessage(ProtocolID.GReqTrafficPermitAllReward,req_daily)
end

function NewYearRewardLayer:onUpLevel(event,data)
    self:showViewLevel()
    local posY = self.table_view:getContainer():getPositionY()
    self.table_view:initData(self.cell_data)
    self.table_view:setContentOffset(cc.p(0,posY))
    local red = ex.Player.promotion_data.new_year_data:getRewardRed()
    ex.Tools:addRedPoint(self.btn_one_key,red,{x = 0.95,y = 0.9})
end

function NewYearRewardLayer:createTableView( )
    local rewward_data = {}
    local round = ex.Player.promotion_data.new_year_data.round
    for i,v in ipairs(cfg.promotiontrafficpermitreward.reward) do
        if v.round == round then
            table.insert( rewward_data, clone(v) )
        end
    end
    self.cell_data = rewward_data
    local obj = {require("src.layer.newyear.NewYearRewardCell"), "ccbi/NewYearRewardCell.ccbi"}
    local size = self.spr_bg:getContentSize()
    size.width = size.width - 10
    size.height = size.height - 10
    self.table_view = ex.Tools:initTableView(self.spr_bg,self.cell_data, obj , size, 5 , cc.p(5,5))
end

function NewYearRewardLayer:setLabelText( )
    local str = ex.Tools:getLang(26)
    self.btn_one_key:setLabelText(str)
    self.btn_one_key:setLabelColor(cc.c4b(132,64,40,255))

    self.lbl_reward_title:setString(ex.Tools:getLang(41023))
    self.lbl_level_title:setString(ex.Tools:getLang(70602))
    self.lbl_base:setString(ex.Tools:getLang(70603))
    self.lbl_special:setString(ex.Tools:getLang(70604))
end

return NewYearRewardLayer