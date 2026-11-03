--[[
    聊天机制：
        1、登陆时，请求非好友消息列表和私聊好友列表及红点状态
        2、登陆后，有私聊消息发到客户端时，
            a、若已请求过对应私聊列表则添加到对应列表，并刷新红点状态
            b、若未请求过对应私聊列表，则不做处理，并刷新红点状态
        3、点击对应私聊好友时，
            a、若已有列表则显示对应私聊列表，并刷新红点
            b、若没有请求过该好友私聊列表，则请求私聊列表
]]

local ChatData = class("ChatData")

ChatLayerType = {}
ChatLayerType.CLT_INVALID = 0
ChatLayerType.CLT_SYSTEM = 1        -- 系统
ChatLayerType.CLT_WORLD = 2         -- 世界
ChatLayerType.CLT_CLAN = 3          -- 公会
ChatLayerType.CLT_FRIEND = 5        -- 好友
ChatLayerType.CLT_SERVER = 6        -- 跨服
ChatLayerType.CLT_CITY = 7          -- 全服
ChatLayerType.CLT_CRUSADE = 8       -- 讨伐团
ChatLayerType.CLT_COUNTRYWAR = 9    -- 国战

local ChatUnit = class("ChatUnit")
function ChatUnit:ctor()
    self.chat_id = 0
    self.chat_type = 0     	           -- 1.系统   2.世界  3.公会  5.私聊  6.跨服  7.同省   8.讨伐团
    self.player_id = 0                 -- 玩家id (0 为系统) 121
    self.clan_id = 0                   -- 公会id  (无 公会为0)
    self.photo = 0                     -- 头像
    self.send_time = 0                 -- 发送时间
    self.unread_chat = false           -- 消息是否未读
    self.player_name = "" 	           -- 玩家昵称 (系统为空)
    self.str_chat_content = ""	       -- 聊天内容
    self.size_content = cc.size(0, 0)  -- 内容大小
    self.area_idx = 1                  -- 省市索引(同省频道用)
    self.server_id = 1                 -- 服务器id(跨服频道用)
    self.peerage_level = 0             -- 尊贵标识等级（当玩家不展示聊天标识时为0，默认也为0）
end

function ChatUnit:getSystemXml(type) 
	local xml_text = ""
	if self.chat_type == 1 then
		xml_text = "<font color='#9abbda'>系统 | %s</font>"
		xml_text = string.format(xml_text, self.str_chat_content)
	elseif self.chat_type == 2 then
		xml_text = "<font color='#a88042'>世界 | <font color='#643200'>%s</font>:%s</font>";
		xml_text = string.format(xml_text, self.player_name, self.str_chat_content)
	elseif self.chat_type == 3 then
		xml_text = "<font color='#a88000'>公会 | <font color='#643200'>%s</font>:%s</font>";
		xml_text = string.format(xml_text, self.player_name, self.str_chat_content)
	elseif self.chat_type == 5 then
		if type == 1 then
			xml_text = "<font color='#984db8'>私聊 | 对 <font color='#643200'>%s</font> 说:%s</font>";
		else
			xml_text = "<font color='#984db8'>私聊 | <font color='#643200'>%s</font> 对你说:%s</font>";
		end
	end
	
	return xml_text
end

function ChatUnit:getSystemName(type)
	local xml_text = ""
	if self.chat_type == 1 then
		xml_text = "<font color='#9abbda'>系统 | </font>";
	elseif self.chat_type == 2 then
		xml_text = "<font color='#a88042'>世界 | <font color='#ffffff'>%s</font>:</font>";
		xml_text = string.format(xml_text, self.player_name)
	elseif self.chat_type == 3 then
		xml_text = "<font color='#a88000'>公会 | <font color='#ffffff'>%s</font>:</font>";
		xml_text = string.format(xml_text, self.player_name)
	elseif self.chat_type == 5 then
		if type == 1 then
			xml_text = "<font color='#984db8'>私聊 | 对 <font color='#ffffff'>%s</font> 说:%s</font>";
		else
			xml_text = "<font color='#984db8'>私聊 | <font color='#ffffff'>%s</font> 对你说:%s</font>";
		end
	end
	return xml_text
end

local ChatCacheUnit = class("ChatCacheUnit")
function ChatCacheUnit:ctor()
    self.player_id = 0
    self.online_status = 0
    self.name = ""
end

