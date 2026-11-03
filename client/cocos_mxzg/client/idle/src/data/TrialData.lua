local TrialData = class("TrialData")

function TrialData:ctor()
	self.red_state = false

	self.hard_lv = 0		-- 当前难度，<= 0: 未选择难度
	self.today_select = false	-- 当前是否已选择难度
	self.pass_lv = 0		-- 当前可以挑战的最大难度
	self.mission_id = 0	   -- 当前关卡
	self:registerEvent()

	-- 战斗数据
	self.vec_data = {}
	self.vec_hp_left = {}

	-- 每日所获的资源
	self.vec_today_reward = {}

	-- 好友支援
	self.select_friend_hero = nil
	self.my_hero_data = nil
	self.friend_data_list = {}
end

function TrialData:registerEvent()
	self.event_list = {

	}
end

function TrialData:removeEvent()
	if self.event_list ~= nil then 
		for k,v in pairs(self.event_list) do
			ex.EventManager:remove(v)
		end
	end
end

function TrialData:clear()
	self:removeEvent()
	self.mission_id = nil
end

function TrialData:setMissionId(mission_id)
	self.mission_id = mission_id
end

function TrialData:getMissionId()
	return self.mission_id
end

function TrialData:getBattleData(idx)
	for k,v in ipairs(self.vec_data) do
		if v.mission_id == idx then
			return v
		end
	end
	return nil
end

function TrialData:getLineupHero(hero_id)
	return TableEx.findValueFunction(self.vec_hp_left, function(v)
		return v.hero_id == hero_id
	end)
end

-- -1 不可领取 0:可领取  1：已领取
function TrialData:getBoxStatus(mission_id)
	local max_mission_id = 1
	local battle_data = nil
	for i,v in pairs(self.vec_data) do
		if v.mission_id == mission_id then
			battle_data = v
		end

		if v.mission_id > max_mission_id then
			max_mission_id = v.mission_id
		end
	end

	-- 上一关信息
	local pre_data = self:getBattleData(mission_id - 1)

	-- 关卡id比箱子id大。没有数据或领取状态为未领取的话。则可以领取
	if (mission_id - 1) <= (max_mission_id) and (pre_data and pre_data.status == 1) and (battle_data == nil or battle_data.status == 0) then
		return 0
	end

	-- 有数据。且已经领取了
	if battle_data ~= nil and battle_data.status == 1 then
		return 1
	end

	return -1
end


function TrialData:returnCheckRedDot( )
	
	local config = cfg.opencondition.condition["main_proving_lang"]
	if (not config) or config.condition_type ~= 1 or config.condition_value > ex.Player.level then
		return
	end

	-- 有箱子可以领取。并且红点状态是真
	local is_visible = false
	for i,v in ipairs(cfg.mainadventurepos.pos) do
		if v.type == TRIAL_TYPE.BOX then
			local status = self:getBoxStatus(v.idx)
			if status == 0 then
				is_visible = true
				break
			end
		end
	end

	is_visible = is_visible == true or self.red_state == true
	return is_visible
end

function TrialData:checkRedDot()
	-- 判断等级
	local config = cfg.opencondition.condition["main_proving_lang"]
	if (not config) or config.condition_type ~= 1 or config.condition_value > ex.Player.level then
		return
	end

	-- 有箱子可以领取。并且红点状态是真
	local is_visible = false
	for i,v in ipairs(cfg.mainadventurepos.pos) do
		if v.type == TRIAL_TYPE.BOX then
			local status = self:getBoxStatus(v.idx)
			if status == 0 then
				is_visible = true
				break
			end
		end
	end

	-- -- 那就放进来统一检测吧，好像不靠谱啊
	-- if is_visible == false then 
	-- 	is_visible = ex.Player.dream_data:checkRedDot()
	-- end 

	is_visible = is_visible == true or self.red_state == true
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHFB_YZSLRK_YZSL, is_visible)
end

function TrialData:getMyHeroMaxFight( )
    local sort = function ( a,b )
        return a.fighting > b.fighting
    end

    local my_hero_list = {}
    for i,v in ipairs(ex.Player.hero_data.hero_list) do
        table.insert(my_hero_list, v)
    end
    table.sort( my_hero_list, sort )
    
	return my_hero_list[1].fighting
end

-- 转换类别，主要是为了abilitydata里的函数方法
function TrialData:getAbilityData(data)
    local hero = require("src.data.HeroAbilityData").new()
    hero.hero_id = data.hero_id
    hero.hero_type = data.hero_type
    hero.level = data.level
    hero.stage = data.stage
    hero.star = data.star
	hero.elem = data.elem
	hero.atk = data.atk or 0
    hero.hp = data.hp or 0
    hero.def = data.def or 0
    hero.spd = data.spd or 0
    hero.occupation = data.occupation
    hero.is_lock = data.is_lock == 1
    hero.hp_up_level = data.hp_up_level
    hero.atk_up_level = data.atk_up_level
    hero.fighting = data.fighting
	hero.equip = {}
	hero.had_battle = false
	hero.fashion_id = data.fashion_id

    return hero
end

function TrialData:setSelectFriend(data, is_select)
	if is_select == true then
		for i,v in ipairs(self.friend_data_list) do
			if v.friend_id == data.friend_id then
				local req = Adven_pb.GReqAdvenSelect()
				req.hero_id = v.hero_data.hero_id
				req.friend_id = data.friend_id
				req.select = true
				NetManager:sendMessage(ProtocolID.GReqAdvenSelect, req)

				local tmp_data = clone(data)
				tmp_data.hero = data.hero_data
				tmp_data.hero_data = self:getAbilityData(data.hero_data)

				table.insert(self.select_friend_hero, tmp_data)
				return
			end
		end
	else
		for i,v in ipairs(self.select_friend_hero) do
			if v.hero.hero_id == data.hero_data.hero_id then
				local req = Adven_pb.GReqAdvenSelect()
				req.hero_id = v.hero.hero_id
				req.friend_id = data.friend_id
				req.select = false
				NetManager:sendMessage(ProtocolID.GReqAdvenSelect, req)

				table.remove(self.select_friend_hero, i)
				return
			end
		end
	end
end 

-- 好友主战列表
function TrialData:gReqFriendAssistHeroList()
    NetManager:sendMessage(ProtocolID.GReqAdvenAssistHeroList)
end

function TrialData:setDispatchHero(data)
	table.insert(self.my_hero_data, data)

	local req = Adven_pb.GReqAdvenAssist()
    req.hero_id = data.hero_id
    NetManager:sendMessage(ProtocolID.GReqAdvenAssist, req)
end

function TrialData:gResFriendAssistHeroList(data)
	self.select_friend_hero = {}
	for i,v in ipairs(data.friend_hero) do
		local tmp_data = clone(v.hero)
		tmp_data.hero = v.hero
		tmp_data.hero_data = self:getAbilityData(v.hero)

		table.insert(self.select_friend_hero, tmp_data)
	end
    self.my_hero_data = data.hero_data   -- 我的出战
	self.friend_data_list = data.data_list
	
	-- 发送刷新
	local is_visible = ex.Player.level >= cfg.opencondition.condition["main_proving_lang"].condition_value and #data.hero_data < ex.Tools:getSysCfg("adventure_assist_num")
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHFB_YZSLRK_YZSL_ZYRK_WDZY, is_visible)
	
    local help_ctr = require("src.layer.TrialHelpCtr"):instance()
	if help_ctr:isOpened() then
		-- 重新刷新界面
		help_ctr:updateScroll()
    end
end

return TrialData
