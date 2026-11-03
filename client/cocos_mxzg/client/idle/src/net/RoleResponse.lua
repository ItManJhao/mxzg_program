local RoleResponse = class("RoleResponse")


-- 心跳包
function RoleResponse:heartBeat(data, byte_array)
	-- 1575970431000
	-- 562949953421312
	cpp.Game:instance():setServerTime(data.server_time)
end


function RoleResponse:login(login, byte_array)
	cpp.ResponseManager:instance():response(byte_array)
	require("src.scene.LoadingSceneCtr"):instance():receivedProtocol(ProtocolID.GResRoleInfo)

	-- 封号了
	if login.status == 1 then
		-- require("src.layer.ConfirmCtr"):instance():openWindow()
		local str1 = ex and ex.Tools:getLang(41177) or ex.Tools:getLang(47051)
		local str2 = ex and ex.Tools:getLang(41178) or ex.Tools:getLang(47377)
		require("src.layer.ConfirmCtr"):instance():openWindow(str1, str2, function(  )
			require("src.scene.UpdateSceneCtr"):instance():enterWithAnimation()
		end, nil, nil, false, false)
		cpp.Game:instance():stopTheGame()
		return
	end

	local rid = login.rid
	local server_time = login.server_time
	cpp.Game:instance():setServerTime(server_time)
	cpp.Game:instance():startCheckNetwork()
	ex.Player.offset_utc = login.offset_utc
	
	-- print("RoleResponse:lua login: 111111")
	-- if rid == "0" or ex.Player.role_id ~= "0" then
	-- -- print("RoleResponse:lua login: 222222")
	-- 	return
	-- end

	print("RoleResponse:login ex.Player.role_id", ex.Player.role_id)
	if rid == 0 then
		-- 创建角色
		local req_role_init = Login_pb.GReqInit()
		req_role_init.nick = ex.Tools:getLang(1534)
		req_role_init.lang = 0
		req_role_init.platform = tonumber(cpp.SocialPlatform:instance():getPlatformStr())
		req_role_init.place = cpp.SocialPlatform:instance():getPfId()--cpp.SocialPlatform:instance():getAgent()
		req_role_init.device_id = cpp.Game:instance():deviceUUID()
		NetManager:sendMessage(ProtocolID.GReqInit, req_role_init)
		return
	else
		NetManager:sendMessage(ProtocolID.GReqRoleInfo)
	end
	-- print("RoleResponse:lua login: 444444")
	ex.Player.role_id = rid
	-- 掉线处理
	cpp.Game:instance():setResLogin()
	
	if require("src.scene.LoadingSceneCtr"):instance():isRuning() ~= true then
		
	end
	-- print("ex.Player.role_id", ex.Player.role_id)
end

function RoleResponse:roleInit(roleInfo)
	if tonumber(roleInfo.rid) > 0 then
		require("src.native.Native").sendReqLogin()
	end
end


