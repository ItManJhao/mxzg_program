--[[
    func: 配置表辅助类
    author:徐东浩
    time:2019-11-28 18:26:38
    版权所有:广州暗耀晶石网络信息科技有限公司
]]
-------------------------------每日首充-------------------------------
cfg.promotiondailyfirstrecharge.getConfigByTurnsAndType = function(turns, type)
    if turns == nil or type == nil then
        return nil
    end

    for k, v in pairs(cfg.promotiondailyfirstrecharge.recharge) do
        if v.turns == turns and v.type == type then
            return v
        end
    end

    return nil
end

-------------------------------英雄降临-------------------------------
cfg.promotionbefall.getConfigByIdx = function(idx)
    for k, v in pairs(cfg.promotionbefall.befall) do
        if v.idx == idx then
            return v
        end
    end

    return nil
end

-------------------------------超值养成礼-------------------------------
cfg.developgift.getConfigByTypeLevel = function(type, level)
    for k, v in pairs(cfg.developgift.developgift) do
        if v.type == type and v.level == level then
            return v
        end
    end

    return nil
end

cfg.developgift.getConfigListByType = function(type)
    local result = {}
    for k, v in pairs(cfg.developgift.developgift) do
        if v.type == type then
            table.insert(result, v)
        end
    end

    table.sort(
        result,
        function(a, b)
            return a.level < b.level
        end
    )

    return result
end

-------------------------------跨服和试炼入口配置表-------------------------------
cfg.gamerewardshow.getConfigByTypeId = function(type, id)
    for k, v in pairs(cfg.gamerewardshow.gamerewardshow) do
        if v.game_type == type and v.game_id == id then
            return v
        end
    end

    return nil
end

cfg.gamerewardshow.getConfigListByType = function(type)
    local result = {}
    for k, v in pairs(cfg.gamerewardshow.gamerewardshow) do
        if v.game_type == type then
            table.insert(result, v)
        end
    end

    table.sort(
        result,
        function(a, b)
            return a.game_id < b.game_id
        end
    )

    return result
end

-------------------------------天梯机器人形象配置表-------------------------------
cfg.serverladderrobotshow.getConfigListByType = function(type)
    local result = {}
    for k, v in pairs(cfg.serverladderrobotshow.serverladderrobotshow) do
        if v.type == type then
            table.insert(result, v)
        end
    end

    table.sort(
        result,
        function(a, b)
            return a.idx < b.idx
        end
    )

    return result
end

-------------------------------天梯购买挑战次数配置表-------------------------------
cfg.serverladderfighttimes.getMaxBuyTimes = function()
    local max = 0
    for k, v in pairs(cfg.serverladderfighttimes.serverladderfighttimes) do
        if v.buy_times > max then
            max = v.buy_times
        end
    end

    return max
end

cfg.serverladderfighttimes.getConfigByBuyTimes = function(times)
    for k, v in pairs(cfg.serverladderfighttimes.serverladderfighttimes) do
        if v.buy_times == times then
            return v
        end
    end

    return nil
end

-------------------------------限时抢购配置表-------------------------------
cfg.promotionflashsale.getConfigListByTurns = function(turns, player_level)
    local result = {}
    for k, v in pairs(cfg.promotionflashsale.promotionflashsale) do
        if v.turns == turns and (v.appear_level == nil or v.appear_level <= player_level) then
            table.insert(result, v)
        end
    end

    table.sort(
        result,
        function(a, b)
            return a.idx < b.idx
        end
    )

    return result
end

-------------------------------彩虹圣殿配置表-------------------------------
-- 根据排位获取称号类型
cfg.rainbow.getSeatTitle = function(rank)
    local temp = 0
    for i, v in ipairs(cfg.rainbow.rainbow) do
        temp = temp + v.num
        if temp >= rank then
            return v.rainbow_type
        end
    end

    return -1
end

-------------------------------彩虹圣殿关卡配置表-------------------------------
-- 根据彩虹圣殿神位类型、关卡和队形位置获得配置
-- cfg.rainbowmission.getConfigByTypeLevelAndPos = function(rainbow_type, level, pos)
--     for i,v in ipairs(cfg.rainbowmission.rainbowmission) do
--         if v.rainbow_type == rainbow_type and v.level == level and v.pos == pos then
--             return v
--         end
--     end

