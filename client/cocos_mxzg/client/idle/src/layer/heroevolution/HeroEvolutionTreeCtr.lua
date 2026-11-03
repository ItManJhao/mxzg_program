-- 英雄进化树界面
local HeroEvolutionTreeCtr = class("HeroEvolutionTreeCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroEvolutionTreeLayer = class("HeroEvolutionTreeLayer", require("src.comp.EventLayerAdaptiveWidth"))

-----------------------------------------------------------------------------
function HeroEvolutionTreeLayer:onCreate()
    self:addBlackBackground()
    self:setAutoClose(true)
    self:setSwallowTouches(true)

    self.node_top:setZOrder(101)
    self.node_1_1:setZOrder(101)
    self.node_1_2:setZOrder(101)
    self.node_1_3:setZOrder(101)
    self.node_2_1:setZOrder(101)
    self.node_2_2:setZOrder(101)
    self.node_2_3:setZOrder(101)
end

function HeroEvolutionTreeLayer:updateLayer(data, list)
    if not data or not data.config or not list or #list == 0 then
        return
    end

    local config = cfg.herotype.star[data.config.hero_type]
    if config then
        local icon_str = string.format("hero-icon/%d.png", config.item_id)
        self.spr_hero_icon:setSpriteFrame(icon_str)
        self.spr_hero_icon:setVisible(true)
    end

    local evolve_level = data.config.level or 1
    local evolve_type = data.config.evolve_type or 1

    for k, v in ipairs(list) do
        local level = v.level
        local type = v.evolve_type

        local node_icon = self[string.format("node_%s_%s", type, level)]
        local hero_icon = self[string.format("spr_hero_icon_%s_%s", type, level)]
        local spr_glow = self[string.format("spr_glow_%s_%s", type, level)]
        local spr_question = self[string.format("spr_question_%s_%s", type, level)]
        local line = self[string.format("spr_line_%s_%s", type, level)]
        node_icon.config = data.config

        if evolve_level < level then
            spr_question:setVisible(true)
            ex.Tools:setGray(line)
        elseif evolve_level >= level then
            if type == evolve_type then
                if evolve_level == level then
                    spr_glow:setVisible(true)
                end

                local icon_str = string.format("hero-icon/%d.png", v.evolve_icon_id)
                hero_icon:setSpriteFrame(icon_str)
                hero_icon:setVisible(true)
                line:setZOrder(100)
            else
                spr_question:setVisible(true)
                ex.Tools:setGray(line)
            end
        end

        node_icon.listener = cc.EventListenerTouchOneByOne:create()
        node_icon.listener:setSwallowTouches(true)
        node_icon.listener:registerScriptHandler(function(touch, event) 
            local touchLocation = touch:getLocation()
            touchLocation = node_icon:getParent():convertToNodeSpace(touchLocation)
            local bBox = node_icon:getBoundingBox()
            if cpp.Game:isInVisible(node_icon) and cc.rectContainsPoint(bBox, touchLocation) then
                local evolve_config = cfg.heroevolvelevel.getEvolutionConfig(data.config.hero_type, level, type)
                require("src.layer.heroevolution.HeroEvolutionInfoCtr"):instance():openWindow({config = evolve_config})
                return true
            else
                return false
            end
        end, cc.Handler.EVENT_TOUCH_BEGAN)
        local event_dispatcher = node_icon:getEventDispatcher()
        event_dispatcher:addEventListenerWithSceneGraphPriority(node_icon.listener, node_icon)
    end
end
-----------------------------------------------------------------------------
function HeroEvolutionTreeCtr:onCreate()
    self:setCCBIPath("ccbi/HeroEvolutionTreeLayer.ccbi")

end

function HeroEvolutionTreeCtr:getLayerClass()
    return HeroEvolutionTreeLayer
end

function HeroEvolutionTreeCtr:openWindow(data)
    if self:isOpened() then
        return
    end

    self.data = data

    self:loadLayer()
    self:open()
    self:initData(data)
end

function HeroEvolutionTreeCtr:initData(data)
    local config_list = cfg.heroevolvelevel.getEvolutionListByHeroType(data.hero_data.hero_type)
    self.layer:updateLayer(data, config_list)
end

return HeroEvolutionTreeCtr