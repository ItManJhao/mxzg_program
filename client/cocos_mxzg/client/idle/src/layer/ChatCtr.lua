local ChatCtr = class("ChatCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ChatLayer = class("ChatLayer", require("src.comp.EventLayerAdaptiveWidth"))


local btn_tab_list = {
	{idx = 1, name = "btn_world", label = ex.Tools:getLang(5177), tag = ChatLayerType.CLT_WORLD, reddot = RedDotType.ZCJ_LTDC_ZCLTAN_SJLT},
	{idx = 2, name = "btn_clan", label = ex.Tools:getLang(5000), tag = ChatLayerType.CLT_CLAN, reddot = RedDotType.ZCJ_LTDC_ZCLTAN_JTLT},
	{idx = 3, name = "btn_friend", label = ex.Tools:getLang(5111), tag = ChatLayerType.CLT_FRIEND, reddot = RedDotType.ZCJ_LTDC_ZCLTAN_HYLT},
	{idx = 4, name = "btn_system", label = ex.Tools:getLang(5298), tag = ChatLayerType.CLT_SYSTEM, reddot = 0},
	{idx = 5, name = "btn_server", label = ex.Tools:getLang(5209), tag = ChatLayerType.CLT_SERVER, reddot = RedDotType.ZCJ_LTDC_ZCLTAN_KF},
	{idx = 6, name = "btn_city", label = ex.Tools:getLang(5688), tag = ChatLayerType.CLT_CITY, reddot = RedDotType.ZCJ_LTDC_ZCLTAN_TS},

    {idx = 7, name = "btn_crusade", label = ex.Tools:getLang(77603), tag = ChatLayerType.CLT_CRUSADE, reddot = 0},
    {idx = 8, name = "btn_countrywar", label = ex.Tools:getLang(53331), tag = ChatLayerType.CLT_COUNTRYWAR, reddot = RedDotType.ZCJ_LTDC_ZCLTAN_ANYZYLT},
}


-- 聊天cell
local ChatLeftCell = class("ChatLeftCell", require("src.comp.EventLayer"))
function ChatLeftCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.menu:setSwallowsTouches(true)
    self.btn_photo:setContentSize(self.spr_photo:getContentSize())

    -- self.spr_title:setVisible(false)

    -- self.lbl_content:setTextColor(cc.c4b(109, 75, 48, 255))

    -- 创建Label对象，并初始化
    local scale_label = 0.5
    self.lbl_content = require("src.comp.RichTextEx"):create()
        :setFontSize(40)
        :setFontFace(FONT_DEFAULT_NAME_BOLD)
        :setFontColor("#5A3509")
        :setScale(scale_label)
        :setAnchorPoint(0, 1)
        :setAnchorTextShadow(true)
        :ignoreContentAdaptWithSize(
            -- :setFontColor("#613C19")
            false
        )
        :setWrapMode(1)
    self.lbl_content:setContentSize(cc.size(350 / scale_label, 0))
    self:addChild(self.lbl_content, 10001)

    self.lbl_content:setCallback(handler(ChatCtr:instance(), ChatCtr.openRichTextUrl))
end

function ChatLeftCell:setString(content)
    -- if ex.Player.chat_data:isEquipInfo(content) then
    --     self.lbl_content:setVisible(false)
    -- else

    -- 处理表情
    local msg =
        string.gsub(
        content,
        "(%#%d+%#)",
        function(w)
            local emojiConfig = cfg.emojiconfig.getEmojiConfigByText(w)
            if not emojiConfig then
                return w
            else
                local str = string.format('< img src= "%s" width = "%s" height = "%s" />', emojiConfig.img, emojiConfig.width, emojiConfig.height)
                return str
            end
        end
    )
    self.lbl_content:setXmlTextLua(msg)
    self.lbl_content:formatText()
    -- end
end

-- 聊天右cell
local ChatRightCell = class("ChatRightCell", require("src.comp.EventLayer"))
function ChatRightCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.menu:setSwallowsTouches(true)
    self.btn_photo:setContentSize(self.spr_photo:getContentSize())

    -- self.spr_title:setVisible(false)

    -- self.lbl_content:setTextColor(cc.c4b(109, 75, 48, 255));

    -- 创建Label对象，并初始化
    local scale_label = 0.5
    self.lbl_content = require("src.comp.RichTextEx"):create()
        :setFontSize(40)
        :setFontFace(FONT_DEFAULT_NAME_BOLD)
        :setFontColor("#5A3509")
        :setScale(scale_label):setAnchorPoint(0, 1)
        :setAnchorTextShadow(true):ignoreContentAdaptWithSize(
            -- :setFontColor("#613C19")
            false
        )
        :setWrapMode(1)
    self.lbl_content:setContentSize(cc.size(350 / scale_label, 0))
    self:addChild(self.lbl_content, 10001)

    self.lbl_content:setCallback(handler(ChatCtr:instance(), ChatCtr.openRichTextUrl))
end

function ChatRightCell:setString(content)
    -- if ex.Player.chat_data:isEquipInfo(content) then
    --     self.lbl_content:setVisible(false)
    -- else

    -- 处理表情
    local msg =
        string.gsub(
        content,
        "(%#%d+%#)",
        function(w)
            local emojiConfig = cfg.emojiconfig.getEmojiConfigByText(w)
            if not emojiConfig then
                return w
            else
                local str = string.format('< img src= "%s" width = "%s" height = "%s" />', emojiConfig.img, emojiConfig.width, emojiConfig.height)
                return str
            end
        end
    )

    self.lbl_content:setXmlTextLua(msg)
    self.lbl_content:formatText()
    -- end
end

-- 聊天系统频道cell
local ChatSystemCell = class("ChatSystemCell", require("src.comp.EventLayer"))
function ChatSystemCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    -- 创建Label对象，并初始化
    local scale_label = 0.5
    self.msg_content = require("src.comp.RichTextEx"):create()
        :setFontSize(40)
        :setFontFace(FONT_DEFAULT_NAME_BOLD)
        :setFontColor("#5A3509")
        :setScale(scale_label)
        :setAnchorPoint(0, 1)
        :setAnchorTextShadow(true)
        :ignoreContentAdaptWithSize(
            -- :setFontColor("#613C19")
            false
        )
        :setWrapMode(1)
    self.msg_content:setContentSize(cc.size(440 / scale_label, 300 / scale_label))
    self:addChild(self.msg_content, 10001)

    self.msg_content:setCallback(handler(ChatCtr:instance(), ChatCtr.openRichTextUrl))
end

-- 聊天好友频道cell
local ChatFriendCell = class("ChatFriendCell", require("src.comp.EventLayer"))
function ChatFriendCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.spr_add:setVisible(false)

    self:reorderChild(self.lbl_name, 10)

    -- auto chat_ctr = ChatCtr::instance();
    -- btn_close->setCallback(CC_CALLBACK_1(ChatCtr::onFriendCancel, chat_ctr));
end

-- 系统频道
local ChatSystemLayer = class("ChatSystemLayer", require("src.comp.EventLayer"))
function ChatSystemLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end

-- 世界频道
local ChatWorldLayer = class("ChatWorldLayer", require("src.comp.EventLayer"))
function ChatWorldLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end

-- 公会频道
local ChatClanLayer = class("ChatClanLayer", require("src.comp.EventLayer"))
function ChatClanLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end

-- 好友频道
local ChatFriendLayer = class("ChatFriendLayer", require("src.comp.EventLayer"))
function ChatFriendLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end

function ChatFriendLayer:updateFriendList()
    local now_time = cpp.Game:instance():getServerTime()
    if now_time - self.refresh_time < 60 then
        return
    end
    self.refresh_time = now_time

    -- ReqFriendsListInfo req_friends_list;
    -- NetManager::instance()->send(&req_friends_list, sizeof(req_friends_list));
end

-- 跨服频道
local ChatServerLayer = class("ChatServerLayer", require("src.comp.EventLayer"))
function ChatServerLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end

-- 同省频道
local ChatCityLayer = class("ChatCityLayer", require("src.comp.EventLayer"))
function ChatCityLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end

-- 讨伐团频道
local ChatCrusadeLayer = class("ChatCrusadeLayer", require("src.comp.EventLayer"))
function ChatCrusadeLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end

-- 国战频道
local ChatCountryWarLayer = class("ChatCountryWarLayer", require("src.comp.EventLayer"))
function ChatCountryWarLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end

function ChatLayer:onCreate()
    self:addBlackBackground()
    self:setAnchorPoint(0.5, 0.5)
    self:setIgnoreAnchorPointForPosition(true)

    -- self:setPosition( - (self:getContentSize().width + 200) * self:getScale() , ex.p.height * 0.5 - self:getContentSize().height * 0.5 * self:getScale())
    self.lbl_edit_text = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 20)
    self.lbl_edit_text:setVisible(false)
    self:addChild(self.lbl_edit_text, 98)

    -- self.btn_tab = {}
    -- self.btn_tab[ChatLayerType.CLT_WORLD] = self.btn_world
    -- self.btn_tab[ChatLayerType.CLT_CLAN] = self.btn_clan
    -- self.btn_tab[ChatLayerType.CLT_FRIEND] = self.btn_friend
    -- self.btn_tab[ChatLayerType.CLT_SYSTEM] = self.btn_system
    -- self.btn_tab[ChatLayerType.CLT_SERVER] = self.btn_server
    -- self.btn_tab[ChatLayerType.CLT_CITY] = self.btn_city
    -- self.btn_tab[ChatLayerType.CLT_CRUSADE] = self.btn_crusade
    -- self.btn_tab[ChatLayerType.CLT_COUNTRYWAR] = self.btn_countrywar

    -- for _,btn in pairs(self.btn_tab) do
    --     btn:setVisible(false)
    --     btn:resetOrder(false)
    --     btn:setLabelOffset(cc.p(0, -2))
    -- end

    -- self.btn_countrywar:setLabelText(ex.Tools:getLang(53331))
    -- self.btn_crusade:setLabelText(ex.Tools:getLang(77603))
    -- self.btn_city:setLabelText(ex.Tools:getLang(5688))
    -- self.btn_server:setLabelText(ex.Tools:getLang(5209))
    -- self.btn_world:setLabelText(ex.Tools:getLang(5177))
    -- self.btn_clan:setLabelText(ex.Tools:getLang(5000))
    -- self.btn_friend:setLabelText(ex.Tools:getLang(5111))
    -- self.btn_system:setLabelText(ex.Tools:getLang(5298))
    -- ex.Tools:setLimitWidth(self.btn_countrywar:getLabel(), 85);

    local content_size = self:getContentSize()
    self.layer_system = ChatSystemLayer:createWithCCBIFile("ccbi/ChatSystemLayer.ccbi")
    self.layer_system:setPosition(cc.p(content_size.width / 2 - self.layer_system:getContentSize().width / 2, 0))
    self.layer_system:setVisible(false)
    self:addChild(self.layer_system)

    self.layer_world = ChatWorldLayer:createWithCCBIFile("ccbi/ChatWorldLayer.ccbi")
    self.layer_world:setPosition(cc.p(content_size.width / 2 - self.layer_world:getContentSize().width / 2, 0))
    self.layer_world:setVisible(false)
    self:addChild(self.layer_world)

    self.layer_clan = ChatClanLayer:createWithCCBIFile("ccbi/ChatClanLayer.ccbi")
    self.layer_clan:setPosition(cc.p(content_size.width / 2 - self.layer_clan:getContentSize().width / 2, 0))
    self.layer_clan:setVisible(false)
    self:addChild(self.layer_clan)

    self.layer_friend = ChatFriendLayer:createWithCCBIFile("ccbi/ChatFriendLayer.ccbi")
    self.layer_friend:setPosition(cc.p(content_size.width / 2 - self.layer_friend:getContentSize().width / 2, 0))
    self.layer_friend:setVisible(false)
    self:addChild(self.layer_friend)

    self.layer_server = ChatServerLayer:createWithCCBIFile("ccbi/ChatServerLayer.ccbi")
    self.layer_server:setPosition(cc.p(content_size.width / 2 - self.layer_server:getContentSize().width / 2, 0))
    self.layer_server:setVisible(false)
    self:addChild(self.layer_server)

    self.layer_city = ChatCityLayer:createWithCCBIFile("ccbi/ChatCityLayer.ccbi")
    self.layer_city:setPosition(cc.p(content_size.width / 2 - self.layer_city:getContentSize().width / 2, 0))
    self.layer_city:setVisible(false)
    self:addChild(self.layer_city)

    self.layer_crusade = ChatCrusadeLayer:createWithCCBIFile("ccbi/ChatCrusadeLayer.ccbi")
    self.layer_crusade:setPosition(cc.p(content_size.width / 2 - self.layer_city:getContentSize().width / 2, 0))
    self.layer_crusade:setVisible(false)
    self:addChild(self.layer_crusade)

    self.layer_countrywar = ChatCountryWarLayer:createWithCCBIFile("ccbi/ChatCountryWarLayer.ccbi")
    self.layer_countrywar:setPosition(cc.p(content_size.width / 2 - self.layer_city:getContentSize().width / 2, 0))
    self.layer_countrywar:setVisible(false)
    self:addChild(self.layer_countrywar)

    self.btn_send:setLabelText(ex.Tools:getLang(23))
    self.btn_send:setLabelColor(cc.c3b(109, 75, 48))

    local red_dot_manager = ex.RedDotManager
    -- red_dot_manager:setStickNode(RedDotType.ZCJ_LTDC_ZCLTAN_SJLT, self.btn_world)
    -- red_dot_manager:setStickNode(RedDotType.ZCJ_LTDC_ZCLTAN_JTLT, self.btn_clan)
    -- red_dot_manager:setStickNode(RedDotType.ZCJ_LTDC_ZCLTAN_HYLT, self.btn_friend)
    -- red_dot_manager:setStickNode(RedDotType.ZCJ_LTDC_ZCLTAN_KF, self.btn_server)
    -- red_dot_manager:setStickNode(RedDotType.ZCJ_LTDC_ZCLTAN_TS, self.btn_city)
    -- local width = content_size.width / 2 * self:getScaleX() - 20
    -- self.scroll_view_tab:setViewSize(cc.size(300, 50))

    local menu = cpp.UIMenu:create()
    menu:setPosition(cc.p(0, 0))
    menu:setName("m")
    menu:setIsTouchInsideNode(self.scroll_view_tab);
    menu:setSwallowsTouches(false);
    self.scroll_view_tab:getContainer():addChild(menu)
    
    self.btn_tab = {}
    for i,v in ipairs(btn_tab_list) do
        local btn_tab = cpp.UIMenuItemTab:create("chat/btn-tab-1.png", "chat/btn-tab-2.png", " ", 1, 1)
        btn_tab:setVisible(false)
        btn_tab:resetOrder(false)
        btn_tab:setScale(0.95)
        btn_tab:setLabelText(v.label)

        local lbl = btn_tab:getLabel();
        if lbl:getContentSize().width * lbl:getScaleX() > 85 then
            -- 将按钮变成九宫格精灵
            local spr_normal = ccui.Scale9Sprite:createWithSpriteFrameName("chat/btn-tab-1.png", cc.rect(20, 10, 40, 15))
            spr_normal:setContentSize(cc.size(lbl:getContentSize().width * lbl:getScaleX() + 20, btn_tab:getContentSize().height))
            btn_tab:setNormalImage(spr_normal)

            local spr_select = ccui.Scale9Sprite:createWithSpriteFrameName("chat/btn-tab-2.png", cc.rect(20, 10, 40, 15))
            spr_select:setContentSize(cc.size(lbl:getContentSize().width * lbl:getScaleX() + 20, btn_tab:getContentSize().height))
            btn_tab:setSelectedImage(spr_select)

            btn_tab:setLabelText("")
            btn_tab:setLabelText(v.label)
        end
        
        btn_tab:setLabelColor(cc.c3b(109, 75, 48));
        btn_tab:setLabelOffset(cc.p(0, -2))

        if v.reddot ~= 0 then
            red_dot_manager:setStickNode(v.reddot, btn_tab)
        end

        self.btn_tab[v.tag] = btn_tab;
        menu:addChild(btn_tab);
    end

    self:addEvent(EVENT.VIDEO_STUDIO_EVENT.SHARE_BATTLE_PLAY_BACK, handler(self, self.onShareBattle))
