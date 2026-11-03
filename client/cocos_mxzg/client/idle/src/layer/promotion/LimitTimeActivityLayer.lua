local LimitTimeActivityLayer = class("LimitTimeActivityLayer", require("src.comp.EventLayer"))
local LimitTimeActivityCell = require("src.layer.promotion.LimitTimeActivityCell")

-------------------------------------LimitTimeActivityLayer----------------------------------------------------
-- 界面说明
-- LimitTimeActivityLayer会根据promotionpage表生成对应的按钮，点击后。会根据promotionpage.layer.寻找对应的文件，并生成对应的layer 添加到自身
function LimitTimeActivityLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

	local win_size = cc.Director:getInstance():getWinSize()
	self.spr_bg:setScaleX(win_size.width / self.spr_bg:getContentSize().width)
	self.spr_bg:setScaleY(win_size.height / self.spr_bg:getContentSize().height)

	self.menu = require("src.comp.menu.UIMenuGeneral"):create()
	self.menu:setPosition(cc.p(0, 0))
	self.menu:setSwallowsTouches(false)
	self.menu:setTouchCallback(handler(self, self.onSelect))
	self.scroll_view:getContainer():addChild(self.menu)

    self.btn_back:setPosition(self:getContentSize().width / 2 + ex.p.width / 2 / self:getScaleX() - 20 / self:getScaleX() - 60,
                              self:getContentSize().height / 2 + ex.p.height / 2 / self:getScaleY() - 100 / self:getScaleY() - 42 - require("src.model.Game"):instance():getNotchHeight())
							  
	-- self.btn_back:setPosition(110, self:getBottomY());
	self.btn_back:registerScriptTapHandler(handler(self, self.onBack))
	self.btn_back:getParent():setLocalZOrder(100)

	self.vec_reddot = {}
	-- self:addEvent(EVENT.MAIN_CITY_PROMOTION.DAILY_INIT, handler(self, self.initWithTable))
end

function LimitTimeActivityLayer:onExit()
	-- 移除红点节点
	local reddot_manager = ex.RedDotManager
	for k,v in pairs(self.vec_reddot) do
		 reddot_manager:removeStickNode(k, v)
	end
end


