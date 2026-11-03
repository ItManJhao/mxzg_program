local AltarReirthLayer = class("AltarReirthLayer", require("src.comp.EventLayer"))

local UIItemHero = require("src.comp.menu.UIMenuItemHero")

local UIItemBackpack = require("src.comp/menu/UIMenuItemBackpack")




-------------------------------AltarReirthLayer-----------------------------------------------
function AltarReirthLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    local last_content_size = self:getContentSize()
    local cur_content_size = cc.size(ex.p.width - 20, ex.p.height - 220)
    local offset = cc.p(cur_content_size.width - last_content_size.width, cur_content_size.height - last_content_size.height)

    self:setContentSize(cur_content_size)
    self:setPosition(ex.p.width / 2 - self:getContentSize().width / 2, ex.p.height / 2 - self:getContentSize().height / 2 + 20)
    
    self.btn_info:setPosition(self:getContentSize().width / 2 + ex.p.width / 2 / self:getScaleX() - 20 / self:getScaleX() - 60, self.btn_info:getPositionY() + offset.y )
    self.spr_bg_2:setPosition(self.spr_bg_2:getPositionX() + offset.x / 2, self.spr_bg_2:getPositionY() )

    self.image_bg:setPosition(self.image_bg:getPositionX() + offset.x / 2, self.btn_info:getPositionY()  )
    self.lbl_select_num:setPosition(self.lbl_select_num:getPositionX() + offset.x / 2, self.btn_info:getPositionY()  )
    self.image_bg_icno:setPosition(self.image_bg_icno:getPositionX() + offset.x / 2, self.btn_info:getPositionY()  )
    self.btn_add:setPosition(self.btn_add:getPositionX() + offset.x / 2, self.btn_info:getPositionY()  )



    -- self.spr_bg_51:setPosition(self.spr_bg_51:getPositionX() + offset.x / 2, self.spr_bg_51:getPositionY() )

    -- self.spr_bg_52:setPosition(self.spr_bg_52:getPositionX() + offset.x / 2, self.spr_bg_52:getPositionY() )
    
    

    self.msg_panel:setPosition(self.msg_panel:getPositionX() + offset.x / 2, self.msg_panel:getPositionY() )
    --self.spr_bg_2:setContentSize(self.spr_bg_2:getContentSize().width + offset.x, self.spr_bg_2:getContentSize().height + offset.y)

    --self.spr_bg_50:setContentSize(self.spr_bg_50:getContentSize().width , 230)

    self.menu_1 = cpp.UIMenu:create()
    self.menu_1:setName("menu_1")
    :setPosition(cc.p(0, 0))

    --local hero1 = ex.Player.backpack_data:createWithData(0,0)
    --hero1:setPosition(0,0)
    self.hero_1_node:addChild(self.menu_1)
    --self.menu_1:addChild(hero1)
    --self.hero1:registerScriptTapHandler(handler(self, self.onClick))

    self.menu_2 = cpp.UIMenu:create()
    self.menu_2:setName("menu_2")
    :setPosition(cc.p(0, 0))
    
    --local hero2 = ex.Player.backpack_data:createWithData(0,0)
    --hero2:setPosition(0,0)
    self.hero_2_node:addChild(self.menu_2)
    --self.menu_2:addChild(hero2)
    --self.hero2:registerScriptTapHandler(handler(self, self.onClick))

    self.select_hero = UIItemHero:createWithData(0, 0, 0, 0)
    self.select_hero:setPosition(0,0)
    
    local menu = cpp.UIMenu:create()
    menu:setName("menu")
    :setPosition(cc.p(0, 0))
    self.hero_select_node:addChild(menu)
    menu:addChild(self.select_hero)
    self.select_hero:registerScriptTapHandler(handler(self,self.onClickHero))

    -- 加一个加号
    self.spr_add_image = cc.Sprite:createWithSpriteFrameName("other/spr-add-1.png")
    :setScale(1)
    :setPosition(0,0)
    self.hero_select_node:addChild(self.spr_add_image)
    self.spr_add_image:setVisible(true)

    self.lbl_money_refresh = require("src.comp.RichTextEx"):create()
	:setFontSize(20)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
    :setAnchorTextShadow(true)
    :setWrapMode(1)
    self.lbl_money_refresh:setPosition(0,0)
	self.show_msg:addChild(self.lbl_money_refresh)


	self.lbl_btn_refresh = require("src.comp.RichTextEx"):create()
	:setFontSize(20)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setAnchorTextShadow(true)
    :setWrapMode(1)
	self.btn_auto:addChild(self.lbl_btn_refresh)
	self.lbl_btn_refresh:setPosition(self.btn_auto:getContentSize().width * 0.5 ,self.btn_auto:getContentSize().height * 0.5)

    
    
	-- self.lbl_btn_refresh = require("src.comp.RichTextEx"):create()
	-- :setFontSize(20)
	-- :setFontFace(FONT_DEFAULT_NAME_BOLD)
    -- :setAnchorTextShadow(true)
    
    -- :setWrapMode(1)
	-- self.need_cost:addChild(self.lbl_btn_refresh)
	-- self.lbl_btn_refresh:setPosition(self.need_cost:getContentSize().width * 0.5 ,self.need_cost:getContentSize().height * 0.5)


    local str = ex.Tools:getLang(70501)
    self.lbl_money_refresh:setXmlTextLua(str)


    self.lbl_select_num:setString(ex.Player:getItemNum(901804))

    self:addEvent(EVENT.HERO_EVENT.HERO_REBORN, handler(self,self.ReshrefPanel))

    self:initDone( )
    self:initData()
