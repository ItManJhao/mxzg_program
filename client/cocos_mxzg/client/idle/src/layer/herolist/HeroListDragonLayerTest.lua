local HeroListDragonLayerTest = class("HeroListDragonLayerTest", require("src.layer.ui.UI_HeroListDragonLayer"))

local HeroListDragonLayerType = {}
HeroListDragonLayerType.ROOM = 10      -- 龙界
HeroListDragonLayerType.WEAR = 20      -- 龙祭

function HeroListDragonLayerTest:onCreate()
    self.super.onCreate(self)
	self:setName("HeroListDragonLayerTest")

    ex.RedDotManager:setStickNode(RedDotType.ZCJ_DHYX_SL_JD, self.btn_tab_1)
    ex.RedDotManager:setStickNode(RedDotType.ZCJ_DHYX_SL_LJ, self.btn_tab_2)
    -- self:initDone()
end

function HeroListDragonLayerTest:onEnterFinish()
    self.btn_tab_1:registerScriptTapHandler(handler(self, self.onDragonRoom))
    self.btn_tab_2:registerScriptTapHandler(handler(self, self.onDragonWear))
    self:changeLayer(HeroListDragonLayerType.ROOM)
end

function HeroListDragonLayerTest:changeLayer(tab)
    if self.cur_layer_tab == tab then
        return
    end
    self.cur_layer_tab = tab
    
    self.btn_tab_1:setChecked(self.cur_layer_tab == HeroListDragonLayerType.ROOM)
    self.btn_tab_2:setChecked(self.cur_layer_tab == HeroListDragonLayerType.WEAR)

    -- self.layer_room:setVisible(self.btn_tab_1:isChecked())
    -- self.layer_wear:setVisible(self.btn_tab_2:isChecked())

    if self.cur_layer then
        self.cur_layer:removeFromParent()
    end

    if self.cur_layer_tab == HeroListDragonLayerType.ROOM then
        -- 初始化子层
        local layer_room = require("src.layer.herolist.HeroListDragonRoomLayerTest"):create()
        layer_room:setPosition(self:getContentSize().width / 2 - layer_room:getContentSize().width / 2, 0)
        self:addChild(layer_room)
        self.cur_layer = layer_room
    elseif self.cur_layer_tab == HeroListDragonLayerType.WEAR then
        local layer_wear = require("src.layer.herolist.HeroListDragonWearLayerTest"):create()
        layer_wear:setPosition(self:getContentSize().width / 2 - layer_wear:getContentSize().width / 2, 0)
        self:addChild(layer_wear)
        self.cur_layer = layer_wear
    end
end

function HeroListDragonLayerTest:onDragonRoom(tag, pSender)
    if self.cur_layer_tab == HeroListDragonLayerType.ROOM then
        return
    end

    self:changeLayer(HeroListDragonLayerType.ROOM)
end

function HeroListDragonLayerTest:onDragonWear(tag, pSender)
    if self.cur_layer_tab == HeroListDragonLayerType.WEAR then
        return
    end

    self:changeLayer(HeroListDragonLayerType.WEAR)
end



return HeroListDragonLayerTest
