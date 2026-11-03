local ClanRankCtr = class("ClanRankCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ClanRankLayer = class("ClanRankLayer", require("src.comp.EventLayerAdaptiveWidth"))

local ClanApplyCell = class("ClanApplyCell", require("src.comp.LuaLayerBase"))
function ClanApplyCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.menu:setSwallowsTouches(false)
    self.btn_photo:setContentSize(self.spr_photo:getContentSize())
end

function ClanApplyCell:initData(data)
    -- 设置排名显示
    if self.spr_rank ~= nil then
        self.spr_rank:setVisible(false)
        self.lbl_rank:setVisible(true)
        self.lbl_rank:enableShadow(FONT_BLACK_C4B, cc.size(1, -1))
        if data.rank > 0 and data.rank < 4 then 
            self.spr_rank:setVisible(true)
            self.lbl_rank:setVisible(false)
            -- self.spr_rank:setSpriteFrame(string.format("rank/spr-paihang-%s.png", data.rank))
            ex.Tools:setSpriteFrame(self.spr_rank, string.format("rank/spr-paihang-%s.png", data.rank))
        end
        self.lbl_rank:setString(string.format("%d", data.rank))
    end
    
    self.spr_photo:setSpriteFrame(string.format("head-icon/%d.png", data.photo))
    self.spr_frame:setSpriteFrame(ex.Tools:getBorderIconByIdx(data.border_id))
    self.lbl_name:setString(data.nick)
    self.lbl_level:setString(ex.Tools:getLang(5453).." "..data.level)
    self.lbl_num:setString(ex.Tools:getLang(52204).." "..data.damage)
end

function ClanRankLayer:onCreate()
    self:setAutoClose(true)
    self:setSwallowTouches(true)
    self:addBlackBackground()

    self.table_view = nil
end

-- 公会排行类型枚举
ClanRankLayerType = {}
ClanRankLayerType.INVALID = 0   -- 无效
ClanRankLayerType.APPLY = 4     -- 公会申请列表

-----------------------------------------------------------------------------
function ClanRankCtr:onCreate()
    self:setCCBIPath("ccbi/ClanRankLayer.ccbi")
    self:setIsSingle(false)

    self.clan_apply_list_count = 0
    self.clan_apply_list = {}
end

function ClanRankCtr:getLayerClass()
    return ClanRankLayer
end

function ClanRankCtr:getClanRankLayer()
    return self.layer
end

function ClanRankCtr:openWindow(layer_type)
    if self:isOpened() then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/clan.plist")
    sfc:addSpriteFrames("ccbi-res/rank.plist")
    sfc:addSpriteFrames("ccbi-res/clan-photo.plist")

    self.layer_type = layer_type

    self:loadLayer()
    self:open()
    self:initData()
end

function ClanRankCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    self:registerEvent()

    print("clan rank tab", self.layer_type)

    if self.layer_type == ClanRankLayerType.APPLY then
        self.layer.lbl_title:setString(ex.Tools:getLang(47119))
    end

    self.clan_apply_list_count = 0
    self.clan_apply_list = {}

    if self.layer_type == ClanRankLayerType.APPLY then
        NetManager:sendMessage(ProtocolID.GResClanReqMsgInfo)
    end

    self:updateTableView()
end

function ClanRankCtr:registerEvent()
   self.layer:addEvent(EVENT.CLAN_EVENT.CLAN_RANK_APPLY, handler(self, self.receiveRes))
end

function ClanRankCtr:updateTableView()
    -- 初始化tableview
    if self.layer_type == ClanRankLayerType.APPLY then
        self.layer.scroll_view:setItemSize(cc.size(self.layer.scroll_view:getViewSize().width, 105))
        self.layer.scroll_view:setItemType(1)
        self.layer.scroll_view.createItemFunction = function(data, scale)
            -- 创建ccbi cell
            local cell_rank = ClanApplyCell:createWithCCBIFile("ccbi/ClanApplyCell.ccbi")
            cell_rank:setIgnoreAnchorPointForPosition(false)
            cell_rank:setAnchorPoint(0.5, 0.5)
    
            cell_rank:initData(data)
    
            cell_rank.menu:setIsTouchInsideNode(self.layer.scroll_view)

            cell_rank.btn_photo.role_id = data.role_id
            cell_rank.btn_photo:registerScriptTapHandler(handler(self, self.onPlayerInfo))
            cell_rank.btn_agree.role_id = data.role_id
            cell_rank.btn_agree:registerScriptTapHandler(handler(self, self.onApplyAgree))
            cell_rank.btn_ignor.role_id = data.role_id
            cell_rank.btn_ignor:registerScriptTapHandler(handler(self, self.onApplyIgnor))
            return cell_rank
        end
    
        self.layer.scroll_view:reloadData(self.clan_apply_list)
    end
end

-- 查看角色信息
function ClanRankCtr:onPlayerInfo(tag, pSender)
    ex.Tools:showPlayerInfo(pSender.role_id, cc.UserDefault:getInstance():getIntegerForKey("server_id"))
end

function ClanRankCtr:onApplyAgree(tag, pSender)
    local data_self = ex.Player.clan_data:getMemberByRoleId(ex.Player.role_id)
    if data_self == nil or data_self.position == ClanPositionType.NORMAL then
        ex.MessageView:add(ex.Tools:getLang(47642))
        return
    end

    local num_max = cfg.clanlevel.clanlevel[ex.Player.clan_data.clan_level].member
    local num_cur = #ex.Player.clan_data.clan_member_list
    if num_cur >= num_max then
        ex.MessageView:add(ex.Tools:getLang(47039))
        return
    end

    local req_agree = Clan_pb.GReqClanReqAgree()
    req_agree.member_id = pSender.role_id
    req_agree.agree_status = 1
    NetManager:sendMessage(ProtocolID.GReqClanReqAgree, req_agree)

    NetManager:sendMessage(ProtocolID.GReqClanInfo)

    NetManager:sendMessage(ProtocolID.GResClanReqMsgInfo)
end

function ClanRankCtr:onApplyIgnor(tag, pSender)
    local data_self = ex.Player.clan_data:getMemberByRoleId(ex.Player.role_id)
    if data_self == nil or data_self.position == ClanPositionType.NORMAL then
        ex.MessageView:add(ex.Tools:getLang(47642))
        return
    end

    local req_agree = Clan_pb.GReqClanReqAgree()
    req_agree.member_id = pSender.role_id
    req_agree.agree_status = 0
    NetManager:sendMessage(ProtocolID.GReqClanReqAgree, req_agree)

    NetManager:sendMessage(ProtocolID.GReqClanInfo)

    NetManager:sendMessage(ProtocolID.GResClanReqMsgInfo)
end

function ClanRankCtr:receiveRes(event, list)
    if self.layer_type == ClanRankLayerType.APPLY and event == EVENT.CLAN_EVENT.CLAN_RANK_APPLY then
        self.clan_apply_list = list
    end
    self:updateTableView()
end

function ClanRankCtr:tableCellTouched(view, cell)

end

return ClanRankCtr
