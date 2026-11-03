--[[
    func: 国战 - 接受数据
    版权所有:广州暗耀晶石网络信息科技有限公司
]]
local CountryWarCtr = class("CountryWarCtr", require("src.ex.BaseCtr"))

function CountryWarCtr:onInit()
    self.data = require("src.layer.countrywar.CountryWarData"):create()
end

function CountryWarCtr:registerResponse(response_ctr) -- 国战数据
    response_ctr:addHandlerAuto(ProtocolID.GResCountryWarTime, CountryWar_pb.GResCountryWarTime, handler(self, self.setCountryWarTime))
    response_ctr:addHandlerAuto(ProtocolID.GResCountryWarCity, CountryWar_pb.GResCountryWarCity, handler(self, self.setCountryWarInfo))
    response_ctr:addHandlerAuto(ProtocolID.GResCountryWarSmallCity, CountryWar_pb.GResCountryWarSmallCity, handler(self, self.setCountryWarAloneInfo))
    response_ctr:addHandlerAuto(ProtocolID.GResCountryWarAttackCity, CountryWar_pb.GResCountryWarAttackCity, handler(self, self.handleAttackCity))
    response_ctr:addHandlerAuto(ProtocolID.GResCountryWarMoveCity, CountryWar_pb.GResCountryWarMoveCity, handler(self, self.handleMoveCity))
    
    --排行榜
    response_ctr:addHandlerAuto(ProtocolID.GResCountryWarRank, CountryWar_pb.GResCountryWarRank, handler(self, self.handleCountryWarRankInfo))
    --积分成就
    response_ctr:addHandlerAuto(ProtocolID.GResCountryWarScore, CountryWar_pb.GResCountryWarScore, handler(self, self.handleCountryWarScoreInfo))
    --领取积分任务
    response_ctr:addHandlerAuto(ProtocolID.GResCountryWarScoreMissionGet, CountryWar_pb.GResCountryWarScoreMissionGet, handler(self, self.handleCountryWarScoreMissionGetInfo))
    --更新积分任务
    response_ctr:addHandlerAuto(ProtocolID.GResCountryWarScoreMissionUpdate, CountryWar_pb.GResCountryWarScoreMissionUpdate, handler(self, self.handleCountryWarScoreMissionUpdateInfo))
    --积分奖励领取
    response_ctr:addHandlerAuto(ProtocolID.GResCountryWarScoreGet, CountryWar_pb.GResCountryWarScoreGet, handler(self, self.handleCountryWarScoreGetInfo))
    --购买积分奖励礼包
    response_ctr:addHandlerAuto(ProtocolID.GResCountryWarScoreBuyGem, CountryWar_pb.GResCountryWarScoreBuyGem, handler(self, self.handleCountryWarScoreBuyGem))
    --领取城池收益
    response_ctr:addHandlerAuto(ProtocolID.GResCountryWarGetCityReward, CountryWar_pb.GResCountryWarGetCityReward, handler(self, self.handleCountryWarGetCityReward))
    --抽奖
    response_ctr:addHandlerAuto(ProtocolID.GResCountryWarLottery, CountryWar_pb.GResCountryWarLottery, handler(self, self.handleCountryWarLotteryInfo))
    --抽奖轮次
    response_ctr:addHandlerAuto(ProtocolID.GResCountryWarLotteryData, CountryWar_pb.GResCountryWarLotteryData, handler(self, self.handleCountryWarLotteryDataInfo))
    --战旗任务
    response_ctr:addHandlerAuto(ProtocolID.GResCountryWarFlag, CountryWar_pb.GResCountryWarFlag, handler(self, self.handleCountryWarFlagInfo))
    --领取战旗任务
    response_ctr:addHandlerAuto(ProtocolID.GResCountryWarFlagMissionGet, CountryWar_pb.GResCountryWarFlagMissionGet, handler(self, self.handleCountryWarFlagMissionGetInfo))
    --更新战旗任务
    response_ctr:addHandlerAuto(ProtocolID.GResCountryWarFlagMissionUpdate, CountryWar_pb.GResCountryWarFlagMissionUpdate, handler(self, self.handleCountryWarFlagMissionUpdateInfo))
    --领取战旗轮次奖励
    response_ctr:addHandlerAuto(ProtocolID.GResCountryWarFlagRoundGet, CountryWar_pb.GResCountryWarFlagRoundGet, handler(self, self.handleCountryWarFlagRoundGetInfo))
    --战场日志
    response_ctr:addHandlerAuto(ProtocolID.GResCountryWarServerLog, CountryWar_pb.GResCountryWarServerLog, handler(self, self.handleCountryWarServerLog))
    --角色日志
    response_ctr:addHandlerAuto(ProtocolID.GResCountryWarRoleLog, CountryWar_pb.GResCountryWarRoleLog, handler(self, self.handleCountryWarRoleLog))
    --随机商城
    response_ctr:addHandlerAuto(ProtocolID.GResCountryWarRandomShop, CountryWar_pb.GResCountryWarRandomShop, handler(self, self.handleCountryWarRandomShop))
    --随机商城购买
    response_ctr:addHandlerAuto(ProtocolID.GResCountryWarRandomShopBuy, CountryWar_pb.GResCountryWarRandomShopBuy, handler(self, self.handleCountryWarRandomShopBuy))
    --积分变动
    response_ctr:addHandlerAuto(ProtocolID.GResCountryWarScoreUpdate, CountryWar_pb.GResCountryWarScoreUpdate, handler(self, self.handleCountryWarScoreUpdate))
      
