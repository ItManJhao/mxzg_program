local MagicWandData = class("MagicWandData")

function MagicWandData:ctor(parent)
    self.parent = parent
    self.magic_wand_max_level = {}
    self.magic_wand_cost = {}
    self:initReddotData()
    self:clear()
end

function MagicWandData:initReddotData()
    for i,v in ipairs(cfg.magicwandstrengthen.magicwandstrengthen) do
        if self.magic_wand_max_level[v.item_type] == nil or self.magic_wand_max_level[v.item_type] < v.level then
            self.magic_wand_max_level[v.item_type] = v.level
        end

        for ii,vv in ipairs(v.cost) do
            if self.magic_wand_cost[vv.item_type] == nil then
                self.magic_wand_cost[vv.item_type] = true
            end
        end
    end
end

function MagicWandData:gReqHeroMagicWandList( )
	local r = HeroMagicWand_pb.GReqHeroMagicWandList()
    r.page = 1
	NetManager:sendMessage(ProtocolID.GReqHeroMagicWandList, r)
end


function MagicWandData:clear( )
    self.magic_wand_list = {}
end

function MagicWandData:addHeroMagicWand(data)
    table.insert(self.magic_wand_list, data)
end

function MagicWandData:removeHeroMagicWand(data)
    TableEx.removeTableData(self.magic_wand_list, function(v)
        return v.magic_id == data.magic_id
    end)
end

function MagicWandData:removeByMagicWandId(magic_id)
    TableEx.removeTableData(self.magic_wand_list, function(v)
        return v.magic_id == magic_id
    end)
end

function MagicWandData:updateHeroMagicWand(data)
    for i,v in ipairs(self.magic_wand_list) do
        if v.magic_id == data.magic_id then
            self.magic_wand_list[i] = data
        end
    end
end

function MagicWandData:removeHeroMagicWandByHeroId(hero_id)
    TableEx.removeTableData(self.magic_wand_list, function(v)
        return v.hero_id == hero_id
    end)
end


function MagicWandData:getMagicWandByMagicId(magic_id)
    return TableEx.findValueFunction(self.magic_wand_list, function(v)
        return v.magic_id == magic_id
    end)
end

function MagicWandData:getMagicWandByHeroId(hero_id)
    return TableEx.findValueFunction(self.magic_wand_list, function(v)
        return v.hero_id == hero_id
    end)
end

function MagicWandData:getRandAttrVisible(item_type, level)
    local c = ex.Tools:getSysCfg("magic_wand_strengthen_unlock_level")
    local list_level = ex.StringUtil.splist(c, "_")
    
    local v_list = {}
    local l_list = clone(list_level)
    table.insert(l_list, 1, 0)

    local cfg_ty = TableEx.findValueFunction(cfg.magicwandtype.magicwandtype, function(v)
		return (v.type_id == item_type)
    end) 

    for i=1, 4 do
        v_list[i] = 0
        
        if cfg_ty.random_attr_max >= i then
            v_list[i] = 1
        end

        if v_list[i] > 0 and (i == 1 or (level >= tonumber(list_level[i-1])) ) then
            v_list[i] = 2
        end
    end

    return v_list, l_list
end

function MagicWandData:getAttrRange(item_type)
    local r_list = {}

    local cfg_type = TableEx.findValueFunction(cfg.magicwandtype.magicwandtype, function(v)
		return (v.type_id == item_type)
    end) 

    for i,v in ipairs(cfg_type.base_attrs) do
        local cfg_attr = TableEx.findValueFunction(cfg.magicwandrange.magicwandrange, function(va)
            return va.attr_type == v.attr and va.rare == cfg_type.rare
        end)

        if cfg_attr then
            table.insert(r_list, {attr= cfg_attr.attr_type, min = cfg_attr.min, max = cfg_attr.max})
        end
    end

    return r_list
end

function MagicWandData:isVisibleMagicWand(hero_id)
    local hero_data = ex.Player.hero_data:getHeroDataById(hero_id)
    if not hero_data then return false end 
    return ex.Tools:getSysCfg("open_magic_wand_hero_star") <= hero_data.star
end

function MagicWandData:isOpenMagicWand(hero_id)
    local hero_data = ex.Player.hero_data:getHeroDataById(hero_id)
    if not hero_data then return false end 
    return ex.JumpManager:checkOpenConditionByAtomNoMsg("hero_magic_wand") and ex.Tools:getSysCfg("open_magic_wand_hero_star") <= hero_data.star
end

function MagicWandData:checkReddotByScene()
	local battle_list = self.parent.promote:getBattleList()
	local bool = false
	for k,v in pairs(battle_list) do
		bool = self:checkReddot(k)
		if bool == true then break end
	end
	return bool
end

function MagicWandData:checkReddot(hero_id)
    return self:isOpenMagicWand(hero_id) and (self:checkWear(hero_id) or self:checkStrengthenReddot(hero_id))
end

function MagicWandData:checkWear(hero_id)
    local hasMagic = ex.Player.backpack_data.magic_wand_list[1] ~= nil
    local magic_wand = self:getMagicWandByHeroId(hero_id)
    if magic_wand == nil then
        return hasMagic
    end
    return false
end

function MagicWandData:checkStrengthenReddot(hero_id)
    local magic_wand = self:getMagicWandByHeroId(hero_id)
    if magic_wand == nil then
        return false
    end
    
    return self:checkStrengthenReddotByData(magic_wand)
end

function MagicWandData:checkStrengthenReddotByData(magic_wand)
    if magic_wand.strengthen_lv < self.magic_wand_max_level[magic_wand.item_type] then
        local c = TableEx.findValueFunction(cfg.magicwandstrengthen.magicwandstrengthen, function(v)
            return v.level == magic_wand.strengthen_lv
        end)
        
        if c and ex.Tools:hasItemList(c.cost, false) then
            return true
        end
    end

    return false
end

return MagicWandData
