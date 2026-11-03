local MakeGemOneKeyTipsCtr = class("MakeGemOneKeyTipsCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local MakeGemOneKeyTipsLayer = class("MakeGemOneKeyTipsLayer", require("src.comp.EventLayer"))

function MakeGemOneKeyTipsLayer:onCreate()
	self:setAutoClose(true)
	self:setSwallowTouches(true)

	self:addBlackBackground()

	local hs_ctr = MakeGemOneKeyTipsCtr:instance()
	local win_size = cc.Director:getInstance():getWinSize();
	local height = Maths.min(self:getContentSize().height, win_size.height);
	self:setScale(height / self:getContentSize().height);

	self.viewSize = cc.size(474, 166)

	self.scroll_view = cc.ScrollView:create(self.viewSize)
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    :setPosition(51, 98)
    self:addChild(self.scroll_view)
    -- self:setExitCallback(handler(self,self.onExitCB))

    self.lbl_btn_update = cc.Label:createWithTTF(ex.Tools:getLang(47589), FONT_DEFAULT_NAME_BOLD, 32)
    self.btn_confirm:addChild(self.lbl_btn_update)
    self.lbl_btn_update:setPosition(self.btn_confirm:getContentSize().width / 2,self.btn_confirm:getContentSize().height / 2)
    self.lbl_btn_update:enableOutline(ex.c3b.BLUE, 1)

end


-----------------------------------------------------------------------------
function MakeGemOneKeyTipsCtr:onCreate()
	self:setCCBIPath("ccbi/MakeGemOneKeyTipsLayer.ccbi")
	self:setIsSingle(false)

	self.callback = nil
end

function MakeGemOneKeyTipsCtr:getLayerClass()
	return MakeGemOneKeyTipsLayer
end

function MakeGemOneKeyTipsCtr:openWindow(data, callback)
	if self:isOpened() then
		return
	end

	self.callback = callback
	
	self:loadLayer()
	self:open()
	self:initData(data)
end

function MakeGemOneKeyTipsCtr:initData(data)
	self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))

	self:updateLayer(data)
end

function MakeGemOneKeyTipsCtr:updateLayer(data)
	-- dump(data, "MakeGemOneKeyTipsCtr:updateLayer")

	local layer = self.layer
	layer.index = self.index
	self.data = data

	local srcoll_view = layer.scroll_view

	local height 
	srcoll_view:getContainer():removeAllChildren()

	local menu = cpp.UIMenu:create()
    :setIsTouchInsideNode(srcoll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
	srcoll_view:getContainer():addChild(menu)
	
    local UIMenuItemHero = require("src.comp.menu.UIMenuItemBackpack")
	local cell_content 
	local scale = 0.8
    if #self.data > 0 then 
	    for i=1, #self.data do

			local cell_props = UIMenuItemHero:createWithData(self.data[i].type, 0)
			cell_props:setNumByStr(self.data[i].num)
			cell_content = cell_props:getContentSize()
			menu:add(cell_props)

			cell_props:registerScriptTapHandler(handler(self,self.onClickGem))
			if not height then height = math.ceil((#self.data / 5)) * (cell_content.height+10) end

			local idx = (i - 1) % 5
			local posX = (cell_content.width + 10) * (idx) * scale + 15
			local posY = height - (math.ceil(i / 5)) * (cell_content.height + 10) * scale
			cell_props:setAnchorPoint(0,0)
			cell_props:setPosition(posX,posY)
			cell_props.lbl_str:setScale(0.4)
			cell_props:setScale(scale)
		end

		local size = cc.size(layer.viewSize.width,math.ceil((#self.data / 5)) * (cell_content.height+10) + 10)
		srcoll_view:setContentSize(size)
		srcoll_view:setContentOffset(cc.p(0,layer.viewSize.height - height)) 
		-- srcoll_view:setTouchEnabled(false)
	end
	
	layer.btn_confirm:registerScriptTapHandler(handler(self,self.enterMake))
end

function MakeGemOneKeyTipsCtr:onClickGem(tag,pSender)
	local info_ctr = require("src.layer.heroinfo.StoneAbilityInfoCtr"):instance()
	info_ctr:openWindow()
	info_ctr:setStoneInfo(pSender:getType())
end

function MakeGemOneKeyTipsCtr:enterMake(tag,pSender)
	if self.callback then
		self.callback()
	end
	self:closeWindow(nil,self.layer)


	-- local max_compose_type = 0
	-- for i,v in ipairs(self.data.Gem) do
	-- 	if v.max_compose_type > max_compose_type then 
	-- 		max_compose_type = v.max_compose_type
	-- 	end
	-- end


	-- print("xxx", cfg.Gemmenttype.Gem[max_compose_type].place)

	-- local req_make_all = BackPack_pb.GReqOneKeyMakeGem()
	-- req_make_all.Gem_type = cfg.Gemmenttype.Gem[max_compose_type].place
    -- NetManager:sendMessage(ProtocolID.GReqOneKeyMakeGem, req_make_all)

    -- print(ex.Player.gold,self.data.need_gold)
	-- self:closeWindow(nil,self.layer)
end

return MakeGemOneKeyTipsCtr
