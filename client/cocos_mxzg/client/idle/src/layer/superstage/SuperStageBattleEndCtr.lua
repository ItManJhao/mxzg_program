local SuperStageBattleEndCtr = class("SuperStageBattleEndCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local SuperStageBattleEndLayer = class("SuperStageBattleEndLayer", require("src.comp.EventLayerAdaptiveWidth"))

-----------------------------------------------------------------------------
function SuperStageBattleEndLayer:onCreate()
    self:addBlackBackground()
    self:setAutoClose(true)
    self:setSwallowTouches(true)

    self.point_progressbar = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("super-stage/progress-1-2.png"))
    self.point_progressbar:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.point_progressbar:setMidpoint(cc.p(0, 0.5))
    self.point_progressbar:setAnchorPoint(ex.a.center)
    self.point_progressbar:setBarChangeRate(cc.p(1, 0))
    self.spr_progress_node:addChild(self.point_progressbar)
    self.point_progressbar:setPosition(ex.p.zero)
    self.point_progressbar:setPercentage(0)

    self.point_base_progressbar = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("super-stage/progress-1-1.png"))
    self.point_base_progressbar:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.point_base_progressbar:setMidpoint(cc.p(0, 0.5))
    self.point_base_progressbar:setAnchorPoint(ex.a.center)
    self.point_base_progressbar:setBarChangeRate(cc.p(1, 0))
    self.spr_progress_node:addChild(self.point_base_progressbar)
    self.point_base_progressbar:setPosition(ex.p.zero)
    self.point_base_progressbar:setPercentage(0)
end

function SuperStageBattleEndLayer:updateTop(result)
    if not result.report then
        return
    end

    local is_win = result.report.win_id == ex.Player.role_id
    ex.Tools:setSpriteFrame(self.spr_wing, string.format("battle-end/spr-wing-%d.png", is_win and 1 or 0))
    ex.Tools:setSpriteFrame(self.spr_result, string.format("super-stage-lang/lbl-challenge-%d.png", is_win and 1 or 0))
  
    if is_win then
        local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_battle_end")
        spr_effect:setPosition(self.spr_wing:getContentSize().width / 2, self.spr_wing:getContentSize().height / 2 + 40)
        spr_effect:setScale(1)
        self.spr_wing:addChild(spr_effect, 0, 10)

        local chibang = sp.SkeletonAnimation:create("spine/chibang.json", "spine/chibang.atlas", 1)
        chibang:setAnimation(0, "idle", true)
        chibang:setPosition(self.spr_wing:getPositionX(), self.spr_wing:getPositionY())
        self:addChild(chibang)

        self.spr_result:setVisible(false)
        self.spr_wing:setVisible(false)
    end
end

-- 播放升段动画
function SuperStageBattleEndLayer:playUpState(data)
    self.delta_stage_node:setVisible(true)
    local pre_config_stage = cfg.superstage.superstage[data.old_stage_id]
    local pre_icon_x = self.spr_pre_stage_icon:getPositionX()
    if pre_config_stage then
        ex.Tools:setSpriteFrame(self.spr_pre_stage_icon, "super-stage-icon/rank-1-" .. pre_config_stage.icon_idx .. ".png")
        self.lbl_old_stage_name:setString(ex.Tools:getLang(pre_config_stage.name_lang))
        self.spr_pre_stage_icon:setVisible(true)
        self.spr_pre_stage_icon:setPositionX(0)
    end

    local next_config_stage = cfg.superstage.superstage[data.new_stage_id]
    if next_config_stage then
        ex.Tools:setSpriteFrame(self.spr_next_stage_icon, "super-stage-icon/rank-1-" .. next_config_stage.icon_idx .. ".png")
        self.lbl_new_stage_name:setString(ex.Tools:getLang(next_config_stage.name_lang))
    end

    self.spr_arrow:setPositionX(self.spr_arrow:getPositionX() - 30)
    self.spr_next_stage_icon:setPositionX(self.spr_next_stage_icon:getPositionX() - 30)
    self.spr_pre_stage_icon:runAction(
        cc.Sequence:create(
            cc.DelayTime:create(0.5),
            cc.MoveTo:create(0.5, cc.p(pre_icon_x, self.spr_pre_stage_icon:getPositionY())),
            cc.CallFunc:create(function ()
                self.spr_arrow:runAction(
                    cc.Sequence:create(
                        cc.Spawn:create(
                            cc.MoveBy:create(0.3, cc.p(30, 0)), 
                            cc.FadeIn:create(0.3)
                        ),
                        cc.CallFunc:create(
                            function()
                                if next_config_stage then
                                    self.spr_next_stage_icon:runAction(
                                        cc.Spawn:create(
                                            cc.MoveBy:create(0.3, cc.p(30, 0)),
                                            cc.FadeIn:create(0.3),
                                            cc.CallFunc:create(
                                                function()
                                                    self.spr_new_stage_name_bg:runAction(cc.FadeIn:create(0.3))
                                                    self.lbl_new_stage_name:runAction(cc.FadeIn:create(0.3))
                                                end
                                            )
                                        )
                                    )
                                end
                            end
                        )
                    )
                )
            end)
        )
    )
