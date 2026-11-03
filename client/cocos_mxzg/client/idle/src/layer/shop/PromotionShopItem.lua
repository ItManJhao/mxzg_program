-- 
local PromotionShopItem = class("PromotionShopItem", require("src.comp.LuaLayerBase"))

function PromotionShopItem:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
end

function PromotionShopItem:setTableView(tableView)
	for i=1,3 do
		self["menu_" .. i]:setIsTouchInsideNode(tableView)
		self["menu_" .. i]:setSwallowsTouches(false)
	end
end

function PromotionShopItem:onclickItem(tag, pSender)
    ex.Tools:showItemInfo(tag, pSender)
end

function PromotionShopItem:onclick(tag, pSender)

    local conf = self.data[tag]

    local can_buy 
	if conf.buy_limit == 0 then 
		can_buy = true
	else
		can_buy = conf.limit.count > conf.limit.times
	end

	if not can_buy then
		ex.MessageView:add(ex.Tools:getLang(41112)) 
		return 
	end

	local need_item = conf.need
	can_buy = ex.Player:getItemNum(need_item.item_type) >= need_item.item_num
	if not can_buy then
		ex.Tools:showEnoughTip(need_item.item_type, true)
		return 
	end

	local item_data = conf.goods
	local content = ex.Tools:getLang(1104)
	local need_item_str = ex.StringUtil.getScientificNumber(need_item.item_num) --or string.format("%d", need_item.item_num)
	-- content = string.format(content,need_item.item_num,ex.Tools:getLang(need_item.item_type),ex.Tools:getLang(item_data.item_type),item_data.item_num)
	content = string.format(content,need_item_str, ex.Tools:getLang(cfg.item.item[need_item.item_type].name),ex.Tools:getLang(cfg.item.item[item_data.item_type].name),item_data.item_num)

	local function callback(num)
		conf.limit.times = conf.limit.times + num
		if  conf.buy_callback then 
			conf.buy_callback(conf.index, num)
		end
	end

	if GUIDE_STEP_CONTROL == "skip" then
		callback()
	else
		-- require("src.layer.ConfirmCtr"):instance():openWindow(title, content, callback,confirm_str,cancel_str)

		local limit_num = -1
		if conf.limit.count > 0 then
			limit_num = conf.limit.count - conf.limit.times
		end
		require("src.layer.ItemSelectCtr"):instance():openWindow(ex.Tools:getLang(41228), item_data, callback, need_item, limit_num)
	end


end

function PromotionShopItem:reset(data)
	self.data = data
	for i=1,3 do
		self["node_" .. i]:setVisible(self.data[i] ~= nil) 
        if self.data[i] ~= nil then 
            local conf = data[i]

			self["node_" .. i]:setVisible(conf ~= nil) 

            if conf ~= nil then
				local item_data = conf.goods
				
				self["lbl_item_name_" .. i]:setString(ex.Tools:getLang(cfg.item.item[item_data.item_type].name))

				local need_item = conf.need
				self["node_" .. i]:setVisible(need_item ~= nil) 

				self["lbl_count_" .. i]:setVisible(conf.limit.count > 0) 
				self["spr_sold_out_" .. i]:setVisible(conf.limit.count <= conf.limit.times) 
				if conf.limit.count > 0 then 
					local str = ex.Tools:getLang(2308) .. conf.limit.times .. "/" .. conf.limit.count
					self["lbl_count_" .. i]:setString(str) 
				end

				local x,y = self["node_item_" .. i]:getPosition()
				self["menu_"..i]:removeAllChildren()
 
				self.item = ex.Tools:createBackpackItem(item_data.item_type,item_data.item_num)
				self["menu_"..i]:addChild(self.item)
				self.item:setScale(0.8)
				self.item:setPosition(x,y)
				self.item:registerScriptTapHandler(handler(self,self.onclickItem))
				self.item:setLocalZOrder(10)

				if conf.limit.count > 0 and conf.limit.count <= conf.limit.times then
					self.item:setGrayed()
				end
				
				local btn = cpp.UIMenuItemLabel:create("button/btn-old-1.png", "", " ", nil)
				self["menu_"..i]:addChild(btn)
				btn:setPosition(94, 68)
				btn:registerScriptTapHandler(handler(self,self.onclick))
				btn:setTag(i)
				btn:setLabelSize(48)
				btn:setLabelColor(cc.c3b(141, 89, 58))
				btn:setLabelText(ex.StringUtil.getScientificNumber(need_item.item_num))
				ex.Tools:addImgToUIMenuItemLabel(btn, nil, string.format("%s.png", cfg.item.item[need_item.item_type].icon), 0.4, 2)
				if need_item ~= nil then
					--self["lbl_price_" .. i]:setString(need_item.item_num)
					-- self["lbl_price_" .. i]:setString(ex.StringUtil.getScientificNumber(need_item.item_num))
					-- self["sp_price_" .. i]:setSpriteFrame(string.format("%s.png", cfg.item.item[need_item.item_type].icon))
				end

				self["bg_new_" .. i]:setVisible(false)
			else
				print(self.__cname,data[i].idx,data[i].type,"is nil")
			end
		end
	end
end

return PromotionShopItem