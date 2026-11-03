local ClanPosHandlerCtr = class("ClanPosHandlerCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ClanPosHandlerLayer = class("ClanPosHandlerLayer", require("src.comp.EventLayerAdaptiveWidth"))

local btn_tab_list = {
	{idx = 1, note = "查看", label = 47407, item = "button/btn-orange-big-1.png", outline = cc.c4b(131,43,22,255), tag = 1, condition = ""},
	{idx = 2, note = "退出公会", label = 47640, item = "button/btn-green-big-1.png", outline = cc.c4b(13,91,45,255), tag = 2, condition = ""},
	{idx = 3, note = "踢除公会", label = 47436, item = "button/btn-green-big-1.png", outline = cc.c4b(13,91,45,255), tag = 3, condition = ""},
	{idx = 4, note = "设为会长", label = 47338, item = "button/btn-orange-big-1.png", outline = cc.c4b(131,43,22,255), tag = 4, condition = ""},
	{idx = 5, note = "升为副会长", label = 47770, item = "button/btn-orange-big-1.png", outline = cc.c4b(131,43,22,255), tag = 5, condition = ""},
	{idx = 6, note = "降为成员", label = 47656, item = "button/btn-orange-big-1.png", outline = cc.c4b(131,43,22,255), tag = 6, condition = ""},
}

function ClanPosHandlerLayer:onCreate()
    self:setAutoClose(true)
    self:setSwallowTouches(true)
    self:addBlackBackground()
end

-----------------------------------------------------------------------------
function ClanPosHandlerCtr:onCreate()
    self:setCCBIPath("ccbi/ClanPosHandlerLayer.ccbi")
    self:setIsSingle(false)
end

function ClanPosHandlerCtr:getLayerClass()
    return ClanPosHandlerLayer
end

function ClanPosHandlerCtr:openWindow(role_id)
    if self:isOpened() then
        return
    end

    self.data_member = ex.Player.clan_data:getMemberByRoleId(role_id)
    if self.data_member == nil then
        return
    end

    self.data_self = ex.Player.clan_data:getMemberByRoleId(ex.Player.role_id)
    if self.data_self == nil then
        return
    end

    self:loadLayer()
    self:open()
    self:initData()
end

function ClanPosHandlerCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    self:updateLayer()
end

function ClanPosHandlerCtr:updateLayer()
    self.layer.lbl_tip:setString(string.format(ex.Tools:getLang(47839), self.data_member.nick))

    local vec_item = {}
    -- 查看
    if self.data_member.rid == self.data_self.rid then
        table.insert(vec_item, 2)
    elseif self.data_member.position == ClanPositionType.VICE_HEAD then
        table.insert(vec_item, 1)
        if self.data_self.position == ClanPositionType.HEAD then
            table.insert(vec_item, 4)
            table.insert(vec_item, 6)
        end
    elseif self.data_member.position == ClanPositionType.NORMAL then
        table.insert(vec_item, 1)
        if self.data_self.position == ClanPositionType.HEAD then
            table.insert(vec_item, 5)
            table.insert(vec_item, 3)
        elseif self.data_self.position == ClanPositionType.VICE_HEAD then
            -- table.insert(vec_item, 5)
            table.insert(vec_item, 3)
        end
    else 
        table.insert(vec_item, 1)
    end

    local num = #vec_item
    for i,v in ipairs(vec_item) do
        local data = btn_tab_list[v]
        local item = cpp.UIMenuItemLabel:create(data.item, nil, ex.Tools:getLang(data.label), nil)
        item:setPosition(0, (num / 2 - i + 0.5) * 60)
        item:setLabelColor(cc.c3b(255, 255, 255))
        item:setLabelSize(40)
        item:setLabelOutLine(data.outline, 4)
        self.layer.menu_handle:addChild(item, 0, 999)

        item:setTag(data.tag)

        item:registerScriptTapHandler(handler(self, self.onHandle))
    end
end

function ClanPosHandlerCtr:onHandle(tag, pSender)
    if tag == 1 then
        ex.Tools:showPlayerInfo(self.data_member.rid, cc.UserDefault:getInstance():getIntegerForKey("server_id"))
    elseif tag == 2 then
        ex.ConfirmCtr:openWindow(ex.Tools:getLang(47640), ex.Tools:getLang(47318), function()
            NetManager:sendMessage(ProtocolID.GReqClanQuit)
        end)
    elseif tag == 3 then
        local req_change_pos = Clan_pb.GReqClanChangePos()
        req_change_pos.member_id = self.data_member.rid
        req_change_pos.type = 2               -- 踢出公会
        NetManager:sendMessage(ProtocolID.GReqClanChangePos, req_change_pos)
    elseif tag == 4 then
        local req_change_pos = Clan_pb.GReqClanChangePos()
        req_change_pos.member_id = self.data_member.rid
        req_change_pos.type = 1               -- 设为会长
        NetManager:sendMessage(ProtocolID.GReqClanChangePos, req_change_pos)
    elseif tag == 5 then
        local req_change_pos = Clan_pb.GReqClanChangePos()
        req_change_pos.member_id = self.data_member.rid
        req_change_pos.type = 1               -- 升职
        NetManager:sendMessage(ProtocolID.GReqClanChangePos, req_change_pos)
    elseif tag == 6 then
        local req_change_pos = Clan_pb.GReqClanChangePos()
        req_change_pos.member_id = self.data_member.rid
        req_change_pos.type = 0               -- 降职
        NetManager:sendMessage(ProtocolID.GReqClanChangePos, req_change_pos)
    end
    
    -- 请求历史
    NetManager:sendMessage(ProtocolID.GResClanReqMsgInfo)

    self:closeWindow()
end

return ClanPosHandlerCtr
