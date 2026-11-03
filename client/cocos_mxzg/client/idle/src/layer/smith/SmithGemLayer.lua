local SmithGemLayer = class("SmithGemLayer", require("src.comp.EventLayer"))

-------------------------------SmithGemLayer-----------------------------------------------
function SmithGemLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.cur_property_type = GEM_PROPERTY_TYPE.UNDEFINED
    self.cur_compose_info = nil -- 当前选中的合成宝石信息
    self.countMutliCompose = 1  -- 批量合成数量
    self.gem_list = {}          -- 宝石列表信息
    self.gem_team_ui = {        -- 合成材料节点信息
        [1] = {
            btn_icon = self.btn_gem_1,
            star_parent = self.node_star_1,
            lbl_num = self.lbl_gem_num_1,
        },
        [2] = {
            btn_icon = self.btn_gem_2,
            star_parent = self.node_star_2,
            lbl_num = self.lbl_gem_num_2,
        },
        [3] = {
            btn_icon = self.btn_gem_3,
            star_parent = self.node_star_3,
            lbl_num = self.lbl_gem_num_3,
        }
    }

    local scale_x = ex.p.width / 640
    local scale_y = ex.p.height / 1280
    local bottom_y = ex.MainSceneCtr:getBottomHeight() + 30

    local node_content_size = self.node_content:getContentSize()
    node_content_size.width = node_content_size.width * scale_x
    node_content_size.height = node_content_size.height * scale_y
    self.node_content:setContentSize(node_content_size)
    self.node_content:setAnchorPoint(ex.a.top_center)
    local pos_y = bottom_y + node_content_size.height
    self.node_content:setPositionY(pos_y)

    self.spr_bg:setPreferredSize(node_content_size)
    
    self.spr_scroll_view_bg:setPreferredSize(cc.size(node_content_size.width * 0.96, node_content_size.height * 0.94))
    self.spr_scroll_view_bg:setAnchorPoint(ex.a.center)
    self.spr_scroll_view_bg:setPosition(cc.p(node_content_size.width / 2, node_content_size.height / 2))

    self.scroll_view:setViewSize(cc.size(node_content_size.width * 0.96, node_content_size.height * 0.91))
    self.scroll_view:setAnchorPoint(ex.a.center)
    self.scroll_view:setPosition(cc.p(node_content_size.width / 2, node_content_size.height / 2))

    self.menu_compose:setLocalZOrder(100)
    pos_y = pos_y + 94
    self.btn_one_key:setPositionY(pos_y)
    self.btn_compose:setPositionY(pos_y)
    
    pos_y = pos_y + 43 + self.node_gem_panel:getContentSize().height / 2
    self.node_gem_panel:setPosition(ex.p.width / 2, pos_y)

    self.btn_one_key:registerScriptTapHandler(handler(self, self.onOneKey))
    self.btn_compose:registerScriptTapHandler(handler(self, self.onCompose))

    self.btn_sub:registerScriptTapHandler(handler(self, self.onChangeNum))
    self.btn_add:registerScriptTapHandler(handler(self, self.onChangeNum))

    self.btn_tab1:registerScriptTapHandler(handler(self, self.onChangeProperty))
    self.btn_tab2:registerScriptTapHandler(handler(self, self.onChangeProperty))
    self.btn_tab3:registerScriptTapHandler(handler(self, self.onChangeProperty))

    self.btn_gem_1:registerScriptTapHandler(handler(self, self.onGem))
    self.btn_gem_2:registerScriptTapHandler(handler(self, self.onGem))
    self.btn_gem_3:registerScriptTapHandler(handler(self, self.onGem))
    self.btn_gem:registerScriptTapHandler(handler(self, self.onGem))
    
    self.btn_tab1:setLabelText(ex.Tools:getLang(5531))
    self.btn_tab2:setLabelText(ex.Tools:getLang(5125))
    self.btn_tab3:setLabelText(ex.Tools:getLang(5550))


    self:addEvent(EVENT.BACKPACK_RES_CHANGE.CHANGE_ITEM,handler(self,self.onChangeDataSource))

    self:createEditBox()

    self:refresh(GEM_PROPERTY_TYPE.ATTACK)
end