--     return nil
-- end

-------------------------------jeweltype配置表-------------------------------
cfg.jeweltype.getConfigListByGemType = function(gem_property_type)
    local list = {}

    for k, v in pairs(cfg.jeweltype.jeweltype) do
        if v.place == gem_property_type then
            table.insert(list, v)
        end
    end

    return list
end

-------------------------------prophecyshow配置表-------------------------------
cfg.prophecyshow.getConfigListByProphecyType = function(prophecy_type)
    local list = {}

    for k, v in pairs(cfg.prophecyshow.prophecyshow) do
        if v.prophecy_type == prophecy_type then
            table.insert(list, v)
        end
    end

    table.sort(
        list,
        function(a, b)
            return a.star < b.star
        end
    )

    return list
end

-------------------------------system配置表-------------------------------
-- 获得天赋领悟idx槽位开启星级
cfg.system.getTalentSlotOpenStar = function(idx)
    idx = idx or 1
    idx = tonumber(idx)

    local vec = ex.Tools:stringSplit(cfg.system.talent_unlock_star, ";")
    if vec and #vec > 1 then
        local last_star = 1
        for i, v in ipairs(vec) do
            local pair = ex.Tools:stringSplit(v, "_")
            if pair and #pair > 1 then
                last_star = tonumber(pair[2])
                if tonumber(pair[1]) == idx then
                    return last_star
                end
            end
        end

        return last_star -- 超出当前配置，按照最后星级开启
    else
        return 1 -- 无配置就1星开启
    end
end

-- 获取天赋领悟开启星级
cfg.system.getTalentOpenStar = function()
    return cfg.system.getTalentSlotOpenStar(1)
end

-------------------------------heroskill配置表-------------------------------
cfg.heroskill.getConfigByType = function(skill_id, level)
    for k, v in pairs(cfg.heroskill.heroskill) do
        if v.type == skill_id and v.level == level then
            return v
        end
    end

    return nil
end

cfg.heroskill.isMaxLevel = function(skill_id, level)
    for k, v in pairs(cfg.heroskill.heroskill) do
        if v.type == skill_id and v.level > level then
            return false
        end
    end

    return true
end

-------------------------------heroskill配置表-------------------------------
cfg.talent.getConfigByType = function(skill_id, level)
    local last_config = nil
    for k, v in pairs(cfg.talent.talent) do
        if v.skill_type == skill_id then
            if not last_config or last_config.level < v.level then
                last_config = v
            end

            if level == v.level then
                return v
            end
        end
    end

    return last_config
end

-------------------------------promotionfirstrechargereward配置表-------------------------------
cfg.promotionfirstrechargereward.getChargeNumByType = function(idx)
    for i, v in ipairs(cfg.promotionfirstrechargereward.promotionfirstrechargereward) do
        if v.idx == idx then
            return v.rmb
        end
    end

    return 0
end

-------------------------------godrelic配置表-------------------------------
cfg.godrelic.getChapterList = function(chapter)
    local vec_chapter = {}
    for i, v in ipairs(cfg.godrelic.godrelic) do
        if chapter == nil or v.chapter == chapter then
            local iter_find =
                TableEx.findValueFunction(
                vec_chapter,
                function(data)
                    return data[1].chapter == v.chapter
                end
            )

            if iter_find then
                table.insert(iter_find, v)
            else
                table.insert(vec_chapter, {v})
            end
        end
    end
    return vec_chapter
end

cfg.godrelic.getMissionConfig = function(chapter, level)
    for i, v in ipairs(cfg.godrelic.godrelic) do
        if v.chapter == chapter and v.level == level then
            return v
        end
    end
    return nil
end

cfg.godrelicstarreward.getChapterList = function(chapter)
    local vec_star = {}

    for i, v in pairs(cfg.godrelicstarreward.godrelicstarreward) do
        if v.chapter == chapter then
            table.insert(vec_star, v)
        end
    end

    table.sort(
        vec_star,
        function(a, b)
            return a.idx < b.idx
        end
    )

    return vec_star
end

-------------------------------herofashion配置表-------------------------------
cfg.herofashion.getConfigByType = function(fashion_id)
    for k, v in pairs(cfg.herofashion.herofashion) do
        if v.fashion_id == fashion_id then
            return v
        end
    end
