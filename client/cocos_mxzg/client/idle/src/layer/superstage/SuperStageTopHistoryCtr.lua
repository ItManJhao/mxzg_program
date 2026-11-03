local SuperStageTopHistoryCtr = class("SuperStageTopHistoryCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local SuperStageTopHistoryLayer = class("SuperStageTopHistoryLayer", require("src.comp.EventLayerAdaptiveWidth"))

local SuperStageTopHistoryMyCell = class("SuperStageTopHistoryMyCell", require("src.comp.EventLayer"))
local SuperStageTopHistoryHighCell = class("SuperStageTopHistoryHighCell", require("src.comp.EventLayer"))

local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

-----------------------------------------------------------------------------
function SuperStageTopHistoryMyCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.btn_share:setVisible(false)

    self.menu:setSwallowsTouches(true)
    self.btn_photo:setContentSize(self.spr_photo:getContentSize())

    self.btn_share:registerScriptTapHandler(handler(self, self.onShare))
end

function SuperStageTopHistoryMyCell:onShare(tag,pSender)
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

function SuperStageTopHistoryMyCell:onShareMenuClick(tag,pSender)
    
end

function SuperStageTopHistoryMyCell:initData(data)
    self.data = data
    self.btn_photo.role_id = data.rid
    self.btn_photo.server_id = data.server_id
    self.btn_report.battle_id = data.battle_id

    self.spr_photo:setSpriteFrame(string.format("head-icon/%d.png", data.head_id))
    self.spr_frame:setSpriteFrame(ex.Tools:getBorderIconByIdx(data.border_id))
    self.lbl_name:setString(data.name)
    self.lbl_level:setString(data.level)
    self.lbl_server_name:setString((data.server_id ~= nil and data.server_id > 0) and ex.StringUtil.getServerName(data.server_id) or ex.Tools:getLang(76061))
    self.lbl_fighting:setString(data.fighting)

    if data.attack then
        if data.win then
            -- self.spr_result:setSpriteFrame("fantasy-land-lang/vs-success.png")
            ex.Tools:setSpriteFrame(self.spr_result, "fantasy-land-lang/vs-success.png")
        else
            -- self.spr_result:setSpriteFrame("fantasy-land-lang/vs-failure.png")
            ex.Tools:setSpriteFrame(self.spr_result, "fantasy-land-lang/vs-failure.png")
        end
    else
        if data.win then
            -- self.spr_result:setSpriteFrame("fantasy-land-lang/defend-success.png")
            ex.Tools:setSpriteFrame(self.spr_result, "fantasy-land-lang/defend-success.png")
        else
            -- self.spr_result:setSpriteFrame("fantasy-land-lang/defend-failure.png")
            ex.Tools:setSpriteFrame(self.spr_result, "fantasy-land-lang/defend-failure.png")
        end
    end

    self.spr_cell_bg:setVisible(data.win)
    self.lbl_time:setString(os.date("%Y-%m-%d %H:%M:%S", data.battle_time))

    if data.old_rank == data.rank then
        self.lbl_point:setString(ex.Tools:getLang(47360))
    elseif data.rank > 0 and (data.old_rank <= 0 or data.old_rank > data.rank) then
        self.lbl_point:setString(ex.Tools:getLang(47424)..data.rank..ex.Tools:getLang(47373))
    else
        self.lbl_point:setString(ex.Tools:getLang(47379)..data.rank..ex.Tools:getLang(47373))
    end
end

-----------------------------------------------------------------------------
function SuperStageTopHistoryHighCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.menu:setSwallowsTouches(true)
    self.btn_photo_1:setContentSize(self.spr_photo_1:getContentSize())
    self.btn_photo_2:setContentSize(self.spr_photo_2:getContentSize())
end

function SuperStageTopHistoryHighCell:initData(data)
    self.data = data
    self.btn_photo_1.role_id = data.attacker_rid
    self.btn_photo_1.server_id = data.attacker_server_id
    self.btn_report.battle_id = data.battle_id

    self.spr_photo_1:setSpriteFrame(string.format("head-icon/%d.png", data.attacker_head_id))
    self.spr_frame_1:setSpriteFrame(ex.Tools:getBorderIconByIdx(data.attacker_border_id))
    self.lbl_name_1:setString(data.attacker_name)
    self.lbl_server_name_1:setString(ex.StringUtil.getServerName(data.attacker_server_id))
    self.lbl_rank_1:setString(data.attacker_rank > 0 and tostring(data.attacker_rank) or "1000+")

    self.btn_photo_2.role_id = data.defender_rid
    self.btn_photo_2.server_id = data.defender_server_id

    self.spr_photo_2:setSpriteFrame(string.format("head-icon/%d.png", data.defender_head_id))
    self.spr_frame_2:setSpriteFrame(ex.Tools:getBorderIconByIdx(data.defender_border_id))
    self.lbl_name_2:setString(data.defender_name)
    self.lbl_server_name_2:setString(ex.StringUtil.getServerName(data.defender_server_id))
    self.lbl_rank_2:setString(data.defender_rank > 0 and tostring(data.defender_rank) or "1000+")

    self.spr_win_1:setVisible(data.win)
    self.spr_win_2:setVisible(not data.win)

    self.lbl_time:setString(os.date("%Y-%m-%d %H:%M:%S", data.battle_time))
end

-----------------------------------------------------------------------------
function SuperStageTopHistoryLayer:onCreate()
    self:addBlackBackground()
    self.scroll_view:setItemType(1)
    self.scroll_view:setItemSize(cc.size(self.scroll_view:getViewSize().width, 155))

    self.btn_tab_1:setLabelText(ex.Tools:getLang(5643))
    self.btn_tab_2:setLabelText(ex.Tools:getLang(5056))
end

-----------------------------------------------------------------------------
function SuperStageTopHistoryCtr:onCreate()
    self:setCCBIPath("ccbi/SuperStageTopHistoryLayer.ccbi")
    self:setIsSingle(false)
end

function SuperStageTopHistoryCtr:getLayerClass()
    return SuperStageTopHistoryLayer
end

function SuperStageTopHistoryCtr:openWindow(callback_change_tab_req, callback_data, str_tip_title, str_tip)
    if self:isOpened() then
        return
    end

    self.callback_change_tab_req = callback_change_tab_req
    self.callback_data = callback_data
    self.str_tip_title = str_tip_title
    self.str_tip = str_tip

    self:loadLayer()
    self:open()
    self:initData()
end

function SuperStageTopHistoryCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    
    self.layer.btn_tab_1:registerScriptTapHandler(handler(self, self.onTab))
    self.layer.btn_tab_2:registerScriptTapHandler(handler(self, self.onTab))

    self.layer:addEvent(EVENT.SUPER_STAGE.TOP_BATTLE_LOG, handler(self, self.updateLayer))
    self.layer:addEvent(EVENT.SUPER_STAGE.TOP_SUPER_BATTLE_LOG, handler(self, self.updateLayer))

    local stage_id = ex.Player.super_stage_data.cur_stage_id
    local config_stage = cfg.superstage.superstage[stage_id > 0 and stage_id or 1]
    self.layer.lbl_my_stage_title:setString(self.str_tip_title)
    self.layer.lbl_my_stage:setString(self.str_tip)

    self.select_type = 0
    self:onTab(1)
end

function SuperStageTopHistoryCtr:onTab(tag, pSender)
    if self.select_type == tag then
        return
    end
    self.select_type = tag

    self.callback_change_tab_req(self.select_type)

    self:updateLayer()
end

function SuperStageTopHistoryCtr:updateLayer()
    self.layer.btn_tab_1:setChecked(self.select_type == 1)
    self.layer.btn_tab_2:setChecked(self.select_type == 2)

    self.layer.lbl_my_stage_title:setVisible(self.select_type == 1)
    self.layer.lbl_my_stage:setVisible(self.select_type == 1)

    -- 判断类型读取对应的记录
    local video_data = self.callback_data(self.select_type)

    if self.select_type == 1 then
        self.layer.scroll_view.createItemFunction = function(data, scale)
            -- 创建ccbi cell
            local cell_rank = SuperStageTopHistoryMyCell:createWithCCBIFile("ccbi/SuperStageTopHistoryMyCell.ccbi")
            cell_rank:setIgnoreAnchorPointForPosition(false)
            cell_rank:setAnchorPoint(0.5, 0.5)
    
            cell_rank:initData(data)
            cell_rank.menu:setIsTouchInsideNode(self.layer.scroll_view)
            cell_rank.btn_photo:registerScriptTapHandler(handler(self, self.onPlayerInfo))
            cell_rank.btn_report:registerScriptTapHandler(handler(self, self.onRecord))
            return cell_rank
        end
    else
        self.layer.scroll_view.createItemFunction = function(data, scale)
            -- 创建ccbi cell
            local cell_rank = SuperStageTopHistoryHighCell:createWithCCBIFile("ccbi/SuperStageTopHistoryHighCell.ccbi")
            cell_rank:setIgnoreAnchorPointForPosition(false)
            cell_rank:setAnchorPoint(0.5, 0.5)
    
            cell_rank:initData(data)
            cell_rank.menu:setIsTouchInsideNode(self.layer.scroll_view)

            cell_rank.btn_photo_1:registerScriptTapHandler(handler(self, self.onPlayerInfo))
            cell_rank.btn_photo_2:registerScriptTapHandler(handler(self, self.onPlayerInfo))
            cell_rank.btn_report:registerScriptTapHandler(handler(self, self.onRecord))
            return cell_rank
        end
    end
    self.layer.scroll_view:reloadData(video_data)
end

-- 查看角色信息
function SuperStageTopHistoryCtr:onPlayerInfo(tag, pSender)
    ex.Tools:showPlayerInfo(pSender.role_id, pSender.server_id)
end

-- 开始挑战
function SuperStageTopHistoryCtr:onRecord(tag, pSender)
    ex.EventManager:fire(EVENT.VIDEO_STUDIO_EVENT.VIDEO_PLAY_BACK_REQ, {battle_id = pSender.battle_id, type = EVENT.SUPER_STAGE.BATTLE})

    self:closeWindow(0, nil)
end

return SuperStageTopHistoryCtr
