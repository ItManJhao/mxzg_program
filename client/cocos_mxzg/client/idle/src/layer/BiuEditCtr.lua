local BiuEditCtr = class("BiuEditCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local BiuEditLayer = class("BiuEditLayer", require("src.comp.EventLayer"))

function BiuEditLayer:onCreate()
    self:addBlackBackground()

    local size = self.spr_input_bg:getContentSize()
    size = cc.size(size.width - 20, size.height - 30)
	self.edit_box = ccui.EditBox:create(size, "other/spr-null.png", 1)
	self.edit_box:setPosition(self.spr_input_bg:getPositionX() + 10, self.spr_input_bg:getPositionY() - 10)
	-- self.selectCount:anch(cc.p(0.5,0.5))
	self.edit_box:setAnchorPoint(cc.p(0,1))
	self.edit_box:setFontSize(22)
    self.edit_box:setFontColor(cc.c3b(122, 71, 45))
    self.edit_box:setPlaceholderFontSize(22)
	self.edit_box:setPlaceHolder(ex.Tools:getLang(47572))
	self.edit_box:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
	self.edit_box:setInputMode(cc.EDITBOX_INPUT_MODE_ANY) 
	-- self.edit_box:registerScriptEditBoxHandler(handler(self,self.editboxHandle))
    self:addChild(self.edit_box)
end

-- function BiuEditLayer:editboxHandle()

-- end

-----------------------------------------------------------------------------
function BiuEditCtr:onCreate()
	self:setCCBIPath("ccbi/BiuEditLayer.ccbi")
	self:setIsSingle(false)
end

function BiuEditCtr:getLayerClass()
	return BiuEditLayer
end

function BiuEditCtr:openWindow(res_need, callback)
	if self:isOpened() then
		return
	end

    self.res_need = res_need
    self.callback = callback

	self:loadLayer()
	self:open()
	self:initData()
end

function BiuEditCtr:initData()
    self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))

    ex.Tools:setSpriteFrame(self.layer.spr_res, cfg.item.item[self.res_need.item_type].icon..".png")
    self.layer.lbl_res:setString(self.res_need.item_num)
end

function BiuEditCtr:onConfirm()
    local text = string.gsub(self.layer.edit_box:getText(), "\r", "")
    text = string.gsub(text, "\n", "")
    text = string.gsub(text, "\r\n", "")
    if string.len(text) <= 0 then
        ex.MessageView:add(ex.Tools:getLang(47499))
        return
    end

    local cut_name = cpp.StringUtil:cutNameWithLength(text, 40, 1, 1) 
    if text ~= cut_name then
        ex.MessageView:add(ex.Tools:getLang(34110))
        return
    end

    -- 判断资源是否足够
    if ex.Tools:hasItem(self.res_need.item_type, self.res_need.item_num, false) == false then
        return
    end

    if self.callback(text) then
        self:closeWindow()
    end
end

return BiuEditCtr