end

cfg.herofashion.getConfigsByHeroType = function(hero_type)
    local configs = {}

    for k, v in pairs(cfg.herofashion.herofashion) do
        if v.hero_type == hero_type then
            table.insert(configs, v)
        end
    end

    table.sort(
        configs,
        function(a, b)
            return a.fashion_id < b.fashion_id
        end
    )

    return configs
end

-------------------------------herofashionup配置表-------------------------------
cfg.herofashionup.getConfigByTypeAndLevel = function(fashion_id, level)
    for k, v in pairs(cfg.herofashionup.herofashionup) do
        if v.fashion_id == fashion_id and v.level == level then
            return v
        end
    end
end

cfg.herofashionup.getMaxConfigByType = function(fashion_id)
    local config = nil
    for k, v in pairs(cfg.herofashionup.herofashionup) do
        if v.fashion_id == fashion_id and (not config or v.level > config.level) then
            config = v
        end
    end

    return config
end

cfg.herofashionup.getAddition = function(fashion_id, level, ability_idx)
    local config = cfg.herofashionup.getConfigByTypeAndLevel(fashion_id, level)
    if not config then
        return 0
    end

    return config.ability[ability_idx] or {}
end

-------------------------------herofashionunlock配置表-------------------------------
cfg.herofashionunlock.getConfigByID = function(fashion_id)
    local configs = {}

    for k, v in pairs(cfg.herofashionunlock.herofashionunlock) do
        if v.fashion_id == fashion_id then
            table.insert(configs, v)
        end
    end

    table.sort(
        configs,
        function(a, b)
            return a.item_type < b.item_type
        end
    )

    return configs
end

cfg.herofashionunlock.getConfigByType = function(item_type)
    for k, v in pairs(cfg.herofashionunlock.herofashionunlock) do
        if v.item_type == item_type then
            return v
        end
    end
    return nil
end

-------------------------------godequipment配置表-------------------------------
cfg.godequipment.getConfigByType = function(equipment_type)
    -- for k,v in pairs(cfg.godequipment.godequipment) do
    --     if v.equipment_type == equipment_type then
    --         return v
    --     end
    -- end

    return cfg.godequipment.godequipment[equipment_type]
end

-- 获得神装套装种类
cfg.godequipment.getGodEquipGroupKind = function()
    local kind = {}

    for k, v in pairs(cfg.godequipment.godequipment) do
        if not kind["A" .. v.settype] then -- 表数据量太大，采用map进行存储
            kind["A" .. v.settype] = v.settype
        end
    end

    local result = {}
    for k, v in pairs(kind) do
        table.insert(result, v)
    end

    table.sort(
        result,
        function(a, b)
            return a < b
        end
    )

    return result
end

-------------------------------godequipmentrandomability配置表-------------------------------
cfg.godequipmentrandomability.getConfigByFullField = function(place, star, ability_type, level)
    for k, v in pairs(cfg.godequipmentrandomability.godequipmentrandomability) do
        if v.place == place and v.star == star and v.ability_type == ability_type and v.level == level then
            return v
        end
    end

    return nil
end

-------------------------------godequipmentrare配置表-------------------------------
cfg.godequipmentrare.getConfigByRare = function(equipment_rare)
    for k, v in pairs(cfg.godequipmentrare.godequipmentrare) do
        if v.equipment_rare == equipment_rare then
            return v
        end
    end
end

cfg.godequipmentrare.getAbilityNumByRare = function(equipment_rare)
    for k, v in pairs(cfg.godequipmentrare.godequipmentrare) do
        if v.equipment_rare == equipment_rare then
            return v.random_ability_num
        end
    end
end

-------------------------------clergyprivilege配置表-------------------------------
cfg.clergyprivilege.getSortConfigs = function()
    local sort_list = {}

    for k, v in pairs(cfg.clergyprivilege.clergyprivilege) do
        table.insert(sort_list, v)
    end

    table.sort(
        sort_list,
        function(a, b)
            return a.clergy_level < b.clergy_level
        end
    )

    return sort_list
end

cfg.clergyprivilege.getConfigByLevel = function(level)
    for k, v in pairs(cfg.clergyprivilege.clergyprivilege) do
        if level == v.clergy_level then
            return v
        end
    end

    return nil
