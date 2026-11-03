local Player = class("Player", require("src.common.SingleInstance"))

Player.role_id = "0"
Player.gem = 0
Player.gold = 0
Player.energy = 0
Player.exp = 0
Player.crown = 0
Player.level = 0
Player.friend_ship = 0
Player.honor = 0
Player.energy_restore = 0
Player.adventure_daily = 0
Player.befall_daily = 0
Player.friends_daily = 0
Player.nick = ""
Player.last_request_time = 0
Player.lang = 0
Player.role_create_time = 0
Player.is_rename = 0
Player.guide_serial = 0
Player.last_week_rank = 0
Player.now_week_honor = 0
Player.server_create_time = 0
Player.vip_level = 0
Player.vip_exp = 0
Player.hero_exp = 0
Player.recharge = 0
Player.total_charge = 0		-- 累充数值
Player.border_id = 0
Player.fighting = 0
Player.forbid_words_end_time = 0
Player.serial_str = {}
Player.area_idx = 1
Player.last_add_exp = 0
Player.world_level = 1		-- 世界等级
Player.awaken_star = 14 	-- add 熊梦 觉醒星级

Player.comment_list = {}	-- 评论状态列表

Player.clergy_exp = 0
Player.clergy_level = 0

Player.maincity_unfold_1 = false	-- 主城界面右上方的活动按钮是否展开
Player.maincity_unfold_2 = true	-- 主城界面右下方的功能按钮是否展开
Player.maincity_unfold_time = 0	-- 主城界面展开动作上次执行时间

Player.maincity_unfold_left = true			-- 主城界面左边的活动按钮是否展开
Player.maincity_unfold_right = true		-- 主城界面右的功能按钮是否展开
Player.maincity_unfold_left_time = 0		-- 主城界面左边的活动按钮展开动作上次执行时间
Player.maincity_unfold_right_time = 0		-- 主城界面左边的活动按钮展开动作上次执行时间
-- 临时存的时区
Player.offset_utc = 0	

-- add 熊梦 把广播显示在战斗下面
Player.battle_state = false    -- 战斗状态
Player.notice_data = nil	   -- 只保存一条国战广播

function Player:ctor()
	self.achievement_data 			= require("src.data.AchievementData"):new()
	self.altar_data 				= require("src.data.AltarData"):new()
	self.battle_data 				= require("src.data.BattleData"):new()
    self.backpack_data 				= require("src.data.BackpackData"):new(self)
	self.blessing_pool 				= require("src.data.BlessingPoolData"):new()
	self.border_data 				= require("src.data.BorderData"):new()
	self.championcross_data 		= require("src.data.ChampionCrossData"):new()
	self.champion_data 				= require("src.data.ChampionData"):new()
	self.chapter_data 				= require("src.data.ChapterData"):new()
	self.chat_data 					= require("src.data.ChatData"):new()
	self.clan_data 					= require("src.data.ClanData"):new()
	-- self.crusade_group_data 		= require("src.layer.crusadegroup.CrusadeGroupData"):new()
	self.daily_dungeon_data 		= require("src.data.DailyDungeonData"):new()
	self.dragon_data 				= require("src.data.DragonData"):new()
	self.dream_data 				= require("src.data.DreamData"):new()
	self.dungeon_data 				= require("src.data.DungeonData"):new()
	self.exotic_adventure_data 		= require("src.data.ExoticAdventureData"):new()
	self.fetter_data 				= require("src.data.FetterData"):new()
	-- self.floating_islands_data		= require("src.data.FloatingIslandsData"):new()
	self.friend_data 				= require("src.data.FriendData"):new()
	self.god_equip_data 			= require("src.data.GodEquipData"):new()
	self.god_relic_data 			= require("src.data.GodRelicData"):new()
	self.heroarrive_data 			= require("src.data.HeroArriveData"):new()
	self.hero_data 					= require("src.data.HeroData"):new()
	self.league_data 				= require("src.data.LeagueData"):new()
	self.lineup_data 				= require("src.data.LineupData"):new()
	self.magic_tower_data 			= require("src.data.MagicTowerData"):new()
	self.mail_data 					= require("src.data.MailData"):new()
	self.market_data 				= require("src.data.MarketData"):new()
	
	self.notice_data 				= require("src.data.NoticeData"):new()
	self.onlineReward_data		 	= require("src.data.OnlineRewardData"):new()
	self.pub_task					= require("src.data.PubTaskData"):new()
	self.prophet_data 				= require("src.data.ProphetData"):new()
	self.pvp_data 					= require("src.data.PvpData"):new()
	self.promotion_data 			= require("src.data.PromotionData"):new()
	self.rainbow_data 				= require("src.data.RainbowData"):new()
	self.rank_data 					= require("src.data.RankData"):new()
	self.seventdaytarget_data 		= require("src.data.SevenDayTargetData"):new()
	self.seven_login_data 			= require("src.data.SevenLoginData"):new()
	self.shop_data 					= require("src.data.ShopData"):new()
	self.space_time_magic_tower_data = require("src.data.STMagicTowerData"):new()
    self.summon_data 				= require("src.data.SummonData"):new()
    self.super_stage_data 			= require("src.data.SuperStageData"):new()
	self.team_arena_data 			= require("src.data.TeamArenaData"):new()
	self.title_data 				= require("src.data.TitleData"):new()
	self.tower_data	 				= require("src.data.TowerData"):new()
	self.trial_data 				= require("src.data.TrialData"):new()
	self.underworld_pagoda_data 	= require("src.data.UnderworldPagodaData"):new()
	self.video_studio_data 			= require("src.data.VideoStudioData"):new()
