local ProphetTreeLayer = class("ProphetTreeLayer", require("src.comp.EventLayer"))
local ProphetTreeChangeCell = class("ProphetTreeChangeCell", require("src.comp.LuaLayerBase"))

local HeroAnim = require("src.person.Hero")
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

local function setBtnNode(node, color, outline_size, outline_color, name, value, icon_type)
    local btn_size = node:getContentSize()
    btn_size.width = btn_size.width / 2
    btn_size.height = btn_size.height / 2

    -- 按钮文字
    -- local lbl_btn_txt= cc.Label:createWithTTF(name, FONT_DEFAULT_NAME_BOLD, 48)
    -- lbl_btn_txt:setScale(0.5)
    -- lbl_btn_txt:setTextColor(color)
    -- lbl_btn_txt:enableOutline(outline_color, outline_size * 2)
    -- lbl_btn_txt:setPosition(btn_size.width + 30, btn_size.height)
    -- node:addChild(lbl_btn_txt)

    local lbl_value = cc.Label:createWithTTF(tostring(value).." "..name, FONT_DEFAULT_NAME_BOLD, 48) -- 20
    lbl_value:setAnchorPoint(0, 0.5)
    lbl_value:setScale(0.5)
    lbl_value:setTextColor(color)
    lbl_value:setName("lbl_value")
    lbl_value:enableOutline(outline_color, outline_size * 2)
    lbl_value:setPosition(btn_size.width - 25, btn_size.height)
    node:addChild(lbl_value)

    local spr_icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", icon_type))
    spr_icon:setScale(0.4)
    spr_icon:setPosition(btn_size.width - 45, btn_size.height)
    node:addChild(spr_icon)
end

local ChangeType = {}
ChangeType.begin = 0
ChangeType.change = 1
ChangeType.confirm = 2

function ProphetTreeChangeCell:onCreate()
    --ex.log("ProphetTreeChangeCell:onCreate")
    self:setAutoClose(false)

    self.spr_light_left:setLocalZOrder(20)
    self.spr_light_right:setLocalZOrder(20)

    self.spr_light_left:setVisible(false)
    self.spr_light_right:setVisible(false)

    self.spine_effect_left_1 = sp.SkeletonAnimation:create("spine/prophet-tree-effect-1.json","spine/prophet-tree-effect-1.atlas", 1)
    self.spine_effect_left_1:setAnimation(0, "stand", true)
    self.spine_effect_left_1:setPosition(self.spr_light_bottom_left:getPositionX(), self.spr_light_bottom_left:getPositionY() + 15)
    self:addChild(self.spine_effect_left_1, 20)

    self.spine_effect_left_2 = sp.SkeletonAnimation:create("spine/prophet-tree-effect-2.json","spine/prophet-tree-effect-2.atlas", 1)
    self.spine_effect_left_2:setAnimation(0, "stand", true)
    self.spine_effect_left_2:setPosition(self.spr_light_bottom_left:getPositionX(), self.spr_light_bottom_left:getPositionY() + 15)
    self:addChild(self.spine_effect_left_2, 10)

    self.spine_effect_right_1 = sp.SkeletonAnimation:create("spine/prophet-tree-effect-1.json","spine/prophet-tree-effect-1.atlas", 1)
    self.spine_effect_right_1:setAnimation(0, "stand", true)
    self.spine_effect_right_1:setPosition(self.spr_light_bottom_right:getPositionX(), self.spr_light_bottom_right:getPositionY() + 15)
    self:addChild(self.spine_effect_right_1, 20)

    self.spine_effect_right_2 = sp.SkeletonAnimation:create("spine/prophet-tree-effect-2.json","spine/prophet-tree-effect-2.atlas", 1)
    self.spine_effect_right_2:setAnimation(0, "stand", true)
    self.spine_effect_right_2:setPosition(self.spr_light_bottom_right:getPositionX(), self.spr_light_bottom_right:getPositionY() + 15)
    self:addChild(self.spine_effect_right_2, 10)

    self:reorderChild(self.node_name_1, 30)
    self:reorderChild(self.node_name_2, 30)
    self.node_name_1:setVisible(false)
    self.node_name_2:setVisible(false)

    self.btn_change:getParent():setLocalZOrder(20)

    --self.btn_change:setLocalZOrder(20)
    --self.btn_confirm:setLocalZOrder(20)
    --self.btn_cancel:setLocalZOrder(20)
    
    local btn_size = self.btn_confirm:getContentSize()
    btn_size.width = btn_size.width / 2
    btn_size.height = btn_size.height / 2

    -- 按钮文字
    local lbl_btn_txt= cc.Label:createWithTTF(ex.Tools:getLang(2401), FONT_DEFAULT_NAME_BOLD, 20) -- 确定
    :setTextColor(FONT_BLACK)
    :setPosition(btn_size.width, btn_size.height)
    self.btn_confirm:addChild(lbl_btn_txt)

    lbl_btn_txt= cc.Label:createWithTTF(ex.Tools:getLang(2402), FONT_DEFAULT_NAME_BOLD, 20) -- 取消
    :setTextColor(FONT_BLACK)
    :setPosition(btn_size.width, btn_size.height)
    self.btn_cancel:addChild(lbl_btn_txt)

    self.btn_change:setVisible(false)
    self.btn_confirm:setVisible(false)
    self.btn_cancel:setVisible(false)

    self.cur_type = ChangeType.begin
    self.hero_left = nil
    self.hero_right = nil