end

cfg.clergyprivilege.getMaxLevel = function()
    local max_level = 0
    for k, v in pairs(cfg.clergyprivilege.clergyprivilege) do
        if max_level < v.clergy_level then
            max_level = v.clergy_level
        end
    end

    return max_level
end

cfg.clergyprivilege.getConfigByPrivilegeType = function(privilege_type)
    for k, v in pairs(cfg.clergyprivilege.clergyprivilege) do
        if type(v.unlock_privilege) == "table" and v.unlock_privilege.type == privilege_type then
            return v
        end
    end

    return nil
end

cfg.clergyprivilege.isPrivilege = function(privilege_type, level)
    local config = cfg.clergyprivilege.getConfigByPrivilegeType(privilege_type)
    if not config then
        return false
    end

    return level >= config.clergy_level
end

-------------------------------teamarenagetinlevel配置表-------------------------------
cfg.teamarenagetinlevel.getConfigByIdx = function(idx)
    return cfg.teamarenagetinlevel.teamarenagetinlevel[idx]
end

cfg.teamarenagetinlevel.getStringForCheckBox = function()
    local string_array = {}

    for i, v in ipairs(cfg.teamarenagetinlevel.teamarenagetinlevel) do
        local data = {}
        data.index = v.idx
        if v.need_level <= 0 then
            data.name = ex.Tools:getLang(74250)
        else
            data.name = string.format(ex.Tools:getLang(74247), v.need_level)
        end

        table.insert(string_array, data)
    end

    return string_array
end

cfg.teamarenagetinlevel.getIdxForLevel = function(level)
    local idx = 1

    for i, v in ipairs(cfg.teamarenagetinlevel.teamarenagetinlevel) do
        if v.need_level == level then
            idx = v.idx
            break
        end
    end

    return idx
end

-------------------------------teamarenagetinscore配置表-------------------------------
cfg.teamarenagetinscore.getConfigByIdx = function(idx)
    return cfg.teamarenagetinscore.teamarenagetinscore[idx]
end

cfg.teamarenagetinscore.getStringForCheckBox = function()
    local string_array = {}

    for i, v in ipairs(cfg.teamarenagetinscore.teamarenagetinscore) do
        local data = {}
        data.index = v.idx
        if v.need_score <= 0 then
            data.name = ex.Tools:getLang(74250)
        else
            data.name = string.format(ex.Tools:getLang(74248), ex.StringUtil.getScientificNumber(v.need_score))
        end

        table.insert(string_array, data)
    end

    return string_array
end

cfg.teamarenagetinscore.getIdxForScore = function(score)
    local idx = 1

    for i, v in ipairs(cfg.teamarenagetinscore.teamarenagetinscore) do
        if v.need_score == score then
            idx = v.idx
            break
        end
    end

    return idx
end

-------------------------------渠道功能开启表-------------------------------
cfg.socialplatform.isOpen = function(functionality)
    local social_platform = cpp.SocialPlatform:instance()
    local str_platform = "platform" .. social_platform:getPlatformStr()
    local soc_platform_id = social_platform.getPlatformId and social_platform:getPlatformId() or ""
    for k, v in pairs(cfg.socialplatform.socialplatform) do
        if v.soc_platform_id == soc_platform_id and v.functionality == functionality and v[str_platform] then
            return v[str_platform] == 1
        end
    end
    return false
end

cfg.socialplatform.getConfig = function(functionality)
    local social_platform = cpp.SocialPlatform:instance()
    local str_platform = "platform" .. social_platform:getPlatformStr()
    local soc_platform_id = social_platform.getPlatformId and social_platform:getPlatformId() or ""
    for k, v in pairs(cfg.socialplatform.socialplatform) do
        if v.soc_platform_id == soc_platform_id and v.functionality == functionality and v[str_platform] then
            return v
        end
    end
    return nil
end

cfg.languagetype.getDefaultConfig = function()
    return false
end

-------------------------------限时道具配置表-------------------------------
cfg.timelimititem.getConfigByID = function(item_id)
    return cfg.timelimititem.timelimititem[item_id]
end

cfg.timelimititem.getRewardType = function(item_id)
    local config = cfg.timelimititem.getConfigByID(item_id)

    if config then
        return config.reward[1].item_type
    end

    return 0
