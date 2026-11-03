local UIFastTMXHexTile = class("UIFastTMXHexTile", function ( ... )
    return cc.Sprite:create(...)
end)



function UIFastTMXHexTile:ctor()
    self.is_light = false
    self.node_ui = nil
    self.building = nil
end

function UIFastTMXHexTile:isLight()
    return self.is_light
end

function UIFastTMXHexTile:setLight(is_light, data, centet_type, outline_type)
    self.is_light = is_light

    if self.spr_light then
        self.spr_light:removeFromParent()
        self.spr_light = nil
    end

    if is_light == false then
        self.lightData = {}
        return
    end

    -- 使用时才创建。避免地图生成速度过慢
    self.lightData = {}

    self.spr_light = cc.Sprite:createWithSpriteFrameName(string.format("crusade-group-map/s%d.png", centet_type))
    self.spr_light:setPosition(self:getContentSize().width * 0.5, self:getContentSize().height * 0.5)
    self:addChild(self.spr_light)

    -- 修改的话。需要同步更改UIFastTMXHexSelect
    for i,v in ipairs(TMXMapLightData) do
        local lightData = data[i]
        local spr_light = self.lightData[i]
        if spr_light == nil and lightData == nil then
            local spr_light = cc.Sprite:createWithSpriteFrameName(string.format("crusade-group-map/s%d-%d.png", outline_type, v.img))
            spr_light:setPosition(self.spr_light:getContentSize().width * 0.5, self.spr_light:getContentSize().height * 0.5)
            spr_light:setRotation(v.r)
            spr_light:setAnchorPoint(v.a)
            spr_light:setFlippedX(v.fx)
            spr_light:setFlippedY(v.fy)
            self.spr_light:addChild(spr_light)
            self.lightData[i] = spr_light
        end
    end
end



return UIFastTMXHexTile