end

function ProphetTreeChangeCell:onChangeCellContentSize(size)
    local last_content_size = self:getContentSize()
    local cur_content_size = size
    local offset = cc.p(cur_content_size.width - last_content_size.width, cur_content_size.height - last_content_size.height)

    self:setContentSize(cur_content_size)
    self:setPosition(ex.p.width / 2 - self:getContentSize().width / 2, ex.p.height / 2 - self:getContentSize().height / 2 + 50)

    self.spr_light_bottom_left:setPosition(self.spr_light_bottom_left:getPositionX() + offset.x / 2, self.spr_light_bottom_left:getPositionY() + offset.y)
    self.spr_light_bottom_right:setPosition(self.spr_light_bottom_right:getPositionX() + offset.x / 2, self.spr_light_bottom_right:getPositionY() + offset.y)
    self.spr_light_left:setPosition(self.spr_light_left:getPositionX() + offset.x / 2, self.spr_light_left:getPositionY() + offset.y)
    self.spr_light_right:setPosition(self.spr_light_right:getPositionX() + offset.x / 2, self.spr_light_right:getPositionY() + offset.y)

    self.spine_effect_left_1:setPosition(self.spr_light_bottom_left:getPositionX(), self.spr_light_bottom_left:getPositionY() + 15)
    self.spine_effect_left_2:setPosition(self.spr_light_bottom_left:getPositionX(), self.spr_light_bottom_left:getPositionY() + 15)
    self.spine_effect_right_1:setPosition(self.spr_light_bottom_right:getPositionX(), self.spr_light_bottom_right:getPositionY() + 15)
    self.spine_effect_right_2:setPosition(self.spr_light_bottom_right:getPositionX(), self.spr_light_bottom_right:getPositionY() + 15)

    self.node_name_1:setPosition(self.spr_light_bottom_left:getPositionX(), self.spr_light_bottom_left:getPositionY() + 175)
    self.node_name_2:setPosition(self.spr_light_bottom_right:getPositionX(), self.spr_light_bottom_right:getPositionY() + 175)

    self.btn_cancel:setPosition(self.btn_cancel:getPositionX() + offset.x / 2, self.btn_cancel:getPositionY() + offset.y)
    self.btn_confirm:setPosition(self.btn_confirm:getPositionX() + offset.x / 2, self.btn_confirm:getPositionY() + offset.y)
    self.btn_change:setPosition(self.btn_change:getPositionX() + offset.x / 2, self.btn_change:getPositionY() + offset.y)

    self.btn_elem0:setPosition(self.btn_elem0:getPositionX() + offset.x / 2, self.btn_elem0:getPositionY() + offset.y)
    self.btn_elem1:setPosition(self.btn_elem1:getPositionX() + offset.x / 2, self.btn_elem1:getPositionY() + offset.y)
    self.btn_elem2:setPosition(self.btn_elem2:getPositionX() + offset.x / 2, self.btn_elem2:getPositionY() + offset.y)
    self.btn_elem3:setPosition(self.btn_elem3:getPositionX() + offset.x / 2, self.btn_elem3:getPositionY() + offset.y)

    self.spr_hero_bg:setPosition(self.spr_hero_bg:getPositionX() + offset.x / 2, self.spr_hero_bg:getPositionY())
    -- self.scrollView:setPosition(self.scrollView:getPositionX() + offset.x / 2, self.scrollView:getPositionY())

    self.spr_hero_bg:setContentSize(self.spr_hero_bg:getContentSize().width, self.spr_hero_bg:getContentSize().height + offset.y)
    -- self.scrollView:setViewSize(cc.size(self.scrollView:getViewSize().width, self.scrollView:getViewSize().height + offset.y))

end

function ProphetTreeChangeCell:setBtnNode(item_num, item_type)
    setBtnNode(self.btn_change, FONT_WHITLE, 2, cc.c3b(31, 86, 167), ex.Tools:getLang(2403), item_num, item_type) -- 置换
