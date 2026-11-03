local GodEquipRareCtr = class("GodEquipRareCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local GodEquipRareLayer = class("GodEquipRareLayer", require("src.comp.EventLayer"))

function GodEquipRareLayer:onCreate()
    self:addBlackBackground()

    self.btn_stone_down:setLabelSize(48)
	self.btn_stone_down:setLabelColor(cc.WHITE)
    self.btn_stone_down:setLabelOutLine(FONT_BLACK_C4B)
    
	self.btn_stone_up:setLabelSize(48)
	self.btn_stone_up:setLabelColor(cc.WHITE)
    self.btn_stone_up:setLabelOutLine(FONT_BLACK_C4B)

    self.btn_stone_down:registerScriptTapHandler(handler(self, self.onStoneDown))
    self.btn_stone_up:registerScriptTapHandler(handler(self, self.onStoneUp))

    self.show_attr_list = {}
    self.show_list = {}

    self.show_attr_new_list = {}
    self.show_new_list = {}


    -- 属性数据
    self.show_attr_now_image_list = {}
    self.show_attr_now_name_list = {}
    self.show_attr_now_pro_list = {}
    self.show_attr_now_pro_value_list = {}
    self.show_attr_now_lock_list = {}

    self.show_attr_new_image_list = {}
    self.show_attr_new_name_list = {}
    self.show_attr_new_pro_list = {}
    self.show_attr_new_pro_value_list = {}

    self.show_new_text_list =  {}
    self.show_now_text_list = {}

    self.save_rare_image_list = {}
    self.save_new_rare_image_list = {}

	self.text_refresh = require("src.comp.RichTextEx"):create()
    :setFontSize(22)
    :setFontFace(FONT_DEFAULT_NAME_BOLD)
    :setAnchorTextShadow(true)
    :setWrapMode(1)
    :setAnchorPoint(1, 0.5)
    self.show_rich:addChild(self.text_refresh)
    self.text_refresh:setPosition(0,0)

    -- show_cost_rich1
    -- show_cost_rich2
    self.show_cost_rich_list = {}

	local cost_1 = require("src.comp.RichTextEx"):create()
    :setFontSize(22)
    :setFontFace(FONT_DEFAULT_NAME_BOLD)
    :setAnchorTextShadow(true)
    :setWrapMode(1)
    :setAnchorPoint(0.5, 0.5)
    self.show_cost_rich1:addChild(cost_1)
    cost_1:setPosition(self.show_cost_rich1:getContentSize().width * 0.5  ,self.show_cost_rich1:getContentSize().height * 0.5)

    table.insert( self.show_cost_rich_list, cost_1 )



    local cost_2 = require("src.comp.RichTextEx"):create()
    :setFontSize(22)
    :setFontFace(FONT_DEFAULT_NAME_BOLD)
    :setAnchorTextShadow(true)
    :setWrapMode(1)
    :setAnchorPoint(0.5, 0.5)
    self.show_cost_rich2:addChild(cost_2)
    cost_2:setPosition(self.show_cost_rich2:getContentSize().width * 0.5  ,self.show_cost_rich2:getContentSize().height * 0.5)

    table.insert( self.show_cost_rich_list, cost_2 )

    self.btn_lock_list = {}

    self:showRichText( {item_type = 900002,item_num = 0} )
    self:dealObject()

    -- self.wash_nums = 0
end

function GodEquipRareLayer:dealObject( )

    for i=1,2 do
        
        table.insert( self.show_attr_list, self["show_attr_"..i] )
        table.insert( self.show_list, self["show_"..i] )

        table.insert( self.show_attr_new_list, self["show_attr_new_"..i] )
        table.insert( self.show_new_list, self["show_new_"..i] )




        table.insert( self.show_attr_now_image_list, self["show_attr_now_image_"..i] )
        table.insert( self.show_attr_now_name_list, self["show_attr_now_name_"..i] )
        table.insert( self.show_attr_now_pro_list, self["show_attr_now_pro_"..i] )
        table.insert( self.show_attr_now_lock_list, self["show_attr_now_lock_"..i] )
        table.insert( self.show_now_text_list, self["show_now_text_"..i] )
        self.show_now_text_list[i]:enableOutline(FONT_BLACK_TEXT, 2)

        local posBar = cc.p(92, 10)
        local progressTimer = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("god-equip/spr-jdt2.png"))
        :setType(cc.PROGRESS_TIMER_TYPE_BAR)
        :setPosition(posBar)
        :setMidpoint(cc.p(0, 0))
        :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
        self.show_attr_now_pro_list[i]:addChild(progressTimer)

        table.insert( self.show_attr_now_pro_value_list, progressTimer )
        


        table.insert( self.show_attr_new_image_list, self["show_attr_new_image_"..i] )
        table.insert( self.show_attr_new_name_list, self["show_attr_new_name_"..i] )
        table.insert( self.show_attr_new_pro_list, self["show_attr_new_pro_"..i] )
        table.insert( self.show_new_text_list, self["show_new_text_"..i] )
        self.show_new_text_list[i]:enableOutline(FONT_BLACK_TEXT,2)

        local progressTimer2 = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("god-equip/spr-jdt2.png"))
        :setType(cc.PROGRESS_TIMER_TYPE_BAR)
        :setPosition(posBar)
        :setMidpoint(cc.p(0, 0))
        :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
        self.show_attr_new_pro_list[i]:addChild(progressTimer2)

        table.insert( self.show_attr_new_pro_value_list, progressTimer2 )
        self.show_attr_now_lock_list[i]:registerScriptTapHandler(handler(self, self["onBtnLock"..i]))
    end

