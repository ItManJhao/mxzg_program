local ShopLayer = class("ShopLayer", require("src.comp.EventLayer"))

function ShopLayer:onCreate()

	local size = self.spr_bg:getContentSize()
	size.width = size.width - 20
	size.height = size.height - 20
	self:resetScaleAtWidth()
	self:addBlackBackground()

	self.tableView = ex.Tools:initTableView(self.spr_bg, {}, {require("src.layer.shop.ShopItemCell"),"ccbi/ShopItemCell.ccbi"}, size, 5 , cc.p(10,10))
	
	if self.btn_refresh ~= nil then
		self.btn_refresh:registerScriptTapHandler(handler(self,self.onRefresh))

		self.lbl_btn_refresh = require("src.comp.RichTextEx"):create()
		:setFontSize(20)
		:setFontFace(FONT_DEFAULT_NAME_BOLD)
		:setAnchorTextShadow(true)
		:setWrapMode(1)
	
		self.btn_refresh:addChild(self.lbl_btn_refresh)
	
		self.lbl_btn_refresh:setPosition(self.btn_refresh:getContentSize().width * 0.5 ,self.btn_refresh:getContentSize().height * 0.5)
	end

	self:addEvent(EVENT.SHOP_EVENT.UPDATE,handler(self,self.onChangeView))

	self.lbl_name:enableOutline(cc.c4b(84,63,34,255), 4)
end

function ShopLayer:onChangeView(event,data)
	print(self.__cname,event)

	local offsetY = self.tableView:getContainer():getPositionY()
    
	local data = ex.Player.market_data:getMarketDataByType(self.shop_type)
	self:updateView(data)
	self.tableView:setContentOffset(cc.p(0,offsetY))
end

function ShopLayer:addTime()
	self:removeTimerByName("time")
	self:addTimer("time",1000,handler(self,self.changeTime),true)
end

function ShopLayer:changeTime()

	if self.shop_type == SHOP_TYPE.TEAMARENA then 
		return 
	end 


	local end_time = ex.Player.market_data:getEndTimeByType(self.shop_type)
	local cur_time = ex.Game:getServerTime()
	local remaining_time = end_time - cur_time
	self.lbl_time:setVisible(remaining_time > 0 and cfg.shopcontrol.shop[self.shop_type].show_time > 0)
	if remaining_time <= 0 then 
		self:removeTimerByName("time")
		return 
	end

	self.lbl_time:setString(string.format(ex.Tools:getLang(2605),
	   math.floor(remaining_time / 3600),
	   math.floor(remaining_time / 60 % 60),
	   math.floor(remaining_time % 60)))
	-- self.lbl_time:setString()
end

function ShopLayer:updateBtnStatus()
	local free_refresh = ex.Player.market_data:getFreeRefreshNumByType(self.shop_type)
	local charge_refresh = ex.Player.market_data:getChargeRefreshNumByType(self.shop_type)
	local charge_item = ex.Player.market_data:ChargeItemCostyType(self.shop_type)
	print(free_refresh,charge_refresh,">>>>>")

	if self.btn_refresh ~= nil then
		local str = ""
		local btn_status = false
	
		local conf = cfg.shopcontrol.shop[self.shop_type]
		if free_refresh > 0 then 
			str = string.format(ex.Tools:getLang(47291),free_refresh,conf.max_refresh_count)
			btn_status = true
		elseif charge_refresh > 0 then 
			str = string.format(ex.Tools:getLang(47465),charge_item.item_type,charge_item.item_num)
			btn_status = ex.Player:getItemNum(charge_item.item_type) >= charge_item.item_num

		elseif free_refresh == 0 and charge_refresh == 0 then 
			self.btn_refresh:setEnabled(false)
			str = ex.Tools:getLang(47018)
		else
			str = ex.Tools:getLang(47018)
		end
		
		-- local charge_item = ex.Player.market_data:ChargeItemCostyType(self.shop_type)
		
		self.lbl_btn_refresh:setXmlTextLua(str)
	end

