local HeroListDragonWearLayerTest = class("HeroListDragonWearLayer", require("src.layer.ui.UI_HeroListDragonWearLayer"))

local UIMenuItemDragonSkill = require("src.comp.menu.UIMenuItemDragonSkill2")

function HeroListDragonWearLayerTest:onCreate()
    self.super.onCreate(self)
	self:setName("HeroListDragonWearLayerTest")

    self.is_load = false
    local scale_label = 0.5
    -- 圣龙等级
    self.lbl_dragon_level = require("src.comp.RichTextEx"):create()
	:setFontSize(44)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#219A00")
    :setScale(scale_label)
    :setAnchorPoint(0.5, 0.5)
	:setAnchorTextShadow(true)
	:setWrapMode(1)
    :setPosition(150, 120)
    self.node_attr:addChild(self.lbl_dragon_level, 10001)

    -- 圣龙阶级
    self.lbl_dragon_grade = require("src.comp.RichTextEx"):create()
	:setFontSize(44)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#219A00")
    :setScale(scale_label)
    :setAnchorPoint(0.5, 0.5)
	:setAnchorTextShadow(true)
	:setWrapMode(1)
    :setPosition(380, 120)
    self.node_attr:addChild(self.lbl_dragon_grade, 10001)

    for i=1,4 do
        self["btn_hallows_" .. i]:setTag(i)
    end

end

function HeroListDragonWearLayerTest:onEnterFinish()
    ex.RedDotManager:setStickNode(RedDotType.ZCJ_DHYX_SL_LJ_SJ, self.btn_levelup)

    self:addEvent(EVENT.BACKPACK_RES_CHANGE.CHANGE_ITEM, handler(self, self.updateLayer))
    self:addEvent(EVENT.DRAGON_EVENT.UPDATE_INFO, handler(self, self.updateLayer))
    
	-- 创建技能按钮
	for i=1,4 do
		self["btn_skill_"..i] = UIMenuItemDragonSkill:create()
        -- :setEnableAction(false)
        :setScale(0.8)
		:setPosition(i * 85 - 55, 0)
        self["btn_skill_"..i]:setTag(i)
        self["btn_skill_"..i]:registerScriptTapHandler(handler(self, self.onSkillInfo))
		self.menu_skill:addChild(self["btn_skill_"..i])
    end
    
    self.menu_skill:setScale(math.min(1, (ex.p.width - 110 - 205) / 350))

    self:updateLayer()
end

function HeroListDragonWearLayerTest:allResLoadDone()
end

