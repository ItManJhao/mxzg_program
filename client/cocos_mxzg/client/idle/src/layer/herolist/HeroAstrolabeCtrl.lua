--[[
    func: 星盘界面
    author:徐东浩
    time:2020-04-28 22:46:12
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local HeroAstrolabeCtrl = class("HeroAstrolabeCtrl", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroAstrolabeLayer = class("HeroAstrolabeLayer", require("src.comp.EventLayer"))

function HeroAstrolabeLayer:onCreate()
    self:addBlackBackground()

    self.btn_star_callback = nil

    self.ui_nodes = {
        [1] = {
            btn = self.btn_star_pos_1,
            label_node = self.node_star_label_1,
            label_star = self.lbl_star_1,
            line = nil,
        },
        [2] = {
            btn = self.btn_star_pos_2,
            label_node = self.node_star_label_2,
            label_star = self.lbl_star_2,
            line = self.spr_line_2,
        },
        [3] = {
            btn = self.btn_star_pos_3,
            label_node = self.node_star_label_3,
            label_star = self.lbl_star_3,
            line = self.spr_line_3,
        },
        [4] = {
            btn = self.btn_star_pos_4,
            label_node = self.node_star_label_4,
            label_star = self.lbl_star_4,
            line = self.spr_line_4,
        },
        [5] = {
            btn = self.btn_star_pos_5,
            label_node = self.node_star_label_5,
            label_star = self.lbl_star_5,
            line = self.spr_line_5,
        },
        [6] = {
            btn = self.btn_star_pos_6,
            label_node = self.node_star_label_6,
            label_star = self.lbl_star_6,
            line = self.spr_line_6,
        },
        [7] = {
            btn = self.btn_star_pos_7,
            label_node = self.node_star_label_7,
            label_star = self.lbl_star_7,
            line = self.spr_line_7,
        },
        [8] = {
            btn = self.btn_star_pos_8,
            label_node = self.node_star_label_8,
            label_star = self.lbl_star_8,
            line = self.spr_line_8,
        },
        [9] = {
            btn = self.btn_star_pos_9,
            label_node = self.node_star_label_9,
            label_star = self.lbl_star_9,
            line = self.spr_line_9,
        },
        [10] = {
            btn = self.btn_star_pos_10,
            label_node = self.node_star_label_10,
            label_star = self.lbl_star_10,
            line = self.spr_line_10,
        },
        [11] = {
            btn = self.btn_star_pos_11,
            label_node = self.node_star_label_11,
            label_star = self.lbl_star_11,
            line = self.spr_line_11,
        },
        [12] = {
            btn = self.btn_star_pos_12,
            label_node = self.node_star_label_12,
            label_star = self.lbl_star_12,
            line = self.spr_line_12,
        },
        [13] = {
            btn = self.btn_star_pos_13,
            label_node = self.node_star_label_13,
            label_star = self.lbl_star_13,
            line = self.spr_line_13,
        },
        [14] = {
            btn = self.btn_star_pos_14,
            label_node = self.node_star_label_14,
            label_star = self.lbl_star_14,
            line = self.spr_line_14,
        },
        [15] = {
            btn = self.btn_star_pos_15,
            label_node = self.node_star_label_15,
            label_star = self.lbl_star_15,
            line = self.spr_line_15,
        },
        [16] = {
            btn = self.btn_star_pos_1,
            label_node = self.node_star_label_1,
            label_star = self.lbl_star_1,
            line = nil,
        },
        [17] = {
            btn = self.btn_star_pos_2,
            label_node = self.node_star_label_2,
            label_star = self.lbl_star_2,
            line = self.spr_line_2,
        },
        [18] = {
            btn = self.btn_star_pos_3,
            label_node = self.node_star_label_3,
            label_star = self.lbl_star_3,
            line = self.spr_line_3,
        },
        [19] = {
            btn = self.btn_star_pos_4,
            label_node = self.node_star_label_4,
            label_star = self.lbl_star_4,
            line = self.spr_line_4,
        },
        [20] = {
            btn = self.btn_star_pos_5,
            label_node = self.node_star_label_5,
            label_star = self.lbl_star_5,
            line = self.spr_line_5,
        },
        [21] = {
            btn = self.btn_star_pos_6,
            label_node = self.node_star_label_6,
            label_star = self.lbl_star_6,
            line = self.spr_line_6,
        },
        [22] = {
            btn = self.btn_star_pos_7,
            label_node = self.node_star_label_7,
            label_star = self.lbl_star_7,
            line = self.spr_line_7,
        },
        [23] = {
            btn = self.btn_star_pos_8,
            label_node = self.node_star_label_8,
            label_star = self.lbl_star_8,
            line = self.spr_line_8,
        },
        [24] = {
            btn = self.btn_star_pos_9,
            label_node = self.node_star_label_9,
            label_star = self.lbl_star_9,
            line = self.spr_line_9,
        },
        [25] = {
            btn = self.btn_star_pos_10,
            label_node = self.node_star_label_10,
            label_star = self.lbl_star_10,
            line = self.spr_line_10,
        },
        [26] = {
            btn = self.btn_star_pos_11,
            label_node = self.node_star_label_11,
            label_star = self.lbl_star_11,
            line = self.spr_line_11,
        },
        [27] = {
            btn = self.btn_star_pos_12,
            label_node = self.node_star_label_12,
            label_star = self.lbl_star_12,
            line = self.spr_line_12,
        },
        [28] = {
            btn = self.btn_star_pos_13,
            label_node = self.node_star_label_13,
            label_star = self.lbl_star_13,
            line = self.spr_line_13,
        },
        [29] = {
            btn = self.btn_star_pos_14,
            label_node = self.node_star_label_14,
            label_star = self.lbl_star_14,
            line = self.spr_line_14,
        },
        [30] = {
            btn = self.btn_star_pos_15,
            label_node = self.node_star_label_15,
            label_star = self.lbl_star_15,
            line = self.spr_line_15,
        }
    }

    self._choice_id = 1
    self.btn_left:setVisible(false)
    self.btn_right:setVisible(true)

    if self._choice_id == 1 then 
        for i=1,15 do
            self.ui_nodes[i].btn:registerScriptTapHandler(handler(self, self.onStar))
            self.ui_nodes[i].btn.local_data = {idx = i}
        end
    elseif self._choice_id == 2 then
        for i=15,30 do
            self.ui_nodes[i].btn:registerScriptTapHandler(handler(self, self.onStar))
            self.ui_nodes[i].btn.local_data = {idx = i}
        end
    end

    self.effect_node = cc.Node:create()
    local spr_effect_1 = cc.Sprite:createWithSpriteFrameName("astrolabe/spr_effect.png")
    spr_effect_1:setScale(1)
    -- spr_effect_1:setBlendFunc({src = gl.ONE, dst = gl.ONE_MINUS_SRC_ALPHA})
    spr_effect_1:setPosition(ex.p.zero)
    self.effect_node:addChild(spr_effect_1, 20)
    local spr_effect_2 = cc.Sprite:createWithSpriteFrameName("astrolabe/spr_effect.png")
    spr_effect_2:setScale(1)
    -- spr_effect_2:setBlendFunc({src = gl.ONE, dst = gl.ONE_MINUS_SRC_ALPHA})
    spr_effect_2:setPosition(ex.p.zero)
    self.effect_node:addChild(spr_effect_2, 20)

    spr_effect_1:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.Spawn:create(cc.ScaleTo:create(2, 1.7), cc.FadeOut:create(2)), cc.ScaleTo:create(0.000001, 1), cc.FadeIn:create(0.00001))))
    spr_effect_2:runAction(cc.Sequence:create(cc.DelayTime:create(1), cc.CallFunc:create(function()
        spr_effect_2:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.Spawn:create(cc.ScaleTo:create(2, 1.7), cc.FadeOut:create(2)), cc.ScaleTo:create(0.000001, 1), cc.FadeIn:create(0.000001))))
    end)))

    self:addChild(self.effect_node)
    self.effect_node:setVisible(false)

    self:addRedDotNode(RedDotType.ZCJ_DHYX_XP_XPXZJM, self.btn_active)
