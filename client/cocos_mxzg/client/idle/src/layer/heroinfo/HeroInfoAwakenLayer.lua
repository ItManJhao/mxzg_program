--[[
* @Description: 英雄觉醒
* @Author: 熊梦
* @Date: 2021-01-27 15:28:00
* ]]
local HeroInfoAwakenLayer = class("HeroInfoAwakenLayer", require("src.comp.EventLayer"))

local HeroInfoAwakenCell = class("HeroInfoAwakenCell", require("src.comp.EventLayer"))


------------------------------------------------------------------------------------------------------------------------
function HeroInfoAwakenCell:initData(attr_type,attr_value,index)
	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/backpack-info.plist")
	local attr_show_type = cfg.attrshow.attrshow[attr_type].icon

	self.spr_info_icon:setSpriteFrame(string.format("backpack-info/spr-attr-%d.png", attr_show_type))


	self.lbl_attr_addition:setString(string.format("%s+%s", ex.Tools:getLang(122000 + attr_type), ex.StringUtil.formatAttrNum(ex.Tools:getLang(2160000 + attr_type), attr_value)))
	self.btn_choice:setTag(index)
	self.btn_choice.idx = index

	ex.Tools:setLimitWidth(self.lbl_attr_addition, 150)
end

------------------------------------------------------------------------------------------------------------------------
function HeroInfoAwakenLayer:onCreate()
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/skill-icon.plist")
    sfc:addSpriteFrames("ccbi-res/hero-info.plist")
    sfc:addSpriteFrames("ccbi-res/hero-info-lang.plist")

	self.hero_data = nil

	self.attribute = {}
	    
    self.scroll_view_1:setItemSize(cc.size(320, 50))
	self.scroll_view_1:setItemType(1)
	
	self.scroll_view_2:setItemSize(cc.size(320, 50))
	self.scroll_view_2:setItemType(1)
	
	-- 基础属性的索引
	self.basics_attribute = {}
	-- 特殊属性的索引
	self.special_attribute = {}
	-- 基础属性可以选择的数量
	self.basics_number = 0
	-- 特殊属性可以选择的数量
	self.special_number = 0

	self.basics_btn = {}

	self.special_btn = {}

	self.awaken = {}

	self.node_all:setScale(math.min(1, ex.s.global_scale))

	self:updateView()

	ex.Tools:setLimitWidth(self.lbl_jichushuxing, 90)
	ex.Tools:setLimitWidth(self.lbl_teshushuxing, 90)

end

function HeroInfoAwakenLayer:updateView()
	self.hero_data = ex.Player.hero_data.promote:getSelectHero()

	self.attribute = cfg.heroawaken.heroawaken[self.hero_data.hero_type]
	if self.attribute == nil then
		return
	end
	self.basics_attribute = {}
	self.special_attribute = {}
	self.basics_number = self.attribute.base_count
	self.special_number = self.attribute.special_count
	self.awaken = self.hero_data.awaken
	self.basics_btn = {}
	self.special_btn = {}

	if #self.awaken.base_index == 0 or #self.awaken.special_index == 0 then
		self.lbl_free:setVisible(true)
		self.node_cost:setVisible(false)
		self.btn_enter:setLabelText(ex.Tools:getLang(4107))
		ex.Tools:addRedPoint(self.btn_enter, true, cc.p(0.95, 0.85))
		ex.Tools:setLimitWidth(self.btn_enter:getLabel(), 110)
	else
		self.lbl_free:setVisible(false)
		self.node_cost:setVisible(true)
		self.spr_icon:setSpriteFrame(string.format("backpack/%d.png", self.attribute.cost[1].item_type))
		self.lbl_num:setString(self.attribute.cost[1].item_num)

		self.btn_enter:setLabelText(ex.Tools:getLang(3011))
		ex.Tools:addRedPoint(self.btn_enter, false, cc.p(0.95, 0.85))
		ex.Tools:setLimitWidth(self.btn_enter:getLabel(), 110)
	end
	self.lbl_free:setVisible(false)
	local base_attr = self.attribute.base_attr
	for k,v in pairs(base_attr) do
		v.idx = k - 1
	end

	self.scroll_view_1.createItemFunction = function(data)
		-- 创建ccbi cell
		local cell = HeroInfoAwakenCell:createWithCCBIFile("ccbi/HeroInfoAwakenCell.ccbi")
		cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(0.5, 0.5)
        cell:initData(data.type, data.value,data.idx)
		cell.btn_choice:registerScriptTapHandler(handler(self, self.onBaseChoice))
		cell.menu_tab:setIsTouchInsideNode(self.scroll_view_1)
		table.insert(self.basics_btn,cell.btn_choice)
		cell.spr_using:setVisible(false)
		ex.Tools:setSpriteLimitWidth(cell.spr_using,60)
		for k,v in pairs(self.awaken.base_index) do
			if v == data.idx then
				-- if #self.basics_attribute == 0 then
				-- 	cell.btn_choice:setChecked(true)
				-- end
				cell.spr_using:setVisible(true)
				break
			end
		end
		for k,v in pairs(self.basics_attribute) do
			if v == data.idx then
				cell.btn_choice:setChecked(true)
				break
			end
		end
        return cell
	end

	self.scroll_view_1:reloadData(base_attr)

	local special_attr = self.attribute.special_attr
	for k,v in pairs(special_attr) do
		v.idx = k - 1
	end

	self.scroll_view_2.createItemFunction = function(data)
		-- 创建ccbi cell
		local cell = HeroInfoAwakenCell:createWithCCBIFile("ccbi/HeroInfoAwakenCell.ccbi")
		cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(0.5, 0.5)
        cell:initData(data.type, data.value,data.idx)
		cell.btn_choice:registerScriptTapHandler(handler(self, self.onSpecialChoice))
		cell.menu_tab:setIsTouchInsideNode(self.scroll_view_2)
		table.insert(self.special_btn,cell.btn_choice)
		cell.spr_using:setVisible(false)
		ex.Tools:setSpriteLimitWidth(cell.spr_using,60)
		for k,v in pairs(self.awaken.special_index) do
			if v == data.idx then
				-- if #self.special_attribute == 0 then
				-- 	cell.btn_choice:setChecked(true)
				-- end
				cell.spr_using:setVisible(true)
				break
			end
		end
		for k,v in pairs(self.special_attribute) do
			if v == data.idx then
				cell.btn_choice:setChecked(true)
				break
			end
		end
		
        return cell
	end

	self.scroll_view_2:reloadData(special_attr)

