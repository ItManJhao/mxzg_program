local ClanGvgLineupMemberCtr = class("ClanGvgLineupMemberCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ClanGvgLineupMemberLayer = class("ClanGvgLineupMemberLayer", require("src.comp.LuaLayerBase"), require("src.comp.EventLayer"))
local UIMenu = require("src.comp.menu.UIMenu")

local ClanGvgLineupMemberCell = class("ClanGvgLineupMemberCell", require("src.comp.LuaLayerBase"))
function ClanGvgLineupMemberCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end

function ClanGvgLineupMemberCell:reset(road_type, road_idx, hero_data, player_name, player_attack, is_self)
    self.lbl_road_idx:setString(string.format("%d", road_idx))
    -- self.spr_road_bg:setSpriteFrame("clan-gvg/spr-road-"..road_type..".png")
    ex.Tools:setSpriteFrame(self.spr_road_bg, "clan-gvg/spr-road-"..road_type..".png")

    self.lbl_name:setString(player_name)
    self.lbl_attack:setString(string.format("%d", player_attack))

    self.is_self = is_self
    self.spr_cell_bg:setVisible(not is_self)

    local item = require("src.comp.menu.UIMenuItemHero"):createWithData("1", hero_data.hero_type, nil, hero_data.hero_level, hero_data.hero_star)
    if hero_data.fashion_id ~= 0 then   -- 有皮肤
        item:setFashionShowForce(hero_data.fashion_id)
    end
    item:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2 + 20)
    self:addChild(item)
end

function ClanGvgLineupMemberLayer:onCreate()
    self:setAutoClose(true)
    self:setSwallowTouches(true)
    self:addBlackBackground()

    local last_content_size = self:getContentSize()
    local cur_content_size = cc.size(ex.p.width - 20, ex.p.height - 220)
    local offset = cc.p(cur_content_size.width - last_content_size.width, cur_content_size.height - last_content_size.height)

    self:setContentSize(cur_content_size)
    self:setPosition(ex.p.width / 2 - self:getContentSize().width / 2, ex.p.height / 2 - self:getContentSize().height / 2 + 20)

    self.lbl_tip:setPositionX(self:getContentSize().width / 2)

    self.spr_bg:setContentSize(cc.size(cur_content_size.width +20, cur_content_size.height + 20))
    self.spr_bg:setPosition(-10, -10)
    self.btn_close:setPosition(cur_content_size.width - 40, cur_content_size.height - 25)

    for i=1,3 do
        self["spr_scroll_bg_"..i]:setContentSize(self["spr_scroll_bg_"..i]:getContentSize().width, cur_content_size.height - 200)

        self["lbl_person_num_"..i]:setPositionY(cur_content_size.height - 180)
        self["spr_road_title_"..i]:setPositionY(cur_content_size.height - 140)
        self["spr_road_tower_"..i]:setPositionY(cur_content_size.height - 165)
        if i == 2 then
            self["spr_road_tower_"..i]:setPositionY(cur_content_size.height - 165 - 7)
        end
    end

    local scroll_bg = self.spr_scroll_bg_1
    self.scroll_size = cc.size(scroll_bg:getContentSize().width * scroll_bg:getScaleX(), scroll_bg:getContentSize().height * scroll_bg:getScaleY() - 10)

    for i=1,3 do
        -- 初始化scroll_view
        local node_road = self["node_road_"..i]
        node_road:setPositionX(node_road:getPositionX() + offset.x / 2)

        self["scroll_view_"..i] = cc.ScrollView:create(self.scroll_size)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setBounceable(false)
        :setPosition(node_road:getPositionX() - self.scroll_size.width / 2, node_road:getPositionY() + 5)
        self:addChild(self["scroll_view_"..i])
    end
end

-----------------------------------------------------------------------------
function ClanGvgLineupMemberCtr:onCreate()
	self:setCCBIPath("ccbi/ClanGvgLineupMemberLayer.ccbi")
    self:setIsSingle(false)
    
end

function ClanGvgLineupMemberCtr:getLayerClass()
	return ClanGvgLineupMemberLayer
end

function ClanGvgLineupMemberCtr:getClanGvgLineupMemberLayer()
	return self.layer
end

