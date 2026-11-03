--[[
    func: 组队竞技场组队界面-我的队伍
    author:徐东浩
    time:2020-04-16 15:28:33
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local TeamArenaMyTeamLayer = class("TeamArenaMyTeamLayer", require("src.comp.EventLayer"))
local TeamArenaMyTeamCell = class("TeamArenaMyTeamCell", require("src.comp.EventLayer"))
local TeamArenaMyTeamAddCell = class("TeamArenaMyTeamAddCell", require("src.comp.EventLayer"))
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

-------------------------------TeamArenaMyTeamAddCell-----------------------------------------------
function TeamArenaMyTeamAddCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    
    local btn_size = self.btn_add:getContentSize()
    local spr_add = cc.Sprite:createWithSpriteFrameName("other/spr-add-1.png")
    spr_add:setAnchorPoint(ex.a.center)
    spr_add:setPosition(btn_size.width / 2, btn_size.height / 2)
    self.btn_add:getNormalImage():addChild(spr_add)

    self:addRedDotNode(RedDotType.ZCJ_DHZC_KFSK_ZDJJC_ZDDT_WDDW_TJWJ, self.btn_add)
end

-------------------------------TeamArenaMyTeamCell-----------------------------------------------
function TeamArenaMyTeamCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.data = nil
    self.node_pos_list = {self.node_pos_1, self.node_pos_2, self.node_pos_3, self.node_pos_4, self.node_pos_5, self.node_pos_6}

    self.lbl_pos:setString(ex.Tools:getLang(74232))

    self.btn_head:registerScriptTapHandler(handler(self, self.onHead))

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

function TeamArenaMyTeamCell:initData(data)
    if not data then return end

    self.data = data

    -- self.btn_head:getNormalImage():setSpriteFrame(string.format("head-icon/%d.png", self.data.member.head_id))
    ex.Tools:setSpriteFrame(self.btn_head:getNormalImage(), string.format("head-icon/%d.png", self.data.member.head_id))
    self.border:setSpriteFrame(ex.Tools:getBorderIconByIdx(self.data.member.border_id))

    local img_size = self.btn_head:getNormalImage():getContentSize()
    local btn_scale = self.btn_head:getScale()
    self.btn_head:setPosition(cc.p((120 - img_size.width) * btn_scale / 2, (120 - img_size.height) * btn_scale / 2))
    self.border:setPosition(img_size.width / 2, img_size.height / 2)

    self.lbl_level:setString(self.data.member.level)
    self.lbl_name:setString(self.data.member.nick)
    self.lbl_power:setString(self.data.fighting)

    local index = 1
    for i, v in ipairs(self.data.hero_data) do
        if self.node_pos_list[index] ~= nil then
            self.node_pos_list[index]:setVisible(false)

            local hero_config = cfg.herotype.star[v.hero_type]
            local item = UIMenuItemHero:createWithData(v.hero_id, v.hero_type, hero_config ~= nil and hero_config.elem or 0, v.level, v.star)
            item.local_data = v
            item:setScale(0.7)
            item:setPosition(self.node_pos_list[index]:getPosition())
            self.menu_hero:addChild(item)
            item:registerScriptTapHandler(handler(self, self.onHero))
        end

        index = index + 1
    end
end

function TeamArenaMyTeamCell:setCaptain(is_captain, is_i_am_caption, is_mine, had_sign)
    self.lbl_pos:setVisible(is_captain)

    self.btn_give:setVisible(is_i_am_caption and not is_mine and not had_sign)
    self.btn_remove:setVisible(is_i_am_caption and not is_mine and not had_sign)
end

function TeamArenaMyTeamCell:onHead(tag, pSender)
    ex.Tools:showPlayerInfo(self.data.member.player_id, self.data.member.server_id)
end

function TeamArenaMyTeamCell:onHero(tag, pSender)
    ex.Tools:showHeroInfo(self.data.member.player_id, self.data.member.server_id, pSender.hero_id)
end

-------------------------------TeamArenaMyTeamLayer-----------------------------------------------
function TeamArenaMyTeamLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    
    self.btn_adjust:registerScriptTapHandler(handler(self,self.onAdjust))
    self.btn_edit:registerScriptTapHandler(handler(self,self.onEdit))
    self.btn_out:registerScriptTapHandler(handler(self,self.onOut))
    self.btn_join:registerScriptTapHandler(handler(self,self.onJoin))

    self.data = nil
    self.is_edit_mode = false

    -- 创建输入框
    local input_size = self.node_input_rect:getContentSize()
	self.name_input = ccui.EditBox:create(input_size, "other/spr-null.png",1)
    self.name_input:setPosition(input_size.width / 2, input_size.height / 2)
    self.name_input:setAnchorPoint(ex.a.center)
    self.name_input:setFontSize(24)
    self.name_input:setMaxLength(6)
    self.name_input:setFontColor(FONT_BROWN_2)
    self.name_input:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND) --输入键盘返回类型，done，send，go等
    self.name_input:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE) --输入模型，如整数类型，URL，电话号码等，会检测是否符合
    self.name_input:registerScriptEditBoxHandler(handler(self,self.editboxHandle))
    self.name_input:setPlaceholderFontSize(24)
    self.name_input:setPlaceHolder(ex.Tools:getLang(74219))
    self.node_input_rect:addChild(self.name_input, 9999)

    local scroll_view_size = self.node_not_null:getContentSize()
    scroll_view_size.width = scroll_view_size.width - 6
    scroll_view_size.height = scroll_view_size.height - 6

    self.scroll_view = cc.ScrollView:create(scroll_view_size)
    self.scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.scroll_view:setPosition(3, 3)
    self.node_not_null:addChild(self.scroll_view)

    self:addEvent(EVENT.TEAM_ARENA.MY_TEAM_REFRESH, handler(self, self.refreshData))
    self:addEvent(EVENT.TEAM_ARENA.TEAM_MAIN_TEAM_SIGN, handler(self, self.refreshData))
    self:addEvent(EVENT.TEAM_ARENA.TEAM_MAIN_TEAM_CAPTAIN, handler(self, self.refreshData))
    self:addEvent(EVENT.TEAM_ARENA.TEAM_MAIN_TEAM_KICKOUT, handler(self, self.refreshData))
    self:addEvent(EVENT.TEAM_ARENA.TEAM_MAIN_TEAM_EXIT, handler(self, self.refreshData))
    self:addEvent(EVENT.TEAM_ARENA.TEAM_MAIN_TEAM_CONDITION, handler(self, self.editCondition))
