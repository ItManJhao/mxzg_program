--[[
* @Description: 装备附魂 - 附魂技能預覽
* @Author: 熊梦
* @Date: 2020-03-11 15:42:00
* ]]

local HeroSoulShowCtr = class("HeroSoulShowCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroSoulShowLayer = class("HeroSoulShowLayer", require("src.comp.EventLayerAdaptiveWidthFull"))
local HeroSoulShowCell = class("HeroSoulShowCell", require("src.comp.LuaLayerBase"))


---------------------------------------------------------------------
function HeroSoulShowCell:onCreate()
	self:setAutoClose(false)
    self:setSwallowTouches(false)
end

function HeroSoulShowCell:initData(data)
	self.lbl_soul_lv:setString(string.format(ex.Tools:getLang(6403)..ex.Tools:getLang(47139) , data.level))

	self.lbl_level:setString(data.level)

	local sfc = cc.SpriteFrameCache:getInstance()
	local frame = sfc:getSpriteFrame(string.format("skill-icon/%d.png", data.skill))
	if not frame then
		frame = sfc:getSpriteFrame(string.format("skill-icon/%d.png", data.skill))
	end
	if frame then
		self.skill_icon:setNormalSpriteFrame(frame)
	end


	local str_skill_name =  ex.Player.hero_data:getSkillName(data.skill, math.max(1, data.level)) 
	if str_skill_name == "" then
		str_skill_name = "--"
	end
	self.skill_name:setString(str_skill_name)

	local str_skill_info = ex.Player.hero_data:getSkillDescription(data.skill, math.max(1, data.level))

	self.lbl_info_scroll = ex.Tools:getNodeWithScrollLabel(cc.size(340,65),16, cc.c3b(95,59,16),str_skill_info)
    self.lbl_info_scroll:setAnchorPoint(ex.a.left_top)
	self.node_skill_info:addChild(self.lbl_info_scroll)
end

function HeroSoulShowCell:checkLayerHeight( now_height )
	local ori_height = 210

	local min_height = 60
	local max_height = 500

	local need_drop = false 
	if now_height < min_height then now_height = min_height end 
	if max_height < now_height then 
		now_height = max_height   
		need_drop = true 
	end 
	local layer_height = now_height + ori_height
	return now_height, need_drop
end
-----------------------------------------------------------------------

function HeroSoulShowLayer:onCreate()
	self:addBlackBackground()
	self:registerBtnEvent()
end

function HeroSoulShowLayer:registerBtnEvent( )
	local ctr = HeroSoulShowCtr:instance()
	self.btn_close:registerScriptTapHandler(handler(ctr, ctr.closeWindow))

end

function HeroSoulShowLayer:iniData( border_tag )
	self.border_tag = border_tag

	self.scroll_view:setItemSize(cc.size(400, 130))
    self.scroll_view:setItemType(1)
	self:updataView()
end

function HeroSoulShowLayer:updataView(  )
	local table_data = {}
	for i,v in ipairs(cfg.heroequipsoul.heroequipsoul) do
		if v.place == self.border_tag then
			table.insert( table_data, v )
		end
	end

	self.scroll_view.createItemFunction = function(data, scale)
		-- 创建ccbi cell
		local cell_layer = HeroSoulShowCell:createWithCCBIFile("ccbi/HeroSoulShowCell.ccbi")
		cell_layer:setIgnoreAnchorPointForPosition(false)
		cell_layer:setScale(scale)
		cell_layer:setAnchorPoint(0.5, 0.5)
		cell_layer:initData(data)
	
		return cell_layer
	end
	
	self.scroll_view:reloadData(table_data)
end

-----------------------------------------------------------------------------
function HeroSoulShowCtr:onCreate()
	self:setCCBIPath("ccbi/HeroSoulShowLayer.ccbi")
	self:setIsSingle(false)
end

function HeroSoulShowCtr:getLayerClass()
	return HeroSoulShowLayer
end

function HeroSoulShowCtr:getHeroSoulLayer()
	return self.layer
end

function HeroSoulShowCtr:openWindow(border_tag)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self.layer:iniData(border_tag)
end

return HeroSoulShowCtr
