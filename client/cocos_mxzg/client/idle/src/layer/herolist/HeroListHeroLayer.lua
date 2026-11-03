local HeroListHeroLayer = class("HeroListHeroLayer", require("src.comp.EventLayer"))

local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero") -- require("src.comp.menu.UIMenuItemHero")

local HeroListLayerHeroType = {}
HeroListLayerHeroType.HERO = 1
HeroListLayerHeroType.ILLUSTRAT = 2

function HeroListHeroLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    
    self.btn_elem0:setTag(ElemType.ALL)
    self.btn_elem1:setTag(ElemType.FIRE)
    self.btn_elem2:setTag(ElemType.WATER)
    self.btn_elem3:setTag(ElemType.FOREST)
    self.btn_elem4:setTag(ElemType.LIGHT)
    self.btn_elem5:setTag(ElemType.SHADOW)

    self.btn_elem0:registerScriptTapHandler(handler(self, self.onElem))
    self.btn_elem1:registerScriptTapHandler(handler(self, self.onElem))
    self.btn_elem2:registerScriptTapHandler(handler(self, self.onElem))
    self.btn_elem3:registerScriptTapHandler(handler(self, self.onElem))
    self.btn_elem4:registerScriptTapHandler(handler(self, self.onElem))
    self.btn_elem5:registerScriptTapHandler(handler(self, self.onElem))

    self.btn_elem_select = require("src.layer.HeroElemSelect"):new()
    self.btn_elem_select:bindSelect(self.btn_elem0)
    self.btn_elem_select:bindSelect(self.btn_elem1)
    self.btn_elem_select:bindSelect(self.btn_elem2)
    self.btn_elem_select:bindSelect(self.btn_elem3)
    self.btn_elem_select:bindSelect(self.btn_elem4)
    self.btn_elem_select:bindSelect(self.btn_elem5)
    
    self.btn_elem_select:setSelected(ElemType.ALL)

    self.viewSize = self.spr_box:getContentSize()
    self.viewSize.height = self.viewSize.height - 105 --height = 363

    self.item_size = cc.Sprite:createWithSpriteFrameName("other/rare-0.png"):getContentSize()
    self.item_size = cc.size(self.item_size.width + 15, self.item_size.height + 12)

    self.scroll_view = require("src.comp.UIScrollViewBackpack"):createWithSize(cc.size(self.viewSize.width, self.viewSize.height + 4))
    self.scroll_view:setPosition(self.spr_box:getPositionX() - self.viewSize.width / 2, self.spr_box:getPositionY() - self.spr_box:getContentSize().height + 10)
    self.scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.scroll_view:setItemSize(cc.size(self.item_size.width, self.item_size.height + 10))
    self.scroll_view:setItemOffset(cc.p(0, 5))
    self.scroll_view:setAutoOffset(true)
    self.scroll_view:setAutoScale(true)
    self.scroll_view:setAutoFull(true)
    self.scroll_view:setCreateNum(4)
    self:addChild(self.scroll_view)

    self.btn_permanent_skin:setPositionX(self.lbl_capacity:getPositionX() - cc.Director:getInstance():getWinSize().width + 250 )
    self.cur_layer_type = HeroListLayerHeroType.HERO
    self.cur_hero_elem = ElemType.ALL
    if not ex.Player.hero_data:isOpenHeroSkinShop(true) then 
        ex.Tools:setGrayAuto(self.btn_permanent_skin:getNormalImage(), true)
    end
    

    self:initDone()

    self:addEvent(EVENT.HERO_INFO_EVENT.HERO_ILLUSTRAT_ACTIVE,handler(self,self.onIllustratUpdate))
    self:addEvent(EVENT.HERO_INFO_EVENT.HERO_HERO_LIST_UPDATE,handler(self,self.updateLayer))
    self:addEvent(EVENT.BATTLE_EVENT.HANG_LINE_UP, handler(self,self.updateLayer))
    
    self.btn_evolve:registerScriptTapHandler(handler(self, self.onEvolveInfo))
    ex.RedDotManager:setStickNode(RedDotType.ZCJ_DHYX_TJT_JHTJ, self.btn_evolve)
end

-- 刷新当前界面
function HeroListHeroLayer:updateLayer()
    self:initDone()
