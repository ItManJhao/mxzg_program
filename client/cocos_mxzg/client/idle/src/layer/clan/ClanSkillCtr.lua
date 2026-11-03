local ClanSkillCtr = class("ClanSkillCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ClanSkillLayer = class("ClanSkillLayer", require("src.comp.EventLayerAdaptiveWidth"))

function ClanSkillLayer:onCreate()
    self:setAutoClose(true)
    self:setSwallowTouches(true)
    self:addBlackBackground()

    -- 公会科技职业按钮初始化
    for i=1,4 do
        self["btn_profession_"..i]:setLabelOffset(cc.p(15, 1))

        local spr_profession_icon = cc.Sprite:createWithSpriteFrameName("clan/spr-profession-"..i..".png")
        spr_profession_icon:setPosition(60, 32)
        self["btn_profession_"..i]:addChild(spr_profession_icon)
    end
    self.btn_profession_1:setChecked(true)
    self.lbl_reset_line:setScaleX(self.lbl_reset:getContentSize().width / self.lbl_reset_line:getContentSize().width * self.lbl_reset:getScaleX())
    self.btn_reset:setContentSize(cc.size(self.lbl_reset:getContentSize().width * self.lbl_reset:getScaleX(), 
                                          self.lbl_reset:getContentSize().height * self.lbl_reset:getScaleY()))

    -- 箭头执行循环动画
    self:updateArrowAction()

    local spr_gold = cc.Sprite:createWithSpriteFrameName("backpack/900001.png")
    spr_gold:setPosition(self.item_gold_need:getContentSize().width / 2, self.item_gold_need:getContentSize().height / 2)
    self.item_gold_need:addChild(spr_gold)
    self.item_gold_need.item_type = 900001

    local spr_donate = cc.Sprite:createWithSpriteFrameName("backpack/901301.png")
    spr_donate:setPosition(self.item_donate_need:getContentSize().width / 2, self.item_donate_need:getContentSize().height / 2)
    self.item_donate_need:addChild(spr_donate)
    self.item_donate_need.item_type = 901301

    self.btn_profession_1:setLabelText(ex.Tools:getLang(111001))
    self.btn_profession_2:setLabelText(ex.Tools:getLang(111002))
    self.btn_profession_3:setLabelText(ex.Tools:getLang(111003))
    self.btn_profession_4:setLabelText(ex.Tools:getLang(111004))



    self:addRedDotNode(RedDotType.ZCJ_DHGH_KJ_ZS, self.btn_profession_1)
    self:addRedDotNode(RedDotType.ZCJ_DHGH_KJ_FS, self.btn_profession_2)
    self:addRedDotNode(RedDotType.ZCJ_DHGH_KJ_MS, self.btn_profession_3)
    self:addRedDotNode(RedDotType.ZCJ_DHGH_KJ_CK, self.btn_profession_4)
end

function ClanSkillLayer:updateArrowAction()
    -- 箭头执行循环动画
    for i=1,ClanSkillNumPerStage do
        local spr_arrow = self["spr_arrow_"..i]
        spr_arrow:stopAllActions()

        spr_arrow:setPosition(self["spr_elem_"..i]:getPosition())

        local end_idx = i + 1
        end_idx = (end_idx > ClanSkillNumPerStage) and 1 or end_idx

        spr_arrow:runAction(cc.Sequence:create(cc.MoveTo:create(2.5, cc.p(self["spr_elem_"..end_idx]:getPosition())), 
                                                cc.CallFunc:create(handler(self, self.updateArrowAction)), 
                                                nil))
    end
end

-----------------------------------------------------------------------------
function ClanSkillCtr:onCreate()
    self:setCCBIPath("ccbi/ClanSkillLayer.ccbi")
    self:setIsSingle(false)
end

function ClanSkillCtr:getLayerClass()
    return ClanSkillLayer
end

function ClanSkillCtr:openWindow()
    if self:isOpened() then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/clan.plist")
	sfc:addSpriteFrames("ccbi-res/backpack-info.plist")

    self:loadLayer()
    self:open()
    self:initData()
end

function ClanSkillCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_info:registerScriptTapHandler(handler(self, self.onInfo))
    self.layer.btn_reset:registerScriptTapHandler(handler(self, self.onReset))
    self.layer.btn_light:registerScriptTapHandler(handler(self, self.onLight))

    self.layer.item_donate_need:registerScriptTapHandler(handler(self, self.onItemInfo))
    self.layer.item_gold_need:registerScriptTapHandler(handler(self, self.onItemInfo))

    for i=1,4 do
        self.layer["btn_profession_"..i]:registerScriptTapHandler(handler(self, self.onProfession))
    end

    self.layer:addEvent(EVENT.CLAN_EVENT.CLAN_SKILL_INFO, handler(self, self.updateLayer))

    self.profession_type = 1

    self:onProfession(self.layer.btn_profession_1:getTag(), self.layer.btn_profession_1)
end

function ClanSkillCtr:updateLayer()
    -- 再加载一次资源，防止资源被移除
    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/backpack-info.plist")
    
    -- 设置红点状态
    if ex.Player.clan_data:lightSkill(self.profession_type, false) > 0 then
        ex.Player.clan_data.clan_skill_check_time[self.profession_type] = true
    end
    ex.Player.clan_data:checkClanSkillReddot()

    local data = ex.Player.clan_data:getSkillDataByProfessionType(self.profession_type)
    local stage = 1
    local elem_idx = 0
    local stage_next = 1
    local elem_idx_next = 1
    if data ~= nil then
        stage = data.stage
        elem_idx = data.elem_idx

        stage_next = data.stage
        elem_idx_next = data.elem_idx + 1
        if data.elem_idx >= ClanSkillNumPerStage then
            stage_next = data.stage + 1
            elem_idx_next = 1
        else
            stage_next = data.stage
            if data.elem_idx <= 0 then 
                elem_idx_next = 1
            end
        end
    end

    -- 显示科技层数
    local stage_max = ex.Player.clan_data:getSkillStageMax()
    self.layer.lbl_stage_num:setString(string.format(ex.Tools:getLang(41339), "("..stage.."/"..stage_max..")"))

    -- 显示当前加成的属性
    local config_ability = cfg.clanskillability.clanskillability[elem_idx_next]
    self.layer.lbl_attr_add_cur:setString(ex.Tools:getAttrText(config_ability.ability, config_ability.num))

    self.layer.spr_elem_cur:setPosition(self.layer["spr_elem_"..elem_idx_next]:getPosition())

    -- 所需资源显示
    local res_need = ex.Player.clan_data:getSkillResNeed(stage_next, elem_idx_next)
    local gold_need = res_need[900001] or -1 
    local donate_need = res_need[901301] or -1

    local gold_cur = ex.Player:getItemNum(900001)
    local donate_cur = ex.Player:getItemNum(901301)

    if gold_need >= 0 then
        self.layer.lbl_gold_need:setString(string.format("%s/%s", ex.StringUtil.getScientificNumber(gold_cur), ex.StringUtil.getScientificNumber(gold_need)))
    else
        self.layer.lbl_gold_need:setString(ex.Tools:getLang(47190))
    end
    if gold_need >= 0 and gold_need > gold_cur then
        self.layer.lbl_gold_need:setColor(cc.c3b(233, 91, 72))
    else
        self.layer.lbl_gold_need:setColor(cc.c3b(122, 71, 45))
    end

    if donate_need >= 0 then
        self.layer.lbl_donate_need:setString(string.format("%s/%s", ex.StringUtil.getScientificNumber(donate_cur), ex.StringUtil.getScientificNumber(donate_need)))
    else
        self.layer.lbl_donate_need:setString(ex.Tools:getLang(47190))
    end
    if donate_need >= 0 and donate_need > donate_cur then
        self.layer.lbl_donate_need:setColor(cc.c3b(233, 91, 72))
    else
        self.layer.lbl_donate_need:setColor(cc.c3b(122, 71, 45))
    end

    -- 刷新点亮属性显示
    local glp_normal = cpp.ShaderFactory:instance():getGLProgram(ShaderType.ST_POSITION_TEXTURE_DEFAULT)
    local glp_gray = cpp.ShaderFactory:instance():getGLProgram(ShaderType.ST_POSITION_TEXTURE_GRAY)

    if elem_idx <= ClanSkillNumPerStage then
        for i=1,ClanSkillNumPerStage do
            if elem_idx >= i then
                self.layer["spr_elem_"..i]:setGLProgram(glp_normal)
            else
                self.layer["spr_elem_"..i]:setGLProgram(glp_gray)
            end
        end
    end

    -- 刷新科技属性累计数值显示
    for i=1,ClanSkillNumPerStage do
        local attr_type, attr_num = ex.Player.clan_data:getSkillExtraNum(self.profession_type, i)
        local str_attr = ex.Tools:getAttrText(attr_type, attr_num)
        self.layer["lbl_elem_"..i]:setString(str_attr)
        --属性对应图标
        local attr_show_type = cfg.attrshow.attrshow[attr_type].icon
        -- self.layer["spr_attr_"..i]:setSpriteFrame(string.format("backpack-info/spr-attr-%d.png", attr_show_type))
        ex.Tools:setSpriteFrame(self.layer["spr_attr_"..i], string.format("backpack-info/spr-attr-%d.png", attr_show_type))
    end
end

-- 功能介绍
function ClanSkillCtr:onInfo()
    ex.InfoCtr:openWindow(ex.Tools:getLang(42024), ex.Tools:getLang(42025))
end

-- 物品介绍
function ClanSkillCtr:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-- 选择职业
function ClanSkillCtr:onProfession(tag, pSender)
    self.profession_type = tag
    local data = ex.Player.clan_data:getSkillDataByProfessionType(self.layer.profession_type)
    local stage = 1
    local elem_idx = 0
    if data ~= nil then
        stage = data.stage
        elem_idx = data.elem_idx
    end

    for _,v in pairs(cfg.clanskillability.clanskillability) do
        if v.occupation == tag then
            -- self.layer["spr_elem_"..v.type]:setSpriteFrame("clan/spr-elem-"..v.ability..".png")
            ex.Tools:setSpriteFrame(self.layer["spr_elem_"..v.type], "clan/spr-elem-"..v.ability..".png")
        end
    end

    ex.Player.clan_data:checkClanSkillReddot()

    self:updateLayer()
end

-- 科技重置
function ClanSkillCtr:onReset(tag, pSender)

    -- 获取重置可获得资源
    local item_cost = ex.Player.clan_data:getClanSkillResetCostByProfession(self.profession_type)

    if item_cost == nil or table.nums(item_cost) <= 0 then
        ex.MessageView:add(ex.Tools:getLang(47625))
        return
    end

    local gem_need = ex.Player.clan_data:getclanSkillResetNeed()

    local gold_rate = ex.Tools:getSysCfg("clan_skill_reset_back_gold_percent")
	local donate_rate = ex.Tools:getSysCfg("clan_skill_reset_back_donate_percent")

    local check_callback = function()
        local is_ok = ex.Player:getItemNum(ItemType.IT_GEM) >=  gem_need[1].item_num
        if is_ok ~= true then
            ex.Tools:showEnoughTip(ItemType.IT_GEM)
        end
        return is_ok
    end

    require("src.layer.ClanSkillResetCtr"):instance():openWindow(ex.Tools:getLang(47277),
                                                                string.format(ex.Tools:getLang(3008), 
                                                                ex.Tools:getLang(111000 + self.profession_type),
                                                                donate_rate, gold_rate),
                                                                item_cost,
                                                                tostring(gem_need[1].item_num),
                                                                function()
                                                                    self:onResetDone()
                                                                end,
                                                                check_callback)
end

-- 科技重置
function ClanSkillCtr:onResetDone()
    local flag = ex.Player.clan_data:clanSkillReset(self.profession_type)
    if flag == -1 then
        ex.MessageView:add(ex.Tools:getLang(47625))
    elseif flag == -2 then
        ex.MessageView:add(ex.Tools:getLang(47597))
    end
end

-- 点亮技能
function ClanSkillCtr:onLight(tag, pSender)
    local data = ex.Player.clan_data:getSkillDataByProfessionType(self.profession_type)
    local stage = 1
    local elem_idx = 0
    if data ~= nil then
        stage = data.stage
        elem_idx = data.elem_idx
    end

    -- 点亮的职业不能超过其他三个职业最低stage+15
    local min_stage = stage
    for profession_type=1,4 do
        if profession_type ~= self.profession_type then
            local tmp_data = ex.Player.clan_data:getSkillDataByProfessionType(profession_type)
            local cur_stage = tmp_data and tmp_data.stage or 1
            if cur_stage < min_stage then
                min_stage = cur_stage
            end
        end
    end

    local next_stage = elem_idx == ClanSkillNumPerStage and stage + 1 or stage
    local stage_diff = ex.Tools:getSysCfg("clan_skill_level_gap")
    if next_stage >= min_stage + stage_diff + 1 then
        ex.MessageView:add(string.format(ex.Tools:getLang(41349), next_stage - stage_diff))
        return
    end

    local flag = ex.Player.clan_data:lightSkill(self.profession_type)
    if flag > 0 then
        self:updateLayer()

        ex.AudioManager:playEffect("music/clan-tec.mp3")

        -- 找到点亮的属性，播放特效
        local cur_elem_idx = 1
        local clan_skill_data = ex.Player.clan_data:getSkillDataByProfessionType(self.profession_type)
        if clan_skill_data ~= nil then
            cur_elem_idx = clan_skill_data.elem_idx
        end
        local node = self.layer["spr_elem_"..cur_elem_idx]
        local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_clan_skill")
        spr_effect:setPosition(node:getContentSize().width / 2, node:getContentSize().height / 2)
        node:addChild(spr_effect, 0, 10)

        if cur_elem_idx == 1 then
            -- 升级一圈后，爆一次升阶动画
            local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_clan_skill_stage")
            spr_effect:setPosition(0, 0)
            self.layer.node_skill:addChild(spr_effect, 0, 10)
        end
    elseif flag == -1 then
        -- 做出满级提示
        ex.MessageView:add(ex.Tools:getLang(47067))
    elseif flag == -2 then
        -- 做出金币不足提示
        ex.MessageView:add(ex.Tools:getLang(47468))
    elseif flag == -3 then
        -- 做出公会捐献点不足提示
        ex.MessageView:add(ex.Tools:getLang(47468))
    end
end

return ClanSkillCtr
