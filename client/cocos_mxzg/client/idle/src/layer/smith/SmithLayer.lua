local SmithLayer = class("SmithLayer", require("src.comp.EventLayer"))


-------------------------------SmithLayer-----------------------------------------------

function SmithLayer:getAsynImage()
    local vec_image = {
        {image_name = "ccbi-res/map-bg-smith-1.jpg", remove_type=1},
        {image_name = "ccbi-res/map-bg-runes-1.jpg", remove_type=1},
    }
    return vec_image
end

function SmithLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/runes.plist")
    sfc:addSpriteFrames("ccbi-res/runes-effect.plist")

    local last_content_size = self:getContentSize()
    local cur_content_size = cc.size(ex.p.width - 20, ex.p.height - 220)
    local offset = cc.p(cur_content_size.width - last_content_size.width, cur_content_size.height - last_content_size.height)

    self:setContentSize(cur_content_size)

    self.menu_top:setLocalZOrder(100)
    self.menu_tab:setLocalZOrder(100)
    if ex.p.width < 640 then
        self.menu_tab:setScale(ex.p.width / 640)
    end

    local notch_height = require("src.model.Game"):instance():getNotchHeight()
    self.btn_back:setPosition(self:getContentSize().width / 2 + ex.p.width / 2 / self:getScaleX() - 20 / self:getScaleX() - 60,
                              self:getContentSize().height / 2 + ex.p.height / 2 / self:getScaleY() - 100 / self:getScaleY() - 20 - notch_height)

    self.btn_info:setPosition(self.btn_back:getPositionX() + self.btn_back:getContentSize().width * 0.5 - self.btn_info:getContentSize().width * 0.5, self.btn_back:getPositionY() - 60)    
    self.btn_runes_preview:setPosition(self.btn_back:getPositionX() + self.btn_back:getContentSize().width * 0.5 - self.btn_runes_preview:getContentSize().width * 0.5 , self.btn_back:getPositionY() - 120)
    self.btn_src:setPosition(self.btn_back:getPositionX() - self.btn_src:getContentSize().width * 0.5 + 30, self.btn_back:getPositionY() - 110)
    self.btn_god_equip_book:setPosition(self.btn_back:getPositionX() + self.btn_back:getContentSize().width * 0.5 - self.btn_runes_preview:getContentSize().width * 0.5 , self.btn_back:getPositionY() - 140)
    
    self.menu_tab:setPosition(self:getContentSize().width / 2, self.btn_back:getPositionY() - 45)

    self.btn_src:registerScriptTapHandler(handler(self,self.onClickGemSrc))
    self.btn_god_equip_book:registerScriptTapHandler(handler(self,self.onClickGodEquipBook))

    self.btn_equip:setLabelText(ex.Tools:getLang(5280))
    self.btn_runes:setLabelText(ex.Tools:getLang(5273))
    self.btn_gem:setLabelText(ex.Tools:getLang(5527))
    self.btn_god_equip:setLabelText(ex.Tools:getLang(5681))


    self.cur_layer_tab = ActivityPanelIdxType.NULL
	self:changeLayer(nil)
end

function SmithLayer:changeLayerBg(str_bg)
    if self.spr_bg ~= nil then
        self.spr_bg:removeFromParent()
        self.spr_bg = nil    
    end

    self.spr_bg = cc.Sprite:create(str_bg)
    local scale_x = ex.p.width / self.spr_bg:getContentSize().width
    local scale_y = ex.p.height / self.spr_bg:getContentSize().height
    self.spr_bg:setScale(scale_x > scale_y and scale_x or scale_y)
    self.spr_bg:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
    -- spr_bg:setCascadeOpacityEnabled(true)
    self:addChild(self.spr_bg, -1)
end

function SmithLayer:getLayerClass()
	return SmithLayer
end

function SmithLayer:registerEvent()
    -- body
end

