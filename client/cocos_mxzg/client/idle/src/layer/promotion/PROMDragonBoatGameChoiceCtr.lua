--[[
* @Description: 端午节活动界面二：龙舟翻牌游戏 选择大奖界面
* @Author: 熊梦
* @Date: 2020-06-17 17:45:00
* ]]
local PROMDragonBoatGameChoiceCtr = class("PROMDragonBoatGameChoiceCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PROMDragonBoatGameChoiceLayer = class("PROMDragonBoatGameChoiceLayer", require("src.comp.EventLayerAdaptiveWidthFull"))

local Propinterval = 120   --道具之间的间隔
local PropLeftPosX = -300   --最左边的横坐标

-----------------------------------------------------------------------
function PROMDragonBoatGameChoiceLayer:onCreate()
    self:addBlackBackground()
	self:registerBtnEvent()
    self:setAutoClose(false)

    self:addEvent(EVENT.PROMOTION_DRAGON_BOAT.ULTIMATE_UPDATE,handler(self,self.updateUltimate))
    
    self.ultimate_id = ex.Player.promotion_data.promotiondragonboattaskinfo_value.ultimate_id 
    
    self.item_table = {}

    self.grid_turns = ex.Player.promotion_data.promotiondragonboattaskinfo_value.grid_turns


    local grid_turns = ex.Player.promotion_data.promotiondragonboattaskinfo_value.grid_turns
    self.lbl_grid_turns:setString(string.format( ex.Tools:getLang(75102),grid_turns))

    local index = 1
    for i,v in ipairs(cfg.promotiondragonboatcard.promotiondragonboatcard) do
        if v.type == 1 and v.turns == self.grid_turns then
            local item = ex.Tools:createBackpackItem(v.reward[1].item_type, v.reward[1].item_num)
            item:registerScriptTapHandler(handler(self, self.onSwitchButton))
            item:setPositionX(PropLeftPosX+Propinterval*index)
            item:setScale(0.8)
            
            table.insert(self.item_table,item)
            item.idx = index

            local item_name = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 20)
            :setScale(1)
            :setTextColor(cc.c4b(130, 67, 38, 255))
            :setPosition(55,-25)
            :setAnchorPoint(ex.a.center)
            item:addChild(item_name)
            local item_config_name = cfg.item.item[v.reward[1].item_type].name
            item_name:setString(ex.Tools:getLang(item_config_name))
            -- ultimate_id ： 选择的大奖id 如果为0代表未选择
            if self.ultimate_id == 0 and index == 1 then
                self.ultimate_id = v.idx
            end
            item.ultimate_id = v.idx
            self.menu_prop:addChild(item)
            index = index + 1
        end
    end

    for i,v in ipairs(self.item_table) do
        if v.ultimate_id == self.ultimate_id then
            local pos = cc.p(self.menu_prop:getPositionX() + v:getPositionX(), 
            self.menu_prop:getPositionY() + v:getPositionY())
            self.spr_box:setPosition(pos)
            self.ultimate_id = v.ultimate_id
            break
        end
    end
end

function PROMDragonBoatGameChoiceLayer:updateUltimate(event,data)
    ex.Player.promotion_data.promotiondragonboattaskinfo_value.ultimate_id = data.idx
   -- ex.MessageView:add(ex.Tools:getLang(75104))
    self.ultimate_id = data.idx

    ex.EventManager:fire(EVENT.PROMOTION_DRAGON_BOAT.GAME_ULTIMATE_UPDATE,data)
    
    -- 收到回调信息 关闭界面
    local choice_ctr = PROMDragonBoatGameChoiceCtr:instance()
    choice_ctr:closeWindow()
end


-- 按钮切换
function PROMDragonBoatGameChoiceLayer:onSwitchButton(event, sender)
    for i,v in ipairs(self.item_table) do
        if v.idx == sender.idx then
            local pos = cc.p(self.menu_prop:getPositionX() + v:getPositionX(), 
            self.menu_prop:getPositionY() + v:getPositionY())
            self.spr_box:setPosition(pos)
            self.ultimate_id = v.ultimate_id
            break
        end
    end
end

-- 按钮回调
function PROMDragonBoatGameChoiceLayer:onSure(event, sender)
    if ex.Player.promotion_data.promotiondragonboattaskinfo_value.ultimate_id == self.ultimate_id then
        -- 没有修改大奖 直接关闭界面
        local choice_ctr = PROMDragonBoatGameChoiceCtr:instance()
        choice_ctr:closeWindow()
        return
    end
    local req = Promotion064_pb.GReqChooseUltimateReward()
    req.idx = self.ultimate_id
    NetManager:sendMessage(ProtocolID.GReqChooseUltimateReward, req)
end

-- 关闭按钮
function PROMDragonBoatGameChoiceLayer:registerBtnEvent( )
	self.btn_close:registerScriptTapHandler(handler(self, self.onSure))
end

-----------------------------------------------------------------------
function PROMDragonBoatGameChoiceCtr:onCreate()
	self:setCCBIPath("ccbi/PROMDragonBoatGameChoiceLayer.ccbi")
	self:setIsSingle(false)
end

function PROMDragonBoatGameChoiceCtr:getLayerClass()
	return PROMDragonBoatGameChoiceLayer
end

function PROMDragonBoatGameChoiceCtr:getDiscussLayer()
	return self.layer
end

function PROMDragonBoatGameChoiceCtr:openWindow(type)
	if self:isOpened() then
		return
	end
	self:loadLayer()
	self:open()
end

return PROMDragonBoatGameChoiceCtr
