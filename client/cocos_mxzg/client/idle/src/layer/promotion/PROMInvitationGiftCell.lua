local PROMInvitationGiftCell = class("PROMInvitationGiftCell", require("src.comp.LuaLayerBase"))

local string_format = string.format
function PROMInvitationGiftCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)


    self.item_menu = cpp.UIMenu:create()
    :setPosition(cc.p(0, 0))
    self:addChild(self.item_menu)

    self.role_num = 0
end



function PROMInvitationGiftCell:setRedPoint(bool)
	ex.Tools:addRedPoint(self.btn_submit,bool)
end


function PROMInvitationGiftCell:setBtnString()
    ex.Tools:addRedPoint(self.btn_done, false )
    local strText = ""
    if self.data.now_limit <  self.data.gain_limit  and  self.data.now_limit == self.data.max_limit  then
        strText = ex.Tools:getLang(2214) -- 领取
        self.btn_done:setNormalImage(cc.Sprite:createWithSpriteFrameName("button/btn-orange-3.png"))
        self.btn_done:setEnabled(false)
    elseif self.data.now_limit <  self.data.gain_limit  and  self.data.now_limit < self.data.max_limit then
        strText = ex.Tools:getLang(2214) -- 领取
        
        ex.Tools:addRedPoint(self.btn_done, true )
    else 
        strText = ex.Tools:getLang(2214) -- 领取
        self.btn_done:setNormalImage(cc.Sprite:createWithSpriteFrameName("button/btn-orange-3.png"))
        self.btn_done:setEnabled(false)
    end

    self.lbl_btn_submit = cc.Label:createWithTTF(strText, FONT_DEFAULT_NAME_BOLD, 36)

    self.lbl_btn_submit:setScale(0.5)
    self.btn_done:addChild(self.lbl_btn_submit)
    self.lbl_btn_submit:setPosition(self.btn_done:getContentSize().width * 0.5, self.btn_done:getContentSize().height * 0.5 )
    self.lbl_btn_submit:setTextColor(FONT_WHITE_C4B)
    self.lbl_btn_submit:enableOutline(FONT_RED, 3)

    self.btn_done:registerScriptTapHandler(handler(self, self.onClickSubmit))
    --self.btn_done:setScale(1)
end


function PROMInvitationGiftCell:checkGet()
    local  bool = false 
    if self.data.now_limit <  self.data.gain_limit  and  self.data.now_limit < self.data.max_limit  then 
        bool = true
    end 
    return bool 
end 



function PROMInvitationGiftCell:onClickSubmit(tag,pSender)

    -- 判断获取状态
    if self:checkGet() then 
        ex.Player.promotion_data:reqInvitationGift(self.data.idx)
        
        ex.Player.promotion_data:setInvitationGidtList(self.data.idx, self.data.now_limit + 1, self.data.max_limit)

        ex.EventManager:fire(EVENT.MAIN_CITY_LEVEL_UP.ACTIVITY_IS_SUCCESS)
    else 
        ex.MessageView:add(ex.Tools:getLang(47126))
    end 
end


function PROMInvitationGiftCell:setTableView(table)
    self.tableView = table
    self.item_menu:setIsTouchInsideNode(self.tableView)
end


function PROMInvitationGiftCell:onClick(tag,pSender)
	-- print(self.__cname,"onClick")
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function PROMInvitationGiftCell:updateItem( award_list)

    local goods_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()
    goods_size.width = goods_size.width * 0.75 + 10

    local begin = 24
    local margin = 5
    local posY = 55
    local scale = 0.75
    for i,v in ipairs(award_list) do
        local item = ex.Player.backpack_data:createWithData(v.item_type, v.item_num)
        local posX = (begin + item:getContentSize().width * scale / 2) + (i - 1) * ((item:getContentSize().width * scale) + margin)
    	
        item:setPosition(posX, posY)
        item:setScale(scale)
        item:registerScriptTapHandler(handler(self, self.onClick))
        self.item_menu:addChild(item)
    end

end




function PROMInvitationGiftCell:reset(data)

    self.lbl_msg:setFontSize(32)

    if not data then print("not data") return end
    self.data = data
    
    self:updateItem(data.reward)

    local str = string_format("(%d/%d)", data.now_limit, data.gain_limit)
    self.lbl_completed:setString(str)

    if  data.type == 1 then 
        self.lbl_msg:setString(string_format(ex.Tools:getLang(41058), data.num))
    else 
        self.lbl_msg:setString(string_format(ex.Tools:getLang(41059), (data.num * 0.01)))
    end 

    


    if data.now_limit > data.gain_limit   then 
        self.btn_done:setVisible(false)
        self.spr_get:setVisible(true)
    else
        self.spr_get:setVisible(false)
        self.btn_done:setVisible(true)
    end
    
    self:setBtnString()
end



return PROMInvitationGiftCell