function LimitTimeActivityLayer:initWithTable(event, vec_idx, select_index, tab)
	self:removeRedDotNodeExit()
	
	select_index = select_index or 0
	local select_cell = nil
	
	--
	tab = tab or {}
	local sfc = cc.SpriteFrameCache:getInstance()
	local view_size = self.scroll_view:getViewSize()
	local cell_size = tab.cell_size or LimitTimeActivityCell:createWithCCBIFile("ccbi/LimitTimeActivityCell.ccbi"):getContentSize()

	self.vec_reddot = {}
	self.menu:removeAllChildren()
	self.idx = nil

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/promotion-tab-icon-2.plist")
	sfc:addSpriteFrames("ccbi-res/promotion-2.plist")
	sfc:addSpriteFrames("ccbi-res/promotion.plist")

	local margin = tab.margin or 10
	-- 创建顶层按钮
	local index = 0
	local have_panel = false
	local cell_1 = nil
	local selecte_idx = 0
	for i,v in ipairs(vec_idx) do
		local config = cfg.promotionpage.promotionpage[v.idx]
		if config then
			
			local isShow = false
			if v.checkopen == "" then
				isShow = true
			elseif self[v.checkopen] then 
				isShow = self[v.checkopen]()
			end 

			if ex.Player.level < v.checkLevelOpen then 
				isShow = false
			end 
			
			if isShow then 
				local cell = LimitTimeActivityCell:createWithCCBIFile("ccbi/LimitTimeActivityCell.ccbi")
				cell.idx = config.idx
				cell:setContentSize(cell_size)
				cell:setPosition(margin + index * cell_size.width, view_size.height * 0.5 - cell_size.height * 0.5)
				self.menu:addChild(cell)

				-- 设置cell
				ex.Tools:setSpriteFrame(cell.spr_icon1, string.format("promotion/icon-%d-1.png", v.icon))
				ex.Tools:setSpriteFrame(cell.spr_icon2, string.format("promotion/icon-%d-2.png", v.icon))

				-- local frame = sfc:getSpriteFrame(string.format("promotion/icon-%d-1.png", v.icon))
				-- cell.spr_icon1:setSpriteFrame(frame)
				-- frame = sfc:getSpriteFrame(string.format("promotion/icon-%d-2.png", v.icon))
				-- cell.spr_icon2:setSpriteFrame(frame)

				cell.spr_icon1:setPositionX(cell_size.width * 0.5)
				cell.spr_icon2:setPositionX(cell_size.width * 0.5)

				-- 设置红点节点
				if v.checkreddot ~= "" and self[v.checkreddot] then
					local bool = self[v.checkreddot]()
					local reddot = tonumber(v.reddot)
					self.vec_reddot[reddot] = cell
					ex.RedDotManager:setStickNode(reddot, cell)
				end

				-- 选中界面
				if select_index == 0 and select_cell == nil then
					select_cell = cell
					selecte_idx = 0
				elseif select_index == config.idx then
					select_cell = cell
					selecte_idx = index
				end

				if index == 0 then
					cell_1 = cell
				end

				index = index + 1
				have_panel = true
			end 
		end
	end
	if select_cell == nil then select_cell = cell_1 end

	local main_ctr = ex.MainSceneCtr
	local win_size = cc.Director:getInstance():getWinSize()
	local notch_height = require("src.model.Game"):instance():getNotchHeight()
	local height_diff = main_ctr:getBottomHeight() - main_ctr:getMenuScaleHeight();
    local top_height = win_size.height - (height_diff + 70) - 22 - notch_height;
    local view_size = cc.size(win_size.width, cell_size.height)
	self.scroll_view:setViewSize(view_size)
	self.scroll_view:setPosition(win_size.width * 0.5 - view_size.width * 0.5, top_height - self.scroll_view:getViewSize().height - 50)
	if tab.is_bounceable ~= nil then
		self.scroll_view:setBounceable(tab.is_bounceable)
	else
		self.scroll_view:setBounceable(true)
	end
	-- self.scroll_view:setBounceable(tab.is_bounceable ~= nil and tab.is_bounceable or true)

	-- 设置列表宽度
	local width = index * cell_size.width + margin * 2
    width = math.max(width , self.scroll_view:getViewSize().width)
    self.scroll_view:setContentSize(cc.size(width, cell_size.height))
    self.scroll_view:setContentOffset(cc.p(math.max(0 - (selecte_idx * cell_size.width), view_size.width - width), 0))
	
    -- 选中界面
	self:onSelect(select_cell:getTag(), select_cell)
end

function LimitTimeActivityLayer:updateLayer()
	local color1 = FONT_BLACK
	local color2 = FONT_RED
	self.btn_recharge:setLabelColor(color1)
	self.btn_vip:setLabelColor(color1)
	self.btn_gem_fund:setLabelColor(color1)
	self.btn_limit:setLabelColor(color1)

	if self.cur_layer then
		self.cur_layer:removeFromParent()
		self.cur_layer = nil
	end
end

function LimitTimeActivityLayer:getTopY()
	return self.scroll_view:getPositionY()
end

function LimitTimeActivityLayer:getBottomY()
	return ex.MainSceneCtr:getBottomHeight() + 10
end

function LimitTimeActivityLayer:setBackCallback(callback)
	self.callback_back = callback
end

function LimitTimeActivityLayer:onSelect(tag, pSender)
	-- 可能是一个空的列表
	ex.AudioManager:playEffect("music/button-click.mp3")
	
	-- 相同界面不创建
	if self.idx == pSender.idx then
		return
	end
	self.idx = pSender.idx

	if self.cur_layer ~= nil then
		self.cur_layer:removeFromParent()
		self.cur_layer = nil
	end

	ex.Player.promotion_data:saveSelectTimeLimitType(pSender.idx)
	-- 创建对应的界面
	local config = cfg.promotionpage.promotionpage[pSender.idx]
	if config.layer == "" then
		print("LimitTimeActivityLayer:onSelect.layer = NULL")
		return
	end
	self.menu:unselectAll()
	pSender:setSelected(true)

	--self:clickHideRedDot(pSender.idx)

	
	-- 生成layer
	local layer = require("src.layer." .. config.layer):createWithCCBIFile("ccbi/".. ex.StringUtil.segment(config.layer, ".", true) ..".ccbi")
	self:addChild(layer)

	self.cur_layer = layer
	layer.layer_promotion = self;

	if layer.onCreateDone then
		layer:onCreateDone()
	end
end

function LimitTimeActivityLayer:onBack(tag, pSender)
	if self.callback_back then
		self.callback_back()
	else
		if not ex.MainSceneCtr:backLastLayer() then
			ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
		end
	end
