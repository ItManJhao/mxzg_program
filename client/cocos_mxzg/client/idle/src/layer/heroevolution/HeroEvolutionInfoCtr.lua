-- 英雄进化信息界面
local HeroEvolutionInfoCtr = class("HeroEvolutionInfoCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroEvolutionInfoLayer = class("HeroEvolutionInfoLayer", require("src.comp.EventLayerAdaptiveWidth"))

-----------------------------------------------------------------------------
function HeroEvolutionInfoLayer:onCreate()
    self:addBlackBackground()
    self:setAutoClose(true)
    self:setSwallowTouches(true)
end

function HeroEvolutionInfoLayer:updateLayer(data)
    local config = data.config or data

    self.lbl_evolution_name:setString(ex.Tools:getLang(config.evo_name))
    self.lbl_desc:setString(ex.Tools:getLang(config.evolve_desc))

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

    local view_size = cc.size(240, 100)
    local scroll_view = cc.ScrollView:create(view_size)
    scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    scroll_view:setPosition(129, 9)
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

    self:updateAttr(config.attr_show)
end

function HeroEvolutionInfoLayer:updateAttr(attr_list)
    if not attr_list or #attr_list == 0 then
        return
    end

    for k, v in pairs(attr_list) do
        local node = self[string.format("node_attr_%d", k)]
        if node then
            local attr_data = v
            local attr = attr_data.attr
            local value = attr_data.value
            local icon = self[string.format("spr_attr_icon_%d", k)]
            if icon then
                ex.Tools:setSpriteFrame(icon, (string.format("backpack-info/spr-attr-%d.png", cfg.attrshow.attrshow[attr].icon)))
            end

            local lbl_attr = self[string.format("lbl_attr_value_%d", k)]
            if lbl_attr then
                local attstr = string.format("+%s", ex.StringUtil.formatAttrNum(ex.Tools:getLang(2160000 + attr), value))
                lbl_attr:setString(attstr)
            end

            node:setVisible(true)
        end
    end
end

-----------------------------------------------------------------------------
function HeroEvolutionInfoCtr:onCreate()
    self:setCCBIPath("ccbi/HeroEvolutionInfoLayer.ccbi")

end

function HeroEvolutionInfoCtr:getLayerClass()
    return HeroEvolutionInfoLayer
end

function HeroEvolutionInfoCtr:openWindow(data)
    if self:isOpened() then
        return
    end

    self.data = data

    self:loadLayer()
    self:open()
    self:initData(data)
end

function HeroEvolutionInfoCtr:initData(data)
    self.layer:updateLayer(data)
end

return HeroEvolutionInfoCtr