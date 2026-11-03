--[[
* @Description: 冥域魔都-战斗结算页面
* @Author: 熊梦
* @Date: 2021-01-14 10:13:00
* ]]
local UnderworldPagodaBattleEndCtr = class("UnderworldPagodaBattleEndCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local UnderworldPagodaBattleEndLayer = class("BattleEndLayer",require("src.comp.EventLayerAdaptiveWidth"))

local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function UnderworldPagodaBattleEndLayer:onCreate()
	self:setAutoClose(true)
	self:addBlackBackground()
end

function UnderworldPagodaBattleEndLayer:initData(is_win,vec_reward) 
	self.vec_reward = vec_reward

	self.scroll_view:setItemSize(cc.size(130, 110))
	self.scroll_view:setAlignmentCenter(true)

	ex.Tools:setSpriteFrame(self.spr_wing, string.format("battle-end/spr-wing-%d.png", is_win and 1 or 0))
	self.lbl_faild:setFontSize(32)

	self.scroll_view:setVisible(false)
	self.btn_strong:setVisible(false)
	self.lbl_faild:setVisible(false)

	if is_win == true then
		local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_battle_end")
    	spr_effect:setPosition(self.spr_wing:getContentSize().width / 2, self.spr_wing:getContentSize().height / 2 + 40)
    	spr_effect:setScale(1)
		self.spr_wing:addChild(spr_effect, 0, 10)	
		
		local chibang = sp.SkeletonAnimation:create("spine/chibang.json","spine/chibang.atlas", 1)
        chibang:setAnimation(0, "idle", true);
	    chibang:setPosition(self.spr_wing:getPositionX(), self.spr_wing:getPositionY())
	    self:addChild(chibang)

	   	self.spr_result:setVisible(false)
	   	self.spr_wing:setVisible(false)

	else
		if #self.vec_reward == 0 then
			self.btn_strong:setVisible(true)
			self.lbl_faild:setVisible(true)
		end
	end


	if #self.vec_reward ~= 0 then
		self.scroll_view.createItemFunction = function(data, scale)
			local item = ex.Tools:createBackpackItem(data.item_type, data.item_num)
			item:registerScriptTapHandler(handler(self, self.onItemInfo))
			return item
		end

		self.scroll_view:reloadData(self.vec_reward)
		self.scroll_view:setVisible(true)
	end

end

function UnderworldPagodaBattleEndLayer:onStrong(tag, pSender)
	ex.JumpManager:jumpByAtom("main_hero_recommend")
end

function UnderworldPagodaBattleEndLayer:onItemInfo(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

function UnderworldPagodaBattleEndLayer:onConfirm()
	local ctr = UnderworldPagodaBattleEndCtr:instance()
	ctr:closeWindow()
end
-----------------------------------------------------------------------------
function UnderworldPagodaBattleEndCtr:onCreate()
	self:setCCBIPath("ccbi/UnderworldPagodaBattleEndLayer.ccbi")
	self:setIsSingle(false)
end

function UnderworldPagodaBattleEndCtr:getLayerClass()
	return UnderworldPagodaBattleEndLayer
end

function UnderworldPagodaBattleEndCtr:getChapterEndLayer()
	return self.layer
end

function UnderworldPagodaBattleEndCtr:openWindow(is_win, vec_reward, ext)
	if self:isOpened() then
		return
	end

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/battle-end.plist")
	sfc:addSpriteFrames("ccbi-res/battle-end-lang.plist")
    
	self:loadLayer()
	self:open()
	self.vec_battle_detail = ext
	if ext == nil then
		self.layer.btn_report:setVisible(false)
	end
	self.layer.btn_report:registerScriptTapHandler(handler(self, self.onBattleDetail))
	self.layer:initData(is_win,vec_reward)
end

function UnderworldPagodaBattleEndCtr:onBattleDetail(tag, pSender)
	require("src.layer.BattleDetailCtr"):instance():openWindow(self.vec_battle_detail)
end


return UnderworldPagodaBattleEndCtr