end

function ChatLayer:onShareBattle(event, data)
    local cur_type = ex.MainSceneCtr:getCurLayerType()

    local battle_layer =
        self:addBattleLayer(
        BattleType.COMP,
        cur_type,
        "",
        EVENT.VIDEO_STUDIO_EVENT.SHARE_BATTLE_PLAY_BACK_CALLBACK,
        function()
            return true, false
        end
    )
    battle_layer:showCloseBtn(true)
    battle_layer:showSpeedBtn(true, false)
    battle_layer:setScale(1.0 / self:getScaleX())
    battle_layer:setPosition(self:getContentSize().width * 0.5 - ex.p.width * 0.5, self:getContentSize().height * 0.5 - ex.p.height * 0.5)

    ex.EventManager:fire(EVENT.VIDEO_STUDIO_EVENT.SHARE_BATTLE_PLAY_BACK_CALLBACK, data.report, {}, data)
end

function ChatLayer:onExit()
    local red_dot_manager = ex.RedDotManager
    red_dot_manager:setStickNode(RedDotType.ZCJ_LTDC_ZCLTAN_SJLT, nil)
    red_dot_manager:setStickNode(RedDotType.ZCJ_LTDC_ZCLTAN_JTLT, nil)
    red_dot_manager:setStickNode(RedDotType.ZCJ_LTDC_ZCLTAN_HYLT, nil)
    red_dot_manager:setStickNode(RedDotType.ZCJ_LTDC_ZCLTAN_ZDLT, nil)
    red_dot_manager:setStickNode(RedDotType.ZCJ_LTDC_ZCLTAN_KF, nil)
    red_dot_manager:setStickNode(RedDotType.ZCJ_LTDC_ZCLTAN_TS, nil)
    red_dot_manager:setStickNode(RedDotType.ZCJ_LTDC_ZCLTAN_ANYZYLT, nil)
end

-----------------------------------------------------------------------------
function ChatCtr:onCreate()
    self:setCCBIPath("ccbi/ChatLayer.ccbi")
    self:setIsSingle(false)
end

function ChatCtr:getLayerClass()
    return ChatLayer
end

function ChatCtr:getChatLayer()
    return self.layer
end

function ChatCtr:openWindow(vec_chat_type, focus_type)
    -- print("ChatCtr:openWindow")
    if self.layer ~= nil then
        self:runLayerAction(true)
    else
        local sfc = cc.SpriteFrameCache:getInstance()
        sfc:addSpriteFrames("ccbi-res/chat.plist")
        sfc:addSpriteFrames("ccbi-res/emoji.plist")
        sfc:addSpriteFrames("ccbi-res/setting-identification.plist")

        self:loadLayer()
        self:open()
        self:initData(vec_chat_type, focus_type)

        self.layer:stopAllActions()
        self:runLayerAction(true)
    end
end

function ChatCtr:closeWindow(tag, pSender)
    self:runLayerAction(false)
end

function ChatCtr:initData(vec_chat_type, focus_type)
    if vec_chat_type == nil or table.nums(vec_chat_type) <= 0 then
        vec_chat_type = {ChatLayerType.CLT_CITY, ChatLayerType.CLT_SERVER, ChatLayerType.CLT_WORLD, ChatLayerType.CLT_CLAN, ChatLayerType.CLT_FRIEND, ChatLayerType.CLT_SYSTEM}
    end

    local margin = 2;
    local offset = 8;
    local x = margin;
    for i,v in ipairs(vec_chat_type) do
        local btn = self.layer.btn_tab[v];
        if btn ~= nil then
            x = x + btn:getContentSize().width * btn:getScaleX()  + offset;
            btn:setVisible(true);
            btn:setPosition(x - btn:getContentSize().width * btn:getScaleX() * 0.5 - offset * 0.5 , 25);
        end
    end

    local scroll_view =  self.layer.scroll_view_tab
    scroll_view:setContentSize(cc.size(math.max(scroll_view:getViewSize().width, x + margin), scroll_view:getViewSize().height));

    if self.current_type == nil then
        self.current_type = vec_chat_type[1]
    end

    if focus_type ~= nil then
        for k,v in pairs(vec_chat_type) do
            if v == focus_type then
                self.current_type = focus_type;
                break
            end
        end
    end

    if self.current_type > ChatLayerType.CLT_CITY then
        local offset = scroll_view:getContentOffset()
        local x = scroll_view:getViewSize().width - scroll_view:getContentSize().width
        local new_x = cc.clampf(self.layer.btn_tab[self.current_type]:getPositionX() - scroll_view:getViewSize().width * 0.5 - scroll_view:getContentSize().width, 0, x)
        scroll_view:setContentOffset(cc.p(new_x, 0))
    end

    if self.layer.layer_city.btn_ignore ~= nil then
        self.layer.layer_city.btn_ignore:registerScriptTapHandler(handler(self, self.onIgnoreChatWorld))

        local is_ignore = cc.UserDefault:getInstance():getIntegerForKey("ignore_chat_city", 1)

        local str_btn_ignore_text = "lang-1/btn-chat-close.png"
        if is_ignore == 1 then
            str_btn_ignore_text = "lang-1/btn-chat-open.png"
        end

        self.layer.layer_city.btn_ignore:setNormalImage(cc.Sprite:createWithSpriteFrameName(str_btn_ignore_text))
        self.layer.layer_city.btn_ignore:setSelectedImage(cc.Sprite:createWithSpriteFrameName(str_btn_ignore_text))
        self.layer.layer_city.lbl_ignore_tip:setVisible(is_ignore == 1)
    end

    self.layer.btn_edit_box = cpp.UIMenuItemImage:create()
    self.layer.btn_edit_box:registerScriptTapHandler(handler(self, self.onTouchEditBox))
    self.layer.btn_tab[ChatLayerType.CLT_WORLD]:getParent():addChild(self.layer.btn_edit_box, 99)

    self.is_draw = false

    self.layer:addEvent(EVENT.FRIEND_EVENT.DELETE_FRIEND, handler(self, self.updateChatFriendLayer))

    -- // 设置红点
    ex.Player.chat_data:updateReddot()

    for k, v in pairs(self.layer.btn_tab) do
        v:registerScriptTapHandler(handler(self, self.onChangeLayer))
    end

    -- self.layer.btn_world:registerScriptTapHandler(handler(self, self.onChangeLayer))
    -- self.layer.btn_clan:registerScriptTapHandler(handler(self, self.onChangeLayer))
    -- self.layer.btn_friend:registerScriptTapHandler(handler(self, self.onChangeLayer))
    -- self.layer.btn_system:registerScriptTapHandler(handler(self, self.onChangeLayer))
    -- self.layer.btn_server:registerScriptTapHandler(handler(self, self.onChangeLayer))
    -- self.layer.btn_city:registerScriptTapHandler(handler(self, self.onChangeLayer))

    self.layer.btn_send:registerScriptTapHandler(handler(self, self.onSend))
    self.layer.emoji_layer:setLocalZOrder(999)
    self.layer.emoji_layer:setSwallowsTouches(true)
    self.layer.emoji_layer:setTouchEnabled(false)
    self.layer.emoji_layer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self.layer.emoji_layer:registerScriptTouchHandler(
        function(event, x, y)
            local pos = self.layer.emoji_layer:getParent():convertToNodeSpace(cc.p(x, y))

            if event == "began" then
                local startX = self.layer.emoji_layer:getPositionX()
                local endX = self.layer.emoji_layer:getPositionX() + self.layer.emoji_layer:getContentSize().width
                local startY = self.layer.emoji_layer:getPositionY()
                local endY = self.layer.emoji_layer:getPositionY() + self.layer.emoji_layer:getContentSize().height

                -- 不在表情layer里的就隐藏表情layer
                if pos.x > endX or pos.x < startX or pos.y > endY or pos.y < startY then
                    -- 如果点中了表情按钮，则点击仅隐藏
                    local btn_emoji_pos_x, btn_emoji_pos_y = self.layer.btn_emoji:getPosition()
                    local btn_emoji_size = self.layer.btn_emoji:getContentSize()

                    if pos.x > btn_emoji_pos_x - btn_emoji_size.width / 2 and 
                        pos.x < btn_emoji_pos_x + btn_emoji_size.width / 2 and
                        pos.y > btn_emoji_pos_y - btn_emoji_size.height / 2 and 
                        pos.y < btn_emoji_pos_y + btn_emoji_size.height / 2 then
                        self.layer.emoji_layer:setTouchEnabled(false)
                    else
                        self.layer.emoji_layer:setVisible(false)
                        self.layer.emoji_layer:setTouchEnabled(false)
                    end

                    return false
                else
                    return true
                end
            end
        end
    )

    self.layer.btn_emoji:registerScriptTapHandler(handler(self, self.onEmoji))

    self:initEmojiView()
    -- self:updateLayer()

    -- self:onChangeLayer(nil)

    self:updateLayer()
    self:updateTableView(false)
end

-- 初始化表情界面
function ChatCtr:initEmojiView()
    local svSize = cc.size(100, self.layer.emoji_layout:getContentSize().height)
    local emoji_btn_sv = cc.ScrollView:create(svSize)
    emoji_btn_sv:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)

    emoji_btn_sv:setPosition(
        self.layer.emoji_layout:getPositionX() + self.layer.emoji_layout:getContentSize().width + 4,
        self.layer.emoji_layout:getPositionY() - self.layer.emoji_layout:getContentSize().height / 2
    )

    -- emoji_btn_sv:setSwallowTouches(false)
    self.layer.emoji_layer:addChild(emoji_btn_sv)

    local menu = cpp.UIMenu:create()
    menu:setIsTouchInsideNode(emoji_btn_sv)
    menu:setSwallowsTouches(false)
    menu:setPosition(cc.p(0, 0))
    emoji_btn_sv:addChild(menu)

    local svContentHeight = 0
    local startY = 0
    local emojiType = 1
    local offsetX = 0
    if emojiType < 3 then
        startY = svSize.height - (97 + 10) * (emojiType - 1) - 97
    end
    for i = 1, emojiType do
        local btn_emoji = cpp.UIMenuItemImage:createWithSpriteFrameName(string.format("chat/btn-emoji-%d.png", 1), nil, nil)
        btn_emoji:setPosition(svSize.width / 2, startY + btn_emoji:getContentSize().height / 2 + (i - 1) * (btn_emoji:getContentSize().height + 10))
        btn_emoji:registerScriptTapHandler(handler(self, self.onEmojiChooseType))
        menu:addChild(btn_emoji)
        btn_emoji:setTag(i)

        if i == 1 then
            svContentHeight = svContentHeight + btn_emoji:getContentSize().height
        else
            svContentHeight = svContentHeight + btn_emoji:getContentSize().height + 10
        end
    end

    if svContentHeight < svSize.height then
        svContentHeight = svSize.height
        emoji_btn_sv:setTouchEnabled(false)
    end
    emoji_btn_sv:setContentSize(svSize.width, svContentHeight)
    emoji_btn_sv:setContentOffset(cc.p(0, -svContentHeight + svSize.height))