end 

function AltarReirthLayer:onBtnInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42046), ex.Tools:getLang(42047))
end


function AltarReirthLayer:initData( )
    --local str_1 = string.format("<img src='backpack/%s.png' width='30' height='30' /> <outline color='#6e3418' size='2'> <font color='#00ff00'>  %s</font></outline> ",901804,0)
    local str_1 = string.format(ex.Tools:getLang(47158),901804,0)
    
    self.lbl_btn_refresh:setXmlTextLua(str_1)

    self.lbl_select_num:setString(ex.Player:getItemNum(901804))


    self.menu_1:removeAllChildren()
    self.menu_2:removeAllChildren()

    local hero1 = ex.Player.backpack_data:createWithData(0,0)
    hero1:setPosition(0,0)
    self.menu_1:addChild(hero1)
    --self.hero1:registerScriptTapHandler(handler(self, self.onClick))

    
    local hero2 = ex.Player.backpack_data:createWithData(0,0)
    hero2:setPosition(0,0)
    self.menu_2:addChild(hero2)
    --self.hero2:registerScriptTapHandler(handler(self, self.onClick))

end

function AltarReirthLayer:onClick(tag,pSender)

    print("pSender.item_type", pSender.item_type)

    if pSender.item_type == 0 then return end 

    ex.Tools:onClickItemInfo(pSender.item_type)
end



function AltarReirthLayer:onClickHero(tag,pSender)
   
    local num_arr = self:Split(cfg.system["hero_reborn_star"] , "_")

    local data = {}
    data.idx = 0
    data.num = 1
    data.type = 0 
    data.elem = 0
    data.star = tonumber(num_arr[1])
    data.max_star = tonumber(num_arr[2])
    data.occupation = 0
    if not self.select_hero_data then 
        data.selected_hero_ids = {}
    else 
        data.selected_hero_ids = {self.select_hero_data.hero_id}
    end 

    data.close_handle = handler(self, self.setSelectHeroList)

    require("src.layer.HeroXSelectCtrl"):instance():openWindow(data, true)


end

function AltarReirthLayer:setSelectHeroList( idx, selected)

    -- selected -- 选贼列表
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


function AltarReirthLayer:initDone( )
    
end


function AltarReirthLayer:Split(szFullString, szSeparator)  
    local nFindStartIndex = 1  
    local nSplitIndex = 1  
    local nSplitArray = {}  
    while true do  
        local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)  
        if not nFindLastIndex then  
            nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))  
            break  
        end  
        nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)  
        nFindStartIndex = nFindLastIndex + string.len(szSeparator)  
        nSplitIndex = nSplitIndex + 1  
    end  
    return nSplitArray  
