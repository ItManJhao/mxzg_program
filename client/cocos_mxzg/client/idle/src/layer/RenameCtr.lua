local RenameCtr = class("RenameCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local RenameLayer = class("RenameLayer", require("src.comp.EventLayer"))

--------------------------------------------
function RenameLayer:onCreate()
	self:setAutoClose(false)
	-- self:setSwallowTouches(false)
    self:addBlackBackground()   
    
	self.edit_box_name = ccui.EditBox:create(cc.size(self.spr_input_bg:getContentSize().width * self.spr_input_bg:getScaleX() - 40,
													 self.spr_input_bg:getContentSize().height * self.spr_input_bg:getScaleY()),
													 "other/spr-null.png",1)  --输入框尺寸，背景图片
    self.edit_box_name:setName("set_name")
    self.edit_box_name:setPosition(cc.p(self.spr_input_bg:getPositionX() + 5 - 20, self.spr_input_bg:getPositionY()))
    self.edit_box_name:setAnchorPoint(cc.p(0.5, 0.5))
    self.edit_box_name:setFontSize(26)
    -- self.edit_box_name:setMaxLength(7)
    self.edit_box_name:setFontColor(FONT_BLACK)
    self.edit_box_name:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND) --输入键盘返回类型，done，send，go等
    self.edit_box_name:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE) --输入模型，如整数类型，URL，电话号码等，会检测是否符合
    self.edit_box_name:registerScriptEditBoxHandler(handler(self, self.editboxHandle)) --输入框的事件，主要有光标移进去，光标移出来，以及输入内容改变等
    -- self.edit_box_name:setText("")
    -- self.edit_box_name:setText("")
    -- self.edit_box_name:setPlaceHolder(ex.Tools:getLang(47509))
    self:addChild(self.edit_box_name, 9999)
    self:addEvent(EVENT.RAND_NAME.RAND_NAME, handler(self, self.randName))
end

function RenameLayer:randName(event, str_name)
    self.edit_box_name:setText(str_name)
end

function RenameLayer:editboxHandle(event, sender)
	-- print(event)
    if event == "ended" then
    	-- local str_name = sender:getText()
        -- for i=1,#str_name do
        --     print("src", i, string.sub(str_name, i, i) )
        -- end
    	-- str_name = cpp.StringUtil:cutNameWithLength(str_name, NAME_LENGTH, 3.57, 4.1)
        -- print("str_name", str_name)
    	-- sender:setText(str_name)
    end
end

-----------------------------------------------------------------------------
function RenameCtr:onCreate()
	self:setCCBIPath("ccbi/RenameLayer.ccbi")
	self:setIsSingle(false)
end

function RenameCtr:getLayerClass()
	return RenameLayer
end

function RenameCtr:getRenameLayer()
	return self.layer
end

function RenameCtr:openWindow()
	if self:isOpened() then
		return
	end
	local sfc = cc.SpriteFrameCache:getInstance()
	self:loadLayer()
	self:open()
	self:initData()
end

function RenameCtr:initData()
	self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))
    self.layer.btn_rand:registerScriptTapHandler(handler(self, self.onRandName))
    
    self:onRandName()
end

function RenameCtr:onConfirm(tag, pSender)
    local layer = self.layer 
    self.str_name = layer.edit_box_name:getText()
    -- local name_len = cpp.StringUtil:getStringLetterCount(self.str_name)

    -- 英文占3.5长度。中文占4.1长度
    local cut_name = cpp.StringUtil:cutNameWithLength(self.str_name, ex.Tools:getSysCfg("player_name_length"), 3.57, 4.1) 
    if self.str_name ~= cut_name then
        ex.MessageView:add(ex.Tools:getLang(1536))
        return 
    end

    -- self.str_name = cpp.StringUtil:cutNameWithLength(self.str_name, NAME_LENGTH, 3.57, 4.1) -- 3.57
    local req_rename = Role_pb.GReqRoleEditNick()
    req_rename.nick = self.str_name
    NetManager:sendMessage(ProtocolID.GReqRoleEditNick, req_rename)
end

function RenameCtr:onRandName()
    local req_rand_name = Role_pb.GReqRoleRandNick()
    NetManager:sendMessage(ProtocolID.GReqRoleRandNick, req_rand_name)
end

function RenameCtr:renameDone()
    ex.Player.nick = self.str_name
    ex.MainSceneCtr:setNick(self.str_name)
    cpp.MainSceneCtr:instance():renameDone()
    
    self:closeWindow(nil, nil)
end


return RenameCtr
