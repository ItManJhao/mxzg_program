--[[
    func: 组队竞技场组队界面
    author:徐东浩
    time:2020-04-14 22:55:45
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local TeamArenaTeamLayer = class("TeamArenaTeamLayer", require("src.comp.EventLayer"))
local TeamArenaTeamCell = class("TeamArenaTeamCell", require("src.comp.LuaLayerBase"))

local RequestResultType = {
    SuccessReq = 1,             -- 申请成功并未入队伍
    SuccessJoin = 2,            -- 申请成功并加入队伍 
    FailForFull = 3,            -- 申请失败，该队伍已满员
    FailForCondition = 4,       -- 申请失败，条件已改变，不符合入队条件
    FailForJoined = 5,          -- 申请失败，已加入别的队伍
}

function TeamArenaTeamCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    
    self.btn_request:registerScriptTapHandler(handler(self, self.onJoin))
    self.btn_requested:registerScriptTapHandler(handler(self, self.onJoin))

    self.btn_request:setLabelText(ex.Tools:getLang(74254))
    self.btn_requested:setLabelText(ex.Tools:getLang(74255))

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
        v.btn_head:registerScriptTapHandler(handler(self, self.onHead))

        v.border = cc.Sprite:create()
        v.border:setScale(1.2)
        v.border:setAnchorPoint(ex.a.center)
        v.btn_head:getNormalImage():addChild(v.border)
    end
end

function TeamArenaTeamCell:setTableView(table_view)
    for i,v in ipairs(self.ui_heads) do
        v.menu:setSwallowsTouches(false)
        v.menu:setIsTouchInsideNode(table_view)
    end

    self.menu:setSwallowsTouches(false)
    self.menu:setIsTouchInsideNode(table_view)
end

function TeamArenaTeamCell:reset(data)
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
    
    self.btn_request:setVisible(not is_my_team and not self.data.is_request)
    self.btn_requested:setVisible(not is_my_team and self.data.is_request)

    for i, v in ipairs(self.ui_heads) do
        self:_setMemberHead(v, self.data.member[i])
    end
end

function TeamArenaTeamCell:_setMemberHead(ui_node, member)
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

function TeamArenaTeamCell:onJoin(tag, pSender)
    if self.data.is_join then
        ex.MessageView:add(ex.Tools:getLang(74216))
        return 
    end

    if self.data.is_request then
        ex.MessageView:add(ex.Tools:getLang(74213))
        return 
    end

    if #self.data.member >= 3 then
        ex.MessageView:add(ex.Tools:getLang(74214))
        return 
    end

    if ex.Player.fighting < self.data.min_fighting or ex.Player.level < self.data.min_lv then
        ex.MessageView:add(ex.Tools:getLang(74215))
        return
    end

    local req = TeamArena_pb.GReqTeamApply()
    req.team_id = self.data.team_id
    NetManager:sendMessage(ProtocolID.GReqTeamApply, req)
end

function TeamArenaTeamCell:onHead(tag, pSender)
    ex.Tools:showPlayerInfo(pSender.player_id, pSender.server_id)
end

-------------------------------TeamArenaTeamLayer-----------------------------------------------
function TeamArenaTeamLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    
    self.btn_find:registerScriptTapHandler(handler(self,self.onFind))
    self.btn_create:registerScriptTapHandler(handler(self,self.onCreateTeam))
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
    self.sreach_input:setPlaceHolder(ex.Tools:getLang(74205))
    self.spr_input_bg:addChild(self.sreach_input, 9999)

    self.table_view = nil

    self:addEvent(EVENT.TEAM_ARENA.TEAM_MAIN_TEAM_DEFAULT, handler(self, self.refreshData))
    self:addEvent(EVENT.TEAM_ARENA.TEAM_MAIN_TEAM_SREACH, handler(self, self.refreshData))
    self:addEvent(EVENT.TEAM_ARENA.TEAM_MAIN_TEAM_REQUEST, handler(self, self.requestHandle))
end

function TeamArenaTeamLayer:reqData()
    local req = TeamArena_pb.GReqTeamRecommend()
    NetManager:sendMessage(ProtocolID.GReqTeamRecommend, req)
end

function TeamArenaTeamLayer:refreshData(event, data)
    self.data = data
    dump(self.data, "TeamArenaTeamLayer:refreshData", 10)
    if self.data and self.data.team and #self.data.team > 0 then
        for i,v in ipairs(self.data.team) do
            v.is_join = self.data.is_join   -- 赋值到列表内部便于tableview使用
        end

        table.sort(self.data.team, function(a, b)
            if #a.member >= 3 and #b.member < 3 then
                return false
            end

            if #a.member < 3 and #b.member >= 3 then
                return true
            end

            if a.fighting == b.fighting then
                return a.team_id > b.team_id 
            end

            return a.fighting > b.fighting 
        end)

        self:refreshTableView(self.data.team)
    else
        self:refreshTableView(nil)
    end
end

function TeamArenaTeamLayer:_getTeamDataByID(team_id)
    if #self.data.team > 0 then
        for i,v in ipairs(self.data.team) do
            if v.team_id == team_id then
                return v
            end
        end
    end

    return nil
end

function TeamArenaTeamLayer:requestHandle(event, data)
    if data.code == RequestResultType.SuccessReq then
        local team_data = self:_getTeamDataByID(data.team_id)
        if team_data then
            team_data.is_request = true
        end

        self:refreshTableView(self.data.team)
        return
    elseif data.code == RequestResultType.SuccessJoin then
        ex.JumpManager:jumpByAtom("team_arena_team_main_my_team")
        return
    elseif data.code == RequestResultType.FailForFull then
        ex.MessageView:add(ex.Tools:getLang(74214))

        self:onRefresh()
        return
    elseif data.code == RequestResultType.FailForCondition then
        ex.MessageView:add(ex.Tools:getLang(74215))
        
        self:onRefresh()
        return
    elseif data.code == RequestResultType.FailForJoined then
        ex.MessageView:add(ex.Tools:getLang(74216))
        return
    else
        printError("TeamArenaTeamLayer:requestHandle 返回状态码未定义!")
        return
    end
end

function TeamArenaTeamLayer:refreshTableView(list)
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
        self.table_view = ex.Tools:initTableView(self.node_not_null, list, {TeamArenaTeamCell, "ccbi/TeamArenaTeamCell.ccbi" }, table_view_size, margin, cc.p(3,3))
    else
        self.table_view:initData(list)
        self.table_view:reloadData()
    end
end

function TeamArenaTeamLayer:reqFind(str)
    if not str then
        ex.MessageView:add(ex.Tools:getLang(74205))
        return
    end

    local req = TeamArena_pb.GReqTeamSearch()
    req.team_name = str
    NetManager:sendMessage(ProtocolID.GReqTeamSearch, req)
end

function TeamArenaTeamLayer:getInputText()
    local input = self.sreach_input:getText()
    input = string.trim(input)

    return input
end

function TeamArenaTeamLayer:onFind(tag, pSender)
    local input = self:getInputText()
    if string.len(input) <= 0 then
        ex.MessageView:add(ex.Tools:getLang(74205))
        return
    end

    self.sreach_input:setText(input)

    self:reqFind(input)
end

function TeamArenaTeamLayer:onCreateTeam(tag, pSender)
    if self.data.is_join then
        ex.MessageView:add(ex.Tools:getLang(74216))
        return
    else
        require("src.layer.teamarena.TeamArenaNewTeamCtrl"):instance():openWindow()
    end
end

function TeamArenaTeamLayer:onRefresh(tag, pSender)
    local input = self:getInputText()

    if string.len(input) > 0 then
        self:reqFind(input)
    else
        self:reqData()
    end
end

return TeamArenaTeamLayer