end

-- 初始化表情选择界面
function ChatCtr:initEmojiChooseView(tag)
    local svSize = cc.size(self.layer.emoji_layout:getContentSize().width, self.layer.emoji_layout:getContentSize().height)

    if not self.layer.emoji_sc then
        self.layer.emoji_sc = cc.ScrollView:create(svSize)
        self.layer.emoji_sc:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)

        self.layer.emoji_sc:setPosition(self.layer.emoji_layout:getPositionX(), self.layer.emoji_layout:getPositionY() - self.layer.emoji_layout:getContentSize().height / 2)
        self.layer.emoji_layer:addChild(self.layer.emoji_sc)

        self.emoji_menu = cpp.UIMenu:create()
        self.emoji_menu:setIsTouchInsideNode(self.layer.emoji_sc)
        self.emoji_menu:setSwallowsTouches(false)
        self.emoji_menu:setPosition(cc.p(0, 0))
        self.layer.emoji_sc:addChild(self.emoji_menu)
    end

    self.emoji_menu:removeAllChildren()

    local margin = 10
    local col
    local row
    local offsetX = 0
    local startY = 0
    local cHeight = 0

    if tag == 1 then
        local len = cfg.emojiconfig.getEmojiNum(tag)
        for i = 1, len do
            local btn_emoji = cpp.UIMenuItemImage:createWithSpriteFrameName(string.format("emoji/emoji-%d-%d.png", tag, i), nil, nil)

            if i == 1 then
                col = math.floor((svSize.width - margin * 2) / btn_emoji:getContentSize().width)
                row = math.ceil(len / col)
                offsetX = (svSize.width - margin * 2 - btn_emoji:getContentSize().width * col) / (col - 1)
                if row * btn_emoji:getContentSize().height < svSize.height then
                    startY = svSize.height - row * btn_emoji:getContentSize().height
                    cHeight = svSize.height
                    self.layer.emoji_sc:setTouchEnabled(false)
                else
                    cHeight = row * btn_emoji:getContentSize().height
                end
            end

            local curRow = math.floor((i - 1) / col)
            local curCol = (col - (i - (curRow * col))) % col

            btn_emoji:setPosition(
                margin + btn_emoji:getContentSize().width / 2 + (col - curCol - 1) * (btn_emoji:getContentSize().width + offsetX),
                startY + (row - curRow) * btn_emoji:getContentSize().width - btn_emoji:getContentSize().width / 2
            )
            btn_emoji:registerScriptTapHandler(handler(self, self.onEmojiClicked))
            btn_emoji:setTag(tag * 1000 + i)
            self.emoji_menu:addChild(btn_emoji)
        end
    end

    self.layer.emoji_sc:setContentSize(cc.size(svSize.width, cHeight))
    self.layer.emoji_sc:setContentOffset(cc.p(0, -cHeight + svSize.height))
end

function ChatCtr:updateChatFriendLayer(event)
    self:updateLayer()
    self:updateFriendList()
    self:updateTableView(false)
end

function ChatCtr:getTimeText(time)
    if time == 0 then
        return ex.Tools:getLang(47226)
    end

    local str_time = ex.StringUtil.convertToHowLong(math.max(0, time))
    return str_time
end

function ChatCtr:isLayerVisible(layer_type)
    if self.layer == nil then
        return false
    end

    return self.current_type == layer_type
end

function ChatCtr:runLayerAction(is_open)
    if self.layer == nil then
        return
    end

    self.is_draw = is_open

    -- 暂时不执行移到边界的动画，直接隐藏或显示
    if not is_open then
        self:fastClose()
    end

    if true then
        return
    end

    -- self.layer.btn_draw:setChecked(self.is_draw)
    -- self.layer:stopActionByTag(100)
    -- if self.is_draw == true then
    --     -- print("ChatCtr:runLayerAction", is_open)
    --     self.layer:setAutoClose(true)
    --     self.layer:setSwallowTouches(true)
    --     local action_move = cc.EaseExponentialOut:create(cc.MoveTo:create(0.5, cc.p(ex.p.width * 0.5 - self.layer:getContentSize().width * self.layer:getScale() * 0.5, self.layer:getPositionY())))
    --     local action_callback = cc.CallFunc:create(function()
    --     end)
    --     local action = cc.Sequence:create(action_move, action_callback, nil)
    --     action:setTag(100)
    --     self.layer:runAction(action)
    --     -- self:updateTableView()
    --     -- self:startScheduler()
    -- else
    --     -- print("ChatCtr:runLayerAction", is_open)
    --     self.layer:setAutoClose(false)
    --     self.layer:setSwallowTouches(false)
    --     local action_move = cc.EaseExponentialOut:create(cc.MoveTo:create(0.5, cc.p(-714 * self.layer:getScale(), self.layer:getPositionY())))
    --     local action_callback = cc.CallFunc:create(function()
    --         self:fastClose()
    --     end)
    --     local action = cc.Sequence:create(action_move, action_callback, nil)
    --     action:setTag(100)
    --     self.layer:runAction(action)
    --     -- self:stopAllScheduler();
    -- end

    -- local red_dot_manager = ex.RedDotManager
    -- red_dot_manager:setSpecialVisible( RDT_MS_CHAT_DRAW_BTN  , not self.is_draw )
end

function ChatCtr:updateLayer()
    if not self:getLayer() then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/chat.plist")

    if self.layer.edit_box ~= nil then
        self.layer.edit_box:setVisible(false)
        self.layer.edit_box:runAction(cc.RemoveSelf:create())
        self.layer.edit_box = nil
    end

    if self.layer.friends_table_view ~= nil then
        self.layer.friends_table_view:removeFromParent(true)
        self.layer.friends_table_view = nil
    end

    self.layer.layer_system:setVisible(false)
    self.layer.layer_world:setVisible(false)
    self.layer.layer_clan:setVisible(false)
    self.layer.layer_friend:setVisible(false)
    self.layer.layer_server:setVisible(false)
    self.layer.layer_city:setVisible(false)
    self.layer.layer_crusade:setVisible(false)
    self.layer.layer_countrywar:setVisible(false)

    self.layer.lbl_edit_text:setVisible(false)
    self.layer.spr_input_bg:setVisible(true)
    self.layer.btn_emoji:setVisible(true)
    self.layer.btn_send:setVisible(true)
    -- //    self.layer.btn_emoji:setVisible(true);

    ex.Player.chat_data:setChatRead(self.current_type)

    if self.current_type == ChatLayerType.CLT_SYSTEM then
        self.layer.btn_tab[ChatLayerType.CLT_SYSTEM]:setChecked(true)
        self.layer.btn_send:setVisible(false)
        -- //        self.layer.btn_emoji:setVisible(false);
        self.layer.spr_input_bg:setVisible(false)
        self.layer.btn_emoji:setVisible(false)
        self.layer.layer_system:setVisible(true)
    elseif self.current_type == ChatLayerType.CLT_WORLD then
        self.layer.btn_tab[ChatLayerType.CLT_WORLD]:setChecked(true)
        self:createEditBox(cc.size(320, 40), cc.p(220, 70))
        self.layer.layer_world:setVisible(true)
    elseif self.current_type == ChatLayerType.CLT_CLAN then
        self.layer.btn_tab[ChatLayerType.CLT_CLAN]:setChecked(true)
        self:createEditBox(cc.size(320, 40), cc.p(220, 70))
        self.layer.layer_clan:setVisible(true)
    elseif self.current_type == ChatLayerType.CLT_FRIEND then
        self.layer.btn_tab[ChatLayerType.CLT_FRIEND]:setChecked(true)
        self:createEditBox(cc.size(320, 40), cc.p(220, 70))

        self.layer.layer_friend:setVisible(true)

        self:updateFriendList()
        self:updateTableView()
        self:updateFriendInfo()
    elseif self.current_type == ChatLayerType.CLT_SERVER then
        self.layer.btn_tab[ChatLayerType.CLT_SERVER]:setChecked(true)
        self:createEditBox(cc.size(320, 40), cc.p(220, 70))
        self.layer.layer_server:setVisible(true)
    elseif self.current_type == ChatLayerType.CLT_CITY then
        self.layer.btn_tab[ChatLayerType.CLT_CITY]:setChecked(true)
        self:createEditBox(cc.size(320, 40), cc.p(220, 70))
        self.layer.layer_city:setVisible(true)
    elseif self.current_type == ChatLayerType.CLT_CRUSADE then
        self.layer.btn_tab[ChatLayerType.CLT_CRUSADE]:setChecked(true)
        self:createEditBox(cc.size(320, 40), cc.p(220, 70))
        self.layer.layer_crusade:setVisible(true)
    elseif self.current_type == ChatLayerType.CLT_COUNTRYWAR then
        self.layer.btn_tab[ChatLayerType.CLT_COUNTRYWAR]:setChecked(true)
        self:createEditBox(cc.size(320, 40), cc.p(220, 70))
        self.layer.layer_countrywar:setVisible(true)
    end

    if (self.current_type == ChatLayerType.CLT_SYSTEM and table.nums(ex.Player.chat_data.vec_chat_system) <= 0) or
            (self.current_type == ChatLayerType.CLT_CLAN and table.nums(ex.Player.chat_data.vec_chat_clan) <= 0) or
            (self.current_type == ChatLayerType.CLT_WORLD and table.nums(ex.Player.chat_data.vec_chat_world) <= 0) or
            (self.current_type == ChatLayerType.CLT_SERVER and table.nums(ex.Player.chat_data.vec_chat_server) <= 0) or
            (self.current_type == ChatLayerType.CLT_CITY and table.nums(ex.Player.chat_data.vec_chat_city) <= 0) or
            (self.current_type == ChatLayerType.CLT_CRUSADE and table.nums(ex.Player.chat_data.vec_chat_crusade) <= 0) or
            (self.current_type == ChatLayerType.CLT_COUNTRYWAR and table.nums(ex.Player.chat_data.vec_chat_countrywar) <= 0) then
        local req_chat_log = Chat_pb.GReqChatLogByType()
        req_chat_log.type = self.current_type
        NetManager:sendMessage(ProtocolID.GReqChatLogByType, req_chat_log)
    end
end

function ChatCtr:updateTableViewWithLayerType(layer_type, is_keep_offset)
    if self.layer == nil or self.current_type ~= layer_type then
        return
    end

    self:updateTableView(false, is_keep_offset)
end

function ChatCtr:updateTableView(is_init, is_keep_offset)
    if self.layer == nil then
        return
    end

    local offset_y = 0
    if is_keep_offset ~= nil and is_keep_offset == true and self.layer.table_view ~= nil then
        offset_y = self.layer.table_view:getContentOffset().y
        if math.abs(offset_y) <= 20 then
            offset_y = 0
        end
    end

    -- 保证tableview只有一份，防止触摸点混乱
    if self.layer.table_view ~= nil then
        self.layer.table_view:removeFromParent()
        self.layer.table_view = nil
    end

    self.layer.table_view = cc.TableView:create(cc.size(546, 590))
    self.layer.table_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.layer.table_view:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.layer.table_view:setBounceable(false)
    self.layer.table_view:setIgnoreAnchorPointForPosition(false)
    self.layer.table_view:setAnchorPoint(0.5, 0)
    self.layer.table_view:setDelegate()
    self.layer.table_view:setDataSource()
    self.layer.table_view:setContentOffset(cc.p(0, 0))

    if is_init ~= true and self.current_type ~= ChatLayerType.CLT_FRIEND then
        ex.Player.chat_data:setChatRead(self.current_type)
    end

    if self.current_type == ChatLayerType.CLT_SYSTEM then
        self.layer.table_view:setViewSize(cc.size(570, 650))
        self.layer.table_view:setPosition(self.layer.layer_system:getContentSize().width / 2, 70)
        self.layer.layer_system:addChild(self.layer.table_view, 99)
    elseif self.current_type == ChatLayerType.CLT_WORLD then
        self.layer.table_view:setViewSize(cc.size(570, 615))
        self.layer.table_view:setPosition(self.layer.layer_world:getContentSize().width / 2, 125)
        self.layer.layer_world:addChild(self.layer.table_view, 99)
    elseif self.current_type == ChatLayerType.CLT_CLAN then
        self.layer.table_view:setViewSize(cc.size(570, 615))
        self.layer.table_view:setPosition(self.layer.layer_clan:getContentSize().width / 2, 125)
        self.layer.layer_clan:addChild(self.layer.table_view, 99)
    elseif self.current_type == ChatLayerType.CLT_FRIEND then
        self.layer.table_view:setViewSize(cc.size(450, 615))
        self.layer.table_view:setPosition(self.layer.layer_friend:getContentSize().width / 2 + 60, 125)
        self.layer.layer_friend:addChild(self.layer.table_view, 99)
    elseif self.current_type == ChatLayerType.CLT_SERVER then
        self.layer.table_view:setViewSize(cc.size(570, 615))
        self.layer.table_view:setPosition(self.layer.layer_server:getContentSize().width / 2, 125)
        self.layer.layer_server:addChild(self.layer.table_view, 99)
    elseif self.current_type == ChatLayerType.CLT_CITY then
        self.layer.table_view:setViewSize(cc.size(570, 615))
        self.layer.table_view:setPosition(self.layer.layer_city:getContentSize().width / 2, 125)
        self.layer.layer_city:addChild(self.layer.table_view, 99)
    elseif self.current_type == ChatLayerType.CLT_CRUSADE then
        self.layer.table_view:setViewSize(cc.size(570, 615))
        self.layer.table_view:setPosition(self.layer.layer_crusade:getContentSize().width / 2, 125)
        self.layer.layer_crusade:addChild(self.layer.table_view, 99)
    elseif self.current_type == ChatLayerType.CLT_COUNTRYWAR then
        self.layer.table_view:setViewSize(cc.size(570, 615))
        self.layer.table_view:setPosition(self.layer.layer_countrywar:getContentSize().width / 2, 125)
        self.layer.layer_countrywar:addChild(self.layer.table_view, 99)
    end

    self.layer.table_view:registerScriptHandler(handler(self, self.scrollViewDidScroll), cc.SCROLLVIEW_SCRIPT_SCROLL) --滚动时的回掉函数
    self.layer.table_view:registerScriptHandler(handler(self, self.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX) --列表项的尺寸
    self.layer.table_view:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX) --创建列表项
    self.layer.table_view:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW) --列表项的数量
    -- self.layer.table_view:registerScriptHandler(handler(self, self.tableCellWillRecycle),cc.TABLECELL_WILL_RECYCLE);            --列表项将被回收
    self.layer.table_view:registerScriptHandler(handler(self, self.tableCellTouched), cc.TABLECELL_TOUCHED) --列表项被点击
    -- self.layer.table_view:registerScriptHandler(handler(self, self.tableCellHighLight),cc.TABLECELL_HIGH_LIGHT);                --列表项高亮显示
    -- self.layer.table_view:registerScriptHandler(handler(self, self.tableCellUnhighLight),cc.TABLECELL_UNHIGH_LIGHT);            --列表项取消高亮

    self.layer.table_view:reloadData()
    self.layer.table_view:setContentOffset(cc.p(0, offset_y))
