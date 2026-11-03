
local GodEquipPromotionCtr = class("GodEquipPromotionCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local GodEquipPromotionLayer = class("GodEquipPromotionLayer", require("src.comp.EventLayer"))

local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function GodEquipPromotionLayer:onCreate()
    self:addBlackBackground()
   
    self.node_gift_list = {}

    for i=1,3 do
        table.insert( self.node_gift_list, self['show_node_'..i])
    end

    self.btn_1:registerScriptTapHandler(handler(self, self.onBtn1))
    self.btn_2:registerScriptTapHandler(handler(self, self.onBtn2))


    self:initData()
    self:updateBtn( )
end

function GodEquipPromotionLayer:initData( )
    
    for i,v in ipairs(cfg.system.god_equipment_privilege_show) do
        local cur_item = UIItemBackpack:createWithData(v.item_type, v.item_num)
        self["show_node_menu_".. i]:addChild(cur_item)
        
        cur_item:registerScriptTapHandler(handler(self, self.onShowInfo))
    end
end

function GodEquipPromotionLayer:updateBtn( )
    --检测开启情况
    if ex.Player.god_equip_data.buy_status == 0 then 
        self.btn_2:setVisible(true)
        self.btn_1:setVisible(false)
    else 
        self.btn_2:setVisible(false)
        self.btn_1:setVisible(true)

        -- 领取情况
        -- if ex.Player.god_equip_data.get_day == 0 then 
        --     self.btn_1:setLabelText(ex.Tools:getLang(47444))

        -- else 
        --     self.btn_1:setLabelText(ex.Tools:getLang(47677))

        -- end 


    end 
end


function GodEquipPromotionLayer:onShowInfo(tag,pSender)
    ex.Tools:onClickItemInfo(pSender.item_type, pSender.item_id)
end


function GodEquipPromotionLayer:onBtn1( tag, pSender )

    if ex.Player.god_equip_data.get_day == 0 then 

        -- NetManager:sendMessage(ProtocolID.GReqGetPrivilegeReward)

    else 
        -- ex.MessageView:add(ex.Tools:getLang(47677))
    end 


end

function GodEquipPromotionLayer:onBtn2( tag, pSender )
    -- 进行跳转
    local open,layer = ex.JumpManager:jumpByAtom("act_privilege_shop")
	if not open then return end
	cfg.funcopen["act_privilege_shop"].open({select_idx = 104})
	GodEquipPromotionCtr:instance():closeWindow()
end



-----------------------------------------------------------------------------
function GodEquipPromotionCtr:onCreate()
    self:setCCBIPath("ccbi/GodEquipPromotionLayer.ccbi")
    self:setIsSingle(false)
end

function GodEquipPromotionCtr:getLayerClass()
    return GodEquipPromotionLayer
end

function GodEquipPromotionCtr:getClanRankLayer()
    return self.layer
end

function GodEquipPromotionCtr:openWindow()
    if self:isOpened() then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/god-equip.plist")
    
    self:loadLayer()
    self:open()
    self:initData()
end

function GodEquipPromotionCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

end

return GodEquipPromotionCtr
