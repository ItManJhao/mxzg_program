local DungeonBoxUseCtr = class("DungeonBoxUseCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local DungeonBoxUseLayer = class("DungeonBoxUseLayer", require("src.comp.EventLayer"))

local UIMenu = require("src.comp.menu.UIMenu")

function DungeonBoxUseLayer:onCreate()
	self:addBlackBackground()
	self.btn_confirm:setLabelText(ex.Tools:getLang(47543))
    self.btn_confirm:setLabelSize(50)
    self.btn_confirm:setLabelScale(0.5)
	
	local box_size = self.box:getContentSize()
	
	local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_dungeon_win_box")
	self.box:addChild(spr_effect)
	spr_effect:setPosition(cc.p(box_size.width / 2, box_size.height / 2))
end

function DungeonBoxUseLayer:showReward(vec_reward)
	local item_size = cc.size(100,100)

	local item_num = table.nums(vec_reward)
	local start_pos = cc.p(self.spr_reward_bg:getPositionX() - (item_size.width + 10) * item_num / 2, self.spr_reward_bg:getPositionY())

	if self.menu_reward == nil then
		self.menu_reward = UIMenu:create();
		self.menu_reward:setPosition(cc.p(0, 0));
		self.menu_reward:setName("menu_reward")
		self:addChild(self.menu_reward, 10);
	end
	self.menu_reward:removeAllChildren()

	for i, v in ipairs(vec_reward) do
		local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
		item:setPosition(start_pos.x + (item_size.width + 10) * (i - 0.5), start_pos.y)
		:registerScriptTapHandler(handler(self, self.onItemInfo))
		self.menu_reward:addChild(item)
	end
end

function DungeonBoxUseLayer:showKey(key_num)
	if key_num < 0 then
		key_num = 0
	end

	if self.menu_key == nil then
		self.menu_key = UIMenu:create();
		self.menu_key:setPosition(cc.p(0, 0));
		self.menu_key:setName("menu_key")
		self:addChild(self.menu_key, 10);
	end
	self.menu_key:removeAllChildren()

	local item = ex.Tools:createBackpackItem(901601, 0)
	item:setPosition(300, 150)
	:registerScriptTapHandler(handler(self, self.onItemInfo))
	self.menu_key:addChild(item)

	-- 添加数量限制
	local lbl_limit = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 36)
	lbl_limit:setAnchorPoint(1, 0)
	lbl_limit:setScale(0.5)
	lbl_limit:setPosition(item:getContentSize().width - 5, 5)
	item:addChild(lbl_limit, 10)

	lbl_limit:setString("1/"..key_num)
	if key_num > 0 then
		lbl_limit:setColor(FONT_LIGHT_YELLOW)
	else
		lbl_limit:setColor(cc.RED)
	end
end

function DungeonBoxUseLayer:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-----------------------------------------------------------------------------
function DungeonBoxUseCtr:onCreate()
	self:setCCBIPath("ccbi/DungeonBoxUseLayer.ccbi")
	self:setIsSingle(false)
end

function DungeonBoxUseCtr:getLayerClass()
	return DungeonBoxUseLayer
end

function DungeonBoxUseCtr:getDungeonBoxUseLayer()
	return self.layer
end

function DungeonBoxUseCtr:openWindow(grid_x, grid_y, box_type)
	if self:isOpened() then
		return
	end

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/dungeon.plist")

	self:loadLayer()
	self:open()
	self:initData(grid_x, grid_y, box_type)
end

function DungeonBoxUseCtr:initData(grid_x, grid_y, box_type)
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

	self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))
	
	self.box_type = box_type
	self.grid_x = grid_x
	self.grid_y = grid_y

	self:updateLayer()
end

function DungeonBoxUseCtr:updateLayer()
	if not self:getLayer() then
		return
	end

	print("box_type", self.box_type)
	local vec_reward = {}
	for k,v in pairs(cfg.sheltereventkeybox.sheltereventkeybox) do
		for i2,v2 in ipairs(v.reward) do
			table.insert(vec_reward, v2)
		end
	end
	table.sort(vec_reward, function(a, b)
		return a.item_type < b.item_type
	end)

	self.layer:showReward(vec_reward)
	self.layer:showKey(ex.Player.dungeon_data:getPropsNum(901601))
end

function DungeonBoxUseCtr:onConfirm(tag, pSender)

	local key_num = ex.Player.dungeon_data:getPropsNum(901601)

	if key_num <= 0 then
		ex.MessageView:add(ex.Tools:getLang(47655))
		return
	end

	ex.Player.dungeon_data:clickEvent(self.grid_x, self.grid_y)
	ex.AudioManager:playEffect("music/shelter105.mp3")

	self:closeWindow(0, nil)
end

return DungeonBoxUseCtr
