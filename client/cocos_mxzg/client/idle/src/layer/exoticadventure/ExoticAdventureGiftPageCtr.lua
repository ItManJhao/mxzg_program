--[[
* @Description: 异界冒险-礼包
* @Author: 熊梦
* @Date: 2020-09-14 16:00:00
* ]]
local ExoticAdventureGiftPageCtr = class("ExoticAdventureGiftPageCtr",require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ExoticAdventureGiftPageLayer = class("ExoticAdventureGiftPageLayer", require("src.comp.EventLayerAdaptiveWidthFull"))

local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function ExoticAdventureGiftPageLayer:onCreate()
    self:addBlackBackground()
	self:registerBtnEvent()
	self:inidata()
end

-- 关闭按钮
function ExoticAdventureGiftPageLayer:registerBtnEvent( )
	local ctr = ExoticAdventureGiftPageCtr:instance()
	self.btn_close:registerScriptTapHandler(handler(ctr, ctr.closeWindow))

	self:addEvent(EVENT.EXOTICADVENTURE.UPDATAGIFT,self.updataGift)
end

function ExoticAdventureGiftPageLayer:inidata()
	local idx = cfg.spacetimeproduct.spacetimeproduct[ex.Player.exotic_adventure_data.product_id].product_id
	local reward = cfg.spacetimeproduct.spacetimeproduct[ex.Player.exotic_adventure_data.product_id].reward
	
	for i,v in ipairs(reward) do
		local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
		item:setScale(0.9)
		item:setPositionX(-250+100*i)
		item:registerScriptTapHandler(handler(self, self.onItemInfo))
		self.menu_reward:addChild(item)
	end

	self.buy_config = cfg.buygem.buygem[idx]
	if not self.buy_config then
		ex.Tools:showDebugStatus(string.format(ex.Tools:getLang(47725), idx))
	end

	self.btn_buy:setLabelText(string.format( ex.Tools:getLang(70610) , self.buy_config.rmb / 100))

	self.lbl_time = cpp.RichTextEx:createWithXMLLua("")
	self.lbl_time:setFontSize(36)
	self.lbl_time:setScale(0.5)
	self.lbl_time:setFontFace(FONT_DEFAULT_NAME_BOLD)
	self.lbl_time:setFontColor("#6EFF6E")
	self.lbl_time:setAnchorTextShadow(false)
	self.lbl_time:setAnchorPoint(cc.p(0,0.5))
	self.lbl_time:setPosition(ex.Tools:getAbsolutePosition(cc.p(0, 0), CommonUIDefine.UIDefine.ComponentOriginType.LEFT_BOTTOM, self.node_time))
	self.node_time:addChild(self.lbl_time)
	
	self:updateCDTime()
	self:addTimer("colorful_timer", 1000, handler(self, self.updateCDTime), true)
end

function ExoticAdventureGiftPageLayer:updateCDTime()
	local remain_time = ex.Player.exotic_adventure_data.product_end_time - ex.Game:getServerTime()

	if remain_time > 86400 then
		local remainder = math.fmod( remain_time, 86400)
        self.lbl_time:setXmlTextLua(string.format(ex.Tools:getLang(47162),
			math.floor(remain_time / 86400),
			math.floor(remainder / 3600),
			math.floor(remainder / 60 % 60)))
    else
        self.lbl_time:setXmlTextLua(string.format(ex.Tools:getLang(47140), 
            math.floor(remain_time / 3600),
            math.floor(remain_time / 60 % 60),
            math.floor(remain_time % 60)))
    end

end

function ExoticAdventureGiftPageLayer:onItemInfo(tag ,pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end


function ExoticAdventureGiftPageLayer:onBtnDone(tag, pSender)
	if ex.Player.exotic_adventure_data.product_end_time < ex.Game:getServerTime() then
		ex.MessageView:add(ex.Tools:getLang(41053))
		return
	end

	-- 拉起支付页面
	if self.buy_config then
		ex.Player:pay(self.buy_config.idx)
    end
end

-- 购买礼包返回 
function ExoticAdventureGiftPageLayer:updataGift()
	-- 直接关闭页面
	local ctr = ExoticAdventureGiftPageCtr:instance()
	ctr:closeWindow()
end

-----------------------------------------------------------------------------
function ExoticAdventureGiftPageCtr:onCreate()
	self:setCCBIPath("ccbi/ExoticAdventureGiftPageLayer.ccbi")
	self:setIsSingle(false)
end

function ExoticAdventureGiftPageCtr:getLayerClass()
	return ExoticAdventureGiftPageLayer
end

function ExoticAdventureGiftPageCtr:getAchievementLayer()
	return self.layer
end

function ExoticAdventureGiftPageCtr:openWindow()
	if self:isOpened() then
		return
	end
	self:loadLayer()
	self:open()
end

function ExoticAdventureGiftPageCtr:initData()

end

return ExoticAdventureGiftPageCtr