-- @param handle_type 操作类型，1：可操作所有对象；2：可操作自己的对象；其他：不可操作
function ClanGvgLineupMemberCtr:openWindow(handle_type)
	if self:isOpened() then
		return
    end
	
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/clan.plist")

	self:loadLayer()
	self:open()
	self:initData(handle_type)
end

function ClanGvgLineupMemberCtr:initData(handle_type)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    self.handle_type = handle_type

    if self.handle_type == 2 then
        self.layer.lbl_tip:setString(ex.Tools:getLang(70124))
    elseif self.handle_type == 1 then
        self.layer.lbl_tip:setString(ex.Tools:getLang(70125))
    else
        self.layer.lbl_tip:setString(ex.Tools:getLang(70141))
    end
    -- -- 初始化模拟数据
    -- -- {{road_type, road_idx, hero_type, hero_star, hero_level, player_name, player_attack}}
    -- ex.Player.clan_data.clan_gvg_team_list = {}
    -- for i=1,3 do
    --     local tmp_table = {}
    --     for j=1,11 do
    --         local data = {}
    --         data.road_type = i
    --         data.road_idx = j
    --         data.rid = i * 100 + j
    --         data.hero_type = 20110006 + math.random(1, 5)
    --         data.hero_star = math.random(1, 11)
    --         data.hero_level = math.random(1, 250)
    --         data.player_name = "player "..(i * 100 + j)
    --         data.fighting = data.hero_star * 1000 + data.hero_level
    --         table.insert(tmp_table, data)
    --     end
    --     ex.Player.clan_data.clan_gvg_team_list[i] = tmp_table
    -- end

	self:updateScrollView()
end

function ClanGvgLineupMemberCtr:updateScrollView()
    if not self:getLayer() then
        return
    end

    if self.layer.select_item ~= nil then
        return
    end

    -- 设置自己所在路的所在位置
    self.layer.lbl_self_idx_1:setVisible(false)
    self.layer.lbl_self_idx_2:setVisible(false)
    self.layer.lbl_self_idx_3:setVisible(false)

    for k,v in pairs(ex.Player.clan_data.clan_gvg_team_list) do
        for i2,v2 in ipairs(v) do
            if v2.rid == ex.Player.role_id then
                self.layer["lbl_self_idx_"..k]:setVisible(true)
                self.layer["lbl_self_idx_"..k]:setString(string.format(ex.Tools:getLang(70123), i2))
            end
        end
    end

    -- 创建三路阵列
    for i=1,3 do
        local scroll_view = self.layer["scroll_view_"..i]

        -- 清空成员，并记录偏移
        local offset_y = scroll_view:getContentOffset().y
        if offset_y >= 0 then
            if scroll_view:getContainer():getChildByTag(999) == nil then
                offset_y = 1
            end
        end
        scroll_view:getContainer():removeAllChildren()
        scroll_view:setTouchEnabled(true)

        local team_road = ex.Player.clan_data.clan_gvg_team_list[i]

        local team_count = 0
        if team_road ~= nil then
            team_count = table.nums(team_road)
        end
        self.layer["lbl_person_num_"..i]:setString(string.format(ex.Tools:getLang(70122), team_count))

        -- 添加对应的成员节点
        local player_count = 0
        local menu = nil
        if team_road ~= nil then

            menu = UIMenu:create()
            menu:setIsTouchInsideNode(scroll_view)
            menu:setSwallowsTouches(false)
            menu:setPosition(cc.p(0, 0))
            menu:setTag(999)
            scroll_view:getContainer():addChild(menu)

            -- 开启menu的移动和移动结束侦听
            menu:enableExchange(true)
            menu:setTouchMoveCallback(handler(self, self.onMemberMove))
            menu:setTouchEndCallback(handler(self, self.onMemberMoveEnd))

            player_count = table.nums(team_road)
            for i2,v2 in ipairs(team_road) do
                local j = player_count - i2 + 1
                local hero_data = {}
                hero_data.hero_type = v2.hero_type
                hero_data.hero_star = v2.hero_star
                hero_data.hero_level = v2.hero_level
                hero_data.fashion_id = v2.fashion_id
                local item_player = ClanGvgLineupMemberCell:createWithCCBIFile("ccbi/ClanGvgLineupMemberCell.ccbi")
                item_player:setAnchorPoint(0, 0)
                item_player:setPosition(0, 0)
                item_player:reset(i, i2, hero_data, v2.name, v2.fighting, v2.rid == ex.Player.role_id)

                local item = cpp.UIMenuItemImage:create()
                item:setEnableAction(false)
                item:setContentSize(item_player:getContentSize())
                item:setPosition(6 + item_player:getContentSize().width / 2, (j - 0.5) * (item_player:getContentSize().height + 5))
                item:registerScriptTapHandler(handler(self, self.onMemberSelect))
                menu:addChild(item)

                item.is_self = v2.rid == ex.Player.role_id

                item:addChild(item_player)

                item:setTag(i * 100 + i2)
            end
        end

        -- 设置偏移值
        local total_height = player_count * 205
        if self.layer.scroll_size.height > total_height then
            scroll_view:setContentSize(self.layer.scroll_size)
            scroll_view:setContentOffset(cc.p(0, 0))

            if menu ~= nil then
                local offset_y = self.layer.scroll_size.height - total_height
                local vec_child = menu:getChildren()
                for i,v in ipairs(vec_child) do
                    v:setPositionY(v:getPositionY() + offset_y)
                end
            end
        else
            scroll_view:setContentSize(cc.size(self.layer.scroll_size.width, total_height))
            if offset_y <= 0 and offset_y > self.layer.scroll_size.height - total_height then
                scroll_view:setContentOffset(cc.p(0, offset_y))
            else
                scroll_view:setContentOffset(cc.p(0, self.layer.scroll_size.height - total_height))
            end
        end
    end