end

-- 刷新好友聊天里的好友列表
function ChatCtr:updateFriendList()
    if self.layer == nil then
        return
    end

    if self.layer.friends_table_view ~= nil then
        self.layer.friends_table_view:removeFromParent()
        self.layer.friends_table_view = nil
    end

    if self.current_type ~= ChatLayerType.CLT_FRIEND then
        return
    end

    -- 选择一个默认选中
    local is_friend_in_list = false
    for i, v in pairs(ex.Player.chat_data.vec_chat_cache) do
        if self.friend_id == v.rid then
            is_friend_in_list = true
            break
        end
    end
    if not is_friend_in_list then
        self.friend_id = -1
        self.pre_touched_index = 1
        for i, v in pairs(ex.Player.chat_data.vec_chat_cache) do
            self.friend_id = v.rid
            self.pre_touched_index = i

            -- local vec_friend_chat = ex.Player.chat_data.map_chat_friends[v.rid]
            -- if vec_friend_chat == nil or table.nums(vec_friend_chat) <= 0 then
            local req = Chat_pb.GReqPrivateChatLog()
            req.friend_id = self.friend_id
            NetManager:sendMessage(ProtocolID.GReqPrivateChatLog, req)
            -- end

            break
        end
    end

    ex.Player.chat_data:setChatRead(ChatLayerType.CLT_FRIEND, self.friend_id)

    -- 检查一遍好友列表合法性，如果好友被删除了，则踢除出列表
    ex.Player.chat_data:updateChatFriend()

    self.layer.friends_table_view = cc.TableView:create(cc.size(120, 620))
    self.layer.friends_table_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.layer.friends_table_view:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.layer.friends_table_view:setBounceable(false)
    self.layer.friends_table_view:setDelegate()
    self.layer.friends_table_view:setDataSource()
    self.layer.friends_table_view:setName("friends_table_view")
    self.layer.friends_table_view:setPosition(15, 120)
    self.layer.layer_friend:addChild(self.layer.friends_table_view)

    self.layer.friends_table_view:registerScriptHandler(handler(self, self.scrollViewDidScroll), cc.SCROLLVIEW_SCRIPT_SCROLL) --滚动时的回掉函数
    self.layer.friends_table_view:registerScriptHandler(handler(self, self.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX) --列表项的尺寸
    self.layer.friends_table_view:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX) --创建列表项
    self.layer.friends_table_view:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW) --列表项的数量
    -- self.layer.friends_table_view:registerScriptHandler(handler(self, self.tableCellWillRecycle),cc.TABLECELL_WILL_RECYCLE);            --列表项将被回收
    self.layer.friends_table_view:registerScriptHandler(handler(self, self.tableCellTouched), cc.TABLECELL_TOUCHED) --列表项被点击
    -- self.layer.friends_table_view:registerScriptHandler(handler(self, self.tableCellHighLight),cc.TABLECELL_HIGH_LIGHT);                --列表项高亮显示
    -- self.layer.friends_table_view:registerScriptHandler(handler(self, self.tableCellUnhighLight),cc.TABLECELL_UNHIGH_LIGHT);            --列表项取消高亮

    self.layer.friends_table_view:reloadData()
    -- self.layer.friends_table_view:setContentOffset(cc.p(0, 0))
end

function ChatCtr:updateFriendInfo()
    if self.layer == nil then
        return
    end

    local data = ex.Player.chat_data:getFriendChatCache(self.friend_id)
    local friend_chat_num = table.nums(ex.Player.chat_data.vec_chat_cache)

    if friend_chat_num <= 0 then
        self.layer.btn_send:setVisible(false)
        self.layer.spr_input_bg:setVisible(false)
        self.layer.btn_emoji:setVisible(false)

        if self.layer.edit_box ~= nil then
            self.layer.edit_box:setVisible(false)
        end
    end

    if data == nil or data.player_id == 0 then
        self.friend_id = -1
        self.pre_touched_index = -1

        if friend_chat_num > 0 then
            self.pre_touched_index = friend_chat_num
            self.friend_id = ex.Player.chat_data.vec_chat_cache[friend_chat_num]
        end

        self:updateFriendList()
        return
    end

    if self.layer.friends_table_view ~= nil then
        local vec_child = self.layer.friends_table_view:getContainer():getChildren()
        for i, v in ipairs(vec_child) do
            local friend_cell = v:getChildByTag(99)
            if friend_cell ~= nil then
                if friend_cell.player_id == data.player_id and friend_cell.player_id > 0 then
                    friend_cell.spr_bg:setSpriteFrame("chat/spr-friend-cell-1.png")
                    friend_cell.lbl_name:setColor(FONT_BROWN)
                    friend_cell.btn_close:setVisible(true)
                else
                    friend_cell.spr_bg:setSpriteFrame("chat/spr-friend-cell-2.png")
                    friend_cell.lbl_name:setColor(FONT_LIGHT_YELLOW)
                    friend_cell.btn_close:setVisible(false)
                end
            end
        end
    end

    self.layer.btn_send:setVisible(true)
    self.layer.spr_input_bg:setVisible(true)
    self.layer.btn_emoji:setVisible(true)

    if self.layer.edit_box ~= nil then
        self.layer.edit_box:setVisible(true)
    end

    if self.layer.table_view ~= nil then
        self.layer.table_view:reloadData()
        self.layer.table_view:setContentOffset(cc.p(0, 0))
    else
        self:updateTableView(true)
    end

    ex.Player.friend_data:saveFriendMsgReadTime(data.player_id, cpp.Game:instance():getServerTime())
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_LTDC_ZCLTAN_HYLT, ex.Player.chat_data.hasUnreadChat(5))
end

-- // tableview所需实现接口
function ChatCtr:scrollViewDidScroll(scroll_view)
    if scroll_view:getName() ~= "friends_table_view" and scroll_view:getContentOffset().y > 0 then
    -- scroll_view:setContentOffset(cc.p(0, 0))
    end
end

function ChatCtr:tableCellTouched(table_view, cell)
    if table_view:getName() == "friends_table_view" then
        local data = ex.Player.chat_data.vec_chat_cache[cell:getIdx() + 1]
        if data ~= nil then
            local sfc = cc.SpriteFrameCache:getInstance()
            local friend_cell = cell:getChildByTag(99)
            friend_cell.spr_bg:setSpriteFrame(sfc:getSpriteFrame("chat/spr-friend-cell-1.png"))

            friend_cell.spr_unread:setVisible(false)

            if self.friend_id == data.rid then
                return
            end

            self.friend_id = data.rid

            if cell:getIdx() ~= self.pre_touched_index then
                table_view:updateCellAtIndex(self.pre_touched_index)
            end
            self.pre_touched_index = cell:getIdx()

            self:updateFriendInfo()

            -- 如果好友聊天列表为空，则请求好友私聊列表
            -- local vec_friend_chat = ex.Player.chat_data.map_chat_friends[data.rid]
            -- if vec_friend_chat == nil or table.nums(vec_friend_chat) <= 0 then
            local req = Chat_pb.GReqPrivateChatLog()
            req.friend_id = self.friend_id
            NetManager:sendMessage(ProtocolID.GReqPrivateChatLog, req)
            -- end

            ex.Player.chat_data:setChatRead(ChatLayerType.CLT_FRIEND, self.friend_id)
        else
            -- 打开好友选择界面，选择私聊对象
            require("src.layer.friend.FriendCtr"):instance():openWindow()
        end
    elseif self.current_type == ChatLayerType.CLT_WORLD or 
            self.current_type == ChatLayerType.CLT_CLAN or 
            self.current_type == ChatLayerType.CLT_SERVER or 
            self.current_type == ChatLayerType.CLT_CITY or 
            self.current_type == ChatLayerType.CLT_CRUSADE or
            self.current_type == ChatLayerType.CLT_COUNTRYWAR then
        local chat_cell = cell:getChildByTag(99)
        self.player_id = chat_cell.player_id

        if ex.Player.role_id == self.player_id then
            return
        end
        -- //        CCLOG(ex.Tools:getLang(47562));
        -- // 添加添加好友选项
        local popup_menu_ctr = require("src.layer.PopupMenuCtr"):instance()
        local vec_item = {}
        -- // 查看
        table.insert(vec_item, {ex.Tools:getLang(47694), handler(self, self.onPlayerVisit)})
        table.insert(vec_item, {ex.Tools:getLang(47687), handler(self, self.onAddFriend)})
        local point = cell:convertToWorldSpace(cc.p(chat_cell:getPositionX() + 70, chat_cell:getPositionY() + chat_cell:getContentSize().height * 0.5 - 35))
        local photo = -1
        local data = nil
        if self.current_type == ChatLayerType.CLT_WORLD then
            data = ex.Player.chat_data.vec_chat_world[table.nums(ex.Player.chat_data.vec_chat_world) - cell:getIdx()]
        elseif self.current_type == ChatLayerType.CLT_CLAN then
            data = ex.Player.chat_data.vec_chat_clan[table.nums(ex.Player.chat_data.vec_chat_clan) - cell:getIdx()]
        end
        if data == nil then
            return
        end

        if data.photo < 0 then
            photo = 0
        else
            photo = data.photo
        end

    -- popup_menu_ctr:openWindow(point, photo, data.player_name, vec_item)

    -- self:onPlayerVisit(0, nil)
    end
end

function ChatCtr:cellSizeForTable(table_view, idx)
    if table_view:getName() == "friends_table_view" then
        return 120, 125
    elseif self.current_type == ChatLayerType.CLT_SYSTEM then
        -- local index = table.nums(ex.Player.chat_data.vec_chat_system) - idx
        local data = ex.Player.chat_data.vec_chat_system[idx + 1]
        return 546, data.size_content.height + 25
    elseif self.current_type == ChatLayerType.CLT_WORLD then
        -- local index = table.nums(ex.Player.chat_data.vec_chat_world) - idx
        -- local data = ex.Player.chat_data.vec_chat_world[index]
        local data = ex.Player.chat_data.vec_chat_world[idx + 1]
        return data.size_content.width, data.size_content.height + 65
    elseif self.current_type == ChatLayerType.CLT_CLAN then
        -- local index = table.nums(ex.Player.chat_data.vec_chat_clan) - idx
        -- local data = ex.Player.chat_data.vec_chat_clan[index]
        local data = ex.Player.chat_data.vec_chat_clan[idx + 1]
        return data.size_content.width, data.size_content.height + 65
    elseif self.current_type == ChatLayerType.CLT_FRIEND then
        local vec = ex.Player.chat_data:getFriendChatHistory(self.friend_id)
        -- local data = vec[table.nums(vec) - idx]
        local data = vec[idx + 1]
        if data ~= nil then
            return data.size_content.width, data.size_content.height + 65
        end
    elseif self.current_type == ChatLayerType.CLT_SERVER then
        local data = ex.Player.chat_data.vec_chat_server[idx + 1]
        return data.size_content.width, data.size_content.height + 65
    elseif self.current_type == ChatLayerType.CLT_CITY then
        local data = ex.Player.chat_data.vec_chat_city[idx + 1]
        return data.size_content.width, data.size_content.height + 65
    elseif self.current_type == ChatLayerType.CLT_CRUSADE then
        local data = ex.Player.chat_data.vec_chat_crusade[idx + 1]
        return data.size_content.width, data.size_content.height + 65
    elseif self.current_type == ChatLayerType.CLT_COUNTRYWAR then
        local data = ex.Player.chat_data.vec_chat_countrywar[idx + 1]
        return data.size_content.width, data.size_content.height + 65
    end
    return 0, 0
