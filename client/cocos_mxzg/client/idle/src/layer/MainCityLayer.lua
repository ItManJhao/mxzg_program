local MainCityLayer = class("MainCityLayer", require("src.comp.EventLayer"))
local ExTimer = require("src.ex.ExTimer")

---------- start mark: 人物走动逻辑数据 ----------
local movableAreaInfos = {
    -- {
    --     type = "line",
    --     data = {
    --         spos = cc.p(890, 600),
    --         epos = cc.p(1030, 420)
    --     },
    --     heroes = {
    --         "spine/zoulu01",
    --         "spine/zoulu02",
    --         "spine/zoulu04"
    --     },
    --     isRandom = true,
    --     randomCount = 3
    -- },
    -- {
    --     -- 中上位置
    --     type = "rect",
    --     data = cc.rect(580, 605, 255, 10),
    --     heroes = {
    --         "spine/zoulu01",
    --         "spine/zoulu02",
    --         "spine/zoulu04"
    --     },
    --     isRandom = true,
    --     randomCount = 3
    -- },
    -- {
    --     -- 中中位置
    --     type = "rect",
    --     data = cc.rect(620, 315, 260, 30),
    --     heroes = {
    --         "spine/zoulu01",
    --         "spine/zoulu02",
    --         "spine/zoulu04"
    --     },
    --     isRandom = true,
    --     randomCount = 3
    -- },
    -- {
    --     -- 右边偏下位置
    --     type = "rect",
    --     data = cc.rect(1210, 185, 70, 65),
    --     heroes = {
    --         "spine/zoulu01",
    --         "spine/zoulu02",
    --         "spine/zoulu04"
    --     },
    --     isRandom = true,
    --     randomCount = 3
    -- },
    -- {
    --     -- 中下位置
    --     type = "rect",
    --     data = cc.rect(695, 60, 55, 120),
    --     heroes = {
    --         "spine/zoulu03",
    --         "spine/zoulu05"
    --     },
    --     isRandom = true,
    --     randomCount = 3
    -- }
    {
        -- 中上位置
        type = "rect",
        data = cc.rect(410, 280, 180, 60),
        heroes = {
            "spine/x_1",
            "spine/x_2",
            "spine/x_3",
            "spine/x_4",
            "spine/x_5",
            "spine/x_6",
        },
        isRandom = true,
        randomCount = 3
    },
    {
        type = "line",
        data = {
            spos = cc.p(1080, 380),
            epos = cc.p(1410, 290)
        },
        heroes = {
            "spine/x_1",
            "spine/x_2",
            "spine/x_3",
            "spine/x_4",
            "spine/x_5",
            "spine/x_6",
        },
        isRandom = true,
        randomCount = 3
    },
}

local MIN_IDLE_TIME = 3
local MAX_IDLE_TIME = 8

local MIN_MOVE_SPEED = 5
local MAX_MOVE_SPEED = 15

local MOVING_SPINE_SCALE = 1.0
---------- end mark: 人物走动逻辑数据 ----------

---------- 地图切换逻辑 ----------
-- 屏蔽场景白天和夜晚切换模式
-- local is_ship_map_bg_into = true
local vec_map_bg_data = {
    {name="spr_map_bg1_1", file = "ccbi-res/map-bg-city-1-1-%s.png"},
    {name="spr_map_bg1_2", file = "ccbi-res/map-bg-city-1-2-%s.png"},
    {name="spr_map_bg2_1", file = "ccbi-res/map-bg-city-2-1-%s.png"},
    {name="spr_map_bg3_1", file = "ccbi-res/map-bg-city-3-1-%s.png"},
    {name="spr_map_bg4_1", file = "ccbi-res/map-bg-city-4-1-%s.jpg"},
}

