local SuperStageMainLadderLayer = class("SuperStageMainLadderLayer", require("src.comp.EventLayer"))
local SuperStageMainLadderSeat = class("SuperStageMainLadderSeat", require("src.comp.EventLayer"))

-- NPC位置百分比
local SeatPosData = {
    {fx = 0.50, fy = 0.65},
    {fx = 0.30, fy = 0.30},
    {fx = 0.70, fy = 0.20},
}

-------------------------------------SuperStageMainLadderSeat----------------------------------------------------
function SuperStageMainLadderSeat:onCreate()
	self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.btn_touch:setContentSize(self:getContentSize())
    
    self.data = {}
end

function SuperStageMainLadderSeat:initDone(data)
    self.data = data

    if self.data.ladder_rank <= 0 then
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

        self.lbl_rank:setString(tostring(self.data.ladder_rank))
    end
    self.lbl_name:setString(tostring(self.data.nick))

    if self.data.image_id <= 0 then   -- 确保后端数据错误。
        self.data.image_id = 10105006
    end

    self.animator = require("src.person.Hero"):create("1", "1", 1, 1, ex.Tools:getHeroSkinByImageId(self.data.image_id)) --sp.SkeletonAnimation:create("spine/"..self.data.role_info.image_id..".json","spine/"..self.data.role_info.image_id..".atlas", 1)
    self.animator:setAnimation(0, "stand", true);
    self.animator:setScale(1.5)
    self.animator:setPosition(cc.p(0, 80))
    self.node_animator:addChild(self.animator, 10)
end

-------------------------------------SuperStageMainLadderLayer----------------------------------------------------
-- 界面布局调整
function SuperStageMainLadderLayer:onCreate()
    self.data = {}
    self.timer_name = "ladder_war_timer"
    self.battle_result = {}

    self:setAutoClose(false)
	self:setSwallowTouches(false)

	-- 铺展到全屏
    ex.Tools:AdjustFullScreenExtend(self.spr_bg)
    
    self.btn_reward_detail:setContentSize(self.lbl_reward_detail:getContentSize())
    self.lbl_reward_detail_under:setScaleX(self.lbl_reward_detail:getContentSize().width * self.lbl_reward_detail:getScaleX() / self.lbl_reward_detail_under:getContentSize().width)
    
    local pos_y = self.node_top:getPositionY()
    
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
    self.node_npc:setPosition(self.player_rect.x, self.player_rect.y)

    self:addTimer(self.timer_name, 1000, handler(self, self.update), true)

    self:initDone()
    self:updateLayer()
end

function SuperStageMainLadderLayer:update(dt)
    self:refreshTitle()
end

function SuperStageMainLadderLayer:initDone()
    self:addRedDotNode(RedDotType.ZCJ_DHZC_KFSK_CFDWS_DFS_DZ, self.btn_legend)
    -- self:addRedDotNode(RedDotType.ZCJ_DHZC_KFSK_CFDWS_DFS_JL, self.btn_history)

    self:addEvent(EVENT.SUPER_STAGE.UPDATE_TOP_INFO, handler(self, self.updateLayer))
    self:addEvent(EVENT.SUPER_STAGE.ADD_TOP_MATCH_TIMES, handler(self, self.refreshTimes))

    ex.RedDotManager:setStickNode(RedDotType.ZCJ_DHZC_KFSK_CFDWS_DFS_DZ, self.btn_rank)

    -- 如果巅峰赛阵容为空，则将主线阵容保存进巅峰赛阵容里去
    local battle_type = BattleType.SUPER_STAGE_TOP
    local battle_config = cfg.battletype.battletype[battle_type]
    local vec_selected = ex.Player.lineup_data:getIdList(battle_config.line_up_type, {NULL_ID, NULL_ID, NULL_ID, NULL_ID, NULL_ID, NULL_ID, NULL_ID, NULL_ID})
    local is_lineup_empty = true
    for i,v in ipairs(vec_selected) do
        if v ~= NULL_ID then
            is_lineup_empty = false
            break
        end
    end
    if is_lineup_empty then
        local vec_selected, fetter_type, formation_id = ex.Player.lineup_data:getIdList(0, {NULL_ID, NULL_ID, NULL_ID, NULL_ID, NULL_ID, NULL_ID, NULL_ID, NULL_ID})
        ex.Player.lineup_data:setLineupById(battle_config.save_line_up_type, vec_selected, fetter_type, formation_id)
    end

    NetManager:sendMessage(ProtocolID.GReqPreliminaries)
end

function SuperStageMainLadderLayer:changeLayerIn()
    ex.EventManager:fire(EVENT.BATTLE_EVENT.CHANGE_LAYER, self, true)
end

function SuperStageMainLadderLayer:changeLayerOutEnd()
    ex.EventManager:fire(EVENT.BATTLE_EVENT.CHANGE_LAYER, self, false)
end

