local DreamData = class("DreamData")

function DreamData:ctor()

    self.max_lv = 0
    self.cur_lv = 0
    self.curr_battle_lv = 0
    self.today_challenge_count = 0
    self.today_max_lv = 0
    self.today_init_lv = 0
    self.reward_lv = 0
    self.wait_next = false

    self.status = 0
    self.next_buff_id = {}
    self.curr_buff_id = 0
    self.hero_list = {}

    self.select_friend_hero = nil
    self.my_hero_data = nil
    self.friend_data_list = {}

    self.my_rank = -1

    self.firstreward = {}
    self.rewards = {}
    self:loadSaveConfig()
end

function DreamData:clean()

end


function DreamData:getDreamlandData()


end 

function DreamData:gResDreamlandData(data)

    self.max_lv = data.max_lv
    self.cur_lv = data.cur_lv
    -- self.curr_battle_lv = data.curr_battle_lv or self.curr_battle_lv
    self.today_challenge_count = data.today_challenge_count
    self.today_max_lv = data.today_max_lv
    self.today_init_lv = data.today_init_lv
    self.reward_lv = data.reward_lv

    -- self.status = data.status
    self.next_buff_id = data.next_buff_id
    self.curr_buff_id = data.curr_buff_id -- 当前选择buff
    --self.hero_list = data.hero_list       -- 阵容信息

    -- 处理基础信息
    self:loadSaveConfig()    

    ex.EventManager:fire(EVENT.DREAM_EVENT.MAIN_SHOW_BTN)

end


function DreamData:checkRedDot(  )
    local is_visible = self:getRedDot()
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHFB_YHMJRK_YHMJ, is_visible)
    return is_visible
end

function DreamData:getRedDot()
    local reward_config = ex.Player.dream_data:showNowFirstReward()
    if not reward_config then
        return false
    end

    if self.max_lv >= reward_config.idx then 
        return true
    end 

    -- if self.today_max_lv == 0 then 
    --     return true
    -- end

    -- if self.today_challenge_count == 0 then 
    --     return true
    -- end
    if ex.Tools:checkReddotStatusOnceDay(RedDotType.ZCJ_DHFB_YHMJRK_YHMJ,false) then
        return true
    end

    if not ex.Player.dream_data.my_hero_data then 
        return true
    end 

	if ex.Player.dream_data.my_hero_data.hero_id == 0 then 
		return true
	end 

    return false
end


function DreamData:setSelectFriend(data)
    self.select_friend_hero = data
    self.select_friend_hero.hero = data.hero_data
    self:setSelectFriendData(self.select_friend_hero.hero_data)
end 

function DreamData:setSelectFriendData( v )
    local HeroAbilityData = require("src.data.HeroAbilityData")
    local hero = HeroAbilityData.new()
    hero.hero_id = v.hero_id
    hero.hero_type = v.hero_type
    hero.level = v.level
    hero.stage = v.stage
    hero.star = v.star
    hero.elem = v.elem
    hero.atk = v.atk or 0
    hero.hp = v.hp or 0
    hero.def = v.def or 0
    hero.spd = v.spd or 0
    hero.occupation = v.occupation
    hero.is_lock = v.is_lock == 1
    hero.hp_up_level = v.hp_up_level
    hero.atk_up_level = v.atk_up_level
    hero.fighting = v.fighting
    hero.fashion_id = v.fashion_id
    hero.equip = {}
    hero.evolve = v.evolve

    self.select_friend_hero_data = hero
end

function DreamData:getMyHeroMaxFight( )
    
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


function DreamData:gResFriendAssistHeroList(data)

    self.select_friend_hero = data.friend_hero -- 选择好友的
    self.my_hero_data = data.hero_data   -- 我的出战
    self.friend_data_list = data.data_list
    self:setSelectFriendData(self.select_friend_hero.hero)
    -- 发送刷新
    
    local nslc = require("src.layer.dream.DreamFriendCtr"):instance()
	if nslc:isOpened() then
		-- 重新刷新界面
		nslc:firstUpdate()
    end

    ex.EventManager:fire(EVENT.DREAM_EVENT.UPDATE_FRIEND_RED)
    ex.Player.trial_data:checkRedDot()

end

function DreamData:gResDreamlandRank(data)

    -- 排名
    self.rank_list_data =  data
    -- 通知界面那数据
    self.my_rank =  data.my_rank.rank
    self.my_rank_data =  data.my_rank
    ex.EventManager:fire(EVENT.DREAM_EVENT.UPDATE_RANK)

