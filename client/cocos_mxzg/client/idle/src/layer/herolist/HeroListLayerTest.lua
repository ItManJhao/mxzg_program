local HeroListTest = class("HeroListTest", require("src.layer.ui.UI_HeroListLayer"))

local HeroListLayerType = {}
HeroListLayerType.HERO = 1
HeroListLayerType.ILLUSTRAT = 2
HeroListLayerType.DRAGON = 3


function HeroListTest:getAsynImage()
    -- dump(cc.Director:getInstance():getTextureCache():getCachedTextureInfo())
    local vec_image = {
        {image_name = "ccbi-res/dragon-relic.pvr.ccz", plist_name = "ccbi-res/dragon-relic.plist", remove_type=2},
        {image_name = "ccbi-res/dragon.pvr.ccz", plist_name = "ccbi-res/dragon.plist", remove_type=2},
        {image_name = "ccbi-res/skill-icon.pvr.ccz", plist_name = "ccbi-res/skill-icon.plist", remove_type=2},
    }
    return vec_image
end

function HeroListTest:onCreate()
    self.super.onCreate(self)
	self:setName("HeroListTest")

    local bottom_height = ex.MainSceneCtr:getBottomHeight()
    local top_height = ex.MainSceneCtr:getTopHeight();
    local girl_height = 140
  
    self.layer_hero = require("src.layer.herolist.HeroListHeroLayerTest"):create()
    self.layer_hero:setPosition(cc.p(0, 0))
    self:addChild(self.layer_hero)  
    self.layer_hero.lyt:setTopMargin(0)

    self.lyt:setBottomMargin(bottom_height)
    -- 保证界面最小高度为540
    local top_margin = math.min(top_height + girl_height, ex.p.height - bottom_height - 850)
    self.lyt:setTopMargin(top_margin)
    
    -- math.min(ex.p.height - bottom_height - top_height, top_height + girl_height)
    self.btn_hero:setTag(HeroListLayerType.HERO)
    self.btn_illustrat:setTag(HeroListLayerType.ILLUSTRAT)
    self.btn_dragon:setTag(HeroListLayerType.DRAGON)

    self.btn_astrolabe:setScale(math.min(0.8, ex.s.global_scale * 0.9))
    self.btn_lineup:setScale(math.min(0.8, ex.s.global_scale * 0.9))

    self.btn_go:setContentSize(cc.size(50, 50))
    ex.EffectFactory:createEffectWithSpineByNameAsyn("spine/act", function(spine)
        spine:setAnimation(0, "act", true)
        spine:setScale(0.6)
    end, self.spr_bg, cc.p(180, self.node_title:getPositionY() + 30), -1)

    -- 耗时0.04
    self.layer_dragon = require("src.layer.herolist.HeroListDragonLayerTest"):create()
    self.layer_dragon:setPosition(self:getContentSize().width / 2 - self.layer_dragon:getContentSize().width / 2, 0)
    self:addChild(self.layer_dragon)

    -- 初始相关数据
    self.cur_layer_type = HeroListLayerType.HERO

    ex.RedDotManager:setStickNode(RedDotType.ZCJ_DHYX_YXT, self.btn_hero)
    ex.RedDotManager:setStickNode(RedDotType.ZCJ_DHYX_TJT, self.btn_illustrat)
    ex.RedDotManager:setStickNode(RedDotType.ZCJ_DHYX_SL, self.btn_dragon)

    self:addEvent(EVENT.HERO_EVENT.UP_BATTLE_RED_POINT,handler(self,self.updateBattleTeam))
    self:addEvent(EVENT.HERO_EVENT.UPDATE_FETTER_RED,handler(self,self.updateFetterRed))

    self:updateBubble(true) -- 耗时 0.02
    self:addTimer("timer", 1000, handler(self, self.updateTimer), true)
end

function HeroListTest:onEnterFinish()
    self:changeLayer(HeroListLayerType.HERO)
end

function HeroListTest:allResLoadDone()
end


function HeroListTest:getLayerOffset()
    return cc.p(0, -require("src.model.Game"):instance():getNotchHeight())
end

function HeroListTest:updateFetterRed(event,data)
    ex.Tools:addRedPoint(self.btn_lineup, ex.Player.fetter_data:checkFetterRed(), cc.p(0.9, 0.9))
  --  ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_YXBZ, ex.Player.fetter_data:checkFetterContractInfo())
end 

function HeroListTest:updateBattleTeam(event,data)
    if self.cur_layer_tab ~= HeroListLayerType.HERO then return end

    local data = ex.Player.hero_data:getHeroByElem(self.layer_hero.cur_hero_elem)
    self.layer_hero:updateTableView(data)
end

function HeroListTest:onExit()
    ex.RedDotManager:removeStickNode(RedDotType.ZCJ_DHYX_YXT, self.btn_hero)
    ex.Player.hero_data:setCurIllustratCfg(nil)
end