end

-- 阶段数据
function CountryWarCtr:setCountryWarTime(null, data)
    -- optional int32 stage = 1; //阶段
    -- optional int32 start_time = 2; //当前阶段开始时间
    -- optional int32 next_stage_time = 3; //下一阶段时间
    -- optional bool had_join = 4; //是否参赛
    self.data.stage = data.stage                
    self.data.type = data.type    
    self.data.start_time = data.start_time                         
    self.data.next_stage_time = data.next_stage_time                     
    self.data.had_join = data.had_join  
    self.data.round = data.round ~= nil and data.round or 1  
    self.data.main_server_id = data.main_server_id

    --购买积分奖励礼包红点赛季开始时展示一次 
    if self.data.stage == 1 then
        cc.UserDefault:getInstance():setBoolForKey(string.format("%sintegral_gift_red", ex.Player.role_id), true)
    end                     

    if self.data:isOpen() then
        self:gReqCountryWarCity()
        self:gReqCountryWarScore()	
        self:gReqCountryWarFlag()
        self.data:setLotterRed()
    end
end

-- 设置大城池数据
function CountryWarCtr:setCountryWarInfo(null, data)
    if not self.data:isOpen() then return end
    local my_big_city = 0
    for k,v in pairs(data.cities) do
        if v.server_id == self.data:getMainServer() and cfg.countrywarcity.countrywarcity[v.idx].type == 1 then
            my_big_city = v.idx
            break
        end
    end
    
    data.curr_id = data.curr_id == 0 and my_big_city or data.curr_id
    self.data:setCurrId(data.curr_id) 
    self.data:setCities(data.cities)
    self.data:setServers(data.servers)
    self.data:setItemTime(data.attack_add_time,data.move_add_time)
    self.data:setAttackNum(data.attack_item_num)
    self.data:setMoveNum(data.move_item_num)
    self.data:setHadReward(data.had_reward)
    ex.EventManager:fire(EVENT.COUNTRY_WAR.ALL_CITY)
end

-- 获得国战单个城市的信息 城内界面显示  小城市
function CountryWarCtr:setCountryWarAloneInfo(null,data)
    if not self.data:isOpen() then return end
    if self.data:getChoiceidx() ~= data.idx then return end 

    self.data.small_cities = data.small_cities
    self.data.occupy_time = data.occupy_time

        -- ex.EventManager:fire(EVENT.COUNTRY_WAR.ALONE_CITY)          -- 跳转到城内
    ex.EventManager:fire(EVENT.COUNTRY_WAR.UPDAT_SMALL_CITY)    -- 刷新城内的信息
end

-- 攻城数据
function CountryWarCtr:handleAttackCity(null,data)
    -- optional int32 curr_id = 1; //当前位置
    -- optional int32 idx = 2;
    -- optional PSBackpackData reward = 3; //奖励
    -- repeated PSCountryWarCity cities = 4; //只有改变的城池数据
    -- repeated PSCountryWarServerFaction faction = 5; //阵营
    -- optional BattleReport report = 6; //战报
    -- optional int32 attack_item_num = 7; //攻击令数量
    self.data:setChoiceidx(data.idx)
    self.data:setCurrId(data.curr_id)
    self.data:UpdataCities(data.cities) -- 刷新大地圖的數據
    self.data:setServers(data.faction)
    self.data:setAttackNum(data.attack_item_num)

    -- 请求当前小城市数据 
    self:gReqCountryWarSmallCity(data.idx)

    ex.EventManager:fire(EVENT.COUNTRY_WAR.ATTACK_INFO,data)
