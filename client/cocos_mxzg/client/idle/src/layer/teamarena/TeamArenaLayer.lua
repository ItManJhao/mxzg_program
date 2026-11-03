local TeamArenaLayer = class("TeamArenaLayer", require("src.comp.EventLayer"))

local ExTimer = require("src.ex.ExTimer")

local nowTeamArenaRankCell = require("src.layer.teamarena.TeamArenaRankCell")

local team_arena_state = {
    battlenotbegun = 1, -- 0未开启
    battleteaming = 2, -- 1组队阶段
    battleing = 3, -- 2挑战阶段
    battleend = 4
 ---- 3结算阶段
}

function TeamArenaLayer:getAsynImage()
    local vec_image = {
        {image_name = "ccbi-res/map-bg-team-arena-bg.jpg", remove_type = 1}
    }
    return vec_image
end

function TeamArenaLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self:setScale(math.min(1, ex.s.global_scale))


    local notch_height = require("src.model.Game"):instance():getNotchHeight()

    self:setPosition(ex.p.width / 2, ex.p.height / 2 + 50)

    -- self.btn_back:setPosition(self:getContentSize().width / 2 + ex.p.width / 2 / self:getScaleX() - 20 / self:getScaleX() - 60,
    --                           self:getContentSize().height / 2 + ex.p.height / 2 / self:getScaleY() - 100 / self:getScaleY() - 42 - notch_height)

    -- self.panel:setPosition(self.panel:getPositionX() + offset.x / 2, self.panel:getPositionY() + offset.y - 30)

    self.spr_bg = cc.Sprite:create("ccbi-res/map-bg-team-arena-bg.jpg")
    self.spr_bg:setScale(ex.p.width / self.spr_bg:getContentSize().width / self:getScaleX(), ex.p.height / self.spr_bg:getContentSize().height / self:getScaleY())
    self.spr_bg:setPosition(self:getContentSize().width * 0.5, self:getContentSize().height * 0.5)

    self:addChild(self.spr_bg, -1)

    self.show_time_langunge = ex.Tools:getLang(74008)

    self.lbl_battle_nums = require("src.comp.RichTextEx"):create():setFontSize(18):setFontFace(FONT_DEFAULT_NAME_BOLD):setAnchorPoint(ex.a.top_center):setWrapMode(1)
    -- self.lbl_battle_nums:setPosition(0,0)
    self.show_nums_panel:addChild(self.lbl_battle_nums)
    self.lbl_battle_nums:setPosition(0, 0)
    self:initDone()
    self.lbl_battle_nums:setXmlTextLua("")

    
    self.lbl_reward1:setString("0/25")
    self.lbl_reward2:setString(ex.Tools:getLang(74013))
    self.lbl_reward2:enableOutline(FONT_BLACK_TEXT, 3)

    self.btn_battle:setLabelText(ex.Tools:getLang(74009))
    self.btn_team_hall:setLabelText(ex.Tools:getLang(74010))

    self:addRedDotNode(RedDotType.ZCJ_DHZC_KFSK_ZDJJC_TZ, self.btn_battle)
    self:addRedDotNode(RedDotType.ZCJ_DHZC_KFSK_ZDJJC_ZDDT, self.btn_team_hall)
    self:addRedDotNode(RedDotType.ZCJ_DHZC_KFSK_ZDJJC_LQJL, self.btn_battle_reward)
end

function TeamArenaLayer:initDone()
    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/team-arena.plist")
    sfc:addSpriteFrames("ccbi-res/team-arena-lang.plist")

    -- 发送协议获取时间数据
    self.timer = ExTimer:new():bind(self)
    self.timer:run(handler(self, self.updateCDTime), 1.0)

    -- 初始化SCROLL

    local viewSize = cc.size(self.spr_bg_1:getContentSize().width - 19, self.spr_bg_1:getContentSize().height - 20)
    self.tableView = ex.Tools:initTableView(self.spr_bg_1, {}, {nowTeamArenaRankCell, "ccbi/TeamArenaRankCell.ccbi"}, viewSize, 7, cc.p(9, 10))

    -- 注册我的队伍
    self.my_team = nowTeamArenaRankCell:createWithCCBIFile("ccbi/TeamArenaRankCell.ccbi")
    self.show_my_team_panel:addChild(self.my_team)
    self.my_team:setPosition(-self.my_team:getContentSize().width * 0.5, -self.my_team:getContentSize().height * 0.5)
    self.my_team:setVisible(false)
    --按钮 显示时间显示

    self:registerEvent()
    self:sendMessageData()
    self:updateTeamArenaTime()
end

function TeamArenaLayer:onExit()
    -- 停止计时器
    self.timer:stop()
end

