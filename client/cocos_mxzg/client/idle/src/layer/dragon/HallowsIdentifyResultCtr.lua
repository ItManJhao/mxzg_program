local HallowsIdentifyResultCtr = class("HallowsIdentifyResultCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HallowsIdentifyResultLayer = class("HallowsIdentifyResultLayer", require("src.comp.EventLayer"))

function HallowsIdentifyResultLayer:onCreate()
    self:setAutoClose(true)
    self:addBlackBackground()
end

-----------------------------------------------------------------------------
function HallowsIdentifyResultCtr:onCreate()
	self:setCCBIPath("ccbi/HallowsIdentifyResultLayer.ccbi")
	self:setIsSingle(false)
end

function HallowsIdentifyResultCtr:getLayerClass()
	return HallowsIdentifyResultLayer
end

function HallowsIdentifyResultCtr:openWindow(data)
	if self:isOpened() then
		return
	end
	
	if data == nil then
		return
	end
    
	self:loadLayer()
	self:open()
	self:initData(data)
end

function HallowsIdentifyResultCtr:initData(data)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	self.layer.btn_go:registerScriptTapHandler(handler(self, self.onGo))
	
    ex.AudioManager:playEffect("music/item-get.mp3")

	local config_item = cfg.item.item[data.type]
	local config_relic = cfg.dragonrelic.dragonrelic[data.type]
	
	self.layer.spr_item_icon:setSpriteFrame(config_item.icon..".png")

	local str_rare = ""
	if config_relic.rare == 1 then
		str_rare = ex.Tools:getLang(74576)
	elseif config_relic.rare == 2 then
		str_rare = ex.Tools:getLang(74575)
	else
		str_rare = ex.Tools:getLang(74574)
	end
	self.layer.lbl_item_name:setString(ex.Tools:getLang(config_item.name).."\n"..SPLIT_CHAR.."\n"..str_rare)

	self.layer.lbl_item_desc:setString(ex.Tools:getLang(config_relic.features))

	ex.Tools:setSpriteFrame(self.layer.spr_light, string.format("dragon/identify-result/spr-light-%d.png", config_relic.rare))
end

function HallowsIdentifyResultCtr:onGo(tag, pSender)
    -- 进行跳转
	ex.JumpManager:jumpByAtom("backpack_hallows")
	
	self:closeWindow()
end

return HallowsIdentifyResultCtr