local PROMSecretTreasureRewardCtr = class("PROMSecretTreasureRewardCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PROMSecretTreasureRewardLayer = class("PROMSecretTreasureRewardLayer", require("src.comp.EventLayerAdaptiveWidth"))
local PROMSecretTreasureRewardCell = class("PROMSecretTreasureRewardCell", require("src.comp.EventLayer"))
local PROMSecretTreasureRewardItem = class("PROMSecretTreasureRewardItem", require("src.comp.EventLayer"))
local UIMenuItemBag = require("src.comp.menu.UIMenuItemBag")

-----------------------------------------------------------------------------
function PROMSecretTreasureRewardLayer:onCreate()
    self:addBlackBackground()
    self:setAutoClose(true)
    self:setSwallowTouches(true)
end

------------------------------------ PROMSecretTreasureRewardItem ------------------------------------
function PROMSecretTreasureRewardItem:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self.spr_frame:setZOrder(100)
    self.spr_gray:setZOrder(101)
    self.spr_awarded:setZOrder(102)
end

function PROMSecretTreasureRewardItem:resetData(data)
    self.data = data
    if not data.config or not data.config.reward or #data.config.reward == 0 then
        return
    end

    local reward = data.config.reward[1]

    local item_type = reward.item_type
    local item_num = reward.item_num or 0

    self.spr_gray:setVisible(not data.is_choose)
    self.spr_glow:setVisible(data.is_choose and not data.is_get)
    self.spr_awarded:setVisible(data.is_get)

    self.spr_item = UIMenuItemBag:createWithData(item_type, item_num)
    self.spr_item:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
    self:addChild(self.spr_item)
    self.btn_item.item_type = item_type
end


-------------------------------------PROMSecretTreasureRewardCell-------------------------------------
function PROMSecretTreasureRewardCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:setIgnoreAnchorPointForPosition(false)
    self:setAnchorPoint(0.5, 0.5)
end

function PROMSecretTreasureRewardCell:resetData(data)
    if not data then
        return
    end

    if data and #data > 0 and data[1].config then
        local type = data[1].config.type
        if type == 1 then
            -- self.spr_choose_lv:setSpriteFrame("promotion-secret-treasure-lang/icon-word-s.png")
            ex.Tools:setSpriteFrame(self.spr_choose_lv, "promotion-secret-treasure-lang/icon-word-s.png")
        elseif type == 2 then
            -- self.spr_choose_lv:setSpriteFrame("promotion-secret-treasure-lang/icon-word-a.png")
            ex.Tools:setSpriteFrame(self.spr_choose_lv, "promotion-secret-treasure-lang/icon-word-a.png")
        elseif type == 3 then
            -- self.spr_choose_lv:setSpriteFrame("promotion-secret-treasure-lang/icon-word-b.png")
            ex.Tools:setSpriteFrame(self.spr_choose_lv, "promotion-secret-treasure-lang/icon-word-b.png")
        end
    end

    local view_size = cc.size(405.0, 122.0)
    self.scroll_view:setItemType(1)
    self.scroll_view:setCreateNum(1)
    self.scroll_view:setViewSize(view_size)
    self.scroll_view:setItemSize(cc.size(118, 118))
    self.scroll_view:setSwallowsTouches(false)
    local con_width = view_size.width
    if #data * 118 > con_width then
        con_width = #data * 118
        self.scroll_view:setTouchEnabled(true)
    else
        self.scroll_view:setTouchEnabled(false)
    end

    self.scroll_view:setContentSize(cc.size(con_width, view_size.height))
    self.scroll_view.createItemFunction = function(item_data, scale)
        local cell = PROMSecretTreasureRewardItem:createWithCCBIFile("ccbi/PROMSecretTreasureRewardItem.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(cc.p(0.5, 0.5))
        cell:resetData(item_data)
        cell.menu:setSwallowsTouches(false)
        cell.menu:setIsTouchInsideNode(self.scroll_view)
        cell.btn_item:registerScriptTapHandler(handler(self, self.onItemInfo))
        return cell
    end

    self.scroll_view:reloadData(data)
end

function PROMSecretTreasureRewardCell:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-----------------------------------------------------------------------------
function PROMSecretTreasureRewardCtr:onCreate()
    self:setCCBIPath("ccbi/PROMSecretTreasureRewardLayer.ccbi")
    self:setIsSingle(false)
end

function PROMSecretTreasureRewardCtr:getLayerClass()
    return PROMSecretTreasureRewardLayer
end

function PROMSecretTreasureRewardCtr:openWindow()
    if self:isOpened() then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/common-ui.plist")

    self:loadLayer()
    self:open()
    self:initData()
end

function PROMSecretTreasureRewardCtr:initData()
    local rewards = ex.Player.promotion_data.promotion70_choose_rewards

    self.layer.scroll_view:setItemType(1)
    local sv_width = self.layer:getContentSize().width - 80
    local sv_height = self.layer:getContentSize().height - 136
    self.layer.scroll_view:setViewSize(cc.size(sv_width, sv_height))
    self.layer.scroll_view:setItemSize(cc.size(550, 170))
    self.layer.scroll_view.createItemFunction = function(item_data, scale)
        local cell = PROMSecretTreasureRewardCell:createWithCCBIFile("ccbi/PROMSecretTreasureRewardCell.ccbi")
        cell:resetData(item_data)
        cell.menu:setSwallowsTouches(false)
        cell.menu:setIsTouchInsideNode(self.layer.scroll_view)
        return cell
    end

    self.layer.scroll_view:setTouchEnabled(false)
    self.layer.scroll_view:reloadData(rewards)
end

return PROMSecretTreasureRewardCtr
