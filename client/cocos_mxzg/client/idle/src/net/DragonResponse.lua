local DragonResponse = class("DragonResponse")

-- 查看圣龙数据
function DragonResponse:dragonInfo(data)
	ex.Player.dragon_data.dragon_room_level = data.identify_level
	ex.Player.dragon_data.dragon_level = data.attr_level
	ex.Player.dragon_data.privilege_end_time = data.privilege_end_time
	ex.Player.dragon_data.vec_dragon_rooms = data.identities

	ex.Player.dragon_data.vec_hallows = {}
	for i,v in ipairs(data.slots) do
		local tmp_data = {}
		tmp_data.pos = v.id
		tmp_data.item_type = v.sys_id
		table.insert(ex.Player.dragon_data.vec_hallows, tmp_data)
	end

	-- 更新界面
	ex.EventManager:fire(EVENT.DRAGON_EVENT.UPDATE_INFO)

	-- 更新红点显示
	ex.Player.dragon_data:checkReddot()
end

-- 放入源石(遗物)
function DragonResponse:dragonPutStone(data)
	for k,v in pairs(ex.Player.dragon_data.vec_dragon_rooms) do
		if v.type == data.identity.type then
			v.level = data.identity.level
			v.speed_add = data.identity.speed_add
			v.start_time = data.identity.start_time
		end
	end

	ex.EventManager:fire(EVENT.DRAGON_EVENT.IDENTIFY_START)

	-- 更新红点显示
	ex.Player.dragon_data:checkReddot()
end

-- 提升鉴定等级(龙界等级)
function DragonResponse:dragonUpgradeIdentity(data)
	ex.Player.dragon_data.dragon_room_level = data.identify_level
	for _,v in pairs(data.identities) do
		for _,v2 in pairs(ex.Player.dragon_data.vec_dragon_rooms) do
			if v.type == v2.type then
				v.start_time = v2.start_time
				v.level = v2.level
				v.speed_add = v2.speed_add

				break
			end
		end
	end

	NetManager:sendMessage(ProtocolID.GReqDragonScanInfo)
	
	-- 更新界面
	ex.EventManager:fire(EVENT.DRAGON_EVENT.UPDATE_INFO)
end

-- 加速鉴定
function DragonResponse:dragonSpeedUpIdentity(data)
	local speed_up_num = 0

	for k,v in pairs(ex.Player.dragon_data.vec_dragon_rooms) do
		if v.type == data.identity.type then
			speed_up_num = data.identity.speed_add - v.speed_add

			v.start_time = data.identity.start_time
			v.level = data.identity.level
			v.speed_add = data.identity.speed_add

			break
		end
	end

	-- 更新界面
	ex.EventManager:fire(EVENT.DRAGON_EVENT.IDENTIFY_SPEEDUP, speed_up_num)
end

-- 鉴定完成
function DragonResponse:dragonIdentityFinish(data)
	if #data.rewards <= 0 then
		return
	end

	for _,v in pairs(data.identities) do
		for _,v2 in pairs(ex.Player.dragon_data.vec_dragon_rooms) do
			if v2.type == v.type then
				v2.start_time = v.start_time
				v2.level = v.level
				v2.speed_add = v.speed_add

				break
			end
		end
	end

	-- 鉴定获得圣物走背包流程，无需处理

	-- 弹出鉴定结果界面
	require("src.layer.dragon.HallowsIdentifyResultCtr"):instance():openWindow(data.rewards[1])

	-- 更新界面
	ex.EventManager:fire(EVENT.DRAGON_EVENT.IDENTIFY_FINISH)

	-- 更新红点显示
	ex.Player.dragon_data:checkReddot()
end

-- 鉴定完成推送
function DragonResponse:dragonIdentityFinishNotice(data)
	NetManager:sendMessage(ProtocolID.GReqDragonIdentityFinish)
end

-- 提升圣龙等级
function DragonResponse:dragonUpgradeLevel(data)
	ex.Player.dragon_data.dragon_level = data.attr_level
	
	local is_have = false
	for i,v in ipairs(ex.Player.dragon_data.vec_hallows) do
		if v.pos == data.slot.id then
			is_have = true

			v.item_type = data.slot.sys_id
		end
	end

	if is_have == false then
		local tmp_data = {}
		tmp_data.pos = data.slot.id
		tmp_data.item_type = data.slot.sys_id
		table.insert(ex.Player.dragon_data.vec_hallows, tmp_data)
	end

    local config_level = cfg.dragonlevel.dragonlevel[ex.Player.dragon_data.dragon_level - 1]
	local config_level_next = cfg.dragonlevel.dragonlevel[ex.Player.dragon_data.dragon_level]
	
	if config_level_next.grade > config_level.grade then
		ex.MessageView:add(ex.Tools:getLang(74604))
	else
		ex.MessageView:add(ex.Tools:getLang(74603))
	end

	-- 更新界面
	ex.EventManager:fire(EVENT.DRAGON_EVENT.UPDATE_INFO)

	-- 更新红点显示
	ex.Player.dragon_data:checkReddot()
end

-- 圣物替换，放上或脱下
function DragonResponse:dragonChange(data)
	for i,v in ipairs(ex.Player.dragon_data.vec_hallows) do
		if v.pos == data.slot.id then
			v.item_type = data.slot.sys_id
		end
	end

	-- 更新界面
	ex.EventManager:fire(EVENT.DRAGON_EVENT.UPDATE_INFO)

	-- 更新红点显示
	ex.Player.dragon_data:checkReddot()
end

-- 调整圣物顺序
function DragonResponse:dragonChangeSort(data)
	ex.Player.dragon_data.vec_hallows = {}
	for i,v in ipairs(data.slots) do
		local tmp_data = {}
		tmp_data.pos = v.id
		tmp_data.item_type = v.sys_id
		table.insert(ex.Player.dragon_data.vec_hallows, tmp_data)
	end

	-- 更新界面
	ex.EventManager:fire(EVENT.DRAGON_EVENT.UPDATE_INFO)
	ex.EventManager:fire(EVENT.HERO_SELECT_EVENT.DRAGON_SKILL)

	-- 更新红点显示
	ex.Player.dragon_data:checkReddot()
end

-- 圣物图鉴
function DragonResponse:dragonCollection(data)
	ex.Player.dragon_data.vec_collection = {}
	for i,v in ipairs(data.sys_id) do
		table.insert(ex.Player.dragon_data.vec_collection, v)
	end

	ex.EventManager:fire(EVENT.DRAGON_EVENT.UPDATE_COLLECTION)
end

-- 圣物升星，圣物在背包中时
function DragonResponse:dragonUpStarInBag(data)

end

-- 圣物升星，圣物在槽位上时
function DragonResponse:dragonUpStarInSlot(data)
	for i,v in ipairs(ex.Player.dragon_data.vec_hallows) do
		if v.pos == data.slot.id then
			v.item_type = data.slot.sys_id
		end
	end

	local award_list = {{item_type = data.slot.sys_id, item_num = 1}}
	require("src.layer.ItemRewardCtr"):instance():openWindow(award_list)

	-- 更新界面
	ex.EventManager:fire(EVENT.DRAGON_EVENT.UPDATE_INFO)

	-- 更新红点显示
	ex.Player.dragon_data:checkReddot()
end

-- 圣物分解
function DragonResponse:dragonResolve(data)
	
end

return DragonResponse