function SmithLayer:changeLayer(tab)
    if self.cur_layer_tab ~= ActivityPanelIdxType.NULL and self.cur_layer_tab == tab then
        return
    end

    if tab == nil then
        tab = ActivityPanelIdxType.SMITH_SHOP
    end

    self.cur_layer_tab = tab

    self.btn_equip:setChecked(self.cur_layer_tab == ActivityPanelIdxType.SMITH_SHOP)
    self.btn_runes:setChecked(self.cur_layer_tab == ActivityPanelIdxType.SMITH_SHOP_SPRITE)
    self.btn_gem:setChecked(self.cur_layer_tab == ActivityPanelIdxType.SMITH_SHOP_GEM)
    self.btn_god_equip:setChecked(self.cur_layer_tab == ActivityPanelIdxType.SMITH_SHOP_GOD_EQUIP)

    self.btn_runes_preview:setVisible(self.cur_layer_tab == ActivityPanelIdxType.SMITH_SHOP_SPRITE)
    self.btn_src:setVisible(self.cur_layer_tab == ActivityPanelIdxType.SMITH_SHOP_GEM)
    self.btn_god_equip_book:setVisible(self.cur_layer_tab == ActivityPanelIdxType.SMITH_SHOP_GOD_EQUIP)

    if self.cur_layer ~= nil then
        self.cur_layer:removeFromParent()
        self.cur_layer = nil
    end

    if self.cur_layer_tab == ActivityPanelIdxType.SMITH_SHOP then
        self:changeLayerBg("ccbi-res/map-bg-smith-1.jpg")

        self.cur_layer = require("src.layer.smith.SmithEquipLayer"):createWithCCBIFile("ccbi/SmithEquipLayer.ccbi")
        self.cur_layer:setPosition(0, 0)
    
        self.btn_equip:setLabelColor(cc.c3b(255, 255, 255))
        self.btn_runes:setLabelColor(cc.c3b(211, 225, 238))  
        self.btn_gem:setLabelColor(cc.c3b(211, 225, 238))  
        self.btn_god_equip:setLabelColor(cc.c3b(211, 225, 238))  
    elseif self.cur_layer_tab == ActivityPanelIdxType.SMITH_SHOP_SPRITE then
        self:changeLayerBg("ccbi-res/map-bg-runes-1.jpg")

        self.cur_layer = require("src.layer.smith.SmithRunesLayer"):createWithCCBIFile("ccbi/SmithRunesLayer.ccbi")
        self.cur_layer:setPosition(-(ex.p.width * 0.5 - self:getContentSize().width * 0.5), -(ex.p.height * 0.5 - self:getContentSize().height * 0.5))
        -- self.cur_layer:setPositionX(self:getContentSize().width / 2 - self.cur_layer:getContentSize().width / 2)
        -- self.cur_layer:setPositionY((self:getContentSize().height - 240) / 2 - self.cur_layer:getContentSize().height / 2 + 30)

        self.btn_runes:setLabelColor(cc.c3b(255, 255, 255))
        self.btn_equip:setLabelColor(cc.c3b(211, 225, 238))  
        self.btn_gem:setLabelColor(cc.c3b(211, 225, 238))  
        self.btn_god_equip:setLabelColor(cc.c3b(211, 225, 238))  

        print("self.cur_layer_tabself.cur_layer_tabself.cur_layer_tab", self.cur_layer_tab)
    elseif self.cur_layer_tab == ActivityPanelIdxType.SMITH_SHOP_GEM then
        self:changeLayerBg("ccbi-res/map-bg-smith-1.jpg")

        self.cur_layer = require("src.layer.smith.SmithGemLayer"):createWithCCBIFile("ccbi/SmithGemLayer.ccbi")
        self.cur_layer:setIgnoreAnchorPointForPosition(false)
        self.cur_layer:setAnchorPoint(ex.a.center)
        local content_size = self:getContentSize()
        self.cur_layer:setPosition(content_size.width * 0.5, content_size.height * 0.5)
        
        self.btn_gem:setLabelColor(cc.c3b(255, 255, 255))
        self.btn_equip:setLabelColor(cc.c3b(211, 225, 238)) 
        self.btn_runes:setLabelColor(cc.c3b(211, 225, 238))
        self.btn_god_equip:setLabelColor(cc.c3b(211, 225, 238))
    elseif self.cur_layer_tab == ActivityPanelIdxType.SMITH_SHOP_GOD_EQUIP then
        self:changeLayerBg("ccbi-res/map-bg-smith-1.jpg")

        self.cur_layer = require("src.layer.smith.SmithGodEquipLayer"):createWithCCBIFile("ccbi/SmithGodEquipLayer.ccbi")
        self.cur_layer:setIgnoreAnchorPointForPosition(false)
        self.cur_layer:setAnchorPoint(ex.a.center)
        local content_size = self:getContentSize()
        self.cur_layer:setPosition(content_size.width * 0.5, content_size.height * 0.5)
        
        self.btn_god_equip:setLabelColor(cc.c3b(255, 255, 255))
        self.btn_equip:setLabelColor(cc.c3b(211, 225, 238)) 
        self.btn_gem:setLabelColor(cc.c3b(211, 225, 238)) 
        self.btn_runes:setLabelColor(cc.c3b(211, 225, 238))
    end

    self:addChild(self.cur_layer)

    -- local lc = cc.LayerColor:create(cc.c4b(255, 0 , 0, 180), self.cur_layer:getContentSize().width, self.cur_layer:getContentSize().height)
    -- lc:setIgnoreAnchorPointForPosition(self.cur_layer:isIgnoreAnchorPointForPosition())
    -- lc:setAnchorPoint(self.cur_layer:getAnchorPoint())
    -- lc:setPosition(self.cur_layer:getPosition())
    -- self:addChild(lc, -1)
