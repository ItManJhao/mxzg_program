local AltarPanelLayer = class("AltarPanelLayer", require("src.comp.EventLayer"))

local UIItemHero = require("src.comp.menu.UIMenuItemHero")

-------------------------------AltarPanelLayer-----------------------------------------------
function AltarPanelLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)


    local last_content_size = self:getContentSize()
    local cur_content_size = cc.size(ex.p.width - 20, ex.p.height - 220)
    local offset = cc.p(cur_content_size.width - last_content_size.width, cur_content_size.height - last_content_size.height)

    self:setContentSize(cur_content_size)
    self:setPosition(ex.p.width / 2 - self:getContentSize().width / 2, ex.p.height / 2 - self:getContentSize().height / 2 + 20)

    --self.spr_bg_2:setContentSize(self.spr_bg_2:getContentSize().width + offset.x, self.spr_bg_2:getContentSize().height + offset.y)

    self.spr_hero_num_bg:setPosition(self.spr_hero_num_bg:getPositionX() + offset.x / 2, self.spr_hero_num_bg:getPositionY() )
    self.lbl_select_num:setPosition(self.lbl_select_num:getPositionX() + offset.x / 2, self.lbl_select_num:getPositionY() )


    self.spr_bg_2:setPosition(self.spr_bg_2:getPositionX() + offset.x / 2, self.spr_bg_2:getPositionY() )


    self.btn_auto:setPosition(self.btn_auto:getPositionX() + offset.x / 2, self.btn_auto:getPositionY())
    self.btn_done:setPosition(self.btn_done:getPositionX() + offset.x / 2, self.btn_done:getPositionY())

    self.btn_elem0:setPosition(self.btn_elem0:getPositionX() + offset.x / 2, self.btn_elem0:getPositionY() )
    self.btn_elem1:setPosition(self.btn_elem1:getPositionX() + offset.x / 2, self.btn_elem1:getPositionY() )
    self.btn_elem2:setPosition(self.btn_elem2:getPositionX() + offset.x / 2, self.btn_elem2:getPositionY() )
    self.btn_elem3:setPosition(self.btn_elem3:getPositionX() + offset.x / 2, self.btn_elem3:getPositionY() )
    self.btn_elem4:setPosition(self.btn_elem4:getPositionX() + offset.x / 2, self.btn_elem4:getPositionY() )
    self.btn_elem5:setPosition(self.btn_elem5:getPositionX() + offset.x / 2, self.btn_elem5:getPositionY() )


    -- self.btn_back:setPosition(self:getContentSize().width / 2 + ex.p.width / 2 / self:getScaleX() - 20 / self:getScaleX() - 60,
    -- self:getContentSize().height / 2 + ex.p.height / 2 / self:getScaleY() - 100 / self:getScaleY() - 30 - notch_height)

    self.btn_info:setPosition(self:getContentSize().width / 2 + ex.p.width / 2 / self:getScaleX() - 20 / self:getScaleX() - 60, self.btn_info:getPositionY() + offset.y)
    self.btn_shop:setPosition(self:getContentSize().width / 2 + ex.p.width / 2 / self:getScaleX() - 20 / self:getScaleX() - 60, self.btn_shop:getPositionY() + offset.y)


    self.spr_hero_bg:setPosition(self.spr_hero_bg:getPositionX() + offset.x / 2, self.spr_hero_bg:getPositionY())
    self.lbl_hero_num:setPosition(self.lbl_hero_num:getPositionX() + offset.x / 2, self.lbl_hero_num:getPositionY())

    
    -- self.spr_hero_bg:setContentSize(self.spr_hero_bg:getContentSize().width, self.spr_hero_bg:getContentSize().height + offset.y)


    self:initDone()
    self:addEvent(EVENT.HERO_EVENT.SELECT_HERO, handler(self,self.onSelectHeroEvevt))

    self:addEvent(EVENT.HERO_EVENT.ALTER_OK, handler(self,self.altarOK))

end 



function AltarPanelLayer:onBtnInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(2507), ex.Tools:getLang(2505))
end

function AltarPanelLayer:onBtnShop(tag, pSender)
    cfg.funcopen.main_shop.open(SHOP_TYPE.SACRIFICE)
end


function AltarPanelLayer:onSelectHeroEvevt(event,data)
    self:onSelectHero(data)
end 

