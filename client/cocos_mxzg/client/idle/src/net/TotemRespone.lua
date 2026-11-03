local TotemRespone = class("TotemRespone")

function TotemRespone:onInitTotemData(data)
    --dump(data)
    ex.Player.hero_data.totems:initTotems(data.list)
    ex.Player.hero_data:checkMainCityRedPoint()
end

function TotemRespone:onAddEquips(data)
    --dump(data)
    ex.Player.hero_data.totems:addTotemsData(data)
    ex.Player.hero_data:checkMainCityRedPoint()
end 

function TotemRespone:onUpdateTotemLevel(data)
    --dump(data)
    ex.Player.hero_data.totems:updateTotemLevel(data.totems)
    -- ex.Player.hero_data:checkMainCityRedPoint()
    if data.type == 1 then 
        ex.EventManager:fire(EVENT.TOTEM.UP_LEVEL)
    else
        ex.EventManager:fire(EVENT.TOTEM.UP_GRADE)
    end
    ex.Player.hero_data:checkMainCityRedPoint()
end

function TotemRespone:onReset(data)
    --dump(data)
    ex.Player.hero_data.totems:updateTotemLevel(data.totems)
    ex.Player.hero_data:checkMainCityRedPoint()
    ex.EventManager:fire(EVENT.TOTEM.RESET)
end

function TotemRespone:onEquipStatus(data)
    --dump(data)
    for i,v in ipairs(data.list) do
        ex.Player.hero_data.totems:updateEquip(v)
    end
    ex.Player.hero_data:checkMainCityRedPoint()
    ex.EventManager:fire(EVENT.TOTEM.UPDATA_EQUIP_INFO)
end

--function TotemRespone:addTotem(data)
    --dump(data)
    --for i,v in ipairs(data.list) do
        --ex.Player.hero_data.totems:setTotemsData()
    --end
    --ex.Player.hero_data:checkMainCityRedPoint()
--end

return TotemRespone
