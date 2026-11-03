local SettingChooseLayer = class("SettingChooseLayer", require("src.comp.EventLayerAdaptiveWidth"))
local SettingChooseCtr = class("SettingChooseCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance")) 

local SettingImageLayer = class("SettingImageLayer", require("src.comp.LuaLayerBase"))

local SettingTitleCell = class("SettingTitleCell", require("src.comp.EventLayer"))

local SettingIdentificationCell = class("SettingIdentificationCell", require("src.comp.EventLayer"))

local ExTimer = require("src.ex.ExTimer")

local UIMenuItemHead = require("src.comp.menu.UIMenuItemHead")
local UIMenuItemBorder = require("src.comp.menu.UIMenuItemBorder")
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")
local HeroAnim = require("src.person.Hero")

----------------------------------------------------------------------------------
function SettingTitleCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.reset_time = 0

    self.timer = ExTimer:new():bind(self)

    self.spr_bg_2:setVisible(false)
    self.spr_bg_1:setVisible(true)
end

function SettingTitleCell:initDone(title_id, scroll_view)
    self.title_id = title_id
    self.btn_go.title_id = title_id
    local config = cfg.title.title[title_id]
    if not config then return end 
    self.reset_time = 0
    self.lbl_status_2:setVisible(false)

    self.time_node:setVisible(false)

    self.menu:setIsTouchInsideNode(scroll_view)
    self.menu:setSwallowsTouches(false)


    self:setCurType( )
end 

function SettingTitleCell:setCurType( )
    local config = cfg.title.title[self.title_id]
    -- self.image:setSpriteFrame(string.format( "role-title/title%d.png", config.resources_id))    
    ex.Tools:setSpriteFrame(self.image, string.format("role-title/title%d.png", config.resources_id))

    self.time_node:setVisible(false)
    if ex.Player.title_data:checkTitle(self.title_id) and ex.Player.title_data:checkTitleEndTime(self.title_id) ~=0  then 
    
        local endTime = ex.Player.title_data:checkTitleEndTime(self.title_id)

        if endTime == -1 then 

        elseif endTime > 0 and endTime - ex.Game:getServerTime() > 0 then 

            --  setSpriteFrame(ex.Tools:getBorderIconByIdx(data.border_id))    
            if config.time > 0 then 
                self.show_image_type_1:setVisible(false)
                self.show_image_type_2:setVisible(false)

                self.time_node:setVisible(true)

            else 
                self.show_image_type_1:setVisible(false)
                self.show_image_type_2:setVisible(true)
            end 
            self.reset_time = endTime
            
            self.timer:run(handler(self, self.updateUsedTime), 1.0)

            self:updateUsedTime( )
        else 

            self.lbl_status_2:setVisible(true)

            ex.Tools:setGrayAuto(self.image , true)
    
            if config.time > 0 then 
                self.show_image_type_1:setVisible(true)
                self.show_image_type_2:setVisible(false)
            else 
                self.show_image_type_1:setVisible(false)
                self.show_image_type_2:setVisible(true)
            end 
            
        end           
    else 
        self.lbl_status_2:setVisible(true)

        ex.Tools:setGrayAuto(self.image , true)

        if config.time > 0 then 
            self.show_image_type_1:setVisible(true)
            self.show_image_type_2:setVisible(false)
        else 
            self.show_image_type_1:setVisible(false)
            self.show_image_type_2:setVisible(true)
        end 
        
    end 
    
    self.lbl_attr_1:setString(ex.Tools:getLang(122000 + config.ability[1].attr) .. "： " .. config.ability[1].value)
    self.lbl_attr_2:setString(ex.Tools:getLang(122000 + config.ability[2].attr) .. "： " .. config.ability[2].value)

    self.lbl_msg:setString(ex.Tools:getLang(config.remark))

end


function SettingTitleCell:onExit()
    self.timer:stop()
end

function SettingTitleCell:updateUsedTime()
    self.reset_time = self.reset_time - 1

    local show_time  =self.reset_time - ex.Game:getServerTime()

    if show_time <=0 then
        self.reset_time = 0
        self.timer:stop()
        self:setCurType( )
        return
    end

    if show_time < 60 then 
        show_time = 60
    end 


    self.lbl_time:setString( string.format(ex.Tools:getLang(47162), 
    math.floor(show_time / 86400),
    math.floor(show_time % 86400 / 3600 ),
    math.floor(show_time / 60 % 60)
    ))
end

function SettingTitleCell:clickCallback(callback)
    self.btn_go:registerScriptTapHandler(callback)
end
----------------------------------------------------------------------------------
function SettingIdentificationCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end

