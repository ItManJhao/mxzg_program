local STMagicTowerResponse = class("STMagicTowerResponse")

-- 初始信息
function STMagicTowerResponse:setSTMagicTowerInfo(data)
    local stmt_data = ex.Player.space_time_magic_tower_data
    stmt_data.mission_id = data.mission_id or 0
    stmt_data.cur_lv = cfg.timetowermisson.getLevelByMission(data.mission_id + 1)
    stmt_data.accumulate_pass = data.accumulate_pass
    stmt_data.max_pass = data.max_pass
    stmt_data.heart = data.heart
    stmt_data.startTime = data.startTime
    stmt_data.endTime = data.endTime

    cfg.funcopen.main_space_time_magic_tower.checkRedDot(stmt_data)
    ex.EventManager:fire(EVENT.SPACE_TIME_MAGIC_TOWER.UPDATE_INFO)
end

function STMagicTowerResponse:stMagicTowerBattle(data)
    if data then
        local stmt_data = ex.Player.space_time_magic_tower_data
        stmt_data.heart = data.heart
        stmt_data.mission_id = data.cur_mission_id
        if type(data.comment) == "number" and data.comment > 0 then
            table.insert(stmt_data.mission_mark, data.comment)
            if #stmt_data.mission_mark > 3 then
                table.remove(stmt_data.mission_mark, 1)
            end
        end
        stmt_data.cur_lv = cfg.timetowermisson.getLevelByMission(data.cur_mission_id + 1)

        cfg.funcopen.main_space_time_magic_tower.checkRedDot(stmt_data)
        ex.EventManager:fire(EVENT.SPACE_TIME_MAGIC_TOWER.BATTLE, data)
    end
end

function STMagicTowerResponse:setSTMagicTowerRankInfo(data)
    if not data then
        return
    end
    local stmt_data = ex.Player.space_time_magic_tower_data
    stmt_data.my_rank = data.my_rank
    if data.rank_list then
        stmt_data.rank_list = clone(data.rank_list)
    end

    ex.EventManager:fire(EVENT.SPACE_TIME_MAGIC_TOWER.UPDATE_RANK)
end


return STMagicTowerResponse