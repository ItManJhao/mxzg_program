local HeroResponse = class("HeroResponse")

function HeroResponse:heroList(data, byte_array)
	cpp.ResponseManager:instance():response(byte_array)

	if data.page <= 1 then
		ex.Player.hero_data.hero_list = {}
	end
	ex.Player.hero_data.hero_capacity = data.hero_capacity
	ex.Player.hero_data.buy_space_times = data.buy_space_times

	local HeroAbilityData = require("src.data.HeroAbilityData")

	-- 英雄六芒星数据
	local hexagram_list = {}

	for i,v in ipairs(data.list) do
		local hero = HeroAbilityData.new()
		hero.hero_id = v.hero_id
		hero.hero_type = v.hero_type
		hero.level = v.level
		hero.stage = v.stage
		hero.star = v.star
		hero.elem = v.elem
        hero.tweak_cube_lv = v.tweak_cube_lv
        hero.tweak_cube_stage = v.tweak_cube_stage
		hero.awaken = v.awaken

		hero.atk = v.atk or 0
		hero.hp = v.hp or 0
		hero.def = v.def or 0
		hero.spd = v.spd or 0

		hero.occupation = v.occupation
		hero.is_lock = v.is_lock == 1
		hero.hp_up_level = v.hp_up_level
		hero.atk_up_level = v.atk_up_level
		hero.fighting = v.fighting
		hero.talents = {}
		for j = 1, #v.talents do
			local talent = {}
			talent.slot = v.talents[j].slot
			talent.skill_id = v.talents[j].skill_id
			talent.level = v.talents[j].level
			table.insert(hero.talents, talent)
		end
		hero.reiki_places = {}

		for k,val in ipairs(v.reiki_places) do
			hero.reiki_places[val] = val
		end

		-- for j = 1, #v.reiki_places do
		-- 	hero.reiki_places[]
		-- end

		hero.equip = {}
		-- hero.bat = 2000 + math.random(1, 1000)
		ex.Player.hero_data:addHero(hero)
		local evolve_type = v.evolve.type
		local evolve_level = v.evolve.level

		hero.evolve = {
			type = evolve_type,
			level = evolve_level
		}

		-- 英雄六芒星数据
		if v.hexagram then
			local hexagram_data = {}
			for j,v2 in ipairs(v.hexagram) do
				if v2.level > 0 then
					local hexagram = {}
					hexagram.hero_id = v.hero_id
					hexagram.type = v2.type
					hexagram.level = v2.level

					hexagram_data[hexagram.type] = hexagram
				end
			end

			if table.nums(hexagram_data) > 0 then
				hexagram_list[v.hero_id] = hexagram_data
			end
		end
	end

	-- 初始化六芒星数据
	ex.Player.hero_data.hexagram:initData(hexagram_list)

	if data.send_status < 1 then
		-- 不是最后一页，继续请求
		local req = Hero_pb.GReqHeroList()
		req.page = data.page + 1
		NetManager:sendMessage(ProtocolID.GReqHeroList, req)
		return
	end
	
	ex.Player.hero_data:initSort()
	ex.Player.hero_data.promote:initUpStarRedPoint()

	-- 请求英雄图鉴奖励列表
	-- local req_illustrat_list = cpp.ByteArray:create()
	-- req_illustrat_list:writeInt(ProtocolID.GReqIllustratReward)
	-- cpp.NetManager:instance():sendByteArray(req_illustrat_list)
	NetManager:sendMessage(ProtocolID.GReqIllustratReward)

	-- cpp.LoadingSceneCtr:instance():receivedProtocol(ProtocolID.GResHeroList) 
	require("src.scene.LoadingSceneCtr"):instance():receivedProtocol(ProtocolID.GResHeroList)
end

function HeroResponse:heroDetail(data)
	local hero_data = ex.Player.hero_data:getHeroDataById(data.detail.hero_id)
	if hero_data then
		hero_data.atk = data.detail.atk or 0
		hero_data.hp = data.detail.hp or 0
		hero_data.def = data.detail.def or 0
		hero_data.spd = data.detail.spd or 0
	end
	ex.EventManager:fire(EVENT.HERO_INFO_EVENT.HERO_UP_LEVEL)
	ex.EventManager:fire(EVENT.HERO_EVENT.HERO_DETAIL, data)
end

function HeroResponse:getChoose( data )

	
	local line_up_type = data.line_up_type and data.line_up_type or 0

	local config =  cfg.battleformation.battleformation[line_up_type]
	if config then 
		local str = string.format(ex.Tools:getLang(41265), ex.Tools:getLang(config.lang))
        ex.MessageView:add(str)

	end 
end 


function HeroResponse:comeBackInfo( data )

	local HeroAbilityData = require("src.data.HeroAbilityData")

	local hero_data = {}
		for i,v in ipairs(data.hero) do
			local hero = HeroAbilityData.new()
			hero.hero_id = v.hero_id
			hero.hero_type = v.hero_type
			hero.level = v.level
			hero.stage = v.stage
			hero.star = v.star
			hero.elem = v.elem
			hero.occupation = v.occupation
			hero.is_lock = v.is_lock == 1
			hero.hp_up_level = v.hp_up_level
			hero.atk_up_level = v.atk_up_level
			hero.fighting = v.fighting
			hero.equip = {}
			hero.reiki_places = {}
            hero.tweak_cube_lv = v.tweak_cube_lv
            hero.tweak_cube_stage = v.tweak_cube_stage 
			hero.awaken = v.awaken
			for idx,val in ipairs(v.reiki_places) do
				hero.reiki_places[val] = val
			end
			-- hero.bat = 2000 + math.random(1, 1000)
			table.insert( hero_data, hero )
		end

	ex.EventManager:fire(EVENT.HERO_EVENT.HERO_ROLLBACK_GETHEROLIST, hero_data)
end



function HeroResponse:comeBack( data )

	ex.EventManager:fire(EVENT.HERO_EVENT.HERO_ROLLBACK_SUCCRESS, data.hero)

