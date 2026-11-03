cfg.funcopen = {
	-- 主城
	["main_city"] = {
		["open"] = function (data)
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
		end
	},
	--工会导航界面
	["main_clan"] = {
		["open"] = function (data)
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.CLAN)
			if data ~= nil and data ~= "" then 
				--layer.changeLayer(layer,data)
			end
		end
	},
	--公会Boss战导航界面
	["main_clan_boss"] = {
		["open"] = function (data)
			if tonumber(ex.Player.clan_data.clan_id) <= 0 then
				ex.MessageView:add(ex.Tools:getLang(52001))
				return
			end
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.CLAN_BOSS)
			if data ~= nil and data ~= "" then 
				--layer.changeLayer(layer,data)
			end
		end
	},
	--公会战导航界面
	["main_clan_gvg"] = {
		["open"] = function (data)
			if tonumber(ex.Player.clan_data.clan_id) <= 0 then
				ex.MessageView:add(ex.Tools:getLang(70149))
				return
			end
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.CLAN_GVG)
			if data ~= nil and data ~= "" then 
				--layer.changeLayer(layer,data)
			end
		end
	},	
	-- 副本
	["main_mission_hall"] = {
		["open"] = function (data)
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_SLZM)
		end
	},
	-- 副本
	["main_mission"] = {
		["open"] = function (data)
			local backToLayer = data and data.backToLayer or nil
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MISSION,backToLayer)
		end
	},
	-- 金币(日常)副本
	["main_mission_gold"] = {
		["open"] = function (data)
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MISSION)
			layer.layer_type = 1
			layer.btn_gold:setChecked(true)
			layer:onChangeLayer()

		end
	},
	-- 经验(日常)副本
	["main_mission_exp"] = {
		["open"] = function (data)
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MISSION)
			layer.layer_type = 2
			layer.btn_gold:setChecked(false)
			layer.btn_exp:setChecked(true)
			layer:onChangeLayer()

		end
	},
	-- 英雄(日常)副本
	["main_mission_hero"] = {
		["open"] = function (data)
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MISSION)
			layer.layer_type = 3
			layer.btn_gold:setChecked(false)
			layer.btn_hero:setChecked(true)
			layer:onChangeLayer()

		end
	},
	-- 羁绊(日常)副本
	["main_mission_fetter"] = {
		["open"] = function (data)
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MISSION)
			layer.layer_type = 4
			layer.btn_gold:setChecked(false)
			layer.btn_fetter:setChecked(true)
			layer:onChangeLayer()

		end
	},
	-- 精灵(日常)副本
	["main_mission_runes"] = {
		["open"] = function (data)
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MISSION)
			layer.layer_type = 5
			layer.btn_gold:setChecked(false)
			layer.btn_runes:setChecked(true)
			layer:onChangeLayer()

		end
	},
	--英雄导航界面
	["main_hero"] = {
		["open"] = function (data)
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.HERO_LAYER)
		end
	},
	-- 圣龙
	["main_dragon"] = {
		["open"] = function (data)
			ex.MainSceneCtr:changeLayer(MainSceneType.HERO_LAYER)
			ex.MainSceneCtr:getCurLayer():changeLayer(3)
		end
	},
	-- 圣龙-鑒定
	["main_dragon_identify"] = {
		["open"] = function (data)
			local cur_layer = ex.MainSceneCtr:changeLayer(MainSceneType.HERO_LAYER)
			cur_layer:changeLayer(3)
			if cur_layer.layer_dragon ~= nil then
				cur_layer.layer_dragon:changeLayer(10)
			end
		end
	},
	-- 圣龙-聖龍
	["main_dragon_info"] = {
		["open"] = function (data)
			local cur_layer = ex.MainSceneCtr:changeLayer(MainSceneType.HERO_LAYER)
			cur_layer:changeLayer(3)
			if cur_layer.layer_dragon ~= nil then
				cur_layer.layer_dragon:changeLayer(20)
			end
		end
	},
	--战斗导航界面
	["main_battle"] = {
		["open"] = function (data)
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MLT_BATTLE)
			if data ~= nil and data ~= "" then 
				if layer[data] then 
					local callback = layer[data]
					callback(layer)
				end
			end

		end
	},
	-- 地牢
	["main_dungeon"] = {
		["open"] = function (data)
			local status = ex.Player.dungeon_data:getOpenStatus()
			if status == 1 then
				ex.MessageView:add("月神庇护所还未开启")
			elseif status == 2 then
				ex.MessageView:add("月神庇护所已关闭")
			else
				local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_DUNGEON)
			end
		end
	},
	-- 异界冒险
	["main_exotic_adventure"] = {
		["open"] = function (data)
			ex.Player.exotic_adventure_data:sendFleet()
			if ex.Player.exotic_adventure_data.not_route ~= 0 then
				local layer = ex.MainSceneCtr:changeLayer(MainSceneType.EXOTIC_ADVENTURE_SAILING)
			else
				local layer = ex.MainSceneCtr:changeLayer(MainSceneType.EXOTIC_ADVENTURE)
			end
			--require("src.layer.exoticadventure.ExoticAdventureLayer"):instance():openWindow()
		end
	},
	-- 英雄殿堂
	["main_hero_palace"] = {
		["open"] = function (data)
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_HERO_PALACE)
		end
	},
	-- 创造法阵
	["main_hero_make"] = {
		["open"] = function (data)
			-- local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
			-- require("src.layer.HeroCreatCtr"):instance():openWindow()
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.HERO_CREAT_LAYER)
		end
	},
    --魔方
	["main_magic_cube"] = {
		["open"] = function (data)
			ex.MainSceneCtr:changeLayer(MainSceneType.MAIN_MAGIC_CUBE)
		end
	},
	-- 召唤法阵
	["main_summon"] = {
		["open"] = function (data)
			local backToLayer = data and data.backToLayer or nil

			ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_SUMMON, backToLayer)
		end
	},
	-- 召唤法阵许愿
	["main_summon_wish"] = {
		["open"] = function (data)
			require("src.layer.SummonHeroPrayerCtr"):instance():openWindow()
		end
	},
	-- 许愿池
	["main_blessingpool"] = {
		["open"] = function (data)
			local backToLayer = data and data.backToLayer or nil

			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_BLESSING_POOL, backToLayer)
			if data ~= nil and data ~= "" then 
				--layer.changePool(layer,data)
			end
		end
	},

	-- 商店
	["main_shop"] = {
		["open"] = function (layer_type, callback)

			local backToLayer = nil
			if layer_type ~= nil and type(layer_type) ~= "number" then
				backToLayer = layer_type.backToLayer or nil
			end

			if not layer_type or layer_type == "" then 
				if ex.MainSceneCtr:getCurLayerType() ~= MainSceneType.MAINCITY_LAYER then
					ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
				end
				layer_type = SHOP_TYPE.MARKET
			end

			local data = ex.Player.market_data:getMarketDataByType(layer_type)
			if data == nil then
				layer_type = SHOP_TYPE.MARKET
				data = ex.Player.market_data:getMarketDataByType(SHOP_TYPE.MARKET)
			end
			-- local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
			if layer_type == SHOP_TYPE.PROMOTION or layer_type == SHOP_TYPE.HERO then
				if data[1] ~= nil then data[1].is_special = true end
				if data[2] ~= nil then data[2].is_special = true end
				require("src.layer.shop.PromotionShopCtr"):instance():openWindow(data)
			elseif layer_type == SHOP_TYPE.MARKET  then
				local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_MARKETSHOP, backToLayer)
				if layer ~= nil then
					layer:onSetCallBack(callback)
				end
			elseif layer_type == SHOP_TYPE.PROPHECY then
				require("src.layer.shop.ProphetTreeShopCtr"):instance():openWindow(data)
			elseif layer_type == SHOP_TYPE.TALENT then
				require("src.layer.shop.HeroTalentShopCtr"):instance():openWindow(data)
			elseif layer_type == SHOP_TYPE.GOD_EQUIP then
				require("src.layer.shop.GodEquipShopCtr"):instance():openWindow(data)
			elseif layer_type == SHOP_TYPE.CHAMPION then
				require("src.layer.shop.ChampionShopCtr"):instance():openWindow(data)
			else 
				require("src.layer.shop.ShopCtr"):instance():openWindow(data)
			end 
			
		end
	},

	-- 英雄-天赋商城
	["main_talent_shop"] = {
		["open"] = function ()
			local data = ex.Player.market_data:getMarketDataByType(SHOP_TYPE.TALENT)
			require("src.layer.shop.HeroTalentShopCtr"):instance():openWindow(data)
		end
	},

	-- 英雄-神装商城
	["main_god_equip_shop"] = {
		["open"] = function ()
			local data = ex.Player.market_data:getMarketDataByType(SHOP_TYPE.GOD_EQUIP)
			require("src.layer.shop.GodEquipShopCtr"):instance():openWindow(data)
		end
	},

	-- 竞技场商城
	["main_pvp_shop"] = {
		["open"] = function ()
			cfg.funcopen.main_shop.open(SHOP_TYPE.PVPNORMAL)
		end
	},

	-- 试炼商城
	["main_trial_shop"] = {
		["open"] = function ()
			cfg.funcopen.main_shop.open(SHOP_TYPE.ADVENTURE)
		end
	},

	-- 天梯商城
	["main_ladder_shop"] = {
		["open"] = function ()
			cfg.funcopen.main_shop.open(SHOP_TYPE.LADDER)
		end
	},

	---------------------------------------------------------------------------------
	-- 铁匠铺-装备锻造
	["main_smith_shop"] = {
		["open"] = function (data)
			local backToLayer = data and data.backToLayer or nil

			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_SMITH, backToLayer)
			layer:changeLayer(ActivityPanelIdxType.SMITH_SHOP)
		end
	},
	-- 铁匠铺-精灵合成
	["main_smith_shop_sprite"] = {
		["open"] = function (data)
			local backToLayer = data and data.backToLayer or nil

			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_SMITH, backToLayer)
			layer:changeLayer(ActivityPanelIdxType.SMITH_SHOP_SPRITE)
		end
	},
	-- 铁匠铺-宝石合成
	["main_smith_shop_gem"] = {
		["open"] = function (data)
			local backToLayer = data and data.backToLayer or nil

			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_SMITH, backToLayer)
			layer:changeLayer(ActivityPanelIdxType.SMITH_SHOP_GEM)
		end
	},
	-- 铁匠铺-神装升星
	["main_smith_shop_god_equip"] = {
		["open"] = function (data)
			local backToLayer = data and data.backToLayer or nil

			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_SMITH, backToLayer)
			layer:changeLayer(ActivityPanelIdxType.SMITH_SHOP_GOD_EQUIP)
		end
	},
	---------------------------------------------------------------------------------

	-- 酒馆派遣
	["main_pub_task"] = {
		["open"] = function (data)
			-- local backToLayer = data and data.backToLayer or nil
			--  local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_PUB_TASK, backToLayer)
			require("src.layer.MainTaskCtr"):instance():openWindow()


		end
	},

	-- 祭献
	["main_altar"] = {
		["open"] = function (data)
			local backToLayer = data and data.backToLayer or nil

			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_ALTAR, backToLayer)
		end
	},
	--祭坛重生
	["act_altar_reborn"] = {
		["open"] = function (data)
			local backToLayer = data and data.backToLayer or nil

			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_ALTAR, backToLayer)
			layer:changeLayer(ActivityPanelIdxType.ALTAR_RESET)
		end
	},

	
	
	-- 先知之树
	["main_prophet_tree"] = {
		["open"] = function (data)
			local backToLayer = data and data.backToLayer or nil

			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_PROPHET_TREE, backToLayer)
			if data ~= nil and data ~= "" then 
				print(data,"main_prophet_tree")
				--layer.changeLayer(layer,data)
			end
		end
	},

	-- 英雄置换
	["main_hero_pernute"] = {
		["open"] = function (data)
			local backToLayer = data and data.backToLayer or nil

			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_HERO_PERNUTE, backToLayer)
		end
	},


	-- 英雄置换
	["main_hero_rollback"] = {
		["open"] = function (data)
			local backToLayer = data and data.backToLayer or nil

			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_HERO_PERNUTE, backToLayer)
			layer.onToHeroBack(layer)
		end
	},

	-- 跨服时空
	["main_fantasy_land"] = {
		["open"] = function (data)
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.LEAGUE_PORTAL)
		end
	},

	-- 天梯争霸
	["main_ladder_war"] = {
		["open"] = function (data)
			ex.Player.league_data:reqLadderInfo()
			
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.LADDER_WAR_MAIN)
			if layer ~= nil then
				layer:onCreateDone()
			end
		end
	},
	-- 竞技场
	["main_pvp"] = {
		["open"] = function (data)
			local layer = ex.MainSceneCtr:getKeepBuffer(MainSceneType.MAINCITY_PVP_BATTLE)
			if layer then
				ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_PVP_BATTLE, nil, nil, true)
			else
				local cur_type = ex.MainSceneCtr:getCurLayerType()
				if cur_type ~= MainSceneType.MAINCITY_LAYER then
					ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
				end
		        require("src.layer.PvpCtr"):instance():openWindow()
		    end
		    ex.Tools:autoPlaySceneMusic()
		end
	},
	-- 冠军赛点赞首页
	["main_champion_like"] = {
		["open"] = function (data)
			ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_CHAMPIONSHIP_LIKE)
		end
	},
	-- 冠军赛个人赛季界面。
	["main_champion_notcheck"] = {
		["open"] = function (data)
			ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_CHAMPIONSHIP)
		end
	},
	-- 冠军赛
	["main_champion"] = {
		["open"] = function (data)
			ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_CHAMPIONSHIP)
		end,
		["isVisible"] = function ()
			local now_day = Maths.getDays(cpp.Game:instance():getServerTime())
			local begin_day = Maths.getDays(ex.Player.champion_data.battle_start_time)
			return now_day == begin_day
		end,
		-- 如果是需要倒计时的活动入口，则实现这个接口，获取结束时间，-1则一直存在		
		["getEndTime"] = function ()
			local now = cpp.Game:instance():getServerTime()
			local cur_date = os.date("*t", now)
			local cur_date = os.time({year=cur_date.year, month=cur_date.month, day=cur_date.day, hour=23,min=59,sec=59})
			return cur_date
		end,
		-- 如果是需要倒计时的活动入口，则实现这个接口，获取结束时间显示字符串
		["getTimeTipString"] = function ()
			local cur_time = ex.Game:getServerTime()
			local battle_status = ex.Player.champion_data:getBattleStatus()
			if battle_status == ChampionType.NOT_START then
				return ex.StringUtil.convertToHowLongHour(ex.Player.champion_data.battle_start_time - cur_time) .. ex.Tools:getLang(1342)
			elseif battle_status == ChampionType.END then
				return ex.Tools:getLang(41159)
			end
			return ((ex.Player.champion_data.period == 2 and ex.Player.champion_data.battle_round == 1) or ex.Player.champion_data.period == 0) and ex.Tools:getLang(41159) or ex.Tools:getLang(5778)
		end
	},

	-- 组对竞技场
	["main_team_arena"] = {
		["open"] = function (data)
			ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_TEAM_ARENA)
		end
	},



	-- 跨服冠军赛点赞首页
	["main_champion_cross_like"] = {
		["open"] = function (data)
			ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_CHAMPIONCROSS_LIKE)
		end
	},
	-- 冠军赛个人赛季界面。
	["main_champion_cross_notcheck"] = {  
		["open"] = function (data)
			ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_CHAMPIONCROSS)
		end
	},
	-- 冠军赛
	["main_champion_cross"] = {
		["open"] = function (data)
			ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_CHAMPIONCROSS)
		end,
		["isVisible"] = function ()
			local now_day = Maths.getDays(cpp.Game:instance():getServerTime())
			local begin_day = Maths.getDays(ex.Player.championcross_data.battle_start_time)
			return now_day == begin_day
		end,
		-- 如果是需要倒计时的活动入口，则实现这个接口，获取结束时间，-1则一直存在		
		["getEndTime"] = function ()
			local now = cpp.Game:instance():getServerTime()
			local cur_date = os.date("*t", now)
			local cur_date = os.time({year=cur_date.year, month=cur_date.month, day=cur_date.day, hour=23,min=59,sec=59})
			return cur_date
		end,
		-- 如果是需要倒计时的活动入口，则实现这个接口，获取结束时间显示字符串
		["getTimeTipString"] = function ()
			local cur_time = ex.Game:getServerTime()
			local battle_status = ex.Player.championcross_data:getBattleStatus()
			if battle_status == ChampionType.NOT_START then
				return ex.StringUtil.convertToHowLongHour(ex.Player.championcross_data.battle_start_time - cur_time) .. ex.Tools:getLang(1342)
			elseif battle_status == ChampionType.END then
				return ex.Tools:getLang(41159)
			end
			return ((ex.Player.championcross_data.period == 2 and ex.Player.championcross_data.battle_round == 1) or ex.Player.championcross_data.period == 0) and ex.Tools:getLang(41159) or ex.Tools:getLang(5778)
		end
	},
	["main_champion_cross_shop"] = {
		["open"] = function (data)
			cfg.funcopen.main_shop.open(SHOP_TYPE.CHAMPION)
		end,
	},
	--勇者试炼->副本大厅->勇者试炼
	["main_proving_lang"] = {
		["open"] = function (data)
			local backToLayer = data and data.backToLayer or nil
			-- 由于勇者试炼有难度设置，涉及跨天刷新，改为没有直接跳转到勇者试炼的，全部跳转到副本大厅
			-- local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_TRIAL, backToLayer)
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_SLZM, backToLayer)
		end
	},
	--勇者试炼->副本大厅->永恒梦境
	["main_infinite"] = {
		["open"] = function (data)
			local backToLayer = data and data.backToLayer or nil
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.DREAM_LAYER, backToLayer)
		end
	},

	--幻境之塔
	["main_fantasy_tower"] = {
		["open"] = function (data)
			local backToLayer = data and data.backToLayer or nil
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_FANTASY_TOWER, backToLayer)
		end
	},

	--幻魔塔
	["magic_tower"] = {
		["open"] = function (data)
			-- 如果幻境之塔层数未达到指定层数，则弹出提示
			if cfg.system.magic_tower_open_day > cc.exports.GetAfterDaysForTime(ex.Player.server_create_time) then
				return false
			end

			local stage_need = ex.Tools:getSysCfg("magic_tower_level_need")
			if stage_need >= ex.Player.tower_data:getNowStage() then
				ex.MessageView:add(string.format(ex.Tools:getLang(57545), stage_need))
				return false
			end
		
			local backToLayer = data and data.backToLayer or nil
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_MAGIC_TOWER, backToLayer)

			return true
		end,
		["isVisible"] = function()
			local flag = ex.JumpManager:checkOpenConditionByAtomNoMsg("magic_tower") and 
						cfg.system.magic_tower_open_day <= cc.exports.GetAfterDaysForTime(ex.Player.server_create_time)
			return flag
		end
	},

	--幻魔塔购买斩魔王者
	["magic_tower_buy_king"] = {
		["open"] = function (data)
			if cfg.funcopen.magic_tower.isVisible() then
				if cfg.funcopen.magic_tower.open() then
					ex.JumpManager:jumpByAtom("magic_tower")

					require("src.layer.magictower.MagicTowerRewardCtr"):instance():openWindow(2)
					require("src.layer.magictower.MagicTowerKingUnlockCtr"):instance():openWindow()
				end
			end
		end
	},

	-- 彩虹圣殿
	["main_chsd"] = {
		["open"] = function (data)
			ex.Player.rainbow_data:reqRainbowInfo()

			local backToLayer = data and data.backToLayer or nil
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_CHSD, backToLayer)
			if layer ~= nil then
				layer:onCreateDone()
			end
		end
	},

	-- 好友
	["main_friend"] = {
		["open"] = function (data)
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
			local num = ex.Player:getItemNum(ItemType.IT_FRIEND_SHIP_POINT)

			require("src.layer.friend.FriendCtr"):instance():openWindow()
		end
	},

	-- 邮件
	["main_mail"] = {
		["open"] = function (data)
			require("src.layer.MailCtr"):instance():openWindow()
		end
	},

	-- 聊天
	["main_chat"] = {
		["open"] = function (data)
			local chat_type = {ChatLayerType.CLT_CITY, ChatLayerType.CLT_SERVER, ChatLayerType.CLT_WORLD, ChatLayerType.CLT_CLAN, ChatLayerType.CLT_FRIEND, ChatLayerType.CLT_SYSTEM}

			-- 国战聊天
			if ex.JumpManager:checkOpenConditionByAtomNoMsg("main_country_war") 
			and ctr.country_war.data:getStage() == COUNTRY_WAR_STATE.BATTLE
			and ctr.country_war.data:getHadjoin() then
				table.insert(chat_type, ChatLayerType.CLT_COUNTRYWAR)
			end

			-- focus_type : 聊天类型  大于7的聊天类型 打开会做滑动到当前位置的处理
			local focus_type = data ~= nil and data.focus_type ~= nil and data.focus_type or nil or nil
			
			require("src.layer.ChatCtr"):instance():openWindow(chat_type,focus_type)
		end
	},

	-- 排行榜
	["main_rank"] = {
		["open"] = function (data)
			require("src.layer.RankListCtr"):instance():openWindow()
		end
	},
	-- 英雄推荐
	["main_hero_recommend"] = {
		["open"] = function (data)

			-- local hero_recommend_ctr = require("src.layer.heroinfo.HeroRecommendCtr"):instance()
			-- hero_recommend_ctr.cur_hero_elem = ElemType.ALL
			-- hero_recommend_ctr:openWindow()

			local hero_suggest_ctr = require("src.layer.heroinfo.HeroSuggestCtr"):instance()
			hero_suggest_ctr:openWindow()
		end
	},
	-- 商店
	["main_black_market"] = {
		["open"] = function (data)
			-- local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
			-- require("src.layer.BlackMarketCtr"):instance():openWindow()
			local backToLayer = data and data.backToLayer or nil

			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_BLACKMARKETSHOP, backToLayer)
			
		end
	},
	-- 商店
	["main_black_market_stage"] = {
		["open"] = function (data)
			-- local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
			-- require("src.layer.BlackMarketCtr"):instance():openWindow()
			local backToLayer = data and data.backToLayer or nil

			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_BLACKMARKETSHOP, backToLayer)
			layer:onChange(SHOP_TYPE.SUPERSTAGE)
		end
	},
	-- 商店
	["main_black_market_time_tower"] = {
		["open"] = function (data)
			local backToLayer = data and data.backToLayer or nil

			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_BLACKMARKETSHOP, backToLayer)
			layer:onChange(SHOP_TYPE.SPACE_TIME_MAGIC_TOWER)
		end
	},
	-- 商店-浮空岛
	["main_black_market_floating_islands"] = {
		["open"] = function (data)
			local backToLayer = data and data.backToLayer or nil
	
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_BLACKMARKETSHOP, backToLayer)
			layer:onChange(SHOP_TYPE.FLOATING_ISLANDS)
		end
	},
	-- 羁绊
	["main_fetter"] = {
		["open"] = function (data)
		local unlock = ex.Player.fetter_data:isUnlockAll()
		local layer_type = unlock and MainSceneType.FETTER_INFO or MainSceneType.FETTER_MAIN_VIEW
		local layer = ex.MainSceneCtr:changeLayer(layer_type)
		end
	},
	-- 录像馆
	["main_video_studio"] = {
		["open"] = function (data)
			require("src.layer.videostudio.VideoStudioCtr"):instance():openWindow()
		end
	},
	-- 商店-异界冒险
	["main_black_market_exotic_adventure"] = {
		["open"] = function (data)
			local backToLayer = data and data.backToLayer or nil
	
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_BLACKMARKETSHOP, backToLayer)
			layer:onChange(SHOP_TYPE.EXOTIC_ADVENTURE)
		end
	},
	---------------------------------------------------------------------------------
	-- 福利窗口
	-- 福利
	["act_welfare"] = {
		["open"] = function (data)
			local backToLayer = data and data.backToLayer or nil
			local select_idx = 0
			if data and data.__select_idx then
				select_idx = data.__select_idx
			end

		    local vec_idx = ex.Player.promotion_data:getPromotionByType(RechargeKindType.PROMOTION)
		    local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_DAILY_CHECK, backToLayer)
			layer:initWithTable(nil, vec_idx, select_idx)
			
			return layer
		end
	},
	-- 签到
	["act_sign_in"] = {
		["open"] = function (data)
			local info = data or {}
			info.__select_idx = ActivityPanelIdxType.WELFARE_SIGN_IN

			return cfg.funcopen["act_welfare"]["open"](info)
		end
	},
	-- 月卡
	["act_month_card_normal"] = {
		["open"] = function (data)
			local info = data or {}
			info.__select_idx = ActivityPanelIdxType.WELFARE_MONTH_CARD

			return cfg.funcopen["act_welfare"]["open"](info)
		end
	},
	-- 至尊月卡
	["act_month_card"] = {
		["open"] = function (data)
		    local info = (data == nil or data == "") and {} or data
			info.__select_idx = ActivityPanelIdxType.WELFARE_MONTH_CARD_SUPER

			return cfg.funcopen["act_welfare"]["open"](info)
		end
	},
	-- 超级英雄商城（秘境商城）
	["act_super_hero"] = {
		["open"] = function (data)
			local info = data or {}
			info.__select_idx = ActivityPanelIdxType.WELFARE_SUPER_HERO

			return cfg.funcopen["act_welfare"]["open"](info)
		end
	},
	-- 每周福利
	["act_week_gift"] = {
		["open"] = function (data)
			local info = data or {}
			info.__select_idx = ActivityPanelIdxType.WELFARE_WEEK_GIFT

			return cfg.funcopen["act_welfare"]["open"](info)
		end
	},
	-- 每月福利
	["act_month_gift"] = {
		["open"] = function (data)
			local info = data or {}
			info.__select_idx = ActivityPanelIdxType.WELFARE_MONTH_GIFT

			return cfg.funcopen["act_welfare"]["open"](info)
		end
	},
	-- 成长基金
	["act_growth_fund"] = {
		["open"] = function (data)
			local info = data or {}
			info.__select_idx = ActivityPanelIdxType.WELFARE_GROWTH_FUND

			return cfg.funcopen["act_welfare"]["open"](info)
		end
	},
	-- 连充福利
	["act_continuity_welfare"] = {
		["open"] = function (data)
			local info = data or {}   
			info.__select_idx = ActivityPanelIdxType.WELFARE_CONTINUITY_WELFARE

			return cfg.funcopen["act_welfare"]["open"](info)
		end
	},
	-- 积天豪礼
	["act_recharge_day_reward"] = {
		["open"] = function (data)
			local info = data or {}
			info.__select_idx = ActivityPanelIdxType.WELFARE_RECHARGE_DAY_REWARD

			return cfg.funcopen["act_welfare"]["open"](info)
		end
	},
	-- 邀请有礼
	["act_invitation"] = {
		["open"] = function (data)
			local info = data or {}
			info.__select_idx = ActivityPanelIdxType.WELFARE_INVITATION

			return cfg.funcopen["act_welfare"]["open"](info)
		end
	},
	---------------------------------------------------------------------------------



	-- 七天登录
	["act_sevent_day_gift"] = {
		["open"] = function (data)
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
			require("src.layer.SevenDayGiftCtr"):instance():openWindow(data)
		end,
		["isVisible"] = function ()
			-- local cur_time = ex.Game:getServerTime()
			-- local end_time = ex.Player.seventdaytarget_data:getLoginEndTime()
			-- return cur_time < end_time
			local _, is_show = ex.Tools:getMainCityBtnStatus("act_sevent_day_gift")
			return is_show and ex.Player.seven_login_data:loginGiftIsOpen()
		end
	},

	-- 七日圣诞
	["act_sevent_day_christmass_gift"] = {
		["open"] = function (data)
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
			require("src.layer.promotion.SevenDayChristmasCtr"):instance():openWindow(data)
		end,
		["isVisible"] = function ()
			ex.Player.promotion_data:checkfestivanewRedDot( )
			return ex.Player.promotion_data:checkFestivalLoginDayISOpen( )
			
		end
	},

	---------------------------------------------------------------------------------
	-- 超级首充
	["act_recharge_first"] = {
		["open"] = function (data)
			local select_idx = 0
			if data and data.__select_idx then
				select_idx = data.__select_idx
			end

		    --ex.RedDotManager:setSpecialVisible(RedDotType.ZCJ_DHZC_ZCCZSC, false)
		    require("src.layer.promotion.RechargeFirstCtr"):instance():openWindow(select_idx)
		end,
		["isVisible"] = function ()
			local _, is_show = ex.Tools:getMainCityBtnStatus("act_recharge_first")
			return is_show and not ex.Player.promotion_data:isRechargeFirstOver()
		end
	},
	-- 超级首充-第一档
	["act_recharge_first_one"] = {
		["open"] = function (data)
			local info = data or {}
			info.__select_idx = ActivityPanelIdxType.RECHARGE_FIRST_ONE

			return cfg.funcopen["act_recharge_first"]["open"](info)
		end,
		["isVisible"] = function ()
			return cfg.funcopen["act_recharge_first"]["isVisible"]()
		end
	},
	-- 超级首充-第二档
	["act_recharge_first_two"] = {
		["open"] = function (data)
			local info = data or {}
			info.__select_idx = ActivityPanelIdxType.RECHARGE_FIRST_TWO

			return cfg.funcopen["act_recharge_first"]["open"](info)
		end,
		["isVisible"] = function ()
			return cfg.funcopen["act_recharge_first"]["isVisible"]()
		end
	},

	---------------------------------------------------------------------------------

	--周向阳
	--超值赠礼
	["act_supre_gift"] = {
		["open"] = function (data)
		    require("src.layer.promotion.PROMSuperGiftCtr"):instance():openWindow()
		end,
		["isVisible"] = function ()
			local isvisible = ex.Player.promotion_data:checkSupreGiftIsOpen()
			local type_list = ex.Player.promotion_data:typeList()

			if type_list ~= nil and #type_list >= 2 then
				if type_list[1].status == 1 and type_list[2].status == 1 then
					isvisible = false
				end	
			end 
			return isvisible
		end
	},
	
	---------------------------------------------------------------------------------

	--新春活动
	["act_new_year"] = {
		["open"] = function (data)
		    --ex.RedDotManager:setSpecialVisible(RedDotType.ZCJ_DHZC_ZCCZSC, false)
		    require("src.layer.newyear.NewYearHallCtr"):instance():openWindow()
		end,
		["isVisible"] = function ()
			-- local _, is_show = ex.Tools:getMainCityBtnStatus("act_recharge_first")
			-- return is_show and not ex.Player.promotion_data:isRechargeFirstOver()
			local open_data =ex.Player.promotion_data.new_year_data:getOpenData()
			if not open_data then return false end 
			local end_time = ex.Player.promotion_data.new_year_data:getRemainTime()
			local start_time = ex.Game:getServerTime() >= open_data.start_time
			return start_time and end_time > 0
		end
	},

	--战队降临
	["act_war_order"] = {
		["open"] = function (data)
		    require("src.layer.promwarorder.PROMWarOrderHallCtr"):instance():openWindow()
		end,
		["isVisible"] = function ()
			local open_data =ex.Player.promotion_data.prom_war_order_data:getOpenData()
			if not open_data then return false end 
			local end_time = ex.Player.promotion_data.prom_war_order_data:getRemainTime()
			local start_time = ex.Game:getServerTime() >= open_data.start_time
			return start_time and end_time > 0
		end
	},

	--限时礼包
	["act_limit_gift"] = {
		["open"] = function (data)
			if table.nums(ex.Player.promotion_data.limit_gift) <= 0 then
				return
			end
			
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LIMIT_GIFT)
		end,
		["isVisible"] = function ()
			return ex.Player.promotion_data:limitGiftIsOpen()
		end
	},

	-- 七日目标
	["act_sevent_day_target"] = {
		["open"] = function (data)
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.SEVEN_DAY_TARGET_LAYER)
		end,
		["isVisible"] = function ()

			-- TOFIX 提交了临时代码。导致功能不正常。暂时屏蔽掉
			-- if true then
			-- 	return false  
			-- end

			local red = ex.Player.seventdaytarget_data:checkLoginRedPoint()
			-- ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZCQTDL,red)
		
			local box_red = ex.Player.seventdaytarget_data:getBoxRedPoint()
			red = red or box_red
			ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZCQTMB, red)

			-- local cur_time = ex.Game:getServerTime()
			-- local end_time = ex.Player.seventdaytarget_data:getEndTime() or 0

			local _, is_show = ex.Tools:getMainCityBtnStatus("act_sevent_day_target")

			local  btime = ex.Player.promotion_data:checkDayTargetIsOpen() 

			return is_show and btime
		end
	},

	---------------------------------------------------------------------------------
	-- 每日首充
	["act_day_first_recharge"] = {
		["open"] = function (data)
			local select_idx = 0
			if data and data.__select_idx then
				select_idx = data.__select_idx
			end

			require("src.layer.promotion.DailyFirstRechargeCtr"):instance():openWindow(select_idx)
		end,
		["isVisible"] = function ()
			local _, is_show = ex.Tools:getMainCityBtnStatus("act_day_first_recharge")
			return is_show and ex.Player.promotion_data:checkDailyFirstRechargeIsOpen()
		end
	},
	-- 每日首充-第一档
	["act_day_first_recharge_one"] = {
		["open"] = function (data)
			local info = data or {}
			info.__select_idx = ActivityPanelIdxType.DAILY_FIRST_RECHARGE_ONE

			return cfg.funcopen["act_day_first_recharge"]["open"](info)
		end,
		["isVisible"] = function ()
			return cfg.funcopen["act_day_first_recharge"]["isVisible"]()
		end
	},
	-- 每日首充-第二档
	["act_day_first_recharge_two"] = {
		["open"] = function (data)
			local info = data or {}
			info.__select_idx = ActivityPanelIdxType.DAILY_FIRST_RECHARGE_TWO

			return cfg.funcopen["act_day_first_recharge"]["open"](info)
		end,
		["isVisible"] = function ()
			return cfg.funcopen["act_day_first_recharge"]["isVisible"]()
		end
	},
	---------------------------------------------------------------------------------
	
	-- 日常成就
	["act_achievement"] = {
		["open"] = function (data)
			-- 更新等级限制问题
			ex.Player.achievement_data:updateDailyRedPoint()

			-- local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
			require("src.layer.AchievementCtr"):instance():openWindow()
		end
	},

	-- 英雄降临
	["act_hero_arrive"] = {
		["open"] = function (data)
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
			require("src.layer.HeroArriveCtr"):instance():openWindow()
		end,
		["isVisible"] = function ()
			local _, is_show = ex.Tools:getMainCityBtnStatus("act_hero_arrive")
			return is_show and ex.Player.heroarrive_data:isOpenAct()
		end,
		["getEndTime"] = function ()
			return ex.Player.heroarrive_data:getEndTime() or 0
		end,
		["getTimeTipString"] = function ()
			local time = ex.Player.heroarrive_data:getEndTime() or 0

			local d, h, m, s = ex.Tools:formatTime(math.max(time - ex.Game:getServerTime(), 0))
            local str_format = "%02d:%02d:%02d"
            return string.format(str_format, d * 24 + h, m, s)
		end
	},

	
	-- 月度反馈
	["act_month_invest"] = {
		["open"] = function (data) 
			ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_MONTH_INVEST)
		end,
		["isVisible"] = function ()
			local _, is_show = ex.Tools:getMainCityBtnStatus("act_month_invest")
			return is_show and ex.Player.promotion_data:monthInvestIsOpen()
		end,
		["getEndTime"] = function ()
			if ex.Player.promotion_data.month_invest_status == 1 then	-- 已购买，不显示时间
				return -1
			end

			return ex.Player.promotion_data.month_invest_end_time or 0
		end,
		["getTimeTipString"] = function ()
			if ex.Player.promotion_data.month_invest_status == 1 then	-- 已购买，不显示时间
				return -1
			end

			local time = ex.Player.promotion_data.month_invest_end_time or 0

			local d, h, m, s = ex.Tools:formatTime(math.max(time - ex.Game:getServerTime(), 0))
            local str_format = "%02d:%02d:%02d"
            return string.format(str_format, d * 24 + h, m, s)
		end
	},

	-- 在线奖励
	["act_online_reward"] = {
		["open"] = function (data)
			-- local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
			require("src.layer.onlinereward.OnlineRewardCtr"):instance():openWindow()
		end,
		["isVisible"] = function ()
			local _, is_show = ex.Tools:getMainCityBtnStatus("act_online_reward")
			return is_show and ex.Player.onlineReward_data:isOpen()
		end
	},

	-- 限时活动
	["act_limit_time_activity"] = {
		["open"] = function (data)
			data = data or {}
			local select_idx = data.select_idx ~= nil and data.select_idx or 0

		    local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LIMIT_TIME_ACTIVITY)
		    local vec_idx = ex.Player.promotion_data:getPromotionByType(PromotionPageType.LIMIT_TIME_ACTIVITY)
		    local tab = {}
		    tab.cell_size = cc.size(168.0, 120.0)
		    tab.margin = 10
		    tab.view_size = cc.size(tab.cell_size.width * table.nums(vec_idx) + (table.nums(vec_idx) + 1) * tab.margin, tab.cell_size.height)
		    tab.is_bounceable = true
			layer:initWithTable(nil, vec_idx, select_idx, tab)
		end,
		["isVisible"] = function()
			-- ex.Player.promotion_data:checkOverValueIsOpen() or
			local _, is_show = ex.Tools:getMainCityBtnStatus("act_limit_time_activity")
			return is_show and 
				(ex.Player.promotion_data:checkDailyRechargeGiftIsOpen()
				or ex.Player.promotion_data:checkBlessingPoolIsOpen() or ex.Player.promotion_data:checkAdventureIsOpen()
				or ex.Player.promotion_data:checkTavernWeeklyIsOpen() or ex.Player.promotion_data:checkSpeedFightIsOpen()
				or ex.Player.promotion_data:checkAlterHeroIsOpen() or ex.Player.promotion_data:checkSummontimesIsOpen()
				or ex.Player.promotion_data:checkPvpwinsIsOpen() or ex.Player.promotion_data:checkProphecytimesIsOpen()
				or ex.Player.promotion_data:checkBuyGoldIsOpen() or ex.Player.promotion_data:checkLevelUpIsOpen()
				or ex.Player.promotion_data:checkExchangeIsOpen() or ex.Player.promotion_data:checkExchangeLimitIsOpen()
				or ex.Player.promotion_data:checkMakeHeroIsOpen() or ex.Player.promotion_data:checkSummonCrystalIsOpen()
				or ex.Player.promotion_data:checkPubArriveIsOpen()
				or ex.Player.promotion_data:checkCommonActivityIsOpen(ex.Player.promotion_data.act_adv_note_promotion_id) 
				or ex.Player.promotion_data:checkCommonActivityIsOpen(ex.Player.promotion_data.act_mystery_box_promotion_id)
				or ex.Player.promotion_data:checkColorfulIsOpen() or ex.Player.promotion_data:checkLoginGiftIsOpen()
				or ex.Player.promotion_data:WeedendGiftIsOpen() or ex.Player.promotion_data:checkLuckFishIsOpen())
		end
	},

	-- 新服限购
	["act_new_server_limit_activity"] = {
		["open"] = function (data)
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
			require("src.layer.promotion.NewServerLimitCtr"):instance():openWindow()
		end,
		["isVisible"] = function ()
			-- local total_list = ex.Player.shop_data:getRechargeList(RechargeKindType.NEW_SERVER_LIMIT)
			-- local day_th = cc.exports.GetAfterDaysForTime(ex.Player.server_create_time)
			-- for i,v in ipairs(total_list) do
			-- 	if v.level == day_th then
			-- 		return true
			-- 	end
			-- end
			--return false

			if ex.Player.promotion_data:getPromotionNewServerLimitISOpen() == false then 
				return false
			end 

			local _, is_show = ex.Tools:getMainCityBtnStatus("act_new_server_limit_activity")
			if not is_show then
				return false
			end

			local total_list = ex.Player.promotion_data:getNewServerListData()

			local index = 0
			for k,v in pairs(total_list) do
				index = index + 1
			end
			
			if index > 0 then 
				return true
			end 
			return false
			
			-- return ex.Player.promotion_data.new_server_limit_end_time ~= 0 and ex.Player.promotion_data.new_server_limit_end_time > ex.Game:getServerTime()
		end
	},
	-- 在线奖励
	["act_buy_gold"] = {
		["open"] = function (data)
			-- local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
			require("src.layer.BuyGoldCtr"):instance():openWindow()
		end
	},
	-- 中秋活动
	["act_mid_autumn"] = {
		["open"] = function (data)
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
			require("src.layer.promotion.MidAutumnActivityCtrl"):instance():openWindow()
		end,
		["isVisible"] = function ()
			if next(ex.Player.promotion_data.mid_autumn_info) == nil then
				return false
			end

			local cur_time = ex.Game:getServerTime()
			-- print("act_mid_autumn isVisible current:", cur_time, ", begin:", ex.Player.promotion_data.mid_autumn_info.begin_time, ", end:", ex.Player.promotion_data.mid_autumn_info.end_time)
			local _, is_show = ex.Tools:getMainCityBtnStatus("act_mid_autumn")
			return is_show and (ex.Player.promotion_data.mid_autumn_info.begin_time < cur_time and ex.Player.promotion_data.mid_autumn_info.end_time > cur_time)
		end
	},
	-- 圣诞-节日豪礼
	["act_festival_gift"] = {
		["open"] = function (data)
			-- local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
			-- require("src.layer.promotion.MidAutumnActivityCtrl"):instance():openWindow()
			require("src.layer.promotion.FestivalGiftCtr"):instance():openWindow()
		end,
		["isVisible"] = function ()
			return ex.Player.promotion_data:checkFestivalOvervalueGiftIsOpen()
		end
	},
	-- 通用活动
	["act_happy_month"] = {
		["open"] = function (data)
			require("src.layer.promotion.CommonUIHelper"):OpenWindow("act_happy_month")
		end,
		["isVisible"] = function ()
			local _, is_show = ex.Tools:getMainCityBtnStatus("act_happy_month")
			return is_show and ex.Player.promotion_data:checkCommonActivityIsOpen(35)
		end
	},
	-- 公会世界boss快捷入口
	["act_clan_boss"] = {
		-- 活动开放日时显示，点击打开活动主界面
		-- 图标下方显示倒计时
		-- 活动未开始时显示开启倒计时“23:59:59后开启”
		-- 活动进行中时显示结束倒计时“23:59:59后结束”
		-- 活动已结束时显示“已结束”
		-- 点击逻辑
		-- 点击判断玩家是否已加入任意公会
		-- 是，打开公会[boss功能主界面]
		-- 否，弹出飘字提示“加入公会后才能参加世界BOSS活动”
		["open"] = function (data)
			if tonumber(ex.Player.clan_data.clan_id) <= 0 then
				ex.MessageView:add(ex.Tools:getLang(52001))
				return
			end
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.CLAN_BOSS)
		end,
		["isVisible"] = function ()
			local cur_time = ex.Game:getServerTime()

			if ex.Player.clan_data.last_req_boss_refresh_time == nil then
				ex.Player.clan_data.last_req_boss_refresh_time = 0
			end		
			if cur_time - ex.Player.clan_data.last_req_boss_refresh_time > 1 then
				ex.Player.clan_data.last_req_boss_refresh_time = cur_time
				if ex.Player.clan_data.clan_boss_info.next_stage_time == nil or ex.Player.clan_data.clan_boss_info.next_stage_time <= cur_time then
					NetManager:sendMessage(ProtocolID.GReqScanWorldBoss)
				end
			end

			ex.Player.clan_data:checkBossReddot()

			local _, is_show = ex.Tools:getMainCityBtnStatus("act_clan_boss")
			return is_show and (ex.Player.clan_data.clan_boss_info.round_start_time ~= nil and ex.Player.clan_data.clan_boss_info.round_start_time < cur_time and 
					ex.Player.clan_data.clan_boss_info.round_end_time ~= nil and ex.Player.clan_data.clan_boss_info.round_end_time > cur_time)
		end,
		-- 如果是需要倒计时的活动入口，则实现这个接口，获取结束时间，-1则一直存在		
		["getEndTime"] = function ()
			return ex.Player.clan_data.clan_boss_info.round_end_time
		end,
		-- 如果是需要倒计时的活动入口，则实现这个接口，获取结束时间显示字符串
		["getTimeTipString"] = function ()
			local cur_time = ex.Game:getServerTime()

			if ex.Player.clan_data.last_req_boss_refresh_time == nil then
				ex.Player.clan_data.last_req_boss_refresh_time = 0
			end		
			if cur_time - ex.Player.clan_data.last_req_boss_refresh_time > 1 then
				ex.Player.clan_data.last_req_boss_refresh_time = cur_time
				if ex.Player.clan_data.clan_boss_info.next_stage_time <= cur_time then
					NetManager:sendMessage(ProtocolID.GReqScanWorldBoss)
				end
			end

			if ex.Player.clan_data.clan_boss_info.stage == 1 and ex.Player.clan_data.clan_boss_info.next_stage_time >= cur_time then
				local time = ex.Player.clan_data.clan_boss_info.next_stage_time

				local d, h, m, s = ex.Tools:formatTime(math.max(time - ex.Game:getServerTime(), 0))
				local str_format = "%02d:%02d:%02d"
				return string.format(ex.Tools:getLang(52110), string.format(str_format, d * 24 + h, m, s))
			elseif ex.Player.clan_data.clan_boss_info.stage == 4 and ex.Player.clan_data.clan_boss_info.next_stage_time >= cur_time then
				return ex.Tools:getLang(41159)
			else
				local time = ex.Player.clan_data.clan_boss_info.round_end_time

				local d, h, m, s = ex.Tools:formatTime(math.max(time - ex.Game:getServerTime(), 0))
				local str_format = "%02d:%02d:%02d"
				return string.format(ex.Tools:getLang(52111), string.format(str_format, d * 24 + h, m, s))
			end
		end
	},
	-- 公会战快捷入口
	["act_clan_gvg"] = {
		-- 出现逻辑：满足以下条件时候，该按钮出现
		-- 玩家当前处在公会中
		-- 公会战正在编队阶段、备战阶段、战斗阶段、存在待领取的奖励
		-- 阶段和时间显示
		-- 编队阶段：成员编队报名阶段，显示“编队阶段”和阶段剩余时间倒数，包括“时：分：秒”
		-- 备战阶段：会长调整成员队伍位置和顺序的阶段，显示“备战阶段”和阶段剩余时间倒数，包括“时：分：秒”
		-- 战斗阶段：正在战斗的过程，显示“正在战斗”，不需要显示时间
		-- 领奖阶段：当成员有公会战奖励还没领取的时候，显示“领取奖励”，并显示到24点奖励被清除之前的时间倒数，包括“时：分：秒”
		["open"] = function (data)
			if tonumber(ex.Player.clan_data.clan_id) <= 0 then
				ex.MessageView:add(ex.Tools:getLang(70149))
				return
			end
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.CLAN_GVG)
		end,
		["isVisible"] = function ()
			local cur_time = ex.Game:getServerTime()

			if ex.Player.clan_data.last_req_gvg_refresh_time == nil then
				ex.Player.clan_data.last_req_gvg_refresh_time = 0
			end	
			if cur_time - ex.Player.clan_data.last_req_gvg_refresh_time > 1 then
				if ex.Player.clan_data.clan_gvg_info.next_stage_time <= cur_time then
					ex.Player.clan_data.last_req_gvg_refresh_time = cur_time
					NetManager:sendMessage(ProtocolID.GReqScanWarInfo)
				end
			end

			ex.Player.clan_data:checkGvgReddot()

			local _, is_show = ex.Tools:getMainCityBtnStatus("act_clan_gvg")
			return is_show and
					ex.Player.clan_data.clan_gvg_info.round_start_time ~= nil and ex.Player.clan_data.clan_gvg_info.round_start_time < cur_time and 
					ex.Player.clan_data.clan_gvg_info.round_end_time ~= nil and ex.Player.clan_data.clan_gvg_info.round_end_time > cur_time
		end,
		-- 如果是需要倒计时的活动入口，则实现这个接口，获取结束时间，-1则一直存在		
		["getEndTime"] = function ()
			return ex.Player.clan_data.clan_gvg_info.round_end_time
		end,
		-- 如果是需要倒计时的活动入口，则实现这个接口，获取结束时间显示字符串
		["getTimeTipString"] = function ()
			local cur_time = ex.Game:getServerTime()

			if ex.Player.clan_data.last_req_gvg_refresh_time == nil then
				ex.Player.clan_data.last_req_gvg_refresh_time = 0
			end	
			if cur_time - ex.Player.clan_data.last_req_gvg_refresh_time > 1 then
				if ex.Player.clan_data.clan_gvg_info.next_stage_time <= cur_time then
					ex.Player.clan_data.last_req_gvg_refresh_time = cur_time
					NetManager:sendMessage(ProtocolID.GReqScanWarInfo)
				end
			end

			if ex.Player.clan_data.clan_gvg_info.stage == 1 and ex.Player.clan_data.clan_boss_info.next_stage_time > cur_time then
				local time = ex.Player.clan_data.clan_gvg_info.next_stage_time

				local d, h, m, s = ex.Tools:formatTime(math.max(time - ex.Game:getServerTime(), 0))
				local str_format = "%02d:%02d:%02d"
				return string.format(ex.Tools:getLang(52110), string.format(str_format, d * 24 + h, m, s))
			elseif ex.Player.clan_data.clan_gvg_info.stage == 2 and ex.Player.clan_data.clan_gvg_info.next_stage_time > cur_time then
				local time = ex.Player.clan_data.clan_gvg_info.next_stage_time

				local d, h, m, s = ex.Tools:formatTime(math.max(time - ex.Game:getServerTime(), 0))
				local str_format = "%02d:%02d:%02d"
				return ex.Tools:getLang(70145).."\n"..string.format(str_format, d * 24 + h, m, s)
			elseif ex.Player.clan_data.clan_gvg_info.stage == 3 and ex.Player.clan_data.clan_gvg_info.next_stage_time > cur_time then
				local time = ex.Player.clan_data.clan_gvg_info.next_stage_time

				local d, h, m, s = ex.Tools:formatTime(math.max(time - ex.Game:getServerTime(), 0))
				local str_format = "%02d:%02d:%02d"
				return ex.Tools:getLang(70146).."\n"..string.format(str_format, d * 24 + h, m, s)
			elseif ex.Player.clan_data.clan_gvg_info.stage == 4 and ex.Player.clan_data.clan_gvg_info.next_stage_time > cur_time then
				return ex.Tools:getLang(70147)
			elseif ex.Player.clan_data.clan_gvg_info.stage == 5 and ex.Player.clan_data.clan_gvg_info.next_stage_time > cur_time then
				local time = ex.Player.clan_data.clan_gvg_info.round_end_time

				local d, h, m, s = ex.Tools:formatTime(math.max(time - ex.Game:getServerTime(), 0))
				local str_format = "%02d:%02d:%02d"
				return ex.Tools:getLang(70136).."\n"..string.format(str_format, d * 24 + h, m, s)
			else
				local time = ex.Player.clan_data.clan_gvg_info.round_end_time

				local d, h, m, s = ex.Tools:formatTime(math.max(time - ex.Game:getServerTime(), 0))
				local str_format = "%02d:%02d:%02d"
				return string.format(ex.Tools:getLang(52111), string.format(str_format, d * 24 + h, m, s))
			end
		end
	},
	-- 头像框
	["main_dress"] = {
		["open"] = function (data)
			-- if not data then data = 1 end 
			local tag
			local select_id
			if not data then 
				tag = 1
				select_id = ex.Player.head_id
			else
				tag = data[1]
				select_id = data[2]
			end
			require("src.layer.SettingChooseCtr"):instance():openWindow(tag, select_id)
		end,
	},


	["main_dream"] = {
		["open"] = function (data)
			local backToLayer = data and data.backToLayer or nil

			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.DREAM_LAYER, backToLayer)

		end,
		["isVisible"] = function ()
			return true
		end
	},


	---------------------------------------------------------------------------------
	-- 超值养成
	["act_develop_gift_activity"] = {
		["open"] = function (data)
			local backToLayer = data and data.backToLayer or nil
			local select_idx = 0
			if data and data.__select_idx then
				select_idx = data.__select_idx
			end

			ex.Player.promotion_data:reqDevelopGiftData()

			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_DEVELOP_GIFT, backToLayer)
		    local vec_idx = ex.Player.promotion_data:getPromotionByType(PromotionPageType.DEVELOP_GIFT)
			layer:initWithTable(nil, vec_idx, select_idx)
		end,
		["isVisible"] = function ()
			return true
		end,
		["getEndTime"] = function ()
			return ex.Player.promotion_data.develop_gift.refresh_date_time or 0
		end,
		["getTimeTipString"] = function ()
			if ex.Player.promotion_data.develop_gift ~= nil and ex.Player.promotion_data.develop_gift.refresh_date_time ~= nil then
				local cur_time = ex.Game:getServerTime()

				local time = ex.Player.promotion_data.develop_gift.refresh_date_time

				local d, h, m, s = ex.Tools:formatTime(math.max(time - ex.Game:getServerTime(), 0))
				local str_format = "%02d:%02d:%02d"
				return string.format(str_format, d * 24 + h, m, s)
			end
		end
	},
	-- 超值养成-英雄多多
	["act_develop_gift_activity_hero"] = {
		["open"] = function (data)
			local info = data or {}
			info.__select_idx = ActivityPanelIdxType.DEVELOP_GIFT_HERO

			return cfg.funcopen["act_develop_gift_activity"]["open"](info)
		end,
		["isVisible"] = function ()
			return cfg.funcopen["act_develop_gift_activity"]["isVisible"]()
		end,
		["getEndTime"] = function ()
			return cfg.funcopen["act_develop_gift_activity"]["getEndTime"]()
		end,
		["getTimeTipString"] = function ()
			return cfg.funcopen["act_develop_gift_activity"]["getTimeTipString"]()
		end
	},
	-- 超值养成-金币多多
	["act_develop_gift_activity_gold"] = {
		["open"] = function (data)
			local info = data or {}
			info.__select_idx = ActivityPanelIdxType.DEVELOP_GIFT_GOLD

			return cfg.funcopen["act_develop_gift_activity"]["open"](info)
		end,
		["isVisible"] = function ()
			return cfg.funcopen["act_develop_gift_activity"]["isVisible"]()
		end,
		["getEndTime"] = function ()
			return cfg.funcopen["act_develop_gift_activity"]["getEndTime"]()
		end,
		["getTimeTipString"] = function ()
			return cfg.funcopen["act_develop_gift_activity"]["getTimeTipString"]()
		end
	},
	-- 超值养成-羁绊多多
	["act_develop_gift_activity_fetter"] = {
		["open"] = function (data)
			local info = data or {}
			info.__select_idx = ActivityPanelIdxType.DEVELOP_GIFT_FETTER

			return cfg.funcopen["act_develop_gift_activity"]["open"](info)
		end,
		["isVisible"] = function ()
			return cfg.funcopen["act_develop_gift_activity"]["isVisible"]()
		end,
		["getEndTime"] = function ()
			return cfg.funcopen["act_develop_gift_activity"]["getEndTime"]()
		end,
		["getTimeTipString"] = function ()
			return cfg.funcopen["act_develop_gift_activity"]["getTimeTipString"]()
		end
	},
	---------------------------------------------------------------------------------

	-- 限时活动->限时抢购
	["act_limit_time_limit_buy"] = {
		["open"] = function (data)
			cfg.funcopen["act_limit_time_activity"].open({select_idx = 426})
		end,
		["isVisible"] = function ()
			return true
		end
	},

	-- VIP任务
	["main_vip"] = {
			["open"] = function (data)
				ex.MainSceneCtr:changeLayer(MainSceneType.FETTER_MAIN_VIEW)
			end,
			["isVisible"] = function ()
				return true
			end
	},
	-- 羁绊铸魂
	["fetter_cast_soul"] = {
		["open"] = function (data)
			
		end,
	},


	---------------------------------------------------------------------------------
	-- 特权窗口
	-- 特权窗口
	["act_privilege"] = {
		["open"] = function (data)
			local backToLayer = data and data.backToLayer or nil
			local select_idx = ActivityPanelIdxType.PRIVILEGE_PRIVILEGE_GIFT
			if data and data.__select_idx then
				select_idx = data.__select_idx
			end

		    local vec_idx = ex.Player.promotion_data:getPromotionByType(PromotionPageType.RECHARGE)
		    local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_RECHARGE, backToLayer)
			layer:initWithTable(nil, vec_idx, select_idx)
			
			return layer
		end,
		["isVisible"] = function ()
			return true
		end
	},
	-- 成长礼包、累充豪礼
	["act_recharge_growth"] = {
		["open"] = function (data)
			local info = data or {}
			info.__select_idx = ActivityPanelIdxType.PRIVILEGE_GROWTH_GIFT

			return cfg.funcopen["act_privilege"]["open"](info)
		end
	},
	-- 每日礼包
	["act_daily_gift"] = {
		["open"] = function (data)
			local info = data or {}
			info.__select_idx = ActivityPanelIdxType.PRIVILEGE_DAILY_GIFT

			return cfg.funcopen["act_privilege"]["open"](info)
		end
	},
	-- 每日礼包
	["act_daily_gift_shop"] = {
		["open"] = function (data)
			local layer = cfg.funcopen["act_daily_gift"]["open"]()
			if layer ~= nil then
				cfg.funcopen["main_shop"].open(SHOP_TYPE.HERO)
			end
			return layer
		end
	},
	-- 充值
	["act_recharge"] = {
		["open"] = function (data)
			if require("src.model.Game"):instance().server_id >= SERVER_SHEN_HE_ID and device.platform == "ios" then
				local info = data or {}
				info.__select_idx = ActivityPanelIdxType.PRIVILEGE_RECHARGE
				local vec_idx = ex.Player.promotion_data:getPromotionByType(PromotionPageType.RECHARGE)
				local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_DAILY_CHECK)
				layer:initWithTable(nil, vec_idx, 1)
				
				return layer
			else
				local info = data or {}
				info.__select_idx = ActivityPanelIdxType.PRIVILEGE_RECHARGE
				return cfg.funcopen["act_privilege"]["open"](info)
			end
		end
	},
	-- 每日充值智能跳转，如果每日礼包卖完了，就跳转到每周福利
	["act_recharge_smart"] = {
		["open"] = function (data)
			-- local backToLayer = data and data.backToLayer or nil
			-- ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_GOD_RELIC_LIST, backToLayer)

			local is_jump_daily = false
			local daily_list = ex.Player.promotion_data:getRechargeList()
			for i,v in ipairs(daily_list) do
				local is_not_buy = ex.Player.promotion_data:getDayLimitStatus(v.idx)
				if is_not_buy then
					is_jump_daily = true
					break
				end
			end

			if is_jump_daily then
				if ex.MainSceneCtr:getCurLayerType() == MainSceneType.MAINCITY_RECHARGE then
					local layer = ex.MainSceneCtr:getCurLayer()
					if layer and layer.changeTab then
						layer:changeTab(ActivityPanelIdxType.PRIVILEGE_DAILY_GIFT)
					end
				elseif ex.MainSceneCtr:getCurLayerType() == MainSceneType.MAINCITY_DAILY_CHECK then
					-- 福利和充值窗口公用基类，所以要先关掉在转入充值窗口
					ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)

					ex.JumpManager:jumpByAtom("act_daily_gift")
				else
					-- 跳转到
					ex.JumpManager:jumpByAtom("act_daily_gift")
				end
			else
				ex.JumpManager:jumpByAtom("act_week_gift")
			end
		end
	},
	-- 特权商城
	["act_privilege_shop"] = {
		["open"] = function (data)
			local info = data or {}
			info.__select_idx = ActivityPanelIdxType.PRIVILEGE_PRIVILEGE_GIFT

			return cfg.funcopen["act_privilege"]["open"](info)
		end
	},
	
	-- 神职特权
	["act_clergy_privilege"] = {
		["open"] = function (data)
			local info = data or {}
			info.__select_idx = ActivityPanelIdxType.PRIVILEGE_CLERGY

			return cfg.funcopen["act_privilege"]["open"](info)
		end
	},

	---------------------------------------------------------------------------------
	-- 后台限时活动
	["act_limit_time_server"] = {
		["open"] = function (data)
			local backToLayer = data and data.backToLayer or nil
			local select_idx = 0
			if data and data.__select_idx then
				select_idx = data.__select_idx
			end

			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LIMIT_TIME_SERVER, backToLayer)
		    local vec_idx = ex.Player.promotion_data:getPromotionByType(PromotionPageType.LIMIT_TIME_SERVER_ACTIVITY)
			-- layer:initWithTable(nil, vec_idx, select_idx)
			if select_idx == ActivityPanelIdxType.BUY_DRAGONBOAT then
				layer:initWithTable(nil, vec_idx, select_idx, {}, data.dragonboat_idx)
			else
				layer:initWithTable(nil, vec_idx, select_idx)
			end

			return layer
		end,
		["isVisible"] = function ()
			return ex.Player.promotion_data:checkBuySkinIsOpen() or ex.Player.promotion_data:checkBuySkinLimitIsOpen() or
					ex.Player.promotion_data:checkSummonWeekCardIsOpen() or ex.Player.promotion_data:checkSuperSummonWeekCardIsOpen() or 
					ex.Player.promotion_data:checkEveryDayLoginIsOpen() or ex.Player.promotion_data:checkThreeDayGiftIsOpen()
					or ex.Player.promotion_data:customizedIsOpen() or ex.Player.promotion_data:checkMagicButterflyIsOpen()
					or ex.Player.promotion_data:checkOverValueIsOpen() or ex.Player.promotion_data:checkDragonBoatIsOpen()
					or ex.Player.promotion_data:checkTimeTreasureIsOpen() or ex.Player.promotion_data:checkExchangeShopIsOpen()
					or ex.Player.promotion_data:checkAstrologyTaskIsOpen() or ex.Player.promotion_data:checkThreeDaysRechargeIsOpen()
		end
	},

	-- 购买皮肤活动
	["act_buy_fashion"] = {  
		["open"] = function (data)
			local isOpen = ex.JumpManager:checkOpenConditionByAtom("act_buy_fashion")
			if not isOpen or not ex.Player.promotion_data:checkBuySkinLimitIsOpen() then
				ex.MessageView:add(ex.Tools:getLang(32201))
				return
			end

			local info = data or {}
			info.__select_idx = ActivityPanelIdxType.BUY_FASHION

			return cfg.funcopen["act_limit_time_server"]["open"](info)
		end        
	},                         
                
	-- 限时活动-超值礼包  
	["act_super_gift"] = {       
		["open"] = function (data)      
			local info = data or {}
			info.__select_idx = ActivityPanelIdxType.BUY_SUPER_GIFT

			return cfg.funcopen["act_limit_time_server"]["open"](info)
		end
	},

	-- 端午节任务跳转
	["act_dragonboat_taks"] = {  
		["open"] = function (data)
			local info = data or {}
			info.__select_idx = ActivityPanelIdxType.BUY_DRAGONBOAT
			info.dragonboat_idx = 1
			return cfg.funcopen["act_limit_time_server"]["open"](info)
		end
	},

	-- 端午节购买礼包跳转
	["act_dragonboat_gift"] = {  
		["open"] = function (data)
			local info = data or {}
			info.__select_idx = ActivityPanelIdxType.BUY_DRAGONBOAT
			info.dragonboat_idx = 3
			return cfg.funcopen["act_limit_time_server"]["open"](info)
		end
	},

	-- 神秘礼盒
	["act_mystery_box"] = {
		["open"] = function (data)
			local select_idx = 0
			if data and data.__select_idx then
				select_idx = data.__select_idx
			end

			require("src.layer.MysteryBoxCtr"):instance():openWindow()
		end,
		["isVisible"] = function ()
			local _, is_show = ex.Tools:getMainCityBtnStatus("act_mystery_box")
			return is_show and ex.Player.promotion_data:checkCommonActivityIsOpen(ex.Player.promotion_data.act_mystery_box_promotion_id)
		end
	},

	-- 冒险日记
	["act_adven_note"] = {
		["open"] = function (data)
			local select_idx = 0
			if data and data.__select_idx then
				select_idx = data.__select_idx
			end

			require("src.layer.AdvenNoteCtr"):instance():openWindow()
		end,
		["isVisible"] = function ()
			local _, is_show = ex.Tools:getMainCityBtnStatus("act_adven_note")
			return is_show and ex.Player.promotion_data:checkCommonActivityIsOpen(ex.Player.promotion_data.act_adv_note_promotion_id)
		end
	},
	---------------------------------------------------------------------------------
	-- 远古战场
	["main_ancient"] = {
		["open"] = function (data)
			local backToLayer = data and data.backToLayer or nil
			ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_ANCIENT, backToLayer)
		end
	},
	["main_god_relic"] = {
		["open"] = function (data)
			local backToLayer = data and data.backToLayer or nil
			ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_GOD_RELIC, backToLayer)
		end
	},
	["main_god_relic_list"] = {
		["open"] = function (data)
			local backToLayer = data and data.backToLayer or nil
			ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_GOD_RELIC_LIST, backToLayer)
		end
	},
	["main_god_equip_summon"] = {
		["open"] = function (data)
			require("src.layer.artifact.ArtifactSummonCtr"):instance():openWindow()
		end
	},
	["main_god_equip_illustration"] = {
		["open"] = function (data)
			require("src.layer.artifact.ArtifactIllustrationCtr"):instance():openWindow()
		end
	},
	---------------------------------------------------------------------------------
	
	---------------------------------------------------------------------------------
	["backpack_runes"] = {
		["open"] = function (data)
			local backToLayer = data and data.backToLayer or nil
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.BACKPACK_LAYER, backToLayer)
			if layer then
				layer:onTabChange(ItemData.IT_SPECIAL)
			end
		end
	},
	["backpack_hallows"] = {
		["open"] = function (data)
			local backToLayer = data and data.backToLayer or nil
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.BACKPACK_LAYER, backToLayer)
			if layer then
				layer:onTabChange(ItemData.IT_HALLOWS)
			end
		end
	},
	["backpack_magic_wand"] = {
		["open"] = function (data)
			local backToLayer = data and data.backToLayer or nil
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.BACKPACK_LAYER, backToLayer)
			if layer then
				layer:onTabChange(ItemData.MAGIC_WAND)
			end
		end
	},
	---------------------------------------------------------------------------------

	-- 组队竞技场-组队主界面
	["team_arena_team_main"] = {
		["open"] = function (data)
			local select_idx = TeamArenaTeamPanelIdxType.TEAM
			if data and data.__select_idx then
				select_idx = data.__select_idx
			end

			local obj = require("src.layer.teamarena.TeamArenaTeamMainCtrl"):instance()

			if obj:isOpened() then
				obj:changeLayer(select_idx)
			else
				obj:openWindow(select_idx)
			end
		end
	},
	-- 组队竞技场-组队主界面-组队页面
	["team_arena_team_main_team"] = {
		["open"] = function (data)
			local info = data or {}
			info.__select_idx = TeamArenaTeamPanelIdxType.TEAM

			return cfg.funcopen["team_arena_team_main"]["open"](info)
		end
	},
	-- 组队竞技场-组队主界面-接收邀请界面
	["team_arena_team_main_recv_invite"] = {
		["open"] = function (data)
			local info = data or {}
			info.__select_idx = TeamArenaTeamPanelIdxType.RECV_INVITE

			return cfg.funcopen["team_arena_team_main"]["open"](info)
		end
	},
	-- 组队竞技场-组队主界面-我的队伍界面
	["team_arena_team_main_my_team"] = {
		["open"] = function (data)
			local info = data or {}
			info.__select_idx = TeamArenaTeamPanelIdxType.MY_TEAM

			return cfg.funcopen["team_arena_team_main"]["open"](info)
		end
	},
	-- 评论有礼
	["comments_reward"] = {
		["open"] = function (data)
			if cfg.socialplatform.isOpen("comments_reward") ~= true then
				return
			end
			
			local discuss_gift = require("src.layer.DiscussCtr"):instance()
			discuss_gift:openWindow(200)
		end,
		["isVisible"] = function ()
			local _, is_show = ex.Tools:getMainCityBtnStatus("comments_reward")
			return is_show and ex.Player.promotion_data:checkDailyFirstRechargeIsOpen()
		end
	},
	-- facebook点赞
	["thumb_up_to_share"] = {
		["open"] = function (data)
			if cfg.socialplatform.isOpen("store_dz") == false or cfg.socialplatform.isOpen("store_share") == false then
				return
			end

			local is_dz = TableEx.findValueFunction(ex.Player.comment_list, function(v)
				return v.type == 100 and v.state == 2
			end)


			local is_share = TableEx.findValueFunction(ex.Player.comment_list, function(v)
				return v.type == 300 and v.state == 2
			end)

			if is_dz == nil then
				local discuss_gift = require("src.layer.DiscussCtr"):instance()
				discuss_gift:openWindow(100)
			elseif is_share == nil then
				local discuss_gift = require("src.layer.DiscussCtr"):instance()
				discuss_gift:openWindow(300)
			elseif type(cfg.system.thumb_up_to_share_end_go_to) == "string" and cfg.system.thumb_up_to_share_end_go_to ~= "" then
				cc.Application:getInstance():openURL(cfg.system.thumb_up_to_share_end_go_to)
			end

			-- local discuss_gift = require("src.layer.DiscussCtr"):instance()
			-- discuss_gift:openWindow(200)
		end,
		["isVisible"] = function ()
			local is_dz = TableEx.findValueFunction(ex.Player.comment_list, function(v)
				return v.type == 100 and v.state == 2
			end)
			
			local is_share = TableEx.findValueFunction(ex.Player.comment_list, function(v)
				return v.type == 300 and v.state == 2
			end)

			local is_open = cfg.socialplatform.isOpen("store_dz") and cfg.socialplatform.isOpen("store_share")
			local ret = is_open and (is_dz == nil or is_share == nil or 
				(type(cfg.system.thumb_up_to_share_end_go_to) == "string" and 
				cfg.system.thumb_up_to_share_end_go_to ~= ""))
			return ret
		end
	},
	
	-- 星盘
	["hero_astrolabe"] = {
		["open"] = function (data)
			if ex.Player.hero_data.astrolabe:isEnabled() then
				require("src.layer.herolist.HeroAstrolabeCtrl"):instance():openWindow()
			else
				require("src.layer.herolist.HeroAstrolabeUnlockCtrl"):instance():openWindow()
			end
		end
	},
	-- 星盘解锁
	["hero_astrolabe_unlock"] = {
		["open"] = function (data)
			require("src.layer.herolist.HeroAstrolabeUnlockCtrl"):instance():openWindow()
		end
	},
	-- 星盘主界面
	["hero_astrolabe_main"] = {
		["open"] = function (data)
			require("src.layer.herolist.HeroAstrolabeCtrl"):instance():openWindow()
		end
	},
	-- 功能预告
	["act_advance_announce"] = {
		["isVisible"] = function (data)
			local ret = ex.Player.promotion_data:checkPromotion66IsOpen()
			return ret;
		end
	},
	-- 超凡段位赛主界面
	["main_super_stage"] = {
		["open"] = function (data)
			if ex.Player.super_stage_data.cur_season <= 0 or not ex.Player.super_stage_data:isOpen() then
				ex.MessageView:add(ex.Tools:getLang(32201))
				return
			elseif ex.Player.super_stage_data.is_matching or ex.Player.super_stage_data.is_battling then
				ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_SUPER_STAGE_MATCH)
			else
				ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_SUPER_STAGE_MAIN)
			end
		end
	},
	-- 超凡段位赛戰令界面
	["main_super_stage_token"] = {
		["open"] = function (data)
			if ex.Player.super_stage_data.cur_season <= 0 then
				ex.MessageView:add(ex.Tools:getLang(32201))
				return
			else
				ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_SUPER_STAGE_TOKEN)
			end
		end
	},

	-- 浮空岛主界面
	["main_floating_islands"] = {
		["open"] = function (data)
			if ctr.floating_islands.data.stage <= 1 then
				ex.MessageView:add(ex.Tools:getLang(31923))
				return
			end
			ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_FLOATING_ISLANDS_BOSS1)
		end
	},

	-- 时空魔塔
	["main_space_time_magic_tower"] = {
		["open"] = function (data)
			local data  = ex.Player.space_time_magic_tower_data
			local now = cpp.Game:instance():getServerTime()
			if not data or data.cur_lv == 0 then
				ex.MessageView:add(ex.Tools:getLang(32201))
				return
			end

			if not data.startTime or not data.endTime or 
			data.startTime == 0 or data.endTime == 0 then
				ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_SPACE_TIME_MAGIC_TOWER_MAIN)
				return
			end

			if now < data.startTime then
				ex.MessageView:add(ex.Tools:getLang(32201))
				return
			end

			if now > data.endTime then
				ex.MessageView:add(ex.Tools:getLang(75629))
				return
			end

			ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_SPACE_TIME_MAGIC_TOWER_MAIN)
		end,
		["checkRedDot"] = function (data)
			local has_red_dot = true
			local configs = cfg.timetowermisson.timetowermisson
			if configs and #configs > 0 and configs[#configs].mission == data.mission_id then
				has_red_dot = false
			end

			if has_red_dot then
				if data.heart <= 0 then
					has_red_dot = false
				end
			end

			if has_red_dot then
				if cfg.opencondition.condition["main_space_time_magic_tower"].condition_value > ex.Player.level then
					has_red_dot = false
				end
			end

			if has_red_dot then
				if data.startTime and data.endTime and data.startTime ~= 0 and data.endTime ~= 0 then
					local now = cpp.Game:instance():getServerTime()
					if now < data.startTime then
						has_red_dot = false
					end

					if now > data.endTime then
						has_red_dot = false
					end
				end
			end

			ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KFSK_SKMT, has_red_dot)
			ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KFSK_SKMT_KSTZ, has_red_dot)
		end
	},

	--冥域魔都主界面
	["main_underworld_pagoda"] = {
		["open"] = function (data)
			ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_UNDERWORLD_PAGODA)
		end,
		["isVisible"] = function ()
			local visible = true
			if cfg.opencondition.condition["main_underworld_pagoda"].condition_value > ex.Player.level then
				visible = false
			end
			return visible
		end,
	},
	
	-- 国战主界面
	["main_country_war"] = {
		["open"] = function (data)	
			if ex.Player.level < cfg.opencondition.condition["main_country_war"].condition_value then
				require("src.layer.countrywar.CountryWarTipsCtr"):instance():openWindow(ex.Tools:getLang(55554), ex.Tools:getLang(55555), ex.Tools:getLang(55586)..string.format( ex.Tools:getLang(55587), cfg.opencondition.condition["main_country_war"].condition_value))
				return
			end
			
			if cc.exports.GetAfterDaysForTime(ex.Player.server_create_time) < cfg.system.country_war_open_day then
				require("src.layer.countrywar.CountryWarTipsCtr"):instance():openWindow(ex.Tools:getLang(55554), ex.Tools:getLang(55555), ex.Tools:getLang(55586)..ex.Tools:getLang(55585))
				return
			end

			ex.MainSceneCtr:runCloudAnimation(0.3, function()
				ex.MainSceneCtr:changeLayer(MainSceneType.MAIN_COUNTRY_WAR)
			end)
		end,
		["isVisible"] = function ()
			return ex.Player.level >= cfg.opencondition.condition["main_country_war"].condition_value
		end,
	},

	-- 国战城市界面
	["MAIN_COUNTRY_WAR_CITY"] = {
		["open"] = function (data)
			ex.MainSceneCtr:runCloudAnimation(0.3, function()
				ex.MainSceneCtr:changeLayer(MainSceneType.MAIN_COUNTRY_WAR_CITY)
			end)
		end,
		["isVisible"] = function ()
			local visible = true
			if cfg.opencondition.condition["main_country_war_city"].condition_value > ex.Player.level then
				visible = false
			end
			return visible
		end,
	},
	
	------------------------------- 梦境秘宝 -------------------------------
	["act_secret_treasure"] = {
		["open"] = function (data)
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAIN_ACT_SECRET_TREASURE)
			return layer
		end,
		["isVisible"] = function ()
			return ex.Player.promotion_data:checkPromotion70IsOpen()
		end
	},

	["act_secret_treasure_package"] = {
		["open"] = function (data)
			local layer = cfg.funcopen["act_secret_treasure"].open()
			if layer then
				layer:resetSelectLayer(802)
			end
		end,
		["isVisible"] = function ()
			return true
		end
	},

	["act_secret_treasure_task"] = {
		["open"] = function (data)
			local layer = cfg.funcopen["act_secret_treasure"].open()
			if layer then
				layer:resetSelectLayer(803)
			end
		end,
		["isVisible"] = function ()
			return true
		end
	},

	------------------------------- 七神器 -------------------------------
	["act_seven_artifact"] = {
		["open"] = function (data)
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAIN_ACT_SEVEN_ARTIFACT)
			return layer
		end,
		["isVisible"] = function ()
			return ex.Player.promotion_data:checkPromotion71IsOpen() or ex.Player.promotion_data:checkShenYuOpen()
		end
	},

	["act_seven_artifact_package"] = {
		["open"] = function (data)
			if ex.Player.promotion_data:checkPromotion71IsOpen() then
				local layer = cfg.funcopen["act_seven_artifact"].open()
				if layer then
					layer:resetSelectLayer(901)
				end
			end
		end,
		["isVisible"] = function ()
			return ex.Player.promotion_data:checkPromotion71IsOpen()
		end
	},
	["main_crusade_group"] = {
		["open"] = function (data)
			local stage = ctr.crusade_group:getStage()
			if stage == CRUSADE_GROUP_STATE.NONE or
				stage == CRUSADE_GROUP_STATE.SIGN_UP or
				stage == CRUSADE_GROUP_STATE.SIGN_UP_END then
				require("src.layer.crusadegroup.CrusadeGroupSignUpCtr"):instance():openWindow()
			elseif stage == CRUSADE_GROUP_STATE.CLOSE then
				ex.MessageView:add(ex.Tools:getLang(77633))
			else
				if ctr.crusade_group.data.sign_up_status then
					ex.MainSceneCtr:runCloudAnimation(0.3, function()
						ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_CRUSADE_GROUP_LAYER)
					end)
				else
					ex.MessageView:add(ex.Tools:getLang(77632))
				end
			end
		end,
		["isVisible"] = function()
			return true
		end
	},
	-- 每日累储
	["act_daily_recharge_gift"] = {
		["open"] = function (data)
			if not ex.Player.promotion_data:checkDailyRechargeGiftIsOpen() then
				ex.MessageView:add(ex.Tools:getLang(32201))
				return
			end

			return cfg.funcopen["act_limit_time_activity"].open({select_idx = ActivityPanelIdxType.BUY_DAILY_RECHARGE_GIFT})
		end
	},
	--讨伐团-神兵
	["main_crusade_group_god_arms"] = {
		["open"] = function (data)
			ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_CRUSADE_GROUP_SHEN_BING_LAYER)
		end
	},
	["main_plane_war"] = {
		["open"] = function (data)
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_PLANE_WAR_MAIN_LAYER)
			return layer
		end,
		["isVisible"] = function ()
			return true
		end
	},

	--------------------------------- 秋赏明月 ----------------------------------
	["act_appreciate_moon"] = {
		["open"] = function (data)
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAIN_ACT_APPRECIATE_MOON)
			return layer
		end,
		["isVisible"] = function ()
			return ex.Player.promotion_data.zhongqiu_data:checkSlotIsOpen() or ex.Player.promotion_data.zhongqiu_data:checkJiaYaoIsOpen()
				   or ex.Player.promotion_data:checkZhongQiuSkinIsOpen() or ex.Player.promotion_data:checkPromotion77IsOpen()
		end
	},

	['act_appreciate_moon_task'] = {
		["open"] = function (data)
			if ex.Player.promotion_data:checkPromotion77IsOpen() then
				local layer = cfg.funcopen["act_appreciate_moon"].open()
				if layer then
					layer:resetSelectLayer(1104)
				end
			end
		end,
		["isVisible"] = function ()
			return ex.Player.promotion_data:checkPromotion77IsOpen()
		end
	},

	['act_appreciate_moon_yue'] = {
		["open"] = function (data)
			if ex.Player.promotion_data.zhongqiu_data:checkJiaYaoIsOpen() then
				local layer = cfg.funcopen["act_appreciate_moon"].open()
				if layer then
					layer:resetSelectLayer(1102)
				end
			end
		end,
		["isVisible"] = function ()
			return ex.Player.promotion_data.zhongqiu_data:checkJiaYaoIsOpen()
		end
	},

	['act_appreciate_moon_slot'] = {
		["open"] = function (data)
			if ex.Player.promotion_data.zhongqiu_data:checkSlotIsOpen() then
				local layer = cfg.funcopen["act_appreciate_moon"].open()
				if layer then
					layer:resetSelectLayer(1101)
				end
			end
		end,
		["isVisible"] = function ()
			return ex.Player.promotion_data.zhongqiu_data:checkSlotIsOpen()
		end
	},

	------------------ 万圣节活动 --------------------
	['act_halloween'] = {
		["open"] = function (data)
			if not ex.Player.promotion_data:checkPromotion78IsOpen() and not ex.Player.promotion_data:checkPromotion79IsOpen()
				   and not ex.Player.promotion_data:checkPromotion80IsOpen() then
				ex.MessageView:add(ex.Tools:getLang(32201))
				return
			end

			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAIN_ACT_HALLOWEEN)
			return layer
		end,
		["isVisible"] = function ()
			return ex.Player.promotion_data:checkPromotion78IsOpen() or ex.Player.promotion_data:checkPromotion79IsOpen()
				   or ex.Player.promotion_data:checkPromotion80IsOpen()
		end
	},

	['act_halloween_package'] = {
		["open"] = function (data)
			if not ex.Player.promotion_data:checkPromotion79IsOpen() then
				ex.MessageView:add(ex.Tools:getLang(32201))
				return
			end

			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAIN_ACT_HALLOWEEN)
			if layer then
				layer:resetSelectLayer(1202)
			end
		end,
		["isVisible"] = function ()
			return ex.Player.promotion_data:checkPromotion79IsOpen()
		end
	},

	['act_halloween_gacha'] = {
		["open"] = function (data)
			if not ex.Player.promotion_data:checkPromotion78IsOpen() then
				ex.MessageView:add(ex.Tools:getLang(32201))
				return
			end

			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAIN_ACT_HALLOWEEN)
			if layer then
				layer:resetSelectLayer(1201)
			end
		end,
		["isVisible"] = function ()
			return ex.Player.promotion_data:checkPromotion78IsOpen()
		end
	},

	['act_halloween_task'] = {
		["open"] = function (data)
			if not ex.Player.promotion_data:checkPromotion80IsOpen() then
				ex.MessageView:add(ex.Tools:getLang(32201))
				return
			end

			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAIN_ACT_HALLOWEEN)
			if layer then
				layer:resetSelectLayer(1203)
			end
		end,
		["isVisible"] = function ()
			return ex.Player.promotion_data:checkPromotion80IsOpen()
		end
	},

	-- 黑色星期五
	['act_black_friday'] = {
		["open"] = function (data)
			if not ex.Player.promotion_data:checkPromotionIs82Open() and 
			not ex.Player.promotion_data:checkPromotionIs83Open() and
			not ex.Player.promotion_data:checkPromotionIs81Open() and
			not ex.Player.promotion_data:checkPromotionIs92Open() then
				ex.MessageView:add(ex.Tools:getLang(32201))
				return
			end

			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAIN_BLACK_FRIDAY)
			return layer
		end,
		["isVisible"] = function ()
			return ex.Player.promotion_data:checkPromotionIs82Open() or ex.Player.promotion_data:checkPromotionIs83Open()
				   or ex.Player.promotion_data:checkPromotionIs81Open() or ex.Player.promotion_data:checkPromotionIs92Open()
		end
	},

	['act_black_friday_81'] = {
		["open"] = function (data)
			if not ex.Player.promotion_data:checkPromotionIs81Open() then
				ex.MessageView:add(ex.Tools:getLang(32201))
				return
			end

			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAIN_BLACK_FRIDAY)
			if layer then
				layer:resetSelectLayer(1303)
			end
		end,
		["isVisible"] = function ()
			return ex.Player.promotion_data:checkPromotionIs81Open()
		end
	},

	['act_black_friday_82'] = {
		["open"] = function (data)
			if not ex.Player.promotion_data:checkPromotionIs82Open() then
				ex.MessageView:add(ex.Tools:getLang(32201))
				return
			end

			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAIN_BLACK_FRIDAY)
			if layer then
				layer:resetSelectLayer(1302)
			end
		end,
		["isVisible"] = function ()
			return ex.Player.promotion_data:checkPromotionIs82Open()
		end
	},

	['act_black_friday_92'] = {
		["open"] = function (data)
			if not ex.Player.promotion_data:checkPromotionIs92Open() then
				ex.MessageView:add(ex.Tools:getLang(32201))
				return
			end

			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAIN_BLACK_FRIDAY)
			if layer then
				layer:resetSelectLayer(1304)
			end
		end,
		["isVisible"] = function ()
			return ex.Player.promotion_data:checkPromotionIs92Open()
		end
	},

	-- 圣诞节活动 （五一抽奖需要判断入口是否显示）
	['act_christmas'] = {
		["open"] = function (data)
			if not ex.Player.promotion_data:checkPromotionIsChristmas2Open() and
			not ex.Player.promotion_data:checkPromotionIsChristmas3Open() and
			not ex.Player.promotion_data:checkPromotionIsChristmas4Open() and
			not ex.Player.promotion_data:checkPromotionIsChristmas5Open() and
			not ex.Player.promotion_data:getPromotion097IsOpen() then
				ex.MessageView:add(ex.Tools:getLang(32201))
				return
			end
			if ex.Player.promotion_data:getPromotion097IsOpen() then
				ex.Player.promotion_data:GReqLaborDayLuckDrawGetDataInfo()
			end
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAIN_CHRISTMAS)
			return layer
		end,
		["isVisible"] = function ()
			return ex.Player.promotion_data:checkPromotionIsChristmas2Open()
				or ex.Player.promotion_data:checkPromotionIsChristmas3Open()
				or ex.Player.promotion_data:checkPromotionIsChristmas4Open()
				or ex.Player.promotion_data:checkPromotionIsChristmas5Open()
				or ex.Player.promotion_data:getPromotion097IsOpen()
		end
	},

	-- 五一抽奖
	['act_five_one_draw'] = {
		["open"] = function (data)
			if ex.Player.promotion_data:getPromotion097IsOpen() then
				local layer = cfg.funcopen["act_christmas"].open()
				if layer then
					layer:resetSelectLayer(1407)
				end
			end
		end,
		["isVisible"] = function ()
			return ex.Player.promotion_data:getPromotion097IsOpen()
		end
	},


	-- 圣诞奇幻夜
	['act_christmas_fantasynight'] = {
		["open"] = function (data)
			if ex.Player.promotion_data:checkPromotionIsChristmas1Open() then
				local layer = cfg.funcopen["act_christmas"].open()
				if layer then
					layer:resetSelectLayer(1401)
				end
			end
		end,
		["isVisible"] = function ()
			return ex.Player.promotion_data:checkPromotionIsChristmas1Open()
		end
	},

	-- 圣诞连线 
	['act_christmas_connection'] = {
		["open"] = function (data)
			if ex.Player.promotion_data:checkPromotionIsChristmas2Open() then
				local layer = cfg.funcopen["act_christmas"].open()
				if layer then
					layer:resetSelectLayer(1402)
				end
			end
		end,
		["isVisible"] = function ()
			return ex.Player.promotion_data:checkPromotionIsChristmas2Open()
		end
	},

	-- 约惠圣诞
	['act_christmas_discount'] = {
		["open"] = function (data)
			if ex.Player.promotion_data:checkPromotionIsChristmas3Open() then
				local layer = cfg.funcopen["act_christmas"].open()
				if layer then
					layer:resetSelectLayer(1403)
				end
			end
		end,
		["isVisible"] = function ()
			return ex.Player.promotion_data:checkPromotionIsChristmas3Open()
		end
	},

	-- 嗨翻圣诞
	['act_christmas_happy'] = {
		["open"] = function (data)
			if ex.Player.promotion_data:checkPromotionIsChristmas4Open() then
				local layer = cfg.funcopen["act_christmas"].open()
				if layer then
					layer:resetSelectLayer(1404)
				end
			end
		end,
		["isVisible"] = function ()
			return ex.Player.promotion_data:checkPromotionIsChristmas4Open()
		end
	},

	-- 圣诞礼盒
	['act_christmas_giftbox'] = {
		["open"] = function (data)
			if ex.Player.promotion_data:checkPromotionIsChristmas5Open() then
				local layer = cfg.funcopen["act_christmas"].open()
				if layer then
					layer:resetSelectLayer(1405)
				end
			end
		end,
		["isVisible"] = function ()
			return ex.Player.promotion_data:checkPromotionIsChristmas5Open()
		end
	},
	-- 惊喜盲盒
	['act_christmas_surprise_blind_box'] = {
		["open"] = function (data)
			if ex.Player.promotion_data:checkPromotionIsChristmas6Open() then
				local layer = cfg.funcopen["act_christmas"].open()
				if layer then
					layer:resetSelectLayer(1406)
				end
			end
		end,
		["isVisible"] = function ()
			return ex.Player.promotion_data:checkPromotionIsChristmas6Open()
		end
	},

	-- 春日踏青活动
	['act_spring'] = {
		["open"] = function (data)
			if not ex.Player.promotion_data:checkPromotion93IsOpen() and
			not ex.Player.promotion_data:checkPromotion94IsOpen() and
			not ex.Player.promotion_data:checkPromotion95IsOpen() and
			not ex.Player.promotion_data:checkPromotion96IsOpen() then
				ex.MessageView:add(ex.Tools:getLang(32201))
				return
			end

			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAIN_SPRING)
			return layer
		end,
		["isVisible"] = function ()
			return ex.Player.promotion_data:checkPromotion93IsOpen()
				or ex.Player.promotion_data:checkPromotion94IsOpen()
				or ex.Player.promotion_data:checkPromotion95IsOpen()
				or ex.Player.promotion_data:checkPromotion96IsOpen()
		end
	},

	-- 活动一：春日踏青
	['act_spring_dice'] = {
		["open"] = function (data)
			if ex.Player.promotion_data:checkPromotion93IsOpen() then
				local layer = cfg.funcopen["act_spring"].open()
				if layer then
					layer:resetSelectLayer(1501)
				end
			end
		end,
		["isVisible"] = function ()
			return ex.Player.promotion_data:checkPromotion93IsOpen()
		end
	},

	-- 活动二：制作彩蛋
	['act_spring_eggs'] = {
		["open"] = function (data)
			if ex.Player.promotion_data:checkPromotion94IsOpen() then
				local layer = cfg.funcopen["act_spring"].open()
				if layer then
					layer:resetSelectLayer(1502)
				end
			end
		end,
		["isVisible"] = function ()
			return ex.Player.promotion_data:checkPromotion94IsOpen()
		end
	},	

	-- 活动三：春游记
	['act_spring_travel'] = {
		["open"] = function (data)
			if ex.Player.promotion_data:checkPromotion95IsOpen() then
				local layer = cfg.funcopen["act_spring"].open()
				if layer then
					layer:resetSelectLayer(1503)
				end
			end
		end,
		["isVisible"] = function ()
			return ex.Player.promotion_data:checkPromotion95IsOpen()
		end
	},	

	-- 活动四：出游寻春
	['act_spring_outing'] = {
		["open"] = function (data)
			if ex.Player.promotion_data:checkPromotion96IsOpen() then
				local layer = cfg.funcopen["act_spring"].open()
				if layer then
					layer:resetSelectLayer(1504)
				end
			end
		end,
		["isVisible"] = function ()
			return ex.Player.promotion_data:checkPromotion96IsOpen()
		end
	},
	
	-- 战马主界面
	["main_alice_wonderland"] = {
		["open"] = function (data)	
			if ex.Player.level < cfg.opencondition.condition["main_alice_wonderland"].condition_value then
				ex.MessageView:add(string.format(ex.Tools:getLang(47214), cfg.opencondition.condition["main_country_war"].condition_value))
				return
			end
			if ctr.alice.data.stage ~= 2 then
				ex.MessageView:add(string.format(ex.Tools:getLang(70703)))			
				return
			end

			ex.MainSceneCtr:runCloudAnimation(0.3, function()
				ex.MainSceneCtr:changeLayer(MainSceneType.ALICE_WONDERLAND)
			end)
		end,
		["isVisible"] = function ()
			return ex.Player.level >= cfg.opencondition.condition["main_alice_wonderland"].condition_value
		end,
	},

}
