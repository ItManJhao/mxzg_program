local HeroListDragonRoomLayer = class("HeroListDragonRoomLayer", require("src.comp.EventLayer"))

local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function HeroListDragonRoomLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    
    self.btn_illustration:setLabelOffset(cc.p(0, -30))

    -- 添加富文本提示
    self.lbl_tip = require("src.comp.RichTextEx"):create()
	:setFontSize(20)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#7A472D")
    :setAnchorPoint(0.5, 0.5)
	:setAnchorTextShadow(true)
	:setWrapMode(1)
    :setPosition(0, 15)
    self.node_privilege:addChild(self.lbl_tip, 10001)

    -- self.lbl_tip:setCallback(handler(self, self.openRichTextUrl))

    -- 龙界等级
    self.lbl_room_level = require("src.comp.RichTextEx"):create()
	:setFontSize(20)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#7A472D")
    :setAnchorPoint(0, 0.5)
	:setAnchorTextShadow(true)
	:setWrapMode(1)
    :setPosition(-220, 0)
    self.node_identify_info:addChild(self.lbl_room_level, 10001)

    -- 龙界鉴定速度
    self.lbl_room_speed = require("src.comp.RichTextEx"):create()
	:setFontSize(20)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#7A472D")
    :setAnchorPoint(0.5, 0.5)
	:setAnchorTextShadow(true)
	:setWrapMode(1)
    :setPosition(120, 0)
    self.node_identify_info:addChild(self.lbl_room_speed, 10001)

    -- 龙界鉴定剩余时间
    self.lbl_progress_tip = require("src.comp.RichTextEx"):create()
	:setFontSize(20)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#7A472D")
    :setAnchorPoint(0.5, 0.5)
	:setAnchorTextShadow(true)
	:setWrapMode(1)
    :setPosition(0, 35)
    self.node_progress:addChild(self.lbl_progress_tip, 10001)

    self.lbl_progress_tip:setXmlTextLua(ex.Tools:getLang(74506))
    self.lbl_progress_tip:formatText()

    -- 所需剩余鉴定值
    self.lbl_left_point = require("src.comp.RichTextEx"):create()
	:setFontSize(20)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#7A472D")
    :setAnchorPoint(0, 0.5)
	:setAnchorTextShadow(true)
	:setWrapMode(1)
    :setPosition(10, 0)
    self.node_left_point:addChild(self.lbl_left_point, 10001)

    -- 鉴定加速效果
    self.lbl_speed_effect = require("src.comp.RichTextEx"):create()
	:setFontSize(20)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#7A472D")
    :setAnchorPoint(0, 0.5)
	:setAnchorTextShadow(true)
	:setWrapMode(1)
    :setPosition(-80, -2)
    self.node_item_info:addChild(self.lbl_speed_effect, 10001)

    -- 初始化数据
    self:initDone()

    self:addTimer("timer", 500, handler(self, self.update), true)
end