--[[
  1,atom 命名 mian_开头的是功能模块
            act_开头的是活动模块

    主城上的功能按钮创建会setName其名为atom
    按钮绑定onClickBtn函数

    onClickBtn函数调用JumpManager的jumpByAtom函数
    进行条件检测如果并进行跳转

  2,创建新模块按钮
    如果功能模块按钮放在主城内，在配置maincitypos.csv添加配置
    如果在屏幕上面的活动系列,createmaincitybtn.csv添加配置

    funcopen保存atom类型的打开和是否显示配置
    如果需要检测活动是否关闭就填写isVisible函数

    opencondition.csv填写atom类型的开启条件
]]
function MainCityLayer:onCreate()
    self:setAutoClose(false)
    -- self:setSwallowTouches(false)

    self.last_refresh_time = ex.Game:getServerMillisecond()
    self.needRefreshPromotionBtn = false
    self.is_show_idle_tip = false

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/main-city.plist")
    sfc:addSpriteFrames("ccbi-res/main-city-effect.plist")
    sfc:addSpriteFrames("ccbi-res/main-summon-ball.plist")
    sfc:addSpriteFrames("ccbi-res/new-year-lang.plist")
    -- [{type = layer}]
    self.vec_keep_layer = {}

    self.scroll_view =
        cpp.UIScrollViewZoom:create(cc.size(ex.p.width, ex.p.height)):setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL):setPosition(cc.p(0, 0)):setBounceable(false):setName("UIScrollViewZoom")
    self.scroll_view:setMoveSpeed(0.7)
    self:addChild(self.scroll_view)
    ex.MainSceneCtr:addKeepLayer(MainSceneType.MAINCITY_LAYER)

    
    local map_size = cc.size(1500, 1280)
    local map_scale = ex.p.height / map_size.height
    local pos_scale = map_size.width / ex.p.width
    local vec_move_speed = {1.3, 1, 0.82, 0.63}
    local height_scale = 1

    self.map_size = map_size
    self.map_bg_type = self:getMapBgType()
    self.node_parallax = cc.ParallaxNode:create()
    self.scroll_view:setContainer(self.node_parallax)
    self.scroll_view:setContentSize(cc.size(map_size.width * map_scale, map_size.height * map_scale))



    self.spr_map_bg1 = cc.Node:create()
    self.spr_map_bg1:setContentSize(map_size)
    self.spr_map_bg1:setScale(map_scale)
    self.spr_map_bg1:setIgnoreAnchorPointForPosition(false)
    self.spr_map_bg1:setAnchorPoint(0, 0)
    self.spr_map_bg1.move_speed = vec_move_speed[1]
    self.node_parallax:addChild(self.spr_map_bg1, -1, cc.p(vec_move_speed[1], 1), cc.p(0, 0))
    
    self.spr_map_bg1_1 = cc.Sprite:create(string.format(vec_map_bg_data[1].file, self.map_bg_type))
    self.spr_map_bg1_1:setAnchorPoint(cc.p(0, 0))
    self.spr_map_bg1_1:setPositionX(-88)
    self.spr_map_bg1_1:setName("spr_map_bg1_1")
    self.spr_map_bg1:addChild(self.spr_map_bg1_1)

    self.spr_map_bg1_2 = cc.Sprite:create(string.format(vec_map_bg_data[2].file, self.map_bg_type))
    self.spr_map_bg1_2:setAnchorPoint(cc.p(1, 0))
    self.spr_map_bg1_2:setPositionX(map_size.width)
    self.spr_map_bg1_2:setName("spr_map_bg1_2")
    self.spr_map_bg1:addChild(self.spr_map_bg1_2)




    self.spr_map_bg2_1 = cc.Sprite:create(string.format(vec_map_bg_data[3].file, self.map_bg_type))
    self.spr_map_bg2_1:setPosition(cc.p(self.spr_map_bg2_1:getContentSize().width * 0.5, self.spr_map_bg2_1:getContentSize().height * 0.5))
    self.spr_map_bg2_1:setName("spr_map_bg2_1")

    self.spr_map_bg2 = cc.Node:create()
    self.spr_map_bg2:setScale(map_scale)
    self.spr_map_bg2:setAnchorPoint(cc.p(0.5, 0))
    self.spr_map_bg2:setContentSize(cc.size(self.spr_map_bg2_1:getContentSize().width, self.spr_map_bg2_1:getContentSize().height ))
    self.spr_map_bg2:setIgnoreAnchorPointForPosition(false)
    self.spr_map_bg2:addChild(self.spr_map_bg2_1)
    
    self.node_parallax:addChild(self.spr_map_bg2, -2, cc.p(vec_move_speed[2], 1), cc.p(map_size.width * 0.5 * map_scale, 0))

    self.spr_map_bg3_1 = cc.Sprite:create(string.format(vec_map_bg_data[4].file, self.map_bg_type))
    self.spr_map_bg3_1:setPosition(cc.p(self.spr_map_bg3_1:getContentSize().width * 0.5, self.spr_map_bg3_1:getContentSize().height * 0.5))
    self.spr_map_bg3_1:setName("spr_map_bg3_1")


    self.spr_map_bg3 = cc.Node:create()
    self.spr_map_bg3:setScale(map_scale)
    self.spr_map_bg3:setAnchorPoint(cc.p(0.5, 0))
    self.spr_map_bg3:setContentSize(cc.size(self.spr_map_bg3_1:getContentSize().width, self.spr_map_bg3_1:getContentSize().height ))
    self.spr_map_bg3:setIgnoreAnchorPointForPosition(false)
    self.spr_map_bg3:addChild(self.spr_map_bg3_1)

    self.node_parallax:addChild(self.spr_map_bg3, -3, cc.p(vec_move_speed[3], 1), cc.p(map_size.width * 0.5 * map_scale, 390))


    self.spr_map_bg4_1 = cc.Sprite:create(string.format(vec_map_bg_data[5].file, self.map_bg_type))
    self.spr_map_bg4_1:setPosition(cc.p(self.spr_map_bg4_1:getContentSize().width * 0.5, self.spr_map_bg4_1:getContentSize().height * 0.5))
    self.spr_map_bg4_1:setName("spr_map_bg4_1")

    -- self.spr_map_bg4:setAnchorPoint(cc.p(0.5, 1))
    -- self.spr_map_bg4:setScale(map_scale * 1.2)
    self.spr_map_bg4 = cc.Node:create()
    self.spr_map_bg4:setScale(map_scale * 1.2)
    self.spr_map_bg4:setAnchorPoint(cc.p(0.5, 1))
    self.spr_map_bg4:setContentSize(cc.size(self.spr_map_bg4_1:getContentSize().width, self.spr_map_bg4_1:getContentSize().height ))
    self.spr_map_bg4:setIgnoreAnchorPointForPosition(false)
    self.spr_map_bg4:addChild(self.spr_map_bg4_1)
    self.node_parallax:addChild(self.spr_map_bg4, -4, cc.p(vec_move_speed[4], 1), cc.p(map_size.width * 0.5 * map_scale, ex.p.height))

    -- 添加主城特效
    for i,v in ipairs(cfg.maincityeffect.maincityeffect) do
        local parent = self[v.parent]
        if parent then
            if v.type == "anim" then
                local spr_effect = ex.EffectFactory:createEffectWithNodeByName(v.para)
                spr_effect:setPosition(v.x, v.y)
                spr_effect:setLocalZOrder(v.z)
                parent:addChild(spr_effect)
            elseif v.type == "spine" then
                local spine = sp.SkeletonAnimation:create("spine/" .. v.para ..  ".json", "spine/" .. v.para ..  ".atlas", 1)
                spine:setAnimation(0, "stand", true)
                spine:setPosition(v.x, v.y)
                spine:setLocalZOrder(v.z)
                parent:addChild(spine)
            end
        end
    end
    
    -- 人物走动
    self._movingHeroes = {}
    self._movableLayer = cc.Node:create()
    self.spr_map_bg2:addChild(self._movableLayer)
    self:_spineRandomMove()

    -- 白云特效
    self:addCloudAction()

    ----------------------------------------------------------------
    -- 获取顶部的位置
    local act_menu_y = ex.MainSceneCtr:getTopY()
    -- 左边按钮底框
    self.node_left_scroll = cc.Node:create()
    self.node_left_scroll:setPosition(0,0)
    self:addChild(self.node_left_scroll)
    self.spf_btn_left_bg = cc.Scale9Sprite:createWithSpriteFrameName("main-city/spr-mian-storagebg.png",cc.rect(0,0,0,0)) 
    self.spf_btn_left_bg:setContentSize(cc.size(85, 500))
    self.spf_btn_left_bg:setIgnoreAnchorPointForPosition(false)
    self.spf_btn_left_bg:setAnchorPoint(ex.a.top_center)
    self.spf_btn_left_bg:setPosition(cc.p(50,act_menu_y-52))
    self.node_left_scroll:addChild(self.spf_btn_left_bg)

    -- 右边按钮底框
    self.node_right_scroll = cc.Node:create()
    self.node_right_scroll:setPosition(0,0)
    self:addChild(self.node_right_scroll)
    self.spf_btn_right_bg = cc.Scale9Sprite:createWithSpriteFrameName("main-city/spr-mian-storagebg.png",cc.rect(0,0,0,0)) 
    self.spf_btn_right_bg:setContentSize(cc.size(85, 500))
    self.spf_btn_right_bg:setIgnoreAnchorPointForPosition(false)
    self.spf_btn_right_bg:setAnchorPoint(ex.a.top_center)
    self.spf_btn_right_bg:setPosition(cc.p(ex.p.width-50,act_menu_y-52))
    self.node_right_scroll:addChild(self.spf_btn_right_bg)

    ----------------------------------------------------------------

    self.menu1 = cpp.UIMenu:create()
    self.menu1:setPosition(cc.p(0, 0))
    self.menu1:setSwallowsTouches(false)
    self.menu1:setIsTouchInsideNode(self.node_paralax)
    self.spr_map_bg1_1:addChild(self.menu1)

    self.menu2 = cpp.UIMenu:create()
    self.menu2:setPosition(cc.p(0, 0))
    self.menu2:setSwallowsTouches(false)
    self.menu2:setIsTouchInsideNode(self.node_paralax)
    self.spr_map_bg2:addChild(self.menu2)

    self.menu3 = cpp.UIMenu:create()
    self.menu3:setPosition(cc.p(0, 0))
    self.menu3:setSwallowsTouches(false)
    self.menu3:setIsTouchInsideNode(self.node_paralax)
    self.spr_map_bg3:addChild(self.menu3)

    self.menu4 = cpp.UIMenu:create()
    self.menu4:setPosition(cc.p(0, 0))
    self.menu4:setSwallowsTouches(false)
    self.menu4:setIsTouchInsideNode(self.node_paralax)
    self.spr_map_bg4:addChild(self.menu4)


    local callback = function(tag, pSender)
        pSender.callback(tag, pSender)
    end

    local UIMenuItemMainCity = require("src.comp.menu.UIMenuItemMainCity")
    local tab_main_city = cfg.maincitypos.main

    self.btns = {}
    for i, v in ipairs(tab_main_city) do
        local idx = v.idx

        local spr_map_bg = self["spr_map_bg" .. v.zorder]
        local item = UIMenuItemMainCity:createWithIcon(string.format("main-city/icon-%s.png", v.atom), callback)
        item.level = tonumber(v.level)
        item.callback = handler(self, self.onClickBtn)
        item:setName(v.atom)
        self.btns[idx] = item
        if v.reddot ~= "" then
            self:addRedDotNode(tonumber(v.reddot), item)

            if v.checkreddot ~= "" and self[v.checkreddot] then
                local bool = self[v.checkreddot]()
                local reddot = tonumber(v.reddot)
                ex.RedDotManager:setRedNodeVisible(reddot, bool)
            end
        end
        item:setPosition(cc.p(tonumber(v.x), tonumber(v.y)))
        item:setScale(1.0 / spr_map_bg:getScaleX() * 0.9, 1.0 / spr_map_bg:getScaleY() * 0.9)
        self["menu" .. v.zorder]:addChild(item)
    end

    local win_size = cc.Director:getInstance():getWinSize()

    local main_ctr = ex.MainSceneCtr
    local bottom_height = main_ctr:getMenuScaleHeight()
    local height_diff = main_ctr:getBottomHeight() - bottom_height
    local top_height = win_size.height - (122 - height_diff) - 22

    local menu_scene = cpp.UIMenu:create()
    menu_scene:setPosition(0, 0)
    self:addChild(menu_scene, 0, 999)

    -- 右下角按钮
    self.btn_unfold_1 = cpp.UIMenuItemImage:createWithSpriteFrameName("main-city/btn-unfold-1.png", nil, nil)
    self.btn_unfold_1:setPosition(win_size.width - 40, bottom_height + 40)
    self.btn_unfold_1:registerScriptTapHandler(handler(self, self.onUnfold))
    self.btn_unfold_1:setName("maincity_unfold")
    menu_scene:addChild(self.btn_unfold_1, 100)
    self.btn_unfold_1:setTag(-1)

    self.btn_task = cpp.UIMenuItemImage:createWithSpriteFrameName("main-city/btn-task-1.png", nil, nil)
    self.btn_task:setPosition(self.btn_unfold_1:getPositionX(), self.btn_unfold_1:getPositionY() + 70)
    self.btn_task:registerScriptTapHandler(handler(self, self.onClickBtn))
    self.btn_task:setName("act_achievement")
    menu_scene:addChild(self.btn_task)
    self.btn_task:setTag(4)

    self.btn_rank = cpp.UIMenuItemImage:createWithSpriteFrameName("main-city/btn-rank-1.png", nil, nil)
    self.btn_rank:setPosition(self.btn_unfold_1:getPositionX() - 70, self.btn_unfold_1:getPositionY())
    self.btn_rank:registerScriptTapHandler(handler(self, self.onClickBtn))
    self.btn_rank:setName("main_rank")
    menu_scene:addChild(self.btn_rank)
    self:addRedDotNode(RedDotType.ZCJ_DHZC_PHB, self.btn_rank)

    self.btn_mail = cpp.UIMenuItemImage:createWithSpriteFrameName("main-city/btn-mail-1.png", nil, nil)
    self.btn_mail:setPosition(self.btn_rank:getPositionX() - 70, self.btn_unfold_1:getPositionY())
    self.btn_mail:registerScriptTapHandler(handler(self, self.onClickBtn))
    self.btn_mail:setName("main_mail")
    menu_scene:addChild(self.btn_mail)
    self.btn_mail:setTag(1)

    self.btn_friend = cpp.UIMenuItemImage:createWithSpriteFrameName("main-city/btn-friend-1.png", nil, nil)
    self.btn_friend:setPosition(self.btn_mail:getPositionX() - 70, self.btn_unfold_1:getPositionY())
    self.btn_friend:registerScriptTapHandler(handler(self, self.onClickBtn))
    self.btn_friend:setName("main_friend")
    menu_scene:addChild(self.btn_friend)
    self.btn_friend:setTag(2)

    -- 录像馆
    self.btn_video_studio = cpp.UIMenuItemImage:createWithSpriteFrameName("main-city/btn-main-video-studio.png", nil, nil)
    self.btn_video_studio:setPosition(self.btn_friend:getPositionX() - 70, self.btn_unfold_1:getPositionY())
    self.btn_video_studio:registerScriptTapHandler(handler(self, self.onClickBtn))
    self.btn_video_studio:setName("main_video_studio")
    menu_scene:addChild(self.btn_video_studio)

    self.btn_facebook_dz = cpp.UIMenuItemImage:createWithSpriteFrameName("main-city/facebook.png", nil, nil)
    self.btn_facebook_dz:setPosition(self.btn_unfold_1:getPositionX(), self.btn_unfold_1:getPositionY() + 140)
    self.btn_facebook_dz:registerScriptTapHandler(handler(self, self.onClickBtn))
    self.btn_facebook_dz:setName("thumb_up_to_share")
    menu_scene:addChild(self.btn_facebook_dz)

    -- 左下角按钮
    -- 英雄推荐
    self.btn_hero_recommend = cpp.UIMenuItemImage:createWithSpriteFrameName("main-city/btn-hero-recommend-1.png", nil, nil)
    self.btn_hero_recommend:setPosition(50, self.btn_mail:getPositionY() + 10)
    self.btn_hero_recommend:registerScriptTapHandler(handler(self, self.onClickBtn))
    self.btn_hero_recommend:setName("main_hero_recommend")
    menu_scene:addChild(self.btn_hero_recommend)

    -- 评论有礼
    -- add 熊梦
    self.btn_discuss_gift = cpp.UIMenuItemImage:createWithSpriteFrameName("main-city/btn-discuss.png", nil, nil)
    self.btn_discuss_gift:setPosition(50, self.btn_mail:getPositionY() + 90)
    self.btn_discuss_gift:registerScriptTapHandler(handler(self, self.onClickBtn))
    self.btn_discuss_gift:setName("comments_reward")
    self.btn_discuss_gift:setVisible(false)
    menu_scene:addChild(self.btn_discuss_gift)

    -- 预告功能按钮
    self.btn_advance_announce = cpp.UIMenuItemImage:createWithSpriteFrameName("main-city/icon-act_advance_announce.png", nil, nil)
    self.btn_advance_announce:setPosition(50, self.btn_mail:getPositionY() + 170)
    self.btn_advance_announce:registerScriptTapHandler(handler(self, self.onClickAdvanceANBtn))
    self.btn_advance_announce:setName("act_advance_announce")
    self.btn_advance_announce:setVisible(false)
    menu_scene:addChild(self.btn_advance_announce)
    ex.RedDotManager:setStickNode(RedDotType.ZCJ_DHZC_GNYG, self.btn_advance_announce)

    self.dream_land = cpp.UIMenuItemImage:createWithSpriteFrameName("main-city/20-0.png", nil, nil)
    self.dream_land:setPosition(65 + self.btn_hero_recommend:getContentSize().width, self.btn_hero_recommend:getPositionY())
    self.dream_land:registerScriptTapHandler(handler(self, self.onClickDream))
    self.dream_land:setName("dream_land")
    menu_scene:addChild(self.dream_land)

    ex.EffectCtr:playNormalEff(20, self.dream_land:getContentSize().width * 0.5, self.dream_land:getContentSize().height * 0.5 + 0, nil, self.dream_land, 10)
    self.dream_land:setVisible(false)
    --self.dream_land:setVisible(true)
    if ex.Player.dream_data.status == 3 then
        self.dream_land:setVisible(true)
    end

    -- 红点绑定
    self:addRedDotNode(RedDotType.ZCJ_DHZC_YJ, self.btn_mail)
    self:addRedDotNode(RedDotType.ZCJ_DHZC_HYAN, self.btn_friend)
    self:addRedDotNode(RedDotType.ZCJ_DHZC_ZCCJ, self.btn_task)

    -- 两个按钮播放特效
    -- ex.EffectCtr:playNormalEff(16, self.btn_task:getContentSize().width / 2, self.btn_task:getContentSize().width / 2, nil, self.btn_task, 10)
    -- ex.EffectCtr:playNormalEff(16, self.btn_rank:getContentSize().width / 2, self.btn_rank:getContentSize().width / 2, nil, self.btn_rank, 10)

    if device.platform == "mac" or is_show_gm == true then
        local function onKeyPressed(keyCode, event)
        end

        local function onKeyReleased(keyCode, event)
            print("keyCode", keyCode)
            if keyCode == 47 then
                -- F1
                require("src.layer.GMCtr"):instance():openWindow()
            end
        end

        local listener = cc.EventListenerKeyboard:create()
        listener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED)
        listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED)
        cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self)

        local btn_GM = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
        btn_GM:setPosition(ex.p.cx, self.btn_friend:getPositionY() + 50)
        btn_GM:setContentSize(cc.size(60, 60))
        btn_GM:registerScriptTapHandler(handler(self, self.onGM))
        menu_scene:addChild(btn_GM, 0, 999)

        local btn_gm_show = cpp.UIMenuItemLabel:create("button/btn-small-1.png", nil, "GM", nil)
        btn_gm_show:setPosition(btn_GM:getContentSize().width * 0.5, btn_GM:getContentSize().height * 0.5)
        btn_gm_show:setLabelColor(cc.c3b(0, 0, 0))
        btn_GM:addChild(btn_gm_show, 0, 999)

        local btn_edit = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
        btn_edit:setContentSize(cc.size(60, 60))
        btn_edit:setPosition(ex.p.width * 0.34, btn_GM:getPositionY())
        btn_edit:registerScriptTapHandler(handler(self, self.onEdit))
        menu_scene:addChild(btn_edit, 0, 1000)

        local btn_edit_show = cpp.UIMenuItemLabel:create("button/btn-small-1.png", nil, ex.Tools:getLang(47112), nil)
        btn_edit_show:setPosition(btn_GM:getContentSize().width * 0.5, btn_GM:getContentSize().height * 0.5)
        btn_edit_show:setLabelColor(cc.c3b(0, 0, 0))
        btn_edit:addChild(btn_edit_show, 0, 999)


        local btn_test = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
        btn_test:setContentSize(cc.size(60, 60))
        btn_test:setPosition(ex.p.width * 0.66, btn_GM:getPositionY())
        btn_test:registerScriptTapHandler(handler(self, self.onTest))
        menu_scene:addChild(btn_test, 0, 1000)

        local btn_test_show = cpp.UIMenuItemLabel:create("button/btn-small-1.png", nil, "测试", nil)
        btn_test_show:setPosition(btn_GM:getContentSize().width * 0.5, btn_GM:getContentSize().height * 0.5)
        btn_test_show:setLabelColor(cc.c3b(0, 0, 0))
        btn_test:addChild(btn_test_show, 0, 999)
    end

    -- 添刷新按钮状态
    self:refreshBtnStatus()
    self:reloadUnfold1()
    self:reloadUnfold2()
    --
    self:runAction(
        cc.CallFunc:create(
            function()
                self:updateIdleTip()
                self:updateSummonTip()
            end
        )
    )

    -- 超值首充
    -- self:updateBtnRechargeFirst(nil,"act_recharge_first")
    -- self:addEvent(EVENT.MAIN_CITY_RECHARGE.RECHARGE_FIRST, handler(self, self.updateBtnRechargeFirst))

    -- self:updateBtnStatus()
    -- 活动红点检查
    ex.Player.promotion_data:checkAllRedDot()

    self:addEvent(EVENT.MAIN_CITY_ACT.ACTIVITY_IS_END, handler(self, self.checkActIsEnd))

    ex.AudioManager:playMusic("music/main-city.mp3")

    -- 开启定时器
    self:startTimer()

    self:addEvent(EVENT.MAIN_CITY.REFRESH_TIMER, handler(self, self.forceRefreshTimer))

    self:addEvent(EVENT.DREAM_EVENT.MAIN_SHOW_BTN, handler(self, self.onShowDreamBtn))

    self:addEvent(EVENT.MAIN_CITY.REFRESH_BTN_STATUS, handler(self, self.refreshBtnStatus))

    self:addEvent(EVENT.MAIN_CITY.REFRESH_IDLE_REWARD_TIP, handler(self, self.updateIdleTip))

    self:onUpdate(
        function(dt)
            self:_update(dt)
        end
    )