end

function TeamArenaMyTeamLayer:reqData()
    local req = TeamArena_pb.GReqTeam()
    NetManager:sendMessage(ProtocolID.GReqTeam, req)
end

function TeamArenaMyTeamLayer:refreshData(event, data)
    self.data = data
    if self.data and self.data.team.team_id == 0 then
        self.data = nil
    end

    if self.data then dump(self.data, "TeamArenaMyTeamLayer:refreshData", 10) end

    self:refreshView()
end

function TeamArenaMyTeamLayer:editCondition(event, data)
    self.data = data

    self.lbl_name:setString(self.data.team.team_name)

    self:refreshCondition()
end

function TeamArenaMyTeamLayer:refreshView()
    local is_exsit_team = self.data and self.data.team
    
    self.node_null:setVisible(not is_exsit_team)
    self.node_not_null:setVisible(not is_exsit_team)

    self.btn_out:setVisible(is_exsit_team and not self.data.team.had_sign)
    self.btn_join:setVisible(is_exsit_team and not self.data.team.had_sign)
    self.btn_adjust:setVisible(is_exsit_team and not self.data.team.had_sign)

    local count_power = 0
    if is_exsit_team then
        self:refreshTableView(self.data.team.member)

        for i, v in ipairs(self.data.team.member) do
            count_power = count_power + v.fighting
        end

        self.lbl_name:setString(self.data.team.team_name)
    else
        self:refreshTableView(nil)
    end

    self.lbl_power:setString(count_power)

    self:refreshCondition()
