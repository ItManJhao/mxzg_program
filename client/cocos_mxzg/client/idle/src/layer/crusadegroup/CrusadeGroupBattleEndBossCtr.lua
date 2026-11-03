local CrusadeGroupBattleEndBossCtr = class("CrusadeGroupBattleEndBossCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local CrusadeGroupBattleEndBossLayer = class("CrusadeGroupBattleEndBossLayer", require("src.comp.EventLayerAdaptiveWidth"))

-----------------------------------------------------------------------------
function CrusadeGroupBattleEndBossLayer:onCreate()
    self:addBlackBackground()
    self:setAutoClose(true)
    self:setSwallowTouches(true)

    self.progress_hp = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("crusade-group/progress-hp-2.png") or cc.Sprite:create())
    self.progress_hp:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.progress_hp:setMidpoint(cc.p(0, 0.5))
    self.progress_hp:setAnchorPoint(ex.a.center)
    self.progress_hp:setBarChangeRate(cc.p(1, 0))
    self.node_hp:addChild(self.progress_hp)
    self.progress_hp:setPosition(ex.p.zero)
    self.progress_hp:setPercentage(0)

    self.spr_hp:setLocalZOrder(20)
    self.lbl_hp_left:setLocalZOrder(30)
end

function CrusadeGroupBattleEndBossLayer:setHp(cur_hp, total_hp)
    self.progress_hp:setPercentage(cur_hp / total_hp * 100)
    self.lbl_hp_left:setString(cur_hp.."/"..total_hp)
end

function CrusadeGroupBattleEndBossLayer:setDamage(cur_damage, total_damage)
    self.lbl_damage_cur:setString(cur_damage)
    self.lbl_damage_total:setString(total_damage)
end

-----------------------------------------------------------------------------
function CrusadeGroupBattleEndBossCtr:onCreate()
    self:setCCBIPath("ccbi/CrusadeGroupBattleEndBossLayer.ccbi")
    self:setIsSingle(false)
end

function CrusadeGroupBattleEndBossCtr:getLayerClass()
    return CrusadeGroupBattleEndBossLayer
end

--[[
    {
        town_id,
        cur_hp,
        total_hp,
        cur_damage,
        total_damage,
        detail
    }
]]
function CrusadeGroupBattleEndBossCtr:openWindow(data)
    if self:isOpened() then
        return
    end

    self.data = data

    self:loadLayer()
    self:open()
    self:initData(data)
end

function CrusadeGroupBattleEndBossCtr:initData()
    self.layer.btn_report:registerScriptTapHandler(handler(self, self.onReport))

    self.layer.btn_back:registerScriptTapHandler(handler(self, self.onBack))
    self.layer.btn_continue:registerScriptTapHandler(handler(self, self.onContinue))

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/crusade-group.plist")

    self:updateLayer()
end

function CrusadeGroupBattleEndBossCtr:updateLayer(data)
    self.layer:setHp(self.data.cur_hp, self.data.total_hp)
    self.layer:setDamage(self.data.cur_damage, self.data.total_damage)
end

function CrusadeGroupBattleEndBossCtr:onReport(tag, pSender)
    if not self.data or not self.data.detail then
        return
    end

    require("src.layer.BattleDetailCtr"):instance():openWindow(self.data.detail)
end

function CrusadeGroupBattleEndBossCtr:onBack(tag, pSender)
    self:closeWindow()
end

function CrusadeGroupBattleEndBossCtr:onContinue(tag, pSender)
    -- 查看boss
    local boss_layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_CRUSADE_GROUP_BOSS_LAYER)
    boss_layer:setCanAttack(true)
    boss_layer:setTileId(self.data.town_id)

    self:closeWindow()
end

return CrusadeGroupBattleEndBossCtr
