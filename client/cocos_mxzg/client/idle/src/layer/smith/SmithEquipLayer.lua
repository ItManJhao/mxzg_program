local SmithEquipLayer = class("SmithEquipLayer", require("src.comp.EventLayer"))

-------------------------------SmithEquipLayer-----------------------------------------------
function SmithEquipLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.statue_compose_act = false

    self.equip_model = ex.Player.hero_data.equip

    local last_content_size = self:getContentSize()
    local cur_content_size = cc.size(ex.p.width - 20, ex.p.height - 220)
    local offset = cc.p(cur_content_size.width - last_content_size.width, cur_content_size.height - last_content_size.height)

    self:setContentSize(cur_content_size)
    self:setPosition(ex.p.width / 2 - self:getContentSize().width / 2, ex.p.height / 2 - self:getContentSize().height / 2 + 20)

    self.node_cell:setPosition(self.node_cell:getPositionX() + offset.x / 2, cur_content_size.height - 430)

    self.menu_compose:setLocalZOrder(100)
    self.btn_one_key:setPosition(self.btn_one_key:getPositionX() + offset.x / 2, self.node_cell:getPositionY() - 40)
    self.btn_compose:setPosition(self.btn_compose:getPositionX() + offset.x / 2, self.node_cell:getPositionY() - 40)

    local btn_tab_scale = (cur_content_size.width - 60 - 30) / (self.btn_tab1:getContentSize().width + 10) / 4
    self.btn_tab1:setScale(btn_tab_scale)
    self.btn_tab1:setPosition(90 * btn_tab_scale + (self.btn_tab1:getContentSize().width * btn_tab_scale + 15) * 0, self.node_cell:getPositionY() - 150)
    self.btn_tab2:setScale(btn_tab_scale)
    self.btn_tab2:setPosition(90 * btn_tab_scale + (self.btn_tab1:getContentSize().width * btn_tab_scale + 15) * 1, self.btn_tab1:getPositionY())
    self.btn_tab3:setScale(btn_tab_scale)
    self.btn_tab3:setPosition(90 * btn_tab_scale + (self.btn_tab1:getContentSize().width * btn_tab_scale + 15) * 2, self.btn_tab1:getPositionY())
    self.btn_tab4:setScale(btn_tab_scale)
    self.btn_tab4:setPosition(90 * btn_tab_scale + (self.btn_tab1:getContentSize().width * btn_tab_scale + 15) * 3, self.btn_tab1:getPositionY())

    self.spr_bg:setPosition(30, 30)
    self.spr_scroll_view_bg:setPosition(40, 40)
    self.scrollView:setPosition(self.spr_scroll_view_bg:getPositionX(), self.spr_scroll_view_bg:getPositionY() + 5)

    self.spr_bg:setContentSize(cc.size(cur_content_size.width - 60, self.node_cell:getPositionY() - 178))
    self.spr_scroll_view_bg:setContentSize(cc.size(cur_content_size.width - 80, self.node_cell:getPositionY() - 198))
    self.scrollView:setViewSize(cc.size(self.spr_scroll_view_bg:getContentSize().width * self.spr_scroll_view_bg:getScaleX(), self.spr_scroll_view_bg:getContentSize().height * self.spr_scroll_view_bg:getScaleY() - 15))

    self.viewSize = self.scrollView:getViewSize()
    self.cell = require("src.layer.MakeEquipCell"):createWithCCBIFile("ccbi/MakeEquipCell.ccbi")
    self:addChild(self.cell)
    -- self.cell.spr_bg:setContentSize(cc.size(cur_content_size.width - 60, self.cell.spr_bg:getContentSize().height + 90))
    -- self.cell.spr_bg:setPositionX(-(self.cell.spr_bg:getContentSize().width - self.cell:getContentSize().width) / 2)
    -- self.cell.spr_bg:setPositionY(-90)
    self.cell:setPosition((cur_content_size.width - self.cell:getContentSize().width) / 2, self.node_cell:getPositionY())
    self:registerBtnEvent()

    local data = self.equip_model:getComposeListByPlace(1)
    self:updateScrollView(data)
    self.cell:reset(data[1])
    self.place = data[1].place
    self:registerEvent()

end

function SmithEquipLayer:registerEvent()
    -- body
    -- self:addEvent(EVENT.MAKE_EQUIP_EVENT.MAKE_EQUIP_WITH_UPDATE,handler(self,self.updateRedByCompose))
    self:addEvent(EVENT.BACK_PACK_EVENT.BACKPACK_INIT_FINISH,handler(self,self.updateRedByCompose))
    self:addEvent(EVENT.BACKPACK_RES_CHANGE.CHANGE_ITEM,handler(self,self.onChangeItem))
