local ClanMemberCtr = class("ClanMemberCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ClanMemberLayer = class("ClanMemberLayer", require("src.comp.EventLayerAdaptiveWidth"))

local ClanMemberCell = class("ClanMemberCell", require("src.comp.LuaLayerBase"))
function ClanMemberCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

end

function ClanMemberCell:initData(data)
    self.data = data

    if data.rid == ex.Player.role_id then
        data.photo = ex.Player.head_id
        data.border_id = ex.Player.border_id

        self.spr_cell_bg:setVisible(false)
    end
    if data.photo ~= nil then
        self.spr_head:setSpriteFrame(string.format("head-icon/%d.png", data.photo))
    end

    self.spr_frame:setSpriteFrame(ex.Tools:getBorderIconByIdx(data.border_id))

    self.lbl_nick:setString(data.nick)
    self.lbl_level:setString(string.format("%d", data.level))
    self.lbl_pos:setString(string.format(ex.Tools:getLang(47298), ex.Player.clan_data:getPosStringWithPos(data.position)))
    self.lbl_damage:setString(string.format(ex.Tools:getLang(47505), data.damage))
    self.lbl_donate_total:setString(string.format(ex.Tools:getLang(47840), data.total_donate))
    self.lbl_donate_today:setString(string.format(ex.Tools:getLang(47841), data.today_donate))

    if data.online_status == 0 then 
        local server_time = cpp.Game:instance():getServerTime()
        local offline_time = data.offline_time
        local remain = server_time - offline_time
        local str = ex.Tools:convertTimeInfo(remain)
        self.lbl_statue:setString(str)
    else
        self.lbl_statue:setString(ex.Tools:getLang(41172))
    end
end

-----------------------------------------------------------------------------
function ClanMemberLayer:onCreate()
    self:setAutoClose(true)
    self:setSwallowTouches(true)
    self:addBlackBackground()

    self.scroll_view:setItemSize(cc.size(550, 135))
    self.scroll_view:setItemType(1)

    self.btn_quit:setLabelText(ex.Tools:getLang(47490))
    self.btn_quit:setLabelShadow(FONT_BLACK_C4B, cc.size(1, -1))
end

-----------------------------------------------------------------------------
function ClanMemberCtr:onCreate()
    self:setCCBIPath("ccbi/ClanMemberLayer.ccbi")
    self:setIsSingle(false)
end

function ClanMemberCtr:getLayerClass()
    return ClanMemberLayer
end

function ClanMemberCtr:openWindow()
    if self:isOpened() then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/clan.plist")

    self:loadLayer()
    self:open()
    self:initData()
end

function ClanMemberCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    self.layer.btn_quit:registerScriptTapHandler(handler(self, self.onQuit))

    self:registerEvent()

	-- 公会信息
	local req_clan_info = Clan_pb.GReqClanInfo()
	req_clan_info.clan_id = ex.Player.clan_data.clan_id
    NetManager:sendMessage(ProtocolID.GReqClanInfo, req_clan_info)
            
    self:updateLayer()
end

function ClanMemberCtr:updateLayer()
    local config = cfg.clanlevel.clanlevel[ex.Player.clan_data.clan_level]
    self.layer.lbl_member_num:setString(string.format("%d/%d", #ex.Player.clan_data.clan_member_list, config.member))
    
    self:updateTableView()
end

function ClanMemberCtr:registerEvent()
   self.layer:addEvent(EVENT.CLAN_EVENT.CLAN_QUIT, handler(self, self.receiveRes))
   self.layer:addEvent(EVENT.CLAN_EVENT.CLAN_MEMBER, handler(self, self.updateLayer))
end

function ClanMemberCtr:onQuit()
    ex.ConfirmCtr:openWindow(ex.Tools:getLang(47640), ex.Tools:getLang(47318), handler(self, self.onQuitDone))
end

function ClanMemberCtr:onQuitDone()
    NetManager:sendMessage(ProtocolID.GReqClanQuit)
end

function ClanMemberCtr:receiveRes(event)
    self:closeWindow(0, nil)

    ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_INFO)
end

function ClanMemberCtr:updateTableView()
    table.sort(ex.Player.clan_data.clan_member_list, function(a, b)
        return a.position < b.position
    end)

    self.layer.scroll_view:getContainer():removeAllChildren()
    self.layer.scroll_view.nodeTouched = function(tag, node)
        local data = node.data
        if data == nil or data.rid == nil or data.rid <= 0 then
            print("clan member data is nil")
            return
        end

        local self_data = ex.Player.clan_data:getMemberByRoleId(ex.Player.role_id)
        if self_data == nil then
            print("clan member self data is nil")
            return
        end

        -- 打开窗口，加入职位变更选项
        require("src.layer.clan.ClanPosHandlerCtr"):instance():openWindow(data.rid)
    end
    self.layer.scroll_view.createItemFunction = function(data)
        -- 创建ccbi cell
        local cell = ClanMemberCell:createWithCCBIFile("ccbi/ClanMemberCell.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(0.5, 0.5)
    
        cell:initData(data)
    
        return cell
    end

    self.layer.scroll_view:reloadData(ex.Player.clan_data.clan_member_list)
end

return ClanMemberCtr
