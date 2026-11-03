local GodEquipShopCtr = class("GodEquipShopCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local GodEquipShopLayer = class("GodEquipShopLayer", require("src.layer.shop.ShopLayer"), require("src.comp.EventLayerAdaptiveWidth"))

-------------------------------------------------------------------
function GodEquipShopCtr:onCreate()
	self:setCCBIPath("ccbi/GodEquipShopLayer.ccbi")
	self:setIsSingle(false)

    self.data = {}
end

function GodEquipShopCtr:getLayerClass()
	return GodEquipShopLayer
end

function GodEquipShopCtr:openWindow(data)
	if self:isOpened() then
		return
	end

    self.data = data
    self.layer_type = 1

	self:loadLayer()
	self:open()

	-- 移除内部事件调用，改用这里控制
	self.layer:removeEvent()
	self.layer:addEvent(EVENT.SHOP_EVENT.UPDATE, handler(self, self.refresh))
	self.layer:addEvent(EVENT.SHOP_EVENT.UPDATE_FREE_REFRESH_TIME, handler(self, self.refresh))
	self:initData()
end

function GodEquipShopCtr:initData()
    local layer = self.layer
    layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    
    layer.lbl_tip:setString(ex.Tools:getLang(72602))

	if not self.data or table.nums(self.data) <= 0 then 
		ex.MessageView:add(ex.Tools:getLang(47239))
		return
    end
    
    self:initScrollViewTab()
	self:refreshViewByElem()
	layer:changeTime()
end

function GodEquipShopCtr:initScrollViewTab()
    local menu_tab = cpp.UIMenu:create()
    menu_tab:setIsTouchInsideNode(self.layer.scroll_view_tab)
    menu_tab:setSwallowsTouches(false)
    menu_tab:setPosition(cc.p(0, 0))
    self.layer.scroll_view_tab:addChild(menu_tab)

    local tags = {}
    for k,v in pairs(cfg.shopgodequipment.shopgodequipment) do
        local is_have = false
        for i2,v2 in ipairs(tags) do
            if v2 == v.type then
                is_have = true
                break
            end
        end
        if is_have == false then
            table.insert(tags, v.type)
        end
    end
    table.sort(tags, function(a, b)
        return a < b
    end)

    -- 添加导航条
    local margin_x, space_x, item_size, scale = 4, 10, nil, 1
    for i,v in ipairs(tags) do
        self.layer["btn_tab_"..i] = cpp.UIMenuItemTab:create("button/btn-tab-3.png", "button/btn-tab-4.png", "", 1, 1)
        self.layer["btn_tab_"..i]:setScale(scale)
        if not item_size then 
            item_size = self.layer["btn_tab_"..i]:getContentSize()
            item_size.width = item_size.width * scale
            item_size.height = item_size.height * scale
        end
        self.layer["btn_tab_"..i]:setTag(tags[i])
        self.layer["btn_tab_"..i]:registerScriptTapHandler(handler(self, self.onTab))
        self.layer["btn_tab_"..i]:setAnchorPoint(ex.a.bottom_center)
        self.layer["btn_tab_"..i]:setPosition(margin_x + (i - 0.5) * item_size.width + (i - 1) * space_x, 0)
        menu_tab:addChild(self.layer["btn_tab_"..i])
        self.layer["btn_tab_"..i]:setLabelText(ex.Tools:getLang(72400 + v))
        self.layer["btn_tab_"..i]:setLabelColor(FONT_BROWN)
        self.layer["btn_tab_"..i]:setLabelOffset(cc.p(0, -3))

        if i == 1 then
            self.layer["btn_tab_"..i]:setChecked(true)
        end
    end
    self.layer.scroll_view_tab:setContentSize(cc.size(2 * margin_x + #tags * item_size.width + (#tags - 1) * space_x, self.layer.scroll_view_tab:getViewSize().height))
    self.layer.scroll_view_tab:setContentOffset(self.layer.scroll_view_tab:maxContainerOffset())
end

function GodEquipShopCtr:refresh( )
	if not self:isOpened() then
		return
	end

	self.data = ex.Player.market_data:getMarketDataByType(SHOP_TYPE.GOD_EQUIP)

	self:refreshViewByElem()
end

function GodEquipShopCtr:refreshViewByElem()
    -- 获取对应类型商品
    local config = cfg.shopgodequipment.shopgodequipment
    local list = {}
    for k,v in pairs(self.data) do
        local tmp = config[v.idx]
        if tmp.type == self.layer_type then
            table.insert(list, v)
        end
	end

	self.layer:updateView(list)
end

function GodEquipShopCtr:onTab(tag, pSender)
    self.layer_type = tag

    self:refreshViewByElem()
end

return GodEquipShopCtr