--[[
    func: 组队竞技场组队界面-收到邀请
    author:徐东浩
    time:2020-04-16 23:07:25
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local TeamArenaRecvInviteLayer = class("TeamArenaRecvInviteLayer", require("src.comp.EventLayer"))
local TeamArenaRecvInviteCell = class("TeamArenaRecvInviteCell", require("src.comp.LuaLayerBase"))

function TeamArenaRecvInviteCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    
    self.btn_join:registerScriptTapHandler(handler(self, self.onJoin))
    self.btn_join:setLabelText(ex.Tools:getLang(74226))

    self.data = nil
    self.ui_heads = {
        [1] = {
            node_not_null = self.node_role_1,
            node_null = self.node_not_role_1,
            menu = self.menu_role_1,
            btn_head = self.btn_head_1,
            border = nil,   -- 下面赋值
            level = self.lbl_level_1
        },
        [2] = {
            node_not_null = self.node_role_2,
            node_null = self.node_not_role_2,
            menu = self.menu_role_2,
            btn_head = self.btn_head_2,
            border = nil,
            level = self.lbl_level_2
        },
        [3] = {
            node_not_null = self.node_role_3,
            node_null = self.node_not_role_3,
            menu = self.menu_role_3,
            btn_head = self.btn_head_3,
            border = nil,
            level = self.lbl_level_3
        },
    }

    for i,v in ipairs(self.ui_heads) do
        local head_size = v.btn_head:getContentSize()
        v.btn_head:registerScriptTapHandler(handler(self, self.onHead))

        v.border = cc.Sprite:create()
        v.border:setScale(1.2)
        v.border:setAnchorPoint(ex.a.center)
        v.btn_head:getNormalImage():addChild(v.border)
    end
end

function TeamArenaRecvInviteCell:setTableView(table_view)
    for i,v in ipairs(self.ui_heads) do
        v.menu:setSwallowsTouches(false)
        v.menu:setIsTouchInsideNode(table_view)
    end

    self.menu:setSwallowsTouches(false)
    self.menu:setIsTouchInsideNode(table_view)
end

function TeamArenaRecvInviteCell:reset(data)
    if not data then return end

    self.data = data

    self.lbl_name:setString(self.data.team_name)

    local is_my_team = false
    local count_power = 0
    for i, v in ipairs(self.data.member) do
        count_power = count_power + v.member.fighting
        if not is_my_team then is_my_team = v.member.player_id == ex.Player.role_id end
    end
    self.lbl_power:setString(count_power)
    
    self.lbl_req_level:setString(self.data.min_lv <= 0 and string.format(ex.Tools:getLang(74256),ex.Tools:getLang(74250)) or string.format(ex.Tools:getLang(74251), self.data.min_lv))
    self.lbl_req_power:setString(self.data.min_fighting <= 0 and string.format(ex.Tools:getLang(74257), ex.Tools:getLang(74250)) or string.format(ex.Tools:getLang(74252), ex.StringUtil.getScientificNumber(self.data.min_fighting)))
    self.lbl_req_level:setColor(ex.Player.level >= self.data.min_lv and cc.c3b(33, 154, 0) or cc.c3b(182, 4, 4))
    self.lbl_req_power:setColor(ex.Player.fighting >= self.data.min_fighting and cc.c3b(33, 154, 0) or cc.c3b(182, 4, 4))
    
    self.btn_join:setVisible(not is_my_team)

    for i, v in ipairs(self.ui_heads) do
        self:_setMemberHead(v, self.data.member[i])
    end
end

function TeamArenaRecvInviteCell:_setMemberHead(ui_node, member)
    local no_role = member == nil

    ui_node.node_null:setVisible(no_role)
    ui_node.node_not_null:setVisible(not no_role)

    if not no_role then
        ui_node.btn_head:getNormalImage():setSpriteFrame(string.format("head-icon/%d.png", member.member.head_id))
        ui_node.btn_head.player_id = member.member.player_id
        ui_node.btn_head.server_id = member.member.server_id

        local img_size = ui_node.btn_head:getNormalImage():getContentSize()
        local btn_scale = ui_node.btn_head:getScale()
        ui_node.btn_head:setPosition(cc.p((120 - img_size.width) * btn_scale / 2, (120 - img_size.height) * btn_scale / 2))

        ui_node.border:setSpriteFrame(ex.Tools:getBorderIconByIdx(member.member.border_id))
        ui_node.border:setPosition(img_size.width / 2, img_size.height / 2)

        ui_node.level:setString(member.member.level)
    end
end

function TeamArenaRecvInviteCell:onJoin(tag, pSender)
    if self.data.is_join then
        ex.MessageView:add(ex.Tools:getLang(74216))
        return 
    end

    if #self.data.member >= 3 then
        ex.MessageView:add(ex.Tools:getLang(74214))
        return 
    end

    -- if ex.Player.fighting < self.data.min_fighting or ex.Player.level < self.data.min_lv then 邀请不判断战力
    --     ex.MessageView:add(ex.Tools:getLang(74215))
    --     return
    -- end

    local req = TeamArena_pb.GReqTeamHandleInvite()
    req.team_id = self.data.team_id
    NetManager:sendMessage(ProtocolID.GReqTeamHandleInvite, req)
end

function TeamArenaRecvInviteCell:onHead(tag, pSender)
    ex.Tools:showPlayerInfo(pSender.player_id, pSender.server_id)
end

-------------------------------TeamArenaRecvInviteLayer-----------------------------------------------
function TeamArenaRecvInviteLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    
    self.btn_clear:registerScriptTapHandler(handler(self,self.onClear))

    self.data = nil

    self.table_view = nil
    
    self:addEvent(EVENT.TEAM_ARENA.TEAM_MAIN_TEAM_INVITE, handler(self, self.refreshData))
    self:addEvent(EVENT.TEAM_ARENA.TEAM_MAIN_TEAM_JOIN, handler(self, self.joinTeam))
end

function TeamArenaRecvInviteLayer:reqData()
    local req = TeamArena_pb.GReqTeamInviteList()
    NetManager:sendMessage(ProtocolID.GReqTeamInviteList, req)
end

function TeamArenaRecvInviteLayer:refreshData(event, data)
    self.data = data
    dump(self.data, "TeamArenaRecvInviteLayer:refreshData", 10)
    if self.data and self.data.team and #self.data.team > 0 then
        for i,v in ipairs(self.data.team) do
            v.is_join = self.data.is_join   -- 赋值到列表内部便于tableview使用
        end

        self:refreshTableView(self.data.team)
    else
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KFSK_ZDJJC_ZDDT_SDYQ, false)
        self:refreshTableView(nil)
    end
end

function TeamArenaRecvInviteLayer:joinTeam(event, data)
    ex.MessageView:add(ex.Tools:getLang(74228))

    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KFSK_ZDJJC_ZDDT_SDYQ, false)
    
    ex.JumpManager:jumpByAtom("team_arena_team_main_my_team")
end

function TeamArenaRecvInviteLayer:refreshTableView(list)
    local no_team = not list or #list <= 0
    self.node_null:setVisible(no_team)
    self.node_not_null:setVisible(not no_team)

    if no_team then
        return
    end

    if not self.table_view then
        local margin = 6
        local table_view_size = self.node_not_null:getContentSize()
        table_view_size.width = table_view_size.width - 6
        table_view_size.height = table_view_size.height - 6
        self.table_view = ex.Tools:initTableView(self.node_not_null, list, {TeamArenaRecvInviteCell, "ccbi/TeamArenaRecvInviteCell.ccbi" }, table_view_size, margin, cc.p(3,3))
    else
        self.table_view:initData(list)
        self.table_view:reloadData()
    end
end

function TeamArenaRecvInviteLayer:onClear(tag, pSender)
    if self.data and self.data.team and #self.data.team > 0 then

        local req = TeamArena_pb.GReqTeamArenaClearAllInvite()
        NetManager:sendMessage(ProtocolID.GReqTeamArenaClearAllInvite, req)

        self:refreshData(nil, nil)
    end
end

return TeamArenaRecvInviteLayer