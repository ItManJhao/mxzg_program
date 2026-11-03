-- 英雄进化界面
local HeroEvolutionLayer = class("HeroEvolutionLayer", require("src.comp.EventLayerAdaptiveWidthFull"))
local HeroEvolutionSeat = class("HeroEvolutionSeat", require("src.comp.EventLayer"))
local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

-------------------------------------HeroEvolutionSeat-------------------------------------
function HeroEvolutionSeat:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.data = {}
end

function HeroEvolutionSeat:resetData(data)
    self.data = data

    self.node_animator:removeAllChildren()

    self.lbl_name = require("src.comp.RichTextEx"):create()
        :setFontSize(44)
        :setFontFace(FONT_DEFAULT_NAME_BOLD)
        :setScale(0.5)
        :setAnchorTextShadow(true)
        :setWrapMode(1)
        :setAnchorPoint(0.5, 0.5)
        :setPosition(self.btn_info:getContentSize().width / 2, self.btn_info:getContentSize().height / 2)
    self.btn_info:addChild(self.lbl_name)
    self.btn_info.data = data

    -- 进化祭台选择光效
    self.spr_glow_effect = ex.EffectFactory:createEffectWithNodeByName("eff_evolution_glow")
    self.spr_glow_effect:setAnchorPoint(cc.p(0.5, 0))
    self.spr_glow_effect:setPosition(0, -80)
    self.spr_glow_effect:setVisible(false)
    self.node_animator:addChild(self.spr_glow_effect, 11)

    if data then
        self.animator = require("src.person.Hero"):create("1", "1", 1, 1, ex.Tools:getHeroSkinByImageId(data.config.evolve_fashion_id))
        self.animator:setAnimation(0, "stand", true)
        self.animator:setScale(1.5)
        self.animator:setAnchorPoint(cc.p(0.5, 0))
        self.animator:setPosition(cc.p(0, 0))
        self.animator:setShadowVisible(false)
        self.node_animator:addChild(self.animator, 10)

        local str = string.format("<img src='evolution/spr-magnifier.png' width='57.2' height='75.4' /><font color='#FFE3B7'>%s</font>", ex.Tools:getLang(data.config.evo_name))
        self.lbl_name:setXmlTextLua(str)
        self.lbl_name:formatText()
    end
end

-- 进化选中设置 
function HeroEvolutionSeat:setSelected(is_select)
    if is_select then
        -- self.spr_stage:setSpriteFrame("evolution/select-stage.png")
        ex.Tools:setSpriteFrame(self.spr_stage, "evolution/select-stage.png")
        self.spr_glow_effect:setVisible(true)
        self.animator:attack()
    else
        -- self.spr_stage:setSpriteFrame("evolution/no-select-stage.png")
        ex.Tools:setSpriteFrame(self.spr_stage, "evolution/no-select-stage.png")
        self.spr_glow_effect:setVisible(false)
        self.animator:setAnimation(0, "stand", true)
    end
end

-------------------------------------HeroEvolutionLayer-------------------------------------
function HeroEvolutionLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(true)
    self:initEventListen()
    self:initPlist()

    self.node_top:setZOrder(100)
    self.node_bottom:setZOrder(100)
    local pos_y = ex.p.height - 100 * ex.s.global_scale - require("src.model.Game"):instance():getNotchHeight()
    self.node_top:setPositionY(pos_y)
    self.node_bottom:setPositionY(ex.MainSceneCtr:getBottomHeight())
    self.node_evolution:setPositionY(self.node_bottom:getPositionY() + self.node_bottom:getContentSize().height - 50)
    self.spr_bg:setContentSize(self:getContentSize())
    self.btn_evolve:registerScriptTapHandler(handler(self, self.onEvolution))
    self.btn_exit:registerScriptTapHandler(handler(self, self.onExittion))
    self.btn_evolution_tree:registerScriptTapHandler(handler(self, self.onEvolutionTree))
    self.btn_info:registerScriptTapHandler(handler(self, self.onEvolutionExplain))
    -- 进化背后环形特效
    local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_evolution_bg")
    spr_effect:setAnchorPoint(cc.p(0.5, 0.5))
    spr_effect:setPosition(self.spr_glow_bg:getContentSize().width / 2, self.spr_glow_bg:getContentSize().height / 2 + 35)
    self.spr_glow_bg:addChild(spr_effect)

    self.lpl_skill_name = require("src.comp.RichTextEx"):create()
        :setFontSize(44)
        :setFontFace(FONT_DEFAULT_NAME_BOLD)
        :setScale(0.5)
        :setAnchorTextShadow(true)
        :setWrapMode(1)
        :setAnchorPoint(0.5, 0.5)
        :setPosition(self.node_bottom:getContentSize().width / 2, 505)
    self.node_bottom:addChild(self.lpl_skill_name)

    self:updateLayer()
