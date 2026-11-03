local FriendData = class("FriendData")
local MAX = 60

function FriendData:ctor()
	self.friend_ship_num = 0
	self.my_friend = {}
    self.friend_request = {}
    self.friend_black_list = {}
	self.friend_search = {}
    self.ungive = {}
    self.give_count = 0

    self.friends_chat_read_time = {}
    self.last_req_time = 0
end


function FriendData:clear()
	self.friend_ship_num = nil
	self.friend_request = nil
	self.friend_black_list = nil
	self.friend_search = nil
	self.ungive = nil
    self.friends_chat_read_time = nil
end

function FriendData:getSearchData()
    return self.friend_search
end

function FriendData:getRequestData()
    return self.friend_request
end

function FriendData:getBlackListData()
    return self.friend_black_list
end

function FriendData:getDataByLayerType(type)
    if type == FRIEND_LAYER_TYPE.FRIEND_LIST then 
        return self.my_friend
    elseif type == FRIEND_LAYER_TYPE.GIFT_LIST then 
        return self:getGiftList()
    elseif type == FRIEND_LAYER_TYPE.REQUEST_LIST then 
        return self:getRequestData()
    elseif type == FRIEND_LAYER_TYPE.BLACK_LIST then 
        return self:getBlackListData()
    end
end

function FriendData:getMyFriendData()
    return self.my_friend
end

function FriendData:canOneKeyGived()
    local total = 0
    for i,v in ipairs(self.my_friend) do
        if v.is_gived == 0 then total = total + 1 end 
        if total > 0 then break end
    end
    return total > 0
end

function FriendData:getFirendShipNum()
    return self.friend_ship_num
end

function FriendData:clearSearchList()
    self.friend_search = {}
end

--好友列表
function FriendData:friendsListInfo(res)
    self.my_friend = {}
    self.give_count = res.give_count
    -- for i=1,res.list_count do
    for i,v in ipairs(res.list) do
		local data = {}
		local friend_data = v
		data.role_id = friend_data.role_id
		data.player_name = friend_data.player_name
        data.player_level = friend_data.player_level
        data.head_id = friend_data.head_id
		data.battle = friend_data.battle
		data.crown = friend_data.crown
		data.clan_id = friend_data.clan_id
		data.clan_icon_id = friend_data.clan_icon_id
		data.clan_name = friend_data.clan_name
		data.online_status = friend_data.online_status
		data.offline_time = friend_data.offline_time
		data.is_gived = friend_data.is_gived
		-- data.is_gift = friend_data.is_gift
        -- data.is_reward = friend_data.is_reward
        data.has_gift = friend_data.has_gift
        data.border_id = friend_data.border_id

		table.insert(self.my_friend,data)
	end
	self:sortFriends()
end

--好友请求列表
function FriendData:friendRequstInfo(res)
    -- vec_friends_request.clear();
    self.friend_request = {}
    -- for i = 0, res.list_count do
    for i,v in ipairs(res.list) do
        local list_data = v
        local data = {}
        data.role_id = list_data.role_id
        data.player_name = list_data.player_name
        data.player_level = list_data.player_level
        data.head_id = list_data.head_id
        data.battle = list_data.battle
        data.crown = list_data.crown
        data.clan_id = list_data.clan_id
        data.clan_icon_id = list_data.clan_icon_id
        data.clan_name = list_data.clan_name
        data.online_status = list_data.online_status
        data.offline_time = list_data.offline_time
        data.border_id = list_data.border_id
        table.insert(self.friend_request,data)
    end
    
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HYAN_HYTJ, table.nums(self.friend_request) > 0);
end

--好友黑名单列表
function FriendData:friendBlackListInfo(list)
    -- vec_friends_request.clear();
    self.friend_black_list = list
    
    -- ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HYAN_HYTJ, table.nums(self.friend_request) > 0);
end

--被添加好友的对象
function FriendData:friendAdd(res)

	local data = {}

    data.role_id = res.resFriendData.role_id
    data.player_name = res.resFriendData.player_name
    data.player_level = res.resFriendData.player_level
    data.head_id = res.resFriendData.head_id
    data.border_id = res.resFriendData.border_id
    data.battle = res.resFriendData.battle
    data.clan_id = res.resFriendData.clan_id
    data.clan_icon_id = res.resFriendData.clan_icon_id
    data.clan_name = res.resFriendData.clan_name
    data.online_status = res.resFriendData.online_status
    table.insert(self.friend_request,data)
    
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HYAN_HYTJ, table.nums(self.friend_request) > 0);
end


