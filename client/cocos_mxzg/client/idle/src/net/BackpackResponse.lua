local BackpackResponse = class("BackpackResponse")

function BackpackResponse:backpackList(data, byte_array)

	ex.Player.backpack_data:clear()

	for i,v in ipairs(data.list) do
		ex.Player.backpack_data:addNewBackpack(v.item_type, v.num, v.item_id)
	end

	ex.Player.backpack_data:checkPieceRed()
	ex.EventManager:fire(EVENT.BACK_PACK_EVENT.BACKPACK_INIT_FINISH)
	
	-- cpp.LoadingSceneCtr:instance():receivedProtocol(ProtocolID.GResBackPackList)
	require("src.scene.LoadingSceneCtr"):instance():receivedProtocol(ProtocolID.GResBackPackList)
	-- ex.Player.backpack_data:checkPieceRed()
	-- ex.out(ex.Player.backpack_data.backpack_list)
	-- print(ex.Tools:getLang(47225))
end

function BackpackResponse:backpackGain(data)
	-- 道具的增删，type=0：不做任何提示；type=1：弹框提示；type=2：语句提示
	-- dump_pbmsg(data, "BackpackResponse:backpackGain")
	-- dump(data)

	local item_tab = cfg.item.item
	local award_list = {}
	for i,v in ipairs(data.list) do
		-- 此协议的符文数据不添加到背包
		local prop_type = ex.Player.backpack_data:getPropType(v.type)
		local item_config = item_tab[v.type]

		if prop_type ~= ItemData.IT_RUNES and
		   prop_type ~= ItemData.IT_HERO_GODEQUIP and
		   prop_type ~= ItemData.MAGIC_WAND and
		   item_config.mode ~= ItemData.IT_HERO and
		   item_config.mode ~= ItemData.IT_HERO_MATERIAL and
		   item_config.mode ~= ItemData.IT_PROP_LIMIT_TIME then
			ex.Player:addItem(v.type, v.num, v.id)
		end

		if data.type == nil or data.type == 0 then

		elseif data.type == 1 then
			local data = {}
			data.item_id   = v.id 
			data.item_type = v.type
			data.item_num  = v.num
			data.star = v.star
			table.insert(award_list, data)
		elseif data.type == 2 then
			ex.Tools:addBackpackMsg(v.type, v.num)
		end
	end

	if data.type ~= nil and data.type == 1 then
		require("src.layer.ItemRewardCtr"):instance():openWindow(award_list)
	end
	
	ex.EventManager:fire(EVENT.BACKPACK_RES_CHANGE.CHANGE_ITEM, data.list)
	ex.EventManager:fire(EVENT.DRAGON_EVENT.REMAINS_BUY)
	ex.EventManager:fire(EVENT.CHRISTMAS.GIFTBOX_UPDATA)
	
	-- 监听一下圣诞活动的道具 显示红点
	if cfg.promotion087lotterytype or cfg.promotion087lotterytype.ppromotion087lotterytype then
		local is_open = cfg.funcopen["act_christmas_happy"].isVisible()
		if is_open then
			local cost_cfg = cfg.promotion087lotterytype.promotion087lotterytype[1].cost[1]
			for i,v in ipairs(data.list) do
				if v.type == cost_cfg.item_type then
					ex.Player.promotion_data:checkPromotion87RedDot()
					break
				end
			end 
		end
	end

	-- 监听一下五一抽奖的道具 显示红点
	if cfg.promotion097labordayreward and cfg.promotion097labordayreward.promotion097labordayreward then
		local is_open = ex.Player.promotion_data:getIsShowFiveOneRed()
		ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_SDJHD_LDJZ, is_open)
		ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_SDJHD_SDQHY_LDJZ, is_open)
	end
	
	local is_open = cfg.funcopen["act_christmas_surprise_blind_box"].isVisible()
	if is_open then
		for i,v in ipairs(data.list) do
			if v.type == 901819 or v.type == 901820 then
				ex.Player.promotion_data:checkPromotion91RedDot()
				break
			end
		end 
	end
	
	
	-- 监听一下冥域魔都的红点
	local is_open = cfg.funcopen["main_underworld_pagoda"].isVisible()
	if is_open then
		ex.Player.underworld_pagoda_data:checkReddot(1)
		ex.Player.underworld_pagoda_data:checkReddot(2)
	end

	ex.Player.dragon_data:checkReddot()

	--刷新春日彩蛋道具
	local is_open = cfg.funcopen["act_spring_eggs"].isVisible()
	if is_open then
		local cost_cfg = cfg.promotion094score.promotion094score[1].cost_item
		for k,v in pairs(cost_cfg) do
			for j,k in pairs(data.list) do
				if k.type == v.item_type then
					ex.EventManager:fire(EVENT.SPRING.GIFTBOX_UPDATA)
					break
				end
			end
		end
	end

	-- 春日踏青 骰子道具检测
	local is_open = cfg.funcopen["act_spring_dice"].isVisible()
	if is_open then
		local cost_type = cfg.system.promotion093_dice_cost[1].item_type
		for k,v in pairs(data.list) do
			if v.type == cost_type then
				ex.Player.promotion_data:checkPromotion93RedDot()
				break
			end
		end
	end

