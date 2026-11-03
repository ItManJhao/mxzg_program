--[[
    func: 天梯争霸
    author:徐东浩
    time:2020-01-03 12:28:44
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local LadderWarMainLayer = class("LadderWarMainLayer", require("src.comp.EventLayer"))
local LadderWarSeat = class("LadderWarSeat", require("src.comp.EventLayer"))

-- NPC位置百分比
local SeatPosData = {
    {fx = 0.26, fy = 0.82},
    {fx = 0.76, fy = 0.69},
    {fx = 0.50, fy = 0.50},
    {fx = 0.74, fy = 0.27},
    {fx = 0.28, fy = 0.23},
}

-------------------------------------LadderWarSeat----------------------------------------------------
function LadderWarSeat:onCreate()
	self:setAutoClose(false)
    self:setSwallowTouches(false)
    
    self.data = {}

    self.node_root:retain()
    self.node_root:removeFromParentAndCleanup(false)
    -- self.node_root:setParent(self.btn_base:getNormalImage())
    self.btn_base:getNormalImage():addChild(self.node_root)
    self.node_root:release()
end

function LadderWarSeat:initDone(data)
    self.data = data

    if self.data.rank <= 0 then
        self.lbl_rank:setTextColor(cc.c3b(122, 71, 45))

        local ttf_config = self.lbl_rank:getTTFConfig()
        ttf_config.fontSize = 36
        self.lbl_rank:setTTFConfig(ttf_config)

        self.lbl_rank:setString(ex.Tools:getLang(70306))
    else
        self.lbl_rank:setTextColor(cc.WHITE)
        self.lbl_rank:enableOutline(cc.c3b(122, 71, 45), 2)

        local ttf_config = self.lbl_rank:getTTFConfig()
        ttf_config.fontSize = 44
        self.lbl_rank:setTTFConfig(ttf_config)

        self.lbl_rank:setString(tostring(self.data.rank))
    end
    self.lbl_name:setString(tostring(self.data.role_info.nick))

    if self.data.role_info.image_id <= 0 then   -- 确保后端数据错误。
        self.data.role_info.image_id = 10105006
    end

    self.animator = require("src.person.Hero"):create("1", "1", 1, 1, ex.Tools:getHeroSkinByImageId(self.data.role_info.image_id)) --sp.SkeletonAnimation:create("spine/"..self.data.role_info.image_id..".json","spine/"..self.data.role_info.image_id..".atlas", 1)
    self.animator:setAnimation(0, "stand", true);
    self.animator:setScale(0.7 * 1.42)
    self.animator:setPosition(cc.p(0, 50))
    self.node_animator:addChild(self.animator, 10)
end

-------------------------------------LadderWarMainLayer----------------------------------------------------
-- 界面布局调整
function LadderWarMainLayer:onCreate()
    self.data = {}
    self.timer_name = "ladder_war_timer"
    self.battle_result = {}

    self:setAutoClose(false)
	self:setSwallowTouches(false)

	-- 铺展到全屏
	ex.Tools:AdjustFullScreenExtend(self.spr_bg)
    
    local pos_y = ex.p.height - 100 * ex.s.global_scale - require("src.model.Game"):instance():getNotchHeight()
    self.node_top:setPositionY(pos_y)
    
    self.node_bottom:setPositionY(self:getBottomY())

    -- 放置npc区域
    pos_y = self.node_bottom:getPositionY() + self.node_bottom:getContentSize().height * self.node_bottom:getScale()
    self.player_rect = cc.rect(
        0, 
        pos_y,
        ex.p.width,
        self.node_top:getPositionY() - self.node_top:getContentSize().height * self.node_top:getScale() - pos_y
    )

    -- 添加npc父节点
    self.node_npc = cc.Node:create()
    self.node_npc:setPosition(self.player_rect.x, self.player_rect.y)
    self:addChild(self.node_npc)

    self.btn_back:registerScriptTapHandler(handler(self, self.onBack))
    self.btn_info:registerScriptTapHandler(handler(self, self.onBtnInfo))

    self.btn_hero_temple:registerScriptTapHandler(handler(self, self.onPalace))
    self.btn_report:registerScriptTapHandler(handler(self, self.onReport))
    self.btn_reward:registerScriptTapHandler(handler(self, self.onReward))
    self.btn_shop:registerScriptTapHandler(handler(self, self.onShop))
    self.btn_rank:registerScriptTapHandler(handler(self, self.onRank))

    self.btn_defense_team:registerScriptTapHandler(handler(self, self.onDefenseTeam))
    self.btn_one_key:registerScriptTapHandler(handler(self, self.onOneKey))
    self.btn_refresh:registerScriptTapHandler(handler(self, self.onRefresh))
    self.btn_add:registerScriptTapHandler(handler(self, self.onAdd))

    self.lbl_vs_times = cc.Label:createWithTTF("-", FONT_DEFAULT_NAME_BOLD, 60)
    self.lbl_vs_times:setScale(0.5)
    self.lbl_vs_times:setAnchorPoint(ex.a.center)
	self.lbl_vs_times:setTextColor(cc.c3b(48, 255, 0))
    self.lbl_vs_times:enableOutline(ex.c3b.BLACK, 2)
    self.lbl_vs_times:setPosition(ex.p.zero)
    self.node_times:addChild(self.lbl_vs_times)
    
    self.lbl_buy_times = cpp.RichTextEx:createWithXMLLua("")
	self.lbl_buy_times:setFontSize(36)
	self.lbl_buy_times:setScale(0.5)
	self.lbl_buy_times:setFontFace(FONT_DEFAULT_NAME_BOLD)
    self.lbl_buy_times:setFontColor("#ffffff")
	self.lbl_buy_times:setAnchorPoint(ex.a.center)
    self.lbl_buy_times:setPosition(ex.p.zero)
    self.lbl_buy_times:setLocalZOrder(10)
    self.node_buy_times:addChild(self.lbl_buy_times)

    self:addRedDotNode(RedDotType.ZCJ_DHZC_KFSK_TTZB_YXD, self.btn_hero_temple)
    self:addRedDotNode(RedDotType.ZCJ_DHZC_KFSK_TTZB_ZB, self.btn_report)

    self:addEvent(EVENT.LADDER_EVENT.REFRESH_MY_RANK, handler(self, self.refreshRank))
    self:addEvent(EVENT.LADDER_EVENT.REFRESH_VS_TIMES, handler(self, self.refreshTimes))
    self:addEvent(EVENT.LADDER_EVENT.REFRESH_BUY_TIMES, handler(self, self.refreshTimes))
    self:addEvent(EVENT.LADDER_EVENT.REFRESH_VS_PLAYER, handler(self, self.refreshNPC))
    self:addEvent(EVENT.LADDER_EVENT.BATTLE_HISTORY_ON_REPORT, handler(self, self.onBattleReport))
end

function LadderWarMainLayer:onCreateDone()
    self:refreshTitle()

    if not ex.Player.league_data.ladder_main_data_is_dirty then
        self:updateView()
    end
end

function LadderWarMainLayer:changeLayerIn()
    -- 刷新排行数据
    ex.Player.rank_data:onRefreshLadder()

    ex.EventManager:fire(EVENT.BATTLE_EVENT.CHANGE_LAYER, self, true)
end

function LadderWarMainLayer:changeLayerOutEnd()
    ex.EventManager:fire(EVENT.BATTLE_EVENT.CHANGE_LAYER, self, false)
end

function LadderWarMainLayer:updateView()
    self:refreshRank()

    self:refreshTimes()

    self:refreshNPC()
end

function LadderWarMainLayer:onExit()
	-- 移除红点节点
end

function LadderWarMainLayer:generateData()
    self.data.list = {}

    if ex.Player.league_data:isOpenLadderWar() then
        for i,v in ipairs(ex.Player.league_data.ladder_main_data.defenders) do
            table.insert(self.data.list, v)
        end
    else
        local getRandomImageID = function()
            local list = cfg.serverladderrobotshow.getConfigListByType(2)

            return tonumber(list[math.random(1, #list)].image)
        end

        for i=1,5 do
            local data = {}
            data.rank = -1

            data.role_info = {}
            data.role_info.rid = i
            data.role_info.nick = ex.Tools:getLang(70304)
            data.role_info.image_id = getRandomImageID()
            data.role_info.border_id = 0
            data.role_info.head_id = 0
            data.role_info.ladder_rank = 0
            data.role_info.server_id = 0
            data.role_info.fight = 0

            table.insert(self.data.list, data)
        end
    end
end

function LadderWarMainLayer:refreshTitle()
    if ex.Player.league_data:isOpenLadderWar() then
        local d, h, m, s = ex.Tools:formatTime(math.max(ex.Player.league_data:getRemainEndTimeForLadder(), 0))

        self.lbl_timing:setString(string.format(ex.Tools:getLang(70303), string.format("%02d:%02d:%02d", d * 24 + h, m, s)))

        self:addTimer(self.timer_name, 1000, handler(self, self.refreshCountDown), true)
    else
        self.lbl_timing:setString(ex.Tools:getLang(70302))
    end
end

function LadderWarMainLayer:refreshCountDown()
    local remain_time = ex.Player.league_data:getRemainEndTimeForLadder()
    
    if remain_time < 0 then
        self.lbl_timing:setString(ex.Tools:getLang(70302))

        self:removeTimerByName(self.timer_name)
        return
    end

    local d, h, m, s = ex.Tools:formatTime(remain_time)

    self.lbl_timing:setString(string.format(ex.Tools:getLang(70303), string.format("%02d:%02d:%02d", d * 24 + h, m, s)))
end

function LadderWarMainLayer:refreshRank()
    if ex.Player.league_data.ladder_main_data.my_rank <= 0 then
        self.lbl_out_rank:setVisible(true)
        self.lbl_in_rank:setVisible(false)
    else
        self.lbl_out_rank:setVisible(false)
        self.lbl_in_rank:setVisible(true)
        self.lbl_in_rank:setString(tostring(ex.Player.league_data.ladder_main_data.my_rank))
    end
end

function LadderWarMainLayer:refreshTimes()
    self.lbl_vs_times:setString(tostring(ex.Player.league_data.ladder_main_data.vs_times))
    -- self.lbl_vs_times:setXmlTextLua(string.format(ex.Tools:getLang(70307), tostring(ex.Player.league_data.ladder_main_data.vs_times)))
    
    self.lbl_buy_times:setXmlTextLua(string.format(ex.Tools:getLang(70308), tostring(ex.Player.league_data.ladder_main_data.buy_remain_times)))
end

function LadderWarMainLayer:refreshNPC()
	self.node_npc:removeAllChildren()
	
    self:generateData()
    
    for i,v in ipairs(self.data.list) do
        local seat = LadderWarSeat:createWithCCBIFile("ccbi/LadderWarSeat.ccbi")
        seat:setPosition(self.player_rect.width * SeatPosData[math.min(5, i)].fx - seat:getContentSize().width / 2, self.player_rect.height * SeatPosData[math.min(5, i)].fy - seat:getContentSize().height / 2)
        self.node_npc:addChild(seat)
        
        -- 设置cell
        seat:initDone(v)
        seat.btn_base:registerScriptTapHandler(handler(self, self.onClickPlayer))
    end
end

function LadderWarMainLayer:getBottomY()
	return ex.MainSceneCtr:getBottomHeight() + 10
end

function LadderWarMainLayer:onBack(tag, pSender)
	if self.callback_back then
		self.callback_back()
	else
        ex.MainSceneCtr:backLastLayer()
	end
end

function LadderWarMainLayer:onBtnInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42044), ex.Tools:getLang(42045))
end

function LadderWarMainLayer:onDefenseTeam()
    require("src.layer.HeroSelectCtr"):instance():openWindow(ex.Tools:getLang(70311),
										 				     ex.Tools:getLang(47396),
										 					 BattleType.LADDER_DEFENDER,
										 					 nil)
end

function LadderWarMainLayer:onOneKey()
    if not ex.Player.league_data:isOpenLadderWar() then
        ex.MessageView:add(ex.Tools:getLang(70313))
        return
    end

    if ex.Player.league_data.ladder_main_data.vs_times <= 0 then
        ex.MessageView:add(ex.Tools:getLang(70321))
        return
    end

    ex.Player.league_data:reqLadderOneKeyChallenge()
end

function LadderWarMainLayer:onRefresh()
    if not ex.Player.league_data:isOpenLadderWar() then
        ex.MessageView:add(ex.Tools:getLang(70313))
        return
    end

    ex.Player.league_data:reqRefreshDefends()
end

function LadderWarMainLayer:onAdd()
    if not ex.Player.league_data:isOpenLadderWar() then
        ex.MessageView:add(ex.Tools:getLang(70313))
        return
    end

    if ex.Player.league_data.ladder_main_data.buy_remain_times <= 0 then
        ex.MessageView:add(ex.Tools:getLang(70315))
        return
    end
    
    local cur_times = math.min(ex.Player.league_data.ladder_main_data.buy_cur_times + 1, cfg.serverladderfighttimes.getMaxBuyTimes())
    local config = cfg.serverladderfighttimes.getConfigByBuyTimes(cur_times)
    local content = string.format(ex.Tools:getLang(70322), tostring(config.cost[1].item_num))
    ex.ConfirmCtr:openWindow("", content, function()
        if ex.Player:getItemNum(config.cost[1].item_type) < config.cost[1].item_num then
            ex.MessageView:add(ex.Tools:getLang(30501))
            return
        end

        ex.Player.league_data:reqBuyVSTimes()
    end)
end

-- 英雄殿
function LadderWarMainLayer:onPalace(tag, pSender)
    require("src.layer.LadderHeroTempleCtr"):instance():openWindow()
end

-- 战报
function LadderWarMainLayer:onReport(tag, pSender)
    require("src.layer.LadderHistoryCtr"):instance():openWindow()
end

-- 奖励
function LadderWarMainLayer:onReward(tag, pSender)
    require("src.layer.LadderRewardCtr"):instance():openWindow()
end

-- 积分商店
function LadderWarMainLayer:onShop(tag, pSender)
    cfg.funcopen.main_shop.open(SHOP_TYPE.LADDER)
end

-- 排行
function LadderWarMainLayer:onRank(tag, pSender)
    require("src.layer.RankTopThreeCtr"):instance():openWindow(RankTopThreeLayerType.LADDER)
end

function LadderWarMainLayer:onClickPlayer(tag, pSender)
    if not ex.Player.league_data:isOpenLadderWar() then
        ex.MessageView:add(ex.Tools:getLang(70313))
        return
    end
    
    if ex.Player.league_data.ladder_main_data.vs_times <= 0 then
        ex.MessageView:add(ex.Tools:getLang(70321))
        return
    end
    
    local seat = pSender:getParent():getParent()
    require("src.layer.LadderChallengeCtrl"):instance():openWindow(seat.data, self)
end

function LadderWarMainLayer:onBattle()
    local battle_layer = self:addBattleLayer(BattleType.LADDER_ATTACKER,
                                            MainSceneType.LADDER_WAR_MAIN,
                                            "", 
                                            EVENT.LADDER_EVENT.BATTLE_REPORT,
                                            function(layer, data, vec_reward, ext)
                                                ex.Tools:autoPlaySceneMusic(0.1)

                                                require("src.layer.LadderBattleEndCtrl"):instance():openWindow(self.battle_result)
                                                return true, false
                                            end)
    battle_layer:setScale(1.0 / self:getParent():getScale())
    battle_layer:setPosition(self:getContentSize().width * 0.5 / battle_layer:getScale()  - ex.p.width * 0.5,
                                self:getContentSize().height * 0.5 / battle_layer:getScale() - ex.p.height * 0.5)
    ex.Tools:autoPlaySceneMusic()
end

function LadderWarMainLayer:onBattleReport(event, battle_id)
    local req_battle = Battle_pb.GReqBattleReport()
    req_battle.battle_id = battle_id
    req_battle.type = EVENT.LADDER_EVENT.BATTLE_HISTORY_REPORT
    NetManager:sendMessage(ProtocolID.GReqBattleReport, req_battle)

    local battle_layer = self:addBattleLayer(BattleType.LADDER_REPORT,
                                            MainSceneType.LADDER_WAR_MAIN,
                                            "", 
                                            EVENT.LADDER_EVENT.BATTLE_HISTORY_REPORT,
                                            function(layer, data, vec_reward, ext)
                                                return true, false
                                            end)
    battle_layer:setScale(1.0 / self:getParent():getScale())
    battle_layer:setPosition(self:getContentSize().width * 0.5 / battle_layer:getScale()  - ex.p.width * 0.5,
                                self:getContentSize().height * 0.5 / battle_layer:getScale() - ex.p.height * 0.5)
end

return LadderWarMainLayer
