local TowerResponse = class("TowerResponse")

function TowerResponse:resTowerData(data)
	ex.Player.tower_data:setNowStage(data.stage)
	ex.Player.tower_data.energy 	 = data.energy
	ex.Player.tower_data.energy_time = data.energy_time
	ex.Player.tower_data.sweep_times = data.sweep_times
	
	ex.Player.tower_data:updateTowerRedDot()
	
	ex.EventManager:fire(EVENT.TOWER_EVENT.TOWER_LAYER_UPDATE)
end

function TowerResponse:resTowerBattleEnd(data)
	ex.Player.tower_data.energy = data.energy
	ex.Player.tower_data.energy_time = data.energy_time

	ex.Player.tower_data:setNowStage(data.stage)
	ex.Player.tower_data:updateFirstRewardRedDot()

	-- 输了显示当前层数。赢了显示上一层
	local stage = data.report.win_id == ex.Player.role_id and data.stage - 1 or data.stage
	data.report.defender.name = string.format(ex.Tools:getLang(47016), stage)
	ex.EventManager:fire(EVENT.TOWER_EVENT.TOWER_BATTLE_END)
	
	ctr.fantasy_tower:addBattleLayer()
	ex.EventManager:fire(EVENT.TOWER_EVENT.TOWER_BATTLE_START, data.report, ex.Tools:convertRewardList(data.items), data)
	-- require("src.layer.ChapterEndCtr"):instance():openWindow(is_win, vec_data)
end

function TowerResponse:resTowerEnergyBuy(data)
	local status = data.status
	local energy = data.energy

	if status == 1 then
		ex.MessageView:add(ex.Tools:getLang(47428))
		return
	elseif status == 2 then
		ex.MessageView:add(ex.Tools:getLang(47322))
		return
	end

	ex.Player.tower_data.energy = energy
	ex.EventManager:fire(EVENT.TOWER_EVENT.TOWER_LAYER_UPDATE)
end

function TowerResponse:resTowerRewardList(data)
	local vec_reward = {}
	for i,v in ipairs(data.list) do
		table.insert(vec_reward, v)
	end

	ex.Player.tower_data.vec_tower_reward = vec_reward
	ex.Player.tower_data:updateFirstRewardRedDot()
end

function TowerResponse:resTowerSweep(data)
	-- 当前扫荡次数新增
	ex.Player.tower_data.sweep_times = data.sweep_times
	ex.Player.tower_data:updateTowerRedDot()
	
	ex.EventManager:fire(EVENT.TOWER_EVENT.TOWER_LAYER_UPDATE)
	-- 更新界面
	require("src.layer.fantasytower.FantasyTowerPreviewCtr"):instance():updateSweepStatue()
end


function TowerResponse:towerLog(data)
    ex.Player.tower_data.log = data
    ex.EventManager:fire(EVENT.TOWER_EVENT.TOWER_LOG)
end

function TowerResponse:editBattle(data)
	ex.EventManager:fire(EVENT.TOWER_EVENT.TOWER_BATTLE_START, data.report, {}, data)
end

return TowerResponse