function SuperStageMainLadderLayer:updateLayer()
    self:refreshTitle()

    self:refreshRank()
    self:refreshReward()

    local super_stage_data = ex.Player.super_stage_data
    self.btn_refresh:setVisible(super_stage_data.pinnacle_stage == 5 and super_stage_data.preliminary_qualification)
    self.node_times:setVisible(super_stage_data.pinnacle_stage == 5 and super_stage_data.preliminary_qualification)

    self:refreshTimes()

    self:refreshNPC()
end

function SuperStageMainLadderLayer:onExit()
	-- 移除红点节点
end

function SuperStageMainLadderLayer:generateData()
    self.data.list = {}

    if ex.Player.super_stage_data.pinnacle_stage == 5 then
        for i,v in ipairs(ex.Player.super_stage_data.ladder_main_data.defenders) do
            table.insert(self.data.list, v)
        end
    else
        local vec_image_id = {}
        table.insert(vec_image_id, 10405015 + 100000000 * 10)
        table.insert(vec_image_id, 10205021 + 100000000 * 10)
        table.insert(vec_image_id, 10505014 + 100000000 * 10)

        for i=1,3 do
            local data = {}
            data.rank = -1

            data.rid = i
            data.nick = ex.Tools:getLang(70304)
            data.image_id = vec_image_id[i]
            data.border_id = 0
            data.head_id = 0
            data.ladder_rank = 0
            data.server_id = 0
            data.fight = 0

            table.insert(self.data.list, data)
        end
    end
end

function SuperStageMainLadderLayer:refreshTitle()
    local now = ex.Game:getServerTime()

    if ex.Player.super_stage_data.pinnacle_stage == 5 then
        local left_time = math.max(ex.Player.super_stage_data.top2_start_time - now, 0)

        self.lbl_timing:setString(string.format(ex.Tools:getLang(76050), ex.StringUtil.convertToTimeFormat(left_time, 4)))
    else
        local left_time = math.max(ex.Player.super_stage_data.top1_start_time - now, 0)

        self.lbl_timing:setString(string.format(ex.Tools:getLang(76049), ex.StringUtil.convertToTimeFormat(left_time, 4)))
    end
end

function SuperStageMainLadderLayer:refreshRank()
    if ex.Player.super_stage_data.ladder_main_data.rank <= 0 then
        self.lbl_out_rank:setVisible(true)
        self.lbl_in_rank:setVisible(false)
    else
        self.lbl_out_rank:setVisible(false)
        self.lbl_in_rank:setVisible(true)
        self.lbl_in_rank:setString(tostring(ex.Player.super_stage_data.ladder_main_data.rank))
    end
end

function SuperStageMainLadderLayer:refreshReward()
    local rank = ex.Player.super_stage_data.ladder_main_data.rank
    local vec_reward = {}
    if rank > 0 then
        for i,v in ipairs(cfg.topmatchsecondreward.topmatchsecondreward) do
            if v.rank_low <= rank and v.rank_up >= rank then
                vec_reward = v.rank_reward
                break
            end
        end
    end

    local item_scale = 0.75
    self.menu_reward:removeAllChildren()
    for i,v in ipairs(vec_reward) do
        local item_backpack = ex.Tools:createBackpackItem(v.item_type, v.item_num)
        item_backpack:registerScriptTapHandler(handler(self, self.onItemInfo))
        item_backpack:setPosition(120 * item_scale * (i - 0.5), 0)
        item_backpack:setScale(item_scale)
        self.menu_reward:addChild(item_backpack)
    end

    self.lbl_tip_no_reward:setVisible(#vec_reward <= 0)
end

function SuperStageMainLadderLayer:refreshTimes()
    local super_stage_data = ex.Player.super_stage_data

    self.lbl_times:setString(string.format("%s/%s", super_stage_data.top_battle_times_left, ex.Tools:getSysCfg("preliminaries_challenges")))
    self.lbl_times_buy:setString(super_stage_data.top_battle_times_buy_left)
    self.lbl_times_buy:setVisible(super_stage_data.top_battle_times_buy_left > 0)
    self.lbl_times_buy_title:setVisible(super_stage_data.top_battle_times_buy_left > 0)
end

function SuperStageMainLadderLayer:refreshNPC()
	self.node_npc:removeAllChildren()
	
    self:generateData()
    
    for i,v in ipairs(self.data.list) do
        if i > 3 then
            break
        end
        
        local seat = SuperStageMainLadderSeat:createWithCCBIFile("ccbi/SuperStageMainLadderSeat.ccbi")
        local pos = SeatPosData[math.min(3, i)]
        seat:setPosition(self.player_rect.width * pos.fx - seat:getContentSize().width / 2, 
                         self.player_rect.height * pos.fy - seat:getContentSize().height / 2)
        self.node_npc:addChild(seat, 999 - i)
        
        -- 设置cell
        seat:initDone(v)
        seat.btn_touch:registerScriptTapHandler(handler(self, self.onClickPlayer))
    end
end

function SuperStageMainLadderLayer:getBottomY()
	return ex.MainSceneCtr:getBottomHeight() + 10
end

function SuperStageMainLadderLayer:onBack(tag, pSender)
	if self.callback_back then
		self.callback_back()
	else
        ex.MainSceneCtr:backLastLayer()
	end
end

function SuperStageMainLadderLayer:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function SuperStageMainLadderLayer:onInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42100), ex.Tools:getLang(42101))
end

