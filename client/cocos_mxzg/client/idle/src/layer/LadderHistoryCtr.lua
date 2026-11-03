local LadderHistoryCtr = class("LadderHistoryCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local LadderHistoryLayer = class("LadderHistoryLayer", require("src.comp.EventLayerAdaptiveWidth"))

local LadderHistoryMyCell = class("LadderHistoryMyCell", require("src.comp.LuaLayerBase"))
local LadderHistoryHighCell = class("LadderHistoryHighCell", require("src.comp.LuaLayerBase"))

local LadderHistoryType = {}
LadderHistoryType.MY = 1
LadderHistoryType.HIGH = 1

function LadderHistoryMyCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.btn_share:setVisible(false)

    self.menu:setSwallowsTouches(true)
    self.btn_photo:setContentSize(self.spr_photo:getContentSize())

    self.btn_share:registerScriptTapHandler(handler(self, self.onShare))
end

function LadderHistoryMyCell:onShare(tag,pSender)
    local pos = {}
    local x,y = pSender:getPosition()
	local world_pos = pSender:getParent():convertToWorldSpace(cc.p(x,y)) -- pSender:convertToWorldSpace(cc.p(x,y)) -- pSender:getPosition()
	pos.x = world_pos.x - pSender:getContentSize().width / 2
    pos.y = world_pos.y - pSender:getContentSize().height / 2
	local ctr = require("src.layer.heroinfo.HeroShareMenuCtr"):instance()--:openWindow(pos)
	local callback = handler(self,self.onShareMenuClick)
	ctr:openWindow(callback)
    -- ctr.layer:setPosition(pos.x,pos.y)
	local pos_x = pos.x - ctr.layer:getContentSize().width
    local pos_y = pos.y - ctr.layer:getContentSize().height / 2 + pSender:getContentSize().height / 2
    ctr.layer:setPosition(pos_x,pos_y)
end

function LadderHistoryMyCell:onShareMenuClick(tag,pSender)
    
end

function LadderHistoryMyCell:initData(data)
    self.data = data
    self.btn_photo.role_id = data.defend_info.rid
    self.btn_photo.server_id = data.defend_info.server_id
    self.btn_report.battle_id = data.battle_id

    self.spr_photo:setSpriteFrame(string.format("head-icon/%d.png", data.defend_info.head_id))
    self.spr_frame:setSpriteFrame(ex.Tools:getBorderIconByIdx(data.defend_info.border_id))
    self.lbl_name:setString(data.defend_info.nick)
    self.lbl_level:setString(data.defend_info.level)
    self.lbl_server_name:setString(ex.StringUtil.getServerName(data.defend_info.server_id))
    self.lbl_fighting:setString(data.defend_info.fight)

    if data.battle_type == 1 then
        if data.is_win > 0 then
            -- self.spr_result:setSpriteFrame("fantasy-land-lang/vs-success.png")
            ex.Tools:setSpriteFrame(self.spr_result, "fantasy-land-lang/vs-success.png")
        else
            -- self.spr_result:setSpriteFrame("fantasy-land-lang/vs-failure.png")
            ex.Tools:setSpriteFrame(self.spr_result, "fantasy-land-lang/vs-failure.png")
        end
    else
        if data.is_win > 0 then
            -- self.spr_result:setSpriteFrame("fantasy-land-lang/defend-success.png")
            ex.Tools:setSpriteFrame(self.spr_result, "fantasy-land-lang/defend-success.png")
        else
            -- self.spr_result:setSpriteFrame("fantasy-land-lang/defend-failure.png")
            ex.Tools:setSpriteFrame(self.spr_result, "fantasy-land-lang/defend-failure.png")
        end
    end

    self.spr_cell_bg:setVisible(data.is_win > 0)
    self.lbl_time:setString(os.date("%Y-%m-%d %H:%M:%S", data.battle_time))
    if data.old_rank <= 0 or data.new_rank < data.old_rank then
        self.lbl_point:setString(ex.Tools:getLang(47424)..data.new_rank..ex.Tools:getLang(47373))
    elseif data.new_rank == data.old_rank then
        self.lbl_point:setString(ex.Tools:getLang(47360))
    else
        self.lbl_point:setString(ex.Tools:getLang(47379)..data.new_rank..ex.Tools:getLang(47373))
    end
end

function LadderHistoryHighCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.menu:setSwallowsTouches(true)
    self.btn_photo_1:setContentSize(self.spr_photo_1:getContentSize())
    self.btn_photo_2:setContentSize(self.spr_photo_2:getContentSize())
end

function LadderHistoryHighCell:initData(data)
    self.data = data
    self.btn_photo_1.role_id = data.attack_info.rid
    self.btn_photo_1.server_id = data.attack_info.server_id
    self.btn_report.battle_id = data.battle_id

    self.spr_photo_1:setSpriteFrame(string.format("head-icon/%d.png", data.attack_info.head_id))
    self.spr_frame_1:setSpriteFrame(ex.Tools:getBorderIconByIdx(data.attack_info.border_id))
    self.lbl_name_1:setString(data.attack_info.nick)
    self.lbl_server_name_1:setString(ex.StringUtil.getServerName(data.attack_info.server_id))
    self.lbl_rank_1:setString(tostring(data.attack_info.ladder_rank))

    self.btn_photo_2.role_id = data.defend_info.rid
    self.btn_photo_2.server_id = data.defend_info.server_id

    self.spr_photo_2:setSpriteFrame(string.format("head-icon/%d.png", data.defend_info.head_id))
    self.spr_frame_2:setSpriteFrame(ex.Tools:getBorderIconByIdx(data.defend_info.border_id))
    self.lbl_name_2:setString(data.defend_info.nick)
    self.lbl_server_name_2:setString(ex.StringUtil.getServerName(data.defend_info.server_id))
    self.lbl_rank_2:setString(tostring(data.defend_info.ladder_rank))

    self.spr_win_1:setVisible(data.win_team == data.attack_info.rid)
    self.spr_win_2:setVisible(data.win_team == data.defend_info.rid)

    self.lbl_time:setString(os.date("%Y-%m-%d %H:%M:%S", data.battle_time))
end

function LadderHistoryLayer:onCreate()
    self:setAutoClose(true)
    self:setSwallowTouches(true)
    self:addBlackBackground()

    self.btn_tab_1:setChecked(true)
    self.btn_tab_1:setTag(1)
    self.btn_tab_2:setTag(2)

    self.btn_tab_1:setLabelText(ex.Tools:getLang(5106))
    self.btn_tab_2:setLabelText(ex.Tools:getLang(5056))


    self.scroll_view:setItemSize(cc.size(self.scroll_view:getViewSize().width, 155))
    self.scroll_view:setItemType(1)
    self.scroll_view:setCreateNum(2)



end

-----------------------------------------------------------------------------
function LadderHistoryCtr:onCreate()
    self:setCCBIPath("ccbi/LadderHistoryLayer.ccbi")
    self:setIsSingle(false)
end

function LadderHistoryCtr:getLayerClass()
    return LadderHistoryLayer
end

function LadderHistoryCtr:getLadderHistoryLayer()
    return self.layer
end

function LadderHistoryCtr:openWindow()
    if self:isOpened() then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/clan.plist")
    sfc:addSpriteFrames("ccbi-res/clan-boss.plist")

    self:loadLayer()
    self:open()
    self:initData()
end

function LadderHistoryCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_tab_1:registerScriptTapHandler(handler(self, self.onTab))
    self.layer.btn_tab_2:registerScriptTapHandler(handler(self, self.onTab))

    self.layer:addRedDotNode(RedDotType.ZCJ_DHZC_KFSK_TTZB_ZB_WDJL, self.layer.btn_tab_1)

    self.layer_type = LadderHistoryType.MY

	-- 跨服天梯战报
    NetManager:sendMessage(ProtocolID.GReqMyLadderBattleRecord)
	NetManager:sendMessage(ProtocolID.GReqHighLadderBattleRecord)
	
    self:updateTableView()
end

function LadderHistoryCtr:updateLayer(layer_type)
    if self.layer == nil then
        return
    end

    if layer_type == self.layer_type then
        self:updateTableView()
    end
end

function LadderHistoryCtr:onTab(tag, pSender)
    if pSender:getTag() <= 0 or self.layer_type == pSender:getTag() then
        return
    end

    self.layer_type = pSender:getTag()

    self:updateTableView()
end

function LadderHistoryCtr:updateTableView()
    if self.layer_type == LadderHistoryType.MY then
        -- 发送已读协议请求
        NetManager:sendMessage(ProtocolID.GReqLadderReadReport)

        self.layer.node_title:setVisible(true)
        self.layer.scroll_view:setViewSize(cc.size(550, 600))

        self.layer.scroll_view.createItemFunction = function(data, scale)
            -- 创建ccbi cell
            local cell_rank = LadderHistoryMyCell:createWithCCBIFile("ccbi/LadderHistoryMyCell.ccbi")
            cell_rank:setIgnoreAnchorPointForPosition(false)
            cell_rank:setAnchorPoint(0.5, 0.5)
    
            cell_rank:initData(data)
            cell_rank.menu:setIsTouchInsideNode(self.layer.scroll_view)
            cell_rank.btn_photo:registerScriptTapHandler(handler(self, self.onPlayerInfo))
            cell_rank.btn_report:registerScriptTapHandler(handler(self, self.onRecord))
            return cell_rank
        end

        self.layer.scroll_view:reloadData(ex.Player.league_data.history_my)
    else
        self.layer.node_title:setVisible(false)
        self.layer.scroll_view:setViewSize(cc.size(550, 650))

        self.layer.scroll_view.createItemFunction = function(data, scale)
            -- 创建ccbi cell
            local cell_rank = LadderHistoryHighCell:createWithCCBIFile("ccbi/LadderHistoryHighCell.ccbi")
            cell_rank:setIgnoreAnchorPointForPosition(false)
            cell_rank:setAnchorPoint(0.5, 0.5)
    
            cell_rank:initData(data)
            cell_rank.menu:setIsTouchInsideNode(self.layer.scroll_view)

            cell_rank.btn_photo_1:registerScriptTapHandler(handler(self, self.onPlayerInfo))
            cell_rank.btn_photo_2:registerScriptTapHandler(handler(self, self.onPlayerInfo))
            cell_rank.btn_report:registerScriptTapHandler(handler(self, self.onRecord))
            return cell_rank
        end

        self.layer.scroll_view:reloadData(ex.Player.league_data.history_high)
    end

    
end

-- 查看角色信息
function LadderHistoryCtr:onPlayerInfo(tag, pSender)
    ex.Tools:showPlayerInfo(pSender.role_id, pSender.server_id)
end

-- 开始挑战
function LadderHistoryCtr:onRecord(tag, pSender)
    ex.EventManager:fire(EVENT.LADDER_EVENT.BATTLE_HISTORY_ON_REPORT, pSender.battle_id)

    self:closeWindow(0, nil)
end

return LadderHistoryCtr