function HeroListDragonRoomLayer:update(dt)
    if #ex.Player.dragon_data.vec_dragon_rooms <= 0 then
        return
    end

    if self.select_room_type ~= 1 and self.lbl_tip ~= nil then
        local now = ex.Game:getServerTime()
        if ex.Player.dragon_data.privilege_end_time > now then
            local left_time = ex.Player.dragon_data.privilege_end_time - now
            self.lbl_tip:setXmlTextLua(string.format(ex.Tools:getLang(74512), ex.StringUtil.convertToTimeFormat(left_time, 4)))
        end
    end

    if self.spr_progress_bg == nil then
        return
    end
    
    if self.spr_progress_bg.max_point ~= nil and self.spr_progress_bg.max_point > 0 then
        local time_identify, need_point = ex.Player.dragon_data:getIdentifyLeftTime(self.select_room_type)

        local room_data = ex.Player.dragon_data.vec_dragon_rooms[self.select_room_type]
        if room_data.level > 0 and time_identify <= 0 then
            self:updateLayer()
            return
        end

        self.lbl_progress_tip:setXmlTextLua(string.format(ex.Tools:getLang(74507), string.format("%02d:%02d:%02d", math.floor(time_identify / 3600), math.floor(time_identify % 3600 / 60), math.floor(time_identify % 60))))
        self.lbl_progress_tip:formatText()

        local add_num = self.spr_progress_bg.need_point - need_point
        if add_num > 0 then
            local item_room = nil
            local vec_children = self.menu_room:getChildren()
            for i,v in ipairs(vec_children) do
                if v:getTag() == self.select_room_type then
                    item_room = v
                    break
                end
            end
            if item_room ~= nil then
                local is_big = add_num > 10000

                local item_size = item_room:getContentSize()
                -- 执行飘字动画
                local lbl_num = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, is_big and 72 or 56)
                lbl_num:setColor(cc.c3b(219,255,18))
                lbl_num:enableOutline(cc.c3b(11,75,0), 2)
                lbl_num:setScale(0.5)
                lbl_num:setOpacity(0)
                lbl_num:setPosition(math.random(item_size.width * 0.2, item_size.width * 0.8), math.random(item_size.height * 0.1, item_size.height * 0.25))
                item_room:addChild(lbl_num, is_big and 1000 or 100)

                lbl_num:setString("+"..add_num)

                lbl_num:runAction(cc.MoveBy:create(1.0, cc.p(0, 100)))
                lbl_num:runAction(cc.Sequence:create(cc.FadeIn:create(0.2),
                                                     cc.DelayTime:create(0.4),
                                                     cc.FadeOut:create(0.3),
                                                     cc.RemoveSelf:create(),
                                                     nil))
            end
        end

        local max_point = 0
		for _,v in pairs(cfg.dragonremains.dragonremains) do
			if v.type == 1 and v.level == room_data.level then
                max_point = v.point
                break
			end
        end
        
        self.lbl_point:setString(max_point - need_point.."/"..max_point)

        self.lbl_left_point:setXmlTextLua(string.format(ex.Tools:getLang(74513), need_point))
        self.lbl_left_point:formatText()

        -- 存放数据，方便定时器刷新
        self.spr_progress_bg.max_point = max_point
        self.spr_progress_bg.need_point = need_point
    end
end

function HeroListDragonRoomLayer:initDone()
    self.btn_info:registerScriptTapHandler(handler(self, self.onInfo))
    self.btn_illustration:registerScriptTapHandler(handler(self, self.onIllustration))
    self.btn_privilege:registerScriptTapHandler(handler(self, self.openRichTextUrl))

    self.btn_uplevel:registerScriptTapHandler(handler(self, self.onDragonRoomLevelUp))
    self.btn_speed_enter:registerScriptTapHandler(handler(self, self.onDragonRoomSpeedEnter))
    self.btn_speed_quit:registerScriptTapHandler(handler(self, self.onDragonRoomSpeedQuit))
    self.btn_speedup:registerScriptTapHandler(handler(self, self.onIdentifySpeedup))
    self.btn_auto_buy:registerScriptTapHandler(handler(self, self.onAutoBuy))

    self:addEvent(EVENT.BACKPACK_RES_CHANGE.CHANGE_ITEM, handler(self, self.updateLayerWithChangeBackpack))
    self:addEvent(EVENT.DRAGON_EVENT.UPDATE_INFO, handler(self, self.updateLayer))
    self:addEvent(EVENT.DRAGON_EVENT.IDENTIFY_SPEEDUP, handler(self, self.updateLayerWithSpeedUp))
    self:addEvent(EVENT.DRAGON_EVENT.IDENTIFY_START, handler(self, self.updateLayerWithIdentity))
    self:addEvent(EVENT.DRAGON_EVENT.IDENTIFY_FINISH, handler(self, self.updateLayerWithIdentity))

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/dragon.plist")

    self.node_identify:setVisible(true)
    self.node_speedup:setVisible(false)

    self.select_room_type = 1

    self.select_identify_item = 0
    for k,v in pairs(cfg.dragonremains.dragonremains) do
        if v.type == 2 then
            local has_num = ex.Player:getItemNum(v.cost[1].item_type)
            if has_num > 0 and v.level > self.select_identify_item then
                self.select_identify_item = v.level
            end
        end
    end
    if self.select_identify_item <= 0 then
        for k,v in pairs(cfg.dragonremains.dragonremains) do
            if v.type == 2 and v.level > self.select_identify_item then
                self.select_identify_item = v.level
            end
        end
    end

    local is_auto_buy = cc.UserDefault:getInstance():getIntegerForKey("is_dragon_identity_auto_buy") or 0
	self.btn_auto_buy:setChecked(is_auto_buy ~= nil and is_auto_buy == 1)

    -- 显示龙界
    self:showRoomItem()

    -- 添加加速物品显示
    self:showIdentifyItem()

    self:updateLayer()
