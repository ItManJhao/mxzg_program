local InputCodeCtr = class("InputCodeCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local InputCodeLayer = class("InputCodeLayer", require("src.comp.LuaLayerBase"))

function InputCodeLayer:onCreate()
	self:setAutoClose(false)
	self:addBlackBackground()

	self.btn_confirm:setLabelText(ex.Tools:getLang(41026)) -- 兑 换

	self.edit_box = ccui.EditBox:create(cc.size(self.spr_input_bg:getContentSize().width * self.spr_input_bg:getScaleX() - 10,
													 self.spr_input_bg:getContentSize().height * self.spr_input_bg:getScaleY()),
													 "other/spr-null.png", 1)  --输入框尺寸，背景图片
    self.edit_box:setPosition(cc.p(self.spr_input_bg:getPositionX() + 5, self.spr_input_bg:getPositionY()))
    self.edit_box:setAnchorPoint(cc.p(0.5, 0.5))
    self.edit_box:setMaxLength(50)
    self.edit_box:setFontSize(26)
    self.edit_box:setFontColor(cc.WHITE)
    self.edit_box:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND) --输入键盘返回类型，done，send，go等
    self.edit_box:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE) --输入模型，如整数类型，URL，电话号码等，会检测是否符合
    self.edit_box:setPlaceholderFontSize(26)
    self.edit_box:setPlaceHolder(ex.Tools:getLang(41027)) -- 请输入兑换码
    self:addChild(self.edit_box, 9999)
end


-----------------------------------------------------------------------------
function InputCodeCtr:onCreate()
	self:setCCBIPath("ccbi/InputCodeLayer.ccbi")
	self:setIsSingle(false)
end

function InputCodeCtr:getLayerClass()
	return InputCodeLayer
end

function InputCodeCtr:openWindow()
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()

	self.layer.btn_close:registerScriptTapHandler(handler(self,self.closeWindow))
	self.layer.btn_confirm:registerScriptTapHandler(handler(self,self.onConfirm))
end

function InputCodeCtr:onConfirm(tag, pSender)
    local str_cdk = self.layer.edit_box:getText()
    print("str_cdk = "..str_cdk)
    if str_cdk == "" then
    	 ex.MessageView:add(ex.Tools:getLang(41027)) -- 请输入兑换码
    	return
    end

    pSender:setEnabled(false)

    -- 发送兑换协议
    -- local req_code = cpp.ByteArray:create()
    -- req_code:writeInt(ProtocolID.GReqCdk)
    -- req_code:writeString(str_cdk, INPUT_CODE_LENGTH)
	-- cpp.NetManager:instance():sendByteArray(req_code)
	

	local req = Code_pb.GReqCdk()
	req.cdk = str_cdk
	NetManager:sendMessage(ProtocolID.GReqCdk, req)

end

function InputCodeCtr:codeResult()
	if not self:getLayer() then
		return
	end

	self.layer.btn_confirm:setEnabled(true)
	self.layer.edit_box:setText("")

	
end


return InputCodeCtr
