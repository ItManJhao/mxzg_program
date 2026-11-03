--[[
    func: 彩虹圣殿对手界面
    author:徐东浩
    time:2020-02-29 11:14:12
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local RainbowChallengeCtrl = class("RainbowChallengeCtrl", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local RainbowChallengeLayer = class("RainbowChallengeLayer", require("src.comp.EventLayerAdaptiveWidth"))
local UIMenuItemSkill = require("src.comp.menu.UIMenuItemSkill")

-- 进化次数
local EvolutionTimes = {
    One = 1,    -- 一次
    Five = 5,   -- 五次
    Ten = 10,    -- 十次
}

function RainbowChallengeLayer:onCreate()
    self:addBlackBackground()
	-- local height = Maths.min(self:getContentSize().height, ex.p.height);
    -- self:setScale(height / self:getContentSize().height);

    self.lbl_evolution = ex.Tools:createRichText(self.spr_evolution_bg, "", 20, false, cc.tex2F(50, 50), CommonUIDefine.UIDefine.ComponentOriginType.RATIO, "#FFF8E6")
    self.lbl_my_rank = ex.Tools:createRichText(self.node_bottom, "", 20, false, cc.tex2F(50, 7), CommonUIDefine.UIDefine.ComponentOriginType.RATIO, "#DF6021")

    -- self.lbl_goto = ex.Tools:createRichText(self.node_bottom, "", 20, false, cc.tex2F(18, 40), CommonUIDefine.UIDefine.ComponentOriginType.RATIO)
    self.lbl_goto = require("src.comp.RichTextEx"):create()
    self.lbl_goto:setFontSize(20)
    self.lbl_goto:setFontFace(FONT_DEFAULT_NAME_BOLD)
    self.lbl_goto:setWrapMode(1)
    self.lbl_goto:setPosition(ex.Tools:getAbsolutePosition(cc.p(21, 43), CommonUIDefine.UIDefine.ComponentOriginType.RATIO, self.node_bottom))
    self.node_bottom:addChild(self.lbl_goto)

    self.node_head:removeFromParent()
    self.node_head:setScale(1 / self.btn_head:getScale())
    self.node_head:setPosition(ex.Tools:getAbsolutePosition(cc.p(50, 50), CommonUIDefine.UIDefine.ComponentOriginType.RATIO, self.btn_head))
    self.btn_head:getNormalImage():addChild(self.node_head)

    -- 主动技能
    self.menu_skill = cpp.UIMenu:create()
    self.menu_skill:setPosition(cc.p(0, 0))
    self.node_skill:addChild(self.menu_skill, 10)

    -- 被动技能
    self.menu_passive_skill = cpp.UIMenu:create()
    self.menu_passive_skill:setPosition(cc.p(0, 0))
    self.scroll_view_passive:addChild(self.menu_passive_skill, 10)
    self.menu_passive_skill:setIsTouchInsideNode(self.scroll_view_passive)
    self.menu_passive_skill:setSwallowsTouches(false)
end

function RainbowChallengeLayer:refreshHeadInfo(rid, name, head_id, border_id, level)
    local not_player = rid == 0
    self.node_owner:setVisible(not not_player)

    if not not_player then
        ex.Tools:setSpriteFrame(self.btn_head:getNormalImage(), string.format("head-icon/%d.png", head_id))
        ex.Tools:setSpriteFrame(self.spr_photo_bg, ex.Tools:getBorderIconByIdx(border_id))

        local img_size = self.btn_head:getNormalImage():getContentSize()
        self.btn_head:setPosition(cc.p(70 + (91 - img_size.width) / 2, -75 + (91 - img_size.height) / 2))
        self.node_head:setPosition(ex.Tools:getAbsolutePosition(cc.p(50, 50), CommonUIDefine.UIDefine.ComponentOriginType.RATIO, self.node_head:getParent()))
        
        self.lbl_level:setString(tostring(level))
        self.lbl_name:setString(tostring(name))

        -- 按钮置灰
        if rid == ex.Player.role_id then
            self.btn_battle:setLabelText(ex.Tools:getLang(47286))
            ex.Tools:setAllGrayAuto(self.btn_battle:getNormalImage(), true)
            self.btn_battle:setLabelColor(cc.c3b(250, 250, 250))
            self.btn_battle:setLabelOutLine(FONT_GRAY_C4B, 2)
            self.btn_battle:setEnabled(false)
        end
    end
end

function RainbowChallengeLayer:refreshShowGirl(image, evolution, type)
    self.animator = require("src.person.Hero"):create("1", "1", 1, 1, image.star, image.skin)
    self.animator:setAnimation(0, "stand", true);
    self.animator:setScale(1.5)
    self.animator:setPosition(cc.p(0, 80))
    self.animator:setShadowVisible(false)
    self.node_animator:addChild(self.animator, 10)

    ex.Tools:setSpriteFrame(self.spr_title, string.format("rainbow/title-%d.png", type))
    self.lbl_evolution:setXmlTextLua(string.format(ex.Tools:getLang(54252), tostring(evolution)))
end

function RainbowChallengeLayer:refreshSkill(skill_show, passive_skill_show)
    local skill = json.decode(skill_show)
    local passive_skill = json.decode(passive_skill_show)

    -- 主动技能
    local margin_x, padding_x = 12, 4
    local n = math.min(2, #skill)
    local pos = cc.p(0, 0)
    for i=1, n do
        -- 由于彩虹圣殿的npc是配置的，当前先不改，写死不是进化技能
        local btn_skill = UIMenuItemSkill:createWithIcon(skill[i].type, skill[i].level, false, handler(self, self.onSkillInfo))
        btn_skill.lbl_name:setVisible(false)
        btn_skill:setPosition(margin_x + btn_skill:getNormalImage():getContentSize().width * btn_skill:getScale() * (i - 0.5) + padding_x * (i - 1), 54)
        self.menu_skill:addChild(btn_skill)
    end

    -- 被动技能
    local skill_item_real_width = 0
    margin_x = 2
    n = #passive_skill
    for i=1, n do
        -- 由于彩虹圣殿的npc是配置的，当前先不改，写死不是进化技能
        local btn_skill = UIMenuItemSkill:createWithIcon(passive_skill[i].type, passive_skill[i].level, false, handler(self, self.onSkillInfo))

        skill_item_real_width = btn_skill:getNormalImage():getContentSize().width * btn_skill:getScale()

        btn_skill.lbl_name:setVisible(false)
        btn_skill:setPosition(margin_x + skill_item_real_width * (i - 0.5) + padding_x * (i - 1), self.scroll_view_passive:getViewSize().height / 2)
        self.menu_passive_skill:addChild(btn_skill)
    end
    self.scroll_view_passive:setContentSize(cc.size(margin_x * 2 + skill_item_real_width * n + padding_x * (n - 1), self.scroll_view_passive:getViewSize().height))
end

function RainbowChallengeLayer:refreshAddition(attr)
    for i=1, 4 do
        self["node_attr_addition_"..i]:setVisible(i <= #attr)
        if i <= #attr then
            ex.Tools:setSpriteFrame(self["spr_attr_addition_"..i], CommonUIDefine.UIDefine.HeroAttrImage[122000 + attr[i].attr])

            self["lbl_attr_addition_"..i]:setString(string.format("%s+%s ", ex.Tools:getLang(122000 + attr[i].attr), ex.StringUtil.formatAttrNum(ex.Tools:getLang(2160000 + attr[i].attr), attr[i].value)))
        end
    end
end

function RainbowChallengeLayer:refreshRank(need_rank, my_rank)
    self.lbl_goto:setXmlTextLua(ex.Tools:getLang(54261))
    self.lbl_goto:setCallback(handler(self, self.onGoto))

    self.lbl_my_rank:setXmlTextLua(string.format(ex.Tools:getLang(my_rank < need_rank and 54304 or 54263), tostring(need_rank), my_rank == 0 and ex.Tools:getLang(70306) or tostring(my_rank)))
end

function RainbowChallengeLayer:onSkillInfo(tag, pSender)
    require("src.layer.HeroSkillInfoCtr"):instance():openWindow(pSender.skill_type, pSender.skill_level)
end

function RainbowChallengeLayer:onGoto(atom)
    
    if require("src.layer.HeroSelectCtr"):instance():isOpened() then
        return
    end

    RainbowChallengeCtrl:instance():closeWindow()

    ex.JumpManager:jumpByAtom(atom)
end


-----------------------------------------------------------------------------
function RainbowChallengeCtrl:onCreate()
    self:setCCBIPath("ccbi/RainbowChallengeLayer.ccbi")
    
    self:setIsSingle(false)

    self.data = {}
    self.my_rank = 0
    self.config = nil           -- rainbow表配置

    self.battle_parent_layer = nil
end

function RainbowChallengeCtrl:openWindow(data, battle_parent_layer, my_rank)
	if self:isOpened() then
		return
    end
    
    self.data = {}
    self.data = data
    self.my_rank = my_rank
    self.battle_parent_layer = battle_parent_layer
    self.config = cfg.rainbow.rainbow[self.data.type]
    
	self:loadLayer()
    self:open()

	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/hero-info.plist")
    sfc:addSpriteFrames("ccbi-res/hero-info-lang.plist")
    sfc:addSpriteFrames("ccbi-res/skill-icon.plist")

	self:init()
end

function RainbowChallengeCtrl:getLayerClass()
	return RainbowChallengeLayer
end

function RainbowChallengeCtrl:closeWindow()
    self.data = {}
    self.is_battle = false
    self.battle_parent_layer = nil

	self:close(self.layer)
end

function RainbowChallengeCtrl:init()
    self.layer.btn_head:registerScriptTapHandler(handler(self, self.onHead))
    self.layer.btn_battle:registerScriptTapHandler(handler(self, self.onBattle))
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_battle_record:registerScriptTapHandler(handler(self, self.onBattleRecord))
    self.layer.btn_evolution_1:registerScriptTapHandler(handler(self, self.onEvolution))
    self.layer.btn_evolution_2:registerScriptTapHandler(handler(self, self.onEvolution))
    self.layer.btn_evolution_3:registerScriptTapHandler(handler(self, self.onEvolution))
    self.layer:addEvent(EVENT.RAINBOW_EVENT.BATTLE_RESULT, handler(self, self.onBattleResult))
    
	self:updateLayer()
end

function RainbowChallengeCtrl:updateLayer()
    self.layer:refreshHeadInfo(self.data.rid, self.data.name, self.data.head_id, self.data.border_id, self.data.level)

    self.layer:refreshShowGirl(self.data.image, self.data.evolution, self.data.type)

    self.layer:refreshSkill(self.data.npc.skill_show, self.data.npc.passive_skill_show)

    self.layer:refreshAddition(self.config.attr)

    self.layer:refreshRank(self.config.need_rank, self.my_rank)

    -- 默认选中第一个
    self:onEvolution(nil, self.layer.btn_evolution_1)
end

function RainbowChallengeCtrl:onBattleRecord(tag, pSender)
    require("src.layer.RainbowHistoryCtr"):instance():openWindow(self.data.id)
end

function RainbowChallengeCtrl:onEvolution(tag, pSender)
    self.layer.btn_evolution_1:setChecked(pSender == self.layer.btn_evolution_1)
    self.layer.btn_evolution_2:setChecked(pSender == self.layer.btn_evolution_2)
    self.layer.btn_evolution_3:setChecked(pSender == self.layer.btn_evolution_3)
end

function RainbowChallengeCtrl:getCurEvolutionTimes()
    if self.layer.btn_evolution_1:isChecked() then
        return EvolutionTimes.One
    elseif self.layer.btn_evolution_2:isChecked() then
        return EvolutionTimes.Five
    else
        return EvolutionTimes.Ten
    end
end

function RainbowChallengeCtrl:onHead()
    ex.Tools:showPlayerInfo(self.data.rid, 0)
end

function RainbowChallengeCtrl:onBattle()
    if self.my_rank > self.config.need_rank then
        ex.MessageView:add(string.format(ex.Tools:getLang(54305), tostring(self.config.need_rank)))
        return
    end

    local cd = ex.Player.rainbow_data:countCD()
    if cd > 0 then
        ex.MessageView:add(string.format(ex.Tools:getLang(54306), ex.StringUtil.convertToHowLongHour(cd)))
        return
    end

    local enterBattle = function()
        require("src.layer.HeroSelectCtr"):instance():openWindow(ex.Tools:getLang(47524),
                                                                  ex.Tools:getLang(47064),
                                                                  BattleType.RAINBOW_ATTACKER,
                                                                  handler(self, self.onPreFight))
    end

    if ex.Player.rainbow_data:isOccupySeat(ex.Player.role_id) then
        ex.ConfirmCtr:openWindow("", ex.Tools:getLang(54264), enterBattle)
    else
        enterBattle()
    end
end

function RainbowChallengeCtrl:onPreFight()
    if self.is_battle then
        ex.MessageView:add(ex.Tools:getLang(47303))
        return
    end
 
    local cd = ex.Player.rainbow_data:countCD()
    if cd > 0 then
        ex.MessageView:add(string.format(ex.Tools:getLang(54306), ex.StringUtil.convertToHowLongHour(cd)))
        return
    end

    -- 发送副本战斗请求
    ex.Player.rainbow_data:reqChallenge(self.data.id, self:getCurEvolutionTimes())
end

-- 接收战斗结果事件，判断进入条件，并处理
function RainbowChallengeCtrl:onBattleResult(e, data, rainbow_type)
    -- if data.code ~= 0 then
    --     ex.MessageView:add(ex.Tools:getLang(70314))

    --     ex.Player.rainbow_data:reqRainbowInfo()

    --     self:closeWindow()
    --     return
    -- end

    if self.is_battle then
        ex.MessageView:add(ex.Tools:getLang(47303))
        return
    end
    
    self.is_battle = true

    self.battle_parent_layer.battle_result = data
    self.battle_parent_layer.battle_result_type = rainbow_type

    self.battle_parent_layer:onBattle()

    self:closeWindow()

    ex.EventManager:fire(EVENT.RAINBOW_EVENT.BATTLE_REPORT, data)
end

return RainbowChallengeCtrl
