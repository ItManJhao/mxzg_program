local DragonRoomLevelUpCtr = class("DragonRoomLevelUpCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local DragonRoomLevelUpLayer = class("DragonRoomLevelUpLayer", require("src.comp.EventLayer"))

local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

function DragonRoomLevelUpLayer:onCreate()
    self:setAutoClose(true)
    self:addBlackBackground()
end

-----------------------------------------------------------------------------
function DragonRoomLevelUpCtr:onCreate()
	self:setCCBIPath("ccbi/DragonRoomLevelUpLayer.ccbi")
	self:setIsSingle(false)
end

function DragonRoomLevelUpCtr:getLayerClass()
	return DragonRoomLevelUpLayer
end

function DragonRoomLevelUpCtr:openWindow()
	if self:isOpened() then
		return
    end
    
	self:loadLayer()
	self:open()
	self:initData()
end

function DragonRoomLevelUpCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onLevelUp))

	self.layer:addEvent(EVENT.DRAGON_EVENT.UPDATE_INFO, handler(self, self.updateLayer))
	
	self.vec_select_hero_id = {}

    self:updateLayer()
end

function DragonRoomLevelUpCtr:updateLayer()
	local config_pre = cfg.dragonidentify.dragonidentify[ex.Player.dragon_data.dragon_room_level]
	local config_after = cfg.dragonidentify.dragonidentify[ex.Player.dragon_data.dragon_room_level + 1]

	self.layer.lbl_recharge_tip:setString(string.format(ex.Tools:getLang(74548), config_pre.need_recharge / 100))
	self.layer.lbl_recharge_tip:setVisible(ex.Player.total_charge < config_pre.need_recharge)
	self.layer.btn_confirm:setEnabled(ex.Player.total_charge >= config_pre.need_recharge)

	if config_after == nil then
		-- 满级
		self.layer.lbl_level_pre:setString("max")
		self.layer.lbl_level_after:setString("max")

		self.layer.lbl_speed_pre:setString("max")
		self.layer.lbl_speed_after:setString("max")

		self.layer.menu_need:setVisible(false)
	else
		-- 未满级
		self.layer.lbl_level_pre:setString(config_pre.idx)
		self.layer.lbl_level_after:setString(config_after.idx)

		self.layer.lbl_speed_pre:setString(string.format(ex.Tools:getLang(74557), config_pre.speed))
		self.layer.lbl_speed_after:setString(string.format(ex.Tools:getLang(74557), config_after.speed))

		-- 显示升级所需素材
		self.layer.menu_need:setVisible(true)
		self.layer.menu_need:removeAllChildren()

		local need_num = #config_pre.upgrade_require
		for i,v in ipairs(config_pre.upgrade_require) do
			local str = string.format("%s/%s", (self.vec_select_hero_id[i] ~= nil and #self.vec_select_hero_id[i] or 0), v.num)
			local node = UIMenuItemHero:createWithData(1, v.type, v.elem, v.num, v.star , nil)
			node:setPieceIcon()
			-- node:setScale(0.75)
			node:setTag(i)
			node:setPosition((node:getContentSize().width + 5) * (i - need_num / 2 - 0.5), 0)
			node:registerScriptTapHandler(handler(self, self.onSelectHero))
			self.layer.menu_need:addChild(node)

			local data = {}
			data.hero_id = 1
			data.num = str 
			data.type = v.type 
			data.elem = v.elem
			data.star = v.star
			node:initSelectItem(data)
			node.data = v
		end
	end
end

function DragonRoomLevelUpCtr:onSelectHero(tag, pSender)
	local data = {}
	data.idx = pSender:getTag()
	data.num = pSender.data.num
	data.type = pSender.data.type 
	data.elem = pSender.data.elem
	data.star = pSender.data.star
	data.occupation = pSender.data.occupation or 0
	data.selected_hero_ids = self.vec_select_hero_id[tag] or {}
	data.close_handle = handler(self, self.onSelectHeroDone)

	require("src.layer.HeroXSelectCtrl"):instance():openWindow(data)
end

function DragonRoomLevelUpCtr:onSelectHeroDone(idx, vec_selected)
	self.vec_select_hero_id[idx] = vec_selected

	-- 更新选中数量显示
	self:updateLayer()
end

function DragonRoomLevelUpCtr:onLevelUp(tag, pSender)
	local config = cfg.dragonidentify.dragonidentify[ex.Player.dragon_data.dragon_room_level]
	if config == nil then
		return
	end

	-- 检测累充金额是否达到要求
	if config.need_recharge > ex.Player.total_charge then
		ex.MessageView:add(string.format(ex.Tools:getLang(74606), config.need_recharge / 100))
		return
	end

	-- 检测资源是否充足
	for i,v in ipairs(config.upgrade_require) do
		if self.vec_select_hero_id[i] == nil or #self.vec_select_hero_id[i] < v.num then
			ex.MessageView:add(ex.Tools:getLang(74607))
			return
		end
	end

	local req = Dragon_pb.GReqDragonUpgradeIdentity()
	for _,v in pairs(self.vec_select_hero_id) do
		local data = req.choose:add()
		data.slot = 1
		for _,v2 in pairs(v) do
			table.insert(data.hero_ids, v2)
		end
		table.insert(req.choose, data)
	end
	NetManager:sendMessage(ProtocolID.GReqDragonUpgradeIdentity, req)

    ex.AudioManager:playEffect("music/hero-up-level.mp3")

	local config_after = cfg.dragonidentify.dragonidentify[ex.Player.dragon_data.dragon_room_level + 2]
	if config_after == nil then
		-- 已满级，则关闭界面
		self:closeWindow()
	else
		self.vec_select_hero_id = {}
		self:updateLayer()
	end
end

return DragonRoomLevelUpCtr