end

-- 更新龙界房间
function HeroListDragonRoomLayer:showRoomItem()
    self.menu_room:removeAllChildren()

    if #ex.Player.dragon_data.vec_dragon_rooms <= 0 then
        return
    end

    local str_item = "dragon/spr-dragon-room-bg.png"
    for i=1,2 do
        local item = cpp.UIMenuItemImage:createWithSpriteFrameName(str_item, str_item, str_item)
        item:setEnableAction(false)
        item:registerScriptTapHandler(handler(self, self.onDragonRoom))
        item:setTag(i)
        item:setScale(((self.select_room_type == i) and 1 or 0.7))
        item:setAnchorPoint(0.5, 0.4)
        self.menu_room:addChild(item)

        local pos_x = (i - self.select_room_type) * 125
        if self.select_room_type ~= i then
            pos_x = pos_x + 20 * ((self.select_room_type > i) and -1 or 1)
        end
        item:setPosition(pos_x, 0)

        item.spr_name = cc.Sprite:createWithSpriteFrameName("dragon-lang/lbl-room-type-"..i.."-1.png")
        item.spr_name:setScale(1.2)
        item.spr_name:setPosition(item:getContentSize().width / 2, item:getContentSize().height + 15)
        item:addChild(item.spr_name, 10)

        local room_data = ex.Player.dragon_data.vec_dragon_rooms[i]

        ex.Tools:addRedPoint(item, self:isShowRoomReddot(room_data.type), cc.p(0.8, 0.8))

        if room_data.level > 0 then
            local config_remains = ex.Player.dragon_data:getRemainsConfigByLevel(room_data.level)
            item.spr_icon = cc.Sprite:createWithSpriteFrameName(cfg.item.item[config_remains.cost[1].item_type].icon..".png")
            item.spr_icon:setPosition(item:getContentSize().width / 2, item:getContentSize().height / 2)
            item:addChild(item.spr_icon, 10)

            item.spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_dragon_identify")
            item.spr_effect:setPosition(item:getContentSize().width / 2 + 5, 0)
            item.spr_effect:setAnchorPoint(cc.p(0.5, 0.15))
            item.spr_effect:setVisible(false)
            item:addChild(item.spr_effect, 10, 10)
    
            item.spr_effect:setVisible(true)
        else
            if room_data.type == 2 and ex.Player.dragon_data.privilege_end_time < ex.Game:getServerTime() then
                item.spr_lock = cc.Sprite:createWithSpriteFrameName("dragon/spr-lock.png")
                item.spr_lock:setPosition(item:getContentSize().width / 2, item:getContentSize().height / 2)
                item:addChild(item.spr_lock, 10)
            else
                item.spr_add = cc.Sprite:createWithSpriteFrameName("other/spr-add-1.png")
                item.spr_add:setPosition(item:getContentSize().width / 2, item:getContentSize().height / 2)
                item:addChild(item.spr_add, 10)
            end
        end
    end
end

