local PROMFiveOneSelectedCtr = class("PROMFiveOneSelectedCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PROMFiveOneSelectedLayer = class("PROMFiveOneSelectedLayer", require("src.comp.EventLayerAdaptiveWidth"))
local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")


function PROMFiveOneSelectedLayer:onCreate()
    self:addBlackBackground()
    self.model = ex.Player.promotion_data.customized_data
    self.arr = {}
    self.canBuy = true
    self.select_idx = 1
    self.viewSize = cc.size(540, 240)
    self.spr_select = cc.Sprite:createWithSpriteFrameName("customized/selected1.png")
    -- self.spr_select:setScale(0.7)
    self:addChild(self.spr_select)
    self.item_memu = cpp.UIMenu:create()
    self:addChild(self.item_memu)
    self.item_memu:setPosition(0,0)

    local lbl_size = self.lbl_desc:getContentSize()
    self.rich_text = cpp.RichTextEx:createWithXMLLua("")
    :setFontSize(22)
    :setFontFace(FONT_DEFAULT_NAME_BOLD)
    :setFontColor("#5E3E16")
    :setAnchorTextShadow(true)
    :ignoreContentAdaptWithSize(false)
    :setWrapMode(2)
    :setContentSize(530,160)
    :setAnchorPoint(ex.a.left_bottom)
    self.rich_view:getContainer():addChild(self.rich_text)
    self.rich_text:setPosition(0,0)
    
    self:registerBtnEvent()
    self:addBtnFront()
    self:addEvent(EVENT.CUSTOMIZED.UPDATE_CUSTOMIZED_ITEM,handler(self,self.onCustomized))
end

function PROMFiveOneSelectedLayer:onCustomized(event,data)
    PROMFiveOneSelectedCtr:instance():closeWindow()
end

function PROMFiveOneSelectedLayer:addBtnFront( )
    self.lbl_btn_cannel = cc.Label:createWithTTF(ex.Tools:getLang(2733), FONT_DEFAULT_NAME_BOLD, 24)
    self.btn_cannel:addChild(self.lbl_btn_cannel)
    self.lbl_btn_cannel:setPosition(self.btn_cannel:getContentSize().width * 0.5, self.btn_cannel:getContentSize().height * 0.5)
    self.lbl_btn_cannel:enableOutline(FONT_BROWN, 1)

    self.lbl_btn_submit = cc.Label:createWithTTF(ex.Tools:getLang(2735), FONT_DEFAULT_NAME_BOLD, 24)
    self.btn_submit:addChild(self.lbl_btn_submit)
    self.lbl_btn_submit:setPosition(self.btn_submit:getContentSize().width * 0.5, self.btn_submit:getContentSize().height * 0.5)
    self.lbl_btn_submit:enableOutline(FONT_BROWN, 1)
end

function PROMFiveOneSelectedLayer:getData()
    return self.data 
end

function PROMFiveOneSelectedLayer:updateBtnStatus( )
    if self.arr and self.arr[self.select_idx] then
        local spr = self.btn_submit:getNormalImage()
        ex.Tools:setGrayAuto(spr, self.arr[self.select_idx].canBuy)
    end
end

function PROMFiveOneSelectedLayer:updateScrollView()
	self.scroll_view:getContainer():removeAllChildren()
	self.menu = cpp.UIMenu:create()
    :setIsTouchInsideNode(self.scroll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    self.scroll_view:getContainer():addChild(self.menu)

    local data = self.data.place_reward[self.select_idx]
    if not data then return end 

    local height 
    local cell_content 
    local scale = 1
    for i=1,#data do
        local cell_props = UIMenuItemBackpack:createWithData(data[i].item_type,data[i].item_num)
        cell_content = cell_props:getContentSize()
        self.menu:add(cell_props)
        if self.arr[self.select_idx] then
            cell_props:setEnabled(not self.arr[self.select_idx].canBuy)
        end
        cell_props:registerScriptTapHandler(handler(self,self.onClickItem))
        if not height then height = math.ceil((#data / 4)) * (cell_content.height+10) end

        local idx = (i - 1) % 4
        local posX = (cell_content.width + 25) * (idx) * scale + 20
        local posY = height - (math.ceil(i / 4)) * (cell_content.height + 10) * scale
        cell_props:setAnchorPoint(0,0)
        cell_props:setPosition(posX,posY)
        cell_props:setScale(scale)
        cell_props:setTag(self.select_idx)
        cell_props:setData(data[i])
        local bool = self.arr[self.select_idx] ~= nil and self.arr[self.select_idx].item_type == data[i].item_type
        cell_props:setSelected(bool)
    end

    local size = cc.size(self.viewSize.width,math.ceil((#data / 4)) * (cell_content.height+10) + 10)
    self.scroll_view:setContentSize(size)
    self.scroll_view:setContentOffset(cc.p(0,self.viewSize.height - height)) 

end

function PROMFiveOneSelectedLayer:updateDesc( )
    local bool = self.arr[self.select_idx] ~= nil 
    self.lbl_tips:setVisible(not bool)
    self.node_desc:setVisible(bool)
    if bool then 
        local item_data = cfg.item.item[self.arr[self.select_idx].item_type]
        local name = ex.Tools:getLang(item_data.name)
        local content = ex.Tools:getLang(item_data.content)

        self.lbl_name:setString(name)
        -- self.lbl_desc:setString(content)
        self.rich_text:setXmlTextLua(content)
        self.rich_text:formatText()
        local rich_size = self.rich_text:getContentSize()
        local view_size = self.rich_view:getContainer():getContentSize()
        self.rich_view:setContentSize(view_size.width,rich_size.height)
        -- self.rich_text:setPosition(0,rich_size.height)
        -- self.rich_view:getContainer():setPosition(0,rich_size.height)
        self.rich_view:setContentOffset(cc.p(0, self.rich_view:getViewSize().height - self.rich_view:getContentSize().height))

    end
end

function PROMFiveOneSelectedLayer:onClickItem(tag,pSender)
    self.arr[tag] = pSender:getData()
    local items = pSender:getParent():getChildren()
    for i,v in ipairs(items) do
        v:setSelected(pSender:getData() == v:getData())
    end
    self:updateSelectedItem()

    self:updateDesc()
    self:updateBtnStatus()
end

function PROMFiveOneSelectedLayer:getPlaceReward(idx)
    for k,v in pairs(self.data.place_reward) do
       for i,val in ipairs(v) do
           if val.idx == idx then 
                return val
           end
       end
    end
end

function PROMFiveOneSelectedLayer:onExit( )

end

function PROMFiveOneSelectedLayer:registerBtnEvent( )
    self.btn_cannel:registerScriptTapHandler(handler(self, self.onCannel))
    self.btn_submit:registerScriptTapHandler(handler(self, self.onSubmit))
end

function PROMFiveOneSelectedLayer:onCannel(tag,pSender)
    PROMFiveOneSelectedCtr:instance():closeWindow()
end

function PROMFiveOneSelectedLayer:onSubmit(tag,pSender)
    if self.arr and self.arr[self.select_idx] then
       if self.arr[self.select_idx].canBuy then
            ex.MessageView:add(ex.Tools:getLang(6148))
            return
       else
            if self.data.posData and self.data.posData[self.select_idx] then
                local req = Promotion097_pb.GReqLaborDayLuckDrawChoice()
                req.position = self.data.posData[self.select_idx]
                req.item_id = self.arr[self.select_idx].item_type
                NetManager:sendMessage(ProtocolID.GReqLaborDayLuckDrawChoice, req)

                PROMFiveOneSelectedCtr:instance():closeWindow()
            end
       end
    end
    
end

function PROMFiveOneSelectedLayer:onSelected(tag,pSender)

    if self.select_idx == tag then return end 
    self.select_idx = tag 
    self.spr_select:setPosition(self["item_".. self.select_idx]:getPosition())
    self:updateScrollView()
    self:updateDesc()
    self:updateBtnStatus()
end

-----------------------------------------------------------------------------
function PROMFiveOneSelectedCtr:onCreate()
    self:setCCBIPath("ccbi/PROMFiveOneSelectedLayer.ccbi")
    self:setIsSingle(false)
end

function PROMFiveOneSelectedCtr:getLayerClass()
    return PROMFiveOneSelectedLayer
end

function PROMFiveOneSelectedCtr:getClanRankLayer()
    return self.layer
end

function PROMFiveOneSelectedCtr:openWindow(data, tag)
    if self:isOpened() then
        return
    end
    self:loadLayer()
    self:open()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self:initData(data, tag)
end

function PROMFiveOneSelectedCtr:initData(data, tag)
    self.layer:setData(data, tag)
    self.layer:updateView()
end

function PROMFiveOneSelectedLayer:setData(data, tag)
    self.data = data
    self.select_idx = tag
end

function PROMFiveOneSelectedLayer:updateView()
    if self.data and self.data.place_reward then
        for i,v in ipairs(self.data.posData) do
            local rewardData = ex.Player.promotion_data:getChoiceReward(v)
            if rewardData then
                self.arr[i] = {}
                self.arr[i].idx = v
                self.arr[i].item_type =  rewardData.id
                self.arr[i].item_num =  rewardData.num
                self.arr[i].canBuy = ex.Player.promotion_data:isFinishByPosIndex(v)
            end 
        end
    end
    self:updateSelectedItem()
    self:updateScrollView()
    self.spr_select:setPosition(self["item_".. self.select_idx]:getPosition())
    self:updateDesc()
    self:updateBtnStatus()
end

function PROMFiveOneSelectedLayer:updateSelectedItem( )
    self.item_memu:removeAllChildren()
    for i=1,4 do
        local node = self["item_"..i]
        local x,y = node:getPosition()
        local item_type = 0
        local item_num = 0
        if self.arr[i] then 
            item_type = self.arr[i].item_type
            item_num = self.arr[i].item_num
        end
        local item = UIMenuItemBackpack:createWithData(item_type, item_num)
        self.item_memu:addChild(item)
        -- item:setScale(0.7)
        item:setPosition(x,y)
        item:setTag(i)
        item:setData()
        item.spr_add = cc.Sprite:createWithSpriteFrameName("other/spr-add-1.png")
        item:addChild(item.spr_add)
        item.spr_add:setPosition(item:getContentSize().width/2,item:getContentSize().height/2)
        item.spr_add:setVisible(self.arr[i] == nil)
        item:registerScriptTapHandler(handler(self,self.onSelected))
    end
end

return PROMFiveOneSelectedCtr
