local ArtifactItemSelectCtr = class("ArtifactItemSelectCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ArtifactItemSelectLayer = class("ArtifactItemSelectLayer", require("src.comp.EventLayer"))

function ArtifactItemSelectLayer:onCreate()
	self:addBlackBackground()
	local hs_ctr = ArtifactItemSelectCtr:instance()
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

function ArtifactItemSelectLayer:onExitCB()
	ex.Player.hero_data.promote:resetStarCount()
	self.select_list = nil
	-- ex.Player.hero_data.promote:setNeedCount(0)
	-- ex.EventManager:fire(EVENT.HERO_INFO_EVENT.HERO_UP_STAR_SELECT_EXIT)
end


function ArtifactItemSelectLayer:selectHero(event,data)

	if not 	data.item_type then  
		self.select_list[data.hero_id] = data
	else 
		self.select_list[data.item_type] = data
	end 
	self.lbl_select:setString(string.format(ex.Tools:getLang(47578),ex.Player.hero_data.promote:getNewUpStarCount(self.index),self.needCount))
end

function ArtifactItemSelectLayer:onUpStar()

	for k,v in pairs(self.select_list) do
		if v.selected == true then 
			ex.Player.hero_data.promote:selectComsumeHero(self.index,v)
		else
			ex.Player.hero_data.promote:cancelComsumeHero(self.index,v.hero_id)
		end
	end
end

-----------------------------------------------------------------------------
function ArtifactItemSelectCtr:ctor()
	local ccbi_file = "ccbi/ArtifactItemSelectLayer.ccbi"
	self:setCCBIPath(ccbi_file)
	self:registerCCBLoader()
	self:setIsSingle(false)
end

function ArtifactItemSelectCtr:loadLayer()
	local layer = ArtifactItemSelectLayer
	local ccbi_file = self:getCCBIPath()
	self.layer = layer:create(ccbi_file)
	self:setLayer(self.layer)

    -- 创建点击事件
    self:registerTouchListen()
end


function ArtifactItemSelectCtr:getArtifactItemSelectLayer()
	return self.layer
end

function ArtifactItemSelectCtr:openWindow(hero_list, callback, num, is_show_lock, is_show_quick_go) --(data, num)
	if self:isOpened() then
		return
	end

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/runes.plist")
	
	self:loadLayer()
	self:open()
	self:initData(hero_list, callback, num, is_show_lock, is_show_quick_go)
end

function ArtifactItemSelectCtr:initData(hero_list, callback, num, is_show_lock, is_show_quick_go)
    self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))
    self.needCount = num
    self.select_num = 0
    self.callback = callback

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
	self:updateLayer(hero_list)
end

