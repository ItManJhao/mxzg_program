local ClanGvgHistoryCtr = class("ClanGvgHistoryCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ClanGvgHistoryLayer = class("ClanGvgHistoryLayer", require("src.comp.LuaLayerBase"))

local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

local ClanGvgHistoryCell = class("ClanGvgHistoryCell", require("src.comp.LuaLayerBase"))
function ClanGvgHistoryCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self:setName("cell_layer")
end

function ClanGvgHistoryCell:addSwordAction()
    self.spr_result:setVisible(false)

    -- 添加刀剑特效
    local spine_sword = sp.SkeletonAnimation:create("spine/battle-sword.json","spine/battle-sword.atlas", 1)
    spine_sword:setAnimation(0, "stand", true);
    spine_sword:setPosition(self.spr_result:getPositionX(), self.spr_result:getPositionY() - 15)
    spine_sword:setScale(0.4)
    self:addChild(spine_sword, 10)
end

function ClanGvgHistoryCell:reset(data)
    if data == nil then
        return
    end

    self.battle_id = data.battle_id

    if data.is_win == nil then
        self.spr_result:setVisible(false)
    else
        if data.is_win == true then
            -- self.spr_result:setSpriteFrame("clan-gvg-lang/spr-gvg-win.png")
            ex.Tools:setSpriteFrame(self.spr_result, "clan-gvg-lang/spr-gvg-win.png")
        else
            -- self.spr_result:setSpriteFrame("clan-gvg-lang/spr-gvg-fail.png")
            ex.Tools:setSpriteFrame(self.spr_result, "clan-gvg-lang/spr-gvg-fail.png")
            self.spr_cell_bg:setVisible(false)
        end
    end

    if data.hero_type_1 ~= nil and data.hero_star_1 ~= nil then
        if self.spr_clan_photo_1 == nil then
            self.spr_clan_photo_1 = UIMenuItemHero:createWithData("1", data.hero_type_1, nil, data.hero_level_1, data.hero_star_1)
            if data.fashion_id_1 ~= 0 and data.fashion_id_1 ~= nil then   -- 有皮肤
                self.spr_clan_photo_1:setFashionShowForce(data.fashion_id_1)
            end
            self.spr_clan_photo_1:setScale(0.8)
            self.spr_clan_photo_1:setPosition(60, self:getContentSize().height / 2)
            self:addChild(self.spr_clan_photo_1, 50)
        else
            self.spr_clan_photo_1:setIcon(data.hero_type_1)
            self.spr_clan_photo_1:setLevel(data.hero_level_1)
            self.spr_clan_photo_1:setStar(data.hero_star_1)
        end
    end

    if data.player_name_1 ~= nil then
        self.lbl_clan_name_1:setString(data.player_name_1)
        if data.server_id_1 ~= nil then
            self.lbl_server_name_1:setString(ex.StringUtil.getServerName(data.server_id_1))
        else
            self.lbl_server_name_1:setString("")
        end
    else
        self.lbl_clan_name_1:setString("")
        self.lbl_server_name_1:setString("")
    end

    if data.hero_type_2 ~= nil and data.hero_star_2 ~= nil then
        if self.spr_clan_photo_2 == nil then
            self.spr_clan_photo_2 = UIMenuItemHero:createWithData("1", data.hero_type_2, nil, data.hero_level_2, data.hero_star_2)
            if data.fashion_id_2 ~= 0 and data.fashion_id_2 ~= nil then   -- 有皮肤
                self.spr_clan_photo_2:setFashionShowForce(data.fashion_id_2)
            end
            self.spr_clan_photo_2:setScale(0.8)
            self.spr_clan_photo_2:setPosition(self:getContentSize().width - 60, self:getContentSize().height / 2)
            self:addChild(self.spr_clan_photo_2, 50)
        else
            self.spr_clan_photo_2:setIcon(data.hero_type_2)
            self.spr_clan_photo_2:setLevel(data.hero_level_2)
            self.spr_clan_photo_2:setStar(data.hero_star_2)
        end
    end

    if data.player_name_2 ~= nil then
        self.lbl_clan_name_2:setString(data.player_name_2)
        if data.server_id_2 ~= nil then
            self.lbl_server_name_2:setString(ex.StringUtil.getServerName(data.server_id_2))
        else
            self.lbl_server_name_2:setString("")
        end
    else
        self.lbl_clan_name_2:setString("")
        self.lbl_server_name_2:setString("")
    end
end

function ClanGvgHistoryLayer:onCreate()
    self:addBlackBackground()

    local last_content_size = self:getContentSize()
    local cur_content_size = cc.size(ex.p.width - 20, ex.p.height - 220)
    local offset = cc.p(cur_content_size.width - last_content_size.width, cur_content_size.height - last_content_size.height)

    self:setContentSize(cur_content_size)
    self:setPosition(ex.p.width / 2 - self:getContentSize().width / 2, ex.p.height / 2 - self:getContentSize().height / 2 + 20)

    self.spr_bg:setContentSize(cc.size(cur_content_size.width + 20, cur_content_size.height + 20))
    self.spr_bg:setPosition(-10, -10)
    self.btn_close:setPosition(cur_content_size.width - 40, cur_content_size.height - 25)

    self.btn_left:setChecked(true)
    self.btn_left:setTag(1)
    self.btn_right:setTag(2)
    self.btn_left:setPosition(self.btn_left:getPositionX() + offset.x / 2, self.btn_left:getPositionY() + offset.y)
    self.btn_right:setPosition(self.btn_right:getPositionX() + offset.x / 2, self.btn_right:getPositionY() + offset.y)
    self.btn_left:setLabelText(ex.Tools:getLang(70131))
    self.btn_right:setLabelText(ex.Tools:getLang(70132))

    self.spr_title_bg:setPosition(self.spr_title_bg:getPositionX() + offset.x / 2, self.spr_title_bg:getPositionY() + offset.y)
    self.lbl_title:setPosition(self.lbl_title:getPositionX() + offset.x / 2, self.lbl_title:getPositionY() + offset.y)

    self.node_clan_info:setPosition(self.node_clan_info:getPositionX() + offset.x / 2, self.node_clan_info:getPositionY() + offset.y)
    self.node_clan_info:setVisible(false)

    self.spr_tableview_bg:setContentSize(cc.size(self.spr_tableview_bg:getContentSize().width + offset.x, self.spr_tableview_bg:getContentSize().height + offset.y))

    -- 初始化tableview
    local view_size = cc.size(self.spr_tableview_bg:getContentSize().width - 20, self.spr_tableview_bg:getContentSize().height - 10)
    local pos = cc.p(self.spr_tableview_bg:getPositionX() + 10, self.spr_tableview_bg:getPositionY() + 5)
    self.table_view = ex.Tools:initTableView(self, {}, {ClanGvgHistoryCell, "ccbi/ClanGvgHistoryCell.ccbi"}, view_size, 5, pos)

    self.lbl_tip:setString(ex.Tools:getLang(70130))

    self.self_rank_layer = ClanGvgHistoryCell:createWithCCBIFile("ccbi/ClanGvgHistoryCell.ccbi")
    self.self_rank_layer:addSwordAction()
    self.self_rank_layer:setScale((self.spr_tableview_bg:getContentSize().width - 20) / self.self_rank_layer:getContentSize().width)
    self.self_rank_layer:setPosition(0, 0)
    self.btn_battling_team:addChild(self.self_rank_layer)
    self.btn_battling_team:setContentSize(self.self_rank_layer:getContentSize())
end

-----------------------------------------------------------------------------
function ClanGvgHistoryCtr:onCreate()
	self:setCCBIPath("ccbi/ClanGvgHistoryLayer.ccbi")
	self:setIsSingle(false)
end

function ClanGvgHistoryCtr:getLayerClass()
	return ClanGvgHistoryLayer
end

function ClanGvgHistoryCtr:getClanGvgHistoryLayer()
	return self.layer
end

function ClanGvgHistoryCtr:openWindow(road_type)
	if self:isOpened() then
		return
	end

    local gvg_info = ex.Player.clan_data.clan_gvg_info
    if gvg_info.stage == 4 or gvg_info.stage == 5 then

    else
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/clan-gvg.plist")
    sfc:addSpriteFrames("ccbi-res/clan-gvg-lang.plist")

	self:loadLayer()
	self:open()
	self:initData(road_type)
end

function ClanGvgHistoryCtr:initData(road_type)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    self.layer.btn_left:registerScriptTapHandler(handler(self, self.onTab))
    self.layer.btn_right:registerScriptTapHandler(handler(self, self.onTab))

    self.layer.btn_battling_team:registerScriptTapHandler(handler(self, self.onBattlingCell))

    self.layer.table_view.cellTouchedCB = handler(self, self.tableCellTouched)
    
    self.road_type = road_type
    self.layer_type = 1

    local gvg_info = ex.Player.clan_data.clan_gvg_info
    if gvg_info.stage == 5 then
        self.layer_type = 2

        self.layer.btn_left:setVisible(false)
        self.layer.btn_right:setAnchorPoint(0.5, 0.5)
        self.layer.btn_right:setPositionX(self.layer:getContentSize().width / 2)
        self.layer.btn_right:setNormalImage(cc.Sprite:createWithSpriteFrameName("button/btn-tab-13.png"))
        self.layer.btn_right:setSelectedImage(cc.Sprite:createWithSpriteFrameName("button/btn-tab-14.png"))

        self.layer.btn_right:setChecked(true)
    elseif gvg_info.stage == 4 then
        
    else
        return
    end

    self.layer.lbl_title:setString(ex.Tools:getLang(70125 + self.road_type))

    -- 打开界面时，请求刷新数据，因为打开界面时有动画遮掩时间差，且战斗内容需要及时展示，所以无需设置请求cd
    self:reqRefresh()

    -- 刷新界面，在收到最新响应后也会调用刷新函数
    -- self:updateLayer()
end

-- 请求刷新消息
function ClanGvgHistoryCtr:reqRefresh()
    if not self:getLayer() then
        return
    end

    if self.layer_type == 1 then
        local req_road_info = ClanWar_pb.GReqScanBattlingInfo()
        req_road_info.road = self.road_type
        NetManager:sendMessage(ProtocolID.GReqScanBattlingInfo, req_road_info)
    else
        local req_road_info = ClanWar_pb.GReqScanHisBattlingInfo()
        req_road_info.road = self.road_type
        NetManager:sendMessage(ProtocolID.GReqScanHisBattlingInfo, req_road_info)
    end
    NetManager:sendMessage(ProtocolID.GReqScanWarInfo)
end

function ClanGvgHistoryCtr:onTab(tag, pSender)
    self.layer_type = tag

    -- 打开界面时，请求刷新数据，因为打开界面时有动画遮掩时间差，且战斗内容需要及时展示，所以无需设置请求cd
    self:reqRefresh()

    -- self:updateLayer()
end

function ClanGvgHistoryCtr:updateLayer()
    if not self:getLayer() then
        return
    end

    self:updateTableView()
end

function ClanGvgHistoryCtr:updateTableView()
    if not self:getLayer() then
        return
    end

    print("ClanGvgHistoryCtr:updateTableView")
    
    self.layer.node_clan_info:setVisible(false)

    if self.layer_type == 1 then
        self.layer.table_view:setViewSize(cc.size(self.layer.table_view:getViewSize().width, self.layer.spr_tableview_bg:getContentSize().height - 285))
    else
        self.layer.table_view:setViewSize(cc.size(self.layer.table_view:getViewSize().width, self.layer.spr_tableview_bg:getContentSize().height - 10))
    end

    if self.layer_type == 1 and ex.Player.clan_data.clan_gvg_cur_history_list.detail == nil then
        dump(ex.Player.clan_data.clan_gvg_cur_history_list, "ex.Player.clan_data.clan_gvg_cur_history_list detail is nil")
        return
    end

    local data = {}
    if self.layer_type == 1 then
        -- 当前战况
        -- 提取当前正在对战的公会信息，及当前对战的两个玩家
        for i,v in ipairs(ex.Player.clan_data.clan_gvg_info.war_infos) do
            local total = v.roads[self.road_type].total
            local alive = v.roads[self.road_type].alive
            
            if v.clan_id == ex.Player.clan_data.clan_id then
                self.layer.lbl_clan_name_1:setString(ex.StringUtil.getServerName(v.server_id)..v.name)
                self.layer.lbl_team_tip_1:setString(string.format(ex.Tools:getLang(70129), alive, total))
            else
                self.layer.lbl_clan_name_2:setString(ex.StringUtil.getServerName(v.server_id)..v.name)
                self.layer.lbl_team_tip_2:setString(string.format(ex.Tools:getLang(70129), alive, total))
            end
        end

        local cur_battling_data = {}
        cur_battling_data.battle_id = ex.Player.clan_data.clan_gvg_cur_history_list.detail.battle_id
        for i,v in ipairs(ex.Player.clan_data.clan_gvg_cur_history_list.detail.players) do
            if v.clan_id == ex.Player.clan_data.clan_id then
                cur_battling_data.player_name_1 = v.name
                cur_battling_data.server_id_1 = v.server_id
                cur_battling_data.is_win = v.win > 0

                for i3,v3 in ipairs(v.heros) do
                    if v3.hero_type > 0 and v3.star > 0 then
                        cur_battling_data.hero_type_1 = v3.hero_type
                        cur_battling_data.hero_level_1 = v3.level
                        cur_battling_data.hero_star_1 = v3.star
                        cur_battling_data.fashion_id_1 = v3.fashion_id
                        break
                    end
                end
            else
                cur_battling_data.player_name_2 = v.name
                cur_battling_data.server_id_2 = v.server_id
                cur_battling_data.is_win = true

                for i3,v3 in ipairs(v.heros) do
                    if v3.hero_type > 0 and v3.star > 0 then
                        cur_battling_data.hero_type_2 = v3.hero_type
                        cur_battling_data.hero_level_2 = v3.level
                        cur_battling_data.hero_star_2 = v3.star
                        cur_battling_data.fashion_id_2 = v3.fashion_id
                        break
                    end
                end
            end
        end
        self.layer.self_rank_layer:reset(cur_battling_data)

        local team_max = 0
        for i,v in ipairs(ex.Player.clan_data.clan_gvg_cur_history_list.battling) do
            local count = table.nums(v.teams)
            if team_max < count then
                team_max = count
            end
        end

        -- 数据加载完成后在显示节点，防止显示闪烁
        self.layer.node_clan_info:setVisible(self.layer_type == 1)

        -- 将双方公会成员信息按照出战先后组合两两一对，自己公会的在左，另一方在右
        local offset = 0
        if cur_battling_data.battle_id ~= nil and string.len(cur_battling_data.battle_id) > 0 then
            offset = 1
        end
        for i,v in ipairs(ex.Player.clan_data.clan_gvg_cur_history_list.battling) do
            for i2=1,team_max do
                local v2 = v.teams[i2 + offset]
                if v2 == nil then v2 = {} end
                local tmp_data = data[i2]
                if tmp_data == nil then tmp_data = {} end
                if v.clan_id == ex.Player.clan_data.clan_id then
                    tmp_data.player_name_1 = v2.name
                    tmp_data.server_id_1 = v.server_id

                    tmp_data.hero_type_1 = v2.hero_type
                    tmp_data.hero_level_1 = v2.hero_level
                    tmp_data.hero_star_1 = v2.hero_star
                    tmp_data.fashion_id_1 = v2.fashion_id
                else
                    tmp_data.player_name_2 = v2.name
                    tmp_data.server_id_2 = v.server_id

                    tmp_data.hero_type_2 = v2.hero_type
                    tmp_data.hero_level_2 = v2.hero_level
                    tmp_data.hero_star_2 = v2.hero_star
                    tmp_data.fashion_id_2 = v2.fashion_id
                end
                if table.nums(tmp_data) > 0 and i2 <= table.nums(v.teams) - offset then
                    data[i2] = tmp_data
                end
            end
        end
    else
        -- 历史战况
        for i,v in ipairs(ex.Player.clan_data.clan_gvg_history_list) do
            local tmp_data = {}
            tmp_data.battle_id = v.battle_id
            for i2,v2 in ipairs(v.players) do
                if v2.clan_id == ex.Player.clan_data.clan_id then
                    tmp_data.player_name_1 = v2.name
                    tmp_data.server_id_1 = v.server_id
                    tmp_data.is_win = v2.win > 0

                    for i3,v3 in ipairs(v2.heros) do
                        if v3.hero_type > 0 then
                            tmp_data.hero_type_1 = v3.hero_type
                            tmp_data.hero_level_1 = v3.level
                            tmp_data.hero_star_1 = v3.star
                            tmp_data.fashion_id_1 = v3.fashion_id
                            break
                        end
                    end
                else
                    tmp_data.player_name_2 = v2.name
                    tmp_data.server_id_2 = v.server_id
                    tmp_data.is_win = v2.win <= 0

                    for i3,v3 in ipairs(v2.heros) do
                        if v3.hero_type > 0 then
                            tmp_data.hero_type_2 = v3.hero_type
                            tmp_data.hero_level_2 = v3.level
                            tmp_data.hero_star_2 = v3.star
                            tmp_data.fashion_id_2 = v3.fashion_id
                            break
                        end
                    end
                end
            end
            table.insert(data, tmp_data)
        end
    end

    -- 将数据加载到table_view里
    self.layer.table_view:initData(data)
end

-- 点击cell，向服务器请求战报，只有当前战报里的正在战斗的战况和历史战报才有战报
function ClanGvgHistoryCtr:tableCellTouched(cell)
    local battle_id = cell:getChildByName("cell_layer").battle_id

    if battle_id == nil then
        return
    end

    for i,v in ipairs(ex.Player.clan_data.clan_gvg_history_list) do
        if v.battle_id ~= nil and string.len(v.battle_id) > 0 and v.battle_id == battle_id then
            require("src.layer.clan.ClanGvgBattleInfoCtr"):instance():openWindow(v)
            return
        end
    end
end

-- 点击cell，向服务器请求战报，只有当前战报里的正在战斗的战况和历史战报才有战报
function ClanGvgHistoryCtr:onBattlingCell(tag, pSender)
    local battle_data = ex.Player.clan_data.clan_gvg_cur_history_list.detail
    if battle_data == nil or battle_data.battle_id == nil or string.len(battle_data.battle_id) <= 0 then
        return
    end

    require("src.layer.clan.ClanGvgBattleInfoCtr"):instance():openWindow(battle_data)
end

return ClanGvgHistoryCtr