function RoleResponse:roleInfo(player, byte_array)
	cpp.ResponseManager:instance():response(byte_array)
	ex.Player.server_lang = player.server_lang
	ex.Player.gem = player.gem
	ex.Player.gold = player.gold
	ex.Player.energy = player.energy
	ex.Player.exp = player.exp
	ex.Player.crown = player.cup
	ex.Player.level = player.level
	ex.Player.head_id = player.head_id
	ex.Player.image_id = player.image_id
	ex.Player.nick = player.nick
	ex.Player.last_request_time = player.last_request_time
	ex.Player.lang = player.lang
	ex.Player.role_create_time = player.create_time
	ex.Player.clan_data.clan_id = player.clan_id
	ex.Player.is_rename = player.is_edit_name
	-- ex.Player.guide_serial = player.serial
	ex.Player.server_create_time = player.server_create_time
	ex.Player.hero_exp = player.hero_exp
	ex.Player.total_charge = player.recharge
	ex.Player.border_id = player.border_id
	ex.Player.fighting = player.fighting

	ex.Player.clergy_exp = player.clergy_exp
	ex.Player.clergy_level = player.clergy_level
	
	ex.Player.peerage_status = player.peerage_status
	ex.Player.peerage_level = player.peerage_level
	

	if player.area_id == nil or player.area_id <= 0 then
		ex.Player.area_idx = 1
	else
		ex.Player.area_idx = player.area_id
	end
	
	-- dump(ex.Player, "RoleResponse:roleInfo")
	-- local vip_level = player.vip_level
	-- if vip_level ~= ex.Player.vip_level then

	-- 	vip_level = math.min(table.nums(cfg.vip.vip) - 1, vip_level)
	-- 	ex.Player.vip_level = vip_level
		
	-- 	-- local add_capacity = cfg.vip.vip[vip_level].extra_bag_space
	-- 	-- ex.Player.hero_data.hero_capacity = ex.Player.hero_data.hero_capacity + add_capacity
	-- end
	-- ex.Player.vip_exp = player.vip_exp
	for i,v in ipairs(player.serial) do
		if v > ex.Player.guide_serial then
			ex.Player.guide_serial = v
		end
	end

	for i,v in ipairs(player.serial_str) do
		table.insert(ex.Player.serial_str, v)
	end

	
	if ex.MainSceneCtr:isRuning() then
		print("ex.MainSceneCtr:isRuning()")
		ex.MainSceneCtr:setGold(0, ex.Player.gold)
		ex.MainSceneCtr:setGem(0, ex.Player.gem)
		ex.MainSceneCtr:setExp(ex.Player.level, ex.Player.exp)

		-- 12点时候
    	local now_time = ex.Game:getServerTime()
		local main_scene = ex.MainSceneCtr:getMainScene()
		if main_scene and main_scene.reset_time < now_time then
			main_scene.reset_time = ex.Game:getServerTime() + GetSystemResetTime() + 10
		else
			return
		end
	end

	-- 世界等级
	NetManager:sendMessage(ProtocolID.GReqWorldLevel)

	ex.Player.rank_data:onRefresh()
	ex.Player.rank_data:onRefreshDungeon()

	-- 登录成功时刷新一次服务器时间。预防掉线
	NetManager:sendMessage(ProtocolID.GReqHeartBeat)

	-- 评论有礼状态列表
	NetManager:sendMessage(ProtocolID.GReqCommentSharedState)

	-- 背包信息
	NetManager:sendMessage(ProtocolID.GReqBackPackList)	
	NetManager:sendMessage(ProtocolID.GReqTimeLimitList)	

	local req_runes_list = Rune_pb.GReqRunesList()
	req_runes_list.page = 1
	NetManager:sendMessage(ProtocolID.GReqRunesList, req_runes_list)
	
	-- 神装列表
    local req = GodEquip_pb.GReqScanGodEquip()
	req.page = 1
	NetManager:sendMessage(ProtocolID.GReqScanGodEquip, req)
	
	NetManager:sendMessage(ProtocolID.GReqGodEquipPrivilege)

    -- 关卡数据
    NetManager:sendMessage(ProtocolID.GReqChapterData)

	-- 关卡数据
	NetManager:sendMessage(ProtocolID.GReqChapterItemList)
	
	-- 每日副本
	NetManager:sendMessage(ProtocolID.GReqDailyDungeonList)

	-- 试炼红点
	-- NetManager:sendMessage(ProtocolID.GReqTrialCfg)
	NetManager:sendMessage(ProtocolID.GReqRedState)

	-- 宠物
	NetManager:sendMessage(ProtocolID.GReqPetInfoList)
	NetManager:sendMessage(ProtocolID.GReqPetIllustrate)

	-- 星盘
	NetManager:sendMessage(ProtocolID.GReqAstrolabeData)
	
	-- 中秋特惠
    -- NetManager:sendMessage(ProtocolID.GReqMidAutumnInfo)

	-- 酒馆达标
	--ex.Player.promotion_data:reqPubArriveInfo()

	ex.Player.promotion_data:reqCommonActivityData(35)

	NetManager:sendMessage(ProtocolID.GReqAdventureNoteInfo)

	NetManager:sendMessage(ProtocolID.GReqMysteryBoxInfo)
	
	-- 请求公会战信息
	NetManager:sendMessage(ProtocolID.GReqScanWarInfo)
	-- 请求公会BOSS战信息
	NetManager:sendMessage(ProtocolID.GReqScanWorldBoss)

	-- 请求上次公会退出时间，用来限制公会创建间隔
	NetManager:sendMessage(ProtocolID.GReqQuitClanTime)

    if ex.Player.clan_data.clan_id ~= NULL_ID then
		-- 公会信息
		local req_clan_info = Clan_pb.GReqClanInfo()
		req_clan_info.clan_id = ex.Player.clan_data.clan_id
		NetManager:sendMessage(ProtocolID.GReqClanInfo, req_clan_info)

    	-- 公会操作相关信息
    	NetManager:sendMessage(ProtocolID.GReqClanReqMsgInfo)

    	-- 请求公会历史记录
    	NetManager:sendMessage(ProtocolID.GReqClanMsgInfo)

    	-- 请求公会科技列表
    	NetManager:sendMessage(ProtocolID.GReqClanSkillList)

    	-- 请求公会捐献列表
    	NetManager:sendMessage(ProtocolID.GReqClanDonateList)

		-- 请求公会boss
		NetManager:sendMessage(ProtocolID.GReqClanMissionInfo)

		-- 请求伤害排行
		NetManager:sendMessage(ProtocolID.GReqClanRankDamage)
    else
		local req_clan_info = Clan_pb.GReqClanInfo()
		req_clan_info.clan_id = 0
		NetManager:sendMessage(ProtocolID.GReqClanInfo, req_clan_info)
    end

    -- 好友列表
    NetManager:sendMessage(ProtocolID.GReqFriendsList)

	-- 好友申请列表
	NetManager:sendMessage(ProtocolID.GReqFriendsRequestList)

	-- 黑名单
	NetManager:sendMessage(ProtocolID.GReqBlackList)
	
	------------ 组对竞技场，初始获得时间
	NetManager:sendMessage(ProtocolID.GReqTeamArenaState)


	-- 发送召唤进度奖励协议
	NetManager:sendMessage(ProtocolID.GReqHeroSummonCount)

	-- 召唤英雄许愿购买情况
	NetManager:sendMessage(ProtocolID.GReqHeroPrayerData)
	
	-- 发送酒馆任务协议
	NetManager:sendMessage(ProtocolID.GReqPubTaskList)

	-- 发送更新许愿池协议
    NetManager:sendMessage(ProtocolID.GReqBlessingPoolList)

	-- 英雄装备
	NetManager:sendMessage(ProtocolID.GReqHeroEquip)

	-- 诸神遗迹
	NetManager:sendMessage(ProtocolID.GReqGodRelicData)

	-- 讨伐团
	ctr.crusade_group:requestGetInfo()

	--永恒梦境初始信息
	ex.Player.dream_data:gReqDreamlandData()


	ex.Player.dream_data:gReqFriendAssistHeroList()
	ex.Player.dream_data:gReqDreamlandBattleStatus()

	--冥域魔都请求数据
	ex.Player.underworld_pagoda_data:gReqHadesInfo()     -- 冥域魔都基础数据
	
	-- 国战
	ctr.country_war:gReqCountryWarTime()

	-- 独角兽
	ctr.alice.reqUnicornInfo()
	
	
