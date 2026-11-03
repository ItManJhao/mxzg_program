--[[
* @Description: 冥域魔都数据处理类
* @Author: 熊梦
* @Date: 2021-01-08 16:28:00
* ]]
local UnderworldPagodaData = class("UnderworldPagodaData")

local HadesType = {
    hades_type_1 = 1,   --赫卡忒地狱
    hades_type_2 = 2    --撒旦魔域
}

local HadesDegree = {
    simple = 1,         --简单
    difficulty = 2      --困难
}

function UnderworldPagodaData:ctor()
	self.hadesInfo_type_1 = {}		-- 赫卡忒地狱信息
	self.hadesInfo_type_2 = {}		-- 撒旦魔域信息

	self.hadesInfo_rank_list_1 = {} -- 赫卡忒地狱排行榜信息
	self.hadesInfo_rank_list_2 = {}	-- 撒旦魔域排行榜信息
end

-- 发送请求数据
function UnderworldPagodaData:gReqHadesInfo()
	-- 冥域魔都
	for i,v in pairs(HadesType) do
		local req = Hades_pb.GReqHadesInfo()
		req.type = v
		NetManager:sendMessage(ProtocolID.GReqHadesInfo,req)

		local req2 = Hades_pb.GResHadesRankList()
		req2.type = v
		NetManager:sendMessage(ProtocolID.GResHadesRankList, req2)
	end
end

-- 发送挑战请求
function UnderworldPagodaData:gReqHadesChallenge(type)
	local req = Hades_pb.GReqHadesChallenge()
	req.type = type
	NetManager:sendMessage(ProtocolID.GReqHadesChallenge, req)
end

-- 发送扫荡请求
function UnderworldPagodaData:gReqHadesSweep(type)
	local req = Hades_pb.GReqHadesSweep()
	req.type = type
	NetManager:sendMessage(ProtocolID.GReqHadesSweep, req)
end

-- 发送排行榜请求
function UnderworldPagodaData:gReqHadesRankList(type)
	local req = Hades_pb.GResHadesRankList()
	req.type = type
	NetManager:sendMessage(ProtocolID.GResHadesRankList, req)
end
-----------------------------------------------------------------------------------------------------------
-- 接收冥域魔都信息
function UnderworldPagodaData:setUnderworldPagodaInfo(data)
	self["hadesInfo_type_"..data.type] = data
	-- 接收到数据更新一下界面
	ex.EventManager:fire(EVENT.UNDERWORLDPAGODA.UPDATE_LAYER)
	self:checkReddot(data.type)
end

-- 接收挑战返回
function UnderworldPagodaData:getUnderworldPagodaChallenge(data)
	self["hadesInfo_type_"..data.type].pass_floor = data.pass_floor
	ex.EventManager:fire(EVENT.UNDERWORLDPAGODA.BATTLE_BOSS_BATTLE, data.report, ex.Tools:convertRewardList(data.pass_reward), data)
	-- 接收到数据更新一下界面
	ex.EventManager:fire(EVENT.UNDERWORLDPAGODA.UPDATE_LAYER)
	ex.EventManager:fire(EVENT.UNDERWORLDPAGODA.UPDATE_BOSS)
	self:checkReddot(data.type)
end

-- 接受扫荡返回 GResHadesSweep
function UnderworldPagodaData:getUnderworldPagodaSweep(data)
	self["hadesInfo_type_"..HadesType.hades_type_1].sweep_count = data.sweep_count
	self["hadesInfo_type_"..HadesType.hades_type_2].sweep_count = data.sweep_count
	-- 接收到数据更新一下界面
	ex.EventManager:fire(EVENT.UNDERWORLDPAGODA.UPDATE_LAYER)
	self:checkReddot(data.type)
end

-- 接受排行榜数据返回 GResHadesRankList
function UnderworldPagodaData:getUnderworldPagodaRankList(data)
	self["hadesInfo_rank_list_"..data.type] = data
	-- 刷新排行榜数据
	ex.EventManager:fire(EVENT.UNDERWORLDPAGODA.UPDATE_RANKLIST)
