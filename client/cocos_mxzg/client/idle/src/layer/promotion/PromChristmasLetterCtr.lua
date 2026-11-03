local PromChristmasLetterCtr = class("PromChristmasLetterCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PromChristmasLetterLayer = class("PromChristmasLetterLayer", require("src.comp.EventLayerAdaptiveWidth"))

function PromChristmasLetterLayer:onCreate()
    self:addBlackBackground()

    
    self.lbl_tittle:setString(ex.Tools:getLang(6128))
    self.lbl_name:setString(ex.Tools:getLang(6126))
    self.btn_receive:setLabelText(ex.Tools:getLang(41346))

	self.viewSize = cc.size(460, 380)
	self.lbl_content = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(36)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#866442")
	:setScale(0.5)
	:setAnchorTextShadow(true)
	:ignoreContentAdaptWithSize(false)
	:setWrapMode(1)
	:setContentSize(cc.size(self.viewSize.width  / 0.5, self.viewSize.height / 0.5))
	:setPosition(cc.p(self.viewSize.width * 0.5, self.viewSize.height))
	:setAnchorPoint(ex.a.top_center)
    self.scrollview:addChild(self.lbl_content)

    local reward = cfg.system.promotion089_reward

    local view_size = cc.size(310, 87)
    -- self.rewards_scroll_view:setCreateNum(1)
    self.rewards_scroll_view:setViewSize(view_size)
    self.rewards_scroll_view:setItemSize(cc.size(120, 120))

    self.rewards_scroll_view.createItemFunction = function(item_data, scale)
        local item_type = item_data.item_type
        local item_num = item_data.item_num

       local item = ex.Player.backpack_data:createWithData(item_type, item_num)
		item:registerScriptTapHandler(handler(self, self.onItemInfo))
        item:setIgnoreAnchorPointForPosition(false)
        item:setAnchorPoint(cc.p(0.5, 0.5))
        item:setScale(0.7)
        return item
    end

    local con_width = view_size.width
    -- if #reward * 120 > con_width then
    --     con_width = #reward * 120
    -- else
    --     -- self.rewards_scroll_view:setTouchEnabled(false)
    -- end

    self.rewards_scroll_view:setContentSize(cc.size(con_width, view_size.height))
    -- self.rewards_scroll_view:setAlignmentCenter(true)
    self.rewards_scroll_view:reloadData(reward)

end

function PromChristmasLetterLayer:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-----------------------------------------------------------------------------
function PromChristmasLetterCtr:onCreate()
    self:setCCBIPath("ccbi/PromChristmasLetterLayer.ccbi")
    self:setIsSingle(false)
end

function PromChristmasLetterCtr:getLayerClass()
    return PromChristmasLetterLayer
end

function PromChristmasLetterCtr:getLayer()
    return self.layer
end

function PromChristmasLetterCtr:openWindow(bool)
    if self:isOpened() then
        return
    end

    self:loadLayer()
    self:open()
    self:initData()
end

function PromChristmasLetterCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_receive:registerScriptTapHandler(handler(self, self.onReceive))
    self.layer.btn_receive:setVisible(true)

    self.layer.lbl_content:setXmlTextLua(ex.Tools:getLang(6127))
    self.layer.lbl_content:formatText()
	local contentSize = self.layer.lbl_content:getContentSize()
	contentSize.width = contentSize.width * self.layer.lbl_content:getScale()
	contentSize.height = contentSize.height * self.layer.lbl_content:getScale()


	if contentSize.height > self.layer.viewSize.height then
		self.layer.lbl_content:setPositionY(contentSize.height)
		self.layer.scrollview:setContentSize(cc.size(self.layer.viewSize.width, contentSize.height))
		self.layer.scrollview:setContentOffset(cc.p(0, -contentSize.height + self.layer.viewSize.height))
	else
		self.layer.scrollview:setContentSize(self.layer.viewSize)
    end
    -- cc.UserDefault:getInstance():setBoolForKey("thankLetter",false)
end

function PromChristmasLetterCtr:onReceive( )
    NetManager:sendMessage(ProtocolID.GReqChristmasNoteReward)  
    self.layer.btn_receive:setVisible(false)
end

function PromChristmasLetterCtr:closeWindow(tag, pSender)
    if self.layer.btn_receive:isVisible() then
        self:onReceive()
    end
    self.layer:removeFromParent()
    self.layer = nil
    self.is_open = false
end

return PromChristmasLetterCtr
