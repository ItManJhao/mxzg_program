local PROMWBuyLevelCtr = class("PROMWBuyLevelCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PROMWBuyLevelLayer = class("PROMWBuyLevelLayer", require("src.comp.EventLayer"))

function PROMWBuyLevelLayer:onCreate()
    self:addBlackBackground()
    self.select_num = 1
    self.total_num = 0
    self.cur_level = ex.Player.promotion_data.prom_war_order_data:getLevel()
    self.select_level = self.cur_level + 1 
    self.can_buy_num = ex.Player.promotion_data.prom_war_order_data:getCanBuyLevel() - self.cur_level
    if self.can_buy_num <= 0 then self.can_buy_num = 1 end
    self.btn_buy:registerScriptTapHandler(handler(self,self.onBuy))
    self.lbl_btn_buy = cc.Label:createWithTTF(ex.Tools:getLang(41201), FONT_DEFAULT_NAME_BOLD, 28)
    self.lbl_btn_buy:setColor(cc.c4b(132,64,40,255))
    self.btn_buy:addChild(self.lbl_btn_buy)
    self.lbl_btn_buy:setPosition(self.btn_buy:getContentSize().width * 0.5, self.btn_buy:getContentSize().height * 0.5)
    -- self.item_price = {}
    -- self.item_price.item_type = ItemType.VIP_EXP
    -- self.item_price.item_num = 1
    self:createRich()
    self:upScrollViewWithPrice()

    self.view_titles:setPositionY(self.view_titles:getPositionY() - 10)

    self:creatSlider()
    self:addEvent(EVENT.WAR_ORDER_ACTIVE.UP_LEVEL,handler(self,self.onLevel))
end

function PROMWBuyLevelLayer:onLevel(event,data)
    local ctr = PROMWBuyLevelCtr:instance()
    if ctr:isOpened() then 
        ctr:closeWindow()
    end
end

function PROMWBuyLevelLayer:onBuy(tag,pSender)
    -- 
    local req_daily = Promotion090_pb.GReqTPermitBuyLevel()
    req_daily.level = self.select_num
    NetManager:sendMessage(ProtocolID.GReqTPermitBuyLevel,req_daily)
end

function PROMWBuyLevelLayer:createRich( )
    local x,y = self.base_rich_node:getPosition()
    self.base_rich = cpp.RichTextEx:createWithXMLLua("")
	self.base_rich:setFontSize(44)
	self.base_rich:setScale(0.5)
	self.base_rich:setFontFace(FONT_DEFAULT_NAME_BOLD)
	self.base_rich:setFontColor("#7A472D")
	self.base_rich:setAnchorTextShadow(false)
	self.base_rich:setAnchorPoint(ex.a.center)
    self.base_rich:setPosition(cc.p(x,y))
    self.base_rich:setLocalZOrder(10)
    self.base_rich:enableOutline(cc.c4b(0,0,0,255))
    self:addChild(self.base_rich)

    x,y = self.special_rich_node:getPosition()
    self.special_rich = cpp.RichTextEx:createWithXMLLua("")
	self.special_rich:setFontSize(44)
	self.special_rich:setScale(0.5)
	self.special_rich:setFontFace(FONT_DEFAULT_NAME_BOLD)
	self.special_rich:setFontColor("#7A472D")
	self.special_rich:setAnchorTextShadow(false)
	self.special_rich:setAnchorPoint(ex.a.center)
    self.special_rich:setPosition(cc.p(x,y))
    self.special_rich:setLocalZOrder(10)
    self.special_rich:enableOutline(cc.c4b(0,0,0,255))
    self:addChild(self.special_rich)

    x,y = self.buy_rich_node:getPosition()

    self.buy_rich = cpp.RichTextEx:createWithXMLLua("")
	self.buy_rich:setFontSize(44)
	self.buy_rich:setScale(0.5)
	self.buy_rich:setFontFace(FONT_DEFAULT_NAME_BOLD)
	self.buy_rich:setFontColor("#7A472D")
	self.buy_rich:setAnchorTextShadow(false)
	self.buy_rich:setAnchorPoint(ex.a.center)
    self.buy_rich:setPosition(cc.p(x,y))
    self.buy_rich:setLocalZOrder(10)
    self.buy_rich:enableOutline(cc.c4b(0,0,0,255))
    self:addChild(self.buy_rich)
end

function PROMWBuyLevelLayer:setRichString()

end

function PROMWBuyLevelLayer:upScrollViewWithPrice( )
    local conf = ex.Player.promotion_data.prom_war_order_data:getCanBuyLevelItem(self.select_level)
    local total = 0
    local base_num = 0
    local special_num = 0
    self.btn_buy:setEnabled(conf ~= nil)
    if not conf then 
        self.lbl_total_num:setString(total)
        local str = string.format( ex.Tools:getLang(70613) , 0, base_num )
        self.base_rich:setXmlTextLua(str)
    
        str = string.format( ex.Tools:getLang(70614) , special_num )
        self.special_rich:setXmlTextLua(str)
    
        str = string.format( ex.Tools:getLang(70615) , 0,0)
        self.buy_rich:setXmlTextLua(str)

        self:createItemByScrollView(self.scroll_view_base,nil)
        self:createItemByScrollView(self.scroll_view_special,nil)
        return 
    end

    total = conf.cost.item_num
    base_num = table.nums(conf.base_items) 
    special_num = table.nums(conf.special_items) 
    self.lbl_total_num:setString(total)
    self:createItemByScrollView(self.scroll_view_base,conf.base_items)
    self:createItemByScrollView(self.scroll_view_special,conf.special_items)

    local str = string.format( ex.Tools:getLang(70613) , self.select_num , base_num )
    self.base_rich:setXmlTextLua(str)

    str = string.format( ex.Tools:getLang(70614) , special_num )
    self.special_rich:setXmlTextLua(str)

    str = string.format( ex.Tools:getLang(70615) , self.select_num,self.select_level)
    self.buy_rich:setXmlTextLua(str)
    self.scroll_view_base:setContentOffset(cc.p(0,0))
    self.scroll_view_special:setContentOffset(cc.p(0,0))
end

function PROMWBuyLevelLayer:createItemByScrollView(scroll_view,data)
    scroll_view:getContainer():removeAllChildren()
    if not data then return end 
    local menu = cpp.UIMenu:create()
    :setIsTouchInsideNode(scroll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    scroll_view:addChild(menu)

    local margin = 10
    local item_size = cc.size(0,0)
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

function PROMWBuyLevelLayer:onInfo(tag,pSender)
    ex.Tools:showItemInfo(tag,pSender)
end

function PROMWBuyLevelLayer:creatSlider( )
    self.progress = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("item-select/progress.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.prog_bg:addChild(self.progress)
    self.progress:setPosition(self.prog_bg:getContentSize().width / 2 ,self.prog_bg:getContentSize().height * 0.5 + 1 )

    self.progress:setPercentage(0)
    self.slider_select = ccui.Slider:create()
    -- :loadBarTexture("buy/prog-1.png", 1)
    self.slider_select:setScale9Enabled(true)
    self.slider_select:loadSlidBallTextures("item-select/spr-slider-1.png", "item-select/spr-slider-1.png", "item-select/spr-slider-1.png", 1)
    self.slider_select:setPosition(self.prog_bg:getPositionX(), self.prog_bg:getPositionY())

    self.slider_select:setContentSize(self.prog_bg:getContentSize().width, self.prog_bg:getContentSize().height)
    self.slider_select:setPercent(0)
    -- self.slider_select:setLocalZOrder(100)
    self.slider_select:addTo(self)
    self.slider_select:addEventListener(function(ref, eventType)
        self.progress:setPercentage(ref:getPercent())

        local can_buy_num = self:getCanBuyNum() - 1
        local num = math.min(math.floor(can_buy_num * ref:getPercent() / 100), can_buy_num)
        if num + 1 == self.select_num then
            return
        end

        self.select_num = num + 1
        self.select_level = self.select_num  + self.cur_level
        self:updateSelectNum()
    end)
end


function PROMWBuyLevelLayer:onSub(tag, pSender)
    self.select_num = self.select_num - 1
    if self.select_num < 1 then
        self.select_num = 1
    end
    self.select_level = self.select_num  + self.cur_level
    local can_buy_num = self:getCanBuyNum()
    local percentage = self.select_num * 100.0 / can_buy_num
    
    self.progress:setPercentage(percentage)
    self.slider_select:setPercent(percentage)

    self:updateSelectNum()
end

function PROMWBuyLevelLayer:onAdd(tag, pSender)
    local can_buy_num = self:getCanBuyNum()
    self.select_num = self.select_num + 1
    if self.select_num > can_buy_num then
        self.select_num = can_buy_num
    end
    self.select_level = self.select_num + self.cur_level
    
    local percentage = (self.select_num) * 100.0 / can_buy_num
    
    self.progress:setPercentage(percentage)
    self.slider_select:setPercent(percentage)

    self:updateSelectNum()
end

function PROMWBuyLevelLayer:onMax(tag, pSender)
    local can_buy_num = self:getCanBuyNum()
    self.select_num = can_buy_num
    self.select_level = can_buy_num + self.cur_level
    
    self.progress:setPercentage(100)
    self.slider_select:setPercent(100)

    self:updateSelectNum()
end

function PROMWBuyLevelLayer:updateSelectNum()
    -- self.lbl_select_num:setString(tostring(self.select_num))
    -- self.lbl_total_num:setString(ex.StringUtil.getScientificNumber(self.select_num * self.item_price.item_num))
    self:upScrollViewWithPrice()
end

function PROMWBuyLevelLayer:getCanBuyNum()
     return self.can_buy_num
    -- if self.total_num > 0 then
    --     return math.min(self.total_num, math.floor(ex.Player:getItemNum(self.item_price.item_type) / self.item_price.item_num))
    -- else
    --     return math.min(9999, math.floor(ex.Player:getItemNum(self.item_price.item_type) / self.item_price.item_num))
    -- end
end

function PROMWBuyLevelLayer:setItem(item)
    -- local config = cfg.item.item[item.item_type]

    -- self.item_type = item.item_type

    -- self.spr_item_icon:setSpriteFrame(config.icon..".png")
    -- self.lbl_item_name:setString(ex.Tools:getLang(config.name))
    -- self.lbl_item_num:setString(ex.StringUtil.getScientificNumber(item.item_num))
end

function PROMWBuyLevelLayer:updateItemLimit()
    if not self.lbl_limit then
        return
    end
    if self.limit == nil or self.limit <= 0 then
        self.lbl_limit:setVisible(false)
        return
    end

    self.lbl_limit:setVisible(true)

    self.lbl_limit:setString(string.format(ex.Tools:getLang(41229), tostring(self.limit)))
end

function PROMWBuyLevelLayer:updateItemPrice()
    if not self.lbl_res_need then
        return
    end
    if self.item_price == nil or self.item_price.item_num <= 0 then
        self.node_price:setVisible(false)
        self.lbl_total_num_tip:setVisible(false)
        self.lbl_total_num:setVisible(false)
        return
    end

    self.node_price:setVisible(true)
    self.lbl_total_num_tip:setVisible(true)
    self.lbl_total_num:setVisible(true)

    local config = cfg.item.item[self.item_price.item_type]
    self.price = self.item_price.item_num

    self.spr_res_need:setSpriteFrame(config.icon..".png")
    self.lbl_res_need:setString(ex.StringUtil.getScientificNumber(self.item_price.item_num))
    self.lbl_total_num:setString(tostring(self.price * self.select_num))
end

-----------------------------------------------------------------------------
function PROMWBuyLevelCtr:onCreate()
    self:setCCBIPath("ccbi/PROMWBuyLevelLayer.ccbi")
    self:setIsSingle(false)
end

function PROMWBuyLevelCtr:getLayerClass()
    return PROMWBuyLevelLayer
end

function PROMWBuyLevelCtr:getClanRankLayer()
    return self.layer
end

function PROMWBuyLevelCtr:openWindow(item, item_price, item_limit_num)
    if self:isOpened() then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/item-select.plist")

    -- self.str_content = str_content

    self:loadLayer()
    self:open()
    self:initData(item, item_price, item_limit_num)
end

function PROMWBuyLevelCtr:initData(item, item_price, item_limit_num)

    self.item_price = item_price
    self.limit = item_limit_num
    self.layer.item_price = item_price and item_price or {item_type=900002,item_num=0}
    self.layer.total_num = item_limit_num and item_limit_num or -1


    self.layer:setItem(item)
    self.layer:updateItemPrice()
    self.layer:updateItemLimit()

    self.layer:updateSelectNum()

    local can_buy_num = self.layer:getCanBuyNum()
    if can_buy_num <= 1 then
        self.layer.progress:setPercentage(100)
        self.layer.slider_select:setPercent(100)

        self.layer.slider_select:setEnabled(false)
    else
        local percentage = self.layer.select_num * 100.0 / can_buy_num
        self.layer.progress:setPercentage(percentage)
        self.layer.slider_select:setPercent(percentage)
    end
    -- self.layer.slider_select:setEnabled(true)
end


return PROMWBuyLevelCtr