end

-- 层切入时会被调用
function MainCityLayer:changeLayerIn()
    self:refreshBtnStatus()

    self:changTimer()
end

-- 刷新预告功能按钮
function MainCityLayer:reloadLeftBtn()
    local y = self.btn_mail:getPositionY() + 10
    local isVisible = self.btn_hero_recommend:isVisible()
    if isVisible then
        y = y + 80
    end

    if ex.Player.level >= cfg.opencondition.condition["comments_reward"].condition_value and cfg.socialplatform.isOpen("comments_reward") then
        local comment_data =
            TableEx.findValueFunction(
            ex.Player.comment_list,
            function(value)
                return value.type == 200 and value.state == 2
            end
        )

        isVisible = cfg.funcopen["comments_reward"].isVisible() and comment_data == nil
        self.btn_discuss_gift:setVisible(isVisible)
        if isVisible then
            self.btn_discuss_gift:setPositionY(y)
            y = y + 80
        end
    end

    -- 预告功能按钮
    isVisible = cfg.funcopen["act_advance_announce"].isVisible()
    self.btn_advance_announce:setVisible(isVisible)
    if isVisible then
        self.btn_advance_announce:stopAllActions()
        self.btn_advance_announce:runAction(cc.Sequence:create(
                cc.CallFunc:create(function ()
                    local isOpen = cfg.funcopen["act_advance_announce"].isVisible()
                    if not isOpen then
                        self.btn_advance_announce:setVisible(false)
                        self.btn_advance_announce:stopAllActions()
                    end
                end),
                cc.DelayTime:create(1)
            )
        )
        self.btn_advance_announce:setPositionY(y)
        y = y + 80
    end
end

-- 刷新社交平台按钮
function MainCityLayer:reloadSocialBtn()
    if ex.Player.maincity_unfold_1 then
        self:setBtnVisible(self.btn_facebook_dz, cfg.funcopen["thumb_up_to_share"].isVisible())

        -- y方向更新按钮
        local yArr = {}
        if self.btn_facebook_dz:isVisible() then
            table.insert(yArr, self.btn_facebook_dz)
        end

        for i, btn in ipairs(yArr) do
            btn:setPosition(cc.p(self.btn_unfold_1:getPositionX(), self.btn_task:getPositionY() + i * 70))
        end
    end
end

function MainCityLayer:setBtnVisible(btn, visible)
    btn:setVisible(visible)
    btn:setEnabled(visible)
end

function MainCityLayer:reloadUnfold1()
    if ex.Player.maincity_unfold_1 then
        ex.Player.maincity_unfold_1 = false
    else
        ex.Player.maincity_unfold_1 = true
    end

    if ex.Player.maincity_unfold_1 then
        self.btn_rank:setVisible(true)
        self.btn_mail:setVisible(true)
        self.btn_friend:setVisible(true)
        self.btn_video_studio:setVisible(true)
        self.btn_task:setVisible(true)

        self.btn_facebook_dz:setVisible(cfg.funcopen["thumb_up_to_share"].isVisible())

        self:setBtnsEnabled(true)

        -- y方向更新按钮
        local yArr = {}
        table.insert(yArr, self.btn_task)
        if self.btn_facebook_dz:isVisible() then
            table.insert(yArr, self.btn_facebook_dz)
        end

        self.btn_rank:runAction(cc.MoveTo:create(0.3, cc.p(self.btn_unfold_1:getPositionX() - 70 * 1, self.btn_unfold_1:getPositionY())))
        self.btn_mail:runAction(cc.MoveTo:create(0.3, cc.p(self.btn_unfold_1:getPositionX() - 70 * 2, self.btn_unfold_1:getPositionY())))
        self.btn_friend:runAction(cc.MoveTo:create(0.3, cc.p(self.btn_unfold_1:getPositionX() - 70 * 3, self.btn_unfold_1:getPositionY())))
        self.btn_video_studio:runAction(cc.MoveTo:create(0.3, cc.p(self.btn_unfold_1:getPositionX() - 70 * 4, self.btn_unfold_1:getPositionY())))

        for i, btn in ipairs(yArr) do
            btn:runAction(cc.MoveTo:create(0.3, cc.p(self.btn_unfold_1:getPositionX(), self.btn_unfold_1:getPositionY() + i * 70)))
        end
    else
        self:setBtnsEnabled(false)

        -- y方向更新按钮
        local yArr = {}
        table.insert(yArr, self.btn_task)
        if self.btn_facebook_dz:isVisible() then
            table.insert(yArr, self.btn_facebook_dz)
        end

        self.btn_rank:runAction(
            cc.Sequence:create(cc.MoveTo:create(0.3, cc.p(self.btn_unfold_1:getPositionX(), self.btn_unfold_1:getPositionY())), cc.CallFunc:create(handler(self, self.setBtnUnVisible)), nil)
        )
        self.btn_mail:runAction(
            cc.Sequence:create(cc.MoveTo:create(0.3, cc.p(self.btn_unfold_1:getPositionX(), self.btn_unfold_1:getPositionY())), cc.CallFunc:create(handler(self, self.setBtnUnVisible)), nil)
        )
        self.btn_friend:runAction(
            cc.Sequence:create(cc.MoveTo:create(0.3, cc.p(self.btn_unfold_1:getPositionX(), self.btn_unfold_1:getPositionY())), cc.CallFunc:create(handler(self, self.setBtnUnVisible)), nil)
        )
        self.btn_video_studio:runAction(
            cc.Sequence:create(cc.MoveTo:create(0.3, cc.p(self.btn_unfold_1:getPositionX(), self.btn_unfold_1:getPositionY())), cc.CallFunc:create(handler(self, self.setBtnUnVisible)), nil)
        )
        for i, btn in ipairs(yArr) do
            btn:runAction(
                cc.Sequence:create(
                    cc.MoveTo:create(0.3, cc.p(self.btn_unfold_1:getPositionX(), self.btn_unfold_1:getPositionY())),
                    cc.CallFunc:create(
                        handler(
                            self,
                            function()
                                btn:setEnabled(ex.Player.maincity_unfold_1)
                                btn:setVisible(ex.Player.maincity_unfold_1)
                            end
                        )
                    ),
                    nil
                )
            )
        end
    end
end

function MainCityLayer:setBtnsEnabled(isEnabled)
    self.btn_rank:setEnabled(isEnabled)
    self.btn_mail:setEnabled(isEnabled)
    self.btn_friend:setEnabled(isEnabled)
    self.btn_video_studio:setEnabled(isEnabled)

    self.btn_task:setEnabled(isEnabled)
    self.btn_facebook_dz:setEnabled(isEnabled)
