local FetterResponse = class("FetterResponse")

function FetterResponse:fetterList(data)
	-- dump(data, "FetterResponse:fetterList")
	-- ex.Player.fetter_data.vec_fetter = {}
	-- print("FetterResponse:fetterList")
	-- dump(data)
	ex.Player.fetter_data.reset_count = data.reset_count

	for i,v in ipairs(data.goddess) do
		ex.Player.fetter_data.vec_fetter[v.type] = v
	end

	local all_unlock = ex.Player.fetter_data:isUnlockAll()
	-- dump(all_unlock)
	if all_unlock == true then 
		local data_res = {}
		data_res.atom = "sys_fetter"
		data_res.icon = "main-scene/spr-fetter.png"
		data_res.lbl = "main-scene-lang/lbl-fetter.png"
		data_res.layer_type = MainSceneType.FETTER_INFO
		ex.EventManager:fire(EVENT.MAIN_DX_EVENT.CHANGE_ICON, data_res)
		local cur_type = ex.MainSceneCtr:getCurLayerType()
		if cur_type == MainSceneType.FETTER_MAIN_VIEW then 
			ex.MainSceneCtr:changeLayer(MainSceneType.FETTER_INFO)
		end
	end
	
	ex.Player.fetter_data:checkReddot()

	--ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_YXBZ, ex.Player.fetter_data:checkFetterContractInfo())

end

function FetterResponse:fetterUplevel(data, byte_array)
	-- local data = NetManager:resLuaData(ProtocolResponse.ResFetterUplevel, byte_array)
	ex.Player.fetter_data:uplevelDone(data.idx, data.level, data.exp)

	NetManager:sendMessage(ProtocolID.GReqFetterList)
	ex.EventManager:fire(EVENT.HERO_EVENT.UPDATE_FETTER_RED)

end

function FetterResponse:fetterUpskill(data, byte_array)
	-- local data = NetManager:resLuaData(ProtocolResponse.ResFetterUpskill, byte_array)
	ex.Player.fetter_data:upskillDone(data.idx, data.level)
	NetManager:sendMessage(ProtocolID.GReqFetterList)
end

function FetterResponse:fetterRefine(data, byte_array)
	-- local data = NetManager:resLuaData(ProtocolResponse.ResFetterRefine, byte_array)
    -- dump(data, "FetterResponse:fetterRefine")
	ex.Player.fetter_data:refineDone(data.idx, data.level)
	NetManager:sendMessage(ProtocolID.GReqFetterList)
end

-- 羁绊洗炼
function FetterResponse:fetterBaptism(data, byte_array)
	ex.Player.fetter_data:baptismDone(data.idx, data.wash_level)
	NetManager:sendMessage(ProtocolID.GReqFetterList)
end


function FetterResponse:fetterUplimit(data, byte_array)
	-- local data = NetManager:resLuaData(ProtocolResponse.ResFetterUplimit, byte_array)
	-- dump(data, "FetterResponse:fetterUplimit")
	ex.Player.fetter_data:uplimitDone(data.idx, data.level)
	NetManager:sendMessage(ProtocolID.GReqFetterList)
end

function FetterResponse:fetterInitTask(data,byte_array)
	-- print("FetterResponse:fetterInitTask")
	-- dump_pbmsg(data)
	-- local data = NetManager:resLuaData(ProtocolResponse.ResFetterInitTask, byte_array)
	ex.Player.fetter_data.vip:initServerData(data)

	local isRed = ex.Player.fetter_data.vip:checkRedPoint()
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHJB,isRed)
end

function FetterResponse:fetterUpProgress(data,byte_array)
	-- print("FetterResponse:fetterUpProgress")
	-- dump_pbmsg(data)
	-- local data = NetManager:resLuaData(ProtocolResponse.ResFetterUpProgress, byte_array)
	for k,v in ipairs(data.progress_list) do
		ex.Player.fetter_data.vip:setProgress(v.idx,v.num)
	end
	local isRed = ex.Player.fetter_data.vip:checkRedPoint()
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHJB,isRed)
	ex.EventManager:fire(EVENT.FETTER_EVENT.UPDATE_PROGRESS)
end

function FetterResponse:fetterRewardResult(data,byte_array)
	-- print("FetterResponse:fetterRewardResult")
	-- dump_pbmsg(data)
	-- local data = NetManager:resLuaData(ProtocolResponse.ResFetterRewardResult, byte_array)
	ex.Player.fetter_data.vip:setStatus(data.fetterStatus.idx,data.fetterStatus.status)
	local isRed = ex.Player.fetter_data.vip:checkRedPoint()
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHJB,isRed)
	ex.EventManager:fire(EVENT.FETTER_EVENT.VIP_REWARD)
end

function FetterResponse:fetterInitVIP(data,byte_array)
	-- print("FetterResponse:fetterInitVIP")
	-- dump_pbmsg(data)
	-- local data = NetManager:resLuaData(ProtocolResponse.ResFetterInitVip, byte_array)
	-- print(self.__cname,"fetterInitVIP")
	ex.Player.fetter_data.vip:setVIP(data.vip_level)

	local isRed = ex.Player.fetter_data.vip:checkRedPoint()
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHJB, isRed)

	-- 记录vip等级
	local save_key = string.format("%s-fetter_vip_level", ex.Player.role_id)
	if cc.UserDefault:getInstance():getIntegerForKey(save_key, 0) == 0 and data.vip_level >= 1 then
		require("src.platform.SocialPlatform"):submitRoleInfoLua("vip_uplevel")
		cc.UserDefault:getInstance():setIntegerForKey(save_key, 1)
	end

end