end


function HeroResponse:switchInfo( data )

	local HeroAbilityData = require("src.data.HeroAbilityData")

	local hero_data = {}
		for i,v in ipairs(data.hero) do
			local hero = HeroAbilityData.new()
			hero.hero_id = v.hero_id
			hero.hero_type = v.hero_type
			hero.level = v.level
			hero.stage = v.stage
			hero.star = v.star
			hero.elem = v.elem
			hero.occupation = v.occupation
			hero.is_lock = v.is_lock == 1
			hero.hp_up_level = v.hp_up_level
			hero.atk_up_level = v.atk_up_level
			hero.fighting = v.fighting
			hero.equip = {}
            hero.tweak_cube_lv = v.tweak_cube_lv
            hero.tweak_cube_stage = v.tweak_cube_stage 

			hero.awaken = v.awaken
			hero.reiki_places = {}
			for idx,val in ipairs(v.reiki_places) do
				hero.reiki_places[val] = val
			end
			-- hero.bat = 2000 + math.random(1, 1000)
			table.insert( hero_data, hero )
		end

	ex.EventManager:fire(EVENT.HERO_EVENT.HERO_PUERNUTE_GETHEROLIST, hero_data)




end

function HeroResponse:switchTargetList( data )
		-- 发送到那里
		local HeroAbilityData = require("src.data.HeroAbilityData")

	local hero_data = {}
		for i,v in ipairs(data.hero) do
			local hero = HeroAbilityData.new()
			hero.hero_id = v.hero_id
			hero.hero_type = v.hero_type
			hero.level = v.level
			hero.stage = v.stage
			hero.star = v.star
			hero.elem = v.elem
			hero.occupation = v.occupation
			hero.is_lock = v.is_lock == 1
			hero.hp_up_level = v.hp_up_level
			hero.atk_up_level = v.atk_up_level
			hero.fighting = v.fighting
			hero.equip = {}
            hero.tweak_cube_lv = v.tweak_cube_lv
            hero.tweak_cube_stage = v.tweak_cube_stage
			hero.awaken = v.awaken
			-- hero.bat = 2000 + math.random(1, 1000)
			table.insert( hero_data, hero )
		end

		ex.EventManager:fire(EVENT.HERO_EVENT.HERO_PUERNUTE, hero_data)
end

function HeroResponse:switch( data )

	ex.EventManager:fire(EVENT.HERO_EVENT.HERO_PUERNUTE_SUCCRESS, data.hero)
end


function HeroResponse:heroReborn()
	ex.EventManager:fire(EVENT.HERO_EVENT.HERO_REBORN)
	ex.EventManager:fire(EVENT.HERO_INFO_EVENT.EXIT_HREO_STAR_RESET)
end 

function HeroResponse:heroIllustratList(data,byte_array)

	cpp.ResponseManager:instance():response(byte_array)

	-- ex.Player.hero_data.hero_illustrat = {}
	-- print(list_count,"HeroResponse")
	for i,v in ipairs(data.list) do
		local hero_type = v.hero_type
		local star = v.star
		ex.Player.hero_data:addIllustrat(hero_type,star)
		ex.Player.hero_data:setIllustratUnLock(hero_type)
		-- print(hero_type , star,"HeroResponse")
	end
end

function HeroResponse:shopHeroCapacity(data)
	ex.Player.hero_data.hero_capacity = data.hero_capacity
	ex.Player.hero_data.buy_space_times = data.buy_space_times

	-- 刷新英雄界面的容量
 	local _, hero_layer = GetMainSceneLayer(MainSceneType.HERO_LAYER)
 	if not hero_layer then return end

    hero_layer:updateCapacity()
end

function HeroResponse:heroUpLevel( data )
	-- body
	-- ex.Tools:startClock()
	local res = {}
	res.hero_id = data.hero_id
	res.hero_level = data.hero_level

	local hero_data = ex.Player.hero_data:getHeroDataById(res.hero_id)
	local is_upLevel = not (res.hero_level == hero_data.level)

	-- if is_upLevel == true then 
	-- 	local config = cfg.herolevel.level[hero_data.level]
	-- 	ex.Player:addGold(-config.gold_need)
	-- 	ex.Player:addItem(ItemType.IT_HERO_EXP,-config.exp_need)
		hero_data.level = res.hero_level
	-- end

	-- ex.Tools:markClock()

	-- ex.Player.hero_data.promote.hero_level_red = {}
	-- local battleList = ex.Player.hero_data.promote:getBattleList()
	-- -- local maxLevel = ex.Player.hero_data.promote:getCanUpLevelMax()
	-- -- local cur_bat = 0
	-- -- local last_bat = 0
	-- local equip_bool
	-- for k,v in pairs(battleList) do
	-- 	local hero_data = ex.Player.hero_data:getHeroDataById(k)
	-- 	if hero_data ~= nil then 
	-- 		-- if hero_data.hero_id == res.hero_id then
	-- 		-- 	cur_bat = hero_data.bat
	-- 		-- end
	-- 		-- ex.Player.hero_data.promote:setHeroUp(k,hero_data.level < maxLevel)
	-- 		ex.Player.hero_data.promote:checkCanUpLevel(k)
	-- 		if not equip_bool then 
	-- 			equip_bool = ex.Player.hero_data.equip:checkBattleHeroEquip(k)
	-- 		end
	-- 		-- if hero_data.hero_id == res.hero_id then
	-- 		-- 	last_bat = hero_data.bat
	-- 		-- end
	-- 	else
	-- 		ex.Player.hero_data.promote:setHeroUp(k,false)
	-- 	end
	-- end
		ex.Player.hero_data.promote:checkCanUpLevel(res.hero_id)

	-- main_ctr:updateHeroUpgradeLayer()
	ex.EventManager:fire(EVENT.HERO_INFO_EVENT.HERO_UP_LEVEL)
	ex.EventManager:fire(EVENT.HERO_INFO_EVENT.UPDATA_HREO_RESET)
	

	-- ex.Tools:markClock()

	

	-- local bool = ex.Player.hero_data.promote:checkMainCityRedPoint()
	 
	-- ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_YXT, (bool or equip_bool))