function TeamArenaLayer:registerEvent()
    self:addEvent(EVENT.TEAM_AEENA_INFO_EVENT.UPDATE_TIME_DATE, handler(self, self.updateTimeData))
    self:addEvent(EVENT.TEAM_AEENA_INFO_EVENT.UPDATE_RANK_LIST_DATE, handler(self, self.updateRankListData))

    self:addEvent(EVENT.TEAM_AEENA_INFO_EVENT.CREATE_TEAM_ARENA_BATTLE, handler(self, self.createBattle))

    self:addEvent(EVENT.TEAM_AEENA_INFO_EVENT.UPDATE_TEAM_ARENA_DATA, handler(self, self.updateTeamArenaData))
end

function TeamArenaLayer:updateTeamArenaData(event, data)
    -- self:resetRichData()

    self.lbl_reward1:setString(ex.Player.team_arena_data.curr_battle_reward_num .. "/25")

    -- ex.Tools:addRedPoint(self.btn_battle_reward,ex.Player.team_arena_data:checkBattleRewardRed() ,ex.r.p95)


end

function TeamArenaLayer:resetRichData()
    -- 显示刷新数据
    local show_test = ""
    local show_time = ex.Player.team_arena_data.last_add_time - ex.Game:getServerTime() + cfg.system.team_arena_times_get_time

    if ex.Player.team_arena_data.challenge_count < cfg.system.team_arena_times_max then 

        if show_time < 0 then
            local str_format = string.format( ex.Tools:getLang(74424) ,ex.Player.team_arena_data.challenge_count, cfg.system.team_arena_times_max )
            show_test =
                string.format("<outline color='#004B81'size='2'><font color='#ffffff'>%s</font></outline>", str_format)
        
            if ex.Player.team_arena_data.challenge_count < cfg.system.team_arena_times_max then 
                NetManager:sendMessage(ProtocolID.GReqTeamArenaData) -- 组队竞技场数据
    
            end 
        
        else
            local show_msg = string.format("%s:%s:%s", math.floor(show_time / 3600), math.floor(show_time / 60 % 60), math.floor(show_time % 60))
            
            local str_format = string.format( ex.Tools:getLang(74424) ,ex.Player.team_arena_data.challenge_count, cfg.system.team_arena_times_max )
            
            show_test =
                string.format(
                "<outline color='#004B81'size='2'><font color='#ffffff'>%s<br>%s <outline color='#000000'size='2'><font color='#76E13B'>%s</font></outline> </br></font></outline>",
                str_format,
                ex.Tools:getLang(74425),
                show_msg
            )
        end

    else 
        
        show_test =
        string.format("<outline color='#004B81'size='2'><font color='#ffffff'>挑战次数：%s/%s</font></outline><br>　　　</br>", ex.Player.team_arena_data.challenge_count, cfg.system.team_arena_times_max)


    end 


    -- if ex.Player.team_arena_data.challenge_count > 0 then 
    --     ex.Tools:addRedPoint(self.btn_battle,true , ex.r.p95)
    -- else 
    --     ex.Tools:addRedPoint(self.btn_battle,false )
    -- end 

    -- ex.Tools:addRedPoint(self.btn_battle_reward,ex.Player.team_arena_data:checkBattleRewardRed() ,ex.r.p95)


    self.lbl_battle_nums:setXmlTextLua(show_test)
    self.lbl_battle_nums:formatText()

    self.lbl_battle_nums:setContentSize(cc.size(225, self.lbl_battle_nums:getContentSize().height))
    self.lbl_battle_nums:setPosition(37, self.lbl_battle_nums:getContentSize().height * 0.5 - 10)
end

function TeamArenaLayer:createBattle(event, data)
    -- 创建战斗

    if self.battle_layer then
        self.battle_layer:removeFromParent()
        self.battle_layer = nil
    end

    local time_out = function()

    end

    self.battle_layer =
        self:addBattleLayerAuto(
        BattleType.TEAM_ARENA,
        MainSceneType.MAINCITY_TEAM_ARENA,
        MainSceneType.MAINCITY_TEAM_ARENA_BATTLW,
        "",
        EVENT.TEAM_AEENA_INFO_EVENT.START_BATTLE,
        function(layer)
            if ex.Player.team_arena_data.battle_data.report_index == ex.Player.team_arena_data.battle_data.report_sum then
                if not self.battle_layer then
                    return
                end
                self.battle_layer:removeFromParent()
                self.battle_layer = nil

                require("src.layer.teamarena.TeamArenaEndCtr"):instance():openWindow()

                self:sendMessageData()
                return
            else
                --    print("dfhgfdhgfjghjkhg")
                local req = TeamArena_pb.GReqTeamArenaBattleReport()
                req.team_id = ex.Player.team_arena_data.cur_battle_team_id
                req.report_index = ex.Player.team_arena_data.battle_data.report_index + 1
                NetManager:sendMessage(ProtocolID.GReqTeamArenaBattleReport, req)
            end

            return false, false
        end
    )
    self.battle_layer:setRecoveryType(RecoveryType.RT_CO_EXIST)
    self.battle_layer:setScale(1.0 / self:getScaleX())
    self.battle_layer:setPosition(
        self:getContentSize().width * 0.5  - ex.p.width * 0.5,
        self:getContentSize().height * 0.5  - ex.p.height * 0.5
    )

    self.battle_layer.time_out = time_out
    self.battle_layer.isbattle = true

    -- local main_scene_type = ex.MainSceneCtr:getCurLayerType()
    -- if main_scene_type ~= MainSceneType.DREAM_LAYER then
    --     ex.EventManager:fire(EVENT.BATTLE_EVENT.CHANGE_LAYER, self, false)
    -- end

    require("src.layer.teamarena.TeamArenaBattleCtr"):instance():closeWindow()
