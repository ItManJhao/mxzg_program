local ErrorCtr = class("ErrorCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ErrorLayer = class("ErrorLayer", require("src.comp.EventLayer"))

function ErrorLayer:onCreate()
	self:setAutoClose(true)
	self:addBlackBackground()
end

function ErrorLayer:closeWindow()
	ErrorCtr:instance():closeWindow()
end

-----------------------------------------------------------------------------
function ErrorCtr:onCreate()
	self:setCCBIPath("ccbi/ErrorLayer.ccbi")
	self:setIsSingle(false)
end

function ErrorCtr:getLayerClass()
	return ErrorLayer
end

function ErrorCtr:getErrorLayer()
	return self.layer
end

function ErrorCtr:openWindow(error)	
	if self:isOpened() then
		self:updateError(error)
		return
	end

	self:loadLayer()
	self:open()

	self:updateError(error)
end

function ErrorCtr:updateError(error)
	self.layer.scroll_view:getContainer():removeAllChildren()

	local str_error = cc.Label:createWithTTF(error, FONT_DEFAULT_NAME_BOLD, 45)
	str_error:setScale(0.5)
	str_error:setAnchorPoint(ex.a.top_center)
	str_error:setDimensions(ex.p.width / str_error:getScale(), 0)
	str_error:setPosition(ex.p.width * 0.5, 0.5)
	self.layer.scroll_view:getContainer():addChild(str_error)

	local content_size = str_error:getContentSize()
	content_size.width = content_size.width * str_error:getScale()
	content_size.height = content_size.height * str_error:getScale()

	local view_size = self.layer.scroll_view:getViewSize()
	if content_size.height > view_size.height then
		str_error:setPositionY(content_size.height)
		self.layer.scroll_view:setContentSize(cc.size(view_size.width, content_size.height))
		self.layer.scroll_view:setContentOffset(cc.p(0, view_size.height - content_size.height))
	else
		self.layer.scroll_view:setContentSize(view_size)
		str_error:setPositionY(view_size.height)
	end
end

return ErrorCtr
