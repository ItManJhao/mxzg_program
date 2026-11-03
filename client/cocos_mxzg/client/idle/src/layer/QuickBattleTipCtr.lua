local QuickBattleTipCtr = class("QuickBattleTipCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local QuickBattleTipLayer = class("QuickBattleTipLayer", require("src.comp.LuaLayerBase"))

function QuickBattleTipLayer:onCreate()
	print("ConfirmLayer:onCreate")
	self:addBlackBackground()
	self:setLocalZOrder(100)

	self.lbl_content = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(44)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
    :setFontColor("#551E14")
	:setScale(0.5)
	:setAnchorTextShadow(true)
	:setAnchorPoint(cc.p(0, 1))
	:ignoreContentAdaptWithSize(false)
	:setWrapMode(1)
	:setContentSize(720, 0)
	:setPosition(0, 0)
	self.scroll_view:addChild(self.lbl_content)
end

function QuickBattleTipLayer:setContent(str_content)
	self.lbl_content:setXmlTextLua(str_content)
	self.lbl_content:formatText()

	local height = self.lbl_content:getContentSize().height * self.lbl_content:getScaleY()

	if height > self.scroll_view:getViewSize().height then
		self.lbl_content:setPositionY(height)
	
		self.scroll_view:setContentSize(cc.size(self.scroll_view:getViewSize().width, height))
		self.scroll_view:setContentOffset(cc.p(0, -height + self.scroll_view:getViewSize().height))
	else
		self.lbl_content:setPositionY(self.scroll_view:getViewSize().height)
	
		self.scroll_view:setContentSize(self.scroll_view:getViewSize())
		self.scroll_view:setContentOffset(cc.p(0, 0))
	end
end

-----------------------------------------------------------------------------
function QuickBattleTipCtr:onCreate()
	self:setCCBIPath("ccbi/QuickBattleTipLayer.ccbi")
	self:setIsSingle(false)
end

function QuickBattleTipCtr:getLayerClass()
	return QuickBattleTipLayer
end

function QuickBattleTipCtr:getQuickBattleTipLayer()
	return self.layer
end

function QuickBattleTipCtr:openWindow(str_content, callback)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(str_content, callback)
end

function QuickBattleTipCtr:initData(str_content, callback)
	self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))
	self.layer.btn_cancel:registerScriptTapHandler(handler(self, self.onCancel))
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

	self.layer:setContent(str_content)
	self.layer.callback = callback
end

function QuickBattleTipCtr:onConfirm(tag, pSender)
	if self:getLayer() == nil then
		return
	end

	if self.layer.callback then
		self.layer.callback(tag, pSender)
	end

	self:closeWindow(tag, pSender)
end

function QuickBattleTipCtr:onCancel(tag, pSender)
	self:closeWindow(tag, pSender)
end

return QuickBattleTipCtr