end

function SmithLayer:updateLayer()
	
end

function SmithLayer:onInfo(tag, pSender)
    if self.cur_layer_tab == ActivityPanelIdxType.SMITH_SHOP then
        ex.InfoCtr:openWindow(ex.Tools:getLang(42014), ex.Tools:getLang(42015))
    elseif self.cur_layer_tab == ActivityPanelIdxType.SMITH_SHOP_SPRITE then
        ex.InfoCtr:openWindow(ex.Tools:getLang(42034), ex.Tools:getLang(42035))
    elseif self.cur_layer_tab == ActivityPanelIdxType.SMITH_SHOP_GOD_EQUIP then
        ex.InfoCtr:openWindow(ex.Tools:getLang(42074), ex.Tools:getLang(42075))
    else
        ex.InfoCtr:openWindow(ex.Tools:getLang(42056), ex.Tools:getLang(42057))
    end
end

function SmithLayer:onRunesPreview(tag, pSender)
    if self.cur_layer_tab == ActivityPanelIdxType.SMITH_SHOP_SPRITE then
        require("src.layer.runes.RunesSkillCtr.lua"):instance():openWindow(ex.Tools:getLang(41104))
    end
end

function SmithLayer:onBack(tag, pSender)
    --ex.MainSceneCtr:instance():changeLayer(MainSceneType.MAINCITY_LAYER)
    ex.MainSceneCtr:backLastLayer()
end

function SmithLayer:onSmithEquip(tag, pSender)
    self:changeLayer(ActivityPanelIdxType.SMITH_SHOP)
end

function SmithLayer:onSmithRunes(tag, pSender)
    self:changeLayer(ActivityPanelIdxType.SMITH_SHOP_SPRITE)
end

function SmithLayer:onSmithGem(tag, pSender)
    self:changeLayer(ActivityPanelIdxType.SMITH_SHOP_GEM)
end

function SmithLayer:onSmithGodEquip(tag, pSender)
    if not ex.JumpManager:checkOpenConditionByAtom("main_smith_shop_god_equip") then
        self:changeLayer(self.cur_layer_tab)

        self.btn_equip:setChecked(self.cur_layer_tab == ActivityPanelIdxType.SMITH_SHOP)
        self.btn_runes:setChecked(self.cur_layer_tab == ActivityPanelIdxType.SMITH_SHOP_SPRITE)
        self.btn_gem:setChecked(self.cur_layer_tab == ActivityPanelIdxType.SMITH_SHOP_GEM)
        self.btn_god_equip:setChecked(self.cur_layer_tab == ActivityPanelIdxType.SMITH_SHOP_GOD_EQUIP)
        return
    end

    self:changeLayer(ActivityPanelIdxType.SMITH_SHOP_GOD_EQUIP)
end

function SmithLayer:onClickGemSrc(tag, pSender)
    local return_data = cfg.system["jewel_get_jump"]

    if not ex.JumpManager:jumpByAtom(return_data.event_arg) then
        ex.MessageView:add(ex.Tools:getLang(return_data.no_jump_hint))
    end
end

function SmithLayer:onClickGodEquipBook(tag ,pSender)
	require("src.layer.artifact.ArtifactIllustrationCtr"):instance():openWindow()
end

return SmithLayer