-- 显示加速物品列表
function HeroListDragonRoomLayer:showIdentifyItem()
    self.menu_item:removeAllChildren()

    local vec_item = {}
    for k,v in pairs(cfg.dragonremains.dragonremains) do
        if v.type == 2 then
            table.insert(vec_item, v)
        end
    end

    table.sort(vec_item, function(a, b)
        return a.level < b.level
    end)

    local item_num = #vec_item
    for i,v in ipairs(vec_item) do
        local item = UIMenuItemBackpack:createWithData(v.cost[1].item_type, 1)
        item:setEnableAction(false)
        item:registerScriptTapHandler(handler(self, self.onItemSelect))
        item:setTag(v.level)
        item:setPosition((i - item_num / 2 - 0.5) * (item:getContentSize().width + 50), 0)
        self.menu_item:addChild(item)

        item.data = v

        item.lbl_num:setString(ex.Player:getItemNum(v.cost[1].item_type).."/1")

        item.spr_select = cc.Sprite:createWithSpriteFrameName("backpack/spr-select-3.png")
        item.spr_select:setPosition(item:getContentSize().width / 2, item:getContentSize().height / 2)
        item:addChild(item.spr_select, 100)

        item.spr_select:setVisible(false)

        local spr_price_bg = cc.Sprite:createWithSpriteFrameName("win-bg/win-bg-17.png")
        spr_price_bg:setScale(0.5, 0.3)
        spr_price_bg:setPosition(item:getContentSize().width / 2, -20)
        item:addChild(spr_price_bg)

        local spr_price_icon = cc.Sprite:createWithSpriteFrameName(cfg.item.item[v.buy[1].item_type].icon..".png")
        spr_price_icon:setScale(0.3)
        spr_price_icon:setAnchorPoint(1, 0.5)
        spr_price_icon:setPosition(spr_price_bg:getPositionX() - 20, spr_price_bg:getPositionY())
        item:addChild(spr_price_icon, 10)

        local lbl_price = cc.Label:createWithTTF(v.buy[1].item_num, FONT_DEFAULT_NAME_BOLD, 40)
        lbl_price:setColor(FONT_LIGHT_YELLOW)
        lbl_price:setScale(0.5)
        lbl_price:setAnchorPoint(0, 0.5)
        lbl_price:setPosition(spr_price_bg:getPositionX() - 10, spr_price_bg:getPositionY())
        item:addChild(lbl_price, 10)
    end

    self:onItemSelect(self.select_identify_item)
end

