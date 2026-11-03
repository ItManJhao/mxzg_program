local UIFastTMXHexBuilding = class("UIFastTMXHexBuilding", function ( ... )
    return cc.Sprite:createWithSpriteFrameName(...)
end)

function UIFastTMXHexBuilding:ctor()
    self.img = 0
end

function UIFastTMXHexBuilding:setImg(img)
    self.img = img
end

function UIFastTMXHexBuilding:getImg()
    return self.img
end

return UIFastTMXHexBuilding