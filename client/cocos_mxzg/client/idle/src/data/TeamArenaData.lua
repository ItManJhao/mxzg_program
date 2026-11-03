local TeamArenaData = class("TeamArenaData")

function TeamArenaData:ctor()

    self.curr_state = 1    --//1未开启；2组队阶段；3挑战阶段；4结算阶段
    self.next_state_time = 0   --   下一个状态时间
    

    self.curr_rank_list = {}
    self.curr_my_team_data = {}

    self.challenge_count = 0
    self.last_add_time = 0
    self.battle_reward_list = {}
    self.curr_battle_reward_num = 0


    self.battle_rank_list = {}
    self.curr_battle_rank_reward_num = 0


    self.cur_battle_team_id = 0 
    self.battle_data = {}
    self.cur_battle_data = {}

    self.had_sign = false 


end



function TeamArenaData:checkBattleRewardRed( )
    
    -- 检测列表红点
    
    for _,v in pairs(cfg.teamarenachallengereward.teamarenachallengereward) do
        if self.curr_battle_reward_num >= v.need_count and self:getBattleRewardstatus(v.idx) == false   then 
            return true 
        end 
    end
    return false 

end


function TeamArenaData:saveTeamArenaData( data )
    self.challenge_count = data.challenge_count
    self.last_add_time = data.last_add_time


    self.battle_reward_list = data.reward_idx
    self.curr_battle_reward_num = data.had_challenge_count

end


function TeamArenaData:saveOrderTeamArenaBattleData( data )
    self.cur_battle_data = data
    self.battle_data.report_index = self.cur_battle_data.report_index
end



function TeamArenaData:saveTeamArenaBattleData( data )
    self.battle_data = data
end


function TeamArenaData:saveBattleRewardList( idx )
    table.insert(self.battle_reward_list,idx )
end

function TeamArenaData:getBattleRewardstatus( idx)

    for i,v in ipairs(self.battle_reward_list) do
        if v == idx then 
            return true
        end 
    end
    return false     
end

-- function TeamArenaData:saveBattleRankRewardList( data )
   
-- end


-- function TeamArenaData:getBattleRankRewardstatus( idx)
--     return false     
-- end


function TeamArenaData:saveTeamArenaState( data )
    
    self.curr_state = data.curr_state
    self.next_state_time = data.next_state_time

end


function TeamArenaData:saveTeamArenaRank( data)
    self.curr_rank_list = data.rank_list
    self.curr_my_team_data = data.self
    self.had_sign = data.had_sign
    -- dump(data)
    -- print("self.had_signself.had_signself.had_sign", self.had_sign)

end


return TeamArenaData