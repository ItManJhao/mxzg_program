local ChampionMyGuessCell = class("ChampionCrossMyGuessCell", require("src.comp.LuaLayerBase"))

function ChampionMyGuessCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:setIgnoreAnchorPointForPosition(false)
    self:setAnchorPoint(0.5, 0.5)
end

function ChampionMyGuessCell:initData(data)
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

    self.lbl_bet_name:setString(player_data[self.data.guess_type].name)
    if self.data.which_win == 0 then
        self.lbl_bet_text:setString(ex.Tools:getLang(47169))
        ex.Tools:setLabelCostColor(self.lbl_bet_num, true)
        self.lbl_bet_num:setString(self.data.guess_coin)
    else
        self.lbl_bet_text:setString(self.data.which_win == self.data.guess_type and ex.Tools:getLang(47538) or ex.Tools:getLang(47758))
        ex.Tools:setLabelCostColor(self.lbl_bet_num, self.data.which_win == self.data.guess_type)
        self.lbl_bet_num:setString(math.abs(self.data.delta))
    end

    self.lbl_round:setString(ex.Player.championcross_data:getChampionTitle(self.data.period, self.data.battle_round))
    
    self.btn_report:setVisible(self.data.battle_id ~= "")
    self.btn_replay:setVisible(self.data.battle_id ~= "")

    self.spr_win1:setVisible(self.data.which_win == 1)
    self.spr_win2:setVisible(self.data.which_win == 2)
end

function ChampionMyGuessCell:onReplay()
    local req_bid = ChampionCross_pb.GReqGetChampionCrossBattle()
    req_bid.bid = self.data.bid--ex.Player.championcross_data.guess.bid
    NetManager:sendMessage(ProtocolID.GReqGetChampionCrossBattle, req_bid)

    -- ChampionMyGuessCtr:instance():closeWindow()
    ex.EventManager:fire(EVENT.CHAMPIONCROSS_EVENT.CLOSE_LIST_VIEW)
end

function ChampionMyGuessCell:onReport()
    if not self.data then
        return
    end
    require("src.layer.BattleDetailCtr"):instance():openWindow(self.data.battle_log)
end

return ChampionMyGuessCell