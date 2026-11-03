local PetSelectCtr = class("PetSelectCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PetSelectLayer = class("PetSelectLayer", require("src.comp.EventLayerAdaptiveWidth"))
local UIMenuItemBag = require("src.comp.menu.UIMenuItemBag")

--------------------------------------------

function PetSelectLayer:onCreate()
	self.viewSize = self.scroll_view:getViewSize()
	self.selected_data = {}
	self.check_box_list = {}
	self:registerBtnEvent()
	self:addBlackBackground()
	
	self.rich_text = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(20)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#5E3E16")
	:setAnchorTextShadow(true)
	:setAnchorPoint(ex.a.right_center)
	self:addChild(self.rich_text)
	self.rich_text:setXmlTextLua(ex.Tools:getLang(4809))
	self.rich_text:formatText()
	local x,y = self.lbl_tips:getPosition()
	print(self.__cname,x,y)
	self.rich_text:setPosition(x,y)
end

function PetSelectLayer:registerBtnEvent( )
	self.btn_goto:registerScriptTapHandler(handler(self, self.onCommit))
	
    local lbl_btn_goto = cc.Label:createWithTTF(ex.Tools:getLang(72028), FONT_DEFAULT_NAME_BOLD, 24)
    lbl_btn_goto:setAnchorPoint(cc.p(0.5, 0.5))
    lbl_btn_goto:setTextColor(cc.c3b(255,255,255))
    lbl_btn_goto:enableOutline(cc.c3b(13,91,45),2)
    self.btn_goto:addChild(lbl_btn_goto)
    lbl_btn_goto:setPosition(self.btn_goto:getContentSize().width / 2,self.btn_goto:getContentSize().height / 2)
end

function PetSelectLayer:onCommit(tag,pSender)
	if self.callback then 
        self.callback(self.selected_data)
	end
	PetSelectCtr:instance():closeWindow()
end

function PetSelectLayer:createCheckBox()
    local checkBox = ccui.CheckBox:create()
    checkBox:setTouchEnabled(true)
    checkBox:loadTextures("win-bg/win-bg-18.png","win-bg/win-bg-18.png","backpack/spr-selected.png","win-bg/win-bg-18.png","win-bg/win-bg-18.png",ccui.TextureResType.plistType)
    checkBox:addEventListener(handler(self,self.selectedEvent))
    -- self:addChild(checkBox)
    return checkBox
end

function PetSelectLayer:selectedEvent(sender,eventType)

	if eventType == ccui.CheckBoxEventType.selected then 

		if self.max_num <= table.nums(self.selected_data) then 
			sender:setSelected(false)
			return 
		end
		self:checkSelected()
	elseif eventType == ccui.CheckBoxEventType.unselected then 

		self:checkSelected()
	end
	-- self:checkSelected()
	-- dump(self.selected_data)

end

function PetSelectLayer:checkSelected( )
	self.selected_data = {}
	for k,v in pairs(self.check_box_list) do
		local select = v:isSelected()
		if select == true then 
			table.insert(self.selected_data,k)
		end
	end

	local str = string.format(ex.Tools:getLang(4808),table.nums(self.selected_data),self.max_num)
	self.lbl_select:setString(str)
end

function PetSelectLayer:updateLayer(data,has_add)
	local layer = self.layer
	-- layer.index = self.index

	local srcoll_view = self.scroll_view
	local height 
	srcoll_view:getContainer():removeAllChildren()
	local menu = cpp.UIMenu:create()
    :setIsTouchInsideNode(srcoll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    srcoll_view:getContainer():addChild(menu)
	local scale = 1 --0.77
	if has_add then table.insert(data,"add_item") end
	if #data > 0 then 

		local save_cell_props = cc.Sprite:createWithSpriteFrameName("other/rare-0.png"):getContentSize()
		local is_first = false
		local cell_content = save_cell_props
		local nums
		
		for i=1,#data do
			nums = #data
			if i == #data and has_add then 
				local idx = (i - 1) % 4
				local item = cpp.UIMenuItemImage:createWithSpriteFrameName("backpack/rare-0.png", nil, nil)
				if not height then height = math.ceil((#data / 4)) * (save_cell_props.height * scale+10) + (10 * scale) end
				local posX = (save_cell_props.width + 25) * scale * (idx) + 18
				local posY = height - (math.ceil(i / 4)) * scale * (save_cell_props.height + 10)
				-- item.need_type = data[i].need_type
				-- item.need_star = data[i].need_star
				item:setAnchorPoint(0,0)
				item:setPosition(posX,posY)
				item:setScale(scale)
				item:setEnableAction(false)
				item:registerScriptTapHandler(handler(self, self.onClickAdd))

				local spr_add = cc.Sprite:createWithSpriteFrameName("runes/btn-add-1.png")
				spr_add:setScale(1)
				spr_add:setPosition(cell_content.width / 2, cell_content.height / 2)
				item:addChild(spr_add)
				menu:addChild(item)
			else
				local item = UIMenuItemBag:createWithData(data[i].sys_id)
				-- self.item_type = data[i].sys_id
				item:setLevel(data[i].level)
				if not height then height = math.ceil((#data / 4)) * (save_cell_props.height * scale+10) + (10 * scale) end
				local idx = (i - 1) % 4
				local posX = (save_cell_props.width + 25) * scale * (idx) + 18
				local posY = height - (math.ceil(i / 4)) * scale * (save_cell_props.height + 10)
				item:setAnchorPoint(0,0)
				item:setPosition(posX,posY)
				item:setScale(scale)
				menu:add(item)
				item.data = data[i]
				item:showPetRare()
	
				cell_content = item:getContentSize()
				local checkBox = self:createCheckBox()
				item:addChild(checkBox)
				checkBox:setPosition(cell_content.width - checkBox:getContentSize().width / 2,cell_content.height - checkBox:getContentSize().height / 2)
				checkBox:setLocalZOrder(10001)
				checkBox:setSelected(data[i].select == true)
				self.check_box_list[data[i].pet_id] = checkBox
			end
		end
		
		local size = cc.size(self.viewSize.width,height)
		srcoll_view:setContentSize(size)
		srcoll_view:setContentOffset(cc.p(0,self.viewSize.height - (height or 0))) 
		-- srcoll_view:setTouchEnabled(math.ceil((#data / 5)) > 2)
	end
	-- layer.lbl_select:setString(string.format(ex.Tools:getLang(47578),0,self.needCount))
	-- layer.needCount = self.needCount
	-- layer.btn_confirm:registerScriptTapHandler(handler(self,self.selectHeroEnter))
	self:checkSelected()

end

function PetSelectLayer:onClickAdd(tag, pSender)
	local type = self.item_type == nil and 900503 or self.item_type
	ex.Tools:onClickItemSrc(type)
end

function PetSelectLayer:jumpCallback(atom)
	self:closeWindow(nil,self.layer)
end

-- function PetSelectLayer:onGo(tag, pSender)
-- 	if cfg.funcopen["act_limit_gift"].isVisible() then
-- 		ex.JumpManager:jumpByAtom("act_limit_gift")
-- 		self:closeWindow()
-- 	else
-- 		ex.MessageView:add(ex.Tools:getLang(41311))
-- 		return
-- 	end
-- end

-----------------------------------------------------------------------------
function PetSelectCtr:onCreate()
	self:setCCBIPath("ccbi/PetSelectLayer.ccbi")
	self:setIsSingle(false)
end

function PetSelectCtr:getLayerClass()
	return PetSelectLayer
end

function PetSelectCtr:getPetSelectLayer()
	return self.layer
end

function PetSelectCtr:openWindow(data,item_type,max_num,callback,need_add,show_rich)
	if self:isOpened() then
		return
	end
	local sfc = cc.SpriteFrameCache:getInstance()
    -- sfc:addSpriteFrames("ccbi-res/achievement.plist")
    -- sfc:addSpriteFrames("ccbi-res/box-effect.plist")
    sfc:addSpriteFrames("ccbi-res/runes.plist")

	self:loadLayer()
    self:open()
    self.layer.data = data 
    self.layer.max_num = max_num
	self.layer.callback = callback
	self.layer.item_type = item_type
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	self.layer:updateLayer(data,need_add)
	self.layer.rich_text:setVisible(show_rich == true)
    -- self.layer:changePanelWithStatus(true)
	-- self:initData(data)
end

return PetSelectCtr
