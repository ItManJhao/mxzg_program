local ArtifactTransformSkill = class("ArtifactTransformSkill",require("src.comp.EventLayer"))

function ArtifactTransformSkill:onCreate()

end

function ArtifactTransformSkill:reset(data)
    self.spr_icon:setSpriteFrame(string.format("skill-icon/%d.png", data.skill))
    self.lbl_skill_name:setString(ex.Player.hero_data:getSkillName(data.skill, data.skill_level))
    self.lbl_skill_desc:setString(ex.Player.hero_data:getSkillDescription(data.skill, data.skill_level))
end

return ArtifactTransformSkill