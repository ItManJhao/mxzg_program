local BuyAdvancedGiftCtr = class("BuyAdvancedGiftCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local BuyAdvancedGiftLayer = class("BuyAdvancedGiftLayer", require("src.comp.EventLayer"))

function BuyAdvancedGiftLayer:onCreate()
    self:addBlackBackground()

    self:setTextStr()
    self.cfg = cfg.promotiontrafficpermitgift.point[ex.Player.promotion_data.new_year_data.round]
    self:createItemByScrollView(self.scroll_view_base,self.cfg.reward)
    self:createItemByScrollView(self.scroll_view_special,self.cfg.reward_mechanism)
    local rmb = cfg.buygem.buygem[self.cfg.production_id].rmb
    local str = ex.Player.promotion_data.new_year_data:isBuySpecial() == false and (string.format( ex.Tools:getLang(70610) , rmb / 100)) or ex.Tools:getLang(70617)
    self.lbl_btn_buy:setString(str)
    self.lbl_tips:setString(ex.Tools:getLang(70622))
    self:addEvent(EVENT.NEW_YEAR_ACTIVE.BUY_SPECIAL,handler(self,self.onSpecial))
end

function BuyAdvancedGiftLayer:onSpecial(event,data)
    local rmb = cfg.buygem.buygem[self.cfg.production_id].rmb
    local str = ex.Player.promotion_data.new_year_data:isBuySpecial() == false and (string.format( ex.Tools:getLang(70610) , rmb / 100)) or ex.Tools:getLang(70617)
    self.lbl_btn_buy:setString(str)
end

function BuyAdvancedGiftLayer:setTextStr( )
    self.lbl_active_base:setString(ex.Tools:getLang(70608))
    self.lbl_active_base:enableOutline(cc.c4b(132,64,40,255), 1)
    self.lbl_active_special:setString(ex.Tools:getLang(70609))
    self.lbl_active_special:enableOutline(cc.c4b(132,64,40,255), 1)

    local str = (not ex.Player.promotion_data.new_year_data:isBuySpecial()) and ex.Tools:getLang(70610) or ex.Tools:getLang(70617)
    self.lbl_btn_buy = cc.Label:createWithTTF(str, FONT_DEFAULT_NAME_BOLD, 28)
    self.lbl_btn_buy:setColor(cc.c4b(132,64,40,255))
    self.btn_buy:addChild(self.lbl_btn_buy)
    self.lbl_btn_buy:setPosition(self.btn_buy:getContentSize().width * 0.5, self.btn_buy:getContentSize().height * 0.5)
    self.btn_buy:registerScriptTapHandler(handler(self, self.onBuy))
    self.btn_buy:setEnabled(not ex.Player.promotion_data.new_year_data:isBuySpecial())
end

function BuyAdvancedGiftLayer:onBuy(tag,pSender)
    pSender:setEnabled(false)
    ex.Player:pay(self.cfg.production_id)
end

function BuyAdvancedGiftLayer:createItemByScrollView(scroll_view,data)
    scroll_view:getContainer():removeAllChildren()
    local menu = cpp.UIMenu:create()
    :setIsTouchInsideNode(scroll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    scroll_view:addChild(menu)

    local margin = 10
    local item_size
    local scroll_width = 0
    for i,v in ipairs(data) do
        local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
        item:setAnchorPoint(cc.p(0,0))
        menu:addChild(item)
        item_size = item:getContentSize()
        item_size.width = item_size.width * 0.8 + margin
        scroll_width = scroll_width +item_size.width
        
        item:registerScriptTapHandler(handler(self,self.onInfo))
        item:setScale(0.8)
        local x = margin + (i - 1) * item_size.width
        item:setPosition(x,0)
    end

    scroll_view:setContentSize(cc.size(scroll_width + margin, item_size.height * 0.8))
end

function BuyAdvancedGiftLayer:onInfo(tag,pSender)
    ex.Tools:showItemInfo(tag, pSender)
end

-----------------------------------------------------------------------------
function BuyAdvancedGiftCtr:onCreate()
    self:setCCBIPath("ccbi/BuyAdvancedGiftLayer.ccbi")
    self:setIsSingle(false)
end

function BuyAdvancedGiftCtr:getLayerClass()
    return BuyAdvancedGiftLayer
end

function BuyAdvancedGiftCtr:getClanRankLayer()
    return self.layer
end

function BuyAdvancedGiftCtr:openWindow(str_content)
    if self:isOpened() then
        return
    end

    self.str_content = str_content

    self:loadLayer()
    self:open()
    self:initData()
end

function BuyAdvancedGiftCtr:initData()
    -- self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    -- self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))
end


return BuyAdvancedGiftCtr
