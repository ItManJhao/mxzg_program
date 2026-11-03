local ProphetResponse = class("ProphetResponse")


function ProphetResponse:prophetSummon(data)
    -- local award_list = {}
    -- local list_count = byte_array:readInt()
  --   for i=1,list_count do
  --   	local data = {}
  --   	data.item_id = byte_array:readInt64()
  --   	data.item_type = byte_array:readInt()
		-- data.item_num = byte_array:readInt()
		-- ex.Player:addItem(data.item_type, data.item_num, data.item_id)

  --   	table.insert(award_list, data)
  --   end

--   for i,v in ipairs(data.award) do
--   	local item = {}
-- 	item.item_id = v.id
-- 	item.item_type = v.type
-- 	item.item_num = v.num
-- 	ex.Player:addItem(item.item_type, item.item_num, item.item_id)
--     table.insert(award_list, item)
--   end


  	local _, cur_layer = GetMainSceneLayer(MainSceneType.MAINCITY_PROPHET_TREE)
    if cur_layer then
    	cur_layer:touchSwallowTouches(false)
		
		-- 展示先知抽奖
		cur_layer:handleSummonResult(data)
    end
	
	ex.Player.promotion_data:reqProphecyLists()
end

function ProphetResponse:prophetSummonLuck(data)
	ex.Player.prophet_data.vec_lucks = data.luckys

	ex.EventManager:fire(EVENT.PROPHET.CHANGE_LUCK)
end

function ProphetResponse:changeHero(data)
	ex.Player.prophet_data.change_data.before_hero_id = data.before_hero_id
	ex.Player.prophet_data.change_data.after_hero_type = data.after_hero_type

	-- ex.log(string.format("changeHero: before_hero_id = %s, after_hero_type = %d", 
	-- 	ex.Player.prophet_data.change_data.before_hero_id,
	-- 	ex.Player.prophet_data.change_data.after_hero_type))

	-- 置换英雄 跳转确认
 	local _, cur_layer = GetMainSceneLayer(MainSceneType.MAINCITY_PROPHET_TREE)
 	if cur_layer then
    	cur_layer:jumpToConfirmChange()
    end
end

return ProphetResponse