end

function Player:addItem(item_type, num, id, ex_attr_idx, skill_type_1, skill_num_1, skill_type_2, skill_num_2)
	
	local pror_type = self.backpack_data:getPropType(item_type)
	if pror_type == ItemData.IT_RUNES or pror_type == ItemData.IT_SPECIAL then
		return
	end

	if item_type <= 900101 then
		-- 钻石 金币 经验
		self:addRes(item_type, num)
	else
		-- 装备 道具 碎片 特殊
		if not id then
			id = "0"
		end
		self.backpack_data:changeBackpack(item_type, num, id, ex_attr_idx, skill_type_1, skill_num_1, skill_type_2, skill_num_2)
		if self.backpack_data:isPiece(item_type) then 
			self.backpack_data:checkPieceRed() 
		end
		
		ex.MainSceneCtr:addResEvent(EVENT.BACK_PACK_EVENT.BACKPACK_UPDATA_LIST, item_type)
		-- ex.EventManager:fire(EVENT.BACK_PACK_EVENT.BACKPACK_UPDATA_LIST, item_type)
	end
end

function Player:addItemByNet(id, item_type, num)
	self:addItem(item_type, num, id)
end

function Player:addGold(num)
	self:addRes(ItemType.IT_GOLD, num)
end

function Player:addGem(num)
	self:addRes(ItemType.IT_GEM, num)
end

