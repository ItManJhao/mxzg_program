local SmithArtifactLayer = class("SmithArtifactLayer",require("src.comp.EventLayer"))

function SmithArtifactLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.cur_compose_info = nil         -- 当前选中的合成神装信息
    self.god_equip_list = {}            -- 神装列表信息
    self.cur_selected_attr_list = {}    -- 当前选中的属性表

    self.god_equip_team_ui = {
        -- 合成材料节点信息
        [1] = {
            btn_null = self.btn_add_1,
            menu = self.menu_equip_1
        },
        [2] = {
            btn_null = self.btn_add_2,
            menu = self.menu_equip_2
        },
        [3] = {
            btn_null = self.btn_add_3,
            menu = self.menu_equip_3
        }
    }

    self.god_equip_compose_ui = {
        btn_null = self.btn_add_0,
        menu = self.menu_equip_0
    }
    
    for i,v in ipairs(self.god_equip_team_ui) do
        local spr_add = cc.Sprite:createWithSpriteFrameName("other/spr-add-1.png")
        spr_add:setPosition(v.btn_null:getContentSize().width / 2, v.btn_null:getContentSize().height / 2)
        v.btn_null:getNormalImage():addChild(spr_add)

        v.btn_null:registerScriptTapHandler(handler(self, self.onAdd))
    end


    self.compose_need_res = {
        [1] = {
            btn = self.btn_res_bg_1,
        },
        [2] = {
            btn = self.btn_res_bg_2,
        }
    }

    for i,v in ipairs(self.compose_need_res) do
        v.btn:registerScriptTapHandler(handler(self, self.onResBtn))
        local btn_size = v.btn:getContentSize()

        v.label = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 44)
        v.label:setScale(0.5)
        v.label:setAnchorPoint(ex.a.right_center)
        v.label:setColor(FONT_WHITLE)
        v.label:enableOutline(ex.c3b.BLACK, 2)
        v.label:setPosition(btn_size.width - 4, btn_size.height / 2)
        v.btn:addChild(v.label, 1)

        v.spr = cc.Sprite:create()
        v.spr:setScale(0.4)
        v.spr:setAnchorPoint(ex.a.center)
        v.spr:setPosition(0, btn_size.height / 2)
        v.btn:addChild(v.spr, 2)
    end

    local bottom_y = ex.MainSceneCtr:getBottomHeight() + 26

    self.btn_one_key:setPositionY(bottom_y)
    self.btn_compose:setPositionY(bottom_y)

    bottom_y = bottom_y + 84
    self.node_bottom:setPositionY(bottom_y)

    local node_content_size = self.node_content:getContentSize()
    node_content_size.width = node_content_size.width * ex.s.global_scale
    node_content_size.height = node_content_size.height * ex.s.global_scale
    self.node_content:setScale(ex.s.global_scale)
    local pos_y = bottom_y - 8 + node_content_size.height
    self.node_content:setPositionY(pos_y)

    self.node_equip_panel:setScale(ex.s.global_scale)
    pos_y = pos_y + 2 + self.node_equip_panel:getContentSize().height * ex.s.global_scale / 2 + (1 - ex.s.global_scale) * self.node_equip_panel:getContentSize().height
    self.node_equip_panel:setPositionY(pos_y)

    -- self.btn_one_key:registerScriptTapHandler(handler(self, self.onOneKey))
    -- self.btn_compose:registerScriptTapHandler(handler(self, self.onCompose))
    self.btn_info:registerScriptTapHandler(handler(self, self.onInfo))

    -- self.lbl_tip_1:setString(ex.Tools:getLang(41328))
    -- self.lbl_tip_2:setString(ex.Tools:getLang(41329))

    self:refresh()
end

function SmithArtifactLayer:onInfo(tag ,pSender)
	ex.InfoCtr:openWindow(ex.Tools:getLang(42076), ex.Tools:getLang(42077))
end


function SmithArtifactLayer:refresh()
    self:refreshData()

    self:refreshView()
end

function SmithArtifactLayer:refreshView()
    self:refreshAttrPanel()

    self:refreshGodEquipPanel()

    self:refreshNeedRes()
end

