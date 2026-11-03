local LimitTimeServerActivityLayer = class("LimitTimeServerActivityLayer", require("src.comp.EventLayer"))
local LimitTimeActivityCell = require("src.layer.promotion.LimitTimeActivityCell")

-------------------------------------LimitTimeServerActivityLayer----------------------------------------------------
-- 界面说明
-- LimitTimeServerActivityLayer会根据promotionpage表生成对应的按钮，点击后。会根据promotionpage.layer.寻找对应的文件，并生成对应的layer 添加到自身
function LimitTimeServerActivityLayer:onCreate()
    self:setAutoClose(false)
	self:setSwallowTouches(false)

	ex.Player.summon_data:setCallback(function(is_lock)
		self:touchSwallowTouches(is_lock)
	 end)
	

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
							  
	self.btn_back:registerScriptTapHandler(handler(self, self.onBack))
	self.btn_back:getParent():setLocalZOrder(100)

	self.vec_reddot = {}
end

function LimitTimeServerActivityLayer:touchSwallowTouches(is_lock)
	-- if self.cur_layer.setSwallowsTouches then 
	-- 	self.cur_layer:setSwallowsTouches(is_lock)
	-- end
end

function LimitTimeServerActivityLayer:onExit()
	-- 移除红点节点
	local reddot_manager = ex.RedDotManager
	for k,v in pairs(self.vec_reddot) do
		 reddot_manager:removeStickNode(k, v)
	end
end

function LimitTimeServerActivityLayer:initWithTable(event, vec_idx, select_index, tab, dragonboat_id)
	self:removeRedDotNodeExit()
	
	select_index = select_index or 0
	local select_cell = nil
	
	-- 龍舟活動是否顯示
	local show_dragonboat = false
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

	local margin = tab.margin or 10
	-- 创建顶层按钮
	local index = 0
	local have_panel = false
	local cell_1, select_order = nil, 1

	--把炫酷皮肤页签调整到最前面
    local needChangeDate = nil
    for i, v in ipairs(vec_idx) do
        if v and v.reddot and v.reddot == RedDotType.ZCJ_DHZC_PFHD_SRLC then
            needChangeDate = v
            break
        end
    end
    if needChangeDate then
        table.insert(vec_idx, 1, needChangeDate)
        table.remove(vec_idx)
    end

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
				if select_index == ActivityPanelIdxType.BUY_DRAGONBOAT then
					show_dragonboat = true
				end
				local cell = LimitTimeActivityCell:createWithCCBIFile("ccbi/LimitTimeActivityCell.ccbi")
				cell.idx = config.idx
				cell:setContentSize(cell_size)
				cell:setPosition(margin + index * cell_size.width, view_size.height * 0.5 - cell_size.height * 0.5)
				self.menu:addChild(cell)

				-- 设置cell
				-- 如果是皮肤活动，则需要根据皮肤活动类型显示不同图标
				if config.icon ~= 701 then
					ex.Tools:setSpriteFrame(cell.spr_icon1, string.format("promotion/icon-%d-1.png", v.icon))
					ex.Tools:setSpriteFrame(cell.spr_icon2, string.format("promotion/icon-%d-2.png", v.icon))
				else
					local fashion_config = nil
					for k,v in pairs(cfg.fashionbuy.fashionbuy) do
						fashion_config = v
						break
					end
					ex.Tools:setSpriteFrame(cell.spr_icon1, string.format("promotion/icon-%d-%d-1.png", v.icon, fashion_config.fashion_id))
					ex.Tools:setSpriteFrame(cell.spr_icon2, string.format("promotion/icon-%d-%d-2.png", v.icon, fashion_config.fashion_id))
				end

				-- local frame = sfc:getSpriteFrame(string.format("promotion/icon-%d-1.png", v.icon))
				-- cell.spr_icon1:setSpriteFrame(frame)
				-- frame = sfc:getSpriteFrame(string.format("promotion/icon-%d-2.png", v.icon))
				-- cell.spr_icon2:setSpriteFrame(frame)

				cell.spr_icon1:setPositionX(cell_size.width * 0.5)
				cell.spr_icon2:setPositionX(cell_size.width * 0.5)

				-- 设置红点节点
				if v.reddot ~= "" then
					self:addRedDotNode(tonumber(v.reddot), cell)
					
                    if v.checkreddot ~= "" and self[v.checkreddot] then
                        local bool = self[v.checkreddot]()
                        local reddot = tonumber(v.reddot)
                        ex.RedDotManager:setRedNodeVisible(reddot, bool)
                    end
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
				have_panel = true
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
	-- self.scroll_view:setContentOffset(cc.p(0 - (select_index * cell_size.width), 0))
	self.scroll_view:setContentOffset(cc.p(math.max(view_size.width - width, -((select_order - 1) * cell_size.width + (select_order > 1 and margin or 0))), 0), true)
	
	-- 选中界面
	-- 端午节活动的页面跳转
	if dragonboat_id ~= nil and select_index == ActivityPanelIdxType.BUY_DRAGONBOAT and show_dragonboat then
		self:onSelect(select_cell:getTag(), select_cell, dragonboat_id)
	else
		self:onSelect(select_cell:getTag(), select_cell)
	end