end

function ClanGvgLineupMemberCtr:onMemberSelect(tag, pSender)
    print("ClanGvgLineupMemberCtr:onMemberSelect", tag)
    local road_type = math.floor(tag / 100)
    local road_idx = math.floor(tag % 100)

    local team_road = ex.Player.clan_data.clan_gvg_team_list[road_type]
    if team_road == nil then
        print("ClanGvgLineupMemberCtr:onMemberMoveEnd team_road is nil")
        return
    end
    local team_data = nil
    for i,v in ipairs(team_road) do
        if i == road_idx then
            team_data = v
            break
        end
    end
    if team_data == nil then
        return
    end

    -- 请求访问角色数据
    local req_player_info = ClanWar_pb.GReqScanMemberRoadInfo()
    req_player_info.rid = team_data.rid
    NetManager:sendMessage(ProtocolID.GReqScanMemberRoadInfo, req_player_info)
end

function ClanGvgLineupMemberCtr:onMemberMove(item, touch_pos)
    if item == nil then
        return
    end

    if self.handle_type ~= 1 and (self.handle_type ~= 2 or item.is_self ~= true) then
        return
    end

    -- 如果点的移动向量在第四象限，则停止scrollview的滑动，并跟踪item位置
    local touch_began = item:getParent().touch_begin
    if math.abs(touch_began.x - touch_pos.x) <= math.abs(touch_began.y - touch_pos.y) * 2 and self.layer.select_item == nil then
        return
    end

    local tag = item:getTag()
    local i = math.floor(tag / 100)
    local j = math.floor(tag % 100)
    -- 点击对应成员时，对应成员隐藏，并创建一个新的item使之随手指移动
    local node_scroll = item:getParent():getParent():getParent()
    node_scroll:setTouchEnabled(false)

    item:setPosition(touch_pos)

    -- 将触摸点相对于menu中的位置转换成相对于当前层中的位置
    local pos_menu = cc.p(touch_pos.x + item:getParent():getPositionX() + item:getParent():getParent():getPositionX(), touch_pos.y + item:getParent():getPositionY() + item:getParent():getParent():getPositionY())
    local pos = cc.p(pos_menu.x + node_scroll:getPositionX(), pos_menu.y + node_scroll:getPositionY())

    local team_road = ex.Player.clan_data.clan_gvg_team_list[math.floor(tag / 100)]
    if team_road == nil then
        print("ClanGvgLineupMemberCtr:onMemberMoveEnd team_road is nil")
        return
    end
    local team_data = nil
    for i,v in ipairs(team_road) do
        if i == tag % 100 then
            team_data = v
            break
        end
    end
    if team_data == nil then
        return
    end

    -- 创建一个一样的item放在当前层中对应位置
    if self.layer.select_item == nil then
        local item_player = ClanGvgLineupMemberCell:createWithCCBIFile("ccbi/ClanGvgLineupMemberCell.ccbi")
        item_player:setAnchorPoint(0, 0)
        item_player:setPosition(0, 0)
        item_player:reset(i, j, team_data, team_data.name, team_data.fighting, team_data.rid == ex.Player.role_id)

        self.layer.select_item = cpp.UIMenuItemImage:create()
        self.layer.select_item:setEnableAction(false)
        self.layer.select_item:setContentSize(item_player:getContentSize())
        self.layer.select_item:setPosition(pos)
        self.layer.select_item:registerScriptTapHandler(handler(self, self.onMemberSelect))
        self.layer:addChild(self.layer.select_item, 999)

        self.layer.select_item:addChild(item_player)

        self.layer.select_item:setTag(tag)
    end
    self.layer.select_item:setPosition(pos)
