--[[
* @Description: 黑色星期五 - 黑色通缉 英雄选择界面
* @Author: 熊梦
* @Date: 2020-11-17 1:26:00
* ]]

local PROMBlackFridayWantedHeroCtr = class("PROMBlackFridayWantedHeroCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PROMBlackFridayWantedHeroLayer = class("PROMBlackFridayWantedHeroLayer", require("src.comp.EventLayerAdaptiveWidth"))

---------------------------------------------------------------------------------

function PROMBlackFridayWantedHeroLayer:onCreate()
    self.heros = {}
    self.idx = ex.Player.promotion_data:getBlackFiveLotterySelectIndex()
    local is_not_select = self.idx == 0
    if self.idx == 0 then 
        self.idx = 1 
    end 
    self.spr_2:setOpacity(80)
    self.spr_3:setOpacity(60)
    self.spr_4:setOpacity(80)
    self:addBlackBackground()
    self.spr_name_bg:setLocalZOrder(3)
    self.lbl_name:setLocalZOrder(3)
    self.spr_elem:setLocalZOrder(3)
    self.spr_elem:setPositionX(self.lbl_name:getPositionX() -  self.lbl_name:getContentSize().width / 2)

    local str = is_not_select and ex.Tools:getLang(91514) or ex.Tools:getLang(91516)    
    self.lbl_btn_enter = cc.Label:createWithTTF(str, FONT_DEFAULT_NAME_BOLD, 30)
    self.lbl_btn_enter:setColor(cc.c3b(14,8,94))
    self.btn_enter:addChild(self.lbl_btn_enter)
    self.lbl_btn_enter:setPosition(self.btn_enter:getContentSize().width * 0.5, self.btn_enter:getContentSize().height * 0.5)
    self.lbl_btn_enter:enableOutline(cc.c3b(253,240,152))
    self.btn_enter:setEnabled(is_not_select == true)

    -- 繁体适配注释 别的版本就解除掉
    --ex.Tools:setLimitWidth(self.lbl_btn_enter, 150)
    --------------------------------------

    --if is_not_select == false then 
    local spr_img = self.btn_enter:getNormalImage()
    ex.Tools:setGrayAuto(spr_img,is_not_select == false)
    if is_not_select then 
        self.lbl_selected_tips:setString(ex.Tools:getLang(91515))
    else 
        self.lbl_selected_tips:setString(ex.Tools:getLang(91517))
    end 
    --end 


    self:registerBtnEvent()
end

function PROMBlackFridayWantedHeroLayer:registerBtnEvent()
    self.btn_left:registerScriptTapHandler(handler(self,self.onLeft))
    self.btn_right:registerScriptTapHandler(handler(self,self.onRight))
    self.btn_close:registerScriptTapHandler(handler(self,self.onClose))
    self.btn_enter:registerScriptTapHandler(handler(self,self.onEnter))
end

 function PROMBlackFridayWantedHeroLayer:editData()
     local tmp_data = clone(self.data)
     local length = table.nums(tmp_data)
     local tmp_idx = self.idx
     local data = {}
     while table.nums(data) < length do
         table.insert(data,tmp_data[tmp_idx])
         tmp_idx = tmp_idx + 1 
         if tmp_idx > length then
             tmp_idx = 1
         end
     end

     return data
 end

function PROMBlackFridayWantedHeroLayer:updateSpine()
    local data = self:editData()
    for i=1,4 do
        if self.heros[i] then 
            self.heros[i]:removeFromParent()
            self.heros[i] = nil
        end 
        local hero_data = cfg.herotype.star[data[i].item_type]
        local skin = ex.Tools:getIllustratHeroSkinByStar(hero_data.type,10)
		local hero = require("src.person.Hero"):create("12323", "123213", hero_data.type, 1,10,skin )-- hero_data.star)
        local node = self["node_"..i]
        local scale = 1.55
        if i == 2 or i ==4 then 
            hero:setOpacity(255 * 0.8)
            scale = 1.4
        elseif i == 3 then 
            hero:setOpacity(255 * 0.6)
            scale = 1.4
        end 
        node:addChild(hero)
        hero:setPositionY(80)
        hero:setScale(scale)
        self.heros[i] = hero
    end
    self:updateHeroInfo()
end

