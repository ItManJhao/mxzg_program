local HeroListItemCell = class("HeroListItemCell", require("src.comp.LuaLayerBase"))

local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero") -- require("src.comp.menu.UIMenuItemHero")


HeroListItemCell.hero_type =
{
    HERO_BAG = 1,   -- 英雄背包
    HERO_IMAGE = 2,-- 英雄图鉴
    HERO_BATTLE = 3,-- 战斗选英雄
    HERO_CHOOSE = 4,-- 酒馆
    HERO_ALTER = 5,-- 英雄祭坛
}

function HeroListItemCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    
    self.items = {}

    if not self.menu_item then 
        local menu = cpp.UIMenu:create()
        self:addChild(menu)
        menu:setPosition(0,0)
        self.menu_item = menu
    end 
end

function HeroListItemCell:reset(data)

    if not data then return end

    self.hero_data = data
    self:updateItem()
end


function HeroListItemCell:setTableView(table)
    self.tableView = table
    self.menu_item:setIsTouchInsideNode(self.tableView)
    self.menu_item:setSwallowsTouches(false)
end

function HeroListItemCell:updateItem()
    
    local begin = -20
    local margin = 30
    local posY = 0
    local scale = 1

    self.menu_item:removeAllChildren()

    local config = cfg.herotype.star

    for k,hero_data in pairs(self.hero_data) do
        local v = hero_data.heroData
        if hero_data.type == HeroListItemCell.hero_type.HERO_BAG then 
            if v then 
                local item = UIMenuItemHero:createWithData(v.hero_id, v.hero_type, v.elem, v.level, v.star)
                local posX = (begin + item:getContentSize().width * scale) + (k - 1) * ((item:getContentSize().width * scale) + margin)
                -- local redPoint = (ex.Player.hero_data.promote:heroIsBattle(v.hero_id) and ex.Player.hero_data.promote:getHeroUpStarRedPoint(v.hero_id)) or (ex.Player.hero_data.promote:heroIsBattle(v.hero_id) and ex.Player.hero_data.promote:getHeroUp(v.hero_id)) or (ex.Player.hero_data.promote:heroIsBattle(v.hero_id) and ex.Player.hero_data.promote:getHeroCanUpgrade(v.hero_id))
                -- redPoint = redPoint or (ex.Player.hero_data.promote:heroIsBattle(v.hero_id) and ex.Player.hero_data.equip:checkBattleHeroEquip(v.hero_id))
                local redPoint = ex.Player.hero_data.promote:heroIsBattle(v.hero_id)
                if redPoint == true then 
                    redPoint = ex.Player.hero_data.promote:getHeroUpStarRedPoint(v.hero_id) or ex.Player.hero_data.promote:getHeroUp(v.hero_id) or ex.Player.hero_data.promote:getHeroCanUpgrade(v.hero_id) or ex.Player.hero_data.equip:checkBattleHeroEquip(v.hero_id)
                    -- print(self.__cname,"id",v.hero_id,"star" , ex.Player.hero_data.promote:getHeroUpStarRedPoint(v.hero_id) , "level", ex.Player.hero_data.promote:getHeroUp(v.hero_id), "grade" , (ex.Player.hero_data.promote:getHeroCanUpgrade(v.hero_id)) , "equip" , ex.Player.hero_data.equip:checkBattleHeroEquip(v.hero_id))
                end
                -- print("redpoint", redPoint)
                item:setRedPoint(redPoint)
                item:setPosition(posX, item:getContentSize().height* 0.5)
                :registerScriptTapHandler(handler(self, self.onShowHeroInfo))
                item:isBattle(ex.Player.hero_data.promote:heroIsBattle(v.hero_id))
                self.menu_item:add(item)
            else 
                local item = UIMenuItemHero:createWithData(0, 0, 0, 0)
                local posX = (begin + item:getContentSize().width * scale ) + (k - 1) * ((item:getContentSize().width * scale) + margin)
                item:setPosition(posX, item:getContentSize().height * 0.5)
                :setEnabled(false)
                self.menu_item:add(item)
            end
        elseif hero_data.type == HeroListItemCell.hero_type.HERO_IMAGE then 
            local elem = config[v.type].elem
            local level = cfg.herostar.star[v.star].level_limit
            local item = UIMenuItemHero:createWithData(NULL_ID, v.type, elem, level, v.star)
            local posX = (begin + item:getContentSize().width * scale ) + (k - 1) * ((item:getContentSize().width * scale) + margin)
            item:setPosition(posX, item:getContentSize().height * 0.5)
            if v.unlock == false then item:setGrayed("") end  
            item:registerScriptTapHandler(handler(self, self.onShowHeroIllustratInfo))
            self.menu_item:add(item)

            local tag = -1
            local illustraData = ex.Player.hero_data:getCurIllustraCfg()
            for ik,idata in pairs(illustraData) do

                if idata.type == v.type and idata.star == v.star then 
                    tag = ik 
                    break
                end 
            end
            item:setTag(tag)
            
        elseif hero_data.type == HeroListItemCell.hero_type.HERO_BATTLE then 

            local item = UIMenuItemHero:createWithData(v.hero_id, v.hero_type, v.elem, v.level, v.star)
            local posX = (begin + item:getContentSize().width * scale ) + (k - 1) * ((item:getContentSize().width * scale) + margin)
            item:setPosition(posX, item:getContentSize().height * 0.5)
            :registerScriptTapHandler(handler(self, self.onBackpackIcon))
            self.menu_item:add(item)
            
            item:setSelected(hero_data.setSelected)

        elseif hero_data.type == HeroListItemCell.hero_type.HERO_CHOOSE then 


            local item = UIMenuItemHero:createWithData(v.hero_id, v.hero_type, v.elem, v.level, v.star)
            local posX = (begin + item:getContentSize().width * scale ) + (k - 1) * ((item:getContentSize().width * scale) + margin)
            item:setPosition(posX, item:getContentSize().height * 0.5)
            :registerScriptTapHandler(handler(self, self.onClickHeroView))

            item:showOccupation() -- 显示元素
            self.menu_item:add(item)
            
            item:setSelected(hero_data.setSelected)

            if hero_data.setTaskIng then 
                
                item:setTasking()
            end 


        elseif hero_data.type == HeroListItemCell.hero_type.HERO_ALTER then 
            local item = UIMenuItemHero:createWithData(v.hero_id, v.hero_type, v.elem, v.level, v.star)
            local posX = (begin + item:getContentSize().width * scale ) + (k - 1) * ((item:getContentSize().width * scale) + margin)
            item:setPosition(posX, item:getContentSize().height * 0.5)
            :registerScriptTapHandler(handler(self, self.onSelectHero))
            self.menu_item:addChild(item)
         
            if hero_data.setBattle then 
                item:setBattling()
            end 

            item:setSelected(hero_data.selected)
        end 
    end
end

function HeroListItemCell:onSelectHero(tag,pSender)

    if pSender then 
        ex.EventManager:fire(EVENT.HERO_EVENT.SELECT_HERO,pSender)
    end
end


function HeroListItemCell:onClickHeroView(tag,pSender)

    if pSender then 
        ex.EventManager:fire(EVENT.HERO_EVENT.CHANGE_HERO_TASK,pSender)
    end
end


function HeroListItemCell:onBackpackIcon(tag,pSender)
    if pSender then 
        ex.EventManager:fire(EVENT.HERO_EVENT.CHANGE_HERO_POSITION,pSender)
    end 
end

function HeroListItemCell:onShowHeroIllustratInfo(tag,pSender)
    ex.Player.hero_data:setIllustratIdx(tag)
    ex.Player.hero_data:setOpenTab(2)
    ex.MainSceneCtr:changeLayer(MainSceneType.HERO_ILLUSTRAT_INFO_LAYER)
end


function HeroListItemCell:onShowHeroInfo(tag, pSender)
    local heroId = pSender:getHeroId()
    ex.Player.hero_data.promote:setSelectHero(heroId)
    ex.MainSceneCtr:changeLayer(MainSceneType.HERO_INFO_LAYER)
end

return HeroListItemCell




