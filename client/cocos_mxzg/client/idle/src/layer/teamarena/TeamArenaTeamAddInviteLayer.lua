--[[
    func: 组队竞技场添加玩家界面-邀请页面
    author:徐东浩
    time:2020-04-17 15:17:00
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local TeamArenaTeamAddInviteLayer = class("TeamArenaTeamAddInviteLayer", require("src.comp.EventLayer"))
local TeamArenaTeamAddInviteCell = class("TeamArenaTeamAddInviteCell", require("src.comp.LuaLayerBase"))
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

function TeamArenaTeamAddInviteCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.data = nil
    self.node_pos_list = {self.node_pos_1, self.node_pos_2, self.node_pos_3, self.node_pos_4, self.node_pos_5, self.node_pos_6}

    self.btn_head:registerScriptTapHandler(handler(self, self.onHead))

    self.btn_invite:registerScriptTapHandler(handler(self, self.onInvite))
    self.btn_invited:registerScriptTapHandler(handler(self, self.onInvite))

    self.btn_invite:setLabelText(ex.Tools:getLang(74316))
    self.btn_invited:setLabelText(ex.Tools:getLang(74317))

    self.border = cc.Sprite:create()
    self.border:setScale(1.2)
    self.border:setAnchorPoint(ex.a.center)
    self.btn_head:getNormalImage():addChild(self.border)

    self.menu_hero = cpp.UIMenu:create()
    self.menu_hero:setPosition(0, 0)
    self.menu_hero:setSwallowsTouches(false)
    self.menu_hero:setLocalZOrder(1)
    self.node_hero:addChild(self.menu_hero)
end

function TeamArenaTeamAddInviteCell:setTableView(table_view)
    self.menu:setSwallowsTouches(false)
    self.menu:setIsTouchInsideNode(table_view)
    self.menu_head:setSwallowsTouches(false)
    self.menu_head:setIsTouchInsideNode(table_view)
    self.menu_hero:setSwallowsTouches(false)
    self.menu_hero:setIsTouchInsideNode(table_view)
end

function TeamArenaTeamAddInviteCell:reset(data)
    if not data then return end

    self.data = data

    self.btn_head:getNormalImage():setSpriteFrame(string.format("head-icon/%d.png", self.data.role.member.head_id))
    self.border:setSpriteFrame(ex.Tools:getBorderIconByIdx(self.data.role.member.border_id))

    local img_size = self.btn_head:getNormalImage():getContentSize()
    local btn_scale = self.btn_head:getScale()
    self.btn_head:setPosition(cc.p((120 - img_size.width) * btn_scale / 2, (120 - img_size.height) * btn_scale / 2))
    self.border:setPosition(img_size.width / 2, img_size.height / 2)

    self.btn_invite:setVisible(not self.data.is_invite)
    self.btn_invited:setVisible(self.data.is_invite)

    self.lbl_level:setString(self.data.role.member.level)
    self.lbl_name:setString(self.data.role.member.nick)
    self.lbl_power:setString(self.data.role.member.fighting)

    local index = 1
    for i, v in ipairs(self.data.role.hero_data) do
        if self.node_pos_list[index] ~= nil then
            self.node_pos_list[index]:setVisible(false)

            local hero_config = cfg.herotype.star[v.hero_type]
            local item = UIMenuItemHero:createWithData(v.hero_id, v.hero_type, hero_config ~= nil and hero_config.elem or 0, v.level, v.star)
            item.local_data = v
            item:setScale(0.7)
            item:setPosition(self.node_pos_list[index]:getPosition())
            self.menu_hero:addChild(item)
            item:registerScriptTapHandler(handler(self, self.onHero))

            index = index + 1
        end
    end
end

function TeamArenaTeamAddInviteCell:onHead(tag, pSender)
    ex.Tools:showPlayerInfo(self.data.role.member.player_id, self.data.role.member.server_id)
end

function TeamArenaTeamAddInviteCell:onHero(tag, pSender)
    ex.Tools:showHeroInfo(self.data.role.member.player_id, self.data.role.member.server_id, pSender.hero_id)
end

function TeamArenaTeamAddInviteCell:onInvite(tag, pSender)
    if self.data.is_invite then 
        ex.MessageView:add(ex.Tools:getLang(74315))
        return
    end

    local req = TeamArena_pb.GReqTeamInvite()
    req.rid = self.data.role.member.player_id
    NetManager:sendMessage(ProtocolID.GReqTeamInvite, req)
end

-------------------------------TeamArenaTeamAddInviteLayer-----------------------------------------------
function TeamArenaTeamAddInviteLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    
    self.btn_find:registerScriptTapHandler(handler(self,self.onFind))
    self.btn_refresh:registerScriptTapHandler(handler(self,self.onRefresh))

    self.data = nil

    -- 创建输入框
    local input_size = self.spr_input_bg:getContentSize()
	self.sreach_input = ccui.EditBox:create(input_size, "other/spr-null.png",1)
    self.sreach_input:setPosition(cc.p(input_size.width / 2, input_size.height / 2))
    self.sreach_input:setAnchorPoint(cc.p(0.5, 0.5))
    self.sreach_input:setFontSize(20)
    self.sreach_input:setMaxLength(6)
    self.sreach_input:setFontColor(FONT_BROWN_2)
    self.sreach_input:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND) --输入键盘返回类型，done，send，go等
    self.sreach_input:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE) --输入模型，如整数类型，URL，电话号码等，会检测是否符合
    self.sreach_input:setPlaceholderFontSize(20)
    self.sreach_input:setPlaceHolder(ex.Tools:getLang(74314))
    self.spr_input_bg:addChild(self.sreach_input, 9999)

    self.table_view = nil

    self:addEvent(EVENT.TEAM_ARENA.TEAM_ADD_INVITE_LIST, handler(self, self.refreshData))
    self:addEvent(EVENT.TEAM_ARENA.TEAM_ADD_INVITE_SREACH, handler(self, self.refreshData))
    self:addEvent(EVENT.TEAM_ARENA.TEAM_ADD_INVITE, handler(self, self.inviteHandle))
