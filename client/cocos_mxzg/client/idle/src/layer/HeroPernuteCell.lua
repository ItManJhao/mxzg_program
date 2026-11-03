local HeroPernuteCell = class("HeroPernuteCell", require("src.comp.EventLayer"))

local UIItemHero = require("src.comp.menu.UIMenuItemHero")

local HeroAnim = require("src.person.Hero")
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

-------------------------------HeroPernuteCell-----------------------------------------------
function HeroPernuteCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)


    local last_content_size = self:getContentSize()
    local cur_content_size = cc.size(ex.p.width - 20, ex.p.height - 220)
    local offset = cc.p(cur_content_size.width - last_content_size.width, cur_content_size.height - last_content_size.height)

    self:setContentSize(cur_content_size)
    self:setPosition(ex.p.width / 2 - self:getContentSize().width / 2, ex.p.height / 2 - self:getContentSize().height / 2 + 20)

    local notch_height = require("src.model.Game"):instance():getNotchHeight()


    self.spr_light_bottom_left:setPosition(self.spr_light_bottom_left:getPositionX() + offset.x / 2, self.spr_light_bottom_left:getPositionY() + offset.y * 0.5 - 100)
    self.spr_light_bottom_right:setPosition(self.spr_light_bottom_right:getPositionX() + offset.x / 2, self.spr_light_bottom_right:getPositionY() + offset.y * 0.5 - 100 )
    self.spr_light_left:setPosition(self.spr_light_left:getPositionX() + offset.x / 2, self.spr_light_left:getPositionY() + offset.y * 0.5 - 100)
    self.spr_light_right:setPosition(self.spr_light_right:getPositionX() + offset.x / 2, self.spr_light_right:getPositionY() + offset.y * 0.5- 100)





    self.spine_effect_left_1 = sp.SkeletonAnimation:create("spine/prophet-tree-effect-1.json","spine/prophet-tree-effect-1.atlas", 1)
    self.spine_effect_left_1:setAnimation(0, "stand", true);
    self.spine_effect_left_1:setPosition(self.spr_light_bottom_left:getPositionX(), self.spr_light_bottom_left:getPositionY() + 15)
    self:addChild(self.spine_effect_left_1, 20)

    self.spine_effect_left_2 = sp.SkeletonAnimation:create("spine/prophet-tree-effect-2.json","spine/prophet-tree-effect-2.atlas", 1)
    self.spine_effect_left_2:setAnimation(0, "stand", true);
    self.spine_effect_left_2:setPosition(self.spr_light_bottom_left:getPositionX(), self.spr_light_bottom_left:getPositionY() + 15)
    self:addChild(self.spine_effect_left_2, 10)

    self.spine_effect_right_1 = sp.SkeletonAnimation:create("spine/prophet-tree-effect-1.json","spine/prophet-tree-effect-1.atlas", 1)
    self.spine_effect_right_1:setAnimation(0, "stand", true);
    self.spine_effect_right_1:setPosition(self.spr_light_bottom_right:getPositionX(), self.spr_light_bottom_right:getPositionY() + 15)
    self:addChild(self.spine_effect_right_1, 20)

    self.spine_effect_right_2 = sp.SkeletonAnimation:create("spine/prophet-tree-effect-2.json","spine/prophet-tree-effect-2.atlas", 1)
    self.spine_effect_right_2:setAnimation(0, "stand", true);
    self.spine_effect_right_2:setPosition(self.spr_light_bottom_right:getPositionX(), self.spr_light_bottom_right:getPositionY() + 15)
    self:addChild(self.spine_effect_right_2, 10)


    self.spine_effect_left_1:setPosition(self.spr_light_bottom_left:getPositionX(), self.spr_light_bottom_left:getPositionY() + 15)
    self.spine_effect_left_2:setPosition(self.spr_light_bottom_left:getPositionX(), self.spr_light_bottom_left:getPositionY() + 15)
    self.spine_effect_right_1:setPosition(self.spr_light_bottom_right:getPositionX(), self.spr_light_bottom_right:getPositionY() + 15)
    self.spine_effect_right_2:setPosition(self.spr_light_bottom_right:getPositionX(), self.spr_light_bottom_right:getPositionY() + 15)



    self.node_name_1:setPosition(self.spr_light_bottom_left:getPositionX(), self.spr_light_bottom_left:getPositionY() )
    self.node_name_2:setPosition(self.spr_light_bottom_right:getPositionX(), self.spr_light_bottom_right:getPositionY() )

    self.node_change_hero:setPosition(self.node_change_hero:getPositionX() + offset.x / 2, self.node_change_hero:getPositionY() + offset.y * 0.5  - 100)


    self.btn_info:setPosition(self:getContentSize().width / 2 + ex.p.width / 2 / self:getScaleX() - 20 / self:getScaleX() -  60, self.btn_info:getPositionY() + offset.y - 100 - notch_height)
    self.spr_hero_bg:setPosition(self.spr_hero_bg:getPositionX() + offset.x / 2, self.spr_hero_bg:getPositionY() + 80)
    self.spr_hero_bg:setContentSize(self.spr_hero_bg:getContentSize().width, self.spr_hero_bg:getContentSize().height + offset.y * 0.5 - 250)
    self.lbl_select_num:setString(ex.Player:getItemNum(901807))

    self.btn_elem0:setPosition(self.btn_elem0:getPositionX() + offset.x / 2, self.spr_hero_bg:getPositionY() + self.spr_hero_bg:getContentSize().height - 40  )
    self.btn_elem1:setPosition(self.btn_elem1:getPositionX() + offset.x / 2, self.spr_hero_bg:getPositionY() + self.spr_hero_bg:getContentSize().height - 40)
    self.btn_elem2:setPosition(self.btn_elem2:getPositionX() + offset.x / 2, self.spr_hero_bg:getPositionY() + self.spr_hero_bg:getContentSize().height - 40)
    self.btn_elem3:setPosition(self.btn_elem3:getPositionX() + offset.x / 2, self.spr_hero_bg:getPositionY() + self.spr_hero_bg:getContentSize().height - 40)
    self.btn_elem4:setPosition(self.btn_elem4:getPositionX() + offset.x / 2, self.spr_hero_bg:getPositionY() + self.spr_hero_bg:getContentSize().height - 40)
    self.btn_elem5:setPosition(self.btn_elem5:getPositionX() + offset.x / 2, self.spr_hero_bg:getPositionY() + self.spr_hero_bg:getContentSize().height - 40)


    self.image_bg:setPosition(self.image_bg:getPositionX() + offset.x / 2 ,  self.spr_hero_bg:getPositionY() + self.spr_hero_bg:getContentSize().height+ 40)
    self.lbl_select_num:setPosition(self.lbl_select_num:getPositionX() + offset.x / 2, self.spr_hero_bg:getPositionY() + self.spr_hero_bg:getContentSize().height + 40)
    self.image_bg_icno:setPosition(self.image_bg_icno:getPositionX() + offset.x / 2, self.spr_hero_bg:getPositionY() + self.spr_hero_bg:getContentSize().height + 40)
    self.btn_add:setPosition(self.btn_add:getPositionX() + offset.x / 2, self.spr_hero_bg:getPositionY() + self.spr_hero_bg:getContentSize().height + 40)



    self.btn_enter:setPosition(self.spr_hero_bg:getPositionX() + self.spr_hero_bg:getContentSize().width * 0.5, self.spr_hero_bg:getPositionY() + self.spr_hero_bg:getContentSize().height + 70)  

    self.lbl_show_msg:setPosition(self.spr_hero_bg:getPositionX() + self.spr_hero_bg:getContentSize().width * 0.5, self.spr_hero_bg:getPositionY() + self.spr_hero_bg:getContentSize().height - 100)

    self.select_hero = UIItemHero:createWithData(0, 0, 0, 0)
    self.select_hero:setPosition(0,0)

    self.btn_enter:registerScriptTapHandler(handler(self, self.onBtnEnter))


    local menu = cpp.UIMenu:create()
    menu:setName("menu")
    :setPosition(cc.p(0, 0))
    self.node_change_hero:addChild(menu)
    menu:addChild(self.select_hero)
    self.select_hero:registerScriptTapHandler(handler(self,self.onClickHero))

    self.spr_add_image = cc.Sprite:createWithSpriteFrameName("other/spr-add-1.png")
    :setScale(1)
    :setPosition(0,0)
    self.node_change_hero:addChild(self.spr_add_image)
    self.spr_add_image:setVisible(true)


    self.hero_num_str = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 36)
    self.hero_num_str:setScale(0.6)
    self.node_change_hero:addChild(self.hero_num_str)
    self.hero_num_str:setPosition(self.select_hero:getContentSize().width * 0.5- 25, -self.select_hero:getContentSize().height * 0.5 + 15 )
    self.hero_num_str:setTextColor(FONT_WHITE_C4B)

    self:reorderChild(self.node_change_hero, 200)
    --self.node_change_hero:stopUpdateZOrder(20)
    self.node_change_hero:setVisible(false)


	self.lbl_btn_refresh = require("src.comp.RichTextEx"):create()
	:setFontSize(24)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setAnchorTextShadow(true)
    :setWrapMode(1)
	self.btn_enter:addChild(self.lbl_btn_refresh)
	self.lbl_btn_refresh:setPosition(self.btn_enter:getContentSize().width * 0.5 ,30)


    -- local show_text = cc.Label:createWithTTF(ex.Tools:getLang(47315), FONT_DEFAULT_NAME_BOLD, 36)
    -- show_text:setScale(0.6)
    -- self.btn_enter:addChild(show_text)
    -- show_text:setPosition(self.btn_enter:getContentSize().width * 0.5 ,self.btn_enter:getContentSize().height * 0.5 + 15 )
    -- show_text:setTextColor(FONT_BLACK_TEXT)


    self:initDone()
    self:addEvent(EVENT.HERO_EVENT.HERO_PUERNUTE, handler(self,self.onSelectHeroList))
    self:addEvent(EVENT.HERO_EVENT.HERO_PUERNUTE_SUCCRESS, handler(self,self.onHeroPernuteSuccess))
    self:addEvent(EVENT.HERO_EVENT.HERO_PUERNUTE_GETHEROLIST, handler(self,self.onHeroListsPernute))

    local str_1 = string.format(ex.Tools:getLang(47211),901807,0)
    self.lbl_btn_refresh:setXmlTextLua(str_1)
    
    NetManager:sendMessage(ProtocolID.GReqSwitchInfo)

