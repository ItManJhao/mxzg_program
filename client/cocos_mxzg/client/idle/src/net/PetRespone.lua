local PetRespone = class("PetRespone")

function PetRespone:onInitPetData(data)

    ex.Player.hero_data.pet:initPet(data.list)
    ex.Player.hero_data:checkMainCityRedPoint()
end

function PetRespone:onCarryPetInfo(data)

    ex.Player.hero_data.pet:changePet(data)
    ex.Player.hero_data:checkMainCityRedPoint()
    ex.EventManager:fire(EVENT.PET.PET_CHANGE)
end

function PetRespone:onDisboardPetInfo(data)

    ex.Player.hero_data.pet:disboardPetByHero(data)
    ex.Player.hero_data:checkMainCityRedPoint()
    ex.EventManager:fire(EVENT.PET.PET_OUT)
end

function PetRespone:onUpdatePetLevel(data)

    ex.Player.hero_data.pet:updataPetLevel(data)
    ex.Player.hero_data:checkMainCityRedPoint()
    ex.EventManager:fire(EVENT.PET.PET_UP_LEVEL)
end

function PetRespone:onAddPetData(data)

    ex.Player.hero_data.pet:addPetData(data)
    ex.Player.hero_data:checkMainCityRedPoint()

end

function PetRespone:onDeletePetData(data)
    ex.Player.hero_data.pet:removePet(data.pet_ids)
    ex.Player.hero_data:checkMainCityRedPoint()
    ex.EventManager:fire(EVENT.PET.DELETE)
end

function PetRespone:onInitPetIllustrateData(data)
    ex.Player.hero_data.pet:initIllustrate(data.pet_types)
end


return PetRespone