local TotemResetReViewCtr = class("TotemResetReViewCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local TotemResetReViewLayer = class("TotemResetReViewLayer", require("src.comp.EventLayerAdaptiveWidth"))
local UIMenuItemBag = require("src.comp.menu.UIMenuItemBag")

--------------------------------------------

function TotemResetReViewLayer:onCreate()
	self.viewSize = self.scroll_view:getViewSize()
	self:addBlackBackground()
	self:registerBtnEvent()
end

function TotemResetReViewLayer:registerBtnEvent( )
	self.btn_reset:registerScriptTapHandler(handler(self, self.onCommit))
	
    local lbl_btn_reset = cc.Label:createWithTTF(ex.Tools:getLang(76816), FONT_DEFAULT_NAME_BOLD, 24)
    lbl_btn_reset:setAnchorPoint(cc.p(0.5, 0.5))
    lbl_btn_reset:setTextColor(cc.c3b(255,255,255))
    lbl_btn_reset:enableOutline(cc.c3b(131,43,22),2)
    self.btn_reset:addChild(lbl_btn_reset)
	lbl_btn_reset:setPosition(self.btn_reset:getContentSize().width / 2,self.btn_reset:getContentSize().height / 2)
	
    local lbl_btn_cannel = cc.Label:createWithTTF(ex.Tools:getLang(76815), FONT_DEFAULT_NAME_BOLD, 24)
    lbl_btn_cannel:setAnchorPoint(cc.p(0.5, 0.5))
    lbl_btn_cannel:setTextColor(cc.c3b(255,255,255))
    lbl_btn_cannel:enableOutline(cc.c3b(13,91,45),2)
    self.btn_cannel:addChild(lbl_btn_cannel)
    lbl_btn_cannel:setPosition(self.btn_cannel:getContentSize().width / 2,self.btn_cannel:getContentSize().height / 2)
end

function TotemResetReViewLayer:onCommit(tag,pSender)
	if self.callback then 
        self.callback(self.selected_data)
	end
	TotemResetReViewCtr:instance():closeWindow()
end

function TotemResetReViewLayer:updateLayer(data)
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
	if #data > 0 then 

		local save_cell_props = cc.Sprite:createWithSpriteFrameName("other/rare-0.png"):getContentSize()
		local is_first = false
		local cell_content = save_cell_props
		local nums  = #data
		
		for i=1,#data do

            local item = UIMenuItemBag:createWithData(data[i].item_type,data[i].item_num)
            -- self.item_type = data[i].sys_id
            item:setLevel(data[i].level)
            if not height then height = math.ceil((#data / 4)) * (save_cell_props.height * scale+10) + (10 * scale) end
            local idx = (i - 1) % 4
            local posX = (save_cell_props.width + 12) * scale * (idx) + 14
            local posY = height - (math.ceil(i / 4)) * scale * (save_cell_props.height + 10)
            item:setAnchorPoint(0,0)
            item:setPosition(posX,posY)
            item:setScale(scale)
            menu:add(item)
            item.data = data[i]
			item:registerScriptTapHandler(handler(self, self.onClickSrc))

            cell_content = item:getContentSize()
		end
		
		local size = cc.size(self.viewSize.width,math.ceil((nums / 4)) * ((cell_content.height+10) * scale) + (10 * scale))
		srcoll_view:setContentSize(size)
		srcoll_view:setContentOffset(cc.p(0,self.viewSize.height - (height or 0))) 
	end
end

function TotemResetReViewLayer:onClickSrc(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

function TotemResetReViewLayer:jumpCallback(atom)
	self:closeWindow(nil,self.layer)
end

-----------------------------------------------------------------------------
function TotemResetReViewCtr:onCreate()
	self:setCCBIPath("ccbi/TotemResetReViewLayer.ccbi")
	self:setIsSingle(false)
end

function TotemResetReViewCtr:getLayerClass()
	return TotemResetReViewLayer
end

function TotemResetReViewCtr:getTotemResetReViewLayer()
	return self.layer
end

function TotemResetReViewCtr:openWindow(data,callback)
	if self:isOpened() then
		return
	end
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/runes.plist")

	self:loadLayer()
    self:open()
    self.layer.data = data 
	self.layer.callback = callback
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	self.layer.btn_cannel:registerScriptTapHandler(handler(self, self.closeWindow))
	self.layer:updateLayer(data)
end

return TotemResetReViewCtr
