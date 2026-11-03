
local LimitShopItemCell = class("LimitShopItemCell", require("src.comp.EventLayer"))

function LimitShopItemCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
	
end

function LimitShopItemCell:initDone(index, goods, need)
	self.index = index
	self.goods = goods
	self.need = need

	self.menu = cpp.UIMenu:create():move(0, 0)
    self:addChild(self.menu)

    -- 物品
    self.btn_goods = ex.Player.backpack_data:createWithData(self.goods.item_type, self.goods.item_num)
	self.btn_goods:setPosition(70, 121)
	:setScale(1)
	:registerScriptTapHandler(handler(self, self.onShowInfo))
	self.menu:addChild(self.btn_goods)

    self.num_text:setString(tostring(self.need.item_num))

end

function LimitShopItemCell:payNow( tag, pSender)
    print("-=-=-=-=-=-=-=-=-=-=", pSender.item_type)
end

function LimitShopItemCell:onShowInfo(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

return LimitShopItemCell
