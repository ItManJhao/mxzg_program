local DungeonBuffListCtr = class("DungeonBuffListCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local DungeonBuffListLayer = class("DungeonBuffListLayer", require("src.comp.EventLayer"))

function DungeonBuffListLayer:onCreate()
	self:addBlackBackground()
	
end

-----------------------------------------------------------------------------
function DungeonBuffListCtr:onCreate()
	self:setCCBIPath("ccbi/DungeonBuffListLayer.ccbi")
	self:setIsSingle(false)
end

function DungeonBuffListCtr:getLayerClass()
	return DungeonBuffListLayer
end

function DungeonBuffListCtr:getDungeonBuffListLayer()
	return self.layer
end

function DungeonBuffListCtr:openWindow()
	if self:isOpened() then
		return
	end

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/dungeon.plist")

	self:loadLayer()
	self:open()
	self:initData()
end

function DungeonBuffListCtr:initData()
	self:updateLayer()
end

function DungeonBuffListCtr:updateLayer()
	if not self:getLayer() then
		return
	end

	local vec_buff_format = {}
	-- table.insert(vec_buff_format, {102, ex.Tools:getLang(47323)})
	-- table.insert(vec_buff_format, {201, ex.Tools:getLang(47128)})
	-- table.insert(vec_buff_format, {202, ex.Tools:getLang(47686)})
	-- table.insert(vec_buff_format, {207, ex.Tools:getLang(47519)})
	-- table.insert(vec_buff_format, {270, ex.Tools:getLang(47394)})
	-- table.insert(vec_buff_format, {291, ex.Tools:getLang(47709)})
	vec_buff_format[102] = ex.Tools:getLang(47323)
	vec_buff_format[201] = ex.Tools:getLang(47128)
	vec_buff_format[202] = ex.Tools:getLang(47686)
	vec_buff_format[207] = ex.Tools:getLang(47519)
	vec_buff_format[270] = ex.Tools:getLang(47394)
	vec_buff_format[291] = ex.Tools:getLang(47709)
	-- dump(vec_buff_format)

	-- dump(ex.Player.dungeon_data.buff_list, "ex.Player.dungeon_data.buff_list")

	for k,v in pairs(vec_buff_format) do
		local buff_data = TableEx.findValueFunction(ex.Player.dungeon_data.buff_list, function(v)
			return v.item_type == k
		end)

		local str = v
		if buff_data then
			str = str ..(buff_data.item_num / 100).."%"
		else
			str = str .. "0%"
		end

		if self.layer["lbl_buff_num_"..k] then
			self.layer["lbl_buff_num_"..k]:setString(str)
		end
	end

	-- for i, v in ipairs(ex.Player.dungeon_data.buff_list) do
	-- 	local str = vec_buff_format[v.item_type]..(v.item_num / 100).."%"
	-- 	self.layer["lbl_buff_num_"..v.item_type]:setString(str)
	-- end
end

return DungeonBuffListCtr
