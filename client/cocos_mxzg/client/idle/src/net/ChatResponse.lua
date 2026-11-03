local ChatResponse = class("ChatResponse")


function ChatResponse:chatList(data)
	-- dump(data, "ChatResponse:chatList")
	ex.Player.chat_data:resChatData(data, false)
end

function ChatResponse:chatLogList(data)
	-- dump(data, "ChatResponse:chatLogList")
	for i,v in ipairs(data.chatLog) do
		-- 测试阶段，手动屏蔽登陆获取的好友消息
		if v.chat_type ~= 5 then
			ex.Player.chat_data:resChatData(v, true)
		end
	end
end

function ChatResponse:chatLogWithType(data)
	-- dump(data, "ChatResponse:chatLogWithType")


-- 	ChatLayerType = {}
-- ChatLayerType.CLT_INVALID = 0
-- ChatLayerType.CLT_SYSTEM = 1        -- 系统
-- ChatLayerType.CLT_WORLD = 2         -- 世界
-- ChatLayerType.CLT_CLAN = 3          -- 公会
-- ChatLayerType.CLT_FRIEND = 5        -- 好友
-- ChatLayerType.CLT_SERVER = 6        -- 跨服
-- ChatLayerType.CLT_CITY = 7          -- 全服
-- ChatLayerType.CLT_CRUSADE = 8       -- 讨伐团
-- ChatLayerType.CLT_COUNTRYWAR = 9    -- 国战

	if data.type == ChatLayerType.CLT_SYSTEM then
		ex.Player.chat_data.vec_chat_system = {}
	elseif data.type == ChatLayerType.CLT_WORLD then
		ex.Player.chat_data.vec_chat_world = {}
	elseif data.type == ChatLayerType.CLT_CLAN then
		ex.Player.chat_data.vec_chat_clan = {}
	elseif data.type == ChatLayerType.CLT_SERVER then
		ex.Player.chat_data.vec_chat_server = {}
	elseif data.type == ChatLayerType.CLT_CITY then
		ex.Player.chat_data.vec_chat_city = {}
	elseif data.type == ChatLayerType.CLT_CRUSADE then
		ex.Player.chat_data.vec_chat_crusade = {}
	elseif data.type == ChatLayerType.CLT_COUNTRYWAR then
		ex.Player.chat_data.vec_chat_countrywar = {}
	end

	for i,v in ipairs(data.chatLog) do
		ex.Player.chat_data:resChatData(v, i < #data.chatLog)
	end
end

function ChatResponse:chatNum(data)
	-- GResChatNum
	ex.Player.chat_data.vec_unread_num = {}
	for i,v in ipairs(data.typeNum) do
		ex.Player.chat_data.vec_unread_num[v.key] = v.value
	end

	ex.Player.chat_data:updateReddot()
end

-- 聊天里正在聊天的好友列表，登陆时获取
function ChatResponse:chatFriendList(data)
	-- GResPrivateChatRoles

	ex.Player.chat_data.vec_chat_cache = {}
	local is_have_red = false
	for i,v in ipairs(data.list) do
		table.insert(ex.Player.chat_data.vec_chat_cache, v)
		if v.red_status > 0 then
			is_have_red = true
		end
	end
	if is_have_red then
		ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_LTDC_ZCLTAN_HYLT, true)
	end
end

-- 单个好友的私聊列表
function ChatResponse:ChatFriendChatList(data)
	-- GResPrivateChatLog

	local iter_chat = ex.Player.chat_data.map_chat_friends[data.friend_id]
	if iter_chat ~= nil then
		ex.Player.chat_data.map_chat_friends[data.friend_id] = {}
	end

	for i,v in ipairs(data.chatLog) do
		ex.Player.chat_data:resChatData(v, true)
	end

	require("src.layer.ChatCtr"):instance():updateFriendList()
	require("src.layer.ChatCtr"):instance():updateTableView(false)
end

-- 添加私聊好友
function ChatResponse:ChatFriendAdd(data)
	-- GResAddPrivateChat
	local is_have = false
	for i,v in ipairs(ex.Player.chat_data.vec_chat_cache) do
		if v.rid == data.role_id then
			is_have = true
			break
		end
	end
	if not is_have then
		table.insert(ex.Player.chat_data.vec_chat_cache, {rid = data.role_id, red_status = 0})
	end

	local chat_ctr = require("src.layer.ChatCtr"):instance()
	chat_ctr.friend_id = data.role_id
	chat_ctr:updateFriendList()
    chat_ctr:updateFriendInfo()
    chat_ctr:updateTableView()
end

-- 删除私聊好友
function ChatResponse:ChatFriendDel(data)
	-- GResRemovePrivateChat
	ex.Player.chat_data:delFriendChatCache(data.role_id)

	local chat_ctr = require("src.layer.ChatCtr"):instance()
	chat_ctr:updateFriendList()
    chat_ctr:updateFriendInfo()
    chat_ctr:updateTableView()
end

return ChatResponse
