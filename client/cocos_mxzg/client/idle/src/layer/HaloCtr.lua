local HaloCtr = class("HaloCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HaloLayer = class("HaloLayer", require("src.comp.EventLayerAdaptiveWidth"))
local HaloCell = class("HaloCell", require("src.comp.LuaLayerBase"))

function HaloCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
end

function HaloLayer:onCreate()
	local win_size = cc.Director:getInstance():getWinSize()
	local height = Maths.min(self:getContentSize().height, win_size.height)
	self:setScale(height / self:getContentSize().height)
	self:addBlackBackground()

	self.lbl_all_attr = cpp.RichTextEx:createWithXMLLua("XX")
	:setFontSize(22)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#FFFFFF")
	:setPosition(cc.p(0, -292.8))
	:setAnchorPoint(cc.p(0.5, 0.5))
	self.node:addChild(self.lbl_all_attr)

	-- 49153

	-- self.scroll_view:setViewSize(cc.size(self.scroll_view:getViewSize().width, self.node:getPositionY() - 330))
	self.scroll_view:setItemType(1)
end


-----------------------------------------------------------------------------
function HaloCtr:onCreate()
	self:setCCBIPath("ccbi/HaloLayer.ccbi")
	self:setIsSingle(false)
end

function HaloCtr:getLayerClass()
	return HaloLayer
end

function HaloCtr:getHaloLayer()
	return self.layer
end

-- 传 英雄类型 或 HeroAbilityData
function HaloCtr:openWindow(vec_hero_type)
	if self:isOpened() then
		return
	end

	-- 默认显示出战的英雄
	if vec_hero_type == nil then
		local vec_hero = ex.Player.lineup_data:getLineup(LineupType.CHAPTER).hero_list
		vec_hero_type = {}
		for i,v in ipairs(vec_hero) do
			if v.position > 0 and v.hero_id > 0 then
				local hero_data = ex.Player.hero_data:getHeroDataById(v.hero_id)
				if hero_data then
					table.insert(vec_hero_type, hero_data.hero_type)
				end
			end
		end
	end

	self:loadLayer()
	self:open()
	self:initData(vec_hero_type)
end

function HaloCtr:initData(vec_hero)
	-- self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	
	self:updateLayer(vec_hero)
end

function HaloCtr:updateLayer(vec_hero)
	if not self:getLayer() then
		return
	end

	local layer = self.layer
	local sfc = cc.SpriteFrameCache:getInstance()

	-- 策划说写死
	local vec_mul_attr = {}
	table.insert(vec_mul_attr, {attr=AbilityType.AT_DAMAGE_UP, value= 0} )
	table.insert(vec_mul_attr, {attr=AbilityType.AT_SKILL_ADD, value= 0} )
	for k,v in pairs(cfg.heroelemmul.heroelemmul) do
		if v.fire and v.fire[1] > 10000 then
			vec_mul_attr[1].value = v.fire[1] - 10000
			vec_mul_attr[2].value = v.fire[2] - 10000
		end
	end

	local str_mul = ""
	for k,v in ipairs(vec_mul_attr) do
		str_mul = str_mul .. string.format("%s+%s ", ex.Tools:getLang(122000 + v.attr), ex.StringUtil.formatAttrNum(ex.Tools:getLang(2160000 + v.attr), v.value))
	end
	layer.lbl_mul:setString(str_mul)

	local vec_idx, vec_attr, icon = ex.Player.battle_data:getBattleHalo(vec_hero)

	-- 总加成效果
	local str_all_attr = string.format("<font color='#FF7200'>%s</font>", ex.Tools:getLang(49153)) 
	for i,v in pairs(vec_attr) do
		str_all_attr = str_all_attr .. string.format("<font color='#FF7200'>%s</font><font color='#4DD028'>+%s </font>", ex.Tools:getLang(122000 + v.attr), ex.StringUtil.formatAttrNum(ex.Tools:getLang(2160000 + v.attr), v.value))
	end
	layer.lbl_all_attr:setXmlTextLua(str_all_attr)
	layer.lbl_all_attr:setVisible(table.nums(vec_attr) > 0)

	-- 显示规则。激活的属性在上面。按照idx升序排列
	local data = {}
	-- 显示的类型
	local vec_type = {} 
	for i,v in ipairs(cfg.elementaddition.elementaddition) do
		v = clone(v)
		v.is_active = TableEx.findValueFunction(vec_idx, function(value) return value == v.idx end) ~= nil
		local data = TableEx.findValueFunction(vec_type, function(value)
			return value.type == v.type
		end)

		if not data then
			local tmp_data = {}
			tmp_data.type = v.type
			tmp_data.is_active = v.is_active
			tmp_data.list = {}
			table.insert(tmp_data.list, v)
			table.insert(vec_type, tmp_data)
		else
			data.is_active = data.is_active or v.is_active
			table.insert(data.list, v)
		end
	end

	table.sort(vec_type, function(a, b)
		local comp_a = a.is_active == true and 1000000 or 0
		comp_a = comp_a + (a.type < b.type and 10000 or 0)

		local comp_b = b.is_active == true and 1000000 or 0
		comp_b = comp_b + (b.type < a.type and 10000 or 0)
		return comp_a > comp_b
	end)

    local sfc = cc.SpriteFrameCache:getInstance()
    local vec_halo = clone(tab_battlehalo)
    local cell_size = HaloCell:createWithCCBIFile("ccbi/HaloCell.ccbi"):getContentSize()
	self.layer.scroll_view:setItemSize(cell_size)
	self.layer.scroll_view.createItemFunction = function(cell_data, scale)
		local cell = HaloCell:createWithCCBIFile("ccbi/HaloCell.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
		cell:setAnchorPoint(0.5, 0.5)

		cell.lbl_name:setString(ex.Tools:getLang(49100 + cell_data.type))
		cell.spr_activate:setVisible(cell_data.is_active)
		cell.spr_effect_bg:setVisible(cell_data.is_active)
		ex.Tools:setSpriteFrame(cell.spr_effect, string.format("hero-icon/elem-%d.png", cell_data.type))

		-- 显示属性
		local attr_num = table.nums(cell_data.list)
		local attr_height = 23
		for i,v in ipairs(cell_data.list) do
			-- 上阵%s个%s系英雄
			local str_list = ex.Tools:getLang(v.lan)
			str_list = string.format(str_list, table.nums(v.elements), ex.Tools:getLang(51000 + cell_data.type))

			if v.is_active  then
				str_list = string.format("<font color='#FFE5BF'>%s </font>", str_list)
			end
			-- 属性
			local str_attr = ""
			for ia,va in ipairs(v.ability) do
				if v.is_active then
					str_attr = str_attr .. string.format("<font color='#FFE5BF'>%s<font color='#4DD028'>+%s </font> </font>", ex.Tools:getLang(122000 + va.attr), ex.StringUtil.formatAttrNum(ex.Tools:getLang(2160000 + va.attr), va.value))
				else
					str_attr = str_attr .. string.format("%s+%s ", ex.Tools:getLang(122000 + va.attr), ex.StringUtil.formatAttrNum(ex.Tools:getLang(2160000 + va.attr), va.value))
				end
			end

			local lbl_content = cpp.RichTextEx:createWithXMLLua("")
			:setFontSize(18)
			:setFontFace(FONT_DEFAULT_NAME_BOLD)
			:setFontColor("#906F48")
			:setPosition(cc.p(115, cell_size.height * 0.4 + (attr_num - 1) * attr_height * 0.5 - (attr_height * (i - 1))))
			:setAnchorPoint(cc.p(0, 0.5))
			:setXmlTextLua(str_list .. " " .. str_attr)
			cell:addChild(lbl_content)
		end
		-- 改变图标
		-- cell.spr_effect = 
		return cell
	end
	self.layer.scroll_view:reloadData(vec_type)
end

return HaloCtr