function FetterResponse:fetterUpdateVIP(data,byte_array)
	-- print("FetterResponse:fetterUpdateVIP")
	-- dump_pbmsg(data)
	-- local data = NetManager:resLuaData(ProtocolResponse.ResFetterUpdateVip, byte_array)
	-- print(self.__cname,"fetterUpdateVIP")
	ex.Player.fetter_data.vip:setVIP(data.vip_level)
	ex.EventManager:fire(EVENT.FETTER_EVENT.VIP_UPDATE)

	local isRed = ex.Player.fetter_data.vip:checkRedPoint()
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHJB,isRed)

		-- 记录vip等级
		local save_key = string.format("%s-fetter_vip_level", ex.Player.role_id)
		if cc.UserDefault:getInstance():getIntegerForKey(save_key, 0) == 0 and data.vip_level >= 1 then
			require("src.platform.SocialPlatform"):submitRoleInfoLua("vip_uplevel")
			cc.UserDefault:getInstance():setIntegerForKey(save_key, 1)
		end
end

function FetterResponse:activeFetter( data,byte_array )
	-- print("FetterResponse:activeFetter")
	-- dump_pbmsg(data)
	-- body
	-- local data = NetManager:resLuaData(ProtocolResponse.ResActiveFetter, byte_array)
	-- require("src.layer.fetters.ActiveFetterCtr"):instance():openWindow(data.vip_level)
	require("src.layer.fetters.ActiveFetterCtr"):instance():openWindow(data.model)
	
	-- 刷新羁绊数据
	-- local req_fetter_list= ProtocolRequest.ReqFetterList
	-- NetManager:sendLuaData(req_fetter_list)
	NetManager:sendMessage(ProtocolID.GReqFetterList)
end

function FetterResponse:fetterReset(data, byte_array)
	print("FetterResponse:fetterReset")
	-- dump_pbmsg(data)
	local fetter_data = ex.Player.fetter_data:getFetterData(data.idx)
	if not fetter_data then
		return
	end

	if data.status == 0 then
		-- print("ex.Player.fetter_data.reset_count = data.reset_count", ex.Player.fetter_data.reset_count, data.reset_count)
		ex.Player.fetter_data.reset_count = data.reset_count

		fetter_data.level = 1
		fetter_data.exp = 0
		fetter_data.refine_level = 0 
		fetter_data.skill_level = 1
		fetter_data.uplimit_level = 0

		-- 更新界面
		ex.EventManager:fire(EVENT.FETTER_EVENT.UPLIMIT)
		ex.EventManager:fire(EVENT.FETTER_EVENT.INFO)
		ex.EventManager:fire(EVENT.FETTER_EVENT.SKIN)
		ex.EventManager:fire(EVENT.FETTER_EVENT.REFINE)
	else
		ex.Tools:showDebugStatus(data.status)
	end

	NetManager:sendMessage(ProtocolID.GReqFetterList)
end

function FetterResponse:fetterMakeSoul(data)
	local fetter_data = ex.Player.fetter_data:getFetterData(data.idx)
	if not fetter_data then
		return
	end
	fetter_data.soul_level = data.soul_count

	local has, need, soul_level, level_max = ex.Player.fetter_data:getSoulData(fetter_data.type)

	ex.EventManager:fire(EVENT.FETTER_EVENT.SOUL_UPDATE, has, need)
	ex.EventManager:fire(EVENT.FETTER_EVENT.SOUL_UPDATE_LEVEL, fetter_data.type, soul_level, level_max)
	ex.EventManager:fire(EVENT.FETTER_EVENT.INFO)

	NetManager:sendMessage(ProtocolID.GReqFetterList)
end


function FetterResponse:fetterContractInfo(data)
	local new_data = {}
	for i,v in ipairs(data.contracts) do
		table.insert( new_data, v )
	end
	ex.Player.fetter_data:setFetterContractInfo(new_data)
end 


function FetterResponse:fetterContractActive(data)
	ex.Player.fetter_data:changeFetterContractInfo(data.type)

	require("src.layer.ContractSummonCtr"):instance():closeWindow()

	require("src.layer.ShowContractImageCtr"):instance():openWindow()
	

	require("src.layer.HeroSelectCtr"):instance():refreshFetterRed()

	ex.EventManager:fire(EVENT.HERO_EVENT.UPDATE_FETTER_RED)
	
end 

----------------------------羁绊幻化-----------------------------------
-- 羁绊幻化数据
function FetterResponse:fetterIllusionData(data)
	ex.Player.fetter_data:setFetterIllusionData(data)
end

-- 初始化羁绊幻化总任务数据
function FetterResponse:fetterIllusionTaskData(data)
	ex.Player.fetter_data:setFetterIllusionTaskData(data)
end

-- 更新羁绊单个任务数据
function FetterResponse:fetterIllusionUpdataTaskData(data)
	ex.Player.fetter_data:UpdataFetterIllusionTaskData(data)
end

-- 领取奖励后任务返回 因为服务器懒得统一 所有多写一遍
function FetterResponse:fetterIllusionUpdataTaskDataTemp(data)
	ex.Player.fetter_data:UpdataFetterIllusionTaskDataTemp(data)
end

-- 更新羁绊灵力数目
function FetterResponse:fetterIllusionUpdataItemNum(data)
	ex.Player.fetter_data:checkIllusionReddot()
	ex.EventManager:fire(EVENT.FETTER_EVENT.ILLUSION_UPDATE_ITEM)
end

-- 皮肤激活
function FetterResponse:fetterIllusionActivation(data)
	ex.Player.fetter_data:setFetterIllusionskinActivation(data)
end

-- 皮肤穿戴
function FetterResponse:fetterIllusionWear(data)
	ex.Player.fetter_data:UpdataFetterIllusionWear(data)
end

---------------------------------------------------------------
return FetterResponse
