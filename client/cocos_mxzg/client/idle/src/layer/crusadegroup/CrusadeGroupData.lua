-- 讨伐团数据
local CrusadeGroupData = class("CrusadeGroupData")

function CrusadeGroupData:ctor()
    self.stage = CRUSADE_GROUP_STATE.NONE        -- 活动阶段   CRUSADE_GROUP_STATE
    self.sign_up_status = false
    self.start_time = 0         -- 活动开始时间
    self.sign_up_start_time = 0 -- 活动报名开始时间
    self.sign_up_end_time = 0   -- 活动报名结束时间
    self.game_end_time = 0      -- 活动结束时间
    self.god_arms_info = nil    -- 神兵信息
    self.role_god_arms_info = nil    -- 玩家神兵道具信息
    self.god_arms_equip = nil        -- 神兵装备
    self.god_arms_core_up = nil      -- 神兵升级核心等级
    self.god_arms_fighting = 0       -- 神兵战力
    self.god_arms_isred = {}         -- 神兵红点数据
    self.last_acquisition_time = 0   -- 最后一次收菜时间
    self.last_acquisition_time_old = 0 -- 收菜界面需要算时间间隔 
    self.can_acquisition = false    -- 是否可以收菜。在ctr.updateStatus中更新这个值
    self.game_data = {
        set_off_max_num = 0,        -- 最大可出征英雄数量 
        energy = 0,                 -- 体力
        refuse_energy_rate = 0,     -- 恢复体力速率
        self_occupation_id = 1,     -- 自己的职级id

        -- 讨伐团信息
        crusade_group_info = {
            group_name = "",    -- 讨伐团名字
            group_id = 0,       -- 讨伐团id
            group_badge_id = 1, -- 讨伐团团徽id
            rename_number = 1,  -- 已改名次數
        },
        -- 讨伐团成员列表
        crusade_group_list = {},
        -- 讨伐团战斗英雄布阵列表
        set_off_hero_list = {},
        -- 讨伐团英雄箱子
        hero_box_list = {},
        -- 讨伐团职级任务列表
        tasklist = {},
        -- 占领城镇列表
        occupied_list = {},

        mark_id = {},

        last_occupation_id = -1,
    }         
    --[[
        game_data = {
            crusade_group_info = {
                group_name = "",    -- 讨伐团名字
                group_id = 0,       -- 讨伐团id
                gorup_member_num = 0    -- 讨伐团人数
                group_badge_id = 0      -- 讨伐团团徽id
            },
            -- 讨伐团成员列表
            crusade_group_list = {
                title = 0,          -- 职级
                name = "",          -- 昵称
                head_id = 0,        -- 头像id
                border_id = 0,      -- 头像框id
                offline_time = 0,   -- 离线时间
                server_id = 0,      -- 服务器id
                power = 0,          -- 战力
                clan_name = "",     -- 公会名字
                occupation_id = 0,    -- 职位
                level = 0           -- 等级

            }，
            set_off_hero_list = {
                hero_id = 0,
                hero_type = 0,
                hero_star = 0,
                hero_evolve = {
                    level = 0,
                    type = 0
                },
                energy = 0,             -- 体力
                is_station = false,     -- 是否驻地开垦
            },
            set_off_max_num = 0,        -- 最大可出征英雄数量 
            refuse_energy_rate = 0      -- 恢复体力速率
            self_occupation_id = 0        -- 自己的职级id
            tasklist = {

            },
            occupied_list = {
                pos = {
                    x, y
                },
                name = "",
                statuion_hero = {
                    
                }
            }
        }
    ]]--

    -- 地图数据
    self.map_config = require("src.config.crusadegroupmap")
    self.map_data = {}
    self.map_size = cc.size(self.map_config.width, self.map_config.height)  -- 地图格子的数量
    self.map_draw_type = self.map_config.staggerindex == "odd" and 1 or 2
    self.map_building_data = self.map_config.layers[2].obj

    -- self.map_refresh_page_size = cc.size(15, 30)    -- 单页刷新的范围
    self.map_refresh_page_size = cc.size(self.map_size.width * 0.5 + 1, self.map_size.height * 0.5 + 1)    -- 单页刷新的范围
    self.map_refresh_page_recorder = {} -- 刷新  {is_recv = true, time = 0}
    self.map_refresh_page_range = cc.size(math.ceil(self.map_size.width / self.map_refresh_page_size.width), math.ceil(self.map_size.height / self.map_refresh_page_size.height))
    self.map_thumbnail_data = {}
    self.map_link_path = {}

    self.map_giveup = {}    -- {[id] = {id=格子,time=结束时间}}

    -- 当前可进入的区域等级。主要用来控制迷雾的显示
    self.area_level = 1