end

function HeroListHeroLayer:initDone()
    self:setCapacityText()
    self:changeLayer(ex.Player.hero_data:getOpenTab())
end

function HeroListHeroLayer:changeLayer(tab)
    if self.cur_layer_tab == tab then
        return
    end

    local elem = ElemType.ALL

    if tab == HeroListLayerHeroType.HERO then
        self.node_capacity:setVisible(true)
        self.bottom_menu:setVisible(false)
    else
        elem = ElemType.FIRE
        self.node_capacity:setVisible(false)
        self.bottom_menu:setVisible(true)
    end

    self:changeHeroElem(tab, elem)
end

function HeroListHeroLayer:changeHeroElem(layer_type, elem)
    --获取属性的点击状态
    elem = ex.Player.hero_data.btn_elem_state
    if self.cur_layer_tab == layer_type and self.cur_hero_elem == elem then
        return
    end

    self.cur_layer_tab = layer_type
    self.cur_hero_elem = elem

    self.btn_elem0:setVisible(self.cur_layer_tab == HeroListLayerHeroType.HERO)
    self.btn_elem1:setPositionX(self.cur_layer_tab == HeroListLayerHeroType.HERO and -126 or -210)
    self.btn_elem2:setPositionX(self.cur_layer_tab == HeroListLayerHeroType.HERO and -42 or -105)
    self.btn_elem3:setPositionX(self.cur_layer_tab == HeroListLayerHeroType.HERO and 42 or 0)
    self.btn_elem4:setPositionX(self.cur_layer_tab == HeroListLayerHeroType.HERO and 126 or 105)
    
    self.btn_elem_select:setSelected(elem)
    
    if self.cur_layer_tab == HeroListLayerHeroType.HERO then 
        local data = ex.Player.hero_data:getHeroByElem(elem)
        self:updateTableView(data)
    else
        local list = ex.Player.hero_data:editIllustratListByElem(elem)
        ex.Player.hero_data:setCurIllustratCfg(list)
        self:updateTableView(list)
    end
end

function HeroListHeroLayer:onElem(tag, pSender)
    --设置属性的点击状态呢
    -- self:changeHeroElem(self.cur_layer_tab, tag)
    ex.Player.hero_data.btn_elem_state = tag
    self:changeHeroElem(self.cur_layer_tab, ex.Player.hero_data.btn_elem_state)
end

function HeroListHeroLayer:editHeroData(data)
    local hero_list = data

    local promote = ex.Player.hero_data.promote

    local function sor(a, b)
        local battle_a = promote:heroIsBattle(a.hero_id) and 1 or 0
        local battle_b = promote:heroIsBattle(b.hero_id) and 1 or 0

        if battle_a ~= battle_b then  return battle_a > battle_b  end

        if a.star ~= b.star then return a.star > b.star end
        if a.level ~= b.level then return a.level > b.level end
        return a.hero_type > b.hero_type
    end
    table.sort(hero_list,sor)
    return hero_list
end