--同意对方添加
function FriendData:friendsAgree(res)
    local data = {}

    data.role_id = res.resFriendData.role_id
    data.player_name = res.resFriendData.player_name
    data.player_level = res.resFriendData.player_level
    data.head_id = res.resFriendData.head_id
    data.border_id = res.resFriendData.border_id
    data.battle = res.resFriendData.battle
    data.clan_id = res.resFriendData.clan_id
    data.crown = res.resFriendData.crown
    data.clan_icon_id = res.resFriendData.clan_icon_id
    data.clan_name = res.resFriendData.clan_name
    data.is_vip = res.resFriendData.is_vip
    data.online_status = res.resFriendData.online_status
    data.offline_time = cpp.Game:instance():getServerTime()
    data.is_gived = res.resFriendData.is_gived
    -- data.is_gift = res.resFriendData.is_gift
    -- data.is_reward = res.resFriendData.is_reward
    data.has_gift = res.resFriendData.has_gift

    local friend_data = self:getFriendById(data.role_id)
    if not friend_data then 
        ex.MessageView:add(string.format(ex.Tools:getLang(41165),data.player_name))
    else
        ex.MessageView:add(ex.Tools:getLang(41171))
        return 
    end

    table.insert(self.my_friend,data)
    self:sortFriends()
end

--删除好友
function FriendData:friendsDelete(res)
	for k,v in ipairs(self.my_friend) do

		if v.role_id == res.rid then 
			table.remove(self.my_friend,k)
			break
		end
	end
end

function FriendData:delMyFriendsList(id)
	for i,v in ipairs(self.my_friend) do
		if v.role_id == id then 
			table.remove(self.my_friend,i)
			break
		end
	end


end

function FriendData:delRequestList(id)
	for i,v in ipairs(self.friend_request) do
		if v.role_id == id then 
			table.remove(self.friend_request,i)
			break
		end
	end
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HYAN_HYTJ, table.nums(self.friend_request) > 0)
end

function FriendData:delSearchList(id)
    for i,v in ipairs(self.friend_search) do
        if v.role_id == id then 
            table.remove(self.friend_search,i)
            break
        end
    end
end

function FriendData:clearFriendsRequest(id)
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HYAN_HYTJ,false)
    self.friend_request = {}
end

function FriendData:sortFriends()
    local sorOnline = function (a,b)
        local a_data = self:getFriendById(a.role_id)
        local b_data = self:getFriendById(b.role_id)

        return a_data.battle > b_data.battle
    end

    local sorOffline = function (a,b)
        local a_data = self:getFriendById(a.role_id)
        local b_data = self:getFriendById(b.role_id)

        return a_data.offline_time > b_data.offline_time
    end
    -- dump(self.my_friend)
    -- table.sort(self.my_friend,sor)
    local online = {}
    local offline = {}
    for i,v in ipairs(self.my_friend) do
        if v.online_status == 1 then 
            table.insert(online,v)
        else
            table.insert(offline,v)
        end
    end
    table.sort(online,sorOnline)
    table.sort(offline,sorOffline)
    self.my_friend = {}
    for i,v in ipairs(online) do
        table.insert(self.my_friend,v)
    end

    for i,v in ipairs(offline) do
        table.insert(self.my_friend,v)
    end
    self:resetFriendsChatReadTime()
end

function FriendData:getFriendById(role_id)

    local friend_data 
    for i,v in ipairs(self.my_friend) do
        if v.role_id == role_id then 
            friend_data = v
            break
        end
    end

    return friend_data
end

function FriendData:resetFriendsChatReadTime()

    local times = {}
    for i,v in ipairs(self.my_friend) do
        local chat = {}
        chat.role_id = v.role_id
        chat.time = self:getFriendsChatLastReadTime(v.role_id)
        table.insert(times,chat)
    end

    for i,v in ipairs(times) do
        local data = {}
        data[1] = v.role_id
        data[2] = v.time
        table.insert(self.friends_chat_read_time,data)
    end
end

