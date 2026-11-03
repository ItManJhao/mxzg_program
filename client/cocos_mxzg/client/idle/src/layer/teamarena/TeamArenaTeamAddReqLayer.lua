--[[
    func: 组队竞技场添加玩家界面-申请列表
    author:徐东浩
    time:2020-04-17 15:23:19
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local TeamArenaTeamAddReqLayer = class("TeamArenaTeamAddReqLayer", require("src.comp.EventLayer"))
local TeamArenaTeamAddReqCell = class("TeamArenaTeamAddReqCell", require("src.comp.LuaLayerBase"))
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

-------------------------------TeamArenaTeamAddReqCell-----------------------------------------------
function TeamArenaTeamAddReqCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.data = nil
    self.node_pos_list = {self.node_pos_1, self.node_pos_2, self.node_pos_3, self.node_pos_4, self.node_pos_5, self.node_pos_6}

    local head_size = self.btn_head:getContentSize()
    self.btn_head:registerScriptTapHandler(handler(self, self.onHead))

    self.border = cc.Sprite:create()
    self.border:setScale(1.2)
    self.border:setAnchorPoint(ex.a.center)
    self.btn_head:getNormalImage():addChild(self.border)

    self.menu_hero = cpp.UIMenu:create()
    self.menu_hero:setPosition(0, 0)
    self.menu_hero:setLocalZOrder(1)
    self.node_hero:addChild(self.menu_hero)

    self.btn_refuse:registerScriptTapHandler(handler(self,self.onRefuse))
    self.btn_pass:registerScriptTapHandler(handler(self,self.onPass))
end

function TeamArenaTeamAddReqCell:setTableView(table_view)
    self.menu:setSwallowsTouches(false)
    self.menu:setIsTouchInsideNode(table_view)
    self.menu_head:setSwallowsTouches(false)
    self.menu_head:setIsTouchInsideNode(table_view)
    self.menu_hero:setSwallowsTouches(false)
    self.menu_hero:setIsTouchInsideNode(table_view)
end

function TeamArenaTeamAddReqCell:reset(data)
    if not data then return end

    self.data = data

    self.btn_head:getNormalImage():setSpriteFrame(string.format("head-icon/%d.png", self.data.member.head_id))
    self.border:setSpriteFrame(ex.Tools:getBorderIconByIdx(self.data.member.border_id))

    local img_size = self.btn_head:getNormalImage():getContentSize()
    local btn_scale = self.btn_head:getScale()
    self.btn_head:setPosition(cc.p((120 - img_size.width) * btn_scale / 2, (120 - img_size.height) * btn_scale / 2))
    self.border:setPosition(img_size.width / 2, img_size.height / 2)

    self.lbl_level:setString(self.data.member.level)
    self.lbl_name:setString(self.data.member.nick)
    self.lbl_power:setString(self.data.fighting)

    local index = 1
    for _, v in ipairs(self.data.hero_data) do
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

function TeamArenaTeamAddReqCell:onHead(tag, pSender)
    ex.Tools:showPlayerInfo(self.data.member.player_id, self.data.member.server_id)
end

function TeamArenaTeamAddReqCell:onHero(tag, pSender)
    ex.Tools:showHeroInfo(self.data.member.player_id, self.data.member.server_id, pSender.hero_id)
end

function TeamArenaTeamAddReqCell:onRefuse(tag, pSender)
    ex.EventManager:fire(EVENT.TEAM_ARENA.TEAM_ADD_REQ_CLICK_HANDLE, {
        member_id = self.data.member.player_id,
        op = 2
    })
end

function TeamArenaTeamAddReqCell:onPass(tag, pSender)
    ex.EventManager:fire(EVENT.TEAM_ARENA.TEAM_ADD_REQ_CLICK_HANDLE, {
        member_id = self.data.member.player_id,
        op = 1
    })
end

-------------------------------TeamArenaTeamAddReqLayer-----------------------------------------------
function TeamArenaTeamAddReqLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    
    self.btn_adjust:registerScriptTapHandler(handler(self,self.onAdjust))
    self.btn_refresh:registerScriptTapHandler(handler(self,self.onRefresh))

    self.data = nil
    self.team_data = nil

    self.table_view = nil

    self:addEvent(EVENT.TEAM_ARENA.MY_TEAM_REFRESH, handler(self, self.editCondition))
    self:addEvent(EVENT.TEAM_ARENA.TEAM_MAIN_TEAM_CONDITION, handler(self, self.editCondition))

    self:addEvent(EVENT.TEAM_ARENA.TEAM_ADD_REQ_CLICK_HANDLE, handler(self, self.clickRequest))

    self:addEvent(EVENT.TEAM_ARENA.TEAM_ADD_REQ_HANDLE, handler(self, self.handleRequest))
    self:addEvent(EVENT.TEAM_ARENA.TEAM_ADD_REQ_LIST, handler(self, self.refreshData))
end

function TeamArenaTeamAddReqLayer:reqData()
    local req = TeamArena_pb.GReqTeam()
    NetManager:sendMessage(ProtocolID.GReqTeam, req)

    local req = TeamArena_pb.GReqTeamApplyList()
    NetManager:sendMessage(ProtocolID.GReqTeamApplyList, req)
end

function TeamArenaTeamAddReqLayer:refreshData(event, data)
    self.data = data
    if self.data and self.data.apply_info and #self.data.apply_info <= 0 then
        self.data = nil
    end

    if self.data then dump(self.data, "TeamArenaTeamAddReqLayer:refreshData", 10) end

    self:refreshView()
end

function TeamArenaTeamAddReqLayer:editCondition(event, data)
    self.team_data = data
    if self.team_data and self.team_data.team and self.team_data.team.team_id ~= 0 then
        self:refreshCondition(data.team.min_lv, data.team.min_fighting)
    else
        self.team_data = nil
    end
end

function TeamArenaTeamAddReqLayer:handleRequest(event, data)
    if self.data and self.data.apply_info and #self.data.apply_info > 0 then
        for i, v in ipairs(self.data.apply_info) do
            if v.member.player_id == data.member_id then
                table.remove(self.data.apply_info, i)
                break
            end
        end
    end

    self:refreshView()
end

function TeamArenaTeamAddReqLayer:clickRequest(event, data)
    if data.op == 1 and self.team_data and #self.team_data.team.member >= 3 then
        ex.MessageView:add(ex.Tools:getLang(74308))
        return
    end

    local req = TeamArena_pb.GReqTeamHandleApply()
    req.member_id = data.member_id
    req.op = data.op
    NetManager:sendMessage(ProtocolID.GReqTeamHandleApply, req)
end

function TeamArenaTeamAddReqLayer:refreshView()
    local is_exsit_player = self.data and self.data.apply_info and #self.data.apply_info > 0
    
    self.node_null:setVisible(not is_exsit_player)
    self.node_not_null:setVisible(is_exsit_player)

    
    if is_exsit_player then
        self:refreshTableView(self.data.apply_info)
    else
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KFSK_ZDJJC_ZDDT_WDDW_TJWJ_RDSQ, false)
        self:refreshTableView(nil)
    end
end

function TeamArenaTeamAddReqLayer:refreshCondition(min_lv, min_fighting)
    self.lbl_min_level:setString(min_lv > 0 and string.format(ex.Tools:getLang(74251), min_lv) or ex.Tools:getLang(74250))
    self.lbl_min_power:setString(min_fighting > 0 and string.format(ex.Tools:getLang(74252), ex.StringUtil.getScientificNumber(min_fighting)) or ex.Tools:getLang(74250))
end

function TeamArenaTeamAddReqLayer:refreshTableView(list)
    if not list or #list <= 0 then
        return
    end

    if not self.table_view then
        local margin = 6
        local table_view_size = self.node_not_null:getContentSize()
        table_view_size.width = table_view_size.width - 6
        table_view_size.height = table_view_size.height - 6
        self.table_view = ex.Tools:initTableView(self.node_not_null, list, {TeamArenaTeamAddReqCell, "ccbi/TeamArenaTeamAddReqCell.ccbi" }, table_view_size, margin, cc.p(3,3))
    else
        self.table_view:initData(list)
        self.table_view:reloadData()
    end
end

function TeamArenaTeamAddReqLayer:onAdjust(tag, pSender)
    if self.team_data then
        require("src.layer.teamarena.TeamArenaConditionCtrl"):instance():openWindow(self.team_data)
    else
        printError("TeamArenaTeamAddReqLayer:onAdjust 队伍数据为空")
    end
end

function TeamArenaTeamAddReqLayer:onRefresh(tag, pSender)
    local req = TeamArena_pb.GReqTeamApplyList()
    NetManager:sendMessage(ProtocolID.GReqTeamApplyList, req)
end

return TeamArenaTeamAddReqLayer