end

function ProphetTreeChangeCell:getCurrentType()
    return self.cur_type
end

function ProphetTreeChangeCell:setCurrentType(cur_type)
    self.cur_type = cur_type

    self.btn_change:setVisible(cur_type == ChangeType.change)
    self.btn_confirm:setVisible(cur_type == ChangeType.confirm)
    self.btn_cancel:setVisible(cur_type == ChangeType.confirm)
end

function ProphetTreeChangeCell:setHeroLeft(hero_id, hero_type, level, star)
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
    
    -- 创建一个骨骼动画
    self.hero_left:setAnchorPoint(cc.p(0.5, 0))
    self.hero_left:setScale(1.42)
    self.hero_left:setPosition(self.spr_light_left:getPositionX(), self.spr_light_left:getPositionY() + 10)
    self:addChild(self.hero_left)
    self.hero_left:stopUpdateZOrder(15)
    self.hero_left:setShadowVisible(false)

    self.node_name_1:setVisible(true)
    self.lbl_hero_name_1:setString(ex.Tools:getLang(hero_type))

    local cost_item = ex.Tools:getSysCfg("prophecy_exchange_cost")
    if star == 4 then
        cost_item = ex.Tools:getSysCfg("prophecy_exchange_cost_4")
    end
    
    local label = self.btn_change:getChildByName("lbl_value")
    if label ~= nil then
        label:setString(tostring(cost_item[1].item_num).." "..ex.Tools:getLang(2403))
    end
end

function ProphetTreeChangeCell:setHeroRight(hero_type, level, star)
    self:removeHero(false, true)

    -- 创建一个骨骼动画
    local skin = ex.Tools:getHeroSkinByStar(hero_type, star)
    self.hero_right = HeroAnim:create("12323", "123213", hero_type, level, star, skin)
    self.hero_right:setAnchorPoint(cc.p(0.5, 0))
    self.hero_right:setScale(1.42)
    self.hero_right:setPosition(self.spr_light_right:getPositionX(), self.spr_light_right:getPositionY() + 10)
    self:addChild(self.hero_right)
    self.hero_right:stopUpdateZOrder(15)
    self.hero_right:setShadowVisible(false)

    self.node_name_2:setVisible(true)
    self.lbl_hero_name_2:setString(ex.Tools:getLang(hero_type))
end

function ProphetTreeChangeCell:removeHero(isLeft, isRight)
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


---------------------------------------------------------------------------------------------------


local LayerType = {}
LayerType.summon = 1
LayerType.change = 2

function ProphetTreeLayer:getAsynImage()
    local vec_image = {
        
    }
    return vec_image
end

function ProphetTreeLayer:onCreate()
	--ex.log("ProphetTreeLayer:onCreate")
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/prophet-tree.plist")
    sfc:addSpriteFrames("ccbi-res/prophet-tree-lang.plist")

	local bg_size = self.spr_bg:getContentSize()
	self.spr_bg:setScaleX(ex.p.width / bg_size.width)
    self.spr_bg:setScaleY(ex.p.height / bg_size.height)  
    
    if ex.p.width < 640 then
        self.node_tab:setScale(ex.p.width / 640)  
        self.spr_tips:setScale(ex.p.width / 640)  
    end

    local notch_height = require("src.model.Game"):instance():getNotchHeight()
    self.btn_back:setPositionY(self.btn_back:getPositionY() - notch_height + 10)

    self.btn_info:setPosition(self.btn_back:getPositionX() + self.btn_back:getContentSize().width / 2 - self.btn_info:getContentSize().width / 2, 
                              self.btn_back:getPositionY() - 60)
    self.btn_shop:setPosition(self.btn_back:getPositionX() + self.btn_back:getContentSize().width / 2 - self.btn_shop:getContentSize().width / 2, 
                              self.btn_back:getPositionY() - 130)
    self.btn_chip:setPosition(self.btn_back:getPositionX() + self.btn_back:getContentSize().width / 2 - self.btn_chip:getContentSize().width / 2, 
                              self.btn_back:getPositionY() - 210)

    self.node_res:setPositionY(self.btn_back:getPositionY() + 15)
    self.node_tab:setPositionY(self.btn_back:getPositionY() - 30)

	self.btn_tab_summon:setLabelText(ex.Tools:getLang(2404)) -- 先祖召唤
    -- self.btn_tab_summon:setLabelColor(ex.c3b.WHITE)
    -- self.btn_tab_summon:getLabel():enableOutline(FONT_BROWN, 2)
    self.btn_tab_summon:setTag(LayerType.summon)
    self.btn_tab_summon:registerScriptTapHandler(handler(self, self.onBtnChangeLayer))

    self.btn_tab_change:setLabelText(ex.Tools:getLang(2405)) -- 英雄置换
    -- self.btn_tab_change:setLabelColor(ex.c3b.WHITE)
    -- self.btn_tab_change:getLabel():enableOutline(FONT_BROWN, 2)
    self.btn_tab_change:setTag(LayerType.change)
    self.btn_tab_change:registerScriptTapHandler(handler(self, self.onBtnChangeLayer))
    self.btn_chip:registerScriptTapHandler(handler(self, self.onchipShop))
    self.btn_luck_question:registerScriptTapHandler(handler(self, self.onQuestionLuck))

    -- self.spr_tips:setVisible(false)
    self.spr_tips:setPosition(self.btn_tab_change:getParent():getParent():getPositionX(), self.btn_tab_change:getParent():getParent():getPositionY() - 120)
    
    self.cur_node = cc.Node:create()
    self:addChild(self.cur_node)

    self:initSwallowLayer()

    self:initDone()

    self:touchSwallowTouches(false)

    self:addEvent(EVENT.BACKPACK_RES_CHANGE.CHANGE_ITEM, handler(self, self.refreshRes))
    self:addEvent(EVENT.PROPHET.CHANGE_LUCK, handler(self, self.refreshLuck))

    self:addTimer("timer", 100, handler(self, self.update), true)
