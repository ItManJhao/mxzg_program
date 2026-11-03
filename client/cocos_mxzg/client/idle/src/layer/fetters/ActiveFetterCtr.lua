local ActiveFetterCtr = class("ActiveFetterCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ActiveFetterLayer = class("ActiveFetterLayer", require("src.comp.LuaLayerBase"))

function ActiveFetterLayer:onCreate()
	self:addBlackBackground()
	-- local ChapterPreview_ctr = ActiveFetterCtr:instance()
	-- local win_size = cc.Director:getInstance():getWinSize()
	-- self.lbl_title:enableOutline(FONT_BLACK_C4B, 1)
	-- self:setCascadeOpacityEnabled(true)
	-- self:setAutoClose(false)
	-- self:setOpacity(0)
end

-----------------------------------------------------------------------------
function ActiveFetterCtr:onCreate()
	self:setCCBIPath("ccbi/ActiveFetterLayer.ccbi")
	self:setIsSingle(false)
end

function ActiveFetterCtr:getLayerClass()
	return ActiveFetterLayer
end

function ActiveFetterCtr:getActiveFetterLayer()
	return self.layer
end

function ActiveFetterCtr:openWindow(data)
	if self:isOpened() then
		return
	end
	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/fetters-lang.plist")
	-- sfc:addSpriteFrames("ccbi-base/equip-icon.plist")
	-- sfc:addSpriteFrames("ccbi-res/equip-refine.plist")
	-- sfc:addSpriteFrames("ccbi-res/item-ChapterPreview.plist")
	self:loadLayer()
	self:open()
	self:initData(data)
end

function ActiveFetterCtr:initData(data)
	local layer = self.layer

	local sp_type = data.type
	local spine = sp.SkeletonAnimation:create("spine/"..sp_type..".json","spine/"..sp_type..".atlas", 1)
    spine:setAnimation(0, "stand", true)
	layer._heroPointer:addChild(spine)

	local spineName = cc.Sprite:createWithSpriteFrameName(string.format("fetters-lang/fetter-%d.png", sp_type))
	layer._heroNamePointer:addChild(spineName)

	local skill_type = ex.Player.fetter_data:getSkillType(sp_type)
	ex.Tools:setSpriteFrame(layer._skillIconSprite, string.format("fetters/skill/%d.png", skill_type))

	ex.Tools:setSpriteFrame(layer._skillDescSprite, string.format("fetters-lang/spr-skill-%d.png", sp_type))

    local fetter_data = ex.Player.fetter_data:getFetterData(sp_type)
	local vec_attr1 = ex.Player.fetter_data:getLevelAttr(fetter_data.level, fetter_data.exp)

	layer._hpNumLabel:setString(vec_attr1[223])
	layer._atkNumLabel:setString(vec_attr1[220])
end

return ActiveFetterCtr
