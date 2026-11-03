local BattleResponse = class("BattleResponse")


-- #TEST 这个只是用来测试战斗后端数据的
function BattleResponse:battleTest(data)
	local btReportData = {}
	generator_protobuf_raw_table(data.report, btReportData)

	ex.EventManager:fire(EVENT.BATTLE_EVENT.TEST_BATTLE, btReportData)
end

function BattleResponse:chapterStart(data)
	ex.Player.chapter_data.vec_battle_detail = data.report.log
	ex.EventManager:fire(EVENT.BATTLE_EVENT.BATTLE_START, data.report, ex.Tools:convertRewardList(data.items))
	
end

function BattleResponse:chapterEnd(data)
	ex.Player.chapter_data.chapter_id = data.idx

	local reward_list = {}
	for k,v in ipairs(data.list) do
		local item_data = {}
		item_data.item_type = v.type
		item_data.item_num = v.num
		item_data.item_id = v.id
		table.insert(reward_list, item_data)
	end


	ex.EventManager:fire(EVENT.BATTLE_EVENT.BATTLE_END, true, ex.Player.chapter_data.chapter_id)


	ex.Player.chapter_data:updateFirstRewardRedDot()

	ex.Player.chapter_data:updateMissionBattleRedDot()

	ex.Player.battle_data:checkQuickRedDot()

	-- 暂时这样,重新登录后。后端会补发上一次的主线战斗奖励。但是因为战报缺失。导致了报错。
	if ex.Player.chapter_data.vec_battle_detail ~= nil then
		require("src.layer.BattleEndCtr"):instance():openWindow(true, reward_list, function(is_win, idx)
		end, data.idx, ex.Player.chapter_data.vec_battle_detail)
	elseif require("src.layer.guide.GuideCtr").isExecutingGuide() == false then
		require("src.layer.ItemRewardCtr"):instance():openWindow(reward_list)
	end
	
	ex.Player.chapter_data:checkExtraRewardReddot()
end

--[[
	挂机战斗
]]
function BattleResponse:battleHang(data)
	local btHangData = {}
	generator_protobuf_raw_table(data, btHangData)

	ex.EventManager:fire(EVENT.BATTLE_EVENT.HANG_BATTLE, btHangData)
end

---------- 第二契约 ----------
function BattleResponse:unlock2Contract(data)
	require("src.layer.ShowContractImageCtr"):instance():openWindow()
	ex.EventManager:fire(EVENT.BATTLE_EVENT.UNLOCK_2_CONTRACT, data)
end

function BattleResponse:queryFormations(data)
	ex.EventManager:fire(EVENT.BATTLE_EVENT.QUERY_FORMATIONS, data)
end

function BattleResponse:unlockFormation(data)
	ex.EventManager:fire(EVENT.BATTLE_EVENT.UNLOCK_FORMATION, data)
end

function BattleResponse:chapterItemList(data)
	ex.Player.chapter_data.res_reward_time = data.reward_time
	ex.Player.chapter_data.max_reward_time = data.max_reward_time
	
	ex.EventManager:fire(EVENT.BATTLE_EVENT.UPDATEREWARD)
	ex.EventManager:fire(EVENT.MAIN_CITY.REFRESH_IDLE_REWARD_TIP)
end

function BattleResponse:chapterSetData(data)
	-- local res_reward_time = data.res_reward_time
	-- local now_idx = data.now_idx
	-- local max_idx = data.max_idx
	ex.Player.chapter_data.chapter_id = data.max_idx

	-- ex.Player.chapter_data:setNowIdx(max_idx)
	-- ex.Player.chapter_data:setMaxIdx(max_idx)
	-- if max_idx <= 0 then
		-- ex.Player.chapter_data:missionCompletion(0)
	-- end

	local main_ctr = ex.MainSceneCtr

	main_ctr:setGold(0, ex.Player.gold)
	main_ctr:setGem(0, ex.Player.gem)
	
	ex.Player.chapter_data:updateMissionBattleRedDot()

	ex.Player.chapter_data:resExtraReward(data.extra_reward_id)
	ex.Player.chapter_data:checkExtraRewardReddot()
end


function BattleResponse:chapterExtraReward(data)
	ex.Player.chapter_data:resExtraReward(data.reward_id)
	ex.EventManager:fire(EVENT.BATTLE_EVENT.EXTRA_REWARD)
	ex.Player.chapter_data:checkExtraRewardReddot()

	if table.nums(data.heroList) > 0 then
		local reward = {}
		for i,v in ipairs(data.heroList) do
			table.insert(reward, v.hero_type)
		end
		ex.Tools:openRewardPanel(reward, nil, 2)
	else
		require("src.layer.ItemRewardCtr"):instance():openWindow(ex.Tools:convertRewardList(data.list))
	end
end

function BattleResponse:chapterItemListReward(data)
	local reward_time = data.reward_time
end

function BattleResponse:battleLineup(data)
	ex.Player.lineup_data:resLineup(data.list, data.assistance_unlock)
end

function BattleResponse:chapterRewardList(data)
	ex.Player.chapter_data.vec_chapter_reward = data.list
	ex.Player.chapter_data:sortReward()
	ex.Player.chapter_data:updateFirstRewardRedDot()
end


function BattleResponse:quickBattleReward(data)
	ex.Player.battle_data:setBattleCount(data.battle_count)

	ex.EventManager:fire(EVENT.QUICK_BATTLE_EVENT.QUICK_BATTLE_REWARD)
	ex.Player.battle_data:checkQuickRedDot()
	ex.Player.promotion_data:reqSpeedFightList()

	require("src.layer.QuickBattleEndCtr"):instance():openWindow(data.list)
end


function BattleResponse:battleReport(data)
	print(data.type)
	ex.EventManager:fire(data.type, data.report, {}, data)
end


function BattleResponse:guideBattle(data)
	ex.EventManager:fire(EVENT.BATTLE_EVENT.GUIDE_BATTLE_CREATE, data)
end

function BattleResponse:preComputeStrength(data)
	ex.EventManager:fire(data.type, data.fighting)
end

function BattleResponse:quickBattleInitData(data)
	ex.Player.battle_data.is_promotion = data.promotion == 1 and true or false
	ex.Player.battle_data.is_privilege = data.privilege == 1 and true or false
	ex.Player.battle_data.max_battle_count = data.max_battle_count
	ex.Player.battle_data.quick_battle_count = data.battle_count

	ex.Player.battle_data:QuickNums()
	ex.Player.battle_data:checkQuickRedDot()
	ex.EventManager:fire(EVENT.QUICK_BATTLE_EVENT.QUICK_BATTLE_REWARD)
end

return BattleResponse
