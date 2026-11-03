local HeroListLayer = class("HeroListLayer", require("src.comp.EventLayer"))

local HeroListLayerType = {}
HeroListLayerType.HERO = 1
HeroListLayerType.ILLUSTRAT = 2
HeroListLayerType.DRAGON = 3

function HeroListLayer:getAsynImage()
    local vec_image = {
		{image_name = "ccbi-res/map-bg-role-1.jpg", remove_type=1},
    }
    return vec_image
end

function HeroListLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    
    local spr_bg = cc.Sprite:create("ccbi-res/map-bg-role-1.jpg")
    spr_bg:setScale(ex.p.width / spr_bg:getContentSize().width, ex.p.height / spr_bg:getContentSize().height)
    spr_bg:setPosition(ex.p.center().x - self:getPositionX(), ex.p.center().y - self:getPositionY() - 20)
    self:addChild(spr_bg, -1)

    self.btn_hero:setTag(HeroListLayerType.HERO)
    self.btn_illustrat:setTag(HeroListLayerType.ILLUSTRAT)
    self.btn_dragon:setTag(HeroListLayerType.DRAGON)
    self.btn_hero:setLabelOffset(cc.p(0, -3))
    self.btn_illustrat:setLabelOffset(cc.p(0, -3))
    self.btn_dragon:setLabelOffset(cc.p(0, -3))

    self.btn_hero:setLabelText(ex.Tools:getLang(47460))
    self.btn_illustrat:setLabelText(ex.Tools:getLang(47423))
    self.btn_dragon:setLabelText(ex.Tools:getLang(74503))

    self.btn_astrolabe:setScale(math.min(1, ex.s.global_scale * 0.9))
    self.btn_lineup:setScale(math.min(1, ex.s.global_scale * 0.9))

    self.btn_hero:registerScriptTapHandler(handler(self, self.onHero))
    self.btn_illustrat:registerScriptTapHandler(handler(self, self.onIllustrat))
    self.btn_dragon:registerScriptTapHandler(handler(self, self.onDragon))
    self.btn_astrolabe:registerScriptTapHandler(handler(self, self.onAstrolabe))

    self:addRedDotNode(RedDotType.ZCJ_DHYX_XP, self.btn_astrolabe)

    local isOpen = ex.JumpManager:checkOpenConditionByAtomNoMsg("hero_astrolabe")
    self.btn_astrolabe:setVisible(isOpen)

    ex.Tools:addRedPoint(self.btn_lineup, ex.Player.fetter_data:checkFetterRed(), cc.p(0.9, 0.9))

    -- 气泡提示相关
    self.btn_go:setContentSize(cc.size(50, 50))
    local spine_girl = sp.SkeletonAnimation:create("spine/act.json", "spine/act.atlas", 1)
    spine_girl:setAnimation(0, "act", true)
    spine_girl:setScale(0.6)
    spine_girl:setPosition(180, self.node_title:getPositionY() - 160)
    self.spr_bg:addChild(spine_girl, -1)

    self.lbl_content = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(22)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#5A3509")
	:setAnchorTextShadow(true)
	:ignoreContentAdaptWithSize(false)
	:setWrapMode(1)
	:setContentSize(cc.size(self.spr_bubble_bg:getContentSize().width - 30, 0))
	:setPosition(cc.p(self.spr_bubble_bg:getPositionX() + 20, self.spr_bubble_bg:getPositionY() + 65))
	:setAnchorPoint(cc.p(0, 0))
    self.spr_bubble_bg:getParent():addChild(self.lbl_content)

    -- 初始化子层
    self.layer_hero = require("src.layer.herolist.HeroListHeroLayer"):createWithCCBIFile("ccbi/HeroListHeroLayer.ccbi")
	self.layer_hero:setPosition(self:getContentSize().width / 2 - self.layer_hero:getContentSize().width / 2, 0)
    self:addChild(self.layer_hero)
    
    self.layer_dragon = require("src.layer.herolist.HeroListDragonLayer"):createWithCCBIFile("ccbi/HeroListDragonLayer.ccbi")
	self.layer_dragon:setPosition(self:getContentSize().width / 2 - self.layer_dragon:getContentSize().width / 2, 0)
    self:addChild(self.layer_dragon)

    -- 初始相关数据
    self.cur_layer_type = HeroListLayerType.HERO

    self:initDone()
    
    ex.RedDotManager:setStickNode(RedDotType.ZCJ_DHYX_YXT, self.btn_hero)
    ex.RedDotManager:setStickNode(RedDotType.ZCJ_DHYX_TJT, self.btn_illustrat)
    ex.RedDotManager:setStickNode(RedDotType.ZCJ_DHYX_SL, self.btn_dragon)
    
    self:addEvent(EVENT.HERO_EVENT.UP_BATTLE_RED_POINT,handler(self,self.updateBattleTeam))
    self:addEvent(EVENT.HERO_EVENT.UPDATE_FETTER_RED,handler(self,self.updateFetterRed))

    self:updateBubble(true)
    self:addTimer("timer", 1000, handler(self, self.updateTimer), true)
