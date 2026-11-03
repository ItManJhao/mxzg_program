local HeroUpStarSelectCtr = class("HeroUpStarSelectCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroUpStarSelectLayer = class("HeroUpStarSelectLayer", require("src.comp.EventLayer"))

function HeroUpStarSelectLayer:onCreate()
	self:addBlackBackground()
	local hs_ctr = HeroUpStarSelectCtr:instance()
	local win_size = cc.Director:getInstance():getWinSize();
	local height = Maths.min(self:getContentSize().height, win_size.height);
	self:setScale(height / self:getContentSize().height);
	ex.Player.hero_data.promote:resetStarCount()
	self.hero_data = ex.Player.hero_data.promote:getSelectHero()

	self.select_list = {}
	self.viewSize = cc.size(474, 166)

	self.scroll_view = cc.ScrollView:create(self.viewSize)
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    :setPosition(51, 98)
    self:addChild(self.scroll_view)
    self:setExitCallback(handler(self,self.onExitCB))

    self:addEvent(EVENT.HERO_INFO_EVENT.HERO_UP_STAR_SELECT,handler(self,self.selectHero))

    self.lbl_btn_update = cc.Label:createWithTTF(ex.Tools:getLang(47589), FONT_DEFAULT_NAME_BOLD, 25)
    self.btn_confirm:addChild(self.lbl_btn_update)
    -- self.btn_confirm:setLabelSize(30)
    self.lbl_btn_update:setPosition(self.btn_confirm:getContentSize().width / 2,self.btn_confirm:getContentSize().height / 2)
    self.lbl_btn_update:enableOutline(ex.c3b.BLUE, 1)

end

function HeroUpStarSelectLayer:onExitCB()
	ex.Player.hero_data.promote:resetStarCount()
	self.select_list = nil
	ex.Player.hero_data.promote:setNeedCount(0)
	ex.EventManager:fire(EVENT.HERO_INFO_EVENT.HERO_UP_STAR_SELECT_EXIT)
end


function HeroUpStarSelectLayer:selectHero(event,data)

	if not 	data.item_type then  
		self.select_list[data.hero_id] = data
	else 
		self.select_list[data.item_type] = data
	end 
	self.lbl_select:setString(string.format(ex.Tools:getLang(47578),ex.Player.hero_data.promote:getNewUpStarCount(self.index),self.needCount))
end

function HeroUpStarSelectLayer:onUpStar()

	for k,v in pairs(self.select_list) do
		if v.selected == true then 
			ex.Player.hero_data.promote:selectComsumeHero(self.index,v)
		else
			ex.Player.hero_data.promote:cancelComsumeHero(self.index,v.hero_id)
		end
	end
end

-----------------------------------------------------------------------------
function HeroUpStarSelectCtr:ctor()
	local ccbi_file = "ccbi/HeroUpStarSelectLayer.ccbi"
	self:setCCBIPath(ccbi_file)
	self:registerCCBLoader()
	self:setIsSingle(false)
end

function HeroUpStarSelectCtr:loadLayer()
	local layer = HeroUpStarSelectLayer
	local ccbi_file = self:getCCBIPath()
	self.layer = layer:create(ccbi_file)
	self:setLayer(self.layer)

    -- 创建点击事件
    self:registerTouchListen()
end


function HeroUpStarSelectCtr:getHeroUpStarSelectLayer()
	return self.layer
end

function HeroUpStarSelectCtr:openWindow(index, is_show_lock, is_show_quick_go) --(data, num)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/runes.plist")
	self:initData(index, is_show_lock, is_show_quick_go)
end

function HeroUpStarSelectCtr:initData(index, is_show_lock, is_show_quick_go)
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
	
	local hero_data = ex.Player.hero_data.promote:getSelectHero()
	if not hero_data then 
		hero_data = ex.Player.hero_data.promote:getSelectHeroTypeByData()
		hero_data.hero_type = hero_data.type
	end
	local data = {}
	local canData
	local nextStar = "to_" .. hero_data.star + 1 .. "_star"
    local starData = cfg.herotype.star[hero_data.hero_type][nextStar]
	
	local replace_item_list = {}

	if index == 0 then 
		self.needCount = 1
		canData = ex.Player.hero_data.promote:getHeroTypeByList(hero_data.hero_type,hero_data.star)
	else
		self.needCount = starData[index].num
		canData,replace_item_list  = ex.Player.hero_data.promote:getCanSelectList(starData[index],index)
	end

    ex.Player.hero_data.promote:setNeedCount(self.needCount)
	if replace_item_list then 
		for i,v in ipairs(replace_item_list) do
			table.insert(data,v)
		end
	end 

    local comsumeData = ex.Player.hero_data.promote:getComsumeHeroList(index)
    for i,v in ipairs(comsumeData) do
    	v.selected = true
    	ex.Player.hero_data.promote:setUpStarCount(1)
    	table.insert(data,v)
    end

    for i,v in ipairs(canData) do
    	v.selected = false
    	table.insert(data,v)
	end
	
	-- 增加按钮
	local btn_add_data = {is_add = true, need_type = hero_data.hero_type, need_star = hero_data.star}
	if index ~= 0 then
		btn_add_data.need_type = (starData[index].type == -1) and hero_data.hero_type or starData[index].type
		if btn_add_data.need_type == 0 then		-- 类型为0是指定星级未指定类型的所有英雄
			local limit_star = math.max(3, math.min(5, starData[index].star))
			local elem = (starData[index].elem == -1) and hero_data.elem or starData[index].elem
			btn_add_data.need_type = 20000000 + 100000 * elem + 1000 * limit_star
			btn_add_data.need_star = limit_star
		else
			btn_add_data.need_star = starData[index].star
		end
	end
	table.insert(data, btn_add_data)

    self.index = index
	self:updateLayer(data)
end

function HeroUpStarSelectCtr:updateLayer(data)
	local layer = self.layer
	layer.index = self.index

	local srcoll_view = layer.scroll_view
	local height 
	srcoll_view:getContainer():removeAllChildren()
	local menu = cpp.UIMenu:create()
    :setIsTouchInsideNode(srcoll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    srcoll_view:getContainer():addChild(menu)
    local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")
	local scale = 0.77
	if #data > 0 then 
		table.sort(data, function(a, b)
			if (a.is_item and a.is_item == 1) or a.is_add then 
				return false
			elseif (b.is_item and b.is_item == 1) or b.is_add then
				return true
			else
				return a.hero_type > b.hero_type
			end
		end)

		local save_cell_props = UIMenuItemHero:createWithData()
		local is_first = false
		local cell_content
		for i=1,#data do
			if data[i].is_item and data[i].is_item == 1 then 
				local item = ex.Player.backpack_data:createWithData(data[i].item_type, data[i].item_num)
				if not height then height = math.ceil((#data / 5)) * (save_cell_props:getContentSize().height * scale+10) + (10 * scale) end
				local idx = (i - 1) % 5
				local posX = (save_cell_props:getContentSize().width + 16) * scale * (idx) + 15
				local posY = height - (math.ceil(i / 5)) * scale * (save_cell_props:getContentSize().height + 10)
				item:setAnchorPoint(0,0)
				item:setPosition(posX,posY)
				item:setScale(scale)
				menu:add(item)
				item.index = self.index
				-- 没有独立ID， 只能默认选择第一个了
				if ex.Player.hero_data.promote:getSlectReplace(self.index) == true and is_first == false then 
					item:setSelected(true)
					is_first = true 
				end 
				cell_content = item:getContentSize()
				item:registerScriptTapHandler(handler(self,self.onClickItem))
			elseif data[i].is_add then
				local idx = (i - 1) % 5
				local item = cpp.UIMenuItemImage:createWithSpriteFrameName("backpack/rare-0.png", nil, nil)
				if not height then height = math.ceil((#data / 5)) * (item:getContentSize().height * scale + 10) + (10 * scale) end
				local posX = (item:getContentSize().width + 16) * scale * (idx) + 15
				local posY = height - (math.ceil(i / 5)) * scale * (save_cell_props:getContentSize().height + 10)
				item.need_type = data[i].need_type
				item.need_star = data[i].need_star
				item:setAnchorPoint(0,0)
				item:setPosition(posX,posY)
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
				cell_props:reset(data[i])
				--if data[i].is_lock and self.is_show_lock then
					--cell_props:setLocked()
				--end
				---- cell_props.battle = true
				--local bool = ex.Player.hero_data.promote:heroIsBattle(data[i].hero_id)
				--if bool == true or ex.Player.hero_data.promote:checkHeroIsBattle(data[i].hero_id) then cell_props:setBattling() end
				-- cell_props.spr_select:setVisible(data.selected)
                cell_props:autoLocked()
				cell_content = cell_props:getContentSize()
				menu:add(cell_props)
				cell_props:registerScriptTapHandler(handler(self,self.onClickHero))
				if not height then height = math.ceil((#data / 5)) * (cell_content.height * scale+10) + (10 * scale) end
				
				local idx = (i - 1) % 5
				local posX = (cell_content.width + 16) * scale * (idx) + 15
				local posY = height - (math.ceil(i / 5)) * scale * (cell_content.height + 10)
				cell_props:setAnchorPoint(0,0)
				cell_props:setPosition(posX,posY)
				cell_props:setScale(scale)
	
				cell_props.index = self.index
			end 
		end
		local size = cc.size(layer.viewSize.width,math.ceil((#data / 5)) * ((cell_content.height+15) * scale) + (10 * scale))
		srcoll_view:setContentSize(size)
		srcoll_view:setContentOffset(cc.p(0,layer.viewSize.height - height)) 
		srcoll_view:setTouchEnabled(math.ceil((#data / 5)) > 2)
	end
	layer.lbl_select:setString(string.format(ex.Tools:getLang(47578),ex.Player.hero_data.promote:getNewUpStarCount(self.index),self.needCount))
	layer.needCount = self.needCount
	layer.btn_confirm:registerScriptTapHandler(handler(self,self.selectHeroEnter))

end

function HeroUpStarSelectCtr:onGo(tag, pSender)
	if cfg.funcopen["act_limit_gift"].isVisible() then
		ex.JumpManager:jumpByAtom("act_limit_gift")
		self:closeWindow()
	else
		ex.MessageView:add(ex.Tools:getLang(41311))
		return
	end
end

function HeroUpStarSelectCtr:onClickItem(tag,pSender)
	local needCount = ex.Player.hero_data.promote:getNeedCount()
	local count = ex.Player.hero_data.promote:getNewUpStarCount(pSender.index)
	if count >= needCount and pSender.selected == false then return end
	pSender:setSelected(not pSender.selected)
	
	ex.Player.hero_data.promote:setSlectReplace( self.index, pSender.selected)
	
	local replace_data = {}
	replace_data.item_type = pSender.item_type
	replace_data.item_num = 1
	replace_data.is_item = 1
	replace_data.selected = true
	ex.EventManager:fire(EVENT.HERO_INFO_EVENT.HERO_UP_STAR_SELECT, replace_data)

end

function HeroUpStarSelectCtr:onClickHero(tag,pSender)
	--if pSender.battle == true then 
		--ex.Player.hero_data:getHeroBattleMsg(pSender:getHeroId())
		--return 
	--end
    if pSender:showLockedMessage() then 
        return 
    end 
	local needCount = ex.Player.hero_data.promote:getNeedCount()
	local count = ex.Player.hero_data.promote:getNewUpStarCount(pSender.index)
	if count >= needCount and pSender.selected == false then return end
	pSender:setSelected(not pSender.selected)

	if pSender.selected == true then 
		if pSender.locked and self.is_show_lock then
			ex.MessageView:add(ex.Tools:getLang(41271))
			pSender.selected = false
			pSender:setSelected(pSender.selected)
			return
		else
			ex.Player.hero_data.promote:setUpStarCount(1)
		end
	else
		ex.Player.hero_data.promote:setUpStarCount(-1)
	end
	pSender.data.selected = pSender.selected
	ex.EventManager:fire(EVENT.HERO_INFO_EVENT.HERO_UP_STAR_SELECT,pSender.data)
end

function HeroUpStarSelectCtr:onClickAdd(tag, pSender)
	local type = pSender.need_type
	local prop_type = ex.Player.backpack_data:getPropType(pSender.need_type)

	if prop_type == ItemData.IT_HERO then
		type = cfg.herotype.star[pSender.need_type].item_id
	end
	
	require("src.layer.BackpackSrcCtr"):instance():openWindow(type, handler(self, self.jumpCallback))
end

function HeroUpStarSelectCtr:jumpCallback(atom)
	self:closeWindow(nil,self.layer)
end

function HeroUpStarSelectCtr:selectHeroEnter(tag,pSender)
	for k,v in pairs(self.layer.select_list) do

		if v.is_item and v.is_item == 1 then 
			
		else 
			if v.selected == true then 
				ex.Player.hero_data.promote:selectComsumeHero(self.index,v)
			else
				ex.Player.hero_data.promote:cancelComsumeHero(self.index,v.hero_id)
			end
		end 
	end
	self:closeWindow(nil,self.layer)
end

return HeroUpStarSelectCtr