end

cfg.timelimititem.getTotalRewardNumType = function(item_id)
    local config = cfg.timelimititem.getConfigByID(item_id)

    if config then
        return config.valid_time * config.reward[1].item_num
    end

    return 0
end

-------------------------------星盘配置表-------------------------------
cfg.astrolabe.getConfigByIdx = function(idx)
    return cfg.astrolabe.astrolabe[idx]
end

cfg.astrolabe.getSetForStar = function()
    local set = {}

    local is_exist = function(t, value)
        for k, v in pairs(t) do
            if v == value then
                return true
            end
        end
        return false
    end

    for k, v in pairs(cfg.astrolabe.astrolabe) do
        if not is_exist(set, v.idx) then
            table.insert(set, v.idx)
        end
    end

    table.sort(
        set,
        function(a, b)
            return a < b
        end
    )

    return set
end

cfg.astrolabe.isSkillByIdx = function(idx)
    local config = cfg.astrolabe.getConfigByIdx(idx)

    if config and config.skills and type(config.skills) == "table" and #config.skills > 0 then
        return true
    else
        return false
    end
end

-------------------------------星盘元素配置表-------------------------------
cfg.astrolabeelement.getConfigByElem = function(elem)
    return cfg.astrolabeelement.astrolabeelement[elem]
end

cfg.astrolabeelement.getSetForIdx = function()
    local set = {}

    local is_exist = function(t, value)
        for k, v in pairs(t) do
            if v == value then
                return true
            end
        end
        return false
    end

    for k, v in pairs(cfg.astrolabeelement.astrolabeelement) do
        if not is_exist(set, v.idx) then
            table.insert(set, v.idx)
        end
    end

    table.sort(
        set,
        function(a, b)
            return a < b
        end
    )

    return set
end

-------------------------------星盘技能配置表-------------------------------
cfg.astrolabeskill.getConfigByIdx = function(idx)
    return cfg.astrolabeskill.astrolabeskill[idx]
end

-------------------------------阵型配置表-------------------------------
cfg.battlematrixaddition.getConfigsByType = function(matrix_type)
    local result = {}

    for i, v in ipairs(cfg.battlematrixaddition.battlematrixaddition) do
        if v.type == matrix_type then
            table.insert(result, v)
        end
    end

    talbe.table.sort(
        result,
        function(a, b)
            return a.position < b.position
        end
    )

    return result
end

cfg.battlematrixaddition.isEnableForPos = function(matrix_type, pos)
    for i, v in ipairs(cfg.battlematrixaddition.battlematrixaddition) do
        if v.type == matrix_type and v.position == pos then
            return v.is_open == 1
        end
    end

    return false
end

-------------------------------表情-------------------------------
cfg.emojiconfig.getEmojiConfig = function(pid, index)
    local ret = nil
    for k, v in ipairs(cfg.emojiconfig.emojiconfig) do
        if pid == v.pid and index == v.index then
            ret = v
            break
        end
    end

    return ret
end

cfg.emojiconfig.getEmojiConfigByText = function(text)
    local ret = nil
    for k, v in ipairs(cfg.emojiconfig.emojiconfig) do
        if text == v.text then
            ret = v
            break
        end
    end

    return ret
end

cfg.emojiconfig.getEmojiNum = function(pid)
    local ret = 0
    for k, v in ipairs(cfg.emojiconfig.emojiconfig) do
        if pid == v.pid then
            ret = ret + 1
        end
    end

    return ret
end

-------------------------------世界等级-------------------------------
cfg.worldlevelgainexp.getBonusByLevelDisp = function(level_disp)
    local ret = 0
    for k, v in ipairs(cfg.worldlevelgainexp.worldlevelgainexp) do
        if level_disp >= v.level_down and level_disp <= v.level_up then
            local bonusList = v.bonus
            if bonusList and #bonusList > 0 and bonusList[1] then
                local bonus_config = bonusList[1]
                local bonus = bonus_config.bonus or 0
                ret = math.floor(bonus / 100)
                break
            end
        end
    end

    return ret
end

cfg.floatingislandsheroshow.getConfig = function(key)
    local config = TableEx.findValueFunction(cfg.floatingislandsheroshow.floatingislandsheroshow, function(value)
        return value.key == key
    end)
    return config and config.value or ""
