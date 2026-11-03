local LTADailyRechargeGiftCell = class("LTADailyRechargeGiftCell", require("src.comp.EventLayer"))

function LTADailyRechargeGiftCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
	
end

function LTADailyRechargeGiftCell:initDone(idx, need, desc)
	self.idx = idx
	self.need = need

	local lbl_desc = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(44)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#FFFFFF")
	:setScale(0.5)
	:setWrapMode(1)
	:setPosition(33, self.lbl_completed:getPositionY())
	:setAnchorPoint(ex.a.left_center)
	self:addChild(lbl_desc)

	lbl_desc:setXmlTextLua(desc)

	self.btn_done:setTag(idx)
end

function LTADailyRechargeGiftCell:setState(completed, state)
	self.state = state

	self.lbl_completed:setString(string.format("(%s/%s)", completed / 100, self.need / 100))

	local strText = ""
	if state == 0 then
		strText = ex.Tools:getLang(2707) -- 未开启
	elseif state == 1 then
		strText = ex.Tools:getLang(2702)-- 前往
	elseif state == 2 then
		strText = ex.Tools:getLang(2214) -- 领取
		self:setRedPoint(true)
	elseif state == 3 then
		strText = ex.Tools:getLang(2703) -- 已领取
	end

	local btn_size = self.btn_done:getContentSize()

	local lbl_btn_txt = cc.Label:createWithTTF(strText, FONT_DEFAULT_NAME_BOLD, 20)
	:setPosition(btn_size.width / 2, btn_size.height / 2)
	self.btn_done:addChild(lbl_btn_txt, 10, 10)

	if state == 0 or state == 3 then
		self.btn_done:setNormalImage(cc.Sprite:createWithSpriteFrameName("button/btn-orange-3.png"))
		lbl_btn_txt:enableOutline(FONT_GRAY, 2)
	else
		lbl_btn_txt:enableOutline(FONT_RED, 2)
	end

	self.btn_done:setEnabled(state == 1 or state == 2)
end

function LTADailyRechargeGiftCell:onGain()
	self.btn_done:getChildByTag(10):removeFromParent()
	self.btn_done:setNormalImage(cc.Sprite:createWithSpriteFrameName("button/btn-orange-3.png"))
	self.btn_done:setEnabled(false)

	local btn_size = self.btn_done:getContentSize()

	-- 已领取
	local lbl_btn_txt = cc.Label:createWithTTF(ex.Tools:getLang(2703), FONT_DEFAULT_NAME_BOLD, 20)
	:enableOutline(FONT_GRAY, 2)
	:setPosition(btn_size.width / 2, btn_size.height / 2)
	self.btn_done:addChild(lbl_btn_txt, 10)

	self:setRedPoint(false)

	self.state = 3
end

function LTADailyRechargeGiftCell:setRedPoint(bool)
	ex.Tools:addRedPoint(self.btn_done,bool)
end

return LTADailyRechargeGiftCell