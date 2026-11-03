local DungeonStageEndCtr = class("DungeonStageEndCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local DungeonStageEndLayer = class("DungeonStageEndLayer", require("src.comp.EventLayer"))

local DungeonStageEndCell = class("DungeonStageEndCell", require("src.comp.LuaLayerBase"))

function DungeonStageEndCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.lbl_num:enableOutline(FONT_BROWN_C4B)
end

function DungeonStageEndCell:reset(data)
    self.spr_res:setSpriteFrame("backpack/"..data.item_type..".png")
    self.lbl_name:setString(ex.Tools:getLang(cfg.item.item[data.item_type].name))
    self.lbl_num:setString(tostring(data.item_num))
end

function DungeonStageEndLayer:onCreate()
    self:addBlackBackground()

    self.table_view = nil
    
    -- 添加按钮特效
    local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_dungeon_stage_end")
    self.spr_title:addChild(spr_effect, 10)
    local item_size = self.spr_title:getContentSize()
    spr_effect:setPosition(cc.p(item_size.width / 2 + 13, item_size.height / 2 - 20))
end

-----------------------------------------------------------------------------
function DungeonStageEndCtr:onCreate()
    self:setCCBIPath("ccbi/DungeonStageEndLayer.ccbi")
    self:setIsSingle(false)
end

function DungeonStageEndCtr:getLayerClass()
    return DungeonStageEndLayer
end

function DungeonStageEndCtr:getDungeonStageEndLayer()
    return self.layer
end

function DungeonStageEndCtr:openWindow(vec_reward)
    if self:isOpened() then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/reward-layer.plist")

    self:loadLayer()
    self:open()
    self:initData(vec_reward)
end

function DungeonStageEndCtr:initData(vec_reward)
    self.vec_reward = vec_reward

    self:updateTableView()
end

function DungeonStageEndCtr:updateTableView()
    if self.layer.table_view ~= nil then
        self.layer.table_view:removeFromParent()
        self.layer.table_view = nil
    end

    if self.vec_reward == nil or table.nums(self.vec_reward) <= 0 then
        local lbl_tip = cc.Label:createWithTTF(ex.Tools:getLang(47296), FONT_DEFAULT_NAME_BOLD, 36)
        lbl_tip:setColor(FONT_LIGHT_YELLOW)
        lbl_tip:setScale(0.5)
        lbl_tip:setPosition(self.layer:getContentSize().width / 2, self.layer:getContentSize().height / 2)
        self.layer:addChild(lbl_tip)
        
        return
    end

    -- 初始化tableview
    local view_size = cc.size(510, 320)
    local pos = cc.p(65, 30)
    self.layer.table_view = ex.Tools:initTableView(self.layer, self.vec_reward, {DungeonStageEndCell, "ccbi/DungeonStageEndCell.ccbi"}, view_size, 5, pos)
end

return DungeonStageEndCtr
