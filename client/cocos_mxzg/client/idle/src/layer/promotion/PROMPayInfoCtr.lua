local PROMPayInfoCtr = class("PROMPayInfoCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PROMPayInfoLayer = class("PROMPayInfoLayer", require("src.comp.LuaLayerBase"))

local string_format = string.format

function PROMPayInfoLayer:onCreate()
    self:addBlackBackground()
end

function PROMPayInfoLayer:showLayerData(item_data, need_item_data)
    local str = ex.Tools:getLang(52306)
	local start_btn_size = self.btn_buy:getContentSize()
    local start_btn_txt = cc.Label:createWithTTF(str, FONT_DEFAULT_NAME_BOLD, 26)
    :setTextColor(FONT_BROWN)
    :setScale(0.8)
	:setPosition(start_btn_size.width/2, start_btn_size.height/2 + 3)
    self.btn_buy:addChild(start_btn_txt)


    local menu = cpp.UIMenu:create()
    self.buy_item:addChild(menu)
    menu:setPosition(0,0)

    local item = ex.Player.backpack_data:createWithData(item_data.item_type, item_data.item_num)
    item:setPosition(item:getContentSize().width * 0.5,item:getContentSize().height * 0.5)
    item:setScale(1)
    item:registerScriptTapHandler(handler(self, self.onClickItem))
    menu:addChild(item)
      
    self.buy_num:setString("")

    local spr_icon = cc.Sprite:createWithSpriteFrameName(string_format("backpack/%d.png", need_item_data.item_type))
    self.show_need_image:addChild(spr_icon)
    spr_icon:setScale(0.6)
    spr_icon:setPosition( spr_icon:getContentSize().width * 0.2,spr_icon:getContentSize().height * 0.2 )

end


function PROMPayInfoLayer:onClickItem(tag , pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-----------------------------------------------------------------------------
function PROMPayInfoCtr:onCreate()
	self:setCCBIPath("ccbi/PROMpvebuyLayer.ccbi")
	self:setIsSingle(false)
end

function PROMPayInfoCtr:getLayerClass()
	return PROMPayInfoLayer
end


function PROMPayInfoCtr:openWindow(item_data, need_item_data ,sendCallback , closeCallback)
    if self:isOpened() then
        return
    end
    
    self.item_data = item_data 
    self.need_item_data = need_item_data

    self.sendCallback = sendCallback
    self.closeCallback = closeCallback
    
    self.select_num = 1
    self:loadLayer()
    self:open()
    self:initData()    
end 

function PROMPayInfoCtr:showSelectData( )
    self.layer.lbl_buy_num:setString(self.select_num)
    self.layer.lbl_energy_num:setString(self.select_num * self.need_item_data.item_num)
end

function PROMPayInfoCtr:subSubmit( tag,pSender)
    self.select_num = self.select_num - 1
    if self.select_num < 1 then 
        self.select_num = 1
    end 
    self:showSelectData()
end

function PROMPayInfoCtr:addSubmit( tag,pSender)

    local new_select_num = self.select_num + 1
    local count = new_select_num * self.need_item_data.item_num 

    if 	count > ex.Player:getItemNum(self.need_item_data.item_type) then 
        new_select_num = self.select_num
    end 

    self.select_num = new_select_num
    self:showSelectData()
end


function PROMPayInfoCtr:buySubmit( tag,pSender)   
    -- 获取我当前的数量
    if self.sendCallback then 
        self.sendCallback(self.select_num)
    end 
    self:showSelectData( )
end


function PROMPayInfoCtr:btnClose(tag,pSender )
    if self.closeCallback then 
        self.closeCallback()
    end 
    self:closeWindow()
end

function PROMPayInfoCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.btnClose))
    self.layer.btn_buy:registerScriptTapHandler(handler(self, self.buySubmit))

    self.layer.btn_sub1:registerScriptTapHandler(handler(self, self.subSubmit))
    self.layer.btn_add1:registerScriptTapHandler(handler(self, self.addSubmit))
    self:showSelectData()
	self.layer:showLayerData(self.item_data , self.need_item_data)

    
end


return PROMPayInfoCtr