end

function HeroResponse:heroUpgradeLevel( data, byte_array )
	-- body
	local res = {}
	res.hero_id = data.hero_id
	res.hero_stage = data.hero_stage
	-- res.hero_id = byte_array:readInt64()
	-- res.hero_stage = byte_array:readInt()
	-- res.hero_exp = byte_array:readInt()
	local hero_data = ex.Player.hero_data:getHeroDataById(res.hero_id)
	local is_upLevel = not (res.hero_stage == hero_data.stage)

	local old_cfg = cfg.heroupgrade.grade[hero_data.stage]
	local new_cfg = cfg.heroupgrade.grade[res.hero_stage]
	local config_hero_type = cfg.herotype.star[hero_data.hero_type]
	-- ex.Player:addItem(ItemType.IT_HERO_UP_STONE, -old_cfg.soul)
	-- ex.Player:addItem(ItemType.IT_GOLD, -old_cfg.gold)
	local idx = 1
	local unlock = false
	while idx do
		local old_skill = old_cfg["skill" .. idx]
		local new_skill = new_cfg["skill" .. idx]
		if not old_skill or not new_skill then break end

		if config_hero_type["skill_" .. idx] <= 0 then
			break
		end 

		unlock = old_skill == 0 and new_skill == 1 
		if unlock == true then break end
		idx = idx + 1
	end

	if is_upLevel == true then 
		hero_data.stage = res.hero_stage
	end

	local data = {unlock = unlock , idx = unlock and idx or 0}

	ex.EventManager:fire(EVENT.HERO_INFO_EVENT.HERO_UP_GRADE,data)

	-- local bool = ex.Player.hero_data.promote:checkMainCityRedPoint()
	-- ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_YXT, (bool or equip_bool))

end

function HeroResponse:heroUpgradeStar(data, byte_array)
	-- body
	local res = {}
	res.hero_id = data.hero_id
	res.hero_star = data.hero_star
	local hero_data = ex.Player.hero_data:getHeroDataById(res.hero_id)
	local is_upLevel = not (res.hero_star == hero_data.star)
    dump(data)

	if is_upLevel == true then 
		hero_data.star = res.hero_star
	end

    hero_data.tweak_cube_lv = data.tweak_cube_lv
    hero_data.tweak_cube_stage = data.tweak_cube_stage

	-- local list_count = byte_array:readInt()
	-- print("HeroResponse:heroUpgradeStar")
	-- dump_pbmsg(data)
	-- print("list_count", list_count)

	-- 返回物品
	res.reward = {}
	-- for i=1,list_count do
	for i,v in ipairs(data.item_list) do

		local item = {}
		item.id = v.id
		item.item_type = v.type
		item.item_num = v.num
		-- item.id = byte_array:readInt64()
		-- item.item_type = byte_array:readInt()
		-- item.item_num = byte_array:readInt()
		table.insert(res.reward,item)

		-- print("item.item_type,", item.item_type, item.item_num, item.id)
		-- ex.Player:addItem(item.item_type, item.item_num, item.id)
	end


	local consume_list = ex.Player.hero_data.promote:getComsumeHeroLists()
	-- dump(consume_list, "consume_list")
	for i,v in pairs(consume_list) do
		if i > 0 then 
			for _,val in pairs(v) do
				print("val.hero_id", val.hero_id)
				ex.Player.hero_data:removeHeroDataById(val.hero_id)
				ex.Player.hero_data.promote:setHeroUp(val.hero_id,nil)
				ex.Player.hero_data.equip:clearHeroEquipData(val.hero_id)
			end
		end
	end
	ex.Player.hero_data.promote:resetComsumeHeroList()
	ex.Player.hero_data.promote.hero_star_red = {}

	for k,v in pairs(ex.Player.hero_data.promote:getBattleList()) do
		ex.Player.hero_data.promote:checkUpStar(k)
	end

	local creatHero = ex.Player.hero_data.promote:getCreatHeroData()
	for k,v in pairs(creatHero) do
		ex.Player.hero_data.promote:checkUpStar(v,true)
	end

	local config = cfg.herostar.star[hero_data.star]
	-- if config ~= nil and config.upstar_cost ~= "" then 
		-- local cost = config.upstar_cost[1]
		-- ex.Player:addItem(cost.item_type,-cost.item_num)
	-- end

	-- ex.EventManager:fire(EVENT.HERO_INFO_EVENT.HERO_UP_STAR,hero_data)

	-- 没有扣除进阶石。所以要刷新背包
	-- 背包信息
    -- local req_backpack = cpp.ByteArray:create()
    -- req_backpack:writeInt(ProtocolID.GReqBackPackList)
    -- cpp.NetManager:instance():sendByteArray(req_backpack)
	NetManager:sendMessage(ProtocolID.GReqBackPackList)

	-- 请求刷新助阵信息
	NetManager:sendMessage(ProtocolID.GReqLineUp)
	
	local eventData = {}
	eventData.event = "EVENT.HERO_INFO_EVENT.HERO_UP_STAR"
	eventData.data = hero_data
	res.eventData = eventData
	res.title = ex.Tools:getLang(47269)

	ex.EventManager:fire(EVENT.BACK_PACK_EVENT.BACK_PACK_REFUND,res)

	-- local bool = ex.Player.hero_data.promote:checkMainCityRedPoint()
	-- ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_YXT, (bool or equip_bool))


	ex.Player.promotion_data:reqMarkHeroLists()
	ex.Player.hero_data.promote:checkCreatHeroRedPoint()

	local bool = ex.Player.hero_data.promote:checkMainCityRedPoint()
	local artifact_red = ex.Player.hero_data.artifact:checkMainCityRedPoint()
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_YXT, bool or artifact_red)
end