function AltarPanelLayer:initDone()
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/main-altar.plist")

    local btn_size = cc.Sprite:createWithSpriteFrameName("button/btn-orange-4.png"):getContentSize()
	btn_size.width = btn_size.width / 2
	btn_size.height = btn_size.height / 2

    self.btn_elem0:setTag(ElemType.ALL)
    self.btn_elem1:setTag(ElemType.FIRE)
    self.btn_elem2:setTag(ElemType.WATER)
    self.btn_elem3:setTag(ElemType.FOREST)
    self.btn_elem4:setTag(ElemType.LIGHT)
    self.btn_elem5:setTag(ElemType.SHADOW)

    self.btn_elem0:registerScriptTapHandler(handler(self, self.onChooseElem))
    self.btn_elem1:registerScriptTapHandler(handler(self, self.onChooseElem))
    self.btn_elem2:registerScriptTapHandler(handler(self, self.onChooseElem))
    self.btn_elem3:registerScriptTapHandler(handler(self, self.onChooseElem))
    self.btn_elem4:registerScriptTapHandler(handler(self, self.onChooseElem))
    self.btn_elem5:registerScriptTapHandler(handler(self, self.onChooseElem))

    self.btn_elem_select = require("src.layer.HeroElemSelect"):new()
    self.btn_elem_select:bindSelect(self.btn_elem0)
    self.btn_elem_select:bindSelect(self.btn_elem1)
    self.btn_elem_select:bindSelect(self.btn_elem2)
    self.btn_elem_select:bindSelect(self.btn_elem3)
    self.btn_elem_select:bindSelect(self.btn_elem4)
    self.btn_elem_select:bindSelect(self.btn_elem5)
    
    self.btn_elem_select:setSelected(ElemType.ALL)

    self.cur_hero_elem = ElemType.ALL
	self.is_choose_elem = true
	self.hero_list_view = {}

	self.altar_hero_list = {}
	self.selected_hero_num = 0
	self.limit_hero_num = ex.Tools:getSysCfg("sacrifice_limit")
	self:setSelectText()

	self.item_size = cc.Sprite:createWithSpriteFrameName("other/rare-0.png"):getContentSize()
    self.item_size = cc.size(self.item_size.width + 15, self.item_size.height + 12)

	-- 英雄列表scroll_view
	self.viewSize = self.spr_hero_bg:getContentSize()
    self.viewSize.height = self.viewSize.height - 110

    -- self.scroll_view = cc.ScrollView:create(self.viewSize)
    -- :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    -- :setPosition(self.spr_hero_bg:getPositionX(), self.spr_hero_bg:getPositionY() + 2)
    -- self:addChild(self.scroll_view)

    self.scroll_view = require("src.comp.UIScrollViewBackpack"):createWithSize(self.viewSize)
    self.scroll_view:setPosition(cc.p(self.spr_hero_bg:getPositionX(), self.spr_hero_bg:getPositionY() + 5))
    self.scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.scroll_view:setItemSize(cc.size(self.item_size.width + 10, self.item_size.height))
    self.scroll_view:setItemOffset(cc.p(0, 5))
    self:addChild(self.scroll_view)

	self:updateScrollView()
end

function AltarPanelLayer:onBack(tag , pSender)
    ex.MainSceneCtr:instance():changeLayer(MainSceneType.MAINCITY_LAYER)
    --ex.MainSceneCtr:backLastLayer()
end

function AltarPanelLayer:setSelectText()

    self.lbl_hero_num:setString(string.format(ex.Tools:getLang(47250), self.now_hero_nums))

	self.lbl_select_num:setString(string.format(ex.Tools:getLang(2504),--"已选中英雄: %d/%d",
		self.selected_hero_num,
		self.limit_hero_num))
end

function AltarPanelLayer:altarOK()
    --卸载装备
    for _,v in pairs(self.altar_hero_list) do
        ex.Player.hero_data.equip:clearHeroEquipData(v)
        --print("altarOK..."..v)
    end
    
	-- 献祭成功 删除献祭的英雄
    ex.Player.hero_data:removePart(ex.Player.hero_data.hero_list, self.altar_hero_list)

    self.altar_hero_list = {}
    self.selected_hero_num = 0
    self:setSelectText()

    self:updateScrollView()
end


function AltarPanelLayer:updateScrollView(data, num)
	self.is_choose_elem = false
	self.hero_list_view = {}

    self.selected_hero_num = num or 0
	

    -- 获取当期属性英雄
    local hero_list = data or clone(ex.Player.hero_data:getHeroByElem(self.cur_hero_elem))

    self.now_hero_nums = table.nums(hero_list)
    if self.now_hero_nums == 0 then
        self.is_choose_elem = true
        
        self:setSelectText()

        self.scroll_view:reloadData({})
        
        self.hero_list_view = {}

    	return
    end

    self:setSelectText()


    -- 给执行任务的英雄排序
    if data == nil then
        ex.Player.hero_data:sortByTask(hero_list, ex.Player:getHeroBattleList())
    end
    self.scroll_view.createItemFunction = function(item_data, scale)
        local item = UIItemHero:createWithData(item_data.hero_id, item_data.hero_type, item_data.elem, item_data.level, item_data.star)
        item:registerScriptTapHandler(function(tag, pSender)
            self:onSelectHero(pSender)
        end)
        -- self.menu_item:addChild(item)
        --if ex.Player.hero_data.promote:checkHeroIsBattle(item_data.hero_id) then 
            --item:setBattling()
        --end
        --if item_data.is_lock then
            --item:setLocked()
        --end
        item:autoLocked()

        item:setSelected(item_data.selected and item_data.selected or false)
        return item
    end
    self.scroll_view:reloadData(hero_list)
    self.hero_list_view = hero_list


    self.is_choose_elem = true

