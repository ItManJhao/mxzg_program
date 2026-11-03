local PlaneWarRankCtr = class("PlaneWarRankCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local PlaneWarRankLayer = class("PlaneWarRankLayer", require("src.comp.EventLayerAdaptiveWidth"))
local PlaneWarRankCell = class("PlaneWarRankCell", require("src.comp.LuaLayerBase"))
local PlaneWarRewardCell = class("PlaneWarRewardCell", require("src.comp.LuaLayerBase"))

local string_format = string.format
function PlaneWarRewardCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end

function PlaneWarRewardCell:onClick(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function PlaneWarRewardCell:updateItem(award_list)
    local menu = cpp.UIMenu:create():setPosition(cc.p(0, 0))
    self:addChild(menu)

    local goods_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()
    goods_size.width = goods_size.width * 0.75 + 10

    local begin = self:getContentSize().width - 30
    local margin = 5
    local posY = 50
    local scale = 0.75
    for i, v in ipairs(award_list) do
        local item = ex.Player.backpack_data:createWithData(v.item_type, v.item_num)
        local posX = (begin - item:getContentSize().width * scale / 2) - (i - 1) * ((item:getContentSize().width * scale) + margin)

        item:setPosition(posX, posY)
        item:setScale(scale)
        item:registerScriptTapHandler(handler(self, self.onClick))
        menu:addChild(item)
    end
end

function PlaneWarRewardCell:reset(data)
    if not data then
        print("not data")
        return
    end
    self.data = data

    self:updateItem(data.reward)

    local str_rank = tostring(data.rank_down)
    if data.rank_down > 4 then
        str_rank = data.rank_up .. "-" .. data.rank_down
    end

    self.lbl_my_rank_tip:setVisible(false)
    self.lbl_my_rank:setVisible(false)

    self.spr_rank:setVisible(false)
    self.lbl_rank:setVisible(true)
    if data.rank_down > 0 and data.rank_down < 4 then
        self.spr_rank:setVisible(true)
        self.lbl_rank:setVisible(false)
        -- self.spr_rank:setSpriteFrame(string.format("rank/spr-paihang-%s.png", data.rank_down))
        ex.Tools:setSpriteFrame(self.spr_rank, string.format("rank/spr-paihang-%s.png", data.rank_down))
    end

    self.lbl_rank:setString(str_rank)
    self.lbl_rank:enableOutline(FONT_BLACK_C4B, 3)
end


function PlaneWarRankCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.spr_photo_btn:registerScriptTapHandler(handler(self, self.onFriendInfo))
end

function PlaneWarRankCell:reset(data)
    if not data then
        print("not data")
        return
    end
    self.data = data

    self.spr_photo:setSpriteFrame(string.format("head-icon/%d.png", self.data.head_id))
    self.spr_frame:setSpriteFrame(ex.Tools:getBorderIconByIdx(self.data.border_id))
    self.lbl_name:setString(ex.StringUtil.getServerName(self.data.server_id)..self.data.name)
    self.lbl_fight:setString(self.data.combat_num)

    if self.data.rank > 0 and self.data.rank < 4 then
        self.spr_rank:setVisible(true)
        self.lbl_rank:setVisible(false)
        -- self.spr_rank:setSpriteFrame(string.format("rank/spr-paihang-%s.png", self.data.rank))
        ex.Tools:setSpriteFrame(self.spr_rank, string.format("rank/spr-paihang-%s.png", self.data.rank))
    else
        self.spr_rank:setVisible(false)
        self.lbl_rank:setVisible(true)
        if self.data.rank < 0 then
            self.lbl_rank:setString(ex.Tools:getLang(47749))
        else
            self.lbl_rank:setString(self.data.rank)
        end
        self.lbl_rank:enableOutline(FONT_BLACK_C4B, 2)
    end

    self.lbl_max:setString(string.format(ex.Tools:getLang(47526), self.data.score))
    self.lbl_max:enableOutline(FONT_BLACK_C4B, 2)

    --
end

function PlaneWarRankCell:onFriendInfo(tag, pSender)
    ex.Tools:showPlayerInfo(self.data.player_id, cc.UserDefault:getInstance():getIntegerForKey("server_id"))
end


------------------------------------------------

local PlaneWarRank = {}
PlaneWarRank.RANK = 10
PlaneWarRank.REWARD = 20

function PlaneWarRankLayer:onCreate()
    self:addBlackBackground()

    self.btn_left:setLabelText(ex.Tools:getLang(5649))
    self.btn_right:setLabelText(ex.Tools:getLang(5025))
    self:addEvent(EVENT.PLANE_WAR.UPDATE_RANK, handler(self, self.initScroll))

    ctr.plane_war:requestPlaneWarRank()
end

function PlaneWarRankLayer:initDone()
    self.btn_left:registerScriptTapHandler(handler(self, self.onRank))
    self.btn_right:registerScriptTapHandler(handler(self, self.onReward))

    self:changeLayer(PlaneWarRank.RANK)
end

function PlaneWarRankLayer:onRank(tag, pSender)
    self:changeLayer(PlaneWarRank.RANK)
end

function PlaneWarRankLayer:onReward(tag, pSender)
    self:changeLayer(PlaneWarRank.REWARD)
end

function PlaneWarRankLayer:changeLayer(type)
    if type == self.select_type then
        return
    end
    self.select_type = type

    self.btn_left:setChecked(self.select_type == PlaneWarRank.RANK)
    self.btn_right:setChecked(self.select_type == PlaneWarRank.REWARD)

    if type == PlaneWarRank.RANK then
        self.rank:setVisible(true)
        self.reward:setVisible(false)
    elseif type == PlaneWarRank.REWARD then
        self.rank:setVisible(false)
        self.reward:setVisible(true)
    end

    self:initScroll()
end

function PlaneWarRankLayer:initScroll()
    -- 刷新数据
    if self.select_type == PlaneWarRank.RANK then
        self.cell_rank_data = ctr.plane_war.data.rank_list
        self.self_rank_data = ctr.plane_war.data.self_rank_data

        if not self.rank_list then
            local win_size = cc.size(self.rank_scroll_bg:getContentSize().width, self.rank_scroll_bg:getContentSize().height - 10)
            self.rank_list = ex.Tools:initTableView(self.rank_scroll_bg, self.cell_rank_data, {PlaneWarRankCell, "ccbi/PlaneWarRankCell.ccbi"}, win_size, 5, cc.p(0, 5), true)
        else
            self.rank_list:initData(self.cell_rank_data)
            self.rank_list:reloadData()
        end
        -- 下面还有一个跑名
        self.spr_photo:setSpriteFrame(string.format("head-icon/%d.png", self.self_rank_data.head_id))
        self.spr_frame:setSpriteFrame(ex.Tools:getBorderIconByIdx(self.self_rank_data.border_id))
        self.lbl_name:setString(ex.StringUtil.getServerName(self.self_rank_data.server_id)..self.self_rank_data.name)
        self.lbl_fight:setString(self.self_rank_data.combat_num)

        if self.self_rank_data.rank < 0 then
            self.lbl_rank:setString(ex.Tools:getLang(47749))
        else
            self.lbl_rank:setString(self.self_rank_data.rank)
        end
        self.lbl_rank:enableOutline(FONT_BLACK_C4B, 2)

        self.lbl_max:setString(string.format(ex.Tools:getLang(47526), self.self_rank_data.score))
        self.lbl_max:enableOutline(FONT_BLACK_C4B, 2)
    elseif self.select_type == PlaneWarRank.REWARD then
        self.cell_reward_data = cfg.planewarrank.planewarrank
        local win_size = cc.size(self.reward_scroll_bg:getContentSize().width, self.reward_scroll_bg:getContentSize().height - 58)
        if not self.reward_list then
            self.reward_list =
                ex.Tools:initTableView(self.reward_scroll_bg, self.cell_reward_data, {PlaneWarRewardCell, "ccbi/PlaneWarRewardCell.ccbi"}, win_size, 5, cc.p(0, 5), true)
        else
            self.reward_list:initData(self.cell_reward_data)
            self.reward_list:reloadData()
        end
    end
end

function PlaneWarRankLayer:onShowInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

------------------------------------------------

function PlaneWarRankCtr:onCreate()
    self:setCCBIPath("ccbi/PlaneWarRankLayer.ccbi")
    self:setIsSingle(false)
end

function PlaneWarRankCtr:getLayerClass()
    return PlaneWarRankLayer
end

function PlaneWarRankCtr:openWindow()
    if self:isOpened() then
        return
    end

    self:loadLayer()
    self:open()
    self.layer:initDone()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
end

return PlaneWarRankCtr
