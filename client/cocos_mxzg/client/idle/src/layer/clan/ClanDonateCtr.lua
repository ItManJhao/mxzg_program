local ClanDonateCtr = class("ClanDonateCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ClanDonateLayer = class("ClanDonateLayer", require("src.comp.EventLayerAdaptiveWidth"))

function ClanDonateLayer:onCreate()
    self:setAutoClose(true)
    self:setSwallowTouches(true)
    self:addBlackBackground()

    -- 添加公会经验进度条
    self.progress_exp = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("clan/progress-exp.png"))
        :setType(cc.PROGRESS_TIMER_TYPE_BAR)
        :setMidpoint(cc.p(0, 0.5))
        :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.progress_exp:setPosition(self.progress_exp_bg:getPosition())
    self.node_clan_info:addChild(self.progress_exp, 20)

    self:reorderChild(self.lbl_exp, 30)

    -- 添加公会经验进度条
    self.progress_point = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("other/spr-bg-2.png"))
        :setType(cc.PROGRESS_TIMER_TYPE_BAR)
        :setMidpoint(cc.p(0, 0.5))
        :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.progress_point:setScaleX(self.spr_progress_bg:getContentSize().width / self.progress_point:getContentSize().width)
    self.progress_point:setPosition(self.spr_progress_bg:getPosition())
    self:addChild(self.progress_point, 20)

    self.btn_reward_list = {}
    local point_max = ex.Player.clan_data:getClanTotalDonatePointMax()
    local progress_width = self.spr_progress_bg:getContentSize().width * self.spr_progress_bg:getScaleX()

    local menu = cpp.UIMenu:create()
    menu:setPosition(0, 0)
    self:addChild(menu, 30)

    local donate_ctr = ClanDonateCtr:instance()
    for i,v in ipairs(cfg.clandonateactivity.clandonateactivity) do
        local str_box_1 = string.format("other/spr-box-%d.png", v.box_type)

        local btn_reward_box = cpp.UIMenuItemImage:createWithSpriteFrameName(str_box_1, str_box_1, str_box_1)
        btn_reward_box:registerScriptTapHandler(handler(donate_ctr, donate_ctr.onClickBox))
        btn_reward_box:setPosition(self.spr_progress_bg:getPositionX() + progress_width * (v.donate_times / point_max - 0.5), self.spr_progress_bg:getPositionY() + 5)
        menu:addChild(btn_reward_box)

        btn_reward_box:setTag(v.idx)
        btn_reward_box.box_type = v.box_type
        self.btn_reward_list[i] = btn_reward_box

        local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_box_unopen")
        spr_effect:setAnchorPoint(cc.p(0.5, 0))
        spr_effect:setPosition(btn_reward_box:getContentSize().width / 2, btn_reward_box:getContentSize().height / 2)
        -- spr_effect:setScale(0.75)
        btn_reward_box:addChild(spr_effect, 10, 10)

        local lbl_reward_point = cc.Label:createWithTTF(string.format("%d", v.donate_times), FONT_DEFAULT_NAME_BOLD, 36)
        lbl_reward_point:setColor(self.lbl_total_point:getColor())
        lbl_reward_point:setScale(0.5)
        lbl_reward_point:setPosition(btn_reward_box:getPositionX(), btn_reward_box:getPositionY() - 35)
        self:addChild(lbl_reward_point)
    end
end

-----------------------------------------------------------------------------
function ClanDonateCtr:onCreate()
    self:setCCBIPath("ccbi/ClanDonateLayer.ccbi")
    self:setIsSingle(false)
end

function ClanDonateCtr:getLayerClass()
    return ClanDonateLayer
end

function ClanDonateCtr:openWindow()
    if self:isOpened() then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/clan.plist")
    sfc:addSpriteFrames("ccbi-res/box-effect.plist")

    self:loadLayer()
    self:open()
    self:initData()
end

function ClanDonateCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_info:registerScriptTapHandler(handler(self, self.onInfo))
    self.layer.btn_donate_1:registerScriptTapHandler(handler(self, self.onDonate))
    self.layer.btn_donate_2:registerScriptTapHandler(handler(self, self.onDonate))
    self.layer.btn_donate_3:registerScriptTapHandler(handler(self, self.onDonate))

    self.layer:addEvent(EVENT.CLAN_EVENT.CLAN_DONATE_INFO, handler(self, self.updateLayer))

    self:updateLayer()
end

