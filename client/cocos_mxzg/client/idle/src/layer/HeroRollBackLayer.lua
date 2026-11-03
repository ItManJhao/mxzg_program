local HeroRollBackLayer = class("HeroRollBackLayer", require("src.comp.EventLayer"))

local UIItemHero = require("src.comp.menu.UIMenuItemHero")

local HeroAnim = require("src.person.Hero")
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

-------------------------------HeroRollBackLayer-----------------------------------------------
function HeroRollBackLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)


    local last_content_size = self:getContentSize()
    local cur_content_size = cc.size(ex.p.width - 20, ex.p.height - 220)
    local offset = cc.p(cur_content_size.width - last_content_size.width, cur_content_size.height - last_content_size.height)

    self:setContentSize(cur_content_size)
    self:setPosition(ex.p.width / 2 - self:getContentSize().width / 2, ex.p.height / 2 - self:getContentSize().height / 2 + 20)
    local notch_height = require("src.model.Game"):instance():getNotchHeight()

    self.btn_info:setPosition(self:getContentSize().width / 2 + ex.p.width / 2 / self:getScaleX() - 20 / self:getScaleX() -  60, self.btn_info:getPositionY() + offset.y - 100 - notch_height)

    self.image_bg:setPosition(self.image_bg:getPositionX() + offset.x / 2 ,  self.image_bg:getPositionY() )
    self.lbl_select_num:setPosition(self.lbl_select_num:getPositionX() + offset.x / 2, self.lbl_select_num:getPositionY() )
    self.image_bg_icno:setPosition(self.image_bg_icno:getPositionX() + offset.x / 2, self.image_bg_icno:getPositionY() )
    self.btn_add:setPosition(self.btn_add:getPositionX() + offset.x / 2, self.btn_add:getPositionY() )

    self.msg_panel:setPosition(self.msg_panel:getPositionX() + offset.x / 2, self.msg_panel:getPositionY() )

    self.select_2:setPosition(self.select_2:getPositionX() + offset.x / 2, self.select_2:getPositionY() + offset.y * 0.5 - 50)
    self.select_1:setPosition(self.select_1:getPositionX() + offset.x / 2, self.select_1:getPositionY() + offset.y * 0.5 - 250)


    self.btn_enter:setPosition(self.btn_enter:getPositionX() + offset.x / 2, self.btn_enter:getPositionY() )  

    self.lbl_tip_text:setPosition(self.lbl_tip_text:getPositionX() + offset.x / 2, self.lbl_tip_text:getPositionY() )  

    
    self.select_hero = UIItemHero:createWithData(0, 0, 0, 0)
    self.select_hero:setPosition(0,0)

    self.btn_enter:registerScriptTapHandler(handler(self, self.onBtnEnter))

    self.lbl_select_num:setString(ex.Player:getItemNum(901807))

    local menu = cpp.UIMenu:create()
    menu:setName("menu")
    :setPosition(cc.p(0, 0))
    self.select_hero_btn:addChild(menu)
    menu:addChild(self.select_hero)
    self.select_hero:registerScriptTapHandler(handler(self,self.onClickHero))
    self:reorderChild(menu, 100)
    self:reorderChild(self.lbl_tip_text_20, 101)
    self.spr_add_image = cc.Sprite:createWithSpriteFrameName("other/spr-add-1.png")
    :setScale(1)
    :setPosition(0,0)
    self.select_hero_btn:addChild(self.spr_add_image)
    self:reorderChild(self.spr_add_image, 101)

    local zhihuan = sp.SkeletonAnimation:create("spine/zhihuanfazhen.json","spine/zhihuanfazhen.atlas", 1)
    zhihuan:setAnimation(0, "idle", true);
    zhihuan:setPosition(0,0)
    self.select_hero_btn:addChild(zhihuan)


    self.lbl_tip_text:setString("")
    self.lbl_money_refresh = require("src.comp.RichTextEx"):create()
	:setFontSize(20)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
    :setAnchorTextShadow(true)
    :setWrapMode(1)
    self.lbl_money_refresh:setPosition(self.lbl_tip_text:getPositionX(),self.lbl_tip_text:getPositionY() - 2)
	self:addChild(self.lbl_money_refresh)


    local str = ex.Tools:getLang(70561)
    self.lbl_money_refresh:setXmlTextLua(str)



	self.lbl_btn_refresh = require("src.comp.RichTextEx"):create()
	:setFontSize(20)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setAnchorTextShadow(true)
    :setWrapMode(1)
	self.btn_enter:addChild(self.lbl_btn_refresh)
	self.lbl_btn_refresh:setPosition(self.btn_enter:getContentSize().width * 0.5 ,self.btn_enter:getContentSize().height * 0.5)


    -- local show_text = cc.Label:createWithTTF(ex.Tools:getLang(47761), FONT_DEFAULT_NAME_BOLD, 36)
    -- show_text:setScale(0.6)
    -- self.btn_enter:addChild(show_text)
    -- show_text:setPosition(self.btn_enter:getContentSize().width * 0.5 ,self.btn_enter:getContentSize().height * 0.5 + 15 )
    -- show_text:setTextColor(FONT_BLACK_TEXT)

