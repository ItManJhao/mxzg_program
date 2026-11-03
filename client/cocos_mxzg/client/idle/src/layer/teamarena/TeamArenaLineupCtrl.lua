--[[
    func: 组队布阵，队长界面
    author:徐东浩
    time:2020-04-13 15:57:12
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local TeamArenaLineupCtrl = class("TeamArenaLineupCtrl", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local TeamArenaLineupLayer = class("TeamArenaLineupLayer", require("src.comp.EventLayer"))
local TeamArenaLineupCell = class("TeamArenaLineupCell", require("src.comp.EventLayer"))
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")


function TeamArenaLineupCell:onCreate()
    self:setAutoClose(true)
    self:setSwallowTouches(false)

    self.data = {}
    self.hide_callback = nil

    self.btn_hide:registerScriptTapHandler(handler(self, self.OnHide))

    self.node_null_pos = {self.node_pos_1, self.node_pos_2, self.node_pos_3, self.node_pos_4, self.node_pos_5, self.node_pos_6, self.node_pos_7, self.node_pos_8}

    self.menu:setSwallowsTouches(false)
    self.menu:setLocalZOrder(10)

    self.menu_hero = cpp.UIMenu:create()
    self.menu_hero:setPosition(0, 0)
    self.menu_hero:setSwallowsTouches(false)
    self.menu_hero:setLocalZOrder(10)
    self.node_hero:addChild(self.menu_hero)
end

function TeamArenaLineupCell:initData(data)
    self.data = data

    self.lbl_name:setString(self.data.member.nick)
    self.lbl_power:setString(tostring(self.data.fighting))

    self:showHeroTeam(self.data.hero_data, self.data.formation_id)

    self:refreshFetters(self.data.goddess_type)
    self:refreshContract(self.data.formation_id)

    self:setSelected(self.data.hidden)
end

function TeamArenaLineupCell:showHeroTeam(hero_list, formation_id)
    self.menu_hero:removeAllChildren()

    local config_matrix = cfg.battlematrixaddition.battlematrixaddition
    for pos=1,LineupNum do
        local item_pos = ex.p.zero
        if self.node_null_pos[pos] then
            -- self.node_null_pos[v.pos]:setVisible(false)
            item_pos = cc.p(self.node_null_pos[pos]:getPosition())
        end

        local is_open = false
        for _,matrix in pairs(config_matrix) do
            if matrix.type == formation_id and matrix.position == pos then
                is_open = matrix.is_open == 1
                break
            end
        end

        if is_open == true then
            self["spr_lock_"..pos]:setVisible(false)

            local hero_data = nil
            for i,v in ipairs(hero_list) do
                if v.pos == pos then
                    hero_data = v
                    break
                end
            end
            if hero_data ~= nil then
                local hero_config = cfg.herotype.star[hero_data.hero_type]
                local item = UIMenuItemHero:createWithData(hero_data.hero_id, hero_data.hero_type, hero_config ~= nil and hero_config.elem or 0, hero_data.level, hero_data.star)
                item:setScale(0.7)
                item:setPosition(item_pos)
                self.menu_hero:addChild(item)
                item:registerScriptTapHandler(handler(self, self.onHero))
            end
        end
    end
end

function TeamArenaLineupCell:refreshFetters(fetters_id)
    self.node_fetters:setVisible(fetters_id ~= 0)

    if fetters_id ~= 0 then
        local skin = ex.Player.fetter_data:getSkin(fetters_id or 0)
        ex.Tools:setSpriteFrame(self.spr_fetters, string.format("hero-icon/%d.png", skin))
    end
end

function TeamArenaLineupCell:refreshContract(formation_id)
    self.node_contract:setVisible(formation_id ~= 0)

    if formation_id ~= 0 then
        ex.Tools:setSpriteFrame(self.spr_contract, string.format('hero-select/spr-matrix-1-%d.png', formation_id))
        self.lbl_contract:setString(ex.Tools:getLang(cfg.battlematrix.battlematrix[formation_id].ability_lang))
    end
end

function TeamArenaLineupCell:setSelected(selected)
    self.data.hidden = selected

    self.btn_hide:setChecked(selected)
end

function TeamArenaLineupCell:getSelected()
    return self.btn_hide:isChecked()
end

function TeamArenaLineupCell:OnHide(tag, pSender)
    if self.hide_callback then
        self.hide_callback(self.data.member.player_id, self:getSelected())
    end
end

function TeamArenaLineupCell:onHero(tag, pSender)
    ex.Tools:showHeroInfo(self.data.member.player_id, self.data.member.server_id, pSender.hero_id)
end

-----------------------------------------------------------------------------

function TeamArenaLineupLayer:onCreate()
    self:addBlackBackground()

    self:setScale(ex.s.global_scale)

    -- self.is_touch_enable = true -- 控制点击
    self.item_list = {}
    self.cell_space = 6

    self.menu_exchange = nil
end

function TeamArenaLineupLayer:refershScrollView(data)
    self.item_list = {}
    self.scroll_view:getContainer():removeAllChildren()

    local scroll_view_size = self.scroll_view:getViewSize()
    local cell_size, count_height = nil, 0
    local count = #data
    for i, v in ipairs(data) do
        local cell = TeamArenaLineupCell:createWithCCBIFile("ccbi/TeamArenaLineupCell.ccbi")
        if not cell_size then
            cell_size = cell:getContentSize()
        end
        
        if count_height <= 0 then
            count_height = count * cell_size.height + (count + 1) * self.cell_space
        end

        cell:setPosition((scroll_view_size.width - cell_size.width) / 2, count_height - i * (cell_size.height + self.cell_space))
        self.scroll_view:addChild(cell)
        
        cell:initData(v)

        cell.menu_hero:setIsTouchInsideNode(self.scroll_view)
        cell.menu:setIsTouchInsideNode(self.scroll_view)
        cell.hide_callback = handler(self, self.onHide)
        
        table.insert(self.item_list, cell)
    end

    self.scroll_view:setContentSize(cc.size(self.scroll_view:getViewSize().width, count_height))
    self.scroll_view:setContentOffset(self.scroll_view:minContainerOffset())

    self.menu_exchange = cpp.UIMenu:create()
    self.menu_exchange:setPosition(0, 0)
    self.menu_exchange:setIsTouchInsideNode(self.scroll_view)
    self.menu_exchange:setSwallowsTouches(false)
    self.menu_exchange:setLocalZOrder(100)
    self.scroll_view:addChild(self.menu_exchange)

    local btn_size = nil
    for i, v in ipairs(self.item_list) do
        if i >= #self.item_list then
            break   -- 最后一个不加
        end

        local btn_exchange = cpp.UIMenuItemImage:createWithSpriteFrameName("team-arena/btn_exchange.png", nil, nil)
        btn_exchange:registerScriptTapHandler(handler(self, self.onExchange))
        btn_exchange:setTag(i)

        if not btn_size then
            btn_size = btn_exchange:getContentSize()
        end

        local pos = cc.p(v:getPosition())
        pos.x = pos.x + cell_size.width - btn_size.width / 2
        pos.y = pos.y - self.cell_space / 2

        btn_exchange:setPosition(pos)
        self.menu_exchange:addChild(btn_exchange)
    end
end

function TeamArenaLineupLayer:onHide(rid, is_checked)
    self:setSelectTeam(rid, is_checked)
end

function TeamArenaLineupLayer:setSelectTeam(rid, is_checked)
    if is_checked then
        for i,v in ipairs(self.item_list) do
            v:setSelected(v.data.member.player_id == rid)
        end
    else
        for i,v in ipairs(self.item_list) do
            if v.data.member.player_id == rid then
                v:setSelected(is_checked)
            end
        end
    end
end

function TeamArenaLineupLayer:onExchange(tag, pSender)
    local idx = pSender:getTag()

    if idx > #self.item_list then
        return
    end

    self:exchangeEffect(self.item_list[idx], self.item_list[idx + 1], idx)
end

-- function TeamArenaLineupLayer:isTouchInside(touch)
-- 	return self.is_touch_enable
-- end

function TeamArenaLineupLayer:exchangeEffect(up_cell, down_cell, idx)
    local up_pos = cc.p(up_cell:getPosition())
    local down_pos = cc.p(down_cell:getPosition())

    self:exchangeStart(up_cell, down_cell)

    up_cell:runAction(cc.Sequence:create(cc.MoveTo:create(0.3, down_pos), cc.CallFunc:create(function()
		self:exchangeEnd(up_cell, down_cell, idx)
    end)))
    
    down_cell:runAction(cc.Sequence:create(cc.MoveTo:create(0.3, up_pos)))
end

function TeamArenaLineupLayer:exchangeStart(up_cell, down_cell)
    up_cell:setLocalZOrder(10)
    down_cell:setLocalZOrder(20)

    self.menu_exchange:setEnabled(false)
end

function TeamArenaLineupLayer:exchangeEnd(up_cell, down_cell, idx)
    up_cell:setLocalZOrder(1)
    down_cell:setLocalZOrder(1)

    -- 交换位置
    self.item_list[idx] = down_cell
    self.item_list[idx + 1] = up_cell

    self.menu_exchange:setEnabled(true)
end

function TeamArenaLineupLayer:getTeamOrder()
    local teams = {}
    for i, v in ipairs(self.item_list) do
        table.insert(teams, v.data.member.player_id)
    end

    return teams
end

function TeamArenaLineupLayer:getHideTeams()
    local teams = {}
    for i, v in ipairs(self.item_list) do
        if v:getSelected() then
            table.insert(teams, v.data.member.player_id)
        end
    end

    return teams
end

-----------------------------------------------------------------------------
function TeamArenaLineupCtrl:onCreate()
    self:setCCBIPath("ccbi/TeamArenaLineupLayer.ccbi")
    
    self:setIsSingle(false)

    self.team_data = {}
    self.is_realy = false

    self.event_lists = {}
end

function TeamArenaLineupCtrl:openWindow()
	if self:isOpened() then
		return
    end

    table.insert(self.event_lists, ex.EventManager:add(EVENT.TEAM_ARENA.MY_TEAM_REFRESH, handler(self, self.refreshData)))
    table.insert(self.event_lists, ex.EventManager:add(EVENT.TEAM_ARENA.TEAM_MAIN_TEAM_LINEUP, handler(self, self.refreshData)))
    table.insert(self.event_lists, ex.EventManager:add(EVENT.BATTLE_EVENT.HANG_LINE_UP, handler(self, self.refreshTeam)))
    
    local req = TeamArena_pb.GReqTeam()
    NetManager:sendMessage(ProtocolID.GReqTeam, req)

    self.is_realy = false
    
	self:loadLayer()
    self:open()

	self:init()
end

function TeamArenaLineupCtrl:getLayerClass()
	return TeamArenaLineupLayer
end

function TeamArenaLineupCtrl:refreshTeam()
    local req = TeamArena_pb.GReqTeam()
    NetManager:sendMessage(ProtocolID.GReqTeam, req)
end

function TeamArenaLineupCtrl:closeWindow()
    self.team_data = {}
    self.is_realy = false

    for i, v in ipairs(self.event_lists) do
        ex.EventManager:remove(v)
    end
    self.event_lists = {}

	self:close(self.layer)
end

function TeamArenaLineupCtrl:init()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_person:registerScriptTapHandler(handler(self, self.onPerson))
    self.layer.btn_save:registerScriptTapHandler(handler(self, self.onSave))
end

function TeamArenaLineupCtrl:refreshData(event, data)
    if not self:isOpened() or not data then
		return
    end

    self.team_data = data.team or {}

    self.is_realy = true

    self:refreshView()
end

function TeamArenaLineupCtrl:refreshView()
    if not self.is_realy then
        return
    end

    self.layer:refershScrollView(self.team_data.member)
end

--------------------------响应处理--------------------------
function TeamArenaLineupCtrl:onPerson(fashion_id)
    require("src.layer.HeroSelectCtr"):instance():openWindow(ex.Tools:getLang(74107),
                                                                  ex.Tools:getLang(74108),
                                                                  BattleType.TEAM_ARENA,
                                                                  nil)
end

function TeamArenaLineupCtrl:onSave(tap, pSender)
    if not self.is_realy then
        return
    end

    local req = TeamArena_pb.GReqTeamArenaLineUp()
    req.team_id = self.team_data.team_id

    local team_order = self.layer:getTeamOrder()
    for i, v in ipairs(team_order) do
        table.insert(req.line_up, v)
    end

    local hides = self.layer:getHideTeams()
    for i,v in ipairs(hides) do
        table.insert(req.hidden_member, v)
    end

    NetManager:sendMessage(ProtocolID.GReqTeamArenaLineUp, req)
end
return TeamArenaLineupCtrl
