-- 英雄进化消耗选择界面
local HeroEvolutionSelectCtr = class("HeroEvolutionSelectCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroEvolutionSelectLayer = class("HeroEvolutionSelectLayer", require("src.comp.EventLayer"))

function HeroEvolutionSelectLayer:onCreate()
    self:addEvent(EVENT.HERO_INFO_EVENT.HERO_EVOLVE_SELECT, handler(self, self.selectHero))

    self:addBlackBackground()
    local hs_ctr = HeroEvolutionSelectCtr:instance()
    local win_size = cc.Director:getInstance():getWinSize()
    local height = Maths.min(self:getContentSize().height, win_size.height)
    self:setScale(height / self:getContentSize().height)
    self.viewSize = cc.size(474, 166)
    self.scroll_view = cc.ScrollView:create(self.viewSize):setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL):setPosition(51, 98)
    self:addChild(self.scroll_view)

    self.lbl_btn_evolve = cc.Label:createWithTTF(ex.Tools:getLang(47589), FONT_DEFAULT_NAME_BOLD, 25)
    self.btn_confirm:addChild(self.lbl_btn_evolve)
    self.lbl_btn_evolve:setPosition(self.btn_confirm:getContentSize().width / 2, self.btn_confirm:getContentSize().height / 2)
    self.lbl_btn_evolve:enableOutline(ex.c3b.BLUE, 1)
end

function HeroEvolutionSelectLayer:selectHero(event, num)
    self.lbl_select:setString(string.format(ex.Tools:getLang(47578), num, self.needCount))
end

-----------------------------------------------------------------------------
function HeroEvolutionSelectCtr:ctor()
    local ccbi_file = "ccbi/HeroEvolutionSelectLayer.ccbi"
    self:setCCBIPath(ccbi_file)
    self:registerCCBLoader()
    self:setIsSingle(false)
end

function HeroEvolutionSelectCtr:loadLayer()
    local layer = HeroEvolutionSelectLayer
    local ccbi_file = self:getCCBIPath()
    self.layer = layer:create(ccbi_file)
    self:setLayer(self.layer)

    -- 创建点击事件
    self:registerTouchListen()
end

function HeroEvolutionSelectCtr:getHeroEvolutionSelectLayer()
    return self.layer
end

function HeroEvolutionSelectCtr:openWindow(index, data, selected_list, is_show_lock, is_show_quick_go)
    if self:isOpened() then
        return
    end

    self.data = data
    self.index = index
    self.select_list = {}
    if selected_list then
        self.select_list = clone(selected_list)
    end
    self.select_num = data.select_num or 0

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/runes.plist")
    
    self:loadLayer()
    self:open()
    self:initData(index, data, is_show_lock, is_show_quick_go)
end

function HeroEvolutionSelectCtr:initData(index, data, is_show_lock, is_show_quick_go)
    self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))

    if is_show_lock == nil then
        self.is_show_lock = false
    else
        self.is_show_lock = is_show_lock
    end

    if is_show_quick_go ~= nil and is_show_quick_go == true then
        self.layer.node_bubble:setVisible(true)

        self.layer.btn_go:setContentSize(cc.size(100, 50))
        self.layer.btn_go:registerScriptTapHandler(handler(self, self.onGo))
    else
        self.layer.node_bubble:setVisible(false)
    end

    local data_list = {}
    local canData
    local replace_item_list = {}

    canData, replace_item_list = self:getCanSelectList(data)
    if replace_item_list then
        for i, v in ipairs(replace_item_list) do
            table.insert(data_list, v)
        end
    end

    for i, v in ipairs(canData) do
        v.selected = false
        table.insert(data_list, v)
    end

    -- 增加按钮
    local btn_add_data = {is_add = true, need_type = data.type, need_star = data.star}
    if index ~= 0 then
        btn_add_data.need_type = data.type
        if btn_add_data.need_type == 0 then -- 类型为0是指定星级未指定类型的所有英雄
            local limit_star = math.max(3, math.min(5, data.star))
            local elem = data.elem
            btn_add_data.need_type = 20000000 + 100000 * elem + 1000 * limit_star
            btn_add_data.need_star = limit_star
        else
            btn_add_data.need_star = data.star
        end
    end
    table.insert(data_list, btn_add_data)

    self:updateLayer(data_list, data)
end