function SmithArtifactLayer:refreshData(item_ids)
    -- item_ids = item_ids or {}
 
    -- self.god_equip_list = {}
    -- self.cur_compose_info = nil

    -- for i,v in ipairs(item_ids) do
    --     local equip = ex.Player.backpack_data:getGodEquipDataByID(v)

    --     if equip then
    --         if not self.cur_compose_info then
    --             -- 获得合成材料配置
    --             self.cur_compose_info = cfg.godequipment.getConfigByType(equip.item_type)
    --         end

    --         if self.cur_compose_info and equip.item_type == self.cur_compose_info.equipment_type and self.cur_compose_info.combine_target ~= 0 then
    --             -- 过滤数据，必须相同类型材料，才可以合并，以及过滤顶级星级材料(顶级星级材料无法合成其他类型)
    --             table.insert(self.god_equip_list, equip)
    --         end
    --     end
    -- end
end

function SmithArtifactLayer:refreshAttrPanel()
    -- self.cur_selected_attr_list = {}
    -- local attr_list = self:countComposeAttr(self.god_equip_list)

    -- self.node_no_null:setVisible(#attr_list > 0)
    -- self.node_null:setVisible(#attr_list <= 0)
    -- if #attr_list > 0 then
    --     for i, v in ipairs(self.god_equip_attr_ui) do
    --         v.btn.local_data = nil
    --         local attr = attr_list[i]
    --         if attr then
    --             v.node:setVisible(true)
    --             v.btn:setVisible(true)
    --             v.btn:setChecked(false)

    --             v.btn.local_data = attr

    --             local attr_show_type = cfg.attrshow.attrshow[attr.sys_id].icon
    --             ex.Tools:setSpriteFrame(v.spr, string.format("hero-info/spr-attr-%d.png", attr_show_type or 101))

    --             v.label:setXmlTextLua(ex.Tools:getAttrRareTextXML(attr.god_equip_ability_config.ability[1].attr, attr.god_equip_ability_config.ability[1].value, attr.god_equip_ability_config.rare))
    --         else
    --             v.node:setVisible(false)
    --             v.btn:setVisible(false)
    --         end
    --     end
    -- end
end

function SmithArtifactLayer:refreshGodEquipPanel()
    for i, v in ipairs(self.god_equip_team_ui) do
        local equip = self.god_equip_list[i]
        if equip then
            v.btn_null:setVisible(false)

            if v.btn_item then
                v.btn_item:removeFromParent()
                v.btn_item = nil
            end

            v.btn_item = ex.Tools:createBackpackItem(equip.item_type, 1)
            v.btn_item:setEnableAction(true)
            v.btn_item:setScale(0.885)
            v.btn_item:setAnchorPoint(ex.a.center)
            v.btn_item:setPosition(ex.p.zero)
            v.menu:addChild(v.btn_item)

            v.btn_item:registerScriptTapHandler(handler(self, self.onAdd))
        else
            if v.btn_item then v.btn_item:setVisible(false) end

            v.btn_null:setVisible(true)
        end
    end

    if self.cur_compose_info and self.cur_compose_info.combine_target ~= 0 then
        -- 有合成
        self.god_equip_compose_ui.btn_null:setVisible(false)

        if self.god_equip_compose_ui.btn_item then
            self.god_equip_compose_ui.btn_item:removeFromParent()
            self.god_equip_compose_ui.btn_item = nil
        end

        self.god_equip_compose_ui.btn_item = ex.Tools:createBackpackItem(self.cur_compose_info.combine_target, 1)
        self.god_equip_compose_ui.btn_item:setEnableAction(true)
        self.god_equip_compose_ui.btn_item:setScale(1.058)
        self.god_equip_compose_ui.btn_item:setAnchorPoint(ex.a.center)
        self.god_equip_compose_ui.btn_item:setPosition(ex.p.zero)
        self.god_equip_compose_ui.menu:addChild(self.god_equip_compose_ui.btn_item)

        self.god_equip_compose_ui.btn_item:registerScriptTapHandler(handler(self, self.onShowInfo))
    else
        -- 无合成
        if self.god_equip_compose_ui.btn_item then self.god_equip_compose_ui.btn_item:setVisible(false) end

        self.god_equip_compose_ui.btn_null:setVisible(true)
    end
end

function SmithArtifactLayer:refreshNeedRes()
    self.node_bottom:setVisible(self.cur_compose_info ~= nil)

    if self.cur_compose_info then
        for i, v in ipairs(self.compose_need_res) do
            local is_show = self.cur_compose_info.up_star_cost and #self.cur_compose_info.up_star_cost >= i
            v.btn:setVisible(is_show)

            if is_show then
                local res = self.cur_compose_info.up_star_cost[i]

                v.btn.local_data = res.item_type

                ex.Tools:setSpriteFrame(v.spr, string.format("backpack/%d.png", res.item_type))

                local total = ex.Player:getItemNum(res.item_type)
                v.label:setString(string.format("%d/%d", total, res.item_num))

                if total >= res.item_num then
                    v.label:setColor(cc.c3b(255,255,255))
                else
                    v.label:setColor(cc.c3b(236,0,0))
                end
            end
        end
    end
end

function SmithArtifactLayer:onShowInfo(tag ,pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function SmithArtifactLayer:onAdd(tag, pSender)
    local item_ids = {}
    for i,v in ipairs(self.god_equip_list) do
        table.insert(item_ids, v.item_id)
    end

    require("src.layer.GodEquipSelectCtrl"):instance():openWindow(handler(self, self.godEquipSelectCallback), item_ids)
end

function SmithArtifactLayer:godEquipSelectCallback(item_ids)
    self:refreshData(item_ids)

    self:refreshView()
end

function SmithArtifactLayer:onCompose(tag ,pSender)
    -- if #self.god_equip_list < 3 then
    --     ex.MessageView:add(ex.Tools:getLang(41330))
    --     return
    -- end
    
    -- if not self.cur_compose_info then
    --     printError("SmithArtifactLayer:onCompose 合成配置找不到")
    --     return
    -- end

    -- local ability_num = cfg.godequipmentrare.getAbilityNumByRare(self.cur_compose_info.rare)
    -- if #self.cur_selected_attr_list < ability_num then
    --     ex.MessageView:add(string.format(ex.Tools:getLang(41331), ability_num))
    --     return
    -- end

    -- if ex.Tools:hasItemList(self.cur_compose_info.up_star_cost, true) then
    --     local req = GodEquip_pb.GReqGodEquipUpStar()
    --     for i, v in ipairs(self.cur_selected_attr_list) do
    --         local attr = GodEquip_pb.PSGodEquipAttr()
    --         attr.id = v.item_id
    --         attr.sort = v.sort
    --         table.insert(req.attr_list, attr)
    --     end
    --     for i, v in ipairs(self.god_equip_list) do
    --         table.insert(req.god_equip_list, v.item_id)
    --     end
    --     NetManager:sendMessage(ProtocolID.GReqGodEquipUpStar, req)

    --     -- 合成后直接刷新界面
    --     self:refresh()
    -- end
end

function SmithArtifactLayer:onOneKey(tag ,pSender)
    local can_up, item_ids = ex.Player.backpack_data:getGodEquipUpStarOneKey()
    
    self:refreshData(item_ids)

    self:refreshView()
end

function SmithArtifactLayer:onSelectAttr(tag ,pSender)
    if pSender:isChecked() then
        local ability_num = cfg.godequipmentrare.getAbilityNumByRare(self.cur_compose_info.rare)
        if #self.cur_selected_attr_list + 1 > ability_num then
            ex.MessageView:add(string.format(ex.Tools:getLang(41332), ability_num))
            pSender:setChecked(false)
            return
        end

        table.insert(self.cur_selected_attr_list, pSender.local_data)
    else
        for i, v in ipairs(self.cur_selected_attr_list) do
            if v.sys_id == pSender.local_data.sys_id then
                table.remove(self.cur_selected_attr_list, i)
                return
            end
        end
    end
end

function SmithArtifactLayer:onResBtn(tag ,pSender)
    local item_type = pSender.local_data

    ex.Tools:showEnoughTip(item_type, true)
end

function SmithArtifactLayer:countComposeAttr(god_equip_list)
    local attr_array = {}

    local addAttr = function(list, god_attr, place, star, item_id)
        for i,v in ipairs(list) do
            if v.sys_id == god_attr.sys_id then
                if god_attr.level > v.level then
                    v.item_id = item_id
                    v.sort = god_attr.sort
                    v.level = god_attr.level
                    v.lock = god_attr.lock

                    v.god_equip_ability_config = cfg.godequipmentrandomability.getConfigByFullField(place, star, god_attr.sys_id, god_attr.level)
                end
                return
            end
        end

        local attr = clone(god_attr)
        attr.item_id = item_id
        attr.god_equip_ability_config = cfg.godequipmentrandomability.getConfigByFullField(place, star, god_attr.sys_id, god_attr.level)
        table.insert(list, attr)
    end

    for i,v in ipairs(god_equip_list) do
        local god_equipment_config = cfg.godequipment.getConfigByType(v.item_type)
        for i2,v2 in ipairs(v.attrs) do
            addAttr(attr_array, v2, god_equipment_config.place, god_equipment_config.star, v.item_id)
        end
    end

    return attr_array
end


return SmithArtifactLayer