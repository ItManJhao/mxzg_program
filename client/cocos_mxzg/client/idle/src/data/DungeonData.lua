local DungeonData = class("DungeonData")


-- 上一次布阵的时间. 每天只能布阵一次
DungeonData.pre_lineup_time = 0

-- 当前所在层及当前层网格砖块类型
DungeonData.cur_stage = 1
DungeonData.cur_grid_type = 1
DungeonData.start_time = 1
DungeonData.end_time = 1

function DungeonData:ctor()
	self.cur_stage = 1
	self.cur_grid_type = 1
	self.start_time = 0
	self.end_time = 0

	self.lineup_hero_list = {}	-- 当前战斗队列英雄队列 {index, hero_id, hero_type, level, star, elem, hero_rate, hero_bat}

	self.monster_hp_list = {}	-- 当前层怪物血量列表 {monster_level, monster_rate}

	-- grid_event_type 	网格打开后的事件类型，-1：怪物；0：无事件；101：金币堆；102：石堆；103：免费宝箱；104：钥匙；105：钥匙宝箱；106：buff；107：药水；108：商店；109：商店增加道具
	-- grid_event_num	商店id、怪物level、钥匙宝箱类型
	self.grid_list = {}		-- 当前层网格列表 {grid_x, grid_y, is_open, grid_event_type, grid_event_num}
	self.props_list = {}	-- 道具列表 {item_type, item_num}
	self.buff_list = {}  	-- 102、201、202、207、270、291 {item_type, item_num}

	self.kill_reward_list = {}	-- 当前击杀奖励领取队列 {index, is_reward}
	self.monster_kill_num = 0	-- 当前击杀怪物数

	self.shop_list = {} 	-- 商店列表 {index, item_type, item_num, cost_type, cost_num, shop_id}

	self.battle_attack_cur_select_index = -1

	-- 添加buff名字枚举
	self.buff_name_list = {}
	self.buff_name_list[102] = ex.Tools:getLang(47323)
	self.buff_name_list[201] = ex.Tools:getLang(47128)
	self.buff_name_list[202] = ex.Tools:getLang(47686)
	self.buff_name_list[207] = ex.Tools:getLang(47519)
	self.buff_name_list[270] = ex.Tools:getLang(47394)
	self.buff_name_list[291] = ex.Tools:getLang(47709)
end

-- 获取当前层的对应怪物配置数据
function DungeonData:getMonsterByStageAndLevel(stage, level)
	-- print("getMonsterByStageAndLevel: ", stage, level)
	for i,v in ipairs(cfg.shelterlevel.shelterlevel) do
		-- print("cfg.shelterlevel.shelterlevel: ", v.stage, stage, v.icon_level, level)
		if v.shelter_stage == tonumber(stage) and v.icon_level == tonumber(level) then
			return v
		end
	end

	return nil
end

function DungeonData:getMonsterCurHp(level)
	for i,v in ipairs(self.monster_hp_list) do
		if v.monster_level == tonumber(level) then
			return v.hp_rate
		end
	end

	return 0
end

-- 获取怪物状态，0：未死；-1：死亡；1：boss怪物周围还有怪物镇守
function DungeonData:getMonsterStatus(monster_level)
	for i,v in ipairs(self.grid_list) do
		if v.grid_event_type < 0 and tonumber(v.grid_event_num) == monster_level then
			-- for i, v2 in ipairs(self.monster_hp_list) do
			-- 	if v.grid_event_num == v2.monster_level then
					-- if v2.monster_left_hp <= 0 then
					-- 	return -1
					-- elseif monster_level ~= 5 then
					if monster_level ~= 5 then
						return 0
					else
						for i,v2 in ipairs(self.grid_list) do
							if v2.grid_event_type < 0 and tonumber(v2.grid_event_num) ~= 5 then
								return 1
							end
						end
						return 0
					end
					-- break
			-- 	end
			-- end
			break
		end
	end
	return -1
end

