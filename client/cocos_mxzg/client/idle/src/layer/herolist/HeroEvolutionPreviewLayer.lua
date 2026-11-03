-- 英雄进化界面
local HeroEvolutionPreviewLayer = class("HeroEvolutionPreviewLayer", require("src.comp.EventLayerAdaptiveWidthFull"))
local HeroEvolutionSeat = class("HeroEvolutionSeat", require("src.comp.EventLayer"))
local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")
local UIMenuItemSkill = require("src.comp.menu.UIMenuItemSkill")

-------------------------------------HeroEvolutionSeat-------------------------------------
function HeroEvolutionSeat:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.data = {}
end

function HeroEvolutionSeat:resetData(data)
    self.data = data

    self.node_animator:removeAllChildren()

    if not self.lbl_name then
        self.lbl_name = require("src.comp.RichTextEx"):create()
            :setFontSize(44)
            :setFontFace(FONT_DEFAULT_NAME_BOLD)
            :setScale(0.5)
            :setAnchorTextShadow(true)
            :setWrapMode(1)
            :setAnchorPoint(0.5, 0.5)
            :setPosition(
                self.btn_info:getContentSize().width / 2,
                self.btn_info:getContentSize().height / 2
            )
        self.btn_info:addChild(self.lbl_name)
    end
    
    self.btn_info.data = data

    -- 进化祭台选择光效
    self.spr_glow_effect = ex.EffectFactory:createEffectWithNodeByName("eff_evolution_glow")
    self.spr_glow_effect:setAnchorPoint(cc.p(0.5, 0))
    self.spr_glow_effect:setPosition(0, -80)
    self.spr_glow_effect:setVisible(false)
    self.node_animator:addChild(self.spr_glow_effect, 11)

    if data then
        self.animator = require("src.person.Hero"):create("1", "1", 1, 1, ex.Tools:getHeroSkinByImageId(data.evolve_fashion_id))
        self.animator:setAnimation(0, "stand", true)
        self.animator:setScale(1.5)
        self.animator:setAnchorPoint(cc.p(0.5, 0))
        self.animator:setPosition(cc.p(0, 0))
        self.animator:setShadowVisible(false)
        self.node_animator:addChild(self.animator, 10)

        local str = string.format("<img src='evolution/spr-magnifier.png' width='57.2' height='75.4' /><font color='#FFE3B7'>%s</font>", ex.Tools:getLang(data.evo_name))
        self.lbl_name:setXmlTextLua(str)
        self.lbl_name:formatText()

        self.lbl_evolution_lv:setString("+" .. data.level)
        self.node_evolve_level:setVisible(true)
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

-------------------------------------HeroEvolutionPreviewLayer-------------------------------------
function HeroEvolutionPreviewLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(true)
    self:initPlist()

    self.node_top:setZOrder(100)
    self.node_bottom:setZOrder(100)
    local pos_y = ex.p.height - 100 * ex.s.global_scale - require("src.model.Game"):instance():getNotchHeight()
    self.node_top:setPositionY(pos_y)
    self.node_bottom:setPositionY(ex.MainSceneCtr:getBottomHeight())
    self.node_btn:setPositionY(self.node_bottom:getPositionY() + self.node_bottom:getContentSize().height + 70)
    self.node_evolution:setPositionY(self.node_bottom:getPositionY() + self.node_bottom:getContentSize().height - 50)
    self.spr_bg:setContentSize(self:getContentSize())
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
    self.node_evolve_name:addChild(self.lpl_skill_name)

    self.lbl_max_tips:setString(ex.Tools:getLang(76345))

    self.btn_left:registerScriptTapHandler(handler(self, self.onLeft))
	self.btn_right:registerScriptTapHandler(handler(self, self.onRight))
end

-- 初始化plist
function HeroEvolutionPreviewLayer:initPlist()
    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-base/evolution.plist")
    sfc:addSpriteFrames("ccbi-base/evolution-lang.plist")
end

function HeroEvolutionPreviewLayer:initView(data, idx)
    if not data or #data == 0 then
        return
    end

    self.illustrat_data = data
    self.idx = idx

    local hero_data = self:getHeroDataByIdx(idx)
    self:updateLayer(hero_data)
end

