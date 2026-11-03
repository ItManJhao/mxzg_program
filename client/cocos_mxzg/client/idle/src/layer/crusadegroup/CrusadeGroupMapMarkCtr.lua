local CrusadeGroupMapMarkCtr = class("CrusadeGroupMapMarkCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local CrusadeGroupMapMarkLayer = class("CrusadeGroupMapMarkLayer", require("src.comp.EventLayerAdaptiveWidth"))

function CrusadeGroupMapMarkLayer:onCreate()
    self:addBlackBackground()

    self.idx = 0
    
    -- // 高度不够会导致文字不会右移
    self.edit_box = ccui.EditBox:create(self.spr_input_bg:getContentSize(), "other/spr-null.png", 1)
    self.edit_box:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    self.edit_box:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    self.edit_box:registerScriptEditBoxHandler(handler(self, self.editboxHandle))
    self.edit_box:setFontSize(26)
    self.edit_box:setFontColor(FONT_BROWN)
    self.edit_box:setPosition(cc.p(self.spr_input_bg:getPositionX() + self.spr_input_bg:getContentSize().width * 0.5,
                                   self.spr_input_bg:getPositionY() + self.spr_input_bg:getContentSize().height * 0.5))

    self:addChild(self.edit_box, 99)
end

function CrusadeGroupMapMarkLayer:editboxHandle()
    
end

function CrusadeGroupMapMarkLayer:onConfirm()
    local req = CrusadeGroup_pb.GReqMark()
    req.territory_id = self.idx
    req.name = self.edit_box:getText()
    NetManager:sendMessage(ProtocolID.GReqMark, req)

    CrusadeGroupMapMarkCtr:instance():closeWindow()
end

function CrusadeGroupMapMarkLayer:onCancel()
    CrusadeGroupMapMarkCtr:instance():closeWindow()
end


-----------------------------------------------------------------------------
function CrusadeGroupMapMarkCtr:onCreate()
	self:setCCBIPath("ccbi/CrusadeGroupMapMarkLayer.ccbi")
	self:setIsSingle(false)
end

function CrusadeGroupMapMarkCtr:getLayerClass()
	return CrusadeGroupMapMarkLayer
end

function CrusadeGroupMapMarkCtr:getCrusadeGroupMapMarkLayer()
	return self.layer
end

function CrusadeGroupMapMarkCtr:openWindow(idx)
	if self:isOpened() then
		return
	end
	
	self:loadLayer()
    self:open()

    self:initData(idx)
end

function CrusadeGroupMapMarkCtr:initData(idx)
    self.layer.idx = idx
    local building_config = cfg.crusadegroupbuild.getConfig(idx)
    if not building_config then
        return
    end

    self.layer.lbl_num:setString(string.format(ex.Tools:getLang(77949), #ctr.crusade_group.data.game_data.territory_mark, ex.Tools:getSysCfg("crusade_group_coordinate")))
    self.layer.edit_box:setText(ex.Tools:getLang(building_config.name))

end

return CrusadeGroupMapMarkCtr
