
local LimitShopCtr = class("LimitShopCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local LimitShopLayer = class("LimitShopLayer", require("src.comp.EventLayerAdaptiveWidth"))


local LimitShopItemCell = require("src.layer.promotion.LimitShopItemCell")

local shopMenuType = {
	41094, 41095
}
-------------------------------------------
function LimitShopLayer:onCreate()
	self:addBlackBackground()
	self.shop_promotion_data = {}

	self.btn_close:registerScriptTapHandler(handler(self, self.onBack))

	self.item_size = cc.size(140, 215)

    self:initData()


	self.num_text:setString(ex.Player:getItemNum(ItemType.IT_LIMIT_SHOP))
end


function LimitShopLayer:initData( )
	
	self.shop_promotion_data = {}
	self.shop_menu = {}
	-- 加载数据
	for k,v in pairs(cfg.shoppromotion.shoppromotion) do

		if not self.shop_promotion_data[v.kind] then 
			self.shop_promotion_data[v.kind] = {}
			table.insert(self.shop_menu, v.kind)
		end 

		local data = {}
		data.index = v.idx

		data.goods = {}
		data.goods.item_type = v.item_type[1].item_type
		data.goods.item_num = v.item_type[1].item_num

		data.need = {}
		data.need.item_type = v.need_item[1].item_type
		data.need.item_num = v.need_item[1].item_num

		table.insert( self.shop_promotion_data[v.kind] , data)		
	end 

	--检查存在的组,创建左侧按钮
	self:createUIMenu()

end


function LimitShopLayer:createUIMenu(  )
	
	local margin = 0
	local offset = 5
	local menu = cpp.UIMenu:create()
	self.res_node:addChild(menu)
    menu:setPosition(0,0)
    menu:setSwallowsTouches(false)
    self.tabs = {}
	self.textTab = {}

	for k,v in pairs(self.shop_menu) do

		--local str = ex.Tools:getLang(shopMenuType[v])
		local str = ""
        local item = cpp.UIMenuItemTab:create("button/btn-tab-1.png",
                                              "button/btn-tab-2.png",
                                              str,
                                              1,
                                              nil)
		local item_size = item:getContentSize()

		local posX = 0
		local posY = item_size.width - (item_size.width + margin) * (k - 1) - offset - item_size.width - 30
		item:setLabelColor(FONT_BLACK)
		item:setPosition(posX , posY)
		item:setRotation(270)
        item:setTag(k)
        item:registerScriptTapHandler(handler(self, self.onClickTab))
        item:setChecked(k==1)
        self.tabs[k] = item
		menu:addChild(item)


		local lbl_bubble = cc.Label:createWithTTF(ex.Tools:getLang(shopMenuType[v]), FONT_DEFAULT_NAME_BOLD, 36)
		lbl_bubble:setScale(0.5)
		lbl_bubble:setAnchorPoint(cc.p(0.5, 0.5))
		lbl_bubble:setTextColor(FONT_BROWN)
		lbl_bubble:setPosition(posX, posY - 10)
		self.res_node:addChild(lbl_bubble, 1)
		lbl_bubble:setDimensions(30, 200)
		self.textTab[k] = lbl_bubble

        
    end


    self.viewSize = self.spr_bg:getContentSize()
    self.viewSize.height = self.viewSize.height - 14

    -- 物品scroll_view
    self.scroll_view = cc.ScrollView:create(self.viewSize)
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    :setPosition(self.spr_bg:getPositionX(), self.spr_bg:getPositionY() + 7)
    self:addChild(self.scroll_view, 20)
	
	self.spr_bg:setLocalZOrder(10)

	self:onClickTab(1)
end


function LimitShopLayer:onClickTab(tag,pSender)
    if tag == self.cur_tag then return end
    self.cur_tag = tag
	self:showPanel(self.cur_tag)
end


function LimitShopLayer:showPanel( cur_tag )
	
	local shop_list = self.shop_promotion_data[cur_tag]
	self.scroll_view:getContainer():removeAllChildren()

	local shopLen = table.nums(shop_list)

	local margin = 0
	local col = math.floor((self.viewSize.width - margin * 2) / self.item_size.width) -- 列数
	local row = math.ceil(1.0 * shopLen / col) -- 行数
	local cont_height = self.item_size.height * row + margin * 2
	cont_height = math.max(cont_height , self.viewSize.height)
	row = math.ceil((cont_height - margin * 2) / self.item_size.height) -- 总行数

	self.scroll_view:setContentSize(cc.size(self.viewSize.width, cont_height))
	self.scroll_view:setContentOffset(cc.p(0, self.viewSize.height - cont_height))

	cont_height = cont_height - (self.item_size.height * 0.5 + margin * 0.5)

	local start = cc.p(self.viewSize.width * 0.5 - (self.item_size.width * col * 0.5), cont_height)
	start.x = start.x + self.item_size.width * 0.5
	
	local index = 0
	for _,v in pairs(shop_list) do
		local x = index % col
		local y = math.floor(index / col)

		local item = self:createCell(v.index, v.goods, v.need)
		item:setPosition(start.x + x * self.item_size.width, start.y - y * self.item_size.height - 5)
		
		self.scroll_view:addChild(item)
		index = index + 1
	end
end

function LimitShopLayer:onBtnPay(tag, pSender)
	local cell = pSender:getParent():getParent()

	--检测物品数量
	local hasNum = ex.Player:getItemNum(cell.need.item_type)

	if hasNum < cell.need.item_num then 
		ex.MessageView:add(ex.Tools:getLang(41097))
	else 

		local content = string.format(ex.Tools:getLang(41096), cell.need.item_num, ex.Tools:getLang(cell.goods.item_type), cell.goods.item_num)

        ex.ConfirmCtr:openWindow(ex.Tools:getLang(41201), content, function()
            -- 扣除购买数据
            if self.is_test_buy ~= true then
                -- ex.Player:addItem(cell.need.item_type, -cell.need.item_num)
            end
            
            local index = cell.index
			ex.Player.promotion_data:reqLimitShopGift(index)

			self.num_text:setString(ex.Player:getItemNum(ItemType.IT_LIMIT_SHOP))

        end)
	end 
end

function LimitShopLayer:createCell(index, good, need)
	local cell = LimitShopItemCell:createWithCCBIFile("ccbi/LimitShopItemCell.ccbi")
	cell:setSwallowTouches(false)
	cell:setIgnoreAnchorPointForPosition(false)
    cell:setAnchorPoint(ex.a.center)

    cell:initDone(index, good, need)
    cell.btn_pay:registerScriptTapHandler(handler(self, self.onBtnPay))
    return cell
end



function LimitShopLayer:onBack(tag, pSender)
	ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
end

-------------------------------------------

function LimitShopCtr:onCreate()
	self:setCCBIPath("ccbi/LimitShopLayer.ccbi")
	self:setIsSingle(false)
end

function LimitShopCtr:getLayerClass()
	return LimitShopLayer
end

function LimitShopCtr:getLimitShopLayer()
	return self.layer
end

function LimitShopCtr:openWindow()
	if self:isOpened() then
		return
	end
	
	self:loadLayer()
	self:open()
	self:initData()
end

function LimitShopCtr:initData()
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	
	self:updateLayer()
end

function LimitShopCtr:updateLayer()
	if not self:getLayer() then
		return
	end
	local layer = self.layer

end

return LimitShopCtr