function HeroEvolutionPreviewLayer:updateLayer(data)
    if not data or not data.hero_type then
        return
    end

    self.data = data
    local hero_type = data.hero_type

    self.hero_data = cfg.herotype.star[hero_type]
    self.icon_occupat:setSpriteFrame("hero-info/icon-occup-" .. self.hero_data.occupation .. ".png")
    self.lbl_profession:setString(ex.Tools:getLang(47304)..ex.Tools:getLang(111000 + self.hero_data.occupation))
    local maxLevel = data.level
	local str = string.format("%s/%s",maxLevel,maxLevel)
	self.lbl_level:setString(str)
    self.lbl_level:setPositionX(self.lbl_level_title:getPositionX() + self.lbl_level_title:getContentSize().width)
    self.lbl_hero_name:setString(ex.Tools:getLang(hero_type))
    self.icon_elem:setSpriteFrame("hero-icon/elem-" .. self.hero_data.elem .. ".png")
	self.icon_elem:setPositionX(self.lbl_hero_name:getPositionX() - self.lbl_hero_name:getContentSize().width / 2 - 20)

    local evolution_list = cfg.heroevolvelevel.getEvolutionListByHeroType(hero_type)
    if not evolution_list or #evolution_list <= 1 then
        return
    end

    local left_data
    local right_data
    for k, v in ipairs(evolution_list) do
        if v.evolve_type == 1 then
            if not left_data or v.level > left_data.level then
                left_data = clone(v)
            end
        else
            if not right_data or v.level > right_data.level then
                right_data = clone(v)
            end
        end
    end

    if not self.seat_left then
        self.seat_left = self:createSeat(left_data)
        self.seat_left:setPosition(self.node_evolution:getContentSize().width / 2 - self.seat_left:getContentSize().width - 48, 50)
        self.node_evolution:addChild(self.seat_left)
    else
        self.seat_left:resetData(left_data)
        self.seat_left:setVisible(true)
    end

    self.select_seat = self.seat_left
    self.seat_left:setSelected(true)

    if not self.seat_right then
        self.seat_right = self:createSeat(right_data)
        self.seat_right:setPosition(self.node_evolution:getContentSize().width / 2 + 48, 50)
        self.node_evolution:addChild(self.seat_right)
    else
        self.seat_right:resetData(right_data)
        self.seat_right:setVisible(true)
    end

    self:updateLeftRight()
    self:updateGradeInfo()
    self:updateAttr()
    self:updateSkill()
end
-- 创建英雄祭台
function HeroEvolutionPreviewLayer:createSeat(data)
    local seat = HeroEvolutionSeat:createWithCCBIFile("ccbi/HeroEvolutionSeat.ccbi")
    seat:resetData(data)

    seat.listener = cc.EventListenerTouchOneByOne:create() --创建一个单点事件监听
    seat.listener:setSwallowTouches(true)
    seat.listener:registerScriptHandler(
        function(touch, event)
            local touchLocation = touch:getLocation()
            touchLocation = seat:getParent():convertToNodeSpace(touchLocation)
            local bBox = seat:getBoundingBox()
            if cpp.Game:isInVisible(seat) and cc.rectContainsPoint(bBox, touchLocation) then
                self:onSelect(seat)
                return true
            else
                return false
            end
        end,
        cc.Handler.EVENT_TOUCH_BEGAN
    )
    local event_dispatcher = seat:getEventDispatcher()
    event_dispatcher:addEventListenerWithSceneGraphPriority(seat.listener, seat)
    seat.btn_info:registerScriptTapHandler(handler(self, self.onEvolutionInfo))

    return seat
end

-- 更新左右按钮
function HeroEvolutionPreviewLayer:updateLeftRight()
    if #self.illustrat_data == 1 then
        self.btn_left:setVisible(false)
        self.btn_right:setVisible(false)
    elseif self.idx == 1 then
        self.btn_left:setVisible(false)
        self.btn_right:setVisible(true)
    elseif self.idx == #self.illustrat_data then
        self.btn_left:setVisible(true)
        self.btn_right:setVisible(false)
    else
        self.btn_left:setVisible(true)
        self.btn_right:setVisible(true)
    end
end

-- 更新进化的属性UI
function HeroEvolutionPreviewLayer:updateAttr()
    local config = self.select_seat.data

    local maxStar = self.data.star
    local level = self.data.level
    local stage = math.min(maxStar, self:getMaxStage())
    local evolve = {
        type = config.evolve_type,
        level = config.level
    }
    local attribute = ex.Player.hero_data:getHeroAttribute(config.hero_type, stage, maxStar, level, evolve)
    self.lbl_attack:setString(ex.Tools:getAttrText(220, math.floor(attribute.atk)))
	self.lbl_hp:setString(ex.Tools:getAttrText(223, math.floor(attribute.hp)))
	self.lbl_defense:setString(ex.Tools:getAttrText(224, math.floor(attribute.def)))
	self.lbl_speed:setString(ex.Tools:getAttrText(101, math.floor(attribute.spd)))
