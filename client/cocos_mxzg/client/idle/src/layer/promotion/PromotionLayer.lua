local PromotionLayer = class("PromotionLayer", require("src.comp.EventLayer"))
local PromotionCell = require("src.layer.promotion.PromotionCell")

-------------------------------------PromotionLayer----------------------------------------------------
-- 界面说明
-- PromotionLayer会根据promotionpage表生成对应的按钮，点击后。会根据promotionpage.layer.寻找对应的文件，并生成对应的layer 添加到自身
function PromotionLayer:onCreate()
	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/promotion.plist")
	
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
	self:addEvent(EVENT.MAIN_CITY_PROMOTION.DAILY_INIT, handler(self, self.initWithTable))
	self:addEvent(EVENT.PROMOTION_EVENT.JUMP_TO_CELL, handler(self, self.onEventByIdx))

	-- 积天豪礼
	ex.Player.promotion_data:reqRechargeDays()
	
	-- 98元累充奖励
	ex.Player.promotion_data:reqRechargeReward()

    -- 周累计充值
    ex.Player.promotion_data:reqRechargeWeek()

    -- 月卡数据
	ex.Player.promotion_data:reqMonthCard()
	
end

function PromotionLayer:createHeroShop()
	local menu = cpp.UIMenu:create()
	menu:setPosition(cc.p(ex.p.width * 0.18, ex.p.height - 130 - require("src.model.Game"):instance():getNotchHeight()))
	self:addChild(menu)

	local btn = cpp.UIMenuItemImage:createWithSpriteFrameName("promotion/btn-hero-shop.png", nil, nil)
	-- btn:setPosition()
	btn:setScale(0.87)
	btn:registerScriptTapHandler(function()
		cfg.funcopen["main_shop"].open(SHOP_TYPE.HERO)
	end)
	menu:addChild(btn)
	ex.EffectCtr:playNormalEff(23, btn:getContentSize().width / 2, btn:getContentSize().height * 0.5+5, nil, btn, 0)
end

function PromotionLayer:onEventByIdx( event,data )
	print(self.__cname,event)
	local items = self.menu:getChildren()
	local cell 
	for k,v in pairs(items) do
		if v.idx == data then 
			cell = v 
			break
		end
	end
	if not cell then return end
	self:onSelect(cell:getTag(), cell)
end

function PromotionLayer:onExit()
	-- 移除红点节点
	local reddot_manager = ex.RedDotManager
	for k,v in pairs(self.vec_reddot) do
		 reddot_manager:removeStickNode(k, v)
	end
end


