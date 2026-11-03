local HeroScoreResponse = class("HeroScoreResponse")

function HeroScoreResponse:heroScore(data)
    ex.EventManager:fire(EVENT.HERO_SCORE_EVENT.HERO_SCORE, data)
end

return HeroScoreResponse