function HeroListDragonRoomLayer:updateLayer()
    if self:isVisible() == false then
        return
    end

    ex.Tools:setSpriteFrame(self.spr_room_bg, "dragon/spr-bg-"..self.select_room_type..".png")
    
    local now = ex.Game:getServerTime()
    -- 特权提示，只有特权房间才显示
    if self.select_room_type == 1 then
        self.node_privilege:setVisible(false)
    else
        self.node_privilege:setVisible(true)
        if ex.Player.dragon_data.privilege_end_time > now then
            local left_time = ex.Player.dragon_data.privilege_end_time - now
            self.lbl_tip:setXmlTextLua(string.format(ex.Tools:getLang(74512), ex.StringUtil.convertToTimeFormat(left_time, 4)))
            self.btn_privilege:setVisible(false)
        else
            self.lbl_tip:setXmlTextLua(ex.Tools:getLang(74511))
            self.btn_privilege:setVisible(true)
        end
        self.lbl_tip:formatText()
        self.btn_privilege:setPosition(self.lbl_tip:getPositionX() + self.lbl_tip:getContentSize().width * self.lbl_tip:getScaleX() / 2, self.lbl_tip:getPositionY())
        self.btn_privilege:setContentSize(80, self.lbl_tip:getContentSize().height * self.lbl_tip:getScaleY())
    end

    -- 鉴定等级
    self.lbl_room_level:setXmlTextLua(string.format(ex.Tools:getLang(74504), ex.Player.dragon_data.dragon_room_level))
    self.lbl_room_level:formatText()

    -- 鉴定速度
    local config_identify = cfg.dragonidentify.dragonidentify[ex.Player.dragon_data.dragon_room_level]
    self.lbl_room_speed:setXmlTextLua(string.format(ex.Tools:getLang(74505), ((config_identify ~= nil) and config_identify.speed or 0)))
    self.lbl_room_speed:formatText()

	local config_after = cfg.dragonidentify.dragonidentify[ex.Player.dragon_data.dragon_room_level + 1]
	if config_after == nil then
        self.btn_uplevel:setLabelText(ex.Tools:getLang(74509))
        self.btn_uplevel:setEnabled(false)
    else
        self.btn_uplevel:setLabelText(ex.Tools:getLang(74508))
        self.btn_uplevel:setEnabled(true)
    end
    
    local room_data = ex.Player.dragon_data.vec_dragon_rooms[self.select_room_type]
    if room_data ~= nil and room_data.level > 0 then
        ex.Tools:setSpriteFrame(self.spr_room_name, "dragon-lang/spr-name-"..room_data.level..".png")
    elseif room_data ~= nil then
        ex.Tools:setSpriteFrame(self.spr_room_name, "dragon-lang/lbl-room-type-"..room_data.type.."-2.png")
    end

    -- 鉴定进度
    local time_identify, need_point = ex.Player.dragon_data:getIdentifyLeftTime(self.select_room_type)
    self.lbl_left_point:setXmlTextLua(string.format(ex.Tools:getLang(74513), need_point))
    self.lbl_left_point:formatText()

    if room_data ~= nil and room_data.level > 0 and time_identify <= 0 then
        NetManager:sendMessage(ProtocolID.GReqDragonIdentityFinish)
    end

    if room_data ~= nil and time_identify > 0 then
        self.lbl_progress_tip:setXmlTextLua(string.format(ex.Tools:getLang(74507), string.format("%02d: %02d: %02d", math.floor(time_identify / 3600), math.floor(time_identify % 3600 / 60), math.floor(time_identify % 60))))
        self.lbl_progress_tip:formatText()

        local max_point = 0
		for _,v in pairs(cfg.dragonremains.dragonremains) do
			if v.type == 1 and v.level == room_data.level then
                max_point = v.point
                break
			end
        end
        
        if self.spr_progress_bg.spr_effect == nil then
            self.spr_progress_bg.spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_dragon_identify_progress")
            self.spr_progress_bg.spr_effect:setPosition(self.spr_progress_bg:getContentSize().width / 2, self.spr_progress_bg:getContentSize().height / 2)
            self.spr_progress_bg:addChild(self.spr_progress_bg.spr_effect)
        end
        self.lbl_point:setString(max_point - need_point.."/"..max_point)

        -- 存放数据，方便定时器刷新
        self.spr_progress_bg.max_point = max_point
        self.spr_progress_bg.need_point = need_point
    else
        self.lbl_progress_tip:setXmlTextLua(ex.Tools:getLang(74506))
        self.lbl_progress_tip:formatText()

        if self.spr_progress_bg.spr_effect ~= nil then
            self.spr_progress_bg.spr_effect:removeFromParent()
            self.spr_progress_bg.spr_effect = nil
        end
        self.lbl_point:setString("0/0")

        -- 存放数据，方便定时器刷新
        self.spr_progress_bg.max_point = 0
        self.spr_progress_bg.need_point = 0
    end

    if room_data ~= nil and room_data.level > 0 then
        self.btn_speed_enter:setVisible(true)
        self.btn_uplevel:setPositionX(-self.btn_speed_enter:getPositionX())
    else
        if self.node_speedup:isVisible() then
            self.node_speedup:setVisible(false)
            self.node_identify:setVisible(true)
        end

        self.btn_speed_enter:setVisible(false)
        self.btn_uplevel:setPositionX(0)
    end
end

-- 是否显示龙界红点
function HeroListDragonRoomLayer:isShowRoomReddot(room_type)
    if room_type ~= 1 then
        if ex.Player.dragon_data.privilege_end_time < ex.Game:getServerTime() then
            return false
        end
    end

    local room_data = ex.Player.dragon_data.vec_dragon_rooms[room_type]
    if room_data == nil or room_data.level <= 0 then
        for k,v in pairs(cfg.dragonremains.dragonremains) do
            if v.type == 1 and ex.Player:getItemNum(v.cost[1].item_type) > 0 then
                return true
            end
        end
    end

    return false