end

function HeroAstrolabeLayer:refershStarPanel(astrolabe_list, skills)
    local find_idx = function(t, idx)
        for k, v in pairs(t) do
            if idx == v.idx then
                return v
            end
        end

        return nil
    end

    local astrolabe_info, skill_info = nil, nil

    local min_index = 1
    local max_index = 15
    if self._choice_id == 2 then
        min_index = 15
        max_index = 30
    end 
   
    for i=min_index,max_index do
        local v = self.ui_nodes[i]
        astrolabe_info = find_idx(astrolabe_list, i)

        if astrolabe_info then
            skill_info = find_idx(skills, i)

            local is_unlock = skill_info ~= nil
            v.btn.local_data = {idx = astrolabe_info.idx}
            if v.line then
                v.line:setVisible(is_unlock)
            end

            if cfg.astrolabe.isSkillByIdx(astrolabe_info.idx) then
                local skill_id = 1
                if skill_info then
                    skill_id = skill_info.skill_id
                else
                    skill_id = astrolabe_info.skills[1]
                end

                local skill_config = cfg.astrolabeskill.getConfigByIdx(skill_id) or {skill_type = 101050082}
                v.btn:setNormalImage(cc.Sprite:createWithSpriteFrameName(string.format("skill-icon/%d.png", skill_config.skill_type)))

                local btn_size = v.btn:getContentSize()
                local border = cc.Sprite:createWithSpriteFrameName("astrolabe/spr_star_border.png")
                border:setScale(1)
                border:setPosition(cc.p(btn_size.width / 2, btn_size.height / 2))
                v.btn:getNormalImage():addChild(border, 10)

                ex.Tools:setGrayAuto(v.btn:getNormalImage(), not is_unlock)
                ex.Tools:setGrayAuto(border, not is_unlock)

                v.label_node:setPositionY(v.btn:getPositionY() - 48)

                v.label_star:setString(string.format(ex.Tools:getLang(4103), astrolabe_info.star))
                v.label_star:setColor(is_unlock and cc.c3b(114, 255, 68) or cc.c3b(186, 179, 186))
            else
                v.btn:setNormalImage(cc.Sprite:createWithSpriteFrameName("astrolabe/btn_star.png"))
                ex.Tools:setGrayAuto(v.btn:getNormalImage(), not is_unlock)

                v.label_node:setPositionY(v.btn:getPositionY() - 32)

                v.label_star:setString(string.format(ex.Tools:getLang(4103), astrolabe_info.star))
                v.label_star:setColor(is_unlock and cc.c3b(114, 255, 68) or cc.c3b(186, 179, 186))
            end
        end
    end
