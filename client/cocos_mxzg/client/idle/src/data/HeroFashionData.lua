local HeroFashionData = class("HeroFashionData")

function HeroFashionData:ctor()
    -- 已有皮肤列表
    self.fashion_list = {}

    -- 穿戴皮肤列表
    self.fashion_wear_list = {}  -- {{hero_id, fashion_id}}
end

function HeroFashionData:setFashionList(data)
    self.fashion_list = data
end

function HeroFashionData:setWearList(data)
    self.fashion_wear_list = data
end

function HeroFashionData:setWearFashion(hero_id, fashion_id)
    for i,v in ipairs(self.fashion_wear_list) do
        if v.hero_id == hero_id then
            if fashion_id == 0 then -- 替换为原始皮肤，则删除数据
                table.remove(self.fashion_wear_list, i)
            else
                v.fashion_id = fashion_id
            end

            return
        end
    end

    local data = {}
    data.hero_id = hero_id
    data.fashion_id = fashion_id
    table.insert(self.fashion_wear_list, data)
end

function HeroFashionData:upgradeFashionLevel(fashion_id, level)
    local data = self:getFashionDataByID(fashion_id)
    if data then
        data.level = level
    end
end

function HeroFashionData:checkFashionStatue( fashion_id)
    
    for i,v in ipairs(self.fashion_list) do
        if fashion_id == v.fashion_id then 
            if v.status == 0 then 
                return true , 0
            else 
                if v.end_time > ex.Game:getServerTime() then 
                    return true ,v.end_time 
                end 
            end 

        end 
    end
    return  false , -1
end

function HeroFashionData:getWearByID(hero_id)
	for i,v in ipairs(self.fashion_wear_list) do
        if v.hero_id == hero_id then
            if self:isActive(v.fashion_id) then -- 需要判断是否已过期
                return v.fashion_id
            end
        end
    end

    return nil
end

function HeroFashionData:getFashionDataByID(fashion_id)
    for i,v in ipairs(self.fashion_list) do
        if v.fashion_id == fashion_id then
            return v
        end
    end

    return nil
end

-- 是否已激活
function HeroFashionData:isActive(fashion_id)
    local data = self:getFashionDataByID(fashion_id)
    return data and (data.status == 0 or (data.status == 1 and data.end_time > ex.Game:getServerTime()) ) or false
end

-- 是否可以激活
function HeroFashionData:isActionable(fashion_id, is_show_tip)
    is_show_tip = is_show_tip or false
    local configs = cfg.herofashionunlock.getConfigByID(fashion_id)
    if #configs <= 0 then return false end

    for i,v in ipairs(configs) do
        if ex.Tools:hasItemList({{item_type = v.item_type, item_num = 1}}, false) then
            return true
        end
    end

    if is_show_tip then
        ex.Tools:showEnoughTip(configs[1].item_type, true)
    end

    return false
end

-- 获取可用于激活指定皮肤的item_type
function HeroFashionData:getItemTypeForActiveFashion(fashion_id)
    local configs = cfg.herofashionunlock.getConfigByID(fashion_id)
    if #configs <= 0 then return nil end

    for i,v in ipairs(configs) do
        if ex.Tools:hasItemList({{item_type = v.item_type, item_num = 1}}, false) then
            return v.item_type
        end
    end

    return nil
end

-- 是否可以升级
function HeroFashionData:isCanUpgrade(fashion_id, level, is_show_tip)
    is_show_tip = is_show_tip or false
    local config = cfg.herofashionup.getConfigByTypeAndLevel(fashion_id, level)
    if not config or config.need_item == "" or #config.need_item <= 0 then
        return false 
    end
    local max_config = cfg.herofashionup.getMaxConfigByType(fashion_id)
    if not max_config or level >= max_config.level then 
        return false    -- 最大等级了
    end
    return ex.Tools:hasItemList(config.need_item, is_show_tip)
end


function HeroFashionData:checkSkinReddot(hero_type)
    local fashion_list = cfg.herofashion.getConfigsByHeroType(hero_type)
	local is_actionable = false
	for i, h in ipairs(fashion_list) do
		local is_active = self:isActive(h.fashion_id)
		-- add 熊梦 英雄皮肤是否可以激活
		if not is_active and self:isActionable(h.fashion_id) then
			is_actionable = true
			break
		end
		-- add 熊梦 英雄皮肤是否可以升级
		local data = self:getFashionDataByID(h.fashion_id)
		if data ~= nil then
			local max_config = cfg.herofashionup.getMaxConfigByType(h.fashion_id)
			local max_level = max_config.level
			local level = is_active and data.level or 0
			local up_config = cfg.herofashionup.getConfigByTypeAndLevel(h.fashion_id, math.max(0, math.min(max_level, level)))
			local is_upgrade_show =  is_active and data.status == 0 and up_config.level < max_level 
			if self:isCanUpgrade(h.fashion_id, level) and is_upgrade_show then
				is_actionable = true
				break
			end
		end
	end
	return is_actionable
end


return HeroFashionData