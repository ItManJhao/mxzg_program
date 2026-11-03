
local HeroHexagramSkillCell = class("HeroHexagramSkillCell", require("src.layer.ui.UI_HeroHexagramSkillCell"))

function HeroHexagramSkillCell:onCreate()
    self.super.onCreate(self)
	self:setName("HeroHexagramSkillCell")

    self:setAnchorPoint(cc.p(0.5, 0.5))
    self:setIgnoreAnchorPointForPosition(false)
end

function HeroHexagramSkillCell:reloadData(data)
    ex.Tools:setSpriteFrame(self.spr_skill_icon, "skill-icon/"..data.id..".png")

    local str_skill_name =  ex.Player.hero_data:getSkillName(data.id, 1)
    if str_skill_name == "" then
		str_skill_name = "--"
	end
    if data.lv > 0 then
        str_skill_name = str_skill_name..ex.Tools:getLang(57013)
    else
        str_skill_name = str_skill_name..string.format(ex.Tools:getLang(57012), data.hexagram_level, data.need_level)
    end

    self.lbl_skill_name:setString(str_skill_name)

    self.lbl_tip:setString(ex.Tools:getLang(data.is_effect and 57014 or 57015))
    self.lbl_tip:setColor(data.is_effect and cc.c3b(0, 255, 6) or cc.c3b(255, 0, 0))

    self.lbl_skill:setString(ex.Player.hero_data:getSkillDescription(data.id, 1))
    -- 适配
    ex.Tools:setLimitWidth(self.lbl_skill_name,280)
    ex.Tools:setLimitWidth(self.lbl_tip,200)
end

return HeroHexagramSkillCell