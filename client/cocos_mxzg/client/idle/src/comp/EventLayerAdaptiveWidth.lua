
local EventLayerAdaptiveWidth = class("EventLayerAdaptiveWidth",  require("src.comp.EventLayer"))
function EventLayerAdaptiveWidth:ctor(...)
    self:resetScaleAtWidth()
    self.super.super.ctor(self, ...)
end
return EventLayerAdaptiveWidth