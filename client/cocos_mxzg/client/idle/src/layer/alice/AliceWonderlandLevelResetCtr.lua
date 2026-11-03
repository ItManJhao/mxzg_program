local AliceWonderlandLevelResetCtr = class("AliceWonderlandLevelResetCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local AliceWonderlandLevelResetLayer = class("AliceWonderlandLevelResetLayer", require("src.layer.ui.UI_AliceWonderlandLevelResetLayer"))
------------------------------------------------
function AliceWonderlandLevelResetLayer:onCreate()
	self.super.onCreate(self)
	self:setName("AliceWonderlandLevelResetLayer")
	self:addBlackBackground()
	ex.Tools:setLimitWidth(self.lbl_tips, 580)
end

-----------------------------------------------
function AliceWonderlandLevelResetCtr:loadLayer()
    local tmp_layer = AliceWonderlandLevelResetLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function AliceWonderlandLevelResetCtr:onCreate()
	self:setIsSingle(false)
end

function AliceWonderlandLevelResetCtr:openWindow()
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
    self:initData()
	-- self:runAction(cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(handler(self, self.initData))))
end

function AliceWonderlandLevelResetCtr:initData()
	self.layer.btn_reset:registerScriptTapHandler(handler(self, self.onReset))
end

function AliceWonderlandLevelResetCtr:onReset()
	local is_pass = false
	local a = ctr.alice.data:getLevelIsReset()
	print(a)
	-- for i,v in ipairs(ctr.alice.data:getLevelIsPass()) do
	-- 	if v then
	-- 		is_pass = true
	-- 	end
	-- 	break
	-- end
	if ctr.alice.data:getLevelIsReset() then
		local req = Alice_pb.GReqResetStar()
		req.star = ctr.alice.data.star
		NetManager:sendMessage(ProtocolID.GReqResetStar, req)	
		ex.MessageView:add(ex.Tools:getLang(580576))
		self:closeWindow()
	end
	
	
end

return AliceWonderlandLevelResetCtr