end

function HeroAstrolabeLayer:onStar(tag ,pSender)
    if self.btn_star_callback then
        self.btn_star_callback(pSender.local_data.idx)
    end
end

function HeroAstrolabeLayer:setLineUpStar(max_star)
    max_star = max_star or 0
    self.lbl_max_star:setString(max_star)
end

function HeroAstrolabeLayer:setAllFinish(next_acionable_idx,is_finish)
    self.node_cur_star:setVisible(not is_finish)

    if not is_finish == false then
        self.btn_active:setVisible(false)
        return
    end
    
    if self._choice_id == 1 and next_acionable_idx <= 15 then
        self.btn_active:setVisible(true)
        ex.Tools:addRedPoint(self.btn_left, false, cc.p(0.95, 0.85))
    elseif self._choice_id == 2 and next_acionable_idx > 15 then
        self.btn_active:setVisible(true)
        ex.Tools:addRedPoint(self.btn_right, false, cc.p(0.95, 0.85))
    else
        if self._choice_id == 2 then
            ex.Tools:addRedPoint(self.btn_left, true, cc.p(0.95, 0.85))
        else
            ex.Tools:addRedPoint(self.btn_right, true, cc.p(0.95, 0.85))
        end
        self.btn_active:setVisible(false)
    end

    
        
end

function HeroAstrolabeLayer:setEffectForIdx(idx)
    local btn = nil

    local min_index = 1
    local max_index = 15
    if self._choice_id == 2 then
        min_index = 15
        max_index = 30
    end 
   
    for i=min_index,max_index do
        local v = self.ui_nodes[i]
        if v.btn.local_data.idx == idx then
            btn = v.btn
        end
    end

    if btn then
        self.effect_node:retain()
        self.effect_node:removeFromParentAndCleanup(false)

        local btn_size = btn:getContentSize()
        if cfg.astrolabe.isSkillByIdx(idx) then
            self.effect_node:setPosition(btn_size.width / 2, btn_size.height / 2 + 2)
            self.effect_node:setScale(1.32)
        else
            self.effect_node:setPosition(btn_size.width / 2, btn_size.height / 2)
            self.effect_node:setScale(0.72)
        end
        btn:addChild(self.effect_node, -10)

        self.effect_node:setVisible(true)
        self.effect_node:release()
    else
        self.effect_node:setVisible(false)
    end
end
-----------------------------------------------------------------------------
function HeroAstrolabeCtrl:onCreate()
    self:setCCBIPath("ccbi/HeroAstrolabeLayer.ccbi")
    
    self:setIsSingle(false)

    self.next_acionable_idx = 0
end