end

function CrusadeGroupData:isOpen()
    local ret = self.sign_up_status and 
        self.stage >= CRUSADE_GROUP_STATE.BATTLE_START and 
        self.stage < CRUSADE_GROUP_STATE.CLOSE
    return ret
end

-- 根据y判断当前的格子id是否-1
function CrusadeGroupData:getTileIndexOffset(y)
    local realY = self.map_size.height - y - 1
    local offset_x = self.map_draw_type == 1 and (math.mod(realY, 2) == 1 and -1 or 0) or (math.mod(realY, 2) == 0 and -1 or 0)
    return offset_x
 end

 function CrusadeGroupData:getMainGroupIdx(idx)
    local buildingData = self.map_building_data[idx - 1]
    if buildingData then
        return buildingData.group_id
    end
    return idx
end

function CrusadeGroupData:convertGridIdToPos(grid_id)
    grid_id = grid_id - 1
    
    local y = math.floor(grid_id / self.map_size.width)
    local x = grid_id - y * self.map_size.width

    return x, y
end

function CrusadeGroupData:convertPosToGridId(x, y)
    return x + y * self.map_size.width + 1
end

function CrusadeGroupData:getMapDataByPos(x, y)
    return self.map_data[self:convertPosToGridId(x, y)]
end

-- 重新计算所有跟我连线的格子。这个算法最多支持10000个数据。目前活动满人是3000人。以后要支持更多则需要修改该算法
function CrusadeGroupData:updateLinkPath()
    self.map_link_path = {}

    -- ex.Tools:startClock()
    local map_close = {}
    local map_open = {}
    for i,v in ipairs(self.game_data.occupied_list) do
        map_open[v.id] = true
    end
    -- ex.Tools:markClock(1)


    local search_func = function (x, y)
        local is_in_range = x < 0 or x >= self.map_size.width or y < 0 or y >= self.map_size.height
        local gid = x + y * self.map_size.width + 1
        if is_in_range ~= true and map_close[gid] == nil and self.map_data[self:getMainGroupIdx(gid)] then
            map_open[gid] = true
        end
    end

    while table.nums(map_open) > 0 do
        local idx = nil
        for k, v in pairs(map_open) do idx = k break end

        self.map_link_path[idx] = true

        local x, y = self:convertGridIdToPos(idx)

        search_func(x + self:getTileIndexOffset(y + 1), y + 1)
        search_func(x + self:getTileIndexOffset(y + 1) + 1, y + 1)
        search_func(x - 1, y)
        search_func(x + 1, y)
        search_func(x + self:getTileIndexOffset(y - 1), y - 1)
        search_func(x + self:getTileIndexOffset(y - 1) + 1, y - 1)

        -- local vec_adjacent = {
        --     cc.p(x + self:getTileIndexOffset(y + 1), y + 1),
        --     cc.p(x + self:getTileIndexOffset(y + 1) + 1, y + 1),
        --     cc.p(x - 1, y),
        --     cc.p(x + 1, y),
        --     cc.p(x + self:getTileIndexOffset(y - 1) , y - 1),
        --     cc.p(x + self:getTileIndexOffset(y - 1) + 1, y - 1),
        -- }

        -- for i,v in ipairs(vec_adjacent) do
        --     local is_in_range = v.x < 0 or v.x >= self.map_size.width or v.y < 0 or v.y >= self.map_size.height
        --     local gid = v.x + v.y * self.map_size.width + 1
        --     if is_in_range ~= true and map_close[gid] == nil and self.map_data[self:getMainGroupIdx(gid)] then
        --         map_open[gid] = true
        --     end
        -- end

        map_open[idx] = nil
        map_close[idx] = true
    end

    self.area_level = 1
    
    for i,v in ipairs(self.game_data.occupied_list) do
        local area_level = cfg.crusadegrouptilelevel.getAreaLevel(v.id)
        if area_level >= self.area_level then
            self.area_level = area_level
       end
    end

    for k,v in pairs(self.map_link_path) do
        local fight_type = cfg.crusadegrouptilelevel.getFightType(k)
        if fight_type == 2 then
           local area_level = cfg.crusadegrouptilelevel.getAreaLevel(k)
           if area_level >= self.area_level then
                self.area_level = area_level + 1
           end
        end
    end

    -- print("xxxx", table.nums(map_close))