end

-------------------------------时空魔塔-------------------------------
-- 根据关卡去获取当前层数
cfg.timetowermisson.getLevelByMission = function(mission)
    local ret = 0
    for k, v in ipairs(cfg.timetowermisson.timetowermisson) do
        ret = v.lv
        if mission == v.mission then
            ret = v.lv
            break
        end
    end

    return ret
end

cfg.timetowermisson.getTypeByLevel = function(level)
    local ret = 1
    for k, v in ipairs(cfg.timetowermisson.timetowermisson) do
        if v.lv == level then
            ret = v.type
            break
        end
    end

    return ret
end

cfg.timetowermisson.getConfigByMission = function(mission)
    local ret
    for k, v in ipairs(cfg.timetowermisson.timetowermisson) do
        if mission == v.mission then
            ret = v
            break
        end
    end

    return ret
end

cfg.timetowermisson.getConfigsByLevel = function(level)
    local ret = {}
    local i = 1
    for k, v in ipairs(cfg.timetowermisson.timetowermisson) do
        if i > 3 then
            break
        end

        if level == v.lv then
            table.insert(ret, v)
            i = i + 1
        end
    end

    return ret
end

cfg.timetowermisson.getMissionCondition = function(mission)
    local ret = {}
    for k, v in ipairs(cfg.timetowermisson.timetowermisson) do
        if mission == v.mission then
            if v.conditions and #v.conditions > 0 then
                for k, v in ipairs(v.conditions) do
                    if v.cid == 1 then
                        local model = {
                            str = ex.Tools:getLang(75611),
                            value_str = string.format("%s%%", math.floor(v.value / 100))
                        }
                        table.insert(ret, model)
                    elseif v.cid == 2 then
                        local model = {
                            str = ex.Tools:getLang(75612),
                            value_str = string.format("%s%s", v.value, ex.Tools.getLang(75624))
                        }
                        table.insert(ret, model)
                    end
                end
            end

            break
        end
    end

    return ret
end

------------------------------冥域魔都------------------------------------
cfg.hadesfloor.getConfig = function(idx,key)
    local config = TableEx.findValueFunction(cfg.hadesfloor.hadesfloor, function(value)
        return value.idx == idx
    end)
    return config and config[key] or ""
end

cfg.hadesmonster.getConfig = function(idx,key)
    local config = TableEx.findValueFunction(cfg.hadesmonster.hadesmonster, function(value)
        return value.floor_idx == idx
    end)
    return config and config[key] or ""
end

cfg.hadesbuycount.getConfig = function(idx)
    local config = TableEx.findValueFunction(cfg.hadesbuycount.hadesbuycount, function(value)
        return value.idx == idx
    end)
    return config and config.cost or "erreo"
end
-------------------------------進化-------------------------------
cfg.heroevolvelevel.checkEvolution = function(hero_data, evolve)
    local hero_type = hero_data.hero_type
    if not cfg.heroevolvelevel or not cfg.heroevolvelevel.heroevolvelevel or #cfg.heroevolvelevel.heroevolvelevel == 0 then
        return false
    end

    local evolve_level = 0
    local evolve_type = 0
    if evolve and type(evolve.level) == "number" and type(evolve.type) == "number" then
        evolve_level = evolve.level
        evolve_type = evolve.type
    end

    for i = 0, #cfg.heroevolvelevel.heroevolvelevel do
        local config = cfg.heroevolvelevel.heroevolvelevel[i]
        if config and config.hero_type == hero_type then
            if (evolve_type == config.evolve_type or evolve_type == 0) and config.level >= evolve_level then
                return true
            end
        end
    end

    return false
end

cfg.heroevolvelevel.getEvolutionList = function(hero_type, evolve)
    if not cfg.heroevolvelevel or not cfg.heroevolvelevel.heroevolvelevel or #cfg.heroevolvelevel.heroevolvelevel == 0 then
        return nil
    end

    local list = {}
    local evolve_level = 0
    local evolve_type = 0
    if evolve and type(evolve.level) == "number" and type(evolve.type) == "number" then
        evolve_level = evolve.level
        evolve_type = evolve.type
    end

    for i = 1, #cfg.heroevolvelevel.heroevolvelevel do
        local config = cfg.heroevolvelevel.heroevolvelevel[i]
        if config and config.hero_type == hero_type then
            if (evolve_type == config.evolve_type or evolve_type == 0) and config.level - evolve_level == 1 then
                table.insert(list, config)
            end
        end
        -- 暂时只支持两个路线进化，所以写死只拿两个配置
        if #list == 2 then
            break
        end
    end

    return list