function ArtifactItemSelectCtr:updateLayer(data)
	local layer = self.layer
	-- layer.index = self.index

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
				item.data = data[i]
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
				local posY = height - (math.ceil(i / 5)) * scale * (item:getContentSize().height + 10)
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
                cell_props:autoLocked()
				-- cell_props.spr_select:setVisible(data.selected)
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
		local size = cc.size(layer.viewSize.width,math.ceil((#data / 5)) * ((cell_content.height+10) * scale) + (10 * scale))
		srcoll_view:setContentSize(size)
		srcoll_view:setContentOffset(cc.p(0,layer.viewSize.height - height)) 
		srcoll_view:setTouchEnabled(math.ceil((#data / 5)) > 2)
	end
	layer.lbl_select:setString(string.format(ex.Tools:getLang(47578),0,self.needCount))
	layer.needCount = self.needCount
	layer.btn_confirm:registerScriptTapHandler(handler(self,self.selectHeroEnter))

end

function ArtifactItemSelectCtr:onGo(tag, pSender)
	if cfg.funcopen["act_limit_gift"].isVisible() then
		ex.JumpManager:jumpByAtom("act_limit_gift")
		self:closeWindow()
	else
		ex.MessageView:add(ex.Tools:getLang(41311))
		return
	end
end

function ArtifactItemSelectCtr:onClickItem(tag,pSender)
	local needCount = self.needCount
	local count = self.select_num
	if count >= needCount and pSender.selected == false then return end
    pSender:setSelected(not pSender.selected)
    
	if pSender.selected == true then 
        self:addSelectItem(pSender)
	else
        self:cannelSelectItem(pSender)
	end
    pSender.data.selected = pSender.selected
    self.select_num = table.nums(self.layer.select_list)
    self.layer.lbl_select:setString(string.format(ex.Tools:getLang(47578),self.select_num,self.needCount))
	
	-- ex.Player.hero_data.promote:setSlectReplace( self.index, pSender.selected)
	
	-- local replace_data = {}
	-- replace_data.item_type = pSender.item_type
	-- replace_data.item_num = 1
	-- replace_data.is_item = 1
	-- replace_data.selected = true
	-- ex.EventManager:fire(EVENT.HERO_INFO_EVENT.HERO_UP_STAR_SELECT, replace_data)

end

function ArtifactItemSelectCtr:onClickHero(tag,pSender)
	--if pSender.battle == true then 
		--ex.Player.hero_data:getHeroBattleMsg(pSender:getHeroId())
		--return 
	--end
    if pSender:showLockedMessage() then 
        return 
    end 
	local needCount = self.needCount
	local count = self.select_num
	if count >= needCount and pSender.selected == false then return end
	pSender:setSelected(not pSender.selected)

	if pSender.selected == true then 
		if pSender.locked and self.is_show_lock then
			ex.MessageView:add(ex.Tools:getLang(41271))
			pSender.selected = false
			pSender:setSelected(pSender.selected)
			return
		else
            -- ex.Player.hero_data.promote:setUpStarCount(1)
            -- self.select_num = self.select_num + 1
            self:addSelectItem(pSender)
		end
	else
        -- self.select_num = self.select_num - 1
        self:cannelSelectItem(pSender)
	end
    pSender.data.selected = pSender.selected
    self.select_num = table.nums(self.layer.select_list)
    self.layer.lbl_select:setString(string.format(ex.Tools:getLang(47578),self.select_num,self.needCount))
	-- ex.EventManager:fire(EVENT.HERO_INFO_EVENT.HERO_UP_STAR_SELECT,pSender.data)
end

function ArtifactItemSelectCtr:addSelectItem(pSender)
    for i,v in ipairs(self.layer.select_list) do
        if v == pSender then 
            return 
        end
    end
    table.insert(self.layer.select_list,pSender)
end

function ArtifactItemSelectCtr:cannelSelectItem(pSender)
    local idx = 0
    for i,v in ipairs(self.layer.select_list) do
        if v == pSender then 
            idx = i 
            break
        end
    end
    if idx ~= 0 then 
        table.remove(self.layer.select_list,idx)
    end
end

function ArtifactItemSelectCtr:onClickAdd(tag, pSender)
	local type = pSender.need_type
	local prop_type = ex.Player.backpack_data:getPropType(pSender.need_type)

	if prop_type == ItemData.IT_HERO then
		type = cfg.herotype.star[pSender.need_type].item_id
	end
	
	require("src.layer.BackpackSrcCtr"):instance():openWindow(type, handler(self, self.jumpCallback))
end

function ArtifactItemSelectCtr:jumpCallback(atom)
	self:closeWindow(nil,self.layer)
end

function ArtifactItemSelectCtr:selectHeroEnter(tag,pSender)
    local data = {}
    for k,v in pairs(self.layer.select_list) do
        
        table.insert(data,v.data)

		-- if v.is_item and v.is_item == 1 then 
			
		-- else 
		-- 	if v.selected == true then 
		-- 		ex.Player.hero_data.promote:selectComsumeHero(self.index,v)
		-- 	else
		-- 		ex.Player.hero_data.promote:cancelComsumeHero(self.index,v.hero_id)
		-- 	end
		-- end 
    end
    -- dump(data)
    if self.callback then 
        self.callback(data)
    end
	self:closeWindow(nil,self.layer)
end

return ArtifactItemSelectCtr