function SettingIdentificationCell:initDone(data,scroll_view)
    -- self.image:setSpriteFrame(string.format( "setting-identification/spr-%d-da.png", data.level))   
    ex.Tools:setSpriteFrame(self.image, string.format( "setting-identification/spr-%d-da.png", data.level))

    self.identification_id = data.level
    self.btn_go.identification_id = data.level
    self.btn_go.identification_replace = false
    if ex.Player.total_charge < data.recharge then
        ex.Tools:setGrayAuto(self.image , true)
        self.image:setScale(0.45)
        self.image:setPositionY(75)
        self.lbl_status:setVisible(true)
        self.show_image_type:setVisible(false)
        self.lbl_recharge:setString(string.format(ex.Tools:getLang(4704),ex.Player.total_charge/100,data.recharge/100))
    else
        ex.Tools:setGrayAuto(self.image , false)
        self.image:setScale(0.55)
        self.lbl_recharge:setString(ex.Tools:getLang(4705))
        self.lbl_status:setVisible(false)
        self.show_image_type:setVisible(true)
        self.image:setPositionY(61)
        self.btn_go.identification_replace = true
    end

    local str = ""
    for k,v in pairs(data.ability) do
        if k ~= 1 then
            str = str.." "
        end
        str = str..ex.Tools:getLang(2140000 + v.attr)		
        str = ex.StringUtil.formatAttrStr(str, "##" , v.value)
    end
    self.lbl_ability:setString(str)

    self.menu:setIsTouchInsideNode(scroll_view)
    self.menu:setSwallowsTouches(false)
end

function SettingIdentificationCell:clickCallback(callback)
    self.btn_go:registerScriptTapHandler(callback)
end
----------------------------------------------------------------------------------
function SettingImageLayer:onCreate()
    self.lbl_elem_add_title:setString(ex.Tools:getLang(41272))
    self.lbl_elem_add:setString(ex.Tools:getLang(41273))
    self.lbl_unlock_condition_title:setString(ex.Tools:getLang(41274))
    self.lbl_unlock_condition:setString(ex.Tools:getLang(41275))

	-- 角色形象
    self.heroAnim = nil
    
    self.btn_tab1:setTag(1)
    self.btn_tab2:setTag(2)
    self.btn_tab3:setTag(3)
    self.btn_tab4:setTag(4)
    
    self.btn_tab1:setLabelText(ex.Tools:getLang(5361))
    self.btn_tab2:setLabelText(ex.Tools:getLang(5787))
    self.btn_tab3:setLabelText(ex.Tools:getLang(5388))
    self.btn_tab4:setLabelText(ex.Tools:getLang(5507))

    local viewSize = cc.size(self.spr_scroll_bg:getContentSize().width, self.spr_scroll_bg:getContentSize().height - 20)
    self.scroll_view = cc.ScrollView:create(viewSize)
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    :setPosition(self.spr_scroll_bg:getPositionX() - viewSize.width / 2 + 2, self.spr_scroll_bg:getPositionY() + 10)
    self:addChild(self.scroll_view)
end

function SettingImageLayer:setHeroMessage(type , fashion_id )

    if type == 1 then 

        self.lbl_elem_add:setString(ex.Tools:getLang(41273))
        self.lbl_unlock_condition:setString(ex.Tools:getLang(41275))

    elseif type == 2 then 

        local hero_fashion = cfg.herofashion.getConfigByType(fashion_id)
        local show_name = ex.Tools:getLang(hero_fashion.fashion_name)

        self.lbl_unlock_condition:setString(string.format( ex.Tools:getLang(3814), show_name) )

        
        local fashion_data = ex.Player.hero_data.fashion:getFashionDataByID(fashion_id)
        if not fashion_data then 
            fashion_data = {}
            fashion_data.level = 0
        end 

        local hero_fashionup_data =  cfg.herofashionup.getConfigByTypeAndLevel(fashion_id, fashion_data.level )
        local show_att = ""
        for i,v in ipairs(hero_fashionup_data.ability) do
            local str = ex.Tools:getLang(2150000 + v.attr)..":" 
            local str_attr_num = str .. ex.StringUtil.formatAttrStr(" "..ex.Tools:getLang(2160000 + v.attr), "##" , v.value)            
            show_att = show_att .. str_attr_num .."\n"
        end

        self.lbl_elem_add:setString(show_att)   
    end 

end 


function SettingImageLayer:setHeroFashionAnim(hero_type, star, fashion_id)
	if fashion_id == 0  then
		return
    end
    
    if self.heroAnim then
        self.heroAnim:removeFromParent()
        self.heroAnim = nil
    end

    self.heroAnim = require("src.person.Hero"):create("1", "1", 1, 1, 1, fashion_id)
    self.heroAnim:setAnimation(0, "stand", true);
    self.heroAnim:setScale(1.5)
    self.heroAnim:setPosition(self.spr_magic:getPositionX(), self.spr_magic:getPositionY() + 80)
    self.heroAnim:setShadowVisible(false)
    self:addChild(self.heroAnim)

end

function SettingImageLayer:setHeroAnim(hero_type, star)
	-- local hero_type, star = ex.Player:getImageId()
	if hero_type == 0 or star == 0 then
		return
    end
    
    if self.heroAnim then
        self.heroAnim:removeFromParent()
        self.heroAnim = nil
    end

    -- 创建一个骨骼动画
    local hero_skin = ex.Tools:getHeroSkinByStar(hero_type, star)
    self.heroAnim = HeroAnim:create("12323", "123213", hero_type, 1, star, hero_skin)
    self.heroAnim:setShadowVisible(false)
	self.heroAnim:setScale(1.5)
    self.heroAnim:setPosition(self.spr_magic:getPositionX(), self.spr_magic:getPositionY() + 80)
    self:addChild(self.heroAnim)
end

