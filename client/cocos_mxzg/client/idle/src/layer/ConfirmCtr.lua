local ConfirmCtr = class("ConfirmCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ConfirmLayer = class("ConfirmLayer", require("src.comp.EventLayerAdaptiveWidth"))

function ConfirmLayer:onCreate()
	print("ConfirmLayer:onCreate")
	self:addBlackBackground()
	self:setLocalZOrder(100)
	-- self:setAutoClose(false)
	--self.lbl_title:enableShadow()

	-- self.btn_confirm:setLabelText(ex.Tools:getLang(11)) -- 确定
	-- self.btn_cancel:setLabelText(ex.Tools:getLang(12)) -- 取消

	self.lbl_content = require("src.comp.RichTextEx"):create()
	:setFontSize(24)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#551E14")
	:setPosition(cc.p(293, 230))
	:setAnchorPoint(ex.a.top_center)
	self:addChild(self.lbl_content)

	self.btn_confirm:setLabelText(ex.Tools:getLang(47589)) -- 确定
	self.btn_cancel:setLabelText(ex.Tools:getLang(47703)) -- 取消

	self.btn_confirm:setLabelColor(FONT_BLACK)
	self.btn_cancel:setLabelColor(cc.WHITE)

    local confirm_ctr = ConfirmCtr:instance()

	self.btn_confirm:registerScriptTapHandler(handler(confirm_ctr, confirm_ctr.onConfirm))
	self.btn_cancel:registerScriptTapHandler(handler(confirm_ctr, confirm_ctr.onCancel))
	-- self.btn_close:registerScriptTapHandler(handler(confirm_ctr, confirm_ctr.closeWindow))
end


-----------------------------------------------------------------------------
function ConfirmCtr:onCreate()
	self:setCCBIPath("ccbi/ConfirmLayer.ccbi")
	self:setIsSingle(false)
end

function ConfirmCtr:getLayerClass()
	return ConfirmLayer
end

function ConfirmCtr:getConfirmLayer()
	return self.layer
end

function ConfirmCtr:openWindow(title, content, callback_confirm,confirm_str,cancel_str, show_cancel, auto_close, callback_cancel, has_url)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(title, content, callback_confirm,confirm_str,cancel_str, show_cancel, auto_close, callback_cancel, has_url)
end

function ConfirmCtr:initData(title,content,callback_confirm,confirm_str,cancel_str, show_cancel, auto_close, callback_cancel, has_url)
	self.layer.lbl_title:setString(title)
	-- self.layer.lbl_content:setString(content)
	self.layer.lbl_content:setXmlTextLua(content)
	self.layer.lbl_content:formatText()

	if self.layer.lbl_content:getContentSize().width > 400 then
		self.layer.lbl_content:ignoreContentAdaptWithSize(false)
		:setWrapMode(1)
		:setContentSize(cc.size(400, 0))
	end
	
	self.layer.callback_confirm = callback_confirm
	self.layer.callback_cancel = callback_cancel

	if title == nil or title == "" then
		self.layer.lbl_title:setVisible(false)
	end

	if title == nil or title == "" then
		self.layer.spr_title_bg:setVisible(false)
	end

	self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))
	self.layer.btn_cancel:registerScriptTapHandler(handler(self, self.onCancel))
	
	--self.layer.btn_confirm:registerScriptTapHandler()
	if confirm_str then 
		self.layer.btn_confirm:setLabelText(confirm_str) -- 确定
	end

	if cancel_str then 
		self.layer.btn_cancel:setLabelText(cancel_str) -- 取消
	end

	if show_cancel == false then
		self.layer.btn_cancel:setVisible(false)
		self.layer.btn_confirm:setPositionX(self.layer:getContentSize().width * 0.5)
	end
	
	if auto_close ~= nil then
		self.layer:setAutoClose(auto_close)
	end

	if has_url then
		self.layer.lbl_content:setCallback(handler(self, self.openRichTextUrl))
	end
end

function ConfirmCtr:openRichTextUrl(url)
   local open, layer = ex.JumpManager:jumpByAtom(url)
    if not open then
        return
    end

    self:closeWindow()
end


function ConfirmCtr:onConfirm(tag, pSender)
	if self:getLayer() == nil then
		return
	end

	if self.layer.callback_confirm then
		self.layer.callback_confirm(tag, pSender)
	end

	self:closeWindow(tag, pSender)
end

function ConfirmCtr:onCancel(tag, pSender)

	if self.layer.callback_cancel then
		self.layer.callback_cancel(tag, pSender)
	end

	self:closeWindow(tag, pSender)
end


return ConfirmCtr
