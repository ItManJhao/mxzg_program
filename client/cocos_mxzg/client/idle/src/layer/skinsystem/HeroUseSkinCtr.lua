local HeroUseSkinCtr = class("HeroUseSkinCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroUseSkinLayer = class("HeroUseSkinLayer", require("src.comp.EventLayer"))

function HeroUseSkinLayer:onCreate()
    self:addBlackBackground()

    -- local map_bg = cc.Sprite:create("ccbi-res/map-bg-role-1.jpg")
	-- local scale_x = ex.p.width / map_bg:getContentSize().width
	-- local scale_y = ex.p.height / map_bg:getContentSize().height
	-- map_bg:setScale(scale_x > scale_y and scale_x or scale_y)
	-- map_bg:setPosition(ex.p.center())
    -- self.map_bg:addChild(map_bg)
    
end


-----------------------------------------------------------------------------
function HeroUseSkinCtr:onCreate()
    self:setCCBIPath("ccbi/HeroUseSkinLayer.ccbi")
    self:setIsSingle(false)
end

function HeroUseSkinCtr:getLayerClass()
    return HeroUseSkinLayer
end

function HeroUseSkinCtr:getHeroUseSkinLayer()
    return self.layer
end

function HeroUseSkinCtr:getAsynImage()
    local vec_image = {
		{image_name = "ccbi-res/map-bg-role-1.jpg", remove_type=1},
    }
    return vec_image
end


function HeroUseSkinCtr:openWindow(item_type, is_show_btn, decompose_data)
    if self:isOpened() then
        return
    end
    self.decompose_data = decompose_data
    self.is_show_btn = is_show_btn
    self.item_type = item_type

    self:loadLayer()
    self:open()
    self:initData()
end

function HeroUseSkinCtr:onUse(tag, pSender)
	local req = HeroFashion_pb.GReqActiveHeroFashion()
	req.item_type = self.item_type
    NetManager:sendMessage(ProtocolID.GReqActiveHeroFashion, req)
    
    self:closeWindow()
end

function HeroUseSkinCtr:onDecompose(tag, pSender)
    if self.decompose_data then
        local decompos_cfg = cfg.decompositionitem.decompositionitem[self.decompose_data.item_type]
        if not decompos_cfg then
            ex.MessageView:add("没有找到分解配置item_type:" .. self.decompose_data.item_type)
            return 
        end
        require("src.layer.decomposeItem.DecomposeSelectCtr"):instance():openWindow(self.decompose_data)
        self:closeWindow()
    end
end

function HeroUseSkinCtr:onLook(tag, pSender)

    require("src.layer.skinsystem.HeroMaxSkinCtr"):instance():openWindow(self.fashion_id)

end


function HeroUseSkinCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    
    self.layer.btn_battle_record:registerScriptTapHandler(handler(self, self.onLook))
    self.layer.btn_up_grade:registerScriptTapHandler(handler(self, self.onUse))
    self.layer.btn_decompose:registerScriptTapHandler(handler(self, self.onDecompose))
    self.layer.btn_decompose:setVisible(false)
    self.layer.btn_up_grade:setLabelText(ex.Tools:getLang(3502))
    self.layer.btn_decompose:setLabelText(ex.Tools:getLang(3923))
    --self.layer:addEvent(EVENT.BORDER_EVENT.ACTIVE_UPDATE,handler(self,self.updateLayer))

    local item_fashon_data = cfg.herofashionunlock.getConfigByType(self.item_type)
    local hero_fashion = cfg.herofashion.getConfigByType(item_fashon_data.fashion_id)
    self.fashion_id = item_fashon_data.fashion_id
    local hero_fashionup_data =  cfg.herofashionup.getConfigByTypeAndLevel(item_fashon_data.fashion_id, 0 )
    if not hero_fashion then return end 

    local show_name = ex.Tools:getLang(hero_fashion.fashion_name)
    if item_fashon_data.type == 1 then 
        local days = item_fashon_data.time_limit / 86400
        show_name = show_name .. string.format(ex.Tools:getLang(3812), days) 
    else 
        show_name = show_name .. ex.Tools:getLang(3811)
    end 


    self.layer.lbl_skin_name:setString(show_name)
    self.layer.lbl_skin_name:enableOutline(cc.c4b(176,42,102,255), 2)
    -- 等级：%d级
    self.layer.lbl_skin_desc:setString(ex.Tools:getLang(hero_fashion.fashion_desc))

    -- self.layer.lbl_skin_tip:setString(ex.Tools:getLang(3801))

    for i,v in ipairs(hero_fashionup_data.ability) do
        local str = ex.Tools:getLang(2150000 + v.attr)..":" 

        local str_attr_num = str .. ex.StringUtil.formatAttrStr(" "..ex.Tools:getLang(2160000 + v.attr), "##" , v.value)

        self.layer["lbl_attr_addition_".. i]:setString( str_attr_num)
    end


    local  animator = require("src.person.Hero"):create("1", "1", 1, 1, 1, item_fashon_data.fashion_id)

    animator:setAnimation(0, "stand", true);

    animator:setScale(1.5)

    animator:setPosition(cc.p(0, 80))

    animator:setShadowVisible(false)

    self.layer.node_animator:addChild(animator, 10)



    --   self.layer.btn_up_grade
    local flag, time = ex.Player.hero_data.fashion:checkFashionStatue(item_fashon_data.fashion_id)

    if self.is_show_btn == true then 
        self.layer.btn_up_grade:setVisible(true)
    else 
        self.layer.btn_up_grade:setVisible(false)
    end 

    if time == 0 then 
        self.layer.btn_up_grade:setVisible(false)
    end 
    
    if self.is_show_btn then
        local item_config = cfg.item.item[self.item_type]
        if (item_config) then
            self.layer.btn_decompose:setVisible(flag and (not self.layer.btn_up_grade:isVisible()) and (item_config.decomposition == 1))
        end
    else
        self.layer.btn_decompose:setVisible(false)
    end

end

return HeroUseSkinCtr
