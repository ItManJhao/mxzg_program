local CrusadeGroupBattleEndTownLoseCtr = class("CrusadeGroupBattleEndTownLoseCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local CrusadeGroupBattleEndTownLoseLayer = class("CrusadeGroupBattleEndTownLoseLayer", require("src.comp.EventLayerAdaptiveWidth"))

local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

-----------------------------------------------------------------------------
function CrusadeGroupBattleEndTownLoseLayer:onCreate()
    self:addBlackBackground()
    self:setAutoClose(true)
    self:setSwallowTouches(true)
end

function CrusadeGroupBattleEndTownLoseLayer:setRecoreryTime(time)
    self.node_tip:setVisible(time > 0)
    if time > 0 then
        self.lbl_tip:setString(string.format(ex.Tools:getLang(77429), ex.StringUtil.convertToTimeFormat(time, 4)))
    end
end

function CrusadeGroupBattleEndTownLoseLayer:setHeroList(vec_hero_list)
    self.menu_hero_list:removeAllChildren()

    local item_size = cc.Sprite:createWithSpriteFrameName("other/rare-0.png"):getContentSize()
    item_size = cc.size(item_size.width + 15, item_size.height + 12)
    local item_scale = 0.75
    local hero_num = #vec_hero_list
    for i,v in ipairs(vec_hero_list) do
        local item = UIMenuItemHero:createWithData("1", v.hero_type, nil, v.level, v.star)
        item:setScale(item_scale)
        item:registerScriptTapHandler(handler(self, self.onHeroInfo))
        item:setPosition((i - 0.5 - hero_num / 2) * (item_size.width * item_scale), 0)
        self.menu_hero_list:add(item)

        if v.hp <= 0 then
            item:setGray(false)

            local lbl_dead = cc.Label:createWithTTF(ex.Tools:getLang(72054), FONT_DEFAULT_NAME_BOLD, 32)
            lbl_dead:setScale(0.5)
            lbl_dead:setColor(cc.RED)
            lbl_dead:setPosition(item:getContentSize().width / 2, item:getContentSize().height / 2)
            item:addChild(lbl_dead, 20)
        end

        -- 显示血量
        local progress_bg = cc.Sprite:createWithSpriteFrameName("crusade-group/progress-bg-hp-1.png") or cc.Sprite:create()
        progress_bg:setPosition(item:getContentSize().width / 2, -20)
        item:addChild(progress_bg, 10)

        local progress_hp = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("crusade-group/progress-hp-1.png") or cc.Sprite:create())
        :setType(cc.PROGRESS_TIMER_TYPE_BAR)
        :setMidpoint(cc.p(0, 0.5))
        :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
        progress_hp:setPosition(progress_bg:getPosition())
        item:addChild(progress_hp, 20)

        progress_hp:setPercentage(v.hp * 100 / v.max_hp)

        -- local lbl_hp = cc.Label:createWithTTF(v.hp.."/"..v.max_hp, FONT_DEFAULT_NAME_BOLD, 24)
        -- lbl_hp:setScale(0.5)
        -- lbl_hp:setPosition(progress_bg:getPosition())
        -- item:addChild(lbl_hp, 30)
    end
end

function CrusadeGroupBattleEndTownLoseLayer:onHeroInfo(tag, pSender)
    
end

-----------------------------------------------------------------------------
function CrusadeGroupBattleEndTownLoseCtr:onCreate()
    self:setCCBIPath("ccbi/CrusadeGroupBattleEndTownLoseLayer.ccbi")
    self:setIsSingle(false)
end

function CrusadeGroupBattleEndTownLoseCtr:getLayerClass()
    return CrusadeGroupBattleEndTownLoseLayer
end

--[[
    {
        is_win,
        town_id,
        recover_time,
        vec_enermy,
        detail
    }
]]
function CrusadeGroupBattleEndTownLoseCtr:openWindow(data)
    if self:isOpened() then
        return
    end

    self.data = data

    self:loadLayer()
    self:open()
    self:initData()
end

function CrusadeGroupBattleEndTownLoseCtr:initData()
    self.layer.btn_report:registerScriptTapHandler(handler(self, self.onReport))

    self.layer.btn_back:registerScriptTapHandler(handler(self, self.onBack))
    self.layer.btn_continue:registerScriptTapHandler(handler(self, self.onContinue))

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/crusade-group.plist")

    self.layer:setRecoreryTime(self.data.recover_time ~= nil and (self.data.recover_time - ex.Game:getServerTime()) or 0)
    self.layer:setHeroList(self.data.vec_enermy)

    self.layer.btn_back:setVisible(not self.data.is_occupied)
    self.layer.btn_continue:setVisible(not self.data.is_occupied)
end

function CrusadeGroupBattleEndTownLoseCtr:onBack(tag, pSender)
    self:closeWindow()
end

function CrusadeGroupBattleEndTownLoseCtr:onContinue(tag, pSender)
    local area_level = cfg.crusadegrouptilelevel.getAreaLevel(self.data.town_id)
    local building_level = cfg.crusadegrouptilelevel.getBuildingLevel(self.data.town_id)
    local fight_type = cfg.crusadegrouptilelevel.getFightType(self.data.town_id)

    if fight_type == 1 then
        -- 访问地块城镇战斗信息界面，并显示攻击按钮
        require("src.layer.crusadegroup.CrusadeGroupTownBattleCtr"):instance():openWindow(self.data.town_id, area_level, building_level, true)
    else
        -- 查看boss
        local boss_layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_CRUSADE_GROUP_BOSS_LAYER)
        boss_layer:setCanAttack(true)
        boss_layer:setTileId(self.data.town_id)
    end

    self:closeWindow()
end

function CrusadeGroupBattleEndTownLoseCtr:onReport(tag, pSender)
    if not self.data or not self.data.detail then
        return
    end

    require("src.layer.BattleDetailCtr"):instance():openWindow(self.data.detail)
end

return CrusadeGroupBattleEndTownLoseCtr
