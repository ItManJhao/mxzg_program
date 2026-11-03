local ClanBossEndCell = class("ClanBossEndCell", require("src.comp.LuaLayerBase"))

function ClanBossEndCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:setIgnoreAnchorPointForPosition(false)
    self:setAnchorPoint(cc.p(0.5, 0.5))
end

function ClanBossEndCell:initData(data)
    self.lbl_damage:setString(data.damage)
    self.lbl_point:setString(data.add_point)
end



return ClanBossEndCell