end 



function HeroPernuteCell:onHeroListsPernute( event, data )
    
    self.hero_list = data

    self:updateScrollView()
end

function HeroPernuteCell:getHeroByElem(elem)
    if elem == 0 then
        return self.hero_list
    end
    local list = {}
    for i, v in ipairs(self.hero_list) do
        if v.elem == elem then
            table.insert(list, v)
        end
    end

    return list
end


function HeroPernuteCell:onHeroPernuteSuccess( event, data)

    -- 生成英雄，并且删除英雄
    for i,v in ipairs(self.select_hero_data) do
        ex.Player.hero_data:removeHeroDataById(v)
    end

    local reikis = ex.Player.hero_data.artifact:getArtifactDataByHeroId(self.click_hero_id)
    ex.Player.hero_data:removeHeroDataById(self.click_hero_id)

    self.click_hero_id = nil
    self.select_hero_data = nil

    for k,v in pairs(reikis) do
        v.hero_id = data.hero_id
    end
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
	ex.Player.hero_data:addHero(hero)

    local heros = {}
    table.insert( heros, {item_type = data.hero_type, item_num = 1, star = data.star, level = data.level, hero_id = data.hero_id})
	require("src.layer.ItemRewardCtr"):instance():openWindow(heros)
    -- 弹出英雄展示

    local str_1 = string.format(ex.Tools:getLang(47007),901807,0)
    self.lbl_btn_refresh:setXmlTextLua(str_1)


    -- self:updateScrollView()
    self:initData( )
    -- 重置数据

    NetManager:sendMessage(ProtocolID.GReqSwitchInfo)