-- 添加一个编辑框 
function SmithGemLayer:createEditBox()
    local size =  self.edit_box_bg:getContentSize()
	self.selectCount = ccui.EditBox:create(size,"other/spr-null.png", 1)
	self.selectCount:setPosition(0,0)
	self.selectCount:setAnchorPoint(cc.p(0,0))
	self.selectCount:setFontName(FONT_DEFAULT_NAME_BOLD)
	self.selectCount:setFontSize(20)
	self.selectCount:setFontColor(cc.WHITE)
	self.selectCount:setPlaceHolder(ex.Tools:getLang(47294))
	self.selectCount:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
	self.selectCount:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC) 
	self.selectCount:registerScriptEditBoxHandler(handler(self,self.editBoxHandle))
    self.edit_box_bg:addChild(self.selectCount)
    self.selectCount:setText(91)
end

function SmithGemLayer:onChangeDataSource()
    self:refresh(self.cur_property_type or GEM_PROPERTY_TYPE.ATTACK)
end

function SmithGemLayer:refreshRedDot()
    local check_show_red = function(property_type)
        local data = self:countOneKeyData(property_type)
    
        return #data > 0
    end

    ex.Tools:addRedPoint(self.btn_tab1, check_show_red(GEM_PROPERTY_TYPE.ATTACK), ex.r.p95)
    ex.Tools:addRedPoint(self.btn_tab2, check_show_red(GEM_PROPERTY_TYPE.BLOOD), ex.r.p95)
    ex.Tools:addRedPoint(self.btn_tab3, check_show_red(GEM_PROPERTY_TYPE.SPEED), ex.r.p95)
end

function SmithGemLayer:refresh(property_type)
    self:refreshData()

    self:refreshView(property_type)

    self:refreshRedDot()
end

function SmithGemLayer:refreshView(property_type)
    self.cur_property_type = property_type

    self.cur_compose_info = self:autoSelectComposeGem(property_type)

    self:refreshScrollView(self.gem_list, property_type)

    self:checkTabBar(property_type)

    self:refreshMutliCompose(self.countMutliCompose, self.cur_compose_info.config.jewel_type)

    self:initMutliCompose()

    self:refreshGemPanel(self.cur_compose_info)
end

function SmithGemLayer:refreshData()
    for i = GEM_PROPERTY_TYPE.ATTACK, GEM_PROPERTY_TYPE.SPEED do
        self.gem_list[i] = {}

        local list = cfg.jeweltype.getConfigListByGemType(i)
        
        table.sort(list, function(a, b)
            if a.rare < b.rare then
                return true
            else
                if a.rare == b.rare then
                    return a.jewel_type < b.jewel_type
                else
                    return false
                end
            end
        end)
    
        for n = 1, #list do
            if list[n].need_equipment ~= "" and #list[n].need_equipment > 0 then
                local data = {}
                data.config = list[n]
                data.max = self:maxMutliCompose(list[n].jewel_type)
        
                table.insert(self.gem_list[i], data)
            end
        end
    end
end

function SmithGemLayer:autoSelectComposeGem(property_type)
    if self.cur_compose_info and self.cur_compose_info.config.place == property_type then
        return self.cur_compose_info
    end

    local gem_data = self.gem_list[property_type]

    -- for i,v in ipairs(gem_data) do
    --     if v.max > 0 then
    --         return v
    --     end
    -- end

    return gem_data[1]
end