function DungeonData:getMonsterKillTotalNum()
	-- local monster_num = 0
	-- for i,v in ipairs(self.grid_list) do
	-- 	if v.grid_event_type < 0 then
	-- 		monster_num = monster_num + 1
	-- 	end
	-- end

	-- local kill_num = self.cur_stage * 5 - monster_num

	-- return kill_num

	return self.monster_kill_num
end

function DungeonData:getTeamHeroHpDataByIndex(index)
	for i,v in ipairs(self.lineup_hero_list) do
		if v.index == index then
			return v
		end
	end
	return nil
end

function DungeonData:getTeamHeroInfoDataById(hero_id)
	for i,v in ipairs(self.lineup_hero_list) do
		if v.hero_id == hero_id then
			return v
		end
	end
	return nil
end

-- 初始化英雄队列
function DungeonData:initTeam(vec_hero)
	if vec_hero == nil or table.nums(vec_hero) <= 0 then
		return
	end

	if self.lineup_hero_list ~= nil and #self.lineup_hero_list > 0 then
		return
	end

	local req_init_team = Dungeon_pb.GReqDungeonInitTeam()
	
	for i,v in ipairs(vec_hero) do
		if i > 6 then
			break
		end

		local team_data = req_init_team.list:add()
		team_data.index = i
		team_data.hero_id = v
	end

	NetManager:sendMessage(ProtocolID.GReqDungeonInitTeam, req_init_team)
end

-- 打开网格
function DungeonData:gridLight(grid_list)
	local is_shop = false

	local vec_grid = {}
	for i,v in ipairs(grid_list) do
		for i2,v2 in pairs(self.grid_list) do
			if (v2.grid_x == v.grid_x and v2.grid_y == v.grid_y and v2.is_open <= 0) then
				local is_around_monster = false
				for i3,v3 in pairs(self.grid_list) do
					if math.abs(v3.grid_x - v2.grid_x) <= 1 and math.abs(v3.grid_y - v2.grid_y) <= 1 and 
						v3.grid_event_type < 0 and tonumber(v3.grid_event_num) ~= 5 then
						is_around_monster = true
						break
					end
				end

				if is_around_monster == false then
					local grid_tmp = {}
					grid_tmp.grid_x = v.grid_x
					grid_tmp.grid_y = v.grid_y
					table.insert(vec_grid, grid_tmp)

					if v2.grid_event_type == 108 then
						is_shop = true
					end
				end

				break
			end
		end
	end

	if table.nums(vec_grid) <= 0 then
		return false
	end

	local req_grid_light = Dungeon_pb.GReqDungeonGridLight()
	for i,v in ipairs(vec_grid) do
		local grid_tmp = req_grid_light.list:add()
		grid_tmp.grid_x = v.grid_x
		grid_tmp.grid_y = v.grid_y
	end
	NetManager:sendMessage(ProtocolID.GReqDungeonGridLight, req_grid_light)
	 
	if is_shop == true then
		NetManager:sendMessage(ProtocolID.GReqDungeonShopList)
	end

 	return true
end

