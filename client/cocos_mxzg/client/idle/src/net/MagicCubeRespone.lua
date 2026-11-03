local MagicCubeRespone = class("MagicCubeRespone")

function MagicCubeRespone:initMagicCubeData(data)
    ex.Player.hero_data.magicCube:initData(data)
    ex.EventManager:fire(EVENT.MAGIC_CUBE.INIT_CUBE_DATA)
end

function MagicCubeRespone:addHero(data)
    ex.Player.hero_data.magicCube:changeCubeData(data)
    ex.EventManager:fire(EVENT.MAGIC_CUBE.ADD_HERO_BY_CUBE)
end

function MagicCubeRespone:onDisboardHero(data)
    ex.Player.hero_data.magicCube:changeCubeData(data)
    ex.EventManager:fire(EVENT.MAGIC_CUBE.DISBOARD_HERO_BY_CUBE)
end

function MagicCubeRespone:openTrench(data)
    ex.Player.hero_data.magicCube:addCubeData(data)
    ex.Player.hero_data.magicCube:setOpenCount(data.open_count)
    ex.EventManager:fire(EVENT.MAGIC_CUBE.OPEN_CUBE)
end

function MagicCubeRespone:onClearCD(data)
    ex.Player.hero_data.magicCube:changeCubeData(data)

    ex.EventManager:fire(EVENT.MAGIC_CUBE.CLEAR_COOL_DOWN)
end

function MagicCubeRespone:onHeroCubeLevel(data)
    for i,v in ipairs(data.update) do
        local hero_data = ex.Player.hero_data:getHeroDataById(v.hero_id)
        if hero_data then 
            hero_data.tweak_cube_lv = v.lv
            hero_data.tweak_cube_stage = v.stage
        end 
    end
    ex.Player.hero_data.magicCube:resetCubeHero() 
    ex.EventManager:fire(EVENT.MAGIC_CUBE.ADD_HERO_BY_CUBE)
end


return MagicCubeRespone
