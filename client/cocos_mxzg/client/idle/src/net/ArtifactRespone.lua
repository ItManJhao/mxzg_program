local ArtifactRespone = class("ArtifactRespone")


function ArtifactRespone:onActiveData(data)
    -- dump(data)
    ex.Player.hero_data.artifact:setArtifactData(data.data)
    local hero_data = ex.Player.hero_data:getHeroDataById(data.data.hero_id)
    local place = data.place
    hero_data.reiki_places[place] = place

    local equip_red = ex.Player.hero_data.equip:checkHeroEquipRedPointByScene()
    local artifact_red = ex.Player.hero_data.artifact:checkMainCityRedPoint()
    local promote_red = ex.Player.hero_data.promote:checkMainCityRedPoint()
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_YXT, equip_red or artifact_red or promote_red)
    ex.EventManager:fire(EVENT.ARTIFACTS.ARTIFACT_ACTIVE,data)
end

function ArtifactRespone:onInitArtifactData(data)
    -- dump(data)
    ex.Player.hero_data.artifact:initArtifact(data.list)
end

function ArtifactRespone:onWearArtifactInfo(data)
    -- dump(data)
    ex.Player.hero_data.artifact:changeArtifact(data)
    local equip_red = ex.Player.hero_data.equip:checkHeroEquipRedPointByScene()
    local artifact_red = ex.Player.hero_data.artifact:checkMainCityRedPoint()
    local promote_red = ex.Player.hero_data.promote:checkMainCityRedPoint()
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_YXT, equip_red or artifact_red or promote_red)
    ex.EventManager:fire(EVENT.ARTIFACTS.ARTIFACT_CHANGE)
end

function ArtifactRespone:onOutArtifactInfo(data)
    -- dump(data)
    ex.Player.hero_data.artifact:outArtifactByHero(data)
    local equip_red = ex.Player.hero_data.equip:checkHeroEquipRedPointByScene()
    local artifact_red = ex.Player.hero_data.artifact:checkMainCityRedPoint()
    local promote_red = ex.Player.hero_data.promote:checkMainCityRedPoint()
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_YXT, equip_red or artifact_red or promote_red)
    ex.EventManager:fire(EVENT.ARTIFACTS.ARTIFACT_OUT)
end

function ArtifactRespone:onCompose(data)
    -- dump(data)
    ex.Player.hero_data.artifact:changeArtifactLevel(data)
    local place_data = {}
    place_data.sys_id = data.reiki_equip.sys_id
    place_data.place = cfg.reikiequip.reikiequip[data.reiki_equip.sys_id].place
    local equip_red = ex.Player.hero_data.equip:checkHeroEquipRedPointByScene()
    local artifact_red = ex.Player.hero_data.artifact:checkMainCityRedPoint()
    local promote_red = ex.Player.hero_data.promote:checkMainCityRedPoint()
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_YXT, equip_red or artifact_red or promote_red)
    ex.EventManager:fire(EVENT.ARTIFACTS.ARTIFACT_COMPOSE,place_data)
end

function ArtifactRespone:onAddEquip(data)
    -- dump(data)
    ex.Player.hero_data.artifact:addEquipData(data)
    -- local place_data = {}
    -- place_data.sys_id = data.reiki_equip.sys_id
    -- place_data.place = cfg.reikiequip.reikiequip[data.reiki_equip.sys_id].place
    -- ex.EventManager:fire(EVENT.ARTIFACTS.ARTIFACT_COMPOSE,place_data)
end

function ArtifactRespone:onTransform(data)
    dump(data)
    ex.Player.hero_data.artifact:artifactTransform(data.data)
    local place_data = {}
    place_data.sys_id = data.data.sys_id
    place_data.place = cfg.reikiequip.reikiequip[data.data.sys_id].place
    local equip_red = ex.Player.hero_data.equip:checkHeroEquipRedPointByScene()
    local artifact_red = ex.Player.hero_data.artifact:checkMainCityRedPoint()
    local promote_red = ex.Player.hero_data.promote:checkMainCityRedPoint()
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_YXT, equip_red or artifact_red or promote_red)
    ex.EventManager:fire(EVENT.ARTIFACTS.ARTIFACT_TRANSFORM,place_data)
end

function ArtifactRespone:deleteArtifact(data)
    ex.Player.hero_data.artifact:removeArtifact(data.reiki_equip_ids)
    ex.EventManager:fire(EVENT.ARTIFACTS.DELETE)
end


return ArtifactRespone