-- spr_bg_msg_bg
    self:initDone()
    -- self:addEvent(EVENT.HERO_EVENT.HERO_PUERNUTE, handler(self,self.onSelectHeroList))
    self:addEvent(EVENT.HERO_EVENT.HERO_ROLLBACK_SUCCRESS, handler(self,self.onHeroRollBackSuccess))

    self:addEvent(EVENT.HERO_EVENT.HERO_ROLLBACK_GETHEROLIST, handler(self,self.onClickHeroList))

    local str_1 = string.format(ex.Tools:getLang(47177),901807,0)
    self.lbl_btn_refresh:setXmlTextLua(str_1)
    

    self.btn_enter:setVisible(false)
    self:initData()
end 



function HeroRollBackLayer:onHeroRollBackSuccess( event, data)
    
    local reikis = ex.Player.hero_data.artifact:getArtifactDataByHeroId(self.select_hero_data.hero_id)
    ex.Player.hero_data:removeHeroDataById(self.select_hero_data.hero_id)

    self.select_hero_data = nil

    -- 开始清除选择数据    
    local HeroAbilityData = require("src.data.HeroAbilityData")
	local hero = HeroAbilityData.new()
	hero.hero_id = data.hero_id
	hero.hero_type = data.hero_type
	hero.level = data.level
	hero.stage = data.stage
	hero.star = data.star
	hero.elem = data.elem
	hero.occupation = data.occupation
	hero.is_lock = data.is_lock == 1
	hero.hp_up_level = data.hp_up_level
	hero.atk_up_level = data.atk_up_level
	hero.fighting = data.fighting
	hero.equip = {}
    hero.talents = data.talents
    hero.reiki_places = {}
    hero.awaken = data.awaken
    for k,v in pairs(data.reiki_places) do
        hero.reiki_places[v] = v
    end
    
    for k,v in pairs(reikis) do
        v.hero_id = data.hero_id
    end

	ex.Player.hero_data:addHero(hero)

    -- local heros = {}
    -- table.insert( heros, {item_type = data.hero_type, item_num = 1, star = data.star, level = data.level})
	-- require("src.layer.ItemRewardCtr"):instance():openWindow(heros)

    self:updateScrollView(ex.Tools:getSysCfg("hero_back_reward"))

    self:initData( )
    -- 重置数据
end 


function HeroRollBackLayer:onClickHero(tag,pSender)
    NetManager:sendMessage(ProtocolID.GReqComeBackInfo)
end


function HeroRollBackLayer:onClickHeroList(event, data)

   
    --local data = ex.Player.hero_data:getHeroByElem(0)
    local select_data = {}
    select_data.idx = 0
    select_data.num = 1
    select_data.type = 0 
    select_data.elem = 0
    select_data.star = 10
    select_data.max_star = 20
    select_data.occupation = 0
    select_data.selected_hero_ids = {}
    select_data.data_list = data
    select_data.close_handle = handler(self, self.setSelectHeroList)

    select_data.window_name = ex.Tools:getLang(47161)
    select_data.window_msg = ex.Tools:getLang(70562)

    require("src.layer.HeroPernuteSelectCtrl"):instance():openWindow(select_data)


end



