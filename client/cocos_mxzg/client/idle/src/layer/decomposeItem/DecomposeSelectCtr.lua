local DecomposeSelectCtr = class("DecomposeSelectCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local DecomposeSelectLayer = class("DecomposeSelectLayer", require("src.comp.EventLayer"))

local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBag")
local UIMenuItemHeroPiece = require("src.comp.menu.UIMenuItemHeroPiece")

function DecomposeSelectLayer:onCreate()
    self:addBlackBackground()

    self.item_type = 0
    self.select_num = 1
    self.total_num = 0
    self.item_price = nil

    -- self:createEditBox()

    self.node_price:setVisible(false)


    self.lbl_btn_submit = cc.Label:createWithTTF(ex.Tools:getLang(3923), FONT_DEFAULT_NAME_BOLD, 24)
    self.btn_submit:addChild(self.lbl_btn_submit)
    self.lbl_btn_submit:setPosition(self.btn_submit:getContentSize().width * 0.5, self.btn_submit:getContentSize().height * 0.5)
    self.lbl_btn_submit:enableOutline(FONT_BROWN, 1)
    self.btn_submit:registerScriptTapHandler(handler(self, self.onClickSubmit))

	self.btn_sub:registerScriptTapHandler(handler(self, self.onClickSub))
    self.btn_add:registerScriptTapHandler(handler(self, self.onClickAdd))
    self.btn_max:registerScriptTapHandler(handler(self, self.onClickMax))

end

function DecomposeSelectLayer:onClickSubmit(tag,pSender)
    local req = BackPack_pb.GReqDecompositionThing()
    local item = {item_id = self.item_data.item_id,item_type = self.item_data.item_type or 0 , num = self.num}

    -- local data = req.item:add()
    req.item.item_id = tonumber(self.item_data.item_id or 0)
    req.item.item_type = self.item_data.item_type or 0 
    req.item.num = self.num

    NetManager:sendMessage(ProtocolID.GReqDecompositionThing, req) 
    DecomposeSelectCtr:instance():closeWindow()
end

function DecomposeSelectLayer:onClickMax(tag,pSender)

    self.num = self.max
	self.selectCount:setText(self.num)

	self.btn_sub:setEnabled(self.num > 1)
	local max = self.max == 0 and 1 or self.max
    self.btn_add:setEnabled(self.num < max)
    self.btn_max:setEnabled(self.num < max)
    self:updateNum(self.num)
end

function DecomposeSelectLayer:onClickSub(tag,pSender)
	if self.num > 1 then 
		self.num = self.num - 1
	end 
	self.selectCount:setText(self.num)

	self.btn_sub:setEnabled(self.num > 1)
	local max = self.max == 0 and 1 or self.max
    self.btn_add:setEnabled(self.num < max)
    self.btn_max:setEnabled(self.num < self.max)
    self:updateNum(self.num)
end

function DecomposeSelectLayer:onClickAdd(tag,pSender)
	local max = self.max == 0 and 1 or self.max
	if self.num < max then 
		self.num = self.num + 1
	end
	self.selectCount:setText(self.num)

	self.btn_sub:setEnabled(self.num > 1)
    self.btn_add:setEnabled(self.num < max)
    self.btn_max:setEnabled(self.num < max)
    self:updateNum(self.num)
end

function DecomposeSelectLayer:updateNum(num)
    local menu = self.cur_srcoll_view:getContainer():getChildByName("menu")
    local list = menu:getChildren()
    for i,v in ipairs(list) do
        v.lbl_num:setString(num * v.data.item_num)
    end
end

function DecomposeSelectLayer:createEditBox()
    local size =  self.edit_box_bg:getContentSize()
    local x,y = self.edit_box_bg:getPosition()
	self.selectCount = ccui.EditBox:create(size,"other/spr-null.png", 1)
	self.selectCount:setPosition(x + size.width / 2,y + size.height / 2)

	self.selectCount:setAnchorPoint(cc.p(0.5,0.5))
	self.selectCount:setFontName(FONT_DEFAULT_NAME_BOLD)
	self.selectCount:setFontSize(20)
	self.selectCount:setFontColor(cc.WHITE)
	self.selectCount:setPlaceHolder(ex.Tools:getLang(47294))
	self.selectCount:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
	self.selectCount:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC) 
    self.selectCount:registerScriptEditBoxHandler(handler(self,self.editboxHandle))
    self.selectCount:setText(1)
    self:addChild(self.selectCount)
    self.btn_sub:setEnabled(self.num > 1)
    self.btn_add:setEnabled(self.num < self.max)
    self.btn_max:setEnabled(self.num < self.max)
end