function Player:addRes(item_type, num)
	if item_type == ItemType.IT_GOLD then
		local form = self.gold
		self.gold = math.max(0, self.gold + num)
		local to = self.gold
		ex.MainSceneCtr:setGold(form, to)
		-- print(num)
		-- print(debug.traceback())

		ex.MainSceneCtr:addResEvent(EVENT.BACKPACK_RES_CHANGE.ITEM_TYPE_IT_GOLD, item_type)
		-- ex.EventManager:fire(EVENT.BACKPACK_RES_CHANGE.ITEM_TYPE_IT_GOLD, item_type)
	elseif item_type == ItemType.IT_GEM then
		local form = self.gem
		self.gem = math.max(0, self.gem + num)
		local to = self.gem
		ex.MainSceneCtr:setGem(form, to)

		ex.MainSceneCtr:addResEvent(EVENT.BACKPACK_RES_CHANGE.ITEM_TYPE_IT_GEM, item_type)
		ex.MainSceneCtr:getMainScene():updateBubbleGem()
		-- ex.EventManager:fire(EVENT.BACKPACK_RES_CHANGE.ITEM_TYPE_IT_GEM, item_type)
	elseif item_type == ItemType.IT_ROLE_EXP then

		self.exp = self.exp + num

		self.last_add_exp = num
		for i=1,100 do
			local config = cfg.mainlevel.mainlevel[self.level]
			if not config then
				break
			end
			
			if self.exp >= config.exp then
				self.exp = self.exp - config.exp
				self.level = self.level + 1
				require("src.platform.SocialPlatform"):submitRoleInfoLua("level_up")
			else
				break
			end
		end
		ex.MainSceneCtr:setExp(self.level, self.exp)

		ex.EventManager:fire(EVENT.BACKPACK_RES_CHANGE.ROLE_LEVEL, ex.Player.level)
		local layer_main_city = ex.MainSceneCtr:getKeepBuffer(MainSceneType.MAINCITY_LAYER)
		if layer_main_city and layer_main_city.refreshBtnStatus then
			layer_main_city:refreshBtnStatus()
		end

		ex.MainSceneCtr:addResEvent(EVENT.BACKPACK_RES_CHANGE.ITEM_TYPE_IT_ROLE_EXP, ItemType.IT_ROLE_EXP)
		self.tower_data:updateTowerRedDot()
		self.trial_data:checkRedDot()
		self.daily_dungeon_data:updateRedDot()
		self.god_relic_data:checkReddot()
		self.god_equip_data:checkSummonReddot()
		-- self.hero_data.equip:checkMakeEquipRedPoint()

		-- ex.EventManager:fire(EVENT.BACKPACK_RES_CHANGE._ROLE_EXP)
	elseif item_type == ItemType.IT_CLAN_EXP then
		self.clan_data:addClanExp(num)
	elseif item_type == ItemType.VIP_EXP then
		while true do
			local level_config = cfg.vip.vip[self.vip_level]
			if (not level_config) or level_config.vip_exp == 0 then
				break
			end

			if level_config.vip_exp - (self.vip_exp + num) > 0 then
				-- 经验不够升级的。增加经验
				self.vip_exp = self.vip_exp + num
				break
			else
				-- 升级了
				num = (num - (level_config.vip_exp - self.vip_exp))
				self.vip_exp = 0
				self.level = self.level + 1
			end
		end

		ex.MainSceneCtr:addResEvent(EVENT.BACKPACK_RES_CHANGE.ITEM_TYPE_VIP_EXP, ItemType.VIP_EXP)
		-- ex.EventManager:fire(EVENT.BACKPACK_RES_CHANGE.ITEM_TYPE_VIP_EXP)
		-- refreshBtnStatus
		-- cpp.MainSceneCtr:instance():setLevel(self.level)
		-- cpp.MainSceneCtr:instance():setExp(self.level, self.exp)
	elseif item_type == ItemType.IT_HERO_EXP then 
		self.hero_exp = self.hero_exp + num
		ex.EventManager:fire(EVENT.BACK_PACK_EVENT.BACKPACK_UPDATA_LIST, item_type)
	end
end

function Player:requestProtoc()
	self.achievement_data:reqAchievement()
	-- self.achievement_data:reqAchievement()
	self.seventdaytarget_data:reqSevenDayTarget()
	self.seventdaytarget_data:reqSevenDayLogin()
end

function Player:getItemNum(item_type)
	if item_type == ItemType.IT_GOLD then
		return self.gold
	elseif item_type == ItemType.IT_GEM then
		return self.gem
	elseif item_type == ItemType.IT_HERO_EXP then 
		return self.hero_exp
	else
		return self.backpack_data:getItemNum(item_type)
	end
end

function Player:getHeroBattleList()
	local battle_list = {}

	local inserHeroId = function(hero_id)
		if hero_id ~= "0" then
			local is_add = true
			for _,v in pairs(battle_list) do
				if v == hero_id then
					is_add = false
					break
				end
			end
			if is_add then
				table.insert(battle_list, hero_id)
			end
		end
	end

	local checkBattleList = function(cur_list)
		for _,v in pairs(cur_list) do
			inserHeroId(v)
		end
	end

	checkBattleList(self.lineup_data:getIdList(LineupType.CHAPTER))
	checkBattleList(self.lineup_data:getIdList(LineupType.PVP_DEFENSE))
	
    return battle_list
end

