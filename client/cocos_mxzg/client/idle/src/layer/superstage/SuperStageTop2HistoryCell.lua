local SuperStageTop2HistoryCell = class("SuperStageTop2HistoryCell", require("src.comp.LuaLayerBase"))

function SuperStageTop2HistoryCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:setIgnoreAnchorPointForPosition(false)
    self:setAnchorPoint(0.5, 0.5)
end

function SuperStageTop2HistoryCell:initData(data)
    self.data = data
    if not self.data then
        return
    end

    local player_data = {self.data.attacker, self.data.defender}

    for i,v in ipairs(player_data) do
        self["lbl_name"..i]:setString(v.name)
        ex.Tools:setSpriteFrame(self["spr_head"..i], string.format("head-icon/%d.png", v.head_id))
        ex.Tools:setSpriteFrame(self["spr_border"..i], ex.Tools:getBorderIconByIdx(v.border_id))
    end

    if self.data.which_win == 0 then
        self.lbl_point_tip:setString(ex.Tools:getLang(47706))
        self.lbl_point:setVisible(false)
    else
        -- add 熊梦 优化比赛记录的提示
        local win_coe = player_data[self.data.which_win].rid == ex.Player.role_id and 1 or -1
        self.lbl_point:setString(self.data.add_point)
        self.lbl_point:setVisible(false)
        self.lbl_point_tip:setString(self:getNextTitle(win_coe))
        ex.Tools:setLabelCostColor(self.lbl_point, win_coe == 1)
    end

    local str_name = ex.Player.super_stage_data:getTopTitle(self.data.battle_round)
    self.lbl_round:setString(str_name)

    self.btn_report:setVisible(self.data.battle_id ~= "")
    self.btn_replay:setVisible(self.data.battle_id ~= "")

    self.spr_win1:setVisible(self.data.which_win == 1)
    self.spr_win2:setVisible(self.data.which_win == 2)
end

function SuperStageTop2HistoryCell:onReplay()
    local req_bid = Pinnacle_pb.GReqGetPinnacleBattle()
    req_bid.bid = self.data.bid
    NetManager:sendMessage(ProtocolID.GReqGetPinnacleBattle, req_bid)

    ex.EventManager:fire(EVENT.MAIN_SCENE.CLOSE_LIST_VIEW)
end

function SuperStageTop2HistoryCell:onReport()
    if not self.data then
        return
    end
    require("src.layer.BattleDetailCtr"):instance():openWindow(self.data.battle_log)
end

-- add 熊梦 竞技场冠军赛 获得下一场比赛的名字 用于显示“进入多少强” 
function SuperStageTop2HistoryCell:getNextTitle(win_coe)
    -- 0:"淘汰赛"
    -- 1:"本次冠军赛已结束"
    -- 16:"十六强赛"
    -- 2:"决赛"
    -- 32:"三十二强赛"
    -- 4:"半决赛"
    -- 8:"八强赛"
    local str_title = ex.Player.super_stage_data:getTopTitle(self.data.battle_round / 2)
    if self.data.battle_round == 4 and win_coe ~= 1 and ex.Player.super_stage_data.my_result.rank == 3 then
            str_title = ex.Tools:getLang(76019)
    elseif self.data.battle_round == 2 then
            str_title = ex.Tools:getLang(win_coe == 1 and 76020 or 76021)
    else
        str_title = win_coe == 1 and ex.Tools:getLang(76022)..str_title or ex.Tools:getLang(76023)..ex.Player.super_stage_data:getTopTitle(self.data.battle_round)
    end
    return str_title
end

return SuperStageTop2HistoryCell