function FriendData:getFriendsChatLastReadTime(role_id)

    for i,v in ipairs(self.friends_chat_read_time) do
        if v[1] == role_id then 
            return v[2]
        end
    end

	return 0
end

function FriendData:hasUnreadChat(id)

    if id ~= nil then 
        local friend_data = self:getFriendById(id)
        if not friend_data then return end

        local chat_data = ex.Player.chat_data:getFriendChatHistory(id)
        if chat_data ~= nil and table.nums(chat_data) > 0 then
            local last = table.nums(chat_data)
            return chat_data[last].unread_chat
        end

        return false
    else
        local result = false
        local data = ex.Player.chat_data.map_chat_friends
        for i,v in ipairs(data) do
            if v.first > 0 then 
                local friend_data = self:getFriendById(v)
                if friend_data then 
                    if table.nums(v.second) > 0 and v.second[table.nums(v.second)].unread_chat then 
                        data:insertFriendChatCache(v.first)
                        return result
                    end
                end
            end
        end
        return result
    end
end

function FriendData:saveFriendMsgReadTime(role_id,time)
    local friend_data = self:getFriendById(role_id)
    if not friend_data then return end

    for i,v in ipairs(self.friends_chat_read_time) do
        if v[1] == role_id then 
            v[2] = time
            break
        end
    end

end

function FriendData:isMyFriend(role_id)
    local friend_data = self:getFriendById(role_id)
    if not friend_data then return false end
    return true
end

function FriendData:friendGift(role_id)
    local friend_data = self:getFriendById(role_id)

    if not friend_data or friend_data.is_gived == 1 then return false end


	local req = Friend_pb.GReqFriendsGive()
    req.rid = role_id
    NetManager:sendMessage(ProtocolID.GReqFriendsGive,req)
end

function FriendData:getGiftList( )
    local data = {}
    for i,v in ipairs(self.my_friend) do
        if v.has_gift > 0 then table.insert(data,v) end
    end
    return data
end

function FriendData:friendGiftAll()
    local is_has_someone_to_gift = false

    -- for i,v in ipairs(self.my_friend) do
    --     if v.has_gift == 1 then 
    --         is_has_someone_to_gift = true
    --         v.has_gift = 2
    --     end
    -- end

    for i,v in ipairs(self.my_friend) do
        if v.is_gived == 0 then 
            is_has_someone_to_gift = true
            v.is_gived = 1
        end
    end

    if not is_has_someone_to_gift then return false end

	local req = Friend_pb.GReqFriendsGiveAll()
	NetManager:sendMessage(ProtocolID.GReqFriendsGiveAll,req)
    return true
end

function FriendData:friendGiven(role_id) 
    local  item = self:getFriendById(role_id)
    if not item or item.is_gived == 1 then 
        return
    end
    
    item.is_gived = 1
end

function FriendData:checkGiftRed()
    local red = false
	for k,v in pairs(ex.Player.friend_data:getMyFriendData()) do
		if v.has_gift == 1 then 
			red = true 
			break
		end
	end
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HYAN_HYLW, red) 
end

function FriendData:isInBlackList(role_id)
    if self.friend_black_list == nil then
        return false
    end

    for i,v in ipairs(self.friend_black_list) do
        if v.role_id == role_id then
            return true
        end
    end

    return false
end

function FriendData:blackListAdd(role_id, server_id)
    if #ex.Player.friend_data.friend_black_list >= tonumber(ex.Tools:getSysCfg("blacklist_max_num")) then
        ex.MessageView:add(ex.Tools:getLang(4018))
        return
    end

    local req = Friend_pb.GReqAddBlackList()
    req.rid = role_id
    req.server_id = server_id
    NetManager:sendMessage(ProtocolID.GReqAddBlackList, req)

    -- 如果是好友，则需要更新好友聊天消息红点状态
    -- 删除好友有响应，在响应里更新状态
    -- if self:isMyFriend(role_id) then
    --     NetManager:sendMessage(ProtocolID.GReqChatNum)
    -- end

    -- 如果有申请信息，需要去除黑名单部分的
    NetManager:sendMessage(ProtocolID.GReqFriendsRequestList)
end

function FriendData:blackListRemove(role_id)
    local req = Friend_pb.GReqRemoveBlackList()
    req.remove_id = role_id
	NetManager:sendMessage(ProtocolID.GReqRemoveBlackList, req)
end

return FriendData