function ChatData:ctor()
	self.vec_chat_system = {}		-- 系统消息 vector<ChatUnit>
    self.vec_chat_world = {}      	-- 世界聊天 vector<ChatUnit>
    self.vec_chat_clan = {}       	-- 公会聊天记录 vector<ChatUnit>
    self.vec_chat_server = {}       -- 跨服聊天记录 vector<ChatUnit>
    self.vec_chat_city = {}       	-- 同省聊天记录 vector<ChatUnit>
    self.vec_chat_crusade = {}      -- 讨伐团聊天记录 vector<ChatUnit>
    self.vec_chat_countrywar = {}   -- 国战聊天记录 vector<ChatUnit>


    self.vec_unread_num = {}        -- 各个频道未读消息数
    
    self.vec_chat_cache = {}       	-- 好友临时聊天 vector<int64_t, int8_t>, vector<好友id，是否有未阅读信息>
    self.map_chat_friends = {} 		-- 好友聊天 map<int64_t , vector<ChatUnit> >
	
	self.dimensions_size = cc.size(340, 200)
    self.friend_width = 0.7
end

function ChatData:resetClanChatData()
    self.vec_chat_clan = {} 
end

function ChatData:resChatData(res, is_init)
    local player = ex.Player
    local chat_ctr = require("src.layer.ChatCtr"):instance()
    local red_dot_manager = ex.RedDotManager
    
    -- res.chat_content = ex.Tools:getLang(47508)
    -- local str_asc2 = ""
    -- for i=1, string.len(res.chat_content) do
    --     str_asc2 = str_asc2..string.byte( res.chat_content, i, i + 1).." "
    -- end
    -- print("str_chat_content byte:", str_asc2)

    if res.chat_type == ChatLayerType.CLT_CITY then
        -- 如果处于屏蔽全服聊天的状态，则不接收世界消息
        local is_ignore = cc.UserDefault:getInstance():getIntegerForKey("ignore_chat_city", 1)
        if is_ignore == 1 then
            return
        end
    end
    
    local chat_unit = {}
    chat_unit.chat_id = cpp.Game:makeLuaId()

    chat_unit.chat_type = res.chat_type
    chat_unit.player_id = res.player_id
    chat_unit.member_id = res.friend_id
    chat_unit.clan_id = res.clan_id
    chat_unit.photo = res.head_id
    chat_unit.border_id = res.border_id
    chat_unit.send_time = res.send_time
    chat_unit.is_vip = res.is_vip
    chat_unit.player_name = res.player_name
    chat_unit.str_clan_name = res.clan_name
    chat_unit.str_chat_content = res.chat_content
    chat_unit.peerage_level = res.peerage
    chat_unit.cg_group_id = res.cruGroupT
    if res.city_id == nil or res.city_id <= 0 then
        chat_unit.area_idx = 1
    else
        chat_unit.area_idx = res.city_id
    end
    chat_unit.server_id = res.server_id
    
--    log("%s",  chat_unit.str_chat_content.c_str());
    if chat_unit.photo == nil or chat_unit.photo < 0 then
        chat_unit.photo = 0
    end

    -- 计算宽度
    local limit = chat_unit.chat_type == 5 and self.friend_width or 1
    
    local scale_label = 0.5
    local label = cpp.RichTextEx:createWithXMLLua("")
    :setFontSize(40)
    :setScale(0.5)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
    :setFontColor("FFFAB9")
    :setAnchorPoint(0, 1)
	:setAnchorTextShadow(true)
	:setWrapMode(1)

    -- 全部为空格时，富文本会取空字符串，label大小会变型，所以取一个实体字符来防止问题
    local str_tmp = res.chat_content
    -- local str_tmp = string.gsub(res.chat_content, "   ", "1")
    -- local str_tmp = string.gsub(str_tmp, "  ", "1")
    -- local str_tmp = string.gsub(str_tmp, " ", "1")

    label:setXmlTextLua(str_tmp)
    label:formatText()

    chat_unit.size_content = {}
    if label:getContentSize().width * label:getScale() < self.dimensions_size.width * limit then
        chat_unit.size_content.width = label:getContentSize().width * label:getScale()
    else
        chat_unit.size_content.width = self.dimensions_size.width * limit
    end
    chat_unit.size_content.width = math.max(150, chat_unit.size_content.width)

	label:ignoreContentAdaptWithSize(false)
    label:setContentSize(cc.size(self.dimensions_size.width * limit / 0.5, 0))
    label:setXmlTextLua(str_tmp)
    label:formatText()

    chat_unit.size_content.height = label:getContentSize().height * label:getScale()