--------------------------活动协议-------------------------------------------------
    -- 功能预告
    NetManager:sendMessage(ProtocolID.GReqNewGamePlayInfo)



	-- 先知英雄置换
	local req_prophet_change = ProphetSummon_pb.GReqProphetChange()
	req_prophet_change.hero_id = 0
	NetManager:sendMessage(ProtocolID.GReqProphetChange, req_prophet_change)

    NetManager:sendMessage(ProtocolID.GReqProphetSummonInfo)

    -- 签到
	ex.Player.promotion_data:reqSignInList()

    -- 每周福利
    --NetManager:sendMessage(ProtocolID.GReqWeekGiftList)
	
	-- 每月福利
    --NetManager:sendMessage(ProtocolID.GReqMouthWelfareList)
	
	-- 每日福利
    NetManager:sendMessage(ProtocolID.GReqDailyWelfareList)
	
    -- 积天豪礼
	ex.Player.promotion_data:reqRechargeDays()
	
	-- 98元累计充值
    ex.Player.promotion_data:reqRechargeReward()

    -- 月卡数据
	ex.Player.promotion_data:reqMonthCard()
    
    -- 限时礼包
    ex.Player.promotion_data:reqLimitGift()

    -- -- 每日首充
	-- ex.Player.promotion_data:reqDailyFirstRecharge()

	-- 超值首充
	ex.Player.promotion_data:reqRechargeFirst()

	--周向阳
	--超值赠礼
	ex.Player.promotion_data:reqGetSupreGiftData()

	-- 月度回馈计划
	ex.Player.promotion_data:reqMonthInvest()

	-- 特权礼包
	ex.Player.promotion_data:reqPrivilegeGift()

	-- ex.Player.promotion_data:reqAdventureList()
	ex.Player.promotion_data:reqAdventureRankList()

	-- ex.Player.promotion_data:reqSpeedFightList()
	ex.Player.promotion_data:reqSpeedFightRankList()

	-- ex.Player.promotion_data:reqTavernWeeklyList()
	ex.Player.promotion_data:reqTavernWeeklyRankList()

	--ex.Player.promotion_data:reqPvpWinsLists()

	ex.Player.promotion_data:clearInvitationList()
	ex.Player.promotion_data:reqInvitationList()

	-- 节日豪礼
	ex.Player.promotion_data:reqFestivalOvervalueGift()
	
	-- 测试
	-- 七日目标
	--ex.Player.seventdaytarget_data:gReqSevenDayTargetList()

	-- 每日累充
	--ex.Player.promotion_data:reqDailyTotalRechargeList()
	
	-- 布阵数据
	NetManager:sendMessage(ProtocolID.GReqLineUp)

	-- 快速战斗
	NetManager:sendMessage(ProtocolID.GReqQuickBattleInitData)

	-- 幻境之塔数据
	NetManager:sendMessage(ProtocolID.GReqTowerData)

	-- 邮件
	NetManager:sendMessage(ProtocolID.GReqMailList)

	-- 活动列表
	NetManager:sendMessage(ProtocolID.GReqPromotionList)

	-- PVP数据
	NetManager:sendMessage(ProtocolID.GReqPvpData)

	-- 点金
	NetManager:sendMessage(ProtocolID.GReqBuyGoldLog)

	-- 日常副本
	NetManager:sendMessage(ProtocolID.GReqDailyDungeonData)

	-- 无限塔奖励列表
	NetManager:sendMessage(ProtocolID.GReqTowerRewardList)

	-- PVP战斗历史
	NetManager:sendMessage(ProtocolID.GReqChapterRewardList)

	ex.Player:requestProtoc()

	-- 勇者试炼战斗列表
	NetManager:sendMessage(ProtocolID.GReqTrialBattleList)
	ex.Player.trial_data:gReqFriendAssistHeroList()
	
    -- 请求英雄避难所数据
	NetManager:sendMessage(ProtocolID.GReqDungeonInfo)

	NetManager:sendMessage(ProtocolID.GReqDungeonShopList)

	NetManager:sendMessage(ProtocolID.GReqDungeonTeam)

	NetManager:sendMessage(ProtocolID.GReqDungeonKillRewardList)

	NetManager:sendMessage(ProtocolID.GReqDungeonPropsList)

	NetManager:sendMessage(ProtocolID.GReqDungeonBuffList)

	NetManager:sendMessage(ProtocolID.GReqDungeonMonsterHpList)

	-- 羁绊
	NetManager:sendMessage(ProtocolID.GReqFetterList)

	-- 羁绊幻化
	NetManager:sendMessage(ProtocolID.GReqFashionData)
	-- 羁绊幻化任务
	NetManager:sendMessage(ProtocolID.GReqFashionTasks)

	-- 膜拜
	NetManager:sendMessage(ProtocolID.GReqRankWorshipList)

	-- 成长礼包
	NetManager:sendMessage(ProtocolID.GResVipDecorateReward)

	-- 头像框
	NetManager:sendMessage(ProtocolID.GReqBorderData)

	-- 头像
	NetManager:sendMessage(ProtocolID.GReqHeadPortraitList)

	-- 红点
	NetManager:sendMessage(ProtocolID.GReqMyBattleRed)

	-- 通行证
	NetManager:sendMessage(ProtocolID.GReqTrafficPermitList)

	--战队降临
	NetManager:sendMessage(ProtocolID.GReqTPermitList)

	NetManager:sendMessage(ProtocolID.GReqHeroJewel)

	NetManager:sendMessage(ProtocolID.GReqFetterContractInfo)
	
	-- 周末福利
	NetManager:sendMessage(ProtocolID.GReqWeekendGiftData)

	-- 皮肤
	NetManager:sendMessage(ProtocolID.GReqHeroFashionList)
	NetManager:sendMessage(ProtocolID.GReqHeroFashion)

	-- 神装探宝
	NetManager:sendMessage(ProtocolID.GReqScanGodEquipLottery)
	-- NetManager:sendMessage(ProtocolID.GReqScanGodEquipRecord)

	-- 英雄殿堂
	NetManager:sendMessage(ProtocolID.GReqHeroPalaceData)
	
	-- 圣龙
	NetManager:sendMessage(ProtocolID.GReqDragonScanInfo)

	-- 组队竞技场红点数据
	NetManager:sendMessage(ProtocolID.GReqTeamArenaRedState)

	-- 私人订制
	NetManager:sendMessage(ProtocolID.GReqCustomRewardData)

	-- 灵器数据
	NetManager:sendMessage(ProtocolID.GReqReikiEquipData)

	-- 灵器数据
	NetManager:sendMessage(ProtocolID.GReqHeroRollingData)

	-- 锦鲤
	NetManager:sendMessage(ProtocolID.GReqWeekendKoiInfo)

	-- 神谕
	NetManager:sendMessage(ProtocolID.GReqZSJTInfo)

	-- 超凡段位赛数据
	ex.Player.super_stage_data:reqInfo()
	
	-- 
	NetManager:sendMessage(ProtocolID.GReqFloatingIslandsTime)
	
	-- 时空魔塔数据
	NetManager:sendMessage(ProtocolID.GReqTimeTowerInfo)


	-- -- 异界冒险
	NetManager:sendMessage(ProtocolID.GReqSpaceTimeAdventureInfo)
    NetManager:sendMessage(ProtocolID.GReqFleetInfo)
 
	-- 图腾
	NetManager:sendMessage(ProtocolID.GReqTotemsInfoList)

	-- 请求英雄列表
	local req_hero_list = Hero_pb.GReqHeroList()
	req_hero_list.page = 1
	NetManager:sendMessage(ProtocolID.GReqHeroList, req_hero_list)

	-- 获取后台活动配置(ProtocolID.GReqRunningPromotion会在返回协议请求)
	ex.Player.promotion_data:reqServerActicityConfig()


	-- 聊天历史记录
	NetManager:sendMessage(ProtocolID.GReqFriendChatList)

    -- 魔方数据
	NetManager:sendMessage(ProtocolID.GReqTweakCube)

	-- 聊天信息
	NetManager:sendMessage(ProtocolID.GReqPrivateChatRoles)
	NetManager:sendMessage(ProtocolID.GReqChatNum)


	-- PVP战斗历史
	NetManager:sendMessage(ProtocolID.GReqPvpBattleHistoryList)


	-- 永恒梦境排行榜
	ex.Player.dream_data:gReqDreamlandRank()

	-- 位面之战
	ctr.plane_war:requestPlaneWar()
	
	ex.Player.hero_data.magic_wand:gReqHeroMagicWandList()
	-- ctr.hero_magic_wand:reqHeroMagicWandList()

	-- 幻魔塔
	ex.Player.magic_tower_data:reqData()
	
	--爱丽丝仙境
	ctr.alice:requestGetInfo()