function HeroEvolutionSelectCtr:updateLayer(data_list, data)
    local layer = self.layer
    local srcoll_view = layer.scroll_view
    local height
    srcoll_view:getContainer():removeAllChildren()
    local menu = cpp.UIMenu:create():setIsTouchInsideNode(srcoll_view):setSwallowsTouches(false):setPosition(cc.p(0, 0))
    srcoll_view:getContainer():addChild(menu)
    local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")
    local scale = 0.77
    if #data_list > 0 then
        table.sort(
            data_list,
            function(a, b)
                if (a.is_item and a.is_item == 1) or a.is_add then
                    return false
                elseif (b.is_item and b.is_item == 1) or b.is_add then
                    return true
                else
                    return a.hero_type > b.hero_type
                end
            end
        )

        local save_cell_props = UIMenuItemHero:createWithData()
        local cell_content
        
        local item_index = 1
        local select_item_num = self.select_num - #self.select_list
        for i = 1, #data_list do
            if data_list[i].is_item and data_list[i].is_item == 1 then
                local item = ex.Player.backpack_data:createWithData(data_list[i].item_type, data_list[i].item_num)
                if not height then
                    height = math.ceil((#data_list / 5)) * (save_cell_props:getContentSize().height * scale + 10) + (10 * scale)
                end
                local idx = (i - 1) % 5
                local posX = (save_cell_props:getContentSize().width + 16) * scale * (idx) + 15
                local posY = height - (math.ceil(i / 5)) * scale * (save_cell_props:getContentSize().height + 10)
                item:setAnchorPoint(0, 0)
                item:setPosition(posX, posY)
                item:setScale(scale)
                menu:add(item)
                item.cell_data = data_list[i]
                cell_content = item:getContentSize()
                item:registerScriptTapHandler(handler(self, self.onClickItem))
                if select_item_num >= item_index then
                    item:setSelected(true)
                end
                item_index = item_index + 1
            elseif data_list[i].is_add then
                local idx = (i - 1) % 5
                local item = cpp.UIMenuItemImage:createWithSpriteFrameName("backpack/rare-0.png", nil, nil)
                if not height then
                    height = math.ceil((#data_list / 5)) * (item:getContentSize().height * scale + 10) + (10 * scale)
                end
                local posX = (item:getContentSize().width + 16) * scale * (idx) + 15
                local posY = height - (math.ceil(i / 5)) * scale * (item:getContentSize().height + 10)
                item.need_type = data_list[i].need_type
                item.need_star = data_list[i].need_star
                item:setAnchorPoint(0, 0)
                item:setPosition(posX, posY)
                item:setScale(scale)
                item:registerScriptTapHandler(handler(self, self.onClickAdd))
                menu:addChild(item)
                
                cell_content = item:getContentSize()

                local spr_add = cc.Sprite:createWithSpriteFrameName("runes/btn-add-1.png")
                spr_add:setScale(1)
                spr_add:setPosition(cell_content.width / 2, cell_content.height / 2)
                item:addChild(spr_add)
            else
                local cell_props = UIMenuItemHero:createWithData()
                cell_props:reset(data_list[i])
                --if data_list[i].is_lock and self.is_show_lock then
                    --cell_props:setLocked()
                --end

                --local bool = ex.Player.hero_data.promote:heroIsBattle(data_list[i].hero_id)
                --if bool == true or ex.Player.hero_data.promote:checkHeroIsBattle(data_list[i].hero_id) then
                    --cell_props:setBattling()
                --end
                cell_props:autoLocked()

                cell_content = cell_props:getContentSize()
                menu:add(cell_props)
                cell_props:registerScriptTapHandler(handler(self, self.onClickHero))
                if not height then
                    height = math.ceil((#data_list / 5)) * (cell_content.height * scale + 10) + (10 * scale)
                end

                local idx = (i - 1) % 5
                local posX = (cell_content.width + 16) * scale * (idx) + 15
                local posY = height - (math.ceil(i / 5)) * scale * (cell_content.height + 10)
                cell_props:setAnchorPoint(0, 0)
                cell_props:setPosition(posX, posY)
                cell_props:setScale(scale)

                cell_props.cell_data = data_list[i]
                for k, v in ipairs(self.select_list) do
                    if v.hero_id == data_list[i].hero_id then
                        cell_props:setSelected(true)
                    end
                end
            end
        end
        local size = cc.size(layer.viewSize.width, math.ceil((#data_list / 5)) * ((cell_content.height + 10) * scale) + (10 * scale))
        srcoll_view:setContentSize(size)
        srcoll_view:setContentOffset(cc.p(0, layer.viewSize.height - height))
        srcoll_view:setTouchEnabled(math.ceil((#data_list / 5)) > 2)
    end

    layer.needCount = data.consume_num
    layer.lbl_select:setString(string.format(ex.Tools:getLang(47578), self.select_num, layer.needCount))
    layer.btn_confirm:registerScriptTapHandler(handler(self, self.selectHeroEnter))
end

function HeroEvolutionSelectCtr:onGo(tag, pSender)
    if cfg.funcopen["act_limit_gift"].isVisible() then
        ex.JumpManager:jumpByAtom("act_limit_gift")
        self:closeWindow()
    else
        ex.MessageView:add(ex.Tools:getLang(41311))
        return
    end
end

function HeroEvolutionSelectCtr:onClickItem(tag, pSender)
    local needCount = self.data.consume_num
    if self.select_num >= needCount and pSender.selected == false then
        return
    end
    pSender:setSelected(not pSender.selected)
    if not pSender.selected then
        self.select_num  = self.select_num - 1
    else
        self.select_num = self.select_num + 1
    end

    ex.EventManager:fire(EVENT.HERO_INFO_EVENT.HERO_EVOLVE_SELECT, self.select_num)
end

function HeroEvolutionSelectCtr:onClickHero(tag, pSender)
    --if pSender.battle == true then
        --ex.Player.hero_data:getHeroBattleMsg(pSender:getHeroId())
        --return
    --end
    if pSender:showLockedMessage() then 
        return 
    end 

    local needCount = self.data.consume_num
    if self.select_num >= needCount and pSender.selected == false then
        return
    end

   if pSender.locked and self.is_show_lock then
        ex.MessageView:add(ex.Tools:getLang(41271))
        return
    end

    pSender:setSelected(not pSender.selected)
    pSender.data.selected = pSender.selected
    
    if not pSender.selected then
        for k, v in ipairs(self.select_list) do
            if pSender.cell_data.hero_id == v.hero_id then
                table.remove(self.select_list, k)
                break
            end
        end
        self.select_num  = self.select_num - 1
    else
        table.insert(self.select_list, pSender.cell_data)
        self.select_num = self.select_num + 1
    end
    
    ex.EventManager:fire(EVENT.HERO_INFO_EVENT.HERO_EVOLVE_SELECT, self.select_num)
end

function HeroEvolutionSelectCtr:onClickAdd(tag, pSender)
    local type = pSender.need_type
    local prop_type = ex.Player.backpack_data:getPropType(pSender.need_type)

    if prop_type == ItemData.IT_HERO then
        type = cfg.herotype.star[pSender.need_type].item_id
    end

    require("src.layer.BackpackSrcCtr"):instance():openWindow(type, handler(self, self.jumpCallback))
end

function HeroEvolutionSelectCtr:jumpCallback(atom)
    self:closeWindow(nil, self.layer)
end

function HeroEvolutionSelectCtr:selectHeroEnter(tag, pSender)
    ex.EventManager:fire(EVENT.HERO_INFO_EVENT.HERO_EVOLVE_SELECT_CERTAIN, {index = self.index, select_list = self.select_list, select_num = self.select_num})
    self:closeWindow(nil, self.layer)
end

-- 懒得写工具类了，丢
function HeroEvolutionSelectCtr:getCanSelectList(data)
    local hero_list = clone(ex.Player.hero_data.hero_list)

    local canSelectList = {}
    local type = data.type
    local elem = data.elem

    for k, val in pairs(hero_list) do
        if data.star == val.star then
            if elem == val.elem and type == val.hero_type then
                table.insert(canSelectList, val)
            elseif type == 0 and elem == val.elem then
                table.insert(canSelectList, val)
            elseif elem == 0 and type == val.hero_type then
                table.insert(canSelectList, val)
            elseif type == 0 and elem == 0 then
                table.insert(canSelectList, val)
            end
        end
    end

    local replace_item_list = nil
    if data.replace_item and data.replace_item > 0 then
        replace_item_list = {}

        local has_nums = ex.Player:getItemNum(data.replace_item)
        for i = 1, has_nums do
            local now_replace_item = {}
            now_replace_item.item_type = data.replace_item
            now_replace_item.item_num = 1
            now_replace_item.is_item = 1
            table.insert(replace_item_list, now_replace_item)
        end
    end

    return canSelectList, replace_item_list
end


return HeroEvolutionSelectCtr
