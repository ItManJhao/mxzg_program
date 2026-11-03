local PROMSuperGiftTargetCell = class("PROMSuperGiftTargetCell", require("src.comp.LuaLayerBase"))

function PROMSuperGiftTargetCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.promotion_id = 39
    self.items = {}

    self.btn_submit:registerScriptTapHandler(handler(self, self.onClickSubmit))
end

function PROMSuperGiftTargetCell:onClickSubmit(tag,pSender)
    if not ex.Player.promotion_data:getTimeIsOpen(self.promotion_id) then
        ex.MessageView:add(ex.Tools:getLang(41053))
        return
    end

    if not self.data.data.can_buy then
        ex.MessageView:add(ex.Tools:getLang(41153))
		return
    end

    self.btn_submit:setEnabled(false)

    ex.Player:pay(self.data.config.production_id)
end

function PROMSuperGiftTargetCell:onClick(tag,pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function PROMSuperGiftTargetCell:updateItem()
    for i,v in ipairs(self.items) do
        v:removeFromParent()
    end
    self.items = {}

    local begin = 24
    local margin = 5
    local posY = self:getContentSize().height / 2
    local scale = 0.75
    for i,v in ipairs(self.data.config.gift_reward) do
        local item = ex.Player.backpack_data:createWithData(v.item_type, v.item_num)
        local posX = (begin + item:getContentSize().width * scale / 2) + (i - 1) * ((item:getContentSize().width * scale) + margin)
    	
        item:setPosition(posX, posY)
        item:setScale(scale)
        item:registerScriptTapHandler(handler(self, self.onClick))
        self.menu:addChild(item)
        table.insert(self.items, item)
    end
end

function PROMSuperGiftTargetCell:reset(data)
    if not data then print("not data") return end
    self.data = data
    
    self:updateItem()

    if self.data.data.can_buy then
        self.btn_submit:setEnabled(true)

        self.btn_submit:setLabelText(string.format(ex.Tools:getLang(2705), self.data.data.rmb / 100))
    else
        self.btn_submit:setEnabled(false)
        self.btn_submit:setLabelText(ex.Tools:getLang(41152))
    end

    local str = string.format(ex.Tools:getLang(2706), math.max(0, self.data.config.buy_limit - self.data.data.buy_times))
    self.num_txt:setString(str)
end

return PROMSuperGiftTargetCell
