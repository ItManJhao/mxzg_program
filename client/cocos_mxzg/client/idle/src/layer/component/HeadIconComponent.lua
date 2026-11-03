--[[
    func: 头像组件
    author:徐东浩
    time:2020-05-12 11:19:44
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local HeadIconComponent = class("HeadIconComponent")

local LevelStyle = {
    bottom = 1,     -- 正下方
    left_top = 2,   -- 左上方
}

local LevelUIArgument = {
    [1] = {
        plist = "ccbi-res/main-scene.plist",
        file = "main-scene/spr-level-bg.png",
        rect = cc.rect(13,0,32,24),
        width = 58,
        pos = cc.p(-1, -48),
    },
    [2] = {
        plist = "ccbi-res/common-ui-2.plist",
        file = "other/spr-circular-1.png",
        rect = cc.rect(14,0,4,32),
        width = 32,
        pos = cc.p(-30, 11),
    }
}

function HeadIconComponent:createDefault()
    local pRet = HeadIconComponent:createWithData(nil, nil, nil, nil, nil, nil, LevelStyle.bottom)
    
    return pRet
end

function HeadIconComponent:createWithData(rid, server_id, head_id, border_id, level, click_callback, level_style)
    local pRet = HeadIconComponent:create()

    if pRet then
        pRet.data = {}
        pRet.data.rid = rid
        pRet.data.server_id = server_id
        pRet.data.head_id = head_id
        pRet.data.border_id = border_id
        pRet.data.level = level

        pRet.level_style = level_style or LevelStyle.bottom
        pRet.click_callback = click_callback
        
        pRet:_init()

        return pRet
    end

    return nil
end

function HeadIconComponent:resetData(rid, server_id, head_id, border_id, level, click_callback)
    self.data = {}
    self.data.rid = rid or self.data.rid
    self.data.server_id = server_id or self.data.server_id
    self.data.head_id = head_id or self.data.head_id
    self.data.border_id = border_id or self.data.border_id
    self.data.level = level or self.data.level

    self.click_callback = click_callback or self.click_callback

    if self.data.head_id then
        self:setHeadIcon(self.data.head_id)
    end

    if self.data.border_id then
        self:setBorderImage(self.data.border_id)
    end

    if self.data.level then
        self:setLevel(self.data.level)
    end
end

function HeadIconComponent:_init()
    self.root = cc.Node:create()

    if self.data.head_id then
        self:setHeadIcon(self.data.head_id)
    end

    if self.data.border_id then
        self:setBorderImage(self.data.border_id)
    end

    if self.data.level then
        self:setLevel(self.data.level)
    end
end

function HeadIconComponent:getNode()
    return self.root
end

function HeadIconComponent:setHeadIcon(head_id)
    self.data.head_id = head_id

    if not self.menu then
        self.menu = cpp.UIMenu:create()
        self.menu:setPosition(0, 0)
        self.root:addChild(self.menu)
    end
    
    if not self.btn_head then
        self.btn_head = cpp.UIMenuItemImage:createWithSpriteFrameName("head-icon/0.png", nil, nil)
        self.btn_head:setIgnoreAnchorPointForPosition(false)
        self.btn_head:setAnchorPoint(ex.a.center)
        self.btn_head:setPosition(ex.p.zero)
        self.btn_head:registerScriptTapHandler(handler(self, self.onClick))
        self.menu:addChild(self.btn_head, 1)
    end

    -- local image = self.btn_head:getNormalImage()
    -- if not image then
        self.btn_head:setNormalImage(cc.Sprite:createWithSpriteFrameName(string.format("head-icon/%d.png", head_id)))
    -- else
    --     ex.Tools:setSpriteFrame(image, string.format("head-icon/%d.png", head_id))
    -- end
end

function HeadIconComponent:setBorderImage(border_id)
    self.data.border_id = border_id

    if not self.border then
        self.border = cc.Sprite:create()
        self.border:setScale(1.2)
        self.border:setAnchorPoint(ex.a.center)
        
        self.btn_head:addChild(self.border, 10)
    end
    
    local btn_size = self.btn_head:getContentSize()
    self.border:setPosition(btn_size.width / 2, btn_size.height / 2)

    self.border:setSpriteFrame(ex.Tools:getBorderIconByIdx(border_id))
end

function HeadIconComponent:setLevel(level)
    self.data.level = level

    local argument = LevelUIArgument[self.level_style] or LevelUIArgument[LevelStyle.bottom]

    if not self.bg_level then
        cc.SpriteFrameCache:getInstance():addSpriteFrames(argument.plist)

        self.bg_level = cc.Scale9Sprite:createWithSpriteFrameName(argument.file, argument.rect)
        self.bg_level:setContentSize(cc.size(argument.width, argument.rect.height))
        self.bg_level:setIgnoreAnchorPointForPosition(false)
        self.bg_level:setAnchorPoint(ex.a.center)
        self.bg_level:setPosition(argument.pos)
        self.btn_head:addChild(self.bg_level, 20)
    end

    local btn_size = self.btn_head:getContentSize()
    self.bg_level:setPosition(cc.pAdd(argument.pos, cc.p(btn_size.width / 2, btn_size.height / 2)))

    if not self.lbl_level then
        local bg_size = self.bg_level:getPreferredSize()

        self.lbl_level = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 36)
        self.lbl_level:setScale(0.5)
		self.lbl_level:setTextColor(FONT_WHITLE)
        self.lbl_level:setAnchorPoint(ex.a.center)
        self.lbl_level:setPosition(bg_size.width / 2, bg_size.height / 2)
		self.bg_level:addChild(self.lbl_level)
    end

    self.lbl_level:setString(tostring(level))
end

function HeadIconComponent:setIsTouchInsideNode(scroll_view)
    if scroll_view then
        self.menu:setIsTouchInsideNode(scroll_view)
        self.menu:setSwallowsTouches(false)
    end
end

function HeadIconComponent:onClick(tag ,pSender)
    if self.click_callback then
        self.click_callback(self.data)
    else
        if self.data.server_id == nil then  -- 判空，可能存在0服
            ex.Tools:showPlayerInfo(self.data.rid)
        else
            ex.Tools:showPlayerInfo(self.data.rid, self.data.server_id)
        end
    end
end

return HeadIconComponent