end 

function HeroPernuteCell:initData( )
    self.node_change_hero:setVisible(false)

    self:removeHero(true, true)
    self.btn_enter:setVisible(false)
    local hero_data = {}
    hero_data.level = 0
    hero_data.star = 0
    hero_data.hero_type = 0
    hero_data.elem = 0
    self.select_hero:reset(hero_data)
    self.spr_add_image:setVisible(true)
    self.lbl_select_num:setString(ex.Player:getItemNum(901807))

    self.hero_num_str:setString("")
end


function HeroPernuteCell:onBtnEnter(tag,pSender)

    if not self.click_hero_id then 
        --self:onClickHero()
        return 
    end 

    if not self.select_hero_data  or   #self.select_hero_data < self.need_star_config.need_hero then 
        ex.MessageView:add(string.format( ex.Tools:getLang(70534), self.need_star_config.need_hero))
        return 
    end 

    -- 判断消耗
    local num = ex.Player:getItemNum(self.need_star_config.cost[1].item_type)
    if num < self.need_star_config.cost[1].item_num then
        ex.Tools:showEnoughTip(self.need_star_config.cost[1].item_type)
        return
    end

    local req = Hero_pb.GReqSwitch()
    req.hero_id = self.click_hero_id
    
    for i,v in ipairs(self.select_hero_data) do
        table.insert( req.target_hero_id, v )    
    end

    NetManager:sendMessage(ProtocolID.GReqSwitch, req)