function HeroListHeroLayer:updateTableView(data)
    if self.cur_layer_tab == HeroListLayerHeroType.HERO then 
        data = self:editHeroData(data)
    end

    local promote = ex.Player.hero_data.promote
    local config_type = cfg.herotype.star
    local config_star = cfg.herostar.star

    self.scroll_view:setLoaded(false)
    self.scroll_view:setAutoFull(self.cur_layer_tab == HeroListLayerHeroType.HERO)
    -- self.scroll_view:setAutoFull(true)
    self.scroll_view.createItemFunction = function(hero_data, scale)
        if self.cur_layer_tab == HeroListLayerHeroType.HERO then 
            local item = nil
            if hero_data then 
                item = UIMenuItemHero:createWithData(hero_data.hero_id, hero_data.hero_type, hero_data.elem, hero_data.level, hero_data.star)
                local redPoint = promote:heroIsBattle(hero_data.hero_id)
                local alice_red = ctr.alice.data:checkNobilityReddot(hero_data.hero_id, cfg.herotype.star[hero_data.hero_type].occupation) ~= -1
                if redPoint then 
                    redPoint = promote:getHeroUpStarRedPoint(hero_data.hero_id) or promote:getHeroUp(hero_data.hero_id) or promote:getHeroCanUpgrade(hero_data.hero_id) or ex.Player.hero_data.equip:checkBattleHeroEquip(hero_data.hero_id) or promote:checkTalentReddot(hero_data.hero_id) or alice_red
                    if not redPoint then
                        local red ,_ = ex.Player.backpack_data:checkRunesRedByHero(hero_data.hero_id)
                        redPoint = red
                    end
                    
                    if not redPoint then
                        local update_stone_type_list = ex.Player.hero_data:checkHeroJewelRed(hero_data.hero_id, hero_data.star) 
                        if #update_stone_type_list > 0 then 
                            redPoint = true
                        end 
                    end

                    if not redPoint then 
                        -- 神装红点判断
                        redPoint = ex.Player.backpack_data:checkGodEquipRedDot(hero_data.hero_id,hero_data.star)
                    end 

                    if not redPoint then 
                        local reds = ex.Player.hero_data.artifact:checkRedPointByHeroId(hero_data.hero_id)
                        for k,v in pairs(reds) do
                            if v == true then 
                                redPoint = true 
                                break
                            end
                        end
                    end 

                    -- add 熊梦 英雄列表有皮肤可激活 显示红点
                    if not redPoint then 
                        local fashion_list = cfg.herofashion.getConfigsByHeroType(hero_data.hero_type)
                        for i, v in ipairs(fashion_list) do
                            local is_active = ex.Player.hero_data.fashion:isActive(v.fashion_id)
					        local is_actionable = ex.Player.hero_data.fashion:isActionable(v.fashion_id)
                            -- 皮肤是否可激活
                            if not is_active and is_actionable then
                                redPoint = true
                                break
                            end
                            -- 皮肤是否可以升级
                            local data = ex.Player.hero_data.fashion:getFashionDataByID(v.fashion_id)
                            if data ~= nil then
                                local max_config = cfg.herofashionup.getMaxConfigByType(v.fashion_id)
			                    local max_level = max_config.level
                                local level = is_active and data.level or 0
                                local up_config = cfg.herofashionup.getConfigByTypeAndLevel(v.fashion_id, math.max(0, math.min(max_level, level)))
                                local is_upgrade_show =  is_active and data.status == 0 and up_config.level < max_level
                                if ex.Player.hero_data.fashion:isCanUpgrade(v.fashion_id, level) and is_upgrade_show then
                                    redPoint = true
                                    break
                                end
                            end
                        end
                    end 
                    if not redPoint then 
                        redPoint = ex.Player.hero_data.pet:checkRedPointByHeroId(hero_data.hero_id)
                    end

                    if not redPoint then 
                        redPoint = ex.Player.hero_data.totems:checkRedPointByHeroId(hero_data.hero_id)
                    end

                    if not redPoint then
                        redPoint = ex.Player.hero_data.magic_wand:checkReddot(hero_data.hero_id)
                    end

                    if not redPoint then
                        redPoint = ex.Player.hero_data.hexagram:checkReddot(hero_data.hero_id)
                    end
                end
                item:setRedPoint(redPoint)
                item:registerScriptTapHandler(handler(self, self.onShowHeroInfo))
                item:isBattle(promote:heroIsBattle(hero_data.hero_id))
                item:setScale(scale)
            else 
                item = UIMenuItemHero:createWithData(0, 0, 0, 0)
                item:setEnabled(false)
                item:setScale(scale)
            end
            return item
        else
            local elem = config_type[hero_data.type].elem
            local level = config_star[hero_data.star].level_limit
            local item = UIMenuItemHero:createWithData(NULL_ID, hero_data.type, elem, level, hero_data.star)
            if hero_data.unlock == false then item:setGrayed("") end  
            item:registerScriptTapHandler(handler(self, self.onShowHeroIllustratInfo))
    
            local tag = -1
            local illustraData = ex.Player.hero_data:getCurIllustraCfg()
            for ik,idata in pairs(illustraData) do
                if idata.type == hero_data.type and idata.star == hero_data.star then 
                    tag = ik 
                    break
                end 
            end
            item:setScale(scale)
            item:setTag(tag)
            return item
        end
    end
    self.scroll_view:reloadData(data)
end

