
local DreamlandResponse = class("DreamlandResponse")

function DreamlandResponse:dreamlandData(ori_data)
-- print("-------------------")
-- dump_pbmsg(ori_data)

    local data = {}
    data.max_lv = ori_data.max_lv
    data.cur_lv = ori_data.cur_lv
    data.today_challenge_count = ori_data.today_challenge_count
    data.today_max_lv = ori_data.today_max_lv
    data.today_init_lv = ori_data.today_init_lv
    data.reward_lv = ori_data.reward_lv > 0 and ori_data.reward_lv or 0

    data.status = nil --ori_data.status
    data.next_buff_id = ori_data.next_buff_id
    data.curr_buff_id = ori_data.curr_buff_id -- 当前选择buff

    -- local hero_list = {}
    -- for i,v in ipairs(ori_data.state) do
    --     local now_hero_data = {}
    --     now_hero_data.elem = v.elem
    --     now_hero_data.hp = v.hp
    --     now_hero_data.level = v.level
    --     now_hero_data.max_hp = v.max_hp
    --     now_hero_data.pos = v.pos
    --     now_hero_data.star = v.star
    --     now_hero_data.type = v.type
    --     hero_list[now_hero_data.pos] = now_hero_data
    -- end

    -- data.hero_list = hero_list       -- 阵容信息
    ex.Player.dream_data:gResDreamlandData(data)
    ex.EventManager:fire(EVENT.DREAM_EVENT.UPDATE_NOW_LEVEL)
    -- ex.EventManager:fire(EVENT.DREAM_EVENT.UPDATE_REWARD_MESSAGE_PANEL)
end

function DreamlandResponse:friendAssistHeroList(ori_data)

    local save_data = {}
    local data_list = {}

    for i,v in ipairs(ori_data.assist_data) do
        local data = {}
        data.hero_data = v.hero
        data.friend_nick = v.friend_nick
        data.friend_id = v.friend_id
        data.type = 1 

        table.insert( data_list, data )
    end
    save_data.friend_hero = ori_data.friend_hero -- 选择好友的
    save_data.hero_data = ori_data.hero_data   -- 我的出战
    save_data.data_list = data_list

    ex.Player.dream_data:gResFriendAssistHeroList(save_data)
end

function DreamlandResponse:dreamlandRank(ori_data)

    local rank_data = {}
    rank_data.my_rank = ori_data.self_data
    rank_data.list = {}
    
    for i,v in ipairs(ori_data.list) do
        local now_data = {}
        now_data.player_id = v.player_id
		now_data.name = v.name
		now_data.clan_id = v.clan_id
		now_data.clan_name = v.clan_name
		now_data.clan_icon_id  = v.clan_icon_id 
		now_data.level  = v.level 
		now_data.head_id = v.head_id
		now_data.border_id = v.border_id
		now_data.complete_time  = v.complete_time 
		now_data.score  = v.score 
		now_data.server_id  = v.server_id 
		now_data.combat_num  = v.combat_num 
        now_data.rank  = v.rank 
        table.insert( rank_data.list , now_data )
    end
    ex.Player.dream_data:gResDreamlandRank(rank_data)
end

function DreamlandResponse:dreamlandGetLevel(ori_data)
    ex.Player.dream_data:gResDreamlandGetLevel()

    ex.EventManager:fire(EVENT.DREAM_EVENT.UPDATE_NOW_LEVEL)
end



--  推送最后一条战报   特殊情况进入
function DreamlandResponse:dreamlandBattleReport( ori_data)
    ex.Player.dream_data.status = 2 -- 显示下一关奖励
    ex.Player.dream_data.curr_battle_lv = ori_data.curr_battle_lv
    ex.Player.dream_data.curr_buff_id = ori_data.curr_buff_id
    ex.Player.dream_data:setRewards(ori_data.rewards)
    ex.Player.dream_data:setEnterBattle(ori_data.report)
    ex.EventManager:fire(EVENT.DREAM_EVENT.UPDATE_NOW_LEVEL)
    ex.EventManager:fire(EVENT.DREAM_EVENT.SHOW_REWARD_MESSAGE_PANEL)
    require("src.layer.dream.DreamSelectCtr"):instance():closeWindow()
end



