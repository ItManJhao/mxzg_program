local HeroMagicWandPreviewCtr = class("HeroMagicWandPreviewCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroMagicWandPreviewLayer = class("HeroMagicWandPreviewLayer", require("src.layer.ui.UI_HeroMagicWandPreviewLayer"))
------------------------------------------------
function HeroMagicWandPreviewLayer:onCreate()
	self.super.onCreate(self)
	self:setName("HeroMagicWandPreviewLayer")
end

function HeroMagicWandPreviewLayer:updateLayer( )
	-- self.lbl_tip:setXmlTextLua("HeroMagicWandPreviewLayer:updateLayerHeroMagicWandPreviewLayer:updateLayerHeroMagicWandPreviewLayer:updateLayerHeroMagicWandPreviewLayer:updateLayerHeroMagicWandPreviewLayer:updateLayer")
	-- self.lbl_tip:formatText()
	-- self:resetLyt()
	local best_magic_wand = nil

	-- 取品质最高的魔杖
	for k,v in pairs(cfg.magicwandtype.magicwandtype) do
		if best_magic_wand == nil or best_magic_wand.rare < v.rare then
			best_magic_wand = v
		end
	end

	local best_strengthen = nil
	-- 取强化属性最高的值
	for i,v in ipairs(cfg.magicwandstrengthen.magicwandstrengthen) do
		if v.item_type == best_magic_wand.type_id and (best_strengthen == nil or best_strengthen.level < v.level) then
			best_strengthen = v
		end
	end

	local best_refine = {}
	-- 取最大精炼属性
	for i,v in ipairs(cfg.magicwandrange.magicwandrange) do
		if v.rare == best_magic_wand.rare then
			table.insert(best_refine, {attr=v.attr_type, value=v.max})
		end
	end

	local best_attr = clone(best_strengthen.attrs)
	for i,v in ipairs(best_attr) do
		local refine_value = TableEx.findValueFunction(best_refine, function(a)
			return a.attr == v.attr
		end)

		if refine_value then
			v.value = v.value + refine_value.value * best_magic_wand.random_attr_max
		end
	end

	local pow_coe = ex.Tools:getSysCfg("magic_wand_attr_pow")
	for i,v in ipairs(best_attr) do
		self["lbl_attr"..i]:setString(string.format("%s%s  %s",
									  ex.Tools:getAttrTextOnly(v.attr),
									  ex.Tools:getLang(57200), 
									  ex.Tools:getAttrValue(v.attr, v.value)))
									  
									--   ex.Tools:getAttrValue(v.attr, v.value)
		self["lbl_add"..i]:setString(string.format("%s  %.2f%%",
									  ex.Tools:getLang(57201), 
									  math.pow(v.value, pow_coe)))
		ex.Tools:setLimitWidth(self["lbl_attr"..i], 140)
		ex.Tools:setLimitWidth(self["lbl_add"..i], 140)
	end

	self.lbl_tip:setXmlTextLua(ex.Tools:getLang(57202))
	self.lbl_tip:formatText()
	self:resetLyt()
	self:setPositionCenter()
end

-----------------------------------------------
function HeroMagicWandPreviewCtr:loadLayer()
	local tmp_layer = HeroMagicWandPreviewLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function HeroMagicWandPreviewCtr:onCreate()
	self:setIsSingle(false)
end

function HeroMagicWandPreviewCtr:openWindow()
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
    self.layer:updateLayer()
end

return HeroMagicWandPreviewCtr