end

-- 生成一个A星寻找节点
function CrusadeGroupData:getAStarNode(x1, y1)
    local idx = y1 * self.map_size.width + x1 + 1
    local main_idx = self:getMainGroupIdx(idx)
    local data = {x=x1, y=y1, h=0, f=0, g=0}
    -- 這個格子被佔領了。如果格子id不等於組id。則這個格子一定是建築的一部分。則這個格子是可以移動的
    -- self.map_data[self:getMainGroupIdx(idx)] ~= nil and 
    data.is_move = self.map_data[self:getMainGroupIdx(idx)] ~= nil
    return data
end               

function CrusadeGroupData:canAttackTile(astar, x, y)

    local idx = self:convertPosToGridId(x, y)
    local building_level = cfg.crusadegrouptilelevel.getBuildingLevel(idx)

    local path = nil
    -- 这个是单个格子
    local pos_list = {}
    if building_level <= 5 then
        pos_list = {
            cc.p(x, y),
        }
    elseif building_level <= 7 then
        pos_list = {
            cc.p(x, y),
            cc.p(x + self:getTileIndexOffset(y-1), y-1),
            cc.p(x + self:getTileIndexOffset(y-1) + 1, y-1),
        }
    elseif building_level <= 8 then
        pos_list = {
            cc.p(x, y),
            cc.p(x + self:getTileIndexOffset(y-1), y-1),
            cc.p(x + self:getTileIndexOffset(y-1) + 1, y-1),
            cc.p(x + self:getTileIndexOffset(y+1), y+1),
            cc.p(x + self:getTileIndexOffset(y+1) + 1, y+1),
            cc.p(x + 1, y),
            cc.p(x - 1, y),
        }
    end


    -- 先从缓冲区拿数据
    for i,v in ipairs(pos_list) do
        local near_pos = {
            cc.p(v.x + self:getTileIndexOffset(v.y + 1), v.y + 1),
            cc.p(v.x + self:getTileIndexOffset(v.y + 1) + 1, v.y + 1),
            cc.p(v.x - 1, v.y),
            cc.p(v.x + 1, v.y),
            cc.p(v.x + self:getTileIndexOffset(v.y - 1) , v.y - 1),
            cc.p(v.x + self:getTileIndexOffset(v.y - 1) + 1, v.y - 1),
        }
        local is_find = false
        for ii, vv in ipairs(near_pos) do
            path = self.map_link_path[vv.x + vv.y * self.map_size.width + 1]
            if path then
                is_find = true
                break
            end
        end

        if is_find then
            break
        end
    end

    -- A星寻路。效率太低了
    -- if path == nil then
    --     for i,v in ipairs(pos_list) do
    --         path = astar:startSearch({x=v.x, y=v.y, h=0, f=0, g=0}, {x=0, y=0, h=0, f=0, g=0})
    --         if path ~= nil then
    --             break
    --         end
    --     end
    -- end

    return path ~= nil 
end

-- 获得团长信息
function CrusadeGroupData:getLeaderData()
    local vec_member = self.game_data.crusade_group_list
    for i,v in ipairs(vec_member) do
        if v.position == 2 then
            return v
        end
    end
    return nil
