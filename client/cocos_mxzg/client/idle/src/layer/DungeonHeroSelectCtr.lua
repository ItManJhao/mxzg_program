local DungeonHeroSelectCtr = class("DungeonHeroSelectCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local DungeonHeroSelectLayer = class("DungeonHeroSelectLayer", require("src.comp.EventLayerAdaptiveWidth"))
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")
local UIMenu = require("src.comp.menu.UIMenu")


DungeonHeroSelectLayer.vec_heros = {}
DungeonHeroSelectLayer.vec_selected = {}
DungeonHeroSelectLayer.callback = nil
DungeonHeroSelectLayer.layer_elem_type = 0

function DungeonHeroSelectLayer:onCreate()
    self:addBlackBackground()
    self:setAutoClose(false)
    self:setSwallowTouches(true)

	-- local win_size = cc.Director:getInstance():getWinSize();
	-- local height = Maths.min(self:getContentSize().height, win_size.height);
	-- self:setScale(height / self:getContentSize().height);
	-- self.btn_close:registerScriptTapHandler(handler(hero_select_ctr, hero_select_ctr.closeWindow))
    -- self.btn_close:setVisible(false)

    --self.btn_confirm:setLabelText(ex.Tools:getLang(47087))
    -- self.btn_confirm:setLabelSize(50)
    -- self.btn_confirm:setLabelScale(0.5)
    self.btn_confirm:setLabelOutLine(cc.c4b(31, 86, 167, 255))

    --self.btn_speed:setLabelText(ex.Tools:getLang(47747))
    -- self.btn_speed:setLabelSize(50)
    -- self.btn_speed:setLabelScale(0.5)
    self.btn_speed:setLabelOutLine(cc.c4b(98, 27, 215, 255))

    self.spr_select:setPosition(self.menu_elem:getPositionX() + self.btn_elem0:getPositionX(), 
                                self.menu_elem:getPositionY() + self.btn_elem0:getPositionY())

    for i=1,6 do
        self["btn_elem"..(i - 1)]:setTag(i - 1)
        self["btn_elem"..(i - 1)]:setEnableAction(false)
    end

    local item_size = cc.Sprite:createWithSpriteFrameName("other/rare-0.png"):getContentSize()
    item_size = cc.size(item_size.width + 15, item_size.height + 15)
    self.scroll_view_backpack = require("src.comp.UIScrollViewBackpack"):createWithSize(cc.size(self.spr_hero_bg:getContentSize().width - 10, self.spr_hero_bg:getContentSize().height - 90))
    self.scroll_view_backpack:setPosition(self.spr_hero_bg:getPositionX() + 5, self.spr_hero_bg:getPositionY() + 5)
    self.scroll_view_backpack:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.scroll_view_backpack:setItemSize(cc.size(item_size.width, item_size.height))
    self.scroll_view_backpack:setItemOffset(cc.p(0, 5))
    self.scroll_view_backpack:setAutoScale(true)
    self:addChild(self.scroll_view_backpack)
-- 
end

-----------------------------------------------------------------------------
function DungeonHeroSelectCtr:onCreate()
	self:setCCBIPath("ccbi/DungeonHeroSelectLayer.ccbi")
	self:setIsSingle(false)
end

function DungeonHeroSelectCtr:getLayerClass()
	return DungeonHeroSelectLayer
end

function DungeonHeroSelectCtr:getDungeonHeroSelectLayer()
	return self.layer
end

function DungeonHeroSelectCtr:openWindow()
	if self:isOpened() then
		return
	end
	
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/dungeon.plist")

	self:loadLayer()
	self:open()
	self:initData()
end

function DungeonHeroSelectCtr:initData()
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.onQuit))

    self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))
    self.layer.btn_speed:registerScriptTapHandler(handler(self, self.onSpeed))

    for i=1,6 do
        self.layer["btn_elem"..(i - 1)]:registerScriptTapHandler(handler(self, self.onElem))
    end

	local layer = self.layer
	layer.vec_selected = {}
    table.insert(layer.vec_selected, NULL_ID)
    table.insert(layer.vec_selected, NULL_ID)
    table.insert(layer.vec_selected, NULL_ID)
    table.insert(layer.vec_selected, NULL_ID)
    table.insert(layer.vec_selected, NULL_ID)
    table.insert(layer.vec_selected, NULL_ID)

	layer.vec_heros = ex.Player.hero_data.hero_list

    -- 对列表进行唯一排序
    -- local function sor(a, b)
    --     local score_a, score_b = 0, 0
    --     if tonumber(a.fighting) > tonumber(b.fighting) then 
    --         score_a = score_a + 1000 
    --     elseif tonumber(a.fighting) < tonumber(b.fighting) then 
    --         score_b = score_b + 1000 
    --     end
    --     if tonumber(a.hero_id) > tonumber(b.hero_id) then 
    --         score_a = score_a + 10 
    --     elseif tonumber(a.hero_id) < tonumber(b.hero_id) then 
    --         score_b = score_b + 10 
    --     end
    --     return score_a > score_b
    -- end

    -- add 熊梦 对英雄进行排序
    -- 先按战力排序 战力相同按星级排序 星级相同按hero_type排序
    local function sor(a, b)
        local score_a = tonumber(a.fighting)
        local score_b = tonumber(b.fighting)
        if score_a == score_b then
            if a.star == b.star then
                return a.hero_type > b.hero_type
            else
                return a.star > b.star
            end
        end
        return score_a > score_b
    end

    table.sort(layer.vec_heros, sor)

	self:updateScrollViewSelected()
	self:updateScrollViewBackpack()
	self:updateLayer()