end

function SmithEquipLayer:onChangeItem(event,data)
    if not data then return end 
    local refresh = false 
    for i,v in ipairs(data) do
        if v.type == ItemType.IT_GOLD then 
            refresh = true 
            break
        else
            local config = cfg.item.item[v.type]
            if config.mode == ItemData.IT_EQUIP then 
                refresh = true 
                break
            end
        end
    end
    if not refresh then return end 
    self:updateRedByCompose()
end

function SmithEquipLayer:updateRedByCompose(event,data)
    print(self.__cname,event)
    self:setRedPointByTab()
    local menu = self.scrollView:getContainer():getChildByName("menu")
    local childrens = menu:getChildren()
    for k,v in pairs(childrens) do
        local bool = self.equip_model:getEquipRedPointByType(v:getType())
        v:setRedPoint(bool)
    end
    self.cell:onFlush()
end

function SmithEquipLayer:updateScrollView(data)
    -- body
    local height 
    self.scrollView:getContainer():removeAllChildren()
    local menu = cpp.UIMenu:create()
    menu:setName("menu")
    :setIsTouchInsideNode(self.scrollView)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    self.scrollView:getContainer():addChild(menu)

    local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")
    self.item_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()
    self.item_size = cc.size(self.item_size.width + 15, self.item_size.height + 12)

    local margin = 4
    local len = table.nums(data)
    local col = math.floor((self.viewSize.width - margin * 2) / self.item_size.width) -- 列数
    local row = math.ceil(1.0 * len / col) -- 行数
    local cont_height = self.item_size.height * row + margin * 2
    cont_height = math.max(cont_height , self.viewSize.height)
    row = math.ceil((cont_height - margin * 2) / self.item_size.height) -- 总行数

    self.scrollView:setContentSize(cc.size(self.viewSize.width, cont_height + 5))
    self.scrollView:setContentOffset(cc.p(0, self.viewSize.height - cont_height - 5))

    cont_height = cont_height - (self.item_size.height * 0.5 + margin * 0.5)

    local start = cc.p(self.viewSize.width * 0.5 - (self.item_size.width * col * 0.5), cont_height - 5)
    start.x = start.x + self.item_size.width * 0.5

    local index = 0
    for i=1,#data do
        local cell_props = UIMenuItemBackpack:createWithData(data[i].equipment_type, 0)
        cell_props:setEnableAction(true)
        cell_content = cell_props:getContentSize()
        cell_props:setTag(i)
        cell_props:setBorder(i == 1)
        -- cell_props:setScale(scale)
        menu:add(cell_props)
        cell_props:registerScriptTapHandler(handler(self,self.onClickEquip))
        local bool = self.equip_model:getEquipRedPointByType(data[i].equipment_type)
        cell_props:setRedPoint(bool)

        -- cell_props:setAnchorPoint(0,0)
        local x = index % col
        local y = math.floor(index / col)
        cell_props:setPosition(start.x + x * self.item_size.width, start.y - y * self.item_size.height)

        cell_props.index = self.index

        index = index + 1
    end
end

function SmithEquipLayer:getLayerClass()
    return SmithEquipLayer
end

function SmithEquipLayer:registerBtnEvent()
    self.tabs = {}
    for i=1,4 do
        local btn = self["btn_tab" .. i]
        self.tabs[i] = btn
        local str = ex.Tools:getLang(50+i)
        btn:setLabelText(str)
        btn:setLabelColor(FONT_BLACK)
        btn:setTag(i)
        btn:registerScriptTapHandler(handler(self, self.onEquipByType))
        btn:setChecked(i == 1)
    end

    self.btn_one_key:registerScriptTapHandler(handler(self, self.onOneKey))

    -- local lbl_one_key = cc.Label:createWithTTF(ex.Tools:getLang(47588), FONT_DEFAULT_NAME_BOLD, 32)
    -- :enableOutline(FONT_BLACK, 1)
    -- self.btn_one_key:addChild(lbl_one_key)
    -- lbl_one_key:setPosition(self.btn_one_key:getContentSize().width/2,self.btn_one_key:getContentSize().height/2 + 2)

    self.btn_compose:registerScriptTapHandler(handler(self, self.onCompose))
    
    -- local lbl_compose = cc.Label:createWithTTF(ex.Tools:getLang(47438), FONT_DEFAULT_NAME_BOLD, 32)
    -- :enableOutline(FONT_BLACK, 1)
    -- self.btn_compose:addChild(lbl_compose)
    -- lbl_compose:setPosition(self.btn_compose:getContentSize().width/2,self.btn_compose:getContentSize().height/2 + 2)

    self:setRedPointByTab()
