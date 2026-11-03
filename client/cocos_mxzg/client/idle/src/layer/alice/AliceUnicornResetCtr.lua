local AliceUnicornResetCtr = class("AliceUnicornResetCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local AliceUnicornResetLayer = class("AliceUnicornResetLayer", require("src.layer.ui.UI_AliceUnicornResetLayer"))
------------------------------------------------
function AliceUnicornResetLayer:onCreate()
	self.super.onCreate(self)
	self:setName("AliceUnicornResetLayer")

	self:addBlackBackground()

	self.lbl_content:setString(string.format(ex.Tools:getLang(580556), ex.Tools:getSysCfg("alice_unicorn_reset_rate")))
	
    self:addEvent(EVENT.ALICE.ALICE_UNICORN_RESET, handler(self, self.updateLayer))
end

function AliceUnicornResetLayer:updateLayer()
	self.scroll_view.createItemFunction = function(data, scale)
        local item = ex.Tools:createBackpackItem(data.item_type, data.item_num)
        item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
        return item
    end
    self.scroll_view:reloadData(self.vec_reward)
end

function AliceUnicornResetLayer:onReset()
	local req = AliceUnicorn_pb.GReqAliceUnicornReset()
	req.hero_id = self.hero_id
	NetManager:sendMessage(ProtocolID.GReqAliceUnicornReset, req)

	self:onClose()
end

-----------------------------------------------
function AliceUnicornResetCtr:loadLayer()
    local tmp_layer = AliceUnicornResetLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function AliceUnicornResetCtr:onCreate()
	self:setIsSingle(false)
end

function AliceUnicornResetCtr:openWindow(hero_id, vec_reward)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
    self:initData(hero_id, vec_reward)
end

function AliceUnicornResetCtr:initData(hero_id, vec_reward)
	self.layer.hero_id = hero_id
	self.layer.vec_reward = vec_reward
	self.layer:updateLayer()
end

return AliceUnicornResetCtr

