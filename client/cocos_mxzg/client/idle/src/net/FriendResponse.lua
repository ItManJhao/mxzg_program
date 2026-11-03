local FriendResponse = class("FriendResponse")

 
function FriendResponse:friendsGive(data)
	print("FriendResponse:friendsGive")
	dump_pbmsg(data)
	local friend_data = ex.Player.friend_data:getFriendById(data.rid)
	if not friend_data then return end 
	friend_data.has_gift = 1
	-- -- 获得道具
	-- -- local data = NetManager:resLuaData(ProtocolResponse.ResFriendsGive, byte_array)
	-- for k,v in ipairs(data.list) do
	-- 	local item = {}
	-- 	item.item_type = v.type
	-- 	item.item_num = v.num
	-- 	ex.Tools:addBackpackMsg(item.item_type, item.item_num)
	-- 	-- ex.Player:addItem(v.item_type, v.item_num, v.item_id, v.ex_attr_idx, v.skill_type_1, v.skill_num_1, v.skill_type_2, v.skill_num_2)
	-- 	-- ex.Player:addItem(item.item_type, item.item_num)
	-- end
	ex.Player.friend_data:checkGiftRed()
	ex.EventManager:fire(EVENT.FRIEND_EVENT.GET_FRIEND_REWARD)
end


function FriendResponse:friendsListInfo(data)
	-- print("FriendResponse:friendsListInfo")
	-- dump_pbmsg(data)
	ex.Player.friend_data:friendsListInfo(data)
    -- ResFriendsListInfo* res = reinterpret_cast<ResFriendsListInfo*>(buffer);
    -- RoleData::instance()->friends_data.friendsListInfo(res);
    
	-- FriendCtr::instance()->updateLayer();
	ex.Player.friend_data:checkGiftRed()
    ex.EventManager:fire(EVENT.FRIEND_EVENT.UPDATE_FRIEND_LIST)

end


function FriendResponse:friendsRequestInfo(data)
	ex.Player.friend_data:friendRequstInfo(data)

end

-- 黑名单列表
function FriendResponse:blackList(data)
	ex.Player.friend_data:friendBlackListInfo(data.black_list)

	ex.EventManager:fire(EVENT.FRIEND_EVENT.UPDATE_BLACK_LIST)
end

-- 黑名单添加成员
function FriendResponse:blackListAdd(data)
    NetManager:sendMessage(ProtocolID.GReqBlackList)
end

-- 黑名单移除成员
function FriendResponse:blackListRemove(data)
    NetManager:sendMessage(ProtocolID.GReqBlackList)
end

function FriendResponse:friendsSearch(data)
	-- print("FriendResponse:friendsSearch")
	-- dump_pbmsg(data)
	-- local data = NetManager:resLuaData(ProtocolResponse.ResFriendsSearch, byte_array)

	ex.Player.friend_data:clearSearchList()

	local function newFriendData (friend_data)
		local d = {}
		d.battle        = friend_data.battle
		d.clan_icon_id  = friend_data.clan_icon_id
		d.clan_id       = friend_data.clan_id
		d.clan_name     = friend_data.clan_name
		d.cup           = friend_data.cup
		d.head_id       = friend_data.head_id
		d.is_gift       = friend_data.is_gift
		-- d.is_gived      = friend_data.is_gived
		-- d.is_reward     = friend_data.is_reward
		d.has_gift     = friend_data.has_gift
		d.is_vip        = friend_data.is_vip
		d.offline_time  = friend_data.offline_time
		d.online_status = friend_data.online_status
		d.player_level  = friend_data.player_level
		d.player_name   = friend_data.player_name
		d.role_id       = friend_data.role_id
		d.border_id 	= friend_data.border_id
		return d
	end
	-- for i=1,data.list do
	for i,v in ipairs(data.list) do
		local friend_data = newFriendData(v)
		-- print(string.len(friend_data.player_name),">>>>>>>>>>>")
		-- dump(friend_data)
		if string.len(friend_data.player_name) > 0 then 
			table.insert(ex.Player.friend_data.friend_search,friend_data)
		end
	end


	ex.EventManager:fire(EVENT.FRIEND_EVENT.UPDATE_SEARCH_LIST)

	-- FriendSearchCtr::instance()->updateLayer(true);
	-- LoadingSceneCtr::instance()->receivedProtocol(res->protocol);
