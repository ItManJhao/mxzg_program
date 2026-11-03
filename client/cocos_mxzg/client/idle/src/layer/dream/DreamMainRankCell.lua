
local DreamMainRankCell = class("DreamMainRankCell", require("src.comp.LuaLayerBase"))

local string_format = string.format
function DreamMainRankCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

end


function DreamMainRankCell:reset(data)

    if not data then print("not data") return end
    self.data = data
    
    --self.image
    ex.Tools:setSpriteFrame(self.image, string.format("rank/spr-rank-%s.png",self.data.rank))
    -- :setSpriteFrame()

    self.lbl_name:setString(self.data.name)
    self.lbl_level:setString(self.data.score)
    
end
return DreamMainRankCell