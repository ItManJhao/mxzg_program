local PROMEveryDayLoginCell = class("PROMEveryDayLoginCell", require("src.comp.LuaLayerBase"))

local string_format = string.format
function PROMEveryDayLoginCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.items = {}

    self.lbl_title = cpp.RichTextEx:createWithXMLLua("")
	self.lbl_title:setFontSize(44)
	self.lbl_title:setScale(0.5)
	self.lbl_title:setFontFace(FONT_DEFAULT_NAME_BOLD)
	self.lbl_title:setFontColor("#613C19")
	self.lbl_title:setAnchorTextShadow(false)
	self.lbl_title:setAnchorPoint(ex.a.left_center)
    self.lbl_title:setPosition(cc.p(self.top_lab:getPositionX(), self.top_lab:getPositionY()))
    self.lbl_title:setLocalZOrder(10)
    self:addChild(self.lbl_title)

end

function PROMEveryDayLoginCell:setBtnString()
    
    local strText = ""
    if self.data.task_value <  self.data.task_table.target then 
        strText = ex.Tools:getLang(2702)-- 前往
        self:setRedPoint(false)

        self.lbl_btn_submit = cc.Label:createWithTTF(strText, FONT_DEFAULT_NAME_BOLD, 36)
        self.lbl_btn_submit:setScale(0.6)
        self.btn_submit:addChild(self.lbl_btn_submit)
        self.lbl_btn_submit:setPosition(self.btn_submit:getContentSize().width * 0.5, self.btn_submit:getContentSize().height * 0.5 )
        self.lbl_btn_submit:setTextColor(FONT_WHITE_C4B)
        self.lbl_btn_submit:enableOutline(FONT_RED, 2)

	elseif self.data.task_value >= self.data.task_table.target and self.data.is_obtain == 0 then
		strText = ex.Tools:getLang(2214) -- 领取
        self:setRedPoint(true)
        self.lbl_btn_submit = cc.Label:createWithTTF(strText, FONT_DEFAULT_NAME_BOLD, 36)
        self.lbl_btn_submit:setScale(0.6)
        self.btn_submit:addChild(self.lbl_btn_submit)
        self.lbl_btn_submit:setPosition(self.btn_submit:getContentSize().width * 0.5, self.btn_submit:getContentSize().height * 0.5 )
        self.lbl_btn_submit:setTextColor(FONT_WHITE_C4B)
        self.lbl_btn_submit:enableOutline(FONT_RED, 2)

	elseif self.data.is_obtain == 1 then
        strText = ex.Tools:getLang(2703) -- 已领取
        self:setRedPoint(false)

        self.lbl_btn_submit = cc.Label:createWithTTF(strText, FONT_DEFAULT_NAME_BOLD, 36)
        self.lbl_btn_submit:setScale(0.6)
        self.btn_submit:addChild(self.lbl_btn_submit)
        self.lbl_btn_submit:setPosition(self.btn_submit:getContentSize().width * 0.5, self.btn_submit:getContentSize().height * 0.5 )
        self.lbl_btn_submit:setTextColor(FONT_WHITE_C4B)
	end

    self.btn_submit:registerScriptTapHandler(handler(self, self.onClickSubmit))

end

function PROMEveryDayLoginCell:setRedPoint(bool)
	ex.Tools:addRedPoint(self.btn_submit,bool)
end


function PROMEveryDayLoginCell:onClickSubmit(tag,pSender)

    if self.data.task_value >= self.data.task_table.target and self.data.is_obtain == 0 then 


        ex.Player.promotion_data:gReqEveryDayLoginReward(self.data.idx)
        
        ex.Player.promotion_data:checkEveryDayLoginRedDot()

        ex.EventManager:fire(EVENT.MAIN_CITY_LEVEL_UP.ACTIVITY_IS_SUCCESS)
    else 
        --提示语句  41044
        if self.data.jump_info_table.event_type == 1 then 
            -- ex.JumpManager:jumpByAtom(self.data.jump_info_table.event_arg)

            local backToLayer =  function ( layer )
                
                local vec_idx = ex.Player.promotion_data:getPromotionByType(PromotionPageType.LIMIT_TIME_SERVER_ACTIVITY)
                layer:initWithTable(nil, vec_idx, 702)
                
            end
            local params = {}
            params.backToLayer = backToLayer
            ex.JumpManager:jumpByAtom(self.data.jump_info_table.event_arg, params)


        else
            ex.MessageView:add(ex.Tools:getLang(self.data.jump_info_table.no_jump_hint))
        end
    end 
end



function PROMEveryDayLoginCell:onClick(tag,pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end




function PROMEveryDayLoginCell:updateItem( award_list)
    local menu = cpp.UIMenu:create()
    :setPosition(cc.p(0, 0))
    self:addChild(menu)

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
        menu:addChild(item)
    end

end



function PROMEveryDayLoginCell:reset(data)

    if not data then print("not data") return end
    self.data = data
    
    self:updateItem(data.reward)

    self.top_lab:setString("")
    local show_value =  data.task_value
    local  show_nums = data.task_table.target
    if data.task_table.type == "RECHARGE" then 
        
        show_nums = tonumber( show_nums ) * 0.01
        show_value = show_value * 0.01

    end 

    -- self.lbl_title:setXmlTextLua("<outline color='#44200B'size='2'>".. ex.Tools:taskString(data.lang,show_nums) .. "</outline>")
    self.lbl_title:setXmlTextLua( ex.Tools:taskString(data.lang,show_nums) )


    -- self.top_lab:setString(ex.Tools:getLang(data.lang) )


    local str = string_format("(%s/%s)", show_value , show_nums)
    self.num_lab:setString(str)
    

    if data.is_obtain == 1   then 
        self.btn_submit:setEnabled(false)
        self.btn_submit:setNormalImage(cc.Sprite:createWithSpriteFrameName("button/btn-orange-3.png"))
    end
    
    self:setBtnString()
end



return PROMEveryDayLoginCell