end

function LimitTimeActivityLayer:clickHideRedDot(idx)
	-- 移除红点节点
	local reddot_manager = ex.RedDotManager
	for k,v in pairs(self.vec_reddot) do
		reddot_manager:setSpecialVisible(k, v.idx ~= idx)
	end
end

function LimitTimeActivityLayer:changeToRechargePage()
	local vec_idx = ex.Player.promotion_data:getPromotionByType(RechargeKindType.RECHARGE)
    local tab = {}
    tab.cell_size = cc.size(200, 120.0)
    tab.view_size = cc.size(tab.cell_size.width * table.nums(vec_idx), tab.cell_size.height)
    tab.is_bounceable = false
    tab.margin = -10

	self:initWithTable(nil, vec_idx, 2, tab)
end


--------------------红点检测-------------------------------
function LimitTimeActivityLayer:checkAdventureRedDot()
	-- 试炼之路 红点
	ex.Player.promotion_data:checkAdventureRedDot()
	return true
end
function LimitTimeActivityLayer:checkSpeedFightRedDot()
	-- 快速战斗 红点
	ex.Player.promotion_data:checkSpeedFightRedDot()
	return true
end

function LimitTimeActivityLayer:checkTavernWeeklyRedDot()
	-- 酒馆垃圾 红点
	ex.Player.promotion_data:checkTavernWeeklyRedDot()
	return true
end




function LimitTimeActivityLayer:checkLevelUpAwardRedDot()
	-- 等级升级 红点
	ex.Player.promotion_data:checkLevelUpAwardRedDot()
	return true
end

function LimitTimeActivityLayer:checkBuyGoldRedDot()
	-- 点金 红点
	ex.Player.promotion_data:checkBuyGoldRedDot()
	return true
end
function LimitTimeActivityLayer:checkProphecytimesRedDot()
	-- 先知 红点
	ex.Player.promotion_data:checkProphecytimesRedDot()
	return true
end
function LimitTimeActivityLayer:checkPvpwinsRedDot()
	-- 竞技者 红点
	ex.Player.promotion_data:checkPvpwinsRedDot()
	return true
end
function LimitTimeActivityLayer:checkSummontimesRedDot()
	-- 召唤 红点
	ex.Player.promotion_data:checkSummontimesRedDot()
	return true
end

function LimitTimeActivityLayer:checkRechargeAwardRedDot()
	-- 召唤 红点
	ex.Player.promotion_data:checkRechargeAwardRedDot()
	return true
end


function LimitTimeActivityLayer:checkExchangeRedDot()
	-- 累冲
	ex.Player.promotion_data:checkExchangeRedDot()
	return true
end

function LimitTimeActivityLayer:checkLTADailyRechargeGiftRedDot()
	-- 每日
	--ex.Player.promotion_data:checkLTADailyRechargeGiftRedDot()
	return true
end

function LimitTimeActivityLayer:checkEveryDayLoginRedDot()
	return ex.Player.promotion_data:checkEveryDayLoginRedDot()
end


function LimitTimeActivityLayer:checkBlessingPoolRedDot()
	-- 许愿池达标
	ex.Player.promotion_data:checkBlessingPoolRedDot()
	return true
end


function LimitTimeActivityLayer:checkMakeHeroRedDot()
	ex.Player.promotion_data:checkMakeHeroRedDot()
	return true
end

function LimitTimeActivityLayer:checkSummonCrystalRedDot()
	-- 许愿池达标
	ex.Player.promotion_data:checkSummonCrystalRedDot()
	return true
end

function LimitTimeActivityLayer:checkPubArriveRedDot()
	-- 许愿池达标
	ex.Player.promotion_data:checkPubArriveRedDot()
	return true
end

function LimitTimeActivityLayer:checkAdvNoteRedDot()
	ex.Player.promotion_data:checkAdvNoteRedDot()
	return true
end

function LimitTimeActivityLayer:checkMysteryBoxRedDot( )
	ex.Player.promotion_data:checkMysteryBoxRedDot()
	return true
end

function LimitTimeActivityLayer:checkLoginGiftRedDot( )
	ex.Player.promotion_data:checkLoginGiftRedDot()
	return true
end

function LimitTimeActivityLayer:checkWeedendGiftRedDot()
	ex.Player.promotion_data:WeedendGiftIsRedDot()
	return true
end

