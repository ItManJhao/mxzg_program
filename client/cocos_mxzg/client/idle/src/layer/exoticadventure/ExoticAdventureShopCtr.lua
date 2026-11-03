--[[
* @Description: 异界冒险-土著商人
* @Author: 熊梦
* @Date: 2020-08-5 14:00:00
* ]]
local ExoticAdventureShopCtr = class("ExoticAdventureShopCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ExoticAdventureShopLayer = class("ExoticAdventureShopLayer", require("src.comp.EventLayerAdaptiveWidthFull"))

local ExoticAdventureShopCell = class("ExoticAdventureShopCell", require("src.comp.LuaLayerBase"))

function ExoticAdventureShopCell:onCreate()
	self:setAutoClose(false)
    self:setSwallowTouches(false)
end

function ExoticAdventureShopCell:initData(data)
	for i=1,3 do
		self["spr_sold_out_"..i]:setVisible(false)
	end
	self.data = data
	for i=1,3 do
		self["node_" .. i]:setVisible(data[i] ~= nil) 
		if data[i] ~= nil then 

			self["node_" .. i]:setVisible(data[i] ~= nil) 
			if data[i] ~= nil then
				local item_data = data[i].reward[1]

				local need_item = data[i].cost[1]
				self["node_" .. i]:setVisible(need_item ~= nil) 
				if need_item ~= nil then
					self["lbl_price_" .. i]:setString(ex.StringUtil.getScientificNumber(need_item.item_num))
					
					self["sp_price_" .. i]:setSpriteFrame(string.format("%s.png", cfg.item.item[need_item.item_type].icon))
				end

                self["lbl_price_" .. i]:enableOutline(cc.c4b(74, 41, 33, 255), 2)
				if data[i].buy_limit > 0 then 
					local str = ex.Tools:getLang(2308) .. data[i].buy_num .. "/" .. data[i].buy_limit

					if data[i].buy_num >= data[i].buy_limit then
						self["spr_sold_out_"..i]:setVisible(true)
					end
				end

				self["lbl_limit_" .. i]:setString(string.format(ex.Tools:getLang(47213),data[i].buy_num,data[i].buy_limit))
				-- self["is_time_" .. i]:setVisible(conf.is_time)

				local x,y = self["node_item_" .. i]:getPosition()
				self["menu_"..i]:removeAllChildren()

				self.item = ex.Tools:createBackpackItem(item_data.item_type,item_data.item_num)
				self["menu_"..i]:addChild(self.item)
				self.item:setScale(1)
				self.item:setPosition(x,y)
				self.item:registerScriptTapHandler(handler(self,self.onclickItem))
				self.item:setLocalZOrder(10)
				self.item.box_reward = data[i].box_reward

				if data[i].buy_limit > 0 and data[i].buy_num >= data[i].buy_limit then
					self.item:setAllGray(true)
				end
				
				local btn = cpp.UIMenuItemLabel:create("shop/spr-taizi.png", "", "", nil)
				self["menu_"..i]:addChild(btn)
				btn:setPosition(94, 65)
				btn:registerScriptTapHandler(handler(self,self.onclick))
				btn:setTag(i)
				btn.idx = data[i].idx
				btn.buy_limit = data[i].buy_limit
				btn.buy_num = data[i].buy_num
				btn.need_item =  need_item
			else
				print(self.__cname,data[i].idx,data[i].type,"is nil")
			end
		end
	end
end

function ExoticAdventureShopCell:onclickItem(tag,pSender)
	--ex.Tools:showItemInfo(tag, pSender)
	if pSender.box_reward ~= nil then
		require("src.layer.exoticadventure.ExoticAdventureBackpackInfoCtr"):instance():openWindow(pSender.item_type,pSender.box_reward)
		--ex.Tools:onClickItemInfo(pSender.box_reward[1].item_type)
	else
		ex.Tools:onClickItemInfo(pSender.item_type)
	end
end

function ExoticAdventureShopCell:onclick(tag,pSender)
	if pSender.buy_num >= pSender.buy_limit then
		ex.MessageView:add(ex.Tools:getLang(76584))
		return
	end
	ex.ConfirmCtr:openWindow(ex.Tools:getLang(76818), string.format(ex.Tools:getLang(76585), pSender.need_item.item_type, pSender.need_item.item_num), function()
		-- 购买
		local req = SpaceTimeAdventure_pb.GReqSpaceTimeShopBuy()
		req.idx = pSender.idx
		NetManager:sendMessage(ProtocolID.GReqSpaceTimeShopBuy, req)
	end)
end

---------------------------------------------------------------------------------


function ExoticAdventureShopLayer:onCreate()
	self:addBlackBackground()
	self:registerBtnEvent()
	self:inidata()
end

function ExoticAdventureShopLayer:inidata()
	self:addEvent(EVENT.EXOTICADVENTURE.SHOP,handler(self,self.updateStarView))

    self.scroll_view:setViewSize(cc.size(self.scroll_view:getViewSize().width, self.scroll_view:getViewSize().height - require("src.model.Game"):instance():getNotchHeight()))
	self.scroll_view:setPosition(self.spr_kuang:getPositionX() / 2 -117,(self.spr_kuang:getPositionY() - 280))
	
	self.scroll_view:setItemSize(cc.size(590, 242))
	self.scroll_view:setItemType(1)
	
	self:updateStarView()
end

function ExoticAdventureShopLayer:updateStarView(event, idx)
	if idx ~= nil then
		local reward = {}
			for index,value in pairs(cfg.spacetimeshop.spacetimeshop) do
				if value.idx == idx then
					for g,h in pairs(cfg.spacetimebox.spacetimebox) do
						if h.idx == value.box_id then
							reward = h.reward
							break
						end
					end
				end
			end
		require("src.layer.ItemRewardCtr"):instance():openWindow(reward)
	end
	self.scroll_view:getContainer():removeAllChildren()
	
	local tmp_data = {}
	local idx = 1
	local count = 0
	local shop_list = {}
	
	for k,v in pairs(ex.Player.exotic_adventure_data.shop_list) do
		for index,value in pairs(cfg.spacetimeshop.spacetimeshop) do
			if v.idx == value.idx then
				local data = {}
				data.idx = v.idx
				data.buy_num = v.buy_num
				data.reward =  value.reward
				data.cost =  value.cost
				data.buy_limit = value.buy_limit
				data.box_reward = {}
				for g,h in pairs(cfg.spacetimebox.spacetimebox) do
					if h.idx == value.box_id then
						data.box_reward = h.reward
						break
					end
				end
				table.insert( shop_list, data )
			end
		end
	end

	for i,v in ipairs(shop_list) do
		if not tmp_data[idx] then tmp_data[idx] = {} end
		table.insert(tmp_data[idx],v)
		count = count + 1 
		if count % 3 == 0 then 
			idx = idx + 1
		end
	end
	self.list_data = tmp_data 



	self.scroll_view.createItemFunction = function(data, scale)
        -- 创建ccbi cell
        local cell_layer = ExoticAdventureShopCell:createWithCCBIFile("ccbi/ExoticAdventureShopCell.ccbi")
        cell_layer:setIgnoreAnchorPointForPosition(false)
        cell_layer:setAnchorPoint(0.5, 0.5)
        cell_layer:setScale(scale)
		cell_layer:initData(data)
		for i = 1,3 do
			cell_layer["menu_"..i]:setIsTouchInsideNode(self.scroll_view)
		end
        return cell_layer
    end

    self.scroll_view:reloadData(self.list_data)
	
end


-- 关闭按钮
function ExoticAdventureShopLayer:registerBtnEvent( )
	local ctr = ExoticAdventureShopCtr:instance()
	self.btn_close:registerScriptTapHandler(handler(ctr, ctr.closeWindow))
end

function ExoticAdventureShopLayer:addShopCell(shop_data)
    local cell = ExoticAdventureShopCell:createWithCCBIFile("ccbi/ExoticAdventureShopCell.ccbi")
	cell:setSwallowTouches(false)
	cell:setIgnoreAnchorPointForPosition(false)
    cell:setAnchorPoint(ex.a.center)

    cell:reset(shop_data)
	return cell
end

-----------------------------------------------------------------------------
function ExoticAdventureShopCtr:onCreate()
	self:setCCBIPath("ccbi/ExoticAdventureShopLayer.ccbi")
	self:setIsSingle(false)
end

function ExoticAdventureShopCtr:getLayerClass()
	return ExoticAdventureShopLayer
end

function ExoticAdventureShopCtr:getAchievementLayer()
	return self.layer
end

function ExoticAdventureShopCtr:openWindow()
	if self:isOpened() then
		return
	end
	self:loadLayer()
	self:open()
end

function ExoticAdventureShopCtr:initData()

end

return ExoticAdventureShopCtr
