local RankData = class("RankData")

function RankData:ctor()
	self.last_req_time = 0

	self.rank_chapter_list = {}		-- 剧情
	self.rank_chapter_self = {}

	self.rank_tower_list = {}		-- 试练塔
	self.rank_tower_self = {}

	self.rank_magic_tower_list = {}		-- 幻魔塔
	self.rank_magic_tower_self = {}

	self.rank_clan_list = {}		-- 公会
	self.rank_clan_self = {}

	self.rank_pvp_list = {}			-- 竞技场
	self.rank_pvp_self = {}

	self.rank_player_list = {}		-- 个人战力
	self.rank_player_self = {}

	self.rank_cross_clan_list = {}	-- 跨服战力
	self.rank_cross_clan_self = {}

	self.rank_cross_fighting_list = {}	-- 跨服公会
	self.rank_cross_fighting_self = {}

	self.rank_ladder_list = {}		-- 天梯战力
	self.rank_ladder_self = {}

	self.rank_buy_gold_list = {}	-- 点金
	self.rank_buy_gold_self = {}

	self.rank_pub_task_list = {}	-- 酒馆常客
	self.rank_pub_task_self = {}

	self.rank_trial_list = {}		-- 试炼之路
	self.rank_trial_self = {}

	self.rank_quick_battle_list = {}	-- 速战之王
	self.rank_quick_battle_self = {}

	self.rank_crusade_group_res_list = {}		-- 讨伐团自然之力排行
	self.rank_crusade_group_res_self = {}

	self.rank_crusade_group_damage_list = {}	-- 讨伐团boss伤害排行
	self.rank_crusade_group_damage_self = {}

	self.rank_crusade_member_res_list = {}		-- 讨伐团成员自然之力排行
	self.rank_crusade_member_res_self = {}

	self.rank_crusade_member_damage_list = {}	-- 讨伐团成员boss伤害排行
	self.rank_crusade_member_damage_self = {}

	-- 地牢排行数据
	self.last_req_dungeon_time = 0
	self.rank_dungeon_list = {}
	self.rank_dungeon_self = {}

	-- 公会boss排行数据
	self.clan_boss_rank_player = {}	-- 公会boss个人排行	{rank, name, point}
	self.clan_boss_self_rank_player = {}-- 公会boss当前个人排名
	self.clan_boss_rank_clan = {}	-- 公会boss公会排行	{rank, name, point}
	self.clan_boss_self_rank_clan = {}	-- 公会boss当前公会排名

	-- [type]
	self.worship_type_list = {}

	-- [{type,name}]
	self.worship_list = {}

	-- 天梯英雄殿点赞列表
	self.rank_ladder_like_list = {}

	self.rank_god_relic_list = {}
	self.rank_god_relic_self = {}

	
	self.rank_floating_islands_list = {}
	self.rank_floating_islands_self = {}

end

function RankData:onRefresh(rank_type)
	-- local now = ex.Game:getServerTime()
	-- if now - self.last_req_time > 180 then
		-- self.last_req_time = now

	if rank_type == nil or rank_type == RankTopThreeLayerType.CHAPTER then
		-- 请求剧情排行榜
		NetManager:sendMessage(ProtocolID.GReqRankChapterList)
	end

	if rank_type == nil or rank_type == RankTopThreeLayerType.TOWER then
    	-- 请求试练塔排行榜
    	NetManager:sendMessage(ProtocolID.GReqTowerRank)
	end
	
	if rank_type == nil or rank_type == RankTopThreeLayerType.MAGIC_TOWER then
    	-- 请求幻魔塔排行榜
    	NetManager:sendMessage(ProtocolID.GResMagicTowerLevelRank)
	end
	
	if rank_type == nil or rank_type == RankTopThreeLayerType.PVP then
    	-- 请求竞技场排行榜
    	NetManager:sendMessage(ProtocolID.GReqPvpRankList)
	end
	
	if rank_type == nil or rank_type == RankTopThreeLayerType.PLAYER then
    	-- 请求个人战力排行榜     
    	NetManager:sendMessage(ProtocolID.GReqFightingRankList)	
	end
	
	if rank_type == nil or rank_type == RankTopThreeLayerType.CLAN then
		-- 请求公会排行榜
		NetManager:sendMessage(ProtocolID.GReqClanRank)
	end
	
	if rank_type == nil or rank_type == RankTopThreeLayerType.CROSS_CLAN then
		-- 请求跨服公会排行榜
		NetManager:sendMessage(ProtocolID.GReqCrossClanRank)
	end
	
	if rank_type == nil or rank_type == RankTopThreeLayerType.CROSS_FIGHTING then
		-- 请求跨服战力排行榜
    	NetManager:sendMessage(ProtocolID.GReqCrossFightingRankList)
	end
