local PROMLimitGiftLayer = class("PROMLimitGiftLayer", require("src.comp.EventLayer"))
local PromotionCell = require("src.layer.promotion.PromotionCell")

local ExTimer = require("src.ex.ExTimer")


function PROMLimitGiftLayer:getAsynImage()
    -- dump(cc.Director:getInstance():getTextureCache():getCachedTextureInfo())
    local vec_image = {
        {image_name = "ccbi-res/promotion-tab-icon-1.pvr.ccz", plist_name = "ccbi-res/promotion-tab-icon-1.plist", remove_type=2},
    }
    return vec_image
end

function PROMLimitGiftLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

	self.cells = {}
	self.cur_gift_id = ""

	local bg_size = self.spr_bg:getContentSize()
	self.spr_bg:setScaleX(ex.p.width / bg_size.width)
	self.spr_bg:setScaleY(ex.p.height / bg_size.height)

	self.menu = require("src.comp.menu.UIMenuGeneral"):create()
	self.menu:setPosition(cc.p(0, 0))
	self.menu:setSwallowsTouches(false)
	self.menu:setTouchCallback(handler(self, self.onSelect))
	self.scroll_view:getContainer():addChild(self.menu)
	self.scroll_view:setLocalZOrder(100)

	local notch_height = require("src.model.Game"):instance():getNotchHeight()
    self.btn_back:setPosition(self:getContentSize().width / 2 + ex.p.width / 2 / self:getScaleX() - 20 / self:getScaleX() - 60,
                              self:getContentSize().height / 2 + ex.p.height / 2 / self:getScaleY() - 100 / self:getScaleY() - 42 - notch_height)
							  
	self.btn_back:registerScriptTapHandler(handler(self, self.onBtnBack))
	self.btn_back:getParent():setLocalZOrder(100)

	self:addEvent(EVENT.MAIN_CITY_RECHARGE.LIMIT_GIFT,handler(self,self.updateLayer))

   	-- 设置按钮scroll_view
    local cell_size = PromotionCell:createWithCCBIFile("ccbi/PromotionCell.ccbi"):getContentSize()
    local view_size = cc.size(ex.p.width, cell_size.height)
	self.scroll_view:setViewSize(view_size)

	local main_ctr = ex.MainSceneCtr
	local notch_height = require("src.model.Game"):instance():getNotchHeight()
	local height_diff = main_ctr:getBottomHeight() - main_ctr:getMenuScaleHeight()
    local top_height = ex.p.height - (height_diff + 70) - 22 - notch_height - 50
	self.scroll_view:setPosition(0, top_height - view_size.height)
	
	
	self:updateLayer()
end