-- 事件激活
function DungeonData:clickEvent(grid_x, grid_y)
	-- 101：金币堆；102：石堆；103：免费宝箱；104：钥匙；105：钥匙宝箱；106：buff；107：药水；108：商店；109：商店增加道具
	local event_type = 0
	local is_need_refresh = false
	for i,v in ipairs(self.grid_list) do
		if v.grid_x == grid_x and v.grid_y == grid_y and v.is_open > 0 then
			if v.grid_event_type == DUNGEON_EVENT_TYPE.GOLD then
				-- 获得金币
				is_need_refresh = true
				event_type = v.grid_event_type

				local req_get_res = Dungeon_pb.GReqDungeonGetRes()
				req_get_res.grid_x = grid_x
				req_get_res.grid_y = grid_y
				NetManager:sendMessage(ProtocolID.GReqDungeonGetRes, req_get_res)
			elseif v.grid_event_type == DUNGEON_EVENT_TYPE.STONE then
				-- 获得羁绊之力
				is_need_refresh = true
				event_type = v.grid_event_type

				local req_get_res = Dungeon_pb.GReqDungeonGetRes()
				req_get_res.grid_x = grid_x
				req_get_res.grid_y = grid_y
				NetManager:sendMessage(ProtocolID.GReqDungeonGetRes, req_get_res)
			elseif v.grid_event_type == DUNGEON_EVENT_TYPE.FREE_BOX_1 or 
					v.grid_event_type == DUNGEON_EVENT_TYPE.FREE_BOX_2 or 
					v.grid_event_type == DUNGEON_EVENT_TYPE.FREE_BOX_3 or 
					v.grid_event_type == DUNGEON_EVENT_TYPE.FREE_BOX_4 or 
					v.grid_event_type == DUNGEON_EVENT_TYPE.FREE_BOX_5 or 
					v.grid_event_type == DUNGEON_EVENT_TYPE.FREE_BOX_6 then
				-- 打开免费宝箱
				local req_open_box = Dungeon_pb.GReqDungeonOpenBox()
				req_open_box.grid_x = grid_x
				req_open_box.grid_y = grid_y
				NetManager:sendMessage(ProtocolID.GReqDungeonOpenBox, req_open_box)

				event_type = v.grid_event_type
			elseif v.grid_event_type == DUNGEON_EVENT_TYPE.KEY then
				-- 获得宝箱钥匙
				is_need_refresh = true
				event_type = v.grid_event_type

				local req_get_res = Dungeon_pb.GReqDungeonGetRes()
				req_get_res.grid_x = grid_x
				req_get_res.grid_y = grid_y
				NetManager:sendMessage(ProtocolID.GReqDungeonGetRes, req_get_res)
			elseif v.grid_event_type == DUNGEON_EVENT_TYPE.KEY_BOX then
				-- 打开钥匙宝箱
				-- 是否有钥匙
				for i,v in ipairs(self.props_list) do
					if v.item_type == 901601 and v.item_num > 0 then
						local req_open_box = Dungeon_pb.GReqDungeonOpenBox()
						req_open_box.grid_x = grid_x
						req_open_box.grid_y = grid_y
						NetManager:sendMessage(ProtocolID.GReqDungeonOpenBox, req_open_box)
					end
				end

				event_type = v.grid_event_type
			elseif v.grid_event_type == DUNGEON_EVENT_TYPE.BUFF then
				-- 获取buff
				is_need_refresh = true
				event_type = v.grid_event_type

				local req_get_res = Dungeon_pb.GReqDungeonGetRes()
				req_get_res.grid_x = grid_x
				req_get_res.grid_y = grid_y
				NetManager:sendMessage(ProtocolID.GReqDungeonGetRes, req_get_res)
			elseif v.grid_event_type == DUNGEON_EVENT_TYPE.POTION_1 or
					v.grid_event_type == DUNGEON_EVENT_TYPE.POTION_2 then
				-- 获取药水
				is_need_refresh = true
				event_type = v.grid_event_type

				local req_get_res = Dungeon_pb.GReqDungeonGetRes()
				req_get_res.grid_x = grid_x
				req_get_res.grid_y = grid_y
				NetManager:sendMessage(ProtocolID.GReqDungeonGetRes, req_get_res)
			elseif v.grid_event_type == DUNGEON_EVENT_TYPE.SHOP_ADD then
				-- 获取商店增加道具
				is_need_refresh = true
				event_type = v.grid_event_type

				local req_get_res = Dungeon_pb.GReqDungeonGetRes()
				req_get_res.grid_x = grid_x
				req_get_res.grid_y = grid_y
				NetManager:sendMessage(ProtocolID.GReqDungeonGetRes, req_get_res)
			elseif v.grid_event_type == DUNGEON_EVENT_TYPE.SHOP then
				event_type = v.grid_event_type
			end

			break
		end
	end

	-- if is_need_refresh == true then
	-- 	v.grid_event_type = 0

	-- 	-- 刷新界面

	-- end

	return event_type,is_need_refresh
