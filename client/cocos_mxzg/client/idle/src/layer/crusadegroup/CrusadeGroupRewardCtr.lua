--[[
    讨伐团奖励预览界面
    在讨伐团报名界面处调用
]]

local CrusadeGroupRewardCtr = class("CrusadeGroupRewardCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local CrusadeGroupRewardLayer = class("CrusadeGroupRewardLayer", require("src.comp.EventLayerAdaptiveWidth"))

local CrusadeGroupRewardCell = class("CrusadeGroupRewardCell", require("src.comp.LuaLayerBase"))

local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function CrusadeGroupRewardCell:onCreate()
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
    :setPosition(cc.p(0, 41))
    self.scroll_view:addChild(self.menu)
end

function CrusadeGroupRewardCell:initData(data)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/crusade-group.plist")

    ex.Tools:setSpriteFrame(self.spr_nobility, "crusade-group/spr-nobility-"..data.icon_idx..".png")
    self.lbl_nobility:setString(ex.Tools:getLang(data.name_lang))

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

function CrusadeGroupRewardCell:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-----------------------------------------------------------------------------
function CrusadeGroupRewardLayer:onCreate()
    self:addBlackBackground()
    self:setAutoClose(true)
    self:setSwallowTouches(true)

    self.scroll_view:setItemSize(cc.size(550, 105))
    self.scroll_view:setItemType(1)
end

-----------------------------------------------------------------------------
function CrusadeGroupRewardCtr:onCreate()
    self:setCCBIPath("ccbi/CrusadeGroupRewardLayer.ccbi")
    self:setIsSingle(false)
end

function CrusadeGroupRewardCtr:getLayerClass()
    return CrusadeGroupRewardLayer
end

function CrusadeGroupRewardCtr:openWindow()
    if self:isOpened() then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/crusade-group.plist")
    sfc:addSpriteFrames("ccbi-res/super-hero.plist")

    self:loadLayer()
    self:open()
    self:initData()
end

function CrusadeGroupRewardCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self:updateScrollView()
end

function CrusadeGroupRewardCtr:updateScrollView()
    local item_list = {}
    for _,v in ipairs(cfg.crusadegroupoccupation.crusadegroupoccupation) do
        if (v.reward ~= nil and v.reward ~= "" and #v.reward > 0) then
            local data = {}
            data.idx = v.id
            data.icon_idx = v.id
            data.name_lang = v.des
            data.vec_reward = v.reward

            table.insert(item_list, data)
        end
    end

    table.sort(item_list, function(a, b)
        return a.idx > b.idx
    end)

    self.layer.scroll_view:getContainer():removeAllChildren()
    self.layer.scroll_view.createItemFunction = function(data)
        -- 创建ccbi cell
        local cell = CrusadeGroupRewardCell:createWithCCBIFile("ccbi/CrusadeGroupRewardCell.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(0.5, 0.5)
    
        cell:initData(data)
    
        return cell
    end

    self.layer.scroll_view:reloadData(item_list)
end

return CrusadeGroupRewardCtr