function HeroAstrolabeCtrl:openWindow()
	if self:isOpened() then
		return
    end
    
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/skill-icon.plist")

	self:loadLayer()
    self:open()

    self.next_acionable_idx = ex.Player.hero_data.astrolabe:getNextStarActionable()

	self:init()
end

function HeroAstrolabeCtrl:getLayerClass()
	return HeroAstrolabeLayer
end

function HeroAstrolabeCtrl:closeWindow()
    self:close(self.layer)
end

function HeroAstrolabeCtrl:init()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_active:registerScriptTapHandler(handler(self, self.onActive))
    self.layer.btn_reset:registerScriptTapHandler(handler(self, self.onReset))
    self.layer.btn_elem:registerScriptTapHandler(handler(self, self.onElem))
    self.layer.btn_left:registerScriptTapHandler(handler(self, self.onLeft))
    self.layer.btn_right:registerScriptTapHandler(handler(self, self.onRight))

    self.layer:addEvent(EVENT.ASTROLABE.STAR_UPDATE, handler(self, self.eventStarUpdate))

    self.layer.btn_star_callback = handler(self, self.onStar)

	self:updateLayer()
end

function HeroAstrolabeCtrl:updateLayer()

    local texture = cc.Director:getInstance():getTextureCache():addImage(string.format("ccbi-res/astrolabe_bg_%d.png", self.layer._choice_id+1))
    if texture then
        self.layer.spr_bg:setTexture(texture)
    end

    self.layer:refershStarPanel(cfg.astrolabe.astrolabe, ex.Player.hero_data.astrolabe.astrolabe_skill)

    self.layer:setLineUpStar(ex.Player.hero_data.astrolabe.max_star)

    self.layer:setAllFinish(self.next_acionable_idx,self.next_acionable_idx == -1)

    self.layer:setEffectForIdx(self.next_acionable_idx)
end

--------------------------响应处理--------------------------
function HeroAstrolabeCtrl:onActive()
    if cfg.astrolabe.isSkillByIdx(self.next_acionable_idx) then
        require("src.layer.herolist.HeroAstrolabeSelectSkillCtrl"):instance():openWindow(self.next_acionable_idx)
    else
        require("src.layer.herolist.HeroAstrolabeActiveCtrl"):instance():openWindow(self.next_acionable_idx)
    end
end

function HeroAstrolabeCtrl:onStar(idx)
    if cfg.astrolabe.isSkillByIdx(idx) then
        require("src.layer.herolist.HeroAstrolabeSelectSkillCtrl"):instance():openWindow(idx)
    else
        require("src.layer.herolist.HeroAstrolabeActiveCtrl"):instance():openWindow(idx)
    end
end

function HeroAstrolabeCtrl:onReset()
    local content_str = string.format(ex.Tools:getLang(4105), cfg.system.astrolabe_reset[1].item_num, cfg.system.astrolabe_reset[1].item_type)
    
    ex.ConfirmCtr:openWindow(ex.Tools:getLang(4104), content_str, function()
        if #ex.Player.hero_data.astrolabe.astrolabe_skill <= 0 then
            -- 已是初始状态
            -- ex.MessageView:add(ex.Tools:getLang())
            return
        end
        
        if not ex.Tools:hasItem(cfg.system.astrolabe_reset[1].item_type, cfg.system.astrolabe_reset[1].item_num, false, true) then
            return
        end
        
        NetManager:sendMessage(ProtocolID.GReqAstrolabeReset)
    end, ex.Tools:getLang(4107), ex.Tools:getLang(4106))
end

function HeroAstrolabeCtrl:onElem()
    self:closeWindow()

    require("src.layer.herolist.HeroAstrolabeUnlockCtrl"):instance():openWindow()
end

function HeroAstrolabeCtrl:onLeft()
    self.layer.btn_left:setVisible(false)
    self.layer.btn_right:setVisible(true)
    if self.layer._choice_id == 1 then return end
    self.layer._choice_id = 1
    self:updateLayer()
end

function HeroAstrolabeCtrl:onRight()
    self.layer.btn_left:setVisible(true)
    self.layer.btn_right:setVisible(false)
    if self.layer._choice_id == 2 then return end
    self.layer._choice_id = 2
    self:updateLayer()
end
--------------------------事件处理--------------------------
function HeroAstrolabeCtrl:eventStarUpdate()
    self.next_acionable_idx = ex.Player.hero_data.astrolabe:getNextStarActionable()

    self:updateLayer()
end

return HeroAstrolabeCtrl