end

function ProphetTreeLayer:update(dt)
    if self.cur_layer_type ~= LayerType.summon then
        return
    end

    if self.round_layer == nil then
        return
    end

    local idx = self.round_layer:getSelectIndex()
    if self.round_idx_select == nil or self.round_idx_select ~= idx then
        self:refreshLuck(nil, idx + 1)
    end
    self.round_idx_select = idx
end

function ProphetTreeLayer:refreshRes()
    self.lbl_num_1:setString(tostring(ex.Player:getItemNum(ItemType.IT_PROPHET_BALL)))
    self.lbl_num_2:setString(tostring(ex.Player:getItemNum(ItemType.IT_PROPHET_PIECE)))
    self.lbl_num_3:setString(tostring(ex.Player:getItemNum(ItemType.IT_PROPHET_SHOP)))
end

-- 更新幸运值显示
function ProphetTreeLayer:refreshLuck(event, index)
    if self.progress_luck == nil then
        self.progress_luck = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("prophet-tree/progress.png"))
        :setType(cc.PROGRESS_TIMER_TYPE_BAR)
        :setMidpoint(cc.p(0, 0.5))
        :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
        :setScale(self.spr_progress_luck_bg:getScale())
        :setPosition(self.spr_progress_luck_bg:getPosition())
        self.node_luck:addChild(self.progress_luck, 10)

        self:reorderChild(self.lbl_luck, 20)
    end

    if self.spine_luck == nil then
        self.spine_luck = sp.SkeletonAnimation:create("spine/jindutiao.json","spine/jindutiao.atlas", 1)
        self.spine_luck:setAnimation(0, "stand", true)
        self.spine_luck:setPosition(0, 0)
        self.node_luck:addChild(self.spine_luck, 0, 10)
    end

    if index == nil then
        index = self.round_layer:getSelectIndex() + 1
    end

    local luck = 0
    for i,v in ipairs(ex.Player.prophet_data.vec_lucks) do
        if v.type == index then
            luck = v.lucky
        end
    end

    self.spine_luck:setVisible(luck >= tonumber(ex.Tools:getSysCfg("prophecy_lucky_effect")))
    
    local luck_max = cfg.prophecyguarantee.prophecyguarantee[index].guarantee_times
    self.progress_luck:setPercentage(luck * 100 / luck_max)

    self.lbl_luck:setString(""..luck.."/"..luck_max)
end

function ProphetTreeLayer:onchipShop(tag,pSender)
    cfg.funcopen.main_shop.open(SHOP_TYPE.FRAGMENT)
end

--触摸吞噬
function ProphetTreeLayer:initSwallowLayer()
    self.touch_layer = cc.Layer:create()
    self.touch_layer:setTouchEnabled(true)
    self.touch_layer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self.touch_layer:registerScriptTouchHandler(function(event)
        if event == "began" then
            return true
        end
    end)
    self:addChild(self.touch_layer, 100)
end

function ProphetTreeLayer:touchSwallowTouches(is_lock)
    self.touch_layer:setSwallowsTouches(is_lock)
end

function ProphetTreeLayer:initDone()
    self.cur_layer_type = 0

    self.cur_cost = {}
    self.cur_cost.item_type = 0
    self.cur_cost.item_num = 0

    self:changeLayer(LayerType.summon)
end