end

-- 初始化监听事件
function HeroEvolutionLayer:initEventListen()
    self:addEvent(EVENT.HERO_INFO_EVENT.UPDATE_EVOLVE, handler(self, self.handleHeroEvolution))
    self:addEvent(EVENT.HERO_INFO_EVENT.HERO_EVOLVE_SELECT_CERTAIN, handler(self, self.handleUpdateConsume))
    self:addEvent(EVENT.BACKPACK_RES_CHANGE.CHANGE_ITEM, handler(self, self.handleUpdateConsumeItem))
    self:addEvent(EVENT.HERO_EVENT.HERO_EXIT_BACK_SUCCRESS, handler(self,self.onHeroRollBackSuccess))
end

-- 初始化plist
function HeroEvolutionLayer:initPlist()
    local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-base/evolution.plist")
end

function HeroEvolutionLayer:updateLayer()
    self.data = ex.Player.hero_data.promote:getSelectHero()
    if not self.data then
        return
    end

    local evolve_data = self.data.evolve
    local hero_type = self.data.hero_type
    local evolution_list = cfg.heroevolvelevel.getEvolutionList(hero_type, evolve_data)

    -- 根据进化进度去创建英雄祭台
    if evolution_list and #evolution_list > 0 then
        self.btn_evolve:setEnabled(true)
        self.btn_evolve:setVisible(true)
        self.node_comsume:setVisible(true)
        self.node_max:setVisible(false)
        if #evolution_list == 1 then
            self.spr_left_line:setVisible(false)
            self.spr_right_line:setVisible(false)
            if self.seat_left then
                self.seat_left:setVisible(false)
            end

            if self.seat_right then
                self.seat_right:setVisible(false)
            end
            
            self.btn_exit:setVisible(true)
            self.btn_exit:setPositionX(160)
            self.btn_evolve:setPositionX(420)

            local seat_data = {
                hero_data = self.data,
                config = evolution_list[1]
            }
            if self.single_seat then
                self.single_seat:removeFromParent()
                self.single_seat = false
            end
            -- if not self.single_seat then
                self.single_seat = self:createSeat(seat_data)
                self.single_seat:setPosition(
                    self.node_evolution:getContentSize().width / 2 - self.single_seat:getContentSize().width / 2,
                    20
                )
                self.node_evolution:addChild(self.single_seat)
            -- else
            --     self.single_seat:resetData(seat_data)
            --     self.single_seat:setVisible(true)
            -- end
            
            self.select_seat = self.single_seat
            self.single_seat:setSelected(true)
        else
            self.spr_left_line:setVisible(true)
            self.spr_right_line:setVisible(true)
            if self.single_seat then
                self.single_seat:setVisible(false)
            end

            local left_seat_data = {
                hero_data = self.data,
                config = evolution_list[1],
                line_name = "spr_left_line"
            }

            self.btn_exit:setVisible(false)
            self.btn_evolve:setPositionX(320)

            if not self.seat_left then
                self.seat_left = self:createSeat(left_seat_data)
                self.seat_left:setPosition(
                    self.node_evolution:getContentSize().width / 2 - self.seat_left:getContentSize().width - 48,
                    self.spr_left_line:getPositionY() - 25
                )
                self.node_evolution:addChild(self.seat_left)
            else
                self.seat_left:resetData(left_seat_data)
                self.seat_left:setVisible(true)
            end

            self.select_seat = self.seat_left
            self.seat_left:setSelected(true)

            if not self.spr_left_line:getChildByName("spr_line_effect") then
                local spr_left_line_effect = ex.EffectFactory:createEffectWithNodeByName("eff_evolution_line")
                spr_left_line_effect:setAnchorPoint(cc.p(0.5, 0.5))
                spr_left_line_effect:setPosition(61, 64)
                self.spr_left_line:addChild(spr_left_line_effect)
                spr_left_line_effect:setName("spr_line_effect")
            else
                self.spr_left_line:getChildByName("spr_line_effect"):setVisible(true)
            end

            local right_seat_data = {
                hero_data = self.data,
                config = evolution_list[2],
                line_name = "spr_right_line"
            }

            if not self.seat_right then
                self.seat_right = self:createSeat(right_seat_data)
                self.seat_right:setPosition(
                    self.node_evolution:getContentSize().width / 2 + 48,
                    self.spr_right_line:getPositionY() - 25
                )
                self.node_evolution:addChild(self.seat_right)
            else
                self.seat_right:resetData(right_seat_data)
                self.seat_right:setVisible(true)
            end

            if not self.spr_right_line:getChildByName("spr_line_effect") then
               local spr_right_line_effect = ex.EffectFactory:createEffectWithNodeByName("eff_evolution_line")
                spr_right_line_effect:setAnchorPoint(cc.p(0.5, 0.5))
                spr_right_line_effect:setPosition(61, 64)
                self.spr_right_line:addChild(spr_right_line_effect)
                spr_right_line_effect:setName("spr_line_effect")
                spr_right_line_effect:setVisible(false)
            else
                self.spr_right_line:getChildByName("spr_line_effect"):setVisible(false)
            end
        end

        self:updateItemInfo()
        self:updateAttr()
        self:updateSkill()
    else
        self.btn_evolve:setVisible(false)
        self.node_comsume:setVisible(false)
        self.node_max:setVisible(true)
        self.btn_exit:setVisible(true)
        self.btn_exit:setPositionX(320)

        if evolve_data and evolve_data.type > 0 then
            local config = cfg.heroevolvelevel.getEvolutionConfig(hero_type, evolve_data.level, evolve_data.type)
            if not config then
                return
            end

            self.spr_left_line:setVisible(false)
            self.spr_right_line:setVisible(false)
            if self.seat_left then
                self.seat_left:setVisible(false)
            end

            if self.seat_right then
                self.seat_right:setVisible(false)
            end

            local seat_data = {
                hero_data = self.data,
                config = config
            }
            
            if not self.single_seat then
                self.single_seat = self:createSeat(seat_data)
                self.single_seat:setPosition(
                    self.node_evolution:getContentSize().width / 2 - self.single_seat:getContentSize().width / 2,
                    20
                )
                self.node_evolution:addChild(self.single_seat)
            else
                self.single_seat:resetData(seat_data)
                self.single_seat:setVisible(true)
            end
            
            self.select_seat = self.single_seat
            self.single_seat:setSelected(true)

            self:updateAttr()
            self:updateSkill()
        end
    end