function PROMBlackFridayWantedHeroLayer:updateHeroInfo()
    local data = cfg.herotype.star[self.data[self.idx].item_type]
    if data then 
        self.lbl_name:setString(ex.Tools:getLang(data.type))
        self.spr_elem:setSpriteFrame(string.format("hero-icon/elem-%d.png",data.elem))
    end 
end 

function PROMBlackFridayWantedHeroLayer:onLeft()
     self.idx = self.idx + 1
     if self.idx > table.nums(self.data) then 
        self.idx = 1
     end 
     self:changeBtnStatus()
     self:updateSpine()
end

function PROMBlackFridayWantedHeroLayer:onRight()
    self.idx = self.idx - 1 
    if self.idx == 0 then 
        self.idx = table.nums(self.data)
    end 
    self:changeBtnStatus()
    self:updateSpine()
end

function PROMBlackFridayWantedHeroLayer:changeBtnStatus()
    local selected = ex.Player.promotion_data:getBlackFiveLotterySelectIndex()
    local is_not_select = selected == 0 
    self.btn_enter:setEnabled(selected ~= self.idx)
    local spr_img = self.btn_enter:getNormalImage()
    ex.Tools:setGrayAuto(spr_img,selected == self.idx)
    if is_not_select then 
        local str = ex.Tools:getLang(91514)
        self.lbl_btn_enter:setString(str)
        self.lbl_selected_tips:setString(ex.Tools:getLang(91515))
        -- 繁体适配注释 别的版本就解除掉
        --ex.Tools:setLimitWidth(self.lbl_btn_enter, 150)
        --------------------------------------
    else 
        local str = self.idx == selected and ex.Tools:getLang(91516) or ex.Tools:getLang(91518)
        self.lbl_btn_enter:setString(str)
        str = self.idx == selected and ex.Tools:getLang(91517) or ex.Tools:getLang(91519)
        self.lbl_selected_tips:setString(str)
        -- 繁体适配注释 别的版本就解除掉
        --ex.Tools:setLimitWidth(self.lbl_btn_enter, 150)
        --------------------------------------
    end 
end 

function PROMBlackFridayWantedHeroLayer:onClose()
    PROMBlackFridayWantedHeroCtr:instance():closeWindow()
end

function PROMBlackFridayWantedHeroLayer:onEnter()
     --if self.callback then 
        --self.callback(self.idx)
        --print("select hero index :" ,self.idx)
     --end 
     local is_selected = ex.Player.promotion_data:BlackFiveLotteryisSelected()
     if is_selected == true then 
        local cost = cfg.system.promotion083_lottery_change_cost[1]
        local can_change = ex.Player:getItemNum(cost.item_type) >= cost.item_num 
        if can_change == true then 
            local function callback()
                local proto = Promotion083_pb.GReqBlackFiveLotterySelect()
                proto.select_info.key = 1
                proto.select_info.value = self.idx
                NetManager:sendMessage(ProtocolID.GReqBlackFiveLotterySelect, proto)
                PROMBlackFridayWantedHeroCtr:instance():closeWindow()
            end 

            ex.ConfirmCtr:openWindow("",ex.Tools:getLang(91540),callback)
        else 

        end 
     else 
        local function callback()
            local proto = Promotion083_pb.GReqBlackFiveLotterySelect()
            proto.select_info.key = 1
            proto.select_info.value = self.idx
            NetManager:sendMessage(ProtocolID.GReqBlackFiveLotterySelect, proto)
            PROMBlackFridayWantedHeroCtr:instance():closeWindow()
        end 

        ex.ConfirmCtr:openWindow("",ex.Tools:getLang(91521),callback)
     end 

end


---------------------------------------------------------------------------------

function PROMBlackFridayWantedHeroCtr:onCreate()
	self:setCCBIPath("ccbi/PROMBlackFridayWantedHeroLayer.ccbi")
	self:setIsSingle(false)
end

function PROMBlackFridayWantedHeroCtr:getLayerClass()
	return PROMBlackFridayWantedHeroLayer
end

function PROMBlackFridayWantedHeroCtr:openWindow(cfg_data,callback)
	if self:isOpened() then
		return
	end


	self:loadLayer()
	self:open()
    self.layer.data = cfg_data
    self.layer:updateSpine()
end

return PROMBlackFridayWantedHeroCtr
