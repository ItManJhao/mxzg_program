local SuperStageTopGuessLayer = class("SuperStageTopGuessLayer", require("src.comp.EventLayer"))

function SuperStageTopGuessLayer:onCreate()
    self.node_guess:setScale(math.min(1, ex.p.width / 640))

    -- 创建双方进度条
	self.prog_player1 = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("championship/spr-prog-1.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    :setPercentage(50)
    self.node_guess:addChild(self.prog_player1)

    -- 这个会被截掉一点，所以setScaleX -1
    self.prog_player2 = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("championship/spr-prog-2.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setMidpoint(cc.p(1, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    :setPercentage(50)
    -- :setScaleX(-1)
    self.node_guess:addChild(self.prog_player2)

    local height = self.node_lineup:getPositionY() + self.node_lineup:getContentSize().height + 2
    self.node_info = require("src.layer.superstage.SuperStageBattleInfoCell"):createWithCCBIFile("ccbi/SuperStageBattleInfoCell.ccbi")
    self.node_info:setIgnoreAnchorPointForPosition(false)
    self.node_info:setAnchorPoint(0.5, 0)
    self.node_info:setPosition(ex.p.width * 0.5, height)
    self:addChild(self.node_info)
    height = ex.p.height * 0.716 - height    -- 标题最下边在73%的位置
    self.node_info:setScale(height / self.node_info:getContentSize().height)
    -- self.prog_player1:setPosition(self.spr_progress_bg:getContentSize().width / 2 ,self.spr_progress_bg:getContentSize().height / 2)

    self:updateLayer()
    self:addEvent(EVENT.SUPER_STAGE.UPDATE_GUESS, handler(self, self.updateLayer))

    NetManager:sendMessage(ProtocolID.GReqGuessPinnacleBattle)
end

function SuperStageTopGuessLayer:refresh()
    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.2), cc.CallFunc:create(function()
        NetManager:sendMessage(ProtocolID.GReqGuessPinnacleBattle)
    end)))
end

function SuperStageTopGuessLayer:updateLayer()
    if ex.Player.super_stage_data.guess == nil then
        self:setVisible(false)
        return
    end

    self:setVisible(ex.Player.super_stage_data.guess.bid ~= 0)
    self.node_info.bid = ex.Player.super_stage_data.guess.bid
    self.node_info:setVisible(ex.Player.super_stage_data.guess.bid ~= 0)
    self.node_info.btn_report:setVisible(ex.Player.super_stage_data.guess.stage == 3 or ex.Player.super_stage_data.guess.stage == 0)

    self.lbl_guess_coin:setString(tostring(ex.Player.super_stage_data.guess.guess_coin))

    local max_odds = ex.Player.super_stage_data:getOddsCoe()
    local odd1 = ex.Player.super_stage_data:getOdds(1)
    local odd2 = ex.Player.super_stage_data:getOdds(2)
    local prog_num = math.max(1, math.floor((2 - odd1) / 0.5 * 100))
    self.prog_player1:setPercentage(prog_num)
    self.prog_player2:setPercentage(100 - prog_num)

    self.lbl_odds1:setString(ex.Tools:getLang(47615) .. string.format("%.02f", odd1))
    self.lbl_odds2:setString(ex.Tools:getLang(47615) .. string.format("%.02f", odd2))

    local parent = self:getParent()
    local is_anim = false
    local which_win = ex.Player.super_stage_data.battle_stage ~= 3 and ex.Player.super_stage_data.guess.which_win or 0
    if parent then
        -- is_anim = parent and parent.stage ~= 3 and ex.Player.super_stage_data.battle_stage == 3
        is_anim = parent.is_run_ani
        self.node_info:reset({which_win = which_win, players={ex.Player.super_stage_data.guess.attacker, ex.Player.super_stage_data.guess.defender}}, is_anim)
        parent:stageBechange()
        -- parent.stage = ex.Player.super_stage_data.battle_stage
    else
        self.node_info:reset({players={ex.Player.super_stage_data.guess.attacker, ex.Player.super_stage_data.guess.defender}}, is_anim)
    end

    self.lbl_name1:setString(ex.Player.super_stage_data.guess.attacker.name)
    self.lbl_name2:setString(ex.Player.super_stage_data.guess.defender.name)

    self.lbl_dice1:setString((ex.Player.super_stage_data.guess.is_guess == 1 and ex.Player.super_stage_data.guess.guess_type == 1) and ex.Tools:getLang(47772) or ex.Tools:getLang(47608))
    self.lbl_dice2:setString((ex.Player.super_stage_data.guess.is_guess == 1 and ex.Player.super_stage_data.guess.guess_type == 2) and ex.Tools:getLang(47772) or ex.Tools:getLang(47608))

    if is_anim then
        self.node_info:onReport()
    end
end

function SuperStageTopGuessLayer:onGuess(tag)
    if ex.Player.super_stage_data.guess.is_guess == 1 then
        ex.MessageView:add(ex.Tools:getLang(70777))
        return
    end

    if ex.Player.super_stage_data.guess.stage ~= 2 then
        ex.MessageView:add(ex.Tools:getLang(34101))
        return
    end

    local name = tag == 1 and ex.Player.super_stage_data.guess.attacker.name or ex.Player.super_stage_data.guess.defender.name
    local odds = ex.Player.super_stage_data:getOdds(tag)

    require("src.layer.BetCtr"):instance():openWindow(name, 
                                                      odds, 
                                                      ex.Player.super_stage_data.guess.guess_coin, 
                                                      ex.Tools:getSysCfg("topmatch_max_guess"), 
                                                      handler(self, self.onGuessDone), 
                                                      tag)
end

function SuperStageTopGuessLayer:onGuessDone(num, ext)
    local req_guess = Pinnacle_pb.GReqGuess()
    req_guess.type = ext
    req_guess.guess_coin = num
    NetManager:sendMessage(ProtocolID.GReqGuess, req_guess)
end

function SuperStageTopGuessLayer:onGuessList()
    require("src.layer.BetListCtr"):instance():openWindow({title = ex.Tools:getLang(47034),
                                                            data_func = function()
                                                                return ex.Player.super_stage_data.guess_record
                                                            end,
                                                            replay_func = function(bid)
                                                                local req_bid = Pinnacle_pb.GReqGetPinnacleBattle()
                                                                req_bid.bid = bid
                                                                NetManager:sendMessage(ProtocolID.GReqGetPinnacleBattle, req_bid)
                                                            end,
                                                            round_func = function(round)
                                                                return ex.Player.super_stage_data:getTopTitle(round)
                                                            end,
                                                            event = EVENT.SUPER_STAGE.UPDATE_GUESS_LIST})
    NetManager:sendMessage(ProtocolID.GReqPinnacleGuessList)
end

return SuperStageTopGuessLayer