end

-- 迁移数据
function CountryWarCtr:handleMoveCity(null,data)
    -- optional int32 curr_id = 1; //当前所在城池
    -- optional int32 idx = 2; //请求的大城池id返回
    -- optional int32 move_item_num = 3; //移动令数
    -- repeated PSCountryWarCity cities = 4; //小城池数据
    self.data:setChoiceidx(data.idx) 
    self.data:setCurrId(data.curr_id)
    self.data:UpdataCities(data.cities)
    self.data:setMoveNum(data.move_item_num)

    -- 请求当前小城市数据 
    self:gReqCountryWarSmallCity(data.idx)
end

--排行榜数据
function CountryWarCtr:handleCountryWarRankInfo(null, data)
    self.data:setRankInfo(data)
end

--积分成就
function CountryWarCtr:handleCountryWarScoreInfo(null, data)
    self.data:setScoreInfo(data)
end

 --领取积分任务
function CountryWarCtr:handleCountryWarScoreMissionGetInfo(null, data)
    self.data:setScoreMissionGetInfo(data)
end

--更新积分任务
function CountryWarCtr:handleCountryWarScoreMissionUpdateInfo(null, data)
    self.data:setScoreMissionUpdateInfo(data)
end

--积分奖励领取
function CountryWarCtr:handleCountryWarScoreGetInfo(null, data)
    self.data:setScoreGetInfo(data)
end

--积分变动
function CountryWarCtr:handleCountryWarScoreUpdate(null, data)
    self.data:setScoreNum(data)
end

--积分礼包购买
function CountryWarCtr:handleCountryWarScoreBuyGem(null, data)
    self.data:setScoreBuyGem(data)
end

--抽奖
function CountryWarCtr:handleCountryWarLotteryInfo(null, data)
    self.data:setLotterData(data)
end

--抽奖轮次
function CountryWarCtr:handleCountryWarLotteryDataInfo(null, data)
    self.data:setLotterRound(data)
end

 --战旗任务
function CountryWarCtr:handleCountryWarFlagInfo(null, data)
    self.data:setTaskRewardData(data)
end

--领取战旗任务
function CountryWarCtr:handleCountryWarFlagMissionGetInfo(null, data)
    self.data:setGetTaskRewardData(data)
end

 --更新战旗任务
function CountryWarCtr:handleCountryWarFlagMissionUpdateInfo(null, data)
    self.data:setUpdateTaskRewardProgress(data)
end

--领取战旗轮次奖励 
function CountryWarCtr:handleCountryWarFlagRoundGetInfo(null, data)
    self.data:setTaskRewardRoundGetData(data)
end

--战场日志
function CountryWarCtr:handleCountryWarServerLog(null, data)
    self.data:setServerLogData(data)
end

--角色日志
function CountryWarCtr:handleCountryWarRoleLog(null, data)
    self.data:setRoleLogData(data)
end

--随机商城
function CountryWarCtr:handleCountryWarRandomShop(null, data)
    self.data:setRandomShopData(data)

end

--随机随机商城购买
function CountryWarCtr:handleCountryWarRandomShopBuy(null, data)
    self.data:setRandomShopBuyData(data)
end

--城池收益
function CountryWarCtr:handleCountryWarGetCityReward(null, data)
    self.data:setHadReward(data.had_reward)
end

-----CountryWar.proto--------------------GReq协议------------------------------------------
--积分排行榜请求
function CountryWarCtr:gReqCountryWarRank(type)
    if type == nil then return end
    local req = CountryWar_pb.GReqCountryWarRank()
	req.rank_type = type
	NetManager:sendMessage(ProtocolID.GReqCountryWarRank, req)
end

-- 积分成就数据请求
function CountryWarCtr:gReqCountryWarScore()
    NetManager:sendMessage(ProtocolID.GReqCountryWarScore)
end

-- 领取积分任务
function CountryWarCtr:gReqCountryWarScoreMissionGet(idx)
    if idx == nil then return end
    local req = CountryWar_pb.GReqCountryWarScoreMissionGet()
	req.idx = idx
	NetManager:sendMessage(ProtocolID.GReqCountryWarScoreMissionGet,req)
end

-- 积分奖励领取
function CountryWarCtr:gReqCountryWarScoreGet(idx)
    if idx == nil then return end
    local req = CountryWar_pb.GReqCountryWarScoreGet()
    req.idx = idx
    NetManager:sendMessage(ProtocolID.GReqCountryWarScoreGet,req)
end

