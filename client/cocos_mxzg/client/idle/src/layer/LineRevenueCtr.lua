local LineRevenueCtr = class("LineRevenueCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local LineRevenueLayer = class("LineRevenueLayer", require("src.comp.EventLayerAdaptiveWidthFull"))

function LineRevenueLayer:onCreate()
	-- self:addBlackBackground()
	ex.Tools:setLimitWidth(self.lbl_tip_0, 240)
	ex.Tools:setLimitWidth(self.lbl_tip_1, 220)
	ex.Tools:setLimitWidth(self.lbl_tip_2, 280)
end

function LineRevenueLayer:onClickJump(tag,pSender)
	ex.JumpManager:jumpByAtom("main_battle")
	LineRevenueCtr:instance():closeWindow()
end

function LineRevenueCtr:updateLayer()
	if not self:getLayer() then
		return
	end
	local layer = self.layer
    layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    
	local chapter_idx = Maths.clampf(ex.Player.chapter_data.chapter_id, 1, ex.Player.chapter_data.max_chapter_id)
    ex.Player.chapter_data:sortReward()
    local data = cfg.chapterreward.chapterreward[chapter_idx]
    local show_data = {}
	for k,v in pairs(data.reward_base) do
		local data = {}
		data.item_type = v.item_type 
		data.item_num = 0
    	table.insert(show_data,data)
    end

    for k,v in pairs(data.reward_unique) do
    	local dt = {}
    	dt.item_type = v.type
    	dt.item_num = v.num or 1
    	table.insert(show_data,dt)
    end
    layer:updateScrollView(show_data)
end

function LineRevenueLayer:updateScrollView(data)
	local menu = cpp.UIMenu:create()
    menu:setSwallowsTouches(false)
    menu:setPosition(cc.p(0, 0))
    menu:setIsTouchInsideNode(self.scrollView)
    self.scrollView:getContainer():addChild(menu)

    local view_size = self.scrollView:getViewSize()
    local item_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()
	item_size = cc.size(item_size.width* 0.8 + 5,  item_size.height* 0.8 + 5)
	
	local num = table.nums(data)
	local col = 4 -- 列数
	local cont_height = item_size.height * math.ceil(1.0 * num / col)
	cont_height = math.max(cont_height , view_size.height)

	self.scrollView:setContentSize(cc.size(view_size.width, cont_height))
	self.scrollView:setContentOffset(cc.p(0, view_size.height - cont_height))

  	cont_height = cont_height - item_size.height * 0.5
 	local start = cc.p(view_size.width * 0.5 - item_size.width * (col - 1) * 0.5, cont_height)
    local index = 0
	for _,v in pairs(data) do
		local x = index % col
        local y = math.floor(index / col)
        local pos = cc.p(start.x + x * item_size.width, start.y - y * item_size.height)
		local item = ex.Player.backpack_data:createWithData(v.item_type, 0)
		item:setScale(0.8)
		item:setPosition(pos)
        item:registerScriptTapHandler(handler(self, self.onItemInfo))
        menu:addChild(item)
		index = index + 1
    end
end

function LineRevenueLayer:onItemInfo(tag, pSender)
	-- dump(pSender.item_type, "pSender")
	ex.Tools:onClickItemInfo(pSender.item_type)
end
-----------------------------------------------------------------------------
function LineRevenueCtr:onCreate()
	self:setCCBIPath("ccbi/LineRevenueLayer.ccbi")
	self:setIsSingle(false)
end

function LineRevenueCtr:getLayerClass()
	return LineRevenueLayer
end

function LineRevenueCtr:getQuickBattleLayer()
	return self.layer
end

function LineRevenueCtr:openWindow()
	if self:isOpened() then
		return
	end
    ex.Player.battle_data:QuickNums()
	self:loadLayer()
	self:open()
	self:initData()
end

function LineRevenueCtr:initData()
	local layer = self.layer
	self:updateLayer()
end
return LineRevenueCtr