end

cfg.heroevolvelevel.getEvolutionListByHeroType = function(hero_type)
    if not cfg.heroevolvelevel or not cfg.heroevolvelevel.heroevolvelevel or #cfg.heroevolvelevel.heroevolvelevel == 0 then
        return nil
    end

    local list = {}

    for i = 1, #cfg.heroevolvelevel.heroevolvelevel do
        local config = cfg.heroevolvelevel.heroevolvelevel[i]
        if config and config.hero_type == hero_type then
            table.insert(list, config)
        end
    end

    return list
end

cfg.heroevolvelevel.getEvolutionConfig = function(hero_type, evolve_level, evolve_type)
    if not cfg.heroevolvelevel or not cfg.heroevolvelevel.heroevolvelevel or #cfg.heroevolvelevel.heroevolvelevel == 0 then
        return nil
    end

    for i = 1, #cfg.heroevolvelevel.heroevolvelevel do
        local config = cfg.heroevolvelevel.heroevolvelevel[i]
        if config and config.hero_type == hero_type and config.level == evolve_level and config.evolve_type == evolve_type then
            return config
        end
    end

    return nil
end


-------------------------------讨伐团-------------------------------
cfg.crusadegrouptilelevel.getAreaLevel = function(gid)
    return cfg.crusadegrouptilelevel.crusadegrouptilelevel.area_level[gid]
end

cfg.crusadegrouptilelevel.getBuildingLevel = function(gid)
    return cfg.crusadegrouptilelevel.crusadegrouptilelevel.building_level[gid]
end

cfg.crusadegrouptilelevel.getLevel = function(gid)
    return cfg.crusadegrouptilelevel.getAreaLevel(gid), cfg.crusadegrouptilelevel.getBuildingLevel(gid)
end

cfg.crusadegrouptilelevel.getFightType = function(gid)
    return cfg.crusadegrouptilelevel.crusadegrouptilelevel.fight_type[gid - 1] or 1
end

cfg.crusadegroupbuild.getConfig = function(gid)
    local area_lv, build_lv = cfg.crusadegrouptilelevel.getLevel(gid)
    local fight_type = cfg.crusadegrouptilelevel.getFightType(gid)
    local config = TableEx.findValueFunction(cfg.crusadegroupbuild.crusadegroupbuild, function (v)
        return v.area_level == area_lv and v.building_level == build_lv and v.type == fight_type
    end)

    return config
end

cfg.aliceunicornstrengthen.getMaxConfig = function(occupation)
    local config
    for _,v in ipairs(cfg.aliceunicornstrengthen.aliceunicornstrengthen) do
        if v.occupation == occupation then
            if config == nil or (v.need_grade > config.need_grade) or (v.need_grade == config.need_grade and v.level > config.level) then
                config = v
            end
        end
    end

    return config
end

cfg.aliceunicornstrengthen.getConfig = function(occupation, grade, level)
    local config = TableEx.findValueFunction(cfg.aliceunicornstrengthen.aliceunicornstrengthen, function (v)
        return v.occupation == occupation and v.need_grade == grade and v.level == level
    end)

    return config
end

cfg.aliceunicornstrengthen.getTotalCost = function(occupation, grade, level)
    local vec_reward = {}
    for _,config in ipairs(cfg.aliceunicornstrengthen.aliceunicornstrengthen) do
        if config.occupation == occupation and (config.need_grade < grade or (config.need_grade == grade and config.level <= level)) then
            for _,item in ipairs(config.up_cost) do
                local is_have = false
                for _,reward in ipairs(vec_reward) do
                    if reward.item_type == item.item_type then
                        reward.item_num = reward.item_num + item.item_num
                        is_have = true
                        break
                    end
                end
                if not is_have then
                    table.insert(vec_reward, clone(item))
                end
            end
        end
    end

    return vec_reward
end