end

function HeroListLayer:getLayerOffset()
    return cc.p(0, -require("src.model.Game"):instance():getNotchHeight())
end

function HeroListLayer:updateFetterRed(event,data)
    ex.Tools:addRedPoint(self.btn_lineup, ex.Player.fetter_data:checkFetterRed(), cc.p(0.9, 0.9))
  --  ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_YXBZ, ex.Player.fetter_data:checkFetterContractInfo())
end 

function HeroListLayer:updateBattleTeam(event,data)
    if self.cur_layer_tab ~= HeroListLayerType.HERO then return end

    local data = ex.Player.hero_data:getHeroByElem(self.layer_hero.cur_hero_elem)
    self.layer_hero:updateTableView(data)
end

function HeroListLayer:onExit()
    ex.RedDotManager:removeStickNode(RedDotType.ZCJ_DHYX_YXT, self.btn_hero)
    ex.Player.hero_data:setCurIllustratCfg(nil)
end

function HeroListLayer:initDone()
    -- local is_visible = ex.JumpManager:checkOpenConditionByAtomNoMsg("main_dragon")
    -- self.btn_dragon:setVisible(is_visible)

    self:changeLayer(HeroListLayerType.HERO)
end

function HeroListLayer:changeLayer(tab)
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

function HeroListLayer:onHero(tag, pSender)
    if self.cur_layer_tab == HeroListLayerType.HERO then
        return
    end
    --当切换到英雄层时回到初始状态
    ex.Player.hero_data.btn_elem_state = 0

    self:changeLayer(HeroListLayerType.HERO)
end

function HeroListLayer:onIllustrat(tag, pSender)
    if self.cur_layer_tab == HeroListLayerType.ILLUSTRAT then
        return
    end
     --当切换到英雄图鉴层时回到初始状态
    ex.Player.hero_data.btn_elem_state = 1
    self:changeLayer(HeroListLayerType.ILLUSTRAT)
end

function HeroListLayer:onDragon(tag, pSender)
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

function HeroListLayer:onLineUp()
    require("src.layer.HeroSelectCtr"):instance():openWindow(ex.Tools:getLang(47546),
                                                             ex.Tools:getLang(47396),
                                                             BattleType.CHAPTER,
                                                             handler(self, self.onLineUpDone))
end

function HeroListLayer:onLineUpDone(vec_hero, fetter_type)

end

function HeroListLayer:updateTimer()
    -- 没到更新时间
    local now_time = ex.Game:getServerTime()
    if now_time - ex.Player.hero_data.hero_bag_tip_time < ex.Tools:getSysCfg("hero_bag_tip_time") then
        return
    end

    ex.Player.hero_data.hero_bag_tip_time = now_time
    self:updateBubble(false)
end

-- 更新气泡文本
function HeroListLayer:updateBubble(is_init)

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

function HeroListLayer:onGo(tag, pSender)
    ex.JumpManager:jumpByAtom(self.btn_go.atom)
end

function HeroListLayer:onAstrolabe(tag, pSender)
    ex.JumpManager:jumpByAtom("hero_astrolabe")
end

return HeroListLayer
