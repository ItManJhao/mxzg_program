local ChampionRankLayer = class("ChampionCrossRankLayer", require("src.comp.EventLayer"))
local ChampionRankCell = class("ChampionCrossRankCell", require("src.comp.LuaLayerBase"))

function ChampionRankCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:setIgnoreAnchorPointForPosition(false)
    self:setAnchorPoint(0.5, 0.5)
    self.btn_role:setContentSize(cc.size(64, 64))
end

function ChampionRankCell:reset(data, width)
    if not data then
        return
    end

    self.data = data

	self.spr_rank:setVisible(false)
	self.lbl_rank:setVisible(true)
    if data.rank > 0 and data.rank < 4 then 
		self.spr_rank:setVisible(true)
		self.lbl_rank:setVisible(false)
        -- self.spr_rank:setSpriteFrame(string.format("rank/spr-paihang-%s.png",data.rank))
        ex.Tools:setSpriteFrame(self.spr_rank, string.format("rank/spr-paihang-%s.png",data.rank))
    end
    self:setContentSize(cc.size(width - 10, self.spr_bg:getContentSize().height))
    self.spr_bg:setContentSize(self:getContentSize())
    self.node_right:setPositionX(width - 113 - 10)

    self.lbl_name:setString(ex.StringUtil.getServerName(data.server_id)..data.name)
    self.lbl_like:setString(data.like)
    self.lbl_point:setString(data.point)

    self.lbl_combat_num:setString(data.fighting)
	self.lbl_rank:setString(data.rank <= 0 and ex.Tools:getLang(47749) or data.rank)

    ex.Tools:setSpriteFrame(self.spr_head, string.format("head-icon/%d.png", data.head_id))
    ex.Tools:setSpriteFrame(self.spr_frame, ex.Tools:getBorderIconByIdx(data.border_id))

    self:updateLike()
end

function ChampionRankCell:updateLike()
    local is_like = ex.Player.championcross_data:isLike(self.data.rid)
    ex.Tools:setGrayAuto(self.spr_like, is_like)
    ex.Tools:setGrayAuto(self.spr_like, is_like)
    self.lbl_like:setString(self.data.like)
    ex.Tools:setGrayAuto(self.btn_like:getNormalImage(), is_like)
    self.btn_like:setEnabled(is_like == false)
end

function ChampionRankCell:onLike()
    if self.data == nil then
        return
    end

    if ex.Player.role_id == self.data.rid then
        ex.MessageView:add(ex.Tools:getLang(47105))
        return
    end

    if ex.Player.championcross_data:isLimitLike() then
        -- ex.MessageView:add(string.format(ex.Tools:getLang(47504), ex.Tools:getSysCfg("champion_max_like")))
        ex.MessageView:add(ex.Tools:getLang(70768))
        return
    end

    local req_like = ChampionCross_pb.GReqChampionCrossLike()
    req_like.rid = self.data.rid
    NetManager:sendMessage(ProtocolID.GReqChampionCrossLike, req_like)

    self.data.like = self.data.like + 1
    ex.Player.championcross_data:addLike(self.data.rid)

    self:updateLike()
end

function ChampionRankCell:onRole()
    if self.data ~= nil then
        ex.Tools:showPlayerInfo(self.data.rid, self.data.server_id)
    end
end

function ChampionRankLayer:onCreate()
    self.my_cell = ChampionRankCell:createWithCCBIFile("ccbi/ChampionCrossRankCell.ccbi")
    self.my_cell:setAnchorPoint(0.5, 0)
    self.my_cell:setPosition(cc.p(self.node_bottom:getContentSize().width * 0.5, 5))
    self.node_bottom:addChild(self.my_cell)

    self.spr_ribbon:setLocalZOrder(1)
    self.my_cell:reset(nil, ex.p.width)

    self.scroll_view:setItemType(1)
    self.scroll_view:setCreateNum(5)

    self:addEvent(EVENT.CHAMPIONCROSS_EVENT.UPDATE_CHAMPION_RANK_LIST, handler(self, self.updateLayer))
end

function ChampionRankLayer:refresh()
    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.2), cc.CallFunc:create(function()
        NetManager:sendMessage(ProtocolID.GReqChampionCrossRank)
    end)))
    
    -- NetManager:sendMessage(ProtocolID.GReqScanChampionKnockout)
end

function ChampionRankLayer:resetY(y)
    self.node_top:setPositionY(y)
    self.spr_rank_bg:setContentSize(cc.size(self.spr_rank_bg:getContentSize().width, y - self.node_bottom:getPositionY() - self.node_bottom:getContentSize().height - 30))
    self.scroll_view:setViewSize(self.spr_rank_bg:getContentSize())
    self.scroll_view:setItemSize(cc.size(self.scroll_view:getViewSize().width, 135))
    self:updateLayer()
end

function ChampionRankLayer:updateLayer()

    local vec_rank = {}
    for i=1,50 do
        table.insert(vec_rank, ex.Player.championcross_data.vec_champion_rank[i])
    end
    
    self.scroll_view.createItemFunction = function(item_data, scale)
        local cell = ChampionRankCell:createWithCCBIFile("ccbi/ChampionCrossRankCell.ccbi")
        cell:reset(item_data, ex.p.width)
        return cell
    end
    self.scroll_view:reloadData(vec_rank)

    local my_data = TableEx.findValueFunction(ex.Player.championcross_data.vec_champion_rank, function(value)
        return value.rid == ex.Player.role_id
    end)

    if my_data == nil then
        my_data = {}
        my_data.rid = ex.Player.role_id
        my_data.name = ex.Player.nick
        my_data.like = ex.Player.championcross_data.worship_count
        my_data.rank = ex.Player.championcross_data.rank
        my_data.level = ex.Player.level
        my_data.head_id = ex.Player.head_id
        my_data.border_id = ex.Player.border_id
        my_data.point = 0
        my_data.fighting = ex.Player.fighting
        my_data.server_id = cc.UserDefault:getInstance():getIntegerForKey("server_id", -1)
    end

    self.my_cell:reset(my_data, ex.p.width)
end

return ChampionRankLayer