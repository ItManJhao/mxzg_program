local CountryWarTipsCtr = class("CountryWarTipsCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local CountryWarTipsLayer = class("CountryWarTipsLayer", require("src.layer.ui.UI_CountryWarTipsLayer"))
function CountryWarTipsLayer:onCreate()
	self.super.onCreate(self)
	self:setName("CountryWarTipsLayer")

	self:removeChildByName("layer_background_black")
	local info_ctr = CountryWarTipsCtr:instance()
	local win_size = cc.Director:getInstance():getWinSize();
	local height = Maths.min(self:getContentSize().height, win_size.height);
	self:setScale(height / self:getContentSize().height);
	self.btn_close:registerScriptTapHandler(handler(info_ctr, info_ctr.closeWindow))
	self.btn_close:setEnableAction(false)

	local content_size = self:getContentSize()
	self.viewSize = cc.size(content_size.width - 50, content_size.height - 220)

	self.scroll_view = cc.ScrollView:create(self.viewSize)
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    :setPosition(28, 105)
    self:addChild(self.scroll_view)

	-- self.scrollBg:setContentSize(self.viewSize.width + 10, self.viewSize.height + 10)
	-- self.lbl_stage:setPosition(self.scrollBg:getPositionX(), self.scrollBg:getPositionY() - self.scrollBg:getContentSize().height - 30)

	self.lbl_content = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(36)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#FFC674")
	:setScale(0.5)
	:setAnchorTextShadow(true)
	:ignoreContentAdaptWithSize(false)
	:setWrapMode(1)
	:setContentSize(cc.size(self.viewSize.width  / 0.5, self.viewSize.height / 0.5))
	:setPosition(cc.p(self.viewSize.width * 0.5, self.viewSize.height))
	:setAnchorPoint(ex.a.top_center)
	self.scroll_view:addChild(self.lbl_content)
end

-----------------------------------------------------------------------------
function CountryWarTipsCtr:loadLayer()
	local tmp_layer = CountryWarTipsLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function CountryWarTipsCtr:onCreate()
	self:setIsSingle(false)
end

function CountryWarTipsCtr:openWindow(str_title, str_content, stage_lbl)
	if self:isOpened() then
		return
	end
	
	self:loadLayer()
	self:open()
	self:initData(str_title, str_content, stage_lbl)
end

function CountryWarTipsCtr:initData(str_title, str_content, stage_lbl)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    
	self.layer.lbl_title:setString(str_title)
	self.layer.lbl_content:setXmlTextLua(str_content)
	self.layer.lbl_content:formatText()
	self.layer.lbl_stage:setString(stage_lbl)
	self.layer.lbl_stage:setDimensions(300, 0)
	self.layer.spr_tips_bg:setContentSize(self.layer.lbl_stage:getContentSize().width, self.layer.spr_tips_bg:getContentSize().height)
	--ex.log("str_content: ".. str_content)

	local contentSize = self.layer.lbl_content:getContentSize()
	contentSize.width = contentSize.width * self.layer.lbl_content:getScale()
	contentSize.height = contentSize.height * self.layer.lbl_content:getScale()

	--ex.log("contentSize.height = "..contentSize.height)

	if contentSize.height > self.layer.viewSize.height then
		self.layer.lbl_content:setPositionY(contentSize.height)
		self.layer.scroll_view:setContentSize(cc.size(self.layer.viewSize.width, contentSize.height))
		self.layer.scroll_view:setContentOffset(cc.p(0, -contentSize.height + self.layer.viewSize.height))
	else
		self.layer.scroll_view:setContentSize(self.layer.viewSize)
	end

end


return CountryWarTipsCtr