end




function HeroPernuteCell:onSelectHeroList( event, data)

    -- 检测当前选贼英雄星级，类型
    self.need_star_config = nil
    for k,v in pairs(cfg.heroswitch.heroswitch) do
        if self.click_elem == v.elem and self.click_star == v.star then 
            self.need_star_config = v
        end 
    end



    local select_data = {}
    select_data.idx = 0
    select_data.num = self.need_star_config.need_hero
    select_data.type = 0 
    select_data.elem = 0
    select_data.star = 5
    select_data.occupation = 0
    
    if self.select_hero_data then 

        select_data.selected_hero_ids = self.select_hero_data
    else 

        select_data.selected_hero_ids = {}
    end 
    

    select_data.data_list = data
    select_data.close_handle = handler(self, self.setSelectHeroList)

    select_data.window_name = ex.Tools:getLang(47486)
    select_data.window_msg = ex.Tools:getLang(70537)

    require("src.layer.HeroPernuteSelectCtrl"):instance():openWindow(select_data)
   
end


function HeroPernuteCell:onClickHero(tag,pSender)

    local req = Hero_pb.GReqSwitchTargetList()
    req.hero_id = self.click_hero_id
    NetManager:sendMessage(ProtocolID.GReqSwitchTargetList, req)

end



function HeroPernuteCell:onAdd( tag, pSender)
    ex.MainSceneCtr:instance():changeLayer(MainSceneType.MAINCITY_LAYER)
    local return_data = cfg.system["hero_back_atom"]
    cfg.funcopen[return_data.event_arg].open({select_idx = return_data.type})

end


function HeroPernuteCell:setSelectHeroList( idx, selected)

    local select_hero_data = nil
    for k, v in pairs(ex.Player.hero_data.hero_list) do
        if selected[1] == v.hero_id then 
            select_hero_data = v
        end 
    end 

    if not select_hero_data then 
        self.select_hero_data = nil
        self:removeHero(false, true)
        local hero_data = {}
        hero_data.level = 0
        hero_data.star = 0
        hero_data.hero_type = 0
        hero_data.elem = 0
        self.select_hero:reset(hero_data)
        self.spr_add_image:setVisible(true)
        return     
    end 

    self.select_hero_data = selected

    -- 刷新
    local hero_data = {}
    hero_data.level = #selected .. "/" .. self.need_star_config.need_hero
    hero_data.star = 5
    hero_data.hero_type = select_hero_data.hero_type
    hero_data.elem = select_hero_data.elem
    self.select_hero:reset(hero_data)

    self.spr_add_image:setVisible(false)
    
    --self.hero_num_str:setString(#selected .. "/" .. self.need_star_config.need_hero )
    -- 
    local str = string.format(ex.Tools:getLang(47672),self.need_star_config.cost[1].item_type,self.need_star_config.cost[1].item_num)
    self.lbl_btn_refresh:setXmlTextLua(str)

    self:setHeroRight(select_hero_data.hero_type, self.click_level, self.click_star)
end


function HeroPernuteCell:onBtnInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42050), ex.Tools:getLang(42051))
end

function HeroPernuteCell:onBtnShop(tag, pSender)
    cfg.funcopen.main_shop.open(SHOP_TYPE.SACRIFICE)
