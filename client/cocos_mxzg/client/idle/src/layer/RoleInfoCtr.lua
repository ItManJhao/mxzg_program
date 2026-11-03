local RoleInfoCtr = class("RoleInfoCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local RoleInfoLayer = class("RoleInfoLayer", require("src.comp.EventLayer"))

local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

--------------------------------------------

function RoleInfoLayer:onCreate()
	self:setAutoClose(true)
    self:setSwallowTouches(true)
    self:addBlackBackground()

    self.menu:setSwallowsTouches(true)

    self:reorderChild(self.menu_hero, 100)

    self.lbl_attack = cc.Label:createWithBMFont("font/red-26.fnt", 0)
	-- self.lbl_attack:setOpacity(last_opacity)
	self.lbl_attack:setAnchorPoint(cc.p(0.5, 0.5))
	self.node_attack:addChild(self.lbl_attack, 50)
	-- self.node_attack:setLocalZOrder(9999)
    self.lbl_attack:setPosition(40, 0)
    
    self.spr_assist_tip_9:setLocalZOrder(1000)

    self:addEvent(EVENT.COMPARE_EVENT.COMPARE_BATTLE_LOG_RES,handler(self, self.onShareBattle))
    self:addEvent(EVENT.FRIEND_EVENT.UPDATE_BLACK_LIST,handler(RoleInfoCtr:instance(), RoleInfoCtr:instance().updateBtnBlackList))
end

function RoleInfoLayer:onShareBattle(event,data)
    
    local cur_type = ex.MainSceneCtr:getCurLayerType()

    local battle_layer = self:addBattleLayer(BattleType.PVP_DEFENSE,
                                            cur_type,
                                            "",
                                            EVENT.COMPARE_EVENT.COMPARE_BATTLE_LOG_RES_CALLBACK,
                                            function()
                                                require("src.layer.compareshare.CompareShareCtr"):instance():openWindow(data)
                                                -- require("src.layer.RoleInfoCtr"):instance():closeWindow()
                                                -- local role_ctr =  require("src.layer.RoleInfoCtr"):instance()
                                                -- if role_ctr:isOpened() then 
                                                --     role_ctr:closeWindow()
                                                -- end
                                                if ex.ConfirmCtr:isOpened() then 
                                                    ex.ConfirmCtr:closeWindow()
                                                end
                                                return true, false
                                            end)
    battle_layer:showCloseBtn(true)
    battle_layer:showSpeedBtn(true,false)
    -- battle_layer:setScale(1.0 / self:getParent():getScale())
    battle_layer:setPosition(self:getContentSize().width * 0.5  / battle_layer:getScale() - ex.p.width  * 0.5,
                            self:getContentSize().height * 0.5 / battle_layer:getScale() - ex.p.height * 0.5)
    
    battle_layer.battle_info:setCloseHandler(function()

        local title , content , callback_confirm , confirm_str , cancel_str , show_cancel , auto_close
        title = ex.Tools:getLang(72016)
        content = ex.Tools:getLang(73027)
        confirm_str = ex.Tools:getLang(2401)
        callback_confirm = function ()  
            battle_layer.battle_ctr:forceStop()
        end
        show_cancel = false
        ex.ConfirmCtr:openWindow(title, content, callback_confirm,confirm_str,cancel_str, show_cancel, auto_close)
    
    end)
                            
    ex.EventManager:fire(EVENT.COMPARE_EVENT.COMPARE_BATTLE_LOG_RES_CALLBACK, data.report, {}, data)
end

function RoleInfoLayer:init(data)
    self:updateMatrix(data.formation_id, data.assistance_unlock)

    self.spr_photo:setSpriteFrame(string.format("head-icon/%d.png", data.head_id))
    self.spr_photo_bg:setSpriteFrame(ex.Tools:getBorderIconByIdx(data.border_id))
    self.lbl_level:setString(string.format("%d", data.level))

    self.lbl_name:setString(ex.StringUtil.getServerName(data.server_id)..data.nick)
    self.lbl_rank:setString(ex.Tools:getLang(52205).." "..data.rank)
    self.lbl_attack:setString(data.fighting)

    if data.clan_id == NULL_ID then
        self.lbl_clan:setString(ex.Tools:getLang(1240))
    else
        self.lbl_clan:setString(data.clan_name)
    end

    ex.Tools:setSpriteFrame(self.spr_matrix, string.format("hero-select/spr-matrix-2-%d.png", data.formation_id or 1))

    -- 显示玩家队伍
    self.menu_hero:removeAllChildren()

    for i,v in ipairs(data.hero_data) do
        local hero_data = v

        local item = UIMenuItemHero:createWithData()
        item:reset(hero_data)
        if hero_data.fashion_id ~= 0 and hero_data.fashion_id ~= nil then
            item:setFashionShowForce(hero_data.fashion_id)
        end

        item:setScale(0.7)
        item:setEnableAction(false)
        item:setTag(i + 1)
        :registerScriptTapHandler(handler(self, self.onHeroInfo))
        self.menu_hero:add(item)

        local node = self["node_icon_"..v.pos]
        item:setPosition(node:getPosition())

        item.server_id = data.server_id
        item.role_id = data.player_id
        item.hero_id = hero_data.hero_id
    end

    if data.player_id == ex.Player.role_id then
        self.btn_add_friend:setVisible(false)
        self.btn_chat:setVisible(false)
        self.btn_compare:setVisible(false)
    elseif data.server_id ~= tonumber(cc.UserDefault:getInstance():getStringForKey("server_id")) then 
        self.btn_add_friend:setVisible(false)
        self.btn_chat:setVisible(false)
        self.btn_compare:setVisible(true)
        self.btn_compare:setPositionX(self:getContentSize().width / 4)
        self.btn_black_list:setPositionX(self:getContentSize().width * 3 / 4)
    else
        local is_friend = ex.Player.friend_data:isMyFriend(data.player_id)
        self.btn_add_friend:setVisible(not is_friend)
        self.btn_chat:setVisible(is_friend)
        self.btn_compare:setVisible(true)
    end

end

function RoleInfoLayer:updateMatrix(matrix_type, assistance_unlock)
    local item_list = {}
    local config_addition = cfg.battlematrixaddition.battlematrixaddition
    for i,v in ipairs(config_addition) do
        if v.type == matrix_type then
            table.insert(item_list, v)
        end
    end

    -- 显示锁状态及属性加成
    for i,v in ipairs(item_list) do
        self["spr_lock_"..v.position]:setVisible(v.is_open <= 0)

        if v.position == 9 then
            self["spr_lock_"..v.position]:setVisible(not assistance_unlock)
        end
    end
end

function RoleInfoLayer:onHeroInfo(tag, pSender)
    if pSender.server_id == nil or pSender.role_id == nil or pSender.hero_id == nil then
        return
    end

    local req = HeroShare_pb.GReqHeroBriefInfo()
    req.server_id = pSender.server_id
    req.rid = pSender.role_id
    req.hero_id = pSender.hero_id
    NetManager:sendMessage(ProtocolID.GReqHeroBriefInfo, req)
end

-----------------------------------------------------------------------------
function RoleInfoCtr:onCreate()
	self:setCCBIPath("ccbi/RoleInfoLayer.ccbi")
	self:setIsSingle(false)
end

function RoleInfoCtr:getLayerClass()
	return RoleInfoLayer
end

function RoleInfoCtr:getRankLayer()
	return self.layer
end

function RoleInfoCtr:openWindow(data)
    dump(data)
	if self:isOpened() then
		return
	end
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/role-info.plist")

	self:loadLayer()
	self:open()
	self:initData(data)
end

function RoleInfoCtr:initData(data)
    self.layer.btn_add_friend:registerScriptTapHandler(handler(self, self.onAddFriend))
    self.layer.btn_chat:registerScriptTapHandler(handler(self, self.onChat))
    self.layer.btn_compare:registerScriptTapHandler(handler(self, self.onCompare))
    self.layer.btn_black_list:registerScriptTapHandler(handler(self, self.onBlackList))

	self:updateLayer(data)
end

function RoleInfoCtr:updateLayer(data)
    -- dump(data)
	self.data = data
    self.layer:init(data)

    self:updateBtnBlackList()
end

function RoleInfoCtr:updateBtnBlackList(event)
    if ex.Player.friend_data:isInBlackList(self.data.player_id) then
        self.layer.btn_black_list:setLabelText(ex.Tools:getLang(47485))
    else
        self.layer.btn_black_list:setLabelText(ex.Tools:getLang(47408))
    end

    if self.data.player_id == ex.Player.role_id then
        self.layer.btn_add_friend:setVisible(false)
        self.layer.btn_chat:setVisible(false)
        self.layer.btn_compare:setVisible(false)
        self.layer.btn_black_list:setVisible(false)
    elseif self.data.server_id ~= tonumber(cc.UserDefault:getInstance():getStringForKey("server_id")) then 
        self.layer.btn_add_friend:setVisible(false)
        self.layer.btn_chat:setVisible(false)
        self.layer.btn_compare:setVisible(true)
    else
        local is_friend = ex.Player.friend_data:isMyFriend(self.data.player_id)
        self.layer.btn_add_friend:setVisible(not is_friend)
        self.layer.btn_chat:setVisible(is_friend)
        self.layer.btn_compare:setVisible(true)
    end
end

-- 添加好友
function RoleInfoCtr:onAddFriend(tag, pSender)
    local req = Friend_pb.GReqFriendsAdd()
    req.rid = self.data.player_id

    NetManager:sendMessage(ProtocolID.GReqFriendsAdd,req)
end

-- 私聊
function RoleInfoCtr:onChat(tag, pSender)

    self:closeWindow()
    require("src.layer.RankListCtr"):instance():closeWindow()
    require("src.layer.RankTopThreeCtr"):instance():closeWindow()
    ex.Player.chat_data:insertFriendChatCache(self.data.player_id)

    local chat_ctr = require("src.layer.ChatCtr"):instance()
    chat_ctr:openWindow()
    chat_ctr:friendChat(self.data.player_id)
end

-- 切磋
function RoleInfoCtr:onCompare(tag, pSender)
    local req = Battle_pb.GReqStudy()
    req.type = self.data.server_id == tonumber(cc.UserDefault:getInstance():getStringForKey("server_id")) and 0 or 1
    req.server_id = self.data.server_id
    req.opponent_id = self.data.player_id

    NetManager:sendMessage(ProtocolID.GReqStudy,req)
end

-- 拉黑
function RoleInfoCtr:onBlackList(tag, pSender)

    -- 如果在黑名单中，则跳转到好友界面的黑名单栏，否则请求拉黑
    if ex.Player.friend_data:isInBlackList(self.data.player_id) then
        require("src.layer.friend.FriendCtr"):instance():openWindow(4)

        self:closeWindow()
    else
        -- 如果为好友，则需要弹出二次确认框
        -- if ex.Player.friend_data:isMyFriend(self.data.player_id) then
            local str_content = string.format(ex.Tools:getLang(4017), self.data.nick)
            require("src.layer.ConfirmCtr"):instance():openWindow(ex.Tools:getLang(4016),
                                                                str_content,
                                                                handler(self, self.onBlackListDone))
        -- else
        --     self:onBlackListDone()
        -- end
    end
end

function RoleInfoCtr:onBlackListDone()
    ex.Player.friend_data:blackListAdd(self.data.player_id, self.data.server_id)
end

return RoleInfoCtr