end

function SmithEquipLayer:setRedPointByTab()
    for k,v in pairs(self.tabs) do
        local bool = self.equip_model:getEquipRedPointByPlace(k)
        ex.Tools:addRedPoint(v,bool)
    end
end

function SmithEquipLayer:onClickEquip(tag,pSender)
    if self.statue_compose_act == true then
        return
    end

    local equip = cfg.equipmenttype.equip[pSender:getType()]
    self.cell:reset(equip)

    local menu = self.scrollView:getContainer():getChildByName("menu")
    local items = menu:getChildren()
    for k,v in pairs(items) do
        v:setBorder(v:getTag() == tag)
    end
end

function SmithEquipLayer:onOneKey(tag,pSender)
    local level_limit = cfg.system.equipment_compose_quickly_level or 25
    local not_can = ex.Player.total_charge <= 0
    if not_can then 
        not_can = level_limit > ex.Player.level
    end
    if not_can then 
        ex.MessageView:add(ex.Tools:getLang(41235))
        return 
    end
    local data = self.equip_model:checkCanComposeByType(self.place)
    local can = table.nums(data.equip) > 0
    if not can then 
        ex.MessageView:add(ex.Tools:getLang(47743))
        return 
    end

    require("src.layer.MakeEquipOneKeyTipsCtr"):instance():openWindow(data)
end

function SmithEquipLayer:onCompose(tag,pSender)
    local flag , type = self.cell:can()
    print(tostring(flag), type)
    if not flag then 

        if type == 1 then 
            ex.MessageView:add(ex.Tools:getLang(47743))
        elseif type == 2 then 
            ex.MessageView:add(ex.Tools:getLang(47702))
        end 
        return 
    end


    local need_data = self.cell:getData()
    local data = ex.Player.backpack_data:getEquipTypeByData(need_data.need_equipment[1].item_type)
    local num = self.cell:getNum() 
    local count = num * need_data.need_equipment[1].item_num
    local remove_equip_list = {}

    if num > 0 then 
        -- 播放特效
        if self.statue_compose_act ~= true then
            self:onComposeAct()
        end    
    else
        ex.MessageView:add(ex.Tools:getLang(47693))
    end
    -- self.equip_model:setRemoveEquipList(remove_equip_list)
end

function SmithEquipLayer:onComposeAct()
    self.statue_compose_act = true
    if self.node_compose_act == nil then
        self.step_compose_act = 1
    else
        self.node_compose_act:removeFromParent()
        self.node_compose_act = nil
    end

    if self.step_compose_act == 4 then
        self.step_compose_act = 1
        self.statue_compose_act = false

        local need_data = self.cell:getData()
        local data = ex.Player.backpack_data:getEquipTypeByData(need_data.need_equipment[1].item_type)
        local num = self.cell:getNum() 

        -- TOFIX 后端不需要id。所以要重新刷新背包
        -- print("xxxx", need_data.equipment_type, num)
        local req_make_equip = BackPack_pb.GReqMakeEquip()
        req_make_equip.equip_type = need_data.equipment_type
        req_make_equip.make_count = num
        NetManager:sendMessage(ProtocolID.GReqMakeEquip, req_make_equip)
        NetManager:sendMessage(ProtocolID.GReqBackPackList)

        return
    end

    self.node_compose_act = cc.Sprite:create()
    self.cell:addChild(self.node_compose_act, 200)

    if self.step_compose_act == 1 then
        self.node_compose_act:setPosition(self.cell.need_node:getPosition())
    elseif self.step_compose_act == 2 then
        self.node_compose_act:setPosition(self.cell.node_compose:getPosition())
    elseif self.step_compose_act == 3 then
        self.node_compose_act:setPosition(self.cell.cur_node:getPosition())
    end

    self.node_compose_act:runAction(ex.EffectFactory:createEffectByName("eff_runes_compose_"..self.step_compose_act, cc.CallFunc:create(handler(self, self.onComposeAct))))

    self.step_compose_act = self.step_compose_act + 1
end

function SmithEquipLayer:onComposeDone(evect)
    -- 如果成功则刷新界面，执行动画
    self.selected_id = NULL_ID
    self.vec_selected = {}

    self:updateLayer()
    self:updateTableView()
end

function SmithEquipLayer:onEquipByType(tag,pSender)

    local data = self.equip_model:getComposeListByPlace(pSender:getTag())
    self:updateScrollView(data)
    self.cell:reset(data[1])
    self.place = data[1].place
    -- self.equip_model:checkCanComposeByType(self.place)
end 

return SmithEquipLayer