end

function DreamData:gResDreamlandGetLevel()
    -- 领奖

end

function DreamData:gResDreamlandBattle(data)

    

end


function DreamData:loadSaveConfig()    
    
    -- for k,v in pairs(cfg.infinitefirstreward.infinitefirstreward) do
    --     local data = {}
    --     data.idx = v.idx
    --     data.reward = v.reward
    --     table.insert( self.firstreward, data )
    -- end

    -- local sort = function (  a,b )
    --     return a.idx<b.idx
    -- end
    -- table.sort( self.firstreward, sort )

end

function DreamData:showNowFirstReward( )
    -- 获得当前首通的奖励
    -- self.lv_reward_record 
    if cfg.infinitefirstreward.infinitefirstreward[self.reward_lv + 5] then 
        return cfg.infinitefirstreward.infinitefirstreward[self.reward_lv + 5]
    end 
    return nil

end

--获取最大通关奖励关卡
function DreamData:showMaxPass()
    local config =  cfg.infinitefirstreward.infinitefirstreward
    local max = 0
    for i,v in pairs(config) do
        if max < v.idx then
            max = v.idx
        end
    end
    return max
end


function DreamData:setUpdateData( ori_data)
    
    self.curr_buff_id = ori_data.curr_buff_id
    self.next_buff_id = ori_data.next_buff_id
    
    local battle_data = ori_data.battle
    local data = {}
    data.report = battle_data.report
    --data.line_up = battle_data.line_up
    data.rewards = battle_data.rewards
    data.cur_lv = battle_data.cur_lv
    data.today_max_lv = battle_data.today_max_lv
    data.max_lv = battle_data.max_lv
    data.status = battle_data.status
    data.curr_battle_lv = battle_data.curr_battle_lv
    self:setBattleInfo(data)
end


function DreamData:setRewards( rewards )
    
    self.rewards = rewards

    
end

function DreamData:setBattleInfo( data)
    
    -- -- 发布战斗
    -- print("-=-=1-22222222222222=3-45=3-=")
    -- dump(data)
    self.max_lv = data.max_lv
    self.cur_lv = data.cur_lv
    self.curr_battle_lv = data.curr_battle_lv
    self.today_max_lv = data.today_max_lv
    self.status = data.status
    self.rewards = data.rewards
    self:toDreamBattle(data.report)

end




function DreamData:toDreamBattle( report)

    ex.EventManager:fire(EVENT.DREAM_EVENT.LOAD_BATTLE)
    ex.EventManager:fire(EVENT.DREAM_EVENT.START_BATTLE, report)
    ex.EventManager:fire(EVENT.DREAM_EVENT.SHOW_REWARD_MESSAGE_PANEL)

    -- 这段是原有的代码
    -- if self.status == 2 then 
    --     -- local cur_main_type = ex.MainSceneCtr:getCurLayerType()
    --     -- if MainSceneType.DREAM_LAYER == cur_main_type then 
    --         ex.EventManager:fire(EVENT.DREAM_EVENT.LOAD_BATTLE)
    --         ex.EventManager:fire(EVENT.DREAM_EVENT.START_BATTLE, report)

    --     -- end 

    -- elseif self.status == 3 then 
        
    --     local cur_main_type = ex.MainSceneCtr:getCurLayerType()
    --     if MainSceneType.DREAM_LAYER == cur_main_type then 
    --         ex.EventManager:fire(EVENT.DREAM_EVENT.OPEN_SELECT_BUFF)
    --     end 
    -- end 

    -- ex.EventManager:fire(EVENT.DREAM_EVENT.SHOW_REWARD_MESSAGE_PANEL)
end

function DreamData:setLineUpData(line_data)
    local hero_list = {}
    for i,v in ipairs(line_data) do
        local now_hero_data = {}
        now_hero_data.elem = v.elem
        now_hero_data.hp = v.hp
        now_hero_data.level = v.level
        now_hero_data.max_hp = v.max_hp
        now_hero_data.pos = v.pos
        now_hero_data.star = v.star
        now_hero_data.type = v.type
        now_hero_data.fashion_id = v.fashion_id
        now_hero_data.evolve = v.evolve
        hero_list[now_hero_data.pos] = now_hero_data
    end
    self.hero_list = hero_list
