
local EventLayerAdaptiveWidthFull = class("EventLayerAdaptiveWidthFullFull",  require("src.comp.EventLayer"))
function EventLayerAdaptiveWidthFull:ctor(...)
    self:resetScaleAtWidth(true)
    self.super.super.ctor(self, ...)
end

return EventLayerAdaptiveWidthFull