function HeroListTest:changeLayer(tab)
    self.btn_hero:setChecked(tab == HeroListLayerType.HERO)
    self.btn_illustrat:setChecked(tab == HeroListLayerType.ILLUSTRAT)
    self.btn_dragon:setChecked(tab == HeroListLayerType.DRAGON)
    if self.cur_layer_tab == tab then
        return
    end

    self.cur_layer_tab = tab

    self.layer_hero:setVisible(self.cur_layer_tab == HeroListLayerType.HERO or self.cur_layer_tab == HeroListLayerType.ILLUSTRAT)
    self:reorderChild(self.layer_hero, self.layer_hero:isVisible() and 1000 or 1)
    self.layer_dragon:setVisible(self.cur_layer_tab == HeroListLayerType.DRAGON)
    self:reorderChild(self.layer_dragon, self.layer_dragon:isVisible() and 1000 or 1)

    if self.cur_layer_tab == HeroListLayerType.HERO or self.cur_layer_tab == HeroListLayerType.ILLUSTRAT then
        self.layer_hero:changeLayer(self.cur_layer_tab)
    elseif self.cur_layer_tab == HeroListLayerType.DRAGON then
        self.layer_dragon:changeLayer(10)
    end
end

function HeroListTest:onHero(tag, pSender)
    if self.cur_layer_tab == HeroListLayerType.HERO then
        return
    end
    --当切换到英雄层时回到初始状态
    ex.Player.hero_data.btn_elem_state = 0

    self:changeLayer(HeroListLayerType.HERO)
end

function HeroListTest:onIllustrat(tag, pSender)
    if self.cur_layer_tab == HeroListLayerType.ILLUSTRAT then
        return
    end
     --当切换到英雄图鉴层时回到初始状态
    ex.Player.hero_data.btn_elem_state = 1
    self:changeLayer(HeroListLayerType.ILLUSTRAT)
end

function HeroListTest:onDragon(tag, pSender)
    local is_visible = ex.JumpManager:checkOpenConditionByAtom("main_dragon")
    if not is_visible then
        self:changeLayer(self.cur_layer_type)
        return
    end

    if self.cur_layer_tab == HeroListLayerType.DRAGON then
        return
    end
    
    self:changeLayer(HeroListLayerType.DRAGON)
end

function HeroListTest:onLineUp()
    require("src.layer.HeroSelectCtr"):instance():openWindow(ex.Tools:getLang(47546),
                                                             ex.Tools:getLang(47396),
                                                             BattleType.CHAPTER,
                                                             handler(self, self.onLineUpDone))
end

function HeroListTest:onLineUpDone(vec_hero, fetter_type)

end

function HeroListTest:updateTimer()
    -- 没到更新时间
    local now_time = ex.Game:getServerTime()
    if now_time - ex.Player.hero_data.hero_bag_tip_time < ex.Tools:getSysCfg("hero_bag_tip_time") then
        return
    end

    ex.Player.hero_data.hero_bag_tip_time = now_time
    -- self:updateBubble(false)
end

-- 更新气泡文本
function HeroListTest:updateBubble(is_init)

    local text = ""
    local atom = ""

    local now_index = ex.Player.hero_data.hero_bag_tip
    local tab_num = table.nums(cfg.herobagjump.herobagjump)
    local config = nil

    local checkJump = function(index)
        local tmp_config = cfg.herobagjump.herobagjump[index]
        local is_open = false

        if tmp_config --[[and ex.JumpManager:checkAtomChildIsOpen(tmp_config.atom)]] then
            return tmp_config
        end

        return nil
    end


    if is_init then
        config = checkJump(now_index)
    end

    if config == nil then
            -- 循环取出下一个显示的配置
        for i=1,tab_num do
            local index = ((now_index - 1 + i) % tab_num + 1)
            config = checkJump(index)
            if config then
                break
            end
        end
    end
    
    self.spr_bubble_bg:getParent():setVisible(config ~= nil)
    if config == nil then
        return
    end

    ex.Player.hero_data.hero_bag_tip = config.idx

    -- 更新显示
    self.btn_go.atom = config.atom
    self.lbl_content:setXmlTextLua(ex.Tools:getLang(config.lang))
    self.lbl_content:formatText()
    self.spr_bubble_bg:setContentSize(cc.size(self.spr_bubble_bg:getContentSize().width, self.lbl_content:getContentSize().height + 80))
    -- self.lbl_go_under
    self.lbl_go:setString(ex.Tools:getLang(config.go_lang))
    self.lbl_go_under:setScaleX(self.lbl_go:getContentSize().width / self.lbl_go_under:getContentSize().width)
    
end

function HeroListTest:onGo(tag, pSender)
    ex.JumpManager:jumpByAtom(self.btn_go.atom)
end

function HeroListTest:onAstrolabe(tag, pSender)
    ex.JumpManager:jumpByAtom("hero_astrolabe")
end

return HeroListTest