end

function BackpackResponse:backpackMakeEquip(data, byte_array)
	local remove_equip_list = ex.Player.hero_data.equip:getRemoveEquipList()
	for k,v in pairs(remove_equip_list) do
		ex.Player.backpack_data:removeItemById(v)
	end

	ex.Player.hero_data.equip:setRemoveEquipList({})
	local items = {}

	local place 
	local total = 0
	for i,v in ipairs(data.equip) do
		local id = v.id
		local type = v.type
		local num = v.num
		ex.Player:addItem(type, num, id)

		local config = cfg.equipmenttype.equip[type]
		place = config.place
		total = total + config.need_gold
		local item = {}
		item.item_type = type 
		item.item_num = num
		table.insert(items,item)
	end

	ex.Player.hero_data.equip:checkMakeEquipRedPointByPlace(place)

	require('src.layer.ItemRewardCtr'):instance():openWindow(items)

	local equip_red = ex.Player.hero_data.equip:checkHeroEquipRedPointByScene()
	local bool = ex.Player.hero_data.promote:checkMainCityRedPoint()
	local artifact_red = ex.Player.hero_data.artifact:checkMainCityRedPoint()
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_YXT, equip_red or bool or artifact_red)
	ex.EventManager:fire(EVENT.MAKE_EQUIP_EVENT.MAKE_EQUIP_WITH_UPDATE)
end

function BackpackResponse:backpackMakeOneKeyEquip(data, byte_array)
	local vec_place = {}

	local items = {}
	for i,v in ipairs(data.equip) do
		local id = v.id
		local type = v.type
		local num = v.num
		-- ex.Player:addItem(type, num, id)

		local item = {}
		item.item_type = type 
		item.item_num = num
		table.insert(items,item)

		local equip_config = cfg.equipmenttype.equip[type]
		if equip_config then
			vec_place[equip_config.place] = 1
		end
	end


	require('src.layer.ItemRewardCtr'):instance():openWindow(items)

	-- ex.Player:addItem(ItemType.IT_GOLD,-consume_gold)
	ex.Player.hero_data.equip:getOneKeyNeedGold(0)

	-- local res = {}
	-- res.reward = items
	-- res.title = ex.Tools:getLang(47108)
	-- ex.EventManager:fire(EVENT.MAKE_EQUIP_EVENT.MAKE_EQUIP_ONE_KEY,res)


	local equi_data = ex.Player.backpack_data:getEquipByPlace()
	-- dump(equi_data,"111")
	for k,v in pairs(vec_place) do
		ex.Player.hero_data.equip:checkMakeEquipRedPointByPlace(k)
	end

	-- local req_backpack = cpp.ByteArray:create()
 --    req_backpack:writeInt(ProtocolID.GReqBackPackList)
 --    cpp.NetManager:instance():sendByteArray(req_backpack)
 
    -- NetManager:sendMessage(ProtocolID.GReqBackPackList)

	ex.EventManager:fire(EVENT.MAKE_EQUIP_EVENT.MAKE_EQUIP_WITH_UPDATE)