end
-- 创建英雄祭台
function HeroEvolutionLayer:createSeat(data)
    local seat = HeroEvolutionSeat:createWithCCBIFile("ccbi/HeroEvolutionSeat.ccbi")
    seat:resetData(data)

    seat.listener = cc.EventListenerTouchOneByOne:create()  --创建一个单点事件监听
    seat.listener:setSwallowTouches(true)
    seat.listener:registerScriptHandler(function(touch, event) 
        local touchLocation = touch:getLocation()
        touchLocation = seat:getParent():convertToNodeSpace(touchLocation)
        local bBox = seat:getBoundingBox()
        if cpp.Game:isInVisible(seat) and cc.rectContainsPoint(bBox, touchLocation) then
            self:onSelect(seat)
            return true
        else
            return false
        end
    end, cc.Handler.EVENT_TOUCH_BEGAN)
    local event_dispatcher = seat:getEventDispatcher()
    event_dispatcher:addEventListenerWithSceneGraphPriority(seat.listener, seat)
    seat.btn_info:registerScriptTapHandler(handler(self, self.onEvolutionInfo))

    return seat
end
-- 更新进化需要消耗物品
function HeroEvolutionLayer:updateItemInfo()
    local config = self.select_seat.data.config
    self.node_items:removeAllChildren()

    local menu = cpp.UIMenu:create()
    menu:setSwallowsTouches(false)
    self.node_items:addChild(menu)
    menu:setPosition(cc.p(0, 0))

    local margin = 18
    local scale = 0.8
    self.hero_items = {}
    self.select_list = {}
    self.consume_items = {}
    local index = 1
    for k, v in pairs(config.consume_hero) do
        local type = v.type == -1 and self.data.hero_type or v.type
        local elem = v.elem == -1 and self.data.elem or v.elem
        local str = string.format("%s/%s", 0, ex.StringUtil.getScientificNumber(v.num))
        local node = UIMenuItemHero:createWithData(nil, type, elem, v.num, v.star, nil)
        node:setScale(scale)
        local data = {}
        data.hero_id = self.data.hero_id
        data.consume_num = v.num
        data.num = str
        data.type = type
        data.elem = elem
        data.star = v.star
        data.replace_item = v.replace_item
        node:initSelectItem(data)
        self.hero_items[k] = node
        node:setTag(k)
        menu:addChild(node)
        node.data = data
        node:setPosition((node:getContentSize().width * scale + margin) * (k - 0.5), 0)
        node:registerScriptTapHandler(handler(self, self.onSelectItem))
        index = index + 1

        if type == 0 then
            node:setAllIcon()
        end
    end

    if config.consume_item and #config.consume_item > 0 then
        for i, v in ipairs(config.consume_item) do
            local item = UIMenuItemBackpack:createWithData(v.item_type, 1)
            local item_num = ex.Player:getItemNum(v.item_type)
            item.lbl_num:setString(ex.StringUtil.getScientificNumber(item_num) .. "/" .. ex.StringUtil.getScientificNumber(v.item_num))
            item.lbl_num:setColor(item_num >= v.item_num and cc.c3b(255, 225, 187) or cc.c3b(254, 133, 128))
            item:setScale(scale)
            item:setPosition((item:getContentSize().width * scale + margin) * (index - 0.5), 0)
            item:registerScriptTapHandler(handler(self, self.onItemInfo))
            item:setTag(index)
            menu:addChild(item)
            item.consume_data = v
            item.is_enough = item_num >= v.item_num
            self.consume_items[i] = item
            index = index + 1
        end
    end
