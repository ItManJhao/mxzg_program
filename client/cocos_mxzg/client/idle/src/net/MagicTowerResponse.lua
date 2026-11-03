local MagicTowerResponse = class("MagicTowerResponse")

-- 幻魔塔基础数据
function MagicTowerResponse:magicTowerData(data)
	--GResMagicTowerData
	local magic_tower_data = ex.Player.magic_tower_data

	magic_tower_data:setNowStage(data.level_data)

	magic_tower_data.can_challenge_times = data.can_challenge_count
	magic_tower_data.buy_times = data.buy_count

	magic_tower_data.challenger_list = data.arena

	magic_tower_data:checkReddot()

	ex.EventManager:fire(EVENT.MAGIC_TOWER_EVENT.UPDATE)
end

-- 幻魔塔挑战回调
function MagicTowerResponse:magicTowerChallenge(data)
	--GResMagicTowerChallenge
	NetManager:sendMessage(ProtocolID.GReqMagicTowerData)

	ctr.magic_tower:addBattleLayer()
	ex.EventManager:fire(EVENT.MAGIC_TOWER_EVENT.BATTLE_START, data.battle_report, ex.Tools:convertRewardList(data.reward), data)
end

-- 幻魔塔购买挑战次数
function MagicTowerResponse:magicTowerBuyCount(data)
	--GResMagicTowerBuyCount
	local magic_tower_data = ex.Player.magic_tower_data

	magic_tower_data.can_challenge_times = data.can_challenge_count
	magic_tower_data.buy_times = data.buy_count

	magic_tower_data:checkReddot()

	ex.EventManager:fire(EVENT.MAGIC_TOWER_EVENT.CHALLENGE_TIMES)
end

-- 幻魔塔扫荡回调
function MagicTowerResponse:magicTowerSweep(data)
	--GResMagicTowerSweep
	local magic_tower_data = ex.Player.magic_tower_data

	magic_tower_data.can_challenge_times = data.can_challenge_count

	magic_tower_data:checkReddot()

	ex.EventManager:fire(EVENT.MAGIC_TOWER_EVENT.CHALLENGE_TIMES)
end

-- 幻魔塔挑战擂主回调
function MagicTowerResponse:magicTowerChallenger(data)
	--GResMagicTowerChallengeArena
    ctr.magic_tower:addBattleLogLayer()
	ex.EventManager:fire(EVENT.MAGIC_TOWER_EVENT.BATTLE_START, data.battle_report, nil, data)
end

-- 幻魔塔擂主数据广播
function MagicTowerResponse:magicTowerChallengerBrocast(data)
	--GResMagicTowerArenaBro
	local magic_tower_data = ex.Player.magic_tower_data
	
	local stage_idx = -1
	for i,v in ipairs(magic_tower_data.challenger_list) do
		if v.level == data.arena.level then
			stage_idx = i
			break
		end
	end
	if stage_idx > 0 then
		magic_tower_data.challenger_list[stage_idx] = data.arena
	else
		table.insert(magic_tower_data.challenger_list, data.arena)
	end

	ex.EventManager:fire(EVENT.MAGIC_TOWER_EVENT.UPDATE)
end

-- 幻魔塔指定层战报
function MagicTowerResponse:magicTowerStageLog(data)
	-- GResMagicTowerLevelPassDetail
	local magic_tower_data = ex.Player.magic_tower_data

	magic_tower_data.stage_log = data

	ex.EventManager:fire(EVENT.MAGIC_TOWER_EVENT.LOG)
end

function MagicTowerResponse:magicTowerShowLog(data)
	-- GResMagicTowerQuery
    ctr.magic_tower:addBattleLogLayer()
	ex.EventManager:fire(EVENT.MAGIC_TOWER_EVENT.BATTLE_START, data.report)
end

function MagicTowerResponse:magicTowerRank(data)
	--GResMagicTowerLevelRank
	ex.Player.rank_data.rank_magic_tower_list = data.list
	ex.Player.rank_data.rank_magic_tower_self = data.self

	require("src.layer.RankTopThreeCtr"):instance():updateTableView()

	ex.EventManager:fire(EVENT.MAGIC_TOWER_EVENT.RANK)
end

function MagicTowerResponse:magicTowerRoadInfo(data)
	--GResMagicTowerRoadInfo
	local magic_tower_data = ex.Player.magic_tower_data

	magic_tower_data.road_normal_list = data.normal_list
	magic_tower_data.road_king_list = data.king_list
	magic_tower_data.is_buy_king = data.state > 0

	magic_tower_data:checkReddot()

	ex.EventManager:fire(EVENT.MAGIC_TOWER_EVENT.ROAD_INFO)
end

function MagicTowerResponse:magicTowerRoadInfoReward(data)
	--GResMagicTowerRoadReceive
	local magic_tower_data = ex.Player.magic_tower_data

	if data.type == 1 then
		magic_tower_data.road_normal_list = data.list
	else
		magic_tower_data.road_king_list = data.list
	end

	magic_tower_data:checkReddot()

	ex.EventManager:fire(EVENT.MAGIC_TOWER_EVENT.ROAD_INFO)
end

return MagicTowerResponse