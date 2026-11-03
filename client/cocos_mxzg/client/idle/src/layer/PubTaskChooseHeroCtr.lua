local PubTaskChooseHeroCtr = class("PubTaskChooseHeroCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PubTaskChooseHeroLayer = class("PubTaskChooseHeroLayer", require("src.comp.EventLayerAdaptiveWidth"))

local LANGUAGE = {
	["star"] = 2216,
	["element"] = 2215,
	["occupation"] = 2217,
}

local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")


function PubTaskChooseHeroLayer:onCreate()
	--print("PubTaskChooseHeroLayer:onCreate")
	--self:setAutoClose(false)
	self:addBlackBackground()
 --    local choose_ctr = PubTaskChooseHeroCtr:instance()
	-- self.btn_auto:registerScriptTapHandler(handler(choose_ctr, choose_ctr.onAutoChoose))
	-- self.btn_start:registerScriptTapHandler(handler(choose_ctr, choose_ctr.onStartTask))
	-- self.btn_close:registerScriptTapHandler(handler(choose_ctr, choose_ctr.onCancel))

	self:addEvent(EVENT.HERO_EVENT.CHANGE_HERO_TASK,handler(self,self.changeHeroTask))

end

function PubTaskChooseHeroLayer:changeHeroTask(event,data)

	local choose_ctr = PubTaskChooseHeroCtr:instance()

    choose_ctr:changeHeroTask(data)
end 

-----------------------------------------------------------------------------
function PubTaskChooseHeroCtr:onCreate()
	self:setCCBIPath("ccbi/MainTaskChooseHeroLayer.ccbi")
	self:setIsSingle(false)
end

function PubTaskChooseHeroCtr:getLayerClass()
	return PubTaskChooseHeroLayer
end

function PubTaskChooseHeroCtr:openWindow(task_id, task_type)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(task_id, task_type)
end

function PubTaskChooseHeroCtr:initData(task_id, task_type)
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	
	self.layer.btn_auto:registerScriptTapHandler(handler(self, self.onAutoChoose))
	self.layer.btn_start:registerScriptTapHandler(handler(self, self.onStartTask))

	self.task_id = task_id
	self.task_type = task_type

	local cur_task = ex.Player.pub_task:getTask(task_id)
	local config = cfg.tavern.pubTask[task_type]
    if cur_task == nil or config == nil then
        return
    end

    self.item_size = cc.Sprite:createWithSpriteFrameName("other/rare-0.png"):getContentSize()
    self.item_size = cc.size(self.item_size.width + 15, self.item_size.height + 12)

    ---------当前任务条件--完成时间--------------------------------
    local start_width = cc.Sprite:createWithSpriteFrameName("hero-info/spr-star-3.png"):getContentSize().width
    local start = cc.p(self.layer.lbl_need:getPositionX() , self.layer.lbl_need:getPositionY() - 50)

    -- 条件
    self.condition = {}
    self.condition.vec_num_cond = {}
	self.condition.vec_spr_cond = {}
	
	local menu = cpp.UIMenu:create()
    -- :setIsTouchInsideNode(self.layer)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    :setName("menu_condition")
    self.layer:addChild(menu)
    for i,v in ipairs(config.hero_condition) do
    	local diffx = start.x + (i - 1) * start_width
    	for k,num in pairs(v) do
			local spr_cond = nil
			if k == "star" then
    			-- 条件 星级
				-- spr_cond = cc.Sprite:createWithSpriteFrameName("hero-info/spr-star-3.png")
				spr_cond = cpp.UIMenuItemImage:createWithSpriteFrameName("hero-info/spr-star-3.png", nil, nil)
    			:setScale(0.8)
				:setPosition(diffx, start.y)
				:setName("star")
    			menu:addChild(spr_cond)

    			local lbl_star_num = cc.Label:createWithTTF(tostring(num), FONT_DEFAULT_NAME_BOLD, 40)
    			:enableOutline(FONT_BROWN, 2)
    			:setScale(0.7)
    			:setPosition(start_width * 0.5, start_width * 0.5)
				spr_cond:addChild(lbl_star_num)
    		elseif k == "element" then
    			-- 条件 元素
				-- spr_cond = cc.Sprite:createWithSpriteFrameName(string.format("hero-icon/elem-%d.png", num))
				spr_cond = cpp.UIMenuItemImage:createWithSpriteFrameName(string.format("hero-icon/elem-%d.png", num), nil, nil)
    			:setScale(0.8)
				:setPosition(diffx, start.y)
				:setName("element")
    			menu:addChild(spr_cond)
    		elseif k == "occupation" then
    			-- 条件 职业
				-- spr_cond = cc.Sprite:createWithSpriteFrameName(string.format("hero-info/spr-occup-%d.png", num))
				spr_cond = cpp.UIMenuItemImage:createWithSpriteFrameName(string.format("hero-info/spr-occup-%d.png", num), nil, nil)
    			:setScale(0.8)
				:setPosition(diffx, start.y)
				:setName("occupation")
    			menu:addChild(spr_cond)
			end
			spr_cond:registerScriptTapHandler(handler(self,self.onClickCondition))
			spr_cond:setTag(i)
			table.insert(self.condition.vec_num_cond, {k, num})
			table.insert(self.condition.vec_spr_cond, spr_cond)
    	end
    end

	local size_nums = #self.condition.vec_spr_cond
	for i,v in ipairs(self.condition.vec_spr_cond) do
		v:setPosition(v:getPositionX() -  (size_nums - 1) * start_width * 0.5 , v:getPositionY())
	end


    self.choose_hero_view = {}

    self.hero_max = config.hero_num

    local menu = cpp.UIMenu:create()
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    self.layer:addChild(menu)

    local bgSize = self.layer.spr_need_bg:getContentSize()
    start = cc.p(self.layer.lbl_need:getPositionX() , self.layer.lbl_need:getPositionY() + 75)
    --start.x = start.x + (bgSize.width * 0.5 - (self.item_size.width + 20) * (self.hero_max - 1) * 0.5) 

    for i=1,self.hero_max do
    	local item = UIMenuItemHero:createWithData(0, 0, 0, 0)
        item:setPosition(start.x + (i - 1) * (self.item_size.width ) , start.y)
        :registerScriptTapHandler(handler(self, self.onClickTaskHero))
        menu:addChild(item)

        item:setEnabled(false)

        table.insert(self.choose_hero_view, item)
    end

	local size_nums_hero = #self.choose_hero_view
	for i,v in ipairs(self.choose_hero_view) do
		v:setPosition(v:getPositionX() -  (size_nums_hero - 1) * (self.item_size.width )  * 0.5, v:getPositionY())
	end


	local need_nums_time = config.need_points[1].item_num
    if ex.Player.promotion_data:getTavernWeeklyListTime() == true  then
        need_nums_time = need_nums_time *  cfg.system["tavern_promotion_discount"] * 0.0001
	end 
	
	self.layer.lbl_items_num:setString(need_nums_time .. "/".. ex.Player.pub_task.adventure_count)

    local taskTime = config.time
    self.layer.lbl_time:setString(string.format("%d:%02d:%02d", 
        math.floor(taskTime / 3600),
        math.floor(taskTime / 60 % 60),
        math.floor(taskTime % 60)))


    ---------自动安排--开始按钮------------------------------------
	local btn_size = cc.Sprite:createWithSpriteFrameName("button/btn-orange-4.png"):getContentSize()
	btn_size.width = btn_size.width  * 0.5
	btn_size.height = btn_size.height * 0.5
	
    local lbl_btn_txt1 = cc.Label:createWithTTF(ex.Tools:getLang(2208), FONT_DEFAULT_NAME_BOLD, 44)
    :setTextColor(FONT_WHITLE)
    :setScale(0.5)
    :enableOutline(FONT_BTN_OUTLINE_GREEN, 2)
    :setPosition(self.layer.btn_auto:getContentSize().width * 0.5, self.layer.btn_auto:getContentSize().height * 0.5)
	self.layer.btn_auto:addChild(lbl_btn_txt1)
	

	local lbl_btn_txt2 = cc.Label:createWithTTF(ex.Tools:getLang(1342), FONT_DEFAULT_NAME_BOLD, 44)
    :setTextColor(FONT_WHITLE)
    :setScale(0.5)
    :enableOutline(FONT_BTN_OUTLINE_GREEN, 2)
    :setPosition(self.layer.btn_start:getContentSize().width * 0.5, self.layer.btn_start:getContentSize().height * 0.5)
	self.layer.btn_start:addChild(lbl_btn_txt2)

	-- local lbl_btn_txt = cc.Label:createWithTTF(ex.Tools:getLang(2208), FONT_DEFAULT_NAME_BOLD, 26)
	-- :enableOutline(FONT_BROWN, 2)
	-- :setPosition(btn_size.width, btn_size.height)
	-- self.layer.btn_auto:addChild(lbl_btn_txt)

	-- lbl_btn_txt = cc.Label:createWithTTF(ex.Tools:getLang(1342), FONT_DEFAULT_NAME_BOLD, 26)
	-- :enableOutline(FONT_DARK_BLUE, 2)
	-- :setPosition(btn_size.width, btn_size.height)
	-- self.layer.btn_start:addChild(lbl_btn_txt)


	--------英雄部分---------------------------------------------
	self.layer.btn_elem0:setTag(ElemType.ALL)
	self.layer.btn_elem1:setTag(ElemType.FIRE)
	self.layer.btn_elem2:setTag(ElemType.WATER)
	self.layer.btn_elem3:setTag(ElemType.FOREST)
	self.layer.btn_elem4:setTag(ElemType.LIGHT)
	self.layer.btn_elem5:setTag(ElemType.SHADOW)

	self.layer.btn_elem0:registerScriptTapHandler(handler(self, self.onChooseElem))
	self.layer.btn_elem1:registerScriptTapHandler(handler(self, self.onChooseElem))
	self.layer.btn_elem2:registerScriptTapHandler(handler(self, self.onChooseElem))
	self.layer.btn_elem3:registerScriptTapHandler(handler(self, self.onChooseElem))
	self.layer.btn_elem4:registerScriptTapHandler(handler(self, self.onChooseElem))
	self.layer.btn_elem5:registerScriptTapHandler(handler(self, self.onChooseElem))

	self.btn_elem_select = require("src.layer.HeroElemSelect"):new()
    self.btn_elem_select:bindSelect(self.layer.btn_elem0)
    self.btn_elem_select:bindSelect(self.layer.btn_elem1)
    self.btn_elem_select:bindSelect(self.layer.btn_elem2)
    self.btn_elem_select:bindSelect(self.layer.btn_elem3)
    self.btn_elem_select:bindSelect(self.layer.btn_elem4)
    self.btn_elem_select:bindSelect(self.layer.btn_elem5)
    
    self.btn_elem_select:setSelected(ElemType.ALL)

	self.cur_hero_elem = ElemType.ALL
	self.is_choose_elem = true
	self.hero_list_view = {}

	self.click_hero_num = 0


	-- 英雄列表scroll_view
	self.viewSize = self.layer.spr_hero_bg:getContentSize()
    self.viewSize.height = self.viewSize.height - 115

    self.viewPos = cc.p(self.layer.spr_hero_bg:getPositionX(), self.layer.spr_hero_bg:getPositionY() + 6)
	

	local item_size = cc.Sprite:createWithSpriteFrameName("other/rare-0.png"):getContentSize()
	item_size = cc.size(item_size.width + 30, item_size.height + 10)
	
    self.layer.select_hero_scroll_view:setItemSize(cc.size(item_size.width, item_size.height))
    self.layer.select_hero_scroll_view:setItemOffset(cc.p(0, 5))
    self.layer.select_hero_scroll_view:setCreateNum(4)
    self.layer.select_hero_scroll_view:setName("hero_select_view")

    -- self.layer.scroll_view = cc.ScrollView:create(self.viewSize)
    -- :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    -- :setPosition(self.viewPos)
    -- self.layer:addChild(self.layer.scroll_view)

    self:checkCondition()

    self:updateScrollView()
end

function PubTaskChooseHeroCtr:onClickCondition(tag,pSender)

	local v = self.condition.vec_num_cond[tag]
	local condition = pSender:getName()
	if condition == v[1] then 
		local lang = ex.Tools:getLang(LANGUAGE[condition])
		local value = ""
		if condition == "star" then 
			value = v[2]
		elseif condition == "element" then
			value = ex.Tools:getLang(2100 + v[2])
		elseif condition == "occupation" then 
			value = ex.Tools:getLang(111000 + v[2])
		end

		local str = string.format(lang,value)
		ex.MessageView:add(str)
	end
end

function PubTaskChooseHeroCtr:updateScrollView()
	
	self.is_choose_elem = false
	self.hero_list_view = {}

    -- 获取当期属性英雄
    local hero_list = ex.Player.hero_data:getHeroByElem(self.cur_hero_elem)
    local heroLen = table.nums(hero_list)
    -- if heroLen == 0 then
    -- 	self.is_choose_elem = true
    -- 	return
    -- end

    -- 给执行任务的英雄排序
    ex.Player.hero_data:sortByTask(hero_list, ex.Player.pub_task.taskHeroList)

    local margin = 0
    --local heroLen = table.nums(hero_list)
    local col = math.floor((self.viewSize.width - margin * 2) / self.item_size.width) -- 列数
    local row = math.ceil(1.0 * heroLen / col) -- 行数
    local cont_height = self.item_size.height * row + margin * 2
    cont_height = math.max(cont_height , self.viewSize.height)
    row = math.ceil((cont_height - margin * 2) / self.item_size.height) -- 总行数

    local index = 0
    for k,v in pairs(hero_list) do
        local nowData = {}
        nowData.type = 4
        nowData.heroData = v
        nowData.setSelected = false
		nowData.setTaskIng = false
		for k, v2 in pairs(self.choose_hero_view) do
			if v.hero_id == v2.hero_id then
                nowData.setSelected = true
                break
            end
        end
		if v.hasTask > 0 then
        	nowData.setTaskIng = true
		end
        table.insert( self.hero_list_view , nowData )
	end 


    self.layer.select_hero_scroll_view.createItemFunction = function(hero_data, scale)
        
        local item = UIMenuItemHero:createWithData(hero_data.heroData.hero_id, hero_data.heroData.hero_type, hero_data.heroData.elem, hero_data.heroData.level, hero_data.heroData.star)
        item:registerScriptTapHandler(handler(self, self.changeHeroTask))
        item:setScale(1)
		item:showOccupation() 
		item:setSelected(hero_data.setSelected)
		if hero_data.setTaskIng then 
			item:setTasking()
		end 

        return item
    end

    self.layer.select_hero_scroll_view:reloadData(self.hero_list_view)

    self.layer.select_hero_scroll_view.menu:setLuaModel(true)
    self.layer.select_hero_scroll_view.menu:enableLongPress(true)
    self.layer.select_hero_scroll_view.menu:setLongPressCallback(handler(self, self.longTouch))


    self.is_choose_elem = true

end

function PubTaskChooseHeroCtr:longTouch(tag, pSender)
    require("src.layer.heroinfo.HeroShareInfoCtr"):instance():openWindowById(pSender.hero_id)
end

function PubTaskChooseHeroCtr:getHeroInListView(hero_id)
	for _,v in pairs(self.hero_list_view) do
			if hero_id == v.heroData.hero_id then
				-- 选择英雄
				return v.heroData
			end
	end
end

function PubTaskChooseHeroCtr:setHeroListViewSelect(hero_id)
	for _,v in pairs(self.hero_list_view) do
		if v.hero_id == hero_id then
			v:setSelected(not v:isSelected())
			return
		end
	end
end

function PubTaskChooseHeroCtr:getChooseHeroView()
	local hero = {}
	for _,v in pairs(self.choose_hero_view) do
		if v.hero_id ~= 0 then
			table.insert(hero, v.hero_id)
		end
	end

	return hero
end

function PubTaskChooseHeroCtr:getChooseHero(hero_id)
	for _,v in pairs(self.choose_hero_view) do
		if v.hero_id == hero_id then
			return cc.p(v:getPositionX(), v:getPositionY())
		end
	end

	return cc.p(0, 0)
end

function PubTaskChooseHeroCtr:setTaskHero(hero_id, enabled, data)
	for _,v in pairs(self.choose_hero_view) do
		if v.hero_id == hero_id then
			v:setEnabled(enabled)
			v:reset(data)
			if hero_id == 0 then
				v:showOccupation()
			else
				v:hideOccupation()
			end
			return
		end
	end
end

function PubTaskChooseHeroCtr:getClickViewPos(pSender)
	local pos = cc.p(self.viewPos.x + self.layer.tableView:getContainer():getPositionX() + pSender:getPositionX(),
		self.viewPos.y + self.layer.tableView:getContainer():getPositionY() + pSender:getPositionY())

	if pos.y < self.viewPos.y then
		pos.y = self.viewPos.y
	elseif pos.y > self.viewPos.y + self.viewSize.height then
		pos.y = self.viewPos.y + self.viewSize.height
	end

	return pos
end


function PubTaskChooseHeroCtr:changeHeroTask(tag,pSender)

	self:onClickHeroView(pSender)
end 


function PubTaskChooseHeroCtr:onClickHeroView( pSender)
	local startPos, endPos = cc.p(0, 0)
	local callback = nil

	--print("click_hero_num: "..self.click_hero_num)

	if pSender.selected == false then
		if self.hero_max <= self.click_hero_num then
			--超出可派遣的最大个数
			ex.MessageView:add(ex.Tools:getLang(2209))
			return
		end

		--print(ex.Tools:getLang(47451), pSender.hero_id)
		self.click_hero_num =  self.click_hero_num + 1

		self:setTaskHero(0, true, ex.Player.hero_data:getHeroDataById(pSender.hero_id))
		self:checkCondition()
	else
		--print(ex.Tools:getLang(47753), pSender.hero_id)
		self.click_hero_num =  self.click_hero_num - 1

		self:setTaskHero(pSender.hero_id, false, {})
		self:checkCondition()
	end

	pSender:setSelected(not pSender:isSelected())
end

function PubTaskChooseHeroCtr:onClickTaskHero(tag, pSender)
	self.click_hero_num =  self.click_hero_num - 1

    self:setTaskHero(pSender.hero_id, false, {})
    -- self:setHeroListViewSelect(pSender.hero_id)
	self:updateScrollView()

	-- 取消选择
	pSender:setEnabled(false)
	pSender:reset()
	pSender:hideOccupation()

	self:checkCondition()
end

function PubTaskChooseHeroCtr:checkCondition()
	print("PubTaskChooseHeroCtr:checkCondition")

	local vec_result = {}
	for i, v in ipairs(self.condition.vec_spr_cond) do
		table.insert(vec_result, 2)
	end
	local setConditionGLProgram = function()
		for i, v in ipairs(self.condition.vec_spr_cond) do
			if v ~= nil then
				local img = v:getNormalImage()--:setGLProgram(cpp.ShaderFactory:instance():getGLProgram(vec_result[i]))
				ex.Tools:setGrayAuto(img, vec_result[i] ~= 0)
			end
		end
	end

	if self.click_hero_num <= 0 then
		setConditionGLProgram()
		return
	end

	local hero_list = self:getChooseHeroView()
	for _,v in pairs(hero_list) do
		local hero = ex.Player.hero_data:getHeroDataById(v)
		for i, v2 in ipairs(self.condition.vec_num_cond) do
			if v2[1] == "star" and hero.star >= v2[2] then
				vec_result[i] = 0
			end
			if v2[1] == "element" and hero.elem == v2[2] then
				vec_result[i] = 0
			end
			if v2[1] == "occupation" and hero.occupation == v2[2] then
				vec_result[i] = 0
			end
		end
	end

	setConditionGLProgram()

end

function PubTaskChooseHeroCtr:setCondition(isShow)
	local glp = ShaderType.ST_POSITION_TEXTURE_DEFAULT
	if isShow == false then
		glp = ShaderType.ST_POSITION_TEXTURE_GRAY
	end

	for i, v in ipairs(self.condition.vec_spr_cond) do
		if self.condition.vec_spr_cond[i] ~= nil then
			self.condition.vec_spr_cond[i]:getNormalImage():setGLProgram(cpp.ShaderFactory:instance():getGLProgram(glp))
		end
	end
end

function  PubTaskChooseHeroCtr:clearChoose()
	for _,v in pairs(self.choose_hero_view) do
		v:setEnabled(false)
		v:reset()
		v:hideOccupation()
	end

	for _,v in pairs(self.hero_list_view) do
		v.setSelected = false	
	end


	self:setCondition(false)

	self.click_hero_num = 0
end

function PubTaskChooseHeroCtr:onAutoChoose(tag, pSender)
	self.layer.btn_auto:setEnabled(false)

	local callback = function()
		self.layer.btn_auto:setEnabled(true)
	end

	-- 初始化结果
	local vec_result = {}
	local auto_list = {}
	for i, v in ipairs(self.condition.vec_spr_cond) do
		table.insert(vec_result, 2)
	end
	for _,v in pairs(self.hero_list_view) do

			if v.heroData.hasTask == 0 then
				local is_succ = false
				for i, v2 in ipairs(self.condition.vec_num_cond) do
					if vec_result[i] ~= 0 then
						if v2[1] == "star" and v.heroData.star >= v2[2] then
							vec_result[i] = 0
							is_succ = true
						end
						if v2[1] == "element" and v.heroData.elem == v2[2] then
							vec_result[i] = 0
							is_succ = true
						end
						if v2[1] == "occupation" and v.heroData.occupation == v2[2] then
							vec_result[i] = 0
							is_succ = true
						end
					end
				end
				if is_succ == true then
					table.insert(auto_list, v.heroData.hero_id)
				end
			end
	end
	
	--[[
	-- 检测是否全部状态正常
	for i, v in ipairs(vec_result) do
		if v ~= 0 then
			if self.condition.vec_num_cond[i][1] == "star" then
				--print(ex.Tools:getLang(47345))
				ex.MessageView:add(string.format(ex.Tools:getLang(2216), self.condition.vec_num_cond[i][2]))
				return
			elseif self.condition.vec_num_cond[i][1] == "element" then
				--print(ex.Tools:getLang(47152))
				ex.MessageView:add(string.format(ex.Tools:getLang(2215), ex.Tools:getLang(2100 + self.condition.vec_num_cond[i][2])))
				return
			elseif self.condition.vec_num_cond[i][1] == "occupation" then
				--print(ex.Tools:getLang(47645))
				ex.MessageView:add(string.format(ex.Tools:getLang(2217), ex.Tools:getLang(111000 + self.condition.vec_num_cond[i][2])))
				-- return
			end
		end
	end
	]]

	-- 清除之前选择的
	self:clearChoose()

	-- 删除相同的
	local auto_hero = DeleteEqualElement(auto_list)
	self.click_hero_num = table.nums(auto_hero)

	--ex.out(auto_hero)

	for _,id in pairs(auto_hero) do
		repeat
			for _,v in pairs(self.hero_list_view) do
					if id == v.heroData.hero_id then
						-- 选择英雄
						--v:setSelected(true)
						v.setSelected = true
						self:setTaskHero(0, true, ex.Player.hero_data:getHeroDataById(v.heroData.hero_id))
						break
					end
			end
		until true
	end

	-- self:setCondition(true)

	local setConditionGLProgram = function()
		for i, v in ipairs(self.condition.vec_spr_cond) do
			if v ~= nil then
				local img = v:getNormalImage()--:setGLProgram(cpp.ShaderFactory:instance():getGLProgram(vec_result[i]))
				ex.Tools:setGrayAuto(img, vec_result[i] ~= 0)
			end
		end
	end

	setConditionGLProgram()

	callback()
	

	-- self.layer.tableView:initData(self.hero_list_view)
	-- self.layer.tableView:reloadData()
	-- local offsetY = self.layer.tableView:getContainer():getPositionY()
	-- self.layer.tableView:setContentOffset(cc.p(0,offsetY))
	self.layer.select_hero_scroll_view:reloadData(self.hero_list_view)

end

function PubTaskChooseHeroCtr:onStartTask(tag, pSender)
	if self.click_hero_num <= 0 then
		--print(ex.Tools:getLang(47253))
		ex.MessageView:add(ex.Tools:getLang(2210))
		return
	end
    
	-- 初始化结果
	local vec_result = {}
	for i, v in ipairs(self.condition.vec_spr_cond) do
		table.insert(vec_result, 2)
	end
	-- 刷新结果
	local hero_list = self:getChooseHeroView()
	for _,v in pairs(hero_list) do
		local hero = ex.Player.hero_data:getHeroDataById(v)
		for i, v2 in ipairs(self.condition.vec_num_cond) do
			if v2[1] == "star" and hero.star >= v2[2] then
				vec_result[i] = 0
			end
			if v2[1] == "element" and hero.elem == v2[2] then
				vec_result[i] = 0
			end
			if v2[1] == "occupation" and hero.occupation == v2[2] then
				vec_result[i] = 0
			end
		end
	end
	-- 检测是否全部状态正常
	for i, v in ipairs(vec_result) do
		if v ~= 0 then
			if self.condition.vec_num_cond[i][1] == "star" then
				--print(ex.Tools:getLang(47345))
				ex.MessageView:add(string.format(ex.Tools:getLang(2216), self.condition.vec_num_cond[i][2]))
				return
			elseif self.condition.vec_num_cond[i][1] == "element" then
				--print(ex.Tools:getLang(47152))
				ex.MessageView:add(string.format(ex.Tools:getLang(2215), ex.Tools:getLang(2100 + self.condition.vec_num_cond[i][2])))
				return
			elseif self.condition.vec_num_cond[i][1] == "occupation" then
				--print(ex.Tools:getLang(47645))
				ex.MessageView:add(string.format(ex.Tools:getLang(2217), ex.Tools:getLang(111000 + self.condition.vec_num_cond[i][2])))
				return
			end
		end
	end
	
	ex.Player.pub_task:doneTask(self.task_id, hero_list)

	self:closeWindow(nil, self.layer)
end

function PubTaskChooseHeroCtr:chooseHeroElem(elem)
	if self.is_choose_elem == false then
		return
	end

    if self.cur_hero_elem == elem then
        return
    end

    self.cur_hero_elem = elem

    self.btn_elem_select:setSelected(elem)

    self:updateScrollView()
end

function PubTaskChooseHeroCtr:onChooseElem(tag, pSender)
	self:chooseHeroElem(tag)
end


return PubTaskChooseHeroCtr