end
-- 更新进化的属性UI
function HeroEvolutionLayer:updateAttr()
    local config = self.select_seat.data.config
    if not config or not config.attr_show then
        return
    end

    for k, v in pairs(config.attr_show) do
        local node = self[string.format("node_attr_addition_%d", k)]
        if node then
            local attr_data = v
            local attr = attr_data.attr
            local value = attr_data.value
            local icon = self[string.format("spr_attr_icon_%d", k)]
            if icon then
                ex.Tools:setSpriteFrame(icon,(string.format("backpack-info/spr-attr-%d.png", cfg.attrshow.attrshow[attr].icon)))
            end

           local lbl_attr = self[string.format("lbl_attr_%d", k)]
            if not lbl_attr then
                lbl_attr = require("src.comp.RichTextEx"):create()
                    :setFontSize(40)
                    :setFontFace(FONT_DEFAULT_NAME_BOLD)
                    :setScale(0.5)
                    :setAnchorTextShadow(true)
                    :setWrapMode(1)
                    :setAnchorPoint(0, 0.5)
                    :setPosition(16, 0)
                node:addChild(lbl_attr)
                self[string.format("lbl_attr_%d", k)] = lbl_attr
            end

            local attstr = ex.Tools:getLang(2141000 + attr)
            attstr = ex.StringUtil.formatAttrStrNum(attstr, "##" , value, "<font color='#219A00'> +%s</font>")
            local str = string.format( "<br><font color='#744D27'>%s</font></br>" , attstr)
            lbl_attr:setXmlTextLua(str)
            lbl_attr:formatText()
            
            node:setVisible(true)
        end
    end