----------------------------------------------------------------------------------
function SettingChooseLayer:onCreate()
    self:addBlackBackground()

    local viewSize = cc.size(self.spr_bg:getContentSize().width, self.spr_bg:getContentSize().height - 20 )
    self.scroll_view = cc.ScrollView:create(viewSize)
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    :setPosition(self.spr_bg:getPositionX() - viewSize.width / 2 + 2, self.spr_bg:getPositionY() + 10)
    self:addChild(self.scroll_view)

    self.btn_confirm:setLabelText(ex.Tools:getLang(41148))
    
	self.layer_image = SettingImageLayer:createWithCCBIFile("ccbi/SettingImageLayer.ccbi")
    self.layer_image:setPosition(cc.p(0, 0))
    self.layer_image:setVisible(false)
    self:addChild(self.layer_image)
    

    -- 添加导航条
    local menu_tab = cpp.UIMenu:create()
    menu_tab:setIsTouchInsideNode(self.btn_scroll_view)
    menu_tab:setSwallowsTouches(false)
    menu_tab:setPosition(cc.p(0, 0))
    self.btn_scroll_view:addChild(menu_tab)

    local btn_tab_str = {5435, 5726, 5180, 4701,5417}
    local margin_x, item_size, scale = 4, nil, 0.95
    for i= 1, #btn_tab_str do
        self["btn_tab"..i] = cpp.UIMenuItemTab:create("button/btn-tab-3.png", "button/btn-tab-4.png", "", 1, 1)
        self["btn_tab"..i]:setScale(scale)
        self["btn_tab"..i]:setTag(i)
        if not item_size then 
            item_size = self["btn_tab"..i]:getContentSize()
            item_size.width = item_size.width * scale
            item_size.height = item_size.height * scale
        end
        self["btn_tab"..i]:setAnchorPoint(ex.a.bottom_center)
        self["btn_tab"..i]:setPosition(margin_x + (i - 0.5) * item_size.width , 0)
        menu_tab:addChild(self["btn_tab"..i])
        self["btn_tab"..i]:setLabelText(ex.Tools:getLang(btn_tab_str[i]))
        self["btn_tab"..i]:setLabelColor(FONT_BROWN)
        self["btn_tab"..i]:setLabelOffset(cc.p(0, -2))
    end
    self.btn_scroll_view:setContentSize(cc.size(2 * margin_x + #btn_tab_str * item_size.width, self.btn_scroll_view:getViewSize().height))
    self.btn_scroll_view:setContentOffset(self.btn_scroll_view:maxContainerOffset())

end

----------------------------------------------------------------------------------

local SettingChooseLayerType = {
    SCLT_PHOTO = 1,
    SCLT_BORDER = 2,
    SCLT_IMAGE = 3,
    SCLT_IDENTIFICATION = 4,
    SCLT_TITLE = 5,
}

function SettingChooseCtr:onCreate()
	self:setCCBIPath("ccbi/SettingChooseLayer.ccbi")
	self:setIsSingle(false)
end

function SettingChooseCtr:getLayerClass()
	return SettingChooseLayer
end

function SettingChooseCtr:openWindow(layer_type)
	if self:isOpened() then
		return
	end

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/rank.plist")
    sfc:addSpriteFrames("ccbi-res/role-title.plist")
    sfc:addSpriteFrames("ccbi-res/setting.plist")

    if layer_type == nil then
        layer_type = SettingChooseLayerType.SCLT_PHOTO
    end

    self.layer_type = layer_type
    self.layer_image_type = 1
    self.selected_idx = -1
    self.selected_star = -1
    self.fashion_id = -1

	self:loadLayer()
	self:open()
	self:initData()
end

function SettingChooseCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirmChange))
    self.layer.btn_identification_chat:registerScriptTapHandler(handler(self, self.onIdentificationStatus))

	self.layer:addEvent(EVENT.BORDER_EVENT.ACTIVE_UPDATE,handler(self,self.updateLayer))
	self.layer:addEvent(EVENT.BORDER_EVENT.USE_UPDATE,handler(self,self.updateLayer))
	self.layer:addEvent(EVENT.BORDER_EVENT.HEAD_USE_UPDATE,handler(self,self.updateLayer))

    for i=1,5 do
        self.layer["btn_tab"..i]:registerScriptTapHandler(handler(self, self.onTab))
    end
   
    for i=1,4 do
        self.layer.layer_image["btn_tab"..i]:registerScriptTapHandler(handler(self, self.onImageTab))
    end

    NetManager:sendMessage(ProtocolID.GReqScanTitleList)

    self:changeLayer(self.layer_type)
end

function SettingChooseCtr:updateLayer(event)
    self:changeLayer()
end