end

-- 获得领地信息
function CrusadeGroupData:getTownData(town_id)
    local vec_town = self.game_data.occupied_list
    for i,v in ipairs(vec_town) do
        if v.id == town_id then
            return v
        end
    end
    return nil
end

-- 获取出征英雄
function CrusadeGroupData:getSetOffHero(hero_id)
    for i,v in ipairs(self.game_data.set_off_hero_list) do
        if v.hero.hero_id == hero_id then
            return v
        end
    end 
    return nil
end

-- 获取神兵信息
function CrusadeGroupData:setGodArmsInfo(data)
    self.god_arms_info = data
    
end

-- 获取玩家神兵信息
function CrusadeGroupData:setRoleGodArmsInfo(data)
    self.role_god_arms_info = data
    -- self:godArmsAddRed()
end 

-- 神兵装备
function CrusadeGroupData:setGodArmsEquip(data)
    self.god_arms_equip = data
   
end

-- 神兵升级核心等级
function CrusadeGroupData:setGodArmsCoreUp(data)
    self.god_arms_core_up = data
    -- self:godArmsAddRed()
end

--神兵战力
function CrusadeGroupData:setShenBinFighting(data)
    self.god_arms_fighting = data.fighting
end

function CrusadeGroupData:checkShenBinRedot()
    local is_light = false
    for i=1,4 do
        local reddot = self:getJobReddot(i)
        if reddot  then
            is_light = true
            break
        end
    end
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_TFT_SB, is_light)
end


function CrusadeGroupData:getJobReddot(job)
    -- 判断职级
    if self:getTeamLvReddot(job) then
        return true
    end
    
    -- 判断槽位
    for i=1, 6 do
        if self:getWearReddot(job, i) then
            return true
        end
    end
    return false
end

function CrusadeGroupData:getWearReddot(job, place)
    local job_data = TableEx.findValueFunction(self.god_arms_info.shenBinInfos, function(data)
        return data.job == job
    end)

    -- 获取当前核心等级和装备列表
    local corelv = 1
    local equip_data = {}
    if job_data ~= nil then
        equip_data = job_data.equipData.equip_list
        corelv = job_data.coreLv
    end

    -- 获取当前槽位的信息
    local pos_data = TableEx.findValueFunction(equip_data, function(data)
        return data.place == place
    end)
    
    -- 如果当前槽位不为空时，则没有红点
    if pos_data and pos_data.equip_type ~= -1 then
        return false
    end

    local config_shenbinhole = TableEx.findValueFunction(cfg.crusadegroupshenbinhole.crusadegroupshenbinhole, function(data)
        return data.job == job and data.corelv == corelv and data.hole == place
    end)

    -- 当前职业和核心等级都获取不到配置表。则视为出bug了
    if config_shenbinhole == nil then
        return false
    end

    -- 获取背包是否有可穿戴的装备
    local item_data2 = TableEx.findValueFunction(self.role_god_arms_info.roleShenBins, function(data)
        return data.item_type == config_shenbinhole.sb_id
    end)

    if item_data2 and item_data2.itemNum >= 1 then
        return true
    end

    -- 获取升级需要的素材
    local need_num = self:getComposeEquip(config_shenbinhole.sb_id, 1)
    local has_num = 0
    local item_data = TableEx.findValueFunction(self.role_god_arms_info.roleShenBins, function(data)
        return data.item_type == ItemType.IT_WEAPON_ESSENCE
    end)

    if item_data then
        has_num = item_data.itemNum
    end

    -- 判断数量是否可以升级
    if has_num >= need_num then
        return true
    end

    return false
end

