local ProphetData = class("ProphetData")

function ProphetData:ctor()
	self.change_data = {}

	self.vec_lucks = {}	-- 召唤幸运值

	self.shop_free_refresh = 0
	self.shop_list = {}
end

function ProphetData:confirmChange(index)
	self.change_data = {}


	-- 发送确认置换
	-- local req_confirm = Task1_pb.GReqProphetConfirmChange()
	-- req_confirm.index = index
	-- NetManager:sendMessage(ProtocolID.GReqProphetConfirmChange, req_confirm)
	
	local req_confirm = ProphetSummon_pb.GReqProphetConfirmChange()
    req_confirm.index = index + 1
    NetManager:sendMessage(ProtocolID.GReqProphetConfirmChange, req_confirm)
end

function ProphetData:clearShop(free)
	self.shop_free_refresh = free
	self.shop_list = {}
end

function ProphetData:addShopData(data)
	table.insert(self.shop_list, data)
end

function ProphetData:buyShopItem(index)
	for _,v in pairs(self.shop_list) do
		if v.index == index then
			if v.limit.count > 0 then
				v.limit.times = v.limit.times + 1
			end
			return
		end
	end
end

return ProphetData
