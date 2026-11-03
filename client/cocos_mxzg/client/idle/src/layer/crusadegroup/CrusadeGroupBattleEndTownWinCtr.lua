local CrusadeGroupBattleEndTownWinCtr = class("CrusadeGroupBattleEndTownWinCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local CrusadeGroupBattleEndTownWinLayer = class("CrusadeGroupBattleEndTownWinLayer", require("src.comp.EventLayerAdaptiveWidth"))

local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

-----------------------------------------------------------------------------
function CrusadeGroupBattleEndTownWinLayer:onCreate()
    self:addBlackBackground()
    self:setAutoClose(true)
    self:setSwallowTouches(true)

    -- 体力提示
    self.lbl_tip = require("src.comp.RichTextEx"):create()
	:setFontSize(44)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#FFDF91")
    :setScale(0.5)
    :setAnchorPoint(0.5, 0.5)
	:setAnchorTextShadow(true)
	:setWrapMode(1)
    :setPosition(0, 0)
    self.node_tip:addChild(self.lbl_tip)
end

function CrusadeGroupBattleEndTownWinLayer:setStarResult(vec_result)
    local star_num = 0
    for i,v in ipairs(vec_result) do
        if self["spr_addition_"..i] ~= nil then
            if v == 1 then
                ex.Tools:setSpriteFrame(self["spr_addition_"..i], "other/star-0.png")
                self["lbl_addition_"..i]:setColor(cc.c3b(33,255,71))
                star_num = star_num + 1
            else
                ex.Tools:setSpriteFrame(self["spr_addition_"..i], "other/star-bg.png")
                self["lbl_addition_"..i]:setColor(cc.c3b(159,155,145))
            end
        end
    end

    local energy_get = ex.Tools:getSysCfg("star_recovery_physical")
    self.lbl_tip:setXmlTextLua(string.format(ex.Tools:getLang(77729), star_num, energy_get[star_num]))
end

function CrusadeGroupBattleEndTownWinLayer:setHeroList(vec_hero_list, star)
    self.menu_hero_list:removeAllChildren()

    local energy_get = ex.Tools:getSysCfg("star_recovery_physical")
    energy_get = energy_get[star]
    
    local item_size = cc.Sprite:createWithSpriteFrameName("other/rare-0.png"):getContentSize()
    item_size = cc.size(item_size.width + 15, item_size.height + 12)
    local item_scale = 0.75
    local hero_num = #vec_hero_list
    for i,v in ipairs(vec_hero_list) do
        local item = UIMenuItemHero:createWithData(v.hero_id, v.hero_type, nil, v.level, v.star)
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

        -- 显示体力
        local spr_energy = cc.Sprite:createWithSpriteFrameName("crusade-group/spr-energy.png") or cc.Sprite:create()
        spr_energy:setPosition(20, -20)
        item:addChild(spr_energy, 10)

        local lbl_energy = cc.Label:createWithTTF("+"..energy_get, FONT_DEFAULT_NAME_BOLD, 32)
        lbl_energy:setPosition(item:getContentSize().width - 30, -20)
        item:addChild(lbl_energy, 20)
    end
end

function CrusadeGroupBattleEndTownWinLayer:setRound(cur_round, total_round)
    self.node_round:removeAllChildren()

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/crusade-group.plist")

    for i=1,total_round do
        local spr_bg = cc.Sprite:createWithSpriteFrameName("crusade-group/spr-stat.png")
        spr_bg:setPosition((i - 0.5 - total_round / 2) * 60, 0)
        self.node_round:addChild(spr_bg)

        if i <= cur_round then
            local spr_yes = cc.Sprite:createWithSpriteFrameName("crusade-group/spr-yes.png")
            spr_yes:setPosition(spr_bg:getContentSize().width / 2, spr_bg:getContentSize().height / 2)
            spr_bg:addChild(spr_yes)
        else
            local lbl_round = cc.Label:createWithTTF(i, FONT_DEFAULT_NAME_BOLD, 36)
            lbl_round:setColor(FONT_LIGHT_YELLOW)
            lbl_round:setScale(0.5)
            lbl_round:setPosition(spr_bg:getContentSize().width / 2, spr_bg:getContentSize().height / 2)
            spr_bg:addChild(lbl_round)
        end
    end
end

function CrusadeGroupBattleEndTownWinLayer:onHeroInfo(tag, pSender)
    
end

-----------------------------------------------------------------------------
function CrusadeGroupBattleEndTownWinCtr:onCreate()
    self:setCCBIPath("ccbi/CrusadeGroupBattleEndTownWinLayer.ccbi")
    self:setIsSingle(false)
end

function CrusadeGroupBattleEndTownWinCtr:getLayerClass()
    return CrusadeGroupBattleEndTownWinLayer
end

--[[
    {
        is_win,
        town_id,
        vec_addition_result,
        vec_self,
        cur_round,
        total_round,
        is_occupied,
        detail
    }
]]
function CrusadeGroupBattleEndTownWinCtr:openWindow(data)
    if self:isOpened() then
        return
    end

    self.data = data

    self:loadLayer()
    self:open()
    self:initData()
end

function CrusadeGroupBattleEndTownWinCtr:initData()
    self.layer.btn_report:registerScriptTapHandler(handler(self, self.onReport))

    self.layer.btn_back:registerScriptTapHandler(handler(self, self.onBack))
    self.layer.btn_continue:registerScriptTapHandler(handler(self, self.onContinue))
    self.layer.btn_occupy:registerScriptTapHandler(handler(self, self.onOccupy))

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/crusade-group.plist")

    self.layer:setStarResult(self.data.vec_addition_result)

    local star_num = 0
    for i,v in ipairs(self.data.vec_addition_result) do
        if v == 1 then
            star_num = star_num + 1
        end
    end
    self.layer:setHeroList(self.data.vec_self, star_num)

    local fight_type = cfg.crusadegrouptilelevel.getFightType(self.data.town_id)
    if fight_type == 1 then
        self.layer:setRound(self.data.cur_round, self.data.total_round)
    end

    self.layer.btn_back:setVisible(not self.data.is_occupied)
    self.layer.btn_continue:setVisible(not self.data.is_occupied)
    self.layer.btn_occupy:setVisible(self.data.is_occupied)
end

function CrusadeGroupBattleEndTownWinCtr:onBack(tag, pSender)
    self:closeWindow()
end

function CrusadeGroupBattleEndTownWinCtr:onContinue(tag, pSender)
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

function CrusadeGroupBattleEndTownWinCtr:onOccupy(tag, pSender)
    ex.EventManager:fire(EVENT.CRUSADE_GROUP.RUN_OCCUPY_EFFECT, self.data.town_id)
    self:closeWindow()
end

function CrusadeGroupBattleEndTownWinCtr:onReport(tag, pSender)
    if not self.data or not self.data.detail then
        return
    end

    require("src.layer.BattleDetailCtr"):instance():openWindow(self.data.detail)
end

return CrusadeGroupBattleEndTownWinCtr