end

function DungeonHeroSelectCtr:onQuit()
    ex.MainSceneCtr:instance():changeLayer(MainSceneType.MAINCITY_LAYER)

    self:closeWindow(0, nil)
end

function DungeonHeroSelectCtr:updateScrollViewSelected()
	if not self:getLayer() then
		return
	end
	local layer = self.layer

    layer.scroll_view_selected:getContainer():removeAllChildren()
    layer.scroll_view_selected:setBounceable(false)

	layer.menu_selected = UIMenu:create();
    layer.menu_selected:setPosition(cc.p(0, 0));
    layer.menu_selected:setSwallowsTouches(false);
    layer.menu_selected:setIsTouchInsideNode(layer.scroll_view_selected);
    layer.menu_selected:setName("menu_selected")
    layer.scroll_view_selected:getContainer():addChild(layer.menu_selected);

    local item_count = 6
    local item_scale = 0.75

	local view_size = layer.scroll_view_selected:getViewSize()
	local item_size = cc.Sprite:createWithSpriteFrameName("other/rare-0.png"):getContentSize()
    item_size = cc.size(item_size.width + 15, item_size.height + 12)

    for i=1,item_count do
        local item = nil
        local is_have = false

        if table.nums(self.layer.vec_selected) >= i and self.layer.vec_selected[i] ~= NULL_ID then  
            local hero_data = nil
            for i,v in pairs(self.layer.vec_heros) do
                if self.layer.vec_selected[i] == v.hero_id then
                    hero_data = v
                    break
                end
            end
            if hero_data ~= nil then
                item = UIMenuItemHero:createWithData(hero_data.hero_id, hero_data.hero_type, nil, hero_data.level, hero_data.star)
                is_have = true
            end
        end

        if item == nil then
            item = UIMenuItemHero:createWithData()
            item:setHeroId(NULL_ID)
            item:removeIcon()
            item:removeElem()
            item:removeLevel()
            item:removeStar()
        end

        if item ~= nil then
            item:setScale(item_scale)
            item:registerScriptTapHandler(handler(self, self.onSelectIcon))
            item:setPosition((i - 0.5) * (item_size.width * item_scale), view_size.height / 2)
            layer.menu_selected:add(item)

            item.spr_progress = cc.Sprite:createWithSpriteFrameName("dungeon/progress-hp.png")
            item.spr_progress:setPosition(item:getContentSize().width / 2, -20)
            item:addChild(item.spr_progress)
            item.spr_progress:setVisible(is_have)
        end
    end

    layer.scroll_view_selected:setContentSize(view_size)
end

function DungeonHeroSelectCtr:updateScrollViewBackpack()
    if not self:getLayer() then
		return
	end
	local layer = self.layer

    local vec_hero = {}
    for i,v in pairs(layer.vec_heros) do
        if layer.layer_elem_type == 0 then
            table.insert(vec_hero, v)
        elseif v.elem == layer.layer_elem_type then
            table.insert(vec_hero, v)
        end
    end

    self.layer.scroll_view_backpack:setData(vec_hero)
    self.layer.scroll_view_backpack.createItemFunction = function(hero_data, scale)
        local item = UIMenuItemHero:createWithData(hero_data.hero_id, hero_data.hero_type, hero_data.elem, hero_data.level, hero_data.star)
        item:registerScriptTapHandler(handler(self, self.onBackpackIcon))

        item.hero_id = hero_data.hero_id
        
        if TableEx.isInTable(layer.vec_selected, hero_data.hero_id) then
            item:setSelected(true)
        end
        return item
    end
    self.layer.scroll_view_backpack:reloadData(vec_hero)
end


function DungeonHeroSelectCtr:updateLayer()
	if not self:getLayer() then
		return
	end
	local layer = self.layer

	local combat_effectiveness = 0;
	for i,v in ipairs(layer.vec_selected) do
		local hero_data = ex.Player.hero_data:getHeroDataById(v)
        if hero_data ~= nil then
            -- hero_data:updateAbility()
			combat_effectiveness = combat_effectiveness + hero_data.fighting
		end
	end

    layer.lbl_battle_count:setString(string.format("%d", combat_effectiveness))
end

function DungeonHeroSelectCtr:onSelectIcon(tag, pSender)
    if pSender:getHeroId() == NULL_ID then
        return
    end
    local layer = self.layer

    local hero_id = pSender:getHeroId()
    pSender:setHeroId(NULL_ID)
    pSender:removeIcon()
    pSender:removeElem()
    pSender:removeLevel()
    pSender:removeStar()
    pSender:resetBg(nil, 0)

    if pSender.spr_progress ~= nil then
        pSender.spr_progress:setVisible(false)
    end

    local vec_child = layer.scroll_view_backpack.menu:getChildren()
    for i,v in ipairs(vec_child) do
        if v.hero_id ~= nil and v.hero_id == hero_id then
            v:setSelected(false)
        end
    end

    TableEx.replace(layer.vec_selected, hero_id, NULL_ID)

    self:updateLayer()