function SettingChooseCtr:changeLayer(layer_type)
    if self.layer == nil then
        return
    end
    
    if layer_type ~= nil then
        if self.layer_type ~= layer_type then
            self.layer_type = layer_type
            self.layer_image_type = 1
            self.selected_idx = -1
        end
    end

    self.layer.btn_tab1:setChecked(self.layer_type == SettingChooseLayerType.SCLT_PHOTO)
    self.layer.btn_tab2:setChecked(self.layer_type == SettingChooseLayerType.SCLT_BORDER)
    self.layer.btn_tab3:setChecked(self.layer_type == SettingChooseLayerType.SCLT_IMAGE)
    self.layer.btn_tab4:setChecked(self.layer_type == SettingChooseLayerType.SCLT_IDENTIFICATION)
    self.layer.btn_tab5:setChecked(self.layer_type == SettingChooseLayerType.SCLT_TITLE)

    self.layer.scroll_view:setVisible(self.layer_type ~= SettingChooseLayerType.SCLT_IMAGE)
    self.layer.layer_image:setVisible(self.layer_type == SettingChooseLayerType.SCLT_IMAGE)
    
    self.layer.btn_confirm:setVisible(true)
    self.layer.btn_confirm:setLabelText(ex.Tools:getLang(41148))

    self.layer.node_identification:setVisible(false)
    
    if self.layer_type == SettingChooseLayerType.SCLT_PHOTO then
        local vec_photo_list = self:getPhotoList()
        local vec_len = table.nums(cfg.headunlock.headunlock)
        self:updateIcon(vec_photo_list, ex.Player.head_id, vec_len, UIMenuItemHead)
    elseif self.layer_type == SettingChooseLayerType.SCLT_BORDER then
        local vec_border_list = self:getBorderList()
        local vec_len = table.nums(cfg.border.icon)
        self:updateIcon(vec_border_list, ex.Player.border_id, vec_len, UIMenuItemBorder)
    elseif self.layer_type == SettingChooseLayerType.SCLT_IMAGE then
        -- if self.selected_idx > 0 then
        --     self.layer.layer_image:setHeroAnim(self.selected_idx, self.selected_star)
        -- else
            self.selected_idx, self.selected_star = ex.Player:getImageId()
            if self.selected_idx > 0  and  self.selected_star == 0 then 
                self.layer.layer_image:setHeroFashionAnim(self.selected_idx, self.selected_star, self.selected_idx)
                self.layer.layer_image:setHeroMessage(2, self.selected_idx)
            else 
                self.layer.layer_image:setHeroAnim(ex.Player:getImageId())
                self.layer.layer_image:setHeroMessage(1, self.selected_idx)
            end 
        -- end

        self.layer.layer_image.btn_tab1:setChecked(self.layer.layer_image.btn_tab1:getTag() == self.layer_image_type)
        self.layer.layer_image.btn_tab2:setChecked(self.layer.layer_image.btn_tab2:getTag() == self.layer_image_type)
        self.layer.layer_image.btn_tab3:setChecked(self.layer.layer_image.btn_tab3:getTag() == self.layer_image_type)
        self.layer.layer_image.btn_tab4:setChecked(self.layer.layer_image.btn_tab4:getTag() == self.layer_image_type)  
        
        self:updateImageScrollView()
    elseif self.layer_type == SettingChooseLayerType.SCLT_IDENTIFICATION then
        self.layer.btn_identification_chat:setChecked(true)
        if ex.Player.peerage_status == 0 then
            self.layer.btn_identification_chat:setChecked(false)
        end
        self.layer.node_identification:setVisible(true)
        self:updateIdentificationScrollView()

        --self.layer.btn_confirm:setLabelText(ex.Tools:getLang(3601))
    elseif self.layer_type == SettingChooseLayerType.SCLT_TITLE then
        self:updateTitleScrollView()
        
        self.layer.btn_confirm:setLabelText(ex.Tools:getLang(3601))
    end
end

function SettingChooseCtr:getPhotoList()
    local config = cfg.headunlock.headunlock
    local headLen = table.nums(config)
    local tmp = {}
    for k,v in pairs(config) do
        table.insert(tmp,v)
    end
    local function sor(a,b)
        -- return a.icon < b.icon
        local proA = ex.Player.border_data:headActiveById(a.icon)  and 100 or 0
        local proB = ex.Player.border_data:headActiveById(b.icon)  and 100 or 0
        if proA ~= proB then return proA > proB end 
        return a.icon < b.icon
    end
    table.sort(tmp,sor)
    local list = {}
    print("headLen", headLen)
    
    if ex.Player.head_id == 0 then
        ex.Player.head_id = 1
    end
    
    -- 已经选择的头像放在第一格
    if ex.Player.head_id > 0 then
        local v = TableEx.findValueFunction(cfg.headunlock.headunlock, function(value)
            return value.icon == ex.Player.head_id
        end)
    
        if v then
            table.insert(list, v)
        end
    end
    
    for k,v in ipairs(tmp) do
        if v.icon ~= ex.Player.head_id and v.icon > 0 then
            table.insert(list, v)
        end
    end

    return list
end

function SettingChooseCtr:getBorderList()
	local config = cfg.border.icon
	local headLen = table.nums(config)
	local list = {}
	print("headLen", headLen)

	for k,v in pairs(config) do
		if v.icon ~= ex.Player.border_id then
			table.insert(list, v)
		end
	end

	local function sor(a,b)
		local proA = ex.Player.border_data:borderActiveById(a.icon) and 100 or 0
		local proB = ex.Player.border_data:borderActiveById(b.icon) and 100 or 0
		if proA == proB then return a.icon < b.icon end 
		return proA > proB 
	end 
	table.sort(list, sor)
    table.insert(list, 1, config[ex.Player.border_id] )
    
    return list
end

