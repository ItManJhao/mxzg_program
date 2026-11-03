local FetterVipInfoCtr = class("AchievementCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local FetterVipInfo = class("FetterVipLayer",require("src.comp.EventLayer"))
local MAX_LEVEL = 13

function FetterVipInfo:onCreate()

	self.cur_level = ex.Player.fetter_data.vip.vip_level
	self.menu:setSwallowsTouches(true)
	local str = self.cur_level == MAX_LEVEL and ex.Tools:getLang(47635) or ex.Tools:getLang(47058)
	self.lbl_next_level:setString(str)
	-- self.btn_back:registerScriptTapHandler(handler(self, self.onBack))
	self.scroll_size = cc.size(478,490)
	self.texts = {}
	self.lbl_next_level:enableOutline(cc.c4b(184,40,17,255), 2)

	self:createClippingNode()
	
	self:addBlackBackground()
	self:setAutoClose(true)

	self.select_level = self.cur_level == MAX_LEVEL and self.cur_level or self.cur_level + 1
	-- self.spr_level:setSpriteFrame(string.format("fetters-lang/title-vip-%s.png",self.cur_level))
	ex.Tools:setSpriteFrame(self.spr_level, string.format("fetters-lang/title-vip-%s.png",self.cur_level))
	self:changeTitle()
	self.btn_left:registerScriptTapHandler(handler(self, self.onLeft))
	self.btn_right:registerScriptTapHandler(handler(self, self.onRight))
	self.btn_left:setTag(-1)
	self.btn_right:setTag(1)
	self:createText()
end

function FetterVipInfo:createClippingNode( )
	local size = self.spr_bg:getContentSize()
	self.stencil = cc.LayerColor:create(cc.c3b(220, 0, 0))
	self.stencil:setContentSize(size)
	self.stencil:setIgnoreAnchorPointForPosition(false)
	self.stencil:setAnchorPoint(cc.p(0, 0))
	self.clipping_node = cc.ClippingNode:create(self.stencil)
	self:addChild(self.clipping_node)
end

function FetterVipInfo:getLevelText(level)

	local select_cfg = cfg.goddessvip.goddessvip[level]
	local unlock = {}
	local ratio = {}
	for k,v in pairs(select_cfg) do
		if k ~= "vip_level" or k ~= "announce_lang" then 
			if type(v) == "number" and v > 0 then 
				local vip_cfg = cfg.goddessviptext.text[k]
				if not vip_cfg then print(k,self.__cname,">>>>>") end
				if vip_cfg ~= nil then 
					local type = vip_cfg.type
					if type == 1 then 
						table.insert(unlock,k)
					else
						table.insert(ratio,k)
					end
				end
			end

		end 
	end

	local function sor(a,b)
		local idxA = cfg.goddessviptext.text[a].index
		local idxB = cfg.goddessviptext.text[b].index
		return idxA < idxB
	end 
	table.sort( ratio,sor )
	table.sort( unlock,sor )

	local text_data = {}
	text_data.unlock = unlock 
	text_data.ratio = ratio 
	return text_data
end

function FetterVipInfo:createTextLayer(level)
	local layer = cc.Layer:create()

	local margin = 10

	local text_data = self:getLevelText(level)

	local spr = cc.Sprite:createWithSpriteFrameName("fetters/spr-vip-dot.png")
	local spr_line = cc.Sprite:createWithSpriteFrameName("fetters/spr-line.png")
	local offset = 5

	local total_height = 0
	for i,v in ipairs(text_data.unlock) do
		total_height = total_height + (spr:getContentSize().height + margin)
	end

	for i,v in ipairs(text_data.ratio) do
		total_height = total_height + (spr:getContentSize().height + margin)
	end
	total_height = total_height + (spr:getContentSize().height + margin) + offset
	local layer_size = cc.size(self.scroll_size.width,total_height)
	layer:setContentSize(layer_size)

	local posY = total_height - spr:getContentSize().height
	-- local height = self.spr_title:getContentSize().height / 2
	local startY = posY 
	-- local margin = 10
	local idx = 0

	for i,v in ipairs(text_data.unlock) do
		local str = self:formatText(v)
		posY = startY - idx * (spr:getContentSize().height + margin)
		self:createRichText(layer,str,posY)
		idx = idx + 1
	end

	local line_height = spr_line:getContentSize().height 
	spr_line:setPosition(layer:getContentSize().width / 2,posY - (spr:getContentSize().height + margin)/2)

	layer:addChild(spr_line)
	
	
	posY = posY - (spr:getContentSize().height + margin) - offset

	for i,v in ipairs(text_data.ratio) do
		local str = self:formatText(v)
		posY = startY - idx * (spr:getContentSize().height + margin)
		self:createRichText(layer,str,posY)
		idx = idx + 1
	end
	
	return layer
end

function FetterVipInfo:showBtn( )
	self.btn_left:setVisible(self.select_level > 1)
	self.btn_right:setVisible(self.select_level < MAX_LEVEL)
end

function FetterVipInfo:onLeft(tag,pSender)
	if self:getActionByTag(10) ~= nil then
		return
	end
	self:updateTextLayer(tag)
end

function FetterVipInfo:onRight(tag,pSender)
	if self:getActionByTag(10) ~= nil then
		return
	end

	self:updateTextLayer(tag)
end

function FetterVipInfo:changeTitle()
	-- self.spr_level:setSpriteFrame(string.format("fetters/vip-lbl/VIP%s.png",self.select_level))
	-- self.spr_next_active:setSpriteFrame(string.format("fetters-lang/vip%s.png",self.select_level))
	ex.Tools:setSpriteFrame(self.spr_next_active, string.format("fetters-lang/vip%s.png",self.select_level))
end

function FetterVipInfo:createRichText(parent,str,posY)
	local spr = cc.Sprite:createWithSpriteFrameName("fetters/spr-vip-dot.png")
	spr:setAnchorPoint(0, 0.5)
	parent:addChild(spr)

	-- local lbl = cc.Label:createWithTTF(str, FONT_DEFAULT_NAME_BOLD, 22)
	local lbl = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(22)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#996a0d")
	:setAnchorPoint(0, 0.5)
	:setXmlTextLua(str)
	parent:addChild(lbl)
	lbl:setPosition(85,posY)
	spr:setPosition(50,posY)
end

function FetterVipInfo:formatText(v)

	local str_idx = cfg.goddessviptext.text[v].text
	local str = ex.Tools:getLang(str_idx)
	if cfg.goddessviptext.text[v].type == 2 then 
		local conf = cfg.goddessvip.goddessvip[self.select_level]
		str = string.format( str,conf[v] )
	elseif cfg.goddessviptext.text[v].type == 3 then 
		local conf = cfg.goddessvip.goddessvip[self.select_level]
		local hour = conf[v] / 3600
		str = string.format( str,hour )
	end

	return str
end

function FetterVipInfo:createText()

	if self.text_layer then 
		self.text_layer:removeFromParent()
		self.text_layer = nil
	end

	self.text_layer = self:createTextLayer(self.select_level)
	local view_size = self.scroll_view:getViewSize()
	local content_size = clone(self.scroll_size)
	local win_size = clone(self.scroll_size)
	local height = math.max( win_size.height,self.text_layer:getContentSize().height )
	win_size.height = height

	self.scroll_view:setContentSize(win_size)
	self.scroll_view:addChild(self.text_layer)
	self.text_layer:setPosition(0, win_size.height - self.text_layer:getContentSize().height)

	self.scroll_view:setContentSize(cc.size(content_size.width, math.max(view_size.height, self.text_layer:getContentSize().height)))
	self.scroll_view:setContentOffset(cc.p(self.scroll_view:getContentOffset().x, view_size.height - self.scroll_view:getContentSize().height))
	self.text_layer:setPositionY(self.scroll_view:getContentSize().height - self.text_layer:getContentSize().height)

	self:showBtn()

end

function FetterVipInfo:onBack(tag,pSender)
	-- ex.MainSceneCtr:changeLayer(MainSceneType.MISSION)
	FetterVipInfoCtr:instance():closeWindow()
end

function FetterVipInfo:onExit()
	
end

-- 创建移动动画
function FetterVipInfo:updateTextLayer(tag)
	if self.text_layer:getActionByTag(10) ~= nil then
		return
	end

	self.select_level = self.select_level + tag

	local view_size = self.scroll_view:getViewSize()
	local text_layer = self:createTextLayer(self.select_level)
	local content_size = clone(self.scroll_size)
	local height = math.max(content_size.height, text_layer:getContentSize().height )
	content_size.height = height
	self.scroll_view:addChild(text_layer)

	local posX = 0
	if tag > 0 then 
		posX = -(content_size.width + 100)
	else
		posX = (content_size.width + 100)
	end

	text_layer:setPosition(posX, self.scroll_view:getContentSize().height - text_layer:getContentSize().height)
	local atc_move_end = cc.CallFunc:create(function()
		self.text_layer = text_layer
		self.scroll_view:setContentSize(cc.size(content_size.width, math.max(view_size.height, text_layer:getContentSize().height)))
		self.scroll_view:setContentOffset(cc.p(self.scroll_view:getContentOffset().x, view_size.height - self.scroll_view:getContentSize().height))
		text_layer:setPositionY(self.scroll_view:getContentSize().height - text_layer:getContentSize().height)
	end)
	text_layer:runAction(cc.EaseExponentialOut:create(cc.MoveTo:create(0.5, cc.p(0, text_layer:getPositionY()))))


	-- 当前的动画退出
	if self.text_layer then
		local posX = 0
		if tag > 0 then 
			posX = (content_size.width + 100)
		else
			posX = -(text_layer:getContentSize().width + 100)
		end
		-- local act_move = cc.EaseExponentialOut:create(cc.MoveBy:create(0.5, cc.p(content_size.width, 0)))
		local act_move = cc.EaseExponentialOut:create(cc.MoveBy:create(0.5, cc.p(posX, 0)))
		local act_seq = cc.Sequence:create(act_move, atc_move_end, cc.RemoveSelf:create())
		act_seq:setTag(10)
		self.text_layer:runAction(act_seq)
	end

	self.text_layer = text_layer
	self:showBtn()
	self:changeTitle()
end

-------------------------

function FetterVipInfoCtr:onCreate()
	self:setCCBIPath("ccbi/FetterVipInfo.ccbi")
	self:setIsSingle(false)
end

function FetterVipInfoCtr:getLayerClass()
	return FetterVipInfo
end

function FetterVipInfoCtr:geFetterVipInfo()
	return self.layer
end

function FetterVipInfoCtr:openWindow(data)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(data)
end

function FetterVipInfoCtr:initData(data)

end

function FetterVipInfoCtr:onClickUpgrade(tag,pSender)

end

function FetterVipInfoCtr:updateLayer(data)


end

return FetterVipInfoCtr


-- return FetterVipInfo