end


function HeroPernuteCell:onSelectHeroEvevt(event,data)
    --self:onSelectHero(data)
end 

function HeroPernuteCell:initDone()

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
	--self:setSelectText()

	self.item_size = cc.Sprite:createWithSpriteFrameName("other/rare-0.png"):getContentSize()
    self.item_size = cc.size(self.item_size.width + 15, self.item_size.height + 12)

	-- 英雄列表scroll_view
	self.viewSize = self.spr_hero_bg:getContentSize()
    self.viewSize.height = self.viewSize.height - 150


    local bg_size = self.spr_hero_bg:getContentSize()
    bg_size.height = bg_size.height - 135
    bg_size.width = bg_size.width - 40
    self.spr_bg_backpack:setPosition(cc.p(self.spr_hero_bg:getPositionX() + self.spr_hero_bg:getContentSize().width * 0.5, self.spr_hero_bg:getPositionY() + 18))
    self.spr_bg_backpack:setContentSize(bg_size)
  

    self.scroll_view = require("src.comp.UIScrollViewBackpack"):createWithSize(self.viewSize)
    self.scroll_view:setPosition(cc.p(self.spr_hero_bg:getPositionX(), self.spr_hero_bg:getPositionY() + 23))
    self.scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.scroll_view:setItemSize(cc.size(self.item_size.width, self.item_size.height + 10))
    self.scroll_view:setItemOffset(cc.p(0, 5))
    self:addChild(self.scroll_view)


    self.click_hero_id = nil
    self.click_select_pSender = nil

    self.btn_enter:setVisible(false)
	
end



function HeroPernuteCell:updateScrollView(data, num)
	self.is_choose_elem = false
	self.hero_list_view = {}

    self.selected_hero_num = num or 0
	
    -- 获取当期属性英雄
    local show_hero_list = {}
    local show_hero_list = data or clone(self:getHeroByElem(self.cur_hero_elem))

    -- 给执行任务的英雄排序
    if data == nil then
        ex.Player.hero_data:sortByTask(show_hero_list, ex.Player:getHeroBattleList())
    end
    self.scroll_view.createItemFunction = function(item_data, scale)
        local item = UIItemHero:createWithData(item_data.hero_id, item_data.hero_type, item_data.elem, item_data.level, item_data.star)
        item:registerScriptTapHandler(function(tag, pSender)
            self:onSelectHero(pSender)
        end)

        --if ex.Player.hero_data.promote:checkHeroIsBattle(item_data.hero_id) then 
            --item:setBattling()
        --end 
        --local hero_data = ex.Player.hero_data:getHeroDataById(item_data.hero_id)
        --if hero_data.is_lock then
            --item:setLocked()
        --end
        item:autoLocked()

        local flag = self.click_hero_id and item_data.hero_id == self.click_hero_id or false
        item:setSelected( flag )
        if flag then 
            self.click_select_pSender = item
        end 
        
        return item
    end
    self.scroll_view:reloadData(show_hero_list)
    self.hero_list_view = show_hero_list


    self.is_choose_elem = true

end

function HeroPernuteCell:chooseHeroElem(elem)
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

function HeroPernuteCell:onChooseElem(tag, pSender)
	self:chooseHeroElem(tag)
end


function HeroPernuteCell:removeHero(isLeft, isRight)
    if isLeft and self.hero_left then
        self.hero_left:removeFromParent()
        self.hero_left = nil

        self.node_name_1:setVisible(false)
    end

    if isRight and self.hero_right then
        self.hero_right:removeFromParent()
        self.hero_right = nil

        self.node_name_2:setVisible(false)
    end
end