function HeroResponse:heroCreat( data, byte_array )
	-- body
	local HeroAbilityData = require("src.data.HeroAbilityData")
	local res = {}
	local hero = ProtocolResponse.PSHeroData(nil, nil, nil, byte_array)
	local hero = {}
	hero.hero_id = data.hero.id 
	hero.hero_type = data.hero.type 
	hero.level = data.hero.level 
	hero.stage = data.hero.stage 
	hero.star = data.hero.star
	hero.elem = data.hero.elem
	hero.occupation = data.hero.occupation
	hero.is_lock = data.hero.is_lock
	hero.hp_up_level = data.hero.hp_up_level
	hero.atk_up_level = data.hero.atk_up_level
    hero.tweak_cube_lv = data.hero.tweak_cube_lv
    hero.tweak_cube_stage = data.hero.tweak_cube_stage
	hero.awaken = data.hero.awaken
	hero.talents = {}
	for j = 1, #data.hero.talents do
		local talent = {}
		talent.slot = data.hero.talents[j].slot
		talent.skill_id = data.hero.talents[j].skill_id
		talent.level = data.hero.talents[j].level
		table.insert(hero.talents, talent)
	end

	hero.reiki_places = {}

	for k,val in ipairs(v.reiki_places) do
		hero.reiki_places[val] = val
	end

	local hero_type_config = cfg.herotype.star[hero.hero_type]
	if hero_type_config then
		hero.occupation = hero_type_config.occupation
		hero.elem = hero_type_config.elem
		hero.bat = 2000 + math.random(1, 1000)
	end
	ex.Player.hero_data:addHero(hero)

	-- local list_count = byte_array:readInt()

	local items = {}
	-- for i=1,list_count do
	for i,v in ipairs(data.item_list) do
		local item = {}
		item.id = v.id 
		item.item_type = v.type 
		item.item_num = v.num
		table.insert(items,item)
		-- ex.Player:addItem(item.item_type, item.item_num, item.id)
	end

	local consume_list = ex.Player.hero_data.promote:getComsumeHeroLists()

	for _,v in pairs(consume_list) do
		for _,val in pairs(v) do
			ex.Player.hero_data:removeHeroDataById(val.hero_id)
			local hero_equip = ex.Player.hero_data.equip:getHeroEquip(val.hero_id).equip_list
			for k,v in pairs(hero_equip) do
				-- ex.Player:addItem(v.item_type, 1 ,v.item_id)
			end
		end
	end
	ex.Player.hero_data.promote:resetComsumeHeroList()
	ex.Player.hero_data.promote.hero_star_red = {}
	ex.Player.hero_data.promote.creat_hero_red = {}
	ex.Player.hero_data.promote.creat_hero_count = {}

	for k,v in pairs(ex.Player.hero_data.promote:getBattleList()) do
		ex.Player.hero_data.promote:checkUpStar(k)
	end

	local creatHero = ex.Player.hero_data.promote:getCreatHeroData()
	for k,v in pairs(creatHero) do
		ex.Player.hero_data.promote:checkUpStar(v,true)
	end

	-- local req_backpack = cpp.ByteArray:create()
 --  	req_backpack:writeInt(ProtocolID.GReqBackPackList)
 --  	cpp.NetManager:instance():sendByteArray(req_backpack)
    NetManager:sendMessage(ProtocolID.GReqBackPackList)

    
	local eventData = {}
	eventData.event = "EVENT.HERO_CREAT_EVENT.HERO_CREAT_SUCCESS"
	eventData.data = hero
	res.eventData = eventData
	res.reward = items
	res.title = ex.Tools:getLang(47269)

	ex.EventManager:fire(EVENT.BACK_PACK_EVENT.BACK_PACK_REFUND,res)

	local bool = ex.Player.hero_data.promote:checkMainCityRedPoint()
	local artifact_red = ex.Player.hero_data.artifact:checkMainCityRedPoint()
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_YXT, bool or artifact_red)
	ex.Player.hero_data.promote:checkCreatHeroRedPoint()

end

function HeroResponse:heroEquipData(data)
	ex.Player.hero_data.magic_wand:clear()

	for i,v in ipairs(data.equip_list) do
		local equip = {}
		equip.hero_id = v.hero_id
		equip.equip_list = {}

		for j,e in ipairs(v.equip_list) do
			local ep = {}
			ep.item_id = e.equip_id
			ep.item_type = e.equip_type
			ep.soul_lv = e.soul_lv
			local cfg = cfg.equipmenttype.equip[ep.item_type]
			if cfg ~= nil then 
				equip.equip_list[cfg.place] = ep
			end
		end
		ex.Player.hero_data.equip:setHeroEquip(equip)

		if v.magic_info.magic_id ~= 0 then
			ex.Player.hero_data.magic_wand:addHeroMagicWand(v.magic_info)
		end
	end





	ex.EventManager:fire(EVENT.HERO_EQUIP_EVENT.HERO_EQUIP_INIT_FINISH)
end