function ProphetTreeLayer:changeLayer(layer_type)
	self.btn_tab_summon:setChecked(LayerType.summon == layer_type)
    self.btn_tab_change:setChecked(LayerType.change == layer_type)
    self.spr_tips:setVisible(LayerType.summon == layer_type)

    self.btn_tab_summon:setLabelColor(LayerType.common == layer_type and ex.c3b.TAB_SLT or ex.c3b.TAB_USLT)
    self.btn_tab_change:setLabelColor(LayerType.senior == layer_type and ex.c3b.TAB_SLT or ex.c3b.TAB_USLT)

    if self.cur_layer_type == layer_type then
        return
    end

    self.cur_layer_type = layer_type

    self:updateProphetTreeLayer()
end

function ProphetTreeLayer:updateProphetTreeLayer()
    self.cur_node:removeAllChildren()

    self.node_luck:setVisible(self.cur_layer_type == LayerType.summon)

    if self.cur_layer_type == LayerType.summon then
        self.cur_cost.item_type = ItemType.IT_PROPHET_BALL
        self.cur_cost.item_num = ex.Tools:getSysCfg("prophecy_summon_cost")
        self:getSummonNode() 
        self:refreshLuck()
    elseif self.cur_layer_type == LayerType.change then
        self.cur_cost.item_type = ItemType.IT_PROPHET_PIECE
        self.cur_cost.item_num = ex.Tools:getSysCfg("prophecy_exchange_cost")[1].item_num
        self:getHeroChangeNode()
    end

    self:refreshRes()
end

function ProphetTreeLayer:onBtnChangeLayer(tag, pSender)
    self:changeLayer(tag)
end

function ProphetTreeLayer:onBtnBack(tag, pSender)
    --ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
    if not ex.MainSceneCtr:backLastLayer() then
        ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
    end
end

function ProphetTreeLayer:onInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42020), ex.Tools:getLang(42021))
end

function ProphetTreeLayer:onQuestionLuck(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42064), ex.Tools:getLang(42065))
end

function ProphetTreeLayer:onBtnShop(tag, pSender)
    cfg.funcopen.main_shop.open(SHOP_TYPE.PROPHECY)
end

------------------------------抽奖部分----------------------------------------------

function ProphetTreeLayer:getSummonNode()
    local menu = cpp.UIMenu:create()
    :setPosition(cc.p(0, 0))
    self.cur_node:addChild(menu)

    -- 召唤按钮
    local btn_summon = cpp.UIMenuItemImage:createWithSpriteFrameName("button/btn-blue-4.png", nil, nil)
    btn_summon:setPosition(ex.p.cx, 230 * self.spr_bg:getScaleY())
    :registerScriptTapHandler(handler(self, self.onSummon))
    menu:addChild(btn_summon)

    -- 召唤
    setBtnNode(btn_summon, FONT_WHITLE, 2, cc.c3b(31, 86, 167), ex.Tools:getLang(70009), self.cur_cost.item_num, self.cur_cost.item_type)

    -- local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_prophet_tree_btn")
    -- spr_effect:setPosition(btn_summon:getContentSize().width / 2, btn_summon:getContentSize().height / 2 - 5)
    -- btn_summon:addChild(spr_effect)

    -- 3D旋转按钮
    self.round_layer = cpp.UIMenuRound:create()
    self.round_layer:setMinScale(0.5)
    self.round_layer:setMaxScale(1.0)
    self.round_layer:setRoundHeight(100 * ex.p.width / 768)
    self.round_layer:setRoundLength(ex.p.width * 2)
    self.round_layer:setPosition(0, ex.p.height * 0.54)
    self.round_layer:openOpacity()
    self.round_layer:setMinOpacity(64)
    self.round_layer:setContentSize(cc.size(self.round_layer:getRoundLength(), 350))
    self.cur_node:addChild(self.round_layer)

    for i=1,4 do
        local strkey = string.format("prophet-tree/elem-%d.png", i)
        local item = cpp.UIMenuItemImage:createWithSpriteFrameName(strkey, strkey, nil)
        item:setEnableAction(false)
        -- item:setCascadeOpacityEnabled(true)
        item:setTag(i - 1)
        item:registerScriptTapHandler(handler(self, self.onRoundSelected))
        self.round_layer:pushItem(item)

        local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_prophet_tree_elem")
        spr_effect:setPosition(item:getContentSize().width / 2 - 7, item:getContentSize().height / 2 + 45)
        item:addChild(spr_effect)

        local spr_selected = item:getSelectedImage()
        if spr_selected then
            spr_selected:setScale(0.95)
            spr_selected:setPosition(item:getContentSize().width * 0.05 * 0.5, item:getContentSize().height * 0.05 * 0.5)
        end

        local ck_menu = cpp.UIMenu:create()
        item:addChild(ck_menu)
        ck_menu:setPosition(0,0)
        
        local ck_item = cpp.UIMenuItemImage:createWithSpriteFrameName("prophet-tree-lang/ck.png", nil, nil)
        -- ck_item:setEnableAction(false)
        ck_item:setAnchorPoint(ex.a.center)
        ck_item:setPosition(216, 32)
        ck_item:setTag(i - 1)
        ck_menu:addChild(ck_item)
        ck_item:registerScriptTapHandler(handler(self, self.onRewardPreview))
    end