function CrusadeGroupData:getTeamLvReddot(job)
    local wear_num = 0

    local job_data = TableEx.findValueFunction(self.god_arms_info.shenBinInfos, function(data)
        return data.job == job
    end)

    -- 当前职业所有槽位都为空
    if job_data == nil then
        return false
    end

    local equip_data = {}
    if job_data ~= nil then
        equip_data = job_data.equipData.equip_list
    end

    -- 计算穿戴数量
    for i,v in ipairs(equip_data) do
        if v.equip_type ~= -1 then
            wear_num = wear_num + 1
        end
    end

    local coreLv = job_data.coreLv + 1
    local config_shenbincore = TableEx.findValueFunction(cfg.crusadegroupshenbincore.crusadegroupshenbincore, function(data)
        return data.job == job and data.corelv == coreLv
    end)

    -- 已经达到最大等级
    if config_shenbincore == nil then
        return false
    end

    -- 如果穿戴了6个装备，而且职级满足条件
    if wear_num >= 6 and self.game_data.self_occupation_id >= config_shenbincore.teamlv then
        return true
    end

    return false
end

--获取合成神兵所需要的材料 与背包里所用的神兵做计算
function CrusadeGroupData:getComposeEquip(sb_id, num)
    local vec_backpack = clone(self.role_god_arms_info.roleShenBins)
    return self:getComposeEquipRecursive(sb_id, num, vec_backpack)
end

function CrusadeGroupData:getComposeEquipRecursive(sb_id, num, vec_backpack)
    local count_num = 0
    local function getID (id)
        for k,v in pairs(vec_backpack) do
            if id == v.item_type then
                return v.itemNum
            end
        end
        return 0
    end

    local sb_config = TableEx.findValueFunction(cfg.crusadegroupshenbin.crusadegroupshenbin,function(v)
            return v.sb_id == sb_id
        end)

    for i, v in ipairs(sb_config.compose_sb) do
        local need_num = v.item_num * num
        local surplus_num = getID(v.item_type) - need_num

        local backpack_data = TableEx.findValueFunction(vec_backpack, function(data)
            return data.item_type == v.item_type
        end)

        if backpack_data and surplus_num >= 0 then
            backpack_data.itemNum = surplus_num
        end
        
        if surplus_num < 0 then
            count_num = count_num + self:getComposeEquipRecursive(v.item_type, -surplus_num, vec_backpack)
        end
    end

    for i, v in ipairs(sb_config.compose_item) do
        local need_num = v.item_num * num 
        count_num = count_num + need_num
    end
    return count_num
end


--合成神兵所要的总材料 没有和背包里的神兵做计算
function CrusadeGroupData:getMaterial(sb_id, num)
    local count_num = 0

    local sb_config = TableEx.findValueFunction(cfg.crusadegroupshenbin.crusadegroupshenbin,function(v)
            return v.sb_id == sb_id
        end)

    for i, v in ipairs(sb_config.compose_sb) do
        local need_num = v.item_num * num 

        if need_num > 0 then
            count_num = count_num + self:getMaterial(v.item_type, need_num)
        end
    end

    for i, v in ipairs(sb_config.compose_item) do
        local need_num = v.item_num * num 
        count_num = count_num + need_num
    end
    return count_num
end


-- 获取标记状态
function CrusadeGroupData:isMark(idx)
    -- 判断这个地块是否已经标记
    local is_mark = TableEx.findValueFunction(self.game_data.territory_mark, function(v)
        return v.territory_id == idx
    end)
    return is_mark
end

-- 檢查職級紅點
function CrusadeGroupData:checkNobilityReddot()
    -- 獲取當前職級任務列表
    local task_num_max = 0
    local complete_num = 0
    local has_task_can_complete = false
    local cur_nobility = self.game_data.self_occupation_id
    for _,task_item in ipairs(cfg.crusadegroupoccupationtask.crusadegroupoccupationtask) do
        if task_item.oc_id == cur_nobility then
            task_num_max = task_num_max + 1
            for _,v in ipairs(self.game_data.tasklist) do
                if v.taskId == task_item.id then
                    if v.complete_type == 0 then
                        complete_num = complete_num + 1
                    elseif v.condition == 0 and v.targetCount >= task_item.task.target then
                        has_task_can_complete = true
                    end
                    break
                end
            end
        end
    end
    
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_TFT_ZJ_RW_WC, has_task_can_complete)
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_TFT_ZJ_RW_JS, task_num_max > 0 and task_num_max <= complete_num)
end

return CrusadeGroupData