function HeroPernuteCell:setHeroLeft(hero_id, hero_type, level, star)
    self:removeHero(true, false)


    local fashion_id = ex.Player.hero_data.fashion:getWearByID(hero_id) or 0

	if fashion_id == 0 then
        local evolve
        local hero_data = ex.Player.hero_data:getHeroDataById(hero_id)
        if hero_data then
            evolve = hero_data.evolve
        end
        
        local skin = ex.Tools:getHeroSkinByStar(hero_type, star, evolve)
        self.hero_left = require("src.person.Hero"):create("12323", "123213", hero_type,level, star, skin)
    else
		self.hero_left = require("src.person.Hero"):create("1", "1", 1, 1, 1, fashion_id)
	end
    self.hero_left:setScale(1.5)
    self.hero_left:setPosition(self.spr_light_left:getPositionX(), self.spr_light_left:getPositionY() + 110)
    self:addChild(self.hero_left)

    -- 创建一个骨骼动画
    -- self.hero_left = HeroAnim:create("12323", "123213", hero_type, level, star)
    -- self.hero_left:setAnchorPoint(cc.p(0.5, 0))
    -- self.hero_left:setPosition(self.spr_light_left:getPositionX(), self.spr_light_left:getPositionY() + 10)
    -- self.hero_left:setScale(2)
    -- self:addChild(self.hero_left)
    -- self.hero_left:stopUpdateZOrder(15)
    -- self.hero_left:setShadowVisible(false)

    self.node_name_1:setVisible(true)

    -- 出现选择对应英雄的窗口

    self.node_change_hero:setVisible(true)


end


function HeroPernuteCell:setHeroRight(hero_type, level, star)
    self:removeHero(false, true)

    local skin = ex.Tools:getHeroSkinByStar(hero_type,star)
    self.hero_right = require("src.person.Hero"):create("12323", "123213", hero_type,level, star, skin)
    self.hero_right:setScale(1.5)
    self.hero_right:setPosition(self.spr_light_right:getPositionX(), self.spr_light_right:getPositionY() + 110)
    self:addChild(self.hero_right)

    -- 创建一个骨骼动画
    -- self.hero_right = HeroAnim:create("12323", "123213", hero_type, level, star)
    -- self.hero_right:setAnchorPoint(cc.p(0.5, 0))
    -- self.hero_right:setPosition(self.spr_light_right:getPositionX(), self.spr_light_right:getPositionY() + 10)
    -- self:addChild(self.hero_right)
    -- self.hero_right:stopUpdateZOrder(15)
    -- self.hero_right:setScale(2)

    -- self.hero_right:setShadowVisible(false)

    self.node_name_2:setVisible(true)

end


function HeroPernuteCell:onSelectHero( pSender)
    --if pSender.battle then
        ---- ex.MessageView:add(ex.Tools:getLang(47070))
        --ex.Player.hero_data:getHeroBattleMsg(pSender.hero_id)
        --return
    --end
    --if pSender.locked then
        --ex.MessageView:add(ex.Tools:getLang(41271))
        --return
    --end
    if pSender:showLockedMessage() then 
        return 
    end 

    -- 如果选择的是已
    if not self.click_hero_id then 
        self.click_hero_id = pSender.hero_id
        self.click_select_pSender = pSender

    else 
        if self.click_hero_id == pSender.hero_id then 
            return 
        else 
            if self.click_select_pSender["setSelected"] then 
                self.click_select_pSender:setSelected(false)
             end 
        end 
    end 

    self.click_hero_type = pSender.hero_id
    self.click_elem = pSender.elem
    self.click_star = pSender.star
    self.click_level = pSender.level

    self.click_hero_id = pSender.hero_id
    self.click_select_pSender = pSender
    pSender:setSelected(true)

    self:setHeroLeft(pSender.hero_id, pSender.hero_type, pSender.level, pSender.star) 

    ---------------------------------------------------
    self.select_hero_data = nil
    local hero_data = {}
    hero_data.level = 0
    hero_data.star = 0
    hero_data.hero_type = 0
    hero_data.elem = 0
    self.select_hero:reset(hero_data)
    self:removeHero(false, true)

    self.spr_add_image:setVisible(true)

    ---------------------------------------------------
    
    self.need_star_config = nil
    for k,v in pairs(cfg.heroswitch.heroswitch) do
        if self.click_elem == v.elem and self.click_star == v.star then 
            self.need_star_config = v
        end 
    end

    self.btn_enter:setVisible(true)
    local str = string.format(ex.Tools:getLang(47480),self.need_star_config.cost[1].item_type,self.need_star_config.cost[1].item_num)
    self.lbl_btn_refresh:setXmlTextLua(str)

end



function HeroPernuteCell:onBtnInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42050), ex.Tools:getLang(42051))
end


return HeroPernuteCell