end

function DungeonData:getResDone(res_data)
	if res_data == nil then
		return 
	end

	for i,v in ipairs(self.grid_list) do
		if v.grid_x == res_data.grid_x and v.grid_y == res_data.grid_y and v.is_open > 0 then
			v.grid_event_type = 0
		end
	end
	local vec_buff_format = {}
	vec_buff_format[102] = ex.Tools:getLang(47323)
	vec_buff_format[201] = ex.Tools:getLang(47128)
	vec_buff_format[202] = ex.Tools:getLang(47686)
	vec_buff_format[207] = ex.Tools:getLang(47519)
	vec_buff_format[270] = ex.Tools:getLang(47394)
	vec_buff_format[291] = ex.Tools:getLang(47709)

	-- 非道具物品，需要作出对应提示
	if res_data.event_type == DUNGEON_EVENT_TYPE.BUFF then
		ex.MessageView:add(string.format(ex.Tools:getLang(47248), "dungeon/buff-"..res_data.item_type..".png", vec_buff_format[res_data.item_type], res_data.item_num / 100))
	elseif res_data.event_type == DUNGEON_EVENT_TYPE.POTION_1 or 
			res_data.event_type == DUNGEON_EVENT_TYPE.POTION_2 then
		ex.Tools:addBackpackMsg(res_data.item_type, res_data.item_num)
	elseif res_data.event_type == DUNGEON_EVENT_TYPE.KEY then
		ex.Tools:addBackpackMsg(res_data.item_type, res_data.item_num)
	elseif res_data.event_type == DUNGEON_EVENT_TYPE.SHOP_ADD then
		ex.Tools:addBackpackMsg(res_data.item_type, res_data.item_num)
	end

	-- 刷新界面
	ex.EventManager:fire(EVENT.DUNGEON_EVENT.GRID_EVENT)
end

function DungeonData:openBoxDone(res_data)
	if res_data == nil then
		return 
	end

	for i,v in ipairs(self.grid_list) do
		if v.grid_x == res_data.grid_x and v.grid_y == res_data.grid_y and v.is_open > 0 then
			v.grid_event_type = 0
		end
	end

	-- 刷新界面
	ex.EventManager:fire(EVENT.DUNGEON_EVENT.GRID_EVENT)
end

function DungeonData:canKillReward(index)
	-- 是否可以领取
	for i,v in ipairs(self.kill_reward_list) do
		if v.index == index then
			if v.reward > 0 then
				return 1
			end
			break
		end
	end

 	local config = cfg.shelterkillreward.shelterkillreward[index]
 	if config == nil then
 		return 2
 	end

	-- 击杀数是否达到
	local kill_num = self:getMonsterKillTotalNum()
	if config.win_times > kill_num then
		return 3
	end

	return 0
end

-- 是否有任意一个奖励可以领取
function DungeonData:IsAnyKillReward()
	for i,v in pairs(cfg.shelterkillreward.shelterkillreward) do
		local result = self:canKillReward(v.idx)
		if result == 0 then
			return true
		end
	end

	return false
end




-- 击杀奖励领取
function DungeonData:killReward(index)
	-- 是否可以领取
	local flag = self:canKillReward(index)
	if flag > 0 then
		return
	end

 	local config = cfg.shelterkillreward.shelterkillreward[index]
 	if config == nil then
 		return
	end

	local req_reward = Dungeon_pb.GReqDungeonKillReward()
	req_reward.reward_index = index
	NetManager:sendMessage(ProtocolID.GReqDungeonKillReward, req_reward)
end

-- 击杀奖励领取
function DungeonData:killRewardDone(index)
 	local config = cfg.shelterkillreward.shelterkillreward[index]
 	if config == nil then
 		return
	end

	local is_have = false
	for i,v in ipairs(self.kill_reward_list) do
		if v.index == index then
			v.reward = 1
			is_have = true
			break
		end
	end

	if is_have == false then
		local reward_data = {}
		reward_data.index = index
		reward_data.is_reward = true
		table.insert(self.kill_reward_list, reward_data)
	end
	-- dump(self.kill_reward_list, "DungeonData:killReward")

	local reward_ctr = require("src.layer.DungeonKillRewardCtr"):instance()
	if reward_ctr:getLayer() ~= nil then
		reward_ctr:updateLayer()
	end
