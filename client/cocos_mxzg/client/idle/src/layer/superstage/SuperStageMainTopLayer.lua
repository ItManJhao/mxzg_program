local SuperStageMainTopLayer = class("SuperStageMainTopLayer", require("src.comp.EventLayer"))

function SuperStageMainTopLayer:onExit()

end

function SuperStageMainTopLayer:onCreate()
    self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)
    self.spr_bg:setScaleY(ex.p.height / self.spr_bg:getContentSize().height)


    self.node_top1:setPositionY(self.node_top1:getPositionY() - require("src.model.Game"):instance():getNotchHeight())
    self.node_top2:setPositionY(self.node_top2:getPositionY() - require("src.model.Game"):instance():getNotchHeight())

    self:updateLayer()

    self:addEvent(EVENT.SUPER_STAGE.UPDATE_SHOW_LAYER, handler(self, self.updateLayer))
    self:addEvent(EVENT.SUPER_STAGE.RANK_INFO, handler(self, self.updateLayer))
    self:addEvent(EVENT.SUPER_STAGE.UPDATE_LIKE, handler(self, self.updateLike))

    ex.RedDotManager:setStickNode(RedDotType.ZCJ_DHZC_KFSK_CFDWS_DFS_DZ, self.btn_rank)

    NetManager:sendMessage(ProtocolID.GReqScanPinnacle)
    NetManager:sendMessage(ProtocolID.GReqPinnacleRank)

    self:addTimer("timer", 1000, handler(self, self.updateTimer), true)
end

function SuperStageMainTopLayer:updateTimer()
    -- 更新赛季倒计时
    local now_time = ex.Game:getServerTime()
    local season_time2 = string.format(ex.Tools:getLang(47391), ex.StringUtil.convertToHowLongHour(math.max(0, ex.Player.super_stage_data.season_end_time - now_time)))
    self.lbl_season_time2:setString(season_time2)
    self.lbl_season_time2:setPositionX(self.lbl_season_time_title:getPositionX() + self.lbl_season_time_title:getContentSize().width + 2)
end

function SuperStageMainTopLayer:updateLayer()
    local getRankText = function(rank)
        if rank <= 0 then
            return ex.Tools:getLang(47749)
        end
        return tostring(rank)
    end

    self.lbl_my_rank:setString(getRankText(ex.Player.super_stage_data.top_rank))
    self.lbl_my_rank_max:setString(getRankText(ex.Player.super_stage_data.top_rank_max))

    local date = os.date("*t", ex.Player.super_stage_data.top2_start_time)
    local season_time1 = ex.Tools:getLang(75958)..string.format(ex.Tools:getLang(76065), date.month, date.day, string.format("%02d:%02d", date.hour, date.min))
    self.lbl_season_time_title:setString(season_time1)

    self.lbl_worship_count:setString(ex.Player.super_stage_data.worship_count)
    self:updateTimer()

    -- 虚位以待
    for i=1,3 do
        local player_data = TableEx.findValueFunction(ex.Player.super_stage_data.vec_top_rank, function(value)
            return value.rank == i
        end)

        self["node_hero"..i]:removeAllChildren()
        self["btn_like"..i]:setVisible(player_data ~= nil)
        self["lbl_like"..i]:setVisible(player_data ~= nil)

        if player_data then
            local hero = require("src.person.Hero"):create("1", "1", 1, 1, ex.Tools:getHeroSkinByImageId(player_data.image_id)) 
            hero:setScale(i == 1 and 1.2 * 1.42 or 1 * 1.42)
            self["node_hero"..i]:addChild(hero)

            self["btn_like"..i].rid = player_data.rid
            self["lbl_name"..i]:setString(player_data.name)
            self["lbl_like"..i]:setString(player_data.like)

            local config_stage = cfg.superstage.superstage[player_data.stage_id]
            if config_stage ~= nil then
                self["lbl_stage"..i]:setString(ex.Tools:getLang(config_stage.name_lang))
            end
        else
            self["lbl_name"..i]:setString(ex.Tools:getLang(47593))
        end
    end
    self:updateLike()
end

function SuperStageMainTopLayer:updateLike()
    for i=1,3 do
        local player_data = TableEx.findValueFunction(ex.Player.super_stage_data.vec_top_rank, function(value)
            return value.rank == i
        end)

        self["lbl_like"..i]:setVisible(player_data ~= nil)

        if player_data then
            self["lbl_like"..i]:setString(player_data.like)

            self["btn_like"..i].rid = player_data.rid

            local is_like = ex.Player.super_stage_data:isLike(player_data.rid)
            ex.Tools:setGrayAuto(self["btn_like"..i]:getNormalImage(), is_like)
            self["btn_like"..i]:setEnabled(is_like == false)
        end
    end
end

function SuperStageMainTopLayer:onTop()
    ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_SUPER_STAGE_TOP)
end

function SuperStageMainTopLayer:onInfo()
    require("src.layer.InfoCtr"):instance():openWindow(ex.Tools:getLang(42100), ex.Tools:getLang(42101))
end

function SuperStageMainTopLayer:onLineup()
    require("src.layer.HeroSelectCtr"):instance():openWindow(ex.Tools:getLang(47546),
                                                                ex.Tools:getLang(47396),
                                                                BattleType.SUPER_STAGE_TOP,
                                                                function(  )
                                                                    NetManager:sendMessage(ProtocolID.GReqPinnacleSaveFormation)
                                                                end,
                                                                nil,
                                                                nil,
                                                            function()
                                                                ex.MessageView:add(ex.Tools:getLang(70772))
                                                                return true
                                                            end)
end

function SuperStageMainTopLayer:onImageSetting()
    require("src.layer.SettingChooseCtr"):instance():openWindow(3)
end

function SuperStageMainTopLayer:onLike(tag, pSender)
    if pSender.rid == nil then
        return
    end

    if ex.Player.super_stage_data:isLike(pSender.rid) then
        return
    end

    if ex.Player.super_stage_data:isLimitLike() then
        ex.MessageView:add(ex.Tools:getLang(70768))
        return
    end

    local req_like = Pinnacle_pb.GReqPinnacleLike()
    req_like.rid = pSender.rid
    NetManager:sendMessage(ProtocolID.GReqPinnacleLike, req_like)
end

function SuperStageMainTopLayer:onBack()
    ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_SUPER_STAGE)
end

function SuperStageMainTopLayer:onRank()
	require("src.layer.superstage.SuperStageTopRankCtr"):instance():openWindow()
end

return SuperStageMainTopLayer