-- 刷新圣物显示
function HeroListDragonWearLayerTest:updateHallows()
    for i=1,4 do
        local btn_hallows = self["btn_hallows_"..i]
        btn_hallows:setEnableAction(false)
        local hallows_data = nil
        for i2,v in ipairs(ex.Player.dragon_data.vec_hallows) do
            if v.pos == i then
                hallows_data = v
                break
            end
        end

        -- 设置红点
        local has_hallows_equip = false
        local has_hallows_upstar = false
        if hallows_data == nil then

        elseif hallows_data.item_type > 0 then
            has_hallows_upstar = true
            local config_relic = cfg.dragonrelic.dragonrelic[hallows_data.item_type]
            if config_relic ~= nil then
                if config_relic.up_star_require == "" or table.nums(config_relic.up_star_require) <= 0 then
                    has_hallows_upstar = false
                else
                    for _,item_need in ipairs(config_relic.up_star_require) do
                        if ex.Player:getItemNum(item_need.item_type) < item_need.item_num then
                            has_hallows_upstar = false
                            break
                        end
                    end
                end
            end
		else
			for _,item_backpack in pairs(ex.Player.backpack_data.backpack_list) do
				local item_config = cfg.item.item[item_backpack.item_type]
				if item_config.mode == ItemData.IT_HALLOWS then
					local is_equip = false
					for _,tmp_hallows in ipairs(ex.Player.dragon_data.vec_hallows) do
						if tmp_hallows.item_type == item_backpack.item_type then
							is_equip = true
							break
						end
					end
					if not is_equip then
						has_hallows_equip = true
						break
					end
				end
			end
        end
        ex.Tools:addRedPoint(btn_hallows, has_hallows_equip or has_hallows_upstar, cc.p(0.8, 0.8))
        
        if hallows_data == nil then
            -- 槽位未解锁
            if btn_hallows.spr_add ~= nil then
                btn_hallows.spr_add:removeFromParent()
                btn_hallows.spr_add = nil
            end

            if btn_hallows.spr_icon ~= nil then
                btn_hallows.spr_icon:removeFromParent()
                btn_hallows.spr_icon = nil
            end

            if btn_hallows.spr_lock == nil then
                btn_hallows.spr_lock = cc.Sprite:create()
                btn_hallows.spr_lock:setPosition(44, 44)
                btn_hallows:addChild(btn_hallows.spr_lock)
                ex.Tools:setSpriteFrameAsyn(btn_hallows.spr_lock, "dragon/spr-lock.png", "dragon")
            end
        elseif hallows_data.item_type > 0 then
            -- 槽位已解锁但未装载圣物
            if btn_hallows.spr_lock ~= nil then
                btn_hallows.spr_lock:removeFromParent()
                btn_hallows.spr_lock = nil
            end

            if btn_hallows.spr_add ~= nil then
                btn_hallows.spr_add:removeFromParent()
                btn_hallows.spr_add = nil
            end

            local is_need_update_effect = false
            if btn_hallows.spr_icon ~= nil and btn_hallows.spr_icon.item_type ~= hallows_data.item_type then
                btn_hallows.spr_icon:removeFromParent()
                btn_hallows.spr_icon = nil
            end

            local config_relic = cfg.dragonrelic.dragonrelic[hallows_data.item_type]

            -- 添加图标
            if btn_hallows.spr_icon == nil then
                is_need_update_effect = true

                btn_hallows.spr_icon = cc.Sprite:create()
                btn_hallows.spr_icon:setPosition(44, 44)
                btn_hallows:addChild(btn_hallows.spr_icon)
                ex.Tools:setSpriteFrameAsyn(btn_hallows.spr_icon, "dragon-relic/"..config_relic.icon..".png", "dragon-relic")

                btn_hallows.spr_icon.node_star = cc.Node:create()
                btn_hallows.spr_icon.node_star:setPosition(44, 5)
                btn_hallows.spr_icon:addChild(btn_hallows.spr_icon.node_star, 20)
            end
            btn_hallows.spr_icon.item_type = hallows_data.item_type

            if btn_hallows.spr_icon.star == nil or btn_hallows.spr_icon.star ~= config_relic.star then
                is_need_update_effect = true

                btn_hallows.spr_icon.node_star:removeAllChildren()
                local star = config_relic.star
                for i=1,star do
                    local spr_star = cc.Sprite:createWithSpriteFrameName("other/star-0.png")
                    spr_star:setScale(0.5)
                    spr_star:setPosition(cc.p((i - star / 2 - 0.5) * 15, 0))
                    btn_hallows.spr_icon.node_star:addChild(spr_star)
                end
            end
            btn_hallows.spr_icon.star = config_relic.star

            -- 添加特效
            if is_need_update_effect == true then
                if btn_hallows.spr_icon.spr_effect ~= nil then
                    btn_hallows.spr_icon.spr_effect:removeFromParent()
                    btn_hallows.spr_icon.spr_effect = nil
                end

                ex.EffectFactory:createEffectWithNodeByNameAsyn("eff_dragon_relic_"..config_relic.rare, btn_hallows.spr_icon, cc.p(44, 44 + 6), 10)
                -- btn_hallows.spr_icon.spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_dragon_relic_"..config_relic.rare)
                -- btn_hallows.spr_icon.spr_effect:setPosition(btn_hallows.spr_icon:getContentSize().width / 2, btn_hallows.spr_icon:getContentSize().height / 2 + 6)
                -- btn_hallows.spr_icon.spr_effect:setAnchorPoint(cc.p(0.5, 0.5))
                -- btn_hallows.spr_icon:addChild(btn_hallows.spr_icon.spr_effect, 10, 10)
            end
        else
            -- 槽位已解锁并装载圣物
            if btn_hallows.spr_lock ~= nil then
                btn_hallows.spr_lock:removeFromParent()
                btn_hallows.spr_lock = nil
            end

            if btn_hallows.spr_icon ~= nil then
                btn_hallows.spr_icon:removeFromParent()
                btn_hallows.spr_icon = nil
            end

            if btn_hallows.spr_add == nil then
                btn_hallows.spr_add = cc.Sprite:createWithSpriteFrameName("other/spr-add-1.png")
                btn_hallows.spr_add:setPosition(btn_hallows:getContentSize().width / 2, btn_hallows:getContentSize().height / 2)
                btn_hallows:addChild(btn_hallows.spr_add)
            end
        end
    end
    for i,v in ipairs(ex.Player.dragon_data.vec_hallows) do
        local btn_hallows = self["btn_hallows_"..v.pos]
        if btn_hallows ~= nil then
            if v.item_type > 0 then
                if btn_hallows.spr_add ~= nil then
                    btn_hallows.spr_add:removeFromParent()
                    btn_hallows.spr_add = nil
                end
    
                if btn_hallows.spr_icon == nil then
                    btn_hallows.spr_icon = cc.Sprite:createWithSpriteFrameName(cfg.item.item[v.item_type].icon..".png")
                    btn_hallows.spr_icon:setPosition(btn_hallows:getContentSize().width / 2, btn_hallows:getContentSize().height / 2)
                    btn_hallows:addChild(btn_hallows.spr_icon)
                end
            else
                if btn_hallows.spr_icon ~= nil then
                    btn_hallows.spr_icon:removeFromParent()
                    btn_hallows.spr_icon = nil
                end
    
                if btn_hallows.spr_add == nil then
                    btn_hallows.spr_add = cc.Sprite:createWithSpriteFrameName("other/spr-add-1.png")
                    btn_hallows.spr_add:setPosition(btn_hallows:getContentSize().width / 2, btn_hallows:getContentSize().height / 2)
                    btn_hallows:addChild(btn_hallows.spr_add)
                end
            end
        end
    end
