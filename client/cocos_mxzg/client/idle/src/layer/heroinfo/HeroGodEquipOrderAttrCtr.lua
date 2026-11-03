local HeroGodEquipOrderAttrCtr = class("HeroGodEquipOrderAttrCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local HeroGodEquipOrderAttrLayer = class("HeroGodEquipOrderAttrLayer", require("src.comp.EventLayer"))

function HeroGodEquipOrderAttrLayer:onCreate()
    self:setAutoClose(true)
    self:setSwallowTouches(false)
	self:addBlackBackground()

end

function HeroGodEquipOrderAttrLayer:resetSize(now_height)
	self:setContentSize(cc.size(self:getContentSize().width, now_height))
	self.bg:setContentSize(self:getContentSize())
	self.show_message:setPositionY(self:getContentSize().height)
end

function HeroGodEquipOrderAttrLayer:initDone( equip_data)
    local ability_type_list = {}
    local min_level = 1
    local max_level = cfg.system.god_equipment_random_ability_level
    -- 
    local equip_ment_config = cfg.godequipment.godequipment[equip_data.item_type]

    for i,v in ipairs(cfg.godequipmentrandomability.godequipmentrandomability) do


        if equip_ment_config.place == v.place and equip_ment_config.star == v.star then 

            if not ability_type_list[v.ability_type] then 
                ability_type_list[v.ability_type] = {}
            end 

            if v.level == min_level or v.level == max_level then 
                if not ability_type_list[v.ability_type][v.level] then 
                    ability_type_list[v.ability_type][v.level] =v.ability[1].value
                end 

                if v.level == min_level then 
                    if ability_type_list[v.ability_type][v.level] > v.ability[1].value then 
                        ability_type_list[v.ability_type][v.level] = v.ability[1].value
                    end 

                else
                    if ability_type_list[v.ability_type][v.level] < v.ability[1].value then 
                        ability_type_list[v.ability_type][v.level] = v.ability[1].value
                    end 
                end 



            end 

        end 
    end


    local index = 0
    for k,v in pairs(ability_type_list) do
        index = index + 1
        local str = ex.Tools:getLang(2150000 + k)..":"
        local lbl_ability = cc.Label:createWithTTF(str, FONT_DEFAULT_NAME_BOLD, 18)
        :setTextColor(cc.c3b(255,224,178))
        :setAnchorPoint(cc.p(0, 0.5))
        lbl_ability:setPosition( 0, -(index - 1)* 26 )
        self.show_text:addChild(lbl_ability)

        local show_min_num = v[1]
        local show_max_num = v[max_level]

        local attstr = ex.Tools:getLang(2141000 + k)
        local flag = ex.StringUtil.formatAttrStrBool(attstr, "##" , show_min_num, "<font color='#219A00'>%s</font>")
        local show_min_nums_str = tostring(show_min_num)
        local show_max_nums_str = tostring(show_max_num)
		if flag == true then 
            show_min_nums_str = string.format("%.1f", show_min_num / 100) .. "%"
            show_max_nums_str = string.format("%.1f", show_max_num / 100) .. "%"
        end 

        local show_str = "   "..show_min_nums_str .. "  -  " .. show_max_nums_str
        local lbl_ability_value = cc.Label:createWithTTF(show_str, FONT_DEFAULT_NAME_BOLD, 18)
        :setTextColor(cc.c3b(255,224,178))
        :setAnchorPoint(cc.p(0, 0.5))
        lbl_ability_value:setPosition( lbl_ability:getContentSize().width, -(index - 1)* 26 )
        self.show_text:addChild(lbl_ability_value)

    end
end

------------------------------------------------
function HeroGodEquipOrderAttrCtr:onCreate()
	self:setCCBIPath("ccbi/HeroGodEquipOrderAttrLayer.ccbi")
	self:setIsSingle(false)
end

function HeroGodEquipOrderAttrCtr:getLayerClass()
	return HeroGodEquipOrderAttrLayer
end

function HeroGodEquipOrderAttrCtr:openWindow( equip_data)
	if self:isOpened() then
		return
	end

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/backpack-info.plist")
	sfc:addSpriteFrames("ccbi-res/skill-icon.plist")

	self:loadLayer()
	self:open()
    self.layer:initDone(equip_data)
   --  self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

end

return HeroGodEquipOrderAttrCtr