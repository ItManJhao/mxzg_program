local DungeonResponse = class("DungeonResponse")

function DungeonResponse:dungeonInfo(data)
	-- dump(data, "DungeonResponse:dungeonInfo")
	
 	ex.Player.dungeon_data.cur_stage = data.cur_stage
 	ex.Player.dungeon_data.cur_grid_type = data.grid_type
 	ex.Player.dungeon_data.start_time = data.start_time
	ex.Player.dungeon_data.end_time = data.end_time
 	ex.Player.dungeon_data.monster_kill_num = data.npc_num

 	ex.Player.dungeon_data.grid_list = data.list

 	-- 刷新网格显示
	ex.EventManager:fire(EVENT.DUNGEON_EVENT.GRID_INFO)

	local potion_use_ctr = require("src.layer.DungeonPotionUseCtr"):instance()
 	if potion_use_ctr:getDungeonPotionUseLayer() ~= nil then
		potion_use_ctr:updateLayer()
 	end


end

function DungeonResponse:dungeonShopList(data)
 	-- local data = NetManager:resLuaData(ProtocolResponse.ResDungeonShopList, byte_array)
	-- dump(data, "DungeonResponse:dungeonShopList")
 	ex.Player.dungeon_data.shop_list = data.list
end

function DungeonResponse:dungeonPropsList(data)
 	-- dump(data, "DungeonResponse:dungeonPropsList")
 	ex.Player.dungeon_data.props_list = data.list
	ex.EventManager:fire(EVENT.DUNGEON_EVENT.PROPS_INFO)
end

function DungeonResponse:dungeonBuffList(data)
 	-- dump(data, "DungeonResponse:dungeonBuffList")
 	ex.Player.dungeon_data.buff_list = data.list
end

function DungeonResponse:dungeonMonsterHpList(data)
	-- dump(data, "DungeonResponse:dungeonMonsterHpList")
	ex.Player.dungeon_data.monster_hp_list = data.list
end

function DungeonResponse:dungeonTeam(data)
	-- dump(data, "DungeonResponse:dungeonTeam")
 	
	ex.Player.dungeon_data.lineup_hero_list = data.list
	
 	-- 记录组队信息，如果当前处于初始组队界面，并获得队列非空，则关闭初始组队界面，并进入英雄避难所
	ex.EventManager:fire(EVENT.DUNGEON_EVENT.HERO_INFO)
 	local hero_select_ctr = require("src.layer.DungeonHeroSelectCtr"):instance()
 	if hero_select_ctr:getDungeonHeroSelectLayer() ~= nil then
 		hero_select_ctr:closeWindow(0, nil)
	end
	local potion_use_ctr = require("src.layer.DungeonPotionUseCtr"):instance()
 	if potion_use_ctr:getDungeonPotionUseLayer() ~= nil then
		potion_use_ctr:updateLayer()
 	end

 	ex.Player.dungeon_data:checkRedDot()
end

function DungeonResponse:dungeonInitTeam(data)
	-- dump(data, "DungeonResponse:dungeonInitTeam")
 	-- 初始组队后，重新向服务器请求组队列表
	NetManager:sendMessage(ProtocolID.GReqDungeonTeam)
end

function DungeonResponse:dungeonGridLight(data)
	NetManager:sendMessage(ProtocolID.GReqDungeonInfo)
end

function DungeonResponse:dungeonKillRewardList(data)
	-- dump(data, "DungeonResponse:dungeonKillRewardList")
	
	ex.Player.dungeon_data.kill_reward_list = data.list

	local reward_ctr = require("src.layer.DungeonKillRewardCtr"):instance()
 	if reward_ctr:getDungeonKillRewardLayer() ~= nil then
		reward_ctr:updateTableView()
 	end
 	
 	ex.Player.dungeon_data:checkRedDot()
end

function DungeonResponse:dungeonKillReward(data)
	-- local data = NetManager:resLuaData(ProtocolResponse.ResDungeonKillReward, byte_array)

	NetManager:sendMessage(ProtocolID.GReqDungeonKillRewardList)
   
	-- local reward_ctr = require("src.layer.DungeonKillRewardCtr"):instance()
 	-- if reward_ctr:getDungeonKillRewardLayer() ~= nil then
	-- 	reward_ctr:updateTableView()
	 -- end
	 
	-- 刷新月神庇护所界面特效
	ex.EventManager:fire(EVENT.DUNGEON_EVENT.TAKE_KILL_REWARD)
end

