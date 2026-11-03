local ChampionGuessTipCtr = class("ChampionCrossGuessTipCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ChampionGuessTipLayer = class("ChampionCrossGuessTipLayer", require("src.comp.EventLayer"))

function ChampionGuessTipLayer:onCreate()

	self.close_time = tonumber(ex.Tools:getSysCfg("champion_jump_last")) or 8
	self.close_time = self.close_time + 1

    self:addBlackBackground()
    local win_size = cc.Director:getInstance():getWinSize();
	local width = Maths.min(self:getContentSize().width, win_size.width);
    self:setScale(width / self:getContentSize().width);
    
	local bet_ctr = ChampionGuessTipCtr:instance()
	self.btn_close:registerScriptTapHandler(handler(bet_ctr, bet_ctr.closeWindow))
	
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

	self.lbl_content:setXmlTextLua(ex.Tools:getLang(47641))


	self.scroll_view:setItemSize(cc.size(110, 110))
	self.scroll_view.createItemFunction = function(item_data, scale)
		local item = ex.Tools:createBackpackItem(item_data.item_type, item_data.item_num)
		item:setScale(scale)
		item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
		return item
	end
	-- local reward =
	self.scroll_view:reloadData(ex.Tools:getSysCfg("champion_jump_show"))

	self:addTimer("timer", 1000, handler(self, self.updateTimer), true)

	self:updateTimer()
end

function ChampionGuessTipLayer:updateTimer()
	self.close_time = self.close_time - 1
	self.btn_cancel:setLabelText(string.format(ex.Tools:getLang(70757), self.close_time))
	-- ex.Tools:getSysCfg("")
	if self.close_time <= 0 then
		self:closeWindow()
	end
end

function ChampionGuessTipLayer:closeWindow()
    ChampionGuessTipCtr:instance():closeWindow()
end

function ChampionGuessTipLayer:onJump()
	local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_CHAMPIONCROSS)
	if layer then
		layer.selected_type = 2
		layer:updateLayerType()
		layer:updateTitle()
		self:closeWindow()
	end
end

function ChampionGuessTipLayer:updateLayer()
end

-----------------------------------------------------------------------------
function ChampionGuessTipCtr:onCreate()
	self:setCCBIPath("ccbi/ChampionCrossGuessTipLayer.ccbi")
	self:setIsSingle(false)
end

function ChampionGuessTipCtr:getLayerClass()
	return ChampionGuessTipLayer
end

function ChampionGuessTipCtr:openWindow()
	if self:isOpened() then
		return
	end

	if require("src.scene.MainSceneCtr"):instance():getMainScene() == nil then
		return
	end

	self:loadLayer()
	self:open()
	self:initData()
end

function ChampionGuessTipCtr:initData()
    
end

return ChampionGuessTipCtr