function HeroListHeroLayer:setCapacityText()
    self.lbl_capacity:setString(string.format(ex.Tools:getLang(47261), ex.Player.hero_data:getLen(),
        ex.Player.hero_data:getCapacity()))
end

function HeroListHeroLayer:updateCapacity()
    self:setCapacityText()

    if self.cur_layer_tab == HeroListLayerHeroType.ILLUSTRAT then return end
    self.cur_hero_elem = ElemType.ALL
    local data = ex.Player.hero_data:getHeroByElem(ElemType.ALL)
    self:updateTableView(data)
end

function HeroListHeroLayer:onIllustratUpdate(event, data)
    if self.cur_layer_tab ~= HeroListLayerHeroType.ILLUSTRAT then
        return
    end

    local list = ex.Player.hero_data:editIllustratListByElem()
    ex.Player.hero_data:setCurIllustratCfg(list)

    self:updateTableView(list)
end

-- 点击英雄列表英雄回调
function HeroListHeroLayer:onShowHeroInfo(tag, pSender)
    local heroId = pSender:getHeroId()
    ex.Player.hero_data.promote:setSelectHero(heroId)
    ex.MainSceneCtr:changeLayer(MainSceneType.HERO_INFO_LAYER)
end

-- 点击英雄图鉴英雄回调
function HeroListHeroLayer:onShowHeroIllustratInfo(tag,pSender)
    ex.Player.hero_data:setIllustratIdx(tag)
    ex.Player.hero_data:setOpenTab(2)
    ex.MainSceneCtr:changeLayer(MainSceneType.HERO_ILLUSTRAT_INFO_LAYER)
end

-- 加容量
function HeroListHeroLayer:onAddCapacity(tag, pSender)
    local config = ex.Player.hero_data:getHeroCapacityConfig(ex.Player.hero_data.buy_space_times + 1)
    local num = 10000000
    local gem = 10000000
    if config then
        gem = config.prize[1].item_num
        num = config.space
    else
        ex.MessageView:add(ex.Tools:getLang(47054))
        return
    end

    local function buy()
        -- for i = 1 ,100 do 
            -- local req_hero_capacity = cpp.ByteArray:create()
            -- req_hero_capacity:writeInt(ProtocolID.GReqShopBuyHeroCapacity)
            -- cpp.NetManager:instance():sendByteArray(req_hero_capacity)
            NetManager:sendMessage(ProtocolID.GReqShopBuyHeroCapacity)
        -- end
    end

    local function charge()
        ex.MainSceneCtr:changeToRechargePage()
    end
    -- 购买英雄容量上限
    if ex.Player.gem >= gem then 
        local title = ex.Tools:getLang(41002)
        local content = string.format(ex.Tools:getLang(41003),gem,num)
        require("src.layer.ConfirmCtr"):instance():openWindow(title,content,buy)
    else
        local title = ex.Tools:getLang(41004)
        local content = ex.Tools:getLang(41005)
        local confirm_str = ex.Tools:getLang(41006)
        require("src.layer.ConfirmCtr"):instance():openWindow(title,content,charge,confirm_str)
    end
end

function HeroListHeroLayer:onEvolveInfo(tag, pSender)
    require("src.layer.herolist.HeroEvolveIllustratCtr"):instance():openWindow()
    local first_evolve_ill_rp_status = cc.UserDefault:getInstance():getIntegerForKey("first_evolve_ill_rp_status", -1)
    if first_evolve_ill_rp_status == 1 then
        cc.UserDefault:getInstance():setIntegerForKey("first_evolve_ill_rp_status", 0)
    end
    
    local evolve_rp = cc.UserDefault:getInstance():getBoolForKey("has_evolve_red_point", false)
    if evolve_rp then
        cc.UserDefault:getInstance():setBoolForKey("has_evolve_red_point", false)
    end

    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_TJT_JHTJ, false)
end

function HeroListHeroLayer:goSkinShop()
    
   if ex.Player.hero_data:isOpenHeroSkinShop() then
    NetManager:sendMessage(ProtocolID.GReqHeroSkinList)
    ex.MainSceneCtr:changeLayer(MainSceneType.HERO_SKIN_SHOP)
   end 
  
    
end

return HeroListHeroLayer
