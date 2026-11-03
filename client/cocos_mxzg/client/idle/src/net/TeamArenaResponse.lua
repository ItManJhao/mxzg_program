local TeamArenaResponse = class("TeamArenaResponse")

function TeamArenaResponse:handleTeam(data)
	ex.EventManager:fire(EVENT.TEAM_ARENA.MY_TEAM_REFRESH, data)
end


function TeamArenaResponse:teamArenaBattle(data)

    ex.EventManager:fire(EVENT.TEAM_AEENA_INFO_EVENT.START_BATTLE, data.report)
	ex.Player.team_arena_data:saveTeamArenaBattleData(data)
end 


function TeamArenaResponse:teamArenaBattleReport(data)

	ex.EventManager:fire(EVENT.TEAM_AEENA_INFO_EVENT.START_BATTLE, data.report)
	ex.Player.team_arena_data:saveOrderTeamArenaBattleData(data)
end 

function TeamArenaResponse:teamArenaBattleRecord(data)

	require("src.layer.teamarena.TeamArenaBattleLogCtr"):instance():showList(data.record)
end 

function TeamArenaResponse:teamArenaBattleRecordDetail(data)

	require("src.layer.teamarena.TeamArenaVideoCtr"):instance():showList(data.detail)
end 


function TeamArenaResponse:teamArenaData(data)

	ex.Player.team_arena_data:saveTeamArenaData(data)
	ex.EventManager:fire(EVENT.TEAM_AEENA_INFO_EVENT.UPDATE_TEAM_ARENA_DATA)

end 



function TeamArenaResponse:teamArenaRefreshDefend(data)
	require("src.layer.teamarena.TeamArenaBattleCtr"):instance():showTeamList(data.defend)

end 


function TeamArenaResponse:teamArenaState(data)

	ex.Player.team_arena_data:saveTeamArenaState(data)
	ex.EventManager:fire(EVENT.TEAM_AEENA_INFO_EVENT.UPDATE_TIME_DATE)

end

function TeamArenaResponse:teamArenaRank(data)

	ex.Player.team_arena_data:saveTeamArenaRank(data)
	ex.EventManager:fire(EVENT.TEAM_AEENA_INFO_EVENT.UPDATE_RANK_LIST_DATE)

end

function TeamArenaResponse:handleTeamSearch(data)
	ex.EventManager:fire(EVENT.TEAM_ARENA.TEAM_MAIN_TEAM_SREACH, data)
end

function TeamArenaResponse:handleTeamRecommend(data)
	ex.EventManager:fire(EVENT.TEAM_ARENA.TEAM_MAIN_TEAM_DEFAULT, data)
end

function TeamArenaResponse:handleTeamApply(data)
	ex.EventManager:fire(EVENT.TEAM_ARENA.TEAM_MAIN_TEAM_REQUEST, data)
end

function TeamArenaResponse:handleTeamCreate(data)
	ex.EventManager:fire(EVENT.TEAM_ARENA.TEAM_MAIN_TEAM_CREATE, data)
end

function TeamArenaResponse:handleTeamReset(data)
	dump(data, "TeamArenaResponse:handleTeamReset----------", 10)
	ex.EventManager:fire(EVENT.TEAM_ARENA.TEAM_MAIN_TEAM_CONDITION, data)
end

function TeamArenaResponse:handleTeamArenaChangeCaptain(data)
	ex.EventManager:fire(EVENT.TEAM_ARENA.TEAM_MAIN_TEAM_CAPTAIN, data)
end

function TeamArenaResponse:handleTeamKickOut(data)
	ex.EventManager:fire(EVENT.TEAM_ARENA.TEAM_MAIN_TEAM_KICKOUT, data)
end

function TeamArenaResponse:handleTeamExit(data)
	ex.EventManager:fire(EVENT.TEAM_ARENA.TEAM_MAIN_TEAM_EXIT)
end

function TeamArenaResponse:handleTeamArenaSign(data)
	ex.EventManager:fire(EVENT.TEAM_ARENA.TEAM_MAIN_TEAM_SIGN, data)
	
	NetManager:sendMessage(ProtocolID.GReqTeamArenaState)
end

function TeamArenaResponse:handleTeamHandleApple(data)
	ex.EventManager:fire(EVENT.TEAM_ARENA.TEAM_ADD_REQ_HANDLE, data)
end

function TeamArenaResponse:handleTeamApplyList(data)
	ex.EventManager:fire(EVENT.TEAM_ARENA.TEAM_ADD_REQ_LIST, data)
end

function TeamArenaResponse:handleTeamArenaRecommendRole(data)
	ex.EventManager:fire(EVENT.TEAM_ARENA.TEAM_ADD_INVITE_LIST, data)
end

function TeamArenaResponse:handleTeamArenaSearchRole(data)
	ex.EventManager:fire(EVENT.TEAM_ARENA.TEAM_ADD_INVITE_SREACH, data)
end

function TeamArenaResponse:handleTeamInvite(data)
	ex.EventManager:fire(EVENT.TEAM_ARENA.TEAM_ADD_INVITE, data)
end

function TeamArenaResponse:handleTeamHandleInvite(data)
	ex.EventManager:fire(EVENT.TEAM_ARENA.TEAM_MAIN_TEAM_JOIN, data)
end

function TeamArenaResponse:handleTeamInviteList(data)
	ex.EventManager:fire(EVENT.TEAM_ARENA.TEAM_MAIN_TEAM_INVITE, data)
end

function TeamArenaResponse:handleTeamArenaBeKickOut(data)
	ex.MessageView:add(ex.Tools:getLang(74320))
end

function TeamArenaResponse:handleTeamArenaLineUp(data)
	ex.EventManager:fire(EVENT.TEAM_ARENA.TEAM_MAIN_TEAM_LINEUP, data)

	ex.MessageView:add(ex.Tools:getLang(74106))
end

function TeamArenaResponse:handleTeamArenaRedState(data)
	-- 先取消再加上
	
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KFSK_ZDJJC_ZDDT_SDYQ, false)
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KFSK_ZDJJC_ZDDT_WDDW_TJWJ_RDSQ, false)

	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KFSK_ZDJJC_LQJL, false)
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KFSK_ZDJJC_ZDDT_KSTZ, false)

	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KFSK_ZDJJC_TZ, false)

	for i,v in ipairs(data.red_list) do

		ex.RedDotManager:setRedNodeVisible(tonumber(v), true)
	end
end

return TeamArenaResponse
