local AliceUnicornPreviewCtr = class("AliceUnicornPreviewCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local AliceUnicornPreviewLayer = class("AliceUnicornPreviewLayer", require("src.layer.ui.UI_AliceUnicornPreviewLayer"))

------------------------------------------------
function AliceUnicornPreviewLayer:onCreate()
	self.super.onCreate(self)
	self:setName("AliceUnicornPreviewLayer")

	self:addBlackBackground()

	for i=1,99 do
		local lbl_attr = self["lbl_attr_"..i]
		if lbl_attr == nil then
			break
		end

		lbl_attr:setString(ex.Tools:getLang(580516 + i))
	end
end

function AliceUnicornPreviewLayer:initData(unicorn_data)
	self.unicorn_data = unicorn_data
	self:runAction(cc.Sequence:create(cc.DelayTime:create(0.11), cc.CallFunc:create(handler(self, self.updateLayer))))
end

function AliceUnicornPreviewLayer:updateLayer()
	local config =nil
	if self.unicorn_data  then
		config = cfg.aliceunicornstrengthen.getConfig(self.unicorn_data.occupation, self.unicorn_data.grade, self.unicorn_data.strengthen_lv)
		self:updateElemRare(self.unicorn_data.rare_attr)
	else
		config = cfg.aliceunicornstrengthen.getMaxConfig(self.unicorn_type)
	end
	local str_level = (config.need_grade == 5) and ex.Tools:getLang(580590) or ("+"..config.level)
	self.lbl_title_1:setString(ex.Tools:getLang(580515))
	self.lbl_title_2:setString(ex.Tools:getLang(580516))
	self.lbl_name:setString(ex.Tools:getLang(580507 + self.unicorn_type))
	self.lbl_grade:setString(ex.Tools:getLang(580502 + config.need_grade)..str_level)

	if config == nil then
		return
	end
	-- ex.Tools:setSpriteFrame(self.spr_unicorn_type, string.format("alice/spr-unicorn-type-%d.png", self.unicorn_type))
	ex.Tools:setSpriteFrameAsyn(self.spr_unicorn_type, "alice/spr-unicorn-type-"..self.unicorn_type..".png", "alice")
	
	
	self:updateEquip(config.need_grade, config.level)
	self:updateElemBase(config.cur_attr)
end

function AliceUnicornPreviewLayer:updateEquip(grade, level)
	for i=1,99 do
		local lbl_equip = self["lbl_equip_strenthen_"..i]
		if lbl_equip == nil then
			break
		end

		lbl_equip:setString("+"..(grade + (level >= i and 1 or 0)))
	end
end

function AliceUnicornPreviewLayer:updateElemBase(attr)
	for i,v in ipairs(attr) do
		local node_attr = self["node_attr_base_"..i]
		if node_attr == nil then
			break
		end

		local attr_show_type = cfg.attrshow.attrshow[attr[i].attr].icon
		ex.Tools:setSpriteFrameAsyn(self["spr_attr_base_"..i], string.format("backpack-info/spr-attribute-%d.png", attr_show_type), "backpack-info")

		local flag = ex.StringUtil.formatAttrStrBool(ex.Tools:getLang(2141000 + attr[i].attr), "##" , attr[i].value, "<font color='#219A00'>%s</font>")
		self["lbl_attr_base_"..i]:setString(ex.Tools:getLang(2150000 + attr[i].attr))
		self["lbl_attr_base_extra_"..i]:setVisible(true)
		if not flag then
			self["lbl_attr_base_extra_"..i]:setString(attr[i].value)
		else
			self["lbl_attr_base_extra_"..i]:setString(string.format("%.1f", attr[i].value / 100) .. "%")
		end
		self["lbl_attr_base_extra_"..i]:setPositionX(self["lbl_attr_base_"..i]:getPositionX() + self["lbl_attr_base_"..i]:getContentSize().width + 10)
	end
end

function AliceUnicornPreviewLayer:updateElemRare(rare_attr)
	if rare_attr == nil then
		rare_attr = {}
	end

	for i=1,99 do
		local node_attr = self["node_attr_"..i]
		if node_attr == nil then
			break
		end
		self["lbl_attr_"..i]:setColor(cc.c4b(253,252,224,255))
		if rare_attr[i] == nil then
			ex.Tools:setSpriteFrameAsyn(self["spr_attr_"..i], "backpack-info/spr-attribute-lock.png", "backpack-info")
			self["lbl_attr_"..i]:setString(ex.Tools:getLang(580516 + i))
			self["lbl_attr_extra_"..i]:setVisible(false)
		else
			ex.Tools:setSpriteFrameAsyn(self["spr_attr_"..i], string.format("backpack-info/spr-attribute-%d.png", rare_attr[i].attr_type), "backpack-info")
			self["lbl_attr_"..i]:setString(ex.Tools:getLang(2150000 + rare_attr[i].attr_type))
			self["lbl_attr_extra_"..i]:setPositionX(self["lbl_attr_"..i]:getPositionX() + self["lbl_attr_"..i]:getContentSize().width + 10)
			self["lbl_attr_extra_"..i]:setVisible(true)
			if rare_attr[i].attr_type == 343 or rare_attr[i].attr_type == 344 then
				self["lbl_attr_"..i]:setColor(cc.c4b(246,247,0,255))
			end
			
			local flag = ex.StringUtil.formatAttrStrBool(ex.Tools:getLang(2141000 + rare_attr[i].attr_type), "##" , rare_attr[i].attr_value, "<font color='#219A00'>%s</font>")
			if not flag then
				self["lbl_attr_extra_"..i]:setString(rare_attr[i].attr_value)
			else
				self["lbl_attr_extra_"..i]:setString(string.format("%.1f", rare_attr[i].attr_value / 100) .. "%")
			end
		end
	end
end

function AliceUnicornPreviewLayer:onElemInfo(tag, pSender)
	require("src.layer.alice.AliceUnicornElemInfoCtr"):instance():openWindow(self.unicorn_type)
end

-----------------------------------------------
function AliceUnicornPreviewCtr:loadLayer()
    local tmp_layer = AliceUnicornPreviewLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function AliceUnicornPreviewCtr:onCreate()
	self:setIsSingle(false)
end

function AliceUnicornPreviewCtr:openWindow(unicorn_type, unicorn_data)
	if self:isOpened() then
		return
	end
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/alice.plist")
	sfc:addSpriteFrames("ccbi-res/backpack-info.plist")

	self:loadLayer()
	self:open()
    self:initData(unicorn_type, unicorn_data)
	
end

function AliceUnicornPreviewCtr:initData(unicorn_type, unicorn_data)
	self.layer.unicorn_type = unicorn_type
	self.layer.unicorn_data = unicorn_data
	-- self.layer:initData(unicorn_data)
	self.layer:updateLayer()
end

return AliceUnicornPreviewCtr
