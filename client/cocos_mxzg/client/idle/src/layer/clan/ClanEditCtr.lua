local ClanEditCtr = class("ClanEditCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ClanEditLayer = class("ClanEditLayer", require("src.comp.EventLayer"))

function ClanEditLayer:onCreate()
    self:setAutoClose(true)
    self:setSwallowTouches(true)
    self:addBlackBackground()

    self.btn_confirm:setLabelText(ex.Tools:getLang(47170))
    self.btn_confirm:setLabelShadow(FONT_BLACK_C4B, cc.size(1, -1))

    -- 公会公告输入框
    self.edit_box_notice = ccui.EditBox:create(cc.size(self.spr_notice_bg:getContentSize().width - 20, self.spr_notice_bg:getContentSize().height - 20), "other/spr-null.png", 1)  --输入框尺寸，背景图片
    self.edit_box_notice:setName("clan_info_notice")
    self.edit_box_notice:setPosition(cc.p(self.spr_notice_bg:getPositionX(), self.spr_notice_bg:getPositionY()))
    self.edit_box_notice:setAnchorPoint(cc.p(0.5, 0.5))
    self.edit_box_notice:setFontSize(26)
    self.edit_box_notice:setFontColor(cc.c3b(122,71,45))
    self.edit_box_notice:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND) --输入键盘返回类型，done，send，go等
    self.edit_box_notice:setInputMode(cc.EDITBOX_INPUT_MODE_ANY) --输入模型，如整数类型，URL，电话号码等，会检测是否符合
    self.edit_box_notice:registerScriptEditBoxHandler(handler(self, self.editboxHandle)) --输入框的事件，主要有光标移进去，光标移出来，以及输入内容改变等
    -- self.edit_box_notice:setText(tostring(pre_input_id))
    -- add 熊梦 修改 公会公告
    self.edit_box_notice:setFontName(FONT_DEFAULT_NAME_BOLD)
    self.edit_box_notice:setText(ex.Player.clan_data.clan_notice)
    self:addChild(self.edit_box_notice, 9999)

    self.clan_notice = ex.Player.clan_data.clan_notice
end

function ClanEditLayer:editboxHandle(event, sender)
    local name = sender:getName()

    if name == "clan_info_notice" then
        if event == "return" then
            local str_name = sender:getText()
            if str_name == nil then
                str_name = ""
            end

            str_name = cpp.StringUtil:cutNameWithLength(str_name, 301, 2, 3.57)

            self.clan_notice = str_name
            sender:setText("")

            self.lbl_notice:setString(self.clan_notice)
        elseif event == "began" then
            -- sender:setText(self.lbl_notice:getString())
            -- sender:selectedAll()
            self.lbl_notice:setString("")
        end
    end
end
-----------------------------------------------------------------------------
function ClanEditCtr:onCreate()
    self:setCCBIPath("ccbi/ClanEditLayer.ccbi")
    self:setIsSingle(false)
end

function ClanEditCtr:getLayerClass()
    return ClanEditLayer
end

function ClanEditCtr:getClanEditLayer()
    return self.layer
end

function ClanEditCtr:openWindow()
    if self:isOpened() then
        return
    end

    self:loadLayer()
    self:open()
    self:initData()
end

function ClanEditCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

	self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))

    self.layer.lbl_notice:setString("")

    self.layer.table_view = nil
    -- self:updateTableView()
end

function ClanEditCtr:onConfirm(tag, pSender)
    local str_clan_notice = self.layer.clan_notice
    if str_clan_notice == nil then
        str_clan_notice = ""
    end
    
    flag = ex.StringUtil.checkName(str_clan_notice)
    if flag == false and str_clan_notice ~= "" then
        ex.MessageView:add(ex.Tools:getLang(47284))
        return
    end

    ex.Player.clan_data.clan_notice = str_clan_notice

    local req_edit = Clan_pb.GReqClanChangInfo()
    req_edit.clan_photo = ex.Player.clan_data.clan_photo
    req_edit.clan_desc = str_clan_notice
    NetManager:sendMessage(ProtocolID.GReqClanChangInfo, req_edit)

    NetManager:sendMessage(ProtocolID.GReqClanInfo)

    -- ex.MessageView:add(ex.Tools:getLang(47021), 0)

    self:closeWindow(0, nil)
end

return ClanEditCtr