function Player:clear()
	self.shop_data:stopAllCheck()

	self.clan_data:clean()
	self.mail_data:clean()
	self.notice_data:clean()
	self.market_data:clean()
	self.video_studio_data:clean()
	self.promotion_data.new_year_data:clean()
	self.promotion_data.prom_war_order_data:clean()
	self.promotion_data.customized_data:clean()

	self:clearEvent()
	self._instance = nil
end

function Player:clearEvent()
	self.hero_data:clear()
	self.trial_data:clear()
	self.achievement_data:clear()
	self.seventdaytarget_data:clear()
	self.promotion_data:clear()
end

function Player:setImageId(hero_type, star)
	self.image_id = 100000000 * star + hero_type
end

function Player:getImageId()
	if self.image_id == 0 then
		return 0,0
	end
	
	local hero_type = math.floor(self.image_id % 100000000)
	local star = math.floor(self.image_id / 100000000)
	return hero_type, star
end

function Player:reqChangeHead()
	-- 修改头像形象
    local req_change = Role_pb.GReqRoleChangeHead()
    -- req_change.head_id = self.head_id
    req_change.image_id = self.image_id
    NetManager:sendMessage(ProtocolID.GReqRoleChangeHead, req_change)

    
    -- 刷新头像
	-- local req_role_info = ProtocolRequest.ReqRoleInfo
 --   	NetManager:sendLuaData(req_role_info)
 	NetManager:sendMessage(ProtocolID.GReqRoleInfo)
 	
end

function Player:pay(idx, info)
	info = info ~= nil and tostring(info) or ""

	-- if  then
		
	-- end
	local buy_config = cfg.buygem.buygem[idx]
	if not buy_config then
		ex.Tools:showDebugStatus(string.format(ex.Tools:getLang(47725), idx))
		return
	end

	-- if self.shop_data:isLimitRecharge(idx) then
	-- 	ex.MessageView:add(ex.Tools:getLang(41237))
	-- 	return
	-- end

	local req_recharge = Recharge_pb.GReqRechargeOrder()
	req_recharge.product_idx = buy_config.idx
	req_recharge.cli_extra_info = info
	NetManager:sendMessage(ProtocolID.GReqRechargeOrder, req_recharge)

	if device.platform == "mac" or is_pass_recharge == true then
		-- local req_gm_recharge = Role_pb.GReqGMRecharge()
    	-- req_gm_recharge.product_id = buy_config.idx
    	-- NetManager:sendMessage(ProtocolID.GReqGMRecharge, req_gm_recharge)
		-- dump(debug.traceback())
		  
    	local req_command = Role_pb.GReqGMCommandNew()
		req_command.command = "RECHARGE"
		table.insert(req_command.param, tostring(buy_config.idx))
		NetManager:sendMessage(ProtocolID.GReqGMCommandNew, req_command)
	end

	-- info = info or ""
	-- local http_data = {}
    -- http_data["action"] = "Recharge.recharge"
    -- http_data["X-Order-Sandbox"] = "1"
    -- http_data["BillNo"] = cpp.Game:makeLuaId()
    -- http_data["UserCode"] = require("src.model.Game"):instance().user_id --ex.SocialPlatform:getUserCode()
    -- http_data["Amount"] = tostring(amount)
    -- http_data["ProductId"] = tostring(buy_config.code)
    -- http_data["RoleId"] = tostring(ex.Player.role_id)
    -- http_data["ServerId"] = tostring(cc.UserDefault:getInstance():getIntegerForKey("server_id", -1)) -- tostring(ex.SocialPlatform:getServerId())
    -- http_data["channel_id"] = ex.SocialPlatform:getChannelId()
    -- http_data["pf_id"] = ex.SocialPlatform:getPfId()
    -- http_data["platform"] = ex.SocialPlatform:getPlatformStr()
    -- http_data["extraInfo"] = info

    -- local http = require("src.net.PlatformApi"):create()
    -- http:setCallback(handler(self, self.payConfirmLua))
    -- http:luaSendGet(json.encode(http_data), 5)
    -- ex.Player.shop_data:startCheckRecharge()

	-- -- ex.MessageView:add(ex.Tools:getLang(47335))
	-- if cpp.SocialPlatform:instance():getPlatformStr() == "2" or is_game_controller == true then
		
	-- 	print("tostring(product_id)", tostring(product_id))
    -- 	local req_recharge = Role_pb.GReqGMRecharge()
    -- 	req_recharge.product_id = tostring(product_id)
    -- 	NetManager:sendMessage(ProtocolID.GReqGMRecharge, req_recharge)
		
    -- 	-- local BillNo = http_data["BillNo"]
    -- 	-- -- 测试充值成功回调
    -- 	-- http_data = {}
    -- 	-- http_data["action"] = "System.recharge"
    -- 	-- http_data["is_test"] = "1"
    -- 	-- http_data["billNo"] = BillNo
    -- 	-- http_data["money"] = tostring(amount)
    -- 	-- http_data["goods_id"] = tostring(product_id)
    -- 	-- http_data["rid"] = tostring(ex.Player.role_id)
    -- 	-- http_data["serverId"] = tostring(cc.UserDefault:getInstance():getIntegerForKey("server_id", -1)) --tostring(ex.SocialPlatform:getServerId())
    -- 	-- http_data["orderId"] = cpp.Game:makeLuaId()
    -- 	-- http_data["userCode"] = tostring(ex.Player.role_id)
    -- 	-- http_data["gameId"] = "158"
    -- 	-- http_data["status"] = "0"
    -- 	-- http_data["extraInfo"] = info
    -- 	-- local http_recv = require("src.net.PlatformApi"):create()
    -- 	-- http_recv:luaSendTestGet(json.encode(http_data), 5)
    -- 	-- ex.Player.shop_data:startCheckRecharge()
	-- end
