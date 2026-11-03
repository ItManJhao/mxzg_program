local MagicTowerRewardCtr = class('MagicTowerRewardCtr', require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local MagicTowerRewardLayer = class('MagicTowerRewardLayer', require("src.layer.ui.UI_MagicTowerRewardLayer"))
local MagicTowerRewardCell = class("MagicTowerRewardCell", require("src.layer.ui.UI_MagicTowerRewardCell"))

local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function MagicTowerRewardCell:onCreate()
    self.super.onCreate(self)
	self:setName("MagicTowerRewardCell")

    self:setAnchorPoint(cc.p(0.5, 0.5))
    self:setIgnoreAnchorPointForPosition(false)

	self.progress = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("achievement/item-progress.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.spr_progress_bg:addChild(self.progress)
    self.progress:setPosition(self.spr_progress_bg:getContentSize().width / 2 ,self.spr_progress_bg:getContentSize().height / 2)
    -- self.spr_stage_bg:setLocalZOrder(1)
    -- self.lbl_stage:setLocalZOrder(1)
end

function MagicTowerRewardCell:resetData(data)
    self.data = data

    self.progress:setPercentage(data.cur_star_num * 100.0 / data.star)
    self.lbl_progress:setString(data.cur_star_num.."/"..data.star)

    self.lbl_title:setString(string.format(ex.Tools:getLang(57535), data.star))

    self.menu_item:removeAllChildren()
    for i,item_data in ipairs(data.reward) do
        local item = UIItemBackpack:createWithData(item_data.item_type, item_data.item_num)
        item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
        self.menu_item:addChild(item)

        if not data.is_unlock then
            local spr_lock = cc.Sprite:createWithSpriteFrameName("other/spr-lock.png")
            item:addChild(spr_lock, 100)
            spr_lock:setPosition(5, item:getContentSize().height - 5)
        end
    end

    self.spr_complete:setVisible(data.is_reward)
    self.btn_go:setVisible(data.is_unlock and data.cur_star_num < data.star)
    self.btn_confirm:setVisible(data.is_unlock and not data.is_reward and data.cur_star_num >= data.star)
    self.spr_unlock:setVisible(not data.is_unlock)

    ex.Tools:addRedPoint(self.btn_confirm, data.is_unlock and not data.is_reward and data.cur_star_num >= data.star, cc.p(0.95, 0.95))
end

function MagicTowerRewardCell:setScrollView(scroll_view)
	self.menu_item:setIsTouchInsideNode(scroll_view)
	self.menu:setIsTouchInsideNode(scroll_view)
end

-- 奖励物品按钮回调
function MagicTowerRewardCell:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function MagicTowerRewardCell:onConfirm(tag, pSender)
    if self.data == nil or self.data.callback == nil then
        return
    end

    self.data.callback(self.data)
end

function MagicTowerRewardCell:onGo(tag, pSender)
    if self.data == nil or self.data.callback == nil then
        return
    end

    self.data.callback(self.data)
end

-----------------------------------------------------------------------------
function MagicTowerRewardLayer:onCreate()
	self.super.onCreate(self)
	self:setName("MagicTowerRewardLayer")

    self:addBlackBackground()

    cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/magic-tower.plist")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/magic-tower-lang.plist")

    self.scroll_view.createItemFunction = function(data, scale)
		local item = MagicTowerRewardCell:create()
		item:resetData(data)
        item:setScrollView(self.scroll_view)
		return item
	end

    self.layer_type = -1

    self:addEvent(EVENT.MAGIC_TOWER_EVENT.ROAD_INFO, handler(self, self.updateLayer))
    
    self:addRedDotNode(RedDotType.ZCJ_DHZC_HJZT_HMT_ZMZL_ZMLC, self.btn_tab_1)
    self:addRedDotNode(RedDotType.ZCJ_DHZC_HJZT_HMT_ZMZL_ZMWZ, self.btn_tab_2)
end

function MagicTowerRewardLayer:onTab(tag, pSender)
    if (self.layer_type == tag) then return end

    self.layer_type = tag

    self:updateLayer()
end

function MagicTowerRewardLayer:updateLayer()
    self.btn_tab_1:setChecked(self.layer_type == 1)
    self.btn_tab_2:setChecked(self.layer_type == 2)

    local magic_tower_data = ex.Player.magic_tower_data
    local is_king_unlock = magic_tower_data.is_buy_king

    if self.layer_type == 1 then
        self.spr_banner:setSpriteFrame("magic-tower/banner-star-3.png")
        self.btn_buy:setVisible(false)
        self.node_king:setVisible(false)

        self.scroll_view:setSize(cc.size(550, 735))
    elseif is_king_unlock then
        self.spr_banner:setSpriteFrame("magic-tower/banner-star-2.png")
        self.btn_buy:setVisible(false)
        self.node_king:setVisible(true)

        self.scroll_view:setSize(cc.size(550, 675))
    else
        self.spr_banner:setSpriteFrame("magic-tower/banner-star-1.png")
        self.btn_buy:setVisible(true)
        self.node_king:setVisible(true)

        self.scroll_view:setSize(cc.size(550, 675))
    end

    local star_num = magic_tower_data:getStarTotalNum()

    self.lbl_star:setString(star_num)

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/achievement.plist")

    local data = {}
    if self.layer_type == 1 then
        for _,v in pairs(cfg.magictowerstarreward.magictowerstarreward) do
            local config = clone(v)
            config.cur_star_num = star_num
            config.is_unlock = true
            config.is_reward = false
            config.callback = handler(self, self.onCellConfirm)

            for _,reward_idx in ipairs(magic_tower_data.road_normal_list) do
                if reward_idx == config.idx then
                    config.is_reward = true
                end
            end

            table.insert(data, config)
        end
    else
        for i,v in pairs(cfg.magictowerkingreward.magictowerkingreward) do
            local config = clone(v)
            config.cur_star_num = star_num
            config.is_unlock = is_king_unlock
            config.is_reward = false
            config.callback = handler(self, self.onCellConfirm)

            for _,reward_idx in ipairs(magic_tower_data.road_king_list) do
                if reward_idx == config.idx then
                    config.is_reward = true
                end
            end

            table.insert(data, config)
        end
    end

    table.sort(data, function(a, b)
        if a.is_reward == b.is_reward then
            return a.star < b.star
        end

        return b.is_reward
    end)

    self.scroll_view:reloadData(data)
end

-- 功能info
function MagicTowerRewardLayer:onInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(57519), ex.Tools:getLang(57520))
end

