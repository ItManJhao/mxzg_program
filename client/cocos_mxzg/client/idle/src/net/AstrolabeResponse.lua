local AstrolabeResponse = class("AstrolabeResponse")


function AstrolabeResponse:handleAstrolabeData(data)
    ex.Player.hero_data.astrolabe:setEnabled(data.active_astrolabe)

    ex.Player.hero_data.astrolabe:setMaxStar(data.max_star)

    ex.Player.hero_data.astrolabe:updateActivedElem(data.active_elem)

    ex.Player.hero_data.astrolabe:updateAstrolabeSkill(data.active)
end

function AstrolabeResponse:handleAstrolabeActiveElem(data)
    ex.Player.hero_data.astrolabe:setEnabled(data.active_astrolabe)

    ex.Player.hero_data.astrolabe:addActivedElem(data.active_elem)

    ex.EventManager:fire(EVENT.ASTROLABE.ACTIVE_ELEM, data.active_elem)
end

function AstrolabeResponse:handleAstrolabeLight(data)
    ex.Player.hero_data.astrolabe:updateAstrolabeSkill(data.active)

    ex.EventManager:fire(EVENT.ASTROLABE.STAR_UPDATE)
end

function AstrolabeResponse:handleAstrolabeReset(data)
    ex.Player.hero_data.astrolabe:updateAstrolabeSkill(data.active)

    ex.EventManager:fire(EVENT.ASTROLABE.STAR_UPDATE)
end

function AstrolabeResponse:handleAstrolabeUpdateMaxStar(data)
    ex.Player.hero_data.astrolabe:setMaxStar(data.max_star)
end

function AstrolabeResponse:handleAstrolabeUnlockElem(data)
    ex.Player.hero_data.astrolabe:setEnabled(data.active_astrolabe)

    ex.EventManager:fire(EVENT.ASTROLABE.UNLOCK_ELEM)
end

return AstrolabeResponse