local QuickBattleEndCtr = class("QuickBattleEndCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local QuickBattleEndLayer = class("QuickBattleEndLayer", require("src.comp.EventLayer"))

function QuickBattleEndLayer:onCreate()
	self:addBlackBackground()
	self:setAutoClose(true)
	-- self:setLocalZOrder(100)

	self:reorderChild(self.lbl_role_exp_num, 10)
	
    local posBar = cc.p(0, 0)
    posBar.x = self.role_exp:getPositionX() + 3 - self.role_exp:getContentSize().width / 2
    posBar.y = self.role_exp:getPositionY()


	self.progress_exp = require("src.comp.UIScale9SpriteEx"):create("battle-end/spr-jdt2.png", cc.rect(10, 10, 1, 1))
	self.progress_exp:setAnchorPoint(cc.p(0, 0.5))
	self.progress_exp:setContentSize(cc.size(self.role_exp:getContentSize().width - 6, self.role_exp:getContentSize().height - 6))
   	self.progress_exp:setPosition(posBar)
	self.progress_exp:setPercentage(0)
	self.node_role:addChild(self.progress_exp)

	self.lbl_tip_1:setString(ex.Tools:getLang(3507))
	self.lbl_tip_2:setString(ex.Tools:getLang(3508))
	self.spr_tip_line_left:setPositionX(self.lbl_tip_1:getPositionX() - self.lbl_tip_1:getContentSize().width * self.lbl_tip_1:getScaleX() / 2 - 5)
	self.spr_tip_line_right:setPositionX(self.lbl_tip_1:getPositionX() + self.lbl_tip_1:getContentSize().width * self.lbl_tip_1:getScaleX() / 2 + 5)

	ex.EffectCtr:playNormalEff(36, 320.0 + 5, 630.0 - 8, nil, self, 0)

	self.scroll_view:setItemSize(cc.size(124, 134))
	self.scroll_view:setCreateNum(4)
	self.scroll_view:setAlignmentCenter(true)

	ex.Tools:layerEnterAction(self)
end

function QuickBattleEndLayer:startTimer()
	self:addTimer("timerExp", 50, handler(self,self.updateCDTime), true)
end

function QuickBattleEndLayer:updateCDTime()
	self.start_pro = self.start_pro + ex.Player.last_add_exp * 0.05
	if self.progressTimerType == 1 then
		local up_level_config = cfg.mainlevel.mainlevel[ex.Player.level]
		local config = cfg.mainlevel.mainlevel[ex.Player.level - 1]
		
		self.progress_exp:setPercentage(1.0 * self.start_pro / config.exp * 100)

		if self.start_pro > config.exp then 
			self.progressTimerType = 2

			self.start_pro = 0
			self.lbl_level:setString("Lv " .. (tostring(ex.Player.level)))
		end 
		self.lbl_role_exp_num:setString(tostring(self.start_pro).. "/" .. config.exp)
	else  
		local config = cfg.mainlevel.mainlevel[ex.Player.level]
		if self.start_pro < ex.Player.exp then 
			self.progress_exp:setPercentage(1.0 * self.start_pro / config.exp * 100)
			self.lbl_role_exp_num:setString(tostring(self.start_pro).. "/" .. config.exp)
		else
			self:removeTimerByName("timerExp")

			self.progress_exp:setPercentage(1.0 * ex.Player.exp / config.exp * 100)
			self.lbl_role_exp_num:setString(tostring(ex.Player.exp).. "/" .. config.exp)
		end 
	end 
end 

function QuickBattleEndLayer:showRoleInfo(head_id, border_id, level, exp)
    self.lbl_level:setString("Lv " .. tostring(level))
    self.spr_photo:setSpriteFrame(string.format("head-icon/%d.png", head_id))
	self.spr_frame:setSpriteFrame(ex.Tools:getBorderIconByIdx(border_id))
	
    local config = cfg.mainlevel.mainlevel[level]
    self.lbl_role_exp_num:setString(tostring(exp).. "/" .. config.exp)
	self.progress_exp:setPercentage(1.0 * exp / config.exp * 100)
end

function QuickBattleEndLayer:showTime(time)
	self.lbl_time:setString(string.format("%02d: %02d: %02d", time / 3600, time % 3600 / 60, time % 60))
end

function QuickBattleEndLayer:showRes(num_role_exp, num_hero_exp, num_stone)
	if num_role_exp ~= nil and num_role_exp > 0 then
		self.lbl_res_num_1:setString(tostring(num_role_exp))
	else
		self.node_res_1:setVisible(false)

		self.node_res_3:setPositionY(self.node_res_2:getPositionY())
		self.node_res_2:setPositionY(self.node_res_1:getPositionY())
	end

	if num_hero_exp ~= nil and num_hero_exp > 0 then
		self.lbl_res_num_2:setString(tostring(num_hero_exp))
	else
		self.node_res_2:setVisible(false)

		self.node_res_3:setPositionY(self.node_res_2:getPositionY())
	end

	if num_stone ~= nil and num_stone > 0 then
		self.lbl_res_num_3:setString(tostring(num_stone))
	else
		self.node_res_3:setVisible(false)
	end
end

function QuickBattleEndLayer:showReward(vec_reward)
	-- local menu = cpp.UIMenu:create()
    -- menu:setSwallowsTouches(false)
    -- menu:setPosition(cc.p(0, 0))
    -- menu:setIsTouchInsideNode(self.scroll_view)
    -- self.scroll_view:getContainer():addChild(menu)
	
    -- local view_size = self.scroll_view:getViewSize()
    -- local item_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()
	-- item_size = cc.size(item_size.width + 20,  item_size.height + 30)

	-- local num = table.nums(vec_reward)
	-- local col = math.floor(view_size.width / item_size.width) -- 列数
	-- col = math.min(col, num)
	-- local row =  math.ceil(1.0 * num / col) -- 行数
	-- local cont_height = item_size.height * row
	-- cont_height = math.max(cont_height , view_size.height)

	-- self.scroll_view:setContentSize(cc.size(view_size.width, cont_height))
	-- self.scroll_view:setContentOffset(cc.p(0, view_size.height - cont_height))

  	-- cont_height = cont_height - item_size.height * 0.5
  	-- if row == 1 then
    -- 	cont_height = cont_height - 20
    -- end

 	-- local start = cc.p(view_size.width * 0.5 - item_size.width * (col - 1) * 0.5, cont_height)

    -- local index = 0
	-- for _,v in ipairs(vec_reward) do
	-- 	local x = index % col
    --     local y = math.floor(index / col)

    --     local pos = cc.p(start.x + x * item_size.width, start.y - y * item_size.height)

	-- 	local item = ex.Player.backpack_data:createWithData(v.type, v.num)
	-- 	item:setPosition(pos)
    --     item:registerScriptTapHandler(handler(self, self.onItem))
    --     menu:addChild(item)

	-- 	index = index + 1
	-- end
	
	self.scroll_view.createItemFunction = function(v, scale)
		local item = ex.Player.backpack_data:createWithData(v.type, v.num)
		item:registerScriptTapHandler(handler(self, self.onItem))
		ex.Tools:itemEnterAction(item)
		return item
	end
	self.scroll_view:reloadData(vec_reward)

end

function QuickBattleEndLayer:onItem(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

-----------------------------------------------------------------------------
function QuickBattleEndCtr:onCreate()
	self:setCCBIPath("ccbi/QuickBattleEndLayer.ccbi")
	self:setIsSingle(false)
end

function QuickBattleEndCtr:getLayerClass()
	return QuickBattleEndLayer
end

function QuickBattleEndCtr:getQuickBattleEndpLayer()
	return self.layer
end

function QuickBattleEndCtr:openWindow(role_data, time, vec_reward)
	if self:isOpened() then
		return
	end

	ex.AudioManager:playEffect("music/item-get.mp3")

	self:loadLayer()
	self:open()
	self:initData(role_data, time, vec_reward)
end

function QuickBattleEndCtr:initData(vec_reward)
	self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.closeWindow))

	self.layer:showTime(tonumber(ex.Tools:getSysCfg("idle_speed_up")))

	local num_role_exp, num_hero_exp, num_stone = 0, 0, 0
	local vec_item = {}
	for i,v in ipairs(vec_reward) do
		if v.type == 900003 then
			num_role_exp = v.num
		elseif v.type == 900101 then
			num_hero_exp = v.num
		elseif v.type == 900102 then
			num_stone = v.num
		else
			table.insert(vec_item, v)
		end
	end
	local backpack_data = ex.Player.backpack_data
	table.sort(vec_item, function(a, b)
		local prop_a = backpack_data:getPropType(a.type)
		local prop_b = backpack_data:getPropType(b.type)
		if prop_a ~= prop_b then
			if prop_a == ItemData.IT_RES then
				return true
			elseif prop_b == ItemData.IT_RES then
				return false
			else
				return prop_a > prop_b
			end
		else
			return a.type > b.type
		end
	end)

	self.layer:showRes(num_role_exp, num_hero_exp, num_stone)
	self.layer:showReward(vec_item)
	
	self.layer.start_pro = 0
	local last_level = ex.Player.level
	local last_exp = ex.Player.exp - ex.Player.last_add_exp
	if last_exp < 0 then 
		self.layer.progressTimerType = 1
		last_level = last_level - 1

		local up_level_config = cfg.mainlevel.mainlevel[last_level + 1]
		local config = cfg.mainlevel.mainlevel[last_level]
		last_exp = last_exp + config.exp
		self.layer.start_pro = last_exp
	else 
		self.layer.progressTimerType = 2
		self.layer.start_pro = last_exp
	end 
	self.layer:showRoleInfo(ex.Player.head_id, ex.Player.border_id, last_level, last_exp)

	self.layer:startTimer()
end

return QuickBattleEndCtr
