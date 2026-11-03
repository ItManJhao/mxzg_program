local PROMWarOrderTaskCell = class("PROMWarOrderTaskCell", require("src.comp.EventLayer"))
local ITEM_SCALE = 0.8

function PROMWarOrderTaskCell:onCreate()
    self.menu = cpp.UIMenu:create()
    self:addChild(self.menu)
    self.menu:setPosition(0,0)
    self:setBtnString()
    self.btn_submit:setVisible(false)
    self:createRichTitle()
end

function PROMWarOrderTaskCell:setTableView(table)
    self.menu:setIsTouchInsideNode(table)
    self.menu:setSwallowsTouches(false)
    self.btn_menu:setIsTouchInsideNode(table)
    self.btn_menu:setSwallowsTouches(false)
end

function PROMWarOrderTaskCell:createRichTitle( )
    local x,y = self.rich_node:getPosition()
    self.lbl_title = cpp.RichTextEx:createWithXMLLua("")
	self.lbl_title:setFontSize(44)
	self.lbl_title:setScale(0.5)
	self.lbl_title:setFontFace(FONT_DEFAULT_NAME_BOLD)
	self.lbl_title:setFontColor("#7A472D")
	self.lbl_title:setAnchorTextShadow(false)
	self.lbl_title:setAnchorPoint(ex.a.left_center)
    self.lbl_title:setPosition(cc.p(x,y))
    self.lbl_title:setLocalZOrder(10)
    self:addChild(self.lbl_title)
end

function PROMWarOrderTaskCell:setBtnString()
    self.lbl_btn_submit = cc.Label:createWithTTF(ex.Tools:getLang(47037), FONT_DEFAULT_NAME_BOLD, 21)
    self.btn_submit:addChild(self.lbl_btn_submit)
    self.lbl_btn_submit:setPosition(self.btn_submit:getContentSize().width * 0.5, self.btn_submit:getContentSize().height * 0.5)
    self.lbl_btn_submit:enableOutline(FONT_BROWN, 1)
    self.btn_submit:registerScriptTapHandler(handler(self, self.onClickSubmit))

    self.lbl_btn_goto = cc.Label:createWithTTF(ex.Tools:getLang(47627), FONT_DEFAULT_NAME_BOLD, 21)
    self.btn_goto:addChild(self.lbl_btn_goto)
    self.lbl_btn_goto:setPosition(self.btn_goto:getContentSize().width * 0.5, self.btn_goto:getContentSize().height * 0.5)
    self.lbl_btn_goto:enableOutline(FONT_DARK_BLUE, 1)
    self.btn_goto:registerScriptTapHandler(handler(self, self.onClickGoto))
end

function PROMWarOrderTaskCell:onClickGoto(tag, pSender)
    if self.data.jump_info.event_type == 1 then 
        ex.JumpManager:jumpByAtom(self.data.jump_info.event_arg)
        require("src.layer.promwarorder.PROMWarOrderHallCtr"):instance():closeWindow()
    else
        ex.MessageView:add(ex.Tools:getLang(self.data.jump_info.no_jump_hint))
    end
end

function PROMWarOrderTaskCell:onClickSubmit(tag,pSender)

    local geted = ex.Player.promotion_data.prom_war_order_data:getTaskById(self.data.idx)
    local has_num = ex.Player.promotion_data.prom_war_order_data:getTaskProgressById(self.data.idx)

    local can_get = has_num >= self.data.mission.target  
    local can_jump = self.data.jump_info.event_type == 1
    if not can_jump then 
        if not can_get or geted then 
            ex.MessageView:add(ex.Tools:getLang(47252))
            return 
        end
    end
	local req_daily = Promotion090_pb.GReqTPermitTaskReward()
	req_daily.idx = self.data.idx
	NetManager:sendMessage(ProtocolID.GReqTPermitTaskReward,req_daily)
end

function PROMWarOrderTaskCell:reset(data)
    if not data then return end 
    self.data = data

    self.menu:removeAllChildren()

    local geted = ex.Player.promotion_data.prom_war_order_data:getTaskById(data.idx)
    local can_get = not geted and ex.Player.promotion_data.prom_war_order_data:getTaskProgressById(data.idx) >= data.mission.target 
    -- local status = 0
    local can_jump = data.jump_info.event_type == 1
    self.btn_submit:setVisible(can_get)
    self.btn_goto:setVisible(not can_get and not geted)
    self.spr_geted:setVisible(ex.Player.promotion_data.prom_war_order_data:getTaskById(data.idx) == true)
	-- self.btn_submit:setVisible(can_get and status < 1)
    -- self.btn_goto:setVisible(not can_get and status < 1)

    if not can_jump then 
        self.btn_submit:setVisible(not geted)
        self.btn_goto:setVisible(false) 
    end 


    local str = ex.Tools:taskString(data.lang,data.mission.target,data.mission.condition)
    self.lbl_title:setXmlTextLua(str)

    if data.exp ~= "" and table.nums(data.exp) > 0 then 
        local exp_item = data.exp[1]
        local pos_x,pos_y = self.reward_node:getPosition()
        local base_item = ex.Tools:createBackpackItem(exp_item.item_type, exp_item.item_num)
        self.menu:addChild(base_item)
        base_item:setPosition(pos_x,pos_y)
        base_item:registerScriptTapHandler(handler(self,self.onBase))
        base_item:setScale(ITEM_SCALE)
    end

    local str = string.format( "(%s/%s)",ex.Tools:convertNumToStr(ex.Player.promotion_data.prom_war_order_data:getTaskProgressById(data.idx)),ex.Tools:convertNumToStr(data.mission.target))
    self.lbl_desc:setString(str)
end

function PROMWarOrderTaskCell:onBase(tag,pSender)
    ex.Tools:showItemInfo(tag, pSender)
end

return PROMWarOrderTaskCell