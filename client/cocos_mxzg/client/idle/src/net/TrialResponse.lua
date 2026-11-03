local TrialResponse = class("TrialResponse")

function TrialResponse:getTrialCfg(data)
	local max_mission_id = 1
	for i,v in ipairs(data.data) do
		if v.mission_id > max_mission_id then
			max_mission_id = v.mission_id
		end
	end
	
	local mission_id = max_mission_id
	ex.Player.trial_data:setMissionId(mission_id)
	ex.Player.trial_data.hard_lv = data.level
	ex.Player.trial_data.today_select = data.today_select
	ex.Player.trial_data.pass_lv = data.pass_lv
	ex.Player.trial_data.vec_data = data.data
	ex.Player.trial_data.vec_hp_left = data.hero_hp
	ex.Player.trial_data.vec_today_reward = data.reward
	require("src.scene.LoadingSceneCtr"):instance():receivedProtocol(ProtocolID.GResTrialCfg)

	-- dump(data.data, "data.data")
	if ex.Player.trial_data.today_select then
		ex.Player.trial_data.red_state = false
	end
	ex.EventManager:fire(EVENT.TRIAL_EVENT.TRIAL_END)
	ex.Player.trial_data:checkRedDot()
end

function TrialResponse:trialPass(data,byte_array)
	ex.Player.promotion_data:reqAdventureList()

	ex.Player.trial_data.red_state = false

	local items = {}
	for i,v in ipairs(data.items) do
		local item_id = v.id 
		local item_type = v.type 
		local item_num = v.num
		table.insert(items,{item_id = item_id ,item_type = item_type , item_num = item_num})
	end
	ex.EventManager:fire(EVENT.TRIAL_EVENT.TRIAL_START, data.report, items)
	
	NetManager:sendMessage(ProtocolID.GReqTrialCfg)

	-- ex.Player.trial_data:checkRedDot()
end

function TrialResponse:trialBox(data, byte_array)

	local tmp_data = {}
	tmp_data.mission_id = data.mission_id
	tmp_data.status = data.status
	tmp_data.def_border_id = 0
	tmp_data.def_fighting = 0
	tmp_data.def_head_id = 0
	tmp_data.def_level = 0
	tmp_data.def_nick = ""
	tmp_data.hero_data = {}
	table.insert(ex.Player.trial_data.vec_data, tmp_data)

	ex.EventManager:fire(EVENT.TRIAL_EVENT.TRIAL_GET_BOX)
	
	NetManager:sendMessage(ProtocolID.GReqTrialCfg)

	-- print("77777777")
	ex.Player.trial_data:checkRedDot()
end


function TrialResponse:shopList(byte_array)
	ex.Player.trial_data:clearShop(byte_array:readByte())
	local list_count = byte_array:readInt()

	for i=1,list_count do
		local data = {}
		data.index = byte_array:readInt()

		data.goods = {}
		data.goods.item_id = byte_array:readInt64()
		data.goods.item_type = byte_array:readInt()
		data.goods.item_num = byte_array:readInt()

		data.need = {}
		data.need.item_type = byte_array:readInt()
		data.need.item_num = byte_array:readInt()

		data.limit = {}
		data.limit.count = byte_array:readInt()
		data.limit.times = byte_array:readInt()
		
		ex.Player.trial_data:addShopData(data)
	end

	-- 刷新商店
	require("src.layer.TrialShopCtr"):instance():updateLayer()
end

function TrialResponse:battleHeroList(data, byte_array)
	local data = NetManager:resLuaData(ProtocolResponse.ResTrialBattleHeroList, byte_array)
	for k,v in pairs(data.list) do
		ex.Player.trial_data:setBattleHero(v)
	end
end

function TrialResponse:battleList(data)
	ex.Player.trial_data.vec_battle = data.list
end

function TrialResponse:redState(data)
	ex.Player.trial_data.red_state = data.red_state == 1
	ex.Player.trial_data:checkRedDot()
	-- ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_YZSL, ex.Player.trial_data.red_state)
end

function TrialResponse:friendAssistHeroList(data)
    local save_data = {}
    local data_list = {}

    for i,v in ipairs(data.assist_data) do
        local tmp_data = {}
        tmp_data.hero_data = v.hero
        tmp_data.friend_nick = v.friend_nick
        tmp_data.friend_id = v.friend_id
		tmp_data.type = 1 
		tmp_data.had_battle = v.had_battle

        table.insert( data_list, tmp_data )
    end
    save_data.friend_hero = data.friend_hero -- 选择好友的
    save_data.hero_data = data.hero_data   -- 我的出战
    save_data.data_list = data_list

	ex.Player.trial_data:gResFriendAssistHeroList(save_data)
end

function TrialResponse:dispatchHero(data)
    NetManager:sendMessage(ProtocolID.GReqAdvenAssistHeroList)
end

function TrialResponse:selectFriend(data)
    NetManager:sendMessage(ProtocolID.GReqAdvenAssistHeroList)
end

function TrialResponse:selectHard(data)
	ex.Player.trial_data.hard_lv = data.lv

	NetManager:sendMessage(ProtocolID.GReqTrialCfg)

	if ex.JumpManager:checkOpenConditionByAtomNoMsg("main_proving_lang") then 
        ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_TRIAL)
    end 
end

return TrialResponse