function HeroRollBackLayer:setSelectHeroList( idx, selected)

    local select_hero_data = nil
    for k, v in pairs(ex.Player.hero_data.hero_list) do
        if selected[1] == v.hero_id then 
            select_hero_data = v
        end 
    end 

    if not select_hero_data then return end 

    self.select_hero_data = select_hero_data
    -- 刷新数据

    self:ReshrefSelectHero()
end
    
-- 刷新选择英雄
function HeroRollBackLayer:ReshrefSelectHero( )

    self.select_2:setVisible(true)
    self.select_1:setVisible(false)

    self.btn_enter:setVisible(true)

    self:setHeroLayret(self.select_hero_data.hero_id, self.select_hero_data.hero_type, self.select_hero_data.level, self.select_hero_data.star)

    local data_hero = {}
    data_hero.star = self.select_hero_data.star
    data_hero.stage = self.select_hero_data.stage
    -- 设置返回星级
    self:createStar(data_hero)


    -- 设置返回等级
    -- 获取9行最大等级
    local star_max_level= cfg.herostar.star[9]
    self.lbl_now_level:setString("Lv " .. self.select_hero_data.level) 
    
    local show_to_level = self.select_hero_data.level
    if self.select_hero_data.level > star_max_level.level_limit then 
        show_to_level = star_max_level.level_limit

    end 
    self.lbl_now_to_level:setString("Lv " .. show_to_level) 

    self.lbl_name:setString(ex.Tools:getLang(self.select_hero_data.hero_type))


    -- self.icon_occupat:setSpriteFrame("hero-icon/elem-" .. self.select_hero_data.elem .. ".png")
    ex.Tools:setSpriteFrame(self.icon_occupat, "hero-icon/elem-" .. self.select_hero_data.elem .. ".png")
	self.icon_occupat:setScale(0.45)

    self.icon_occupat:setPosition(self.lbl_name:getPositionX() - self.lbl_name:getContentSize().width * 0.5 , self.lbl_name:getPositionY())

    -- 设置返回物品
    -- 计算物品
    -- 先计算等级退还   
    local get_item_list = self:getRollbackData( )

    self.need_cost_config = nil
    for i,v in ipairs(cfg.heroback.heroback) do
        if  v.elem ==  self.select_hero_data.elem and v.star ==  self.select_hero_data.star and
        ((not self.select_hero_data.evolve and v.evolve_level == 0) or self.select_hero_data.evolve.level == v.evolve_level) then 
            self.need_cost_config = v
        end
    end

    -- 固定展示
    -- 展示本体英雄

    -- 显示物品
    local show_data_list = {}
    local toNowHeroList = {}


    local HeroAbilityData = require("src.data.HeroAbilityData")
	local toHero = HeroAbilityData.new()
	toHero.hero_id = self.select_hero_data.hero_id
	toHero.hero_type = self.select_hero_data.hero_type
	toHero.level = show_to_level
	toHero.stage = self.select_hero_data.stage
	toHero.star = 9
	toHero.elem = self.select_hero_data.elem
	toHero.occupation = self.select_hero_data.occupation
	toHero.is_lock = self.select_hero_data.is_lock == 1
	toHero.hp_up_level = self.select_hero_data.hp_up_level
	toHero.atk_up_level = self.select_hero_data.atk_up_level
	toHero.fighting = self.select_hero_data.fighting
	toHero.equip = {}
    toHero.talents = self.select_hero_data.talents
    
    
    local hero_type_config = cfg.herotype.star[self.select_hero_data.hero_type]
    local bendihero = {hero = toHero, isHero = 1}
    local bendiheros = {item_type = hero_type_config.item_id , item_num = self.need_cost_config.reback_hero_chip_num}
    
    table.insert( toNowHeroList, bendihero)
    table.insert( toNowHeroList, bendiheros)
    show_data_list = self:createItem(show_data_list, toNowHeroList)   -- 本体英雄碎片
    show_data_list = self:createItem(show_data_list, self.need_cost_config.reback_item)
    show_data_list = self:createItem(show_data_list, get_item_list)

    self:updateScrollView(show_data_list)
    -- 计算消耗
    local str_1 = string.format(ex.Tools:getLang(47094),self.need_cost_config.cost[1].item_type,self.need_cost_config.cost[1].item_num)
    self.lbl_btn_refresh:setXmlTextLua(str_1)

end