end

function RankData:onRefreshDungeon()
	-- local now = ex.Game:getServerTime()
	-- if now - self.last_req_dungeon_time > 180 then
	-- 	self.last_req_dungeon_time = now

    	-- 请求地牢排行榜
    	NetManager:sendMessage(ProtocolID.GReqDungeonRankList)
	-- end
end

function RankData:onRefreshLadder()
	-- local now = ex.Game:getServerTime()
	-- if now - self.last_req_ladder_time > 180 then
	-- 	self.last_req_ladder_time = now

		-- 请求天梯排行榜
		local req = Ladder_pb.GReqLadderRank()
		req.page = 1 
    	NetManager:sendMessage(ProtocolID.GReqLadderRank, req)
	-- end
end

function RankData:onRefreshBuyGold()
	-- local now = ex.Game:getServerTime()
	-- if now - self.last_req_buy_gold_time > 180 then
	-- 	self.last_req_buy_gold_time = now

    	-- 请求点金排行榜
    	NetManager:sendMessage(ProtocolID.GReqScanBuyGoldRank)
	-- end
end

function RankData:onRefreshPubTask()
	-- local now = ex.Game:getServerTime()
	-- if now - self.last_req_pub_task_time > 180 then
	-- 	self.last_req_pub_task_time = now

    	-- 请求酒馆常客排行榜
    	NetManager:sendMessage(ProtocolID.GReqScanTavernRank)
	-- end
end

function RankData:onRefreshTrial()
	-- local now = ex.Game:getServerTime()
	-- if now - self.last_req_trial_time > 180 then
	-- 	self.last_req_trial_time = now

    	-- 请求试炼之路排行榜
    	NetManager:sendMessage(ProtocolID.GReqScanAdventureRank)
	-- end
end

function RankData:onRefreshQuickBattle()
	-- local now = ex.Game:getServerTime()
	-- if now - self.last_req_quick_battle_time > 180 then
	-- 	self.last_req_quick_battle_time = now

    	-- 请求速战之王排行榜
    	NetManager:sendMessage(ProtocolID.GReqScanSpeedFightRank)
	-- end
end

function RankData:onRefreshCrusadeGroupRank(group_id)
	-- local now = ex.Game:getServerTime()
	-- if now - self.last_req_quick_battle_time > 180 then
	-- 	self.last_req_quick_battle_time = now

		-- 请求讨伐团自然之力排行榜
		local req = CrusadeGroupRank_pb.GReqCrusadeGroupRank()
		req.type = 1
		req.cgId = group_id
		NetManager:sendMessage(ProtocolID.GReqCrusadeGroupRank, req)
		
		-- 请求讨伐团boss伤害排行榜
		local req = CrusadeGroupRank_pb.GReqCrusadeGroupRank()
		req.type = 2
		req.cgId = group_id
    	NetManager:sendMessage(ProtocolID.GReqCrusadeGroupRank, req)
	-- end
end