end
-- 更新进化的技能UI
function HeroEvolutionPreviewLayer:updateSkill()
    local hero_type = self.select_seat.data.hero_type
    local hero_conf = cfg.herotype.star[hero_type]
    local evolve_level = self.select_seat.data.level
    local skill_id = self.select_seat.data.skill_id
    local skill_level = self.select_seat.data.skill_level
    local skill_old_id = self.select_seat.data.skill_old_id
    local skill_old_level = self:getOldSkillLevel(skill_old_id, hero_type, self.data.star)

    self.menu_pre_skill:removeAllChildren()
    local btn_old_skill = UIMenuItemSkill:createWithIcon(skill_old_id, skill_old_level, false, handler(self, self.onSkillInfo))
    btn_old_skill:resetLblName()
    self.menu_pre_skill:addChild(btn_old_skill)

    self.menu_next_skill:removeAllChildren()
    local btn_skill = UIMenuItemSkill:createWithIcon(skill_id, skill_level, true, handler(self, self.onSkillInfo))
    btn_skill:resetLblName()
    self.menu_next_skill:addChild(btn_skill)

    local skill_config = cfg.heroskill.getConfigByType(skill_id, skill_level)
    local str = string.format("<font color='#875F33'>%s</font><font color='#EC50FF'>%s</font><outline color='#000000'size='2'><font color='#00FFFF'>+%s</font></outline><font color='#EC50FF'>%s</font>", ex.Tools:getLang(skill_config.lan_name), "【"..ex.Tools:getLang(76344), evolve_level, "】")
    self.lpl_skill_name:setXmlTextLua(str)
    self.lpl_skill_name:formatText()
    local desc = ex.Tools:getLang(skill_config.lan_describe)
    if ex.Tools:getLang(skill_config.lan_describe) == "" then
        desc = ex.Tools:getLang(5702) .. ex.Tools:getLang(5663)
    end
    
    if not self.skill_desc_scroll_view then
        local view_size = cc.size(562, 96)
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

function HeroEvolutionPreviewLayer:getOldSkillLevel(skill_id, hero_type, star)
    local hero_type_config = cfg.herotype.star[hero_type]
    if not hero_type_config then
        return 0
    end

    local index = 1;
    for i = 1, 4 do
        if hero_type_config["skill_"..i] == skill_id then
            index = i
            break
        end
    end

    local skill_level = 1
    local star_config = cfg.herostar.star[star]
    if star_config then
        skill_level = star_config["skill"..index]
    end
    
    return skill_level
end

function HeroEvolutionPreviewLayer:updateGradeInfo()
    if not self.gradeArr then
        self.gradeArr = {}
        for i = 1, 6 do
            self.gradeArr[i] = self["sp_grade" .. i]
        end
    end

    local maxStar = self.data.star
    local stage = math.min(maxStar, self:getMaxStage())
    for k, v in pairs(self.gradeArr) do
        v:setVisible(k <= maxStar)
        local path = stage >= k and "hero-info/spr-quality-2.png" or "hero-info/spr-quality-1.png"
        v:initWithSpriteFrameName(path)
    end
end

function HeroEvolutionPreviewLayer:getMaxStage()
	local max = 0
	for i,v in ipairs(cfg.heroupgrade.grade) do
		if i > max then max = i end
	end
	return max
end

function HeroEvolutionPreviewLayer:getHeroDataByIdx(idx)
    local hero_data
    for k, v in ipairs(self.illustrat_data) do
        if v.idx == idx then
            hero_data = v
            break
        end
    end

    return hero_data
end


-- 返回按钮事件
function HeroEvolutionPreviewLayer:onBack(tag, pSender)
    if not ex.MainSceneCtr:backLastLayer() then
        local layer = ex.MainSceneCtr:changeLayer(MainSceneType.HERO_LAYER)
        layer:changeLayer(2)
    end  
end

-- 选中祭台按钮事件
function HeroEvolutionPreviewLayer:onSelect(pSender)
    local data = pSender.data
    local evolve_type = self.select_seat.data.evolve_type
    if self.select_seat and self.select_seat.data.evolve_type == data.evolve_type then
        return
    end

    self.select_seat:setSelected(false)
    pSender:setSelected(true)
    self.select_seat = pSender

    self:updateAttr()
    self:updateSkill()
end

-- 点击进化信息按钮（点击英雄祭坛那个放大镜）
function HeroEvolutionPreviewLayer:onEvolutionInfo(tag, pSender)
    local data = pSender.data
    require("src.layer.heroevolution.HeroEvolutionInfoCtr"):instance():openWindow(data)
end
-- 点击进化描述按钮（那个感叹号按钮）
function HeroEvolutionPreviewLayer:onEvolutionExplain(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42096), ex.Tools:getLang(42097))
end

function HeroEvolutionPreviewLayer:onSkillInfo(tag, pSender)
    local ctr = require("src.layer.HeroSkillInfoCtr"):instance()
	ctr:openWindow(pSender.skill_type, pSender.skill_level)
	ctr.layer:setLocalZOrder(1000001)
end

function HeroEvolutionPreviewLayer:onLeft(tag, pSender)
    if self.is_updating then
        return
    end

    self.is_updating = true
    local hero_data = self:getHeroDataByIdx(self.idx - 1)
    if hero_data then
        self.idx = self.idx - 1
    end
    self:updateLayer(hero_data)
    self.is_updating = false
end

function HeroEvolutionPreviewLayer:onRight(tag, pSender)
    if self.is_updating then
        return
    end
    
    self.is_updating = true
    local hero_data = self:getHeroDataByIdx(self.idx + 1)
    if hero_data then
        self.idx = self.idx + 1
    end
    self:updateLayer(hero_data)
    self.is_updating = false
end


return HeroEvolutionPreviewLayer