--    log("chat_unit.size_content.size = %f, %f", chat_unit.size_content.width, chat_unit.size_content.height);
    
--    auto scene_ctr = (TownSceneCtr*)SceneCtr:getRunningSceneCtr();
--    if (scene_ctr) {
--        scene_ctr->insertChat(&chat_unit);
--    }

    -- 系统
    if chat_unit.chat_type == ChatLayerType.CLT_SYSTEM then
        -- chat_unit.unread_chat = not chat_ctr:isDraw() or not chat_ctr:isLayerVisible(CLT_SYSTEM)
        if is_init == true then chat_unit.unread_chat = false else
            chat_unit.unread_chat = not chat_ctr:isLayerVisible(chat_unit.chat_type)
        end
		table.insert(self.vec_chat_system, chat_unit)
        self:limitChatCount(self.vec_chat_system)
        chat_ctr:updateTableViewWithLayerType(chat_unit.chat_type, true)
    -- 世界
    elseif chat_unit.chat_type == ChatLayerType.CLT_WORLD then
        -- chat_unit.unread_chat = not chat_ctr:isDraw() or not chat_ctr:isLayerVisible(CLT_WORLD)

        if is_init == true or chat_unit.player_id == player.role_id then 
            chat_unit.unread_chat = false 
        else
            chat_unit.unread_chat = not chat_ctr:isLayerVisible(chat_unit.chat_type)
        end
        if table.nums(self.vec_chat_world) > 0 or chat_ctr:isLayerVisible(chat_unit.chat_type) then
            table.insert(self.vec_chat_world, chat_unit)
            if is_init ~= true then
                self:limitChatCount(self.vec_chat_world)
                chat_ctr:updateTableViewWithLayerType(chat_unit.chat_type, true)
            end
        end
    -- 公会
    elseif chat_unit.chat_type == ChatLayerType.CLT_CLAN then
        -- chat_unit.unread_chat = not chat_ctr:isDraw() or not chat_ctr:isLayerVisible(CLT_CLAN)

        if is_init == true or chat_unit.player_id == player.role_id then 
            chat_unit.unread_chat = false 
        else
            chat_unit.unread_chat = not chat_ctr:isLayerVisible(chat_unit.chat_type)
        end
        if table.nums(self.vec_chat_clan) > 0 or chat_ctr:isLayerVisible(chat_unit.chat_type) then
            table.insert(self.vec_chat_clan, chat_unit)
            if is_init ~= true then
                self:limitChatCount(self.vec_chat_clan)
                chat_ctr:updateTableViewWithLayerType(chat_unit.chat_type, true)
            end
        end
    -- 好友
    elseif chat_unit.chat_type == ChatLayerType.CLT_FRIEND then
        -- chat_unit.unread_chat = chat_ctr.friend_id ~= chat_unit.player_id or not chat_ctr:isDraw() or not chat_ctr:isLayerVisible(CLT_FRIEND)

        --[[
            1、如果私聊列表有此人，
                a、如果，消息列表为空，
                    ①、如果有红点，则不做处理，直接return
                    ②、如果无红点，则添加消息及红点，并刷新界面
                b、如果，消息列表不为空，则添加消息及红点，并刷新界面
            2、如果私聊列表无此人，则直接添加消息及红点，并刷新界面
        ]]
        local friend_id = chat_unit.player_id
        if chat_unit.player_id == player.role_id then
            friend_id = chat_unit.member_id
        end

        local is_in_layer = chat_ctr.friend_id == chat_unit.player_id and chat_ctr:isLayerVisible(chat_unit.chat_type)

        if is_init == true or chat_unit.player_id == player.role_id then 
            chat_unit.unread_chat = false 
        else
            chat_unit.unread_chat = not is_in_layer
        end
        
        local iter_chat = self.map_chat_friends[friend_id]

        if iter_chat == nil then
            self.map_chat_friends[friend_id] = {}
            iter_chat = self.map_chat_friends[friend_id]
        end
        table.insert(iter_chat, chat_unit)

        -- if is_init == false then
            local is_have = false
            for i,v in ipairs(self.vec_chat_cache) do
                if v.rid == friend_id then
                    is_have = true
                end
            end
            if not is_have then
                table.insert(self.vec_chat_cache, {rid = friend_id, red_status = 0})
            end

            if is_init == false and chat_ctr.friend_id ~= friend_id then 
                for i,v in ipairs(self.vec_chat_cache) do
                    if v.rid == friend_id then
                        v.red_status = 1
                    end
                end
            end
        -- end

        if chat_unit.player_id == player.role_id then
            -- 自己说的话
            if chat_ctr.friend_id == chat_unit.member_id then
                chat_ctr:updateTableViewWithLayerType(chat_unit.chat_type, true)
			end
        else
            -- 好友说的话
            local friend_data = player.friend_data:getFriendById(chat_unit.player_id)
            if friend_data ~= nil then
                -- 修改好友在线时间
                if (chat_unit.send_time - cpp.Game:instance():getServerTime()) < 10 then
                    friend_data.online_status = true;
				end
                
                self:insertFriendChatCache(friend_data.role_id)
                player.friend_data:sortFriends()
                if is_init == false and chat_ctr.layer ~= nil then
                    chat_ctr:updateFriendList()
				end

                if is_init == false and chat_ctr.friend_id == chat_unit.player_id then
					chat_ctr:updateTableViewWithLayerType(chat_unit.chat_type, true)
				end
            end
        end
    elseif chat_unit.chat_type == ChatLayerType.CLT_SERVER then
        if is_init == true or chat_unit.player_id == player.role_id or cfg.opencondition.condition["main_chat_cross_share"].condition_value > player.level then 
            chat_unit.unread_chat = false 
        else
            chat_unit.unread_chat = not chat_ctr:isLayerVisible(chat_unit.chat_type)
        end
        if table.nums(self.vec_chat_server) > 0 or chat_ctr:isLayerVisible(chat_unit.chat_type) then
            table.insert(self.vec_chat_server, chat_unit)
            if is_init ~= true then
                self:limitChatCount(self.vec_chat_server)
                chat_ctr:updateTableViewWithLayerType(chat_unit.chat_type, true)
            end
        end
    elseif chat_unit.chat_type == ChatLayerType.CLT_CITY then
        if is_init == true or chat_unit.player_id == player.role_id or cfg.opencondition.condition["main_chat_city"].condition_value > player.level then 
            chat_unit.unread_chat = false 
        else
            chat_unit.unread_chat = not chat_ctr:isLayerVisible(chat_unit.chat_type)
        end
        if table.nums(self.vec_chat_city) > 0 or chat_ctr:isLayerVisible(chat_unit.chat_type) then
            table.insert(self.vec_chat_city, chat_unit)
            if is_init ~= true then
                self:limitChatCount(self.vec_chat_city)
                chat_ctr:updateTableViewWithLayerType(chat_unit.chat_type, true)
            end
        end
    elseif chat_unit.chat_type == ChatLayerType.CLT_CRUSADE then
        if is_init == true or chat_unit.player_id == player.role_id or cfg.opencondition.condition["main_crusade_group"].condition_value > player.level then 
            chat_unit.unread_chat = false 
        else
            chat_unit.unread_chat = not chat_ctr:isLayerVisible(chat_unit.chat_type)
        end
        -- if table.nums(self.vec_chat_crusade) > 0 or chat_ctr:isLayerVisible(chat_unit.chat_type) then
            table.insert(self.vec_chat_crusade, chat_unit)
            if is_init ~= true then
                self:limitChatCount(self.vec_chat_crusade)
                chat_ctr:updateTableViewWithLayerType(chat_unit.chat_type, true)
            end
        -- end
    elseif chat_unit.chat_type == ChatLayerType.CLT_COUNTRYWAR then
        if  is_init == true or chat_unit.player_id == player.role_id or ex.JumpManager:checkOpenConditionByAtomNoMsg("main_country_war") == false or ctr.country_war.data:getStage() ~= COUNTRY_WAR_STATE.BATTLE or not ctr.country_war.data:getHadjoin() then 
            chat_unit.unread_chat = false 
        else
            chat_unit.unread_chat = not chat_ctr:isLayerVisible(chat_unit.chat_type)
        end
        -- if table.nums(self.vec_chat_crusade) > 0 or chat_ctr:isLayerVisible(chat_unit.chat_type) then
            table.insert(self.vec_chat_countrywar, chat_unit)
            if is_init ~= true then
                self:limitChatCount(self.vec_chat_countrywar)
                chat_ctr:updateTableViewWithLayerType(chat_unit.chat_type, true)
            end
    end

    if is_init ~= true and not chat_ctr:isLayerVisible(chat_unit.chat_type) then
        if self.vec_unread_num[chat_unit.chat_type] == nil then
            self.vec_unread_num[chat_unit.chat_type] = 1
        else
            self.vec_unread_num[chat_unit.chat_type] = self.vec_unread_num[chat_unit.chat_type] + 1
        end

        self:updateReddot()
    end
