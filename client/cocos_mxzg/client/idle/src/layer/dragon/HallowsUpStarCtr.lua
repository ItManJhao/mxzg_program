local HallowsUpStarCtr = class("HallowsUpStarCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HallowsUpStarLayer = class("HallowsUpStarLayer", require("src.comp.EventLayerAdaptiveWidth"))

local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function HallowsUpStarLayer:onCreate()
    self:setAutoClose(true)
    self:addBlackBackground()
end

-----------------------------------------------------------------------------
function HallowsUpStarCtr:onCreate()
	self:setCCBIPath("ccbi/HallowsUpStarLayer.ccbi")
	self:setIsSingle(false)
end

function HallowsUpStarCtr:getLayerClass()
	return HallowsUpStarLayer
end

function HallowsUpStarCtr:getHallowsUpStarLayer()
	return self.layer
end

function HallowsUpStarCtr:openWindow(item_type, is_in_bag, pos)
	if self:isOpened() then
		return
	end
	
	if item_type == nil then
		return
	end

	self.config_relic = cfg.dragonrelic.dragonrelic[item_type]
	self.is_in_bag = is_in_bag
	self.pos = pos
	
	if self.config_relic == nil then
		return
	end

	self:loadLayer()
	self:open()
	self:initData()
end

function HallowsUpStarCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	self.layer.btn_replace:registerScriptTapHandler(handler(self, self.onReplace))
	self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onUpStar))
	
	if self.is_in_bag == nil or self.is_in_bag == true then
		self.layer.btn_replace:setVisible(false)
		self.layer.btn_confirm:setPositionX(self.layer:getContentSize().width / 2)
	end

    self:updateLayer()
end