end

function RoleResponse:reqList()

end

function RoleResponse:summonList(byte_array)

end

function RoleResponse:renameDone(data, byte_array)
	-- local data = NetManager:resLuaData(ProtocolResponse.ResRoleEditNick, byte_array)
	if data.revise_type == 0 then
		-- 改名成功
		ex.MessageView:add(ex.Tools:getLang(47346), 0)
		require("src.layer.RenameCtr"):instance():renameDone()
		require("src.platform.SocialPlatform"):submitRoleInfoLua("create_role")
		
		-- local req_role_info = ProtocolRequest.ReqRoleInfo
  --  		NetManager:sendLuaData(req_role_info)
  		NetManager:sendMessage(ProtocolID.GReqRoleInfo)
	elseif data.revise_type == 1 then
		ex.MessageView:add(ex.Tools:getLang(20124))
	elseif data.revise_type == 2 then
		ex.MessageView:add(ex.Tools:getLang(20127))
	end
end

function RoleResponse:changeNickDone(data)
	-- 改名成功
	ex.MessageView:add(ex.Tools:getLang(54107))
    ex.Player.nick = data.nick
    ex.MainSceneCtr:setNick(data.nick)
    cpp.MainSceneCtr:instance():renameDone()
	require("src.layer.ChangeNickCtr"):instance():renameDone()
	require("src.layer.SettingCtr"):instance():onChangeNickDone()
	require("src.platform.SocialPlatform"):submitRoleInfoLua("create_role")