end

function Player:payConfirmLua(json)
	
end

function Player:getChatProvinceList()
	local area_config = cfg.area.area[self.area_idx]
	if area_config == nil then
		return {}
	end

	local vec_province = {}
	for k,v in pairs(cfg.area.area) do
		local is_have = false
		for i2,v2 in ipairs(vec_province) do
			if v2.name == v.province then
				if v2.index > v.idx then
					v2.index = v.idx
				end
				is_have = true
				break
			end
		end
		if not is_have then
			local data = {}
			data.index = v.idx
			data.name = v.province
			table.insert(vec_province, data)
		end
	end

	table.sort(vec_province, function(a, b)
		return a.index < b.index
	end)

	local cur_province_idx = 1
	for i,v in ipairs(vec_province) do
		if area_config.province == v.name then
			cur_province_idx = i
			break
		end
	end

	return vec_province, cur_province_idx
end

function Player:getChatCityList()
	local area_config = cfg.area.area[self.area_idx]
	if area_config == nil then
		return {}
	end

	local vec_city = {}
	for k,v in pairs(cfg.area.area) do
		if v.province == area_config.province then
			local data = {}
			data.index = v.idx
			data.name = v.city
			table.insert(vec_city, data)
		end
	end

	table.sort(vec_city, function(a, b)
		return a.index < b.index
	end)

	local cur_city_idx = 1
	for i,v in ipairs(vec_city) do
		if area_config.city == v.name then
			cur_city_idx = i
			break
		end
	end

	return vec_city, cur_city_idx
end

function Player:setChatAreaWithIdx(idx, is_send_proto)
	if cfg.area.area[idx] == nil then
		return
	end

	self.area_idx = idx

	if is_send_proto ~= nil and is_send_proto == true then
		-- 发送服务器信息
		local req_update_area_idx = Role_pb.GReqUpdateAreaId()
		req_update_area_idx.area_id = self.area_idx
		NetManager:sendMessage(ProtocolID.GReqUpdateAreaId, req_update_area_idx)

		-- 请求最新同省聊天消息
		local req_chat_log = Chat_pb.GReqChatLogByType()
		req_chat_log.type = 7
		NetManager:sendMessage(ProtocolID.GReqChatLogByType, req_chat_log)
	end
end


function Player:getRoleCommentSharedState(shared_type)
	for k,v in pairs(self.comment_list) do
		if v.type == shared_type then
			return v.state
		end
	end
	return 0
end




return Player
