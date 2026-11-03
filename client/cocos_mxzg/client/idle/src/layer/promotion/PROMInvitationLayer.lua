local PROMInvitationLayer = class("PROMInvitationLayer", require("src.layer.promotion.PromotionBaseLayer"))

local string_format = string.format

local showTabData = 
{
    {type = 1, langunage = 41070},
    {type = 2, langunage = 41071},
    {type = 3, langunage = 41072},
}

function PROMInvitationLayer:onCreateDone()
    self:setSwallowTouches(false)
    self:setAutoClose(false)
    self.cur_tag = 0
    self:initdDone()

    local win_size = cc.Director:getInstance():getWinSize()

    --self.spr_bg:setScaleX(win_size.width / self.spr_bg:getContentSize().width)
    --self.spr_bg:setScaleY(win_size.height / self.spr_bg:getContentSize().height)

    
    -- ex.Tools:setLimitWidth(self.active_tips_show, 500)
    self.active_tips_show:setFontSize(30)
    self.active_tips_show:setDimensions(1000, 0)

    self.text_lab:setDimensions(500, 0)
    -- self.please_tips_show:setDimensions(200, 0)
    self.please_tips_show:setAnchorPoint(cc.p(0,0.5))
    self.please_tips_show:setPosition(-270, self.please_tips_show:getPositionY() + 50)

    self.text_lab:setDimensions(500, 0)

    self.spr_top_node:setPositionY(self.layer_promotion:getTopY())
    self.spr_bg:setPositionY(self.layer_promotion:getTopY())

    self.code:setString(ex.Player.promotion_data.invitation.code)


    self.coeMsg_str = cc.Label:createWithTTF(ex.Tools:getLang(47736), FONT_DEFAULT_NAME_BOLD, 36)
    -- self.coeMsg_str:setScale(0.7)
    self.coeMsg:addChild(self.coeMsg_str)
    self.coeMsg_str:setPosition(0,0)
    self.coeMsg_str:setTextColor(FONT_YELLOW)
    self.coeMsg_str:enableOutline(FONT_BLACK_C4B, 1)
    ex.Tools:setLimitWidth(self.coeMsg_str, 165)

    self.rolecount_str = cc.Label:createWithTTF(string.format(ex.Tools:getLang(47666), #ex.Player.promotion_data.invitation.role_list), FONT_DEFAULT_NAME_BOLD, 26)
    self.rolecount_str:setScale(0.5)
    self.rolecount:addChild(self.rolecount_str)
    self.rolecount_str:setPosition(0,0)
    self.rolecount_str:enableOutline(FONT_BLACK_C4B, 1)
    

	local btn_size = self.btn_copy:getContentSize()
	local lbl_btn_txt = cc.Label:createWithTTF(ex.Tools:getLang(47492), FONT_DEFAULT_NAME_BOLD, 20)
	:setPosition(btn_size.width / 2, btn_size.height / 2)
    self.btn_copy:addChild(lbl_btn_txt, 10, 10)
    self.btn_copy:registerScriptTapHandler(handler(self, self.btnCopy))
    --lbl_btn_txt:enableOutline(FONT_GRAY, 2)
    lbl_btn_txt:enableOutline(FONT_DARK_BLUE, 1)


    self:addEvent(EVENT.MAIN_CITY_LEVEL_UP.ACTIVITY_IS_SUCCESS,handler(self,self.updateList))
    self:addEvent(EVENT.MAIN_CITY_LEVEL_UP.ACTIVITY_CODE_REFRESH_DATA,handler(self,self.refreshCode))
    
end


function PROMInvitationLayer:btnCopy(tag,pSender)

    ex.MessageView:add(ex.Tools:getLang(47714), 0)

    print("PROMInvitationLayer:btnCopy", ex.Player.promotion_data.invitation.code)
    cpp.Game:instance():setClipboard(ex.Player.promotion_data.invitation.code)
end


function PROMInvitationLayer:btnSubmit(tag,pSender)
    local str_code = self.edit_box:getText()

    if str_code == "" or str_code == nil then 
        ex.MessageView:add(ex.Tools:getLang(47068))
        return 
    end 
    ex.Player.promotion_data:reqUseInvitationCode(str_code)
    
end


function PROMInvitationLayer:refreshCode(event,data)
    self:showPanel(self.cur_tag)
end



function PROMInvitationLayer:initdDone( )
    
    self:createTabBtn()
end


function PROMInvitationLayer:createTabBtn()
	local margin = 0
	local offset = 5
	self.menu = cpp.UIMenu:create()
	self.node_tab:addChild(self.menu)
    self.menu:setPosition(0,0)
    self.menu:setSwallowsTouches(false)
    self.tabs = {}

    --local red_poins = ex.Player.seventdaytarget_data:getDayRedPoint(self.select_day)
    for k,v in pairs(showTabData) do
    
        local str = ex.Tools:getLang(v.langunage)
		
        local item = cpp.UIMenuItemTab:create("button/btn-tab-1.png",
                                              "button/btn-tab-2.png",
                                              str,
                                              1,
                                              nil)
		local item_size = item:getContentSize()
		local posY = -6
		local posX = item_size.width + (item_size.width + margin) * (v.type - 1) + offset
		item:setLabelColor(FONT_BLACK)
        item:setPosition(posX - 650 * 0.5, posY)
        item:setTag(v.type)
        item:registerScriptTapHandler(handler(self, self.onClickTab))
        item:setChecked(v.type==1)
        item:setLabelScale(0.5,0.5)
        self.tabs[v.type] = item

        ex.Tools:setLimitWidth(item:getLabel(), 100)
        
        -- local reddot_manager = ex.RedDotManager
        -- if i < 4 then 
        --     local red_id = 1006000
        --     red_id = red_id + i * 100
        --     reddot_manager:setStickNode(red_id , item)
        --     reddot_manager:setRedNodeVisible(red_id,red_poins[i] == true)
        -- end

        self.menu:addChild(item)
    end
    
    self:onClickTab(1)
end


function PROMInvitationLayer:onClickTab(tag,pSender)
    if tag == self.cur_tag then return end
    self.cur_tag = tag
	self:showPanel(self.cur_tag)
end

function  PROMInvitationLayer:showPanel(tag,pSender)
    --显示数据
    ex.Tools:addRedPoint(self.tabs[2],ex.Player.promotion_data:checkInvitationGiftRedDot())

    self.useCodeBg:setVisible(false)
    local bg_size = self.gift_list:getContentSize()
    self:reloadTab()
    if tag == 1 then 
        -- 被我邀请得到人
        if self.edit_box then 
            self.edit_box:setVisible(false)
            self.btn_submit:setVisible(false)
        end 
        self.use_code:setVisible(false)

        self.cell_data =  ex.Player.promotion_data.invitation.role_list 

        if #self.cell_data > 0 then 
            self.useCodeBg:setVisible(false)
        

            local sub_size = cc.size(60, 60)

            local viewSize = sub_size
            local posx = self.gift_list:getPositionX()
            local posy = self.gift_list:getPositionY()
        
            local win_size = cc.Director:getInstance():getWinSize()
            if  self.layer_promotion then
                local top_y = self.layer_promotion:getTopY()
                top_y = top_y - 20 - 160	-- banner高106
                
                viewSize = cc.size(win_size.width  - sub_size.width, top_y - self.layer_promotion:getBottomY() - sub_size.height)
                posx = win_size.width * 0.5 - viewSize.width * 0.5
                posy = self.layer_promotion:getBottomY() + sub_size.height * 0.5
            end
        
        
            if viewSize.width > bg_size.width then 
                viewSize.width = bg_size.width
                posx = win_size.width * 0.5 - viewSize.width * 0.5
            end     
        
            self.tableView = ex.Tools:initTableView(self,self.cell_data, {require("src.layer.promotion/PROMInvitationRoleCell"),"ccbi/PROMInvitationRoleCell.ccbi"} , viewSize, 7 , cc.p(posx, posy))
                
        else 
            self.useCodeBg:setVisible(true)
            self.text_lab:setString(ex.Tools:getLang(41074))
        end 

    elseif tag == 2 then 
        
        self.use_code:setVisible(false)
        if self.edit_box then 
            self.edit_box:setVisible(false)
            self.btn_submit:setVisible(false)
        end
        self.cell_data =  self:sor(ex.Player.promotion_data.invitation.gift_list)
        
        
        

        local sub_size = cc.size(60, 60)

        local viewSize = sub_size
        local posx = self.gift_list:getPositionX()
        local posy = self.gift_list:getPositionY()
    
        local win_size = cc.Director:getInstance():getWinSize()
        if  self.layer_promotion then
            local top_y = self.layer_promotion:getTopY()
            top_y = top_y - 20 - 160	-- banner高106
            
            viewSize = cc.size(win_size.width  - sub_size.width, top_y - self.layer_promotion:getBottomY() - sub_size.height)
            posx = win_size.width * 0.5 - viewSize.width * 0.5
            posy = self.layer_promotion:getBottomY() + sub_size.height * 0.5
        end
    
    
        if viewSize.width > bg_size.width then 
            viewSize.width = bg_size.width
            posx = win_size.width * 0.5 - viewSize.width * 0.5
        end     
    
    
        self.tableView = ex.Tools:initTableView(self,self.cell_data, {require("src.layer.promotion/PROMInvitationGiftCell"),"ccbi/PROMCompleteAwardCell.ccbi"} , viewSize, 7 , cc.p(posx, posy))
            

    else 
        
        
        if ex.Player.promotion_data.invitation.status == 1 then 
            --  其他操作
            self.use_code:setVisible(false)
            self.useCodeBg:setVisible(true)
            self.text_lab:setString(ex.Tools:getLang(41073))
            if self.edit_box then 
                self.edit_box:setVisible(false)
                self.btn_submit:setVisible(false)
            end

        else 
            self.use_code:setVisible(true)
            if not self.edit_box then 
                self.edit_box = ccui.EditBox:create(cc.size(self.code_bg:getContentSize().width * self.code_bg:getScaleX() - 30,
                                                                self.code_bg:getContentSize().height * self.code_bg:getScaleY()),
                                                                "other/spr-null.png", 1)  --输入框尺寸，背景图片
                                          
                                                                
                self.edit_box:setPosition(cc.p(self.use_code:getPositionX() - self.code_bg:getContentSize().width * 0.5 + 20,self.use_code:getPositionY() - 200 - self.code_bg:getContentSize().height))
                self.edit_box:setAnchorPoint(cc.p(0, 0))
                self.edit_box:setMaxLength(50)
                self.edit_box:setFontSize(26)
                self.edit_box:setFontColor(FONT_BROWN)
                self.edit_box:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND) --输入键盘返回类型，done，send，go等
                self.edit_box:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE) --输入模型，如整数类型，URL，电话号码等，会检测是否符合
                -- self.edit_box:setPlaceholderFontSize(18)
                -- self.edit_box:setPlaceHolder(ex.Tools:getLang(47002)) -- 请输入兑换码
                self:addChild(self.edit_box, 9999)
        
                local menu = cpp.UIMenu:create()
                self:addChild(menu)
                menu:setPosition(cc.p(self.use_code:getPositionX() * 1.5 ,self.use_code:getPositionY() - 185 - self.code_bg:getContentSize().height))

                self.btn_submit = cpp.UIMenuItemImage:createWithSpriteFrameName("button/btn-old-1.png", "button/btn-old-1.png", "")
                self.btn_submit:registerScriptTapHandler(handler(self, self.btnSubmit))
                self.btn_submit:setPosition(0,0)
                menu:addChild(self.btn_submit)

                local lbl_btn_submit = cc.Label:createWithTTF(ex.Tools:getLang(47156), FONT_DEFAULT_NAME_BOLD, 36)
                lbl_btn_submit:setScale(0.5)
                self.btn_submit:addChild(lbl_btn_submit)
                lbl_btn_submit:setPosition(self.btn_submit:getContentSize().width * 0.5 , self.btn_submit:getContentSize().height * 0.5 + 2)
                lbl_btn_submit:setTextColor(FONT_BROWN)
            else 
                self.edit_box:setVisible(true)
                self.btn_submit:setVisible(true)
            end    
        end
    end 
end


function PROMInvitationLayer:reloadTab( )
    if not self.tableView then return end 

    self.tableView:initData({})
    self.tableView:reloadData()

end


function PROMInvitationLayer:updateList(event,data)

    ex.Tools:addRedPoint(self.tabs[2],ex.Player.promotion_data:checkInvitationGiftRedDot())

    if not self.tableView then return end
    local offsetY = self.tableView:getContainer():getPositionY()
    self.cell_data =  self:sor(ex.Player.promotion_data.invitation.gift_list)
    self.tableView:initData(self.cell_data)
    self.tableView:reloadData()
    self.tableView:setContentOffset(cc.p(0,offsetY))
end



function PROMInvitationLayer:sor( data )
    if #data < 1 then return {} end

    local function sort_table (a,b)

        local astatus = a.now_limit < a.max_limit and 1 or 0
        local bstatus = b.now_limit < b.max_limit and 1 or 0
        
        if astatus == bstatus then 
            return a.idx < b.idx
        else 
            return astatus > bstatus
        end 

    end 
    table.sort( data, sort_table )
    return data
    
end

return PROMInvitationLayer