end

function GodEquipRareLayer:onBtnLock1(tag,pSender )
    -- 锁定1 
    if self.btn_lock_list[1] and self.btn_lock_list[1] == true  then 
        -- 已经选贼
        self.btn_lock_list[1] = false 
    else 

        if not self.btn_lock_list[1] then 
            self.btn_lock_list[1] = true
        end 
    end 
    self:addNeedGems()
end

function GodEquipRareLayer:onBtnLock2(tag,pSender )
    -- 锁定2 
    if self.btn_lock_list[2] and self.btn_lock_list[2] == true  then 
        -- 已经选贼
        self.btn_lock_list[2] = false 
    else 
        if not self.btn_lock_list[2] then 
            self.btn_lock_list[2] = true
        end 
    end 
    self:addNeedGems()
end

function GodEquipRareLayer:chenkNeedGem( )
    local nums = 0
    for k,v in pairs(self.btn_lock_list) do
        if v == true then 
            nums = nums + 1
        end 
    end

    local show_gem_item = {}
    if nums == 1 then 
        show_gem_item = cfg.system.god_equipment_wash_lock_one_cost[1]
    elseif nums == 2 then 
        show_gem_item = cfg.system.god_equipment_wash_lock_two_cost[1]
    else 
        show_gem_item = {item_type = 900002,item_num = 0}
    end 
    return show_gem_item
end


function GodEquipRareLayer:addNeedGems( )

    local show_gem_item = self:chenkNeedGem()
    self:showRichText(show_gem_item)
end

function GodEquipRareLayer:getMaxAttr( item_type)
    -- 
    local max_level = cfg.system.god_equipment_random_ability_level
    local max_config = ex.Player.backpack_data:getgodequipmentrandomability(self.equip_ment_config.place, self.equip_ment_config.star, item_type, max_level)
    return max_config[1].value
end


function GodEquipRareLayer:getAttrValue( attr, value)
    local attstr = ex.Tools:getLang(2141000 + attr)
    local flag = ex.StringUtil.formatAttrStrBool(attstr, "##" , value, "<font color='#219A00'>%s</font>")
    local str = ex.Tools:getLang(2150000 + attr)..":"
    local show_nums_str = tostring(value)
    if flag == true then 
        show_nums_str = string.format("%.1f", value / 100) .. "%"
    end 
    return str .. show_nums_str, show_nums_str
end

