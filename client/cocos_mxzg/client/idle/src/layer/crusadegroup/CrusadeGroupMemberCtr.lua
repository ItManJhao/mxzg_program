--[[
    讨伐团成员界面
    在讨伐团场景处调用
]]

local CrusadeGroupMemberCtr = class("CrusadeGroupMemberCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local CrusadeGroupMemberLayer = class("CrusadeGroupMemberLayer", require("src.comp.EventLayerAdaptiveWidth"))

local CrusadeGroupMemberCell = class("CrusadeGroupMemberCell", require("src.comp.LuaLayerBase"))

-----------------------------------------------------------------------------
function CrusadeGroupMemberCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end

function CrusadeGroupMemberCell:initData(data)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/crusade-group.plist")

    ex.Tools:setSpriteFrame(self.spr_nobility, "crusade-group/spr-nobility-"..data.knighthood_id..".png")
    self.lbl_nobility:setString(ex.Tools:getLang(cfg.crusadegroupoccupation.crusadegroupoccupation[data.knighthood_id].des))

    ex.Tools:setSpriteFrame(self.spr_member_photo, "head-icon/"..data.head_id..".png")
    ex.Tools:setSpriteFrame(self.spr_member_border, ex.Tools:getBorderIconByIdx(data.border_id))
    self.lbl_member_level:setString(data.level)

    self.lbl_member_name:setString(ex.StringUtil.getServerName(data.server_id)..data.nick)
    self.lbl_clan_name:setString(data.guild_name)

    local now = ex.Game:getServerTime()
    if data.last_offline_time <= 0 or data.last_offline_time > now then
        self.lbl_time:setString(ex.Tools:getLang(24))
    else
        self.lbl_time:setString(ex.StringUtil.convertToTimeFormat(data.last_offline_time - now, 6))
    end

    self.spr_group_pos:setVisible(data.position > 0)
    if data.position == 2 then
        ex.Tools:setSpriteFrame(self.spr_group_pos, "crusade-group/spr-pos-1.png")
    elseif data.position == 1 then
        ex.Tools:setSpriteFrame(self.spr_group_pos, "crusade-group/spr-pos-2.png")
    end
    self.lbl_attack:setString(data.fighting)
end

-----------------------------------------------------------------------------
function CrusadeGroupMemberLayer:onCreate()
    self:addBlackBackground()
    self:setAutoClose(true)
    self:setSwallowTouches(true)

    self.scroll_view:setItemSize(cc.size(560, 115))
    self.scroll_view:setItemType(1)

    self:addTimer("timer", 1000, handler(self, self.update), true)
    self:update(0)
end

function CrusadeGroupMemberLayer:update(dt)
    -- self.lbl_time:setString(ex.StringUtil.convertToTimeFormat(ctr.crusade_group.data.game_end_time - ex.Game:getServerTime()))
    if ctr.crusade_group.data.game_end_time > ex.Game:getServerTime() then
        self.lbl_time:setString(ex.StringUtil.convertToTimeFormat(ctr.crusade_group.data.game_end_time - ex.Game:getServerTime()))
    else
        self.lbl_time:setString(ex.Tools:getLang(32200))
    end

end

-----------------------------------------------------------------------------
function CrusadeGroupMemberCtr:onCreate()
    self:setCCBIPath("ccbi/CrusadeGroupMemberLayer.ccbi")
    self:setIsSingle(false)
end

function CrusadeGroupMemberCtr:getLayerClass()
    return CrusadeGroupMemberLayer
end

function CrusadeGroupMemberCtr:openWindow()
    if self:isOpened() then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/crusade-group.plist")
    sfc:addSpriteFrames("ccbi-res/super-hero.plist")

    self:loadLayer()
    self:open()
    self:initData()
end

function CrusadeGroupMemberCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_info:registerScriptTapHandler(handler(self, self.onInfo))
    self.layer.btn_rename:registerScriptTapHandler(handler(self, self.onGroupRename))

    self.layer:addEvent(EVENT.CRUSADE_GROUP.MEMBER, handler(self, self.updateLayer))
    self.layer:addEvent(EVENT.CRUSADE_GROUP.GROUP_RENAME, handler(self, self.groupRenameDone))

    self:updateLayer()

    -- 請求成員列表
    NetManager:sendMessage(ProtocolID.GReqGroupInfo)
end

function CrusadeGroupMemberCtr:updateLayer()
    local crusade_data = ctr.crusade_group.data.game_data
    local leader_data = ctr.crusade_group.data:getLeaderData() or {head_id = 1, border_id = 1, level = 1, clan_name = ""}

    -- 讨伐团信息
    ex.Tools:setSpriteFrame(self.layer.spr_group_icon, "clan-photo/"..crusade_data.crusade_group_info.group_badge_id..".png")
    self.layer.lbl_group_name:setString(string.format(ex.Tools:getLang(77701), crusade_data.crusade_group_info.group_name))
    self.layer.lbl_group_member_num:setString(string.format(ex.Tools:getLang(77703), #crusade_data.crusade_group_list))
    self.layer.btn_rename:setPositionX(self.layer.lbl_group_name:getPositionX() + self.layer.lbl_group_name:getContentSize().width * self.layer.lbl_group_name:getScaleX() + 30)
    self.layer.btn_rename:setVisible(leader_data ~= nil and leader_data.rid == ex.Player.role_id)

    -- 讨伐团团长信息
    ex.Tools:setSpriteFrame(self.layer.spr_leader_photo, "head-icon/"..leader_data.head_id..".png")
    ex.Tools:setSpriteFrame(self.layer.spr_leader_border, ex.Tools:getBorderIconByIdx(leader_data.border_id))
    self.layer.lbl_leader_name:setString(ex.StringUtil.getServerName(leader_data.server_id)..leader_data.nick)
    self.layer.lbl_leader_level:setString(leader_data.level)
    self.layer.lbl_clan_name:setString(leader_data.guild_name)
    self.layer.lbl_attack:setString(leader_data.fighting)

    -- 讨伐团成员信息
    self:updateScrollView()
end

function CrusadeGroupMemberCtr:updateScrollView()
    self.layer.scroll_view:getContainer():removeAllChildren()
    self.layer.scroll_view.createItemFunction = function(data)
        -- 创建ccbi cell
        local cell = CrusadeGroupMemberCell:createWithCCBIFile("ccbi/CrusadeGroupMemberCell.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(0.5, 0.5)
    
        cell:initData(data)
    
        return cell
    end

    table.sort(ctr.crusade_group.data.game_data.crusade_group_list, function(a, b)
        return a.position > b.position
    end)
    self.layer.scroll_view:reloadData(ctr.crusade_group.data.game_data.crusade_group_list)
end

-- 功能说明
function CrusadeGroupMemberCtr:onInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42104), ex.Tools:getLang(42105))
end

-- 討伐團改名
function CrusadeGroupMemberCtr:onGroupRename(tag, pSender)
    -- 只可以改名一次
    if ctr.crusade_group.data.game_data.crusade_group_info.rename_number >= 1 then
        ex.MessageView:add(ex.Tools:getLang(77748))
        return
    end

    -- 只有團長才能改名
    local leader_data = ctr.crusade_group.data:getLeaderData()
    if leader_data == nil or leader_data.rid ~= ex.Player.role_id then
        -- ex.MessageView:add(ex.Tools:getLang(77748))
        return
    end

    require("src.layer.crusadegroup.CrusadeGroupRenameCtr"):instance():openWindow()
end

-- 討伐團改名成功，刷新名字
function CrusadeGroupMemberCtr:groupRenameDone(event)
    self.layer.lbl_group_name:setString(string.format(ex.Tools:getLang(77701), ctr.crusade_group.data.game_data.crusade_group_info.group_name))
    self.layer.btn_rename:setPositionX(self.layer.lbl_group_name:getPositionX() + self.layer.lbl_group_name:getContentSize().width * self.layer.lbl_group_name:getScaleX() + 30)
end

return CrusadeGroupMemberCtr
