local BackpackInfoCtr = class("BackpackInfoCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local BackpackInfoLayer = class("BackpackInfoLayer", require("src.comp.EventLayer"))


function BackpackInfoLayer:onCreate()
	print("BackpackInfoLayer:onCreate")

	self:setAutoClose(true)
	self:setSwallowTouches(true)

	self.btn_list ={}
	
	self:addBlackBackground()
end

function BackpackInfoLayer:checkLayerHeight( now_height )
	local ori_height = 210

	local min_height = 60
	local max_height = 300

	local need_drop = false 
	if now_height < min_height then now_height = min_height end 
	if max_height < now_height then 
		now_height = max_height   
		need_drop = true 
	end 
	local layer_height = now_height + ori_height
	self:refeshLayerSize(layer_height, now_height)
	return now_height, need_drop
end

function BackpackInfoLayer:refeshLayerSize( height , now_height)
	-- 设置拉长这些渣渣
	local cur_size = self:getContentSize();
	local btn_height = 0
	if table.nums(self.btn_list) > 2 then 
		btn_height = self.btn_list[1].btn:getContentSize().width / 2 + 30
		self.menu:setPositionY(self.menu:getPositionY() + btn_height - 40)
	end
	self.spr_bg:setContentSize(cur_size.width + 20, height + btn_height + 20)
	self.btn_close:setPositionX(self.btn_close:getPositionX() + 20)

	self.node:setPosition(self:getContentSize().width / 2, self.spr_bg:getContentSize().height)
	-- self.btn_detail:setPositionY(-self.spr_bg:getContentSize().height + 45)
	-- self.btn_enter:setPositionY(self.btn_detail:getPositionY())
	-- self.btn_decompose:setPositionY(self.btn_detail:getPositionY())
	for i,v in ipairs(self.btn_list) do
		local y = -self.spr_bg:getContentSize().height + 45
		if i > 2 then 
			y = y - v.btn:getContentSize().height / 2 - 30
		end 
		v.btn:setPositionY(y)
	end

end

function BackpackInfoLayer:setCountdown(end_time, is_run)
	self.end_time = end_time

	if not self.lbl_time then
		self.lbl_time = cpp.RichTextEx:createWithXMLLua("")
		self.lbl_time:setFontSize(36)
		self.lbl_time:setScale(0.5)
		self.lbl_time:setFontFace(FONT_DEFAULT_NAME_BOLD)
		self.lbl_time:setFontColor("#ffffff")
		self.lbl_time:setAnchorTextShadow(false)
		self.lbl_time:setAnchorPoint(ex.a.left_bottom)
		self.lbl_time:setPosition(cc.p(12, 12))
		self.lbl_time:setLocalZOrder(10)
		self.spr_bg:addChild(self.lbl_time)

		if is_run then 
			self:addTimer("backpack_info_timer", 1000, handler(self, self.updateCDTime), true)
		end
	end

	self:updateCDTime()
end

function BackpackInfoLayer:updateCDTime()
	local remain_time = self.end_time - ex.Game:getServerTime()
	if remain_time > 86400 then
		local remainder = math.fmod( remain_time, 86400)
        self.lbl_time:setXmlTextLua(string.format(ex.Tools:getLang(3906),
			math.floor(remain_time / 86400),
			math.floor(remainder / 3600),
			math.floor(remainder / 60 % 60)))
    else
        self.lbl_time:setXmlTextLua(string.format(ex.Tools:getLang(41129), 
            math.floor(remain_time / 3600),
            math.floor(remain_time / 60 % 60),
            math.floor(remain_time % 60)))
    end
end


-----------------------------------------------------------------------------
function BackpackInfoCtr:onCreate()
	self:setCCBIPath("ccbi/BackpackInfoLayer.ccbi")
	self:setIsSingle(false)
end


function BackpackInfoCtr:getLayerClass()
	return BackpackInfoLayer
end

--[[
	show_use
	点击自己背包，奖励窗口才会显示使用按钮
]]

function BackpackInfoCtr:openWindow(item_data, back_open, callback, show_use, show_detail)
	if self:isOpened() then
		return
	end

	self.callback = callback or nil
	self:loadLayer()
	self:open()
	self:initDone(item_data, back_open, show_use, show_detail)

end

function BackpackInfoCtr:initDone(item_data, back_open, show_use, show_detail)
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	self.layer.btn_enter:registerScriptTapHandler(handler(self, self.onOpen))
	self.layer.btn_src:registerScriptTapHandler(handler(self, self.onItemSrc))

	local item_table = type(item_data) == "table"
	self.item_data = item_data
	self.item_type = item_table and item_data.item_type or item_data
	if  type(self.item_data) == "table" and not self.item_data.item_id then self.item_data.item_id = 0 end

	local config = cfg.item.item[self.item_type]

	if not config then
		return
	end 

	self.is_piece = ex.Player.backpack_data:isPiece(self.item_type)
	local item = self.is_piece and require("src.comp.menu.UIMenuItemHeroPiece") or require("src.comp.menu.UIMenuItemBackpack")

	self.layer.lbl_prop_name:setString(ex.Tools:getLang(config.name))
	-- self.layer.lbl_gain:setString(ex.Tools:getLang(config.gain))

	local vec_prop_type_name = {}
	vec_prop_type_name[1] = ex.Tools:getLang(47502)
	vec_prop_type_name[2] = ex.Tools:getLang(47215)
	vec_prop_type_name[3] = ex.Tools:getLang(47102)
	vec_prop_type_name[4] = ex.Tools:getLang(47723)
	vec_prop_type_name[5] = ex.Tools:getLang(47698)
	vec_prop_type_name[6] = ex.Tools:getLang(47080)
	vec_prop_type_name[7] = ex.Tools:getLang(47654)
	vec_prop_type_name[8] = ex.Tools:getLang(47530)
	vec_prop_type_name[9] = ex.Tools:getLang(47723)
	vec_prop_type_name[10] = ex.Tools:getLang(47717)
	vec_prop_type_name[11] = ex.Tools:getLang(47093)
	vec_prop_type_name[13] = ex.Tools:getLang(47123)
	vec_prop_type_name[14] = ex.Tools:getLang(47193)
	vec_prop_type_name[23] = ex.Tools:getLang(57101)
	vec_prop_type_name[ItemData.IT_PROP_LIMIT_TIME] = ex.Tools:getLang(47215)
	vec_prop_type_name[ItemData.PET] = ex.Tools:getLang(4811)
	vec_prop_type_name[ItemData.RECHAR_CARD] = ex.Tools:getLang(47723)

	
	local type = ex.Player.backpack_data:getPropType(self.item_type)
	self.layer.lbl_prop_type:setString(ex.Tools:getLang(47086)..vec_prop_type_name[type])

	local label = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(40)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
    :setFontColor("#906F48")
	:setScale(0.5)
	:setAnchorTextShadow(true)
	:setAnchorPoint(cc.p(0, 1))
	:ignoreContentAdaptWithSize(false)
	:setWrapMode(1)
    :setContentSize( self.layer.lbl_content_node:getContentSize().width * 2 ,10 )

	local show_content = ex.Tools:getLang(config.content)

	local hero_type = self.item_type - 10000000
	local hero_type_config = cfg.herotype.star[hero_type]
	local is_show_enter = config.use_type > 0 and show_use
	local is_show_detail = self.is_piece and show_detail and hero_type_config ~= nil
	local is_show_src = config ~= nil and config.source ~= "" and table.nums(config.source) > 0

	self.layer.btn_src:setVisible(is_show_src and is_show_detail)
	self.layer.btn_detail:setVisible(is_show_detail or is_show_src)
	self.layer.btn_enter:setVisible(is_show_enter)
	-- self.layer.btn_detail:setPositionX(is_show_enter and -90 or 0)
	-- self.layer.btn_enter:setPositionX((is_show_detail or is_show_src) and 90 or 0)
	self.layer.btn_decompose:setVisible(false)
	if item_table and config.decomposition == 1 then  
		self.layer.btn_decompose:setVisible(true)
	end

	if self.layer.btn_detail:isVisible() then 
		local data = {}
		data.btn = self.layer.btn_detail
		data.pro = self.layer.btn_detail:getTag()
		table.insert(self.layer.btn_list,data)
	end

	if self.layer.btn_enter:isVisible() then 
		local data = {}
		data.btn = self.layer.btn_enter
		data.pro = self.layer.btn_enter:getTag()
		table.insert(self.layer.btn_list,data)
	end

	if self.layer.btn_decompose:isVisible() then 
		local data = {}
		data.btn = self.layer.btn_decompose
		data.pro = self.layer.btn_decompose:getTag()
		table.insert(self.layer.btn_list,data)
	end

	self.layer.btn_decompose:registerScriptTapHandler(handler(self, self.onDecompose))

	local btn_num = table.nums(self.layer.btn_list)

	local function sor(a,b)
		return a.pro < b.pro
	end

	table.sort(self.layer.btn_list,sor)

	if btn_num == 1 then 
		self.layer.btn_list[1].btn:setPositionX(0)
	elseif btn_num > 1 then 
		for i,v in ipairs(self.layer.btn_list) do
			local x = i % 2 == 0 and 90 or -90
			v.btn:setPositionX(x)
		end
	end
	
	-- 必须是具体英雄碎片才显示详情
	if is_show_detail then
		self.layer.btn_detail:registerScriptTapHandler(handler(self, self.onItemDetail))
		self.layer.btn_detail:setLabelText(ex.Tools:getLang(47610))
	else
		self.layer.btn_detail:registerScriptTapHandler(handler(self, self.onItemSrc))
		self.layer.btn_detail:setLabelText(ex.Tools:getLang(47243))
	end

	label:setXmlTextLua(show_content)
	label:formatText()

	local content_size = self.layer.lbl_content_node:getContentSize()
	local need_height = label:getContentSize().height * 0.5
	local scroll_height, isdrop = self.layer:checkLayerHeight(need_height)

	local item = self.is_piece and require("src.comp.menu.UIMenuItemHeroPiece") or require("src.comp.menu.UIMenuItemBackpack")
	local node = item:createWithData(self.item_type)
	:setPosition(self.layer.spr_icon:getPositionX(), self.layer.spr_icon:getPositionY())
	if not self.is_piece then 
		if node.lbl_num then 
			node.lbl_num:setVisible(false) 
		end
	end
	if config.mode == ItemData.PET then 
		node:showPetRare()
	end 
	self.layer.node:addChild(node)

	ex.Tools:setSpriteFrame(self.layer.spr_icon, config.icon .. ".png")
	
	if isdrop == true then 
		self.scroll_view = cc.ScrollView:create(cc.size( content_size.width , scroll_height))
		:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
		:setPosition(self.layer.lbl_content_node:getPositionX() - content_size.width / 2, self.layer.lbl_content_node:getPositionY() - scroll_height)
		self.layer.node:addChild(self.scroll_view)

		self.scroll_view:addChild(label)
		label:setPosition(cc.p(0, need_height))
				
		self.scroll_view:setContentSize(cc.size(content_size.width, need_height))
		self.scroll_view:setContentOffset(cc.p(0, -need_height + scroll_height))
	
	else 
		label:setPosition(self.layer.lbl_content_node:getPositionX() - self.layer.lbl_content_node:getContentSize().width / 2, self.layer.lbl_content_node:getPositionY() )
		self.layer.node:addChild(label)
	end 
end

function BackpackInfoCtr:onOpen(tag,pSender)

	local conf = cfg.item.item[self.item_type]
	if not conf then return end 
	if conf.use_type == 99 and conf.use_jump > 0 then
		ex.JumpManager:jumpById(conf.use_jump)
	elseif conf.use_type == 3 then
		require("src.layer.SelfSelectGiftCtrl"):instance():openWindow(self.item_type)
	elseif conf.use_type == 5 then
		--公会的改名卡
		if conf.name == 702045 then
			require("src.layer.ClanChangeNickCtr"):instance():openWindow()
		else
			require("src.layer.ChangeNickCtr"):instance():openWindow()
		end
	elseif conf.use_type == 7 then
		ex.ConfirmCtr:openWindow("", ex.Tools:getLang(2125), function()
			local req = BackPack_pb.GReqRechargeCardUse()
			req.item_id = self.item_type
			NetManager:sendMessage(ProtocolID.GReqRechargeCardUse, req)
		end, nil, nil, false)
	else
		if ex.Player.backpack_data:isPiece(self.item_type) then
			local config = cfg.item.item[self.item_type]
			local has_num = ex.Player:getItemNum(self.item_type)
			local can_num = math.floor(has_num / config.use_value)
			if can_num == 0 then 
				self:closeWindow()
				return 
			elseif can_num == 1 then 

				local left = ex.Player.hero_data:getCapacity() - ex.Player.hero_data:getLen()
				if left < 1 then
					ex.MessageView:add(ex.Tools:getLang(1121))
					return
				end

				-- local req_piece = BackPack_pb.GReqPieceReward()
				-- req_piece.item_type = self.item_type
				-- req_piece.use_num = 1
				local req_piece = BackPack_pb.GReqElitePieceHero()
				req_piece.item_type = self.item_type
				req_piece.num = 1

				NetManager:sendMessage(ProtocolID.GReqElitePieceHero, req_piece)

				self:closeWindow()
				return 
			end
		end
		require("src.layer.BackpackUseCtr"):instance():openWindow(self.item_type)
	end
	self:closeWindow()
end

function BackpackInfoCtr:editBoxDesc(items)
	-- body
	local str = ","
	--local str = "\n"
	local len = #items
	print(self.__cname,len)
	for i,v in ipairs(items) do
		local item_type = v.item_type or v.type
		local name = ex.Tools:getLang(item_type)
		local num = v.item_num or v.num
		str = str .. name .. "*" .. num
		if i ~= len then str = str .. "," end
	end
	return str
end

function BackpackInfoCtr:onDecompose(tag,pSender)
	if type(self.item_data) == "table" then  
		local decompos_cfg = cfg.decompositionitem.decompositionitem[self.item_data.item_type]
		if not decompos_cfg then
			ex.MessageView:add("没有找到分解配置item_type:" .. self.item_data.item_type)
			return 
		end
		require("src.layer.decomposeItem.DecomposeSelectCtr"):instance():openWindow(self.item_data)
		self:closeWindow()
	end
end

function BackpackInfoCtr:onItemDetail(tag, pSender)
	local callback =function ()
		ex.MainSceneCtr:changeLayer(MainSceneType.BACKPACK_LAYER)
		ex.MainSceneCtr:getCurLayer():changeLayer(ItemData.IT_PIECE)
		BackpackInfoCtr:instance():openWindow(self.item_type, true, nil, true, true)
	end

	-- 获取英雄碎片初始星级，并跳转到对应英雄星级图鉴
	local hero_type = self.item_type - 10000000
	local hero_type_config = cfg.herotype.star[hero_type]
	if not hero_type_config then
		return
	end

	local layer = ex.MainSceneCtr:changeLayer(MainSceneType.HERO_ILLUSTRAT_INFO_LAYER)
	layer:showData(hero_type_config.type, hero_type_config.star, callback)

    self:closeWindow()
end

function BackpackInfoCtr:onItemSrc(tag, pSender)
	ex.Tools:onClickItemSrc(self.item_type)
end

function BackpackInfoCtr:addCountdown(end_time, is_run)
	self.layer:setCountdown(end_time, is_run)
end

return BackpackInfoCtr