-- 点击cell按钮的回调
function MagicTowerRewardLayer:onCellConfirm(data)
    if data.is_reward or not data.is_unlock then
        return
    elseif data.cur_star_num < data.star then
        self:onGo()
        return
    end

    local req = MagicTower_pb.GReqMagicTowerRoadReceive()
    req.receive_id = data.idx
    req.type = self.layer_type
    NetManager:sendMessage(ProtocolID.GReqMagicTowerRoadReceive, req)
end

-- 解鎖斬魔王者
function MagicTowerRewardLayer:onBuy(tag, pSender)
    if ex.Player.magic_tower_data:getStarTotalNum() < cfg.system.magic_tower_king_gift_star then
        ex.MessageView:add(string.format(ex.Tools:getLang(57543), cfg.system.magic_tower_king_gift_star))
        return
    end

    require("src.layer.magictower.MagicTowerKingUnlockCtr"):instance():openWindow()
end

-- 前往
function MagicTowerRewardLayer:onGo(tag, pSender)
    require("src.comp.LuaNodeCtr"):closeOtherWindow()
end

-----------------------------------------------------------------------------
function MagicTowerRewardCtr:loadLayer()
	local tmp_layer = MagicTowerRewardLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function MagicTowerRewardCtr:openWindow(tab_type)
    if self:isOpened() then
        return
    end
    
    self:loadLayer()
    self:open()
    self:initData(tab_type or 1)
end

function MagicTowerRewardCtr:initData(tab_type)
    self.layer:onTab(tab_type)
end

return MagicTowerRewardCtr