end

function ShopLayer:updateRes()
	local charge_item = ex.Player.market_data:ChargeItemCostyType(self.shop_type)
	local conf = cfg.shopcontrol.shop[self.shop_type]

	self.res_node:setVisible(conf.cost_item ~= "")
	if not conf or conf.cost_item == "" then return end

	self.spr_icon:setSpriteFrame(string.format("backpack/%d.png", conf.cost_item))
	local num = ex.Player:getItemNum(conf.cost_item)
	self.lbl_num:setString(num)
end

function ShopLayer:onRefresh(tag,pSender)

	local res_refresh = Shop_pb.GReqShopRefresh()
	res_refresh.type = self.shop_type
	NetManager:sendMessage(ProtocolID.GReqShopRefresh,res_refresh)
end


function ShopLayer:updateRefreshMax( )
	if self.shop_type == SHOP_TYPE.TEAMARENA then 
		local conf = cfg.shopcontrol.shop[self.shop_type]
		local rechage_refresh_max = conf.daily_charge_refresh
		local rechage_refresh_num = ex.Player.market_data:getChargeRefreshNumByType(self.shop_type)

		self.lbl_limit_time:setString(string.format(ex.Tools:getLang(47398),rechage_refresh_max - rechage_refresh_num,rechage_refresh_max))
		self.lbl_time:setVisible(false)
	else
		if self.lbl_limit_time then 
			self.lbl_limit_time:setString("")
		end 
	end 
end

--获取 X 星级英雄的个数
function ShopLayer:getHeroNum(star_num)
	if star_num == 0  then
		return 0
	end
	local hero_list = ex.Player.hero_data:getHeroList()
	local hero_num = 0
	for i,v in ipairs(hero_list) do
		if v.star >= star_num then
			hero_num = hero_num + 1
		end
	end
	return hero_num
end

function ShopLayer:updateView(data)
	if not self.shop_type then
		for _,v in pairs(data) do
			self.shop_type = v.type
			break
		end
	end
	self.conf = ex.Player.market_data.cfg[self.shop_type]

	local shop_list = {}
	local cur_player_level = ex.Player.level
	for k,v in pairs(data) do
		local config = self.conf[v.idx]	
		if v.type == 102400 then
			local hero_num = self:getHeroNum(config.hero_star)
			if (config == nil or config.appear_level == nil or cur_player_level >= config.appear_level) and hero_num >= config.hero_num then
				table.insert(shop_list,v)
			end
		else
			if config == nil or config.appear_level == nil or cur_player_level >= config.appear_level then
				table.insert(shop_list,v)
			end
		end
	
	end
	local function sor(a,b)
		return a.idx < b.idx		
	end
	table.sort(shop_list,sor)
	
	local tmp_data = {}
	local idx = 1
	local count = 0
	for i,v in ipairs(shop_list) do
		if not tmp_data[idx] then tmp_data[idx] = {} end
		table.insert(tmp_data[idx],v)
		count = count + 1 
		if count % 3 == 0 then 
			idx = idx + 1
		end
	end

	self.data = tmp_data 

	self.tableView:initData(self.data)

	self:updateRes()

	local show_time = false
	if cfg.shopcontrol.shop[self.shop_type] then 
		show_time = cfg.shopcontrol.shop[self.shop_type].auto_refresh_mode > 0 and cfg.shopcontrol.shop[self.shop_type].show_time > 0
		if self.btn_refresh ~= nil then
			show_btn = cfg.shopcontrol.shop[self.shop_type].manual_refresh_mode > 0
			self.btn_refresh:setVisible(show_btn)
		end
	end

	
	self.lbl_time:setVisible(show_time)

	self:updateBtnStatus()

	if cfg.shopcontrol.shop[self.shop_type].show_time > 0 then
		self:addTime()
	end

	self:updateRefreshMax( )

end

return ShopLayer