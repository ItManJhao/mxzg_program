local DragonPrivilegeCtr = class("DragonPrivilegeCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local DragonPrivilegeLayer = class("DragonPrivilegeLayer", require("src.comp.EventLayer"))

function DragonPrivilegeLayer:onCreate()
    self:setAutoClose(true)
    self:addBlackBackground()
end

-----------------------------------------------------------------------------
function DragonPrivilegeCtr:onCreate()
	self:setCCBIPath("ccbi/DragonPrivilegeLayer.ccbi")
	self:setIsSingle(false)
end

function DragonPrivilegeCtr:getLayerClass()
	return DragonPrivilegeLayer
end

function DragonPrivilegeCtr:openWindow()
	if self:isOpened() then
		return
    end
    
	self:loadLayer()
	self:open()
	self:initData()
end

function DragonPrivilegeCtr:initData()
    self.layer.btn_go:registerScriptTapHandler(handler(self, self.onActivate))

    self:updateLayer()
end

function DragonPrivilegeCtr:updateLayer()

end

function DragonPrivilegeCtr:onActivate(tag, pSender)
    -- 进行跳转
    local open,layer = ex.JumpManager:jumpByAtom("act_privilege_shop")
	if not open then return end
	self:closeWindow()
end

return DragonPrivilegeCtr