end


function FriendResponse:friendsAdd(data)
	print("FriendResponse:friendsAdd")
	dump_pbmsg(data)
	-- local data = NetManager:resLuaData(ProtocolResponse.ResFriendsAdd, byte_array)
	-- dump(data)
	
	-- if ex.Player.role_id == data.resFriendData.role_id then return end 
	-- ex.Player.friend_data:friendAdd(data)
	ex.MessageView:add(string.format(ex.Tools:getLang(41185), data.target_nick), 0)
	-- ex.EventManager:fire(EVENT.FRIEND_EVENT.UPDATE_FRIEND_LIST)
	-- ex.EventManager:fire(EVENT.FRIEND_EVENT.UPDATE_FRIEND_LIST)
end

function FriendResponse:friendApplying(data)
	print("FriendResponse:friendApplying")
	dump_pbmsg(data)
	ex.Player.friend_data:friendAdd(data)
	ex.MessageView:add(string.format(ex.Tools:getLang(41186), data.resFriendData.player_name), 0)
	ex.EventManager:fire(EVENT.FRIEND_EVENT.UPDATE_FRIEND_LIST)
end


function FriendResponse:friendsAgree(data)
	print("FriendResponse:friendsAgree")
	dump_pbmsg(data)
	-- local data = NetManager:resLuaData(ProtocolResponse.ResFriendsAgree, byte_array)
	-- dump(data)
	if data.resFriendData.role_id ~= "0" then 
		print(data.resFriendData.role_id ,">>>>>>>")
		ex.Player.friend_data:friendsAgree(data)
	end
	ex.EventManager:fire(EVENT.FRIEND_EVENT.UPDATE_FRIEND_LIST)
end


function FriendResponse:friendsDelete(data)
	print("FriendResponse:friendsDelete")
	dump_pbmsg(data)
	-- local data = NetManager:resLuaData(ProtocolResponse.ResFriendsDelete, byte_array)
	-- dump(data)
	if data.rid ~= "0" then 
		ex.Player.friend_data:friendsDelete(data)
	end
	ex.Player.chat_data:updateChatFriend()
	ex.Player.friend_data:checkGiftRed()
	ex.EventManager:fire(EVENT.FRIEND_EVENT.DELETE_FRIEND)
	
	NetManager:sendMessage(ProtocolID.GReqChatNum)
end

function FriendResponse:friendsChatList(data)
	-- print("FriendResponse:friendsChatList")
	-- dump_pbmsg(data)
	-- local data = NetManager:resLuaData(ProtocolResponse.ResFriendsChatList, byte_array)
	-- dump(data)
	-- for i=1,data.list_count do
	for i,v in ipairs(data.list) do

		local chat_data = v
		local read_time = ex.Player.friend_data:getFriendsChatLastReadTime(chat_data.friend_id)

		local friends_chat = ex.Player.chat_data.map_chat_friends
		local friend_chat = friends_chat[chat_data.friend_id]
		if not friend_chat then 
			friends_chat[chat_data.friend_id] = {}
		end

		local unit = ex.Player.chat_data:newChatUnit()
		unit.chat_type = 5
		unit.send_time = chat_data.time 
		unit.str_chat_content = chat_data.chat_content
		unit.unread_chat = chat_data.time > read_time

		if chat_data.manage_id == ex.Player.role_id then 
			unit.manager_id = ex.Player.role_id
			unit.photo = ex.Player.head_id
			unit.member_id = chat_data.friend_id
		else 
			unit.manager_id = chat_data.friend_id
			unit.photo = chat_data.head_id
			unit.member_id = ex.Player.role_id
		end


		-- 计算宽度
		local limit = ex.Player.chat_data.friend_width
		local label = cc.Label:createWithTTF(unit.str_chat_content,FONT_DEFAULT_NAME_BOLD,42)

		label:setAlignment(cc.TextHAlignment.LEFT, cc.TextVAlignment.TOP)
		label:setScale(0.5)
		if label:getContentSize().width * label:getScale() > self.dimensions_size.width * label:getScale() * limit then
			label:setDimensions(self.dimensions_size.width * limit, 0)
		end
		unit.size_content = cc.size(label:getContentSize().width * label:getScale(), label:getContentSize().height * label:getScale())
		unit.size_content.width = math.max(150, unit.size_content.width) -- ui有最窄宽度
		table.insert(friends_chat[chat_data.friend_id],unit)
	end