function PROMLimitGiftLayer:updateLayer(_, is_force)
	self.menu:removeAllChildren()
	self.cells = {}
	self.limit_gift_data = clone(ex.Player.promotion_data.limit_gift)
	for k,v in pairs(self.limit_gift_data) do
		local config = cfg.buygem.buygem[v.idx]
		if config.kind == 22 then
			table.remove( self.limit_gift_data, k )
		end
	end

	ex.Player.promotion_data:checkLimitGift()

	if table.nums(self.limit_gift_data) <= 0 then
		-- 没有礼包了 跳转主城
		ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
		return
	end

	self.timer = ExTimer:new():bind(self):runOnce(handler(self, self.checkClose), 0.6)

	local sfc = cc.SpriteFrameCache:getInstance()

	local view_size = self.scroll_view:getViewSize()
	local cell_size = PromotionCell:createWithCCBIFile("ccbi/PromotionCell.ccbi"):getContentSize()

	local select_cell = nil

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/promotion-tab-icon-1.plist")

	local margin = 10
	local index = 0
	local cell_1 = nil
	for _,v in pairs(self.limit_gift_data) do
		local config = cfg.buygem.buygem[v.idx]
		if config ~= nil and config.icon ~= "" then
			local cell = PromotionCell:createWithCCBIFile("ccbi/PromotionCell.ccbi")
			cell:setPosition(margin + index * cell_size.width, view_size.height * 0.5 - cell_size.height * 0.5)
			cell.gift_id = v.gift_id
			cell.idx = v.idx
			self.menu:addChild(cell)
			table.insert(self.cells, cell)
			
			local icon = 200
			if config ~= nil then
				icon = config.icon
			end
			
			-- local frame = sfc:getSpriteFrame(string.format("promotion/icon-%d-1.png", icon))
			-- cell.spr_icon1:setSpriteFrame(frame)
			-- frame = sfc:getSpriteFrame(string.format("promotion/icon-%d-2.png", icon))
			-- cell.spr_icon2:setSpriteFrame(frame)
			ex.Tools:setSpriteFrame(cell.spr_icon1, string.format("promotion/icon-%d-1.png", icon))
			ex.Tools:setSpriteFrame(cell.spr_icon2, string.format("promotion/icon-%d-2.png", icon))

			cell.spr_icon1:setPositionX(cell_size.width * 0.5)
			cell.spr_icon2:setPositionX(cell_size.width * 0.5)
			
			-- %d星升级礼包
			-- if config.kind == RechargeKindType.HERO_UPSTAR then
			-- 	cell:addBtnText(ex.Tools:getLang(config.item_language))
			-- end
			
			-- 光暗跟三系是特殊的。语言是在图片里面的
			if config.item_language ~= "" then
				cell:addBtnText(ex.Tools:getLang(config.item_language))
			end


			if self.cur_gift_id == v.gift_id then
				cell:setSelected(true)
				select_cell = cell
			else
				cell:setSelected(false)
			end
			
			if index == 0 then
				cell_1 = cell
			end

			index = index + 1
		end
	end

	if select_cell == nil then
		select_cell = cell_1
	end

	local width = index * cell_size.width + margin * 2
    width = math.max(width , view_size.width)
    self.scroll_view:setContentSize(cc.size(width, cell_size.height))
    self.scroll_view:setContentOffset(cc.p(0, 0))

    self:onSelect(select_cell:getTag(), select_cell, is_force)
end

function PROMLimitGiftLayer:checkClose()
	if table.nums(self.limit_gift_data) == 0 then
		-- 没有礼包了 跳转主城
		ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
		return
	end

	if self.timer then
		self.timer:stop()
	end
	self.timer = nil
end

function PROMLimitGiftLayer:onExit()
	if self.timer then
		self.timer:stop()
	end
	self.timer = nil
end

function PROMLimitGiftLayer:getBottomY()
	return ex.MainSceneCtr:getBottomHeight() + 40
end

function PROMLimitGiftLayer:getTopY()
	return self.scroll_view:getPositionY()
end

function PROMLimitGiftLayer:onSelect(tag, pSender, is_force)
	ex.AudioManager:playEffect("music/button-click.mp3")

	if (is_force == nil or is_force == false) and self.cur_gift_id == pSender.gift_id then
		return
	end

	self.cur_gift_id = pSender.gift_id

	self.menu:unselectAll()
	for i,v in ipairs(self.cells) do
		if v ~= pSender then
			v:setSelected(false) 
		end
	end
	pSender:setSelected(true)

	--print("onSelect...id = "..self.cur_gift_id)

	if self.cur_layer ~= nil then
		self.cur_layer:removeFromParent()
		self.cur_layer = nil
	end

	-- 创建对应的界面
	local config = cfg.buygem.buygem[pSender.idx]
	if config == nil then
		print("PROMLimitGiftLayer:onSelect buygem config ", pSender.idx, " = NULL")
		return
	end

	local page_config = cfg.promotionpage.promotionpage[config.icon]
	if page_config == nil then
		print("PROMLimitGiftLayer:onSelect promotionpage config ", promotion_page_idx, " = nil")
		return
	end

	-- 生成layer
	local layer = require("src.layer." .. page_config.layer):createWithCCBIFile("ccbi/".. ex.StringUtil.segment(page_config.layer, ".", true) ..".ccbi")
	self:addChild(layer)

	self.cur_layer = layer
	layer.layer_promotion = self;

	if layer.onCreateDone then
		layer:onCreateDone(self.cur_gift_id)
	end
end

function PROMLimitGiftLayer:onBtnBack(tag, pSender)
	ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
end


return PROMLimitGiftLayer