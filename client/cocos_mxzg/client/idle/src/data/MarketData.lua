local MarketData = class("MarketData")

function MarketData:ctor()
	self.market_list = {}				-- 商店购买次数
	self.free_refresh_list = {}			-- 免费刷新的次数
	self.charge_refresh_list = {}		-- 付费刷新的次数
	self.charge_item_cost_list = {}		-- 付费物品
	self.end_time_list = {}				-- 结束时间
	self.alter_time_limit_list = {}     -- 祭坛商城，限时数据存放

	self.last_free_time_list = {}		-- 最后刷新的时间
	self.curr_free_num_list = {}		-- 当前刷新次数
	self.need_timer_type_list = {}		-- 正在检测时间的类型
	self:initCfg()
end

function MarketData:initCfg()
	self.cfg = {}
	self.cfg[SHOP_TYPE.MARKET] 		= cfg.shopmarket.shopmarket
	self.cfg[SHOP_TYPE.WISHPOOL] 	= cfg.shopwishpool.shopwishpool
	self.cfg[SHOP_TYPE.PROPHECY] 	= cfg.shopprophecy.shopprophecy 
	self.cfg[SHOP_TYPE.SACRIFICE] 	= cfg.shopsacrifice.shopsacrifice 
	self.cfg[SHOP_TYPE.PVPNORMAL] 	= cfg.shoppvpnormal.shoppvpnormal
	self.cfg[SHOP_TYPE.CLAN] 		= cfg.shopclan.shopclan
		self.cfg[SHOP_TYPE.ADVENTURE] 	= cfg.shopadventure.shopadventure
		self.cfg[SHOP_TYPE.STALL] 		= cfg.shopstall.shopstall
		self.cfg[SHOP_TYPE.PROMOTION] 	= cfg.shoppromotion.shoppromotion 
		self.cfg[SHOP_TYPE.HERO] 		= cfg.shophero.shophero 
		self.cfg[SHOP_TYPE.CLAN_BOSS] 	= cfg.shoprunes.shopstall 
		self.cfg[SHOP_TYPE.LADDER] 		= cfg.shopladder.shopladder
		self.cfg[SHOP_TYPE.FRAGMENT] 	= cfg.shopfragment.fragment
		self.cfg[SHOP_TYPE.TALENT] 		= cfg.shoptalent.shoptalent
		self.cfg[SHOP_TYPE.FASHION] 	= cfg.shopfashion.shopfashion
		self.cfg[SHOP_TYPE.GOD_EQUIP] 	= cfg.shopgodequipment.shopgodequipment
		self.cfg[SHOP_TYPE.CHAMPION] 	= cfg.shopchampion.shopchampion
		self.cfg[SHOP_TYPE.TEAMARENA] 	= cfg.shopteamarena.shopteamarena
		self.cfg[SHOP_TYPE.SUPERHERO] 	= cfg.shopsuperhero.shopsuperhero
		self.cfg[SHOP_TYPE.DAY] 		= cfg.shopday.shopday
		self.cfg[SHOP_TYPE.SUPERSTAGE] 	= cfg.shopsuperrank.shopsuperrank
		self.cfg[SHOP_TYPE.FLOATING_ISLANDS] = cfg.shopfloatingisland.shopfloatingisland
		self.cfg[SHOP_TYPE.SPACE_TIME_MAGIC_TOWER] = cfg.shoptimetower.shoptimetower
		self.cfg[SHOP_TYPE.SHEN_YU] = cfg.shopzsjt.shopzsjt
		self.cfg[SHOP_TYPE.EXOTIC_ADVENTURE] = cfg.shopdifferentworld.shopdifferentworld
		self.cfg[SHOP_TYPE.CHRISTMAS] = cfg.shopchristmas.shopchristmas
		self.cfg[SHOP_TYPE.SPRING] = cfg.shopmakeegg.shopmakeegg
		self.cfg[SHOP_TYPE.COUNTRY_WAR_RANDOM_SHOP] = cfg.countrywarrandomshop.countrywarrandomshop
		self.cfg[SHOP_TYPE.COUNTRY_WAR_SHOP] = cfg.shopcountrywar.shopcountrywar
		self.cfg[SHOP_TYPE.ALICE_SHOP] 	= cfg.shopalice.shopalice
end

function MarketData:getCfgByType(shop_type)
	return self.cfg[shop_type]
