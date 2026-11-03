local BetTipCtr = class("BetTipCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local BetTipLayer = class("BetTipLayer", require("src.comp.EventLayer"))

function BetTipLayer:onCreate()
	self:addBlackBackground()
	
    local win_size = cc.Director:getInstance():getWinSize();
	local width = Maths.min(self:getContentSize().width, win_size.width);
    self:setScale(width / self:getContentSize().width);
    
	self.scroll_view:setItemSize(cc.size(110, 110))

	self.lbl_content = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(22)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#5A3509")
	:ignoreContentAdaptWithSize(false)
	:setWrapMode(1)
	:setContentSize(cc.size(450, 150))
	:setPosition(cc.p(275, 320))
	:setAnchorPoint(ex.a.top_center)
	self:addChild(self.lbl_content)
end

function BetTipLayer:updateLayer()
end

-----------------------------------------------------------------------------
function BetTipCtr:onCreate()
	self:setCCBIPath("ccbi/BetTipLayer.ccbi")
	self:setIsSingle(false)
end

function BetTipCtr:getLayerClass()
	return BetTipLayer
end

function BetTipCtr:openWindow(vec_reward, str_content, close_time, callback_jump)
	if self:isOpened() then
		return
	end

	if require("src.scene.MainSceneCtr"):instance():getMainScene() == nil then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(vec_reward, str_content, close_time, callback_jump)
end

function BetTipCtr:initData(vec_reward, str_content, close_time, callback_jump)
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	self.layer.btn_cancel:registerScriptTapHandler(handler(self, self.closeWindow))
	self.layer.btn_jump:registerScriptTapHandler(handler(self, self.onJump))

	self.callback_jump = callback_jump
    
	self.layer.scroll_view.createItemFunction = function(item_data, scale)
		local item = ex.Tools:createBackpackItem(item_data.item_type, item_data.item_num)
		item:setScale(scale)
		item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
		return item
	end
	
	self.layer.scroll_view:reloadData(vec_reward)
	
	self.close_time = close_time or 8
	self.close_time = self.close_time + 1

	self.layer.lbl_content:setXmlTextLua(str_content or "")
	self.layer.lbl_content:formatText()

	self.layer:addTimer("timer", 1000, handler(self, self.updateTimer), true)

	self:updateTimer()
end

function BetTipCtr:updateTimer()
	self.close_time = self.close_time - 1
	self.layer.btn_cancel:setLabelText(string.format(ex.Tools:getLang(70757), self.close_time))
	-- ex.Tools:getSysCfg("")
	if self.close_time <= 0 then
		self:closeWindow()
	end
end

function BetTipCtr:onJump()
	if self.callback_jump then
		if self.callback_jump() then
			self:closeWindow()
		end
	end
end

return BetTipCtr