function HeroResponse:heroEquipChange(data , byte_array )
	-- body
	-- local hero_id = byte_array:readInt64()
	-- local place  = byte_array:readInt8()
	-- local equip_data = {}
	-- equip_data.item_id = byte_array:readInt64()
	-- equip_data.item_type = byte_array:readInt()
	local hero_id = data.hero_id
	-- local equip_id = data.sys_id
	local equip = {}
	equip.item_id = data.equip.equip_id
	equip.item_type = data.equip.equip_type
	equip.place = data.equip.place
	equip.soul_lv = data.equip.soul_lv
	local place = equip.place
	-- local equip_data = ex.Player.backpack_data:getItemDataByType(equip_id)
	-- if not equip_data then 
	-- 	equip_data = {}
	-- 	equip_data.item_type = equip_id
	-- 	equip_data.num = 1
	-- 	equip_data.item_id = "0"
	-- end 
	-- local place = cfg.equipmenttype.equip[equip_data.item_type].place
	-- local place = cfg.equipmenttype.equip[equip_id].place

	local hero_equip = ex.Player.hero_data.equip:getHeroEquip(hero_id)
	local place_table = {}
	-- if hero_equip.equip_list[place] == nil then 
	-- 	hero_equip.equip_list[place] = equip_data
	-- else
	-- 	local item_data = hero_equip.equip_list[place]
	-- 	-- ex.Player:addItem(item_data.item_type, 1 ,item_data.item_id)
	-- 	hero_equip.equip_list[place] = equip_data

	-- end
	hero_equip.equip_list[place] = equip
	table.insert(place_table,place)
	-- ex.Player.backpack_data:removeItemById(equip_data.item_id)

	ex.EventManager:fire(EVENT.HERO_EQUIP_EVENT.HERO_EQUIP_CHANGE,place_table)

	-- local equip_red = ex.Player.hero_data.equip:checkHeroEquipRedPointByScene()
	-- local bool = ex.Player.hero_data.promote:checkMainCityRedPoint()
	-- ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_YXT, equip_red or bool)
	ex.Player.hero_data.equip:initRedPoint()

	local equip_red = ex.Player.hero_data.equip:checkHeroEquipRedPointByScene()
	local bool = ex.Player.hero_data.promote:checkMainCityRedPoint()
	local artifact_red = ex.Player.hero_data.artifact:checkMainCityRedPoint()
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_YXT, equip_red or bool or artifact_red)

	ex.AudioManager:playEffect("music/equip-wear-1.mp3")
end

function HeroResponse:heroEquipDisboard (data , byte_array )
	-- body
	-- local hero_id = byte_array:readInt64()
	-- local place  = byte_array:readInt8()
	-- local equip_data = {}
	-- equip_data.item_id = byte_array:readInt64()
	-- equip_data.item_type = byte_array:readInt()
	-- dump_pbmsg(data)
	local hero_id = data.hero_id
	-- local equip_type = data.equip_type
	local equip = {}
	equip.item_id = data.equip.equip_id
	equip.item_type = data.equip.equip_type
	equip.place = data.equip.place

	equip.soul_lv = data.equip.soul_lv
	local place_table = {}

	local hero_equip = ex.Player.hero_data.equip:getHeroEquip(hero_id)
	local place = equip.place
	local equip_data = {}

	-- for k,v in pairs(hero_equip.equip_list) do
	-- 	if v.item_type == equip_type then 
	-- 		equip_data.item_type = v.item_type
	-- 		equip_data.item_id = v.equip_id
	-- 		place = cfg.equipmenttype.equip[v.item_type].place
	-- 		break
	-- 	end
	-- end

	-- hero_equip.equip_list[place] = nil
	hero_equip.equip_list[place] = equip

	table.insert(place_table,place)


	ex.EventManager:fire(EVENT.HERO_EQUIP_EVENT.HERO_EQUIP_CHANGE,place_table)

	ex.Player.hero_data.equip:initRedPoint()
	local equip_red = ex.Player.hero_data.equip:checkHeroEquipRedPointByScene()
	local bool = ex.Player.hero_data.promote:checkMainCityRedPoint()
	local artifact_red = ex.Player.hero_data.artifact:checkMainCityRedPoint()
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_YXT, equip_red or bool or artifact_red)

end

function HeroResponse:heroIllustratUpdate(data,byte_array)
	-- local hero_type = byte_array:readInt()
	-- local star = byte_array:readInt()
	print("HeroResponse:heroIllustratUpdate")
	-- dump_pbmsg(data)
	local hero_type  = data.hero_type
	local star  = data.star
	ex.Player.hero_data:addIllustrat(hero_type,star)
	ex.Player.hero_data:setIllustratUnLock(hero_type)
	ex.EventManager:fire(EVENT.HERO_INFO_EVENT.HERO_ILLUSTRAT_ACTIVE)
end

function HeroResponse:heroOneKeyEquip( data , byte_array )
	local hero_id = data.hero_id 
	-- local hero_id = byte_array:readInt64()
	local count  = byte_array:readInt8()
	local hero_equip = ex.Player.hero_data.equip:getHeroEquip(hero_id).equip_list
	local place_table = {}
	local equip_data = {}
	-- for i=1,count do
	for k,v in ipairs(data.equip) do
		local equip = {}
		equip.item_id = v.equip_id
		equip.item_type = v.equip_type
		equip.soul_lv = v.soul_lv
		local place = v.place

		if hero_equip[place] ~= nil then 
			-- ex.Player:addItem(hero_equip[place].item_type, 1 ,hero_equip[place].item_id)
		end
		
		hero_equip[v.place] = equip
		ex.Player.backpack_data:removeItemById(equip.item_id)
		equip_data[place] = equip
		table.insert(place_table,place)
	end

	ex.EventManager:fire(EVENT.HERO_EQUIP_EVENT.HERO_EQUIP_CHANGE,place_table)

	-- local equip_red = ex.Player.hero_data.equip:checkHeroEquipRedPointByScene()
	-- local bool = ex.Player.hero_data.promote:checkMainCityRedPoint()
	-- ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_YXT, equip_red or bool)
	ex.Player.hero_data.equip:initRedPoint()
	local equip_red = ex.Player.hero_data.equip:checkHeroEquipRedPointByScene()
	local bool = ex.Player.hero_data.promote:checkMainCityRedPoint()
	local artifact_red = ex.Player.hero_data.artifact:checkMainCityRedPoint()
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_YXT, equip_red or bool or artifact_red)
end

