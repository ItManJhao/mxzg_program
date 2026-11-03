local ShopItemCell = class("ShopItemCell", require("src.comp.LuaLayerBase"))


local limit_lang = {
	[0] = 2607,
	[1] = 2608,
	[2] = 2609,
	[3] = 2610,
}

function ShopItemCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
	-- self.lbl_item_name
	-- self.sp_price
	-- self.lbl_price
	-- self.lbl_count
	-- self.spr_item_bg

	for i=1,3 do
		self:reorderChild(self["spr_sold_out_"..i], 100)
		self["spr_sold_out_"..i]:setVisible(false)
	end
end

function ShopItemCell:setTableView(tableView)
	for i=1,3 do
		self["menu_" .. i]:setIsTouchInsideNode(tableView)
		self["menu_" .. i]:setSwallowsTouches(false)

	end
end

function ShopItemCell:onclickItem(tag,pSender)
	print(self.__cname,">>>>>>>>>>>")
	ex.Tools:showItemInfo(tag, pSender)
end

function ShopItemCell:onclick(tag,pSender)
	print(self.__cname,tag,"onclick")
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

function ShopItemCell:reset(data)
	local sfc = cc.SpriteFrameCache:getInstance() 
	sfc:addSpriteFrames("ccbi-res/shop-lang.plist")
	
	self.data = data
	for i=1,3 do
		self["node_" .. i]:setVisible(self.data[i] ~= nil) 
		if self.data[i] ~= nil then 
			local conf = ex.Player.market_data:getMarketItemCfg(data[i].type,data[i].idx)
			local shop_conf = cfg.shopcontrol.shop[data[i].type]
			-- local 
			self["node_" .. i]:setVisible(conf ~= nil) 
			--dump(conf)
			if conf ~= nil then
				local item_data = conf.item_type[1]
				
				self["lbl_item_name_" .. i]:setString(ex.Tools:getLang(cfg.item.item[item_data.item_type].name))
				if self["lbl_item_name_" .. i]:getContentSize().width * self["lbl_item_name_" .. i]:getScaleX() > 170 then 
					self["lbl_item_name_" .. i]:setScale(170 / self["lbl_item_name_" .. i]:getContentSize().width)
				end

				if self.data[i].is_special ~= nil and self.data[i].is_special == true then
					self["lbl_item_name_" .. i]:setColor(cc.c3b(255,183,28))
				end

				-- self["lbl_item_name_" .. i]:setVisible(conf ~= nil) 

				local need_item = conf.need_item[1]
				self["node_" .. i]:setVisible(need_item ~= nil) 
				if need_item ~= nil then
					--self["lbl_price_" .. i]:setString(need_item.item_num)
					-- self["lbl_price_" .. i]:setString(ex.StringUtil.getScientificNumber(need_item.item_num))
					
					-- self["sp_price_" .. i]:setSpriteFrame(string.format("%s.png", cfg.item.item[need_item.item_type].icon))
				end

				local need_privilege = conf.clergy_require and conf.clergy_require > 0 or false
				local is_clergy_privilege = need_privilege and cfg.clergyprivilege.isPrivilege(CLERGY_PRIVILEGE_TYPE.STALL_SHOP, ex.Player.clergy_level) or false
				if need_privilege and not is_clergy_privilege then
					-- local lbl_active = ex.Tools:createRichText(self["lbl_count_" .. i]:getParent(), ex.Tools:getLang(49313), 20, false, cc.p(self["lbl_count_" .. i]:getPosition()))
					local lbl_active = require("src.comp.RichTextEx"):create()
					lbl_active:setFontSize(20)
					lbl_active:setFontFace(FONT_DEFAULT_NAME_BOLD)
					lbl_active:setAnchorTextShadow(false)
					lbl_active:setWrapMode(1)
					lbl_active:setPosition(self["lbl_count_" .. i]:getPosition())
					lbl_active:setXmlTextLua(ex.Tools:getLang(49313))
					lbl_active:setCallback(function(atom)
						ex.JumpManager:jumpByAtom(atom)
					end)
					self["lbl_count_" .. i]:getParent():addChild(lbl_active)
					self["lbl_count_" .. i]:setVisible(false)
				else
					local is_limit_show = conf.buy_limit > 0
					self["lbl_count_" .. i]:setVisible(is_limit_show)
					if is_limit_show then

						-- 现在这里出现特殊逻辑，组对竞技场一语双关
						if data[i].type == SHOP_TYPE.TEAMARENA then 

							local lang = shop_conf and limit_lang[shop_conf.auto_refresh_mode] or 2308
							if conf.limit_type == 0  then 
								lang = 2607
							else 
								lang = 2609
							end 

							local str = ex.Tools:getLang(lang) .. self.data[i].buy_num .. "/" .. conf.buy_limit
							self["lbl_count_" .. i]:setString(str) 
						else 
							local lang = shop_conf and limit_lang[shop_conf.auto_refresh_mode] or 2308
							local str = ex.Tools:getLang(lang) .. self.data[i].buy_num .. "/" .. conf.buy_limit
							self["lbl_count_" .. i]:setString(str) 
						end 

						if self.data[i].buy_num >= conf.buy_limit then
							self["spr_sold_out_"..i]:setVisible(true)
						end
					end
				end

				self["spr_comprehend_"..i]:setVisible(self.data[i].is_comprehend ~= nil and self.data[i].is_comprehend == true)
				
				-- self["is_time_" .. i]:setVisible(conf.is_time)
				
				local x,y = self["node_item_" .. i]:getPosition()
				self["menu_"..i]:removeAllChildren()
				
				self.item = ex.Tools:createBackpackItem(item_data.item_type,item_data.item_num)
				self["menu_"..i]:addChild(self.item)
				self.item:setScale(0.8)
				self.item:setPosition(x,y)
				self.item:registerScriptTapHandler(handler(self,self.onclickItem))
				self.item:setLocalZOrder(10)

				if conf.buy_limit > 0 and self.data[i].buy_num >= conf.buy_limit then
					self.item:setGrayed()
				end
				
				local btn = cpp.UIMenuItemLabel:create("button/btn-old-1.png", "", " ", nil)
				self["menu_"..i]:addChild(btn)
				btn:setPosition(94, 73)
				btn:registerScriptTapHandler(handler(self,self.onclick))
				btn:setTag(i)
				btn:setLabelSize(48)
				btn:setLabelColor(cc.c3b(141, 89, 58))
				btn:setLabelText(ex.StringUtil.getScientificNumber(need_item.item_num))
				ex.Tools:addImgToUIMenuItemLabel(btn, nil, string.format("%s.png", cfg.item.item[need_item.item_type].icon), 0.4, 2)
				if need_privilege and not is_clergy_privilege then
					btn:setLabelColor(FONT_WHITE_2_GRAY)
					ex.Tools:setGrayAuto(btn.spr_res, true)
					ex.Tools:setGrayAuto(btn:getNormalImage(), true)
					btn:setEnabled(false)
				end
				
				self["bg_new_" .. i]:setVisible(false)
				--是否有打折
				if conf.discount and conf.discount > 0 and conf.discount < 100 then
					local discount = conf.discount
					local spr_discount_bg = cc.Sprite:createWithSpriteFrameName("other/spr-discount-bg.png")
					spr_discount_bg:setPosition(self.item:getPositionX() - self.item:getContentSize().width * 0.5 - 5, self.item:getPositionY() + self.item:getContentSize().height * 0.5 - 28)
					spr_discount_bg:setScale(0.9)
					self["node_" .. i]:addChild(spr_discount_bg)
		
					if math.floor(discount / 10) == discount / 10 then
						discount = math.floor(discount / 10)
					end
		
					local lbl_discount_1 = cc.Label:createWithTTF(tostring(discount), FONT_DEFAULT_NAME_BOLD, 60)
					lbl_discount_1:setScale(0.5)
					:setColor(cc.c4b(255,238,145,255))
					:enableOutline(cc.c4b(190, 0, 0, 255), 2)
					lbl_discount_1:setPosition(spr_discount_bg:getContentSize().width / 2 - 10, spr_discount_bg:getContentSize().height / 2 + 5)
					spr_discount_bg:addChild(lbl_discount_1)
		
					local lbl_discount_2 = cc.Label:createWithTTF(ex.Tools:getLang(47553), FONT_DEFAULT_NAME_BOLD, 44)
					lbl_discount_2:setScale(0.5)
					:setColor(cc.c4b(255,255,255,255))
					:enableOutline(cc.c4b(190, 0, 0, 255), 2)
					lbl_discount_2:setPosition(spr_discount_bg:getContentSize().width / 2 + 10, spr_discount_bg:getContentSize().height / 2 - 5)
					spr_discount_bg:addChild(lbl_discount_2)

					local must = cfg.system.shop_must_buy_item_type
					local must_min = cfg.system.shop_must_min
					local must_max = cfg.system.shop_must_max
					local recommend_min = cfg.system.shop_recommend_min
					local recommend_max = cfg.system.shop_recommend_max
					local res_type = cfg.system.shop_res_type
					if must == conf.item_type[1].item_type then 
						if conf.discount >= must_min and conf.discount <= must_max then 
							local tag = cc.Sprite:createWithSpriteFrameName("shop-lang/spr-type-1.png")
							self["bg_new_" .. i]:addChild(tag)
							tag:setPosition(self["bg_new_" .. i]:getContentSize().width - 15,self["bg_new_" .. i]:getContentSize().height - 10)
						end
					elseif conf.need_item[1].item_type == res_type then 

						if conf.discount >= recommend_min and conf.discount <= recommend_max then 
							local tag = cc.Sprite:createWithSpriteFrameName("shop-lang/spr-type-2.png")
							self["bg_new_" .. i]:addChild(tag)
							tag:setPosition(self["bg_new_" .. i]:getContentSize().width - 15,self["bg_new_" .. i]:getContentSize().height - 10)
						end
					end
					-- if conf.discount <= 20 then 
					-- 	local tag = cc.Sprite:createWithSpriteFrameName("shop/spr-type-1.png")
					-- 	self["bg_new_" .. i]:addChild(tag)
					-- 	tag:setPosition(self["bg_new_" .. i]:getContentSize().width - 15,self["bg_new_" .. i]:getContentSize().height - 10)
					-- elseif conf.discount > must and conf.discount <= recommend then 
					-- 	local tag = cc.Sprite:createWithSpriteFrameName("shop/spr-type-2.png")
					-- 	self["bg_new_" .. i]:addChild(tag)
					-- 	tag:setPosition(self["bg_new_" .. i]:getContentSize().width - 15,self["bg_new_" .. i]:getContentSize().height - 10)
					-- end
				end


				if SHOP_TYPE.STALL == data[i].type or SHOP_TYPE.MARKET == data[i].type  then 
					self["bg_new_" .. i]:setVisible(true)
				end

			else
				print(self.__cname,data[i].idx,data[i].type,"is nil")
			end
		end
	end
end

return ShopItemCell