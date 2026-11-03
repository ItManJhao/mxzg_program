local HeroXSelectCtrl = class("HeroXSelectCtrl", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroXSelectLayer = class("HeroXSelectLayer", require("src.comp.EventLayer"))

function HeroXSelectLayer:onCreate()
    self:addBlackBackground()
	local height = Maths.min(self:getContentSize().height, ex.p.height);
	self:setScale(height / self:getContentSize().height);
	
	self.viewSize = cc.size(474, 166)

	self.scroll_view = cc.ScrollView:create(self.viewSize)
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    :setPosition(51, 98)
    self:addChild(self.scroll_view)

    self.lbl_btn_update = cc.Label:createWithTTF(ex.Tools:getLang(47589), FONT_DEFAULT_NAME_BOLD, 28)
    self.btn_confirm:addChild(self.lbl_btn_update)
    self.lbl_btn_update:setPosition(self.btn_confirm:getContentSize().width / 2,self.btn_confirm:getContentSize().height / 2)
    self.lbl_btn_update:enableOutline(ex.c3b.BLUE, 1)
end

-----------------------------------------------------------------------------
function HeroXSelectCtrl:onCreate()
    self:setCCBIPath("ccbi/HeroXSelectLayer.ccbi")
    
    self:setIsSingle(false)

    self.data = {}

    self.show_heros = {}

    self.selected_item = {}
end

-- data格式:
-- {
--     "idx": 0,
--     "type": 0,
--     "occupation": 0,
--     "elem": 0,
--     "star": 0,
--     "num": 0,
--     "selected_hero_ids": [
--         0,
--         0
--     ],
--     "ignore_hero_ids": [
--         0
--     ],
--     "select_handle": "select_handle",
--     "close_handle": "close_handle"
-- }
function HeroXSelectCtrl:openWindow(data, is_show_lock)
	if self:isOpened() then
		return
	end

    self.data = {}
    self.selected_item = {}
    self.data = data

    if is_show_lock == nil then is_show_lock = false end
    self.is_show_lock = is_show_lock
    
	self:loadLayer()
    self:open()
    
	self:init()
end

function HeroXSelectCtrl:getLayerClass()
	return HeroXSelectLayer
end

function HeroXSelectCtrl:closeWindow()
    -- -- print("HeroXSelectCtrl:closeWindow")
    if self.data.close_handle ~= nil then
        local selected = {}
    
        for i, v in ipairs(self.show_heros) do
            if v.selected then
                table.insert(selected, v.hero_id)
            end
        end
        -- dump(selected, "selected")
        self.data.close_handle(self.data.idx, selected)
    end

    self.data = {}
    self.show_heros = {}
    self.selected_item = {}

	self:close(self.layer)
end

function HeroXSelectCtrl:init()
    self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))
    
    -- 准备显示的英雄数据
    self:generateData()
    -- dump(self.show_heros, "show_heros")
	self:updateLayer()
end

function HeroXSelectCtrl:generateData()
    self.show_heros = {}

    if self.data.max_star and self.data.max_star > 0 then 

        for k, v in pairs(ex.Player.hero_data.hero_list) do
            -- -- print("hero type:", v.hero_type, ", occupation:", v.occupation, ", star:", v.star, ", elem:", v.elem)
            if ( (self.data.star <= v.star and v.star <= self.data.max_star )  or self.data.star == 0) and  
                (self.data.type == v.hero_type or self.data.type == 0 ) and 
                (self.data.occupation == v.occupation or self.data.occupation == 0 ) and 
                (self.data.elem == v.elem or self.data.elem == 0 ) then
                -- -- print("+++++++++++++++++")
                if not ex.Tools:isExistValueInTable(self.data.ignore_hero_ids, v.hero_id) then
                    local hero_data = clone(v)  -- 保险起见，克隆一个
                    hero_data.selected = ex.Tools:isExistValueInTable(self.data.selected_hero_ids, v.hero_id)
                    -- -- print("hero_id:", v.hero_id, ", selected:", hero_data.selected)
                    table.insert(self.show_heros, hero_data)
                end
            end 
        end

    else 

        for k, v in pairs(ex.Player.hero_data.hero_list) do
            -- -- print("hero type:", v.hero_type, ", occupation:", v.occupation, ", star:", v.star, ", elem:", v.elem)
            if (self.data.star == v.star or self.data.star == 0) and  
                (self.data.type == v.hero_type or self.data.type == 0 ) and 
                (self.data.occupation == v.occupation or self.data.occupation == 0 ) and 
                (self.data.elem == v.elem or self.data.elem == 0 ) then
                -- -- print("+++++++++++++++++")
                if not ex.Tools:isExistValueInTable(self.data.ignore_hero_ids, v.hero_id) then
                    local hero_data = clone(v)  -- 保险起见，克隆一个
                    hero_data.selected = ex.Tools:isExistValueInTable(self.data.selected_hero_ids, v.hero_id)
                    -- -- print("hero_id:", v.hero_id, ", selected:", hero_data.selected)
                    table.insert(self.show_heros, hero_data)
                end
            end 
        end

    end 