function RankData:onRefreshCrusadeMemberRank(group_id, type)
	-- local now = ex.Game:getServerTime()
	-- if now - self.last_req_quick_battle_time > 180 then
	-- 	self.last_req_quick_battle_time = now

		-- 请求讨伐团成员排行榜
		local req = CrusadeGroupRank_pb.GReqCrusadeGroupPRank()
		req.type = type
		req.cgId = group_id
		NetManager:sendMessage(ProtocolID.GReqCrusadeGroupPRank, req)
	-- end
end

function RankData:onRefreshQuickBattle()
	-- local now = ex.Game:getServerTime()
	-- if now - self.last_req_quick_battle_time > 180 then
	-- 	self.last_req_quick_battle_time = now

    	-- 请求速战之王排行榜
    	NetManager:sendMessage(ProtocolID.GReqScanSpeedFightRank)
	-- end
end

function RankData:onRefreshGodRelic()
	NetManager:sendMessage(ProtocolID.GReqGodRelicRank)
end

-- 请求幻魔塔排行榜
function RankData:onRefreshMagicTower()
	NetManager:sendMessage(ProtocolID.GReqMagicTowerLevelRank)
end

function RankData:addWorshipType(type)
	table.insert(self.worship_type_list, type)
end

-- 0:已经膜拜。 1:未膜拜
function RankData:getWorshipStatus(type)
	for _,v in ipairs(self.worship_type_list) do
		if v == type then
			return 0
		end
	end
	
	return 1
end


function RankData:showWorshipTip()
	for i,v in ipairs(self.worship_list) do
		self:addWorshipTip(v.nick, v.type, v.text)
		self.worship_list[i] = nil
		break
	end
end

function RankData:addWorshipTip(name, type, text)
	local str_text = text or ex.Tools:getLang(71000 + type)
	ex.MessageView:add(string.format(ex.Tools:getLang(71000), name, str_text))
end

function RankData:checkRedDot()
	local isOpen = ex.JumpManager:checkOpenConditionByAtomNoMsg("main_rank")

	if isOpen ~= true then
		return
	end

	local rank_data_cur = {}
	rank_data_cur[15] = table.nums(self.rank_chapter_list) > 0 and true or nil
	rank_data_cur[4] = table.nums(self.rank_tower_list) > 0 and true or nil
	rank_data_cur[3] = table.nums(self.rank_clan_list) > 0 and true or nil
	rank_data_cur[2] = table.nums(self.rank_pvp_list) > 0 and true or nil
	rank_data_cur[1] = table.nums(self.rank_player_list) > 0 and true or nil

	local rank_data_cross = {}
	rank_data_cross[13] = table.nums(self.rank_cross_fighting_list) > 0 and true or nil
	rank_data_cross[14] = table.nums(self.rank_cross_clan_list) > 0 and true or nil

	-- 暂时只有4个排行榜。
	local is_cur_visible = false
	local is_cross_visible = false
	-- for i=1,4 do
	for i, v in pairs(rank_data_cur) do
		local is_worship = TableEx.isInTable(self.worship_type_list, i)
		if is_worship == nil then
			is_cur_visible = true
			break
		end
	end
	if cfg.opencondition.condition["main_rank_cross"].condition_value <= ex.Player.level then
		for i, v in pairs(rank_data_cross) do
			local is_worship = TableEx.isInTable(self.worship_type_list, i)
			if is_worship == nil then
				is_cross_visible = true
				break
			end
		end
	end

	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_PHB, is_cur_visible or is_cross_visible)
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_PHB_BF, is_cur_visible)
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_PHB_KF, is_cross_visible)
end

function RankData:checkLadderHeroTempleRedDot()
	local is_open = ex.JumpManager:checkOpenConditionByAtomNoMsg("main_ladder_war")

	local is_visible = false
	for k,v in pairs(self.rank_ladder_like_list) do
		if v.can_like then
			-- ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KFSK_TTZB_YXD, true )
			is_visible = true
			break
		end
	end

	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KFSK_TTZB_YXD, is_visible and is_open)
end

function RankData:onRefreshFloatingIslands()
	NetManager:sendMessage(ProtocolID.GReqFloatingIslandsRank)
end

return RankData



