--[[
* @Description: 尊贵标识弹框界面
* @Author: 熊梦
* @Date: 2020-06-29 18:42:00
* ]]

local SettingIdentificationCtr = class("SettingIdentificationCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local SettingIdentificationLayer = class("SettingIdentificationLayer", require("src.comp.EventLayerAdaptiveWidthFull"))
-----------------------------------------------------------------------

function SettingIdentificationLayer:onCreate()
	self:addBlackBackground()
	self.level = 1

	
	local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_reward")
    spr_effect:setPosition(self.spr_title:getPositionX(), self.spr_title:getPositionY()-15)
	self:addChild(spr_effect, 20, 100)
end

function SettingIdentificationLayer:registerBtnEvent(event,pSender)
	local event_arg = "main_dress"
	local data = {}
	data[1] = 4
	data[2] = 1
	ex.JumpManager:jumpByAtom(event_arg,data)
	--self:closeWindow()
	local settingIdentification_ctr = SettingIdentificationCtr:instance()
	settingIdentification_ctr:closeWindow()
end

function SettingIdentificationLayer:updateLayer( )
	-- self.image:setSpriteFrame(string.format( "setting-identification/spr-%d-da.png", self.level))  
	ex.Tools:setSpriteFrame(self.image, string.format( "setting-identification/spr-%d-da.png", self.level))

	local con = cfg.peerageemblem.peerageemblem[self.level]

	local str = ""
    for k,v in pairs(con.ability) do
        if k ~= 1 then
            str = str.."    "
        end
        str = str..ex.Tools:getLang(2140000 + v.attr)		
        str = ex.StringUtil.formatAttrStr(str, "##" , v.value)
	end
	
    self.lbl_ability:setString(str)

end
-----------------------------------------------------------------------------
function SettingIdentificationCtr:onCreate()
	self:setCCBIPath("ccbi/SettingIdentificationRewardCell.ccbi")
	self:setIsSingle(false)
end

function SettingIdentificationCtr:getLayerClass()
	return SettingIdentificationLayer
end

function SettingIdentificationCtr:getDiscussLayer()
	return self.layer
end

function SettingIdentificationCtr:openWindow(level)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self.layer.level = level
	self.layer:updateLayer()
end

return SettingIdentificationCtr