end



function AltarPanelLayer:updateScrollViewB()
	self.scroll_view:getContainer():removeAllChildren()

	self.is_choose_elem = false
	self.hero_list_view = {}

    self.selected_hero_num = 0
    self:setSelectText()
	
	local hero_menu = cpp.UIMenu:create()
    :setIsTouchInsideNode(self.scroll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    :setName("menu_altar")
    self.scroll_view:addChild(hero_menu)

    -- 获取当期属性英雄
    local hero_list = clone(ex.Player.hero_data:getHeroByElem(self.cur_hero_elem))
    local heroLen = table.nums(hero_list)
    if heroLen == 0 then
    	self.is_choose_elem = true
    	return
    end

    -- 给执行任务的英雄排序
    ex.Player.hero_data:sortByTask(hero_list, ex.Player:getHeroBattleList())

    local margin = 0
    --local heroLen = table.nums(hero_list)
    local col = math.floor((self.viewSize.width - margin * 2) / self.item_size.width) -- 列数
    local row = math.ceil(1.0 * heroLen / col) -- 行数
    local cont_height = self.item_size.height * row + margin * 2
    cont_height = math.max(cont_height , self.viewSize.height)
    --row = math.ceil((cont_height - margin * 2) / self.item_size.height) -- 总行数

    self.scroll_view:setContentSize(cc.size(self.viewSize.width, cont_height))
    self.scroll_view:setContentOffset(cc.p(0, self.viewSize.height - cont_height))

    cont_height = cont_height - (self.item_size.height * 0.5 + margin * 0.5)

    local start = cc.p(self.viewSize.width * 0.5 - (self.item_size.width * col * 0.5), cont_height)
    start.x = start.x + self.item_size.width * 0.5

    --ex.log(string.format("heroLen=%d, col=%d, row=%d", heroLen, col, row))

    local index = 0
    for _,v in pairs(hero_list) do
        local x = index % col
        local y = math.floor(index / col)

        local item = UIItemHero:createWithData(v.hero_id, v.hero_type, v.elem, v.level, v.star)
        item:setPosition(start.x + x * self.item_size.width, start.y - y * self.item_size.height)
        :registerScriptTapHandler(handler(self, self.onSelectHero))
        hero_menu:addChild(item)

        if v.hasTask ~= nil and v.hasTask > 0 then
            item:setBattling()
        end

        table.insert(self.hero_list_view, item)

        index = index + 1
    end

    self.is_choose_elem = true
end

function AltarPanelLayer:onSelectHero( pSender)
    --if pSender.battle then
        --ex.Player.hero_data:getHeroBattleMsg(pSender:getHeroId())
        ---- ex.MessageView:add(ex.Tools:getLang(47070))
        --return
    --end
    --if pSender.locked then
        --ex.MessageView:add(ex.Tools:getLang(41271))
        --return
    --end
    if pSender:showLockedMessage() then 
        return 
    end 

    local flag = false
	local isSelected = pSender:isSelected()
	if isSelected == false then
		if self.limit_hero_num <= self.selected_hero_num then
			--每次最多选择10个
			ex.MessageView:add(ex.Tools:getLang(2503))
			return
		end
		self.selected_hero_num = self.selected_hero_num + 1
        flag = true
	else
		self.selected_hero_num = self.selected_hero_num - 1
	end

    for _,v in pairs(self.hero_list_view) do
        -- for k,v in pairs(item_list) do
            if v.hero_id == pSender:getHeroId() then
                v.selected = flag
                break;
            end
        -- end  
    end


	self:setSelectText()

	pSender:setSelected(not pSender:isSelected())
end

function AltarPanelLayer:onBtnAuto(tag, pSender)
    if self.selected_hero_num == self.limit_hero_num then
		return
	end

    self.selected_hero_num = 0

    for i,v in ipairs(self.hero_list_view) do
            
            local locked = ex.Player.hero_data:checkHeroIsLock(v.hero_id)
            if locked == false and self.selected_hero_num < self.limit_hero_num then 

                print(self.__cname,locked,v.hero_id)
                v.selected = true 
                self.selected_hero_num = self.selected_hero_num + 1
            else
                v.selected = false
            end 
	end

    self:setSelectText()
    self:updateScrollView(self.hero_list_view, self.selected_hero_num)
end

function AltarPanelLayer:onBtnAltar(tag, pSender)
    if self.selected_hero_num <= 0 then
        --print(ex.Tools:getLang(47253))
        ex.MessageView:add(ex.Tools:getLang(2210))
        return
    end

    local item_list = {}
    local inserItem = function(item_type, item_num)
        local is_add = true
        for _,v in pairs(item_list) do
           if v.item_type == item_type then
              v.item_num = v.item_num + item_num
              is_add = false
              break
           end
        end

        if is_add then
            local item = {}
            item.item_type = item_type
            item.item_num = item_num
            table.insert(item_list, item)
        end
    end

    -- for _,v in pairs(self.hero_list_view) do
    --     if v:isSelected() then
    --         table.insert(self.altar_hero_list, v.hero_id)

    --         for _,n in pairs(cfg.herostar.star[v.star].sacrifice_item_refund) do
    --             inserItem(n.item_type, n.item_num)
    --         end
    --     end
    --  end

    local vip_add = 1
    local vip_config = cfg.goddessvip.goddessvip[ex.Player.fetter_data.vip.vip_level]    

    if vip_config then
        -- dump(vip_config, "vip_config")
        vip_add = vip_add + vip_config.sacrifice_bonus / 100
    end
    print(ex.Player.fetter_data.vip.vip_level,self.__cname,vip_add)
    self.altar_hero_list = {}
    for _,v in pairs(self.hero_list_view) do
        if v.selected then
            table.insert(self.altar_hero_list, v.hero_id)

            -- 献祭道具
            for _,n in pairs(cfg.herostar.star[v.star].sacrifice_item_refund) do
                inserItem(n.item_type, n.item_num * (n.item_type == ItemType.IT_ALTAR_SHOP and vip_add or 1))
            end

            -- 升级返还的材料
            for i=1,v.level-1 do
                local config = cfg.herolevel.level[i]
                if config then
                    inserItem(ItemType.IT_GOLD, config.gold_need)
                    inserItem(ItemType.IT_HERO_EXP, config.exp_need)
                end
            end
            -- 升星返还的材料 
            for i=1,v.star-1 do
                local star = cfg.herostar.star[i]
                if star ~= nil then 
                    for _,n in pairs(star.upstar_cost) do
                        inserItem(n.item_type, n.item_num)
                    end
                    for _,n in pairs(star.need_item) do
                        inserItem(n.item_type, n.item_num)
                    end
                end
            end

            -- 返还升阶材料
            for i=0, v.stage - 1 do
                local config = cfg.heroupgrade.grade[i]
                if config then
                    inserItem(ItemType.IT_HERO_UP_STONE, config.soul)
                    inserItem(ItemType.IT_GOLD, config.gold) 
                end
            end
        end  
    end


    --print("selected_hero_num = "..self.selected_hero_num)
    --ex.out(self.altar_hero_list)
    for k,v in pairs(item_list) do
        v.item_num = math.floor(v.item_num)
    end

    require("src.layer.AltarConfirmCtr"):instance():openWindow(ex.Tools:getLang(2507),
        ex.Tools:getLang(2506), item_list, function()
           local function callback ()
                -- 发送献祭英雄协议
                local req_altar = Task1_pb.GReqAltarHero()
                for _,v in pairs(self.altar_hero_list) do
                    table.insert(req_altar.hero_id, v)
                end
                NetManager:sendMessage(ProtocolID.GReqAltarHero, req_altar)
           end
           local has = false 
           for k,v in pairs(self.altar_hero_list) do
               local hero_data = ex.Player.hero_data:getHeroDataById(v)
               if hero_data.star >= 5 then 
                    has = true 
                    break
               end
           end
           if has then 
            local title = ""
            local content = string.format(ex.Tools:getLang(41140))
            require("src.layer.ConfirmCtr"):instance():openWindow(title,content,callback)
           else
                callback()
           end
        end)
end

function AltarPanelLayer:chooseHeroElem(elem)
	if self.is_choose_elem == false then
		return
	end

    if self.cur_hero_elem == elem then
        return
    end

    self.cur_hero_elem = elem

    self.btn_elem_select:setSelected(elem)

    self:updateScrollView()
end

function AltarPanelLayer:onChooseElem(tag, pSender)
	self:chooseHeroElem(tag)
end




function AltarPanelLayer:onBtnInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(2507), ex.Tools:getLang(2505))
end

function AltarPanelLayer:onBtnShop(tag, pSender)
    cfg.funcopen.main_shop.open(SHOP_TYPE.SACRIFICE)
end


return AltarPanelLayer