end

function DungeonHeroSelectCtr:onBackpackIcon(tag, pSender)

    if pSender:isSelected() then
        return
    end

    local layer = self.layer

    local hero_id = pSender:getHeroId()

    -- 不许重复英雄上阵
    local hero_data = ex.Player.hero_data:getHeroDataById(hero_id)
    for k,v in pairs(self.layer.vec_selected) do
        local tmp_hero_data = ex.Player.hero_data:getHeroDataById(v)
        if tmp_hero_data and tmp_hero_data.hero_type == hero_data.hero_type then
            ex.MessageView:add(ex.Tools:getLang(41298))
            return
        end
    end

    self:onBackpackHeroSelect(hero_id)
end

function DungeonHeroSelectCtr:onBackpackHeroSelect(hero_id)
    local layer = self.layer

    -- 检查空位是否足够
    if not TableEx.isInTable(layer.vec_selected, NULL_ID) then
        return
    end 

    if not TableEx.isInTableFunction(layer.vec_heros, function(value)
        return value.hero_id == hero_id
    end) then
        return
    end

    TableEx.replace(layer.vec_selected, NULL_ID, hero_id)
    
    -- 将英雄放到出战列表中
    local vec_children = layer.scroll_view_backpack.menu:getChildren()
    for k,v2 in pairs(vec_children) do
        if v2.hero_id == hero_id then
            v2:setSelected(true)
        end
    end


    local menu = layer.menu_selected
    local item = menu:getItemByHeroId(NULL_ID)
    local hero_data = ex.Player.hero_data:getHeroDataById(hero_id)
    if item and hero_data then
        item:setHeroId(hero_id)
        item:setStar(hero_data.star)
        item:setIcon(hero_data.hero_type)
        item:setElem(hero_data.elem)
        item:setLevel(hero_data.level)
        item:resetBg()

        if item.spr_progress ~= nil then
            item.spr_progress:setVisible(true)
        end
    end
    
    self:updateLayer()
end

function DungeonHeroSelectCtr:onElem(tag, pSender)
    local layer = self.layer
    layer.layer_elem_type = tag

    self.layer.spr_select:setPosition(self.layer.menu_elem:getPositionX() + pSender:getPositionX(),
                                      self.layer.menu_elem:getPositionY() + pSender:getPositionY())

    self:updateScrollViewBackpack()
end

-- 一键布阵
function DungeonHeroSelectCtr:onSpeed(tag, pSender)
    local layer = self.layer

    local vec_child = layer.scroll_view_backpack.menu:getChildren()
    for i, v in ipairs(layer.vec_selected) do
        for i2,v2 in ipairs(vec_child) do
            if v2.hero_id ~= nil and v2.hero_id == v then
                v2:setSelected(false)
            end
        end
    end

    -- 筛选最高战力的六个英雄放入队列
    layer.vec_selected = {}
    table.insert(layer.vec_selected, NULL_ID)
    table.insert(layer.vec_selected, NULL_ID)
    table.insert(layer.vec_selected, NULL_ID)
    table.insert(layer.vec_selected, NULL_ID)
    table.insert(layer.vec_selected, NULL_ID)
    table.insert(layer.vec_selected, NULL_ID)

    self:updateScrollViewSelected()

    local index = 1
    for i,v1 in ipairs(layer.vec_heros) do
        if layer.layer_elem_type == 0 or v1.elem == layer.layer_elem_type then
            if index > 6 then 
                break
            end
             -- 不许重复英雄上阵
            local repeat_hero = false
            local hero_data = ex.Player.hero_data:getHeroDataById(v1.hero_id)
            for q,p in pairs(layer.vec_selected) do
                local tmp_hero_data = ex.Player.hero_data:getHeroDataById(p)
                if tmp_hero_data and tmp_hero_data.hero_type == hero_data.hero_type then
                    repeat_hero = true
                    break
                end
            end

            if not repeat_hero then
                self:onBackpackHeroSelect(v1.hero_id)

                index = index + 1
            end
        end
    end
end

-- 进入冒险
function DungeonHeroSelectCtr:onConfirm(tag, pSender)
    local layer = self.layer

    local vec_selected = {}
    for i,v in ipairs(layer.vec_selected) do
        if v ~= NULL_ID then
            table.insert(vec_selected, v)
        end
    end

    if table.nums(vec_selected) <= 0 then
        ex.MessageView:add(ex.Tools:getLang(47422))
        return
    end

    -- 发送请求协议，由服务器返回对应数据，并刷新地牢界面英雄列表显示
    ex.Player.dungeon_data:initTeam(vec_selected)
    
    -- self:closeWindow(tag, pSender)
end

return DungeonHeroSelectCtr
