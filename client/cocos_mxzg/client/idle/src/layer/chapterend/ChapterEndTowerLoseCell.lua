local ChapterEndTowerLoseCell = class("ChapterEndTowerLoseCell", require("src.comp.EventLayer"))

function ChapterEndTowerLoseCell:onCreate()
	self:setAutoClose(false)
    self:setSwallowTouches(false)
	self:setPosition(cc.p(0, 0))
end

function ChapterEndTowerLoseCell:reset(data)
	if cfg.funcopen["act_limit_gift"].isVisible() then
		self.btn_limit_gift:setVisible(true)
		self.btn_buy_gift:setVisible(true)
		-- self.lbl_time:setVisible(false)
		return
	end

	self:removeAllChildren()
	-- 用默认的输赢
	local cell = require("src.layer.chapterend.ChapterEndLoseCell"):createWithCCBIFile("ccbi/ChapterEndLoseCell.ccbi")
	cell:setPosition(cc.p(0, 0))
	self:addChild(cell)
	cell:reset(data)
end

function ChapterEndTowerLoseCell:fixHeight()
	return 0
end

function ChapterEndTowerLoseCell:onClose( )
	require("src.layer.chapterend.ChapterEndCtr"):instance():closeWindow()
end

function ChapterEndTowerLoseCell:onStrong(tag, pSender)
	ex.JumpManager:jumpByAtom("main_hero_recommend")
end

function ChapterEndTowerLoseCell:onGift(tag, pSender)
	if cfg.funcopen["act_limit_gift"].isVisible() ~= true then
		ex.MessageView:add(ex.Tools:getLang(47536))
		pSender:setVisible(false)
		return
	end
	ex.JumpManager:jumpByAtom("act_limit_gift")
	require("src.layer.chapterend.ChapterEndCtr"):instance():closeWindow()
end

return ChapterEndTowerLoseCell