--[[
    func: 限时活动 奇珍异宝
    author:熊梦
    time:2020-07-10 10:02:00
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local PROMRareTreasureslyLayer = class("PROMRareTreasureslyLayer", require("src.layer.promotion.PromotionBaseLayer"))


-- 奖励item位置
local ItemXPos = {-179, -60, 60, 179}

function PROMRareTreasureslyLayer:onCreateDone()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	self.promotion_id = 68

	self.time_info = ex.Player.promotion_data:getPromotionDatas(self.promotion_id)

	self.node_bg:setScaleX(ex.s.global_scale)
	self.node_bg:setScaleY(self.layer_promotion:getTopY() / self.spr_bg2:getContentSize().height)
	self.node_bg:setPosition(0, self.layer_promotion:getTopY() - 10)
	self.node_item:setPositionY(self.layer_promotion:getTopY() - 630)
	

	self.lbl_time = cpp.RichTextEx:createWithXMLLua("")
	self.lbl_time:setFontSize(36)
	self.lbl_time:setScale(0.5)
	self.lbl_time:setFontFace(FONT_DEFAULT_NAME_BOLD)
	self.lbl_time:setFontColor("#ffffff")
	self.lbl_time:setAnchorTextShadow(false)
	self.lbl_time:setAnchorPoint(ex.a.center)
    self.lbl_time:setPosition(ex.Tools:getAbsolutePosition(cc.p(80, 0), CommonUIDefine.UIDefine.ComponentOriginType.LEFT_BOTTOM, self.time_node))
    self.lbl_time:setLocalZOrder(10)
	self.time_node:addChild(self.lbl_time)

	-- 文字提示
	local lbl = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(22)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#6F4DC8")
    :setScale(1)
    :setPosition(0,60)
	:setAnchorPoint(ex.a.center)
	lbl:setXmlTextLua(ex.Tools:getLang(75801))
	self.node_item:addChild(lbl)
	-- 已經選擇的道具列表
	self.item_list = {}
	if ex.Player.promotion_data.promotion_timetreasureinfo.idx_list ~= nil then
		for i,v in ipairs(ex.Player.promotion_data.promotion_timetreasureinfo.idx_list) do
			table.insert( self.item_list, v)
		end
	end

	-- 按钮状态
	local red_visible = false
	if ex.Player.promotion_data.promotion_timetreasureinfo.status == 1 then
		ex.Tools:setAllGrayAuto(self.btn_do, true)
		self.btn_do:setLabelText(ex.Tools:getLang(75803))
		self.btn_do:setLabelSize(46)
		self.btn_do:setLabelColor(cc.c3b(255,255,255))
	else
		ex.Tools:setAllGrayAuto(self.btn_do, false)
		self.btn_do:setLabelText(ex.Tools:getLang(75802))
		self.btn_do:setLabelSize(48)
		self.btn_do:setLabelColor(cc.c3b(255,255,255))
		red_visible = true
	end
	ex.Tools:addRedPoint(self.btn_do, red_visible, cc.p(0.85, 0.85))


	local config = cfg.promotimetreasureinfo.promotimetreasureinfo
	local index = 1
	for i,v in ipairs(config) do
		if v.day == ex.Player.promotion_data.promotion_timetreasureinfo.day then
			local item_type = v.reward[1].item_type
			local item_num = v.reward[1].item_num
			local item = ex.Tools:createBackpackItem(v.reward[1].item_type, v.reward[1].item_num)
			item:setScale(0.9)
			item:setPosition(110 * index - 330,0)
			item:registerScriptTapHandler(handler(self, self.onItemInfo))
			item.idx = v.idx
			self.menu_item:addChild(item)

			local spr_select_bg = cc.Sprite:createWithSpriteFrameName("win-bg/win-bg-18.png")
			:setPosition(110 * index - 295,18)
			:setName("spr_select_bg")
			self.node_item:addChild(spr_select_bg, 99)

			local setselected = false
			for q,h in ipairs(self.item_list) do
				if h == v.idx then
					setselected = true
					break
				end
			end

			local spr_select = cc.Sprite:createWithSpriteFrameName("backpack/spr-selected.png")
				:setPosition(110 * index - 295,18)
				:setVisible(setselected)
				:setName("spr_select")
				self.node_item:addChild(spr_select, 99)
			spr_select_bg.listener = cc.EventListenerTouchOneByOne:create()
			spr_select_bg.listener:setSwallowTouches(true)
			spr_select_bg.listener:registerScriptHandler(
				function(touch, event)
					local touchLocation = touch:getLocation()
					touchLocation = spr_select_bg:getParent():convertToNodeSpace(touchLocation)
					local bBox = spr_select_bg:getBoundingBox()
					if touchLocation.x >= bBox.x and touchLocation.x <= bBox.x + bBox.width and touchLocation.y >= bBox.y and touchLocation.y <= bBox.y + bBox.height then
						self:onSelectedRunes(item, spr_select)
						return true
					end

					return false
				end,cc.Handler.EVENT_TOUCH_BEGAN)
			local event_dispatcher = spr_select_bg:getEventDispatcher()
			event_dispatcher:addEventListenerWithSceneGraphPriority(spr_select_bg.listener, spr_select_bg)
			index = index + 1
		end
	end

	
	self:updateCDTime()

	self:addTimer("colorful_timer", 1000, handler(self, self.updateCDTime), true)
end

function PROMRareTreasureslyLayer:updateCDTime()
	local remain_time = self.time_info.end_time - ex.Game:getServerTime()

	if ex.Game:getServerTime()  <  self.time_info.start_time then 
		self.lbl_time:setXmlTextLua(ex.Tools:getLang(41052));
		return 
	end 

	if remain_time < 0 then 
		self.lbl_time:setXmlTextLua(ex.Tools:getLang(41053));

        self:removeTimerByName("colorful_timer")
        
        ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
		return
	end

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


function PROMRareTreasureslyLayer:onSelectedRunes(pSender, spr_select)
	if ex.Player.promotion_data.promotion_timetreasureinfo.status == 1 then
		ex.MessageView:add(ex.Tools:getLang(75803))
		return
	end
	local is_select = not spr_select:isVisible()
	-- 判斷已經選擇的道具
	local max_item = #self.item_list
	if max_item >= 3 and is_select == true then
		ex.MessageView:add(ex.Tools:getLang(75806))
		return
	end

	if is_select == true then
		table.insert( self.item_list, pSender.idx )
	else
		for i,v in ipairs(self.item_list) do
			if v == pSender.idx then
				table.remove( self.item_list, i )
				break
			end
		end	
	end
	spr_select:setVisible(is_select)
end

-- 道具点击回调
function PROMRareTreasureslyLayer:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-- 确认选择
function PROMRareTreasureslyLayer:onSure()
	local max_item = #self.item_list 
	if max_item < 3 then
		ex.MessageView:add(ex.Tools:getLang(75805))
		return
	elseif max_item > 3 then
		ex.MessageView:add(ex.Tools:getLang(75805))
		return
	elseif ex.Player.promotion_data.promotion_timetreasureinfo.status == 1 then
		ex.MessageView:add(ex.Tools:getLang(75803))
		return
	end

	ex.ConfirmCtr:openWindow(ex.Tools:getLang(3500), ex.Tools:getLang(75807), function()
		local req = Promotion068_pb.GReqChooseItem()
		for i=1, #self.item_list do
			table.insert(req.idx_list, self.item_list[i])
		end
		NetManager:sendMessage(ProtocolID.GReqChooseItem, req)
		ex.Tools:setAllGrayAuto(self.btn_do, true)
		self.btn_do:setLabelText(ex.Tools:getLang(75803))
		self.btn_do:setLabelSize(46)
		self.btn_do:setLabelColor(cc.c3b(188,188,188))
		ex.Tools:addRedPoint(self.btn_do, false, cc.p(0.85, 0.85))
    end)   
end


return PROMRareTreasureslyLayer