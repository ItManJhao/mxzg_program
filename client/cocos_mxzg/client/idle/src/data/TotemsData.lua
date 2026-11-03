local TotemsData = class("TotemsData")

function TotemsData:ctor(parent)
	self.parent = parent

    self._totems_list = {}
    self._totems_level_cfg = {}
    self._totems_grade_cfg = {}
    self._totems_active = {}

    self:initCfg()
end

function TotemsData:initCfg( )
    self:initLevelCfg()
    self:initGradeCfg()
end

function TotemsData:initLevelCfg()
    self._totems_level_cfg = {}
    for k,v in pairs(cfg.totemslevel.totemslevel) do
        if self._totems_level_cfg[v.totems_id] == nil then self._totems_level_cfg[v.totems_id] = {} end
        self._totems_level_cfg[v.totems_id][v.level] = v
    end
    for k,v in pairs(self._totems_level_cfg) do
        local active = {}
        active.type = k
        active.bool = false
        -- self._totems_active[k] = active
        table.insert(self._totems_active,active)
    end
end

function TotemsData:initGradeCfg()
    self._totems_grade_cfg = {}
    for k,v in pairs(cfg.totems.totems) do
        if self._totems_grade_cfg[v.totems_id] == nil then self._totems_grade_cfg[v.totems_id] = {} end
        self._totems_grade_cfg[v.totems_id][v.quality] = v
    end
end

function TotemsData:hasAllTotems( )
    return table.nums(self._totems_list) == table.nums(self._totems_level_cfg)
end

function TotemsData:getLevelCfgByType(type,level)
    return self._totems_level_cfg[type][level]
end

function TotemsData:getGradeCfgByType(type,grade)
    return self._totems_grade_cfg[type][grade]
end

function TotemsData:getGradeALLCfgByType(type)
    return self._totems_grade_cfg[type]
end

