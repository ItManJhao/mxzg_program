local BackpackLayer = class("BackpackLayer", require("src.comp.EventLayer"))

local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")
local UIItemHeroPiece = require("src.comp.menu.UIMenuItemHeroPiece")

function BackpackLayer:getAsynImage()
    local vec_image = {
        {image_name = "ccbi-res/map-bg-backpack-1.jpg", remove_type=1},
    }
    return vec_image
end


function BackpackLayer:onCreate()
    -- print("BackpackLayer:onCreate1111")
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    
    local spr_bg = cc.Sprite:create("ccbi-res/map-bg-backpack-1.jpg")
    spr_bg:setScale(ex.p.width / spr_bg:getContentSize().width, ex.p.height / spr_bg:getContentSize().height)
    spr_bg:setPosition(ex.p.center().x - self:getPositionX(), ex.p.center().y - self:getPositionY())
    self:addChild(spr_bg, -2)

    local menu_tab = cpp.UIMenu:create()
    menu_tab:setIsTouchInsideNode(self.btn_scroll_view)
    menu_tab:setSwallowsTouches(false)
    menu_tab:setPosition(cc.p(0, 0))
    self.btn_scroll_view:addChild(menu_tab)

    -- 添加导航条
    local tags = {ItemData.IT_EQUIP,
                  ItemData.IT_PROP,
                  ItemData.IT_PIECE,
                  ItemData.IT_SPECIAL,
                  ItemData.IT_HERO_STONE,
                  ItemData.IT_HERO_GODEQUIP,
                  ItemData.MAGIC_WAND,
                  ItemData.IT_HALLOWS,
                  ItemData.PET
    }
    local btn_tab_str = {71, 72, 73, 74, 75, 76, 57101, 77,4811}
    local margin_x, space_x, item_size, scale = 4, 10, nil, 1
    for i= 1, #btn_tab_str do
        self["btn_tab"..i] = cpp.UIMenuItemTab:create("button/btn-tab-1.png", "button/btn-tab-2.png", "", 1, 1)
        self["btn_tab"..i]:setScale(scale)
        if not item_size then 
            item_size = self["btn_tab"..i]:getContentSize()
            item_size.width = item_size.width * scale
            item_size.height = item_size.height * scale
        end
        self["btn_tab"..i]:setTag(tags[i])
        self["btn_tab"..i]:registerScriptTapHandler(handler(self, self.onTabChange))
        self["btn_tab"..i]:setAnchorPoint(ex.a.bottom_center)
        self["btn_tab"..i]:setPosition(margin_x + (i - 0.5) * item_size.width + (i - 1) * space_x, 0)
        menu_tab:addChild(self["btn_tab"..i])
        self["btn_tab"..i]:setLabelText(ex.Tools:getLang(btn_tab_str[i]))
        self["btn_tab"..i]:setLabelColor(FONT_BROWN)
        self["btn_tab"..i]:setLabelOffset(cc.p(0, -2))
    end
    self.btn_scroll_view:setContentSize(cc.size(2 * margin_x + #btn_tab_str * item_size.width + (#btn_tab_str - 1) * space_x, self.btn_scroll_view:getViewSize().height))
    self.btn_scroll_view:setContentOffset(self.btn_scroll_view:maxContainerOffset())

	self.btn_tab2:setChecked(true)

    ex.RedDotManager:setStickNode(RedDotType.ZCJ_DHBB_BBSP, self.btn_tab3)

    self.btn_tab3:setName("btn_piece")

    self.btn_get:registerScriptTapHandler(handler(self, self.onGet))
    self.btn_sale:registerScriptTapHandler(handler(self, self.onSale))
    -- self.btn_sale:setLabelText(" ")
    -- self.btn_sale:setLabelSize(44)
    -- self.btn_sale:setLabelColor(cc.c3b(255,255,255))
    -- self.btn_sale:setLabelOutLine(cc.c4b(131,43,22,255))


    self.spr_box_size_origin = self.spr_box:getContentSize()
    self.scroll_view_size_origin = cc.size(self.spr_box_size_origin.width, self.spr_box_size_origin.height - 10)

    self.item_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()
    self.item_size = cc.size(self.item_size.width * ex.s.global_scale + 15, self.item_size.height * ex.s.global_scale + 17 * math.max(1, ex.s.global_scale))

    self.scroll_view = require("src.comp.UIScrollViewBackpack"):createWithSize(self.scroll_view_size_origin)
    self.scroll_view:setPosition(0, 5)
    self.scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.scroll_view:setItemSize(cc.size(self.item_size.width + 10, self.item_size.height + 10))
    self.scroll_view:setItemOffset(cc.p(0, 5))
    self.scroll_view:setAutoFull(true)
    self.scroll_view:setCreateNum(4)
    self.spr_box:addChild(self.scroll_view)

    self.cur_layer_tab = ItemData.IT_INVALID

    self:addEvent(EVENT.BACK_PACK_EVENT.OPEN_BOX_REWARD,handler(self,self.onOpenBoxReward))
    self:addEvent(EVENT.BACK_PACK_EVENT.BACKPACK_UPDATA_LIST,handler(self,self.onOpenBoxReward))


    self:addEvent(EVENT.RUNES_EVENT.REMOVE, handler(self, self.onOpenBoxReward))
    self:addEvent(EVENT.RUNES_EVENT.RUNES_INIT,handler(self,self.onOpenBoxReward))
    self:addEvent(EVENT.RUNES_EVENT.RUNES_ADD,handler(self,self.onOpenBoxReward))
    self:addEvent(EVENT.RUNES_EVENT.RUNES_DELETE,handler(self,self.onOpenBoxReward)) 
    self:addEvent(EVENT.RUNES_EVENT.SELECT_SMITH_UPDATE_TABLE,handler(self,self.onOpenBoxReward)) 
    self:addEvent(EVENT.ARTIFACTS.DELETE,handler(self,self.onOpenBoxReward)) 
    
    local spine_girl = sp.SkeletonAnimation:create("spine/shangcheng.json","spine/shangcheng.atlas", 1)
    spine_girl:setAnimation(0, "act", true)
    -- spine_girl:setScale(0.75)
    spine_girl:setPosition(200, self.spr_bg:getPositionY() + self.spr_bg:getContentSize().height - 250)
    self.spr_bg:addChild(spine_girl, -1)
    -- self.spr_bubble_bg:setPosition(220,950)

    self.rich_shop_info = require("src.comp.RichTextEx"):create()
	:setFontSize(18)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#7A472D")
    :setAnchorPoint(0.5, 0.5)
    :setScaleX(-1)
	self.spr_bubble_bg:addChild(self.rich_shop_info, 10)
    self.rich_shop_info:setPosition(self.spr_bubble_bg:getContentSize().width / 2,55)

    local menu = cpp.UIMenu:create()
    menu:setPosition(self.rich_shop_info:getPosition())
    self.spr_bubble_bg:addChild(menu, 11)
    self.btn_rich_shop_info = cpp.UIMenuItemImage:create()
    self.btn_rich_shop_info:setPosition(0,0)
    self.btn_rich_shop_info:registerScriptTapHandler(handler(self,self.openRichTextUrl))
    menu:addChild(self.btn_rich_shop_info)


    -- self.rich_shop_info:setCallback(handler(self, self.openRichTextUrl))
    -- self.spr_bubble_bg:setContentSize(cc.size(self.rich_shop_info:getContentSize().width,self.rich_shop_info:getContentSize().height+ 80))

    self:initDone()
end

function BackpackLayer:openRichTextUrl(url)
    local shop_type = cfg.system.back_bubble_shop
    if shop_type == nil then return end 
    cfg.funcopen.main_shop.open(shop_type)
end

function BackpackLayer:bubbleIsVisible( )
    local shop_type = cfg.system.back_bubble_shop
    local item_type = cfg.system.back_bubble_item
    local discount = cfg.system.back_bubble_discount
    
    local shop_cfg = ex.Player.market_data:getCfgByType(shop_type)
    local shop_data = ex.Player.market_data:getDataByType(shop_type)
    -- dump(shop_cfg)
    local show = false
    local item_type_name = ""


    for i,v in pairs(shop_data or {}) do
        -- dump(v)
        local item_data = shop_cfg[v.idx]
        if v.buy_num < item_data.buy_limit then 
            if item_data.item_type[1].item_type == item_type and item_data.discount <= discount then 
                local item_data = shop_cfg[v.idx]
                item_type_name = string.format(ex.Tools:getLang(47643),item_data.discount / 10,ex.Tools:getLang(cfg.item.item[item_data.item_type[1].item_type].name))
                show = true 
                break
            end
        end
    end

    self.spr_bubble_bg:setVisible(show)
    if show == true then
        local str_content = string.format(ex.Tools:getLang(3604), item_type_name)
        self.rich_shop_info:setXmlTextLua(str_content)
        self.rich_shop_info:formatText()
        self.btn_rich_shop_info:setContentSize(cc.size(self.rich_shop_info:getContentSize().width, self.rich_shop_info:getContentSize().height))
    end
    -- getMarketDataByItem
    -- dump(ex.Player.market_data:getmarketList())
    
end

function BackpackLayer:onExit()
    ex.RedDotManager:removeStickNode(RedDotType.ZCJ_DHBB_BBSP, self.btn_tab3)
end

-- function BackpackLayer:updateView(event,data)

-- end

function BackpackLayer:onOpenBoxReward(event)
    -- print(self.__cname,event,self.cur_layer_tab)
    
    print("self.cur_layer_tab", self.cur_layer_tab)
    local cur_data = ex.Player.backpack_data:getItemsByPageSign(self.cur_layer_tab)
    if self.cur_layer_tab == ItemData.IT_SPECIAL then
        -- 如果是符文，则将已穿戴的符文从显示列表中踢除
        cur_data = clone(cur_data)
        repeat 
            local is_have = false
            for i,v in ipairs(cur_data) do
                if v.hero_id > 0 then
                    table.remove(cur_data, i)
                    is_have = true
                    break
                end
            end
            if is_have == false then
                break
            end
        until false
    elseif self.cur_layer_tab == ItemData.IT_HERO_GODEQUIP then
        cur_data = clone(cur_data)
        repeat 
            local is_have = false
            for i,v in ipairs(cur_data) do
                if v.hero_id > 0 then
                    table.remove(cur_data, i)
                    is_have = true
                    break
                end
            end
            if is_have == false then
                break
            end
        until false
    elseif self.cur_layer_tab == ItemData.MAGIC_WAND then
        cur_data = clone(cur_data)
        repeat 
            local is_have = false
            for i,v in ipairs(cur_data) do
                if v.hero_id > 0 then
                    table.remove(cur_data, i)
                    is_have = true
                    break
                end
            end
            if is_have == false then
                break
            end
        until false
    end

    self.btn_get:setVisible(self.cur_layer_tab == ItemData.IT_HERO_GODEQUIP or self.cur_layer_tab == ItemData.MAGIC_WAND)
    self.btn_sale:setVisible(self.cur_layer_tab == ItemData.IT_HERO_GODEQUIP or self.cur_layer_tab == ItemData.MAGIC_WAND)
    self.btn_sale:setLabelText(self.cur_layer_tab == ItemData.MAGIC_WAND and ex.Tools:getLang(57206) or ex.Tools:getLang(5587))


    if self.cur_layer_tab == ItemData.IT_HERO_GODEQUIP or self.cur_layer_tab == ItemData.MAGIC_WAND then
        self.spr_box:setPreferredSize(cc.size(self.spr_box_size_origin.width, self.scroll_view_size_origin.height - 25))
        self.scroll_view:setViewSize(cc.size(self.scroll_view_size_origin.width, self.scroll_view_size_origin.height - 35))
    else
        self.spr_box:setPreferredSize(self.spr_box_size_origin)
        self.scroll_view:setViewSize(self.scroll_view_size_origin)
    end

    self:updateScrollView(cur_data)
end

function BackpackLayer:initDone()
    self:changeLayer(2)

    self:bubbleIsVisible()
end

function BackpackLayer:changeLayer(tab)
    for i=1,99 do
        if self["btn_tab"..i] == nil then
            break
        end

        self["btn_tab"..i]:setChecked(tab == self["btn_tab"..i]:getTag())
    end

    if tab == ItemData.IT_HERO_GODEQUIP and not ex.JumpManager:checkOpenConditionByAtom("bag_god_equip") then
        -- 神装未开启
        for i=1,99 do
            if self["btn_tab"..i] == nil then
                break
            end

            self["btn_tab"..i]:setChecked(self.cur_layer_tab == self["btn_tab"..i]:getTag())
        end
        return
    end

    if self.cur_layer_tab == tab then
        return
    end

    self.cur_layer_tab = tab
    -- 统一入口
    self:onOpenBoxReward()
end

function BackpackLayer:updateScrollView(vec_data, uncheck)
    self.scroll_view:setLoaded(false)
    
    self.scroll_view.createItemFunction = function(item_data, scale, index, pos)
        local item = nil
        if item_data == nil then
            item = UIItemBackpack:createWithData(0, 0)
            item:setScale(scale * ex.s.global_scale)
        else
            -- 添加对应物品
            if ex.Player.backpack_data:isPiece(item_data.item_type) then
                item = UIItemHeroPiece:createWithData(item_data.item_type)
                :setCompleted(item_data.item_num)
                local red = ex.Player.backpack_data:getPieceRed(item_data.item_type)
                item:setRedPoint(red)
                item:setScale(scale * ex.s.global_scale)
            elseif item_data.item_tag == ItemData.PET then 
                item = UIItemBackpack:createWithData(item_data.item_type)
                item:setScale(scale * ex.s.global_scale)
                item:setLevel(item_data.level)
                item:showPetRare()
                item.data = item_data
            elseif self.cur_layer_tab == ItemData.MAGIC_WAND then
                item = UIItemBackpack:createWithData(item_data.item_type)
                item:setScale(scale * ex.s.global_scale)
                item:setStrengthen(item_data.strengthen_lv)
                item.item_id = item_data.magic_id
                item.data = item_data
            else
                item = UIItemBackpack:createWithData(item_data.item_type, item_data.item_num)
                item:setScale(scale * ex.s.global_scale)
                item.item_id = item_data.item_id
                item.reiki_equip_id = item_data.reiki_equip_id
            end
            item:registerScriptTapHandler(handler(self, self.onShowInfo))
        end

        -- 添加花纹
        if (index - 1) / self.scroll_view.col_num >= 1 and (index - 1) % self.scroll_view.col_num > 0 then
            local spr_pattern = cc.Sprite:createWithSpriteFrameName("backpack/spr-pattern.png")
            spr_pattern:setPosition(pos.x - self.scroll_view.item_size.width / 2, pos.y + self.scroll_view.item_size.height / 2)
            self.scroll_view:getContainer():addChild(spr_pattern, -1)
        end
        
        return item
    end
    self.scroll_view:reloadData(vec_data)
end

function BackpackLayer:onTabChange(tag, pSender)
    self:changeLayer(tag)
end

function BackpackLayer:onShowInfo(tag, pSender)
    -- ex.Tools:onClickItemInfo(pSender.item_type)
    local item_tag = ex.Player.backpack_data:getPropType(pSender.item_type)

    if ItemData.IT_EQUIP == item_tag then 
        local config = cfg.equipmenttype.equip[pSender.item_type]
        local ctr = require("src.layer.AbilityInfoCtr"):instance()
        ctr:openWindow()
        :addEquipInfo(config,{})
		:addWearButtion({str = ex.Tools:getLang(47583), call = function(tag, pSender)
            ex.MainSceneCtr:changeLayer(MainSceneType.HERO_LAYER)
        end, data = nil, keep = false})
    elseif ItemData.IT_HERO_FASHION ==  item_tag then

        --打开皮肤界面    
        local item_data = {item_type = pSender.item_type,item_num = pSender.num,item_id = pSender.item_id}
        require("src.layer.skinsystem.HeroUseSkinCtr"):instance():openWindow(pSender.item_type, true, item_data)

    elseif ItemData.IT_RUNES == item_tag then
        print("item_id:", pSender.item_id)
        local runes = ex.Player.backpack_data:getItemById(pSender.item_id, true)
		local ctr = require("src.layer.runes.RunesTipsCtr"):instance()
		ctr:openWindow()
		:addEquipInfo(runes)
		:addWearButtion({str = ex.Tools:getLang(47438) , call = function()
							local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_SMITH)
							layer:changeLayer(20)
							ctr:closeWindow(0, nil)
						end,data = 1 , keep = false},
						{str = ex.Tools:getLang(47520) , call = function()
							require("src.layer.runes.RunesRecastCtr"):instance():openWindow(runes)
							ctr:closeWindow(0, nil)
						end,data = 1 , keep = false},
						{str = ex.Tools:getLang(47584) , call = function()
							ex.ConfirmCtr:openWindow(ex.Tools:getLang(47584), ex.Tools:getLang(47748), function()
                                local req_runes_discompose = Rune_pb.GReqRuneDisCombine()
                                req_runes_discompose.rune_id = pSender.item_id
                                NetManager:sendMessage(ProtocolID.GReqRuneDisCombine, req_runes_discompose)
                                ctr:closeWindow(0, nil)
                            end)
						end,data = 1 , keep = false},
						{str = ex.Tools:getLang(47326) , call = function()
							ex.MainSceneCtr:changeLayer(MainSceneType.HERO_LAYER)
							ctr:closeWindow(0, nil)
                        end,data = 1 , keep = false})
    elseif ItemData.IT_HERO_GODEQUIP == item_tag then
        local equip = ex.Player.backpack_data:getGodEquipDataByID(pSender.item_id)
        local config = cfg.godequipment.getConfigByType(equip.item_type)
        local info_ctr = require("src.layer.heroinfo.HeroGodEquipAbilityInfoCtr"):instance()
        info_ctr:openWindow()
        :setDataInfo(equip)
        :addWearButtion(
            {str = ex.Tools:getLang(47751), call = handler(self, self.onSaleDirect), data = equip },            
            {str = ex.Tools:getLang(47618), call = handler(self, self.onGodEquipWash), data = equip, gray_flag = config.rare < GOD_EQUIP_RARE_GRADE.JiPin},
            {str = ex.Tools:getLang(47326), call = handler(self, self.onGodEquipWear), data = pSender.item_id},            
            {str = ex.Tools:getLang(47438), call = handler(self, self.onGodEquipMerge), data = nil}
            )
    elseif ItemData.MAGIC_WAND == item_tag then
        -- local equip = ex.Player.backpack_data:getMagicWand(pSender.item_id)
        -- require("src.layer.heromagicwand.HeroMagicWandInfoCtr"):instance():openWindow(equip)
        local data = ex.Player.backpack_data:getMagicWand(pSender.item_id)
        require("src.layer.heromagicwand.HeroMagicWandInfoCtr"):instance():openWindow(data)
    elseif ItemData.IT_HERO_STONE == item_tag then
        local info_ctr = require("src.layer.heroinfo.StoneAbilityInfoCtr"):instance()
        info_ctr:openWindow()
        info_ctr:setStoneInfo(pSender.item_type):addWearButtion(
                    {str = ex.Tools:getLang(47184), call = handler(self, self.onDoneUpLevel), data = nil},
                    {str = ex.Tools:getLang(47326), call = handler(self, self.onDoneChange), data = nil})
    elseif ItemData.IT_HALLOWS == item_tag then
        local config_relic = cfg.dragonrelic.dragonrelic[pSender.item_type]
        local info_ctr = require("src.layer.dragon.HallowsInfoCtr"):instance()
        info_ctr:openWindow()

        local is_visible = ex.JumpManager:checkOpenConditionByAtom("main_dragon")
        if is_visible then
            info_ctr:addDataInfo(pSender.item_type)
                    :addWearButtion(
                        {str = ex.Tools:getLang(74543), 
                        call = function()
                            require("src.layer.dragon.HallowsResolveCtr"):instance():openWindow(pSender.item_type)
                        end, 
                        data = nil},
                        {str = ex.Tools:getLang(74544), 
                        call = function()
                            if config_relic.up_star_type <= 0 then
                                ex.MessageView:add(ex.Tools:getLang(74609))
                                return
                            end
                            require("src.layer.dragon.HallowsUpStarCtr"):instance():openWindow(pSender.item_type, true)
                        end, 
                        data = nil},
                        {str = ex.Tools:getLang(74545), 
                        call = function()
                            -- ex.JumpManager:jumpByAtom("main_dragon")
                            cfg.funcopen["main_dragon_info"].open()
                        end, 
                        data = nil})
        else
            info_ctr:addDataInfo(pSender.item_type)
                    :addWearButtion(
                        {str = ex.Tools:getLang(74543), 
                        call = function()
                            require("src.layer.dragon.HallowsResolveCtr"):instance():openWindow(pSender.item_type)
                        end, 
                        data = nil},
                        {str = ex.Tools:getLang(74544), 
                        call = function()
                            require("src.layer.dragon.HallowsUpStarCtr"):instance():openWindow(pSender.item_type, true)
                        end,
                        data = nil,
                        enable = config_relic.up_star_type > 0})
            info_ctr:addDataInfo(pSender.item_type)
                    :addWearButtion(
                        {str = ex.Tools:getLang(47184), call = handler(self, self.onDoneUpLevel), data = nil},
                        {str = ex.Tools:getLang(47326), call = handler(self, self.onDoneChange), data = nil})
        end
    elseif ItemData.IT_PROP_LIMIT_TIME == item_tag then
        local info_ctrl = require("src.layer.BackpackInfoCtr"):instance()
        info_ctrl:openWindow(pSender.item_type,true, nil, true, true)

        local prop_data = ex.Player.backpack_data:getLimitTimeItemById(pSender.item_id)
        if prop_data then
            info_ctrl:addCountdown(prop_data.end_time, true)
        end
    elseif ItemData.ARTIFACTS == item_tag then 
        local data = {}
        data.equip = {sys_id = pSender.item_type}
        local equip_list = {}
        equip_list[1] = pSender.item_type
        data.equip_list = equip_list
        local ctr = require("src.layer.artifacts.ArtifactTipsCtr"):instance()
        ctr:openWindow()
        local layer = ctr:addEquipInfo(data)

        local item_cfg = cfg.item.item[pSender.item_type]
        if item_cfg.decomposition == 1 then 
            local item_data = {item_type = pSender.item_type,item_num = 1,item_id = pSender.reiki_equip_id}
            local btn_call = {str = ex.Tools:getLang(3923), call = function ()
                require("src.layer.decomposeItem.DecomposeSelectCtr"):instance():openWindow(item_data)
            end, data = item_data, atom = "decompose"}
            layer:addWearButtion(btn_call)
        end
    elseif ItemData.PET == item_tag then 
        require("src.layer.pet.PetInfoTipsCtr"):instance():openWindow(pSender.data)
    else
        local item_data = {}
        item_data.item_type = pSender.item_type
        item_data.item_num = pSender.num
        require("src.layer.BackpackInfoCtr"):instance():openWindow(item_data,true, nil, true, true)
    end
end

function BackpackLayer:onDoneUpLevel()
    ex.JumpManager:jumpByAtom("main_smith_shop_gem")
end

function BackpackLayer:onDoneChange()
    ex.JumpManager:jumpByAtom("main_hero")
end

function BackpackLayer:onGodEquipMerge()
    ex.JumpManager:jumpByAtom("main_smith_shop_god_equip")
end

function BackpackLayer:onGodEquipWear()
    ex.JumpManager:jumpByAtom("main_hero")
end

function BackpackLayer:onGodEquipWash(tag, pSender)
    local equip = pSender.data
    local config = cfg.godequipment.getConfigByType(equip.item_type)
    if config.rare < GOD_EQUIP_RARE_GRADE.JiPin then
        -- ex.MessageView:add(ex.Tools:getLang())
        return
    end
    require("src.layer.GodEquipRareCtr"):instance():openWindow(pSender.data.item_id)
end

function BackpackLayer:onSaleDirect(tag, pSender)
    require("src.layer.GodEquipSaleCtrl"):instance():openWindow({pSender.data}, handler(self, self.doSale))
end

function BackpackLayer:onGet()
    if self.cur_layer_tab == ItemData.IT_HERO_GODEQUIP then
        ex.JumpManager:jumpByAtom("main_god_equip_summon")
    elseif self.cur_layer_tab == ItemData.MAGIC_WAND then
        ex.JumpManager:jumpByAtom("main_country_war")
    end
end

function BackpackLayer:onSale()
    if self.cur_layer_tab == ItemData.IT_HERO_GODEQUIP then
        require("src.layer.GodEquipSelectSaleCtrl"):instance():openWindow(handler(self, self.doSale))
    elseif self.cur_layer_tab == ItemData.MAGIC_WAND then
        require("src.layer.heromagicwand.HeroMagicWandSellCtr"):instance():openWindow(handler(self, self.doSale))
    end
end

function BackpackLayer:doSale(sale_list)
    if not sale_list or #sale_list <= 0 then
        return
    end

    if self.cur_layer_tab == ItemData.IT_HERO_GODEQUIP then
        local req = GodEquip_pb.GReqGodEquipRecycle()
        for i,v in ipairs(sale_list) do
            table.insert(req.god_equips, v.item_id)
        end
        NetManager:sendMessage(ProtocolID.GReqGodEquipRecycle, req)
    elseif self.cur_layer_tab == ItemData.MAGIC_WAND then
        local req = HeroMagicWand_pb.GReqMagicWandDecompose()
        for i,v in ipairs(sale_list) do
            table.insert(req.magic_ids, v.magic_id)
        end
        NetManager:sendMessage(ProtocolID.GReqMagicWandDecompose, req)
    end
end

return BackpackLayer