end

function BackpackResponse:backpackBoxReward(data, byte_array)
	local item_type = data.item_type
	local use_num = data.user_num
	-- ex.Player.backpack_data:changeBackpack(item_type, -use_num, "0")

	local items = {}
	for i,v in ipairs(data.list) do
		local id = v.id
		local type = v.type
		local num  = v.num
		-- ex.Player:addItemByNet(id, type, num)

		local item = {}
		item.item_type = type 
		item.item_num = num
		item.item_id = id
		table.insert(items, item)
	end

	-- ex.AudioManager:playEffect("music/item-get.mp3")
	require("src.layer.ItemRewardCtr"):instance():openWindow(items)
	ex.EventManager:fire(EVENT.BACK_PACK_EVENT.OPEN_BOX_REWARD, data)

end

function BackpackResponse:backpackPieceReward(data, byte_array)
	-- local item_type = data.item_type
	-- local count = table.nums(data.list)
	
	-- ex.Player:addItem(item_type, -(count * num), "0")
	ex.AudioManager:playEffect("music/item-get.mp3")

	-- ex.Player.backpack_data:changeBackpack("0", item_type, -(count * num))

	local HeroAbilityData = require("src.data.HeroAbilityData")
	local heros = {}
	-- for i=1,count do
	for i,v in ipairs(data.list) do

		-- local hero = HeroAbilityData.new()
		-- hero.hero_id = v.hero_id
		-- hero.hero_type = v.hero_type
		-- hero.level =  v.level
		-- hero.stage = v.stage
		-- hero.star = v.star
		-- hero.elem = v.elem
		-- hero.occupation = v.occupation
		-- hero.is_lock = v.is_lock
		-- hero.fighting = v.fighting
		-- -- hero.hp_up_level = v.hp_up_level
		-- -- hero.atk_up_level = v.atk_up_level
		-- hero.equip = {}
		-- hero.bat = 2000 + math.random(1, 1000)
		-- ex.Player.hero_data:addHero(hero)

		table.insert(heros, {item_type = v.hero_type, item_num = 1} )
	end

	for k,v in pairs(ex.Player.hero_data.promote:getBattleList()) do
		ex.Player.hero_data.promote:checkUpStar(k)
	end

	local creatHero = ex.Player.hero_data.promote:getCreatHeroData()
	for k,v in pairs(creatHero) do
		ex.Player.hero_data.promote:checkUpStar(v,true)
	end

	ex.Player.hero_data.promote:checkCreatHeroRedPoint()
	-- ex.Tools:openRewardPanel(heros, nil)

	require("src.layer.ItemRewardCtr"):instance():openWindow(heros)

	ex.Player.backpack_data:checkPieceRed()

	local bool = ex.Player.hero_data.promote:checkMainCityRedPoint()
	local artifact_red = ex.Player.hero_data.artifact:checkMainCityRedPoint()
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_YXT, bool or artifact_red)
	ex.Player.hero_data.promote:checkCreatHeroRedPoint()
	ex.EventManager:fire(EVENT.BACK_PACK_EVENT.BACKPACK_UPDATA_LIST)
end

function BackpackResponse:handleJewelCombine(data)
	local list = {}
	for k,v in pairs(data.jewel) do
		table.insert(list, {item_type = v.type, item_num = v.num} )
	end

	require("src.layer.ItemRewardCtr"):instance():openWindow(list)

	ex.AudioManager:playEffect("music/item-get.mp3")
end

function BackpackResponse:handleJewelAllCombine(data)
	local list = {}
	for k,v in pairs(data.jewel) do
		table.insert(list, {item_type = v.type, item_num = v.num} )
	end

	require("src.layer.ItemRewardCtr"):instance():openWindow(list)

	ex.AudioManager:playEffect("music/item-get.mp3")
end

function BackpackResponse:handleTimeLimitList(data)
	ex.Player.backpack_data:refreshLimitTimeProp(data.list)
end

return BackpackResponse
