local PetData = class("PetData")

function PetData:ctor(parent)
	self.parent = parent

    self._petList = {}
    self._petIllustrateList = {}
    self:initIllustrat()
    self:initCfg()
end

function PetData:initCfg( )
    self._pet_level_cfg = {}
    local pet_cfg = cfg.petlevel.petlevel
    for i,v in ipairs(pet_cfg) do
        if not self._pet_level_cfg[v.id] then 
            self._pet_level_cfg[v.id] = {}
        end
        self._pet_level_cfg[v.id][v.level] = v
    end
end

function PetData:getLevelCfgByType(type,level)
    return self._pet_level_cfg[type][level]
end

function PetData:setPetData(data)
    local d = {}
    d.hero_id = data.hero_id
    d.pet_id = data.pet_id
    d.sys_id = data.sys_id
    d.level = data.level
    table.insert(self._petList,d)
end

function PetData:initPet(list)
    self._petList = {}
    for i,v in ipairs(list) do
        self:setPetData(v)
    end
end

-- function PetData:getPetDataByHeroId(hero_id)
--     local data = {}
--     local artifact_cfg = cfg.reikiequip.reikiequip
--     for i,v in ipairs(self._petList) do
--         if v.hero_id == hero_id then 
--             local place = artifact_cfg[v.sys_id].place
--             data[place] = v
--         end
--     end
--     return data
-- end

function PetData:disboardPetByHero(data)
    for i,v in ipairs(self._petList) do
        if v.pet_id == data.pet_id then 
            v.hero_id = 0
            break
        end
    end
end

function PetData:changePet(data)

    for i,v in ipairs(self._petList) do
        if v.hero_id == data.hero_id then 
            v.hero_id = 0
            break
        end 
    end

    for i,v in ipairs(self._petList) do
        if data.pet.pet_id == v.pet_id then 
            v.hero_id = data.pet.hero_id
            v.sys_id = data.pet.sys_id 
            v.level = data.pet.level
            break
        end
    end
end

function PetData:getPetByHeroId(hero_id)
    for i,v in ipairs(self._petList) do
        if v.hero_id == hero_id then 
            return v 
        end
    end
end

function PetData:notCarryPetList( )
    local data = {}
    for i,v in ipairs(self._petList) do
        if v.hero_id == 0 then 
            table.insert(data,v)
        end
    end
    return data
end

function PetData:notCarryPetListByType(sys_id)
    local data = {}
    for i,v in ipairs(self._petList) do
        if v.hero_id == 0 and v.sys_id == sys_id then 
            table.insert(data,v)
        end
    end
    return data
end

function PetData:updataPetLevel(data)
    for i,v in ipairs(self._petList) do
        if data.pet.pet_id == v.pet_id then 
            v.level = data.pet.level
            v.sys_id = data.pet.sys_id
            v.hero_id = data.pet.hero_id
            break
        end
    end
end

function PetData:getPetMaxCfgByType(type)
    local level = 1
    while (level) do 
        local level_cfg = self:getLevelCfgByType(type,level)
        if level_cfg ~= nil then 
            level = level + 1
        else
            level = level - 1
            break
        end
    end
    return self:getLevelCfgByType(type,level)
end

function PetData:addPetData(data)
    for i,v in ipairs(data.list) do
        self:setPetData(v)
    end
end

function PetData:canCarryPetByHero(hero_id)
    local hero_data = self.parent:getHeroDataById(hero_id)
    local pet_list = self:notCarryPetList()
    local elem = hero_data.elem
    local data = {}
    for i,v in ipairs(pet_list) do
        local pet_cfg = cfg.pet.pet[v.sys_id]
        if pet_cfg.elem == elem then 
            table.insert(data,v)
        end
    end
    return data
end

function PetData:isOpenPetByHero(hero_id)
    local hero_data = self.parent:getHeroDataById(hero_id)
    if not hero_data then return false end
    local role_open = ex.Player.level >= cfg.system.open_pet_role_level
    local hero_open = hero_data.star >= cfg.system.open_pet_hero_star
    return role_open and hero_open
end

function PetData:checkRedPointByHeroId(hero_id)
    local red = false
    local pet_data = self:getPetByHeroId(hero_id)
    local open = self:isOpenPetByHero(hero_id)
    if open == false  then return red end
    local pet_list = self:canCarryPetByHero(hero_id)
    if not pet_data then 
        return #pet_list > 0
    else
        for i,v in ipairs(pet_list) do
            local pets_cfg = cfg.pet.pet 
            if pets_cfg[v.sys_id].rare > pets_cfg[pet_data.sys_id].rare then 
                red = pets_cfg[v.sys_id].rare > pets_cfg[pet_data.sys_id].rare 
                if red == true then break end
            elseif pets_cfg[v.sys_id].rare == pets_cfg[pet_data.sys_id].rare then 
                -- return v.level > pet_data.level
                red = v.level > pet_data.level
                if red == true then break end
            end
        end
    end
    return red
end


function PetData:removePet(list)

    for k,v in pairs(list) do
        for i,val in pairs(self._petList) do
            if val.pet_id == v then 
                table.remove(self._petList,i)
                break
            end
        end
    end

end

function PetData:checkMainCityRedPoint( )
    local pet_red = false 
    local hero_list = ex.Player.hero_data.promote:getBattleList()
    for k,v in pairs(hero_list) do
        pet_red = self:checkRedPointByHeroId(k)
        if pet_red == true then break end
    end
    return pet_red
end

function PetData:initIllustrat( )
    self._illustrat_cfg = {}
    for k,v in pairs(cfg.pet.pet) do
        table.insert(self._illustrat_cfg,v)
    end
    local function sor(a,b)
        return a.id < b.id 
    end
    table.sort(self._illustrat_cfg,sor)
end

function PetData:initIllustrate(list)
    for i,v in ipairs(list) do
        self._petIllustrateList[v] = true
    end
end

function PetData:getIllustrateActive(type)
    return self._petIllustrateList[type] == true
end

function PetData:getIllustratByElem(elem)
    local data = {}

    if elem == 0 then 

        data  = self._illustrat_cfg

    else 
        for i,v in ipairs(self._illustrat_cfg) do
            if v.elem == elem then 
                table.insert(data,v)
            end
        end
    end

    local function sor(a,b) 
        local proA = self:getIllustrateActive(a.id) == true and 100 or 0
        local proB = self:getIllustrateActive(b.id) == true and 100 or 0
        if proA == proB then 
            return a.id > b.id
        else
            return proA > proB
        end
    end

    table.sort(data,sor)

    return data
end

function PetData:clear( )
    self.parent = nil 
    -- self._heroArtifactList = nil
    self._petList = nil
    self._petIllustrateList = nil
end

return PetData