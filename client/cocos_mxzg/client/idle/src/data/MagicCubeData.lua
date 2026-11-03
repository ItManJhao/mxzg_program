local MagicCubeData = class("MagicCubeData")

function MagicCubeData:ctor(parent)
    self.parent = parent
    self._rank_list = {}
    self._rank_hero = {}
    self._open_count = 0
    self._cube_data ={}
    self._cube_hero_list = {}
end 

function MagicCubeData:initData(data)
    self:setRankHero(data.rank_hero)
    self._cube_data = {}
    self:setCubeData(data.trench)
    self:setOpenCount(data.open_count)
    self:resetCubeHero()
end

function MagicCubeData:getSelectList()
    local list = {}

    local cube_hero_list = {}
    for i,v in ipairs(self._cube_data) do
        if v.hero_id ~= 0 then 
            cube_hero_list[v.hero_id] = true 
        end 
    end

    for i,v in ipairs(self.parent.hero_list) do
        local is_filter = self:heroIsRank(v.hero_id) == true or cube_hero_list[v.hero_id] == true 
        if not is_filter then 
            table.insert(list,v)
        end
    end
    local function sor(a,b)
        if a.level ~= b.level then return a.level > b.level end 
        if a.star ~= b.star then return a.star > b.star end 
        return a.hero_type > b.hero_type
    end
    table.sort(list,sor)
    return list
end

function MagicCubeData:heroIsRank(hero_id)
    return self._rank_hero[hero_id]
end

function MagicCubeData:setRankHero(hero_list)
    self._rank_list = {}
    self._rank_hero = {}
    for i,v in ipairs(hero_list) do
        self._rank_list[i] = v 
        self._rank_hero[v] = true 
    end
end

function MagicCubeData:getMagicCubeLevel()
    local level = 999999
    if table.nums(self._rank_list) < 6 then return 1 end 
    for idx,val in ipairs(self._rank_list) do
        local hero_data = ex.Player.hero_data:getHeroDataById(val)
        if hero_data then 
            if level > hero_data.level then 
                level = hero_data.level 
            end 
        end 
    end

    return level
end

function MagicCubeData:setOpenCount(num)
    self._open_count = num 
end

function MagicCubeData:getOpenCount()
    return self._open_count 
end

function MagicCubeData:getCubeDataByIdx(idx)
    for i,v in ipairs(self._cube_data) do
        if v.index == idx then 
            return v
        end 
    end
end

function MagicCubeData:isHeroInCubeList(hero_id)
    for i,v in ipairs(self._cube_data) do
        if v.hero_id == hero_id then 
            return true
        end 
    end

    return false
end

function MagicCubeData:getRanHeroList()
    local data = {}
    for i,v in ipairs(self._rank_list) do
        if v ~= 0 then
            local hero_data = ex.Player.hero_data:getHeroDataById(v)
            if hero_data then 
                table.insert(data,hero_data)
            end 
        end
    end

    local function sor(a,b)
        if a.level == b.level then 
            return a.fighting < b.fighting 
        end 
        return a.level < b.level
    end 

    table.sort(data,sor)

    return data
end

function MagicCubeData:setCubeData(data)
    for i,v in ipairs(data) do
        local d = {}
        d.index = v.index 
        d.last_change_time = v.last_change_time 
        d.hero_id = v.hero_id
        table.insert(self._cube_data,d)
    end 
    self:resetCubeHero()
end

function MagicCubeData:changeCubeData(data)
    local trench = {}
    trench.index = data.trench.index 
    trench.last_change_time = data.trench.last_change_time 
    trench.hero_id = data.trench.hero_id 
    for i,v in ipairs(self._cube_data) do
        if v.index == trench.index then 
            self._cube_data[i] = trench 
            break 
        end 
    end
    self:resetCubeHero()
end

function MagicCubeData:addCubeData(data)
    self:setOpenCount(data.open_count)
    local trench = {}
    trench.index = data.trench.index 
    trench.last_change_time = data.trench.last_change_time 
    trench.hero_id = data.trench.hero_id 
    table.insert(self._cube_data,trench)
    self:resetCubeHero()
end

function MagicCubeData:resetCubeHero()
    self._cube_hero_list = {}
    for i,v in ipairs(self._cube_data) do
        if v.hero ~= 0 then 
            self._cube_hero_list[v.hero_id] = true 
        end 
    end
    for i,v in pairs(self._cube_hero_list) do
        self.parent.promote:checkCanUpLevel(i)
        self.parent.promote:checkHeroCanUpgrade(i)
    end
    self.parent:checkMainCityRedPoint()
end

function MagicCubeData:isCubeHero(hero_id)
    return self._cube_hero_list ~= nil and self._cube_hero_list[hero_id] or false
end

--function MagicCubeData:onDisboardHero(data)
    
--end

function MagicCubeData:clear()
    self._rank_list = nil 
    self._rank_hero = nil 
    self._open_count = nil 
    self._cube_data = nil
    self._cube_hero_list = nil
end

return MagicCubeData 
