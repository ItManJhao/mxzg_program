local DevelopGiftActivityLayer = class("DevelopGiftActivityLayer", require("src.comp.EventLayer"))
local DevelopGiftActivityCell = require("src.layer.promotion.DevelopGiftActivityCell")

-------------------------------------DevelopGiftActivityLayer----------------------------------------------------
-- 界面说明
-- DevelopGiftActivityLayer会根据promotionpage表生成对应的按钮，点击后。会根据promotionpage.layer.寻找对应的文件，并生成对应的layer 添加到自身
function DevelopGiftActivityLayer:onCreate()
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
							  
	self.btn_back:registerScriptTapHandler(handler(self, self.onBack))
	self.btn_back:getParent():setLocalZOrder(100)

	self.vec_reddot = {}
end

function DevelopGiftActivityLayer:onExit()
	-- 移除红点节点
	local reddot_manager = ex.RedDotManager
	for k,v in pairs(self.vec_reddot) do
		 reddot_manager:removeStickNode(k, v)
	end
end

function DevelopGiftActivityLayer:initWithTable(event, vec_idx, select_index, tab)
	self:removeRedDotNodeExit()
	
	select_index = select_index or 0
	local select_cell = nil
	
	--
	tab = tab or {}
	local sfc = cc.SpriteFrameCache:getInstance()
	local view_size = self.scroll_view:getViewSize()
	local cell_size = tab.cell_size or DevelopGiftActivityCell:createWithCCBIFile("ccbi/LimitTimeActivityCell.ccbi"):getContentSize()

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
	for i,v in ipairs(vec_idx) do
		local config = cfg.promotionpage.promotionpage[v.idx]
		if config then
			
			local isShow = true
			if v.checkopen == "" then
				isShow = true
			elseif self[v.checkopen] then 
				isShow = self[v.checkopen]()
			end 

			if ex.Player.level < v.checkLevelOpen then 
				isShow = false
			end 
			
			if isShow then 
				local cell = DevelopGiftActivityCell:createWithCCBIFile("ccbi/LimitTimeActivityCell.ccbi")
				cell.idx = config.idx
				cell:setContentSize(cell_size)
				cell:setPosition(margin + index * cell_size.width, view_size.height * 0.5 - cell_size.height * 0.5)
				self.menu:addChild(cell)

				-- 设置cell
				-- 如果是皮肤活动，则需要根据皮肤活动类型显示不同图标
				ex.Tools:setSpriteFrame(cell.spr_icon1, string.format("promotion/icon-%d-1.png", v.icon))
				ex.Tools:setSpriteFrame(cell.spr_icon2, string.format("promotion/icon-%d-2.png", v.icon))

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
	self:onSelect(select_cell:getTag(), select_cell)
end

function DevelopGiftActivityLayer:updateLayer()
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

function DevelopGiftActivityLayer:getTopY()
	return self.scroll_view:getPositionY()
end

function DevelopGiftActivityLayer:getBottomY()
	return ex.MainSceneCtr:getBottomHeight() + 10
end

function DevelopGiftActivityLayer:setBackCallback(callback)
	self.callback_back = callback
end

function DevelopGiftActivityLayer:onSelect(tag, pSender)
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
		print("DevelopGiftActivityLayer:onSelect.layer = NULL")
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
		layer:onCreateDone(config.idx)
	end
end

function DevelopGiftActivityLayer:onBack(tag, pSender)
	if self.callback_back then
		self.callback_back()
	else
		ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
	end
end

function DevelopGiftActivityLayer:clickHideRedDot(idx)
	-- 移除红点节点
	local reddot_manager = ex.RedDotManager
	for k,v in pairs(self.vec_reddot) do
		reddot_manager:setSpecialVisible(k, v.idx ~= idx)
	end
end


--------------------红点检测-------------------------------
-- function DevelopGiftActivityLayer:checkAdventureRedDot()
-- 	-- 试炼之路 红点
-- 	ex.Player.promotion_data:checkAdventureRedDot()
-- 	return true
-- end




--------------------是否开启检测-------------------------------
-- function DevelopGiftActivityLayer:checkOverValueIsOpen()
-- 	return ex.Player.promotion_data:checkOverValueIsOpen()
-- end





return DevelopGiftActivityLayer