function GodEquipRareLayer:UpdateGodEquipData( godequip_id )

    self.godequip_id = godequip_id
    if not self.godequip_id or self.godequip_id == 0 then return end 

    local now_god_equip_data = ex.Player.backpack_data:getGodEquipDataByID(godequip_id)
    if not now_god_equip_data then return end 

    local equip_ment_config = cfg.godequipment.godequipment[now_god_equip_data.item_type]
    self.equip_ment_config = equip_ment_config
    self.ori_name:setString(ex.Tools:getLang(now_god_equip_data.item_type))

    
	self.equip_item = ex.Player.backpack_data:createWithData(now_god_equip_data.item_type, 1)
	self.equip_item:setPosition(0, 0)
	self.equip_item:setScale(1)
	self.show_item:addChild(self.equip_item)
    
	-- ex.Tools:generationStar(self.equip_item, equip_ment_config.star, "other/star-%d.png", 0.6, -10, cc.p(self.equip_item:getContentSize().width * 0.5, 15), 1000)

    local show_ability = equip_ment_config.ability[1]
    local attr_show_type = cfg.attrshow.attrshow[show_ability.attr].icon
    -- self.show_attr_image:setSpriteFrame(string.format("backpack-info/spr-attr-%d.png", attr_show_type))
    ex.Tools:setSpriteFrame(self.show_attr_image, string.format("backpack-info/spr-attr-%d.png", attr_show_type))

    self.show_attr_text:setString( string.format("%s %s", self:getAttrValue(show_ability.attr,show_ability.value), ex.Tools:getLang(72701)))

    self.show_text10:setString(ex.Tools:getLang(72706))

    self:changeNums()
    self:ChangeNowGodEquipData(now_god_equip_data.attrs)
    self:ShowNewGodEquipData( now_god_equip_data.wash_attrs )

    self:changeBtnPosition( )
    self:showNeedCost()
    self:initData(now_god_equip_data)
end

function GodEquipRareLayer:initData(now_god_equip_data )

    -- 判断上次是否锁定洗练
    self.btn_lock_list = {}
    for i,v in ipairs(now_god_equip_data.attrs) do
        
        if not self.btn_lock_list[i] then 
            self.btn_lock_list[i] = false 
        end 

        if v.lock == 1 then 
            self.btn_lock_list[i] = true
        end 

        self.show_attr_now_lock_list[i]:setChecked(self.btn_lock_list[i])
    end
    self:addNeedGems()
end 


function GodEquipRareLayer:changeNums( )
    local now_god_equip_data = ex.Player.backpack_data:getGodEquipDataByID(self.godequip_id)

    self.show_text11:setString(string.format( ex.Tools:getLang(72708), now_god_equip_data.wash_num))
end

function GodEquipRareLayer:showRichText( need_data)

    local str = string.format("<font color='#FFE8C1'>%s</font><img src='backpack/%s.png' width='30' height='30' /><font color='#FFE8C1'>%s</font>",ex.Tools:getLang(72704),need_data.item_type,need_data.item_num)

    self.text_refresh:setXmlTextLua(str)
    self.text_refresh:formatText()

end

function GodEquipRareLayer:getNeedCost( )
    
    local rare_dat = cfg.godequipmentrare.godequipmentrare[self.equip_ment_config.rare]

    return rare_dat.wash_cost

end

function GodEquipRareLayer:showNeedCost( )
    
    local need_cost_list = self:getNeedCost()

    for k,v in pairs(need_cost_list) do

        local need_nums = ex.Player:getItemNum(v.item_type)
        local show_nums = v.item_num

        local need_nums_str = need_nums
        local show_nums_str = show_nums
        if ItemType.IT_GOLD == v.item_type then 
            need_nums_str = ex.StringUtil.getScientificNumber(need_nums)
            show_nums_str = ex.StringUtil.getScientificNumber(show_nums)
        
        end 

        local str = string.format("<img src='backpack/%s.png' width='30' height='30' /><font color='#FFE8C1'>%s/%s</font>",v.item_type,need_nums_str, show_nums_str)
        
        if show_nums > need_nums then 
            str = string.format("<img src='backpack/%s.png' width='30' height='30' /><font color='#ec0000'>%s</font><font color='#FFE8C1'>/%s</font>",v.item_type,need_nums_str, show_nums_str)
        end 
        
        
        
        
        self.show_cost_rich_list[k]:setXmlTextLua(str)
        self.show_cost_rich_list[k]:formatText()
    end
    
end






