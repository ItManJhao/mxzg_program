local AltarData = class("AltarData")

function AltarData:ctor()
	self.shop_free_refresh = 0
	self.shop_list = {}
	
end

function AltarData:clearShop(free)
	self.shop_free_refresh = free
	self.shop_list = {}
end

function AltarData:addShopData(data)
	table.insert(self.shop_list, data)
end

function AltarData:buyShopItem(index)
	for _,v in pairs(self.shop_list) do
		if v.index == index then
			if v.limit.count > 0 then
				v.limit.times = v.limit.times + 1
			end
			return
		end
	end
end

function AltarData:getLimitShop()
	local shop_limit_list = {}
    for k,v in pairs(cfg.promotionsacrificeshop.promotionsacrificeshop) do        
        for i,data in ipairs(v.item_type) do
            table.insert( shop_limit_list, data)
        end
	end
	return shop_limit_list
end


return AltarData