end

function RoleResponse:playerInfo(data, byte_array)
	-- local data = NetManager:resLuaData(ProtocolResponse.ResPlayerInfo, byte_array)
	-- dump(data, "RoleResponse:playerInfo")
	require("src.layer.RoleInfoCtr"):instance():openWindow(data)
end

function RoleResponse:roleUpgrade(data, byte_array)
	local level_before = data.level_beford
	local level_current = data.level_current
	local now_exp = data.now_exp
	
	-- ex.Player.exp = now_exp
	ex.MainSceneCtr:setExp(level_current, ex.Player.exp)

	local award_list = {}

	-- local list_count = byte_array:readInt()
	-- for i=1,list_count do
	-- 	local data = {}
	-- 	data.item_id = byte_array:readInt64()
	-- 	data.item_type = byte_array:readInt()
	-- 	data.item_num = byte_array:readInt()
	-- 	ex.Player:addItem(data.item_type, data.item_num, data.item_id)
		
	-- 	table.insert(award_list, data)
	-- end

	for i,v in ipairs(data.list) do
		local data = {}
		data.item_id = v.id
		data.item_type = v.type
		data.item_num = v.num
		table.insert(award_list, data)
	end
	
	require("src.layer.RoleUpgradeCtr"):instance():openWindow(level_before, level_current, award_list)
	ex.Player.promotion_data:checkLevelUpAwardRedDot()
	
	NetManager:sendMessage(ProtocolID.GReqPromotionList)

	-- cpp.MainSceneCtr:instance():setLevel(level_current)
	-- if level_before < 15 and level_current >= 15 then
	-- 	-- cpp.NodeCtr:closeOtherWindow()
	-- 	require("src.layer.promotion.RechargeFirstCtr"):instance():openWindow()
	-- end
	ex.EventManager:fire(EVENT.BACKPACK_RES_CHANGE.ROLE_LEVEL, level_current)
	
	require("src.layer.guide.GuideLevelCtr"):instance():executeFile(data.level_beford, data.level_current)

	
	ex.Player.trial_data:checkRedDot()

	-- 冥域魔都红点检测
	if level_current == cfg.system.underworld_pagoda_2_level then
		ex.Player.underworld_pagoda_data:checkReddot(2)
	elseif level_current == cfg.system.underworld_pagoda_1_level then
		ex.Player.underworld_pagoda_data:checkReddot(1)
	end