end

function ChatCtr:tableCellAtIndex(table_view, idx)
    local cell = cc.TableViewCell:create()
    cell:setLocalZOrder(-idx)

    ex.Tools:try(
        function()
            local sfc = cc.SpriteFrameCache:getInstance()
            if table_view:getName() == "friends_table_view" then
                local data = ex.Player.chat_data.vec_chat_cache[idx + 1]
                local item_data = nil
                if data ~= nil then
                    item_data = ex.Player.chat_data:getFriendChatCache(data.rid)
                end
                local friend_cell = ChatFriendCell:createWithCCBIFile("ccbi/ChatFriendCell.ccbi")
                friend_cell:setPosition(0, 2)
                friend_cell:setTag(99)
                cell:addChild(friend_cell)

                if item_data ~= nil then
                    -- local spr_frame = sfc:getSpriteFrame(string.format("other/spr-online-%d.png", item_data.online_status + 1))
                    friend_cell.player_id = item_data.player_id
                    friend_cell.lbl_name:setString(item_data.name)
                    friend_cell.lbl_level:setString(tostring(item_data.level))
                    friend_cell.spr_unread:setVisible(data.red_status > 0)
                    friend_cell.spr_photo:setSpriteFrame(string.format("head-icon/%d.png", item_data.head_id))
                    friend_cell.spr_photo_bg:setSpriteFrame(ex.Tools:getBorderIconByIdx(item_data.border_id))
                    -- friend_cell.spr_online:setSpriteFrame(spr_frame)

                    friend_cell.btn_close:registerScriptTapHandler(handler(self, self.closeFriendChat))

                    local friend_data = ex.Player.friend_data:getFriendById(item_data.player_id)
                    if friend_data ~= nil then
                        friend_cell.lbl_level:setString(tostring(friend_data.player_level))
                        local spr_frame = sfc:getSpriteFrame(string.format("head-icon/%d.png", friend_data.head_id))
                        if spr_frame ~= nil then
                            friend_cell.spr_photo:setSpriteFrame(spr_frame)
                        end
                    end

                    if self.friend_id == item_data.player_id then
                        friend_cell.spr_bg:setSpriteFrame("chat/spr-friend-cell-1.png")
                        friend_cell.lbl_name:setColor(FONT_BROWN)
                        friend_cell.btn_close:setVisible(true)
                    else
                        friend_cell.spr_bg:setSpriteFrame("chat/spr-friend-cell-2.png")
                        friend_cell.lbl_name:setColor(FONT_LIGHT_YELLOW)
                        friend_cell.btn_close:setVisible(false)
                    end
                else
                    -- 添加一个➕加按钮，点击后打开好友选择列表
                    friend_cell.btn_close:setVisible(false)
                    friend_cell.lbl_level:setVisible(false)
                    friend_cell.spr_level_bg:setVisible(false)
                    friend_cell.spr_photo:setVisible(false)
                    friend_cell.spr_photo_bg:setVisible(false)
                    friend_cell.lbl_name:setVisible(false)
                    friend_cell.spr_unread:setVisible(false)

                    friend_cell.spr_add:setVisible(true)

                    if self.friend_id == nil or self.friend_id <= 0 then
                        friend_cell.spr_bg:setSpriteFrame("chat/spr-friend-cell-1.png")
                    else
                        friend_cell.spr_bg:setSpriteFrame("chat/spr-friend-cell-2.png")
                    end
                end
            elseif self.current_type == ChatLayerType.CLT_SYSTEM then
                -- local index = table.nums(ex.Player.chat_data.vec_chat_system) - idx
                local data = ex.Player.chat_data.vec_chat_system[idx + 1]

                local system_cell = ChatSystemCell:createWithCCBIFile("ccbi/ChatSystemCell.ccbi")
                system_cell:setPosition(12, 0)

                local size = cc.size(546, data.size_content.height + 22)

                system_cell.msg_content:setXmlTextLua(data.str_chat_content)
                system_cell.msg_content:formatText()

                system_cell.msg_flag:setPosition(51, size.height - 23)
                system_cell.msg_content:setPosition(98, size.height - 11)

                system_cell:setContentSize(size)
                system_cell.msg_bg:setPreferredSize(size)
                system_cell:setTag(99)
                cell:addChild(system_cell)
            elseif self.current_type == ChatLayerType.CLT_WORLD then
                -- if data.title_id ~= nil and data.title_id > 0 then
                --     msg_cell.spr_title:setSpriteFrame(string.format("title/%d.png", data.title_id))
                --     local posX = msg_cell.lbl_name:getPosition().x
                --     posX = posX + (msg_cell.lbl_name:getContentSize().width * msg_cell.lbl_name:getScale() + 10) * (data.player_id == ex.Player.role_id and -1 or 1)
                --     msg_cell.spr_title:setPositionX(posX)
                --     msg_cell.spr_title:setVisible(true)
                -- end
                -- local data = ex.Player.chat_data.vec_chat_world[table.nums(ex.Player.chat_data.vec_chat_world) - idx]
                local data = ex.Player.chat_data.vec_chat_world[idx + 1]
                local msg_cell = nil

                if data.photo < 0 then
                    data.photo = 0
                end
                if data.player_id ~= ex.Player.role_id then
                    msg_cell = ChatLeftCell:createWithCCBIFile("ccbi/ChatLeftCell.ccbi")
                    msg_cell:setPosition(0, 0)

                    msg_cell.lbl_content:setPosition(110, data.size_content.height + 12)
                    msg_cell.node_parent:setPosition(20, data.size_content.height - 15)
                    msg_cell.spr_bg:setPosition(90, data.size_content.height + 22)
                    msg_cell.spr_bg:setContentSize(cc.size(30 + data.size_content.width, 20 + data.size_content.height))

                    -- add 熊梦 添加尊贵标识 
                    msg_cell.spr_peerage:setVisible(false)
                    msg_cell.lbl_name:setPositionX(88)

                    if data.peerage_level > 0 then
                        local peerage_frame = sfc:getSpriteFrame(string.format("setting-identification/spr-%d-xiao.png", data.peerage_level))
                        if peerage_frame ~= nil then
                            msg_cell.spr_peerage:setVisible(true)
                            msg_cell.spr_peerage:setSpriteFrame(peerage_frame)
                            msg_cell.lbl_name:setPositionX(121)
                        end
                    end
                else
                    data.photo = ex.Player.head_id
                    data.border_id = ex.Player.border_id

                    msg_cell = ChatRightCell:createWithCCBIFile("ccbi/ChatRightCell.ccbi")
                    msg_cell:setPosition(0, 0)

                    msg_cell:setPositionX(table_view:getViewSize().width - msg_cell:getContentSize().width - 20)
                    msg_cell.lbl_content:setPosition(msg_cell:getContentSize().width - data.size_content.width - 95, data.size_content.height + 12)

                    msg_cell.node_parent:setPositionY(data.size_content.height - 15)
                    msg_cell.spr_bg:setPositionY(data.size_content.height + 22)
                    msg_cell.spr_bg:setContentSize(cc.size(30 + data.size_content.width, 20 + data.size_content.height))

                    -- add 熊梦 添加尊贵标识 
                    msg_cell.spr_peerage:setVisible(false)
                    msg_cell.lbl_name:setPositionX(356)

                    if data.peerage_level > 0 then
                        local peerage_frame = sfc:getSpriteFrame(string.format("setting-identification/spr-%d-xiao.png", data.peerage_level))
                        if peerage_frame ~= nil then
                            msg_cell.spr_peerage:setVisible(true)
                            msg_cell.spr_peerage:setSpriteFrame(peerage_frame)
                            msg_cell.lbl_name:setPositionX(320)
                        end
                    end
                end

                msg_cell.menu:setIsTouchInsideNode(table_view)
                msg_cell.btn_photo:registerScriptTapHandler(handler(self, self.onPlayerVisit))
                msg_cell.btn_photo:setPosition(msg_cell.spr_photo:getPosition())
                msg_cell.btn_photo.player_id = data.player_id
                msg_cell.btn_photo.server_id = cc.UserDefault:getInstance():getIntegerForKey("server_id")

                local frame = sfc:getSpriteFrame(string.format("head-icon/%d.png", data.photo))
                if frame == nil then
                    frame = sfc:getSpriteFrame("head-icon/0.png")
                end
                msg_cell.spr_photo:setSpriteFrame(frame)
                msg_cell.spr_border:setSpriteFrame(ex.Tools:getBorderIconByIdx(data.border_id))

                msg_cell.player_id = data.player_id
                msg_cell.lbl_name:setString(data.player_name)
                msg_cell:setTag(99)
                cell:addChild(msg_cell)

                msg_cell:setString(data.str_chat_content)
            elseif self.current_type == ChatLayerType.CLT_CLAN then
                -- local data = ex.Player.chat_data.vec_chat_clan[table.nums(ex.Player.chat_data.vec_chat_clan) - idx]
                local data = ex.Player.chat_data.vec_chat_clan[idx + 1]
                local msg_cell = nil

                if data.photo < 0 then
                    data.photo = 0
                end
                if data.player_id ~= ex.Player.role_id then
                    msg_cell = ChatLeftCell:createWithCCBIFile("ccbi/ChatLeftCell.ccbi")
                    msg_cell:setPosition(0, 0)

                    msg_cell.lbl_content:setPosition(110, data.size_content.height + 12)
                    msg_cell.node_parent:setPosition(20, data.size_content.height - 15)
                    msg_cell.spr_bg:setPosition(90, data.size_content.height + 22)
                    msg_cell.spr_bg:setContentSize(cc.size(30 + data.size_content.width, 20 + data.size_content.height))

                    -- add 熊梦 添加尊贵标识 
                    msg_cell.spr_peerage:setVisible(false)
                    msg_cell.lbl_prename:setPositionX(229)
                    msg_cell.lbl_name:setPositionX(88)

                    if data.peerage_level > 0 then
                        local peerage_frame = sfc:getSpriteFrame(string.format("setting-identification/spr-%d-xiao.png", data.peerage_level))
                        if peerage_frame ~= nil then
                            msg_cell.spr_peerage:setVisible(true)
                            msg_cell.spr_peerage:setSpriteFrame(peerage_frame)
                            msg_cell.lbl_prename:setPositionX(255)
                            msg_cell.lbl_name:setPositionX(121)
                        end
                    end
                else
                    data.photo = ex.Player.head_id
                    data.border_id = ex.Player.border_id

                    msg_cell = ChatRightCell:createWithCCBIFile("ccbi/ChatRightCell.ccbi")
                    msg_cell:setPosition(0, 0)

                    msg_cell:setPositionX(table_view:getViewSize().width - msg_cell:getContentSize().width - 20)
                    msg_cell.lbl_content:setPosition(msg_cell:getContentSize().width - data.size_content.width - 95, data.size_content.height + 12)
                    msg_cell.node_parent:setPositionY(data.size_content.height - 15)
                    msg_cell.spr_bg:setPositionY(data.size_content.height + 22)
                    msg_cell.spr_bg:setContentSize(cc.size(30 + data.size_content.width, 20 + data.size_content.height))

                    -- add 熊梦 添加尊贵标识 
                    msg_cell.spr_peerage:setVisible(false)
                    msg_cell.lbl_prename:setPositionX(243)
                    msg_cell.lbl_name:setPositionX(356)

                    if data.peerage_level > 0 then
                        local peerage_frame = sfc:getSpriteFrame(string.format("setting-identification/spr-%d-xiao.png", data.peerage_level))
                        if peerage_frame ~= nil then
                            msg_cell.spr_peerage:setVisible(true)
                            msg_cell.spr_peerage:setSpriteFrame(peerage_frame)
                            msg_cell.lbl_prename:setPositionX(199)
                            msg_cell.lbl_name:setPositionX(320)
                        end
                    end
                end

                msg_cell.menu:setIsTouchInsideNode(table_view)
                msg_cell.btn_photo:registerScriptTapHandler(handler(self, self.onPlayerVisit))
                msg_cell.btn_photo:setPosition(msg_cell.spr_photo:getPosition())
                msg_cell.btn_photo.player_id = data.player_id
                msg_cell.btn_photo.server_id = cc.UserDefault:getInstance():getIntegerForKey("server_id")

                local frame = sfc:getSpriteFrame(string.format("head-icon/%d.png", data.photo))
                if frame == nil then
                    frame = sfc:getSpriteFrame("head-icon/0.png")
                end
                msg_cell.spr_photo:setSpriteFrame(frame)
                msg_cell.spr_border:setSpriteFrame(ex.Tools:getBorderIconByIdx(data.border_id))

                msg_cell.player_id = data.player_id
                msg_cell.lbl_name:setString(data.player_name)
                msg_cell:setTag(99)
                cell:addChild(msg_cell)

                msg_cell:setString(data.str_chat_content)
            elseif self.current_type == ChatLayerType.CLT_FRIEND then
                local vec = ex.Player.chat_data:getFriendChatHistory(self.friend_id)
                -- local data = vec[table.nums(vec) - idx]
                local data = vec[idx + 1]
                if data ~= nil then
                    if data.photo < 0 then
                        data.photo = 0
                    end

                    data.unread_chat = false
                    local msg_cell = nil
                    if data.player_id ~= ex.Player.role_id then
                        msg_cell = ChatLeftCell:createWithCCBIFile("ccbi/ChatLeftCell.ccbi")
                        msg_cell:setPosition(0, 0)

                        local friend_data = ex.Player.friend_data:getFriendById(self.friend_id)
                        msg_cell.lbl_name:setString(friend_data.player_name)
                        msg_cell.lbl_content:setPosition(110, data.size_content.height + 12)
                        msg_cell.node_parent:setPosition(20, data.size_content.height - 15)
                        msg_cell.spr_bg:setPosition(90, data.size_content.height + 22)
                        msg_cell.spr_bg:setContentSize(cc.size(30 + data.size_content.width, 20 + data.size_content.height))

                         -- add 熊梦 不展示尊贵标识 
                        msg_cell.spr_peerage:setVisible(false)
                        msg_cell.lbl_prename:setPositionX(229)
                        msg_cell.lbl_name:setPositionX(88)
                    else
                        data.photo = ex.Player.head_id
                        data.border_id = ex.Player.border_id

                        msg_cell = ChatRightCell:createWithCCBIFile("ccbi/ChatRightCell.ccbi")
                        msg_cell:setPosition(0, 0)

                        data.photo = ex.Player.head_id

                        msg_cell.lbl_name:setString(ex.Player.nick)

                        msg_cell.lbl_content:setPosition(msg_cell:getContentSize().width - data.size_content.width - 95, data.size_content.height + 12)
                        msg_cell.node_parent:setPositionY(data.size_content.height - 15)
                        msg_cell.spr_bg:setPositionY(data.size_content.height + 22)
                        msg_cell.spr_bg:setContentSize(cc.size(30 + data.size_content.width, 20 + data.size_content.height))

                         -- add 熊梦 不展示尊贵标识 
                        msg_cell.spr_peerage:setVisible(false)
                        msg_cell.lbl_prename:setPositionX(243)
                        msg_cell.lbl_name:setPositionX(356)
                    end

                    msg_cell.menu:setIsTouchInsideNode(table_view)
                    msg_cell.btn_photo:registerScriptTapHandler(handler(self, self.onPlayerVisit))
                    msg_cell.btn_photo:setPosition(msg_cell.spr_photo:getPosition())
                    msg_cell.btn_photo.player_id = data.player_id
                    msg_cell.btn_photo.server_id = cc.UserDefault:getInstance():getIntegerForKey("server_id")

                    local frame = sfc:getSpriteFrame(string.format("head-icon/%d.png", data.photo))
                    if frame == nil then
                        frame = sfc:getSpriteFrame("head-icon/0.png")
                    end
                    msg_cell.spr_photo:setSpriteFrame(frame)
                    msg_cell.spr_border:setSpriteFrame(ex.Tools:getBorderIconByIdx(data.border_id))

                    -- //        msg_cell.lbl_content:setString(data.str_chat_content);
                    msg_cell:setTag(99)
                    cell:addChild(msg_cell)

                    msg_cell.lbl_content:setContentSize(cc.size(msg_cell.lbl_content:getContentSize().width * ex.Player.chat_data.friend_width, 0))

                    msg_cell:setString(data.str_chat_content)
                end
            elseif self.current_type == ChatLayerType.CLT_SERVER then
                -- local data = ex.Player.chat_data.vec_chat_server[table.nums(ex.Player.chat_data.vec_chat_server) - idx]
                local data = ex.Player.chat_data.vec_chat_server[idx + 1]
                local msg_cell = nil

                if data.photo < 0 then
                    data.photo = 0
                end
                if data.player_id ~= ex.Player.role_id then
                    msg_cell = ChatLeftCell:createWithCCBIFile("ccbi/ChatLeftCell.ccbi")
                    msg_cell:setPosition(0, 0)

                    msg_cell.lbl_content:setPosition(110, data.size_content.height + 12)
                    msg_cell.node_parent:setPosition(20, data.size_content.height - 15)
                    msg_cell.spr_bg:setPosition(90, data.size_content.height + 22)
                    msg_cell.spr_bg:setContentSize(cc.size(30 + data.size_content.width, 20 + data.size_content.height))

                    -- add 熊梦 添加尊贵标识 
                    msg_cell.spr_peerage:setVisible(false)
                    msg_cell.lbl_prename:setPositionX(229)
                    msg_cell.lbl_name:setPositionX(88)

                    if data.peerage_level > 0 then
                        local peerage_frame = sfc:getSpriteFrame(string.format("setting-identification/spr-%d-xiao.png", data.peerage_level))
                        if peerage_frame ~= nil then
                            msg_cell.spr_peerage:setVisible(true)
                            msg_cell.spr_peerage:setSpriteFrame(peerage_frame)
                            msg_cell.lbl_prename:setPositionX(250)
                            msg_cell.lbl_name:setPositionX(121)
                        end
                    end
                else
                    data.photo = ex.Player.head_id
                    data.border_id = ex.Player.border_id

                    msg_cell = ChatRightCell:createWithCCBIFile("ccbi/ChatRightCell.ccbi")
                    msg_cell:setPosition(0, 0)

                    msg_cell:setPositionX(table_view:getViewSize().width - msg_cell:getContentSize().width - 20)
                    msg_cell.lbl_content:setPosition(msg_cell:getContentSize().width - data.size_content.width - 95, data.size_content.height + 12)

                    msg_cell.node_parent:setPositionY(data.size_content.height - 15)
                    msg_cell.spr_bg:setPositionY(data.size_content.height + 22)
                    msg_cell.spr_bg:setContentSize(cc.size(30 + data.size_content.width, 20 + data.size_content.height))

                    -- add 熊梦 添加尊贵标识 
                    msg_cell.spr_peerage:setVisible(false)
                    msg_cell.lbl_prename:setPositionX(243)
                    msg_cell.lbl_name:setPositionX(356)

                    if data.peerage_level > 0 then
                        local peerage_frame = sfc:getSpriteFrame(string.format("setting-identification/spr-%d-xiao.png", data.peerage_level))
                        if peerage_frame ~= nil then
                            msg_cell.spr_peerage:setVisible(true)
                            msg_cell.spr_peerage:setSpriteFrame(peerage_frame)
                            msg_cell.lbl_prename:setPositionX(199)
                            msg_cell.lbl_name:setPositionX(320)
                        end
                    end
                end

                msg_cell.menu:setIsTouchInsideNode(table_view)
                msg_cell.btn_photo:registerScriptTapHandler(handler(self, self.onPlayerVisit))
                msg_cell.btn_photo:setPosition(msg_cell.spr_photo:getPosition())
                msg_cell.btn_photo.player_id = data.player_id
                msg_cell.btn_photo.server_id = data.server_id

                local frame = sfc:getSpriteFrame(string.format("head-icon/%d.png", data.photo))
                if frame == nil then
                    frame = sfc:getSpriteFrame("head-icon/0.png")
                end
                msg_cell.spr_photo:setSpriteFrame(frame)
                msg_cell.spr_border:setSpriteFrame(ex.Tools:getBorderIconByIdx(data.border_id))

               

                msg_cell.player_id = data.player_id
                msg_cell.lbl_name:setString(data.player_name)

                msg_cell.lbl_prename:setVisible(true)
                if data.player_id ~= ex.Player.role_id then
                    msg_cell.lbl_prename:setPositionX(msg_cell.lbl_name:getPositionX() + msg_cell.lbl_name:getContentSize().width * msg_cell.lbl_name:getScaleX())
                else
                    msg_cell.lbl_prename:setPositionX(msg_cell.lbl_name:getPositionX() - msg_cell.lbl_name:getContentSize().width * msg_cell.lbl_name:getScaleX())
                end
                msg_cell.lbl_prename:setString(ex.StringUtil.getServerName(data.server_id))

                msg_cell:setTag(99)
                cell:addChild(msg_cell)

                msg_cell:setString(data.str_chat_content)
            elseif self.current_type == ChatLayerType.CLT_CITY then
                -- local data = ex.Player.chat_data.vec_chat_city[table.nums(ex.Player.chat_data.vec_chat_city) - idx]
                local data = ex.Player.chat_data.vec_chat_city[idx + 1]
                local msg_cell = nil

                if data.photo < 0 then
                    data.photo = 0
                end

                if data.player_id ~= ex.Player.role_id then
                    msg_cell = ChatLeftCell:createWithCCBIFile("ccbi/ChatLeftCell.ccbi")
                    msg_cell:setPosition(0, 0)

                    msg_cell.lbl_content:setPosition(110, data.size_content.height + 12)
                    msg_cell.node_parent:setPosition(20, data.size_content.height - 15)
                    msg_cell.spr_bg:setPosition(90, data.size_content.height + 22)
                    msg_cell.spr_bg:setContentSize(cc.size(30 + data.size_content.width, 20 + data.size_content.height))
                    -- add 熊梦 添加尊贵标识 
                    msg_cell.spr_peerage:setVisible(false)
                    msg_cell.lbl_prename:setPositionX(229)
                    msg_cell.lbl_name:setPositionX(88)

                    if data.peerage_level > 0 then
                        local peerage_frame = sfc:getSpriteFrame(string.format("setting-identification/spr-%d-xiao.png", data.peerage_level))
                        if peerage_frame ~= nil then
                            msg_cell.spr_peerage:setVisible(true)
                            msg_cell.spr_peerage:setSpriteFrame(peerage_frame)
                            msg_cell.lbl_prename:setPositionX(250)
                            msg_cell.lbl_name:setPositionX(121)
                        end
                    end
                else
                    data.photo = ex.Player.head_id
                    data.border_id = ex.Player.border_id
                    data.area_idx = ex.Player.area_idx

                    msg_cell = ChatRightCell:createWithCCBIFile("ccbi/ChatRightCell.ccbi")
                    msg_cell:setPosition(0, 0)

                    msg_cell:setPositionX(table_view:getViewSize().width - msg_cell:getContentSize().width - 20)
                    msg_cell.lbl_content:setPosition(msg_cell:getContentSize().width - data.size_content.width - 95, data.size_content.height + 12)

                    msg_cell.node_parent:setPositionY(data.size_content.height - 15)
                    msg_cell.spr_bg:setPositionY(data.size_content.height + 22)
                    msg_cell.spr_bg:setContentSize(cc.size(30 + data.size_content.width, 20 + data.size_content.height))

                    -- add 熊梦 添加尊贵标识 
                    msg_cell.spr_peerage:setVisible(false)
                    msg_cell.lbl_prename:setPositionX(243)
                    msg_cell.lbl_name:setPositionX(356)

                    if data.peerage_level > 0 then
                        local peerage_frame = sfc:getSpriteFrame(string.format("setting-identification/spr-%d-xiao.png", data.peerage_level))
                        if peerage_frame ~= nil then
                            msg_cell.spr_peerage:setVisible(true)
                            msg_cell.spr_peerage:setSpriteFrame(peerage_frame)
                            msg_cell.lbl_prename:setPositionX(199)
                            msg_cell.lbl_name:setPositionX(320)
                        end
                    end
                end

                msg_cell.menu:setIsTouchInsideNode(table_view)
                msg_cell.btn_photo:registerScriptTapHandler(handler(self, self.onPlayerVisit))
                msg_cell.btn_photo:setPosition(msg_cell.spr_photo:getPosition())
                msg_cell.btn_photo:setEnabled(false)
                msg_cell.btn_photo.player_id = data.player_id
                msg_cell.btn_photo.server_id = cc.UserDefault:getInstance():getIntegerForKey("server_id")

                local frame = sfc:getSpriteFrame(string.format("head-icon/%d.png", data.photo))
                if frame == nil then
                    frame = sfc:getSpriteFrame("head-icon/0.png")
                end
                msg_cell.spr_photo:setSpriteFrame(frame)
                msg_cell.spr_border:setSpriteFrame(ex.Tools:getBorderIconByIdx(data.border_id))

                msg_cell.player_id = data.player_id
                msg_cell.lbl_name:setString(data.player_name)

                local area_config = cfg.area.area[data.area_idx]
                msg_cell.lbl_prename:setVisible(true)
                if data.player_id ~= ex.Player.role_id then
                    msg_cell.lbl_prename:setPositionX(msg_cell.lbl_name:getPositionX() + msg_cell.lbl_name:getContentSize().width * msg_cell.lbl_name:getScaleX())
                else
                    msg_cell.lbl_prename:setPositionX(msg_cell.lbl_name:getPositionX() - msg_cell.lbl_name:getContentSize().width * msg_cell.lbl_name:getScaleX())
                end
                -- msg_cell.lbl_prename:setString("["..area_config.city.."]")
                -- 全服ID
                msg_cell.lbl_prename:setString(ex.StringUtil.getServerName(data.server_id))

                msg_cell:setTag(99)
                cell:addChild(msg_cell)

                msg_cell:setString(data.str_chat_content)
            elseif self.current_type == ChatLayerType.CLT_CRUSADE then
                -- local data = ex.Player.chat_data.vec_chat_server[table.nums(ex.Player.chat_data.vec_chat_server) - idx]
                local data = ex.Player.chat_data.vec_chat_crusade[idx + 1]
                local msg_cell = nil

                if data.photo < 0 then
                    data.photo = 0
                end
                if data.player_id ~= ex.Player.role_id then
                    msg_cell = ChatLeftCell:createWithCCBIFile("ccbi/ChatLeftCell.ccbi")
                    msg_cell:setPosition(0, 0)

                    msg_cell.lbl_content:setPosition(110, data.size_content.height + 12)
                    msg_cell.node_parent:setPosition(20, data.size_content.height - 15)
                    msg_cell.spr_bg:setPosition(90, data.size_content.height + 22)
                    msg_cell.spr_bg:setContentSize(cc.size(30 + data.size_content.width, 20 + data.size_content.height))

                    -- add 熊梦 添加尊贵标识 
                    msg_cell.spr_peerage:setVisible(false)
                    msg_cell.spr_group_pos:setVisible(false)
                    msg_cell.lbl_prename:setPositionX(229)
                    msg_cell.lbl_name:setPositionX(88)

                    if data.cg_group_id > 0 then
                        local peerage_frame = sfc:getSpriteFrame(string.format("crusade-group/spr-pos-%d.png", data.cg_group_id))
                        if peerage_frame ~= nil then
                            msg_cell.spr_group_pos:setVisible(true)
                            msg_cell.spr_group_pos:setSpriteFrame(peerage_frame)
                            msg_cell.lbl_prename:setPositionX(250)
                            msg_cell.lbl_name:setPositionX(121)
                        end
                    end
                else
                    data.photo = ex.Player.head_id
                    data.border_id = ex.Player.border_id

                    msg_cell = ChatRightCell:createWithCCBIFile("ccbi/ChatRightCell.ccbi")
                    msg_cell:setPosition(0, 0)

                    msg_cell:setPositionX(table_view:getViewSize().width - msg_cell:getContentSize().width - 20)
                    msg_cell.lbl_content:setPosition(msg_cell:getContentSize().width - data.size_content.width - 95, data.size_content.height + 12)

                    msg_cell.node_parent:setPositionY(data.size_content.height - 15)
                    msg_cell.spr_bg:setPositionY(data.size_content.height + 22)
                    msg_cell.spr_bg:setContentSize(cc.size(30 + data.size_content.width, 20 + data.size_content.height))

                    -- add 熊梦 添加尊贵标识 
                    msg_cell.spr_peerage:setVisible(false)
                    msg_cell.spr_group_pos:setVisible(false)
                    msg_cell.lbl_prename:setPositionX(250)
                    msg_cell.lbl_name:setPositionX(356)

                    if data.cg_group_id > 0 then
                        local peerage_frame = sfc:getSpriteFrame(string.format("crusade-group/spr-pos-%d.png", data.cg_group_id))
                        if peerage_frame ~= nil then
                            msg_cell.spr_group_pos:setVisible(true)
                            msg_cell.spr_group_pos:setSpriteFrame(peerage_frame)
                            msg_cell.lbl_prename:setPositionX(199)
                            msg_cell.lbl_name:setPositionX(320)
                        end
                    end
                end

                msg_cell.menu:setIsTouchInsideNode(table_view)
                msg_cell.btn_photo:registerScriptTapHandler(handler(self, self.onPlayerVisit))
                msg_cell.btn_photo:setPosition(msg_cell.spr_photo:getPosition())
                msg_cell.btn_photo.player_id = data.player_id
                msg_cell.btn_photo.server_id = data.server_id

                local frame = sfc:getSpriteFrame(string.format("head-icon/%d.png", data.photo))
                if frame == nil then
                    frame = sfc:getSpriteFrame("head-icon/0.png")
                end
                msg_cell.spr_photo:setSpriteFrame(frame)
                msg_cell.spr_border:setSpriteFrame(ex.Tools:getBorderIconByIdx(data.border_id))

               

                msg_cell.player_id = data.player_id
                msg_cell.lbl_name:setString(data.player_name)

                msg_cell.lbl_prename:setVisible(true)
                if data.player_id ~= ex.Player.role_id then
                    msg_cell.lbl_prename:setPositionX(msg_cell.lbl_name:getPositionX() + msg_cell.lbl_name:getContentSize().width * msg_cell.lbl_name:getScaleX())
                else
                    msg_cell.lbl_prename:setPositionX(msg_cell.lbl_name:getPositionX() - msg_cell.lbl_name:getContentSize().width * msg_cell.lbl_name:getScaleX())
                end
                msg_cell.lbl_prename:setString(ex.StringUtil.getServerName(data.server_id))

                msg_cell:setTag(99)
                cell:addChild(msg_cell)

                msg_cell:setString(data.str_chat_content)
            elseif self.current_type == ChatLayerType.CLT_COUNTRYWAR then
                local data = ex.Player.chat_data.vec_chat_countrywar[idx + 1]
                local msg_cell = nil

                if data.photo < 0 then
                    data.photo = 0
                end

                if data.player_id ~= ex.Player.role_id then
                    msg_cell = ChatLeftCell:createWithCCBIFile("ccbi/ChatLeftCell.ccbi")
                    msg_cell:setPosition(0, 0)

                    msg_cell.lbl_content:setPosition(110, data.size_content.height + 12)
                    msg_cell.node_parent:setPosition(20, data.size_content.height - 15)
                    msg_cell.spr_bg:setPosition(90, data.size_content.height + 22)
                    msg_cell.spr_bg:setContentSize(cc.size(30 + data.size_content.width, 20 + data.size_content.height))
                    -- add 熊梦 添加尊贵标识 
                    msg_cell.spr_peerage:setVisible(false)
                    msg_cell.lbl_prename:setPositionX(229)
                    msg_cell.lbl_name:setPositionX(88)

                    if data.peerage_level > 0 then
                        local peerage_frame = sfc:getSpriteFrame(string.format("setting-identification/spr-%d-xiao.png", data.peerage_level))
                        if peerage_frame ~= nil then
                            msg_cell.spr_peerage:setVisible(true)
                            msg_cell.spr_peerage:setSpriteFrame(peerage_frame)
                            msg_cell.lbl_prename:setPositionX(250)
                            msg_cell.lbl_name:setPositionX(121)
                        end
                    end
                else
                    data.photo = ex.Player.head_id
                    data.border_id = ex.Player.border_id
                    data.area_idx = ex.Player.area_idx

                    msg_cell = ChatRightCell:createWithCCBIFile("ccbi/ChatRightCell.ccbi")
                    msg_cell:setPosition(0, 0)

                    msg_cell:setPositionX(table_view:getViewSize().width - msg_cell:getContentSize().width - 20)
                    msg_cell.lbl_content:setPosition(msg_cell:getContentSize().width - data.size_content.width - 95, data.size_content.height + 12)

                    msg_cell.node_parent:setPositionY(data.size_content.height - 15)
                    msg_cell.spr_bg:setPositionY(data.size_content.height + 22)
                    msg_cell.spr_bg:setContentSize(cc.size(30 + data.size_content.width, 20 + data.size_content.height))

                    -- add 熊梦 添加尊贵标识 
                    msg_cell.spr_peerage:setVisible(false)
                    msg_cell.lbl_prename:setPositionX(243)
                    msg_cell.lbl_name:setPositionX(356)

                    if data.peerage_level > 0 then
                        local peerage_frame = sfc:getSpriteFrame(string.format("setting-identification/spr-%d-xiao.png", data.peerage_level))
                        if peerage_frame ~= nil then
                            msg_cell.spr_peerage:setVisible(true)
                            msg_cell.spr_peerage:setSpriteFrame(peerage_frame)
                            msg_cell.lbl_prename:setPositionX(199)
                            msg_cell.lbl_name:setPositionX(320)
                        end
                    end
                end

                msg_cell.menu:setIsTouchInsideNode(table_view)
                msg_cell.btn_photo:registerScriptTapHandler(handler(self, self.onPlayerVisit))
                msg_cell.btn_photo:setPosition(msg_cell.spr_photo:getPosition())
                msg_cell.btn_photo:setEnabled(false)
                msg_cell.btn_photo.player_id = data.player_id
                msg_cell.btn_photo.server_id = cc.UserDefault:getInstance():getIntegerForKey("server_id")

                local frame = sfc:getSpriteFrame(string.format("head-icon/%d.png", data.photo))
                if frame == nil then
                    frame = sfc:getSpriteFrame("head-icon/0.png")
                end
                msg_cell.spr_photo:setSpriteFrame(frame)
                msg_cell.spr_border:setSpriteFrame(ex.Tools:getBorderIconByIdx(data.border_id))

                msg_cell.player_id = data.player_id
                msg_cell.lbl_name:setString(data.player_name)

                local area_config = cfg.area.area[data.area_idx]
                msg_cell.lbl_prename:setVisible(true)
                if data.player_id ~= ex.Player.role_id then
                    msg_cell.lbl_prename:setPositionX(msg_cell.lbl_name:getPositionX() + msg_cell.lbl_name:getContentSize().width * msg_cell.lbl_name:getScaleX())
                else
                    msg_cell.lbl_prename:setPositionX(msg_cell.lbl_name:getPositionX() - msg_cell.lbl_name:getContentSize().width * msg_cell.lbl_name:getScaleX())
                end
                -- msg_cell.lbl_prename:setString("["..area_config.city.."]")
                -- 全服ID
                msg_cell.lbl_prename:setString(ex.StringUtil.getServerName(data.server_id))

                msg_cell:setTag(99)
                cell:addChild(msg_cell)

                msg_cell:setString(data.str_chat_content)
            end
        end
    )

    return cell