-- 排行
function SuperStageMainLadderLayer:onRank(tag, pSender)
    if ex.Player.super_stage_data.pinnacle_stage ~= 5 then
        ex.MessageView:add(ex.Tools:getLang(76053))
        return
    end

    require("src.layer.superstage.SuperStageTopRankCtr"):instance():openWindow()
end

-- 战报
function SuperStageMainLadderLayer:onHistory(tag, pSender)
    local super_stage_data = ex.Player.super_stage_data
    require("src.layer.superstage.SuperStageTopHistoryCtr"):instance():openWindow(function(tab_type)
            if tab_type == 1 then
                NetManager:sendMessage(ProtocolID.GReqPreliminariesRecord)
            else
                NetManager:sendMessage(ProtocolID.GReqGreatDemeanor)
            end
        end,
        function(select_type)
            if select_type == 1 then
                return ex.Player.super_stage_data.vec_top_battle_log
            else
                return ex.Player.super_stage_data.vec_top_super_battle_log
            end
        end,
        ex.Tools:getLang(74811),
        super_stage_data.ladder_main_data.rank > 0 and super_stage_data.ladder_main_data.rank or ex.Tools:getLang(74812))
end

-- 传奇
function SuperStageMainLadderLayer:onLegend(tag, pSender)
    if ex.Player.super_stage_data.pinnacle_stage ~= 5 then
        ex.MessageView:add(ex.Tools:getLang(76053))
        return
    end

    require("src.layer.superstage.SuperStageTopLegendCtr"):instance():openWindow()
end

-- 布阵
function SuperStageMainLadderLayer:onLineup(tag, pSender)
    -- 沒有預賽資格則無法佈陣
    if not ex.Player.super_stage_data.preliminary_qualification then
        ex.MessageView:add(ex.Tools:getLang(76057))
        return
    end

    require("src.layer.HeroSelectCtr"):instance():openWindow(ex.Tools:getLang(75911),
										 				     ex.Tools:getLang(47396),
										 					 BattleType.SUPER_STAGE_TOP,
										 					 nil)
end

-- 獎勵預覽
function SuperStageMainLadderLayer:onReward(tag, pSender)
    require("src.layer.rank.RankSingleCtr"):instance():openWindow({title=ex.Tools:getLang(47370),
                                                                  class=require("src.layer.superstage.SuperStageTopRewardCell"),
                                                                  file="ccbi/DreamRewardCell.ccbi",
                                                                  data_func=function()
                                                                        return cfg.topmatchsecondreward.topmatchsecondreward
                                                                   end,
                                                                   "",
                                                                   tip=ex.Tools:getLang(70771)})
end

-- 购买战斗次数
function SuperStageMainLadderLayer:onAddTimes(tag, pSender)
    local super_stage_data = ex.Player.super_stage_data
    local buy_times = tonumber(ex.Tools:getSysCfg("super_stage_buy_times")) - super_stage_data.top_battle_times_buy_left
    local res_need = cfg.topmatchfirstfighttimes.topmatchfirstfighttimes[buy_times + 1]
    if res_need == nil then
        ex.MessageView:add(ex.Tools:getLang(74935))
        return
    end
    res_need = res_need.cost[1]

    -- 打开购买确认框
    ex.ConfirmCtr:openWindow(ex.Tools:getLang(16), 
                             string.format(ex.Tools:getLang(74934), res_need.item_num), 
                             function()
                                 if res_need.item_num > ex.Player:getItemNum(res_need.item_type) then
                                    ex.Tools:showEnoughTip(res_need.item_type, true)
                                    return
                                 end
                                 NetManager:sendMessage(ProtocolID.GReqPreliminariesPurchases)
                             end)
end

function SuperStageMainLadderLayer:onRefresh()
    if ex.Player.super_stage_data.pinnacle_stage ~= 5 then
        ex.MessageView:add(ex.Tools:getLang(75913))
        return
    end

    NetManager:sendMessage(ProtocolID.GReqRefreshOpponent)
end

function SuperStageMainLadderLayer:onClickPlayer(tag, pSender)
    if ex.Player.super_stage_data.pinnacle_stage ~= 5 then
        ex.MessageView:add(ex.Tools:getLang(75913))
        return
    end

    -- 沒有預賽資格則無法佈陣
    if not ex.Player.super_stage_data.preliminary_qualification then
        ex.MessageView:add(ex.Tools:getLang(76057))
        return
    end
    
    if ex.Player.super_stage_data.top_battle_times_left <= 0 then
        ex.MessageView:add(ex.Tools:getLang(75920))
        return
    end
    
    local seat = pSender:getParent():getParent()
    require("src.layer.superstage.SuperStageTopChallengeCtr"):instance():openWindow(seat.data, self)
end

return SuperStageMainLadderLayer
