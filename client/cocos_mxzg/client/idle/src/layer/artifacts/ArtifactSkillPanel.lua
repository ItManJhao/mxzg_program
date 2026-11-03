local ArtifactSkillPanel = class("ArtifactSkillPanel", require("src.comp.EventLayer"))

function ArtifactSkillPanel:onCreate()
    
end

function ArtifactSkillPanel:reset(data)
    self.lbl_skill_name:setString(ex.Player.hero_data:getSkillName(data.skill, data.skill_level))
    self.lbl_skill_desc:setString(ex.Player.hero_data:getSkillDescription(data.skill, data.skill_level))

    if self.item_icon ~= nil then 
        self.item_icon:removeFromParent()
    end

    self.item_icon = cc.Sprite:createWithSpriteFrameName(string.format("skill-icon/%d.png", data.skill))

    if not self.item_icon then 
         self.item_icon = cc.Sprite:createWithSpriteFrameName(string.format("skill-icon/%d.png", 0))
    end
    self:addChild(self.item_icon)
    local x,y = self.node:getPosition()
    self.item_icon:setPosition(x,y)
end

return ArtifactSkillPanel