function TotemsData:getMaxLevelCfgByType(type)
    local type_cfg = self._totems_level_cfg[type]
    return type_cfg[#type_cfg]
end

function TotemsData:getMaxLevelCfgByType(type)
    local type_cfg = self._totems_level_cfg[type]
    return type_cfg[#type_cfg]
end

function TotemsData:getMaxGradeCfgByType(type)
    local type_cfg = self._totems_grade_cfg[type]
    return type_cfg[#type_cfg]
end

function TotemsData:getLevelReturnCostByType(data)
    local type_level_cfg = self._totems_level_cfg[data.sys_id]
    local type_grade_cfg = self._totems_grade_cfg[data.sys_id]
    local tmp = {}
    for i=1,data.level - 1 do
        local level_cfg = type_level_cfg[i]
        if level_cfg ~= nil then 
            for i,v in ipairs(level_cfg.cost) do
                if tmp[v.item_type] == nil then 
                    tmp[v.item_type] = {} 
                    tmp[v.item_type].item_type = v.item_type
                    tmp[v.item_type].item_num = v.item_num
                else
                    tmp[v.item_type].item_num = tmp[v.item_type].item_num + v.item_num
                end 

            end
        end
    end

    for i=1,data.quality - 1 do
        local grade_cfg = type_grade_cfg[i]
        if grade_cfg ~= nil then 
            for i,v in ipairs(grade_cfg.cost) do
                if tmp[v.item_type] == nil then 
                    tmp[v.item_type] = {} 
                    tmp[v.item_type].item_type = v.item_type
                    tmp[v.item_type].item_num = v.item_num
                else
                    tmp[v.item_type].item_num = tmp[v.item_type].item_num + v.item_num
                end 

            end
        end
    end
    local cost_data = {}
    for k,v in pairs(tmp) do
        table.insert(cost_data,v)
    end
    local function sor(a,b)
        local a_rare =  cfg.item.item[a.item_type].rare_mark 
        local b_rare =  cfg.item.item[b.item_type].rare_mark 
        if a_rare ~= b_rare then return a_rare > b_rare end 
        return a.item_type < b.item_type
    end
    table.sort(cost_data,sor)
    return cost_data
    
end

function TotemsData:setTotemsData(data)
    local d = {}
    d.hero_id = data.hero_id
    d.level = data.level
    d.quality = data.quality
    d.sys_id = data.sys_id
    d.t_id = data.t_id
    -- self._totems_active[data.sys_id] = true
    for i,v in ipairs(self._totems_active) do
        if v.type == d.sys_id then 
            v.bool  = true
        end
    end
    table.insert(self._totems_list,d)
end

function TotemsData:getTotemByHero(hero_id)
    for i,v in ipairs(self._totems_list) do
        if v.hero_id == hero_id then 
            return v
        end
    end
end

function TotemsData:updateTotemLevel(totem)
    for i,v in ipairs(self._totems_list) do
        if v.t_id == totem.t_id then 
            v.level = totem.level
            v.quality = totem.quality
        end
    end
end

function TotemsData:updateEquip(totem)
    for i,v in ipairs(self._totems_list) do
        if v.t_id == totem.t_id then 
            v.level = totem.level
            v.quality = totem.quality
            v.hero_id = totem.hero_id
        end
    end
end

function TotemsData:initTotems(list)
    self._totems_list = {}
    for i,v in ipairs(list) do
        self:setTotemsData(v)
    end
end

function TotemsData:disboardPetByHero(data)
    for i,v in ipairs(self._totems_list) do
        if v.t_id == data.t_id then 
            v.hero_id = 0
            break
        end
    end
end

function TotemsData:getTotemDataByType(type)
    for i,v in ipairs(self._totems_list) do
        if v.sys_id == type then 
            return v 
        end
    end
end

function TotemsData:getTotemsList( )
    local data = {}
    -- local tmp = {}
    -- local sor = {}
    data.active = {}
    data.not_active = {}
    for i,v in pairs(self._totems_active) do
        if v.bool == true then 
            local d = self:getTotemDataByType(v.type)
            table.insert(data.active,d)
        else
            local d = self:getLevelCfgByType(v.type,1)
            table.insert(data.not_active,d)
        end
    end
    table.sort(data.active,function(a,b)
        return a.sys_id < b.sys_id
    end)

    table.sort(data.not_active,function(a,b)
        return a.totems_id < b.totems_id
    end)
    -- dump(data)
    return data 
end

function TotemsData:addTotemsData(data)
    for _,v in pairs(data.list) do
        self:setTotemsData(v)
    end
end

function TotemsData:getNotCarryTotemNum( )
    local num = 0
    for i,v in ipairs(self._totems_list) do
        if v.hero_id == 0 then num = num + 1 end
    end
    return num
end

function TotemsData:checkTotemOpen(hero_id)
    local role_level = cfg.system.open_totems_role_level 
    local hero_star = cfg.system.open_totems_hero_star 
    local hero_data = ex.Player.hero_data:getHeroDataById(hero_id)
    if not hero_data then return false end 
    return ex.Player.level >= role_level and hero_data.star >= hero_star
end

function TotemsData:checkTotemOpenByHeroData(hero_data)
    if not hero_data then
        return false
    end
    local role_level = cfg.system.open_totems_role_level or 1
    local hero_star = cfg.system.open_totems_hero_star or 10
    return ex.Player.level >= role_level and hero_data.star >= hero_star
end


function TotemsData:checkTotemCanUp(totem)
    local level_cfg = self:getLevelCfgByType(totem.sys_id,totem.level)
    local grade_cfg = self:getGradeCfgByType(totem.sys_id,totem.quality + 1)
    local is_up_grade = grade_cfg ~= nil and totem.level == grade_cfg.needlevel
    local is_max_level = self:getMaxLevelCfgByType(totem.sys_id).level == totem.level
    local red = true 
    if is_up_grade == true then 
        for i,v in ipairs(grade_cfg.cost) do
            local has_num = ex.Player:getItemNum(v.item_type)
            red = has_num >= v.item_num
            if red == false then break end
        end
    else
        if is_max_level == true then return false end 
        for i,v in ipairs(level_cfg.cost) do
            local has_num = ex.Player:getItemNum(v.item_type)
            red = has_num >= v.item_num
            if red == false then break end
        end
    end

    return red
end

function TotemsData:checkRedPointByHeroId(hero_id)

    local is_open = self:checkTotemOpen(hero_id)
    if not is_open then return false end 
    local totem = self:getTotemByHero(hero_id)
    if not totem then 
        return self:getNotCarryTotemNum() > 0
    end

    local red = self:checkTotemCanUp(totem)

    if red == false then 
        red = self:checkBestTotem(totem)
    end

    return red
end

function TotemsData:checkBestTotem( totem )
    local red = false 
    for i,v in ipairs(self._totems_list) do
        if v.hero_id == 0 then 
            if v.quality > totem.quality then 
                return true
            elseif v.quality == totem.quality then 
                return v.level > totem.level
            end
        end
    end

    return red
end

function TotemsData:checkMainCityRedPoint( )
    local red = false 
    local hero_list = ex.Player.hero_data.promote:getBattleList()
    for k,v in pairs(hero_list) do
        red = self:checkRedPointByHeroId(k)
        if red == true then break end
    end
    return red
end


function TotemsData:clear( )
	self.parent = nil

    self._totems_list = nil
    self._totems_level_cfg = nil
    self._totems_grade_cfg = nil
    self._totems_active = nil
end

return TotemsData