end

-- 刷新技能显示
function HeroListDragonWearLayerTest:updateSkill()
    local config_remains = cfg.dragonrelic.dragonrelic
    for i=1,4 do
        local btn_skill = self["btn_skill_"..i]
        local hallows_data = nil
        for i2,v in ipairs(ex.Player.dragon_data.vec_hallows) do
            if v.pos == i then
                hallows_data = v
                break
            end
        end

        btn_skill:setLock(hallows_data == nil)
        btn_skill.skill_type = 0
        if hallows_data == nil then
            
        elseif hallows_data.item_type <= 0 then
            btn_skill:setIcon(0)
            btn_skill:setLevel(0)
        else
            local config_relic = cfg.dragonrelic.dragonrelic[hallows_data.item_type]
            btn_skill:setIcon(config_relic.skill)
            btn_skill:setLevel(config_relic.star)
            btn_skill.skill_type = config_relic.skill
            btn_skill.skill_level = config_relic.star
        end
    end
end

function HeroListDragonWearLayerTest:updateLayer()
    if self:isVisible() == false then
        return
    end
    
    local config_level = cfg.dragonlevel.dragonlevel[ex.Player.dragon_data.dragon_level]
    -- 圣龙等阶
    self.lbl_dragon_level:setXmlTextLua(string.format(ex.Tools:getLang(74524), config_level.level, ex.Player.dragon_data:getDragonLevelMaxByGrade(config_level.grade)))
    self.lbl_dragon_level:formatText()
    self.lbl_dragon_grade:setXmlTextLua(string.format(ex.Tools:getLang(74525), config_level.grade))
    self.lbl_dragon_grade:formatText()
    
    self.lbl_dragon_name:setString(ex.Tools:getLang(config_level.name))

    if self.spine_dragon == nil or self.node_spine_dragon.relic_unlock == nil or self.node_spine_dragon.relic_unlock ~= config_level.relic_unlock then
        if self.spine_dragon ~= nil then
            self.spine_dragon:removeFromParent()
            self.spine_dragon = nil
        end
        local str_name = "spine/Dragon-"..config_level.relic_unlock
        self.spine_dragon = sp.SkeletonAnimation:create(str_name..".json", str_name..".atlas", 1)
        self.spine_dragon:setAnimation(0, "stand", true)
        self.spine_dragon:setScale(0.95)
        self.spine_dragon:setPosition(0, 0)
        self.node_spine_dragon:addChild(self.spine_dragon, 0, 10)

        self.node_spine_dragon.relic_unlock = config_level.relic_unlock
    end

    -- 更新属性显示
    local dragon_ability = clone(config_level.ability)
    for _,v in ipairs(dragon_ability) do
        for _,v2 in ipairs(ex.Player.dragon_data.vec_hallows) do
            if v2 ~= nil and v2.item_type > 0 then
                local config_relic = cfg.dragonrelic.dragonrelic[v2.item_type]
                for _,v3 in ipairs(config_relic.ability) do
                    if v3.attr == v.attr then
                        v.value = v.value + v3.value
                    end
                end
            end
        end
    end
    for _,v in ipairs(dragon_ability) do
        if v.attr == 220 then
            self.lbl_attack:setString(v.value)
        elseif v.attr == 223 then
            self.lbl_hp:setString(v.value)
        elseif v.attr == 224 then
            self.lbl_defense:setString(v.value)
        elseif v.attr == 101 then
            self.lbl_speed:setString(v.value)
        end 
    end

    -- 更新圣物显示
    self:updateHallows()

    -- 更新圣物技能显示
    self:updateSkill()

    -- 更新资源显示
    local config_level_next = cfg.dragonlevel.dragonlevel[ex.Player.dragon_data.dragon_level + 1]
    if config_level_next == nil then
        self.node_res_need_1:setVisible(false)
        self.node_res_need_2:setVisible(false)
        self.btn_levelup:setVisible(false)

        self.lbl_level_max_tip:setVisible(true)
    else
        self.btn_levelup:setLabelText(ex.Tools:getLang((config_level.grade == config_level_next.grade) and 74527 or 74528))

        self.node_res_need_1:setVisible(true)
        self.node_res_need_2:setVisible(true)
        self.btn_levelup:setVisible(true)

        self.lbl_level_max_tip:setVisible(false)

        for i=1,2 do
            local spr_res_need = self["spr_res_need_"..i]
            local lbl_res_need = self["lbl_res_need_"..i]
            
            local config_need = config_level.item_require[i]
            if config_need == nil then
                self["node_res_need_"..i]:setVisible(false)
            else
                self["node_res_need_"..i]:setVisible(true)

                spr_res_need:setSpriteFrame(cfg.item.item[config_need.item_type].icon..".png")

                local item_num = ex.Player:getItemNum(config_need.item_type)
                lbl_res_need:setString(ex.StringUtil.getScientificNumber(item_num).."/"..ex.StringUtil.getScientificNumber(config_need.item_num))
                lbl_res_need:setColor((item_num >= config_need.item_num) and cc.c3b(255,225,178) or cc.c3b(185,0,0))
            end
        end
    end
