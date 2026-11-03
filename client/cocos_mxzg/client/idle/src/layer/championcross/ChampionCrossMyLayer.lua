local ChampionMyLayer = class("ChampionCrossMyLayer", require("src.comp.EventLayer"))

function ChampionMyLayer:onCreate()
    -- self:updateLayerType()
    self:addEvent(EVENT.CHAMPIONCROSS_EVENT.UPDATE_MY_CHAMPION, handler(self, self.updateLayerType))


    local menu = cpp.UIMenu:create()
    menu:setPosition(cc.p(0, 0))
    self:addChild(menu)

    self.btn_lineup = cpp.UIMenuItemLabel:create("button/btn-buy-5.png",
                                                 "button/btn-buy-5.png",
                                                 ex.Tools:getLang(47288),
                                                 nil)
    -- self.btn_lineup:setLabelColor(cc.c3b(255, 255, 255))
    -- self.btn_lineup:setLabelShadow(cc.c4b(177, 84, 0, 255), cc.size(0, -1), 10)
    self.btn_lineup:setLabelOutLine(cc.c4b(70, 6, 255, 255))
    self.btn_lineup:setLabelSize(48)
    self.btn_lineup:setPosition(ex.p.width * 0.5, ex.p.height * 0.124)
    self.btn_lineup:registerScriptTapHandler(handler(self, self.onLineup))
    menu:addChild(self.btn_lineup)
    self:addTimer("timer", 1000, handler(self, self.updateTimer), true)
end

function ChampionMyLayer:refresh()
    NetManager:sendMessage(ProtocolID.GReqMyChampionCrossBattle)
end

function ChampionMyLayer:updateLayerType()

    if self.layer_idle then
        self.layer_idle:removeFromParent()
        self.layer_idle = nil
    end

    if self.layer_info then
        self.layer_info:removeFromParent()
        self.layer_info = nil
    end

    -- 冠军赛未开始
    if ex.Player.championcross_data.my_champion.period == ChampionType.IDLE or (ex.Player.championcross_data.my_champion.bid ~= nil and ex.Player.championcross_data.my_champion.bid == 0) then
        self.layer_idle = require("src.layer.championcross.ChampionCrossMyCompeteLayer"):createWithCCBIFile("ccbi/ChampionCrossMyCompeteLayer.ccbi")
        self:addChild(self.layer_idle)
    else
        self.layer_info = require("src.layer.championcross.ChampionCrossBattleInfoCell"):createWithCCBIFile("ccbi/ChampionCrossBattleInfoCell.ccbi")
        self.layer_info:setScale(ex.s.global_scale)
        self.layer_info:setIgnoreAnchorPointForPosition(false)
        self.layer_info:setAnchorPoint(ex.a.center)
        self.layer_info:setPosition(ex.p.width * 0.5, ex.p.height * 0.45)
        self:addChild(self.layer_info)
    end

    self:updateLayer()
end

function ChampionMyLayer:updateTimer()
    if self.layer_idle then

        if ex.Player.championcross_data.my_champion.period == ChampionType.IDLE then
            local time = ex.Player.championcross_data.battle_start_time - ex.Game:getServerTime()
            self.layer_idle.lbl_start_time:setString(ex.StringUtil.convertToTimeFormat(math.max(0, time), 5))
            self.layer_idle.lbl_time_tip:setString(ex.Tools:getLang(47701))
            self.layer_idle.lbl_title:setString(ex.Tools:getLang(47077))
            self.layer_idle.lbl_content:setXmlTextLua(ex.Tools:getLang(71101))
        else
            local time = ex.Player.championcross_data.end_time - ex.Game:getServerTime()
            self.layer_idle.lbl_start_time:setString(ex.StringUtil.convertToTimeFormat(math.max(0, time), 5))
            self.layer_idle.lbl_time_tip:setString(ex.Tools:getLang(47353))
            self.layer_idle.lbl_title:setString(ex.Tools:getLang(70773))
            self.layer_idle.lbl_content:setXmlTextLua(ex.Tools:getLang(70774))
        end
    end
end

function ChampionMyLayer:updateLayer()
    if self.layer_idle then

    elseif self.layer_info then
        local stage = ex.Player.championcross_data.my_champion.stage

        -- 如果跟主赛程的变量不一致。则玩家是止步与淘汰赛内
        if ex.Player.championcross_data.my_champion.period ~= ex.Player.championcross_data.period or ex.Player.championcross_data.my_champion.battle_round ~= ex.Player.championcross_data.battle_round then
            stage = 0
        end



        self.layer_info.bid = ex.Player.championcross_data.my_champion.bid or 0
        self.layer_info:setVisible(ex.Player.championcross_data.my_champion.period ~= ChampionType.IDLE)
        self.layer_info.btn_report:setVisible(stage == 3 or stage == 0)
        local parent = self:getParent()
        local is_anim = false
        local which_win = stage ~= 3 and ex.Player.championcross_data.my_champion.which_win or 0
        if parent then
            local old_battle = ex.Player.championcross_data.my_old_battle_id
            is_anim = parent.is_run_ani and ex.Player.championcross_data.my_champion.battle_id ~= old_battle
            if stage == 3  then
                ex.Player.championcross_data.my_old_battle_id = ex.Player.championcross_data.my_champion.battle_id
            end
            -- local is_anim = parent and parent.my_stage ~= 3 and ex.Player.championcross_data.battle_stage == 3
            self.layer_info:reset({which_win = which_win, players={ex.Player.championcross_data.my_champion.attacker, ex.Player.championcross_data.my_champion.defender}}, is_anim)
            -- parent.my_stage = ex.Player.championcross_data.battle_stage
            parent:stageBechange()
        else
            self.layer_info:reset({which_win = which_win, players={ex.Player.championcross_data.my_champion.attacker, ex.Player.championcross_data.my_champion.defender}}, is_anim)
        end
    end

    self:updateTimer()
end

function ChampionMyLayer:reset(type, data)

end

function ChampionMyLayer:onLineup()
    if ex.Player.championcross_data.my_champion.period == ChampionType.IDLE or ex.Player.championcross_data.my_champion.stage == 1 then
        require("src.layer.HeroSelectCtr"):instance():openWindow(ex.Tools:getLang(47632),
                                                                 ex.Tools:getLang(47589),
                                                                 BattleType.CHAMPIONCROSS,
                                                                 function()
                                                                    NetManager:sendMessage(ProtocolID.GReqChampionCrossSaveFormation)
                                                                 end,
                                                                 nil,
                                                                 nil,
                                                                function()
                                                                    local can_save = ex.Player.championcross_data.my_champion.period == ChampionType.IDLE or ex.Player.championcross_data.my_champion.stage == 1
                                                                    if can_save ~= true then
                                                                        ex.MessageView:add(ex.Tools:getLang(70770))
                                                                    else
                                                                        ex.MessageView:add(ex.Tools:getLang(70772))
                                                                    end
                                                                    return can_save
                                                                end)
    else
        ex.MessageView:add(ex.Tools:getLang(70770))
    end
end


return ChampionMyLayer