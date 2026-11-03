local TerminalLayer = class("TerminalLayer", cc.Node)

function TerminalLayer:ctor()
    self._bgLayer = cc.LayerColor:create(cc.c4b(0, 0, 0, 200))
    self:addChild(self._bgLayer)

    self._scrollView = ccui.ScrollView:create()
    self._scrollView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self._scrollView:setBounceEnabled(true)
    self._scrollView:jumpToBottom()
    self:addChild(self._scrollView)

    self._terminalLabel = cc.Label:createWithTTF('', FONT_DEFAULT_NAME_BOLD, 20)
    self._terminalLabel:enableWrap(true)
    self._terminalLabel:enableOutline(FONT_LIGHT_GRAY_C4B, 1)
    self._terminalLabel:setOverflow(cc.LabelOverflow.RESIZE_HEIGHT)
    self._terminalLabel:setAnchorPoint(cc.p(0,0))
    self._scrollView:addChild(self._terminalLabel)

    self._menuNode = cpp.UIMenu:create()
    self._menuNode:setPosition(cc.p(0, 0))
    self:addChild(self._menuNode)
    
    self._closeBtn = cpp.UIMenuItemLabel:create(
        "button/btn-close-4.png",
        "button/btn-close-4.png",
        "", nil
    )
    self._closeBtn:setScale(1.5)
    self._closeBtn:registerScriptTapHandler(function() self:_onClose() end)
    self._menuNode:addChild(self._closeBtn)

    self:onNodeEvent('enter', function() self:_onEnter() end)
end

function TerminalLayer:print(str)
    self:_print(str)
    print(str)
end

function TerminalLayer:println(str)
    self:_print(str .. '\n')
    print(str)
end

function TerminalLayer:setScrollViewSize(size)
    self._menuNode:setContentSize(size)
    self._bgLayer:setContentSize(size)
    self._scrollView:setContentSize(size)
    self._scrollView:setInnerContainerSize(size)
    self._terminalLabel:setWidth(size.width)
    self._terminalLabel:updateContent()
    self._scrollView:jumpToBottom()
end

function TerminalLayer:_onEnter()
    NodeUtils.adjustTop(self._closeBtn, -50)
    NodeUtils.adjustRight(self._closeBtn, -50)
end

function TerminalLayer:_onClose()
    self:setVisible(false)
end

function TerminalLayer:_print(str)
    local text = self._terminalLabel:getString()
    text = text .. str
    self._terminalLabel:setString(text)
    self._scrollView:jumpToBottom()
end

return TerminalLayer