end

function HeroXSelectCtrl:updateLayer()
    self.layer.scroll_view:getContainer():removeAllChildren()
    
	local menu = cpp.UIMenu:create()
    :setIsTouchInsideNode(self.layer.scroll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    self.layer.scroll_view:getContainer():addChild(menu)
    
	local height = 0
    local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")
    local scale = 0.77
   
    -- add 熊梦 英雄重置排序 按照 星級 元素 等級 id
    local function sort_table (a,b)
        if a.star == b.star then
            if a.elem ==  b.elem then
                if a.level ==  b.level then
                    return a.hero_id > b.hero_id
                else
                    return a.level > b.level
                end
            else
                return a.elem > b.elem
            end 
        else
            return a.star > b.star
        end
    end

    table.sort( self.show_heros, sort_table )

	if #self.show_heros > 0 then 
		local cell_size
		for i = 1, #self.show_heros do
			local cell_props = UIMenuItemHero:createWithData()
            cell_props:reset(self.show_heros[i])
            
			--local fighting = ex.Player.hero_data.promote:heroIsBattle(self.show_heros[i].hero_id)
            --if fighting == true then 
                --cell_props:setBattling() 
            --end
            --if self.show_heros[i].is_lock and self.is_show_lock then
                --cell_props:setLocked()
            --end
            cell_props:autoLocked()

            cell_props:setSelected(self.show_heros[i].selected)
            if self.show_heros[i].selected then
                table.insert(self.selected_item, cell_props)
            end

			cell_size = cell_props:getContentSize()
			menu:add(cell_props)
            cell_props:registerScriptTapHandler(handler(self,self.onClickHero))
            
            if height == 0 then
                 height = math.max(self.layer.viewSize.height, math.ceil(#self.show_heros / 5) * ((cell_size.height + 10) * scale))
            end
			
			cell_props:setPosition((cell_size.width + 16) * scale * (((i - 1) % 5) + 0.5), height - (math.ceil(i / 5) - 0.5) * (cell_size.height + 10) * scale)
			cell_props:setScale(scale)

			cell_props.index = self.index
        end
        
        local size = cc.size(self.layer.viewSize.width, height)
        -- print("self.show_heros len:", #self.show_heros, ", size:", size.width, ", ", size.height, ", cell_size:", cell_size.width, ", ", cell_size.height, ", view_size:", self.layer.viewSize.width, ", ", self.layer.viewSize.height)

        self.layer.scroll_view:setContentSize(size)
		-- self.layer.scroll_view:setContentOffset(cc.p(0, self.layer.viewSize.height - height)) 
		self.layer.scroll_view:setContentOffset(cc.p(0, self.layer.viewSize.height - size.height)) 
		self.layer.scroll_view:setTouchEnabled(math.ceil((#self.show_heros / 5)) > 2)
    end
    
	self:refreshSelectedNumLabel()
	self.layer.btn_confirm:registerScriptTapHandler(handler(self,self.onBtnSubmit))
end

function HeroXSelectCtrl:getSelectedNum()
    local num = 0
    for i, v in ipairs(self.show_heros) do
        if v.selected then
            num = num + 1
        end
    end

    return num
end

function HeroXSelectCtrl:refreshSelectedNumLabel()
    self.layer.lbl_select:setString(string.format(ex.Tools:getLang(47578), self:getSelectedNum(), self.data.num))
end

function HeroXSelectCtrl:onClickHero(tag, pSender)
    --if pSender.battle == true then 
        --ex.Player.hero_data:getHeroBattleMsg(pSender.hero_id)

        --return 
    --end
    --if pSender.locked and self.is_show_lock then
        --ex.MessageView:add(ex.Tools:getLang(41271))
        --return
    --end
    if pSender:showLockedMessage() then 
        return 
    end 

    -- 特例：如果只要求一个英雄，则当选中了一个之后，又选中其余的英雄，则自动取消之前选中的英雄
    if self.data.num <= 1 and pSender.selected == false and self:getSelectedNum() > 0 then
        for k,v in pairs(self.selected_item) do
            v:setSelected(false)
            v.data.selected = false

            -- 通知宿主选择事件
            if self.data.select_handle ~= nil then
                self.data.select_handle(self.data.idx, v.data)
            end
        end

        -- 清空
        self.selected_item = {}
    end

    if self:getSelectedNum() >= self.data.num and pSender.selected == false then
        return
    end

	pSender:setSelected(not pSender.selected)

    pSender.data.selected = pSender.selected
    
    self:refreshSelectedNumLabel()

	if self.data.select_handle ~= nil then
        self.data.select_handle(self.data.idx, pSender.data)
    end

    if pSender.selected then
        table.insert(self.selected_item, pSender)
    else
        for i,v in ipairs(self.selected_item) do
            if v == pSender then
                table.remove(self.selected_item, i)
                break
            end
        end
    end
end

function HeroXSelectCtrl:onBtnSubmit(tag, pSender)
	self:closeWindow()
end

return HeroXSelectCtrl
