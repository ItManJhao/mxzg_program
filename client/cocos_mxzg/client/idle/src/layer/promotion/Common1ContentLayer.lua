--[[
    func: 通用1号模板Cell层
    author:徐东浩
    time:2019-10-19 22:56:30
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local Common1ContentLayer = class("Common1ContentLayer", require("src.comp.LuaLayerBase"))
local CommonUIHelper = require("src.layer.promotion.CommonUIHelper")

function Common1ContentLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.Owner = nil
    self.ID = 0         -- 前后端活动类型id
    self.config = nil
    self.ui_layout_arg = nil
    self.data = nil

    self.total_progress = 0
    self.items = {}

    self.item_menu = nil

    self.item_btn_status = CommonUIDefine.ItemBtnStatus.NONE

    self.title = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(46)
	:setScale(0.5)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#613c19")
	:setAnchorTextShadow(false)
	-- :ignoreContentAdaptWithSize(false)
	-- :setWrapMode(1)
	:setAnchorPoint(ex.a.left_center)
    :setPosition(ex.Tools:getAbsolutePosition(cc.p(15, 125), CommonUIDefine.UIDefine.ComponentOriginType.LEFT_BOTTOM, self))
    :setLocalZOrder(10)
    self:addChild(self.title)
    
    self.btn_do:registerScriptTapHandler(handler(self, self.onBtnClick))
end

function Common1ContentLayer:onCreateDone(owner, ui_layout_arg, config, data, id)
    self.Owner = owner
    self.ID = id
    self.config = config
    self.ui_layout_arg = ui_layout_arg
    self.data = data

    self:refreshBtnStatus()

    -- 加载窗体定制内容
    CommonUIHelper:ParseWinLayoutArgs(self.ui_layout_arg, self)

    self:refresh()
end

function Common1ContentLayer:refreshBtnStatus()
    if self.data ~= nil then
        if self.data.is_got then
            self.item_btn_status = CommonUIDefine.ItemBtnStatus.GOT
        elseif self.data.progress >= self.config.target_num then
            self.item_btn_status = CommonUIDefine.ItemBtnStatus.GET
        else
            if self.config.jump_info.event_type ~= 0 then
                self.item_btn_status = CommonUIDefine.ItemBtnStatus.JUMP
            else
                self.item_btn_status = CommonUIDefine.ItemBtnStatus.HINT
            end
        end
    else
        self.item_btn_status = CommonUIDefine.ItemBtnStatus.NONE
    end
end

function Common1ContentLayer:setIsTouchInsideNode(scroll_view)
    if scroll_view ~= nil then
        if self.menu ~= nil then
            self.menu:setSwallowsTouches(false)
            self.menu:setIsTouchInsideNode(scroll_view)
        end
        if self.item_menu ~= nil then
            self.item_menu:setIsTouchInsideNode(scroll_view)
        end
    end
end

function Common1ContentLayer:refresh()
    self.num_lab:setString(string.format("(%d/%d)", self.data.progress, self.config.target_num))

    self.title:setXmlTextLua(ex.Tools:getLang(self.config.title))

    self.btn_do:setVisible(self.item_btn_status ~= CommonUIDefine.ItemBtnStatus.GOT)
    self.spr_got:setVisible(self.item_btn_status == CommonUIDefine.ItemBtnStatus.GOT)

    if self.item_btn_status ~= CommonUIDefine.ItemBtnStatus.GOT then
        if self.item_btn_status ~= CommonUIDefine.ItemBtnStatus.GET then
            self.btn_do:setLabelText(ex.Tools:getLang(self.config.btn_undone))
            ex.Tools:addRedPoint(self.btn_do, false)
        else
            self.btn_do:setLabelText(ex.Tools:getLang(self.config.btn_done))
            ex.Tools:addRedPoint(self.btn_do, true)
        end
    else
        ex.Tools:addRedPoint(self.btn_do, false)
    end

    self:createMenuWithItem()
end

function Common1ContentLayer:onBtnClick(tag ,pSender)
    if self.item_btn_status == CommonUIDefine.ItemBtnStatus.GET then
        if not ex.Player.promotion_data:checkCommonActivityIsOpen(self.ID) then
            ex.MessageView:add(ex.Tools:getLang(47324))
            return
        end

        -- 发送领取协议
        local req_get = Task4_pb.GReqActivityItemGet()
        req_get.activity_idx = self.ID
        req_get.idx = self.config.idx

        NetManager:sendMessage(ProtocolID.GReqActivityItemGet, req_get)
    elseif self.item_btn_status == CommonUIDefine.ItemBtnStatus.JUMP then
        CommonUIHelper:onEventDispatcher(self.config.jump_info.event_type, self.config.jump_info.event_arg)
    elseif self.item_btn_status == CommonUIDefine.ItemBtnStatus.HINT then
        if self.config.jump_info.no_jump_hint ~= nil and self.config.jump_info.no_jump_hint ~= 0 then
            ex.MessageView:add(ex.Tools:getLang(self.config.jump_info.no_jump_hint))
        end
    end
end

function Common1ContentLayer:createMenuWithItem()
    -- body
    self.item_menu = cpp.UIMenu:create()
    self.item_menu:setSwallowsTouches(false)
    self.item_menu:setLocalZOrder(10)
    self.item_menu:setPosition(0,0)
    self:addChild(self.item_menu)

    local begin = 24
    local margin = 5
    local posY = 55
    local scale = 0.75
    for i,v in ipairs(self.config.finish_reward) do
        local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
        local posX = (begin + item:getContentSize().width * scale / 2) + (i - 1) * ((item:getContentSize().width * scale) + margin)
        item:setPosition(posX, posY)
        item:setScale(scale)
        item:registerScriptTapHandler(handler(self, self.onClick))
        item:setLocalZOrder(i * 10)
        self.item_menu:addChild(item)
        self.items[i] = item
    end
end

function Common1ContentLayer:onClick(tag,pSender)
	-- print(self.__cname,"onClick")
    ex.Tools:onClickItemInfo(pSender.item_type)
end

return Common1ContentLayer