end

function TeamArenaMyTeamLayer:refreshCondition()
    local is_exsit_team = self.data ~= nil and self.data.team ~= nil

    self.lbl_min_level:setString((is_exsit_team and self.data.team.min_lv > 0) and string.format(ex.Tools:getLang(74251), self.data.team.min_lv) or ex.Tools:getLang(74250))
    self.lbl_min_power:setString((is_exsit_team and self.data.team.min_fighting > 0) and string.format(ex.Tools:getLang(74252), ex.StringUtil.getScientificNumber(self.data.team.min_fighting)) or ex.Tools:getLang(74250))
end

function TeamArenaMyTeamLayer:requestHandle(event, data)
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
        printError("TeamArenaMyTeamLayer:requestHandle 返回状态码未定义!")
        return
    end
end

function TeamArenaMyTeamLayer:refreshTableView(list)
    local no_team = not list or #list <= 0
    self.node_null:setVisible(no_team)
    self.node_not_null:setVisible(not no_team)

    if no_team then
        return
    end

    self.scroll_view:getContainer():removeAllChildren()

    local list_lenght = math.min(#list, 3)
    if self:isCaptain(ex.Player.role_id) and not self.data.team.had_sign then
        list_lenght = math.min(#list + 1, 3)
    end

    local cell_space, count_height = 6, 0
    count_height = 3   -- 底部空余
    for i = list_lenght, 1, -1 do   -- 倒序插入
        local data = list[i]
        local item = nil
        if data then
            item = TeamArenaMyTeamCell:createWithCCBIFile("ccbi/TeamArenaMyTeamCell.ccbi")

            item.menu_head:setSwallowsTouches(false)
            item.menu_hero:setSwallowsTouches(false)
            item.menu:setSwallowsTouches(false)
            item.menu_head:setIsTouchInsideNode(self.scroll_view)
            item.menu_hero:setIsTouchInsideNode(self.scroll_view)
            item.menu:setIsTouchInsideNode(self.scroll_view)

            item.btn_give:registerScriptTapHandler(handler(self, self.onGive))
            item.btn_remove:registerScriptTapHandler(handler(self, self.onRemove))
            item.btn_give.root_layer = item
            item.btn_remove.root_layer = item

            item:setCaptain(self:isCaptain(data.member.player_id), self:isCaptain(ex.Player.role_id), data.member.player_id == ex.Player.role_id, self.data.team.had_sign)
        else
            item = TeamArenaMyTeamAddCell:createWithCCBIFile("ccbi/TeamArenaMyTeamAddCell.ccbi")

            item.menu:setSwallowsTouches(false)
            item.menu:setIsTouchInsideNode(self.scroll_view)

            item.btn_add:registerScriptTapHandler(handler(self, self.onAdd))
            item.btn_add.root_layer = item
        end
        local item_size = item:getContentSize()
        item:setIgnoreAnchorPointForPosition(true)
        item:setPosition(3, count_height)

        if item.initData then item:initData(data) end

        self.scroll_view:addChild(item)

        count_height = count_height + item_size.height
        if i ~= 1 then
            count_height = count_height + cell_space
        end
    end
    count_height = count_height + 3 -- 顶部空余

    self.scroll_view:setContentSize(cc.size(self.scroll_view:getViewSize().width, count_height))
    self.scroll_view:setContentOffset(self.scroll_view:minContainerOffset())
end

function TeamArenaMyTeamLayer:setEditMode(is_edit)
    if is_edit then
        self.name_input:setText("")
        self.name_input:touchDownAction(self.name_input, ccui.TouchEventType.ended)
    end

    self.node_input:setVisible(is_edit)
end

function TeamArenaMyTeamLayer:isCaptain(player_id)
    if self.data then
        return player_id == self.data.team.captain_id
    end

    return false
end

function TeamArenaMyTeamLayer:getInputText()
    local input = self.name_input:getText()
    input = string.trim(input)

    return input
end

function TeamArenaMyTeamLayer:editboxHandle(strEventName, sender)
    if strEventName == "ended" then 
		self:onEdit()
	end
end

function TeamArenaMyTeamLayer:onAdjust(tag, pSender)
    if not self:isCaptain(ex.Player.role_id) then
        ex.MessageView:add(ex.Tools:getLang(74239))
        return
    end

    if self.data then
        require("src.layer.teamarena.TeamArenaConditionCtrl"):instance():openWindow(self.data)
    else
        printError("TeamArenaMyTeamLayer:onAdjust 队伍数据为空")
    end
end

function TeamArenaMyTeamLayer:onEdit(tag, pSender)
    if not self:isCaptain(ex.Player.role_id) then
        ex.MessageView:add(ex.Tools:getLang(74238))
        return
    end

    if self.is_edit_mode then
        -- 编辑模式下再次点击，则确认修改
        local input = self:getInputText()
        if string.len(input) > 0 then
            if input ~= self.data.team.team_name then   -- 名字相同不处理
                local req = TeamArena_pb.GReqTeamReset()
                req.team_name = input
                req.min_fighting = self.data.team.min_fighting
                req.min_lv = self.data.team.min_lv
                req.auto_agree = self.data.team.auto_agree
                NetManager:sendMessage(ProtocolID.GReqTeamReset, req)
            end
        end
    end

    self.is_edit_mode = not self.is_edit_mode
    self:setEditMode(self.is_edit_mode)
end

function TeamArenaMyTeamLayer:onOut(tag, pSender)
    if self.data.team.had_sign then
        ex.MessageView:add(ex.Tools:getLang(74242))
        return
    end

    ex.ConfirmCtr:openWindow(ex.Tools:getLang(16), ex.Tools:getLang(74243), function()
        local req = TeamArena_pb.GReqTeamExit()
        NetManager:sendMessage(ProtocolID.GReqTeamExit, req)
    end)
end

function TeamArenaMyTeamLayer:onJoin(tag, pSender)
    if self.data.team.had_sign then
        ex.MessageView:add(ex.Tools:getLang(74244))
        return
    end

    if not self:isCaptain(ex.Player.role_id) then
        ex.MessageView:add(ex.Tools:getLang(74245))
        return
    end

    ex.ConfirmCtr:openWindow(ex.Tools:getLang(16), ex.Tools:getLang(74253), function()
        local req = TeamArena_pb.GReqTeamArenaSign()
        NetManager:sendMessage(ProtocolID.GReqTeamArenaSign, req)
    end)
end

function TeamArenaMyTeamLayer:onGive(tag, pSender)
    local data = pSender.root_layer.data

    ex.ConfirmCtr:openWindow(ex.Tools:getLang(16), ex.Tools:getLang(74240), function()
        local req = TeamArena_pb.GReqTeamArenaChangeCaptain()
        req.captain_id = data.member.player_id
        NetManager:sendMessage(ProtocolID.GReqTeamArenaChangeCaptain, req)
    end)
end

function TeamArenaMyTeamLayer:onRemove(tag, pSender)
    local data = pSender.root_layer.data

    ex.ConfirmCtr:openWindow(ex.Tools:getLang(16), ex.Tools:getLang(74241), function()
        local req = TeamArena_pb.GReqTeamKickOut()
        req.member_id = data.member.player_id
        NetManager:sendMessage(ProtocolID.GReqTeamKickOut, req)
    end)
end

function TeamArenaMyTeamLayer:onAdd(tag, pSender)
    require("src.layer.teamarena.TeamArenaTeamAddMainCtrl"):instance():openWindow()
end

return TeamArenaMyTeamLayer