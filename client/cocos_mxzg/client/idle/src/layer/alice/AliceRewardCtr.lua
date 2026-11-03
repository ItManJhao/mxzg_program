local AliceRewardCtr = class('AliceRewardCtr', require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local AliceRewardLayer = class('AliceRewardLayer', require("src.layer.ui.UI_AliceRewardLayer"))
local AliceRewardCell = class("AliceRewardCell", require("src.layer.ui.UI_AliceRewardCell"))

local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function AliceRewardCell:onCreate()
    self.super.onCreate(self)
	self:setName("AliceRewardCell")

    self:setAnchorPoint(cc.p(0.5, 0.5))
    self:setIgnoreAnchorPointForPosition(false)
end

function AliceRewardCell:resetData(data, type)
    self.node_rank:setVisible(type == 1)
    self.node_star:setVisible(type == 2)

    if type == 1 then
        self.spr_rank:setVisible(data.rank_up <= 3)
        self.lbl_rank:setVisible(data.rank_up > 3)
        if data.rank_up <= 3 then
            ex.Tools:setSpriteFrameAsyn(self.spr_rank, "rank/spr-paihang-"..data.rank_up..".png", "rank")
        else
            self.lbl_rank:setString(data.rank_up.."-"..data.rank_down)
        end
    else
        self.lbl_star:setString(string.format(ex.Tools:getLang(580589), data.star))
    end

    local vec_reward = data.rewards or data.reward
    self.menu_item:removeAllChildren()
    for _,item_data in ipairs(vec_reward) do
        local item = UIItemBackpack:createWithData(item_data.item_type, item_data.item_num)
        item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
        self.menu_item:addChild(item)
    end
end

function AliceRewardCell:setScrollView(scroll_view)
	self.menu_item:setIsTouchInsideNode(scroll_view)
end

function AliceRewardCell:setSelf(data, rank)
    self.node_rank:setVisible(false)
    self.node_star:setVisible(false)
    self.node_self:setVisible(true)

    self.lbl_self_rank:setString(ex.Tools:getLang(5290)..(rank <= 0 and ex.Tools:getLang(5652) or rank))
    self.lbl_self_rank_tip:setString(rank <= 0 and (ex.Tools:getLang(5139)..":"..ex.Tools:getLang(5652)) or (ex.Tools:getLang(5139)..":"))

    if data then
        local vec_reward = data.rewards or data.reward
        self.menu_item:removeAllChildren()
        for _,item_data in ipairs(vec_reward) do
            local item = UIItemBackpack:createWithData(item_data.item_type, item_data.item_num)
            item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
            self.menu_item:addChild(item)
        end
        self:resetLyt()
    end
end

-- 奖励物品按钮回调
function AliceRewardCell:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-----------------------------------------------------------------------------
function AliceRewardLayer:onCreate()
	self.super.onCreate(self)
	self:setName("AliceRewardLayer")

    self:addBlackBackground()

    self.scroll_view.createItemFunction = function(data, scale)
		local item = AliceRewardCell:create()
		item:resetData(data, self.layer_type)
        item:setScrollView(self.scroll_view)
		return item
	end

    self.layer_type = -1

    self:addEvent(EVENT.MAGIC_TOWER_EVENT.ROAD_INFO, handler(self, self.updateLayer))
    
    self:addRedDotNode(RedDotType.ZCJ_DHZC_HJZT_HMT_ZMZL_ZMLC, self.btn_tab_1)
    self:addRedDotNode(RedDotType.ZCJ_DHZC_HJZT_HMT_ZMZL_ZMWZ, self.btn_tab_2)
end

function AliceRewardLayer:onTab(tag, pSender)
    if (self.layer_type == tag) then return end

    self.layer_type = tag

    self:updateLayer()
end

function AliceRewardLayer:updateLayer()
    self.btn_tab_1:setChecked(self.layer_type == 1)
    self.btn_tab_2:setChecked(self.layer_type == 2)

    self.node_rank:setVisible(self.layer_type == 1)
    self.node_star:setVisible(self.layer_type == 2)

    local data = {}
    local rank_self = ctr.alice.data.rank_data and (ctr.alice.data.rank_data.self and ctr.alice.data.rank_data.self.rank or -1) or -1
    local data_self = nil
    if self.layer_type == 1 then
        self.scroll_view:setSize(cc.size(self.spr_rank_bg:getContentSize().width - 10, self.spr_rank_bg:getContentSize().height - 50))
        self.scroll_view:setPosition(self.spr_rank_bg:getPositionX() + self.node_rank:getPositionX() - self.node_rank:getContentSize().width * self.node_rank:getAnchorPoint().x, 
                                     self.spr_rank_bg:getPositionY() + self.node_rank:getPositionY() - self.node_rank:getContentSize().height * self.node_rank:getAnchorPoint().y + 5)

        for _,config in ipairs(cfg.alicerankreward.alicerankreward) do
            if config.star == self.cur_star then
                table.insert(data, config)

                if config.rank_up <= rank_self and config.rank_down >= rank_self then
                    data_self = config
                end
            end
        end
    else
        self.scroll_view:setSize(cc.size(self.spr_star_bg:getContentSize().width - 10, self.spr_star_bg:getContentSize().height - 50))
        self.scroll_view:setPosition(self.spr_star_bg:getPositionX() + self.node_star:getPositionX() - self.node_star:getContentSize().width * self.node_star:getAnchorPoint().x, 
                                     self.spr_star_bg:getPositionY() + self.node_star:getPositionY() - self.node_star:getContentSize().height * self.node_star:getAnchorPoint().y + 5)

        for _,config in pairs(cfg.alicestarreward.alicestarreward) do
            table.insert(data, config)
        end
        table.sort(data, function(a, b)
            return a.star < b.star
        end)
    end

    self.scroll_view:reloadData(data)

    if self.layer_type == 1 then
        if self.cell_self == nil then
            self.cell_self = AliceRewardCell:create()
            self.cell_self:setPosition(self.spr_content_self_bg:getPosition(), self.spr_content_self_bg:getPositionY())
            self.node_rank:addChild(self.cell_self)
        end
        self.cell_self:setSelf(data_self, rank_self)
    end
end

-----------------------------------------------------------------------------
function AliceRewardCtr:loadLayer()
	local tmp_layer = AliceRewardLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function AliceRewardCtr:openWindow(star)
    if self:isOpened() then
        return
    end
    
    self:loadLayer()
    self:open()
    self:initData(star or 5)
end

function AliceRewardCtr:initData(star)
    self.layer.cur_star = star

    self.layer:onTab(1)
end

return AliceRewardCtr