function ClanDonateCtr:updateLayer()
    -- 显示捐献按钮是否可点击    
    local donated_index = ex.Player.clan_data.donate_things
    local is_donated = donated_index > 0

    local config = cfg.clanlevel.clanlevel[ex.Player.clan_data.clan_level]
    -- 公会经验
    self.layer.progress_exp:setPercentage(ex.Player.clan_data.clan_exp * 100.0 / config.need_clan_exp)
    self.layer.lbl_exp:setString(ex.Player.clan_data.clan_exp.."/"..config.need_clan_exp)
    self.layer.lbl_clan_level:setString(string.format(ex.Tools:getLang(47719),ex.Player.clan_data.clan_level))

    local config_next = cfg.clanlevel.clanlevel[ex.Player.clan_data.clan_level + 1]
    if config_next ~= nil then
        self.layer.lbl_clan_level_tip_next:setString(string.format(ex.Tools:getLang(47807), config_next.member))
    else
        self.layer.lbl_clan_level_tip_next:setString(ex.Tools:getLang(74509))
    end
    
    for i,v in ipairs(cfg.clandonate.clandonate) do
        if self.layer["btn_donate_" .. v.type] then
            if donated_index == v.type then
                self.layer["btn_donate_" .. v.type]:setLabelText(ex.Tools:getLang(47559))
            else
                self.layer["btn_donate_" .. v.type]:setLabelText(ex.Tools:getLang(47384))
            end
            self.layer["btn_donate_" .. v.type]:setEnabled(is_donated == false)
            
            if is_donated == true then
                ex.Tools:setGrayAuto(self.layer["btn_donate_" .. v.type]:getDisabledImage(), true)
            end
        end

    end

    -- 设置资源消耗与资源获得显示
    for i=1,3 do
        local donate_config = cfg.clandonate.clandonate[i]
        self.layer["spr_donate_get_"..i]:setSpriteFrame(string.format("backpack/%d.png", donate_config.reward[1].item_type))
        self.layer["spr_exp_get_"..i]:setSpriteFrame(string.format("backpack/%d.png", donate_config.clan_exp_gain[1].item_type))
        self.layer["spr_res_need_"..i]:setSpriteFrame(string.format("backpack/%d.png", donate_config.cost_res[1].item_type))

        self.layer["lbl_donate_get_"..i]:setString(string.format("%d", donate_config.reward[1].item_num))
        self.layer["lbl_exp_get_"..i]:setString(string.format("%d", donate_config.clan_exp_gain[1].item_num))
        self.layer["lbl_res_need_"..i]:setString(string.format("%d", donate_config.cost_res[1].item_num))
    end

    -- 设置公会总捐献领奖按钮是否可点击
    self.layer.lbl_total_point:setString(string.format("%d", ex.Player.clan_data.total_donate_num))
    self.layer.progress_point:setPercentage(ex.Player.clan_data.total_donate_num  * 100.0 / ex.Player.clan_data:getClanTotalDonatePointMax())

    for i,v in ipairs(self.layer.btn_reward_list) do
        local tag = v:getTag()
        local str_box_1 = string.format("other/spr-box-open-%d.png", v.box_type)
        local flag = ex.Player.clan_data:clanCanDonateReward(tag)

        if flag == -1 then
            -- 已领取
            v:setNormalImage(cc.Sprite:createWithSpriteFrameName(str_box_1))
            v:setSelectedImage(cc.Sprite:createWithSpriteFrameName(str_box_1))

            local spr_effect = v:getChildByTag(10)

            if spr_effect ~= nil then
                spr_effect:stopAllActions()
                spr_effect:removeFromParent()
                spr_effect = nil
            end
        elseif flag == 1 then
            -- 可领取
            v:setNormalImage(cc.Sprite:createWithSpriteFrameName(str_box_1))
            v:setSelectedImage(cc.Sprite:createWithSpriteFrameName(str_box_1))

            local spr_effect = v:getChildByTag(10)

            if spr_effect ~= nil then
                spr_effect:stopAllActions()
                spr_effect:runAction(ex.EffectFactory:createEffectByName("eff_box_open"))
                spr_effect:setPosition(v:getContentSize().width / 2 - 3, v:getContentSize().height / 2 - 12)
            else 
                spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_box_open")
                spr_effect:setAnchorPoint(cc.p(0.5, 0))
                spr_effect:setPosition(v:getContentSize().width / 2, v:getContentSize().height / 2)
                v:addChild(spr_effect, 10, 10)
            end
        end
    end
end

-- 功能介绍
function ClanDonateCtr:onInfo()
    ex.InfoCtr:openWindow(ex.Tools:getLang(42026), ex.Tools:getLang(42027))
end

-- 公会捐献响应
function ClanDonateCtr:onDonate(tag, pSender)
    local name = pSender:getName()

    print("donate name: ", name)

    local idx = -1
    if name == "btn_donate_1" then
        idx = 1
    elseif name == "btn_donate_2" then
        idx = 2
    elseif name == "btn_donate_3" then
        idx = 3
    end
    if idx == -1 then
        return
    end

    local flag = ex.Player.clan_data:clanDonate(idx)
    if flag == 1 then
        self:updateLayer()
    elseif flag == -1 then
        ex.MessageView:add(ex.Tools:getLang(47234))
    elseif flag == -2 then
        ex.MessageView:add(ex.Tools:getLang(47409))
    end
end

function ClanDonateCtr:onClickBox(tag , pSender)
    local idx = pSender:getTag()

    local config = cfg.clandonateactivity.clandonateactivity[idx]
    if config == nil then
        return
    end
    local flag = ex.Player.clan_data:clanCanDonateReward(config.idx)

    if flag > 0 then
        require("src.layer.SevenTargetRewardInfoCtr"):instance():openWindow(config, flag > 0, handler(self,self.onClanTotalDonate))
    else 
        require("src.layer.SevenTargetRewardInfoCtr"):instance():openWindow(config, flag > 0, nil)
    end
end

-- 公会总捐献次数领奖
function ClanDonateCtr:onClanTotalDonate(tag, pSender)
    local idx = tag

    local config = cfg.clandonateactivity.clandonateactivity[idx]
    if config == nil then
        return
    end

    local flag = ex.Player.clan_data:clanDonateReward(config.idx)
    if flag > 0 then
        self:updateLayer()
    elseif flag == -1 then
        ex.MessageView:add(ex.Tools:getLang(47354))
    elseif flag == -2 then
        ex.MessageView:add(ex.Tools:getLang(47541))
    end
end

return ClanDonateCtr
