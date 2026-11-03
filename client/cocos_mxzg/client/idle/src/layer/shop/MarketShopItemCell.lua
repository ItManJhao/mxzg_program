local MarketShopItemCell = class("MarketShopItemCell", require("src.comp.LuaLayerBase"))

function MarketShopItemCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	self.show_discount_list = {}
	for i=1,3 do
		self:reorderChild(self["spr_sold_out_"..i], 100)
		self["spr_sold_out_"..i]:setVisible(false)
	end
end

function MarketShopItemCell:setTableView(tableView)
	for i=1,3 do
		self["menu_" .. i]:setIsTouchInsideNode(tableView)
		self["menu_" .. i]:setSwallowsTouches(false)

	end
end

function MarketShopItemCell:onclickItem(tag,pSender)
	ex.Tools:showItemInfo(tag, pSender)
end

function MarketShopItemCell:onclick(tag,pSender)
	local conf = ex.Player.market_data:getMarketItemCfg(self.data[tag].type,self.data[tag].idx)
	local can_buy
	if conf.buy_limit == 0 then 
		can_buy = true
	else
		can_buy = conf.buy_limit > self.data[tag].buy_num
	end

	if not can_buy then
		ex.MessageView:add(ex.Tools:getLang(41112)) 
		return 
	end


	local need_item = conf.need_item[1]
	can_buy = ex.Player:getItemNum(need_item.item_type) >= need_item.item_num
	if not can_buy then
		ex.Tools:showEnoughTip(need_item.item_type, true)
		return 
	end

	-- local item_data = conf.item_type[1]
	-- local content = ex.Tools:getLang(1104)
	-- local need_item_str = ex.StringUtil.getScientificNumber(need_item.item_num)
	-- -- content = string.format(content,need_item.item_num,ex.Tools:getLang(need_item.item_type),ex.Tools:getLang(item_data.item_type),item_data.item_num)
	-- content = string.format(content,need_item_str, ex.Tools:getLang(cfg.item.item[need_item.item_type].name),ex.Tools:getLang(cfg.item.item[item_data.item_type].name),item_data.item_num)

	local function callback( num )
		if self.data[tag].type == SHOP_TYPE.ORDER then
			if not ex.Player.promotion_data:getTimeIsOpen(42) then	-- promotionPros.gReqPromotionSacrificeShop.id
				ex.MessageView:add(ex.Tools:getLang(47324))
				return
			end

			local res_buy = Promotion042_pb.GReqShopBuySacrifice()
			res_buy.idx = self.data[tag].idx 
			NetManager:sendMessage(ProtocolID.GReqShopBuySacrifice,res_buy)
		else
			local res_buy = Shop_pb.GReqShopBuy()
			-- print("buy num :" .. num)
			res_buy.idx = self.data[tag].idx 
			res_buy.type = self.data[tag].type 
			res_buy.buy_times = num or 1
			NetManager:sendMessage(ProtocolID.GReqShopBuy,res_buy)
		end 
	end

	if GUIDE_STEP_CONTROL == "skip" then
		callback()
	else
		local conf = ex.Player.market_data:getMarketItemCfg(self.data[tag].type,self.data[tag].idx)
		dump(conf)
		local item = {}
		item.item_type = conf.item_type[1].item_type
		item.item_num = conf.item_type[1].item_num
		local item_price = {}
		item_price.item_type = conf.need_item[1].item_type
		item_price.item_num = conf.need_item[1].item_num
		local limit_num = -1
		if conf.buy_limit > 0 then
			limit_num = conf.buy_limit - self.data[tag].buy_num
		end
		require("src.layer.ItemSelectCtr"):instance():openWindow(ex.Tools:getLang(41228), item, callback, item_price, limit_num)
	end

	

end