function SettingChooseCtr:updateIcon(list,id,headLen,item_class)
    self.layer.scroll_view:getContainer():removeAllChildren()
    self.layer.list = {}

	local menu = cpp.UIMenu:create()
	:setIsTouchInsideNode(self.layer.scroll_view)
	:setSwallowsTouches(false)
	:setPosition(cc.p(0, 0))
	self.layer.scroll_view:addChild(menu)

	local viewSize = self.layer.scroll_view:getViewSize()
	local item_size = UIMenuItemBorder:createHead(1):getContentSize()
	item_size = cc.size(item_size.width + 30, item_size.height + 20)

	local col = math.floor(viewSize.width / item_size.width) -- 列数
	local row = math.ceil(1.0 * headLen / col) -- 行数
	local cont_height = item_size.height * row
	cont_height = math.max(cont_height , viewSize.height)

	self.layer.scroll_view:setContentSize(cc.size(viewSize.width, cont_height))
	self.layer.scroll_view:setContentOffset(cc.p(0, viewSize.height - cont_height))

	cont_height = cont_height - item_size.height * 0.5

	local start = cc.p(viewSize.width * 0.5 - (item_size.width * col * 0.5), cont_height)
	start.x = start.x + item_size.width * 0.5

	local index = 0
	for _,v in pairs(list) do
		local x = index % col
		local y = math.floor(index / col)

		-- local tem = UIMenuItemBorder
		local icon = v.icon
		-- local id = ex.Player.border_id
		local node = item_class:createHead(icon, index == 0, index == 0 and icon == id)
		node.data = v
		node:setPosition(start.x + x * item_size.width, start.y - y * item_size.height)
		node:registerScriptTapHandler(handler(self, self.onBtnSelected))
		menu:addChild(node)

        if item_class == UIMenuItemHead then
			local head_frame = cc.Sprite:createWithSpriteFrameName("head-icon/spr-frame-2.png")
			head_frame:setPosition(node:getContentSize().width / 2, node:getContentSize().height / 2)
            node:addChild(head_frame)
        elseif item_class == UIMenuItemBorder then
            local active = ex.Player.border_data:borderActiveById(icon)
            local can_activate = false
            if not active then 
                local has = true 
                local conf = cfg.border.icon[icon]
                for i,v2 in ipairs(conf.condition) do
                    has = ex.Player.backpack_data:getItemNum(v2.item_type) >= v2.item_num
                    if has == false then  
                        break 
                    else
                        can_activate = true
                    end
                end
            end
            node:setCanActivate(can_activate)
		end

		table.insert(self.layer.list, node)
		index = index + 1
	end
end