end

-- 进入下一层
function DungeonData:nextStage()
	-- 如果boss未击杀，则无法进入下一层
	-- 击杀数是否达到
	local monster_num = 0
	local event_num = 0
	for i,v in ipairs(self.grid_list) do
		if v.grid_event_type < 0 then
			monster_num = monster_num + 1
		end
	end
	if monster_num > 0 then
		return 
	end

	-- 如果有事件未激活，则弹出确认框
	
	self:nextStageDone()
end

function DungeonData:nextStageDone()
	-- 如果boss未击杀，则无法进入下一层
	for i,v in ipairs(self.grid_list) do
		if v.grid_event_type < 0 then
			return
		end
	end

	local req_next_stage = Dungeon_pb.GReqDungeonNextStage()
	req_next_stage.next_stage = self.cur_stage + 1
	NetManager:sendMessage(ProtocolID.GReqDungeonNextStage, req_next_stage)
end

function DungeonData:getPropsNum(props_type)
	for i,v in ipairs(self.props_list) do
		if v.item_type == props_type then
			return v.item_num
		end
	end
	return 0
end

-- 获得道具
function DungeonData:addProps(props_type, props_num)
	-- 901601：神秘钥匙；901602：hp恢复药剂；901603：驱散药剂；901604：召唤商人
	local is_have = false
	for i,v in ipairs(self.props_list) do
		if v.item_type == props_type then
			if v.item_num <= 0 then
				v.item_num = 0
			end
			v.item_num = v.item_num + props_num
			if v.item_num <= 0 then
				v.item_num = 0
			end
			is_have = true
			break
		end
	end

	if is_have == false then
		table.insert(self.props_list, {props_type, 1})
	end
end

-- 使用道具
function DungeonData:useProps(props_type, target)
	-- 901601：神秘钥匙；901602：hp恢复药剂；901603：驱散药剂；901604：召唤商人
	for i,v in ipairs(self.props_list) do
		if v.item_type == props_type then
			if v.item_num <= 0 then
				ex.MessageView:add(ex.Tools:getLang(47014))
				return
			end

			if v.item_type == 901601 then
				return
			end

			if (v.item_type == 901602 or v.item_type == 901603) and 
				v.cur_use_num >= ex.Tools:getSysCfg("shelter_item_use_limit") then
				ex.MessageView:add(ex.Tools:getLang(41219))
				return
			end

			v.item_num = v.item_num - 1
			v.cur_use_num = v.cur_use_num + 1

			if v.item_type == 901601 then

			elseif v.item_type == 901602 then
				local req_use_props = Dungeon_pb.GReqDungeonUseProps()
				req_use_props.props_type = props_type
				req_use_props.target_id = tonumber(target)
				NetManager:sendMessage(ProtocolID.GReqDungeonUseProps, req_use_props)
			elseif v.item_type == 901603 then
				local req_use_props = Dungeon_pb.GReqDungeonUseProps()
				req_use_props.props_type = props_type
				req_use_props.target_id = tonumber(target)
				NetManager:sendMessage(ProtocolID.GReqDungeonUseProps, req_use_props)
			elseif v.item_type == 901604 then
				NetManager:sendMessage(ProtocolID.GReqDungeonShopAdd)
			end

			break
		end
	end
end