end

function ClanGvgLineupMemberCtr:onMemberMoveEnd()
    if self.layer.select_item == nil then
        return
    end

    -- 移动结束后，记录创建的item位置并销毁该item
    local pos_des_x, pos_des_y = self.layer.select_item:getPosition()
    local tag = self.layer.select_item:getTag()

    print("ClanGvgLineupMemberCtr:onMemberMoveEnd", tag)

    self.layer.select_item:removeFromParent()
    self.layer.select_item = nil

    local team_road = ex.Player.clan_data.clan_gvg_team_list[math.floor(tag / 100)]
    if team_road == nil then
        print("ClanGvgLineupMemberCtr:onMemberMoveEnd team_road is nil")
        return
    end
    local team_data = nil
    for i,v in ipairs(team_road) do
        if i == tag % 100 then
            team_data = v
            break
        end
    end
    if team_data == nil then
        return
    end

    -- 确定在哪个scroll_view区域
    local road_des = 1
    local idx_des = 1
    for i=1,3 do
        local scroll_view = self.layer["scroll_view_"..i]
        
        if pos_des_x > scroll_view:getPositionX() and pos_des_x < scroll_view:getPositionX() + scroll_view:getViewSize().width--[[ and
        pos_des_y > scroll_view:getPositionY() and pos_des_y < scroll_view:getPositionY() + scroll_view:getViewSize().height]] then
            road_des = i

            -- 确定归属所在路线的位置
            local menu = scroll_view:getContainer():getChildByTag(999)
            if menu ~= nil then
                local pos_y_des_in_menu = pos_des_y - scroll_view:getPositionY() - scroll_view:getContainer():getPositionY()

                local vec_child = menu:getChildren()
                for i2,item in ipairs(vec_child) do
                    -- 如果在该item所在位置上一格区域内，或该item所在位置下一格区域内，则返回该item所在的idx值
                    print("pos_y_des_in_menu", pos_y_des_in_menu, "item pos_y", item:getPositionY(), "item height", item:getContentSize().height, item:getTag())
                    if pos_y_des_in_menu > item:getPositionY() then
                        if pos_y_des_in_menu < item:getPositionY() + item:getContentSize().height or item:getTag() % 10 <= 1 then
                            idx_des = item:getTag() % 100
                            break
                        end
                    elseif pos_y_des_in_menu < item:getPositionY() then
                        if pos_y_des_in_menu > item:getPositionY() - item:getContentSize().height or item:getTag() % 10 >= table.nums(vec_child) then
                            idx_des = item:getTag() % 100 + 1
                            break
                        end
                    end
                end
            end
        
            break
        end
    end

    -- 如果确定了目标所属路线，并目标的路线已经改变了，则对目标的数据进行修正，并向服务器发送修改请求
    -- if road_des > 0 then
        print("target:", road_des, idx_des)
        -- 将选中的item对目标路线进行插入处理

        -- 向服务器发送请求
        local req_lineup_change = ClanWar_pb.GReqAdjustRoadSort()
        req_lineup_change.rid = team_data.rid
        req_lineup_change.road = road_des
        req_lineup_change.sort = idx_des
        NetManager:sendMessage(ProtocolID.GReqAdjustRoadSort, req_lineup_change)
    -- end

    -- 刷新界面显示
    self:updateScrollView()
end

return ClanGvgLineupMemberCtr