function MarketShopItemCell:reset(data)

	local sfc = cc.SpriteFrameCache:getInstance() 
	sfc:addSpriteFrames("ccbi-res/shop-lang.plist")
	
	for i=1,3 do
		self["spr_sold_out_"..i]:setVisible(false)
	end

	self.data = data
	for i=1,3 do
		self["node_" .. i]:setVisible(self.data[i] ~= nil) 
		if self.data[i] ~= nil then 
			local conf = ex.Player.market_data:getMarketItemCfg(data[i].type,data[i].idx)

			if self.show_discount_list[i] then 
				self.show_discount_list[i]:setVisible(false) 
				self.show_discount_list[i]:removeAllChildren()
			end 

			self["node_" .. i]:setVisible(conf ~= nil) 
			if conf ~= nil then
				local item_data = conf.item_type[1]
				

				local need_item = conf.need_item[1]
				self["node_" .. i]:setVisible(need_item ~= nil) 
				if need_item ~= nil then
					self["lbl_price_" .. i]:setString(ex.StringUtil.getScientificNumber(need_item.item_num))
					
					self["sp_price_" .. i]:setSpriteFrame(string.format("%s.png", cfg.item.item[need_item.item_type].icon))
				end

                self["lbl_price_" .. i]:enableOutline(cc.c4b(74, 41, 33, 255), 2)
				if conf.buy_limit > 0 then 
					local str = ex.Tools:getLang(2308) .. self.data[i].buy_num .. "/" .. conf.buy_limit

					if self.data[i].buy_num >= conf.buy_limit then
						self["spr_sold_out_"..i]:setVisible(true)
					end
				end

				-- self["is_time_" .. i]:setVisible(conf.is_time)

				local x,y = self["node_item_" .. i]:getPosition()
				self["menu_"..i]:removeAllChildren()

				self.item = ex.Tools:createBackpackItem(item_data.item_type,item_data.item_num)
				self["menu_"..i]:addChild(self.item)
				self.item:setScale(1)
				self.item:setPosition(x,y)
				self.item:registerScriptTapHandler(handler(self,self.onclickItem))
				self.item:setLocalZOrder(10)

				if conf.buy_limit > 0 and self.data[i].buy_num >= conf.buy_limit then
					self.item:setAllGray(true)
				end
				
				local btn = cpp.UIMenuItemLabel:create("shop/spr-taizi.png", "", "", nil)
				self["menu_"..i]:addChild(btn)
				btn:setPosition(94, 65)
				btn:registerScriptTapHandler(handler(self,self.onclick))
				btn:setTag(i)
				
				--是否有打折
				if conf.discount and conf.discount > 0 and conf.discount < 100 then
					local discount = conf.discount
					if not self.show_discount_list[i] then 
						self.show_discount_list[i] = cc.Sprite:createWithSpriteFrameName("other/spr-discount-bg.png")
						self.show_discount_list[i]:setPosition(self.item:getPositionX() - self.item:getContentSize().width * 0.5 - 5, self.item:getPositionY() + self.item:getContentSize().height * 0.5 - 28)
						self.show_discount_list[i]:setScale(0.9)
						self["node_" .. i]:addChild(self.show_discount_list[i])
					else 
						self.show_discount_list[i]:setVisible(true) 
					end 

					if math.floor(discount / 10) == discount / 10 then
						discount = math.floor(discount / 10)
					end
		
					local lbl_discount_1 = cc.Label:createWithTTF(tostring(discount), FONT_DEFAULT_NAME_BOLD, 60)
					lbl_discount_1:setScale(0.5)
					:setColor(cc.c4b(255,238,145,255))
					:enableOutline(cc.c4b(190, 0, 0, 255), 2)
					lbl_discount_1:setPosition(self.show_discount_list[i]:getContentSize().width / 2 - 10, self.show_discount_list[i]:getContentSize().height / 2 + 5)
					self.show_discount_list[i]:addChild(lbl_discount_1)
		
					local lbl_discount_2 = cc.Label:createWithTTF(ex.Tools:getLang(47553), FONT_DEFAULT_NAME_BOLD, 44)
					lbl_discount_2:setScale(0.5)
					:setColor(cc.c4b(255,255,255,255))
					:enableOutline(cc.c4b(190, 0, 0, 255), 2)
					lbl_discount_2:setPosition(self.show_discount_list[i]:getContentSize().width / 2 + 10, self.show_discount_list[i]:getContentSize().height / 2 - 5)
					self.show_discount_list[i]:addChild(lbl_discount_2)

					local must = cfg.system.shop_must_buy_item_type
					local must_min = cfg.system.shop_must_min
					local must_max = cfg.system.shop_must_max
					local recommend_min = cfg.system.shop_recommend_min
					local recommend_max = cfg.system.shop_recommend_max
					local res_type = cfg.system.shop_res_type
					if must == conf.item_type[1].item_type then 
						if conf.discount >= must_min and conf.discount <= must_max then 
							local tag = cc.Sprite:createWithSpriteFrameName("shop-lang/spr-type-1.png")
							--self["bg_new_" .. i]:addChild(tag)
							--tag:setPosition(self["bg_new_" .. i]:getContentSize().width - 15,self["bg_new_" .. i]:getContentSize().height - 10)
						end
					elseif conf.need_item[1].item_type == res_type then 

						if conf.discount >= recommend_min and conf.discount <= recommend_max then 
							local tag = cc.Sprite:createWithSpriteFrameName("shop-lang/spr-type-2.png")
							--self["bg_new_" .. i]:addChild(tag)
							--tag:setPosition(self["bg_new_" .. i]:getContentSize().width - 15,self["bg_new_" .. i]:getContentSize().height - 10)
						end
					end

				else 

				end
		

			else
				print(self.__cname,data[i].idx,data[i].type,"is nil")
			end
		end
	end
end

return MarketShopItemCell