end

function TeamArenaLayer:updateTimeData(event, data)
    self:updateTeamArenaTime()
end

function TeamArenaLayer:updateRankListData(event, data)
    self:updateTeamArenaRank()
end

function TeamArenaLayer:updateCDTime()
    if ex.Player.team_arena_data.curr_state == team_arena_state.battleing then
        if ex.Player.team_arena_data.had_sign == true and ex.Player.team_arena_data.curr_my_team_data.member and #ex.Player.team_arena_data.curr_my_team_data.member > 0 then
            -- if ex.Player.team_arena_data.curr_my_team_data.member and  #ex.Player.team_arena_data.curr_my_team_data.member > 0 then

            self:resetRichData()
        end
    end

    --  当时间小于0 改变状态
    if ex.Player.team_arena_data.next_state_time - ex.Game:getServerTime() < 0 then
        self:sendMessageData() -- 获取新的状态
        return
    end


    local show_times = ex.Player.team_arena_data.next_state_time - ex.Game:getServerTime()
    local show_msg = string.format("%s:%s:%s", math.floor(show_times / 3600), math.floor(show_times / 60 % 60), math.floor(show_times % 60))

    self.lbl_time:setString(self.show_time_langunge .. " " .. show_msg)
end

function TeamArenaLayer:sendMessageData()
    NetManager:sendMessage(ProtocolID.GReqTeamArenaRank) -- 获取排行榜=

    NetManager:sendMessage(ProtocolID.GReqTeamArenaState) -- 获取时间
end

function TeamArenaLayer:updateTeamArenaTime()
    -- 改变游戏状态的时间，状态，
    NetManager:sendMessage(ProtocolID.GReqTeamArenaData) -- 组队竞技场数据
    -- self.is_status:setSpriteFrame(string.format("team-arena-lang/spr-battle-%s.png", ex.Player.team_arena_data.curr_state))
    ex.Tools:setSpriteFrame(self.is_status, string.format("team-arena-lang/spr-battle-%s.png", ex.Player.team_arena_data.curr_state))
    self.show_team_name:setString(ex.Tools:getLang(74018))
    self.lbl_message:setString("")
    if ex.Player.team_arena_data.curr_state == team_arena_state.battlenotbegun then
        self.show_time_langunge = ex.Tools:getLang(74005)
        self.lbl_title:setString(ex.Tools:getLang(74002))

        ex.Player.team_arena_data.curr_my_team_data.member = {}
        self.lbl_message:setString(ex.Tools:getLang(74003))

        self.my_team:updateMyTeam(ex.Player.team_arena_data.curr_my_team_data)
        
        -- self.node_null:setVisible(true)
        self.btn_battle:setVisible(false)
        self.btn_team_hall:setVisible(false)
    elseif ex.Player.team_arena_data.curr_state == team_arena_state.battleteaming then
        self.show_time_langunge = ex.Tools:getLang(74006)
        self.lbl_title:setString(ex.Tools:getLang(74001))

        -- self.node_null:setVisible(true)

        if ex.Player.team_arena_data.curr_my_team_data.captain_id and  ex.Player.team_arena_data.curr_my_team_data.captain_id == 0 then
            self.lbl_message:setString(ex.Tools:getLang(74004))
        end 

        self.btn_battle:setVisible(false)
        self.btn_team_hall:setVisible(true)
    elseif ex.Player.team_arena_data.curr_state == team_arena_state.battleing then
        self.show_time_langunge = ex.Tools:getLang(74007)
        self.lbl_title:setString(ex.Tools:getLang(74001))

        -- 判断队伍是否唯恐
        -- if ex.Player.team_arena_data.curr_my_team_data.captain_id > 0 then
        if ex.Player.team_arena_data.had_sign == true and ex.Player.team_arena_data.curr_my_team_data.member and #ex.Player.team_arena_data.curr_my_team_data.member > 0 then
            
            self.btn_battle:setVisible(true)
            self.btn_team_hall:setVisible(false)
        else
            -- 继续显示组对
            self.btn_battle:setVisible(false)
            self.btn_team_hall:setVisible(true)
        end
    elseif ex.Player.team_arena_data.curr_state == team_arena_state.battleend then
        self.show_time_langunge = ex.Tools:getLang(74008)
        self.lbl_title:setString(ex.Tools:getLang(74001))

        self.btn_battle:setVisible(false)
        self.btn_team_hall:setVisible(false)
    else
        return
    end
    -- 如果是正确状态显示
