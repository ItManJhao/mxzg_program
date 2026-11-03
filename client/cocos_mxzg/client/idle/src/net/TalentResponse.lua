local TalentResponse = class("TalentResponse")


function TalentResponse:handleHeroTalentLearn(data)
    ex.Player.hero_data:changeHeroTalent(data.hero_id, data.talent)
end

function TalentResponse:handleHeroTalentUpgrade(data)
    ex.Player.hero_data:changeHeroTalent(data.hero_id, data.talent)

    -- require("src.layer.heroinfo.HeroTalentUpLevelCtr"):instance():refresh(data.hero_id, data.talent.skill_id, data.talent.level, data.talent.slot)
end

function TalentResponse:handleHeroTalentForget(data)
    ex.Player.hero_data:changeHeroTalent(data.hero_id, data.talent)
end

return TalentResponse