function HeroResponse:heroOneKeyDisboard( data , byte_array )

	local hero_id = data.hero_id
	local hero_equip = ex.Player.hero_data.equip:getHeroEquip(hero_id)
	local place_table = {}

	for k,v in ipairs(data.equip) do
		print("heroOneKeyDisboard",v.equip_type, 1 ,v.equip_id)
		-- ex.Player:addItem(v.equip_type, 1 ,v.equip_id)
		local place = v.place
		hero_equip.equip_list[place] = nil
		table.insert(place_table,place)
	end
	-- local hero_id = byte_array:readInt64()
	-- local count  = byte_array:readInt8()
	-- local hero_equip = ex.Player.hero_data.equip:getHeroEquip(hero_id)
	-- local place_table = {}
	-- for k,v in pairs(hero_equip.equip_list) do
	-- 	ex.Player:addItem(v.item_type, 1 ,v.item_id)
	-- 	local place = cfg.equipmenttype.equip[v.item_type].place
	-- 	table.insert(place_table,place)
	-- 	v = nil
	-- end
	hero_equip.equip_list = {}
	ex.EventManager:fire(EVENT.HERO_EQUIP_EVENT.HERO_EQUIP_CHANGE,place_table)

	-- local equip_red = ex.Player.hero_data.equip:checkHeroEquipRedPointByScene()
	-- local bool = ex.Player.hero_data.promote:checkMainCityRedPoint()
	-- ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_YXT, equip_red or bool)
	ex.Player.hero_data.equip:initRedPoint()
	local equip_red = ex.Player.hero_data.equip:checkHeroEquipRedPointByScene()
	local bool = ex.Player.hero_data.promote:checkMainCityRedPoint()
	local artifact_red = ex.Player.hero_data.artifact:checkMainCityRedPoint()
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_YXT, equip_red or bool or artifact_red)
end

function HeroResponse:heroFighting(data)
	local hero_data = ex.Player.hero_data:getHeroDataById(data.hero_id)
	if hero_data then
		hero_data.atk = data.atk or 0
		hero_data.def = data.def or 0
		hero_data.hp = data.hp or 0
		hero_data.spd = data.spd or 0
		hero_data.fighting = data.new_fighting
	end
	ex.EventManager:fire(EVENT.HERO_INFO_EVENT.HERO_UP_LEVEL)
	ex.EventManager:fire(EVENT.HERO_INFO_EVENT.HERO_FIGHTING_CHANGE, data.new_fighting)

	if  data.new_fighting > data.ori_fighting then
		ex.EventManager:fire(EVENT.HERO_INFO_EVENT.HERO_ATTACKUP, data.ori_fighting, data.new_fighting - data.ori_fighting, data.new_fighting)
	end
end

function HeroResponse:roleFighting(data)
	-- 如果是heroinfo界面，则不显示总战力变化
	local layer_type = ex.MainSceneCtr:getCurLayerType()
	if layer_type ~= MainSceneType.HERO_INFO_LAYER and data.new_fighting > data.ori_fighting then
		ex.EventManager:fire(EVENT.HERO_INFO_EVENT.HERO_ATTACKUP, data.ori_fighting, data.new_fighting - data.ori_fighting, data.new_fighting)
	end
	
	-- 加载攻击力增减显示控制器
	ex.Player.fighting = data.new_fighting
	ex.EventManager:fire(EVENT.MAIN_SCENE.UPDATE_FIGHTING, data.ori_fighting, data.new_fighting)
end

function HeroResponse:heroAdd(data)
	local HeroAbilityData = require("src.data.HeroAbilityData")
	for i,v in ipairs(data.heros) do
		local hero = HeroAbilityData.new()
		hero.hero_id = v.hero_id
		hero.hero_type = v.hero_type
		hero.level = v.level
		hero.stage = v.stage
		hero.star = v.star
		hero.elem = v.elem
		hero.occupation = v.occupation
		hero.is_lock = v.is_lock == 1
		hero.hp_up_level = v.hp_up_level
		hero.atk_up_level = v.atk_up_level
		hero.fighting = v.fighting
        hero.tweak_cube_lv = v.tweak_cube_lv
        hero.tweak_cube_stage = v.tweak_cube_stage
		hero.awaken = v.awaken
		hero.talents = {}
		for j = 1, #v.talents do
			local talent = {}
			talent.slot = v.talents[j].slot
			talent.skill_id = v.talents[j].skill_id
			talent.level = v.talents[j].level
			table.insert(hero.talents, talent)
		end

		hero.reiki_places = {}

		for k,val in ipairs(v.reiki_places) do
			hero.reiki_places[val] = val
		end

		hero.equip = {}
		ex.Player.hero_data:addHero(hero)
	end

	ex.Player.hero_data:initSort()
	ex.Player.hero_data.promote:initUpStarRedPoint()

	ex.EventManager:fire(EVENT.HERO_EVENT.ADD)
end

function HeroResponse:heroDelete(data)
	for i,v in ipairs(data.heros) do
		ex.Player.hero_data:removeHeroDataById(v)
	end

	ex.EventManager:fire(EVENT.HERO_EVENT.DELETE)
end

function HeroResponse:heroCapacity(data)
	ex.Player.hero_data.hero_capacity = data.heroCapacity
end

function HeroResponse:onHeroShare(data)
	ex.MessageView:add(ex.Tools:getLang(41215))
end

