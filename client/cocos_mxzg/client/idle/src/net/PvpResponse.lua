local PvpResponse = class("PvpResponse")

function PvpResponse:pvpData(data, byte_array)
	ex.Player.pvp_data.free_count = data.free_count
	ex.Player.pvp_data.score = data.score
	ex.Player.pvp_data.season_end_time = data.season_end_time
	ex.Player.pvp_data.season_count = data.season_count or 0
	ex.Player.pvp_data.season_reward_list = data.season_reward

	ex.Player.pvp_data.like_list = data.like_rids

	ex.Player.pvp_data.enemy_list = data.list
	require("src.layer.PvpCtr"):instance():updateBattleList()
	
	ex.Player.pvp_data:checkRedDot()
end

function PvpResponse:pvpPlayerRefresh(data)
	ex.Player.pvp_data.enemy_list = data.list
	require("src.layer.PvpCtr"):instance():updateBattleList()
	ex.Player.pvp_data:checkRedDot()
end

function PvpResponse:pvpBattle(data, byte_array)
	-- dump(data, "PvpResponse:pvpBattle")
	local cross_battle = cc.UserDefault:getInstance():getBoolForKey("pvp_cross_battle")
	if cross_battle ~= nil and cross_battle == true then
		local vec_reward = {}
		for i,v in ipairs(data.list) do
			table.insert(vec_reward, {item_type = v.type, item_num = v.num})
		end
		local ctr = require("src.layer.PvpEndCtr"):instance()
		ctr:openWindow(data.is_win > 0,
						data.player_id,
						vec_reward,
						data)
		local is_clergy_privilege = cfg.clergyprivilege.isPrivilege(CLERGY_PRIVILEGE_TYPE.PVP, ex.Player.clergy_level)
		ctr:addBottomTip(ex.Tools:getLang(is_clergy_privilege and (data.chance_status ~= 0 and 49308 or 49309) or 49307))
		if data.is_win > 0 then
			NetManager:sendMessage(ProtocolID.GReqPvpPlayerRefresh)
		end
	else
		ctr.pvp_battle:addBattleLayer()
		ex.EventManager:fire(EVENT.PVP_EVENT.BATTLE_START, data.report,
							ex.Tools:convertRewardList(data.list),
							data)
	end

	ex.Player.crown = data.self_cup
	require("src.layer.PvpCtr"):instance():updateLayer()

	-- 重新更新对手
	NetManager:sendMessage(ProtocolID.GReqPvpData)

	if cross_battle ~= nil and cross_battle == true and data.is_win > 0 then
		-- 重新更新对手
		NetManager:sendMessage(ProtocolID.GReqPvpPlayerRefresh)
	end

	-- 刷新排行榜
	NetManager:sendMessage(ProtocolID.GReqPvpRankList)

	-- 查看战斗历史
	NetManager:sendMessage(ProtocolID.GReqPvpBattleHistoryList)

	ex.Player.promotion_data:reqPvpWinsLists()

	ex.Player.pvp_data:checkRedDot()
end


function PvpResponse:pvpBattleEnd(data, byte_array)

	require("src.layer.PvpEndCtr"):instance():openWindow(data.is_win == 1 and true or false,
														 data.list or {},
														 data.self_score,
														 data.enemy_score)
	ex.Player.crown = ex.Player.crown + data.self_score
	require("src.layer.PvpCtr"):instance():updateLayer()

	-- 重新更新对手
	NetManager:sendMessage(ProtocolID.GReqPvpData)
	NetManager:sendMessage(ProtocolID.GReqPvpPlayerRefresh)

	-- 刷新排行榜
	NetManager:sendMessage(ProtocolID.GReqPvpRankList)

	-- 查看战斗历史
	NetManager:sendMessage(ProtocolID.GReqPvpBattleHistoryList)

	ex.Player.promotion_data:reqPvpWinsLists()

	ex.Player.pvp_data:checkRedDot()
end


function PvpResponse:pvpBattleHistory(data)

end


function PvpResponse:pvpBattleHistoryList(data, byte_array)
	ex.Player.pvp_data.history_id_list = {}
	for i,v in ipairs(data.list) do
		table.insert(ex.Player.pvp_data.history_id_list, v.battle_id)
		ex.Player.pvp_data.history_list[v.battle_id] = v
	end
	-- ex.Player.pvp_data.history_id_list = data.list
	-- NetManager:sendMessage(ProtocolID.GReqPvpBattleHistory, req_battle_history)
end

-- 查询玩家的点赞和被点赞次数
function PvpResponse:pvpLike(data)
	-- GResPvpLike

	-- 刷新次数
	local is_have = false
	for k,v in pairs(ex.Player.pvp_data.like_list) do
		if v == data.rid then
			is_have = true
			break
		end
	end
	if is_have == false then
		table.insert(ex.Player.pvp_data.like_list, data.rid)
	end
	for i,v in ipairs(ex.Player.pvp_data.rank_list) do
		if v.player_id == data.rid then
			v.belike = data.belike
		end
	end

	-- 获得奖励

	-- 刷新显示
	require("src.layer.PvpCtr"):instance():updateRankList()
end

-- 赛季积分奖励领取
function PvpResponse:pvpSeasonReward(data)
	-- GResPvpSeasonReward
	for k,v in pairs(ex.Player.pvp_data.season_reward_list) do
		if v == data.type then
			return
		end
	end
	table.insert(ex.Player.pvp_data.season_reward_list, data.type)

	-- 刷新显示
	require("src.layer.PvpCtr"):instance():updateBattleList()
end

return PvpResponse