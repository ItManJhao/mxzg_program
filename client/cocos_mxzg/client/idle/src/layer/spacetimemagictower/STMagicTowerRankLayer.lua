local STMagicTowerRankLayer = class("STMagicTowerRankLayer", require("src.comp.EventLayer"))
local STMagicTowerSeat = class("STMagicTowerSeat", require("src.comp.EventLayer"))
local STMagicTowerRankCell = class("STMagicTowerRankCell", require("src.comp.LuaLayerBase"))


-- NPC位置百分比
local SeatPosData = {
    -- {x坐标百分比，y坐标百分比，缩放系数}
    {fx = 0.50, fy = 0.70, fs = 1.0},
    {fx = 0.26, fy = 0.27, fs = 0.8},
    {fx = 0.74, fy = 0.27, fs = 0.8}
}

-------------------------------------STMagicTowerSeat-------------------------------------

function STMagicTowerSeat:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.data = {}

    self.node_root:retain()

    self.node_root:removeFromParentAndCleanup(false)

    -- self.node_root:setParent(self.btn_base:getNormalImage())
    self.btn_base:getNormalImage():addChild(self.node_root)

    self.node_root:release()
end

function STMagicTowerSeat:initDone(data)
    self.data = data

    self.node_animator:removeAllChildren()
    if not self.lbl_attack then
        self.lbl_attack = cc.Label:createWithBMFont("font/red-26.fnt", 0)
        self.lbl_attack:setAnchorPoint(cc.p(0.5, 0.5))
        self.node_attack:addChild(self.lbl_attack, 50)
        self.lbl_attack:setPosition(40, 0)
    end

    if data then
        self.lbl_name:setString(string.format("[s%s] %s", data.server_id, data.player_name))
        self.animator = require("src.person.Hero"):create("1", "1", 1, 1, ex.Tools:getHeroSkinByImageId(data.image_id))
        self.animator:setAnimation(0, "stand", true)
        self.animator:setScale(1.5)
        self.animator:setPosition(cc.p(0, 80))
        self.animator:setShadowVisible(false)
        self.node_animator:addChild(self.animator, 10)
        self.lbl_attack:setString(data.fighting)
        -- self.spr_rank:setSpriteFrame(string.format("championship/lbl-rank%s.png", data.rank))
        ex.Tools:setSpriteFrame(self.spr_rank, string.format("championship/lbl-rank%s.png", data.rank))
        self.spr_rank:setVisible(true)
        self.node_attack:setVisible(true)
    else
        self.lbl_name:setString(ex.Tools:getLang(47593))
        self.spr_rank:setVisible(false)
        self.node_attack:setVisible(false)
    end
end

-------------------------------------STMagicTowerRankCell-------------------------------------
function STMagicTowerRankCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:setIgnoreAnchorPointForPosition(false)
    self:setAnchorPoint(0.5, 0.5)
    self.btn_role:setContentSize(cc.size(64, 64))
    self.spr_rank:setVisible(false)
    self.lbl_rank:setVisible(false)
end

function STMagicTowerRankCell:reset(data, width)
    if not data then
        return
    end

    self.data = data
    
    if data.rank > 0 and data.rank < 4 then
        self.spr_rank:setVisible(true)
        self.lbl_rank:setVisible(false)
        -- self.spr_rank:setSpriteFrame(string.format("rank/spr-paihang-%s.png", data.rank))
        ex.Tools:setSpriteFrame(self.spr_rank, string.format("rank/spr-paihang-%s.png", data.rank))
    else
        self.spr_rank:setVisible(false)
        self.lbl_rank:setVisible(true)
    end

    self:setContentSize(cc.size(width, self.spr_bg:getContentSize().height))
    self.spr_bg:setContentSize(self:getContentSize())
    self.lbl_pass_lv:setPositionX(width - 113 - 10)
    self.lbl_pass_lv:setString(string.format(ex.Tools:getLang(54505), data.max_pass))

    self.lbl_name:setString(string.format("[s%s] %s", data.server_id, data.player_name))
    self.lbl_rank:setString(data.rank <= 0 and ex.Tools:getLang(47749) or data.rank)
    self.lbl_power:setString(string.format("%s%s", ex.Tools:getLang(52204), data.fighting))

    ex.Tools:setSpriteFrame(self.spr_head, string.format("head-icon/%d.png", data.head_id))
    ex.Tools:setSpriteFrame(self.spr_frame, ex.Tools:getBorderIconByIdx(data.border_id))
    self.btn_role.data = data
end