function PromotionLayer:initWithTable(event, vec_idx, select_index, tab)
	select_index = select_index or 0
	local select_cell = nil
	self:removeRedDotNodeExit()
	
	--
	tab = tab or {}
	local sfc = cc.SpriteFrameCache:getInstance()
	local view_size = self.scroll_view:getViewSize()
	local cell_size = tab.cell_size or PromotionCell:createWithCCBIFile("ccbi/PromotionCell.ccbi"):getContentSize()

	self.vec_reddot = {}
	self.menu:removeAllChildren()
	self.idx = nil

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/promotion-tab-icon-1.plist")
	sfc:addSpriteFrames("ccbi-res/promotion-tab-icon-2.plist")

	local margin = tab.margin or 10
	-- 创建顶层按钮
	local index = 0
	local cell_1, select_order = nil, 1
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
				local cell = PromotionCell:createWithCCBIFile("ccbi/PromotionCell.ccbi")
				cell.idx = config.idx
				cell:setTag(config.idx)
				cell:setContentSize(cell_size)
				cell:setPosition(margin + index * cell_size.width, view_size.height * 0.5 - cell_size.height * 0.5)
				self.menu:addChild(cell)

				-- 设置cell
				ex.Tools:setSpriteFrame(cell.spr_icon1, string.format("promotion/icon-%d-1.png", v.icon))
				ex.Tools:setSpriteFrame(cell.spr_icon2, string.format("promotion/icon-%d-2.png", v.icon))

				-- 添加必买标签
				if config.idx == 101 then	-- 成长礼包（累充豪礼）添加标签
					local spr_flag1 = cc.Sprite:createWithSpriteFrameName("promotion/spr-txt-18.png")
					spr_flag1:setAnchorPoint(cc.p(0.5, 0))
					spr_flag1:setPosition(cc.p(cell.spr_icon1:getContentSize().width * 0.52, cell.spr_icon1:getContentSize().height * 0.76))
					cell.spr_icon1:addChild(spr_flag1, 10)

					local spr_flag2 = cc.Sprite:createWithSpriteFrameName("promotion/spr-txt-18.png")
					spr_flag2:setAnchorPoint(cc.p(0.5, 0))
					spr_flag2:setPosition(cc.p(cell.spr_icon2:getContentSize().width * 0.52, cell.spr_icon2:getContentSize().height * 0.76))
					cell.spr_icon2:addChild(spr_flag2, 10)
				end

				-- local frame = sfc:getSpriteFrame(string.format("promotion/icon-%d-1.png", v.icon))
				-- cell.spr_icon1:setSpriteFrame(frame)
				-- frame = sfc:getSpriteFrame(string.format("promotion/icon-%d-2.png", v.icon))
				-- cell.spr_icon2:setSpriteFrame(frame)

				cell.spr_icon1:setPositionX(cell_size.width * 0.5)
				cell.spr_icon2:setPositionX(cell_size.width * 0.5)

				--设置红点节点
				if v.checkreddot ~= "" and self[v.checkreddot] then
					local bool = self[v.checkreddot]()
					local reddot = tonumber(v.reddot)
					self.vec_reddot[reddot] = cell
					-- ex.RedDotManager:setStickNode(reddot, cell)
					self:addRedDotNode(reddot, cell)
				end

				-- 选中界面
				if select_index == 0 and select_cell == nil then
					select_cell = cell
					select_order = index + 1
				elseif select_index == config.idx then
					select_cell = cell
					select_order = index + 1
				end

				if index == 0 then
					cell_1 = cell
				end

				index = index + 1
			end 
		end
	end
	if select_cell == nil then 
		select_cell = cell_1 
		select_order = 1
	end

	local main_ctr = ex.MainSceneCtr
	local win_size = cc.Director:getInstance():getWinSize()
	local notch_height = require("src.model.Game"):instance():getNotchHeight()
	local height_diff = main_ctr:getBottomHeight() - main_ctr:getMenuScaleHeight();
    local top_height = win_size.height - (height_diff + 70) - 22 - notch_height - 50;
	local view_size = cc.size(win_size.width, cell_size.height)
	
	-- 标题栏。scroll_view 大小扩大30 ，位置也上移30
	self.scroll_view:setViewSize(cc.size(view_size.width, view_size.height + 30))
	self.scroll_view:setPosition(win_size.width * 0.5 - view_size.width * 0.5, top_height - self.scroll_view:getViewSize().height + 30)
	if tab.is_bounceable ~= nil then
		self.scroll_view:setBounceable(tab.is_bounceable)
	else
		self.scroll_view:setBounceable(true)
	end
	-- self.scroll_view:setBounceable(tab.is_bounceable ~= nil and tab.is_bounceable or true)

	-- 设置列表宽度
	local width = index * cell_size.width + margin * 2
    width = math.max(width , self.scroll_view:getViewSize().width)
    local offset_x = Maths.clampf(self.scroll_view:getViewSize().width * 0.5 - (select_index * cell_size.width), 0, self.scroll_view:getViewSize().width - width)
    self.scroll_view:setContentSize(cc.size(width, cell_size.height))
	-- self.scroll_view:setContentOffset(cc.p(offset_x, 0))
	self.scroll_view:setContentOffset(cc.p(math.max(view_size.width - width, -((select_order - 1) * cell_size.width + (select_order > 1 and margin or 0))), 0), true)

	-- 选中界面
	if select_cell ~= nil then
		self:onSelect(select_cell:getTag(), select_cell)
	end

	ex.Player.promotion_data:reqSignInList()
end

function PromotionLayer:updateLayer()
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

function PromotionLayer:getTopY()
	return self.scroll_view:getPositionY()
end

function PromotionLayer:getBottomY()
	return ex.MainSceneCtr:getBottomHeight() + 10
end

function PromotionLayer:setBackCallback(callback)
	self.callback_back = callback
end

function PromotionLayer:onSelect(tag, pSender)
	-- 可能是一个空的列表
	ex.AudioManager:playEffect("music/button-click.mp3")
	print(pSender.idx,self.__cname)
	-- 相同界面不创建
	if self.idx == pSender.idx then
		return
	end
	
	self:changeTab(pSender.idx)
end

function PromotionLayer:changeTab(idx)
	self.idx = idx
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
	if self.cur_layer ~= nil then
		self.cur_layer:removeFromParent()
		self.cur_layer = nil
	end

	-- 创建对应的界面
	local config = cfg.promotionpage.promotionpage[self.idx]
	if config.layer == "" then
		print("PromotionLayer:onSelect.layer = NULL")
		return
	end
	self.menu:unselectAll()
	local children = self.menu:getChildren()
	for i,v in ipairs(children) do
		if v.idx == self.idx then
			v:setSelected(true)
		end
	end

	print("ccbi/".. ex.StringUtil.segment(config.layer, ".", true) ..".ccbi")
	-- 生成layer
	local layer = require("src.layer." .. config.layer):createWithCCBIFile("ccbi/".. ex.StringUtil.segment(config.layer, ".", true) ..".ccbi")
	self:addChild(layer)

	self.cur_layer = layer
	layer.layer_promotion = self

	if layer.onCreateDone then
		layer:onCreateDone()
	end
end

