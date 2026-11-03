--[[
* @Description: 春日踏青活动-活动一：奖励预览界面
* @Author: 熊梦
* @Date: 2021-3-29 17:30:00
* ]]

local PROMFiveOneRewardCtr = class("PROMFiveOneRewardCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PROMFiveOneRewardLayer = class("PROMFiveOneRewardLayer", require("src.comp.EventLayer"))

local language = {
	6509,
	6510,
	6511
}

function PROMFiveOneRewardLayer:onCreate()
	self:setAutoClose(true)
	self:addBlackBackground()
end

function PROMFiveOneRewardLayer:refresh(data)
	local max_weight = {}
	for i,v in ipairs(data) do
		for j,k in ipairs(v) do
			max_weight[k.round] = (max_weight[k.round] or 0) + k.weight
		end
	end

	local content_list = {}
	-- 添加所有子节点
	for i,v in ipairs(data) do
		local item_data = {}
		local type = 1
		for j,k in ipairs(v) do
			local table_data = {}
			table_data.item_type = k.reward[1].item_type
			table_data.item_num =  k.reward[1].item_num
			table_data.weight = k.weight
			table.insert( item_data, table_data)
			type =  k.round
		end
		table.insert(content_list, self:addItems(item_data,max_weight[type],type))
	end
	
	-- 计算高度
	local temp_height = 20
	for i=1, #content_list do
		temp_height = temp_height + content_list[i].height
	end
	self.scroll_view:setContentSize(cc.size(self.scroll_view:getViewSize().width, temp_height))
	self.scroll_view:setContentOffset(self.scroll_view:minContainerOffset())

	-- 子节点布局
	for i=1, #content_list do
		content_list[i].node:setPosition(self.scroll_view:getViewSize().width / 2, temp_height)
		self.scroll_view:addChild(content_list[i].node)

		temp_height = temp_height - content_list[i].height
	end
end

function PROMFiveOneRewardLayer:addItems(item_list,max_weight,lang)
	local count_row = math.ceil(#item_list / 4)
	local margin_x, margin_y, margin_top, margin_bottom = 25, 25, 50, 10

	local node_box = cc.Node:create()
	node_box:setAnchorPoint(ex.a.top_center)


	local menu = cpp.UIMenu:create()
	menu:setIsTouchInsideNode(self.scroll_view)
    menu:setSwallowsTouches(false)
	node_box:addChild(menu);
	
	local node_width = self.scroll_view:getViewSize().width
	local item_scale = 0.9
	local start_pos_x = 0
	local item_size = cc.size(0, 0)
	for i,v in ipairs(item_list) do
		local row, col = math.ceil(i / 4), 1 + ((i - 1) % 4)
		local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
		item:setScale(item_scale)
		item_size = item:getContentSize()
		item_size = cc.size(item_size.width * item_scale, item_size.height * item_scale)
		menu:addChild(item)
		item:registerScriptTapHandler(handler(self, self.onItem))
		
		local lbl = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 40)
		:setColor(cc.c3b(255,255,178))
		:setAnchorPoint(0.5, 0.5)
		:setScale(0.5)
		:setPosition(item:getPositionX()+60, item:getPositionY()-15)
		item:addChild(lbl)
		local weight  = string.format( "%.2f",(v.weight/max_weight)*100) 
		lbl:setString(weight.."%")

		start_pos_x = (node_width - 4 * item_size.width - 3 * margin_x) / 2
		item:setPosition(start_pos_x + (col - 0.5) * item_size.width + (col - 1) * margin_x, 0 - margin_top - ((row - 0.5) * item_size.height + (row - 1) * margin_y))
	end
	
	local node_size = cc.size(node_width, margin_top + margin_bottom + count_row * item_size.height + (count_row - 1) * margin_y)
	node_box:setContentSize(node_size)

	menu:setPosition(cc.p(0, node_size.height))

	local sprite_zuo = cc.Sprite:createWithSpriteFrameName("prophet-tree/xian.png")
	sprite_zuo:setScaleX(-1)
	sprite_zuo:setPosition(125,node_size.height - 30)
	node_box:addChild(sprite_zuo)

	local sprite_you = cc.Sprite:createWithSpriteFrameName("prophet-tree/xian.png")
	sprite_you:setPosition(405,node_size.height- 30)
	node_box:addChild(sprite_you)

	local text = cc.Label:createWithTTF(string.format(ex.Tools:getLang(6145), lang) , FONT_DEFAULT_NAME_BOLD, 50)
    text:setScale(0.5)
    text:setPosition(265,node_size.height- 30)
	text:setAnchorPoint(cc.p(0.5,0.5))
	text:setColor(cc.c3b(255,204,134))
    node_box:addChild(text)
	ex.Tools:setLimitWidth(text, 120)

	return {height = node_size.height, node = node_box}
end

function PROMFiveOneRewardLayer:onItem(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-----------------------------------------------------------------------------
function PROMFiveOneRewardCtr:onCreate()
	self:setCCBIPath("ccbi/PROMFiveOneRewardLayer.ccbi")
	self:setIsSingle(false)

	self.data = {}
end

function PROMFiveOneRewardCtr:getLayerClass()
	return PROMFiveOneRewardLayer
end

function PROMFiveOneRewardCtr:getProphetTreeRewardPreviewLayer()
	return self.layer
end

function PROMFiveOneRewardCtr:openWindow(table_data)
	self.data = self:getShowAllRewardInfo()
	self:loadLayer()
	self:open()
	self:refreshView()
end

function PROMFiveOneRewardCtr:getShowAllRewardInfo(  )
	local showAllData = {}
	if cfg.promotion097labordayreward and cfg.promotion097labordayreward.promotion097labordayreward then
		showAllData = clone(cfg.promotion097labordayreward.promotion097labordayreward)
		local nowFiveOneData = ex.Player.promotion_data:getSaveFiveOneData()
		if nowFiveOneData then
			local nowRoundConfigData = nil
			for i,v in ipairs(showAllData) do
				if v[1].round == nowFiveOneData.cur_round then
					nowRoundConfigData = v
					break
				end
			end
			if nowRoundConfigData then
				for i,v in ipairs(nowRoundConfigData) do
					if v.canChoice == 1 then
						local rewardData = ex.Player.promotion_data:getChoiceReward(v.position)
						if rewardData then
						    v.reward = {}
						    local rData = {}
						    rData.item_type = rewardData.id
						    rData.item_num = rewardData.num
						    table.insert(v.reward, rData)
						end
					end
				end
			end
		end
	end
	return showAllData
end

function PROMFiveOneRewardCtr:refreshView()
    self.layer:refresh(self.data)
end

return PROMFiveOneRewardCtr