end


function FriendResponse:friendsGift(data)
	print("FriendResponse:friendsGift")
	dump_pbmsg(data)
	-- local data = NetManager:resLuaData(ProtocolResponse.ResFriendsGive, byte_array)
	-- dump(data)
	ex.Player.friend_data.give_count = data.give_count
	local friend_data = ex.Player.friend_data:getFriendById(data.rid)
	if not friend_data then 
		return 
	end

	ex.Player.friend_data:friendGiven(data.rid)
	ex.Player.friend_data:checkGiftRed()
	ex.EventManager:fire(EVENT.FRIEND_EVENT.UPDATE_FRIEND_LIST)

	local reward = {}
	for i,v in ipairs(data.rewards) do
		local conf = cfg.item.item[v.type]
		local str = ex.Tools:getLang(conf.name) .. "*" .. v.num
		table.insert(reward,str)
	end

	local reward_str = ""
	for i,v in ipairs(reward) do
		reward_str = reward_str .. v 
		if i ~= #reward then 
			reward_str = reward_str .. ","
		end
	end

	local str_tip = string.format(ex.Tools:getLang(41141),friend_data.player_name,reward_str)
	ex.MessageView:add(str_tip, 0)

	ex.Player.chat_data:insertSystemChatData(str_tip)
end

function FriendResponse:friendsRewardGet(data)
	print("FriendResponse:friendsRewardGet")
	dump_pbmsg(data)
	local friend_data = ex.Player.friend_data:getFriendById(data.rid)
	if not friend_data then return end 
	friend_data.has_gift = 2
	local names = {}
	local reward = {}

	for i,v in ipairs(data.rewards) do
		local conf = cfg.item.item[v.type]
		local str = ex.Tools:getLang(conf.name) .. "*" .. v.num
		table.insert(reward,str)
	end



	local reward_str = ""
	for i,v in ipairs(reward) do
		reward_str = reward_str .. v 
		if i ~= #reward then 
			reward_str = reward_str .. ","
		end
	end

	-- for i,v in ipairs(names) do
	local str_tip = string.format(ex.Tools:getLang(41142),reward_str)
	ex.MessageView:add(str_tip, 0)
	ex.Player.friend_data:checkGiftRed()
	-- end
end