end

function SuperStageBattleEndLayer:updateState(data)
    local config_stage = cfg.superstage.superstage[data.new_stage_id]
    if config_stage == nil then
        return
    end

    ex.Tools:setSpriteFrame(self.spr_stage_icon, "super-stage-icon/rank-1-" .. config_stage.icon_idx .. ".png")
    self.lbl_stage_name:setString(ex.Tools:getLang(config_stage.name_lang))
    self.spr_stage_icon:setVisible(true)
end

function SuperStageBattleEndLayer:updateDataView(qualifying_match, data)
    if qualifying_match then
        self.normal_detal_layout:setVisible(false)
        self.upstage_node:setVisible(true)

        local recordBgList = {}
        if data.advance_num then
            local startX = 0
            local offsetX = 30
            for i = 1, data.advance_num do
                local spr = cc.Sprite:createWithSpriteFrameName("super-stage/spr-stat.png")
                local w = spr:getContentSize().width

                if i == 1 then
                    local halfNum = math.floor(data.advance_num / 2)
                    
                    if data.advance_num % 2 == 0 then
                        startX = 0 - (halfNum - 1) * (w + offsetX) - (w + offsetX) / 2
                    else
                        startX = 0 - halfNum * (w + offsetX)
                    end
                end
                spr:setPosition(startX + (i - 1) * (w + offsetX), 0)
                self.upstage_node:addChild(spr)
                recordBgList[i] = spr
            end
            
            if data.advance_result and #data.advance_result > 0 then
                for i = 1, #data.advance_result do
                    if recordBgList[i] then
                        local spr_stat = recordBgList[i]
                        local spr_name = ""
                        if data.advance_result[i] == 1 then
                            spr_name = "super-stage/spr-yes.png"
                        else
                            spr_name = "super-stage/spr-no.png"
                        end

                        local spr_status = cc.Sprite:createWithSpriteFrameName(spr_name)
                        spr_status:setOpacity(0)
                        spr_status:setPosition(20, 20)
                        spr_stat:addChild(spr_status)

                        if i == #data.advance_result then
                            spr_status:setOpacity(0)
                            spr_status:setScale(2)
                            spr_status:runAction(cc.Spawn:create(cc.ScaleTo:create(0.5, 1), cc.FadeIn:create(0.5)))
                        else
                            spr_status:setOpacity(255)
                        end
                    end
                end
            end
        end
    else
        self.normal_detal_layout:setVisible(true)
        self.upstage_node:setVisible(false)
        self:playIntegralAnim(data)
    end

    self:updatePointAndExp(data)
end

