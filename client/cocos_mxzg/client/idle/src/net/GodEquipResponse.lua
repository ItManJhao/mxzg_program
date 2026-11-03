local GodEquipResponse = class("GodEquipResponse")

function GodEquipResponse:lotteryInfo(data)
	ex.Player.god_equip_data:resLotteryInfo(data)
end

function GodEquipResponse:lotteryHistory(data)
	ex.Player.god_equip_data:resLotteryHistory(data)
end

function GodEquipResponse:lotteryReward(data)
	ex.Player.god_equip_data:lotteryDone(data)
end

function GodEquipResponse:scanGodEquip(data)
	for i,v in ipairs(data.equips) do
		local equip = clone(v)
		equip.item_id = v.id
		equip.item_type = v.sys_id
		equip.id = nil
		equip.sys_id = nil
        table.insert(ex.Player.backpack_data.god_equip_list, equip)
    end

	if #data.equips > 0 then 
		-- 神装列表
		local req = GodEquip_pb.GReqScanGodEquip()
		req.page = data.page + 1
		NetManager:sendMessage(ProtocolID.GReqScanGodEquip, req)
	else
		ex.EventManager:fire(EVENT.BACKPACK_RES_CHANGE.CHANGE_ITEM)
	end 
end

function GodEquipResponse:addGodEquip(data)
	for i,v in ipairs(data.equips) do
		local data = clone(v)
		data.item_id = data.id
		data.item_type = data.sys_id
		data.id = nil
		data.sys_id = nil
        table.insert(ex.Player.backpack_data.god_equip_list, data)
	end
	
	ex.EventManager:fire(EVENT.BACKPACK_RES_CHANGE.CHANGE_ITEM)
end

function GodEquipResponse:delGodEquip(data)
	for i,v in ipairs(data.equip_ids) do
		for i2,v2 in ipairs(ex.Player.backpack_data.god_equip_list) do
			if v2.item_id == v then
				table.remove(ex.Player.backpack_data.god_equip_list, i2)
				break
			end
		end
	end
	
	ex.EventManager:fire(EVENT.BACKPACK_RES_CHANGE.CHANGE_ITEM)
end

function GodEquipResponse:wearGodEquip(data)

	local hero_id = data.hero_id 

	for i,v in ipairs(data.equips) do
		
		local equips = data.equips[i] 
		ex.Player.backpack_data:changeGodEquipList(hero_id,equips )

	end

	require("src.layer.heroinfo.HeroGodEquipStateCtr"):instance():closeWindow()

	-- 发送界面同志
	ex.EventManager:fire(EVENT.HERO_INFO_EVENT.HERO_UPDATE_GODEQUIP)

end

function GodEquipResponse:disboardGodEquip(data)

	local hero_id = data.hero_id 
	local equip_id = data.equip_id 

	ex.Player.backpack_data:subGodEquipList(hero_id,equip_id )

	require("src.layer.heroinfo.HeroGodEquipStateCtr"):instance():closeWindow()

	-- 发送界面同志
	ex.EventManager:fire(EVENT.HERO_INFO_EVENT.HERO_UPDATE_GODEQUIP)

end


function GodEquipResponse:updateGodEquipOff(data)

	for i,v in ipairs(data.equip_ids) do
		ex.Player.backpack_data:updateGodEquipOff(v)
	end
end 

function GodEquipResponse:washGodEquip(data)

	local equip = data.equip 
	ex.Player.backpack_data:washGodEquip(equip )
	-- require("src.layer.GodEquipRareCtr"):instance():ChangeNowGodEquipData(equip.attrs)
	require("src.layer.GodEquipRareCtr"):instance():ShowNewGodEquipData(equip.wash_attrs)

end


function GodEquipResponse:saveWashGodEquip(data)
	local equip = data.equip 
	ex.Player.backpack_data:saveWashGodEquip(equip )
	require("src.layer.GodEquipRareCtr"):instance():ChangeNowGodEquipData(equip.attrs)
	require("src.layer.GodEquipRareCtr"):instance():ShowNewGodEquipData({})
end

function GodEquipResponse:godEquipUpStar(data)
	local equip = clone(data.equip)
	equip.item_id = data.equip.id
	equip.item_type = data.equip.sys_id
	equip.id = nil
	equip.sys_id = nil
	
	require("src.layer.ItemRewardCtr"):instance():openWindow({equip})
end

function GodEquipResponse:godEquipFighting(data)
	local fighting = data.fighting 

	require("src.layer.heroinfo.HeroGodEquipAttrCtr"):instance():showFighting( fighting)

end


function GodEquipResponse:godEquipPrivilege(data)

	ex.Player.god_equip_data:saveGodEquipPrivilege(data )

end

function GodEquipResponse:getPrivilegeReward(data)

	ex.Player.god_equip_data:saveGetPrivilegeReward(data )

	ex.Player.promotion_data:checkPrivilegeGiftRedDot()

end


return GodEquipResponse