function HeroResponse:onShareHeroInfo(data)
	print("HeroResponse:onShareHeroInfo")
	-- local HeroAbilityData = require("src.data.HeroAbilityData")
	-- local hero = HeroAbilityData.new()
	local hero = {}
	-- hero.hero_id = data.hero.hero_id
	hero.hero_type = data.hero.hero.hero_type
	hero.level = data.hero.hero.level
	hero.stage = data.hero.hero.stage
	hero.star = data.hero.hero.star
	-- hero.elem = data.hero.elem
	hero.atk = data.hero.hero.atk
	hero.def = data.hero.hero.def
	hero.hp = data.hero.hero.hp
	hero.agl = data.hero.hero.agl
    hero.tweak_cube_lv = data.hero.hero.tweak_cube_lv
    hero.tweak_cube_stage = data.hero.hero.tweak_cube_stage
	hero.awaken = data.hero.hero.awaken

	hero.fighting = data.hero.hero.fighting
	hero.fashion_id = data.hero.hero.fashion_id
	hero.reiki_places = {}
	for i,v in ipairs(data.hero.hero.reiki_places) do
		hero.reiki_places[v] = v
	end

	hero.evolve = data.hero.hero.evolve

	local equip_list = {}
	local rune_list = {}
	local gems_list = {}
	local talent_list = {}
	local god_equip_list = {}
	local reiki_equip_list = {}

	for i,v in ipairs(data.hero.rune_list) do
		local dt = {}
		dt.ability_id = v.ability_id
		dt.item_type = v.item_type
		dt.skill = v.skill
		-- for k,val in pairs(v.skill) do
		-- 	-- local skill_data = v.skill[i]
		-- 	dt.skill[i].sort = val[k]
		-- 	dt.skill[i].skill_id = val[k]
		-- 	dt.skill[i].level = val[k]
		-- end
		-- dt.equipment_type = v.equip_type
		rune_list[i] = dt
	end
	for i,v in ipairs(data.hero.equip_list) do
		local dt = {}
		dt.equip_id = v.equip_id
		dt.equip_type = v.equip_type
		dt.item_type = v.equip_type
		dt.soul_lv = v.soul_lv and v.soul_lv or 0
		-- dt.equipment_type = v.equip_type
		dt.place = v.place
		equip_list[i] = dt
	end
	for i,v in ipairs(data.hero.jewel_list) do
		local jewel = {}
		jewel.jewel_id = v.jewel_id
		jewel.place = v.place
		jewel.jewel_type = v.jewel_type

		table.insert(gems_list, jewel)
	end
	for i,v in ipairs(data.hero.talent_list) do
		local talent = {}
		talent.slot = v.slot
		talent.skill_id = v.skill_id
		talent.level = v.level

		table.insert(talent_list, talent)
	end
	for i,v in ipairs(data.hero.god_equip_list) do
		local god_equip = {}
		god_equip.hero_id = 1
		god_equip.item_type = v.sys_id
		god_equip.attrs = v.attrs
		god_equip.is_share = true
		god_equip.equip_list = god_equip_list
		table.insert(god_equip_list, god_equip)
	end
	for i,v in ipairs(data.hero.reiki_equip_list) do
		local reiki_equip = {}
		reiki_equip.sys_id = v 
		local conf = cfg.reikiequip.reikiequip[v]
		reiki_equip.place = conf.place
		reiki_equip_list[conf.place] = reiki_equip
		-- table.insert(reiki_equip_list, reiki_equip)
	end

	local pet_data = data.hero.hero.pet
	local totem_data = data.hero.hero.totems
	local magic_wand_data = data.hero.magic_info

	local occupation = cfg.herotype.star[data.hero.hero.hero_type].occupation
	local unicorn_data = {}
	unicorn_data.rare_attr = data.hero.unicorn_rare_attr
	unicorn_data.grade = data.hero.unicorn_grade
	unicorn_data.strengthen_lv = data.hero.unicorn_strength
	unicorn_data.occupation = occupation
	require("src.layer.heroinfo.HeroShareInfoCtr"):instance()
		:openWindow(hero,
					equip_list,
					rune_list, 
					gems_list, 
					talent_list, 
					god_equip_list,
					reiki_equip_list,
					pet_data,
					totem_data,
					magic_wand_data,
					unicorn_data)
end

function HeroResponse:onLock(data)
	local hero_data = ex.Player.hero_data:getHeroDataById(data.hero_id)
	if hero_data == nil then return end

	hero_data.is_lock = data.is_lock > 0

	ex.MessageView:add(ex.Tools:getLang((hero_data.is_lock == true) and 41269 or 41270))

	ex.EventManager:fire(EVENT.HERO_INFO_EVENT.HERO_FIGHTING_CHANGE)
end




--------------------------------------------------------影星宝石
function HeroResponse:heroJewel(data)
	local save_hero_stone_list = {}

	for i,v in ipairs(data.jewel_list) do
		local now_data = {}
		now_data.hero_id = v.hero_id
		local jewel_data = {}
		for ji,jv in ipairs(v.jewel_list) do
			local now_jewel_data = {} 
			now_jewel_data.jewel_id = jv.jewel_id
			now_jewel_data.place = jv.place
			now_jewel_data.jewel_type = jv.jewel_type
			table.insert( jewel_data, now_jewel_data )
		end
		now_data.jewel_list = jewel_data
		save_hero_stone_list[now_data.hero_id] = now_data
	end

	ex.Player.hero_data:setHeroJewelList(save_hero_stone_list)
end

function HeroResponse:heroJewelChange(data)
	
	local hero_id = data.hero_id 
	--local jewel_data = data.jewel[1] 
	local jewel_data = {}
	jewel_data.jewel_id = data.jewel.jewel_id
	jewel_data.place = data.jewel.place
	jewel_data.jewel_type = data.jewel.jewel_type

	ex.Player.hero_data:changeHeroJewelListForHeroid(hero_id, jewel_data)
	ex.EventManager:fire(EVENT.HERO_INFO_EVENT.HERO_UPDATE_STONE)
	
end

function HeroResponse:heroJewelDisboard(data)
	local hero_id = data.hero_id 
	local jewel_data = {}
	jewel_data.jewel_id = data.jewel.jewel_id
	jewel_data.place = data.jewel.place
	jewel_data.jewel_type = data.jewel.jewel_type
	ex.Player.hero_data:subHeroJewelListForHeroid(hero_id, jewel_data)

	ex.EventManager:fire(EVENT.HERO_INFO_EVENT.HERO_UPDATE_STONE)

end

function HeroResponse:heroJewelOneKeyWear(data)

	local jewel_data = {}
	local hero_id = data.hero_id 
	for ji,jv in ipairs(data.jewel) do
		local now_jewel_data = {} 
		now_jewel_data.jewel_id = jv.jewel_id
		now_jewel_data.place = jv.place
		now_jewel_data.jewel_type = jv.jewel_type
		table.insert( jewel_data, now_jewel_data )
	end

	ex.Player.hero_data:refreshJewelData(hero_id, jewel_data)
	ex.EventManager:fire(EVENT.HERO_INFO_EVENT.HERO_UPDATE_STONE)

end