-- 城池收益数据请求
function CountryWarCtr:gReqCountryWarGetCityReward()
    NetManager:sendMessage(ProtocolID.GReqCountryWarGetCityReward)
end

-- 抽奖信息数据请求
function CountryWarCtr:gReqCountryWarLotteryData()
    NetManager:sendMessage(ProtocolID.GReqCountryWarLotteryData)
end

-- 抽奖
function CountryWarCtr:gReqCountryWarLottery(tag)
    if tag == nil then return end
    local req = CountryWar_pb.GReqCountryWarLottery()
    req.lottery_times = tag
    NetManager:sendMessage(ProtocolID.GReqCountryWarLottery, req)
end

-- 战旗任务数据请求
function CountryWarCtr:gReqCountryWarFlag()
    NetManager:sendMessage(ProtocolID.GReqCountryWarFlag)
end

-- 领取战旗轮次奖励
function CountryWarCtr:gReqCountryWarFlagRoundGet(idx)
    if idx == nil then return end
    local req = CountryWar_pb.GReqCountryWarFlagRoundGet()
    req.idx = idx
    NetManager:sendMessage(ProtocolID.GReqCountryWarFlagRoundGet, req)
end

-- 领取战旗任务
function CountryWarCtr:gReqCountryWarFlagMissionGet(idx)
    if idx == nil then return end
    local req = CountryWar_pb.GReqCountryWarFlagMissionGet()
    req.idx = idx
    NetManager:sendMessage(ProtocolID.GReqCountryWarFlagMissionGet, req)
end

-- 战场日志数据请求
function CountryWarCtr:gReqCountryWarServerLog()
    NetManager:sendMessage(ProtocolID.GReqCountryWarServerLog)
end

-- 角色日志数据请求
function CountryWarCtr:gReqCountryWarRoleLog()
    NetManager:sendMessage(ProtocolID.GReqCountryWarRoleLog)
end

-- 随机商城数据请求
function CountryWarCtr:gReqCountryWarRandomShop()
    NetManager:sendMessage(ProtocolID.GReqCountryWarRandomShop)
end

-- 随机商城购买
function CountryWarCtr:gReqCountryWarRandomShopBuy(idx,num)
    if idx == nil then return end
    local req = CountryWar_pb.GReqCountryWarRandomShopBuy()
    req.idx = idx
    req.count = num or 1
    NetManager:sendMessage(ProtocolID.GReqCountryWarRandomShopBuy,req) 
end

-- 请求阶段时间数据
function CountryWarCtr:gReqCountryWarTime()
    NetManager:sendMessage(ProtocolID.GReqCountryWarTime)
end
-- 请求大城池数据
function CountryWarCtr:gReqCountryWarCity()
    NetManager:sendMessage(ProtocolID.GReqCountryWarCity)
end
-- 请求小城池数据 单个城池的数据
function CountryWarCtr:gReqCountryWarSmallCity(idx)
   -- 验证位置的合法性
   local isbool = false
   for k,v in pairs(cfg.countrywarcityrelation.countrywarcityrelation) do
       if v.city_id == idx then
           isbool = true
           break
       end
   end
   if not isbool then
       print("gReqCountryWarSmallCity idx 不合法",idx)
       return
   end
    local req = CountryWar_pb.GReqCountryWarSmallCity()
    req.idx = idx
    NetManager:sendMessage(ProtocolID.GReqCountryWarSmallCity,req)
end
-- 发送攻城消息
function CountryWarCtr:gReqCountryWarAttackCity(idx)
    -- 验证位置的合法性
    local isbool = false
    for k,v in pairs(cfg.countrywarcityrelation.countrywarcityrelation) do
        if v.city_id == idx then
            isbool = true
            break
        end
    end
    if not isbool then
        print("gReqCountryWarAttackCity idx 不合法",idx)
        return
    end
    local req = CountryWar_pb.GReqCountryWarAttackCity()
    req.idx = idx
    NetManager:sendMessage(ProtocolID.GReqCountryWarAttackCity,req)
end
-- 发送迁移消息
function CountryWarCtr:gReqCountryWarMoveCity(idx)
    -- 验证位置的合法性
    local isbool = false
    for k,v in pairs(cfg.countrywarcityrelation.countrywarcityrelation) do
        if v.city_id == idx then
            isbool = true
            break
        end
    end
    if not isbool then
        print("gReqCountryWarMoveCity idx 不合法",idx)
        return
    end
    local req = CountryWar_pb.GReqCountryWarMoveCity()
    req.idx = idx
    NetManager:sendMessage(ProtocolID.GReqCountryWarMoveCity,req)
end


return CountryWarCtr