-------------------------------------STMagicTowerRankLayer-------------------------------------
-- 界面布局调整
function STMagicTowerRankLayer:onCreate()
    self.data = {}

    self:setAutoClose(false)
    self:setSwallowTouches(false)

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/championship.plist")

    -- 铺展到全屏
    ex.Tools:AdjustFullScreenExtend(self.spr_bg)

    local pos_y = ex.p.height - 80 * ex.s.global_scale - require("src.model.Game"):instance():getNotchHeight()
    self.node_top:setPositionY(pos_y)

    self.node_rank:setPositionY(self:getBottomY())

    -- 放置npc区域
    pos_y = self.node_rank:getPositionY() + self.node_rank:getContentSize().height * self.node_rank:getScale()
    self.player_rect = cc.rect(0, pos_y, ex.p.width, self.node_top:getPositionY() - self.node_top:getContentSize().height * self.node_top:getScale() - pos_y)

    -- 添加npc父节点
    self.node_npc = cc.Node:create()
    self.node_npc:setPosition(self.player_rect.x, self.player_rect.y)
    self:addChild(self.node_npc)

    self.btn_back:registerScriptTapHandler(handler(self, self.onBack))
    self.scroll_view:setItemType(1)
    self.scroll_view:setCreateNum(4)
    local sv_width = self.spr_rank_scroll_view_bg:getContentSize().width - 10
    local sv_height = self.spr_rank_scroll_view_bg:getContentSize().height - 15
    self.scroll_view:setViewSize(cc.size(sv_width, sv_height))
    self.scroll_view:setItemSize(cc.size(self.scroll_view:getViewSize().width, 112))
    self:updateView()

    self:addEvent(EVENT.SPACE_TIME_MAGIC_TOWER.UPDATE_RANK, handler(self, self.updateView))
    NetManager:sendMessage(ProtocolID.GReqTimeTowerRankInfo)
end

function STMagicTowerRankLayer:updateView()
    local data = ex.Player.space_time_magic_tower_data
    if data.my_rank > 0 then
        self.lbl_my_rank:setString(string.format("%s第%s名", ex.Tools:getLang(5290), data.my_rank))
    else
        self.lbl_my_rank:setString(string.format("%s%s", ex.Tools:getLang(5290), ex.Tools:getLang(47749)))
    end

    self.lbl_my_mission:setString(string.format("%s：%s", ex.Tools:getLang(70401), string.format(ex.Tools:getLang(72045), data.mission_id)))
    local list = clone(data.rank_list)
    self:refreshNPC(list)
    self.scroll_view.createItemFunction = function(item_data, scale)
        local cell = STMagicTowerRankCell:createWithCCBIFile("ccbi/STMagicTowerRankCell.ccbi")
        cell:reset(item_data, self.scroll_view:getViewSize().width)
        cell.btn_role:registerScriptTapHandler(handler(self, self.onClickPlayer))
        return cell
    end
    if list and #list > 3 then
        table.remove(list, 1)
        table.remove(list, 1)
        table.remove(list, 1)
    end
    
    self.scroll_view:reloadData(list)
end

function STMagicTowerRankLayer:refreshNPC(list)
    self.node_npc:removeAllChildren()

    for i = 1, 3 do
        local seat_data = list[i]
        local seat = STMagicTowerSeat:createWithCCBIFile("ccbi/STMagicTowerSeat.ccbi")
        seat:setPosition(
            self.player_rect.width * SeatPosData[math.min(6, i)].fx - seat:getContentSize().width / 2,
            self.player_rect.height * SeatPosData[math.min(6, i)].fy - seat:getContentSize().height / 2
        )
        seat:setScale(SeatPosData[math.min(6, i)].fs)
        seat:setZOrder(100 - i)
        self.node_npc:addChild(seat)

        -- 设置cell
        seat:initDone(seat_data)
        seat.btn_base.data = seat_data or {}
        seat.btn_base:registerScriptTapHandler(handler(self, self.onClickPlayer))
        seat.btn_base:setEnabled(false)
    end
end

function STMagicTowerRankLayer:getBottomY()
    return ex.MainSceneCtr:getBottomHeight() + 10
end

function STMagicTowerRankLayer:onBack(tag, pSender)
    if not ex.MainSceneCtr:backLastLayer() then
        ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_SPACE_TIME_MAGIC_TOWER_MAIN)
    end
end

function STMagicTowerRankLayer:onClickPlayer(tag, pSender)
    -- ex.Tools:showPlayerInfo(pSender.data.player_id, pSender.data.server_id)
end


return STMagicTowerRankLayer
