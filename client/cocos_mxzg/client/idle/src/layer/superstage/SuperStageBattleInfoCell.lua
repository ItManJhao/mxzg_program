local SuperStageBattleInfoCell = class("SuperStageBattleInfoCell", require("src.comp.EventLayer"))
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")
local HeadIconComponent = require("src.layer.component.HeadIconComponent")

function SuperStageBattleInfoCell:onCreate()
    self.bid = 0

    self.menu_report:setLocalZOrder(9999)

    self.ui_role = {
        [1] = {
            head_parent = self.node_head_1,
            lbl_power = self.lbl_power_1,
            lbl_name = self.lbl_name_1,
            spr_win = self.spr_win1,
            null_heros = {
                [1] = self.spr_hero_left_1,
                [2] = self.spr_hero_left_2,
                [3] = self.spr_hero_left_3,
                [4] = self.spr_hero_left_4,
                [5] = self.spr_hero_left_5,
                [6] = self.spr_hero_left_6,
                [7] = self.spr_hero_left_7,
                [8] = self.spr_hero_left_8,
            },
            spr_matrix = self.spr_matrix_1,
            null_skills = {
                [1] = self.spr_skill_null_left_1,
                [2] = self.spr_skill_null_left_2,
                [3] = self.spr_skill_null_left_3,
                [4] = self.spr_skill_null_left_4,
            },
            hero_parent = self.node_hero_1,
            skill_parent = self.node_skill_1,
            head = nil,
            hero_menu = nil,
            skill_menu = nil,
        },
        [2] = {
            head_parent = self.node_head_2,
            lbl_power = self.lbl_power_2,
            lbl_name = self.lbl_name_2,
            spr_win = self.spr_win2,
            null_heros = {
                [1] = self.spr_hero_right_1,
                [2] = self.spr_hero_right_2,
                [3] = self.spr_hero_right_3,
                [4] = self.spr_hero_right_4,
                [5] = self.spr_hero_right_5,
                [6] = self.spr_hero_right_6,
                [7] = self.spr_hero_right_7,
                [8] = self.spr_hero_right_8,
            },
            spr_matrix = self.spr_matrix_2,
            null_skills = {
                [1] = self.spr_skill_null_right_1,
                [2] = self.spr_skill_null_right_2,
                [3] = self.spr_skill_null_right_3,
                [4] = self.spr_skill_null_right_4,
            },
            hero_parent = self.node_hero_2,
            skill_parent = self.node_skill_2,
            head = nil,
            hero_menu = nil,
            skill_menu = nil,
        },
    }

    for i, v in ipairs(self.ui_role) do
        v.head = HeadIconComponent:createWithData()
        v.head:getNode():setScale(0.8)
        v.head_parent:setLocalZOrder(10)
        v.head_parent:addChild(v.head:getNode(), 10)

        v.hero_menu = cpp.UIMenu:create()
        v.hero_menu:setPosition(cc.p(0, 0))
        v.hero_parent:addChild(v.hero_menu)

        v.skill_menu = cpp.UIMenu:create()
        v.skill_menu:setPosition(cc.p(0, 0))
        v.skill_parent:addChild(v.skill_menu)

        v.skill_menu:setVisible(false)  -- 内容还未添加
        v.skill_parent:setVisible(false)  -- 内容还未添加
    end

    -- self.node_role_1:setLocalZOrder(5)
    -- self.node_role_2:setLocalZOrder(5)

    self.spr_magic:setScale(1)
    self.spr_magic:setOpacity(255)
    self.spr_magic:stopAllActions()
    self.spr_magic:runAction(cc.RepeatForever:create(cc.RotateBy:create(10, 360)))
end

function SuperStageBattleInfoCell:reset(data, is_anim)
    self.data = data

    self.spr_win1:setVisible(data.which_win == 1)
    self.spr_win2:setVisible(data.which_win == 2)

    if #data.players > 1 then
        for i, v in ipairs(self.ui_role) do
            local role_info = data.players[i]

            if role_info.rid ~= 0 then
                v.lbl_name:setString(role_info.name)
                v.lbl_power:setString(tostring(role_info.fighting))

                v.head:resetData(role_info.rid, role_info.server_id, role_info.head_id, role_info.border_id, role_info.level)
                ex.Tools:setSpriteFrame(v.spr_matrix, string.format("hero-select/spr-matrix-2-%d.png", role_info.formation_id))

                local idx_list = {1,1,1,1,1,1,1,1}
                -- 重置锁定位置状态
                for i,_ in ipairs(idx_list) do
                    local node_null = v.null_heros[i]
                    if node_null then
                        node_null:setVisible(false)
                    end
                end


                v.hero_menu:removeAllChildren()
                for ii,vi in ipairs(role_info.heros) do
                    local node_null = v.null_heros[vi.pos]

                    local item = UIMenuItemHero:createWithData(vi.id, vi.hero_type, cfg.herotype.star[vi.hero_type].elem, vi.level, vi.star)
                    if vi.fashion_id ~= 0 and vi.fashion_id ~= nil then   -- 有皮肤
                        item:setFashionShowForce(vi.fashion_id)
                    end
                    item.player_data = role_info
                    item:setScale(0.7)
                    item:setPosition(node_null and cc.p(node_null:getPosition()) or ex.p.zero)
                    item:registerScriptTapHandler(handler(self, self.onHero))
                    v.hero_menu:addChild(item)

                    idx_list[vi.pos] = 0
                end

                for i2, v2 in ipairs(idx_list) do
                    if v2 == 1 then
                        local is_enable = cfg.battlematrixaddition.isEnableForPos(role_info.formation_id, i2)
                        local node_null = v.null_heros[i2]
                        if node_null then
                            node_null:setVisible(true)
                            ex.Tools:setSpriteFrame(node_null, is_enable and "other/rare-0.png" or "hero-select/spr-lock.png")
                            node_null:setScale(is_enable and 0.73 or 1)
                        end
                    end
                end
            end
        end
    end

    if is_anim then
         -- 执行音效
        ex.AudioManager:playEffect("music/audio-ready.wav")
        
        -- 显示特效
        self.spr_magic:setScale(0.1)
        self.spr_magic:setOpacity(0)
        self:reorderChild(self.spr_magic, 100)

        self.spr_magic:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.FadeIn:create(0.2), nil))
        self.spr_magic:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.ScaleTo:create(0.2, 1), nil))


        self:reorderChild(self.spr_vs, 100)
        -- self.spr_vs:runAction(ex.EffectFactory:createEffectByName("eff_clan_gvg_vs"))
    end
end

function SuperStageBattleInfoCell:onReport()
    if not self.bid or self.bid == 0 then
        return
    end
    
    -- 查询战斗。如果有。就开始战斗
    local req_bid = Pinnacle_pb.GReqGetPinnacleBattle()
    req_bid.bid = self.bid
    NetManager:sendMessage(ProtocolID.GReqGetPinnacleBattle, req_bid)
end

function SuperStageBattleInfoCell:onHero(tag, pSender)
    ex.Tools:showHeroInfo(pSender.player_data.rid, pSender.player_data.server_id, pSender.hero_id)
end

return SuperStageBattleInfoCell