local PetIllustratCtr = class("PetIllustratCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PetIllustratLayer = class("PetIllustratLayer", require("src.comp.EventLayerAdaptiveWidth"))
local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBag")

--------------------------------------------

function PetIllustratLayer:onCreate()
    self.item_type = 1100505
    self.btn_elem_select = require("src.layer.HeroElemSelect"):new()
    self:registerBtnEvent()
    -- self:upBtnLable()
    self.elem = 1
    self:createScrollView()
    self:updataView()
    self:addBlackBackground()
end

function PetIllustratLayer:createScrollView( )
    self.item_size = cc.Sprite:createWithSpriteFrameName("other/rare-0.png"):getContentSize()
    self.item_size = cc.size(self.item_size.width + 15, self.item_size.height + 12)
    self.scroll_view = require("src.comp.UIScrollViewBackpack"):createWithSize(cc.size(540.0, 490.0))
    self.scroll_view:setPosition(49, 81)
    self.scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.scroll_view:setItemSize(cc.size(self.item_size.width, self.item_size.height + 10))
    self.scroll_view:setItemOffset(cc.p(0, 5))
    self.scroll_view:setAutoOffset(true)
    self.scroll_view:setAutoScale(true)
    -- self.scroll_view:setAutoFull(true)
    self.scroll_view:setCreateNum(4)
    self:addChild(self.scroll_view)
end

function PetIllustratLayer:updataView( )
    self.scroll_view:setLoaded(false)
    -- self.scroll_view:setAutoFull(true)
    -- self.scroll_view:setAutoFull(true)
    self.scroll_view.createItemFunction = function(data, scale)
        if data ~= nil then 
            local item = UIMenuItemBackpack:createWithData(data.id,0)
            item:registerScriptTapHandler(handler(self, self.onShowInfo))
            item:setScale(scale)
            local active = ex.Player.hero_data.pet:getIllustrateActive(data.id)
            item:setAllGray(not active)
            item:showPetRare()
            local pet_cfg = ex.Player.hero_data.pet:getPetMaxCfgByType(data.id)
            item:setLevel(pet_cfg.level)

            return item
        end
    end
    local data = ex.Player.hero_data.pet:getIllustratByElem(self.elem)

    self.scroll_view:reloadData(data)
end

function PetIllustratLayer:onShowInfo(tag,pSender)
    -- print("touch")
    -- print(self.__cname,pSender.item_type)
    local level_cfg = ex.Player.hero_data.pet:getPetMaxCfgByType(pSender.item_type)
    require("src.layer.pet.PetInfoIllustratCtr"):instance():openWindow(level_cfg)
end

function PetIllustratLayer:registerBtnEvent( )
    for i=1,5 do
        local btn = self["btn_elem"..i]
        btn:setTag(i)
        btn:registerScriptTapHandler(handler(self, self.onElem))
        self.btn_elem_select:bindSelect(btn)
    end
    self.btn_elem_select:setSelected(ElemType.FIRE)
end

function PetIllustratLayer:onElem(tag,pSender)
    if tag == self.elem then return end 
    self.elem = tag 
    self.btn_elem_select:setSelected(tag)

    local data = ex.Player.hero_data.pet:getIllustratByElem(self.elem)
    
    self.scroll_view:reloadData(data)
end

-----------------------------------------------------------------------------
function PetIllustratCtr:onCreate()
	self:setCCBIPath("ccbi/PetIllustratLayer.ccbi")
	self:setIsSingle(false)
end

function PetIllustratCtr:getLayerClass()
	return PetIllustratLayer
end

function PetIllustratCtr:getPetIllustratLayer()
	return self.layer
end

function PetIllustratCtr:openWindow(data)
	if self:isOpened() then
		return
	end

	self:loadLayer()
    self:open()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    -- self.layer:changePanelWithStatus(true)
	-- self:initData(data)
end

return PetIllustratCtr
