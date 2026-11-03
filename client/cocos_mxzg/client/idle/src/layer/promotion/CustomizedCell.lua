local CustomizedCell = class("CustomizedCell", require("src.comp.EventLayer"))
local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function CustomizedCell:onCreate()
	self:setAutoClose(false)
    self:setSwallowTouches(false)
    self.model = ex.Player.promotion_data.customized_data
    self:createMenu()
    self:setScale(ex.s.global_scale)
    self.btn_submit:registerScriptTapHandler(handler(self,self.onSubmit))
    self.btn_buy:registerScriptTapHandler(handler(self,self.onBuy))
end

function CustomizedCell:createMenu()
    self.item_memu = cpp.UIMenu:create()
    self:addChild(self.item_memu)
    self.item_memu:setPosition(0,0)
end

function CustomizedCell:reset(data)
    self.data = data
    self.item_memu:removeAllChildren()

    
    local str = ex.Tools:getLang(2730)

    str = string.format(str,cfg.buygem.buygem[self.data.product_id].rmb / 100)
    self.lbl_title:setString(str)

    local gem = cfg.buygem.buygem[self.data.product_id].item
    if type(gem) == "table" then 
        local x,y = self.gem_item:getPosition()
        local item = ex.Tools:createBackpackItem(gem[1].item_type, gem[1].item_num)
        self.item_memu:addChild(item)
        item:setPosition(x,y)
        item:setScale(0.7)
    end
    local custom_data = self.model:getCustomById(data.product_id)

    for i=1,3 do
        local node = self["item_"..i]
        local x,y = node:getPosition()
        local item_type = 0
        local item_num = 0
        if custom_data ~= nil and  custom_data.custom_reward_id[i] then 
            local idx = custom_data.custom_reward_id[i]
            local item_data = cfg.customreward.customreward[idx].reward[1]
            item_type = item_data.item_type
            item_num = item_data.item_num
        end
        local item = UIMenuItemBackpack:createWithData(item_type, item_num)
        self.item_memu:addChild(item)
        item:setScale(0.7)
        item:setPosition(x,y)
        item.spr_add = cc.Sprite:createWithSpriteFrameName("other/spr-add-1.png")
        item:addChild(item.spr_add)
        item.spr_add:setPosition(item:getContentSize().width/2,item:getContentSize().height/2)
        item.spr_add:setVisible(custom_data == nil)
        item:registerScriptTapHandler(handler(self, self.onItemClick))
    end

    self.btn_buy:setVisible(custom_data ~= nil)
    self.btn_submit:setVisible(custom_data == nil)

    self.lbl_btn_submit = cc.Label:createWithTTF(ex.Tools:getLang(2736), FONT_DEFAULT_NAME_BOLD, 20)
    self.btn_submit:addChild(self.lbl_btn_submit)
    self.lbl_btn_submit:setPosition(self.btn_submit:getContentSize().width * 0.5, self.btn_submit:getContentSize().height * 0.5)
    self.lbl_btn_submit:enableOutline(FONT_BROWN, 1)

    local str_buy = ex.Tools:getLang(2737)
    self.lbl_btn_buy = cc.Label:createWithTTF(string.format(str_buy,cfg.buygem.buygem[self.data.product_id].rmb / 100), FONT_DEFAULT_NAME_BOLD, 20)
    self.btn_buy:addChild(self.lbl_btn_buy)
    self.lbl_btn_buy:setPosition(self.btn_buy:getContentSize().width * 0.5, self.btn_buy:getContentSize().height * 0.5)
    self.lbl_btn_buy:enableOutline(FONT_BROWN, 1)

    local buy_count = custom_data ~= nil and custom_data.buy_count or 0
    self.lbl_count:setString(string.format(ex.Tools:getLang(2729),cfg.buygem.buygem[self.data.product_id].limit_times,buy_count,cfg.buygem.buygem[self.data.product_id].limit_times))

    local spr = self.btn_buy:getNormalImage()
    local gray = buy_count < cfg.buygem.buygem[self.data.product_id].limit_times
    ex.Tools:setGrayAuto(spr, not gray)

    self.btn_buy:setEnabled(gray)
    

end

function CustomizedCell:onItemClick(tag,pSender)
    require("src.layer.promotion.CustomizedSelectedCtr"):instance():openWindow(self.data)
end

function CustomizedCell:onSubmit(tag,pSender)
    require("src.layer.promotion.CustomizedSelectedCtr"):instance():openWindow(self.data)
end

function CustomizedCell:onBuy(tag,pSender)
    ex.Player:pay(self.data.product_id)
end

return CustomizedCell