end

-- 限制记录的聊天内容数量
function ChatData:limitChatCount(vec)
	if table.nums(vec) <= 100 then
		return
	end

	table.remove(vec, 1)
	if table.nums(vec) > 100 then
		self:limitChatCount(vec)
	end
end

function ChatData:getFriendChatCache(player_id)
    local friend_data = ex.Player.friend_data:getFriendById(player_id)
    if friend_data ~= nil then
        local cache_unit = {}
        cache_unit.player_id = friend_data.role_id
        cache_unit.online_status = friend_data.online_status
        cache_unit.name = friend_data.player_name
        cache_unit.level = friend_data.player_level
        cache_unit.head_id = friend_data.head_id
        cache_unit.border_id = friend_data.border_id
        return cache_unit
	end
    
    return nil
end

function ChatData:insertFriendChatCache(player_id)
	local is_have = false
	for i,v in ipairs(self.vec_chat_cache) do
		if v.rid == player_id then
			is_have = true
			break
		end
	end
	if is_have == false then
		table.insert(self.vec_chat_cache, {rid = player_id, red_status = 0})
	end
end

function ChatData:hasUnreadChat(chat_type, player_id)
    local msg_vec = {}
    
    if chat_type == ChatLayerType.CLT_SYSTEM then
        msg_vec = self.vec_chat_system
    elseif chat_type == ChatLayerType.CLT_WORLD then
        msg_vec = self.vec_chat_world
    elseif chat_type == ChatLayerType.CLT_CLAN then
        msg_vec = self.vec_chat_clan
    elseif chat_type == ChatLayerType.CLT_FRIEND then
        for i,v in ipairs(self.vec_chat_cache) do
            if v.red_status > 0 then
                return true
            end
        end
        return false
    elseif chat_type == ChatLayerType.CLT_SERVER then
        msg_vec = self.vec_chat_server
    elseif chat_type == ChatLayerType.CLT_CITY then
        msg_vec = self.vec_chat_city
    elseif chat_type == ChatLayerType.CLT_CRUSADE then
        msg_vec = self.vec_chat_crusade
	else
		return false
	end
    
	for i,v in ipairs(msg_vec) do
		if v.unread_chat == true then
            return true
		end
	end
    
    return false;