function SettingChooseCtr:updateImageScrollView()
    local layer_image = self.layer.layer_image

    layer_image.scroll_view:getContainer():removeAllChildren()
	layer_image.hero_list_view = {}

    local cur_list = {}
    if self.layer_image_type == 1 then
        cur_list = ex.Player.hero_data:editIllustratListByStar(1, 6)
    elseif self.layer_image_type == 2 then
        cur_list = ex.Player.hero_data:editIllustratListByStar(6, 10)
    elseif self.layer_image_type == 3 then
        cur_list = ex.Player.hero_data:editIllustratListByStar(10, 99)
    else
        -- 重新组装数据 
        -- cfg.herofashion.herofashion
        for i,v in pairs(cfg.herofashion.herofashion) do
            local cur_fashion_data = {}
            cur_fashion_data.type = v.hero_type
            cur_fashion_data.star = 0
            cur_fashion_data.fashion_id = v.fashion_id
            cur_fashion_data.unlock = ex.Player.hero_data.fashion:checkFashionStatue(cur_fashion_data.fashion_id)
            table.insert(cur_list, cur_fashion_data)

        end
    end
	local illustrat_list = {}

    local cur_type, cur_star = ex.Player:getImageId()
	if cur_type > 0 and cur_star > 0 then
		-- 把已选的英雄摆在最前面
		for _,v in pairs(cur_list) do
            if v.type == cur_type and v.star == cur_star then
				table.insert(illustrat_list, v)
				break
			end
		end

		for _,v in pairs(cur_list) do
			if v.type ~= cur_type or v.star ~= cur_star then
				table.insert(illustrat_list, v)
			end
		end
	else
		illustrat_list = cur_list
    end

	local hero_menu = cpp.UIMenu:create()
    :setIsTouchInsideNode(layer_image.scroll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    layer_image.scroll_view:addChild(hero_menu)

    local viewSize = layer_image.scroll_view:getViewSize()
    local item_size = cc.Sprite:createWithSpriteFrameName("other/rare-0.png"):getContentSize()
    item_size = cc.size(item_size.width + 15, item_size.height + 12)

    local heroLen = table.nums(illustrat_list)
    local col = math.floor(viewSize.width / item_size.width) -- 列数
    local row = math.ceil(1.0 * heroLen / col) -- 行数
    local cont_height = item_size.height * row
    cont_height = math.max(cont_height , viewSize.height)

    layer_image.scroll_view:setContentSize(cc.size(viewSize.width, cont_height))
    layer_image.scroll_view:setContentOffset(cc.p(0, viewSize.height - cont_height))

    cont_height = cont_height - item_size.height * 0.5

    local start = cc.p(viewSize.width * 0.5 - (item_size.width * col * 0.5), cont_height)
    start.x = start.x + item_size.width * 0.5

    local index = 0
    for _,v in pairs(illustrat_list) do
    	local x = index % col
        local y = math.floor(index / col)

        local elem = cfg.herotype.star[v.type].elem
        --local level = cfg.herostar.star[v.star].level_limit

        local node = UIMenuItemHero:createWithData("0", v.type, elem, 1, v.star, 0 , false, v.fashion_id)
        node:setShopCountVisible(false)
        node:removeLevel()
        node:setPosition(start.x + x * item_size.width, start.y - y * item_size.height)
        node:registerScriptTapHandler(handler(self, self.onBtnSelected))
        hero_menu:addChild(node)


        node:setSelected(v.type == cur_type and v.star == cur_star) -- 设置已选
        if self.layer_image_type == 4 then 
            node:setIcon(v.type, true, v.fashion_id, true )
            node:removeStar()

            node:setSelected(v.fashion_id == cur_type ) -- 设置已选
        end 

        if v.unlock ~= true then
            node:setGray(false)
        end

        

        node.unlock = v.unlock
        if v.unlock == false then node:setGrayed() end  

    	table.insert(layer_image.hero_list_view, node)

    	index = index + 1
    end
end

function SettingChooseCtr:updateIdentificationScrollView()
    self.layer.scroll_view:getContainer():removeAllChildren()

    self.layer.list = {}

    
    self.selected_idx = ex.Player.peerage_level
    if ex.Player.peerage_level == 0 then
        self.selected_idx = 1
        self.layer.btn_confirm:setLabelText(ex.Tools:getLang(3601))
    end

    local sort_data = cfg.peerageemblem.peerageemblem

    local sort = function (a,b )
        return a.level < b.level
    end

    table.sort( sort_data, sort )

    local config = sort_data[1]
    if ex.Player.total_charge < config.recharge then
        self.layer.btn_confirm:setVisible(true)
    else
        self.layer.btn_confirm:setVisible(false)
    end


    for _,v in ipairs(sort_data) do
        local task_node = SettingIdentificationCell:createWithCCBIFile("ccbi/SettingIdentificationCell.ccbi")
        task_node:setSwallowTouches(false)
        task_node:setIgnoreAnchorPointForPosition(false)
        task_node:setAnchorPoint(ex.a.center)

        task_node:initDone(v, self.layer.scroll_view)
        task_node:clickCallback(handler(self, self.onBtnSelected))

        -- task_node:setName("title_cell" .. index)
        self.layer.scroll_view:addChild(task_node)

        task_node.spr_bg_1:setVisible(v.level ~= self.selected_idx)
        task_node.spr_bg_2:setVisible(v.level == self.selected_idx)
       
        table.insert(self.layer.list, task_node)
    end

    local viewSize = self.layer.scroll_view:getViewSize()
    local item_size = SettingTitleCell:createWithCCBIFile("ccbi/SettingIdentificationCell.ccbi"):getContentSize()
    item_size.height = item_size.height + 5

    -- 调整ScrollView
    --self:adjustScrollView()
    local cont_height = item_size.height * table.nums(self.layer.list)
    cont_height = math.max(cont_height , viewSize.height)

    self.layer.scroll_view:setContentSize(cc.size(viewSize.width, cont_height))
    self.layer.scroll_view:setContentOffset(cc.p(0, viewSize.height - cont_height))

    -- 按排好的顺序显示
    local start = cc.p(viewSize.width * 0.5 - 2, cont_height - item_size.height * 0.5)
    for i,v in ipairs(self.layer.list) do
        v:setPosition(start.x, start.y - (i - 1) * item_size.height)
    end    

end


function SettingChooseCtr:updateTitleScrollView()
    self.layer.scroll_view:getContainer():removeAllChildren()

    self.layer.list = {}

    self.selected_idx = 1

    local index = 0

    local sort_data = ex.Player.title_data:getSortTitleData()

    local sort = function (a,b )
        if a.sort_index == b.sort_index then 
            return a.idx < b.idx   
        else 
            return a.sort_index > b.sort_index
        end 
    end

    table.sort( sort_data, sort )

    for _,v in pairs(sort_data) do
        -- local task_node = self:addTaskCell(v.idx)
        local task_node = SettingTitleCell:createWithCCBIFile("ccbi/SettingTitleCell.ccbi")
        task_node:setSwallowTouches(false)
        task_node:setIgnoreAnchorPointForPosition(false)
        task_node:setAnchorPoint(ex.a.center)

        task_node:initDone(v.idx, self.layer.scroll_view)
        task_node:clickCallback(handler(self, self.onBtnSelected))

        task_node:setName("title_cell" .. index)
        self.layer.scroll_view:addChild(task_node)

        task_node.spr_bg_1:setVisible(v.idx ~= self.selected_idx)
        task_node.spr_bg_2:setVisible(v.idx == self.selected_idx)

        -- task_node.btn_go:registerScriptTapHandler(handler(self, self.onBtnSelected))
    
        table.insert(self.layer.list, task_node)
        index = index + 1
    end


    local viewSize = self.layer.scroll_view:getViewSize()
    --cc.size(480, 150)
    local item_size = SettingTitleCell:createWithCCBIFile("ccbi/SettingTitleCell.ccbi"):getContentSize()
    item_size.height = item_size.height + 5

    -- 调整ScrollView
    --self:adjustScrollView()
    local cont_height = item_size.height * table.nums(self.layer.list)
    cont_height = math.max(cont_height , viewSize.height)

    self.layer.scroll_view:setContentSize(cc.size(viewSize.width, cont_height))
    self.layer.scroll_view:setContentOffset(cc.p(0, viewSize.height - cont_height))

    -- 按排好的顺序显示
    local start = cc.p(viewSize.width * 0.5 - 2, cont_height - item_size.height * 0.5)
    for i,v in ipairs(self.layer.list) do
        v:setPosition(start.x, start.y - (i - 1) * item_size.height)
    end    
end

function SettingChooseCtr:onTab(tag, pSender)
    if tag == self.layer_type then
        return
    end
    if tag == SettingChooseLayerType.SCLT_IDENTIFICATION then
        self.layer.btn_identification_chat:setChecked(true)
        if ex.Player.peerage_status == 0 then
            self.layer.btn_identification_chat:setChecked(false)
        end
        self.layer.node_identification:setVisible(true)
    else
        self.layer.node_identification:setVisible(false)
    end
    self:changeLayer(tag)
end

function SettingChooseCtr:onImageTab(tag, pSender)
    if tag == self.layer_image_type then
        return
    end

    -- self.layer_image_type = 1
    -- self.selected_idx = -1

    self.layer_image_type = tag
    self:changeLayer(self.layer_type)
end

function SettingChooseCtr:onBtnSelected(tag, pSender)
    if self.layer_type == SettingChooseLayerType.SCLT_PHOTO then
        if not pSender.data then
            ex.MessageView:add(ex.Tools:getLang(47197))
            return
        end
        local is_active = ex.Player.border_data:headActiveById(pSender.data.icon)
    
        if not is_active then
            ex.MessageView:add(ex.Tools:getLang(pSender.data.tips_lang))
            return 
        end

        self.selected_idx = pSender.data.icon
        
        for _,v in pairs(self.layer.list) do
            v:setSelected(v.head_id == pSender.head_id)
        end
    elseif self.layer_type == SettingChooseLayerType.SCLT_BORDER then
        local conf = cfg.border.icon[pSender.icon_id]
        local active = ex.Player.border_data:borderActiveById(pSender.icon_id)
        local has = true 
        if not active then 
            if conf.condition ~= "" and table.nums(conf.condition) > 0 then 
                if conf.active_type == 2 then 
                    for i,v in ipairs(conf.condition) do
                        has = ex.Player.backpack_data:getItemNum(v.item_type) >= v.item_num
                        if has == false then break end
                    end
                    if has == false then 
                        ex.MessageView:add(ex.Tools:getLang(conf.tips_lang))
                        -- ex.MessageView:add("ex.Tools:getLang(conf.tips_lang)")
                        self.layer.btn_confirm:setLabelText(ex.Tools:getLang(41148))
                        return 
                    end
                else 
                    ex.MessageView:add(ex.Tools:getLang(conf.tips_lang))
                    -- ex.MessageView:add("ex.Tools:getLang(conf.tips_lang)")
                    self.layer.btn_confirm:setLabelText(ex.Tools:getLang(41148))
                    return 
                end
            end 
        end 
        for _,v in pairs(self.layer.list) do
            v:setSelected(v.icon_id == pSender.icon_id)
        end
        
        self.selected_idx = pSender.icon_id
        
        if not active then 
            if has then 
                self.layer.btn_confirm:setLabelText(ex.Tools:getLang(41147))
            end
        else
            self.layer.btn_confirm:setLabelText(ex.Tools:getLang(41148))
        end
        -- self.layer.select_id[self.cur_tag] = pSender.icon_id
    elseif self.layer_type == SettingChooseLayerType.SCLT_IMAGE then
        for _,v in pairs(self.layer.layer_image.hero_list_view) do
            v:setSelected(v.hero_type == pSender.hero_type and v.star == pSender.star and v.fashion_id == pSender.fashion_id)
        end

        if self.layer_image_type == 4 then 
            self.layer.layer_image:setHeroFashionAnim(pSender.hero_type, pSender.star, pSender.fashion_id)
            self.layer.layer_image:setHeroMessage(2, pSender.fashion_id)
        else 
            self.layer.layer_image:setHeroAnim(pSender.hero_type, pSender.star)
            self.layer.layer_image:setHeroMessage(1, pSender.fashion_id)
        end 
        
        self.selected_idx = pSender.hero_type
        self.selected_star = pSender.star
        self.fashion_id = pSender.fashion_id
    elseif self.layer_type == SettingChooseLayerType.SCLT_IDENTIFICATION then
        self.selected_idx = pSender.identification_id

        for i,v in ipairs(self.layer.list) do
            if v.identification_id == self.selected_idx then 
                v.spr_bg_1:setVisible(false)
                v.spr_bg_2:setVisible(true)
            else
                v.spr_bg_2:setVisible(false)
                v.spr_bg_1:setVisible(true)
            end 
        end

        if pSender.identification_replace then
            self.layer.btn_confirm:setVisible(false)
        else
            self.layer.btn_confirm:setVisible(true)
            self.layer.btn_confirm:setLabelText(ex.Tools:getLang(3601))
        end
    elseif self.layer_type == SettingChooseLayerType.SCLT_TITLE then
        self.selected_idx = pSender.title_id

        for i,v in ipairs(self.layer.list) do
            if v.title_id == self.selected_idx then 
                v.spr_bg_1:setVisible(false)
                v.spr_bg_2:setVisible(true)
            else
                v.spr_bg_2:setVisible(false)
                v.spr_bg_1:setVisible(true)
            end 
        end

        if ex.Player.title_data:checkTitle(pSender.title_id) and ex.Player.title_data:checkTitleEndTime(pSender.title_id) ~=0 then 
            self.layer.btn_confirm:setVisible(false)
        else
            self.layer.btn_confirm:setVisible(true)
            self.layer.btn_confirm:setLabelText(ex.Tools:getLang(3601))
        end
    end
end

function SettingChooseCtr:onIdentificationStatus(tag, pSender)
    local req = Role_pb.GReqCommentSharedReward()
    NetManager:sendMessage(ProtocolID.GReqUpdatePeerageStatus, req)
end


function SettingChooseCtr:onConfirmChange(tag, pSender)
    if self.layer_type == SettingChooseLayerType.SCLT_PHOTO then
        if self.selected_idx == ex.Player.head_id then
            ex.MessageView:add(ex.Tools:getLang(47594))
        end

        local req_replace = HeadPortrait_pb.GReqChangeHeadPortrait()
        req_replace.idx = self.selected_idx
        NetManager:sendMessage(ProtocolID.GReqChangeHeadPortrait, req_replace)
    elseif self.layer_type == SettingChooseLayerType.SCLT_BORDER then
        if self.selected_idx == ex.Player.border_id then
            ex.MessageView:add(ex.Tools:getLang(47705))
            return
        end

        local active = ex.Player.border_data:borderActiveById(self.selected_idx)
		if not active then 
			local has = true 
            local conf = cfg.border.icon[self.selected_idx]
            if conf == nil then
                ex.MessageView:add(ex.Tools:getLang(47705))
                return
            end

			for i,v in ipairs(conf.condition) do
				has = ex.Player.backpack_data:getItemNum(v.item_type) >= v.item_num
				if has == false then
					return 
				else
					--激活协议
					local req_active = Border_pb.GReqActiveBorder()
					req_active.idx = self.selected_idx
					NetManager:sendMessage(ProtocolID.GReqActiveBorder, req_active)
				end
			end
		else 
			--替 换协议
			local req_replace = Border_pb.GReqUseBorder()
			req_replace.idx = self.selected_idx
			NetManager:sendMessage(ProtocolID.GReqUseBorder, req_replace)
		end
    elseif self.layer_type == SettingChooseLayerType.SCLT_IMAGE then
        local cur_list = {}
        if self.layer_image_type == 1 then
            if self.selected_star >= 6 then
                ex.MessageView:add(ex.Tools:getLang(47198))
                return
            end
            cur_list = ex.Player.hero_data:editIllustratListByStar(1, 6)
        elseif self.layer_image_type == 2 then
            if self.selected_star < 6 or self.selected_star >= 10 then
                ex.MessageView:add(ex.Tools:getLang(47198))
                return
            end
            cur_list = ex.Player.hero_data:editIllustratListByStar(6, 10)
        elseif self.layer_image_type == 3 then
            if self.selected_star < 10 then
                ex.MessageView:add(ex.Tools:getLang(47198))
                return
            end
            cur_list = ex.Player.hero_data:editIllustratListByStar(10, 99)
        else
            -- print("self.selected_idx   ", self.selected_idx)
            
            if self.fashion_id < 1 then 
                ex.MessageView:add(ex.Tools:getLang(47198))
                return 
            end 
            
            if ex.Player.hero_data.fashion:checkFashionStatue(self.fashion_id) == false then 
                ex.MessageView:add(ex.Tools:getLang(41280))
                return 
            end 

        end

        if self.layer_image_type ==  4 then
            ex.Player:setImageId(self.fashion_id, 0)
            ex.Player:reqChangeHead()
        else 

            for i,v in ipairs(cur_list) do
                if v.type == self.selected_idx and v.star == self.selected_star then
                    if v.unlock ~= true then
                        ex.MessageView:add(ex.Tools:getLang(41280))
                        return
                    end

                    ex.Player:setImageId(v.type, v.star)
                    ex.Player:reqChangeHead()
                end
            end

        end 
    elseif self.layer_type == SettingChooseLayerType.SCLT_IDENTIFICATION then
        local config = cfg.peerageemblem.peerageemblem[self.selected_idx]
        if ex.Player.total_charge < config.recharge then
            local event_arg = "act_recharge_smart"
          
            ex.JumpManager:jumpByAtom(event_arg)
            self:closeWindow()
            require("src.layer.SettingCtr"):instance():closeWindow()
        else
            -- 替换聊天标志

        end
    elseif self.layer_type == SettingChooseLayerType.SCLT_TITLE then
        local config = cfg.title.title[self.selected_idx]
        ex.JumpManager:jumpByAtom(config.jump.event_arg)

        self:closeWindow()
        require("src.layer.SettingCtr"):instance():closeWindow()
    end

	self:changeLayer(self.layer_type)
end

return SettingChooseCtr