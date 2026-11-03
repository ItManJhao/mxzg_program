local HeroPernuteSelectCtrl = class("HeroPernuteSelectCtrl", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroPernuteSelectLayer = class("HeroPernuteSelectLayer", require("src.comp.EventLayer"))

function HeroPernuteSelectLayer:onCreate()
    self:addBlackBackground()
	local height = Maths.min(self:getContentSize().height, ex.p.height);
	self:setScale(height / self:getContentSize().height);
	
	self.viewSize = cc.size(530, 220)

	self.scroll_view = cc.ScrollView:create(self.viewSize)
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    :setPosition(35, 98)
    self:addChild(self.scroll_view)

    self.lbl_btn_update = cc.Label:createWithTTF(ex.Tools:getLang(47606), FONT_DEFAULT_NAME_BOLD, 24)
    self.btn_confirm:addChild(self.lbl_btn_update)
    self.lbl_btn_update:setPosition(self.btn_confirm:getContentSize().width / 2,self.btn_confirm:getContentSize().height / 2)
    self.lbl_btn_update:setTextColor(cc.c4b(255, 255, 255, 255))
    self.lbl_btn_update:enableOutline(cc.c4b(13, 91, 45,255), 2)
    --self.lbl_btn_update:enableOutline(ex.c3b.BLUE, 1)
end

-----------------------------------------------------------------------------
function HeroPernuteSelectCtrl:onCreate()
    self:setCCBIPath("ccbi/HeroPernuteSelectLayer.ccbi")
    
    self:setIsSingle(false)

    self.data = {}

    self.show_heros = {}

    self.selected_item = {}
end


function HeroPernuteSelectCtrl:openWindow(data)
	if self:isOpened() then
		return
	end
    self.first_hero_type = 0
    self.data = {}
    self.selected_item = {}
    self.data = data
	self:loadLayer()
    self:open()
    
	self:init()
end

function HeroPernuteSelectCtrl:getLayerClass()
	return HeroPernuteSelectLayer
end

function HeroPernuteSelectCtrl:closeWindow()
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

function HeroPernuteSelectCtrl:init()
    self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))
    

    self.layer.lbl_name:setString(self.data.window_name)
    self.layer.lbl_msg:setString(self.data.window_msg)

    -- 准备显示的英雄数据
    self:generateData()
	self:updateLayer()
end

function HeroPernuteSelectCtrl:generateData()
    self.show_heros = {}

    if self.data.max_star and self.data.max_star > 0 then 

        for i,v in ipairs(self.data.data_list) do
            if not ex.Tools:isExistValueInTable(self.data.ignore_hero_ids, v.hero_id) then
                if self.data.star <= v.star and v.star <= self.data.max_star then 
                    local hero_data = clone(v)  
                    hero_data.selected = ex.Tools:isExistValueInTable(self.data.selected_hero_ids, v.hero_id)
                    table.insert(self.show_heros, hero_data)
                end 
            end
        end


    else 
        local hero_type_nums = {}
        for i,v in ipairs(self.data.data_list) do
            if not ex.Tools:isExistValueInTable(self.data.ignore_hero_ids, v.hero_id) then
                local hero_data = clone(v)  
                hero_data.selected = ex.Tools:isExistValueInTable(self.data.selected_hero_ids, v.hero_id)

                if hero_data.selected == true then 
                    self.first_hero_type = v.hero_type
                end 
                

                hero_data.type_nums = 0
                if not hero_type_nums[v.hero_type] then 
                    hero_type_nums[v.hero_type] = 0
                end     
                hero_type_nums[v.hero_type] = hero_type_nums[v.hero_type] + 1
                
                table.insert(self.show_heros, hero_data)
            end
        end

        for i,v in ipairs(self.show_heros) do
            self.show_heros[i].type_nums = hero_type_nums[v.hero_type]
        end
        
        local sort = function (a, b  )
            if a.type_nums == b.type_nums then 
                return a.hero_type > b.hero_type
            else 
                return a.type_nums > b.type_nums
            end 
        end
        table.sort( self.show_heros, sort )
    end 

end

function HeroPernuteSelectCtrl:updateLayer()
    self.layer.scroll_view:getContainer():removeAllChildren()
    
	local menu = cpp.UIMenu:create()
    :setIsTouchInsideNode(self.layer.scroll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    self.layer.scroll_view:getContainer():addChild(menu)
    
	local height = 0
    local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")
	local scale = 0.9
	if #self.show_heros > 0 then 
        local cell_size

		for i = 1, #self.show_heros do
			local cell_props = UIMenuItemHero:createWithData()
            cell_props:reset(self.show_heros[i])
            
			--local fighting = ex.Player.hero_data.promote:checkHeroIsBattle(self.show_heros[i].hero_id)
            --if fighting == true then 
                --cell_props:setBattling() 
            --end
            --local hero_data = ex.Player.hero_data:getHeroDataById(self.show_heros[i].hero_id)
            --if hero_data.is_lock then
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
                height = math.max(self.layer.viewSize.height, math.ceil(#self.show_heros / 4) * ((cell_size.height + 20) * scale))
           end
           
			cell_props:setPosition((cell_size.width + 30) * scale * (((i - 1) % 4) + 0.5), height - (math.ceil(i / 4) - 0.5) * (cell_size.height + 20) * scale)
			cell_props:setScale(scale)

			cell_props.index = self.index
        end
        
        local size = cc.size(self.layer.viewSize.width, height)

        self.layer.scroll_view:setContentSize(size)
		self.layer.scroll_view:setContentOffset(cc.p(0, self.layer.viewSize.height - size.height)) 
		self.layer.scroll_view:setTouchEnabled(math.ceil((#self.show_heros / 5)) > 2)
    end
    
	self:refreshSelectedNumLabel()
	self.layer.btn_confirm:registerScriptTapHandler(handler(self,self.onBtnSubmit))
end

function HeroPernuteSelectCtrl:getSelectedNum()
    local num = 0
    for i, v in ipairs(self.show_heros) do
        if v.selected then
            num = num + 1
        end
    end

    return num
end

function HeroPernuteSelectCtrl:refreshSelectedNumLabel()
    self.layer.lbl_select:setString(string.format(ex.Tools:getLang(47578), self:getSelectedNum(), self.data.num))
end

function HeroPernuteSelectCtrl:onClickHero(tag, pSender)
    --if pSender.battle == true then 
        --ex.Player.hero_data:getHeroBattleMsg(pSender.hero_id)

        --return 
    --end
    --if pSender.locked then
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

    -- 检测第二个要跟第一个一样
    if self:getSelectedNum() >= 1 and self.first_hero_type > 0  and self.first_hero_type ~= pSender.hero_type then 
        
        ex.MessageView:add(ex.Tools:getLang(70535))
        return 
    end 

    self.first_hero_type = pSender.hero_type

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

function HeroPernuteSelectCtrl:onBtnSubmit(tag, pSender)
	self:closeWindow()
end

return HeroPernuteSelectCtrl