end

function RoleResponse:inputCodeGift(data)
	local is_succeed = data.is_success > 0
	if is_succeed then
		ex.MessageView:add(ex.Tools:getLang(41028), 0) -- 兑换成功, 请查看邮件

		-- 邮件
		NetManager:sendMessage(ProtocolID.GReqMailList)
	else
		-- ex.MessageView:add(ex.Tools:getLang(41029)) -- 兑换失败, 兑换码无效
	end

	require("src.layer.InputCodeCtr"):instance():codeResult()
end

function RoleResponse:randNick(data, byte_array)
	-- local data = NetManager:resLuaData(ProtocolResponse.ResRoleRandNick, byte_array)
	ex.EventManager:fire(EVENT.RAND_NAME.RAND_NAME, data.nick)
end



function RoleResponse:offline(data, byte_array)
	-- require("src.layer.ConfirmCtr"):instance():openWindow()
	local str2 = ""
	if data.type == 1 then
		str2 = ex.Tools:getLang(41179)
	elseif data.type == 2 then
		str2 = ex.Tools:getLang(41180)
	end

	require("src.layer.ConfirmCtr"):instance():openWindow(ex.Tools:getLang(41177), str2, function()
			-- require("src.scene.UpdateSceneCtr"):instance():enterWithAnimation()
			local scene = cc.Director:getInstance():getRunningScene()
			scene:runAction(cc.CallFunc:create(function(  )
				require("src.scene.UpdateSceneCtr"):instance():enterWithAnimation()
			end))
			
	end, nil, nil, false, false)
	cpp.Game:instance():stopTheGame()
