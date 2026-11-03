local AliceCtr = class("AliceCtr", require("src.ex.BaseCtr"))

function AliceCtr:onInit()
    self.data = require("src.layer.alice.AliceData"):create()
end

function AliceCtr:registerResponse(response_ctr) 
    ----------------------------------Alice.proto-----------------------------------
    -- 爱丽丝信息
    response_ctr:addHandlerAuto(ProtocolID.GResAliceData, Alice_pb.GResAliceData, handler(self, self.aliceInfo))
    response_ctr:addHandlerAuto(ProtocolID.GResChallengeLevel, Alice_pb.GResChallengeLevel, handler(self, self.challengeLevel))
    response_ctr:addHandlerAuto(ProtocolID.GResResetStar, Alice_pb.GResResetStar, handler(self, self.resetStar))
    response_ctr:addHandlerAuto(ProtocolID.GResSelectPlayerAttr, Alice_pb.GResSelectPlayerAttr, handler(self, self.selectPlayerAttr))
    response_ctr:addHandlerAuto(ProtocolID.GResAliceRank, Alice_pb.GResAliceRank, handler(self, self.aliceRankInfo))
    response_ctr:addHandlerAuto(ProtocolID.GResAliceTopLog, Alice_pb.GResAliceTopLog, handler(self, self.topLog))
    response_ctr:addHandlerAuto(ProtocolID.GResAliceSelectAssist, Alice_pb.GResAliceSelectAssist, handler(self, self.selectAssist))
    response_ctr:addHandlerAuto(ProtocolID.GResAliceHeroDetail, Alice_pb.GResAliceHeroDetail, handler(self, self.heroDetail))
    response_ctr:addHandlerAuto(ProtocolID.GResAliceLineUpFighting, Alice_pb.GResAliceLineUpFighting, handler(self, self.heroFighting))
    response_ctr:addHandlerAuto(ProtocolID.GResAliceAssistDetail, Alice_pb.GResAliceAssistDetail, handler(self, self.assistHeroInfo))


    ----------------------------------AliceUnicorn.proto-----------------------------------
    -- 爱丽丝独角兽信息
    response_ctr:addHandlerAuto(ProtocolID.GResAliceUnicornData, AliceUnicorn_pb.GResAliceUnicornData, handler(self, self.unicornData))
    response_ctr:addHandlerAuto(ProtocolID.GResAliceUnicornStrength, AliceUnicorn_pb.GResAliceUnicornStrength, handler(self, self.unicornStrength))
    response_ctr:addHandlerAuto(ProtocolID.GResAliceUnicornUpGrade, AliceUnicorn_pb.GResAliceUnicornUpGrade, handler(self, self.unicornUpGrade))
    response_ctr:addHandlerAuto(ProtocolID.GResAliceUnicornWash, AliceUnicorn_pb.GResAliceUnicornWash, handler(self, self.unicornWash))
    response_ctr:addHandlerAuto(ProtocolID.GResAliceUnicornWashSave, AliceUnicorn_pb.GResAliceUnicornWashSave, handler(self, self.unicornWashSave))
    response_ctr:addHandlerAuto(ProtocolID.GResAliceUnicornReset, AliceUnicorn_pb.GResAliceUnicornReset, handler(self, self.unicornReset))
end

function AliceCtr:startTimer()
    if self.is_ctr_start_time then
        return
    end

    -- 30秒
    self:addTimer("update", 30000, handler(self, self.updateStatus), true)
end

function AliceCtr:updateStatus()
    local server_time = ex.Game:getServerTime()

    -- 刷新数据
end

----------------------- 请求协议 --------------------------
function AliceCtr:requestGetInfo()
    local config = cfg.funcopen["main_alice_wonderland"]
    if config and config.isVisible and config.isVisible() then
        NetManager:sendMessage(ProtocolID.GReqAliceData)
    end
end

function AliceCtr:reqRankData(star)
    local req = Alice_pb.GReqAliceRank()
	req.star = star
	NetManager:sendMessage(ProtocolID.GReqAliceRank, req)
end

function AliceCtr:reqRankTopData(star)
    local req = Alice_pb.GReqAliceTopLog()
	req.star = star
	NetManager:sendMessage(ProtocolID.GReqAliceTopLog, req)
end

function AliceCtr:reqUnicornInfo()
    local req = AliceUnicorn_pb.GReqAliceUnicornData()
    req.page = 1
    NetManager:sendMessage(ProtocolID.GReqAliceUnicornData, req)
end

-------------------------- 处理协议回调 -------------------------

----------------------------------Alice.proto-----------------------------------
-- 爱丽丝信息
function AliceCtr:aliceInfo(null, data)
    -- GResAliceInfo
    self.data.star_data = data.star_data
    self.data.end_time = data.next_stage_time
    self.data.stage = data.stage
    self.data:setAssitData()
    self.data:setStar(data.curr_star)
    self:reqRankData(self.data.star)
    if data.stage == 2 then
        self.data:checkAliceRed()
    end
    ex.EventManager:fire(EVENT.ALICE.ALICE_UPDATE_LAYER)
end

-- 挑战关卡
function AliceCtr:challengeLevel(null, data)
    -- GResChallengeLevel
    self.data.iswin = {}
    for i,v in ipairs(data.report) do
        local iswin = v.win_id ~= -1
        table.insert( self.data.iswin, iswin )  
    end
    self.data.enemy_attr = data.enemy_attr
    self.data:setEnemyAttr(data.enemy_attr)
    -- self.data.skill_point = data.skill_point
    self.data.report_num = #data.report
    ex.EventManager:fire(EVENT.ALICE.ALICE_START_BATTLE, BattleType.ALICE_TEAM_ONE)
    ex.EventManager:fire(EVENT.ALICE.ALICE_BATTLE_INFO, data.report[1], nil, data)
    