end



function AltarReirthLayer:ReshrefSelectHero( )
   
    local config = nil
    -- 查找配置
    for k,v in pairs(cfg.heroreborn.heroreborn) do
        if self.select_hero_data.hero_type == v.hero and self.select_hero_data.star == v.star then 
            config = v
        end 
    end

    if not config then ex.MessageView:add(ex.Tools:getLang(47101) .. self.select_hero_data.hero_type) return  end 
    
    self.spr_add_image:setVisible(false)

    self.select_config = config
    -- self.hero1:onInit(config.reback_hero_chip[1].item_type, config.reback_hero_chip[1].item_num)
    -- self.hero1:initDone()

    -- self.hero2:onInit(config.reback_elem_chip[1].item_type, config.reback_elem_chip[1].item_num)
    -- self.hero2:initDone()

    
    self.menu_1:removeAllChildren()
    self.menu_2:removeAllChildren()

    local hero1 = ex.Player.backpack_data:createWithData(config.reback_hero_chip[1].item_type, config.reback_hero_chip[1].item_num)
    hero1:setPosition(0,0)
    self.menu_1:addChild(hero1)
    hero1:registerScriptTapHandler(handler(self, self.onClick))

    local hero2 = ex.Player.backpack_data:createWithData(config.reback_elem_chip[1].item_type, config.reback_elem_chip[1].item_num)
    hero2:setPosition(0,0)
    self.menu_2:addChild(hero2)
    hero2:registerScriptTapHandler(handler(self, self.onClick))

    
    local hero_data = {}
    hero_data.hero_id = self.select_hero_data.hero_id
    hero_data.level = self.select_hero_data.level
    hero_data.star = self.select_hero_data.star
    hero_data.hero_type = self.select_hero_data.hero_type
    hero_data.elem = self.select_hero_data.elem
    self.select_hero:reset(hero_data)

    -- 刷新金币数据
    local str = string.format(ex.Tools:getLang(47400),config.cost[1].item_type,config.cost[1].item_num)
    self.lbl_btn_refresh:setXmlTextLua(str)

end


function AltarReirthLayer:onAdd( tag, pSender)
    ex.MainSceneCtr:instance():changeLayer(MainSceneType.MAINCITY_LAYER)

    --ex.JumpManager:jumpByAtomFireEvent(self.data.jump_info.event_arg)
    -- local return_data = cfg.system["hero_reborn_atom"]
    -- local flag = ex.JumpManager:jumpByAtom(return_data.event_arg)
    -- if flag == true then 
    --     local vec_idx = ex.Player.promotion_data:getPromotionByType(RechargeKindType.PROMOTION)
    --     ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.DAILY_INIT, vec_idx, return_data.type)
    -- end 


    local return_data = cfg.system["hero_reborn_atom"]

    cfg.funcopen[return_data.event_arg].open({select_idx = return_data.type})

end

function AltarReirthLayer:onBtnAuto( tag, pSender)
    
    if not self.select_config then 
        self:onClickHero()
        return 
    end 

    -- 判断消耗
    local num = ex.Player:getItemNum(self.select_config.cost[1].item_type)
    if num < self.select_config.cost[1].item_num then
        ex.Tools:showEnoughTip(self.select_config.cost[1].item_type)
        return
    end

    local req = Hero_pb.GReqHeroReborn()
    req.hero_id = self.select_hero_data.hero_id
    NetManager:sendMessage(ProtocolID.GReqHeroReborn, req)

    -- self:ReshrefPanel()
end

function AltarReirthLayer:ReshrefPanel( )
    
    self.select_config = nil
    -- self.hero1:removeItemData()

    -- self.hero2:removeItemData()

    
    local hero_data = {}
    hero_data.level = 0
    hero_data.star = 0
    hero_data.hero_type = 0
    hero_data.elem = 0
    self.select_hero:reset(hero_data)

    self.select_hero_data = nil
    self.spr_add_image:setVisible(true)

    self:initData()

end


return AltarReirthLayer