function GodEquipRareLayer:ShowNewGodEquipData( attrs_data )

    local  ability = {}
	for i,v in ipairs(attrs_data) do
		local rand_attr = ex.Player.backpack_data:getgodequipmentrandomability(self.equip_ment_config.place, self.equip_ment_config.star,   v.sys_id, v.level)
        for ki,kv in ipairs(rand_attr) do
            local now_data = {}
            now_data.attr = kv.attr
            now_data.value = kv.value
            now_data.lock = v.lock
            now_data.sys_id = v.sys_id
            now_data.level = v.level
            table.insert(ability, now_data)
		end 
	end
    local max_level = cfg.system.god_equipment_random_ability_level
    for i=1,2 do
        -- 是否显示1 2 
        self.show_attr_new_list[i]:setVisible(false)
        self.show_new_list[i]:setVisible(true)


        if ability[i] then 
            self.show_attr_new_list[i]:setVisible(true)
            self.show_new_list[i]:setVisible(false)

            local attr_show_type = cfg.attrshow.attrshow[ability[i].attr].icon

            -- self.show_attr_new_image_list[i]:setSpriteFrame(string.format("god-equip/spr-attr-%s.png", attr_show_type))
            ex.Tools:setSpriteFrame(self.show_attr_new_image_list[i], string.format("god-equip/spr-attr-%s.png", attr_show_type))

            self.show_attr_new_name_list[i]:setString(ex.Tools:getLang(2150000 + ability[i].attr))
    

            local value_percentage = 100 * ability[i].level / max_level
            self.show_attr_new_pro_value_list[i]:setPercentage(value_percentage)
            
            -- self.show_new_text_list[i]:setString(string.format("%.2f", value_percentage / 100).."%"  )
            local show_str , show_nums = self:getAttrValue(ability[i].attr,ability[i].value) 
            self.show_new_text_list[i]:setString(string.format("%s", show_nums) )
        end 
    end

    self:changeBtnPosition( )
    self:changeNums()
    self:showNeedCost()
end 


function GodEquipRareLayer:ChangeNowGodEquipData( attrs_data )

    local  ability = {}
	for i,v in ipairs(attrs_data) do
		local rand_attr = ex.Player.backpack_data:getgodequipmentrandomability( self.equip_ment_config.place, self.equip_ment_config.star, v.sys_id, v.level)
        for ki,kv in ipairs(rand_attr) do
            local now_data = {}
            now_data.attr = kv.attr
            now_data.value = kv.value
            now_data.lock = v.lock
            now_data.sys_id = v.sys_id
            now_data.level = v.level
            table.insert(ability, now_data)
		end 
	end
    local max_level = cfg.system.god_equipment_random_ability_level

    for i=1,2 do
        -- 是否显示1 2 
        self.show_attr_list[i]:setVisible(false)
        self.show_list[i]:setVisible(true)

            
        if ability[i] then 
            self.show_attr_list[i]:setVisible(true)
            self.show_list[i]:setVisible(false)

            local attr_show_type = cfg.attrshow.attrshow[ability[i].attr].icon
            -- self.show_attr_now_image_list[i]:setSpriteFrame(string.format("god-equip/spr-attr-%s.png", attr_show_type))
            ex.Tools:setSpriteFrame(self.show_attr_now_image_list[i], string.format("god-equip/spr-attr-%s.png", attr_show_type))

            self.show_attr_now_name_list[i]:setString(ex.Tools:getLang(2150000 + ability[i].attr))

            local value_percentage = 100 * ability[i].level / max_level
            self.show_attr_now_pro_value_list[i]:setPercentage(value_percentage)

            -- self.show_now_text_list[i]:setString(string.format("%.2f", value_percentage / 100) .."%" )
            local show_str , show_nums = self:getAttrValue(ability[i].attr,ability[i].value) 

            self.show_now_text_list[i]:setString(string.format("%s", show_nums )  )
        end 
    end
end 