end

function ChatCtr:numberOfCellsInTableView(table_view)
    if table_view:getName() == "friends_table_view" then
        return table.nums(ex.Player.chat_data.vec_chat_cache) + 1
    elseif self.current_type == ChatLayerType.CLT_SYSTEM then
        return table.nums(ex.Player.chat_data.vec_chat_system)
    elseif self.current_type == ChatLayerType.CLT_WORLD then
        return table.nums(ex.Player.chat_data.vec_chat_world)
    elseif self.current_type == ChatLayerType.CLT_CLAN then
        return table.nums(ex.Player.chat_data.vec_chat_clan)
    elseif self.current_type == ChatLayerType.CLT_FRIEND then
        local vec = ex.Player.chat_data:getFriendChatHistory(self.friend_id)
        return vec ~= nil and table.nums(vec) or 0
    elseif self.current_type == ChatLayerType.CLT_SERVER then
        return table.nums(ex.Player.chat_data.vec_chat_server)
    elseif self.current_type == ChatLayerType.CLT_CITY then
        return table.nums(ex.Player.chat_data.vec_chat_city)
    elseif self.current_type == ChatLayerType.CLT_CRUSADE then
        return table.nums(ex.Player.chat_data.vec_chat_crusade)
    elseif self.current_type == ChatLayerType.CLT_COUNTRYWAR then
        return table.nums(ex.Player.chat_data.vec_chat_countrywar)
    end
    return 0