function HallowsUpStarCtr:updateLayer()
	-- 获取下一星级配置
	local config_relic_next = cfg.dragonrelic.dragonrelic[self.config_relic.up_star_type]

	-- 更新显示
	local config_item_pre = cfg.item.item[self.config_relic.relic_type]
	local str_skill_desc = ex.Player.hero_data:getSkillDescription(self.config_relic.skill, self.config_relic.star)
	if self.layer.node_info_pre.item ~= nil then
		self.layer.node_info_pre.item:removeFromParent()
		self.layer.node_info_pre.item = nil
	end
	self.layer.node_info_pre.item = UIMenuItemBackpack:createWithData(self.config_relic.relic_type, 0)
	self.layer.node_info_pre.item:setPosition(75, 120)
	self.layer.node_info_pre:addChild(self.layer.node_info_pre.item)

	self.layer.lbl_item_name_pre:setString(ex.Tools:getLang(config_item_pre.name))
	if self.layer.node_desc_before ~= nil then
		self.layer.node_desc_before:removeFromParent()
		self.layer.node_desc_before = nil
	end
	self.layer.node_desc_before = ex.Tools:getNodeWithScrollLabel(self.layer.spr_desc_bg_pre:getContentSize(),
																  16,
																  cc.WHITE,
																  str_skill_desc)
	self.layer.node_desc_before:setAnchorPoint(self.layer.spr_desc_bg_pre:getAnchorPoint())
	self.layer.node_desc_before:setPosition(self.layer.spr_desc_bg_pre:getPosition())
	self.layer.node_info_pre:addChild(self.layer.node_desc_before, 10)
	for i,v in ipairs(self.config_relic.ability) do
		-- self.layer["spr_attr_"..i.."_pre"]:setSpriteFrame("backpack-info/spr-attr-"..v.attr..".png")
		ex.Tools:setSpriteFrame(self.layer["spr_attr_"..i.."_pre"], "backpack-info/spr-attr-"..v.attr..".png")
		self.layer["lbl_attr_"..i.."_pre"]:setString(ex.StringUtil.formatAttrStr(" "..ex.Tools:getLang(2140000 + v.attr), "##" , v.value))
	end

	if config_relic_next == nil then
		self.layer.node_info_after:setVisible(false)
		self.layer.node_res_need:setVisible(false)
		self.layer.spr_arrow:setVisible(false)
		self.layer.btn_confirm:setVisible(false)

		self.layer.btn_replace:setPositionX(320)
	else
		self.layer.node_info_after:setVisible(true)
		self.layer.node_res_need:setVisible(true)
		self.layer.spr_arrow:setVisible(true)
		self.layer.btn_confirm:setVisible(true)

		self.layer.btn_replace:setPositionX(180)

		local config_item_after = cfg.item.item[config_relic_next.relic_type]
		local str_skill_desc = ex.Player.hero_data:getSkillDescription(config_relic_next.skill, config_relic_next.star)
		if self.layer.node_info_after.item ~= nil then
			self.layer.node_info_after.item:removeFromParent()
			self.layer.node_info_after.item = nil
		end
		self.layer.node_info_after.item = UIMenuItemBackpack:createWithData(config_relic_next.relic_type, 0)
		self.layer.node_info_after.item:setPosition(75, 120)
		self.layer.node_info_after:addChild(self.layer.node_info_after.item)

		self.layer.lbl_item_name_after:setString(ex.Tools:getLang(config_item_after.name))
		if self.layer.node_desc_after ~= nil then
			self.layer.node_desc_after:removeFromParent()
			self.layer.node_desc_after = nil
		end
		self.layer.node_desc_after = ex.Tools:getNodeWithScrollLabel(self.layer.spr_desc_bg_after:getContentSize(),
																	 16,
																	 cc.WHITE,
																	 str_skill_desc)
		self.layer.node_desc_after:setAnchorPoint(self.layer.spr_desc_bg_after:getAnchorPoint())
		self.layer.node_desc_after:setPosition(self.layer.spr_desc_bg_after:getPosition())
		self.layer.node_info_after:addChild(self.layer.node_desc_after, 10)
		for i,v in ipairs(config_relic_next.ability) do
			-- self.layer["spr_attr_"..i.."_after"]:setSpriteFrame("backpack-info/spr-attr-"..v.attr..".png")
			ex.Tools:setSpriteFrame(self.layer["spr_attr_"..i.."_after"], "backpack-info/spr-attr-"..v.attr..".png")
			self.layer["lbl_attr_"..i.."_after"]:setString(ex.StringUtil.formatAttrStr(" "..ex.Tools:getLang(2140000 + v.attr), "##" , v.value))
		end

		local can_up_star = true
		if self.config_relic.up_star_require == "" or table.nums(self.config_relic.up_star_require) <= 0 then
			can_up_star = false
		else
			for i,v in ipairs(self.config_relic.up_star_require) do
				local config_item_res_need = cfg.item.item[v.item_type]
				local node = self.layer["node_res_need_"..i]
				if node.item ~= nil then
					node.item:removeFromParent()
					node.item = nil
				end
				node.item = UIMenuItemBackpack:createWithData(v.item_type, 0)
				node.item:setScale(0.7)
				node.item:setPosition(0, 0)
				node:addChild(node.item)

				self.layer["spr_res_need_name_"..i]:setString(ex.Tools:getLang(config_item_res_need.name))

				local item_num = ex.Player:getItemNum(v.item_type)
				self.layer["spr_res_need_num_"..i]:setString(ex.StringUtil.getScientificNumber(item_num).."/"..ex.StringUtil.getScientificNumber(v.item_num))
				self.layer["spr_res_need_num_"..i]:setColor((v.item_num > item_num) and cc.c3b(185,0,0) or cc.c3b(255,225,187))

				if v.item_num > item_num then
					can_up_star = false
				end
			end
		end

		ex.Tools:addRedPoint(self.layer.btn_confirm, can_up_star)
	end
end

function HallowsUpStarCtr:onReplace(tag, pSender)
	require("src.layer.dragon.HallowsSelectCtr"):instance():openWindow(self.pos)

	self:closeWindow()
end

function HallowsUpStarCtr:onUpStar(tag, pSender)
	local config_relic_next = cfg.dragonrelic.dragonrelic[self.config_relic.up_star_type]
	if config_relic_next == nil then
		return
	end

	for i,v in ipairs(self.config_relic.up_star_require) do
		if v.item_num > ex.Player:getItemNum(v.item_type) then
			ex.Tools:showEnoughTip(v.item_type, true)
			return
		end
	end

	if self.is_in_bag then
		local req = Dragon_pb.GReqDragonUpStarInBag()
		req.sys_id = self.config_relic.relic_type
		NetManager:sendMessage(ProtocolID.GReqDragonUpStarInBag, req)
	else
		local req = Dragon_pb.GReqDragonUpStarInSlot()
		req.slot_id = self.pos
		NetManager:sendMessage(ProtocolID.GReqDragonUpStarInSlot, req)
	end

	self:closeWindow()
end

return HallowsUpStarCtr