end
-- 更新进化的技能UI
function HeroEvolutionLayer:updateSkill()
    local hero_data = self.select_seat.data.hero_data
    local hero_conf = cfg.herotype.star[hero_data.hero_type]

    local skill_id = self.select_seat.data.config.skill_id
    local skill_level = self.select_seat.data.config.skill_level
    local skill_old_id = self.select_seat.data.config.skill_old_id
    if not self.spr_skill_icon then
        self.spr_skill_icon_bg = cc.Sprite:createWithSpriteFrameName("evolution/spr-skill-bg.png")
        self.spr_skill_icon_bg:setPosition(cc.p(0, 0))
        self.node_skill:addChild(self.spr_skill_icon_bg)
        self.spr_skill_icon = cc.Sprite:createWithSpriteFrameName(string.format("skill-icon/%d.png", skill_id))
        self.spr_skill_icon:setPosition(cc.p(0, 0))
        self.node_skill:addChild(self.spr_skill_icon)
        self.spr_skill_icon_frame = cc.Sprite:createWithSpriteFrameName("skill-icon/spr-skill-evolve-frame.png")
        self.spr_skill_icon_frame:setPosition(cc.p(0, 4))
        self.node_skill:addChild(self.spr_skill_icon_frame)
    else
        ex.Tools:setSpriteFrame(self.spr_skill_icon, string.format("skill-icon/%d.png", skill_id))
    end

    local skill_config = cfg.heroskill.getConfigByType(skill_id, skill_level)
    local str = string.format("<font color='#875F33'>%s</font><font color='#EC50FF'>%s</font>", ex.Tools:getLang(skill_config.lan_name), ex.Tools:getLang(76339))
    self.lpl_skill_name:setXmlTextLua(str)
    self.lpl_skill_name:formatText()
    local desc = ex.Tools:getLang(skill_config.lan_describe)
    if ex.Tools:getLang(skill_config.lan_describe) == "" then
        desc = ex.Tools:getLang(5702) .. ex.Tools:getLang(5663)
    end

    if not self.skill_desc_scroll_view then
        local view_size = cc.size(534, 94)
        self.skill_desc_scroll_view = cc.ScrollView:create(view_size)
        self.skill_desc_scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        self.skill_desc_scroll_view:setPosition(4, 2)
        self.spr_desc_bg:addChild(self.skill_desc_scroll_view)

        if not self.lpl_next_skill_desc then
            self.lpl_next_skill_desc = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 18)
                :setTextColor(cc.c3b(135,95,51))
                :setAnchorPoint(cc.p(0.5, 1))
                :setPositionX(view_size.width / 2)
                :setDimensions(view_size.width, 0)
            self.skill_desc_scroll_view:addChild(self.lpl_next_skill_desc)
        end
    end

    self.lpl_next_skill_desc:setString(desc)
    
    local lbl_size = self.lpl_next_skill_desc:getContentSize()
    local sv_size = self.skill_desc_scroll_view:getViewSize()
    if lbl_size.height > sv_size.height then
        self.skill_desc_scroll_view:setContentSize(cc.size(sv_size.width, lbl_size.height))
        self.lpl_next_skill_desc:setPositionY(lbl_size.height)
        self.skill_desc_scroll_view:setContentOffset(cc.p(0, sv_size.height - lbl_size.height))
        self.skill_desc_scroll_view:setTouchEnabled(true)
    else
        self.skill_desc_scroll_view:setContentSize(cc.size(sv_size.width, sv_size.height))
        self.lpl_next_skill_desc:setPositionY(sv_size.height)
        self.skill_desc_scroll_view:setTouchEnabled(false)
    end
end
-- 处理选中消耗物品的事件处理
function HeroEvolutionLayer:handleUpdateConsume(event, data)
    local index = data.index
    
    if self.hero_items and #self.hero_items >= index then
         self.select_list[index] = {}
        if data.select_list and #data.select_list > 0 then
            for k, v in ipairs(data.select_list) do
                table.insert(self.select_list[index], v)
            end
        end

        local node = self.hero_items[index]
        -- 如果数量已经满了则设置is_enough为true
        node.is_enough = data.select_num >= node.data.consume_num
        node.data.select_num = data.select_num
        local str = string.format("%s/%s", data.select_num, node.data.consume_num)
		node:setSelectNum(str)
    end
end
-- 处理背包物品变动的事件处理
function HeroEvolutionLayer:handleUpdateConsumeItem(event, data)
    if not self.consume_items then
        return
    end

    for k, v in pairs(self.consume_items) do
        local consume_data = v.consume_data
        if consume_data and consume_data.item_type then
            local item_num = ex.Player:getItemNum(consume_data.item_type)
            v.lbl_num:setString(item_num .. "/" .. consume_data.item_num)
            -- 如果数量已经满了则设置is_enough为true
            v.is_enough = item_num >= consume_data.item_num
        end
    end
end
-- 处理进化成功事件
function HeroEvolutionLayer:handleHeroEvolution(event, data)
    require("src.layer.heroevolution.HeroEvolutionSuccessCtr"):instance():openWindow(data)
    self:updateLayer()
end

