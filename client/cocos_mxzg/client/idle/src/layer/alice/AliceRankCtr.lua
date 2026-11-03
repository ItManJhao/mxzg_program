local AliceRankCtr = class('AliceRankCtr', require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local AliceRankLayer = class('AliceRankLayer', require("src.layer.ui.UI_AliceRankLayer"))
local AliceRankCell = class("AliceRankCell", require("src.layer.ui.UI_AliceRankCell"))

local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function AliceRankCell:onCreate()
    self.super.onCreate(self)
	self:setName("AliceRankCell")

    self:setAnchorPoint(cc.p(0.5, 0.5))
    self:setIgnoreAnchorPointForPosition(false)

    self.btn_photo:setContentSize(self.spr_photo:getContentSize())
end

function AliceRankCell:resetData(data)
    self.data = data

    self.spr_rank:setVisible(data.rank > 0 and data.rank <= 3)
    self.lbl_rank:setVisible(data.rank <= 0 or data.rank > 3)
    if data.rank <= 0 then
        self.lbl_rank:setString(ex.Tools:getLang(5652))
    elseif data.rank <= 3 then
        ex.Tools:setSpriteFrameAsyn(self.spr_rank, "rank/spr-paihang-"..data.rank..".png", "rank")
    else
        self.lbl_rank:setString(data.rank)
    end

    self.spr_photo:setSpriteFrame(string.format("head-icon/%d.png", data.head_id))
    self.spr_border:setSpriteFrame(ex.Tools:getBorderIconByIdx(data.broad_id))

    self.btn_photo.player_id = data.rid
    self.btn_photo.server_id = data.server_id

    self.lbl_server:setString(ex.StringUtil.getServerName(data.server_id))
    self.lbl_name:setString(data.name)

    self.lbl_round:setString(ex.Tools:getLang(580033)..data.battle_round)
    self.lbl_hero:setString(ex.Tools:getLang(580034)..data.battle_dead)
end

function AliceRankCell:setSelf()
    self.spr_cell_bg_self:setVisible(true)
end

-- 人物头像回调
function AliceRankCell:onPhoto(tag, pSender)
    ex.Tools:showPlayerInfo(pSender.player_id, pSender.server_id)
end

-----------------------------------------------------------------------------
function AliceRankLayer:onCreate()
	self.super.onCreate(self)
	self:setName("AliceRankLayer")

    self:addBlackBackground()

    self.spr_rank_self:setLocalZOrder(100)

    for i=1,10 do
        local node_top_name = self["node_name_"..i]
        if node_top_name == nil then
            break
        end

        node_top_name:setLocalZOrder(100)
    end

    self.scroll_view.createItemFunction = function(data, scale)
		local item = AliceRankCell:create()
		item:resetData(data)
		return item
	end

    self.layer_type = -1

    self:addEvent(EVENT.ALICE.ALICE_RANK, handler(self, self.updateLayer))
end

function AliceRankLayer:onTab(tag, pSender)
    if (self.layer_type == tag) then return end

    self.layer_type = tag

    self:updateLayer()
end

function AliceRankLayer:updateLayer()
    self.btn_tab_1:setChecked(self.layer_type == 1)
    self.btn_tab_2:setChecked(self.layer_type == 2)

    self.node_rank:setVisible(self.layer_type == 1)
    self.node_top:setVisible(self.layer_type == 2)


    if self.layer_type == 1 then
        local data = ctr.alice.data.rank_data and (ctr.alice.data.rank_data.list or {}) or {}
        local data_self = ctr.alice.data.rank_data and ctr.alice.data.rank_data.self or nil

        self.scroll_view:reloadData(data)
        
        if self.cell_self == nil then
            self.cell_self = AliceRankCell:create()
            self.cell_self:setPosition(self.spr_content_self_bg:getPosition(), self.spr_content_self_bg:getPositionY())
            self.node_rank:addChild(self.cell_self)
        end
		self.cell_self:resetData(data_self)
        self.cell_self:setSelf()
    else
        local data = ctr.alice.data.rank_top_data or {}
        for i=1,99 do
            local node_seat = self["node_top_"..i]
            if node_seat == nil then
                break
            end

            local spine = self["spine_top_"..i]
            if spine ~= nil then
                spine:removeFromParent()
            end

            local seat_data = data[i]
            if seat_data == nil then
                self["lbl_name_"..i]:setString("--")
                self["btn_log_"..i]:setVisible(false)
                self["btn_log_"..i].data = nil
            else
                self["lbl_name_"..i]:setString(seat_data.name)
                self["btn_log_"..i]:setVisible(true)
                self["btn_log_"..i].data = seat_data

                local hero_type = math.floor(seat_data.image % 100000000)
	            local star = math.floor(seat_data.image / 100000000)
                self["spine_top_"..i] = sp.SkeletonAnimation:create("spine/".. hero_type .. ".json", "spine/".. hero_type .. ".atlas", 1)
                local spine = self["spine_top_"..i]
                spine:setScale(0.8)
                spine:setPosition(0, 0)
                spine:setAnimation(0, "stand", true)
                node_seat:addChild(spine)
            end
        end
    end
end

-- 大神風采戰報回調
function AliceRankLayer:onBattleLog(tag, pSender)
    if pSender.data ~= nil then
        require("src.layer.alice.AliceBattleLogCtr"):instance():openWindow(pSender.data)
    end
end

-----------------------------------------------------------------------------
function AliceRankCtr:loadLayer()
	local tmp_layer = AliceRankLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function AliceRankCtr:openWindow(star)
    if self:isOpened() then
        return
    end
    
    self:loadLayer()
    self:open()
    self:initData(star or 5)
end

function AliceRankCtr:initData(star)
    self.cur_star = star

    ctr.alice:reqRankData(star)
    ctr.alice:reqRankTopData(star)

    self.layer:onTab(1)
end

return AliceRankCtr
