local ChapterEndTowerWinCell = class("ChapterEndTowerWinCell", require("src.comp.EventLayer"))

function ChapterEndTowerWinCell:onCreate()
	self:setAutoClose(false)
    self:setSwallowTouches(false)
	self:setPosition(cc.p(0, 0))
end

function ChapterEndTowerWinCell:reset(data)

	if cfg.towerreward.towerreward[data.stage] == nil then
		self:removeAllChildren()
		return
	end
	self.data = data

	local str_tip = ex.Tools:getLang(cfg.towerreward.towerreward[data.stage - 1].settle_tips)
    self.lbl_battle_time:setString(ex.Tools:getLang(47155)..ex.StringUtil.convertToTimeFormat(math.floor(data.detail.battle_duration / 1000), 5))

	-- self.btn_next_stage:registerScriptTapHandler(data.callback)
	-- self.btn_next_stage_done:registerScriptTapHandler(handler(self, self.closeWindow))

	local lbl_tip = require("src.comp.RichTextEx"):create()
	:setFontSize(48)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
    -- :setFontColor("#613C19")
	:setFontColor("#FFFFFF")
    :setScale(0.5)
    :setAnchorPoint(0.5, 1)
	:setAnchorTextShadow(true)
	-- :ignoreContentAdaptWithSize(false)
	:setWrapMode(1)

	lbl_tip:setXmlTextLua(str_tip)
	lbl_tip:formatText()

	lbl_tip:setPosition(self:getContentSize().width / 2, 120)
	
	self.node_tower_next_stage:addChild(lbl_tip, 10001)
end

function ChapterEndTowerWinCell:fixHeight()
	return 0
end

function ChapterEndTowerWinCell:onClose( )
	require("src.layer.chapterend.ChapterEndCtr"):instance():closeWindow()
end

function ChapterEndTowerWinCell:onNext()
	if not self.data then
		require("src.layer.chapterend.ChapterEndCtr"):instance():closeWindow()
		return
	end

	local req_battle = Tower_pb.GReqTowerBattle()
	req_battle.stage = self.data.stage
	NetManager:sendMessage(ProtocolID.GReqTowerBattle, req_battle)

	require("src.layer.chapterend.ChapterEndCtr"):instance():closeWindow()

end

return ChapterEndTowerWinCell