function SuperStageBattleEndLayer:updatePointAndExp(data)
    local new_integral = data.new_integral or 0
    local old_integral = data.old_integral or 0

    self.exp_label:setString(new_integral)
    if new_integral == old_integral then
        self.exp_tab_icon:setVisible(false)
        self.exp_delta_label:setColor(cc.c3b(0xFF, 0xDF, 0x91))
        self.exp_delta_label:setString(ex.Tools:getLang(74822))
    else
        if new_integral < old_integral then
            -- self.exp_tab_icon:setSpriteFrame("fantasy-land/down.png")
            ex.Tools:setSpriteFrame(self.exp_tab_icon, "fantasy-land/down.png")
            self.exp_delta_label:setColor(cc.c3b(0xF2, 0x0F, 0x0F))
            self.exp_delta_label:setString(old_integral - new_integral)
        else
            -- self.exp_tab_icon:setSpriteFrame("fantasy-land/up.png")
            ex.Tools:setSpriteFrame(self.exp_tab_icon, "fantasy-land/up.png")
            self.exp_delta_label:setColor(cc.c3b(0xFF, 0xDF, 0x91))
            self.exp_delta_label:setString(new_integral - old_integral)
        end
        self.exp_tab_icon:setVisible(true)
    end

    local new_elite_integral = data.new_elite_integral or 0
    local old_elite_integral = data.old_elite_integral or 0
    self.point_label:setString(new_elite_integral)
    if new_elite_integral == old_elite_integral then
        self.point_tab_icon:setVisible(false)
        self.point_delta_label:setColor(cc.c3b(0xFF, 0xDF, 0x91))
        self.point_delta_label:setString(ex.Tools:getLang(74822))
    else
        if new_elite_integral < old_elite_integral then
            -- self.point_tab_icon:setSpriteFrame("fantasy-land/down.png")
            ex.Tools:setSpriteFrame(self.point_tab_icon, "fantasy-land/down.png")
            self.point_delta_label:setColor(cc.c3b(0xF2, 0x0F, 0x0F))
            self.point_delta_label:setString(old_elite_integral - new_elite_integral)
        else
            -- self.point_tab_icon:setSpriteFrame("fantasy-land/up.png")
            ex.Tools:setSpriteFrame(self.point_tab_icon, "fantasy-land/up.png")
            self.point_delta_label:setColor(cc.c3b(0xFF, 0xDF, 0x91))
            self.point_delta_label:setString(new_elite_integral - old_elite_integral)
        end
        self.point_tab_icon:setVisible(true)
    end
end

function SuperStageBattleEndLayer:playIntegralAnim(data)
    local old_integral = data.old_integral or 0
    local new_integral = data.new_integral or 0
    local max_integral = data.max_integral or 0

    self.pregress_label:setString(string.format("%s / %s", new_integral, max_integral))

    local protection_integral = data.protection_integral or 0

    -- if old_integral >= protection_integral then
    --     self.point_base_progressbar:setPercentage(math.floor(protection_integral / max_integral * 100))
    -- else
    --     self.point_base_progressbar:setPercentage(0)
    -- end

    local startP = math.floor(old_integral / max_integral * 100)
    local endP = math.floor(new_integral / max_integral * 100) 

    local animTime = 0.8
    if new_integral < old_integral then
        if old_integral >= protection_integral and new_integral < protection_integral then
            local firstTime = (old_integral - protection_integral) / (new_integral - old_integral) * animTime
            local firstP = math.floor(protection_integral / max_integral * 100)
            self.point_progressbar:runAction(
                cc.Sequence:create(
                    cc.ProgressFromTo:create(firstTime, startP, firstP),
                    -- cc.CallFunc:create(
                    --     function()
                    --         self.point_base_progressbar:setPercentage(0)
                    --     end
                    -- ),
                    cc.ProgressFromTo:create(animTime - firstTime, startP, endP)
                )
            )
        else
            self.point_progressbar:runAction(cc.ProgressFromTo:create(animTime, startP, endP))
        end
    elseif new_integral > old_integral then
        if old_integral < protection_integral then
            local firstTime = (protection_integral - old_integral) / (new_integral - old_integral) * animTime
            local firstP = math.floor(protection_integral / max_integral * 100)
            self.point_progressbar:runAction(
                cc.Sequence:create(
                    cc.ProgressFromTo:create(firstTime, startP, firstP),
                    -- cc.CallFunc:create(
                    --     function()
                    --         self.point_base_progressbar:setPercentage(firstP)
                    --     end
                    -- ),
                    cc.ProgressFromTo:create(animTime - firstTime, startP, endP)
                )
            )
        else
            self.point_progressbar:runAction(cc.ProgressFromTo:create(animTime, startP, endP))
        end
    else
        self.point_progressbar:setPercentage(endP)
    end
