local HeroListDragonLayer = class("HeroListDragonLayer", require("src.comp.EventLayer"))

local HeroListDragonLayerType = {}
HeroListDragonLayerType.ROOM = 10      -- 龙界
HeroListDragonLayerType.WEAR = 20      -- 龙祭

function HeroListDragonLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    
    self.btn_tab_1:setLabelOffset(cc.p(0, -3))
    self.btn_tab_2:setLabelOffset(cc.p(0, -3))

    self.btn_tab_1:setLabelText(ex.Tools:getLang(74502))
    self.btn_tab_2:setLabelText(ex.Tools:getLang(74503))

    -- 初始化子层
    self.layer_room = require("src.layer.herolist.HeroListDragonRoomLayer"):createWithCCBIFile("ccbi/HeroListDragonRoomLayer.ccbi")
	self.layer_room:setPosition(self:getContentSize().width / 2 - self.layer_room:getContentSize().width / 2, 0)
    self:addChild(self.layer_room)
    
    self.layer_wear = require("src.layer.herolist.HeroListDragonWearLayer"):createWithCCBIFile("ccbi/HeroListDragonWearLayer.ccbi")
	self.layer_wear:setPosition(self:getContentSize().width / 2 - self.layer_wear:getContentSize().width / 2, 0)
    self:addChild(self.layer_wear)

    ex.RedDotManager:setStickNode(RedDotType.ZCJ_DHYX_SL_JD, self.btn_tab_1)
    ex.RedDotManager:setStickNode(RedDotType.ZCJ_DHYX_SL_LJ, self.btn_tab_2)

    self:initDone()
end

function HeroListDragonLayer:initDone()
    self.btn_tab_1:registerScriptTapHandler(handler(self, self.onDragonRoom))
    self.btn_tab_2:registerScriptTapHandler(handler(self, self.onDragonWear))

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/dragon.plist")

    self:changeLayer(HeroListDragonLayerType.ROOM)
end

function HeroListDragonLayer:changeLayer(tab)
    if self.cur_layer_tab == tab then
        return
    end
    self.cur_layer_tab = tab
    
    self.btn_tab_1:setChecked(self.cur_layer_tab == HeroListDragonLayerType.ROOM)
    self.btn_tab_2:setChecked(self.cur_layer_tab == HeroListDragonLayerType.WEAR)

    self.layer_room:setVisible(self.btn_tab_1:isChecked())
    self.layer_wear:setVisible(self.btn_tab_2:isChecked())

    if self.cur_layer_tab == HeroListDragonLayerType.ROOM then
        self.layer_room:updateLayer()
    elseif self.cur_layer_tab == HeroListDragonLayerType.WEAR then
        self.layer_wear:updateLayer()
    end
end

function HeroListDragonLayer:onDragonRoom(tag, pSender)
    if self.cur_layer_tab == HeroListDragonLayerType.ROOM then
        return
    end

    self:changeLayer(HeroListDragonLayerType.ROOM)
end

function HeroListDragonLayer:onDragonWear(tag, pSender)
    if self.cur_layer_tab == HeroListDragonLayerType.WEAR then
        return
    end

    self:changeLayer(HeroListDragonLayerType.WEAR)
end



return HeroListDragonLayer