end

-- 重置星级
function AliceCtr:resetStar(null, data)
    -- GResResetStar
    for i,v in ipairs(self.data.star_data) do
        if  v.star == data.star_data.star then
            v.assist_battle = data.star_data
            v.assist_idx = data.star_data.assist_idx
            v.enemy_attr = data.star_data.enemy_attr
            v.had_first = data.star_data.had_first
            v.level_info = data.star_data.level_info
            v.player_attr = data.star_data.player_attr
            v.skill_point = data.star_data.skill_point
            v.star = data.star_data.star
        end
    end
    self.data:setAssitData(data.star_data.star,data.star_data.assist_idx)
    ex.EventManager:fire(EVENT.ALICE.ALICE_UPDATE_LAYER)
end

-- 选择属性
function AliceCtr:selectPlayerAttr(null, data)
    -- GResSelectPlayerAttr
    for i,v in ipairs(self.data.star_data) do
        if  v.star == self.data.star then
            v.player_attr = data.player_attr
            v.skill_point = data.skill_point
        end
    end
    ex.EventManager:fire(EVENT.ALICE.ALICE_UPDATE_RED_POINT)
    self.data:checkAliceRed()
end

-- 爱丽丝排行榜信息
function AliceCtr:aliceRankInfo(null, data)
    -- GResAliceRank
    self.data.rank_data = data

    ex.EventManager:fire(EVENT.ALICE.ALICE_RANK)
end

-- 大神战报
function AliceCtr:topLog(null, data)
    -- GResAliceTopLog
    self.data.rank_top_data = data.top_log

    ex.EventManager:fire(EVENT.ALICE.ALICE_RANK)
end

-- 选择支援
function AliceCtr:selectAssist(null, data)
    -- GResAliceSelectAssist
    for i,v in ipairs(self.data.star_data) do
        if v.star == data.star then
            v.assist_idx = data.idx
        end
    end
    self.data:setAssitData(data.star,data.idx)
    ex.EventManager:fire(EVENT.ALICE.ALICE_UPDATE_LAYER)

end

-- 查看英雄详细
function AliceCtr:heroDetail(null, data)
    -- GResAliceHeroDetail
    local data = data
    ex.EventManager:fire(EVENT.ALICE.ALICE_ASSIST_HERO_INFO,data)
end

--英雄阵容战力
function AliceCtr:heroFighting(null, data)
    self.data.fight = data.fighting
    ex.EventManager:fire(EVENT.ALICE.ALICE_UPDATE_FIGHT,data.line_up_type,data.fighting)
end

function AliceCtr:assistHeroInfo(null, data)
    local data = data
    ex.EventManager:fire(EVENT.ALICE.ALICE_ASSIST_HERO_INFO,data)
end


----------------------------------AliceUnicorn.proto-----------------------------------
-- 获取独角兽数据
function AliceCtr:unicornData(null, data)
    -- GResAliceUnicornData

    if data.page == 1 then
        self.data.unicorn_list = {}
    end

    for _,v in ipairs(data.unicorn_data) do
        table.insert(self.data.unicorn_list, v)
    end

    if data.page > 0 then
        local req = AliceUnicorn_pb.GReqAliceUnicornData()
        req.page = data.page + 1
        NetManager:sendMessage(ProtocolID.GReqAliceUnicornData, req)
    end

    ex.EventManager:fire(EVENT.ALICE.ALICE_UNICORN_UPDATE)
end

-- 独角兽强化
function AliceCtr:unicornStrength(null, data)
    -- GResAliceUnicornStrength

    self.data:unicornStrenthenDone(data.hero_id, data.strengthen_lv)

    ex.EventManager:fire(EVENT.ALICE.ALICE_UNICORN_UPDATE)
end

-- 独角兽突破
function AliceCtr:unicornUpGrade(null, data)
    -- GResAliceUnicornUpGrade

    self.data:unicornUpgradeDone(data.unicorn_data)

    local hero_data = ex.Player.hero_data:getHeroDataById(data.unicorn_data.hero_id)
    local occupation = cfg.herotype.star[hero_data.hero_type].occupation

    local unicorn_data = {}
    unicorn_data.unicorn_type = occupation
    unicorn_data.grade = data.unicorn_data.grade
    unicorn_data.level = data.unicorn_data.strengthen_lv
    unicorn_data.attr_data = data.unicorn_data.rare_attr[#data.unicorn_data.rare_attr]
    require("src.layer.alice.AliceUnicornUpgradeCtr"):instance():openWindow(unicorn_data)

    ex.EventManager:fire(EVENT.ALICE.ALICE_UNICORN_UPDATE)
end

-- 独角兽洗练
function AliceCtr:unicornWash(null, data)
    -- GResAliceUnicornWash

    self.data:unicornWashDone(data.hero_id, data.rare_attr)

    ex.EventManager:fire(EVENT.ALICE.ALICE_UNICORN_WASH)
end

-- 独角兽洗练
function AliceCtr:unicornWashSave(null, data)
    -- GResAliceUnicornWashSave

    self.data:unicornWashSaveDone(data.hero_id)

    ex.EventManager:fire(EVENT.ALICE.ALICE_UNICORN_WASH)
end

-- 独角兽重置
function AliceCtr:unicornReset(null, data)
    -- GResAliceUnicornReset

    self.data:unicornResetDone(data.unicorn_data)

    ex.EventManager:fire(EVENT.ALICE.ALICE_UNICORN_RESET)
end


return AliceCtr
