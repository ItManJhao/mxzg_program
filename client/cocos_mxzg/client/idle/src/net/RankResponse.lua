local RankResponse = class("RankResponse")

function RankResponse:rankTowerList(data)
	-- local data = NetManager:resLuaData(ProtocolResponse.ResRankTowerList, byte_array)
	-- dump(data, "RankResponse:rankTowerList")

	-- 数据排序	
	-- 排序。
	table.sort(data.list, function(a,b)
		return a.rank < b.rank
	end)

	local max_stage = table.nums(cfg.towerreward.towerreward)
	for k,v in pairs(data.list) do
		v.score = Maths.clampf(v.score, 1 , max_stage)
	end
	-- print(max_stage)
	data.self_data.score = Maths.clampf(data.self_data.score, 1 , max_stage)
	-- print(data.self_data.score)

	ex.Player.tower_data.rank_list = data.list
	ex.Player.tower_data.rank_self = data.self_data

	ex.Player.rank_data.rank_tower_list = data.list
	ex.Player.rank_data.rank_tower_self = data.self_data

	require("src.layer.RankListCtr"):instance():updateTableView()
	require("src.layer.RankTopThreeCtr"):instance():updateTableView()

end

function RankResponse:rankPvpList(data)
	-- local data = NetManager:resLuaData(ProtocolResponse.ResRankPvpList, byte_array)
	-- dump(data, "RankResponse:rankPvpList")
	ex.Player.pvp_data.rank_self = data.self_data

	ex.Player.pvp_data.rank_list = data.list
	-- dump(data, "PvpResponse:rankPvpList")

	ex.Player.rank_data.rank_pvp_list = data.list
	ex.Player.rank_data.rank_pvp_self = data.self_data

	require("src.layer.PvpCtr"):instance():updateBattleList()

	require("src.layer.RankListCtr"):instance():updateTableView()
	require("src.layer.RankTopThreeCtr"):instance():updateTableView()


end

-- 公会排行
function RankResponse:rankClanList(data)
	-- dump(data, "ClanResponse:clanRank")
	-- 刷新公会排行界面
 	ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_RANK_CLAN, data.list)

 	-- 刷新排行榜界面
	ex.Player.rank_data.rank_clan_list = data.list
	ex.Player.rank_data.rank_clan_self = data.psClanRankData

	require("src.layer.RankListCtr"):instance():updateTableView()
	require("src.layer.RankTopThreeCtr"):instance():updateTableView()
end

function RankResponse:rankChapterList(data)
	-- local data = NetManager:resLuaData(ProtocolResponse.ResRankChapterList, byte_array)
	-- dump(data, "RankResponse:rankChapterList")

	ex.Player.rank_data.rank_chapter_list = data.list
	ex.Player.rank_data.rank_chapter_self = data.self_data

	require("src.layer.RankListCtr"):instance():updateTableView()
	require("src.layer.RankTopThreeCtr"):instance():updateTableView()
end


function RankResponse:rankTowerList(data)
	-- local data = NetManager:resLuaData(ProtocolResponse.ResRankTowerList, byte_array)
	-- dump(data, "RankResponse:rankTowerList")

	-- 数据排序	
	-- 排序。
	table.sort(data.list, function(a,b)
		return a.rank < b.rank
	end)

	local max_stage = table.nums(cfg.towerreward.towerreward)
	for k,v in pairs(data.list) do
		v.score = Maths.clampf(v.score, 1 , max_stage)
	end
	
	data.self_data.score = Maths.clampf(data.self_data.score, 1 , max_stage)

	ex.Player.tower_data.rank_list = data.list
	ex.Player.tower_data.rank_self = data.self_data

	ex.Player.rank_data.rank_tower_list = data.list
	ex.Player.rank_data.rank_tower_self = data.self_data

	require("src.layer.RankListCtr"):instance():updateTableView()
	require("src.layer.RankTopThreeCtr"):instance():updateTableView()


	ex.EventManager:fire(EVENT.RANK_EVENT.UPDATE_TOWER_LAYER)
end

function RankResponse:rankPlayerList(data)
	-- local data = NetManager:resLuaData(ProtocolResponse.ResRankPlayerList, byte_array)
	-- dump(data, "RankResponse:rankPlayerList")

	ex.Player.rank_data.rank_player_list = data.list
	ex.Player.rank_data.rank_player_self = data.self_data

	require("src.layer.RankListCtr"):instance():updateTableView()
	require("src.layer.RankTopThreeCtr"):instance():updateTableView()
end

function RankResponse:rankDungeonList(data)
	-- local data = NetManager:resLuaData(ProtocolResponse.ResRankDungeonList, byte_array)
	-- dump(data, "RankResponse:rankDungeonList")

	ex.Player.rank_data.rank_dungeon_list = data.list
	ex.Player.rank_data.rank_dungeon_self = data.self_data

	require("src.layer.RankListCtr"):instance():updateTableView()
	require("src.layer.RankTopThreeCtr"):instance():updateTableView()
end


function RankResponse:rankWorshipList(data)
	-- local data = NetManager:resLuaData(ProtocolResponse.ResRankWorshipList, byte_array)
	-- dump(data, "RankResponse:rankWorshipList")

	ex.Player.rank_data.worship_type_list = data.list

	ex.EventManager:fire(EVENT.RANK_EVENT.UPDATE_WORSHIP)

	ex.Player.rank_data:checkRedDot()
end


function RankResponse:rankWorshipOffline(data)
	-- print("RankResponse:rankWorshipList", byte_array:getLength())
	-- local data = NetManager:resLuaData(ProtocolResponse.ResRankWorship, byte_array)
	-- dump(data, "RankResponse:rankWorship")

	ex.Player.rank_data.worship_list = data.list
	-- dump(data, "RankResponse:rankWorship")
end

function RankResponse:rankCrossClanList(data)
	ex.Player.rank_data.rank_cross_clan_list = data.list
	ex.Player.rank_data.rank_cross_clan_self = data.psClanRankData

	require("src.layer.RankListCtr"):instance():updateTableView()
	require("src.layer.RankTopThreeCtr"):instance():updateTableView()
end

function RankResponse:rankCrossFightingList(data)
	ex.Player.rank_data.rank_cross_fighting_list = data.list
	ex.Player.rank_data.rank_cross_fighting_self = data.self_data

	require("src.layer.RankListCtr"):instance():updateTableView()
	require("src.layer.RankTopThreeCtr"):instance():updateTableView()
end

function RankResponse:godRelicRank(data)
	ex.Player.rank_data.rank_god_relic_list = data.list
	ex.Player.rank_data.rank_god_relic_self = data.self

	require("src.layer.RankListCtr"):instance():updateTableView()
	require("src.layer.RankTopThreeCtr"):instance():updateTableView()
end


function RankResponse:floatingIslandsRank(data)
	ex.Player.rank_data.rank_floating_islands_list = data.ranks
	ex.Player.rank_data.rank_floating_islands_self = data.self
	ex.EventManager:fire(EVENT.RANK_EVENT.UPDATE_RANK_TOP_LAYER)
end


return RankResponse