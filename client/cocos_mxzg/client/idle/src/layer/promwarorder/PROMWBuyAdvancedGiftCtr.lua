local PROMWBuyAdvancedGiftCtr = class("PROMWBuyAdvancedGiftCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PROMWBuyAdvancedGiftLayer = class("PROMWBuyAdvancedGiftLayer", require("src.comp.EventLayer"))

function PROMWBuyAdvancedGiftLayer:onCreate()
    self:addBlackBackground()
    print("PROMWBuyAdvancedGiftLayer:onCreate")
    self:setTextStr()
    print("%%%%%%………………………………………………………………………………………………###########")
    dump(cfg.promotion090trafficpermitgift.promotion090trafficpermitgift[1])
    self.cfg = cfg.promotion090trafficpermitgift.promotion090trafficpermitgift[1]
    self:createItemByScrollView(self.scroll_view_base,self.cfg.reward)
    self:createItemByScrollView(self.scroll_view_special,self.cfg.reward_mechanism)
    local rmb = cfg.buygem.buygem[self.cfg.production_id].rmb
    local str = ex.Player.promotion_data.prom_war_order_data:isBuySpecial() == false and (string.format( ex.Tools:getLang(70610) , rmb / 100)) or ex.Tools:getLang(70617)
    self.lbl_btn_buy:setString(str)
    self.lbl_tips:setString(ex.Tools:getLang(70622))
    self:addEvent(EVENT.WAR_ORDER_ACTIVE.BUY_SPECIAL,handler(self,self.onSpecial))
end

function PROMWBuyAdvancedGiftLayer:onSpecial(event,data)
    local rmb = cfg.buygem.buygem[self.cfg.production_id].rmb
    local str = ex.Player.promotion_data.prom_war_order_data:isBuySpecial() == false and (string.format( ex.Tools:getLang(70610) , rmb / 100)) or ex.Tools:getLang(70617)
    self.lbl_btn_buy:setString(str)
end

function PROMWBuyAdvancedGiftLayer:setTextStr( )
    self.lbl_active_base:setString(ex.Tools:getLang(70608))
    self.lbl_active_base:enableOutline(cc.c4b(132,64,40,255), 1)
    self.lbl_active_special:setString(ex.Tools:getLang(70609))
    self.lbl_active_special:enableOutline(cc.c4b(132,64,40,255), 1)

    local str = (not ex.Player.promotion_data.prom_war_order_data:isBuySpecial()) and ex.Tools:getLang(70610) or ex.Tools:getLang(70617)
    self.lbl_btn_buy = cc.Label:createWithTTF(str, FONT_DEFAULT_NAME_BOLD, 28)
    self.lbl_btn_buy:setColor(cc.c4b(132,64,40,255))
    self.btn_buy:addChild(self.lbl_btn_buy)
    self.lbl_btn_buy:setPosition(self.btn_buy:getContentSize().width * 0.5, self.btn_buy:getContentSize().height * 0.5)
    self.btn_buy:registerScriptTapHandler(handler(self, self.onBuy))
    self.btn_buy:setEnabled(not ex.Player.promotion_data.prom_war_order_data:isBuySpecial())
end

function PROMWBuyAdvancedGiftLayer:onBuy(tag,pSender)
    pSender:setEnabled(false)
    print("self.cfg.production_id==", self.cfg.production_id)
    ex.Player:pay(self.cfg.production_id)
end

function PROMWBuyAdvancedGiftLayer:createItemByScrollView(scroll_view,data)
    scroll_view:getContainer():removeAllChildren()
    local menu = cpp.UIMenu:create()
    :setIsTouchInsideNode(scroll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    scroll_view:addChild(menu)

    local margin = 10
    local item_size
    local scroll_width = 0
    if not data then
        data = {}
    end
    for i,v in ipairs(data) do
        local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
        item:setAnchorPoint(cc.p(0,0))
        menu:addChild(item)
        item_size = item:getContentSize()
        print(item_size.width * 0.8)
        item_size.width = item_size.width * 0.8 + margin
        scroll_width = scroll_width +item_size.width
        
        item:registerScriptTapHandler(handler(self,self.onInfo))
        item:setScale(0.8)
        local x = margin + (i - 1) * item_size.width
        item:setPosition(x,0)
    end

    if (item_size) then
        scroll_view:setContentSize(cc.size(scroll_width + margin, item_size.height * 0.8))
    end
end

function PROMWBuyAdvancedGiftLayer:onInfo(tag,pSender)
    ex.Tools:showItemInfo(tag, pSender)
end

-----------------------------------------------------------------------------
function PROMWBuyAdvancedGiftCtr:onCreate()
    self:setCCBIPath("ccbi/PROMWBuyAdvancedGiftLayer.ccbi")
    self:setIsSingle(false)
end

function PROMWBuyAdvancedGiftCtr:getLayerClass()
    return PROMWBuyAdvancedGiftLayer
end

function PROMWBuyAdvancedGiftCtr:getClanRankLayer()
    return self.layer
end

function PROMWBuyAdvancedGiftCtr:openWindow(str_content)
    if self:isOpened() then
        return
    end

    self.str_content = str_content

    self:loadLayer()
    self:open()
    self:initData()
end

function PROMWBuyAdvancedGiftCtr:initData()
    -- self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    -- self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))
end


return PROMWBuyAdvancedGiftCtr