end

-- 设置消息已读
function ChatData:setChatRead(chat_type, player_id)
    local msg_vec = {}
    if chat_type == ChatLayerType.CLT_SYSTEM then
        msg_vec = self.vec_chat_system
    elseif chat_type == ChatLayerType.CLT_WORLD then
        msg_vec = self.vec_chat_world
    elseif chat_type == ChatLayerType.CLT_CLAN then
        msg_vec = self.vec_chat_clan
    elseif chat_type == ChatLayerType.CLT_FRIEND then
        if player_id == nil then
            return false
        end
        local is_have = false
        for i,v in ipairs(self.vec_chat_cache) do
            if v.rid == player_id then
                v.red_status = 0
                is_have = true
                break
            end
        end
        if is_have == false then
            return false
        end
    elseif chat_type == ChatLayerType.CLT_SERVER then
        msg_vec = self.vec_chat_server
    elseif chat_type == ChatLayerType.CLT_CITY then
        msg_vec = self.vec_chat_city
    elseif chat_type == ChatLayerType.CLT_CRUSADE then
        msg_vec = self.vec_chat_crusade
    end
    
	for i,v in ipairs(msg_vec) do
        v.unread_chat = false
    end
    
    -- 设置消息已读
    local req_read = Chat_pb.GReqChatLogRead()
    req_read.friend_id = player_id or 0
    req_read.type = chat_type
    NetManager:sendMessage(ProtocolID.GReqChatLogRead, req_read)

    if chat_type ~= ChatLayerType.CLT_FRIEND then
        ex.Player.chat_data.vec_unread_num[chat_type] = 0

        ex.Player.chat_data:updateReddot()
    elseif player_id ~= nil and player_id > 0 then
        -- 刷新未读消息数量
        NetManager:sendMessage(ProtocolID.GReqChatNum)
    end

    return true
end

function ChatData:updateChatFriend()
    -- 检查一遍好友列表合法性，如果好友被删除了，则踢除出列表
    repeat 
        local is_have = false
        for i,v in ipairs(self.vec_chat_cache) do
            local item_data = self:getFriendChatCache(v.rid)
            if item_data == nil then
                if self.map_chat_friends[v.rid] ~= nil then
                    self.map_chat_friends[v.rid] = {}
                end
                table.remove(self.vec_chat_cache, i)
                is_have = true
                break
            end
        end
        if is_have == false then
            break
        end
    until false