end

function MarketData:getDataByType(shop_type)
	return self.market_list[shop_type]
end

function MarketData:setEndTimeByType(type,end_time)
	self.end_time_list[type] = end_time
end

function MarketData:getEndTimeByType(type)
	return self.end_time_list[type]
end

function MarketData:getmarketList()
	return self.market_list
end

function MarketData:getMarketItemCfg(type,idx)
	return self:getMarketItemCfgData(type,idx)
end

function MarketData:getMarketDataByItem(type,idx)
	if not self.market_list[type] then return end
	return self.market_list[type][idx]
end

function MarketData:getMarketDataByType(type)
	return self:getShopData(type)
end

function MarketData:getFreeRefreshNumByType(type)
	return self.free_refresh_list[type]
end

function MarketData:getChargeRefreshNumByType(type)
	return self.charge_refresh_list[type]
end

function MarketData:ChargeItemCostyType(type)
	return self.charge_item_cost_list[type]
end

function MarketData:updateMarketDataByItem(data)
	local type = data.type 
	local idx = data.idx
	self.market_list[type][idx] = data
end

function MarketData:buyBlackMarketItem(index)
	local conf = self:getMarketItemCfg(SHOP_TYPE.STALL,index)
	if not conf then return end
	local record = self:getMarketDataByType(SHOP_TYPE.STALL)
	-- dump(record)

	-- if ex.Player.vip_level < conf.noble_require then
	-- 	ex.MessageView:add(ex.Tools:getLang(47333))
	-- 	return false
	-- end

	if ex.Player:getItemNum(conf.need_item[1].item_type) < conf.need_item[1].item_num then
		ex.MessageView:add(ex.Tools:getLang(47249))
		return false
	end

	-- local is_have = false

	-- local record = self:getMarketDataByType(SHOP_TYPE.STALL)
	-- dump(record)
	local item_data
	for i,v in pairs(record) do
		if index == v.idx then 
			item_data = v 
			break
		end
	end

	if item_data.buy_num >= conf.buy_limit then 
		ex.MessageView:add(ex.Tools:getLang(47386))
		return false 
	end


	-- local res_buy = ProtocolRequest.ReqShopBuy
	-- res_buy.type.value = SHOP_TYPE.STALL
	-- res_buy.idx.value = index
	-- NetManager:sendLuaData(res_buy) 
	local res_buy = Shop_pb.GReqShopBuy()
	res_buy.type = SHOP_TYPE.STALL
	res_buy.idx = index
	NetManager:sendMessage(ProtocolID.GReqShopBuy,res_buy)

	return false
end

function MarketData:getMarketItemOrderCfg( type,idx)
	
	return self.alter_time_limit_list[idx]

end

function MarketData:addItem(data)
	local js = json.decode(data.charge_item_cost)
	local type = data.type
	self.market_list[type] = {}
	-- if not self.market_list[type] then self.market_list[type] = {} end
	if not self.free_refresh_list[type] then self.free_refresh_list[type] = {} end
	if not self.charge_refresh_list[type] then self.charge_refresh_list[type] = {} end

	self.free_refresh_list[type] = data.free_refresh_num
	self.charge_refresh_list[type] = data.charge_refresh_num
	self.last_free_time_list[type] = data.last_free_time
	self.curr_free_num_list[type] = data.curr_free_num

	for i,v in ipairs(data.item) do
		self.market_list[type][v.idx] = {}
		self.market_list[type][v.idx].idx = v.idx
		self.market_list[type][v.idx].type = type
		self.market_list[type][v.idx].buy_num = v.buy_num
		self.market_list[type][v.idx].is_time = false
	end

	if next(js) ~= nil then 
		for k,v in pairs(js) do
			local data = {}
			data.item_type = v.item_type--tonumber(k)
			data.item_num = v.item_num
			self.charge_item_cost_list[type] = data
		end
	end
end


