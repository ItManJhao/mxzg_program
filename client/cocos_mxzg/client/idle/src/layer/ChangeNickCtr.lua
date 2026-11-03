local ChangeNickCtr = class("ChangeNickCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ChangeNickLayer = class("ChangeNickLayer", require("src.comp.EventLayer"))
--------------------------------------------
function ChangeNickLayer:onCreate()
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
    -- self.edit_box_name:setText("")
    -- self.edit_box_name:setText("")
    -- self.edit_box_name:setPlaceHolder(ex.Tools:getLang(54102))
    self.edit_box_name:setPlaceHolder(ex.Tools:getLang(54102))
    self:addChild(self.edit_box_name, 9999)

    -- self.edit_box_name.m_pCursorSprite:setColor(FONT_BROWN)

    -- 设置所需资源
    --优先使用改名卡
    self.type = 2
    local item_res = ex.Tools:getSysCfg("consumption_props")[1]
    if ex.Player:getItemNum(item_res.item_type) < item_res.item_num then
        item_res = ex.Tools:getSysCfg("nick_change_cost")[1]
        --type判断使用的是那个类型 2 改名卡 1 钻石
        self.type = 1
    end

    ex.Tools:setSpriteFrame(self.spr_res, "" .. cfg.item.item[item_res.item_type].icon .. ".png")
    -- self.spr_res:setSpriteFrame("" .. cfg.item.item[item_res.item_type].icon .. ".png")
    self.lbl_res:setString(ex.StringUtil.getScientificNumber(item_res.item_num))
end

function ChangeNickLayer:editboxHandle(event, sender)
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
function ChangeNickCtr:onCreate()
    self:setCCBIPath("ccbi/ChangeNickLayer.ccbi")
    self:setIsSingle(false)
end

function ChangeNickCtr:getLayerClass()
    return ChangeNickLayer
end

function ChangeNickCtr:getChangeNickLayer()
    return self.layer
end

function ChangeNickCtr:openWindow()
    if self:isOpened() then
        return
    end
    local sfc = cc.SpriteFrameCache:getInstance()
    self:loadLayer()
    self:open()
    self:initData()
end

function ChangeNickCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))
end

function ChangeNickCtr:onConfirm(tag, pSender)
    local layer = self.layer
    self.str_name = layer.edit_box_name:getText()
    -- local name_len = cpp.StringUtil:getStringLetterCount(self.str_name)
    -- 资源是否充足
    if self.layer.type == 1 then
        local item_res = ex.Tools:getSysCfg("nick_change_cost")[1]
        if ex.Player:getItemNum(item_res.item_type) < item_res.item_num then
            ex.MessageView:add(string.format(ex.Tools:getLang(1108), ex.Tools:getLang(cfg.item.item[item_res.item_type].name)))
            return
        end
    end

    if self.str_name == nil or string.len(self.str_name) <= 0 then
        ex.MessageView:add(ex.Tools:getLang(47266))
        return
    end
    if self.str_name == ex.Player.nick then
        ex.MessageView:add(ex.Tools:getLang(54104))
        return
    end

    -- 英文占3.5长度。中文占4.1长度
    -- self.str_name = cpp.StringUtil:cutNameWithLength(self.str_name, NAME_LENGTH, 3.57, 4.1) -- 3.57
    local cut_name = cpp.StringUtil:cutNameWithLength(self.str_name, ex.Tools:getSysCfg("player_name_length"), 3.57, 4.1)
    if self.str_name ~= cut_name then
        ex.MessageView:add(ex.Tools:getLang(1536))
        return
    end
    --角色的改名
    local req_rename = Role_pb.GReqRoleRename()
    req_rename.nick = self.str_name
    req_rename.type = self.layer.type
    NetManager:sendMessage(ProtocolID.GReqRoleRename, req_rename)
end

function ChangeNickCtr:renameDone()
    if self.layer == nil then
        return
    end

    self:closeWindow(nil, nil)
end

return ChangeNickCtr
