local HeroMaxSkinCtr = class("HeroMaxSkinCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroMaxSkinLayer = class("HeroMaxSkinLayer", require("src.comp.EventLayer"))

function HeroMaxSkinLayer:onCreate()
    self:addBlackBackground()

    -- self:setPositionY(self:getPositionY() + 150)

    -- 铺展到全屏
    -- self.spr_bg = cc.Sprite:create("ccbi-res/map-bg-role-1.jpg")
    -- self.spr_bg:setScale(ex.p.width / self.spr_bg:getContentSize().width, ex.p.height / self.spr_bg:getContentSize().height)
    -- self.spr_bg:setPosition(ex.p.center().x - self:getPositionX(), ex.p.center().y - self:getPositionY())
    -- self:addChild(self.spr_bg, -1)
end

function HeroMaxSkinLayer:refreshShowGirl(fashion_id)
    self.node_animator:removeAllChildren()

    self.animator = require("src.person.Hero"):create("1", "1", 1, 1, 1, fashion_id)
    self.animator:setAnimation(0, "stand", true);
    self.animator:setScale(1.5)
    self.animator:setPosition(cc.p(0, 80))
    self.animator:setShadowVisible(false)
    self.node_animator:addChild(self.animator, 10)
end

function HeroMaxSkinLayer:refreshAttr(herofashion_config, herofashionup_config)
    self.lbl_skin_name:setString(ex.Tools:getLang(herofashion_config.fashion_name))

    self.lbl_skin_desc:setString(ex.Tools:getLang(herofashion_config.fashion_desc))

    self:_setAddition(self.lbl_attr_1, herofashionup_config, 1)
    self:_setAddition(self.lbl_attr_2, herofashionup_config, 2)
    self:_setAddition(self.lbl_attr_3, herofashionup_config, 3)
    self:_setAddition(self.lbl_attr_4, herofashionup_config, 4)
end

function HeroMaxSkinLayer:_setAddition(label, config, ability_idx)
    local cur_value = clone(cfg.herofashionup.getAddition(config.fashion_id, config.level, ability_idx))
    local str_value_cur = cur_value.value
    if cur_value.attr ~= AbilityType.AT_SPEED_BASE then
        str_value_cur = (cur_value.value / 100).."%"
    end
    label:setString(ex.Tools:getLang(122000 + cur_value.attr)..": +"..str_value_cur)
end

-----------------------------------------------------------------------------
function HeroMaxSkinCtr:getAsynImage()
    local vec_image = {
        {image_name = "ccbi-res/map-bg-role-1.jpg", remove_type=1},
    }
    return vec_image
end

function HeroMaxSkinCtr:onCreate()
    self:setCCBIPath("ccbi/HeroMaxSkinLayer.ccbi")
    self:setIsSingle(false)

    self.fashion_id = 0
    self.config = {}
    self.max_up_config = {}
end    

function HeroMaxSkinCtr:getLayerClass()
    return HeroMaxSkinLayer
end    

function HeroMaxSkinCtr:getHeroMaxSkinLayer()
    return self.layer
end    

function HeroMaxSkinCtr:openWindow(fashion_id)
    if self:isOpened() then
        return
    end

    self.fashion_id = fashion_id
    self.config = cfg.herofashion.getConfigByType(self.fashion_id)
    self.max_up_config = cfg.herofashionup.getMaxConfigByType(self.fashion_id)

    self:loadLayer()
    self:open()
    self:updateLayer()

    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
end

function HeroMaxSkinCtr:updateLayer()
    self.layer:refreshShowGirl(self.fashion_id)

    self.layer:refreshAttr(self.config, self.max_up_config)
end

return HeroMaxSkinCtr