-- 添加buff
function DungeonData:addBuff(buff_index)
	local config = cfg.sheltereventbuff.sheltereventbuff[buff_index]
	if config == nil then
		return
	end

	for i, v in ipairs(config.effect) do
		local is_have = false
		for i2, v2 in ipairs(self.buff_list) do
			if v.item_type == v2.item_type then
				v2.item_num = v2.item_num + v.item_num
				is_have = true
				break
			end
		end
		if is_have == false then
			local data = {}
			data.item_type = v.item_type
			data.item_num = v.item_num
			table.insert(self.buff_list, data)
		end
		ex.MessageView:add(ex.Tools:getLang(47529)..self.buff_name_list[v.item_type]..(v.item_num/100).."%", 0)
	end
end

-- 召唤商店
function DungeonData:shopAdd()
	-- 查询召唤商店次数是否足够
	local props_num = 0
	for i,v in ipairs(self.props_list) do
		if v.item_type == 901604 then
			if v.item_num <= 0 then
				return
			end

			-- if v.cur_use_num >= ex.Tools:getSysCfg("shelter_item_use_limit") then
			-- 	ex.MessageView:add(ex.Tools:getLang(47433))
			-- 	return
			-- end

			break
		end
	end
	
	NetManager:sendMessage(ProtocolID.GReqDungeonShopAdd)
end

-- 商店物品购买
function DungeonData:shopBuy(index)
	-- 查询商品项是否存在
	local is_have = false
	for i,v in ipairs(self.shop_list) do
		if v.index == index then
			-- 判定所需资源是否足够
			if v.cost_num > ex.Player:getItemNum(v.cost_type) then
				ex.MessageView:add(string.format(ex.Tools:getLang(1108),
					ex.Tools:getLang(cfg.item.item[v.cost_type].name)))
				return
			end

			is_have = true

			break
		end
	end

	if is_have == true then
		local req_shop_buy = Dungeon_pb.GReqDungeonShopBuy()
		req_shop_buy.index = index
		NetManager:sendMessage(ProtocolID.GReqDungeonShopBuy, req_shop_buy)
	end
end

function DungeonData:shopBuyDone(res_data)
	print("DungeonData:shopBuyDone")
	local is_have = false
	local shop_id = 0
	for i,v in ipairs(self.shop_list) do
		if v.index == res_data.index then
			is_have = true
			v.is_buy = 1
			shop_id = v.shop_id

			-- ex.Player:addItem(v.item_type, v.item_num)
			-- ex.Tools:addBackpackMsg(v.item_type, v.item_num)
			-- ex.Player:addItem(v.cost_type, -v.cost_num)
			break
		end
	end

	-- 请求刷新网格事件
	NetManager:sendMessage(ProtocolID.GReqDungeonInfo)

	-- 刷新界面显示
	if is_have == true and shop_id ~= 0 then
		local shop_list_ctr = require("src.layer.DungeonShopListCtr"):instance()
		local shop_ctr = require("src.layer.DungeonShopCtr"):instance()
		if shop_list_ctr:getLayer() ~= nil then
			shop_list_ctr:updateLayer()
		end
		if shop_ctr:getLayer() ~= nil then
			local vec_shop_item = {}
			for i,v in pairs(self.shop_list) do
				if v.shop_id == shop_id then
					table.insert(vec_shop_item, v)
				end
			end
			shop_ctr:updateLayer(vec_shop_item)
		end
	end
end

-- 获取庇护所开放状态  0:已开启 1:未开始 2:已关闭  
function DungeonData:getOpenStatus()
	local now = ex.Game:getServerTime()

	-- print("DungeonData:getOpenStatus:", self.start_time, self.end_time, now)
	if self.start_time <= 0 or self.start_time > now then
		return 1
	elseif self.end_time <= now then
		return 2
	else
		return 0
	end

	return - 1
end

function DungeonData:checkRedDot()
	local status = self:getOpenStatus()

	if status == 0 and #self.lineup_hero_list <= 0 and  ex.JumpManager:checkOpenConditionByAtomNoMsg("main_dungeon") then
		ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_YGZC_YSBHS, true)
	else
		ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_YGZC_YSBHS, false)
	end
	
	-- 击杀祭祀红点
	local is_visible = self:IsAnyKillReward()
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_YGZC_YSBHS_JSJS, is_visible)
end

return DungeonData
