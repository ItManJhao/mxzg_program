local SuperStageRewardCtr = class("SuperStageRewardCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local SuperStageRewardLayer = class("SuperStageRewardLayer", require("src.comp.EventLayerAdaptiveWidth"))

local SuperStageRewardCell = class("SuperStageRewardCell", require("src.comp.LuaLayerBase"))

local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function SuperStageRewardCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.scroll_view = cpp.UIScrollViewZoom:create(cc.size(320, 120))
    :setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    :setBounceable(true)
    :setIgnoreAnchorPointForPosition(false)
    :setAnchorPoint(0, 0.5)
    :setPosition(200, 68)
    :setSwallowsTouches(false)
    self:addChild(self.scroll_view)

    self.menu = cpp.UIMenu:create()
    self.menu:setName("menu")
    :setIsTouchInsideNode(self.scroll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 60))
    self.scroll_view:addChild(self.menu)
end

function SuperStageRewardCell:initData(data)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/super-stage-icon.plist")

    ex.Tools:setSpriteFrame(self.spr_stage_icon, "super-stage-icon/rank-2-"..data.icon_idx..".png")
    self.lbl_stage_name:setString(ex.Tools:getLang(data.name_lang))

    local item_size = cc.size(100, 100)
    local item_scale = 0.8
    
    for i, v in ipairs(data.vec_reward) do
        local item_backpack = ex.Tools:createBackpackItem(v.item_type, v.item_num)
        item_backpack:registerScriptTapHandler(handler(self, self.onItemInfo))
        item_backpack:setPosition((item_size.width + 10) * item_scale * (i - 0.5), 0)
        item_backpack:setScale(item_scale)
        self.menu:addChild(item_backpack)
    end
    
    if #data.vec_reward <= 3 then
        self.scroll_view:setContentSize(self.scroll_view:getViewSize())
    else 
        self.scroll_view:setContentSize(cc.size(#data.vec_reward * (item_size.width + 10) * item_scale, 100))
    end
end

function SuperStageRewardCell:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-----------------------------------------------------------------------------
function SuperStageRewardLayer:onCreate()
    self:addBlackBackground()
    self:setAutoClose(true)
    self:setSwallowTouches(true)

    self.scroll_view:setItemSize(cc.size(550, 141))
    self.scroll_view:setItemType(1)

    self.btn_tab_1:setChecked(true)

    self.btn_tab_1:setLabelText(ex.Tools:getLang(74823))
    self.btn_tab_2:setLabelText(ex.Tools:getLang(74824))
end

-----------------------------------------------------------------------------
function SuperStageRewardCtr:onCreate()
    self:setCCBIPath("ccbi/SuperStageRewardLayer.ccbi")
    self:setIsSingle(false)
end

function SuperStageRewardCtr:getLayerClass()
    return SuperStageRewardLayer
end

function SuperStageRewardCtr:openWindow()
    if self:isOpened() then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/super-hero.plist")

    self:loadLayer()
    self:open()
    self:initData()
end

function SuperStageRewardCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    self.layer.btn_tab_1:registerScriptTapHandler(handler(self, self.onTab))
    self.layer.btn_tab_2:registerScriptTapHandler(handler(self, self.onTab))

    local stage_id = ex.Player.super_stage_data.cur_stage_id
    local config_stage = cfg.superstage.superstage[stage_id > 0 and stage_id or 1]
    self.layer.lbl_my_stage:setString(ex.Tools:getLang(config_stage.name_lang))

    self:onTab(1)
end

function SuperStageRewardCtr:onTab(tag, pSender)
    self.layer_type = tag

    self:updateScrollView()
end

function SuperStageRewardCtr:updateScrollView()
    local item_list = {}
    for _,v in ipairs(cfg.superstage.superstage) do
        if (self.layer_type == 1 and v.first_reward ~= nil and v.first_reward ~= "" and #v.first_reward > 0) or
           (self.layer_type == 2 and v.stage_reward ~= nil and v.stage_reward ~= "" and #v.stage_reward > 0) then
            local data = {}
            data.idx = v.idx
            data.icon_idx = v.icon_idx
            data.name_lang = v.name_lang
            if self.layer_type == 1 then
                data.vec_reward = v.first_reward
            elseif self.layer_type == 2 then
                data.vec_reward = v.stage_reward
            end
            table.insert(item_list, data)
        end
    end

    table.sort(item_list, function(a, b)
        return a.idx > b.idx
    end)

    self.layer.scroll_view:getContainer():removeAllChildren()
    self.layer.scroll_view.createItemFunction = function(data)
        -- 创建ccbi cell
        local cell = SuperStageRewardCell:createWithCCBIFile("ccbi/SuperStageRewardCell.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(0.5, 0.5)
    
        cell:initData(data)
    
        return cell
    end

    self.layer.scroll_view:reloadData(item_list)
end

return SuperStageRewardCtr