function MarketData:checkAlterActiveData()
	-- 检测祭坛活动数据
	if ex.Player.promotion_data:checkAlterHeroIsOpen() then 
		local alter_data =ex.Player.promotion_data:getAlterHeroListData()
		for k,v in pairs(alter_data) do
			self.alter_time_limit_list[v.idx] = {}
			self.alter_time_limit_list[v.idx].idx = v.idx
			self.alter_time_limit_list[v.idx].type = SHOP_TYPE.ORDER
			self.alter_time_limit_list[v.idx].buy_num = v.hasNum

			self.alter_time_limit_list[v.idx].chance = v.chance
			self.alter_time_limit_list[v.idx].item_type = v.item_type
			self.alter_time_limit_list[v.idx].need_item = v.need_item
			self.alter_time_limit_list[v.idx].buy_limit = v.buy_limit

			self.alter_time_limit_list[v.idx].is_time = true
		end

	end 
end

function MarketData:getShopData(type)
	-- 检测祭坛活动数据
	local return_data = {} 
	
	if type == SHOP_TYPE.SACRIFICE then 
		self:checkAlterActiveData()

		for k,v in pairs(self.market_list[type]) do
			return_data[k] = v
		end
		
		for k,v in pairs(self.alter_time_limit_list) do
			return_data[k] = v
		end
	else 
		return_data = self.market_list[type]
	end 
	return return_data
end

function MarketData:getMarketItemCfgData( type, idx)
	if type == SHOP_TYPE.ORDER then 
		return self.alter_time_limit_list[idx]
	else 
	   return self.cfg[type][idx]
	end 
end

function MarketData:removeTimer( )
	if self.timer_id ~= nil then 
		ex.Timer:removeTimerById(self.timer_id)
		self.timer_id = nil
	end
end

function MarketData:startTimer( )
	self:removeTimer()

	self.timer_id = ex.Timer:addTimer(1000, handler(self,self.changTime), true)	
end

function MarketData:checkNeedTimeByType()
	self.need_timer_type_list = {}
	for k,v in pairs(self.last_free_time_list) do
		local shop_type = k
		local conf = cfg.shopcontrol["shop"][shop_type]

		if conf ~= nil then
			local refresh_max = conf.max_refresh_count
			if self.free_refresh_list[shop_type] < refresh_max then 
				table.insert(self.need_timer_type_list,shop_type)

				if conf.auto_refresh_mode == 4 then
					local end_time = v + conf.free_refresh_time
					self:setEndTimeByType(k, end_time)
				end
			end
		end
	end
	self:startTimer()
end

function MarketData:changTime( )
	if table.nums(self.need_timer_type_list) <= 0 then 
		self:removeTimer()
	end
	
	for i,v in ipairs(self.need_timer_type_list) do
		local shop_type = v
		local last_time = self.last_free_time_list[shop_type]
		local remain_time = ex.Game:getServerTime() - last_time
		local free_refresh_time = cfg.shopcontrol["shop"][shop_type].free_refresh_time
		if remain_time >= free_refresh_time then 
			local res = Shop_pb.GReqGetFreeNum()
			res.type = shop_type
			NetManager:sendMessage(ProtocolID.GReqGetFreeNum,res)
		end
	end
end

function MarketData:addFreeNum(data)
	local shop_type = data.type
	local free_refresh_num = data.free_refresh_num
	local last_free_time = data.last_free_time

	self.free_refresh_list[shop_type] = free_refresh_num
	self.last_free_time_list[shop_type] = last_free_time

end

function MarketData:getShopTypeIsNeedRefresh(type)
	local need = false 
	for i,v in ipairs(self.need_timer_type_list) do
		if v == type then need = true break end 
	end
	return need
end

function MarketData:getLastTimeByShopType(type)
	return self.last_free_time_list[type]
end

function MarketData:filterHeroItemByElem(data,elem)
	if elem == 0 then return data end 
	local elem_data = {}

	for i,v in ipairs(data) do
		for k,val in ipairs(v) do
			local shop_conf = self.cfg[val.type][val.idx]
			if shop_conf then 
				local item_type = shop_conf.item_type[1].item_type
				for _, j in pairs(cfg.elitepieces.pieces) do
					if j.item_type == item_type and j.element == elem then
						table.insert(elem_data, val)
					end
				end
			end
		end
	end

	local tmp_data = {}
	local idx = 1
	local count = 0
	for i,v in ipairs(elem_data) do
		if not tmp_data[idx] then tmp_data[idx] = {} end
		table.insert(tmp_data[idx],v)
		count = count + 1 
		if count % 3 == 0 then 
			idx = idx + 1
		end
	end

	dump(tmp_data)
	return tmp_data
end

function MarketData:clean( )
	self:removeTimer()
end


return MarketData