end

function DreamData:gReqDreamlandWinAddLv()
    NetManager:sendMessage(ProtocolID.GReqDreamlandWinAddLv)
end

function DreamData:gReqDreamlandBattleStatus()
    NetManager:sendMessage(ProtocolID.GReqDreamlandBattleStatus)
end

function DreamData:setDreamBattleStatus(status)
    self.status = status



    -- -- 如果打开选择BUFF那就关闭她
    -- local nslc = require("src.layer.dream.DreamSelectCtr"):instance()
    -- if nslc:isOpened() then
    --     -- 重新刷新界面
    --     nslc:closeWindow()

    --     -- 要去拿
    --     ex.Player.dream_data:gReqDreamlandBattleReport()
    --     ex.EventManager:fire(EVENT.DREAM_EVENT.LOAD_BATTLE)
    -- end

    if self.status == 3 then
        ex.MainSceneCtr:removeKeepLayer(MainSceneType.DREAM_LAYER)
    end

    ex.EventManager:fire(EVENT.DREAM_EVENT.UPDATE_STATUS)

    -- self:addEvent(EVENT.DREAM_EVENT.UPDATE_STATUS,handler(self,self.updateStatus))

end


function DreamData:setDreamlandDispatchHero( )
    
end

function DreamData:setEnterBattle( report)
    self:toDreamBattle(report)
end


function DreamData:setDispatchHero(data)
    self.my_hero_data = data.hero
end


function DreamData:setSelectFriendHeroData( data)
    self.select_friend_hero = data
end

function DreamData:setFriendHeroData( data)
    self.my_hero_data = data
end


-- 推送最后一条战报
function DreamData:gReqDreamlandBattleReport()
    NetManager:sendMessage(ProtocolID.GReqDreamlandBattleReport)
end


function DreamData:gReqDreamlandEndBattle()
    NetManager:sendMessage(ProtocolID.GReqDreamlandEndBattle)
end


-- 基础信息
function DreamData:gReqDreamlandData()
    NetManager:sendMessage(ProtocolID.GReqDreamlandData)
end

-- 好友主战列表
function DreamData:gReqFriendAssistHeroList()
    NetManager:sendMessage(ProtocolID.GReqFriendAssistHeroList)
end

-- 拍横浜
function DreamData:gReqDreamlandRank()
    NetManager:sendMessage(ProtocolID.GReqDreamlandRank)
end

function DreamData:gReqDreamlandGetLevel(idx)
    local req = Dreamland_pb.GReqDreamlandGetLevel()
    req.idx = idx
    NetManager:sendMessage(ProtocolID.GReqDreamlandGetLevel, req)

    self.reward_lv = idx

    ex.EventManager:fire(EVENT.DREAM_EVENT.UPDATE_REWARD_MESSAGE_PANEL)
    -- ex.EventManager:fire(EVENT.DREAM_EVENT.SHOW_REWARD_MESSAGE_PANEL)

    ex.Player.trial_data:checkRedDot()
end

function DreamData:gReqDreamlandBattle()
    NetManager:sendMessage(ProtocolID.GReqDreamlandBattle)
end


function DreamData:gReqDreamlandDispatchHero(hero_id)
    local req = Dreamland_pb.GReqDreamlandDispatchHero()
    req.hero_id = hero_id
    NetManager:sendMessage(ProtocolID.GReqDreamlandDispatchHero, req)
end


function DreamData:gReqDreamlandStartBattle()
    NetManager:sendMessage(ProtocolID.GReqDreamlandStartBattle)
    -- NetManager:sendMessage(ProtocolID.GReqDreamlandStartBattle)
end


function DreamData:gReqDreamlandSelectBuff(idx)
    local req = Dreamland_pb.GReqDreamlandSelectBuff()
    req.idx = idx
    NetManager:sendMessage(ProtocolID.GReqDreamlandSelectBuff, req)
end



function DreamData:gReqDreamlandSelectFriend(rid)
    local req = Dreamland_pb.GReqDreamlandSelectFriend()
    req.rid = rid
    NetManager:sendMessage(ProtocolID.GReqDreamlandSelectFriend, req)

    -- local nslc = require("src.layer.dream.DreamFriendCtr"):instance()
	-- if nslc:isOpened() then
	-- 	nslc:updateFriendList()
    -- end

end




return DreamData
