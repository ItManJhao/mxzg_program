local CountryWarBuyRewardCtr = class("CountryWarBuyRewardCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local CountryWarBuyRewardLayer = class("CountryWarBuyRewardLayer", require("src.comp.EventLayer"))


function CountryWarBuyRewardLayer:onCreate()
    self:addBlackBackground()
    self:setTextStr()
    self.cfg = cfg.countrywarmissiongift.countrywarmissiongift[ctr.country_war.data.type]
    self:createItemByScrollView(self.scroll_view,self.cfg.reward)
    local rmb = cfg.buygem.buygem[self.cfg.production_id].rmb
    local str = ctr.country_war.data.score_buy_gem == false and (string.format( ex.Tools:getLang(70610) , rmb / 100)) or ex.Tools:getLang(70617)
    self.lbl_btn_buy:setString(str)
    ex.Tools:setLimitWidth(self.lbl_title, 150)
    ex.Tools:setLimitWidth(self.lbl_title_2, 150)
    self:addEvent(EVENT.COUNTRY_WAR.UPDATE_BUY_GIFT,handler(self,self.onSpecial))
end

function CountryWarBuyRewardLayer:onSpecial(event,data)
    local rmb = cfg.buygem.buygem[self.cfg.production_id].rmb
    local str = ctr.country_war.data.score_buy_gem == false and (string.format( ex.Tools:getLang(70610) , rmb / 100)) or ex.Tools:getLang(70617)
    self.lbl_btn_buy:setString(str)
end

function CountryWarBuyRewardLayer:setTextStr( )
    local str = (not ctr.country_war.data.score_buy_gem) and ex.Tools:getLang(70610) or ex.Tools:getLang(70617)
    self.lbl_btn_buy = cc.Label:createWithTTF(str, FONT_DEFAULT_NAME_BOLD, 22)
    self.lbl_btn_buy:setColor(cc.c4b(132,64,40,255))
    self.btn_buy:addChild(self.lbl_btn_buy)
    self.lbl_btn_buy:setPosition(self.btn_buy:getContentSize().width * 0.5, self.btn_buy:getContentSize().height * 0.5)
    self.btn_buy:registerScriptTapHandler(handler(self, self.onBuy))
    self.btn_buy:setEnabled(not ctr.country_war.data.score_buy_gem)
end

function CountryWarBuyRewardLayer:onBuy(tag,pSender)
    pSender:setEnabled(false)
    ex.Player:pay(self.cfg.production_id)
end

function CountryWarBuyRewardLayer:createItemByScrollView(scroll_view,data)
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
        print(item_size.width * 0.8)
        item_size.width = item_size.width * 0.8 + margin
        scroll_width = scroll_width +item_size.width
        
        item:registerScriptTapHandler(handler(self,self.onInfo))
        item:setScale(0.8)
        local x = margin + (i - 1) * item_size.width
        item:setPosition(x,0)
    end

    scroll_view:setContentSize(cc.size(scroll_width + margin, item_size.height * 0.8))
end

function CountryWarBuyRewardLayer:onInfo(tag,pSender)
    ex.Tools:showItemInfo(tag, pSender)
end

-----------------------------------------------------------------------------
function CountryWarBuyRewardCtr:onCreate()
    self:setCCBIPath("ccbi/CountryWarBuyRewardLayer.ccbi")
    self:setIsSingle(false)
end

function CountryWarBuyRewardCtr:getLayerClass()
    return CountryWarBuyRewardLayer
end

function CountryWarBuyRewardCtr:getClanRankLayer()
    return self.layer
end

function CountryWarBuyRewardCtr:openWindow(str_content)
    if self:isOpened() then
        return
    end

    self.str_content = str_content

    self:loadLayer()
    self:open()
    self:initData()
end

function CountryWarBuyRewardCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
end


return CountryWarBuyRewardCtr
