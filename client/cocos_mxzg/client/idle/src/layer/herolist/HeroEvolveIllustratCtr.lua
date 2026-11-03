local HeroEvolveIllustratCtr = class("HeroEvolveIllustratCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroEvolveIllustratLayer = class("HeroEvolveIllustratLayer", require("src.comp.EventLayerAdaptiveWidth"))
local UIItemHero = require("src.comp.menu.UIMenuItemHero")

--------------------------------------------

function HeroEvolveIllustratLayer:onCreate()
    self.item_type = 1100505
    self.btn_elem_select = require("src.layer.HeroElemSelect"):new()
    self:registerBtnEvent()
    self.elem = 1
    self:createScrollView()
    self:updataView()
    self:addBlackBackground()
end

function HeroEvolveIllustratLayer:createScrollView()
    self.item_size = cc.Sprite:createWithSpriteFrameName("other/rare-0.png"):getContentSize()
    local offset_x = (540 % (self.item_size.width + 15)) / (math.floor(540 / (self.item_size.width + 15)) + 1)
    self.item_size = cc.size(self.item_size.width + 15 + offset_x, self.item_size.height + 12)
    self.scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.scroll_view:setItemSize(cc.size(self.item_size.width, self.item_size.height + 10))
    self.scroll_view:setItemOffset(cc.p(0, 5))
end

function HeroEvolveIllustratLayer:updataView()
    self.scroll_view:setLoaded(false)
    self.scroll_view.createItemFunction = function(data, scale)
        if data ~= nil then
            local item = UIItemHero:createWithData(nil, data.hero_type, data.elem, data.level, data.star, nil)
            item:registerScriptTapHandler(handler(self, self.onShowEvolveInfo))
            item:setScale(scale)
            item.hero_data = data
    
            return item
        end
    end
    local data = ex.Player.hero_data:getEvolveIllustratByElem(self.elem)

    self.scroll_view:reloadData(data)
end

function HeroEvolveIllustratLayer:onShowEvolveInfo(tag, pSender)
    if not pSender.hero_data then
        return
    end
    local data = ex.Player.hero_data:getEvolveIllustratByElem(pSender.hero_data.elem)

    HeroEvolveIllustratCtr:instance():closeWindow()
    local layer = ex.MainSceneCtr:changeLayer(MainSceneType.HERO_EVOLUTION_PREVIEW_LAYER)
	layer:initView(data, pSender.hero_data.idx)
end

function HeroEvolveIllustratLayer:registerBtnEvent()
    for i = 1, 5 do
        local btn = self["btn_elem" .. i]
        btn:setTag(i)
        btn:registerScriptTapHandler(handler(self, self.onElem))
        self.btn_elem_select:bindSelect(btn)
    end
    self.btn_elem_select:setSelected(ElemType.FIRE)
end

function HeroEvolveIllustratLayer:onElem(tag, pSender)
    if tag == self.elem then
        return
    end
    self.elem = tag
    self.btn_elem_select:setSelected(tag)

    local data = ex.Player.hero_data:getEvolveIllustratByElem(self.elem)

    self.scroll_view:reloadData(data)
end

-----------------------------------------------------------------------------
function HeroEvolveIllustratCtr:onCreate()
    self:setCCBIPath("ccbi/HeroEvolveIllustratLayer.ccbi")
    self:setIsSingle(false)
end

function HeroEvolveIllustratCtr:getLayerClass()
    return HeroEvolveIllustratLayer
end

function HeroEvolveIllustratCtr:getHeroEvolveIllustratLayer()
    return self.layer
end

function HeroEvolveIllustratCtr:openWindow(elem)
    if self:isOpened() then
        return
    end
    local sfc = cc.SpriteFrameCache:getInstance()

    self:loadLayer()
    self:open()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    if elem then
        self.layer:onElem(elem)
    end
end

return HeroEvolveIllustratCtr