function SmithGemLayer:refreshScrollView(data, property_type)
    local height 
    self.scroll_view:getContainer():removeAllChildren()

    local menu = cpp.UIMenu:create()
    menu:setName("menu")
    :setIsTouchInsideNode(self.scroll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    self.scroll_view:getContainer():addChild(menu)

    local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")
    self.item_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()
    self.item_size = cc.size(self.item_size.width + 15, self.item_size.height + 12)

    local gem_data = data[property_type]
    local view_size = self.scroll_view:getViewSize()
    local margin = 4
    local len = table.nums(gem_data)
    local col = math.floor((view_size.width - margin * 2) / self.item_size.width) -- 列数
    local row = math.ceil(1.0 * len / col) -- 行数
    local cont_height = self.item_size.height * row + margin * 2
    cont_height = math.max(cont_height , view_size.height)
    row = math.ceil((cont_height - margin * 2) / self.item_size.height) -- 总行数

    self.scroll_view:setContentSize(cc.size(view_size.width, cont_height + 5))
    self.scroll_view:setContentOffset(cc.p(0, view_size.height - cont_height - 5))

    cont_height = cont_height - (self.item_size.height * 0.5 + margin * 0.5)

    local start = cc.p(view_size.width * 0.5 - (self.item_size.width * col * 0.5), cont_height - 5)
    start.x = start.x + self.item_size.width * 0.5

    local index = 0
    for i=1,#gem_data do
        local item_type = gem_data[i].config.jewel_type
        local cell_props = UIMenuItemBackpack:createWithData(item_type, ex.Player:getItemNum(item_type))
        cell_props:setEnableAction(true)
        cell_props.local_data = gem_data[i]
        menu:add(cell_props)

        cell_props:registerScriptTapHandler(handler(self,self.onClickGem))

        cell_props:setRedPoint(gem_data[i].max > 0)

        -- cell_props:setAnchorPoint(0,0)
        local x = index % col
        local y = math.floor(index / col)
        cell_props:setPosition(start.x + x * self.item_size.width, start.y - y * self.item_size.height)

        -- cell_props.index = self.index

        index = index + 1
    end

    self:setSelectItem(self.cur_compose_info.config.jewel_type)
end

function SmithGemLayer:checkTabBar(property_type)
    self.btn_tab1:setChecked(property_type == GEM_PROPERTY_TYPE.ATTACK)
    self.btn_tab2:setChecked(property_type == GEM_PROPERTY_TYPE.BLOOD)
    self.btn_tab3:setChecked(property_type == GEM_PROPERTY_TYPE.SPEED)
end

function SmithGemLayer:editBoxHandle(strEventName,sender)
    if strEventName == "ended" then
        if tonumber(sender:getText()) ~= nil then 
            self.countMutliCompose = math.max(1, sender:getText())
            self:refreshMutliCompose(tonumber(sender:getText()),self.cur_compose_info.config.jewel_type) 
        else
            sender:setText(1)
            self.countMutliCompose = 1 
            ex.MessageView:add(ex.Tools:getLang(47294))
        end
    end
end

-- 初始化宝石合成的最大值
function SmithGemLayer:initMutliCompose()
    local max = self:maxMutliCompose(self.cur_compose_info.config.jewel_type)
    self.countMutliCompose =math.max(1, max)
    self.selectCount:setText(self.countMutliCompose)
    self.btn_sub:setEnabled(self.countMutliCompose > 1)
    self.btn_add:setEnabled(self.countMutliCompose < max)
    ex.Tools:setGrayAuto(self.btn_sub:getNormalImage(), self.countMutliCompose <= 1)
    ex.Tools:setGrayAuto(self.btn_add:getNormalImage(), self.countMutliCompose >= max)
end

function SmithGemLayer:refreshMutliCompose(cur_num, gem_type)
    local max = self:maxMutliCompose(gem_type)
    self.countMutliCompose = math.max(1, math.min(cur_num, max))
    self.selectCount:setText(self.countMutliCompose)
    -- self.lbl_compose_num:setString(tostring(self.countMutliCompose))
    self.btn_sub:setEnabled(self.countMutliCompose > 1)
    self.btn_add:setEnabled(self.countMutliCompose < max)

    ex.Tools:setGrayAuto(self.btn_sub:getNormalImage(), self.countMutliCompose <= 1)
    ex.Tools:setGrayAuto(self.btn_add:getNormalImage(), self.countMutliCompose >= max)
end

function SmithGemLayer:refreshGemPanel(gem_info)
    local need_type, need_num = gem_info.config.need_equipment[1].item_type, gem_info.config.need_equipment[1].item_num
    local need_star = cfg.jeweltype.jeweltype[need_type].star

    local need_equip_num = ex.Player.backpack_data:getItemNum(need_type)

    local need_num_temp = math.modf(need_num / 3)

    for i,v in ipairs(self.gem_team_ui) do
        v.btn_icon.local_type = need_type
        ex.Tools:setSpriteFrame(v.btn_icon:getNormalImage(), string.format("backpack/%d.png", need_type))

        local need_equip_num_temp = 0
        if need_equip_num >= need_num_temp then
            need_equip_num_temp = need_num_temp
            need_equip_num = need_equip_num - need_num_temp
        end
        v.lbl_num:setString(string.format("%d/%d", need_equip_num_temp, need_num_temp))
        if need_equip_num_temp >= need_num_temp then
            v.lbl_num:setColor(FONT_WHITLE)
        else
            v.lbl_num:setColor(TIPS_RED)
        end

        v.star_parent:removeAllChildren()
        ex.Tools:generationStar(v.star_parent, need_star, "other/star-%d.png", 0.6, -10)
    end

    self.btn_gem.local_type = gem_info.config.jewel_type
    ex.Tools:setSpriteFrame(self.btn_gem:getNormalImage(), string.format("backpack/%d.png", gem_info.config.jewel_type))
    self.node_star:removeAllChildren()
    ex.Tools:generationStar(self.node_star, gem_info.config.star, "other/star-%d.png", 0.6, -10)
end

function SmithGemLayer:maxMutliCompose(gem_type)
    local max = 0

    local config = cfg.jeweltype.jeweltype[gem_type]
    if config and config.need_equipment ~= "" and #config.need_equipment > 0 then
        local num = ex.Player.backpack_data:getItemNum(config.need_equipment[1].item_type)
        max = math.floor(num / config.need_equipment[1].item_num)
    end

    return max
end

function SmithGemLayer:setSelectItem(gem_type)
    local children = self.scroll_view:getContainer():getChildByName("menu"):getChildren()
    for i,v in ipairs(children) do
        v:setBorder(v.local_data.config.jewel_type == gem_type)
    end
end

function SmithGemLayer:onClickGem(tag,pSender)
    if self.cur_compose_info.config.jewel_type == pSender.local_data.config.jewel_type then
        return
    end

    self.cur_compose_info = pSender.local_data

    self:refreshMutliCompose(1, self.cur_compose_info.config.jewel_type)

    self:initMutliCompose()

    self:refreshGemPanel(self.cur_compose_info)

    self:setSelectItem(self.cur_compose_info.config.jewel_type)
end

function SmithGemLayer:onOneKey(tag,pSender)
    local data = self:countOneKeyData(self.cur_property_type)

    if #data <= 0 then
        ex.MessageView:add(ex.Tools:getLang(54410))
        return
    end

    require("src.layer.MakeGemOneKeyTipsCtr"):instance():openWindow(data, handler(self, self.oneKeyConfirm))
end

function SmithGemLayer:oneKeyConfirm()
    local req = HeroJewel_pb.GReqJewelAllCombine()
    req.jewel_place = self.cur_property_type
    NetManager:sendMessage(ProtocolID.GReqJewelAllCombine, req)
end

function SmithGemLayer:onCompose(tag,pSender)
    local num = self.countMutliCompose

    if num > self.cur_compose_info.max then
        ex.MessageView:add(ex.Tools:getLang(54410))
        return
    end

    local req = HeroJewel_pb.GReqJewelCombine()
    req.jewel_type = self.cur_compose_info.config.jewel_type
    req.make_count = num
    NetManager:sendMessage(ProtocolID.GReqJewelCombine, req)
end

function SmithGemLayer:onChangeNum(tag, pSender)
    local delta = 0
    if pSender == self.btn_sub then
        delta = -1
    else
        delta = 1
    end

    local cur_num = self.countMutliCompose + delta
    self:refreshMutliCompose(cur_num, self.cur_compose_info.config.jewel_type)
end

function SmithGemLayer:onChangeProperty(tag,pSender)
    local property_type = GEM_PROPERTY_TYPE.UNDEFINED
    if pSender == self.btn_tab1 then
        property_type = GEM_PROPERTY_TYPE.ATTACK
    elseif pSender == self.btn_tab2 then
        property_type = GEM_PROPERTY_TYPE.BLOOD
    else
        property_type = GEM_PROPERTY_TYPE.SPEED
    end

    self.countMutliCompose = 1
    self:refreshView(property_type)
end

function SmithGemLayer:onGem(tag,pSender)
	local info_ctr = require("src.layer.heroinfo.StoneAbilityInfoCtr"):instance()
	info_ctr:openWindow()
	info_ctr:setStoneInfo(pSender.local_type)
end

function SmithGemLayer:countOneKeyData(property_type)
    local new_data = {}

    local list = cfg.jeweltype.getConfigListByGemType(property_type)

    table.sort(list, function(a, b)
        return a.jewel_type < b.jewel_type
    end)

    for n = 1, #list do
        table.insert(new_data, {type = list[n].jewel_type, num = ex.Player.backpack_data:getItemNum(list[n].jewel_type), config = list[n]})
    end

    local origin_data = clone(new_data)

    local find_gem = function(list, gem_type)
        for k,v in pairs(list) do
            if v.type == gem_type then
                return v
            end
        end

        return nil
    end

    local need_equip = nil
    for i,v in ipairs(new_data) do
        if v.config.need_equipment ~= "" and #v.config.need_equipment > 0 then
            need_equip = find_gem(new_data, v.config.need_equipment[1].item_type)

            local new_num = math.floor(need_equip.num / v.config.need_equipment[1].item_num)

            v.num = v.num + new_num
            need_equip.num = need_equip.num - new_num * v.config.need_equipment[1].item_num
        end
    end

    local obtain_equip = {}
    for i=1, #new_data do
        if new_data[i].num > origin_data[i].num then
            table.insert(obtain_equip, {type = new_data[i].type, num = new_data[i].num - origin_data[i].num})
        end
    end

    return obtain_equip
end

return SmithGemLayer