end


function RoleResponse:roleForbidChat(data)
	ex.Player.forbid_words_end_time = data.forbid_words_end_time
end

function RoleResponse:roleForbid(data)
	local str2 = string.format(ex.Tools:getLang(41187), os.date("%Y-%m-%d %H:%M:%S", data.forbid_end_time))
	require("src.layer.ConfirmCtr"):instance():openWindow(ex.Tools:getLang(41177), str2, function()
		-- require("src.scene.UpdateSceneCtr"):instance():enterWithAnimation()

		local scene = cc.Director:getInstance():getRunningScene()
		scene:runAction(cc.CallFunc:create(function(  )
			require("src.scene.UpdateSceneCtr"):instance():enterWithAnimation()
		end))

	end, nil, nil, false, false)
	cpp.Game:instance():stopTheGame()
end

function RoleResponse:error(data)
	local error_data = {}
	generator_protobuf_raw_table(data, error_data)
	local tip_config = cfg.tips.tips[error_data.error]

	local str_error = ""
	if tip_config == nil then
		str_error = tostring(error_data.error)
	else
		str_error = ex.Tools:getLang(error_data.error)
	end

	if table.nums(error_data.params) > 0 then
		str_error = str_error .. " |"
	end

	for i,v in ipairs(error_data.params) do
		str_error = str_error .. " " .. v
	end
	
	ex.MessageView:instance():add(str_error, 1)
end

function RoleResponse:roleUpdateAreaIdx(data)
	if data.area_id == nil or data.area_id <= 0 then
		ex.Player.area_idx = 1
	else
		ex.Player.area_idx = data.area_id
	end
end

function RoleResponse:worldLevel(data)
	ex.Player.world_level = data.level
	-- ex.Player.world_level = 65
end

function RoleResponse:newbieReward(data)
	ex.EventManager:fire(EVENT.BACKPACK_RES_CHANGE.FIRST_REWARD)
end


-- add 熊梦
-- 评论状态
function RoleResponse:commentSharedState(data)
	ex.Player.comment_list = data.list
	ex.EventManager:fire(EVENT.MAIN_CITY.REFRESH_BTN_STATUS)
--	dump(ex.Player.comment_list )
end


-- 评论有礼
function RoleResponse:commentSharedComment(data)
	ex.Player.comment_list = data.list
--	dump(ex.Player.comment_list )
	ex.EventManager:fire(EVENT.MAIN_CITY.REFRESH_BTN_STATUS)

end

-- 评论有礼
function RoleResponse:commentSharedReward(data)
	ex.Player.comment_list = data.list
--	dump(data.list)
	
	ex.EventManager:fire(EVENT.MAIN_CITY.REFRESH_BTN_STATUS)
end

-- 尊贵标识 开关
function RoleResponse:UpdatePeerageReward(data)
	ex.Player.peerage_status = data.status
end

-- 尊贵标识 弹窗
function RoleResponse:showActivePeerage(data)
	ex.Player.peerage_level = data.level
	local ctr = require("src.layer.SettingIdentificationCtr"):instance()
	ctr:openWindow(data.level)
end
--公会改名卡
function RoleResponse:clanChangeNickDone(data)
		-- 公会改名成功
		ex.MessageView:add(ex.Tools:getLang(54107))
		ex.Player.clan_data.clan_name = data.nick
		require("src.layer.ClanChangeNickCtr"):instance():renameDone()
end

return RoleResponse