end

-- 红点检测
function UnderworldPagodaData:checkReddot(type)
	if type ==  HadesType.hades_type_1 then
		if ex.Player.level < cfg.system.underworld_pagoda_1_level then
			ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KFSK_MYMD_HKTDY_JD,false)
			ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KFSK_MYMD_HKTDY_JD,false)
			return
		end
	else
		if ex.Player.level < cfg.system.underworld_pagoda_2_level then
			ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KFSK_MYMD_SDMY_JD,false)
			ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KFSK_MYMD_SDMY_KN,false)
			return
		end
	end
	local reddot_type_1 = {
		--  主场景  导航-主城  跨服时空  冥域魔都  赫卡忒地狱  简单
		RedDotType.ZCJ_DHZC_KFSK_MYMD_HKTDY_JD,
		--  主场景  导航-主城  跨服时空  冥域魔都  赫卡忒地狱  困难
		RedDotType.ZCJ_DHZC_KFSK_MYMD_HKTDY_KN,
	}
	local reddot_type_2 = {
		--  主场景  导航-主城  跨服时空  冥域魔都  撒旦魔域  简单
		RedDotType.ZCJ_DHZC_KFSK_MYMD_SDMY_JD,
		--  主场景  导航-主城  跨服时空  冥域魔都  撒旦魔域  困难
		RedDotType.ZCJ_DHZC_KFSK_MYMD_SDMY_KN,
	}
	local reddot_type = {
		reddot_type_1,
		reddot_type_2
	}

	local max_tab = {}
	local type_1_conut = 0
    local type_2_conut = 0
    for i,v in ipairs(cfg.hadesfloor.hadesfloor) do
        if v.type == type then 
            if v.difficulty_lv == HadesDegree.simple then
                type_1_conut = type_1_conut + 1
            else
                type_2_conut = type_2_conut + 1
            end
        end
    end
    table.insert( max_tab, type_1_conut )  -- 简单的关卡数量
	table.insert( max_tab, type_2_conut )  -- 困难的关卡数量
	
	ex.RedDotManager:setRedNodeVisible(reddot_type[type][HadesDegree.simple],false)
	ex.RedDotManager:setRedNodeVisible(reddot_type[type][HadesDegree.difficulty],false)
	-- 检测是否可以挑战
	local data = self["hadesInfo_type_"..type]
	if data == nil or next(data) == nil then
        return
    end  
	if data.pass_floor >= max_tab[HadesDegree.simple] + max_tab[HadesDegree.difficulty] then
		return
	end
	local hades_degree = data.pass_floor >= max_tab[HadesDegree.simple] and HadesDegree.difficulty or HadesDegree.simple
	local floor = data.pass_floor >= max_tab[HadesDegree.simple] and data.pass_floor - max_tab[HadesDegree.simple] or data.pass_floor
	floor = floor == 0 and 1 or floor
	local battle_item = {}
	for k,j in ipairs(cfg.hadesfloor.hadesfloor) do
		if j.type == type and j.difficulty_lv == hades_degree and j.show_floor == floor then
			battle_item = j.cost
			break
		end	
	end

	if #battle_item ~= 0 then
		if ex.Player:getItemNum(battle_item[1].item_type) >= battle_item[1].item_num then
			ex.RedDotManager:setRedNodeVisible(reddot_type[type][hades_degree],true)
			return
		end
	end
	-- 检测是否可以扫荡 （花钻石的扫荡不检测 直接return）
	local free_visible = false
	if data.pass_floor >= 1 then
		for k,v in pairs(cfg.hadesbuycount.hadesbuycount) do
			if v.idx == data.sweep_count+1 and #v.cost == 2 then
				local cost_num = 0
				for j,k in ipairs(v.cost) do
					if ex.Player:getItemNum(k.item_type) >= k.item_num then
						cost_num = cost_num + 1
					end
				end
				free_visible = cost_num == #v.cost and true or false
				break
			end
		end
	end
	ex.RedDotManager:setRedNodeVisible(reddot_type[type][hades_degree],free_visible)
	return
end


return UnderworldPagodaData
