-- 英雄进化成功界面
local HeroEvolutionSuccessCtr = class("HeroEvolutionSuccessCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroEvolutionSuccessLayer = class("HeroEvolutionSuccessLayer", require("src.comp.EventLayerAdaptiveWidth"))
local HeroEvolutionAttrCell = class("HeroEvolutionAttrCell", require("src.comp.LuaLayerBase"))

-------------------------------------STMagicTowerRankCell-------------------------------------
function HeroEvolutionAttrCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:setIgnoreAnchorPointForPosition(false)
    self:setAnchorPoint(0, 0.5)
end

function HeroEvolutionAttrCell:reset(data)
    if not data then
        return
    end

    self.data = data
    local old_value = data.old_value or 0
    local new_value = data.new_value or 0

    local pre_str = ex.Tools:getAttrText(data.attr_type, old_value)
    local cur_str = ex.StringUtil.formatAttrNum(ex.Tools:getLang(2160000 + data.attr_type), new_value)
    self.lbl_attr_pre:setString(pre_str)
    self.lbl_attr_cur_value:setString(cur_str)
end


-----------------------------------------------------------------------------
function HeroEvolutionSuccessLayer:onCreate()
    self:addBlackBackground()
    self:setAutoClose(true)
    self:setSwallowTouches(true)
end

function HeroEvolutionSuccessLayer:updateLayer(data)
    local hero_data = data.hero_data
    local attr_update = data.attr_update
    local config = cfg.heroevolvelevel.getEvolutionConfig(hero_data.hero_type, hero_data.evolve.level, hero_data.evolve.type)
    self.animator = require("src.person.Hero"):create("1", "1", 1, 1, ex.Tools:getHeroSkinByImageId(config.evolve_fashion_id))
    self.animator:setAnimation(0, "stand", true)
    self.animator:setScale(1.5)
    self.animator:setAnchorPoint(cc.p(0.5, 0))
    self.animator:setPosition(cc.p(0, 0))
    self.animator:setShadowVisible(false)
    self.node_hero:addChild(self.animator, 10)

    self.lbl_hero_name:setString(ex.Tools:getLang(config.evo_name))

    self.spr_skill_icon_bg = cc.Sprite:createWithSpriteFrameName("evolution/spr-skill-bg.png")
    self.spr_skill_icon_bg:setPosition(cc.p(0, 0))
    self.node_skill:addChild(self.spr_skill_icon_bg)
    self.spr_skill_icon = cc.Sprite:createWithSpriteFrameName(string.format("skill-icon/%d.png", config.skill_id))
    self.spr_skill_icon:setPosition(cc.p(0, 0))
    self.node_skill:addChild(self.spr_skill_icon)

    local skill_config = cfg.heroskill.getConfigByType(config.skill_id, config.skill_level)
    self.lpl_skill_name:setString(ex.Tools:getLang(skill_config.lan_name))
    local desc = ex.Tools:getLang(skill_config.lan_describe)
    if ex.Tools:getLang(skill_config.lan_describe) == "" then
        desc = ex.Tools:getLang(5702) .. ex.Tools:getLang(5663)
    end

    local view_size = cc.size(219, 130)
    local scroll_view = cc.ScrollView:create(view_size)
    scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    scroll_view:setPosition(375, 52)
    self:addChild(scroll_view)
    local lbl_desc = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 18)
		:setTextColor(cc.c3b(161,129,89))
        :setAnchorPoint(cc.p(0, 1))
        :setDimensions(view_size.width, 0)
    lbl_desc:setString(desc)
	scroll_view:addChild(lbl_desc)
    local lbl_size = lbl_desc:getContentSize()
    if lbl_size.height > view_size.height then
        scroll_view:setContentSize(cc.size(view_size.width, lbl_size.height))
        lbl_desc:setPositionY(lbl_size.height)
        scroll_view:setContentOffset(cc.p(0, view_size.height - lbl_size.height))
    else
        scroll_view:setContentSize(cc.size(view_size.width, view_size.height))
        lbl_desc:setPositionY(view_size.height)
    end

    self:updateAttr(attr_update)
end

function HeroEvolutionSuccessLayer:updateAttr(attr_update)
    local start_x = 284
    local start_y = 356
    if attr_update and #attr_update > 0 then
        for k, v in ipairs(attr_update) do
            local cell = HeroEvolutionAttrCell:createWithCCBIFile("ccbi/HeroEvolutionAttrCell.ccbi")
            cell:reset(v)
            cell:setPosition(start_x, start_y + (k - 1) * cell:getContentSize().height)
            self:addChild(cell)
        end
    end
end
-----------------------------------------------------------------------------
function HeroEvolutionSuccessCtr:onCreate()
    self:setCCBIPath("ccbi/HeroEvolutionSuccessLayer.ccbi")
end

function HeroEvolutionSuccessCtr:getLayerClass()
    return HeroEvolutionSuccessLayer
end

function HeroEvolutionSuccessCtr:openWindow(data)
    if self:isOpened() then
        return
    end

    self.data = data

    self:loadLayer()
    self:open()
    self:initData(data)
end

function HeroEvolutionSuccessCtr:initData(data)
    self.layer:updateLayer(data)
end

return HeroEvolutionSuccessCtr