local ArtifactData = class("ArtifactData")

function ArtifactData:ctor(parent)
	self.parent = parent
    -- self._heroArtifactList = {}
    self._artifactList = {}
end

function ArtifactData:setArtifactData(data)

    -- self._artifactList

    -- if not self._heroArtifactList[data.hero_id] then 
    --     self._heroArtifactList[data.hero_id] = {}
    -- end

    -- local place = cfg.reikiequip.reikiequip[data.sys_id].place
    -- local artifact_data = {}
    -- artifact_data.reiki_equip_id = data.reiki_equip_id
    -- artifact_data.sys_id = data.sys_id
    -- self._heroArtifactList[data.hero_id][place] = artifact_data

    local d = {}
    d.hero_id = data.hero_id
    d.reiki_equip_id = data.reiki_equip_id
    d.sys_id = data.sys_id
    table.insert(self._artifactList,d)

end

function ArtifactData:initArtifact(list)
    for i,v in ipairs(list) do
        self:setArtifactData(v)
    end
end

function ArtifactData:getArtifactDataByHeroId(hero_id)
    local data = {}
    local artifact_cfg = cfg.reikiequip.reikiequip
    for i,v in ipairs(self._artifactList) do
        if v.hero_id == hero_id then 
            local place = artifact_cfg[v.sys_id].place
            data[place] = v
        end
    end
    return data
end

function ArtifactData:outArtifactByHero(data)
    for i,v in ipairs(self._artifactList) do
        if v.hero_id == data.hero_id and v.reiki_equip_id == data.reiki_equip_id then 
            v.hero_id = 0
            break
        end
    end
end

function ArtifactData:changeArtifact(data)
    if data.old_reiki_id ~= 0 then
        for i,v in ipairs(self._artifactList) do
            if v.reiki_equip_id == data.old_reiki_id and v.hero_id == data.hero_id then 
                v.hero_id = 0
                break
            end
        end
    end

    for i,v in ipairs(self._artifactList) do
        if v.reiki_equip_id == data.reiki_equip_id then 
            v.hero_id = data.hero_id
            break
        end
    end
end

function ArtifactData:getNotWearArtifact( )
    local data = {}
    for i,v in ipairs(self._artifactList) do
        if v.hero_id == 0 then 
            table.insert(data,v)
        end
    end

     return data
end

function ArtifactData:getNotWearArtifactByPlace(place)
    local data = {}
    for i,v in ipairs(self._artifactList) do
        local conf = cfg.reikiequip.reikiequip[v.sys_id]
        if v.hero_id == 0 and conf.place == place then 
            table.insert(data,v)
        end
    end

     return data
end

function ArtifactData:changeArtifactLevel(data)
    for i,v in ipairs(self._artifactList) do
        if data.reiki_equip.reiki_equip_id == v.reiki_equip_id then 
            v.sys_id = data.reiki_equip.sys_id
            break
        end
    end
end

function ArtifactData:artifactTransform(data)
    for i,v in ipairs(self._artifactList) do
        if data.reiki_equip_id == v.reiki_equip_id then 
            v.sys_id = data.sys_id
            break
        end
    end
end

function ArtifactData:getBagItem()
    local data = {}
    for i,v in ipairs(self._artifactList) do
        if v.hero_id == 0 then 
            local item = {}
            item.item_type = v.sys_id
            item.hero_id = v.hero_id
            item.reiki_equip_id = v.reiki_equip_id
            table.insert( data, item )
        end
    end
    return data
end

function ArtifactData:addEquipData(data)
    -- 装备存在时，清除英雄ID
    -- 没有存在，就直接插入
    for i,v in ipairs(data.data) do
        local equip = self:hasEquipById(v.reiki_equip_id)
        if equip then 
            equip.hero_id = 0
        else
            local dt = {}
            dt.hero_id = v.hero_id
            dt.reiki_equip_id = v.reiki_equip_id
            dt.sys_id = v.sys_id
            table.insert(self._artifactList,dt)
        end
    end
