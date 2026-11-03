local FloatingIslandsResponse = class("FloatingIslandsResponse")

function FloatingIslandsResponse:floatingIslandsTime(data)
	-- dump(ctr.floating_islands.data, "floatingIslandsTime")
	-- ctr.floating_islands.data.start_time = data.start_time
	-- ctr.floating_islands.data.end_time = data.end_time
	ctr.floating_islands.data.stage = data.stage
	ctr.floating_islands.data.next_time = data.next_time
	
	-- NetManager:sendMessage(ProtocolID.GReqFloatingIslandsData)
	ex.EventManager:fire(EVENT.FLOATING_ISLANDS.UPDATE_TIME)
	ctr.floating_islands:startTimer()
	ctr.floating_islands.data:checkReddot()

	-- 功能已开放
	if ctr.floating_islands.data.stage > 1 then
		NetManager:sendMessage(ProtocolID.GReqFloatingIslandsData)
	end
end

function FloatingIslandsResponse:floatingIslandsData(data)
	ctr.floating_islands.data.self_max_dmg = data.self_max_dmg
	ctr.floating_islands.data.total_dmg = data.total_dmg
	ctr.floating_islands.data.challenge_count = data.challenge_count
	ctr.floating_islands.data.can_buy_count = data.can_buy_count
	ctr.floating_islands.data:checkReddot()

	ex.EventManager:fire(EVENT.FLOATING_ISLANDS.UPDATE_LAYER)
end

function FloatingIslandsResponse:floatingIslandsChallenge(data)
	ctr.floating_islands:startBattle()
	ex.EventManager:fire(EVENT.FLOATING_ISLANDS.BATTLE_BOSS_BATTLE, data.report, ex.Tools:convertRewardList(data.challenge_reward), data)
	
	NetManager:sendMessage(ProtocolID.GReqFloatingIslandsData)
end

function FloatingIslandsResponse:floatingIslandsBuyCount(data)
	ctr.floating_islands.data.challenge_count = data.challenge_count
	ctr.floating_islands.data.can_buy_count = data.can_buy_count
	ctr.floating_islands.data:checkReddot()
	ex.EventManager:fire(EVENT.FLOATING_ISLANDS.UPDATE_LAYER)
end

return FloatingIslandsResponse