end

function ChatCtr:createEditBox(content_size, position)
    if self.layer.edit_box ~= nil then
        self.layer.edit_box:removeFromParent()
        self.layer.edit_box = nil
    end

    -- // 高度不够会导致文字不会右移
    self.layer.edit_box = ccui.EditBox:create(content_size, "other/spr-null.png", 1)
    self.layer.edit_box:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    self.layer.edit_box:setInputMode(cc.EDITBOX_INPUT_MODE_EMAILADDR)
    self.layer.edit_box:registerScriptEditBoxHandler(handler(self, self.editboxHandle))
    self.layer.edit_box:setFontSize(20)
    self.layer.edit_box:setFontColor(FONT_BROWN)
    self.layer.edit_box:setPosition(position)
    -- self.layer.edit_box:setVisible(false)
    self.layer:addChild(self.layer.edit_box, 99)

    self.layer.btn_edit_box:setContentSize(content_size)
    self.layer.btn_edit_box:setPosition(position)
    self.layer:setVisible(true)
end

function ChatCtr:editboxHandle(strEventName, sender)
    if strEventName == "began" then
        self.layer.lbl_edit_text:setVisible(false)
    elseif strEventName == "ended" then
        self.str_chat_text = sender:getText()

        -- self.layer.edit_box:setVisible(false)

        self.layer.lbl_edit_text:setVisible(true)
        self.layer.lbl_edit_text:setDimensions(self.layer.edit_box:getContentSize().width, self.layer.edit_box:getContentSize().height)
        -- self.layer.lbl_edit_text:setAlignment(cc.Label.TextHAlignment.LEFT, cc.Label.TextVAlignment.CENTER)
        self.layer.lbl_edit_text:setPosition(self.layer.edit_box:getPosition())
        -- // 部分机器设置后.文字会消失...
        -- // self.layer.lbl_edit_text->setLineBreakWithoutSpace(true);
        -- self.layer.lbl_edit_text:setString(self.str_chat_text)

        self.layer.btn_edit_box:setVisible(true)
    elseif strEventName == "changed" then
    end
end

-- 按钮回调
function ChatCtr:onChangeLayer(tag, pSender)
    local tmp_type = ChatLayerType.CLT_WORLD


    for k,v in pairs(self.layer.btn_tab) do
        if v:isChecked() then
            tmp_type = k;
        end
    end

    -- if self.layer.btn_system:isChecked() then
    --     tmp_type = ChatLayerType.CLT_SYSTEM
    -- elseif self.layer.btn_world:isChecked() then
    --     tmp_type = ChatLayerType.CLT_WORLD
    -- elseif self.layer.btn_clan:isChecked() then
    --     tmp_type = ChatLayerType.CLT_CLAN
    -- elseif self.layer.btn_friend:isChecked() then
    --     tmp_type = ChatLayerType.CLT_FRIEND
    -- elseif self.layer.btn_server:isChecked() then
    --     tmp_type = ChatLayerType.CLT_SERVER
    -- elseif self.layer.btn_city:isChecked() then
    --     tmp_type = ChatLayerType.CLT_CITY
    -- end

    self:onChangeLayerWithLayerType(tmp_type)
