local CrusadeGroupRenameCtr = class("CrusadeGroupRenameCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local CrusadeGroupRenameLayer = class("CrusadeGroupRenameLayer", require("src.comp.EventLayer"))
--------------------------------------------
function CrusadeGroupRenameLayer:onCreate()
    self:addBlackBackground()

    self.lbl_title:setString(ex.Tools:getLang(54101))
    self.btn_confirm:setLabelText(ex.Tools:getLang(54103))

    -- 创建输入框
    self.edit_box_name =
        ccui.EditBox:create(
        cc.size(self.spr_input_bg:getContentSize().width * self.spr_input_bg:getScaleX() - 8, self.spr_input_bg:getContentSize().height * self.spr_input_bg:getScaleY()),
        "other/spr-null.png",
        1
    ) --输入框尺寸，背景图片
    self.edit_box_name:setName("set_name")
    self.edit_box_name:setPosition(cc.p(self.spr_input_bg:getPositionX() + 1, self.spr_input_bg:getPositionY()))
    self.edit_box_name:setAnchorPoint(cc.p(0.5, 0.5))
    self.edit_box_name:setFontSize(26)
    -- self.edit_box_name:setMaxLength(7)
    self.edit_box_name:setFontColor(FONT_BLACK)
    self.edit_box_name:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND) --输入键盘返回类型，done，send，go等
    self.edit_box_name:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE) --输入模型，如整数类型，URL，电话号码等，会检测是否符合
    self.edit_box_name:registerScriptEditBoxHandler(handler(self, self.editboxHandle)) --输入框的事件，主要有光标移进去，光标移出来，以及输入内容改变等
    self.edit_box_name:setPlaceHolder(ex.Tools:getLang(54102))
    self:addChild(self.edit_box_name, 9999)
end

function CrusadeGroupRenameLayer:editboxHandle(event, sender)
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
function CrusadeGroupRenameCtr:onCreate()
    self:setCCBIPath("ccbi/CrusadeGroupRenameLayer.ccbi")
    self:setIsSingle(false)
end

function CrusadeGroupRenameCtr:getLayerClass()
    return CrusadeGroupRenameLayer
end

function CrusadeGroupRenameCtr:openWindow()
    if self:isOpened() then
        return
    end
    local sfc = cc.SpriteFrameCache:getInstance()
    self:loadLayer()
    self:open()
    self:initData()
end

function CrusadeGroupRenameCtr:initData()
    self.layer:addEvent(EVENT.CRUSADE_GROUP.GROUP_RENAME, handler(self, self.renameDone))

    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))
end

function CrusadeGroupRenameCtr:onConfirm(tag, pSender)
    local layer = self.layer
    self.str_name = layer.edit_box_name:getText()

    if self.str_name == nil or string.len(self.str_name) <= 0 then
        ex.MessageView:add(ex.Tools:getLang(47266))
        return
    end
    if self.str_name == ctr.crusade_group.data.game_data.crusade_group_info.group_name then
        ex.MessageView:add(ex.Tools:getLang(54104))
        return
    end

    -- 英文占3.5长度。中文占4.1长度
    -- self.str_name = cpp.StringUtil:cutNameWithLength(self.str_name, NAME_LENGTH, 3.57, 4.1) -- 3.57
    local cut_name = cpp.StringUtil:cutNameWithLength(self.str_name, ex.Tools:getSysCfg("group_name_length"), 3.57, 4.1)
    if self.str_name ~= cut_name then
        ex.MessageView:add(ex.Tools:getLang(1536))
        return
    end

    --角色的改名
    local req = CrusadeGroup_pb.GReqGroupRename()
    req.name = self.str_name
    NetManager:sendMessage(ProtocolID.GReqGroupRename, req)
end

function CrusadeGroupRenameCtr:renameDone()
    if self.layer == nil then
        return
    end

    self:closeWindow(nil, nil)
end

return CrusadeGroupRenameCtr
