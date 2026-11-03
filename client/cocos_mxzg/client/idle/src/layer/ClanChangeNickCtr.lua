local ClanChangeNickCtr = class("ClanChangeNickCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ClanChangeNickLayer = class("ClanChangeNickLayer", require("src.comp.EventLayer"))
local type = 1
--------------------------------------------
function ClanChangeNickLayer:onCreate()
    self:addBlackBackground()

    self.lbl_title:setString(ex.Tools:getLang(54108))
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
    self.edit_box_name:setFontColor(FONT_BLACK)
    self.edit_box_name:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND) --输入键盘返回类型，done，send，go等
    self.edit_box_name:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE) --输入模型，如整数类型，URL，电话号码等，会检测是否符合
    self.edit_box_name:registerScriptEditBoxHandler(handler(self, self.editboxHandle)) --输入框的事件，主要有光标移进去，光标移出来，以及输入内容改变等
    self.edit_box_name:setPlaceHolder(ex.Tools:getLang(54109))
    self:addChild(self.edit_box_name, 9999)
    -- 设置所需资源
    local item_res = ex.Tools:getSysCfg("clan_renaming_card")[1]
    self.spr_res:setSpriteFrame("" .. cfg.item.item[item_res.item_type].icon .. ".png")
    self.lbl_res:setString(ex.StringUtil.getScientificNumber(item_res.item_num))
end

function ClanChangeNickLayer:editboxHandle(event, sender)
    if event == "ended" then
    end
end

-----------------------------------------------------------------------------
function ClanChangeNickCtr:onCreate()
    self:setCCBIPath("ccbi/ClanChangeNickLayer.ccbi")
    self:setIsSingle(false)
end

function ClanChangeNickCtr:getLayerClass()
    return ClanChangeNickLayer
end

function ClanChangeNickCtr:getChangeNickLayer()
    return self.layer
end

function ClanChangeNickCtr:openWindow()
    if self:isOpened() then
        return
    end
    local sfc = cc.SpriteFrameCache:getInstance()
    self:loadLayer()
    self:open()
    self:initData()
end

function ClanChangeNickCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))
end

function ClanChangeNickCtr:onConfirm(tag, pSender)
    local layer = self.layer
    self.str_name = layer.edit_box_name:getText()
    -- local name_len = cpp.StringUtil:getStringLetterCount(self.str_name)
    local item_res = ex.Tools:getSysCfg("clan_renaming_card")[1]
    if ex.Player:getItemNum(item_res.item_type) < item_res.item_num then
        ex.MessageView:add(string.format(ex.Tools:getLang(1108), ex.Tools:getLang(cfg.item.item[item_res.item_type].name)))
        return
    end
    if self.str_name == nil or string.len(self.str_name) <= 0 then
        ex.MessageView:add(ex.Tools:getLang(47266))
        return
    end
    if self.str_name == ex.Player.clan_data.clan_name then
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
    --公会的改名
        local req_r111 = Clan_pb.GReqClanRenamingCard()
        req_r111.nick = self.str_name
        NetManager:sendMessage(ProtocolID.GReqClanRenamingCard, req_r111)
        return
end

function ClanChangeNickCtr:renameDone()
    if self.layer == nil then
        return
    end

    self:closeWindow(nil, nil)
end

return ClanChangeNickCtr