function FriendResponse:friendsRewardAll(data) 
	print("FriendResponse:friendsRewardAll")
	dump_pbmsg(data)
	-- ex.Player.friend_data.give_count = data.give_count
	for i,v in ipairs(data.rids) do
		local friend_data = ex.Player.friend_data:getFriendById(v)
		if friend_data then 
			friend_data.has_gift = 2
		end
		-- if ex.Player.friend_data.give_count < cfg.system.friend_reward_send_limit then 
		-- 	ex.Player.friend_data.give_count = ex.Player.friend_data.give_count + 1
		-- 	ex.Player.friend_data:friendGift(v)
		-- end
	end

	local reward = {}
	local has_item = {}
	local has_num = {}

	local reward_str = ""
	local over_reward_str = ""
	local length = 0

	for i,v in ipairs(data.rewards) do
		length = length + 1
	end

	for i,v in ipairs(data.rewards) do
		local conf = cfg.item.item[v.type]
		local str = ex.Tools:getLang(conf.name) .. "*" .. v.num
		reward_str = reward_str .. str 
		if length ~= i then reward_str = reward_str .. "," end
	end

	length = 0
	for i,v in ipairs(data.over_rewards) do
		length = length + 1
	end

	for i,v in ipairs(data.over_rewards) do
		local conf = cfg.item.item[v.type]
		local str = ex.Tools:getLang(conf.name) .. "*" .. v.num
		over_reward_str = over_reward_str .. str 
		if length ~= i then over_reward_str = over_reward_str .. "," end
	end

	local tmp = {}
	for k,v in pairs(has_num) do
		local data = {}
		data.type = k 
		data.num = v
		table.insert( tmp,data )
	end
	table.sort( tmp,function(a,b) return a.type < b.type end )

	for i,v in ipairs(data.rids) do

		local friend_data = ex.Player.friend_data:getFriendById(v)
		if friend_data then 
			friend_data.has_gift = 2
		end
		if ex.Player.friend_data.give_count < cfg.system.friend_reward_send_limit then 
			ex.Player.friend_data.give_count = ex.Player.friend_data.give_count + 1
			ex.Player.friend_data:friendGift(v)
		-- 	local str_tip = string.format(ex.Tools:getLang(41142),reward_str)
		-- 	ex.MessageView:add(str_tip, 0)
		-- else
		-- 	local str_tip = string.format(ex.Tools:getLang(41142),over_reward_str)
		-- 	ex.MessageView:add(str_tip, 0)
		end

		local str_tips = i <= data.reward_num and reward_str or over_reward_str
		local str_tip = string.format(ex.Tools:getLang(41142),str_tips)
		ex.MessageView:add(str_tip, 0)

				
	end

	-- local reward_str = ""
	-- for i,v in ipairs(reward) do
	-- 	reward_str = reward_str .. v 
	-- 	if i ~= #reward then 
	-- 		reward_str = reward_str .. ","
	-- 	end
	-- end

	-- local str_tip = string.format(ex.Tools:getLang(41142),reward_str)
	-- ex.MessageView:add(str_tip, 0)

	-- for i,v in ipairs(names) do
		-- local str_tip = string.format(ex.Tools:getLang(41141),v,reward_str)
		-- ex.MessageView:add(str_tip, 0)
	-- end

	-- local str_tip = string.format(ex.Tools:getLang(41141),data.name,ex.Tools:getLang(data.rewards[1].type))
	-- ex.MessageView:add(str_tip, 0)
	ex.Player.friend_data:checkGiftRed()
	ex.EventManager:fire(EVENT.FRIEND_EVENT.ONE_KEY_REWARD)
end 

function FriendResponse:friendsGivedAll(data) 
	print("FriendResponse:friendsRfriendsGivedAllewardAll")
	dump_pbmsg(data)
	for i,v in ipairs(data.rids) do
		local friend_data = ex.Player.friend_data:getFriendById(v)
		if friend_data then 
			friend_data.is_gived = 1
		end
	end

	local names = {}
	local reward = {}

	for i,v in ipairs(data.rewards) do
		local conf = cfg.item.item[v.type]
		local str = ex.Tools:getLang(conf.name) .. "*" .. v.num
		table.insert(reward,str)
	end

	local reward_str = ""
	for i,v in ipairs(reward) do
		reward_str = reward_str .. v 
		if i ~= #reward then 
			reward_str = reward_str .. ","
		end
	end


	-- local str_tip = string.format(ex.Tools:getLang(41142),reward_str)
	-- ex.MessageView:add(str_tip, 0)

	for i,v in ipairs(data.names) do
		local str_tip = string.format(ex.Tools:getLang(41141),v,reward_str)
		ex.MessageView:add(str_tip, 0)
		ex.Player.chat_data:insertSystemChatData(str_tip)
	end
	ex.Player.friend_data:checkGiftRed()
	ex.EventManager:fire(EVENT.FRIEND_EVENT.ONE_KEY_GIVED)
end 

function FriendResponse:friendOnlineStatus(data)
	local friend_data = ex.Player.friend_data:getFriendById(data.rid)
	if friend_data ~= nil then
		friend_data.online_status = data.online
		friend_data.offline_time = data.offline_time
	end

	ex.Player.friend_data:sortFriends()
	ex.EventManager:fire(EVENT.FRIEND_EVENT.UPDATE_FRIEND_LIST)
end

return FriendResponse
