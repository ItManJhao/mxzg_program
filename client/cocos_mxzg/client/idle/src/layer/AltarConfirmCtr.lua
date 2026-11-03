local AltarConfirmCtr = class("AltarConfirmCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local AltarConfirmLayer = class("AltarConfirmLayer", require("src.comp.EventLayer"))


function AltarConfirmLayer:onCreate()
    self:addBlackBackground()
	local btn_size = self.btn_done:getContentSize()

    self.lbl_content = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(42)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#613C19")
	:setScale(0.5)
	:setAnchorTextShadow(true)
	:ignoreContentAdaptWithSize(false)
	:setWrapMode(1)
	:setContentSize(cc.size(960.0, 240.0))
	:setPosition(cc.p(25.0, 340.0))
	:setAnchorPoint(cc.p(0, 1))
    self:addChild(self.lbl_content)
end

function AltarConfirmLayer:initDone(title, content, item_list)
	self.lbl_title:setString(title)
	self.lbl_content:setXmlTextLua(content)

	-- 英雄列表scroll_view
	local viewSize = self.spr_bg:getContentSize()
    viewSize.height = viewSize.height - 10

    local scroll_view = cc.ScrollView:create(viewSize)
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    :setPosition(self.spr_bg:getPositionX(), self.spr_bg:getPositionY() + 5)
    self:addChild(scroll_view)

    local menu = cpp.UIMenu:create()
    :setIsTouchInsideNode(scroll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    scroll_view:addChild(menu)

    local item_size = cc.Sprite:createWithSpriteFrameName("other/rare-0.png"):getContentSize()
    item_size = cc.size(item_size.width + 15, item_size.height + 12)

    local itemLen = table.nums(item_list)

    local col = math.floor(viewSize.width / item_size.width) -- 列数
    local row = math.ceil(1.0 * itemLen / col) -- 行数
    local cont_height = item_size.height * row
    cont_height = math.max(cont_height , viewSize.height)
    row = math.ceil(cont_height / item_size.height) -- 总行数

    scroll_view:setContentSize(cc.size(viewSize.width, cont_height))
    scroll_view:setContentOffset(cc.p(0, viewSize.height - cont_height))

    cont_height = cont_height - item_size.height * 0.5

    local start = cc.p(viewSize.width * 0.5 - (item_size.width * col * 0.5), cont_height)
    start.x = start.x + item_size.width * 0.5

    local index = 0
    for _,v in pairs(item_list) do
    	local x = index % col
        local y = math.floor(index / col)

        local node = ex.Player.backpack_data:createWithData(v.item_type, v.item_num)
        node:setPosition(start.x + x * item_size.width, start.y - y * item_size.height)
        node:registerScriptTapHandler(handler(self, self.onBtnInfo))
        menu:addChild(node)

        index = index + 1
    end

end

function AltarConfirmLayer:onBtnInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end


function AltarConfirmCtr:onCreate()
	self:setCCBIPath("ccbi/AltarConfirmLayer.ccbi")
	self:setIsSingle(false)
end

function AltarConfirmCtr:getLayerClass()
	return AltarConfirmLayer
end

function AltarConfirmCtr:openWindow(title, content, item_list, callback)
	if self:isOpened() then
		return
	end

	self.callback = callback

	self:loadLayer()
    self:open()
    
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_done:registerScriptTapHandler(handler(self, self.onBtnDone))
    
	self.layer:initDone(title, content, item_list)
end

function AltarConfirmCtr:onBtnDone(tag, pSender)
	if self.callback then
		self.callback()
	end

	self:closeWindow(nil, self.layer)
end

return AltarConfirmCtr