function HeroRollBackLayer:createItem( tab1 , tab2 )
    local returnItemList = {}
    for k,v in pairs(tab1) do
        table.insert( returnItemList, v )
    end
    for k,v in pairs(tab2) do
        table.insert( returnItemList, v )
    end
    return returnItemList
end


function HeroRollBackLayer:onBtnEnter(tag,pSender)

    if not self.select_hero_data then 
        return 
    end 


    -- 判断消耗
    local num = ex.Player:getItemNum(self.need_cost_config.cost[1].item_type)
    if num < self.need_cost_config.cost[1].item_num then
        ex.Tools:showEnoughTip(self.need_cost_config.cost[1].item_type)
        return
    end

    local req = Hero_pb.GReqComeBack()
    req.hero_id = self.select_hero_data.hero_id

    NetManager:sendMessage(ProtocolID.GReqComeBack, req)


end 



function HeroRollBackLayer:getRollbackData( )
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

    local star_max_level= cfg.herostar.star[9]
    local level_start =  self.select_hero_data.level >= star_max_level.level_limit and star_max_level.level_limit or self.select_hero_data.level
    -- 升级返还的材料
    for i=level_start,self.select_hero_data.level-1 do
        local config = cfg.herolevel.level[i]
        if config then
            inserItem(ItemType.IT_GOLD, config.gold_need)
            inserItem(ItemType.IT_HERO_EXP, config.exp_need)
        end
    end
    -- 升星返还的材料 
    for i=9,self.select_hero_data.star-1 do
        local star = cfg.herostar.star[i]
        if star ~= nil then 
            for _,n in pairs(star.upstar_cost) do
                inserItem(n.item_type, n.item_num)
            end
        end
    end

    return item_list

end






function HeroRollBackLayer:createStar(data)
	local margin = -18
	self.now_star:removeAllChildren()
	self.to_star:removeAllChildren()

    local pos = {}
    local show_star = data.star - 9
	for i=1, show_star do
		if i == 1 then 
			pos.x = 0
			pos.y = -5
		end
		local path =  "other/star-2.png"
		local sp = cc.Sprite:createWithSpriteFrameName(path)
		self.now_star:addChild(sp)
        sp:setScale(0.8)
		sp:setPosition(-pos.x,pos.y)
		pos.x = pos.x + sp:getContentSize().width + margin
	end

	for i=1,4 do
		if i == 1 then 
			pos.x = 0
			pos.y = -5
		end
		local path = "other/star-1.png"
        local sp = cc.Sprite:createWithSpriteFrameName(path)
        sp:setScale(0.8)
		self.to_star:addChild(sp)
		sp:setPosition(pos.x,pos.y)
		pos.x = pos.x + sp:getContentSize().width + margin
	end
end


function HeroRollBackLayer:setHeroLayret(hero_id, hero_type, level, star)
    self:removeHero(false)

    -- 创建一个骨骼动画
    -- self.hero_layer = HeroAnim:create("12323", "123213", hero_type, level, star)
    -- self.hero_layer:setAnchorPoint(cc.p(0.5, 0))
    -- self.hero_layer:setPosition(0,-30)
    -- self.hero_layer:setScale(2)
    -- self.now_hero:addChild(self.hero_layer)
    -- self.hero_layer:stopUpdateZOrder(15)
    -- self.hero_layer:setShadowVisible(false)

    local fashion_id = ex.Player.hero_data.fashion:getWearByID(hero_id) or 0

	if fashion_id == 0 then
        local evolve
        local hero_data = ex.Player.hero_data:getHeroDataById(hero_id)
        if hero_data then
            evolve = hero_data.evolve
        end

        local skin = ex.Tools:getHeroSkinByStar(hero_type, star, evolve)
        self.hero_layer = require("src.person.Hero"):create("12323", "123213", hero_type, level, star, skin)
    else
		self.hero_layer = require("src.person.Hero"):create("1", "1", 1, 1, 1, fashion_id)
	end
    
    self.hero_layer:setScale(2)
    self.hero_layer:setPosition(0,240)
    self.now_hero:addChild(self.hero_layer)



end



function HeroRollBackLayer:removeHero(flag)
    if flag and  self.hero_layer then
        self.hero_layer:removeFromParent()
        self.hero_layer = nil
    end