end


function MainCityLayer:reloadUnfold2()
end

function MainCityLayer:reloadUnfoldLeft()
    if ex.Player.maincity_unfold_left then
        ex.Player.maincity_unfold_left = false
    else
        ex.Player.maincity_unfold_left = true
    end

    local time = 0.1
    local margin = -6
  
    if ex.Player.maincity_unfold_left then
        for i,v in ipairs(self.btn_left_act) do
            if i ~= 1 then 
                v:setEnabled(false)
                v:setVisible(true)
                v:runAction(
                    cc.Sequence:create(cc.MoveTo:create(time, cc.p(self.btn_left_act[1]:getPositionX(), self.btn_left_act[1]:getPositionY() - (i-1) * 82)), 
                    cc.CallFunc:create(function()
                        v:setEnabled(true)
                    end), nil))
            end
        end
        self.btn_unfold_left:runAction(cc.Sequence:create(cc.MoveTo:create(time, cc.p(self.btn_left_act[1]:getPositionX(), self.btn_left_act[1]:getPositionY() - #self.btn_left_act * 82 + 24)),
                            cc.CallFunc:create(function()
                                self.btn_unfold_left:setNormalImage(cc.Sprite:createWithSpriteFrameName("main-city/btn-mian-storage-up.png"))
                            end), nil))

         -- 设置左边按钮背景框大小
         local bg_height = 500
         bg_height = (#self.btn_left_act) * 79 + 30
         self.spf_btn_left_bg:setContentSize(cc.size(85, bg_height))
    else
        for i,v in ipairs(self.btn_left_act) do
            if i ~= 1 then 
                v:setEnabled(false)
                v:runAction(
                    cc.Sequence:create(cc.MoveTo:create(time, cc.p(self.btn_left_act[1]:getPositionX(), self.btn_left_act[1]:getPositionY())), 
                    cc.CallFunc:create(function()
                        v:setVisible(false)
                        v:setEnabled(true)
                    end), nil))
            end
        end

        -- 切换收纳图片
        self.btn_unfold_left:runAction(cc.Sequence:create(cc.MoveTo:create(time, cc.p(self.btn_left_act[1]:getPositionX(), self.btn_left_act[1]:getPositionY() - 79 + 10)),
                            cc.CallFunc:create(function()
                                self.btn_unfold_left:setNormalImage(cc.Sprite:createWithSpriteFrameName("main-city/btn-mian-storage-lower.png"))
                            end), nil))

        -- 设置左边按钮背景框大小
        local bg_height = 500
        bg_height = 1 * 79 + 30
        self.spf_btn_left_bg:setContentSize(cc.size(85, bg_height))
    end

end

function MainCityLayer:reloadUnfoldRight()
    if ex.Player.maincity_unfold_right then
        ex.Player.maincity_unfold_right = false
    else
        ex.Player.maincity_unfold_right = true
    end

    local time = 0.1
    if ex.Player.maincity_unfold_right then
        for i,v in ipairs(self.btn_right_act) do
            if i ~= 1 then 
                v:setEnabled(false)
                v:setVisible(true)
                v:runAction(
                    cc.Sequence:create(cc.MoveTo:create(time, cc.p(self.btn_right_act[1]:getPositionX(), self.btn_right_act[1]:getPositionY() - (i-1) * 82)), 
                    cc.CallFunc:create(function()
                        v:setEnabled(true)
                    end), nil))
            end
        end
        self.btn_unfold_right:runAction(cc.Sequence:create(cc.MoveTo:create(time, cc.p(self.btn_right_act[1]:getPositionX(), self.btn_right_act[1]:getPositionY() - #self.btn_right_act * 82 + 24)),
                            cc.CallFunc:create(function()
                                self.btn_unfold_right:setNormalImage(cc.Sprite:createWithSpriteFrameName("main-city/btn-mian-storage-up.png"))
                            end), nil))

         -- 设置左边按钮背景框大小
         local bg_height = 500
         bg_height = (#self.btn_right_act) * 79 + 30
         self.spf_btn_right_bg:setContentSize(cc.size(85, bg_height))
    else
        for i,v in ipairs(self.btn_right_act) do
            if i ~= 1 then 
                v:setEnabled(false)
                v:runAction(
                    cc.Sequence:create(cc.MoveTo:create(time, cc.p(self.btn_right_act[1]:getPositionX(), self.btn_right_act[1]:getPositionY())), 
                    cc.CallFunc:create(function()
                        v:setVisible(false)
                        v:setEnabled(true)
                    end), nil))
            end
        end

        -- 切换收纳图片
        self.btn_unfold_right:runAction(cc.Sequence:create(cc.MoveTo:create(time, cc.p(self.btn_right_act[1]:getPositionX(), self.btn_right_act[1]:getPositionY() - 79 + 10)),
                            cc.CallFunc:create(function()
                                self.btn_unfold_right:setNormalImage(cc.Sprite:createWithSpriteFrameName("main-city/btn-mian-storage-lower.png"))
                            end), nil))

         -- 设置右边按钮背景框大小
         local bg_height = 500
         bg_height = 1 * 79 + 30
         self.spf_btn_right_bg:setContentSize(cc.size(85, bg_height))
    end

end

-- 刷新按钮状态
function MainCityLayer:refreshBtnStatus()
    self:reloadLeftBtn()
    self:reloadSocialBtn()

    -- 活动入口
    if self.act_menu ~= nil then
        self.act_menu:removeFromParent()
    end
    self.act_menu = nil


    local act_menu_y = ex.MainSceneCtr:getTopY()
    local act_menu_x = ex.p.width - 60

    
    self.act_menu = cpp.UIMenu:create()
    self.act_menu:setIgnoreAnchorPointForPosition(false)
    self.act_menu:setAnchorPoint(1, 1)
    self.act_menu:setContentSize(cc.size(1,1))
    self.act_menu:setPosition(act_menu_x, act_menu_y)
    self:addChild(self.act_menu)

    -- 活动入口
    if self.act_left_menu ~= nil then
        self.act_left_menu:removeFromParent()
    end
    self.act_left_menu = nil

    self.act_left_menu = cpp.UIMenu:create()
    self.act_left_menu:setPosition(0,act_menu_y)
    self:addChild(self.act_left_menu)

    -- 活动入口
    if self.act_right_menu ~= nil then
        self.act_right_menu:removeFromParent()
    end
    self.act_right_menu = nil

    self.act_right_menu = cpp.UIMenu:create()
    self.act_right_menu:setPosition(0,act_menu_y)
    self:addChild(self.act_right_menu)

    -- 添加按钮扩展信息
    local addBtnExtInfo = function(item, is_unlock, show_label)
        -- 置灰处理
        cpp.ShaderFactory:instance():setAllChildren(item, not is_unlock and ShaderType.ST_POSITION_TEXTURE_GRAY or ShaderType.ST_POSITION_TEXTURE_DEFAULT)

        local tmp_lbl = item:getChildByTag(300)
        if tmp_lbl then
            tmp_lbl:removeFromParent()
        end

        if show_label ~= nil then
            local lbl_level_txt = cc.Label:createWithTTF(tostring(show_label), FONT_DEFAULT_NAME_BOLD, 36)
            lbl_level_txt:setTextColor(cc.c3b(229, 226, 226))
            -- lbl_level_txt:setPosition(item:getContentSize().width / 2, item:getContentSize().height / 2)
            lbl_level_txt:setPosition(item:getContentSize().width * 0.5, 53)
            lbl_level_txt:setAnchorPoint(cc.p(0.5, 0))
            lbl_level_txt:setScale(0.5)
            lbl_level_txt:setTag(300)
            lbl_level_txt:enableOutline(cc.c4b(73, 73, 73, 255), 4)
            item:addChild(lbl_level_txt)
        end
    end

    self.btn_act = {}
    self.btn_left_act = {}
    self.btn_right_act = {}
    local act_cfg = cfg.createmaincitybtn.act
    local begin_x = ex.p.width - 60
    -- local begin_y = top_height
    local margin = 10
    local item_scale = 0.9 * 0.8
    local is_unlock, is_show, need_label = false, false, ""
    for k, v in pairs(act_cfg) do
        if v.path ~= nil and v.path ~= "" then
            is_unlock, is_show, need_label = ex.Tools:getMainCityBtnStatus(v.atom)
            if v.atom == "act_seven_artifact" then
                print(is_show)
            end
            if is_show then -- 需要显示
                -- 如果龙舟活动开启的话 则替换限时活动的图标为龙舟活动的图标
                local atom = v.atom
                if ex.Player.promotion_data:checkDragonBoatIsOpen() and v.atom == "act_limit_time_server" then
                    atom = "act_limit_time_server_2"
                end

                local path = string.format("main-city/icon-%s.png", atom)
                local item = cpp.UIMenuItemImage:createWithSpriteFrameName(path, nil, nil)
                item:setScale(item_scale)
                item.type = v.type
                if v.atom == "act_new_year" then
                    if ex.Player.promotion_data.new_year_data.round > 1 and not ex.Player.promotion_data.new_year_data.buy_special and ex.Player.maincity_unfold_left then
                        local node = cc.Node:create()
                        node:setName("zhanlingqipao")

                        cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/new-year-lang.plist")

                        local spr = cc.Sprite:createWithSpriteFrameName("new-year-lang/spr-bubble.png")
                        spr:setPosition(item:getContentSize().width + 50, item:getContentSize().height )
                        node:addChild(spr)
                        item:addChild(node)
                    end                 
                end

                if v.effId ~= nil and v.effId ~= "" then
                    if v.effId == 6 then
                        -- 降低超值首充的特效播放速度
                        local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_main_city_first_charge")
                        spr_effect:setPosition(item:getContentSize().width / 2, item:getContentSize().height / 2)
                        item:addChild(spr_effect, 10)
                    else
                        ex.EffectCtr:playNormalEff(v.effId, item:getContentSize().width / 2 * 0.9, item:getContentSize().width / 2 * 0.9, nil, item, 0)
                    end
                end

                local open_cfg = cfg.funcopen[v.atom]

                if open_cfg ~= nil then
                    ex.Tools:try(
                    function()
                        if open_cfg and open_cfg.isVisible then
                            local visible = open_cfg.isVisible()

                            item:setVisible(visible)
                        end
                    end)

                    self.btn_act[v.atom] = item
                    if v.reddot ~= "" and v.reddot ~= nil then
                        ex.RedDotManager:setStickNode(tonumber(v.reddot), item)
                        if v.checkreddot ~= "" and self[v.checkreddot] then
                            local bool = self[v.checkreddot]()
                            local reddot = tonumber(v.reddot)
                            ex.RedDotManager:setRedNodeVisible(reddot, bool)
                        end
                    end
                    local size = item:getContentSize()
                    -- 按钮位置通过下面的sortActBtn函数调整
                    -- local row = idx % 4 == 0 and 4 or idx % 4
                    -- local posX = begin_x - (row - 1) * (size.width * item_scale + margin)
                    -- local rol = math.ceil(v.idx / 4)
                    -- local posY = begin_y - (rol - 1) * (size.height * item_scale + margin)
                    -- item:setPosition(posX, posY)
                    item:setName(v.atom)

                    if open_cfg.getEndTime ~= nil then
                        local end_time = open_cfg.getEndTime()
                        if end_time > 0 then
                            item.act_end_time = end_time
                        end
                    end

                    -- type: 
                    -- 1: 活动按钮显示在主界面
                    -- 2: 活动按钮显示在左边收缩框
                    -- 3: 活动按钮显示在右边收缩框
                    if v.type == 2 then 
                        self.act_left_menu:addChild(item)
                    elseif v.type == 3 then
                        self.act_right_menu:addChild(item)
                    else 
                        self.act_menu:addChild(item)
                    end

                    if v.callback ~= "" then
                        item:registerScriptTapHandler(handler(self, self.onClickBtn))
                    end

                    addBtnExtInfo(item, is_unlock, need_label)
                end
            end
        end
    end

    for k, v in pairs(self.btns) do
        is_unlock, is_show, need_label = ex.Tools:getMainCityBtnStatus(v:getName())

        if is_show then
            v:setVisible(true)

            addBtnExtInfo(v, is_unlock, need_label)
        else
            v:setVisible(false)
        end
    end

    -- 记录按钮
    self:recordShrinkBtn(2,self.btn_left_act)
    self:recordShrinkBtn(3,self.btn_right_act)
    -- 左边添加收缩按钮
    local path_left = "main-city/btn-mian-storage-lower.png"
    if ex.Player.maincity_unfold_left then
        path_left = "main-city/btn-mian-storage-up.png"
    end
    self.btn_unfold_left = cpp.UIMenuItemImage:createWithSpriteFrameName(path_left, nil, nil)
    self.btn_unfold_left:registerScriptTapHandler(handler(self, self.onClickBtnLeftStretch))
    self.act_left_menu:addChild(self.btn_unfold_left)
    if self.btn_left_act[1] ~= nil then
        self.btn_left_act[1]:setLocalZOrder(100)
    end 
    -- 右边收纳
    local path_right = "main-city/btn-mian-storage-lower.png"
    if ex.Player.maincity_unfold_right then
        path_right = "main-city/btn-mian-storage-up.png"
    end
    self.btn_unfold_right = cpp.UIMenuItemImage:createWithSpriteFrameName(path_right, nil, nil)
    self.btn_unfold_right:registerScriptTapHandler(handler(self, self.onClickBtnRightStretch))
    self.act_right_menu:addChild(self.btn_unfold_right)

    if self.btn_right_act[1] ~= nil then
        self.btn_right_act[1]:setLocalZOrder(100)
    end

    self:sortActBtn()
end

-- 记录按钮 伸缩做准备
function MainCityLayer:recordShrinkBtn(type,table_btn)
    local btn_left_act = {}
    local btn_data = {}
    for k, v in pairs(self.btn_act) do
        if v:isVisible() then
           if v.type == type then
                local data = {}
                data.atom = k
                data.idx = cfg.createmaincitybtn.act[k].idx
                local conf = cfg.createmaincitybtn.act[k]
                table.insert(btn_data, data)
            end
        end
    end

    local function sor(a, b)
        local confA = cfg.createmaincitybtn.act[a.atom]
        local confB = cfg.createmaincitybtn.act[b.atom]
        local colA = confA.col
        local colB = confB.col
        return colA < colB
    end

    table.sort(btn_data, sor)

    for i,v in ipairs(btn_data) do
        table.insert(table_btn,self.btn_act[v.atom])
    end

end

function MainCityLayer:startTimer()
    self:changTimer()

    self:addTimer("timer", 500, handler(self, self.changTimer), true)
    self:addTimer("timer_bg_type", 20000, handler(self, self.intoDayOrNight), true)
end

function MainCityLayer:getMapBgType()
    -- if is_ship_map_bg_into then
    --     return 1
    -- end
    local time = ex.Game:getServerTime()
    local m = tonumber(os.date("%H", time)) * 3600 + tonumber(os.date("%M", time)) * 60

    -- 白天， 早上6.30分-晚上6.30分为白天
    if m >= 23400 and m <= 66600 then
        return 1
    end

    -- 夜晚
    return 2
end

-- 主场景切换到白天或夜晚
function MainCityLayer:intoDayOrNight()
    -- 判断是否互相切换场景
    local tmp_map_type = self:getMapBgType() -- self.map_bg_type == 2 and 1 or 2
    if tmp_map_type == self.map_bg_type then
        return
    end

    self.map_bg_type = tmp_map_type

    local action_tag = 99988
    self:stopActionByTag(action_tag)
    for i,v in ipairs(vec_map_bg_data) do
        local spr_ori = self[v.name]
        if spr_ori then
            spr_ori:removeChildByName("into_bg")
            local spr_bg = cc.Sprite:create(string.format(v.file, self.map_bg_type))
            spr_bg:setAnchorPoint(cc.p(0, 0))
            spr_bg:setOpacity(0)
            spr_bg:setName("into_bg")
            spr_ori:addChild(spr_bg)
            spr_bg:runAction(cc.FadeTo:create(10, 255))
            spr_ori:runAction(cc.Sequence:create(cc.DelayTime:create(7), cc.FadeTo:create(3, 0)))
        end
    end
    
    local func_change = cc.Sequence:create(cc.DelayTime:create(14),cc.CallFunc:create(function()
        print("func_change")
        local res_manager = require("src.model.ResManager"):instance()
        for i,v in ipairs(vec_map_bg_data) do
            local spr_ori = self[v.name]
            if spr_ori then
                spr_ori:stopAllActions()
                spr_ori:setOpacity(255)
                local file_name = string.format(v.file, self.map_bg_type)
                local file_name_remove = string.format(v.file, self.map_bg_type == 2 and 1 or 2)
                local image = display.loadImage(file_name)
                if image then
                    spr_ori:setTexture(image)
                end
                spr_ori:removeChildByName("into_bg")
                res_manager:removeImage({
                    {image_name = file_name_remove, remove_type=1},
                })
            end
        end
    end))
    func_change:setTag(action_tag)
    self:runAction(func_change)
end

function MainCityLayer:forceRefreshTimer()
    self:changTimer(true)
end

function MainCityLayer:changTimer(is_force)
    local cur_time = ex.Game:getServerMillisecond()

    self:refreshPromotionData(cur_time)

    cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/main-city.plist")

    for k, v in pairs(self.btn_act) do
        if is_force ~= nil and is_force then
            local open_cfg = cfg.funcopen[k]
            if open_cfg.getEndTime ~= nil then
                v.act_end_time = open_cfg.getEndTime()
            end
        end

        if v:isVisible() and v.act_end_time ~= nil and v.act_end_time > 0 then
            if cur_time / 1000 < v.act_end_time then
                if v.lbl_time == nil then
                    v.lbl_time = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 36)
                    v.lbl_time:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
                    v.map_type = self.getMapBgType()
                    if v.map_type == 2 then
                        v.lbl_time:setColor(cc.c3b(38,254,134))
                    else
                        v.lbl_time:setColor(FONT_BLACK)   
                    end
                    v.lbl_time:setScale(0.5)
                    v.lbl_time:setAnchorPoint(cc.p(0.5, 1))
                    v.lbl_time:setPosition(v:getContentSize().width / 2, 8)
                    -- add 熊梦 如果是收纳条里面的按钮 时间颜色改为白色 并加上时间背景框
                    if v.type ~= 1 then
                        v.lbl_time:setColor(FONT_WHITLE)
                        -- add 熊梦 添加时间背景框
                        v.time_bg = cc.Sprite:createWithSpriteFrameName("main-city/spr-time-bg.png")
                        v.time_bg:setAnchorPoint(cc.p(0.5, 1))
                        v.time_bg:setPosition(v:getContentSize().width / 2, 8)
                        v.time_bg:setScaleY(1.4)
                        v.time_bg:setScaleX(1.3)
                        v:addChild(v.time_bg)
                    end
                    v:addChild(v.lbl_time)
                else
                    if v.map_type ~= self.map_bg_type then
                        if self.map_bg_type == 1 then
                            v.lbl_time:setColor(FONT_BLACK)  
                        else
                            v.lbl_time:setColor(cc.c3b(38,254,134))
                        end   
                        if v.type ~= 1 then
                            v.lbl_time:setColor(FONT_WHITLE)
                        end
                        v.map_type = self.getMapBgType()
                    end

                end

                local open_cfg = cfg.funcopen[v:getName()]
                v.lbl_time:setString(open_cfg.getTimeTipString())
            else
                self:checkActIsEnd(0, v:getName())
            end
        else
            -- 移除时间
            if v.lbl_time ~= nil and tolua.isnull(v.lbl_time) ~= nil then
                v.lbl_time:removeFromParent()
            end
            if v.time_bg ~= nil and tolua.isnull(v.time_bg) ~= nil then
                v.time_bg:removeFromParent()
            end
            v.lbl_time = nil
            v.time_bg = nil
        end
    end
end

function MainCityLayer:checkActIsEnd(event, atom)
    local open_cfg = cfg.funcopen[atom]
    if open_cfg and open_cfg.isVisible then
        local visible = open_cfg.isVisible()
        if self.btn_act ~= nil and self.btn_act[atom] then
            self.btn_act[atom]:setVisible(visible)
        end
    end
    self:sortActBtn()
end

function MainCityLayer:sortActBtn()
    local act_cfg = cfg.createmaincitybtn.act

    --dump(self.btn_act, "self.btn_act")

    local show_btn_list = {}
    local show_btn_left_list = {}
    local show_btn_right_list = {}
    local tmp = {}
    local tmp_left = {}
    local tmp_right = {}
    local max_row = 0
    local max_left_row = 0
    local max_right_row = 0
    for k, v in pairs(self.btn_act) do
        if v:isVisible() then
            local data = {}
            data.atom = k
            data.idx = act_cfg[k].idx
            local conf = cfg.createmaincitybtn.act[k]
           
           if v.type == 2 then
                table.insert(tmp_left, data)
                if conf.row > max_left_row then
                    max_left_row = conf.row
                end
            elseif v.type == 3 then
                table.insert(tmp_right, data)
                if conf.row > max_right_row then
                    max_right_row = conf.row
                end
            else
                if not tmp[conf.row] then
                    tmp[conf.row] = {}
                end
                table.insert(tmp[conf.row], data)
                if conf.row > max_row then
                    max_row = conf.row
                end
            end
        end
    end

    local function sor(a, b)
        local confA = cfg.createmaincitybtn.act[a.atom]
        local confB = cfg.createmaincitybtn.act[b.atom]
        local colA = confA.col
        local colB = confB.col
        return colA < colB
    end

    for i = 1, max_row do
        if not tmp[i] then
            tmp[i] = {}
        end
    end

    for i = 1, max_left_row do
        if not tmp_left[i] then
            tmp_left[i] = {}
        end
    end

    for i = 1, max_right_row do
        if not tmp_right[i] then
            tmp_right[i] = {}
        end
    end

    for i, v in ipairs(tmp) do
        table.sort(v, sor)
    end

    local row = 0
    for i, v in ipairs(tmp) do
        if table.nums(v) > 0 then
            row = row + 1
        end
        for i, val in ipairs(v) do
            val.row = row
            table.insert(show_btn_list, val)
        end
    end

    for i, v in ipairs(tmp_left) do
        table.insert(show_btn_left_list, v)
    end

    for i,v in ipairs(tmp_right) do
        table.insert(show_btn_right_list, v)
    end

    table.sort(show_btn_left_list, sor)
    table.sort(show_btn_right_list, sor)

    for i,v in ipairs(show_btn_left_list) do
        v.row = i
    end

    for i,v in ipairs(show_btn_right_list) do
        v.row = i
    end

    local win_size = cc.Director:getInstance():getWinSize()
    local main_ctr = ex.MainSceneCtr
    local bottom_height = main_ctr:getMenuScaleHeight()
    local height_diff = main_ctr:getBottomHeight() - bottom_height

    local pos = 1

    local begin_x = -70
    local top_height = -60

    -- for k,v in pairs(show_btn_list) do
    --     if v.atom == "act_limit_time_activity" then
    --         table.insert(d,v)
    --     end
    -- end
    -- show_btn_list = d
    ---------------------------
    local top = top_height
    local margin = -6
    local col = cfg.system.home_screen_row_icon_num
    local nums = {}

    local min_scale = 1
    for i, v in ipairs(show_btn_list) do
        local btn = self.btn_act[v.atom]
        local size = cc.size(btn:getContentSize().width * btn:getScaleX() * 1.2, btn:getContentSize().height * btn:getScaleY() * 1.2)

        if not nums[v.row] then
            nums[v.row] = 1
        else
            nums[v.row] = nums[v.row] + 1
        end

        local posX = begin_x - (nums[v.row] - 1) * (size.width + margin)
        local posY = top - (v.row - 1) * (size.height + margin)
        btn:setVisible(nums[v.row] <= col)
        if (nums[v.row] <= col) == false then
        end
        btn:setPosition(posX, posY)

        -- print("posY", posY)
        if btn:isVisible() and math.abs(posX - 50) > self.act_menu:getPositionX() then
            local scale = self.act_menu:getPositionX() / (math.abs(posX) + 50)
            if scale < min_scale then
                min_scale = scale
            end
        end

    end

    -- 左右收纳条 图标位置设置
    local show_list = {show_btn_left_list, show_btn_right_list}
    local maincity_unfold = {ex.Player.maincity_unfold_left, ex.Player.maincity_unfold_right}
    local spf_btn_list_bg = {self.spf_btn_left_bg, self.spf_btn_right_bg}
    local btn_unfold_left = {self.btn_unfold_left, self.btn_unfold_right}
    for index,value in ipairs(show_list) do
        -- 左边收纳
        local max_left_row = 0
        --ex.Player.maincity_unfold_left :true  展开状态
        --ex.Player.maincity_unfold_left :false 收缩状态
        if #value > 0 then
            for i, v in ipairs(value) do
                local btn = self.btn_act[v.atom]
                local size = cc.size(btn:getContentSize().width * btn:getScaleX() * 1.2, btn:getContentSize().height * btn:getScaleY() * 1.2)
        
                if not nums[v.row] then
                    nums[v.row] = 1
                else
                    nums[v.row] = nums[v.row] + 1
                end
        
                local posX = 50
                if index == 2 then
                    posX = win_size.width - 50
                end
                local posY = top - (v.row - 1) * (size.height + margin) 
                btn:setVisible(nums[v.row] <= col)
            
                btn:setPosition(posX, posY)

                btn:setVisible(true)
                if not maincity_unfold[index] and i ~= 1 then
                    btn:setVisible(false)
                end
                
                max_left_row = v.row > max_left_row and v.row or max_left_row
            end   
            if not maincity_unfold[index] then
                local posX = 50
                if index == 2 then
                    posX = win_size.width - 50
                end
                local posY = top * 79
                -- 设置按钮背景框大小
                local bg_height = 500
                bg_height = 1 * 79 + 30
                spf_btn_list_bg[index]:setContentSize(cc.size(85, bg_height))
    
                -- 添加收缩按钮
                local posY = top - (79 + margin -1)
                btn_unfold_left[index]:setPosition(posX,posY)       
            else
                    -- 设置按钮背景框大小
                local bg_height = 500
                bg_height = #value * 79 + 30
                spf_btn_list_bg[index]:setContentSize(cc.size(85, bg_height))
    
                local posY = top - (max_left_row) * (79 + margin + 3)
                local posX = 50
                if index == 2 then
                    posX = win_size.width - 50
                end
                btn_unfold_left[index]:setPosition(posX,posY)
            end
            spf_btn_list_bg[index]:setVisible(true)
            btn_unfold_left[index]:setVisible(true)   
        else
            spf_btn_list_bg[index]:setVisible(false)
            btn_unfold_left[index]:setVisible(false)   
        end
    end
  --  self.act_menu:setScale(min_scale)
end

function MainCityLayer:refreshPromotionData(cur_time)
    -- 检测当前时间跟明天的差距，正点准时刷新活动数据

    local now_day = os.date("%Y%m%d", (cur_time * 0.001))

    local last_refresh_day = os.date("%Y%m%d", (self.last_refresh_time * 0.001))

    if now_day ~= last_refresh_day then
        if self.needRefreshPromotionBtn == false then
            ex.Player.promotion_data:nextDayRefreshPromotion()

            -- 重新刷新活动红点
            self.needRefreshPromotionBtn = true
        else
            if ex.Game:getServerMillisecond() - self.last_refresh_time > 10 then
                -- 刷新界面信息
                ex.Player.promotion_data:checkAllRedDot()

                ex.EventManager:fire(EVENT.MAIN_CITY_ACT.ACTIVITY_IS_END, "act_day_first_recharge")
                ex.EventManager:fire(EVENT.MAIN_CITY_ACT.ACTIVITY_IS_END, "act_limit_time_activity")
                self.needRefreshPromotionBtn = false

                self.last_refresh_time = ex.Game:getServerMillisecond()
            end
        end
        return
    end
end

function MainCityLayer:onClickBtn(tag, pSender)
    local atom = pSender:getName()
    ex.JumpManager:jumpByAtom(atom)
    if atom == "act_new_year" then
        pSender:removeChildByName("zhanlingqipao")
    end
    -- ex.JumpManager:jumpByAtom(atom)
    print(self.__cname, atom)
end

function MainCityLayer:onClickAdvanceANBtn()
    require("src.layer.promotion.PROM66Ctr"):instance():openWindow()
end

function MainCityLayer:onUnfold(tag, pSender)
    local str_name = pSender:getName()
    if str_name ~= "maincity_unfold" then
        return
    end

    -- 两个展开动作共用同一个时间间隔，执行间隔设置为1s
    local now = ex.Game:getServerMillisecond()
    if now - ex.Player.maincity_unfold_time <= 500 then
        return
    end
    ex.Player.maincity_unfold_time = now

    if tag == -1 then
        self:reloadUnfold1()
    elseif tag == -2 then
        self:reloadUnfold2()
    end
end

-- 左边按钮伸缩回调
function MainCityLayer:onClickBtnLeftStretch(tag, pSender)
    --print("=============左边按钮伸缩回调===============")
    -- 两个展开动作共用同一个时间间隔，执行间隔设置为1s
    local now = ex.Game:getServerMillisecond()
    if now - ex.Player.maincity_unfold_left_time <= 500 then
        return
    end
    ex.Player.maincity_unfold_left_time = now

    self:reloadUnfoldLeft()

end

-- 右边按钮伸缩回调
function MainCityLayer:onClickBtnRightStretch(tag, pSender)
    --print("============右边按钮伸缩回调===============")
    -- 两个展开动作共用同一个时间间隔，执行间隔设置为1s
    local now = ex.Game:getServerMillisecond()
    if now - ex.Player.maincity_unfold_right_time <= 500 then
        return
    end
    ex.Player.maincity_unfold_right_time = now

    self:reloadUnfoldRight()

end

function MainCityLayer:setBtnUnVisible()
    self.btn_rank:setVisible(ex.Player.maincity_unfold_1)
    self.btn_mail:setVisible(ex.Player.maincity_unfold_1)
    self.btn_friend:setVisible(ex.Player.maincity_unfold_1)
    self.btn_video_studio:setVisible(ex.Player.maincity_unfold_1)
    self.btn_task:setVisible(ex.Player.maincity_unfold_1)

    self.btn_rank:setEnabled(ex.Player.maincity_unfold_1)
    self.btn_mail:setEnabled(ex.Player.maincity_unfold_1)
    self.btn_friend:setEnabled(ex.Player.maincity_unfold_1)
    self.btn_video_studio:setEnabled(ex.Player.maincity_unfold_1)
    self.btn_task:setEnabled(ex.Player.maincity_unfold_1)
end

function MainCityLayer:onClickDream(tag, pSender)
    local layer = ex.MainSceneCtr:changeLayer(MainSceneType.DREAM_LAYER)
    ex.EventManager:fire(EVENT.DREAM_EVENT.OPEN_SELECT_BUFF)
end

function MainCityLayer:onShowDreamBtn()
    if ex.Player.dream_data.status == 3 then
        self.dream_land:setVisible(true)
    else
        self.dream_land:setVisible(false)
    end
end

function MainCityLayer:addCloudAction()
    local win_size = self.spr_map_bg3:getContentSize()
    if self.layer_cloud == nil then
        self.layer_cloud = cc.Layer:create()
        self.layer_cloud:setPosition(0, 0)
        self.spr_map_bg3:addChild(self.layer_cloud)
    end
    self.layer_cloud:removeAllChildren()

    for i = 1, 10 do
        local spr_cloud = cc.Sprite:create()
        spr_cloud:setPosition(win_size.width + 150, win_size.height * 0.8)
        spr_cloud:setOpacity(self.map_bg_type == 2 and 50 or 200)
        self.layer_cloud:addChild(spr_cloud, 20, 100)
        local act_delay = cc.DelayTime:create(math.random(1, 60))
        -- local act_delay = cc.DelayTime:create(math.random(1, 2))
        local act_callback = cc.CallFunc:create(handler(self, self.cloudActionEnd))
        spr_cloud:runAction(cc.Sequence:create(act_delay, act_callback, cc.RemoveSelf:create(), nil))
    end

    -- CallFuncN
end

function MainCityLayer:cloudActionEnd(pSender)
    if self.layer_cloud == nil or table.nums(self.layer_cloud:getChildren()) > 10 then
        return
    end

    local win_size = self.spr_map_bg2:getContentSize()

    local str_cloud = string.format("main-city-effect/spr-cloud-%d.png", math.random(1, 4))
    local spr_cloud = cc.Sprite:createWithSpriteFrameName(str_cloud)
    self.layer_cloud:addChild(spr_cloud, 20, 100)
    spr_cloud:setOpacity(self.map_bg_type == 2 and 50 or 200)
    spr_cloud:setPosition(win_size.width, win_size.height * math.random(5, 9) / 10.0)

    local act_move_by = cc.MoveBy:create(math.random(50, 100), cc.p(-win_size.width - 300, 0))
    local act_delay = cc.DelayTime:create(math.random(1, 20))
    -- local act_delay = cc.DelayTime:create(math.random(1, 2))
    local act_callback = cc.CallFunc:create(handler(self, self.cloudActionEnd))
    spr_cloud:runAction(cc.Sequence:create(act_move_by, act_delay, act_callback, cc.RemoveSelf:create(), nil))

    if table.nums(self.layer_cloud:getChildren()) < 10 then
        local spr_cloud = cc.Sprite:create()
        spr_cloud:setPosition(win_size.width, win_size.height * 0.8)
        spr_cloud:setOpacity(self.map_bg_type == 2 and 50 or 200)
        self.layer_cloud:addChild(spr_cloud, 20, 100)

        local act_delay = cc.DelayTime:create(math.random(1, 60))
        -- local act_delay = cc.DelayTime:create(math.random(1, 2))
        local act_callback = cc.CallFunc:create(handler(self, self.cloudActionEnd))
        spr_cloud:runAction(cc.Sequence:create(act_delay, act_callback, cc.RemoveSelf:create(), nil))
    end
end

function MainCityLayer:addPotionAction()
    local spr_potion = cc.Sprite:createWithSpriteFrameName("main-city-effect/spr-potion.png")
    spr_potion:setPosition(1220, 250)
    spr_potion:setScale(1)
    self.spr_map_bg2:addChild(spr_potion, 50, 30)

    local action_move = cc.Sequence:create(cc.MoveBy:create(1, cc.p(0, 5)), cc.MoveBy:create(1, cc.p(0, -5)), nil)
    spr_potion:runAction(cc.RepeatForever:create(action_move))
end

function MainCityLayer:addAirshipAction()
    local spr_airship = cc.Sprite:createWithSpriteFrameName("main-city-effect/spr-airship.png")
    spr_airship:setPosition(1040, 430)
    spr_airship:setScale(1)
    self.spr_map_bg:addChild(spr_airship, 50, 30)

    local action_move = cc.Sequence:create(cc.MoveBy:create(2, cc.p(0, 10)), cc.MoveBy:create(2, cc.p(0, -10)), nil)
    spr_airship:runAction(cc.RepeatForever:create(action_move))
end

function MainCityLayer:addSpineAction()
    -- 添加触手骨骼动画
    local spine_grass_1 = sp.SkeletonAnimation:create("spine/t1.json", "spine/t1.atlas", 1)
    spine_grass_1:setAnimation(0, "act1", true)
    spine_grass_1:setPosition(80, 50)
    self.spr_map_bg1:addChild(spine_grass_1, 10)

    local spine_grass_2 = sp.SkeletonAnimation:create("spine/t2.json", "spine/t2.atlas", 1)
    spine_grass_2:setAnimation(0, "act1", true)
    spine_grass_2:setPosition(160, 50)
    self.spr_map_bg1:addChild(spine_grass_2, 10)

    -- 添加树丛骨骼动画
    local spine_grass_3 = sp.SkeletonAnimation:create("spine/t3.json", "spine/t3.atlas", 1)
    spine_grass_3:setAnimation(0, "act1", true)
    spine_grass_3:setPosition(1240, 300)
    self.spr_map_bg1:addChild(spine_grass_3, 10)

    local spine_grass_4 = sp.SkeletonAnimation:create("spine/t4.json", "spine/t4.atlas", 1)
    spine_grass_4:setAnimation(0, "act1", true)
    spine_grass_4:setPosition(1280, 290)
    self.spr_map_bg1:addChild(spine_grass_4, 0)

    -- 添加房顶旗帜骨骼
    -- local spine_flag_1 = sp.SkeletonAnimation:create("spine/t5.json","spine/t5.atlas", 1)
    -- spine_flag_1:setAnimation(0, "act1", true);
    -- spine_flag_1:setPosition(525, 482)
    -- self.spr_map_bg2:addChild(spine_flag_1, 0)

    -- local spine_smoke = sp.SkeletonAnimation:create("spine/g.json","spine/g.atlas", 1)
    -- spine_smoke:setAnimation(0, "act1", true);
    -- spine_smoke:setPosition(290, 310)
    -- self.spr_map_bg2:addChild(spine_smoke, 0)

    -- cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_BGR_A8888)
    -- 添加彩虹骨骼
    local spine_rainbow = sp.SkeletonAnimation:create("spine/chaihong.json", "spine/chaihong.atlas", 1)
    spine_rainbow:setAnimation(0, "act1", true)
    spine_rainbow:setPosition(1510, 350)
    self.spr_map_bg2:addChild(spine_rainbow, 0)
    -- cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_BGR_A8888)

    -- 添加黑洞骨骼
    local spine_blackhole = sp.SkeletonAnimation:create("spine/heidong.json", "spine/heidong.atlas", 1)
    spine_blackhole:setAnimation(0, "act1", true)
    spine_blackhole:setPosition(60, 300)
    self.spr_map_bg1:addChild(spine_blackhole, 0)

    -- 添加紫色蝴蝶骨骼
    local spine_butterfly = sp.SkeletonAnimation:create("spine/hudie.json", "spine/hudie.atlas", 1)
    spine_butterfly:setAnimation(0, "act1", true)
    spine_butterfly:setPosition(390, 215)
    self.spr_map_bg1:addChild(spine_butterfly, 0)

    -- 添加⛲️骨骼
    local spine_spring = sp.SkeletonAnimation:create("spine/penquan.json", "spine/penquan.atlas", 1)
    spine_spring:setAnimation(0, "act1", true)
    spine_spring:setPosition(312, 390)
    self.spr_map_bg1:addChild(spine_spring, 0)

    -- 添加铁匠房子门口发光骨骼
    local spine_smith_light = sp.SkeletonAnimation:create("spine/tiejiangguang.json", "spine/tiejiangguang.atlas", 1)
    spine_smith_light:setAnimation(0, "act1", true)
    spine_smith_light:setPosition(335, 205)
    self.spr_map_bg2:addChild(spine_smith_light, 0)

    -- 添加铁匠烟囱烟雾骨骼
    local spine_smith_smoke = sp.SkeletonAnimation:create("spine/yanwu.json", "spine/yanwu.atlas", 1)
    spine_smith_smoke:setAnimation(0, "act1", true)
    spine_smith_smoke:setPosition(300, 300)
    self.spr_map_bg2:addChild(spine_smith_smoke, 0)

    -- 添加尖顶房烟囱烟雾骨骼
    local spine_house_smoke = sp.SkeletonAnimation:create("spine/yanwu.json", "spine/yanwu.atlas", 1)
    spine_house_smoke:setAnimation(0, "act1", true)
    spine_house_smoke:setScale(0.5)
    spine_house_smoke:setPosition(855, 410)
    self.spr_map_bg1:addChild(spine_house_smoke, 0)

    -- 添加风车烟囱烟雾骨骼
    local spine_windmill_smoke = sp.SkeletonAnimation:create("spine/yanwu.json", "spine/yanwu.atlas", 1)
    spine_windmill_smoke:setAnimation(0, "act1", true)
    spine_windmill_smoke:setScale(0.75)
    spine_windmill_smoke:setPosition(1575, 560)
    self.spr_map_bg2:addChild(spine_windmill_smoke, 0)

    -- 添加流水骨骼
    local spine_water = sp.SkeletonAnimation:create("spine/liushui.json", "spine/liushui.atlas", 1)
    spine_water:setAnimation(0, "act1", true)
    spine_water:setPosition(1085, 214)
    self.spr_map_bg2:addChild(spine_water, 0)

    -- 添加风车骨骼
    local spine_wind_mill = sp.SkeletonAnimation:create("spine/windmill.json", "spine/windmill.atlas", 1)
    spine_wind_mill:setAnimation(0, "stand", true)
    spine_wind_mill:setPosition(1615, 515)
    self.spr_map_bg2:addChild(spine_wind_mill, 0)
end

function MainCityLayer:addButterflyAction()
    local butterfly_pos_list = {}
    table.insert(butterfly_pos_list, {self.spr_map_bg1, 210, 370, 0.5})
    table.insert(butterfly_pos_list, {self.spr_map_bg1, 690, 130, 0.5})
    table.insert(butterfly_pos_list, {self.spr_map_bg1, 715, 300, 0.5})
    table.insert(butterfly_pos_list, {self.spr_map_bg1, 920, 135, 0.5})
    table.insert(butterfly_pos_list, {self.spr_map_bg1, 980, 180, 0.5})
    table.insert(butterfly_pos_list, {self.spr_map_bg1, 1460, 400, 0.5})

    table.insert(butterfly_pos_list, {self.spr_map_bg2, 435, 160, 0.5})
    table.insert(butterfly_pos_list, {self.spr_map_bg2, 540, 210, 0.5})
    table.insert(butterfly_pos_list, {self.spr_map_bg2, 1505, 420, 0.5})
    table.insert(butterfly_pos_list, {self.spr_map_bg2, 1530, 375, 0.5})

    local butterfly_nums = 2 + math.random(1, 3)
    -- print("get butterfly_nums: ", butterfly_nums)
    local butterfly_pos_idx_list = {}
    local cur_num = 0
    for i = 1, 10000 do
        local cur_idx = math.random(1, #butterfly_pos_list)
        local is_have = false
        for i, v in ipairs(butterfly_pos_idx_list) do
            if v == cur_idx then
                is_have = true
                break
            end
        end
        if is_have == false then
            -- print("get idx: ", cur_idx)
            table.insert(butterfly_pos_idx_list, cur_idx)

            cur_num = cur_num + 1
            if cur_num >= butterfly_nums then
                break
            end
        end
    end

    for i, v in ipairs(butterfly_pos_idx_list) do
        local x, y, scale, parent = butterfly_pos_list[v][2], butterfly_pos_list[v][3], butterfly_pos_list[v][4], butterfly_pos_list[v][1]
        local spr_effect = ex.EffectCtr:playNormalEff(4, x, y, nil, parent, 10)
        spr_effect:setScale(scale)

        local action_move = cc.Sequence:create(cc.MoveBy:create(2, cc.p(0, 10)), cc.MoveBy:create(2, cc.p(0, -10)), nil)
        spr_effect:runAction(cc.RepeatForever:create(action_move))
    end
end

function MainCityLayer:onExit()
    -- 移除层定时器
    self:removeTimerByName("timer")

    ex.EffectCtr:removeAllEffFromLayer(self)
end

function MainCityLayer:registerEvent()
    -- body
    --装备合成
    self:addEvent(EVENT.MAKE_EQUIP_EVENT.MAKE_EQUIP_WITH_UPDATE, handler(self, self.onInitRedPoint))
    self:addEvent(EVENT.BACK_PACK_EVENT.BACKPACK_INIT_FINISH, handler(self, self.onInitRedPoint))
end

function MainCityLayer:addKeepLayer(layer_type, layer)
    -- 检查重复。
    local tmp_layer = self.vec_keep_layer[layer_type]
    self.vec_keep_layer[layer_type] = layer
    return tmp_layer
end

function MainCityLayer:getKeepLayer(layer_type)
    return self.vec_keep_layer[layer_type]
end

function MainCityLayer:removeKeepLayer(layer_type, auto_remove)
    local tmp_layer = self.vec_keep_layer[layer_type]
    if auto_remove and tmp_layer then
        tmp_layer:removeFromParent()
    end
    self.vec_keep_layer[layer_type] = nil
end

function MainCityLayer:onInitRedPoint(event, data)
    local tab_main_city = ex.MainCityTable.data

    for i, v in ipairs(tab_main_city) do
        local idx = v.idx
        if v.reddot ~= "" then
            if v.checkreddot ~= "" then
                local bool = self[v.checkreddot]()
                local reddot = tonumber(v.reddot)
                ex.RedDotManager:setRedNodeVisible(reddot, bool)
            end
        end
    end
end

function MainCityLayer:creatHeroRed()
    return ex.Player.hero_data.promote:checkCreatHeroRedPoint()
end

function MainCityLayer:creatSmithShopRed()
    local bool = false
    for i = 1, EquipMaxCount do
        bool = ex.Player.hero_data.equip:getEquipRedPointByPlace(i)
        if bool == true then
            break
        end
    end
    return bool
end

function MainCityLayer:createSummonRed()
    return ex.Player.summon_data:checkRedDot()
end

function MainCityLayer:checkBlessingPoolRedDot()
    return ex.Player.blessing_pool:checkBlessingPoolRedDot()
end

function MainCityLayer:checkRedPointByMainCity()
    return ex.Player.heroarrive_data:checkRedPointByMainCity()
end

function MainCityLayer:onSelectDungeonHeroDone(vec_battle, fetters_type)
    local vec_hero = {}
    for k, v in pairs(vec_battle) do
        local data = {}
        data.hero_id = v
        data.hp = 10000
        table.insert(vec_hero, data)
    end

    local has_hero =
        TableEx.isInTableFunction(
        vec_hero,
        function(value)
            if value.hero_id ~= NULL_ID then
                return true
            end
            return false
        end,
        fetters_type
    )

    if not has_hero then
        ex.MessageView:add(ex.Tools:getLang(47475))
        return
    end

    ex.Player.lineup_data:setLineup(LineupType.DUNGEON, vec_hero)
    ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_DUNGEON)
end

function MainCityLayer:onGM(tag, pSender)
    require("src.layer.GMCtr"):instance():openWindow()
end

function MainCityLayer:onEdit(tag, pSender)
    ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_EDIT)
end

function MainCityLayer:onTest()
    -- local name = "MainCityLayer:onEdit"
    -- local preLayer = ex.MainSceneCtr:getMainScene():getChildByName(name);
    -- if preLayer then
    --     preLayer:removeFromParent();
    -- end
    
    -- ex.Tools.startClock()
    -- local layer = require("src.layer.herolist.HeroListLayerTest"):create()
    -- layer:setPosition(cc.p(0, 0))
    -- layer:setName(name);
    -- ex.MainSceneCtr:getMainScene():addChild(layer)
    
    -- ex.MessageView:add(ex.Tools:markClock())

    require("src.layer.heromagicwand.HeroMagicWandWearCtr"):instance():openWindow()
    
end

function MainCityLayer:updateSummonTip()
    for i = 1, 4 do
        local menu = self["menu" .. i]
        if menu then
            local item = menu:getChildByName("main_summon")
            if item then
                item:removeChildByName("spr_summon_tip")

                local spr_tip = cc.Sprite:createWithSpriteFrameName("main-city/spr-tip-summon.png")
                spr_tip:setAnchorPoint(0.6, 0)
                spr_tip:setPosition(item:getContentSize().width * 0.15, item:getContentSize().height * 0.8)
                spr_tip:setName("spr_summon_tip")
                spr_tip:setVisible(ex.Player.summon_data:isVisibleTipSummon())
                item:addChild(spr_tip, 100)
            end
        end
    end
end

function MainCityLayer:updateIdleTip()
    if self.is_show_idle_tip or ex.Player.chapter_data.res_reward_time <= 0 then
        return
    end

    self.is_show_idle_tip = true

    local time_diff = ex.Game:getServerTime() - (ex.Player.chapter_data.res_reward_time or 0)
    if time_diff > ex.Player.chapter_data.max_reward_time * 0.5 and require("src.layer.guide.GuideCtr").isExecutingGuide() == false then
        -- ex.ConfirmCtr:openWindow(
        --     ex.Tools:getLang(3500),
        --     ex.Tools:getLang(41320),
        --     function()
        --         ex.JumpManager:jumpByAtom("main_battle")
        --     end,
        --     ex.Tools:getLang(3601)
        -- )
        require("src.layer.LineRevenueCtr"):instance():openWindow()
    end
end

function MainCityLayer:_update(dt)
    local mainMapSize = self.spr_map_bg1:getContentSize()
    for i, v in ipairs(self._movingHeroes) do
        v:setLocalZOrder(1000000 - v:getPositionY())
        local diffY = mainMapSize.height - v:getPositionY()
        local yFactor = diffY / mainMapSize.height
        local scale = 0.6 + (0.4 * MOVING_SPINE_SCALE * yFactor)
        if v:getScaleX() > 0 then
            v:setScale(scale)
        else
            v:setScaleX(-scale)
            v:setScaleY(scale)
        end
    end
end

---------- start mark: 人物走动逻辑 ----------
function MainCityLayer:_spineRandomMove()
    for i, v in ipairs(movableAreaInfos) do
        local heroes = v.heroes

        if v.isRandom then
            heroes = {}
            for i = 1, math.random(v.randomCount) do
                table.insert(heroes, v.heroes[math.random(#v.heroes)])
            end
        end

        for i, heroName in ipairs(heroes) do
            local spine = sp.SkeletonAnimation:create(heroName .. ".json", heroName .. ".atlas", MOVING_SPINE_SCALE)
            local pos = cc.p(0, 0)
            if v.type == "line" then
                pos = self:_genPositionInLine(v.data.spos, v.data.epos)
            elseif v.type == "rect" then
                pos = self:_genPositionInRect(v.data)
            end
            spine:setAnimation(0, "stand", true)
            spine:setPosition(pos)
            self._movableLayer:addChild(spine)
            self:_nextActionForRandomMove(spine, v)

            table.insert(self._movingHeroes, spine)
        end
    end
end

function MainCityLayer:_nextActionForRandomMove(spine, areaInfo)
    local actions = {
        function(_spine, _areaInfo, nextHandler)
            self:_idleActionForRandomMove(_spine, _areaInfo, nextHandler)
        end,
        function(_spine, _areaInfo, nextHandler)
            self:_moveActionForRandomMove(_spine, _areaInfo, nextHandler)
        end
    }

    local nextHandler = nil
    nextHandler = function()
        local nextActionIdx = math.random(#actions)
        actions[nextActionIdx](spine, areaInfo, nextHandler)
    end

    nextHandler()
end

function MainCityLayer:_idleActionForRandomMove(spine, areaInfo, nextHandler)
    spine:setAnimation(0, "stand", true)
    local idleTime = math.random(MIN_IDLE_TIME, MAX_IDLE_TIME)
    local action = cc.Sequence:create(cc.DelayTime:create(idleTime), cc.CallFunc:create(nextHandler), nil)
    spine:runAction(action)
end

function MainCityLayer:_moveActionForRandomMove(spine, areaInfo, nextHandler)
    spine:setAnimation(0, "run", true)
    if areaInfo.type == "line" then
        self:_lineMoveForRandomMove(spine, areaInfo.data, nextHandler)
    elseif areaInfo.type == "rect" then
        self:_rectMoveForRandomMove(spine, areaInfo.data, nextHandler)
    end
end

function MainCityLayer:_lineMoveForRandomMove(spine, areaData, nextHandler)
    local pos = self:_genPositionInLine(areaData.spos, areaData.epos)
    local dist = cc.pGetDistance(pos, cc.p(spine:getPositionX(), spine:getPositionY()))
    local t = dist / (math.random(MIN_MOVE_SPEED, MAX_MOVE_SPEED))
    self:_setFaceForRandomMove(spine, pos)
    local action = cc.Sequence:create(cc.MoveTo:create(t, pos), cc.CallFunc:create(nextHandler), nil)
    spine:runAction(action)
end

function MainCityLayer:_rectMoveForRandomMove(spine, areaData, nextHandler)
    local pos = self:_genPositionInRect(areaData)
    local dist = cc.pGetDistance(pos, cc.p(spine:getPositionX(), spine:getPositionY()))
    local t = dist / (math.random(MIN_MOVE_SPEED, MAX_MOVE_SPEED))
    self:_setFaceForRandomMove(spine, pos)
    local action = cc.Sequence:create(cc.MoveTo:create(t, pos), cc.CallFunc:create(nextHandler), nil)
    spine:runAction(action)
end

function MainCityLayer:_setFaceForRandomMove(spine, endPos)
    local spX = spine:getPositionX()
    if spX < endPos.x then
        spine:setScaleX(1)
    else
        spine:setScaleX(-1)
    end
end

function MainCityLayer:_genPositionInLine(spos, epos)
    local x = math.random(epos.x, spos.x)
    local y = ((x - spos.x) / (epos.x - spos.x)) * (epos.y - spos.y) + spos.y

    return cc.p(x, y)
end

function MainCityLayer:_genPositionInRect(rect)
    local x = rect.x + math.random(rect.width) - 1
    local y = rect.y + math.random(rect.height) - 1

    return cc.p(x, y)
end

function MainCityLayer:_calcDistForRandomMove(spos, epos)
    return cc.pGetDistance(spos, epos)
end
---------- end mark: 人物走动逻辑 ----------

function MainCityLayer:changeLayerInEnd()




    if self.map_size == nil then
        return
    end

    -- 重新计算位置偏移
    local getAbsolutePosition = function(cn, position)
        local ret = position
        while(cn:getParent() ~= nil) do
            cn = cn:getParent()
            ret.x = ret.x + cn:getPositionX()
            ret.y = ret.y + cn:getPositionY()
        end
        return ret
    end

    local getParallaxChildPosition = function(parallax, ratio, offset)
        local pos = getAbsolutePosition(parallax, cc.p(parallax:getPositionX(), parallax:getPositionY()))
        local x = -pos.x + pos.x * ratio.x + offset.x;
        local y = -pos.y + pos.y * ratio.y + offset.y;
        return cc.p(x, y)
    end

    local pos1 = getParallaxChildPosition(self.node_parallax, cc.p(self.spr_map_bg1.move_speed, 1), cc.p(0, 0))
    self.scroll_view:setContentOffset(cc.p(self.scroll_view:getViewSize().width - self.scroll_view:getContentSize().width, 0))
    local pos2 = getParallaxChildPosition(self.node_parallax, cc.p(self.spr_map_bg1.move_speed, 1), cc.p(self.map_size.width, 0))

    -- dump(getParallaxChildPosition(self.node_parallax, cc.p(1.3, 1), cc.p(0, 0)))
    -- dump(getParallaxChildPosition(self.node_parallax, cc.p(1.3, 1), cc.p(self.map_size.width, 0)))
    self.spr_map_bg1_1:setPositionX(-pos1.x)
    self.spr_map_bg1_2:setPositionX(self.map_size.width + self.map_size.width - pos2.x)


    -- 居中显示地图
    local offset_x = -(self.scroll_view:getContentSize().width * 0.5 - self.scroll_view:getViewSize().width * 0.5)
    offset_x = math.min(0, offset_x)
    self.scroll_view:setContentOffset(cc.p(offset_x, 0))

    self.map_size = nil
end


return MainCityLayer