end

-- 加速器加速，服务器响应回调刷新，根据加速多少时间来飘字
function HeroListDragonRoomLayer:updateLayerWithSpeedUp(event, speed_num)
    self:updateLayer()

    ex.AudioManager:playEffect("music/hero-up-star.mp3")

    local time_identify, need_point = ex.Player.dragon_data:getIdentifyLeftTime(self.select_room_type)

    if self.spr_progress_bg ~= nil then
        self.spr_progress_bg.need_point = need_point + speed_num
    end
end

function HeroListDragonRoomLayer:updateLayerWithIdentity(event)
    self:showRoomItem()
    self:updateLayer()
end

function HeroListDragonRoomLayer:updateLayerWithChangeBackpack(event)
    self:showRoomItem()
    self:updateLayer()
end

-- 根据富文本响应，打开圣龙特权界面
function HeroListDragonRoomLayer:openRichTextUrl(url)
    require("src.layer.dragon.DragonPrivilegeCtr"):instance():openWindow()
end

-- 龙界选中
function HeroListDragonRoomLayer:onDragonRoom(tag, pSender)
    local room_data = ex.Player.dragon_data.vec_dragon_rooms[tag]
    if self.select_room_type == tag then 
        if room_data.type == 2 and ex.Player.dragon_data.privilege_end_time < ex.Game:getServerTime() then
            -- ex.MessageView:add("该龙界未开启")
            return
        end

        if room_data.level <= 0 then
            -- 如果龙界为空，则打开遗物选择界面
            require("src.layer.dragon.RemainsSelectCtr"):instance():openWindow(self.select_room_type)
        elseif not self.node_speedup:isVisible() and room_data.start_time > 0 then
            -- 如果当前处于该房间，并且该房间正在鉴定遗物，并且不处于鉴定加速界面，则进入鉴定加速界面
            self:onDragonRoomSpeedEnter()
            return
        else
            -- 否则不响应
            return
        end
    end

    local now = ex.Game:getServerTime()
    -- 如果龙界为特权龙界，并且未解锁，则弹出提示，不做动画
    -- if room_data.type == 2 and ex.Player.dragon_data.privilege_end_time < now then
    --     ex.MessageView:add("该龙界未解锁")
    --     return
    -- end

    self.select_room_type = tag

    self:updateLayer()

    -- 龙界切换动画
    local vec_children = self.menu_room:getChildren()
    for i,v in ipairs(vec_children) do
        if v:getTag() > 0 then
            v:stopAllActions()

            local pos_x = (v:getTag() - self.select_room_type) * 125
            if self.select_room_type ~= v:getTag() then
                pos_x = pos_x + 20 * ((self.select_room_type > v:getTag()) and -1 or 1)
            end
            local action_move = cc.MoveTo:create(0.3, cc.p(pos_x, 0))
            v:runAction(action_move)

            local action_scale = cc.ScaleTo:create(0.3, ((self.select_room_type == v:getTag()) and 1 or 0.7))
            v:runAction(action_scale)
        end
    end
end

-- 鉴定物品选中
function HeroListDragonRoomLayer:onItemSelect(tag, pSender)
    self.select_identify_item = tag

    local vec_children = self.menu_item:getChildren()
    for i,v in ipairs(vec_children) do
        if v.spr_select ~= nil then
            v.spr_select:setVisible(self.select_identify_item == v:getTag())
        end
    end

    for k,v in pairs(cfg.dragonremains.dragonremains) do
        if v.type == 2 and v.level == tag then
            self.lbl_identify_item_name:setString(ex.Tools:getLang(cfg.item.item[v.cost[1].item_type].name))
            
            self.lbl_speed_effect:setXmlTextLua(string.format(ex.Tools:getLang(74610), v.point))
            self.lbl_speed_effect:formatText()
        end
    end
end

function HeroListDragonRoomLayer:onInfo(tag, pSender)
	require("src.layer.InfoCtr"):instance():openWindow(ex.Tools:getLang(42080),
                                                       ex.Tools:getLang(42081))