end

function HeroRollBackLayer:initDone( )
    
    self.item_size = cc.Sprite:createWithSpriteFrameName("other/rare-0.png"):getContentSize()
    self.item_size = cc.size(self.item_size.width + 10, self.item_size.height + 12)

    self.viewSize = self.spr_bg_backpack:getContentSize()

    self.scroll_view = require("src.comp.UIScrollViewBackpack"):createWithSize(self.viewSize)
    self.scroll_view:setPosition(self.spr_bg_backpack:getPositionX() - self.viewSize.width / 2, self.spr_bg_backpack:getPositionY())
    self.scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.scroll_view:setItemSize(cc.size(self.item_size.width, self.item_size.height + 10))
    self.scroll_view:setItemOffset(cc.p(0, 5))
    self.msg_panel:addChild(self.scroll_view)


    self:updateScrollView(ex.Tools:getSysCfg("hero_back_reward"))
end



function HeroRollBackLayer:updateScrollView(data)

    self.scroll_view.createItemFunction = function(item_data, scale)
        
        local item = nil 
        if item_data.isHero and  item_data.isHero == 1 then 
            item = UIMenuItemHero:createWithData()
            item:reset(item_data.hero)
            --item:registerScriptTapHandler(handler(self,self.onClickItemHero))
        else  
            item = ex.Player.backpack_data:createWithData(item_data.item_type, item_data.item_num)
            item:registerScriptTapHandler(handler(self, self.onClick))
        end 

        return item
    end
    self.scroll_view:reloadData(data)

end 

function HeroRollBackLayer:onClickItemHero(tag,pSender)


end



function HeroRollBackLayer:onClick(tag,pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end


function HeroRollBackLayer:initData( )

    self.select_hero_btn:setVisible(true)

    self:removeHero(true)

    local hero_data = {}
    hero_data.level = 0
    hero_data.star = 0
    hero_data.hero_type = 0
    hero_data.elem = 0
    self.select_hero:reset(hero_data)

    self.select_1:setVisible(true)
    self.select_2:setVisible(false)

    local str_1 = string.format(ex.Tools:getLang(47094),901807,0)
    self.lbl_btn_refresh:setXmlTextLua(str_1)

    self.lbl_select_num:setString(ex.Player:getItemNum(901807))
end




function HeroRollBackLayer:onAdd( tag, pSender)
    ex.MainSceneCtr:instance():changeLayer(MainSceneType.MAINCITY_LAYER)
    local return_data = cfg.system["hero_back_atom"]
    cfg.funcopen[return_data.event_arg].open({select_idx = return_data.type})

end




function HeroRollBackLayer:onBtnInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42052), ex.Tools:getLang(42053))
end

function HeroRollBackLayer:onBtnShop(tag, pSender)
    cfg.funcopen.main_shop.open(SHOP_TYPE.SACRIFICE)
end


function HeroRollBackLayer:onSelectHeroEvevt(event,data)
    --self:onSelectHero(data)
end 




function HeroRollBackLayer:setHeroLeft(hero_type, level, star)
    self:removeHero(true, false)

    -- 创建一个骨骼动画
    -- self.hero_left = HeroAnim:create("12323", "123213", hero_type, level, star)
    -- self.hero_left:setAnchorPoint(cc.p(0.5, 0))
    -- self.hero_left:setPosition(self.spr_light_left:getPositionX(), self.spr_light_left:getPositionY() + 10)
    -- self:addChild(self.hero_left)
    -- self.hero_left:stopUpdateZOrder(15)
    -- self.hero_left:setShadowVisible(false)


    local skin = ex.Tools:getHeroSkinByStar(hero_type,star)
    self.hero_left = require("src.person.Hero"):create("12323", "123213", hero_type,level, star, skin)
    self.hero_left:setScale(1.5)
    self.hero_left:setPosition(self.spr_light_left:getPositionX(), self.spr_light_left:getPositionY() + 110)
    self:addChild(self.hero_left)


    self.node_name_1:setVisible(true)

    -- 出现选择对应英雄的窗口

    self.node_change_hero:setVisible(true)


end






function HeroRollBackLayer:onBtnInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42052), ex.Tools:getLang(42053))
end


return HeroRollBackLayer