function GodEquipRareLayer:onStoneDown(tag,pSender )
    -- 洗练
    -- 判断锁定的属是否已经大道了最大值
    local now_god_equip_data = ex.Player.backpack_data:getGodEquipDataByID(self.godequip_id)
    if not now_god_equip_data then return end 
    --  now_god_equip_data.attrs

    local  lock_list = {}
    for k,v in pairs(self.btn_lock_list) do
        if v == true then 
            table.insert( lock_list, k)
            
        end 
    end


    if #lock_list > 0 and #now_god_equip_data.attrs == #lock_list then 
        local flag = false
        local max_level = cfg.system.god_equipment_random_ability_level
        for i,v in ipairs(lock_list) do
            local wash_data = now_god_equip_data.attrs[v]
            if wash_data.level   ==   max_level then 
                flag = true
            end 
        end

        for i,v in ipairs(lock_list) do
            local wash_data = now_god_equip_data.wash_attrs[v]
            if wash_data and wash_data.level   ==   max_level then 
                flag = true
            end 
        end
        
        if flag == true then 

            ex.MessageView:add(ex.Tools:getLang(72711))
            return
            -- local show_str = string.format( ex.Tools:getLang(72711))
            -- ex.ConfirmCtr:openWindow(ex.Tools:getLang(16), show_str, handler(self, self.returnBackCall))   
        else 
            self:fireCheckWashGodEquip()
        end 
    else 
        self:fireCheckWashGodEquip()
    end 
end

function GodEquipRareLayer:returnBackCall( )


end 

function GodEquipRareLayer:fireCheckWashGodEquip( )
        -- 扣钱，扣绑定钻石
        local show_gem_item = self:chenkNeedGem()
        if ex.Player:getItemNum(show_gem_item.item_type) < show_gem_item.item_num then
            ex.Tools:showEnoughTip(show_gem_item.item_type, true)
            return 
        end
    
        local need_cost_list = self:getNeedCost()
    
        for k,v in pairs(need_cost_list) do        
            if ex.Player:getItemNum(v.item_type) < v.item_num then
                ex.Tools:showEnoughTip(v.item_type, true)
                return 
            end
        end
    
        local req = GodEquip_pb.GReqWashGodEquip()
        req.equip_id = self.godequip_id
        -- req.lock_sort = {}
        for k,v in pairs(self.btn_lock_list) do
            if v == true then 
                table.insert( req.lock_sort, k)
            end 
        end
    
        NetManager:sendMessage(ProtocolID.GReqWashGodEquip, req)
    
        -- 判断按钮情况
        -- self.wash_nums = self.wash_nums + 1
        

end

function GodEquipRareLayer:changeBtnPosition( )
    local now_god_equip_data = ex.Player.backpack_data:getGodEquipDataByID(self.godequip_id)

    if #now_god_equip_data.wash_attrs == 0 then 

        self.btn_stone_down:setVisible(true)
        self.btn_stone_up:setVisible(false)

        self.btn_stone_down:setPosition(320, 95)
        self.show_text11:setPosition(320, 55.0)
    else 

        self.btn_stone_down:setVisible(true)
        self.btn_stone_up:setVisible(true)

        self.btn_stone_down:setPosition(203, 95)
        self.show_text11:setPosition(203, 55.0)
    end 

end


function GodEquipRareLayer:onStoneUp(tag,pSender )
    local req = GodEquip_pb.GReqSaveWashGodEquip()
    req.equip_id = self.godequip_id
	NetManager:sendMessage(ProtocolID.GReqSaveWashGodEquip, req)
    
end

function GodEquipRareLayer:onBtnInfo(tag, pSender )
    ex.InfoCtr:openWindow(ex.Tools:getLang(42072), ex.Tools:getLang(42073))
end

-----------------------------------------------------------------------------
function GodEquipRareCtr:onCreate()
    self:setCCBIPath("ccbi/GodEquipRareLayer.ccbi")
    self:setIsSingle(false)
end

function GodEquipRareCtr:getLayerClass()
    return GodEquipRareLayer
end

function GodEquipRareCtr:getClanRankLayer()
    return self.layer
end

function GodEquipRareCtr:openWindow(godequip_id)
    if self:isOpened() then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    --sfc:addSpriteFrames("ccbi-res/backpack-info.plist")    
    sfc:addSpriteFrames("ccbi-res/god-equip.plist")
    
    self:loadLayer()
    self:open()
    self:initData(godequip_id)
end

function GodEquipRareCtr:initData(godequip_id)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self:UpdateGodEquipData(godequip_id) 
end


function GodEquipRareCtr:UpdateGodEquipData( godequip_id)
    self.layer:UpdateGodEquipData(godequip_id)
end

function GodEquipRareCtr:ShowNewGodEquipData(data )
    self.layer:ShowNewGodEquipData(data)
end


function GodEquipRareCtr:ChangeNowGodEquipData(data )
    self.layer:ChangeNowGodEquipData(data)
end


return GodEquipRareCtr