function DungeonResponse:dungeonNextStage(data)
 	-- local data = NetManager:resLuaData(ProtocolResponse.ResDungeonNextStage, byte_array)
	-- dump(data, "DungeonResponse:dungeonNextStage")
	 
	require("src.layer.DungeonStageEndCtr"):instance():openWindow(data.list)

 	-- 刷新当前层的数据显示
	NetManager:sendMessage(ProtocolID.GReqDungeonInfo)
	 
	NetManager:sendMessage(ProtocolID.GReqDungeonMonsterHpList)
end

function DungeonResponse:dungeonUseProps(data)
 	-- local data = NetManager:resLuaData(ProtocolResponse.ResDungeonUseProps, byte_array)
 	
	-- dump(data, "DungeonResponse:dungeonUseProps")
	if data.status <= 0 then
		return
	end

	-- 如果使用驱散药剂，则通知前端爆裂四周网格
	if data.props_type == 901603 then
		ex.EventManager:fire(EVENT.DUNGEON_EVENT.USE_POTION_SUCCEED, data.props_type, data.target_id)
	end
	
	NetManager:sendMessage(ProtocolID.GReqDungeonInfo)
	 
	NetManager:sendMessage(ProtocolID.GReqDungeonTeam)
end

function DungeonResponse:dungeonGetRes(data)
	 -- local data = NetManager:resLuaData(ProtocolResponse.ResDungeonGetRes, byte_array)
	
	ex.Player.dungeon_data:getResDone(data)
 	
	NetManager:sendMessage(ProtocolID.GReqDungeonPropsList)
	
	NetManager:sendMessage(ProtocolID.GReqDungeonBuffList)
end

function DungeonResponse:dungeonOpenBox(data)
 	-- local data = NetManager:resLuaData(ProtocolResponse.ResDungeonOpenBox, byte_array)
 	
	 ex.Player.dungeon_data:openBoxDone(data)
end

function DungeonResponse:dungeonShopBuy(data)
 	-- local data = NetManager:resLuaData(ProtocolResponse.ResDungeonShopBuy, byte_array)
 	
 	if data.status > 0 then
		ex.Player.dungeon_data:shopBuyDone(data)
	end
end

function DungeonResponse:dungeonShopAdd(data)
 	-- local data = NetManager:resLuaData(ProtocolResponse.ResDungeonShopAdd, byte_array)
 	
	NetManager:sendMessage(ProtocolID.GReqDungeonShopList)
	 
	NetManager:sendMessage(ProtocolID.GReqDungeonPropsList)

 	-- 刷新道具数量显示，并显示新增道具的神秘商店显示
 	if data.status > 0 then
		local vec_shop_item = {}
		local shop_item = {}
		shop_item.index = data.index
		shop_item.item_type = data.item_type
		shop_item.item_num = data.item_num
		shop_item.cost_type = data.cost_type
		shop_item.cost_num = data.cost_num
		shop_item.discount = data.discount
		shop_item.is_buy = 0
		table.insert(vec_shop_item, shop_item)

		require("src.layer.DungeonShopCtr"):instance():openWindow(vec_shop_item)
 	end
end

function DungeonResponse:dungeonBattleEnd(data)
	-- local data = NetManager:resLuaData(ProtocolResponse.ResDungeonBattleEnd, byte_array)
	
	-- 结算后立马刷新网格信息和英雄信息
	NetManager:sendMessage(ProtocolID.GReqDungeonInfo)
	 
	NetManager:sendMessage(ProtocolID.GReqDungeonTeam)

	NetManager:sendMessage(ProtocolID.GReqDungeonMonsterHpList)

	-- 如果是跳过战斗，则直接调用结算函数
    if cc.UserDefault:getInstance():getIntegerForKey("is_dungeon_battle_pass"..ex.Player.role_id) ~= 1 then
		ex.EventManager:fire(EVENT.DUNGEON_EVENT.BATTLE_START, data.report)
	else
		ex.EventManager:fire(EVENT.DUNGEON_EVENT.BATTLE_END, data.report.win_id == ex.Player.role_id)
	end
end

-- 庇护所重制时。发此协议让前端刷新庇护所数据
function DungeonResponse:dungeonUpdate(data)
	-- 结算后立马刷新网格信息和英雄信息
	NetManager:sendMessage(ProtocolID.GReqDungeonInfo)
	 
	NetManager:sendMessage(ProtocolID.GReqDungeonTeam)

	NetManager:sendMessage(ProtocolID.GReqDungeonPropsList)

	NetManager:sendMessage(ProtocolID.GReqDungeonShopList)

	NetManager:sendMessage(ProtocolID.GReqDungeonMonsterHpList)
end

return DungeonResponse