end

function TeamArenaLayer:updateTeamArenaRank()
    local show_test_list = ex.Player.team_arena_data.curr_rank_list

    if #ex.Player.team_arena_data.curr_my_team_data.member > 0  then 
        
        self.lbl_message:setString("")
        self.my_team:setVisible(true)
        self.my_team:updateMyTeam(ex.Player.team_arena_data.curr_my_team_data)
    else
        self.my_team:setVisible(false)
        if ex.Player.team_arena_data.curr_state == team_arena_state.battlenotbegun then
            self.lbl_message:setString(ex.Tools:getLang(74003))
        elseif ex.Player.team_arena_data.curr_state == team_arena_state.battleteaming then
            if ex.Player.team_arena_data.curr_my_team_data.captain_id and  ex.Player.team_arena_data.curr_my_team_data.captain_id == 0 then
                self.lbl_message:setString(ex.Tools:getLang(74004))
            end 
        end 

    end 


    if not self.tableView  or show_test_list == {}  or #show_test_list < 1 then

        if not self.show_test_list or  #self.show_test_list < 1 then 
            self.node_null:setVisible(true)
        end 
        
        return
    end
    self.node_null:setVisible(false)
    local offsetY = self.tableView:getContainer():getPositionY()
    self.show_test_list = show_test_list
    self.tableView:initData(show_test_list)
    self.tableView:reloadData()
    -- self.tableView:setContentOffset(cc.p(0,offsetY))

    -- self.my_team:updateMyTeam()  74018
end

function TeamArenaLayer:onBtnBattleLog(tag, pSender)
    require("src.layer.teamarena.TeamArenaBattleLogCtr"):instance():openWindow()
end

function TeamArenaLayer:onBtnTeam(tag, pSender)
    -- 如果我本身是队长，那我就怎么样
    if ex.Player.team_arena_data.curr_my_team_data.captain_id == ex.Player.role_id then
        require("src.layer.teamarena.TeamArenaLineupCtrl"):instance():openWindow()
    else
        require("src.layer.HeroSelectCtr"):instance():openWindow(ex.Tools:getLang(74107), ex.Tools:getLang(74108), BattleType.TEAM_ARENA, nil)
    end
end

function TeamArenaLayer:onBack(tag, pSender)
    ex.MainSceneCtr:backLastLayer()
end

function TeamArenaLayer:onBtnBattleReward(tag, pSender)
    require("src.layer.teamarena.TeamArenaRewardCtr"):instance():openWindow()
end

function TeamArenaLayer:onBtnReward(tag, pSender)
    require("src.layer.teamarena.TeamArenaRankRewardCtr"):instance():openWindow()

end

function TeamArenaLayer:onBtnInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42082), ex.Tools:getLang(42083))
end

function TeamArenaLayer:onBtnShop(tag, pSender)
    cfg.funcopen.main_shop.open(SHOP_TYPE.TEAMARENA)
end

function TeamArenaLayer:onBtnAuto(tag, pSender)
    -- 不是组对大厅就是挑战
    if ex.Player.team_arena_data.curr_state == team_arena_state.battleteaming then
        -- 前往组对大厅
        ex.JumpManager:jumpByAtom("team_arena_team_main")
    elseif ex.Player.team_arena_data.curr_state == team_arena_state.battleing then
        if ex.Player.team_arena_data.had_sign == false then
            ex.JumpManager:jumpByAtom("team_arena_team_main")
        else
            -- 打开战斗， 判断是不是不队长
            if ex.Player.team_arena_data.curr_my_team_data.captain_id == 0 then
                ex.JumpManager:jumpByAtom("team_arena_team_main")
            elseif ex.Player.team_arena_data.curr_my_team_data.captain_id == ex.Player.role_id then
                -- 还需要判断数量

                -- ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KFSK_ZDJJC_ZDDT_KSTZ, ex.Player.team_arena_data.challenge_count - 1 > 0)

                if ex.Player.team_arena_data.challenge_count > 0 then
                    require("src.layer.teamarena.TeamArenaBattleCtr"):instance():openWindow()
                else
                    ex.MessageView:add(ex.Tools:getLang(74016))
                end
            else
                ex.MessageView:add(ex.Tools:getLang(74015))
            end
        end
    end
end

return TeamArenaLayer
