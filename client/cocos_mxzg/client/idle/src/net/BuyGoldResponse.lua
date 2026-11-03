local BuyGoldResponse = class("BuyGoldResponse")


function BuyGoldResponse:buyaGoldLog(data, byte_array)
	-- local data = NetManager:resLuaData(ProtocolResponse.ResBuyGoldLog, byte_array)
	-- dump(data)
	ex.Player.shop_data.buy_gold_status = data.status
	ex.Player.shop_data.buy_gold_time = data.time
	ex.Player.shop_data.buy_gold_list = {}

	for i,v in ipairs(data.list) do
		ex.Player.shop_data:addBuyGoldNum(v.idx, v.num)
	end

	ex.Player.shop_data:checkBuyGoleReddot()
	require("src.layer.BuyGoldCtr"):instance():updateLayer()
end


function BuyGoldResponse:buyaGold(data, byte_array)
	-- local data = NetManager:resLuaData(ProtocolResponse.ResBuyGold, byte_array)
	-- dump(data)

	-- local config_cost = cfg.buygoldcost.buygoldcost[data.idx]

	-- ex.Player:addGem(-config_cost.prize)

	-- local Percent = cfg.vip.vip[ex.Player.vip_level].buy_gold_bonus

	local str = ""

	if data.get_rate > 0 then
		str = string.format(ex.Tools:getLang(47220), data.get_rate/100)
	end
	-- ex.Player:addItem(ItemType.IT_GOLD, data.gold)
	ex.Tools:addBackpackMsg(ItemType.IT_GOLD, data.gold,str)
	
	ex.Player.promotion_data:reqBuyGoldList()
	ex.Player.shop_data:checkBuyGoleReddot()
end

return BuyGoldResponse