--------------------是否开启检测-------------------------------
function LimitTimeActivityLayer:checkOverValueIsOpen()
	return ex.Player.promotion_data:checkOverValueIsOpen()
end

function LimitTimeActivityLayer:checkDailyRechargeGiftIsOpen()
	return ex.Player.promotion_data:checkDailyRechargeGiftIsOpen()
end



function LimitTimeActivityLayer:checkBlessingPoolIsOpen()
	return ex.Player.promotion_data:checkBlessingPoolIsOpen()
end

function LimitTimeActivityLayer:checkAdventureIsOpen()
	return ex.Player.promotion_data:checkAdventureIsOpen()
end

function LimitTimeActivityLayer:checkTavernWeeklyIsOpen()
	return ex.Player.promotion_data:checkTavernWeeklyIsOpen()
end

function LimitTimeActivityLayer:checkSpeedFightIsOpen()
	return ex.Player.promotion_data:checkSpeedFightIsOpen()
end


function LimitTimeActivityLayer:checkAlterHeroIsOpen()
	return ex.Player.promotion_data:checkAlterHeroIsOpen()
end

function LimitTimeActivityLayer:checkSummontimesIsOpen()
	return ex.Player.promotion_data:checkSummontimesIsOpen()
end

function LimitTimeActivityLayer:checkPvpwinsIsOpen()
	return ex.Player.promotion_data:checkPvpwinsIsOpen()
end

function LimitTimeActivityLayer:checkProphecytimesIsOpen()
	return ex.Player.promotion_data:checkProphecytimesIsOpen()
end

function LimitTimeActivityLayer:checkBuyGoldIsOpen()
	return ex.Player.promotion_data:checkBuyGoldIsOpen()
end

function LimitTimeActivityLayer:checkLevelUpIsOpen()
	return ex.Player.promotion_data:checkLevelUpIsOpen()
end

function LimitTimeActivityLayer:checkExchangeIsOpen( )
	return ex.Player.promotion_data:checkExchangeIsOpen()
end

function LimitTimeActivityLayer:checkExchangeLimitIsOpen( )
	return ex.Player.promotion_data:checkExchangeLimitIsOpen()
end

function LimitTimeActivityLayer:checkBuySkinLimitIsOpen( )
	return ex.Player.promotion_data:checkBuySkinLimitIsOpen()
end

function LimitTimeActivityLayer:checkMakeHeroIsOpen( )
	return ex.Player.promotion_data:checkMakeHeroIsOpen()
end

function LimitTimeActivityLayer:checkSummonCrystalIsOpen()
	return ex.Player.promotion_data:checkSummonCrystalIsOpen()
end

function LimitTimeActivityLayer:checkPubArriveIsOpen()
	return ex.Player.promotion_data:checkPubArriveIsOpen()
end

function LimitTimeActivityLayer:checkAdvNoteIsOpen()
	return ex.Player.promotion_data:checkCommonActivityIsOpen(ex.Player.promotion_data.act_adv_note_promotion_id)
end

function LimitTimeActivityLayer:checkMysteryBoxIsOpen()
	return ex.Player.promotion_data:checkCommonActivityIsOpen(ex.Player.promotion_data.act_mystery_box_promotion_id)
end

function LimitTimeActivityLayer:checkColorfulIsOpen()
	return ex.Player.promotion_data:checkColorfulIsOpen()
end

function LimitTimeActivityLayer:checkLoginGiftIsOpen()
	return ex.Player.promotion_data:checkLoginGiftIsOpen()
end

function LimitTimeActivityLayer:checkLimitBuyIsOpen()
	return ex.Player.promotion_data:checkLimitBuyIsOpen()
end

function LimitTimeActivityLayer:checkWeedendGiftIsOpen()
	return ex.Player.promotion_data:WeedendGiftIsOpen()
end


function LimitTimeActivityLayer:checkEveryDayLoginIsOpen()
	return ex.Player.promotion_data:checkEveryDayLoginIsOpen()
end

function LimitTimeActivityLayer:checkOverValueIsOpen()
	return ex.Player.promotion_data:checkOverValueIsOpen()
end


function LimitTimeActivityLayer:checkSpiritWeekCardIsOpen()
	return ex.Player.promotion_data:SpiritWeekCardIsOpen()
end

function LimitTimeActivityLayer:checkLuckFishIsOpen()
	return ex.Player.promotion_data:checkLuckFishIsOpen()
end


return LimitTimeActivityLayer