end

function ChatData:delFriendChatCache(id)
	for i,v in pairs(self.vec_chat_cache) do
		if v.rid == id then
            table.remove(self.vec_chat_cache, i)
            return
		end
    end
end


function ChatData:insertSystemChatData(content)
-- //    int8_t chat_type;               // 1.系统  2.世界  3.公会  4.喇叭  5.私聊  (组队未设置.)
-- //    int64_t player_id;              // 玩家id (0 为系统)
-- //    int64_t friend_id;              // 好友id
-- //    int64_t clan_id;                // 公会id (无 公会为0)
-- //    int32_t send_time;              // 发送时间
-- //    int16_t player_level;           // 玩家等级
-- //    int8_t is_vip;                  // 是否是会员
-- //    char player_name[NAME_LENGTH];  // 玩家昵称 (系统为空)
-- //    char clan_name[NAME_LENGTH];    // 公会名称
-- //    char chat_content[200];         // 聊天内容
    local unit = {}
    unit.chat_type = 1
    unit.player_id = 0
    unit.send_time = ex.Game:getServerTime()
    unit.chat_content = content
    self:resChatData(unit)
end

function ChatData:getFriendChatHistory(friend_id)
    local iter_chat = self.map_chat_friends[friend_id]
    if iter_chat ~= nil then
        return iter_chat
	end
    return nil
end

function ChatData:newChatUnit()
    local unit = ChatUnit:new()
    return unit
end

-- 更新红点
function ChatData:updateReddot()
    local unread_num_world = self.vec_unread_num[ChatLayerType.CLT_WORLD] or 0
    local unread_num_clan = self.vec_unread_num[ChatLayerType.CLT_CLAN] or 0
    local unread_num_friend = self.vec_unread_num[ChatLayerType.CLT_FRIEND] or 0
    local unread_num_server = self.vec_unread_num[ChatLayerType.CLT_SERVER] or 0
    local unread_num_city = self.vec_unread_num[ChatLayerType.CLT_CITY] or 0
    local unread_num_crusade = self.vec_unread_num[ChatLayerType.CLT_CRUSADE] or 0
    local unread_num_countrywar = self.vec_unread_num[ChatLayerType.CLT_COUNTRYWAR] or 0
    
    -- 跨服和同省频道有等级限制,未开启时不显示红点
    if cfg.opencondition.condition["main_chat_cross_share"].condition_value > ex.Player.level then
        unread_num_server = 0
    end
    
    if cfg.opencondition.condition["main_chat_city"].condition_value > ex.Player.level then
        unread_num_city = 0
    end

    if cfg.opencondition.condition["main_crusade_group"].condition_value > ex.Player.level then
        unread_num_crusade = 0
    end

    if not ex.JumpManager:checkOpenConditionByAtomNoMsg("main_country_war") or ctr.country_war.data:getStage() ~= COUNTRY_WAR_STATE.BATTLE or not ctr.country_war.data:getHadjoin() then
        unread_num_countrywar = 0
    end

    local red_dot_manager = ex.RedDotManager
    red_dot_manager:setRedNodeVisible(RedDotType.ZCJ_LTDC_ZCLTAN_SJLT, unread_num_world > 0, unread_num_world)
	red_dot_manager:setRedNodeVisible(RedDotType.ZCJ_LTDC_ZCLTAN_JTLT, unread_num_clan > 0, unread_num_clan)
	red_dot_manager:setRedNodeVisible(RedDotType.ZCJ_LTDC_ZCLTAN_HYLT, unread_num_friend > 0, unread_num_friend)
	red_dot_manager:setRedNodeVisible(RedDotType.ZCJ_LTDC_ZCLTAN_KF, unread_num_server > 0, unread_num_server)
    red_dot_manager:setRedNodeVisible(RedDotType.ZCJ_LTDC_ZCLTAN_TS, unread_num_city > 0, unread_num_city)
    red_dot_manager:setRedNodeVisible(RedDotType.ZCJ_LTDC_ZCLTAN_TFT, unread_num_crusade > 0, unread_num_crusade)
    red_dot_manager:setRedNodeVisible(RedDotType.ZCJ_LTDC_ZCLTAN_ANYZYLT, unread_num_countrywar > 0, unread_num_countrywar)
end

return ChatData