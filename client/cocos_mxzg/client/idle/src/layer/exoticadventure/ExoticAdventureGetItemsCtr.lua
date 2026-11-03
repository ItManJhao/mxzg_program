--[[
* @Description: 异界冒险-随机事件-获得道具界面
* @Author: 熊梦
* @Date: 2020-08-3 16:00:00
* ]]
local ExoticAdventureGetItemsCtr = class("ExoticAdventureGetItemsCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ExoticAdventureGetItemsLayer = class("ExoticAdventureGetItemsLayer", require("src.comp.EventLayerAdaptiveWidthFull"))

local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function ExoticAdventureGetItemsLayer:onCreate()
	self:addBlackBackground()
	self:registerBtnEvent()
	self:inidata()
end

function ExoticAdventureGetItemsLayer:inidata()
	local event_type = ex.Player.exotic_adventure_data.event_type
	local event_data = ex.Player.exotic_adventure_data.event[event_type][1]

	self.item_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()
	self.item_size = cc.size(self.item_size.width * ex.s.global_scale , self.item_size.height * ex.s.global_scale + 17 * math.max(1, ex.s.global_scale))

	self.scroll_view:setContentSize(cc.size(self.spr_box:getContentSize().width,self.spr_box:getContentSize().height))
	self.scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	self.scroll_view:setItemSize(cc.size(self.scroll_view:getContentSize().width, self.item_size.height + 40))
	self.scroll_view:setItemOffset(cc.p(0, 5))
--	self.scroll_view:setAutoFull(true)
  --  self.scroll_view:setCreateNum(4)

	local vec_data = {}
	for k,v in pairs(event_data.item_list) do
		local data = {}
		data.item_type = v.type
		data.item_num = v.num
		data.reward = nil
		-- 对箱子物资做特殊的处理
		if v.id ~= 0 then
			for index,value in pairs(cfg.spacetimebox.spacetimebox) do
				if value.idx == v.id then
					data.reward = value.reward
					break
				end
			end
		end
		table.insert( vec_data, data)
	end

	self:updateScrollView(vec_data)
end

function ExoticAdventureGetItemsLayer:updateScrollView(vec_data)
	self.scroll_view:setLoaded(false)

    
    self.scroll_view.createItemFunction = function(item_data, scale, index, pos)
		local item = nil
		if item_data ~= nil then
			item = UIItemBackpack:createWithData(item_data.item_type, item_data.item_num)
			item:setScale(scale * ex.s.global_scale)
			item.reward = nil
			if item_data.reward ~= nil then
				item.reward = item_data.reward 
			end
			item:registerScriptTapHandler(handler(self, self.onShowInfo))
		else
			-- item = UIItemBackpack:createWithData(0, 0)
            -- item:setScale(scale * ex.s.global_scale)
		end
        return item
    end
    self.scroll_view:reloadData(vec_data)
end

function ExoticAdventureGetItemsLayer:onShowInfo(tag, pSender)
	if pSender.reward ~= nil then
		require("src.layer.exoticadventure.ExoticAdventureBackpackInfoCtr"):instance():openWindow(pSender.item_type,pSender.reward)
	else
		ex.Tools:onClickItemInfo(pSender.item_type)
	end
end

-- 关闭按钮
function ExoticAdventureGetItemsLayer:registerBtnEvent( )
	local ctr = ExoticAdventureGetItemsCtr:instance()
	self.btn_close:registerScriptTapHandler(handler(ctr, ctr.closeWindow))
end

function ExoticAdventureGetItemsLayer:onSure(tag,pSender)
	local ctr = ExoticAdventureGetItemsCtr:instance()
	ctr:closeWindow()
end

-----------------------------------------------------------------------------
function ExoticAdventureGetItemsCtr:onCreate()
	self:setCCBIPath("ccbi/ExoticAdventureGetItemsLayer.ccbi")
	self:setIsSingle(false)
end

function ExoticAdventureGetItemsCtr:getLayerClass()
	return ExoticAdventureGetItemsLayer
end

function ExoticAdventureGetItemsCtr:getAchievementLayer()
	return self.layer
end

function ExoticAdventureGetItemsCtr:openWindow()
	if self:isOpened() then
		return
	end
	self:loadLayer()
	self:open()
end

function ExoticAdventureGetItemsCtr:initData()

end

return ExoticAdventureGetItemsCtr