function PromotionLayer:onBack(tag, pSender)
	if self.callback_back then
		self.callback_back()
	else
		if not ex.MainSceneCtr:backLastLayer() then
			ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
		end
	end
end

function PromotionLayer:clickHideRedDot(idx)
	-- 移除红点节点
	local reddot_manager = ex.RedDotManager
	for k,v in pairs(self.vec_reddot) do
		reddot_manager:setSpecialVisible(k, v.idx ~= idx)
	end
end

function PromotionLayer:checkRCGGrowthRedDot()
	-- 签到 红点
	ex.Player.promotion_data:checkRCGGrowthRedDot()
	return true
end

function PromotionLayer:checkSignInRedDot()
	-- 签到 红点
	ex.Player.promotion_data:checkSignInRedDot()
	return true
end

function PromotionLayer:checkMonthCardRedDot()
	-- 月卡 红点
	ex.Player.promotion_data:checkMonthCardRedDot()
	return true
end

function PromotionLayer:checkSuperMonthCardRedDot()
	-- 至尊月卡 红点
	ex.Player.promotion_data:checkSuperMonthCardRedDot()
	return true
end

function PromotionLayer:checkRechargeDaysAwardRedDot()
	-- 积天豪礼 红点
	ex.Player.promotion_data:checkRechargeDaysAwardRedDot()
	return true
end

function PromotionLayer:checkRechargeAwardRedDot()
	-- 周累计充值 红点
	ex.Player.promotion_data:checkRechargeAwardRedDot()
	return true
end

function PromotionLayer:checkLevelUpAwardRedDot()
	-- 等级升级 红点
	ex.Player.promotion_data:checkLevelUpAwardRedDot()
	return true
end

function PromotionLayer:checkBuyGoldRedDot()
	-- 点金 红点
	ex.Player.promotion_data:checkBuyGoldRedDot()
	return true
end
function PromotionLayer:checkProphecytimesRedDot()
	-- 先知 红点
	ex.Player.promotion_data:checkProphecytimesRedDot()
	return true
end
function PromotionLayer:checkPvpwinsRedDot()
	-- 竞技者 红点
	ex.Player.promotion_data:checkPvpwinsRedDot()
	return true
end
function PromotionLayer:checkSummontimesRedDot()
	-- 召唤 红点
	ex.Player.promotion_data:checkSummontimesRedDot()
	return true
end

function PromotionLayer:checkRechargeAward2RedDot()
	-- 积天豪礼 红点
	ex.Player.promotion_data:checkRechargeAward2RedDot()
	return true
end


function PromotionLayer:changeToRechargePage()
	local vec_idx = ex.Player.promotion_data:getPromotionByType(RechargeKindType.RECHARGE)
    local tab = {}
    tab.cell_size = cc.size(168, 120.0)
    tab.view_size = cc.size(tab.cell_size.width * table.nums(vec_idx), tab.cell_size.height)
    tab.is_bounceable = false
    tab.margin = -10
    self:initWithTable(nil, vec_idx, 103, tab)
end

function PromotionLayer:checkVipRedDot()
	ex.Player.promotion_data:checkVipRedDot()
	return true
end

function PromotionLayer:checkLimitRedDot()
	ex.Player.promotion_data:checkLimitRedDot()
	return true
end

function PromotionLayer:checkPrivilegeGiftRedDot()
	ex.Player.promotion_data:checkPrivilegeGiftRedDot()
	return true
end

function PromotionLayer:checkClergyPrivilegeRedDot()
	ex.Player.promotion_data:checkClergyPrivilegeRedDot()
	return true
end

function PromotionLayer:checkInvitationGiftRedDot()
	ex.Player.promotion_data:checkInvitationGiftRedDot()
	return true
end


--------------------是否开启检测-------------------------------
function PromotionLayer:checkSummontimesIsOpen()
	return ex.Player.promotion_data:checkSummontimesIsOpen()
end

function PromotionLayer:checkPvpwinsIsOpen()
	return ex.Player.promotion_data:checkPvpwinsIsOpen()
end

function PromotionLayer:checkProphecytimesIsOpen()
	return ex.Player.promotion_data:checkProphecytimesIsOpen()
end

function PromotionLayer:checkBuyGoldIsOpen()
	return ex.Player.promotion_data:checkBuyGoldIsOpen()
end

function PromotionLayer:checkLevelUpIsOpen()
	return ex.Player.promotion_data:checkLevelUpIsOpen()
end


function PromotionLayer:checkLimitIsOpen()
	return ex.Player.promotion_data:checkLimitIsOpen()
end


function PromotionLayer:checkWeekChecIsOpen()
	return ex.Player.promotion_data:checkWeekChecIsOpen()
end
function PromotionLayer:checkMouthWelfareIsOpen()
	return ex.Player.promotion_data:checkMouthWelfareIsOpen()
end
function PromotionLayer:checkDailyRechargeGiftIsOpen()
	return ex.Player.promotion_data:checkDailyRechargeGiftIsOpen()
end


return PromotionLayer