end

function ArtifactData:hasEquipById(id)
    for i,v in ipairs(self._artifactList) do
        if v.reiki_equip_id == id then 
            return v
        end
    end

end

function ArtifactData:checkRedPointByHeroId(hero_id)
    local reds = {}
    local is_cube_hero = self.parent.magicCube:isCubeHero(hero_id) == true 
    if is_cube_hero then 
        for i=1,2 do
            reds[i] = false 
        end
        return reds
    end 
    local equips = self:getNotWearArtifact()
    local hero_data = self.parent:getHeroDataById(hero_id)
    local active_reds = self:checkActiveRed(hero_data)
    local up_level_reds = self:checkUpLevelRed(hero_data)
    for i=1,2 do
        reds[i] = active_reds[i] or up_level_reds[i]
    end
    return reds
end

function ArtifactData:checkActiveRed(hero_data)
    local reds = {}
    if not hero_data then return reds end
    for i=1,2 do
        local is_active = hero_data.reiki_places[i] ~= nil
        local active_cfg = cfg.reikiequipactive.reikiequipactive[i]
        local has_num = ex.Player:getItemNum(active_cfg.cost_item[1].item_type)
        local can_active = hero_data.star >= active_cfg.start and hero_data.level >= active_cfg.level and has_num >= active_cfg.cost_item[1].item_num
        reds[i] = not is_active and can_active
    end

    return reds
end

function ArtifactData:checkUpLevelRed(hero_data)
    local reds = {}
    if not hero_data then return reds end
    local hero_equip = self:getArtifactDataByHeroId(hero_data.hero_id)
    local equips = self:getNotWearArtifact()
    for i=1,2 do
        local is_active = hero_data.reiki_places[i] ~= nil
        if is_active then 
            local place = hero_data.reiki_places[i]
            local equip_data = hero_equip[place]
            if not equip_data then 
                for k,v in pairs(equips) do
                    local equip_cfg = cfg.reikiequip.reikiequip[v.sys_id]
                    if equip_cfg.place == place then 
                        reds[place] = true
                        break
                    end
                end
            else
                local equip_cfg = cfg.reikiequip.reikiequip[equip_data.sys_id]
                if equip_cfg.up_star_target ~= "" then 
                    for i,v in ipairs(equip_cfg.up_star_target) do
                        local up_cfg = cfg.reikiequip.reikiequip[v]
                        local item_data = up_cfg.up_star_cost[1]
                        reds[place] = ex.Player:getItemNum(item_data.item_type) >= item_data.item_num
                        if reds[place] then 
                            local need_hero = up_cfg.cost_star_hero[1]
                            local replace_num = ex.Player:getItemNum(need_hero.replace_item)
                            local hero_list = self.parent:getHeroByStar(need_hero.star)
                            for k,v in ipairs(hero_list) do
                                if v.hero_id == hero_data.hero_id then 
                                    table.remove(hero_list,k)
                                    break
                                end
                            end
                            reds[place] = (table.nums(hero_list) + replace_num) >= need_hero.num
                        end
                    end
                else
                    reds[place] = false
                end
            end
        
        end
    end
    return reds
end



function ArtifactData:removeArtifact(list)

    for k,v in pairs(list) do
        for i,val in pairs(self._artifactList) do
            if val.reiki_equip_id == v then 
                table.remove(self._artifactList,i)
                break
            end
        end
    end

end

function ArtifactData:checkMainCityRedPoint( )
    local artifact_red = false 
    local hero_list = ex.Player.hero_data.promote:getBattleList()
    for k,v in pairs(hero_list) do
        local reds = ex.Player.hero_data.artifact:checkRedPointByHeroId(k)
        for k,v in pairs(reds) do
            if v == true then 
                artifact_red = true 
                break
            end
        end
    end
    return artifact_red
end

function ArtifactData:clear( )
    self.parent = nil 
    -- self._heroArtifactList = nil
    self._artifactList = nil
end

return ArtifactData