end

function SuperStageBattleEndLayer:updateReward(reward)
    if not reward or #reward == 0 then
        return
    end

    if reward and #reward > 0 then
        local startX = self:getContentSize().width / 2
        local scale = 0.7
        local offsetX = 30
        for i, v in ipairs(reward) do
            local item = ex.Tools:createBackpackItem(v.type, v.num)
            local itemW = item:getContentSize().width * scale
            local itemH = item:getContentSize().height * scale

            if i == 1 then
                local halfNum = math.floor(#reward / 2)
                if #reward % 2 == 0 then
                    startX = self:getContentSize().width / 2 - (halfNum - 1) * (itemW + offsetX) - (itemW + offsetX) / 2
                else
                    startX = self:getContentSize().width / 2 - halfNum * (itemW + offsetX)
                end
            end

            item:setScale(scale)
            item:setPosition(startX + (i - 1) * (itemW + offsetX), self.lbl_hdwp:getPositionY() - 20 - itemH / 2)
            item:registerScriptTapHandler(handler(self, self.onItemInfo))
            self.menu:addChild(item)
        end
    end
end

function SuperStageBattleEndLayer:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end


-----------------------------------------------------------------------------
function SuperStageBattleEndCtr:onCreate()
    self:setCCBIPath("ccbi/SuperStageBattleEndLayer.ccbi")
    self:setIsSingle(false)
end

function SuperStageBattleEndCtr:getLayerClass()
    return SuperStageBattleEndLayer
end

function SuperStageBattleEndCtr:openWindow(battle_type, data)
    if self:isOpened() then
        return
    end

    self.data = data

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/super-stage-lang.plist")
    sfc:addSpriteFrames("ccbi-res/super-stage-icon.plist")
    sfc:addSpriteFrames("ccbi-res/super-stage.plist")
    sfc:addSpriteFrames("ccbi-res/fantasy-land.plist")
    sfc:addSpriteFrames("ccbi-res/battle-end.plist")

    self:loadLayer()
    self:open()
    self:initData(data)
end

function SuperStageBattleEndCtr:initData(data)
    self.layer.btn_report:registerScriptTapHandler(handler(self, self.onReport))
    self:updateLayer(data)
end

function SuperStageBattleEndCtr:updateLayer(data)
    local result = data.result or {}
    self.layer:updateTop(result)

    local config = data.config_stage
    local old_config = data.config_stage_old
    if not config then
        return
    end
    if not old_config then
        old_config = config
    end

    local model = {
        new_integral = data.result.new_integral,
        old_integral = data.result.old_integral,
        new_elite_integral = data.result.new_elite_integral,
        old_elite_integral = data.result.old_elite_integral,
        max_integral = config.integral_limit,
        protection_integral = config.protection_integral,
        reward = data.reward,
        old_stage_id = data.result.old_stage_id,
        new_stage_id = data.result.new_stage_id
    }


    --是否是晋级赛
    local qualifying_match = false
    if result.advance_result and #result.advance_result > 0 then
        local advance_result = result.advance_result or {}
        local advance_num = old_config.advance_num or #advance_result
        model.advance_result = advance_result
        model.advance_num = advance_num
        qualifying_match = true
        self.layer.lbl_hdwp:setPositionY(self.layer.lbl_hdwp:getPositionY() + 10)
    else
        if model.new_stage_id < model.old_stage_id then
            model.old_integral = model.max_integral
        end
    end

    -- 结算奖励
    self.layer:updateReward(result.reward)


    -- 段位变动则播放动画，否则就单纯展示段位
    if data.result.old_stage_id ~= data.result.new_stage_id then
            self.layer:playUpState(model)
    else
        self.layer:updateState(model)
    end

    self.layer:updateDataView(qualifying_match, model)
end

function SuperStageBattleEndCtr:onReport(tag, pSender)
    if not self.data or not self.data.result or not self.data.result.report then
        return
    end

    require("src.layer.BattleDetailCtr"):instance():openWindow(self.data.result.report.log)
end

return SuperStageBattleEndCtr
