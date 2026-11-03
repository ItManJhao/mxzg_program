local AliceUnicornElemInfoCtr = class("AliceUnicornElemInfoCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local AliceUnicornElemInfoLayer = class("AliceUnicornElemInfoLayer", require("src.layer.ui.UI_AliceUnicornElemInfoLayer"))

------------------------------------------------
function AliceUnicornElemInfoLayer:onCreate()
	self.super.onCreate(self)
	self:setName("AliceUnicornElemInfoLayer")

	self:addBlackBackground()
end

function AliceUnicornElemInfoLayer:updateLayer()
	local vec_attr = {}
	for _,config in ipairs(cfg.aliceunicornrare.aliceunicornrare) do
		if config.occupation == self.unicorn_type then
			table.insert(vec_attr, config.attribute[1])
		end
	end

	table.sort(vec_attr, function(a, b)
		return a.attr > b.attr
	end)

	self.node_elem:removeAllChildren()
	local size = self.node_elem:getContentSize()
	for i,attr_data in ipairs(vec_attr) do
		local flag = ex.StringUtil.formatAttrStrBool(ex.Tools:getLang(2141000 + attr_data.attr), "##" , attr_data.value, "<font color='#219A00'>%s</font>")
		local str_attr = ""
		if not flag then
			str_attr = ex.Tools:getLang(2150000 + attr_data.attr).."+"..attr_data.value
		else
			str_attr = ex.Tools:getLang(2150000 + attr_data.attr).."+"..string.format("%.1f", attr_data.value / 100) .. "%"
		end
		local lbl_elem = cc.Label:createWithTTF(str_attr, FONT_DEFAULT_NAME_BOLD, 40)
		lbl_elem:setScale(0.5)
		lbl_elem:setAnchorPoint(0, 0.5)
		lbl_elem:setColor(math.floor(attr_data.attr / 300) == 1 and cc.c3b(255, 226, 124) or cc.c3b(255, 227, 183))
		lbl_elem:setPosition(size.width * 0.5 * ((i + 1) % 2), size.height - 40 * (0.5 + math.floor((i - 1) / 2)))
		self.node_elem:addChild(lbl_elem)
	end
end

-----------------------------------------------
function AliceUnicornElemInfoCtr:loadLayer()
    local tmp_layer = AliceUnicornElemInfoLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function AliceUnicornElemInfoCtr:onCreate()
	self:setIsSingle(false)
end

function AliceUnicornElemInfoCtr:openWindow(unicorn_type)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
    self:initData(unicorn_type)
end

function AliceUnicornElemInfoCtr:initData(unicorn_type)
	self.layer.unicorn_type = unicorn_type

	self.layer:updateLayer()
end

return AliceUnicornElemInfoCtr
