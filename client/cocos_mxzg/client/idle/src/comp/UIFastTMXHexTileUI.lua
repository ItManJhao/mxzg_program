local UIFastTMXHexTileUI = class("UIFastTMXHexTileUI", function ( ... )
    return cc.Node:create(...)
end)

function UIFastTMXHexTileUI:ctor()
    -- local 
    self.show_collect = false
    self.show_elem = 0
    self.show_station = false
    self.show_spine = false
    self.show_giveup = false
end

function UIFastTMXHexTileUI:showCollect(b)
    if b == self.show_collect then
        return
    end

    self.show_collect = b

    if b then
        local spr_collect = cc.Sprite:createWithSpriteFrameName("crusade-group-map/spr-collect.png")
        spr_collect:setName("spr_collect")
        spr_collect:setPosition(cc.p(0, 10))
        self:addChild(spr_collect, 10)

        local spr_material = cc.Sprite:createWithSpriteFrameName("backpack/902048.png")
        spr_material:setName("spr_material")
        spr_material:setPositionY(20)
        spr_material:setScale(0.5)
        self:addChild(spr_material, 10)
    else
        self:removeChildByName("spr_collect")
        self:removeChildByName("spr_material")
    end
end

function UIFastTMXHexTileUI:showElem(elem)
    if elem == self.show_elem then
        return
    end

    self.show_elem = elem
    self:removeChildByName("spr_elem")

    if self.show_elem == 0 then
        return
    end

    local spr_elem = cc.Sprite:createWithSpriteFrameName(string.format("hero-icon/elem-%d.png", self.show_elem))
    spr_elem:setName("spr_elem")
    spr_elem:setScale(0.5)
    spr_elem:setPosition(cc.p(0, -30))
    self:addChild(spr_elem)
end

function UIFastTMXHexTileUI:showStation(b, name)
    if b == self.show_station then
        return
    end
    self.show_station = b

    if b then
        local spr_station = cc.Sprite:createWithSpriteFrameName(string.format("hero-icon/spr-lock-2.png", 1))
        spr_station:setName("spr_station")
        -- spr_station:setPositionY(-10)
        self:addChild(spr_station)

        local lbl_name = cc.Label:createWithTTF(name, FONT_DEFAULT_NAME_BOLD, 20)
        lbl_name:setName("lbl_name")
        lbl_name:setTextColor(cc.c3b(255, 255, 255))
        lbl_name:enableOutline(ex.c3b.BLACK, 2)
        lbl_name:setPositionY(-20)
        self:addChild(lbl_name)
    else
        self:removeChildByName("spr_station")
        self:removeChildByName("lbl_name")
    end
end

function UIFastTMXHexTileUI:runOccupyEffect(type)
    local effect = ex.EffectFactory:createEffectWithNodeByName(string.format("eff_occupy_%d", type))
    effect:setPositionY(90)
    self:addChild(effect, 1000)
end

function UIFastTMXHexTileUI:showSpine(b)
    if b == self.show_spine then
        return
    end

    self.show_spine = b

    if b then
        local sp_boss = sp.SkeletonAnimation:create("spine/10701006.json","spine/10701006.atlas", 1)
        sp_boss:setAnimation(0, "stand", true)
        -- sp_boss:setPosition(ex.p.width * 0.5, ex.p.height * 0.6)
        sp_boss:setScale(2)
        self:addChild(sp_boss)
    else
        self:removeChildByName("sp_boss")
    end
end

function UIFastTMXHexTileUI:updateGiveup(time)
    local is_show_giveup = time > 0
    if is_show_giveup then
        if self.show_giveup == false then
            self.show_giveup = true
            self.lbl_giveup_text = cc.Label:createWithTTF("放弃中", FONT_DEFAULT_NAME_BOLD, 18)
            self.lbl_giveup_text:enableOutline(cc.c4b(91, 46, 25, 255), 2)
            self.lbl_giveup_text:setName("lbl_giveup_text")
            self.lbl_giveup_text:setPositionY(20)
            self:addChild(self.lbl_giveup_text, 999)

            self.lbl_giveup_time = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 18)
            self.lbl_giveup_time:enableOutline(cc.c4b(91, 46, 25, 255), 2)
            self.lbl_giveup_time:setName("lbl_giveup_time")
            self.lbl_giveup_time:setPositionY(0)
            self:addChild(self.lbl_giveup_time, 999)
        end

        self.lbl_giveup_time:setString(ex.Tools:formatTime6(time))
    else
        self.show_giveup = false
        self.lbl_giveup_text = nil
        self.lbl_giveup_time = nil
        self:removeChildByName("lbl_giveup_text")
        self:removeChildByName("lbl_giveup_time")
    end
end

return UIFastTMXHexTileUI