function DreamlandResponse:dreamlandEndBattle( ori_data)

    --dump_pbmsg(ori_data)
    local save_data = {}
    save_data.status = ori_data.battle_state
    save_data.rewards= ori_data.rewards
    ex.Player.dream_data.curr_battle_lv = ex.Player.dream_data.today_init_lv + 1
    ex.Player.dream_data.status = save_data.status
    ex.Player.dream_data:setRewards(ori_data.rewards)
    -- ex.Player.dream_data:setDreamBattleStatus(save_data.status)

    ex.Player.dream_data:gReqDreamlandData()
    ex.Player.dream_data:gReqDreamlandRank()
    -- 通知界面发送关闭
    
    --require("src.layer.ItemRewardCtr"):instance():openWindow(save_data.rewards)

end


function DreamlandResponse:dreamlandBattleStatus(ori_data)
    ex.Player.dream_data.status = ori_data.status
    ex.Player.dream_data.curr_battle_lv = ori_data.curr_battle_lv

    if ex.Player.dream_data.status == 1 then
        require("src.layer.dream.DreamSelectCtr"):instance():closeWindow()
    end

    ex.EventManager:fire(EVENT.DREAM_EVENT.MAIN_SHOW_BTN)
end


function DreamlandResponse:dreamlandBattle(ori_data)
    local data = {}
    data.report = ori_data.report
    --data.line_up = ori_data.line_up
    data.rewards = ori_data.rewards
    data.cur_lv = ori_data.cur_lv
    -- data.curr_battle_lv = ori_data.curr_battle_lv    
    data.today_max_lv = ori_data.today_max_lv
    data.max_lv = ori_data.max_lv
    -- data.status = ori_data.status
    data.curr_battle_lv = ori_data.curr_battle_lv
    
    -- 判断打开状态，如果打开，发送选择BUFF
    if data.status == 3 then 
        -- 发送消息

    end 

    ex.Player.dream_data:setBattleInfo(data)

    ex.EventManager:fire(EVENT.DREAM_EVENT.MAIN_SHOW_BTN)
    ex.EventManager:fire(EVENT.DREAM_EVENT.UPDATE_NOW_LEVEL)

end

function DreamlandResponse:dreamlandDispatchHero(ori_data)

    local data = {}
    data.hero = ori_data.hero
    
    
    ex.Player.dream_data:setDispatchHero(data)

    ex.EventManager:fire(EVENT.DREAM_EVENT.UPDATE_FRIEND_RED)

end


function DreamlandResponse:dreamlandSelectFriend(ori_data)

    -- 选择成功
    -- self.friend_rid =  ori_data.rid

    local nslc = require("src.layer.dream.DreamFriendCtr"):instance()
	if nslc:isOpened() then
		-- 重新刷新界面
		nslc:updateFriendList()
    end
    
    ex.EventManager:fire(EVENT.DREAM_EVENT.UPDATE_FRIEND_RED)

end

function DreamlandResponse:dreamlandStartBattle(ori_data)

    local line_up = ori_data.line_up
    ex.Player.dream_data:setLineUpData(line_up)

    -- 开去
    local nslc = require("src.layer.dream.DreamSelectCtr"):instance()
	if nslc:isOpened() then
		-- 重新刷新界面
		nslc:updateHeroData()
    end
end

function DreamlandResponse:dreamlandSelectBuff(ori_data)
    local save_data = {}
    save_data.curr_buff_id = ori_data.curr_buff_id
    save_data.next_buff_id = ori_data.next_buff_id
    save_data.battle = ori_data.battle
    save_data.battle.status = 2 -- 后端没有返回该值。如果为其他值。则会删除战斗界面-- 显示下一关奖励
    -- ex.EventManager:fire(EVENT.DREAM_EVENT.SHOW_REWARD_MESSAGE_PANEL)
    ex.Player.dream_data:setUpdateData(save_data)
    ex.EventManager:fire(EVENT.DREAM_EVENT.MAIN_SHOW_BTN)
    require("src.layer.dream.DreamSelectCtr"):instance():closeWindow()


    -- ex.Player.dream_data:gReqDreamlandBattleStatus()
end


function DreamlandResponse:dreamlandWinAddLv(ori_data)
    ex.Player.dream_data.status = ori_data.status
    ex.Player.dream_data.curr_battle_lv = ori_data.curr_battle_lv
    ex.Player.dream_data.cur_lv = ori_data.cur_lv
    ex.Player.dream_data.today_max_lv = ori_data.today_max_lv
    ex.Player.dream_data.max_lv = ori_data.max_lv

    ex.Player.dream_data:setDreamBattleStatus(ori_data.status)

    ex.EventManager:fire(EVENT.DREAM_EVENT.SHOW_REWARD_MESSAGE_PANEL)
    ex.EventManager:fire(EVENT.DREAM_EVENT.MAIN_SHOW_BTN)

    ex.Player.dream_data:gReqDreamlandData()

end

return DreamlandResponse