end

-- 按钮回调
function ChatCtr:onChangeLayerWithLayerType(layer_type)
    -- 跨服和同省频道有等级限制
    if layer_type == ChatLayerType.CLT_SERVER and cfg.opencondition.condition["main_chat_cross_share"].condition_value > ex.Player.level then
        ex.MessageView:add(string.format(ex.Tools:getLang(41212), tostring(cfg.opencondition.condition["main_chat_cross_share"].condition_value)))
        layer_type = self.current_type
    elseif layer_type == ChatLayerType.CLT_CITY and cfg.opencondition.condition["main_chat_city"].condition_value > ex.Player.level then
        ex.MessageView:add(string.format(ex.Tools:getLang(41216), tostring(cfg.opencondition.condition["main_chat_city"].condition_value)))
        layer_type = self.current_type
    end

    for k,v in pairs(self.layer.btn_tab) do
        v:setChecked(layer_type == k)
    end

    -- self.layer.btn_system:setChecked(layer_type == ChatLayerType.CLT_SYSTEM)
    -- self.layer.btn_clan:setChecked(layer_type == ChatLayerType.CLT_CLAN)
    -- self.layer.btn_world:setChecked(layer_type == ChatLayerType.CLT_WORLD)
    -- self.layer.btn_server:setChecked(layer_type == ChatLayerType.CLT_SERVER)
    -- self.layer.btn_city:setChecked(layer_type == ChatLayerType.CLT_CITY)
    -- self.layer.btn_friend:setChecked(layer_type == ChatLayerType.CLT_FRIEND)

    if
        (layer_type == ChatLayerType.CLT_SYSTEM and table.nums(ex.Player.chat_data.vec_chat_system) <= 0) or
            (layer_type == ChatLayerType.CLT_CLAN and table.nums(ex.Player.chat_data.vec_chat_clan) <= 0) or
            (layer_type == ChatLayerType.CLT_WORLD and table.nums(ex.Player.chat_data.vec_chat_world) <= 0) or
            (layer_type == ChatLayerType.CLT_SERVER and table.nums(ex.Player.chat_data.vec_chat_server) <= 0) or
            (layer_type == ChatLayerType.CLT_CITY and table.nums(ex.Player.chat_data.vec_chat_city) <= 0)
     then
        local req_chat_log = Chat_pb.GReqChatLogByType()
        req_chat_log.type = layer_type
        NetManager:sendMessage(ProtocolID.GReqChatLogByType, req_chat_log)
    end

    if self.current_type ~= layer_type then
        self.current_type = layer_type
        self:updateLayer()
        self:updateTableView(false)
    end
end

function ChatCtr:onTouchEditBox(tag, pSender)
    -- if self.layer.edit_box ~= nil then
    --     self.layer.btn_edit_box:setVisible(false)
    --     self.layer.edit_box:setVisible(true)
    -- self.layer.edit_box:becomeFirstResponder()
    -- end
end

function ChatCtr:onSend(pSender)
    self.layer.emoji_layer:setVisible(false)
    self.layer.emoji_layer:setTouchEnabled(true)

    if self.layer.edit_box == nil then
        return
    end
    if self.str_chat_text == nil then
        ex.MessageView:add(ex.Tools:getLang(41025))
        return
    end
    local str_tmp = string.gsub(self.str_chat_text, " ", "")
    local str_tmp = string.gsub(str_tmp, "\n", "")
    if string.len(str_tmp) <= 0 then
        ex.MessageView:add(ex.Tools:getLang(41025))
        self.str_chat_text = ""
        return
    end

    local chat_level = 0
    if ex.Tools:getSysCfg("chat_unlock_main_level") ~= nil then
        chat_level = tonumber(ex.Tools:getSysCfg("chat_unlock_main_level"))
    end

    if ex.Player.level < chat_level then
        ex.MessageView:add(string.format(ex.Tools:getLang(41024), chat_level))
        -- message_view->add(language_table->getLanguage(41024))
        return
    end

    -- 如果处于屏蔽全服聊天的状态，则不接收世界消息
    if self.current_type == ChatLayerType.CLT_CITY then
        local is_ignore = cc.UserDefault:getInstance():getIntegerForKey("ignore_chat_city", 1)
        if is_ignore == 1 then
            ex.MessageView:add(ex.Tools:getLang(41355))
            return
        end
    end

    local now = ex.Game:getServerMillisecond()
    local send_interval = ex.Tools:getSysCfg("chat_frequency_at_least")
    if ex.Player.chat_data.last_send_time == nil then
        ex.Player.chat_data.last_send_time = now
    elseif now - ex.Player.chat_data.last_send_time < send_interval * 1000 then
        local left_time_million_second = send_interval * 1000 - (now - ex.Player.chat_data.last_send_time)
        local left_time_second = math.floor(left_time_million_second / 1000)
        if left_time_million_second % 1000 > 0 then
            left_time_second = left_time_second + 1
        end
        ex.MessageView:add(string.format(ex.Tools:getLang(41154), left_time_second))
        return
    end
    ex.Player.chat_data.last_send_time = now

    print("str_chat_text = ", self.str_chat_text)

    local char_max = tonumber(ex.Tools:getSysCfg("chat_num"))
    if string.len(self.str_chat_text) > char_max then
        self.str_chat_text = string.sub(self.str_chat_text, 0, char_max)
    end

    if now / 1000 < ex.Player.forbid_words_end_time then
        ex.MessageView:add(ex.Tools:getLang(10004))
        return
    end

    --  RedDotManager* red_dot_manager = RedDotManager::instance();
    if self.current_type == ChatLayerType.CLT_WORLD then
        local req_chat = Chat_pb.GReqChat()
        req_chat.type = 2
        req_chat.rid = 0
        req_chat.msg = self.str_chat_text
        NetManager:sendMessage(ProtocolID.GReqChat, req_chat)
    elseif self.current_type == ChatLayerType.CLT_CLAN then
        if ex.Player.clan_data.clan_id <= 0 then
            -- // 没有军团弹出消息
            ex.MessageView:add(ex.Tools:getLang(41078))
            return
        end

        local req_chat = Chat_pb.GReqChat()
        req_chat.type = 3
        req_chat.msg = self.str_chat_text
        NetManager:sendMessage(ProtocolID.GReqChat, req_chat)
    elseif self.current_type == ChatLayerType.CLT_FRIEND then
        if tonumber(self.friend_id) <= 0 then
            ex.MessageView:add(ex.Tools:getLang(1509))
            return
        end

        local req_chat = Chat_pb.GReqChat()
        req_chat.type = 5
        req_chat.rid = self.friend_id
        req_chat.msg = self.str_chat_text
        NetManager:sendMessage(ProtocolID.GReqChat, req_chat)
    elseif self.current_type == ChatLayerType.CLT_CITY then
        local req_chat = Chat_pb.GReqChat()
        req_chat.type = 7
        req_chat.rid = 0
        req_chat.msg = self.str_chat_text
        NetManager:sendMessage(ProtocolID.GReqChat, req_chat)
    elseif self.current_type == ChatLayerType.CLT_SERVER then
        local req_chat = Chat_pb.GReqChat()
        req_chat.type = 6
        req_chat.rid = 0
        req_chat.msg = self.str_chat_text
        NetManager:sendMessage(ProtocolID.GReqChat, req_chat)
    elseif self.current_type == ChatLayerType.CLT_CRUSADE then
        local req_chat = Chat_pb.GReqChat()
        req_chat.type = 8
        req_chat.rid = 0
        req_chat.msg = self.str_chat_text
        NetManager:sendMessage(ProtocolID.GReqChat, req_chat)
    elseif self.current_type == ChatLayerType.CLT_COUNTRYWAR then
        local req_chat = Chat_pb.GReqChat()
        req_chat.type = ChatLayerType.CLT_COUNTRYWAR
        req_chat.rid = 0
        req_chat.msg = self.str_chat_text
        NetManager:sendMessage(ProtocolID.GReqChat, req_chat)
    end

    print("send =", self.str_chat_text)
    self.str_chat_text = ""
    self.layer.lbl_edit_text:setString("")
    self.layer.edit_box:setText("")
end

function ChatCtr:onIgnoreChatWorld(tag, pSender)
    local is_ignore = cc.UserDefault:getInstance():getIntegerForKey("ignore_chat_city", 1)

    is_ignore = (is_ignore == 1 and 0 or 1)
    cc.UserDefault:getInstance():setIntegerForKey("ignore_chat_city", is_ignore)

    local str_btn_ignore_text = "lang-1/btn-chat-close.png"
    if is_ignore == 1 then
        str_btn_ignore_text = "lang-1/btn-chat-open.png"
    end

    ex.MessageView:add(ex.Tools:getLang(41357 + is_ignore))

    pSender:setNormalImage(cc.Sprite:createWithSpriteFrameName(str_btn_ignore_text))
    pSender:setSelectedImage(cc.Sprite:createWithSpriteFrameName(str_btn_ignore_text))
    self.layer.layer_city.lbl_ignore_tip:setVisible(is_ignore == 1)
end

function ChatCtr:onFriendVisit(pSender)
    ex.Tools:showPlayerInfo(self.friend_id, cc.UserDefault:getInstance():getIntegerForKey("server_id"))
end

function ChatCtr:friendChat(player_id)
    if self.layer == nil then
        return
    end

    if self.layer == nil then
        self:openWindow()
    end
    self:onChangeLayerWithLayerType(ChatLayerType.CLT_FRIEND)

    local req_add = Chat_pb.GReqAddPrivateChat()
    req_add.role_id = player_id
    NetManager:sendMessage(ProtocolID.GReqAddPrivateChat, req_add)

    local req = Chat_pb.GReqPrivateChatLog()
    req.friend_id = player_id
    NetManager:sendMessage(ProtocolID.GReqPrivateChatLog, req)
end

-- 关闭一个好友聊天
function ChatCtr:closeFriendChat()
    local req_close = Chat_pb.GResRemovePrivateChat()
    req_close.role_id = self.friend_id
    NetManager:sendMessage(ProtocolID.GReqRemovePrivateChat, req_close)
end

function ChatCtr:onPlayerVisit(tag, pSender)
    ex.Tools:showPlayerInfo(pSender.player_id, pSender.server_id)
end

function ChatCtr:onAddFriend(tag, pSender)
    local friend_data = ex.Player.friend_data:getFriendById(self.player_id)
    if friend_data ~= nil then
        return
    end

    local req = Friend_pb.GReqFriendsAdd()
    req.rid = self.player_id
    NetManager:sendMessage(ProtocolID.GReqFriendsAdd, req)

    ex.MessageView:add(ex.Tools:getLang(47295), 0)
end

function ChatCtr:onEmoji()
    local isVisible = self.layer.emoji_layer:isVisible()
    self.layer.emoji_layer:setVisible(not isVisible)
    self.layer.emoji_layer:setTouchEnabled(true)
    self:initEmojiChooseView(1)
end
-- 选择表情包
function ChatCtr:onEmojiChooseType(tag, pSender)
    self:initEmojiChooseView(tag)
end

function ChatCtr:onEmojiClicked(tag, pSender)
    if self.layer.edit_box then
        local text = self.layer.edit_box:getText() or ""
        local pid = math.floor(tag / 1000)
        local index = tag % 1000
        local config = cfg.emojiconfig.getEmojiConfig(pid, index)
        if config and config.text then
            self.layer.edit_box:setText(text .. config.text)
            self.str_chat_text = text .. config.text
        end
    end

    self.layer.emoji_layer:setVisible(false)
    self.layer.emoji_layer:setTouchEnabled(false)
end

function ChatCtr:openRichTextUrl(url)
    if string.len(url) <= 0 then
        return
    end

    -- 如果当前有其他打开界面，则不做跳转
    for i, v in ipairs(ex.node_list) do
        if v.class.__cname ~= "ChatCtr" and v.layer ~= nil then
            print("has layer opened:", v.class.__cname)
            return
        end
    end

    if self.layer.battle_layer ~= nil then
        return
    end

    local vec_str = string.split(url, SPLIT_CHAR)
    dump(vec_str)
    if vec_str[1] == "hero_share" then
        local req = HeroShare_pb.GReqShareHeroInfo()
        req.share_id = vec_str[3]
        req.server_id = tonumber(vec_str[2])
        NetManager:sendMessage(ProtocolID.GReqShareHeroInfo, req)
    elseif vec_str[1] == "battle_share" then
        local req = Video_pb.GReqScanShare()
        req.share_id = vec_str[3]
        -- req.server_id = tonumber(vec_str[2])
        NetManager:sendMessage(ProtocolID.GReqScanShare, req)
    elseif vec_str[1] == "superstage_share" then
        require("src.layer.superstage.SuperStageAccountCtr"):instance():openWindow(tonumber(vec_str[3]), tonumber(vec_str[2]))
    elseif vec_str[1] == "crusade_location_share" then
        ex.EventManager:fire(EVENT.CRUSADE_GROUP.SET_MAP_FOCUS, tonumber(vec_str[2]))
        self:closeWindow(0, nil)
    else
        ex.JumpManager:jumpByAtom(vec_str[1])
        self:closeWindow(0, nil)
    end
end

return ChatCtr
