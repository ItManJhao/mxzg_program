local ChapterEndCtr = class("ChapterEndCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ChapterEndLayer = class("ChapterEndLayer", require("src.comp.EventLayerAdaptiveWidth"))

local SHOW_TYPE = {
	TOWER_END = 1
}

function ChapterEndLayer:onCreate()
	self:setAutoClose(true)
	self:addBlackBackground()
	-- self:resetScaleAtWidth(true)
	self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)
	self.btn_report:setPositionX(self:getContentSize().width - 70)

	self.time = 5

	self:setExitCallback(handler(self,self.exitCallBack))
	self.scroll_view:setItemSize(cc.size(130, 110))
	self.scroll_view:setAlignmentCenter(true)

	self.menu_main:setLocalZOrder(100)

	ex.Tools:layerEnterAction(self)
end

function ChapterEndLayer:startTimer()
	
	self:addTimer("timer",1000,handler(self, self.changTimer), true)
end

function ChapterEndLayer:changTimer()
	self.time = self.time - 1 

	self.lbl_time:setString(string.format(ex.Tools:getLang(47336),self.time))
	if self.time <= 0 then 
		self:removeTimerByName("timer")
		require("src.layer.chapterend.ChapterEndCtr"):instance():closeWindow()
	end
end

function ChapterEndLayer:exitCallBack()
	self:removeTimerByName("timer")
	if self.callback then
		self.callback(self.is_win, self.idx)
	end
end

function ChapterEndLayer:addBottomTip(str)
	local lbl_active = require("src.comp.RichTextEx"):create()
	lbl_active:setFontSize(20)
	lbl_active:setFontFace(FONT_DEFAULT_NAME_BOLD)
	lbl_active:setAnchorTextShadow(false)
	lbl_active:setWrapMode(1)
	lbl_active:setIgnoreAnchorPointForPosition(false)
	lbl_active:setAnchorPoint(ex.a.center)
	lbl_active:setPosition(self:getContentSize().width / 2, 36)
	lbl_active:setXmlTextLua(str)
	lbl_active:setCallback(function(atom)
		require("src.layer.chapterend.ChapterEndCtr"):instance():closeWindow()
		ex.JumpManager:jumpByAtom(atom)
	end)
	self:addChild(lbl_active)
end


-----------------------------------------------------------------------------
function ChapterEndCtr:onCreate()
	self:setCCBIPath("ccbi/ChapterEndLayer.ccbi")
	self:setIsSingle(false)
end

function ChapterEndCtr:getLayerClass()
	return ChapterEndLayer
end

function ChapterEndCtr:getChapterEndLayer()
	return self.layer
end

function ChapterEndCtr:openWindow(data)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(data)
end

function ChapterEndCtr:openWindowWithTower(data)
	self:openWindow(data)
end


-- data参数 is_win, vec_reward, callback, idx, vec_battle_detail, layer_type
function ChapterEndCtr:initData(data)

	local layer = self.layer
	layer.is_win = data.is_win
	layer.callback = data.callback
	layer.idx = data.idx
	data.vec_reward = data.vec_reward or {}
	self.vec_battle_detail = data.detail
	self.vec_reward = data.vec_reward
	
	--如果没有战报内容隐藏战报按钮 防止报错
	self.layer.btn_report:setVisible(self.vec_battle_detail and true or false)

	self.layer.btn_report:registerScriptTapHandler(handler(self, self.onBattleDetail))

	ex.Tools:setSpriteFrame(layer.spr_wing, string.format("battle-end/spr-wing-%d.png", data.is_win and 1 or 0))
	ex.Tools:setSpriteFrame(layer.spr_result, string.format("battle-end-lang/lbl-result-%d.png", data.is_win and 1 or 0))

	local battle_type = data.battle_type or 0
	local config = cfg.battleendui.battleendui[battle_type]

	if data.is_win then
		local add_height = 0
		-- 胜利特效
		local chibang = sp.SkeletonAnimation:create("spine/chibang.json","spine/chibang.atlas", 1)
        chibang:setAnimation(0, "idle", true);
	    chibang:setPosition(layer.spr_wing:getPositionX(), layer.spr_wing:getPositionY())
		layer:addChild(chibang)
		
		layer.spr_result:setVisible(false)
		layer.spr_wing:setVisible(false)

		if config and config.win_cell ~= "" then
			local cell = require("src.layer." .. config.win_cell):createWithCCBIFile(config.win_ccbi)
			layer:addChild(cell)
			cell:reset(data)

			local height = cell:getContentSize().height
			if cell.fixHeight then
				height = cell:fixHeight(height)
			end

			layer.spr_bg:setContentSize(cc.size(layer.spr_bg:getContentSize().width, layer.spr_bg:getContentSize().height + height))
			layer.btn_report:setPositionY(layer.btn_report:getPositionY() + height)
			chibang:setPositionY(chibang:getPositionY() + height)
			-- if config.win_reward == 1 then
			-- 	cell:setPositionY(230)
			-- end
		end

		if not config or config.win_reward == 1 then
			layer.scroll_view.createItemFunction = function(data, scale)
				local item = ex.Tools:createBackpackItem(data.item_type, data.item_num)
				-- item:setScale(0.6)
				item:registerScriptTapHandler(handler(self, self.onItem))
				return item
			end
			layer.scroll_view:reloadData(data.vec_reward)
		end
	else
		-- 输了
		if config and config.lose_cell ~= "" then
			local cell = require("src.layer." .. config.lose_cell):createWithCCBIFile(config.lose_ccbi)
			layer:addChild(cell)
			cell:reset(data)

			local height = cell:getContentSize().height
			if cell.fixHeight then
				height = cell:fixHeight()
			end
			layer.spr_bg:setContentSize(cc.size(layer.spr_bg:getContentSize().width, layer.spr_bg:getContentSize().height + height))

			if config.lose_reward == 1 then
				cell:setPositionY(230)
			end
		else
			-- 用默认的输赢
			local cell = require("src.layer.chapterend.ChapterEndLoseCell"):createWithCCBIFile("ccbi/ChapterEndLoseCell.ccbi")
			cell:setPosition(cc.p(0, 0))
			layer:addChild(cell)
			cell:reset(data)
		end

		if not config or config.lose_reward == 1 then
			layer.scroll_view.createItemFunction = function(data, scale)
				local item = ex.Tools:createBackpackItem(data.item_type, data.item_num)
				item:registerScriptTapHandler(handler(self, self.onItem))
				ex.Tools:itemEnterAction(item)
				return item
			end
			layer.scroll_view:reloadData(data.vec_reward)
		end
	end
	ex.AudioManager:playEffect(string.format("music/battle-end-%d.mp3", data.is_win and 1 or 0))
end

function ChapterEndCtr:onItem(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function ChapterEndCtr:onConfirm(tag, pSender)
	local layer = self.layer
	
	if layer.callback then
		layer.callback(layer.is_win, layer.idx)
	end
	
	self:closeWindow(tag, pSender)
end

function ChapterEndCtr:onBattleDetail(tag, pSender)
	require("src.layer.BattleDetailCtr"):instance():openWindow(self.vec_battle_detail)
end

function ChapterEndCtr:addBottomTip(tip)
	if not self:isOpened() then
		return
	end

	self.layer:addBottomTip(tip)
end

return ChapterEndCtr