end

function HeroListDragonWearLayerTest:onInfo(tag, pSender)
	require("src.layer.InfoCtr"):instance():openWindow(ex.Tools:getLang(42086),
                                                       ex.Tools:getLang(42087))
end

function HeroListDragonWearLayerTest:onSkillInfo(tag, pSender)
    if pSender.skill_type == nil or pSender.skill_type <= 0 then
        return
    end
    require("src.layer.HeroSkillInfoCtr"):instance():openWindow(pSender.skill_type, pSender.skill_level)
end

-- 查看圣物信息及添加圣物
function HeroListDragonWearLayerTest:onClickHallows(tag, pSender)
    local hallows_data = nil
    for i2,v in ipairs(ex.Player.dragon_data.vec_hallows) do
        if v.pos == tag then
            hallows_data = v
            break
        end
    end
    
    if hallows_data == nil then
        local cur_unlock_num = cfg.dragonlevel.dragonlevel[ex.Player.dragon_data.dragon_level].relic_unlock
        local next_grade = 0
        for i,v in ipairs(cfg.dragonlevel.dragonlevel) do
            if v.relic_unlock > cur_unlock_num then
                next_grade = v.grade
                break
            end
        end
        ex.MessageView:add(string.format(ex.Tools:getLang(74605), next_grade))
        return
    end

    if hallows_data.item_type > 0 then
        -- 已装载圣物，点击打开圣物升星界面
        require("src.layer.dragon.HallowsUpStarCtr"):instance():openWindow(hallows_data.item_type, false, hallows_data.pos)
    else
        -- 未装载圣物，点击打开圣物选择界面
        local vec_item = ex.Player.backpack_data:getItemsByPageSign(ItemData.IT_HALLOWS)
        if #vec_item <= 0 then
            ex.MessageView:add(ex.Tools:getLang(74554))
            return
        end
        require("src.layer.dragon.HallowsSelectCtr"):instance():openWindow(hallows_data.pos)
    end
end

-- 调整技能顺序，打开调整界面
function HeroListDragonWearLayerTest:onSkillReplace(tag, pSender)
    require("src.layer.dragon.DragonSkillCtr"):instance():openWindow()
end

-- 圣龙升级
function HeroListDragonWearLayerTest:onLevelup(tag, pSender)
    local config_level = cfg.dragonlevel.dragonlevel[ex.Player.dragon_data.dragon_level]
    local config_level_next = cfg.dragonlevel.dragonlevel[ex.Player.dragon_data.dragon_level + 1]

    if config_level_next == nil then
        ex.MessageView:add(ex.Tools:getLang(74553))
        return
    end

    for i,v in ipairs(config_level.item_require) do
        if ex.Player:getItemNum(v.item_type) < v.item_num then
            -- 资源不足
            ex.Tools:showEnoughTip(v.item_type, true)
            return
        end
    end

    NetManager:sendMessage(ProtocolID.GReqDragonUpgradeLevel)

    ex.AudioManager:playEffect("music/hero-up-level.mp3")

    -- 先做一次+1处理，防止同一等级多次发协议
    ex.Player.dragon_data.dragon_level = ex.Player.dragon_data.dragon_level + 1

    self:updateLayer()

    ex.Player.dragon_data:checkReddot()
end

return HeroListDragonWearLayerTest