function DecomposeSelectLayer:editboxHandle( strEventName,sender )


	if strEventName == "began" then 
		-- sender:selectedAll()
	elseif strEventName == "ended" then 
		local str = sender:getText()
		-- print(type(str), tonumber(str))
		if tonumber(str) ~= nil then 
			self:setEditboxNum(math.max(1, tonumber(string.format("%d", tonumber(str)))))
			self.btn_sub:setEnabled(self.num > 1)
            self.btn_add:setEnabled(self.num < self.max)
            self.btn_max:setEnabled(self.num < self.max)
		else
			sender:setText(1)
			self:setEditboxNum(1)

			ex.MessageView:add(ex.Tools:getLang(47294))
		end

	elseif strEventName == "changed" then

	end
end

function DecomposeSelectLayer:setEditboxNum(num)
	self.num = num
	print("max"..self.num,self.max)

	self.selectCount:setText(math.min( self.num,self.max ))

	self.btn_sub:setEnabled(self.num > 1)
    self.btn_add:setEnabled(self.num < self.max)
    self.btn_max:setEnabled(self.num < self.max)
end

function DecomposeSelectLayer:updateSelectNum()
    self.lbl_select_num:setString(tostring(self.select_num))
    self.lbl_total_num:setString(ex.StringUtil.getScientificNumber(self.select_num * self.item_price.item_num))
end

function DecomposeSelectLayer:updateScrollView( )
    local decompos_cfg = cfg.decompositionitem.decompositionitem[self.item_data.item_type]
    local reward_data = decompos_cfg.reward
    -- local viewSize = self.cur_srcoll_view:getContainer():getContentSize()
    local viewSize = self.cur_srcoll_view:getViewSize()

    local scale = 1
    local height
	self.cur_srcoll_view:getContainer():removeAllChildren()
	local menu = cpp.UIMenu:create()
    :setIsTouchInsideNode(self.cur_srcoll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    :setName("menu")
    self.cur_srcoll_view:getContainer():addChild(menu)
    local cell_content
    for i=1,#reward_data do

        local cell_props = UIMenuItemBackpack:createWithData(reward_data[i].item_type,reward_data[i].item_num)
        cell_props.data = reward_data[i]
        -- cell_props:reset(data[i])
        -- cell_props.battle = true
        -- cell_props.spr_select:setVisible(data.selected)
        cell_content = cell_props:getContentSize()
        menu:add(cell_props)
        cell_props:registerScriptTapHandler(handler(self,self.onClickItem))
        if not height then height = math.ceil((#reward_data / 4)) * (cell_content.height * scale+10) + (10 * scale) end
        
        local idx = (i - 1) % 4
        local posX = (cell_content.width + 16) * scale * (idx) + 6
        local posY = height - (math.ceil(i / 5)) * scale * (cell_content.height + 10)
        cell_props:setAnchorPoint(0,0)
        cell_props:setPosition(posX,posY)
        cell_props:setScale(scale)

        cell_props.index = self.index

    end
    local size = cc.size(viewSize.width,math.ceil((#reward_data / 4)) * ((cell_content.height+10) * scale) + (10 * scale))
    self.cur_srcoll_view:setContentSize(size)
    self.cur_srcoll_view:setContentOffset(cc.p(0,viewSize.height - height)) 
    self.cur_srcoll_view:setContentOffset(cc.p(0, self.cur_srcoll_view:getViewSize().height - self.cur_srcoll_view:getContentSize().height))
    -- self.cur_srcoll_view:setTouchEnabled(math.ceil((#reward_data / 4)) > 2)
end

function DecomposeSelectLayer:onClickItem(tag,pSender)
    ex.Tools:showItemInfo(tag,pSender)
end
-----------------------------------------------------------------------------
function DecomposeSelectCtr:onCreate()
	self:setCCBIPath("ccbi/DecomposeSelectLayer.ccbi")
	self:setIsSingle(false)
end

function DecomposeSelectCtr:getLayerClass()
	return DecomposeSelectLayer
end

function DecomposeSelectCtr:openWindow(item_data)
	if self:isOpened() then
		return
    end

	self:loadLayer()
	self:open()
	self:initData(item_data)
end

function DecomposeSelectCtr:initData(item_data)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    local str = string.format(ex.Tools:getLang(3922),ex.Tools:getLang(cfg.item.item[item_data.item_type].name))
    self.layer.lbl_item_name:setString(str)
    self.layer.num = 1
    self.layer.max = item_data.item_num
    self.layer.item_data = item_data
    self.layer:createEditBox()
    -- item_data.item_num = 1
    -- self.layer.max = 2
    if item_data.item_num > 1 then 
        self.layer.cur_srcoll_view = self.layer.scroll_view_1
    else
        self.layer.cur_srcoll_view = self.layer.scroll_view_2
    end
    self.layer.node_1:setVisible(item_data.item_num > 1)
    self.layer.node_2:setVisible(item_data.item_num == 1)
    self.layer.selectCount:setVisible(item_data.item_num > 1)
    self.layer:updateScrollView()

end

return DecomposeSelectCtr