end

function ProphetTreeLayer:onRewardPreview(tag, pSender)
    local index = self.round_layer:getSelectIndex()

    if tag ~= index then
        self.round_layer:setSelected(tag)
    else
        require("src.layer.ProphetTreeRewardPreviewCtr"):instance():openWindow(index + 1)
    end
end

function ProphetTreeLayer:onSummon(tag, pSender)
    if ex.Player:getItemNum(self.cur_cost.item_type) < self.cur_cost.item_num then
        -- ex.MessageView:add(string.format(ex.Tools:getLang(1108),
        --     ex.Tools:getLang()))
        ex.Tools:showEnoughTip(self.cur_cost.item_type, true)
        return
    end
    
    self:touchSwallowTouches(true)
    
    --print("getSelectIndex: "..index)
    
    self:doSummon()
end

function ProphetTreeLayer:doSummon()
    local index = self.round_layer:getSelectIndex()
    
    local req_prophet_summon = ProphetSummon_pb.GReqProphetSummon()
    req_prophet_summon.index = index + 1
    NetManager:sendMessage(ProtocolID.GReqProphetSummon, req_prophet_summon)

    NetManager:sendMessage(ProtocolID.GReqProphetSummonInfo)
end

function ProphetTreeLayer:onRoundSelected(tag, pSender)
    self:onRoundSelectedIdx(tag)
end

function ProphetTreeLayer:onRoundSelectedIdx(idx)
    self.round_layer:setSelected(idx)

    self:refreshLuck(nil, idx + 1)
end

function ProphetTreeLayer:handleSummonResult(data)
    local vec_reward = {}
    for i,v in ipairs(data.list) do
        table.insert(vec_reward, {item_type = v.type, item_num = v.num})
    end
    
    local btn_content = {}
    btn_content.item = {item_type = self.cur_cost.item_type, item_num = self.cur_cost.item_num}
    
    require("src.layer.ProphetTreeRewardCtr"):instance():openWindow(vec_reward, btn_content, handler(self, self.doSummon))

    -- 扣除刷新消耗
    self:refreshRes()
end

--------------------------英雄置换部分-----------------------------------------------

function ProphetTreeLayer:getHeroChangeNode()
    self.change_layer = ProphetTreeChangeCell:createWithCCBIFile("ccbi/ProphetTreeChangeCell.ccbi")
    self.change_layer:setSwallowTouches(false)
    self.change_layer:setIgnoreAnchorPointForPosition(false)
    self.change_layer:setAnchorPoint(cc.p(0.5, 0))
    self.change_layer:onChangeCellContentSize(cc.size(self.change_layer:getContentSize().width * self.spr_bg:getScaleX(), self.change_layer:getContentSize().height * self.spr_bg:getScaleY()))
    self.change_layer:setPosition(self.spr_bg:getPositionX(), 100 * self.spr_bg:getScaleY())
    --self.change_layer:setScaleX(self.spr_bg:getScaleX())
    --self.change_layer:setScaleY(self.spr_bg:getScaleY())
    self.cur_node:addChild(self.change_layer)

    self.change_layer:setBtnNode(self.cur_cost.item_num, self.cur_cost.item_type)

    self.change_layer.btn_elem0:setTag(ElemType.ALL)
    self.change_layer.btn_elem1:setTag(ElemType.FIRE)
    self.change_layer.btn_elem2:setTag(ElemType.WATER)
    self.change_layer.btn_elem3:setTag(ElemType.FOREST)

    self.change_layer.btn_elem0:registerScriptTapHandler(handler(self, self.onChooseElem))
    self.change_layer.btn_elem1:registerScriptTapHandler(handler(self, self.onChooseElem))
    self.change_layer.btn_elem2:registerScriptTapHandler(handler(self, self.onChooseElem))
    self.change_layer.btn_elem3:registerScriptTapHandler(handler(self, self.onChooseElem))

    self.btn_elem_select = require("src.layer.HeroElemSelect"):new()
    self.btn_elem_select:bindSelect(self.change_layer.btn_elem0)
    self.btn_elem_select:bindSelect(self.change_layer.btn_elem1)
    self.btn_elem_select:bindSelect(self.change_layer.btn_elem2)
    self.btn_elem_select:bindSelect(self.change_layer.btn_elem3)
    
    self.btn_elem_select:setSelected(ElemType.ALL)

    self.change_layer.btn_change:registerScriptTapHandler(handler(self, self.onChangeHero))
    self.change_layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirmChange))
    self.change_layer.btn_cancel:registerScriptTapHandler(handler(self, self.onCancelChange))

    self.item_size = cc.Sprite:createWithSpriteFrameName("other/rare-0.png"):getContentSize()
    self.item_size = cc.size(self.item_size.width + 15, self.item_size.height + 12)

    -- 英雄列表scroll_view
    self.viewSize = self.change_layer.spr_hero_bg:getContentSize()
    self.viewSize.height = self.viewSize.height - 100

    self.scroll_view = cc.ScrollView:create(self.viewSize)
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    :setPosition(cc.p(self.change_layer.spr_hero_bg:getPositionX(), self.change_layer.spr_hero_bg:getPositionY() + 10))
    self.change_layer:addChild(self.scroll_view)

    self.cur_hero_elem = ElemType.ALL
    self.is_choose_elem = true
    self.hero_list_view = {}

    self.click_hero_id = 0
    self.click_hero_star = 0

    self:updateScrollView()
