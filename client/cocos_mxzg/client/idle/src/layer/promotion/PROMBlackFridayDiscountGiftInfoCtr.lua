local PROMBlackFridayDiscountGiftInfoCtr = class("PROMBlackFridayDiscountGiftInfoCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PROMBlackFridayDiscountGiftInfoLayer = class("PROMBlackFridayDiscountGiftInfoLayer", require("src.comp.LuaLayerBase"))
local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")
function PROMBlackFridayDiscountGiftInfoLayer:onCreate()
	self:addBlackBackground()
	self:registerBtnEvent()
end

function PROMBlackFridayDiscountGiftInfoLayer:inidata(data)
	
	self.item_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()
	self.item_size = cc.size(self.item_size.width * ex.s.global_scale , self.item_size.height * ex.s.global_scale + 17 * math.max(1, ex.s.global_scale))

	
	-- self.scroll_view:setContentSize(cc.size(#data * self.item_size.width+20,self.spr_box:getContentSize().height))
	-- self.scroll_view:setPositionX(self.lbl_title:getPositionX())
	self.scroll_view:setItemSize(cc.size(self.item_size.width+20, self.item_size.height + 40))
	-- self.scroll_view:setItemType(1)
	self.scroll_view:setAlignmentCenter(true)

	-- 繁体适配注释 别的版本就解除掉
	--ex.Tools:setLimitWidth(self.lbl_title, 140)
	--ex.Tools:setLimitWidth(self.btn_award:getLabel(), 100)
	--------------------------------------
	

	self:updateScrollView(data)

end

function PROMBlackFridayDiscountGiftInfoLayer:updateScrollView(vec_data)
	self.scroll_view:setLoaded(false)

    
    self.scroll_view.createItemFunction = function(item_data, scale, index, pos)
		local item = nil
		if item_data ~= nil then
			item = UIItemBackpack:createWithData(item_data.item_type, item_data.item_num)
			item:setScale(scale * ex.s.global_scale)
			item:registerScriptTapHandler(handler(self, self.onShowInfo))
		end
        return item
    end
    self.scroll_view:reloadData(vec_data)
end

function PROMBlackFridayDiscountGiftInfoLayer:onShowInfo(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

-- 关闭按钮
function PROMBlackFridayDiscountGiftInfoLayer:registerBtnEvent( )
	local ctr = PROMBlackFridayDiscountGiftInfoCtr:instance()
	self.btn_close:registerScriptTapHandler(handler(ctr, ctr.closeWindow))
	self.btn_award:registerScriptTapHandler(handler(ctr, ctr.closeWindow))
end
-----------------------------------------------------------------------------
function PROMBlackFridayDiscountGiftInfoCtr:onCreate()
	self:setCCBIPath("ccbi/PROMBlackFridayDiscountGiftInfoLayer.ccbi")
	self:setIsSingle(false)
end


function PROMBlackFridayDiscountGiftInfoCtr:getLayerClass()
	return PROMBlackFridayDiscountGiftInfoLayer
end

function PROMBlackFridayDiscountGiftInfoCtr:openWindow(data)
	if self:isOpened() then
		return
	end

	self.callback = callback or nil
	self:loadLayer()
	self:open()
	self.layer:inidata(data)
end

return PROMBlackFridayDiscountGiftInfoCtr