--处理回退成功事件
function HeroEvolutionLayer:onHeroRollBackSuccess(event, data)
    if (data.reward and #data.reward > 0) then
        local heros = {}
        local rewardData = data.reward
        for i=1,#rewardData do
            table.insert( heros, {item_type = rewardData[i].type, item_num = rewardData[i].num, star = rewardData[i].star, level = rewardData[i].level, hero_id = rewardData[i].id})
        end
        require("src.layer.ItemRewardCtr"):instance():openWindow(heros)
    end
    self:updateLayer()
end

-- 返回按钮事件
function HeroEvolutionLayer:onBack(tag, pSender)
    ex.MainSceneCtr:changeLayer(MainSceneType.HERO_INFO_LAYER)
end
-- 选中祭台按钮事件
function HeroEvolutionLayer:onSelect(pSender)
    local data = pSender.data
    local evolve_type = self.select_seat.data.config.evolve_type
    if self.select_seat and self.select_seat.data.config.evolve_type == data.config.evolve_type then
        return
    end

    if self.select_seat.data.line_name then
        local line = self[self.select_seat.data.line_name]
        if line then
            local effect = line:getChildByName("spr_line_effect")
            if effect then
                effect:setVisible(false)
            end
        end
    end

    if data.line_name then
        local line = self[data.line_name]
        if line then
            local effect = line:getChildByName("spr_line_effect")
            if effect then
                effect:setVisible(true)
            end
        end
    end

    self.select_seat:setSelected(false)
    pSender:setSelected(true)
    self.select_seat = pSender

    self:updateItemInfo()
    self:updateAttr()
    self:updateSkill()
end

--回退按钮点击事件
function HeroEvolutionLayer:onExittion()
    local cost_data = cfg.system.heroevo_back_cost[1]
    if cost_data then
        local item_num = cost_data.item_num
        local content = string.format(ex.Tools:getLang(76346), item_num)
        ex.ConfirmCtr:instance():openWindow(ex.Tools:getLang(4016), content, handler(self, self.onBlackClickDone))
    else 
        print("没有这个进化回退消耗的配置，找策划！！！")
    end
end

function HeroEvolutionLayer:onBlackClickDone()
    local cost_data = cfg.system.heroevo_back_cost[1]
    local item_type = cost_data.item_type
    local has_num = ex.Player:getItemNum(item_type)
    if has_num >= cost_data.item_num then 
        local req = Hero_pb.GReqEvolveBack()
        req.hero_id = self.data.hero_id
        NetManager:sendMessage(ProtocolID.GReqEvolveBack, req)
    else 
        ex.MessageView:add(ex.Tools:getLang(47222))
    end 
end

-- 进化按钮点击事件
function HeroEvolutionLayer:onEvolution()
    for k, v in pairs(self.consume_items) do
        if not v.is_enough then
            ex.MessageView:add(ex.Tools:getLang(76340))
            return
        end
    end

    for k, v in pairs(self.hero_items) do
        if not v.is_enough then
            ex.MessageView:add(ex.Tools:getLang(76340))
            return
        end
    end

    local doEvolve = function ( )
        self.btn_evolve:setEnabled(false)
        local req = Hero_pb.GReqEvolve()
        req.hero_id = self.data.hero_id
        req.type = self.select_seat.data.config.evolve_type

        for k, v in pairs(self.select_list) do
            if v and #v > 0 then
                local model = req.consume:add()
                model.index = k - 1
                for i = 1, #v do
                    local data = v[i]
                    table.insert(model.hero_id, data.hero_id)
                end
            end
        end

        NetManager:sendMessage(ProtocolID.GReqEvolve, req)
    end

    local config = self.select_seat.data.config
    if config and config.level == 1 then
        ex.ConfirmCtr:openWindow(
            ex.Tools:getLang(18),
            ex.Tools:getLang(76331),
            function()
                doEvolve()
            end
        )
    else
        doEvolve()
    end
end

-- 点击进化信息按钮（点击英雄祭坛那个放大镜）
function HeroEvolutionLayer:onEvolutionInfo(tag, pSender)
    local data = pSender.data
    require("src.layer.heroevolution.HeroEvolutionInfoCtr"):instance():openWindow(data)
end
-- 点击进化描述按钮（那个感叹号按钮）
function HeroEvolutionLayer:onEvolutionExplain(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42096), ex.Tools:getLang(42097))
end
-- 点击进化树按钮
function HeroEvolutionLayer:onEvolutionTree()
    local data = self.select_seat.data
    require("src.layer.heroevolution.HeroEvolutionTreeCtr"):instance():openWindow(data)
end

function HeroEvolutionLayer:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function HeroEvolutionLayer:onSelectItem(tag, pSender)
    local index = pSender:getTag()
    local data = pSender.data
    local select_list = self.select_list[index]
    require("src.layer.heroevolution.HeroEvolutionSelectCtr"):instance():openWindow(index, data, select_list, true, false)
end

return HeroEvolutionLayer
