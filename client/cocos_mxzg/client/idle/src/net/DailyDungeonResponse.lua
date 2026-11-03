local DailyDungeonResponse = class("DailyDungeonResponse")

function DailyDungeonResponse:dailyDungeonList(data)
 	for i,v in ipairs(data.list) do 		
		ex.Player.daily_dungeon_data:setMissionCount(v.mission_type, v.count)
		ex.Player.daily_dungeon_data:setMissionId(v.mission_type, v.mission)
 	end

 	ex.Player.daily_dungeon_data:updateRedDot()
end

function DailyDungeonResponse:dailyDungeonEnd(data, byte_array)
	local is_sweep = data.report.win_id == 0
	local is_win = data.report.win_id == ex.Player.role_id
	if is_win == true or is_sweep == true then
		-- 修改次数。
		ex.Player.daily_dungeon_data:addMissionCount(data.mission_type, 1)
		ex.Player.daily_dungeon_data:setMissionId(data.mission_type, data.mission_id)
		ex.Player.daily_dungeon_data:updateRedDot()
	end
	
	ex.EventManager:fire(EVENT.DAILY_DUNGEON_EVENT.BATTLE_START, data.report, ex.Tools:convertRewardList(data.list), {is_clergy_add = data.chance_status})
	ex.EventManager:fire(EVENT.DAILY_DUNGEON_EVENT.UPDATE)
end

function DailyDungeonResponse:dailyDungeonSweep(data)
	local clergy_type
	if data.mission_type == 1 then
		clergy_type = CLERGY_PRIVILEGE_TYPE.GOLD_MISSION
	elseif data.mission_type == 2 then
		clergy_type = CLERGY_PRIVILEGE_TYPE.EXP_MISSION
	elseif data.mission_type == 3 then
		clergy_type = CLERGY_PRIVILEGE_TYPE.HERO_MISSION
	elseif data.mission_type == 4 then
		clergy_type = CLERGY_PRIVILEGE_TYPE.FETTER_MISSION
	elseif data.mission_type == 5 then
		clergy_type = CLERGY_PRIVILEGE_TYPE.RUNE_MISSION
	end

	local is_clergy_privilege = cfg.clergyprivilege.isPrivilege(clergy_type, ex.Player.clergy_level)
	ex.Player.daily_dungeon_data:updateRedDot()

	local award_list = ex.Tools:convertRewardList(data.list)
	require("src.layer.ItemRewardCtr"):instance():openWindow(award_list)
	require("src.layer.ItemRewardCtr"):instance():addBottomTip(ex.Tools:getLang(is_clergy_privilege and (data.chance_status ~= 0 and 49308 or 49309) or 49307))
end

return DailyDungeonResponse