end

function ProphetTreeLayer:getHeroByStar4_5(cur_list)
    local hero_list = {}
    for _,v in pairs(cur_list) do
         if v.star == 4 or v.star == 5 then
           table.insert(hero_list, v)
        end
    end
    return hero_list
end

function ProphetTreeLayer:updateScrollView()
    self.scroll_view:getContainer():removeAllChildren()
    self.is_choose_elem = false
    self.hero_list_view = {}

    local hero_menu = cpp.UIMenu:create()
    :setIsTouchInsideNode(self.scroll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    self.scroll_view:addChild(hero_menu)

     -- 获取当期属性英雄 只有四星和五星英雄才可以置换
    local hero_list = self:getHeroByStar4_5(self:getHeroByElem(self.cur_hero_elem))
    local heroNum = table.nums(hero_list)
    if heroNum == 0 then
        self.is_choose_elem = true
         -- 检查上次未置换完成数据
        self:checkLastChange()
        return
    end

    -- 按星级排序
    ex.Player.hero_data:sortByStar(hero_list)

    -- 给执行任务的英雄排序
    ex.Player.hero_data:sortByTask(hero_list, ex.Player:getHeroBattleList())

    local margin = 0
    local col = math.floor((self.viewSize.width - margin * 2) / self.item_size.width) -- 列数
    local row = math.ceil(1.0 * heroNum / col) -- 行数
    local cont_height = self.item_size.height * row + margin * 2
    cont_height = math.max(cont_height , self.viewSize.height)
    --row = math.ceil((cont_height - margin * 2) / self.item_size.height) -- 总行数

    self.scroll_view:setContentSize(cc.size(self.viewSize.width, cont_height))
    self.scroll_view:setContentOffset(cc.p(0, self.viewSize.height - cont_height))

    cont_height = cont_height - (self.item_size.height * 0.5 + margin * 0.5)

    local start = cc.p(self.viewSize.width * 0.5 - (self.item_size.width * col * 0.5), cont_height)
    start.x = start.x + self.item_size.width * 0.5

    local index = 0
    for _,v in pairs(hero_list) do
        local x = index % col
        local y = math.floor(index / col)

        local item = UIMenuItemHero:createWithData(v.hero_id, v.hero_type, v.elem, v.level, v.star)
        item:setPosition(start.x + x * self.item_size.width, start.y - y * self.item_size.height)
        item:registerScriptTapHandler(handler(self, self.onClickHeroView))
        hero_menu:addChild(item)

        --if v.hasTask > 0 then
            --item:setBattling()
         --end
        --if v.is_lock then
            --item:setLocked()
        --end
        
        item:autoLocked()

        if self.click_hero_id == v.hero_id then
            item:setSelected(true)
        end

        table.insert(self.hero_list_view, item)

        index = index + 1
    end

    -- 检查上次未置换完成数据
    self:checkLastChange()

    self.is_choose_elem = true
end

function ProphetTreeLayer:checkLastChange()
    -- self.change_layer:setCurrentType(ChangeType.begin)

    if table.nums(ex.Player.prophet_data.change_data) == 0 or
        ex.Player.prophet_data.change_data.before_hero_id == "0" or
        ex.Player.prophet_data.change_data.after_hero_type == 0
     then
        -- setCurrentType(ChangeType.begin)
        return
    end

    local hero_list = self:getHeroByStar4_5(self:getHeroByElem(0))
    for _,v in pairs(hero_list) do
        if v.hero_id == ex.Player.prophet_data.change_data.before_hero_id then
            -- v:setSelected(true)
            self.change_layer:setHeroLeft(v.hero_id, v.hero_type, v.level, v.star)
            self.change_layer:setHeroRight(ex.Player.prophet_data.change_data.after_hero_type, v.level, v.star)
            self.change_layer:setCurrentType(ChangeType.confirm)
            return
        end
    end

    self.change_layer:setCurrentType(ChangeType.begin)
end

function ProphetTreeLayer:jumpToConfirmChange()
    self:touchSwallowTouches(false)

    self.change_layer:setCurrentType(ChangeType.confirm)

    for _,v in pairs(self.hero_list_view) do
        if v.hero_id == ex.Player.prophet_data.change_data.before_hero_id then
            self.change_layer:setHeroRight(ex.Player.prophet_data.change_data.after_hero_type, v.level, v.star)
            return
        end
    end
end

function ProphetTreeLayer:confirmChangeHero()
    self.change_layer:removeHero(true, true)

    ex.Player.hero_data:changeHeroType(ex.Player.prophet_data.change_data.before_hero_id,
        ex.Player.prophet_data.change_data.after_hero_type)

    for _,v in pairs(self.hero_list_view) do
        if v.hero_id == ex.Player.prophet_data.change_data.before_hero_id then
            v:setIcon(ex.Player.prophet_data.change_data.after_hero_type)
            v:setSelected(false)
            return
        end
    end
end

function ProphetTreeLayer:cancelChangeHero()
    self.change_layer:removeHero(false, true)
end

function ProphetTreeLayer:onClickHeroView(tag, pSender)
    --if pSender.battle then
        ----ex.MessageView:add(ex.Tools:getLang(47070))
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

    if pSender:isSelected() or self.change_layer:getCurrentType() == ChangeType.confirm then
        return
    end

    self.click_hero_id = pSender.hero_id
    self.click_hero_star = pSender.star
    pSender:setSelected(true)
    self.change_layer:setCurrentType(ChangeType.change)

    self.change_layer:setHeroLeft(pSender.hero_id, pSender.hero_type, pSender.level, pSender.star)

    for _,v in pairs(self.hero_list_view) do
        if v.hero_id ~= pSender.hero_id then
            v:setSelected(false)
        end
    end
end

function ProphetTreeLayer:onChangeHero(tag, pSender)
    local cost_item_num = ex.Tools:getSysCfg("prophecy_exchange_cost")[1].item_num
    if self.click_hero_star == 4 then
        cost_item_num = ex.Tools:getSysCfg("prophecy_exchange_cost_4")[1].item_num
    end
    
    -- 扣除刷新消耗
    if ex.Player:getItemNum(self.cur_cost.item_type) < cost_item_num then
        -- ex.MessageView:add(string.format(ex.Tools:getLang(1108),
        --     ex.Tools:getLang(self.cur_cost.item_type)))
        ex.Tools:showEnoughTip(self.cur_cost.item_type, true)
        return
    end
    
    self:refreshRes()

    self:touchSwallowTouches(true)

    -- 发送英雄置换
    local req_prophet_change = ProphetSummon_pb.GReqProphetChange()
	req_prophet_change.hero_id = self.click_hero_id
	NetManager:sendMessage(ProtocolID.GReqProphetChange, req_prophet_change)
end

function ProphetTreeLayer:onConfirmChange(tag, pSender)
    self.change_layer:setCurrentType(ChangeType.begin)
    self:confirmChangeHero()

    -- 确定置换
    ex.Player.prophet_data:confirmChange(0)

    self.click_hero_id = 0
    self:updateScrollView()
end

function ProphetTreeLayer:onCancelChange(tag, pSender)
    self.change_layer:setCurrentType(ChangeType.change)
    self:cancelChangeHero()

    -- 取消置换
    ex.Player.prophet_data:confirmChange(1)
end

function ProphetTreeLayer:getHeroByElem(elem)
    if elem == ElemType.ALL then
        local list = {}
        for _,v in pairs(ex.Player.hero_data.hero_list) do
            if v.elem == ElemType.FIRE or
                v.elem == ElemType.WATER or
                v.elem == ElemType.FOREST
             then
                table.insert(list, v)
            end
        end
        return list
    else
        return ex.Player.hero_data:getHeroByElem(elem)
    end
end

function ProphetTreeLayer:chooseHeroElem(elem)
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

function ProphetTreeLayer:onChooseElem(tag, pSender)
    self:chooseHeroElem(tag)
end


return ProphetTreeLayer