end

function HeroInfoAwakenLayer:onBaseChoice(tag,pSender)
	print("=========onBaseChoice=============",tag)
	local ischecked = pSender:isChecked()
	if self.basics_number == 1 then
		for k,v in pairs(self.basics_btn) do
			if v.idx ~= tag then
				v:setChecked(false)
			end
		end
		self.basics_attribute = {}
	else
		if #self.basics_attribute >= self.basics_number and ischecked then
			ex.MessageView:add(ex.Tools:getLang(47773))
			pSender:setChecked(not ischecked)
			return
		end
	end

	if ischecked then
		table.insert(self.basics_attribute,tag)
	else
		for k,v in pairs(self.basics_attribute) do
			if v == tag then
				table.remove( self.basics_attribute,k)
				break
			end
		end
	end
	pSender:setChecked(ischecked)
	dump(self.basics_attribute)
end

function HeroInfoAwakenLayer:onSpecialChoice(tag,pSender)
	print("==========onSpecialChoice============",tag)
	local ischecked = pSender:isChecked()
	if self.special_number == 1 then
		for k,v in pairs(self.special_btn) do
			if v.idx ~= tag then
				v:setChecked(false)
			end
		end
		self.special_attribute = {}
	else
		if #self.special_attribute >= self.special_number and ischecked then
			ex.MessageView:add(ex.Tools:getLang(47773))
			pSender:setChecked(not ischecked)
			return
		end
	end

	if ischecked then
		table.insert(self.special_attribute,tag)
	else
		for k,v in pairs(self.special_attribute) do
			if v == tag then
				table.remove( self.special_attribute,k)
				break
			end
		end
	end
	pSender:setChecked(ischecked)
	dump(self.special_attribute)
end

function HeroInfoAwakenLayer:onBtnInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(6301), ex.Tools:getLang(6302))
end

function HeroInfoAwakenLayer:onEnter(tag, pSender)
	-- 属性数量不够不给修改
	if #self.basics_attribute ~= self.basics_number or #self.special_attribute ~= self.special_number then
		ex.MessageView:add(string.format(ex.Tools:getLang(6306),self.basics_number,self.special_number)    )
		return
	end

	-- 道具不夠
	if #self.awaken.base_index ~= 0 and #self.awaken.special_index ~= 0 then
		if ex.Player:getItemNum(self.attribute.cost[1].item_type) < self.attribute.cost[1].item_num then
			if 900002 == self.attribute.cost[1].item_type then
				ex.MessageView:add(ex.Tools:getLang(30501))
			else
				ex.MessageView:add(ex.Tools:getLang(30503))
			end
			return
		end
	end
	
	-- 相同的选择 不给修改
	local base_alike = 0
	local special_alike = 0
	for i,v in pairs(self.hero_data.awaken.base_index) do
		for j,k in pairs(self.basics_attribute) do
			if v == k then
				base_alike = base_alike + 1
				break
			end
		end
	end
	for i,v in pairs(self.hero_data.awaken.special_index) do
		for j,k in pairs(self.special_attribute) do
			if v == k then
				special_alike = special_alike + 1
				break
			end
		end
	end
	if base_alike == self.basics_number and special_alike == self.special_number then
		ex.MessageView:add(ex.Tools:getLang(6304))
		return
	end


	local tips_lang = 6305
	if #self.awaken.base_index == 0 or #self.awaken.special_index == 0 then
		tips_lang = 6308
	end
	ex.ConfirmCtr:openWindow(ex.Tools:getLang(41301), string.format(ex.Tools:getLang(tips_lang), self.attribute.cost[1].item_type, self.attribute.cost[1].item_num), function()
		local req = HeroAwaken_pb.GReqHeroAwakenSelect()
		req.hero_id = self.hero_data.hero_id
		for i,v in ipairs(self.basics_attribute) do
			table.insert(req.base_index,v)
		end
		for i,v in ipairs(self.special_attribute) do
			table.insert(req.special_index,v)
		end
		NetManager:sendMessage(ProtocolID.GReqHeroAwakenSelect, req)
	end)
end

return HeroInfoAwakenLayer