end

function TeamArenaTeamAddInviteLayer:reqData()
    local req = TeamArena_pb.GReqTeamArenaRecommendRole()
    NetManager:sendMessage(ProtocolID.GReqTeamArenaRecommendRole, req)
end

function TeamArenaTeamAddInviteLayer:inviteHandle(event, data)
    if self.data and self.data.roles and #self.data.roles > 0 then
        for i, v in ipairs(self.data.roles) do
            if v.role.member.player_id == data.rid then
                v.is_invite = true
                break
            end
        end

        local is_local = self.table_view ~= nil
        local offset = nil
        if is_local then offset = cc.p(self.table_view:getContentOffset()) end

        self:refreshTableView(self.data.roles)

        if is_local then self.table_view:setContentOffset(offset) end
    end
end

function TeamArenaTeamAddInviteLayer:refreshData(event, data)
    self.data = data
    dump(self.data, "TeamArenaTeamAddInviteLayer:refreshData", 10)
    if self.data and self.data.roles and #self.data.roles > 0 then
        table.sort(self.data.roles, function(a, b)
            if a.role.fighting == b.role.fighting then
                return a.role.member.player_id > b.role.member.player_id
            else
                return a.role.fighting > b.role.fighting
            end
        end)

        self:refreshTableView(self.data.roles)
    else
        self:refreshTableView(nil)
    end
end

function TeamArenaTeamAddInviteLayer:refreshTableView(list)
    local no_player = not list or #list <= 0
    self.node_null:setVisible(no_player)
    self.node_not_null:setVisible(not no_player)

    if no_player then
        return
    end

    if not self.table_view then
        local margin = 6
        local table_view_size = self.node_not_null:getContentSize()
        table_view_size.width = table_view_size.width - 6
        table_view_size.height = table_view_size.height - 6
        self.table_view = ex.Tools:initTableView(self.node_not_null, list, {TeamArenaTeamAddInviteCell, "ccbi/TeamArenaTeamAddInviteCell.ccbi" }, table_view_size, margin, cc.p(3,3))
    else
        self.table_view:initData(list)
        self.table_view:reloadData()
    end
end

function TeamArenaTeamAddInviteLayer:reqFind(str)
    if not str then
        ex.MessageView:add(ex.Tools:getLang(74205))
        return
    end

    local req = TeamArena_pb.GReqTeamArenaSearchRole()
    req.role_name = str
    NetManager:sendMessage(ProtocolID.GReqTeamArenaSearchRole, req)
end

function TeamArenaTeamAddInviteLayer:getInputText()
    local input = self.sreach_input:getText()
    input = string.trim(input)

    return input
end

function TeamArenaTeamAddInviteLayer:onFind(tag, pSender)
    local input = self:getInputText()
    if string.len(input) <= 0 then
        ex.MessageView:add(ex.Tools:getLang(74205))
        return
    end

    self.sreach_input:setText(input)

    self:reqFind(input)
end

function TeamArenaTeamAddInviteLayer:onRefresh(tag, pSender)
    local input = self:getInputText()

    if string.len(input) > 0 then
        self:reqFind(input)
    else
        self:reqData()
    end
end

return TeamArenaTeamAddInviteLayer