end

function LimitTimeServerActivityLayer:updateLayer()
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

function LimitTimeServerActivityLayer:getTopY()
	return self.scroll_view:getPositionY()
end

function LimitTimeServerActivityLayer:getBottomY()
	return ex.MainSceneCtr:getBottomHeight() + 10
end

function LimitTimeServerActivityLayer:setBackCallback(callback)
	self.callback_back = callback
end

function LimitTimeServerActivityLayer:onSelect(tag, pSender, dragonboat_id)
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


	-- 创建对应的界面
	local config = cfg.promotionpage.promotionpage[pSender.idx]
	if config.layer == "" then
		print("LimitTimeServerActivityLayer:onSelect.layer = NULL")
		return
	end
	self.menu:unselectAll()
	pSender:setSelected(true)

	--self:clickHideRedDot(pSender.idx)

	print(self.__cname,ex.StringUtil.segment(config.layer, ".", true))
	-- 生成layer
	local layer = require("src.layer." .. config.layer):createWithCCBIFile("ccbi/".. ex.StringUtil.segment(config.layer, ".", true) ..".ccbi")
	self:addChild(layer)

	self.cur_layer = layer
	layer.layer_promotion = self;

	if layer.onCreateDone then
		layer:onCreateDone(config.idx)
	end

	if dragonboat_id ~= nil then
		layer:onChangeLayer(dragonboat_id)
	end
end

function LimitTimeServerActivityLayer:onBack(tag, pSender)
	if self.callback_back then
		self.callback_back()
	else
		-- ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
		ex.MainSceneCtr:backLastLayer()
	end
end

function LimitTimeServerActivityLayer:clickHideRedDot(idx)
	-- 移除红点节点
	local reddot_manager = ex.RedDotManager
	for k,v in pairs(self.vec_reddot) do
		reddot_manager:setSpecialVisible(k, v.idx ~= idx)
	end
end

--------------------红点检测-------------------------------
function LimitTimeServerActivityLayer:checkEveryDayLoginRedDot()
	return ex.Player.promotion_data:checkEveryDayLoginRedDot()
end

--------------------是否开启检测-------------------------------
function LimitTimeServerActivityLayer:checkSummonWeekCardIsOpen()
	return ex.Player.promotion_data:checkSummonWeekCardIsOpen()
end

function LimitTimeServerActivityLayer:checkSuperSummonWeekCardIsOpen()
	return ex.Player.promotion_data:checkSuperSummonWeekCardIsOpen()
end

function LimitTimeServerActivityLayer:checkEveryDayLoginIsOpen()
	return ex.Player.promotion_data:checkEveryDayLoginIsOpen()
end

function LimitTimeServerActivityLayer:checkOverValueIsOpen()
	return ex.Player.promotion_data:checkOverValueIsOpen()
end

function LimitTimeServerActivityLayer:checkBuySkinIsOpen()
	return ex.Player.promotion_data:checkBuySkinIsOpen()
end

function LimitTimeServerActivityLayer:checkBuySkinLimitIsOpen()
	return ex.Player.promotion_data:checkBuySkinLimitIsOpen()
end

function LimitTimeServerActivityLayer:checkThreeDayGiftIsOpen()
	return ex.Player.promotion_data:checkThreeDayGiftIsOpen()
end

function LimitTimeServerActivityLayer:customizedIsOpen()
	return ex.Player.promotion_data:customizedIsOpen()
end

function LimitTimeServerActivityLayer:checkMagicButterflyIsOpen()
	return ex.Player.promotion_data:checkMagicButterflyIsOpen()
end

function LimitTimeServerActivityLayer:checkDragonBoatIsOpen()
	return ex.Player.promotion_data:checkDragonBoatIsOpen()
end

function LimitTimeServerActivityLayer:checkTimeTreasureIsOpen()
	return ex.Player.promotion_data:checkTimeTreasureIsOpen()
end

function LimitTimeServerActivityLayer:checkLuckFishIsOpen()
	return ex.Player.promotion_data:checkLuckFishIsOpen()
end

function LimitTimeServerActivityLayer:checkExchangeShopIsOpen()
	return ex.Player.promotion_data:checkExchangeShopIsOpen()
end

function LimitTimeServerActivityLayer:checkAstrologyTaskIsOpen()
	return ex.Player.promotion_data:checkAstrologyTaskIsOpen()
end

function LimitTimeServerActivityLayer:checkThreeDaysRechargeIsOpen()
	return ex.Player.promotion_data:checkThreeDaysRechargeIsOpen()
end


return LimitTimeServerActivityLayer