function HeroResponse:heroJewelOneKeyDisboard(data)

	local jewel_data = {}
	local hero_id = data.hero_id 
	for ji,jv in ipairs(data.jewel) do
		local now_jewel_data = {} 
		now_jewel_data.jewel_id = jv.jewel_id
		now_jewel_data.place = jv.place
		now_jewel_data.jewel_type = jv.jewel_type
		table.insert( jewel_data, now_jewel_data )
	end

	ex.Player.hero_data:refreshJewelData(hero_id, jewel_data)

	ex.EventManager:fire(EVENT.HERO_INFO_EVENT.HERO_UPDATE_STONE)

end

------------------------------------------------------------------------------
-- 英雄评论
function HeroResponse:heroCommentInfo(data)
	
	ex.EventManager:fire(EVENT.HERO_INFO_EVENT.HERO_COMMENT_INFO, data)
end

-- 评论成功返回消息（单独写一个函数原因是显示一下评论成功的字样）
function HeroResponse:UpdateheroCommentsSccessInfo(data)
	ex.MessageView:add(ex.Tools:getLang(4607))
	ex.EventManager:fire(EVENT.HERO_INFO_EVENT.UPDATE_COMMENT_INFO, data)
end


function HeroResponse:UpdateheroCommentInfo(data)
	
	ex.EventManager:fire(EVENT.HERO_INFO_EVENT.UPDATE_COMMENT_INFO, data)
end

-- 英雄點贊
function HeroResponse:UpdateheroCommentLikeInfo(data)
	
	ex.EventManager:fire(EVENT.HERO_INFO_EVENT.UPDATE_COMMENT_LIKE_INFO, data)
end


------------------------------------------------------------------------------
function HeroResponse:heroPalaceInfo(data)
	ex.Player.hero_data.hero_palace_list = data.hero_palace
	-- ex.Player.hero_data:updateHeroPalaceReddot(cc.UserDefault:getInstance():getIntegerForKey("server_id"))
	ex.Player.hero_data:updateHeroPalacehallReddot()
	ex.EventManager:fire(EVENT.HERO_PALACE_EVENT.UPDATE_LAYER)
end

function HeroResponse:heroPalaceWorship(data)
    NetManager:sendMessage(ProtocolID.GReqHeroPalaceData)
end

function HeroResponse:heroPalaceGetReward(data)
    NetManager:sendMessage(ProtocolID.GReqHeroPalaceData)
end

------------------------------进化--------------------------------------------
function HeroResponse:heroEvolution(data)
	if not data or type(data.hero_id) ~= "number" or not data.evolve then
		return
	end

	local hero_data = ex.Player.hero_data:getHeroDataById(data.hero_id)
	if not hero_data then
		return
	end
	
	local evolve_type = data.evolve.type
	local evolve_level = data.evolve.level

	hero_data.evolve = {
		type = evolve_type,
		level = evolve_level
	}

	ex.EventManager:fire(EVENT.HERO_INFO_EVENT.UPDATE_EVOLVE, {hero_data = hero_data, attr_update = data.update})
end

----------------背包英雄回退
function HeroResponse:evolveComeBack(data)
	if not data or type(data.hero_id) ~= "number"then
		return
	end
	local hero_data = ex.Player.hero_data:getHeroDataById(data.hero_id)
	if not hero_data then
		return
	end
	local evolve_type = data.evolve.type
	local evolve_level = data.evolve.level

	hero_data.evolve = {
		type = evolve_type,
		level = evolve_level
	}
	ex.EventManager:fire(EVENT.HERO_EVENT.HERO_EXIT_BACK_SUCCRESS, data)
end

----------------英雄觉醒
function HeroResponse:awakenSelect(data)
	local hero_data = ex.Player.hero_data:getHeroDataById(data.hero_id)
	if hero_data then
		hero_data.awaken = data.awaken
	end

	ex.EventManager:fire(EVENT.HERO_INFO_EVENT.AWAKEN)
end

----------------英雄装备附魂
function HeroResponse:heroEquipSoulLvUp(data)
	local hero_id = data.hero_id
	local equip = {}
	equip.item_id = data.equip_data.equip_id
	equip.item_type = data.equip_data.equip_type
	equip.place = data.equip_data.place
	equip.soul_lv = data.equip_data.soul_lv
	local place = equip.place

	local hero_equip = ex.Player.hero_data.equip:getHeroEquip(hero_id)
	local place_table = {}

	hero_equip.equip_list[place] = equip
	ex.EventManager:fire(EVENT.HERO_INFO_EVENT.SOUL)
	ex.EventManager:fire(EVENT.HERO_INFO_EVENT.SOUL_RESULT)
end

----------------英雄装备附魂重置
function HeroResponse:heroEquipSoulReset(data)
	local hero_id = data.hero_id
	local equip = {}
	equip.item_id = data.equip_data.equip_id
	equip.item_type = data.equip_data.equip_type
	equip.place = data.equip_data.place
	equip.soul_lv = data.equip_data.soul_lv
	local place = equip.place

	local hero_equip = ex.Player.hero_data.equip:getHeroEquip(hero_id)
	local place_table = {}

	hero_equip.equip_list[place] = equip
	ex.EventManager:fire(EVENT.HERO_INFO_EVENT.SOUL)
end

-------------------------英雄重生---------
function HeroResponse:updataHeroResetNum(data)
	ex.Player.hero_data:setHeroResetNum(data)
end

function HeroResponse:heroLevelReset(data)
	local hero_data = ex.Player.hero_data:getHeroDataById(data.hero_id)
	hero_data.level = data.hero_level
	hero_data.stage = 0
	ex.EventManager:fire(EVENT.HERO_INFO_EVENT.HERO_UP_LEVEL)
	ex.EventManager:fire(EVENT.HERO_INFO_EVENT.UPDATA_HREO_RESET)
	ex.EventManager:fire(EVENT.HERO_INFO_EVENT.EXIT_HREO_RESET)
end

------------------------------永久皮肤---------------------------------
function HeroResponse:resheroSkinList(data)
	ex.Player.hero_data:setheroSkinList(data)
end



return HeroResponse