end

function HeroListDragonRoomLayer:onIllustration(tag, pSender)
    require("src.layer.dragon.HallowsIllustrationCtr"):instance():openWindow()
end

-- 鉴定升级，如果未满级则打开升级界面
function HeroListDragonRoomLayer:onDragonRoomLevelUp(tag, pSender)
    require("src.layer.dragon.DragonRoomLevelUpCtr"):instance():openWindow()
end

-- 进入加速界面
function HeroListDragonRoomLayer:onDragonRoomSpeedEnter(tag, pSender)
    self.node_identify:setVisible(false)
    self.node_speedup:setVisible(true)

    self:showIdentifyItem()
    self:updateLayer()
end

-- 退出加速界面
function HeroListDragonRoomLayer:onDragonRoomSpeedQuit(tag, pSender)
    self.node_identify:setVisible(true)
    self.node_speedup:setVisible(false)

    self:updateLayer()
end

-- 自动购买选中
function HeroListDragonRoomLayer:onAutoBuy(tag, pSender)
    cc.UserDefault:getInstance():setIntegerForKey("is_dragon_identity_auto_buy", self.btn_auto_buy:isChecked() and 1 or 0)
end

-- 鉴定加速
function HeroListDragonRoomLayer:onIdentifySpeedup(tag, pSender)
    local data = nil
    for k,v in pairs(cfg.dragonremains.dragonremains) do
        if v.type == 2 and v.level == self.select_identify_item then
            data = v
            break
        end
    end
    if data == nil then
        return
    end

    local room_data = ex.Player.dragon_data.vec_dragon_rooms[self.select_room_type]
    if room_data == nil then
        return
    end

    if room_data.level <= 0 then
        return
    end

    local time_identify, need_point = ex.Player.dragon_data:getIdentifyLeftTime(self.select_room_type)
    if time_identify <= 0 or need_point <= 0 then
        ex.MessageView:add(ex.Tools:getLang(74593))
        return
    end

    local is_auto_buy = cc.UserDefault:getInstance():getIntegerForKey("is_dragon_identity_auto_buy") or 0
    -- 自动购买，判断所需购买鉴定物品的资源是否数量足够
    if is_auto_buy == 1 and ex.Player:getItemNum(data.buy[1].item_type) < data.buy[1].item_num then
        ex.Tools:showEnoughTip(data.buy[1].item_type, true)
        return
    end

    -- 非自动购买，判断所需鉴定物品是否数量足够
    if is_auto_buy == 0 and ex.Player:getItemNum(data.cost[1].item_type) <= 0 then
        require("src.layer.ConfirmCtr"):instance():openWindow(ex.Tools:getLang(74594), 
                                                              string.format(ex.Tools:getLang(74595), data.buy[1].item_num), 
                                                              function()
                                                                  if ex.Player:getItemNum(data.buy[1].item_type) < data.buy[1].item_num then
                                                                      ex.Tools:showEnoughTip(data.buy[1].item_type, true)
                                                                      return
                                                                  end
                                                                  local req = Dragon_pb.GReqDragonSpeedUpIdentity()
                                                                  req.speed = data.level
                                                                  req.auto = 1
                                                                  req.type = self.select_room_type
                                                                  NetManager:sendMessage(ProtocolID.GReqDragonSpeedUpIdentity, req)
                                                              end)
        return
    end

    local callback = function()
        local req = Dragon_pb.GReqDragonSpeedUpIdentity()
        req.speed = data.level
        req.auto = is_auto_buy
        req.type = self.select_room_type
        NetManager:sendMessage(ProtocolID.GReqDragonSpeedUpIdentity, req)
    end

    -- 查看是否超出所需鉴定值，超出则需要二次确认
    if need_point < data.point then
        require("src.layer.ConfirmCtr"):instance():openWindow(ex.Tools:getLang(74594), ex.Tools:getLang(74596), callback)
        return
    else
        callback()
    end
end

return HeroListDragonRoomLayer
