local HeroMagicWandResponse = class("HeroMagicWandResponse")

function HeroMagicWandResponse:resHeroMagicWandList(data)
    if data.page <= 1 then
		ex.Player.backpack_data.magic_wand_list = {}
    end

    for i,v in ipairs(data.list) do
        ex.Player.backpack_data:addMagicWand(v)
    end

    if table.nums(data.list) > 0 then
        -- 不是最后一页，继续请求
        local r = HeroMagicWand_pb.GReqHeroMagicWandList()
		r.page = data.page + 1
        NetManager:sendMessage(ProtocolID.GReqHeroMagicWandList, r)
		return
	end
end

function HeroMagicWandResponse:resHeroMagicWandOn(data)
    ex.Player.hero_data.magic_wand:removeByMagicWandId(data.magic_id)
    ex.Player.hero_data.magic_wand:addHeroMagicWand(data.magic_info)

    ex.EventManager:fire(EVENT.HERO_INFO_EVENT.MAGIC_WAND_WEAR)
end

function HeroMagicWandResponse:resHeroMagicWandOff(data)
    ex.Player.hero_data.magic_wand:removeHeroMagicWandByHeroId(data.hero_id)

    ex.EventManager:fire(EVENT.HERO_INFO_EVENT.MAGIC_WAND_WEAR)
end

function HeroMagicWandResponse:resMagicWandStrengthen(data)
    if data.magic_info.hero_id ~= 0 then
        ex.Player.hero_data.magic_wand:updateHeroMagicWand(data.magic_info)
    else
        ex.Player.backpack_data:changeMagicWand(data.magic_info)
    end

    ex.EventManager:fire(EVENT.HERO_INFO_EVENT.MAGIC_WAND_STRENGTHEN)
end

function HeroMagicWandResponse:resMagicWandBaptism(data)
    if data.magic_info.hero_id ~= 0 then
        ex.Player.hero_data.magic_wand:updateHeroMagicWand(data.magic_info)
    else
        ex.Player.backpack_data:changeMagicWand(data.magic_info)
    end

    ex.EventManager:fire(EVENT.HERO_INFO_EVENT.MAGIC_WAND_REFINE)
end

function HeroMagicWandResponse:resMagicWandSave(data)
    if data.magic_info.hero_id ~= 0 then
        ex.Player.hero_data.magic_wand:updateHeroMagicWand(data.magic_info)
    else
        ex.Player.backpack_data:changeMagicWand(data.magic_info)
    end
    
    ex.EventManager:fire(EVENT.HERO_INFO_EVENT.MAGIC_WAND_REFINE)
end

function HeroMagicWandResponse:resMagicWandDecompose(data)
    for i,v in ipairs(data.del_ids) do
        ex.Player.backpack_data:deleteMagicWand(v)
    end
end

function HeroMagicWandResponse:resMagicWandBaginfo(data)
    if data.sign == 0 then
        for i,v in ipairs(data.list) do
            ex.Player.backpack_data:deleteMagicWand(v.magic_id)
        end
    else
        for i,v in ipairs(data.list) do
            ex.Player.backpack_data:addMagicWand(v)
        end
    end
end

return HeroMagicWandResponse