
local MainScene = class("MainScene", require("src.comp.EventLayer"))

local MainSceneCtr = class("MainSceneCtr", require("src.scene.SceneCtr"))
local MainTouchEffectLayer = class("MainTouchEffectLayer", function()
                              return cc.Layer:create()
                            end)

local game = require("src.model.Game"):instance()

local scale_auto = math.min(1, ex.p.width / 640)

function MainTouchEffectLayer:ctor()
    --创建一个单点事件监听
    self.listener_touch = cc.EventListenerTouchOneByOne:create()  
    self.listener_touch:setSwallowTouches(false)
    self.listener_touch:registerScriptHandler(function()
        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN)

    self.listener_touch:registerScriptHandler(function()
    end, cc.Handler.EVENT_TOUCH_MOVED)

    self.listener_touch:registerScriptHandler(function(touch, event)
        local pos = touch:getLocation()

        local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_touch")
        spr_effect:setPosition(pos)
        self:addChild(spr_effect)

        local gl_program = cpp.ShaderFactory:instance():getGLProgram(ShaderType.ST_POSITION_TEXTURE_DEFAULT_HIGHP)
        spr_effect:setGLProgram(gl_program)
    end, cc.Handler.EVENT_TOUCH_ENDED)

    local event_dispatcher = self:getEventDispatcher() 
    -- event_dispatcher:addEventListenerWithSceneGraphPriority(self.listener_touch, self)
    event_dispatcher:addEventListenerWithFixedPriority(self.listener_touch, -999999999)

    self:registerScriptHandler(function(event)
        if event == "exit" then
            event_dispatcher:removeEventListener(self.listener_touch)
		end
	end)
end

function MainScene:onCreate()
	self.cur_main_layer = nil
	self.tmp_main_layer = nil
	self.menu_scale = nil
	self.main_layer = nil
    self.is_changing = false
    self.online_time = ex.Game:getServerTime()

    local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/main-scene-lang.plist")

    local win_size = cc.Director:getInstance():getWinSize()

    self:setContentSize(win_size)

    local reverse_scale = 0.5
    local notch_height = require("src.model.Game"):instance():getNotchHeight()
    local main_ctr = require("src.scene.MainSceneCtr"):instance()

    -- 加入主场景其他元素
    self.main_layer = cc.Layer:create()
	self.main_layer:setAnchorPoint(cc.p(0, 0))
    self.main_layer:setPosition(cc.p(0, 0))
    self.main_layer:setName("main_layer")
    self:addChild(self.main_layer, 20)

    -- 主场景菜单
	local main_menu = cpp.UIMenu:create()
    main_menu:setPosition(cc.p(0, 0))
    self.main_layer:addChild(main_menu, 100)
    -- -- 添加主背景
    -- local bg = cc.Sprite:create("ccbi-res/map-bg-main-scene.jpg")
    -- bg:setScaleX(win_size.width / bg:getContentSize().width)
    -- bg:setScaleY(win_size.height / bg:getContentSize().height)
    -- bg:setAnchorPoint(cc.p(0, 0))
    -- bg:setPosition(cc.p(0, 0))
    -- bg:setName("main_scene_bg")
    -- self:addChild(bg, -10)

    local spr_bottom_bg = cc.Sprite:createWithSpriteFrameName("main-scene/spr-bottom-bg.png")
    spr_bottom_bg:setScale(win_size.width / spr_bottom_bg:getContentSize().width)
    spr_bottom_bg:setAnchorPoint(cc.p(0.5, 0))
    spr_bottom_bg:setPosition(win_size.width / 2, 0)
    self:addChild(spr_bottom_bg, 10)

    -- 添加角色上方的角色信息控件
	self.spr_up_bg = cc.Sprite:createWithSpriteFrameName("main-scene/spr-up-bg.png")
    self.spr_up_bg:setScale(win_size.width / self.spr_up_bg:getContentSize().width)
    self.spr_up_bg:setPosition(win_size.width / 2, win_size.height - notch_height)
    self.main_layer:addChild(self.spr_up_bg, 10)

	local top_scale = self.spr_up_bg:getScale()

    -- 角色能量显示
    local res_scale = 0.8
    local res_offset_x = -45
    local add_offset_x = 46

    local node_attack = cc.Node:create()
    node_attack:setScale(scale_auto)
    node_attack:setPosition(win_size.width * 0.445, win_size.height - 30 - notch_height)
    self.main_layer:addChild(node_attack, 30)

	local spr_attack_bg = cc.Sprite:createWithSpriteFrameName("main-scene/spr-res-bg.png")
    node_attack:addChild(spr_attack_bg, 20)


	local icon_attack = cc.Sprite:createWithSpriteFrameName("res-icon/attack-1.png");
    icon_attack:setPosition(res_offset_x, 0);
    node_attack:addChild(icon_attack, 30);


	self.lbl_attack = cc.Label:createWithTTF("0", FONT_DEFAULT_NAME_BOLD, 36)
    self.lbl_attack:enableOutline(cc.c4b(0, 0, 0, 255), 2)
    self.lbl_attack:setScale(0.5)
    self.lbl_attack:setPosition(spr_attack_bg:getPositionX() + 7.5, spr_attack_bg:getPositionY() - 1)
    node_attack:addChild(self.lbl_attack, 30)

    -- 添加角色等级
    self.spr_head_frame = cc.Sprite:createWithSpriteFrameName(ex.Tools:getBorderIconByIdx(ex.Player.border_id));
    self.spr_head_frame:setScale(top_scale);
    self.spr_head_frame:setPosition(win_size.width * 0.065, win_size.height - 80 + (49 - notch_height));
    self.main_layer:addChild(self.spr_head_frame, 20);

	self.spr_head = cc.Sprite:createWithSpriteFrameName("head-icon/0.png");
    self.spr_head:setScale(top_scale * 0.8);
    self.spr_head:setName("spr_head");
    self.spr_head:setPosition(self.spr_head_frame:getPosition());
    self.main_layer:addChild(self.spr_head, 19);

	local spr_nick_bg = cc.Sprite:createWithSpriteFrameName("main-scene/spr-name-bg-1.png");
    spr_nick_bg:setAnchorPoint(cc.p(0, 0.5));
    spr_nick_bg:setScale(top_scale * res_scale);
    spr_nick_bg:setPosition(self.spr_head_frame:getPositionX() + 25 * self.spr_head_frame:getScale(),
                            node_attack:getPositionY());
    self.main_layer:addChild(spr_nick_bg, 10);

    -- 添加角色昵称
    self.lbl_role_nick = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 23);
    self.lbl_role_nick:enableShadow(cc.c4b(0, 0, 0, 255), cc.size(1, -2));
    self.lbl_role_nick:setAnchorPoint(cc.p(0, 0.5));
    self.lbl_role_nick:setPosition(spr_nick_bg:getPositionX() + 30 * spr_nick_bg:getScale(), spr_nick_bg:getPositionY())
    self.lbl_role_nick:setScale(top_scale * res_scale);
    self.main_layer:addChild(self.lbl_role_nick, 20);

    local spr_level_bg = cc.Sprite:createWithSpriteFrameName("main-scene/spr-level-bg.png");
    spr_level_bg:setPosition(self.spr_head_frame:getPositionX(), self.spr_head_frame:getPositionY() - 40 * self.spr_head_frame:getScale())
    self.main_layer:addChild(spr_level_bg, 20);

	self.lbl_level = cc.Label:createWithBMFont("font/40.fnt", "0");
    self.lbl_level:setPosition(spr_level_bg:getPosition());
    self.main_layer:addChild(self.lbl_level, 20);

	local btn_role_info = cpp.UIMenuItemImage:create()
    btn_role_info:setContentSize(cc.size(self.spr_head_frame:getContentSize().width * 0.7, self.spr_head_frame:getContentSize().height * 0.7))
    btn_role_info:setAnchorPoint(self.spr_head_frame:getAnchorPoint())
    btn_role_info:setPosition(self.spr_head_frame:getPosition())
    btn_role_info:registerScriptTapHandler(handler(main_ctr, main_ctr.onRole))
    main_menu:addChild(btn_role_info)

    local spr_progress_exp_bg = cc.Sprite:createWithSpriteFrameName("main-scene/progress-role-exp-bg.png");
    spr_progress_exp_bg:setScale(top_scale);
    spr_progress_exp_bg:setPosition(win_size.width * 0.5, node_attack:getPositionY() + 25);
    spr_progress_exp_bg:setName("spr_progress_exp_bg");
    self.main_layer:addChild(spr_progress_exp_bg, 19);

    -- 进度条
    self.progress_exp = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("main-scene/progress-role-exp.png"))
    self.progress_exp:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.progress_exp:setMidpoint(cc.p(0, 0.5))
    self.progress_exp:setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.progress_exp:setPosition(spr_progress_exp_bg:getPositionX(), spr_progress_exp_bg:getPositionY() + 1)
    self.progress_exp:setScale(spr_progress_exp_bg:getScale())
    self.main_layer:addChild(self.progress_exp, 19)

	self.menu_scale = cpp.UIMenu:create()
    self.menu_scale:setPosition(cc.p(0, 0))
    self.menu_scale:setTag(10)
    self.menu_scale:setName("menu_scale")
    self.main_layer:addChild(self.menu_scale, 20)

    -- 底部按钮配置表
    local vec_item = {
    	{img = "main-scene-lang/spr-city", lbl="main-scene-lang/lbl-city.png", name="spr_city", level_need = 0, layer_type = MainSceneType.MAINCITY_LAYER, reddot = RedDotType.ZCJ_DHZC},
		{img = "main-scene-lang/spr-hero", lbl="main-scene-lang/lbl-hero.png", name = "spr_hero", level_need = 0, layer_type = MainSceneType.HERO_LAYER, reddot = RedDotType.ZCJ_DHYX},
		{img = "main-scene-lang/spr-backpack", lbl="main-scene-lang/lbl-backpack.png", name = "spr_backpack", level_need = 0, layer_type = MainSceneType.BACKPACK_LAYER, reddot = RedDotType.ZCJ_DHBB},
		{img = "main-scene-lang/spr-battle", lbl="main-scene-lang/lbl-battle.png", name = "spr_battle", level_need = 0, layer_type = MainSceneType.MLT_BATTLE, reddot = RedDotType.ZCJ_DHZD},
        {img = "main-scene-lang/spr-skin", lbl="main-scene-lang/lbl-skin.png", name = "spr_mission", level_need = cfg.opencondition.condition["main_mission_hall"].condition_value, layer_type = MainSceneType.MAINCITY_SLZM, reddot = RedDotType.ZCJ_DHFB},
        {img = "main-scene-lang/spr-clan", lbl="main-scene-lang/lbl-clan.png", name = "spr_clan", level_need = cfg.opencondition.condition["main_clan"].condition_value, layer_type = MainSceneType.CLAN, reddot = RedDotType.ZCJ_DHGH},
        {img = ex.Player.fetter_data:isUnlockAll() and "main-scene/spr-fetter" or  "main-scene/spr-fetters-unlock", level_need = 0, name = "spr_fetter", lbl= ex.Player.fetter_data:isUnlockAll() and "main-scene-lang/lbl-fetter.png" or "main-scene-lang/lbl-fetters-unlock.png" , name = "sys_fetter", layer_type = ex.Player.fetter_data:isUnlockAll() and MainSceneType.FETTER_INFO or MainSceneType.FETTER_MAIN_VIEW, reddot = RedDotType.ZCJ_DHJB},
    }

	-- 如果按钮长度超出屏幕上限，则缩小按钮初始缩放
    local icon_scale = 1
    local text_scale = 1
    local size_item = cc.Sprite:createWithSpriteFrameName("main-scene/scale-bar-1.png"):getContentSize()
	local o_scale = win_size.width * 0.9 / (size_item.width * math.max(table.nums(vec_item), 6))   --spr_bottom_bg:getScale() * 1.5
    size_item.width = size_item.width * o_scale
	size_item.height = size_item.height * o_scale
    local begin_x = win_size.width * 0.5 - (table.nums(vec_item)) * size_item.width * 0.5 - size_item.width * 0.5 * 0.375

	self.vec_reddot_item = {}
    -- local reddot_manager = ex.RedDotManager

    local last_pos_x = begin_x

    for i,v in ipairs(vec_item) do
        local item_scale = "main-scene/scale-bar-1.png"

        local item = cpp.UIMenuItemScale:create("main-scene/scale-bar-1.png",
                                                "main-scene/scale-bar-1.png",
                                                1, nil)
        item.layer_type = v.layer_type
        item:setTag(100 * math.floor(v.layer_type / 100000))
        item:setOScale(o_scale * 1.5);
    	item:setName(v.name)
        item:setInitPos(cc.p(last_pos_x + item:getContentSize().width * o_scale / 2, -11));
        last_pos_x = last_pos_x + item:getContentSize().width * o_scale
        item:registerScriptTapHandler(handler(main_ctr, main_ctr.onChangeLayer))
        self.menu_scale:addChild(item);


        if v.img == "main-scene/spr-city.png" then
            item:setChecked(true)
        end

        local str_icon = (v.level_need > ex.Player.level) and v.img.."-2.png" or v.img..".png"
        local spr_icon = cc.Sprite:createWithSpriteFrameName(str_icon)
        spr_icon.icon_name = v.img
    	spr_icon:setName("icon")
    	spr_icon:setPosition(cc.p(item:getContentSize().width * 0.5, item:getContentSize().width * 0.6 - 4))
        spr_icon:setScale(icon_scale)
    	item:addChild(spr_icon, 15)

        print(v.lbl)
		local spr_text = cc.Sprite:createWithSpriteFrameName(v.lbl)
        spr_text:setName("lbl")
    	spr_text:setPosition(cc.p(item:getContentSize().width * 0.5, item:getContentSize().height * 0.2 + 5))
    	spr_text:setScale(text_scale)
        item:addChild(spr_text, 20)
        
        -- 加入等级限制提示
        item.level_need = v.level_need
        if v.level_need > ex.Player.level then
            item.lbl_level_limit = cc.Label:createWithTTF(string.format(ex.Tools:getLang(47074), v.level_need), FONT_DEFAULT_NAME_BOLD, 36)
            -- item.lbl_level_limit:setColor(FONT_LIGHT_YELLOW)
            item.lbl_level_limit:enableOutline(ex.c3b.BLUE, 2)
            item.lbl_level_limit:setScale(0.5)
            item.lbl_level_limit:setPosition(item:getContentSize().width / 2, item:getContentSize().height * 0.45 + 2)
            item:addChild(item.lbl_level_limit, 50)

            -- item:setGray(true)
        end

    	if v.reddot then
			ex.RedDotManager:setStickNode(v.reddot, item)
			self.vec_reddot_item[v.reddot] = item
    	end
    end

    self:addEvent(EVENT.MAIN_DX_EVENT.CHANGE_ICON,handler(self,self.onChangeDXIcon))

    -- 隔离层，使聊天按钮拖动时，触摸事件不会分发到下一层
    self.layer_isolate = cc.Layer:create()
    self.layer_isolate:setSwallowsTouches(true)
    self.layer_isolate:setVisible(false)
    self.main_layer:addChild(self.layer_isolate, 119)
    self.layer_isolate.listener_touch = cc.EventListenerTouchOneByOne:create()  --创建一个单点事件监听
    self.layer_isolate.listener_touch:setSwallowTouches(false)
    self.layer_isolate.listener_touch:registerScriptHandler(function(touch, event)
        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN )
    local event_dispatcher = self:getEventDispatcher() 
    event_dispatcher:addEventListenerWithSceneGraphPriority(self.layer_isolate.listener_touch, self.layer_isolate)

    -- 场景聊天按钮menu
	self.menu_chat = require("src.comp.menu.UIMenu"):create()
    self.menu_chat:setSwallowsTouches(false)
    self.menu_chat:setPosition(cc.p(0, 0))
    self.main_layer:addChild(self.menu_chat, 120)

    -- 开启menu的移动和移动结束侦听
    self.menu_chat:enableExchange(true, true)
    self.menu_chat:setTouchMoveCallback(handler(self, self.onBtnChatMove))
    self.menu_chat:setTouchEndCallback(handler(self, self.onBtnChatMoveEnd))

    -- local bottom_height = main_ctr:getMenuScaleHeight()

    -- 创建聊天按钮
    self.btn_chat = cpp.UIMenuItemImage:createWithSpriteFrameName("main-city/btn-chat-1.png", nil, nil)
    self.btn_chat:setPosition(win_size.width - 40, 135 + 400)
    self.btn_chat:registerScriptTapHandler(handler(self, self.onChat))
    self.btn_chat:setName("main_chat")
    self.menu_chat:addChild(self.btn_chat)
    self.btn_chat:setTag(3)

    -- 延时10秒刷新
    self.reset_time = ex.Game:getServerTime() + GetSystemResetTime() + 10
    self.scheduler_reset = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.updateTimer), 1, false)

    self.scheduler_res_change = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.updateResEvent), 0.1, false)
    self:addEvent(EVENT.BORDER_EVENT.USE_UPDATE, handler(self,self.onChangeHeadFrame))
    self:addEvent(EVENT.BORDER_EVENT.HEAD_USE_UPDATE, handler(self,self.onChangeHead))
    self:addEvent(EVENT.BATTLE_EVENT.STATUS_CHANGE, handler(self,self.updateBattleBtn))
    self:addEvent(EVENT.BACKPACK_RES_CHANGE.ROLE_LEVEL, handler(self,self.updateLevel))
    self:addEvent(EVENT.BACKPACK_RES_CHANGE.CHANGE_ITEM, handler(self,self.updateResNum))
    self:addEvent(EVENT.MAIN_SCENE.UPDATE_FIGHTING, handler(main_ctr, main_ctr.setBattle))
    
    self:addRedDotNode(RedDotType.ZCJ_LTDC_ZCLTAN, self.btn_chat)

    self:updateNodeRes()

    -- -- 检查服务器版本
    -- local asset_manager = require("src.model.AssetManager"):instance()
    -- asset_manager.comp_version_callback = handler(self, self.onNewVersion)

    -- -- 重新打包后。可以删除该判断
    -- if asset_manager.checkNowVersion and cpp.SocialPlatform:instance():getPlatformStr() ~= "2" then
    --     asset_manager:checkNowVersion()
    -- end


    -- --创建一个协程
    -- co = coroutine.wrap(
	--     function (i)
    --         ex.Tools:startClock()
    --         local server_data = cc.FileUtils:getInstance():getStringFromFile(cc.FileUtils:getInstance():getWritablePath() .. "resversion.rvs")
    --         local local_data = cc.FileUtils:getInstance():getStringFromFile(cc.FileUtils:getInstance():getWritablePath() .. "resversion.rvs" .. ".pre")
    --         ex.Tools:markClock()
        
    --         server_data = json.decode(server_data)
    --         -- local_data = json.decode(local_data)
    --         ex.Tools:markClock()
	--     end
    -- )

    -- --开启协程
    -- co(1)


    -- local_data = nil
    -- server_data = nil
    -- ex.Tools:markClock()
    

end

-- 更新资源节点显示，如果res_type_1为空，则显示默认
function MainScene:updateNodeRes(res_type_1, res_type_2)
    if res_type_1 == nil then
        res_type_1 = 900001
        res_type_2 = 900002
    end

    local res_offset_x = -45
    local add_offset_x = 46
    local win_size = cc.Director:getInstance():getWinSize()
    local notch_height = require("src.model.Game"):instance():getNotchHeight()
    local main_ctr = require("src.scene.MainSceneCtr"):instance()

    -- 角色第一个资源节点显示
    if self.node_res_1 == nil then

        self.node_res_1 = cc.Node:create()
        self.node_res_1:setPosition(win_size.width * 0.629,
                                    win_size.height - 30 - notch_height)
        self.node_res_1:setScale(scale_auto)
        self.main_layer:addChild(self.node_res_1, 20)

        self.node_res_1.spr_bg = cc.Sprite:createWithSpriteFrameName("main-scene/spr-res-bg.png")
        self.node_res_1.spr_bg:setPosition(0, 0)
        self.node_res_1:addChild(self.node_res_1.spr_bg, 20)

        self.node_res_1.icon = cc.Sprite:createWithSpriteFrameName("backpack/"..res_type_1..".png")
        self.node_res_1.icon:setScale(0.40)
        self.node_res_1.icon:setPosition(res_offset_x, 0)
        self.node_res_1:addChild(self.node_res_1.icon, 30)

        self.node_res_1.lbl = cc.Label:createWithTTF("0", FONT_DEFAULT_NAME_BOLD, 36)
        self.node_res_1.lbl:enableOutline(cc.c4b(0, 0, 0, 255), 2)
        self.node_res_1.lbl:setScale(0.5)
        self.node_res_1.lbl:setPosition(0, -1)
        self.node_res_1:addChild(self.node_res_1.lbl, 30)

        local menu = cpp.UIMenu:create()
        menu:setPosition(cc.p(0, 0))
        self.node_res_1:addChild(menu, 100)

        self.node_res_1.btn_add = cpp.UIMenuItemImage:createWithSpriteFrameName("button/btn-add-4.png", nil, nil)
        self.node_res_1.btn_add:setName("btn_add_res_1")
        self.node_res_1.btn_add:setScale(0.9)
        self.node_res_1.btn_add:setPosition(add_offset_x, 0)
        self.node_res_1.btn_add:registerScriptTapHandler(handler(self, self.onAddRes))
        menu:addChild(self.node_res_1.btn_add)

        -- self:addRedDotNode(RedDotType.ZCJ_DJ, self.node_res_1.btn_add)
    else
        self.node_res_1.icon:setSpriteFrame("backpack/"..res_type_1..".png")
    end

    if res_type_2 ~= nil then
        if self.node_res_2 == nil then
            self.node_res_2 = cc.Node:create()
            self.node_res_2:setPosition(win_size.width * 0.83,
                                        win_size.height - 30 - notch_height)
            self.node_res_2:setScale(scale_auto)
            self.main_layer:addChild(self.node_res_2, 20)

            self.node_res_2.spr_bg = cc.Sprite:createWithSpriteFrameName("main-scene/spr-res-bg.png")
            self.node_res_2.spr_bg:setPosition(0, 0)
            self.node_res_2:addChild(self.node_res_2.spr_bg, 20)

            self.node_res_2.icon = cc.Sprite:createWithSpriteFrameName("backpack/"..res_type_2..".png")
            self.node_res_2.icon:setScale(0.40)
            self.node_res_2.icon:setPosition(res_offset_x, 0)
            self.node_res_2:addChild(self.node_res_2.icon, 30)

            self.node_res_2.lbl = cc.Label:createWithTTF("0", FONT_DEFAULT_NAME_BOLD, 36)
            self.node_res_2.lbl:enableOutline(cc.c4b(0, 0, 0, 255), 2)
            self.node_res_2.lbl:setScale(0.5)
            self.node_res_2.lbl:setPosition(0, -1)
            self.node_res_2:addChild(self.node_res_2.lbl, 30)

            local menu = cpp.UIMenu:create()
            menu:setPosition(cc.p(0, 0))
            self.node_res_2:addChild(menu, 100)

            self.node_res_2.btn_add = cpp.UIMenuItemImage:createWithSpriteFrameName("button/btn-add-4.png", nil, nil)
            self.node_res_2.btn_add:setName("btn_add_res_2")
            self.node_res_2.btn_add:setScale(0.9)
            self.node_res_2.btn_add:setPosition(add_offset_x, 0)
            self.node_res_2.btn_add:registerScriptTapHandler(handler(self, self.onAddRes))
            menu:addChild(self.node_res_2.btn_add)
        else
            self.node_res_2:setVisible(true)
            self.node_res_2.icon:setSpriteFrame("backpack/"..res_type_2..".png")
        end
    else
        self.node_res_2:setVisible(false)
    end

    self.node_res_1.item_type = res_type_1
    self.node_res_1.btn_add.item_type = res_type_1
    self:updateResNum(res_type_1)

    if self.node_res_2 ~= nil then
        self.node_res_2.item_type = res_type_2
        self.node_res_2.btn_add.item_type = res_type_2
        self:updateResNum(res_type_2)
    end
    
    if res_type_1 == 900001 then
        ex.RedDotManager:setStickNode(RedDotType.ZCJ_DJ, self.node_res_1.btn_add)
    else
        ex.RedDotManager:setStickNode(RedDotType.ZCJ_DJ, nil)
    end
    
    -- ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DJ, )

    self:updateBubbleGem()
end

function MainScene:onAddRes(tag, pSender)
    if pSender.item_type == 900001 then
        require("src.layer.BuyGoldCtr"):instance():openWindow()
    elseif pSender.item_type == 900002 then
        ex.MainSceneCtr:changeToRechargePage()
    else
        ex.Tools:onClickItemSrc(pSender.item_type)
    end
end

function MainScene:updateResNum()
    if self.node_res_1 ~= nil and self.node_res_1:isVisible() then
        self.node_res_1.lbl:setString(ex.StringUtil.getScientificNumber(ex.Player:getItemNum(self.node_res_1.item_type)))
    end
    if self.node_res_2 ~= nil and self.node_res_2:isVisible() then
        self.node_res_2.lbl:setString(ex.StringUtil.getScientificNumber(ex.Player:getItemNum(self.node_res_2.item_type)))
    end
end

function MainScene:onNewVersion(server_version, now_version)
    require("src.layer.ConfirmCtr"):instance():openWindow(ex.Tools:getLang(110028), ex.Tools:getLang(110029), function()
		require("src.scene.UpdateSceneCtr"):instance():enterWithAnimation()
    end, nil, nil, false, false)
    require("src.layer.guide.GuideCtr"):remove(true)
end

function MainScene:onChat(tag, pSender)
    local atom = pSender:getName()
    ex.JumpManager:jumpByAtom(atom)
end

--[[ 聊天按钮拖动回调
    追踪触点，产生拖动按钮效果，并记录拖动方向及速度
]]
function MainScene:onBtnChatMove(item, touch_pos)
    self.layer_isolate.listener_touch:setSwallowTouches(true)

    -- 记录速度向量
    self.chat_move_dir = cc.p(touch_pos.x - item:getPositionX(), touch_pos.y - item:getPositionY())
    local item_half_width = self.btn_chat:getContentSize().width * self.btn_chat:getScaleX() / 2

    -- 聊天按钮位置越界修正
    if touch_pos.x > ex.p.width - item_half_width then
        touch_pos.x = ex.p.width - item_half_width
    elseif touch_pos.x < item_half_width then
        touch_pos.x = item_half_width
    end

    local main_ctr = require("src.scene.MainSceneCtr"):instance()
    local bottom_height = main_ctr:getMenuScaleHeight()
    local height_diff = main_ctr:getBottomHeight() - bottom_height
    local top_height = (122 - height_diff) + 22
    if touch_pos.y > ex.p.height - top_height then
        touch_pos.y = ex.p.height - top_height
    elseif touch_pos.y < bottom_height then
        touch_pos.y = bottom_height
    end

    item:setPosition(touch_pos)
end

--[[ 聊天按钮拖动结束回调
    如果按钮拖动速度不够，则按照左右半屏来判定按钮移动哪边
    如果按钮拖动速度足够，则根据拖动方向来决定按钮移动哪边
]]
function MainScene:onBtnChatMoveEnd()
    self.layer_isolate.listener_touch:setSwallowTouches(false)

    --[[
    local speed_move = 1000
    local speed_eage = 10
    local item_pos_x, item_pos_y = self.btn_chat:getPosition()
    local item_half_width = self.btn_chat:getContentSize().width * self.btn_chat:getScaleX() / 2

    if math.sqrt(math.pow(math.abs(self.chat_move_dir.x), 2) + math.pow(math.abs(self.chat_move_dir.y), 2)) <= speed_eage then
        if self.btn_chat:getPositionX() > ex.p.cx then
            self.btn_chat:runAction(cc.MoveTo:create(((ex.p.width - item_pos_x) / speed_move), cc.p(ex.p.width - item_half_width, item_pos_y)))
        else
            self.btn_chat:runAction(cc.MoveTo:create(((item_pos_x) / speed_move), cc.p(item_half_width, item_pos_y)))
        end
    else
        -- 根据速度向量，获取最终落点
        local main_ctr = require("src.scene.MainSceneCtr"):instance()
        local bottom_height = main_ctr:getMenuScaleHeight()
        local height_diff = main_ctr:getBottomHeight() - bottom_height
        local top_height = (122 - height_diff) + 22

        local offset_x = -item_pos_x
        if self.chat_move_dir.x > 0 then
            offset_x = ex.p.width - item_pos_x
        end
        local des_y = offset_x / self.chat_move_dir.x * self.chat_move_dir.y + item_pos_y

        if des_y <= ex.p.height - top_height and des_y > bottom_height then
            if self.chat_move_dir.x > 0 then
                self.btn_chat:runAction(cc.MoveTo:create(math.abs((ex.p.width - item_pos_x) / speed_move), cc.p(ex.p.width - item_half_width, des_y)))
            else
                self.btn_chat:runAction(cc.MoveTo:create(math.abs((item_pos_x) / speed_move), cc.p(item_half_width, des_y)))
            end
        elseif des_y > ex.p.height - top_height then
            -- 向上抛
            local des_x = (ex.p.height - top_height - item_pos_y) / self.chat_move_dir.y * self.chat_move_dir.x + item_pos_x
            if self.chat_move_dir.x > 0 then
                -- 向右上抛
                self.btn_chat:runAction(cc.Sequence:create(cc.MoveTo:create(math.abs((des_x - item_pos_x) / speed_move), cc.p(des_x, ex.p.height - top_height)),
                                                            cc.MoveTo:create(math.abs((ex.p.width - des_x) / speed_move), cc.p(ex.p.width - item_half_width, ex.p.height - top_height)),
                                                            nil))
            else
                -- 向左上抛
                self.btn_chat:runAction(cc.Sequence:create(cc.MoveTo:create(math.abs((des_x - item_pos_x) / speed_move), cc.p(des_x, ex.p.height - top_height)),
                                                            cc.MoveTo:create(math.abs((des_x) / speed_move), cc.p(item_half_width, ex.p.height - top_height)),
                                                            nil))
            end
        elseif des_y < bottom_height then
            -- 向下抛
            local des_x = (bottom_height - item_pos_y) / self.chat_move_dir.y * self.chat_move_dir.x + item_pos_x
            if self.chat_move_dir.x > 0 then
                -- 向右下抛
                self.btn_chat:runAction(cc.Sequence:create(cc.MoveTo:create(math.abs((des_x - item_pos_x) / speed_move), cc.p(des_x, bottom_height)),
                                                            cc.MoveTo:create(math.abs((ex.p.width - des_x) / speed_move), cc.p(ex.p.width - item_half_width, bottom_height)),
                                                            nil))
            else
                -- 向左下抛
                self.btn_chat:runAction(cc.Sequence:create(cc.MoveTo:create(math.abs((des_x - item_pos_x) / speed_move), cc.p(des_x, bottom_height)),
                                                            cc.MoveTo:create(math.abs((des_x) / speed_move), cc.p(item_half_width, bottom_height)),
                                                            nil))
            end
        else
            if self.chat_move_dir.x > 0 then
                self.btn_chat:runAction(cc.MoveTo:create(math.abs((ex.p.width - item_pos_x) / speed_move), cc.p(ex.p.width - item_half_width, des_y)))
            else
                self.btn_chat:runAction(cc.MoveTo:create(math.abs((item_pos_x) / speed_move), cc.p(item_half_width, des_y)))
            end
        end
    end
    ]]
end

function MainScene:onChangeHeadFrame(event,data)
    local str = ex.Tools:getBorderIconByIdx(ex.Player.border_id)
    self.spr_head_frame:setSpriteFrame(str)
end

function MainScene:onChangeHead(event,data)
    local str = string.format("head-icon/%d.png",ex.Player.head_id)
    self.spr_head:setSpriteFrame(str)
end

function MainScene:onChangeDXIcon(event,data)
    if not data then return end
    if not data.atom then return end
    if not data.icon then return end
    if not data.lbl then return end

    local item = self.menu_scale:getChildByName(data.atom)
    if not item then return end

    item.layer_type = data.layer_type
    local icon  = item:getChildByName("icon")
    if icon then 
        icon:setSpriteFrame(data.icon)
    end

    local lbl = item:getChildByName("lbl")
    if lbl then 
        lbl:setSpriteFrame(data.lbl)
    end
end

function MainScene:updateBubbleGem()
    local gem_need = tonumber(ex.Tools:getSysCfg("main_scene_bubble_gem_need")) or 0
    local pos_add_gem = cc.p(-1, -1)
    if self.node_res_2 ~= nil and self.node_res_2.item_type == 900002 then
        pos_add_gem = cc.p(self.node_res_2:getPositionX() + self.node_res_2.btn_add:getPositionX(),
                            self.node_res_2:getPositionY() + self.node_res_2.btn_add:getPositionY())
    end
    local is_show = self.is_show_buy_gem_tip ~= false and pos_add_gem.x > 0 and ex.Player.gem > gem_need

    -- 添加购买钻石按钮气泡提示
    if is_show and self.main_layer:getChildByName("spr_bubble_tip") == nil then
        local spr_tip = cc.Sprite:createWithSpriteFrameName("main-city/spr-tip-welfare.png")
        spr_tip:setName("spr_bubble_tip")
        spr_tip:setAnchorPoint(0.6, 1)
        spr_tip:setPosition(pos_add_gem.x, pos_add_gem.y + 5)
        self.main_layer:addChild(spr_tip, 100)

        -- 气泡添加侦听事件，点击后消失
        spr_tip.listener = cc.EventListenerTouchOneByOne:create()  --创建一个单点事件监听
        spr_tip.listener:setSwallowTouches(false)
        spr_tip.listener:registerScriptHandler(function(touch, event)
            return true
        end, cc.Handler.EVENT_TOUCH_BEGAN)
        spr_tip.listener:registerScriptHandler(function()
        end, cc.Handler.EVENT_TOUCH_MOVED)
        spr_tip.listener:registerScriptHandler(function(touch, event)
            if spr_tip == nil then return end
            local touchLocation = touch:getLocation()   -- Get the touch position
            touchLocation = spr_tip:getParent():convertToNodeSpace(touchLocation)
            local bBox = spr_tip:getBoundingBox()
            bBox.height = bBox.height + 16
            local is_touch_inside = (touchLocation.x >= bBox.x and touchLocation.x <= bBox.x + bBox.width and touchLocation.y >= bBox.y and touchLocation.y <= bBox.y + bBox.height)
            if is_touch_inside == false then
                return
            end

            self.is_show_buy_gem_tip = false
            spr_tip:runAction(cc.Sequence:create(cc.FadeOut:create(0.5), cc.RemoveSelf:create(), nil))
            spr_tip = nil
        end, cc.Handler.EVENT_TOUCH_ENDED)
        local event_dispatcher = spr_tip:getEventDispatcher() 
        event_dispatcher:addEventListenerWithSceneGraphPriority(spr_tip.listener, spr_tip)
    end

    if is_show then
        if self.main_layer:getChildByName("spr_bubble_tip") then
            self.main_layer:getChildByName("spr_bubble_tip"):setVisible(true)
        end
    else
        if self.main_layer:getChildByName("spr_bubble_tip") then
            self.main_layer:getChildByName("spr_bubble_tip"):removeFromParent()
        end
    end
end

function MainScene:updateResEvent()
    local main_ctr = ex.MainSceneCtr
    -- 一帧单次只发3个事件
    local count_max = 3
    for i=1, count_max do
        local count = 0
        for k,v in pairs(main_ctr.vec_res_evect) do
            for vk, vv in pairs(v) do
                -- 临时代码
                if vv == true then
                    count = count + 1
                    -- vv = 事件类型。 k = item_type
                    ex.EventManager:fire(vk, k)
                    v[vk] = false                 
                    -- 次数达到上限，跳出循环
                    if count >= count_max  then
                        break
                    end 
                end
            end

            -- 次数达到上限，跳出循环
            if count >= count_max  then
                break
            end
        end
    end

    -- 显示膜拜的数据
    ex.Player.rank_data:showWorshipTip()
end

function MainScene:updateTimer()
    local now_time = ex.Game:getServerTime()
    -- 临时代码，12点10秒同步后端的数据
    if self.reset_time ~= nil and now_time > self.reset_time then
        NetManager:sendMessage(ProtocolID.GReqRoleInfo)
    end

    -- game.is_realname = 0
    
    -- if cpp.SocialPlatform:instance():isDebug() ~= true then
        -- self.online_time = ex.Game:getServerTime()
        -- 未实名认证
        if game.is_realname ~= nil and game.is_realname <= 0 then
            -- 已经在线一个小时
            local time_diff = math.max(0, now_time - self.online_time) 
            if ex.Player.onlineReward_data.online_time + time_diff >= ex.Tools:getSysCfg("not_realname_identification_online_time") and require("src.layer.ConfirmCtr"):instance():isOpened() ~= true then
                require("src.layer.ConfirmCtr"):instance():openWindow(ex.Tools:getLang(41068), ex.Tools:getLang(41210), function()
                    require("src.scene.UpdateSceneCtr"):instance():enterWithAnimation()
                end, nil, nil, false, false)
                cpp.Game:instance():stopTheGame()
            end
        end
    -- end
    
    
    local summon1 = ex.Player.summon_data:getFreeTime(1)
    local summon2 = ex.Player.summon_data:getFreeTime(3)
    if summon1 ~= nil and summon2 ~= nil and summon1 ~= 0 and summon2 ~= 0 then
        if summon1 < now_time or summon2 < now_time then
            NetManager:sendMessage(ProtocolID.GResHeroSummonCount)
        end
    end

end

function MainScene:updateLevel(evt, level)
    self:updateBattleBtn(evt, nil, level)

    ex.RedDotManager:refreshConditionRedDot()
end

function MainScene:updateBattleBtn(evt, type, level)
    local now_idx = ex.Player.chapter_data.chapter_id + 1
	local status = ex.Player.chapter_data:getBattleStatus(now_idx, level or ex.Player.level)
    local chapter_config = cfg.chapterreward.chapterreward[now_idx]

    local btn_battle = self.menu_scale:getChildByName("spr_battle")
    local spr_icon = btn_battle:getChildByName("icon")

    spr_icon:setVisible(true)
    if btn_battle.spr_effect ~= nil then
        btn_battle.spr_effect:removeFromParent()
        btn_battle.spr_effect = nil
    end


    if btn_battle.spr_spine ~= nil then
        btn_battle.spr_spine:removeFromParent()
        btn_battle.spr_spine = nil
    end

    if status == -3 then
		return
    end
    spr_icon:setVisible(false)

    local eff2 = ex.EffectCtr:playNormalEff(19, btn_battle:getContentSize().width * 0.5, btn_battle:getContentSize().height * 0.5, nil, btn_battle, 11, nil, nil, nil, 1)
    btn_battle.spr_effect = eff2.anim.anim
    btn_battle.spr_effect:setAnchorPoint(cc.p(0.5, 0.42))


	local spr_spine = sp.SkeletonAnimation:create("spine/zhandoujijian.json","spine/zhandoujijian.atlas", 1)
    spr_spine:setAnimation(0, "idle", true);
    spr_spine:setPosition( btn_battle:getContentSize().width * 0.5, btn_battle:getContentSize().height * 0.5)
    spr_spine:setScale(1)
	btn_battle:addChild(spr_spine, 19)
    btn_battle.spr_spine = spr_spine

    -- 刷新scale按钮的等级限制显示
    local vec_scale_btn = self.menu_scale:getChildren()
    for i,v in ipairs(vec_scale_btn) do
        if v.level_need ~= nil and v.level_need <= ex.Player.level and v.lbl_level_limit ~= nil then
            v.lbl_level_limit:removeFromParent()
            v.lbl_level_limit = nil

            -- v:setGray(false)
            local spr_icon = v:getChildByName("icon")
            if spr_icon and spr_icon.icon_name then
                spr_icon:setSpriteFrame(spr_icon.icon_name..".png")
            end
        end
    end
end

function MainScene:onExit()
	for k,v in pairs(self.vec_reddot_item) do
		ex.RedDotManager:removeStickNode(k, v)
    end
    
    if self.scheduler_reset then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler_reset)
        self.scheduler_reset = nil
    end

    if self.scheduler_res_change then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler_res_change)
        self.scheduler_res_change = nil
    end

    ex.RedDotManager:setStickNode(RedDotType.ZCJ_DJ, nil)

    ex.AudioManager:stopMusic()

    -- 检查服务器版本
    local asset_manager = require("src.model.AssetManager"):instance()
    asset_manager.comp_version_callback = nil
    
    -- local removefile = {}
    -- table.insert(removefile, {type = 1, plist = "", image = "ccbi-res/map-bg-loading.jpg"})
    -- table.insert(removefile, {type = 1, plist = "", image = "ccbi-res/anti-addiction.jpg"})
    -- table.insert(removefile, {type = 1, plist = "", image = "spine/jiemian.png"})
    -- table.insert(removefile, {type = 1, plist = "", image = "ccbi-res/anti-addiction.jpg"})
    -- table.insert(removefile, {type = 2, plist = "ccbi-res/main-city-effect.plist", image = "ccbi-res/main-city-effect.pvr.ccz"})
    -- table.insert(removefile, {type = 2, plist = "ccbi-res/main-city.plist", image = "ccbi-res/main-city.pvr.ccz"})
    -- table.insert(removefile, {type = 2, plist = "ccbi-res/main-scene-effect-2.plist", image = "ccbi-res/main-scene-effect-2.pvr.ccz"})
    -- table.insert(removefile, {type = 2, plist = "ccbi-res/logo-scene.plist", image = "ccbi-res/logo-scene.pvr.ccz"})
    -- table.insert(removefile, {type = 2, plist = "ccbi-res/loading.plist", image = "ccbi-res/loading.pvr.ccz"})
    
    -- for i,v in ipairs(removefile) do
    --     -- 释放帧缓存
    --     if v.type == 2 then
    --         cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile(v.plist)
    --     end

    --     if v.image then
    --         local texture = cc.Director:getInstance():getTextureCache():getTextureForKey(v.image)
    --         if texture and texture:getReferenceCount() == 1 then
    --             cc.Director:getInstance():getTextureCache():removeTextureForKey(v.image)
    --         end
    --     end
    -- end
end

function MainSceneCtr:instance()
    if self._instance == nil then
        self._instance = self:create()
    end
    return self._instance
end

function MainSceneCtr:ctor()
    self.super.ctor(self)

    self.cur_layer_type = 0
    self.vec_keep_layer = {}
    self.vec_keep_buffer = {}

    self.vec_res_evect = {}
    self.vec_audio_effect = {}
    self.layer_effect_id = nil
    
	-- 记录层级访问，初始版本
	self.save_layer_list = {}
end

function MainSceneCtr:loadLayer(scene)
    scene.scene_ctr = self
    self.scene = scene
    self.layer = MainScene:create()
    scene:addChild(self.layer)
end

function MainSceneCtr:onExit()
    self.cur_layer_type = 0
    self.vec_keep_layer = {}
    self.vec_keep_buffer = {}
end

function MainSceneCtr:enter()
    self.super.enter(self)
    self:changeLayer(MainSceneType.MAINCITY_LAYER)
    self:addKeepLayer(MainSceneType.MLT_BATTLE)
end

function MainSceneCtr:didEnter()
    self.super.didEnter(self)

    self.scene:addChild(MainTouchEffectLayer:create(), 999999)
    self.layer:updateBattleBtn()

    self:setBattle(nil, 0, ex.Player.fighting)
    self:setGold(0, ex.Player.gold)
    self:setGem(0, ex.Player.gem)
    self:setExp(ex.Player.level, ex.Player.exp)
    self:setNick(ex.Player.nick)
    self:setHeadIcon(ex.Player.head_id)


    ex.SocialPlatform:updateExtraDataLua()
    ex.Player.shop_data:startCheckRecharge()
    ex.Player.hero_data:initRedPoint()
    ex.Player.hero_data:sortAllHero()

    ex.SocialPlatform:submitRoleInfoLua("enter_game")
    require("src.layer.guide.GuideCtr"):restart()
    ex.MessageView:clear()

    if ex.JumpManager:checkOpenConditionByAtomNoMsg("main_champion") then
        NetManager:sendMessage(ProtocolID.GReqScanChampion)
    end
    if ex.JumpManager:checkOpenConditionByAtomNoMsg("main_champion_cross") then
        NetManager:sendMessage(ProtocolID.GReqScanChampionCross)
    end


    if cpp.SocialPlatform:instance():getPlatformStr() == "1" and cpp.SocialPlatform:instance():isDebug() then
    -- if true then
        local game = require("src.model.Game"):instance()
        game.error_log = ""

        -- print("11111")
        old___G__TRACKBACK__2 = __G__TRACKBACK__
        __G__TRACKBACK__ = function(errorMessage)
            local msg = debug.traceback(errorMessage, 3)
            game.error_log = game.error_log .. msg .. "\n"

            local is_open = cc.UserDefault:getInstance():getBoolForKey("open_error_windows", true)
            if is_open then
                require("src.layer.ErrorCtr"):instance():openWindow(msg)
            end

            old___G__TRACKBACK__2(errorMessage)

            xpcallFun()
        end
    end

    require("src.layer.HeroAttackupCtr"):instance()

    -- 释放背景资源
    cc.Director:getInstance():getTextureCache():removeTextureForKey("ccbi-base/map-bg-loading-1.png")
    cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("ccbi-res/loading.plist")
    cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("ccbi-res/logo-scene.plist")

    print("xx", require("src.model.Game"):instance().server_id)
    
    if require("src.model.Game"):instance().server_id >= SERVER_SHEN_HE_ID and device.platform == "ios" then
        local guide_ctr = require("src.layer.guide.GuideCtr"):instance()
        if guide_ctr then
            guide_ctr.guide_num = 1900
            guide_ctr:saveGuideNum()
            guide_ctr:remove(true)
            if ex.Player.is_rename == 0 then
                require("src.layer.NpcTalkCtr"):instance():closeWindow()
                require("src.layer.SubmovieCtr"):instance():closeWindow()
                require("src.layer.RenameCtr"):instance():openWindow()
            end
        end
    end
end

function MainSceneCtr:getMainScene()
    if self:isRuning() ~= true then
        return nil
    end
    return self.layer
end

function MainSceneCtr:getCurLayerType()
    return self.cur_layer_type
end

function MainSceneCtr:getCurLayer()
    local main_scene = self:getMainScene()
    if main_scene == nil then
        return nil
    end
    return main_scene.cur_main_layer;
end

function MainSceneCtr:getMenuScaleHeight()
    local bottom_height = self:getBottomHeight()
    if bottom_height <= 0 then bottom_height = 100 end
    return bottom_height
end

function MainSceneCtr:getBottomHeight()
    -- if self:isRuning() ~= true then
    --     return 0
    -- end

    if self.layer == nil or tolua.isnull(self.layer) then
        return 0
    end

    -- local size_item = cc.Sprite:createWithSpriteFrameName("main-scene/scale-bar-1.png"):getContentSize()
    -- local o_scale = ex.p.width * 0.9 / (size_item.width * 6)

    local node = self.layer.menu_scale:getChildren()[1]
    return node:getContentSize().height * node:getOScale() + 10
end

function MainSceneCtr:updateScaleBtn()
    -- 如果是转向七个主界面，则更新下方七个按钮状态
    local tmp_layer_type = math.floor(self.cur_layer_type / 100000) * 100
    local vec_child = self.layer.menu_scale:getChildren()
    for i, v in ipairs(vec_child) do
        v:setChecked(false)
        v:stopAllActions()
    end
    for i, v in ipairs(vec_child) do
        if v:getTag() == tmp_layer_type then
            v:setChecked(true)
            break
        end
    end
end

-- 界面切换逻辑
-- 保留界面
function MainSceneCtr:addKeepLayer(type, parent_type)
    local layer_type = TableEx.isInTable(self.vec_keep_layer, type)
    if layer_type == nil then
        table.insert(self.vec_keep_layer, type)
    end
    local main_scene = self.layer
    if self:isRuning() ~= true or self.cur_layer_type ~= type or main_scene.cur_main_layer == nil then
        return
    end
    self:addKeepBuffer(type, main_scene.cur_main_layer, parent_type)
end

-- 移除保留的界面
function MainSceneCtr:removeKeepLayer(type)
    TableEx.removeTableData(self.vec_keep_layer, function ( value )
        return value == type
    end)

    local keep_data = TableEx.findValueFunction(self.vec_keep_buffer, function(value)
        return value.type == type
    end)

    if keep_data ~= nil then
        local layer = keep_data.layer

        TableEx.removeTableData(self.vec_keep_buffer, function ( value )
            return value.type == type
        end)

        if self:isRuning() ~= true or self.cur_layer_type == type or layer == nil then
            return
        end

        layer:removeFromParent()
    end
end

-- 是否保留该界面
function MainSceneCtr:isKeepLayer(type)
    return TableEx.isInTable(self.vec_keep_layer, type) ~= nil
end

-- 清除
function MainSceneCtr:clearKeepLayer()
    self.vec_keep_layer = {}
end

-- 保留界面缓存
function MainSceneCtr:addKeepBuffer(type, node, parent_type)
    local keep_data = TableEx.findValueFunction(self.vec_keep_buffer, function(value)
        return value.type == type
    end)

    if keep_data == nil then
        local data = {}
        data.type = type
        data.layer = node
        data.parent_type = parent_type
        table.insert(self.vec_keep_buffer, data)
    end
end

-- 获取关联的界面
function MainSceneCtr:getKeepConflict(type)
    for i,v in ipairs(self.vec_keep_buffer) do
        if v.parent_type ~= nil and v.parent_type == type then
            return v
        end
    end
    return nil
end

function MainSceneCtr:getKeepBuffer(type)
    local keep_data = TableEx.findValueFunction(self.vec_keep_buffer, function(value)
        return value.type == type
    end)

    if keep_data == nil then
        return nil
    end

    return keep_data.layer
end

function MainSceneCtr:getKeepNodeType(node)
    local keep_data = TableEx.findValueFunction(self.vec_keep_buffer, function(value)
        return value.layer == node
    end)

    if keep_data then
        return keep_data.type
    end

    return -1
end

function MainSceneCtr:removeActionEnd(node)
    local type = self:getKeepNodeType(node)

    if type <= 0 then
        node:removeFromParent()
        return
    end

    node:setVisible(false)
end

function MainSceneCtr:checkNowLayer(type )
    if type == self.cur_layer_type then 
        return true 
    end 
    return false
end

function MainSceneCtr:onChangeLayer(tag, pSender)
    if pSender.layer_type then
        --当进入英雄层时初始化属性的点击状态
        if pSender.layer_type==MainSceneType.HERO_LAYER then
            ex.Player.hero_data.btn_elem_state = 0

        end
        self:changeLayer(pSender.layer_type)

        self:updateScaleBtn()
    end
end

function MainSceneCtr:changeLayer(layer_type, callback ,node, is_fast)
    print("MainSceneCtr:changeLayer", layer_type)
    if layer_type == nil then
        layer_type = MainSceneType.MAINCITY_LAYER
    end
    
    local delay = is_fast == true and 0 or 0.13

    -- 判断是否可切换到该图层
    if self:didChangeLayer(layer_type) ~= true then
        return self.layer.cur_main_layer
    end

    -- if self:isRuning() ~= true then
    --     return nil
    -- end

    local main_scene = self.layer
    -- if main_scene.is_changing == true then
    --     return
    -- end

    -- main_scene.is_changing = true
    -- local act_change = function()
    --     main_scene.is_changing = false
    -- end
    -- main_scene:runAction(cc.Sequence:create(cc.DelayTime:create(0.02), cc.DelayTime:create(0.02), cc.CallFunc:create(act_change)))

    -- 保存临时类型
    local tmp_type = self.cur_layer_type
    self.cur_layer_type = layer_type

    self:updateScaleBtn()

    local win_size = cc.Director:getInstance():getWinSize()
    local action_dir = self.cur_layer_type > tmp_type and -1 or 1
    local is_fast_change = is_fast or self.layer.cur_main_layer == nil
    
    -- 切换层
    -- 先执行当前层移动到界面以外并释放
    local tmp_main_layer = self.layer.cur_main_layer
    if main_scene.cur_main_layer ~= nil then
        main_scene.cur_main_layer = nil
        tmp_main_layer:stopActionByTag(100);

        -- 层切出时调用层回调
        if tmp_main_layer.changeLayerOut ~= nil then
            tmp_main_layer:changeLayerOut()
        end

        local func_node = function()
            -- 层切出结束时调用层回调
            if tmp_main_layer.changeLayerOutEnd ~= nil then
                tmp_main_layer:changeLayerOutEnd()
            end
            self:removeActionEnd(tmp_main_layer)
        end

        local act_remove = cc.Sequence:create(cc.EaseExponentialOut:create(cc.MoveTo:create(delay,
                                                             cc.p(win_size.width * action_dir + win_size.width / 2, win_size.height / 2))),
                                                             cc.CallFunc:create(func_node))

        act_remove:setTag(100)
        tmp_main_layer:runAction(act_remove)
        tmp_main_layer:setLocalZOrder(-1)
        main_scene.cur_main_layer = NULL
    end
    
    -- 战斗界面使用 conflict_data
    local conflict_data = self:getKeepConflict(layer_type)
    if conflict_data then
        self.cur_layer_type = conflict_data.type
        main_scene.cur_main_layer = conflict_data.layer
    else
        -- 一般的常驻界面
        main_scene.cur_main_layer = self:getKeepBuffer(layer_type)
    end
    

    if self.cur_layer_type == MainSceneType.MAINCITY_LAYER then 
        self.save_layer_list = {}
    end 

    local nowLayer = {}
    nowLayer.layer = self.cur_layer_type
    nowLayer.callBack = callback    -- 需要放入回掉参数，前往你制定的标签,用于返回上层标签

    table.insert( self.save_layer_list, nowLayer )

    if node ~= nil then
        main_scene.cur_main_layer = node
    elseif main_scene.cur_main_layer == nil then
        main_scene.cur_main_layer = self:createLayerWithType(self.cur_layer_type)
    end

    if main_scene.cur_main_layer == nil then
        return nil
    end

    -- 切换后不会被删除
    if self:isKeepLayer(self.cur_layer_type) and self:getKeepBuffer(self.cur_layer_type) == nil then
        self:addKeepBuffer(self.cur_layer_type, main_scene.cur_main_layer)
    end

    self:addMainSceneLayer(main_scene.cur_main_layer)

    main_scene:updateNodeRes()

    -- 层切入时调用层回调
    if main_scene.cur_main_layer.changeLayerIn ~= nil then
        main_scene.cur_main_layer:changeLayerIn()
    end

    local layer_offset = cc.p(0, 0)

    -- 快速切换
    if is_fast_change then

        if main_scene.cur_main_layer.getLayerOffset then
            layer_offset = main_scene.cur_main_layer:getLayerOffset()
        end

        main_scene.cur_main_layer:setLocalZOrder(0)
        main_scene.cur_main_layer:stopActionByTag(100)
        main_scene.cur_main_layer:stopActionByTag(101)
        main_scene.cur_main_layer:setVisible(true)
        main_scene.cur_main_layer:setPosition(cc.p(win_size.width / 2 + layer_offset.x, win_size.height / 2 + 20  + layer_offset.y))

        if main_scene.cur_main_layer.changeLayerInEnd ~= nil then
            main_scene.cur_main_layer:changeLayerInEnd()
        end
    else
        local func_node = function()
            -- 层切入结束时调用层回调
            if main_scene.cur_main_layer.changeLayerInEnd ~= nil then
                main_scene.cur_main_layer:changeLayerInEnd()
            end
        end

        if main_scene.cur_main_layer.getLayerOffset then
            layer_offset = main_scene.cur_main_layer:getLayerOffset()
        end

        main_scene.cur_main_layer:setLocalZOrder(0)
        main_scene.cur_main_layer:setPosition(cc.p(-win_size.width * action_dir + win_size.width / 2 + layer_offset.x, win_size.height / 2 + 20 + layer_offset.y))
        main_scene.cur_main_layer:stopActionByTag(100)
        main_scene.cur_main_layer:stopActionByTag(101)
        local act_in = cc.Sequence:create(cc.Show:create(),
                                          cc.EaseExponentialOut:create(cc.MoveTo:create(delay, cc.p(win_size.width / 2 + layer_offset.x,
                                                                   win_size.height / 2 + 20 + layer_offset.y))),
                                          cc.CallFunc:create(func_node))
        act_in:setTag(101)
        main_scene.cur_main_layer:runAction(act_in)
    end

    main_scene.tmp_main_layer = tmp_main_layer
    self.tmp_layer_type = tmp_type;

    self:changeLayerEnd(self.cur_layer_type)

    return self.layer.cur_main_layer
end

function MainSceneCtr:addMainSceneLayer(layer)
    -- 不是缓存的节点
    local main_scene = self.layer
    if layer:getParent() == nil then
        main_scene:addChild(layer)
        layer:setIgnoreAnchorPointForPosition(false)
        layer:setAnchorPoint(cc.p(0.5, 0.5))
    end
end

function MainSceneCtr:backLastLayer()
    --当前点的上一个点
    -- self.save_layer_list
    if #self.save_layer_list < 1 then return end 

    local refresh_layer_list = {}
    local last_layer = nil
    local now_layer = nil
    for i,v in ipairs(self.save_layer_list) do
        if self.cur_layer_type == v.layer then 
            now_layer = clone(v)
            break;
        else 
            if table.nums(v) > 0 then
                last_layer = clone(v)
                table.insert( refresh_layer_list, clone(v))
            end
        end 
    end
    if last_layer then 
        self.save_layer_list = refresh_layer_list
        local new_layer
        if 	MainSceneType.COMMON1ACTIVITYLAYER == last_layer.layer then 
        		require("src.layer.promotion.CommonUIHelper"):OpenWindow("act_happy_month")
        else 
            
            if MainSceneType.MAINCITY_DAILY_CHECK == last_layer.layer then
                local data = {}
                data.__select_idx = 7
                new_layer = cfg.funcopen["act_welfare"].open(data)
            elseif MainSceneType.MAINCITY_RECHARGE == last_layer.layer then
                new_layer = cfg.funcopen["act_recharge"].open()
            elseif MainSceneType.MAINCITY_LIMIT_TIME_SERVER == last_layer.layer then
                new_layer = ex.MainSceneCtr:changeLayer(last_layer.layer)
                local select_idx = ex.Player.promotion_data.save_select_time_limit_type
                local vec_idx = ex.Player.promotion_data:getPromotionByType(PromotionPageType.LIMIT_TIME_SERVER_ACTIVITY)
                local tab = {}
                tab.cell_size = cc.size(168.0, 120.0)
                tab.margin = 10
                tab.view_size = cc.size(tab.cell_size.width * table.nums(vec_idx) + (table.nums(vec_idx) + 1) * tab.margin, tab.cell_size.height)
                tab.is_bounceable = true
                new_layer:initWithTable(nil, vec_idx, select_idx, tab) 
            elseif MainSceneType.MAINCITY_LIMIT_TIME_ACTIVITY == last_layer.layer then 
                new_layer = ex.MainSceneCtr:changeLayer(last_layer.layer)
                local select_idx = ex.Player.promotion_data.save_select_time_limit_type
                local vec_idx = ex.Player.promotion_data:getPromotionByType(PromotionPageType.LIMIT_TIME_ACTIVITY)
                local tab = {}
                tab.cell_size = cc.size(168.0, 120.0)
                tab.margin = 10
                tab.view_size = cc.size(tab.cell_size.width * table.nums(vec_idx) + (table.nums(vec_idx) + 1) * tab.margin, tab.cell_size.height)
                tab.is_bounceable = true
                new_layer:initWithTable(nil, vec_idx, select_idx, tab)   
            elseif MainSceneType.MAINCITY_CHSD == last_layer.layer then  
                -- add 熊梦 因为彩虹圣殿请求数据在open方法里面请求 返回的时候不会走open方法 导致彩虹圣殿没数据
                -- 所以特殊处理 手动调用一下open方法
                cfg.funcopen["main_chsd"].open()
            elseif MainSceneType.HERO_EVOLUTION_PREVIEW_LAYER == now_layer.layer then
                new_layer = ex.MainSceneCtr:changeLayer(MainSceneType.HERO_LAYER)
                new_layer:changeLayer(2)
                require("src.layer.herolist.HeroEvolveIllustratCtr"):instance():openWindow()
            else
                new_layer = ex.MainSceneCtr:changeLayer(last_layer.layer)  
            end 

            -- local new_layer = ex.MainSceneCtr:changeLayer(last_layer.layer)
            -- 执行上层回掉
            if now_layer and now_layer.callBack then 
                now_layer.callBack(new_layer)
            end
        end 
        return true
    end 
    return false
end


function MainSceneCtr:didChangeLayer(layer_type)
    local is_change = true
    if layer_type == MainSceneType.CLAN then
        if layer_type == MainSceneType.CLAN then
            local need_level = cfg.opencondition.condition["main_clan"].condition_value
            if need_level > ex.Player.level then
                ex.MessageView:add(string.format(ex.Tools:getLang(47214), need_level))
                is_change = false
            end
        else
            is_change = false
            ex.MessageView:add(ex.Tools:getLang(47100))
        end
    elseif layer_type == MainSceneType.MAINCITY_SLZM then
        is_change = ex.JumpManager:checkOpenConditionByAtom("main_mission")
    end

    local main_scene = ex.MainSceneCtr:getMainScene()

    -- 隐藏主城的图层
    if layer_type == MainSceneType.MAINCITY_LAYER then
        local layer_main_city = ex.MainSceneCtr:getKeepBuffer(MainSceneType.MAINCITY_LAYER)
        if layer_main_city then
             for k,v in pairs(layer_main_city.vec_keep_layer) do
                v:setVisible(false)
            end
        end
    elseif layer_type == MainSceneType.MLT_BATTLE then
        local layer_main_battle = ex.MainSceneCtr:getKeepBuffer(MainSceneType.MLT_BATTLE)
        if layer_main_battle then
             for k,v in pairs(layer_main_battle.vec_keep_layer) do
                v:setVisible(false)
            end
        end
    end

    is_change = is_change and layer_type ~= ex.MainSceneCtr:getCurLayerType()

    return is_change
end

function MainSceneCtr:changeLayerAnim(layer_type)

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/main-scene-effect.plist")

    local main_scene = ex.MainSceneCtr:getMainScene()
    local main_layer = main_scene.main_layer
    local main_menu = main_scene.menu_scale
    
    local btn_selected = main_menu:getChildByTag(100 * math.floor(layer_type / 100000))

    if main_scene.spr_effect ~= nil then
        main_scene.spr_effect:removeFromParent()
        main_scene.spr_effect = nil
    end

    main_scene.spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_main_scene_scale")
    main_scene.spr_effect:setPosition(btn_selected:getContentSize().width / 2, btn_selected:getContentSize().height / 2)
    btn_selected:addChild(main_scene.spr_effect)
    main_scene.spr_effect:setScale(70 / 90)

    main_scene.spr_effect:setTag(10000)
end

function MainSceneCtr:changeLayerEnd(layer_type)
    local main_scene = ex.MainSceneCtr:getMainScene()
    if main_scene ~= nil then
        self:changeLayerAnim(layer_type)
    end
    ex.Tools:autoPlaySceneMusic()
end

-- 战斗界面
function MainSceneCtr:addBattleLayer(parent, battle_layer, battle_type, parent_type, is_change)

    if self.layer.cur_main_layer == parent or is_change == true then
        self:changeLayer(battle_type, nil,  battle_layer, true)
    end

    if self.layer.cur_main_layer == parent then
        self:addKeepLayer(battle_type, parent_type)
        local keep_buffer = self:getKeepBuffer(battle_type)
        if keep_buffer then
            keep_buffer.layer = battle_layer
        end
    else
        -- print(self:getCurLayerType())
        battle_layer:setVisible(self:getCurLayerType() == battle_type)
        self:addMainSceneLayer(battle_layer)
        self:addKeepLayer(battle_type, parent_type)
        self:addKeepBuffer(battle_type, battle_layer, parent_type)
    end
end


function MainSceneCtr:createLayerWithType(layer_type)
    print("layer_type", layer_type)
    local node = nil
    local layer_config = TableEx.findValueFunction(cfg.mainscenepage.mainscenepage, function(config)
        return MainSceneType[config.layer_type] == layer_type
    end)

    if layer_config then
        if layer_config.ccbi == "" then
            node = require(layer_config.code):create()
        else
            node = require(layer_config.code):createWithCCBIFile(layer_config.ccbi)
        end
    end
    -- if layer_type == MainSceneType.BACKPACK_LAYER  then
    --     node = require("src.layer.BackpackLayer"):createWithCCBIFile("ccbi/BackpackLayer.ccbi")
    -- elseif layer_type == MainSceneType.HERO_LAYER then
    --     node = require("src.layer.herolist.HeroListLayer"):createWithCCBIFile("ccbi/HeroListLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_LAYER then
    --     node = require("src.layer.MainCityLayer"):create()
    -- elseif layer_type == MainSceneType.HERO_INFO_LAYER then
    --     node = require("src.layer.heroinfo.HeroInfoLayer"):createWithCCBIFile("ccbi/HeroInfoLayer.ccbi")
    -- elseif layer_type == MainSceneType.HERO_ILLUSTRAT_INFO_LAYER then
    --     node = require("src.layer.HeroIllustratInfoLayer"):createWithCCBIFile("ccbi/HeroIllustratInfoLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_SUMMON then
    --     node = require("src.layer.SummonLayer"):createWithCCBIFile("ccbi/SummonLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_PUB_TASK then
    --     node = require("src.layer.PubTaskLayer"):createWithCCBIFile("ccbi/MainTaskLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_BLESSING_POOL then
    --     node = require("src.layer.BlessingPoolLayer"):createWithCCBIFile("ccbi/BlessingPoolLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_FANTASY_TOWER then
    --     node = require("src.layer.fantasytower.FantasyTowerLayer"):createWithCCBIFile("ccbi/FantasyTowerLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_PROPHET_TREE then
    --     node = require("src.layer.ProphetTreeLayer"):createWithCCBIFile("ccbi/ProphetTreeLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_DUNGEON then
    --     node = require("src.layer.DungeonLayer"):createWithCCBIFile("ccbi/DungeonLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_DUNGEON_SHOP then
    --     node = require("src.layer.shop.DungeonShopLayer"):createWithCCBIFile("ccbi/DungeonShopLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_TRIAL then
    --     node = require("src.layer.TrialLayer"):createWithCCBIFile("ccbi/TrialLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_DAILY_CHECK then
    --     node = require("src.layer.promotion.PromotionLayer"):createWithCCBIFile("ccbi/PromotionLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_RECHARGE then
    --     node = require("src.layer.promotion.PromotionLayer"):createWithCCBIFile("ccbi/PromotionLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_ALTAR then
    --     node = require("src.layer.AltarLayer"):createWithCCBIFile("ccbi/AltarLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_LIMIT_GIFT then
    --     node = require("src.layer.promotion.PROMLimitGiftLayer"):createWithCCBIFile("ccbi/PROMLimitGiftLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_MONTH_INVEST then
    --     node = require("src.layer.promotion.PROMMonthInvestLayer"):createWithCCBIFile("ccbi/PROMMonthInvestLayer.ccbi")
    -- elseif layer_type == MainSceneType.CLAN then
    --     node = require("src.layer.clan.ClanLayer"):createWithCCBIFile("ccbi/ClanLayer.ccbi")
    -- elseif layer_type == MainSceneType.CLAN_GVG then
    --     node = require("src.layer.clan.ClanGvgLayer"):createWithCCBIFile("ccbi/ClanGvgLayer.ccbi")
    -- elseif layer_type == MainSceneType.CLAN_BOSS then
    --     node = require("src.layer.clan.ClanBossLayer"):createWithCCBIFile("ccbi/ClanBossLayer.ccbi")
    -- elseif layer_type == MainSceneType.MISSION then
    --     node = require("src.layer.MissionLayer"):createWithCCBIFile("ccbi/MissionLayer.ccbi")
    -- elseif layer_type == MainSceneType.SEVEN_DAY_TARGET_LAYER then
    --     node = require("src.layer.SevenDayTargetLayer"):createWithCCBIFile("ccbi/SevenDayTargetLayer.ccbi")
    -- elseif layer_type == MainSceneType.MLT_BATTLE then
    --     node = require("src.layer.battle.BattleLayer"):create()
    -- elseif layer_type == MainSceneType.MLT_BATTLE_TEST then
    --     node = require("src.layer.battle.TestBattleLayer"):create()
    -- elseif layer_type == MainSceneType.MLT_BATTLE_OLD then
    --     node = require("src.layer.BattleLayer"):create()
    -- elseif layer_type == MainSceneType.MAINCITY_LIMIT_TIME_ACTIVITY then
    --     node = require("src.layer.promotion.LimitTimeActivityLayer"):createWithCCBIFile("ccbi/LimitTimeActivityLayer.ccbi")
    -- elseif layer_type == MainSceneType.FETTER_MAIN_VIEW then
    --     node = require("src.layer.fetters.FetterMainViewLayer"):createWithCCBIFile("ccbi/FetterMainViewLayer.ccbi")
    -- elseif layer_type == MainSceneType.DRAGON_VIEW then
    --     node = require("src.layer.fetters.FetterUnlockLayer"):createWithCCBIFile("ccbi/FetterUnlockLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_SMITH then
    --     node = require("src.layer.smith.SmithLayer"):createWithCCBIFile("ccbi/SmithLayer.ccbi")
    -- elseif layer_type == MainSceneType.FETTER_INFO then
    --     node = require("src.layer.fetters.FettersInfoLayer"):createWithCCBIFile("ccbi/FettersInfoLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_EDIT then
    --     node = require("src.layer.battle.BattleEditLayer"):create()
    -- elseif layer_type == MainSceneType.MAINCITY_BLACKMARKETSHOP then
    --     node = require("src.layer.shop.BlackMarketShopCtr"):createWithCCBIFile("ccbi/BlackMarketShopLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_MARKETSHOP then
    --     node = require("src.layer.shop.MarketShopCtr"):createWithCCBIFile("ccbi/MarketShopLayer.ccbi")
    -- elseif layer_type == MainSceneType.DREAM_LAYER then
    --     node = require("src.layer.dream.DreamCtr"):createWithCCBIFile("ccbi/DreamLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_SLZM then
    --     node = require("src.layer.SlzmLayer"):createWithCCBIFile("ccbi/SlzmLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_HERO_PERNUTE then
    --     node = require("src.layer.HeroPernuteLayerCtr"):createWithCCBIFile("ccbi/HeroPernuteLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_CHAMPIONSHIP_LIKE then
    --     node = require("src.layer.champion.ChampionShowLayer"):createWithCCBIFile("ccbi/ChampionShowLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_CHAMPIONSHIP then
    --     node = require("src.layer.champion.ChampionLayer"):createWithCCBIFile("ccbi/ChampionLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_CHAMPIONCROSS_LIKE then
    --     node = require("src.layer.championcross.ChampionCrossShowLayer"):createWithCCBIFile("ccbi/ChampionCrossShowLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_CHAMPIONCROSS then
    --     node = require("src.layer.championcross.ChampionCrossLayer"):createWithCCBIFile("ccbi/ChampionCrossLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_DEVELOP_GIFT then
    --     node = require("src.layer.promotion.DevelopGiftActivityLayer"):createWithCCBIFile("ccbi/LimitTimeActivityLayer.ccbi")
    -- elseif layer_type == MainSceneType.LEAGUE_PORTAL then
    --     node = require("src.layer.LeaguePortalMainLayer"):createWithCCBIFile("ccbi/LeaguePortalMainLayer.ccbi")
    -- elseif layer_type == MainSceneType.LADDER_WAR_MAIN then
    --     node = require("src.layer.LadderWarMainLayer"):createWithCCBIFile("ccbi/LadderWarMainLayer.ccbi")
    -- elseif layer_type == MainSceneType.HERO_CREAT_LAYER then
    --     node = require("src.layer.HeroCreatLayer"):createWithCCBIFile("ccbi/HeroCreatLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_CHSD then
    --     node = require("src.layer.RainbowMainLayer"):createWithCCBIFile("ccbi/RainbowMainLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_ANCIENT then
    --     node = require("src.layer.ancient.AncientLayer"):createWithCCBIFile("ccbi/AncientLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_GOD_RELIC_LIST then
    --     node = require("src.layer.godrelic.GRMissionListLayer"):createWithCCBIFile("ccbi/GRMissionListLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_GOD_RELIC then
    --     node = require("src.layer.godrelic.GRMissionLayer"):createWithCCBIFile("ccbi/GRMissionLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_HERO_PALACE then
    --     node = require("src.layer.HeroPalaceLayer"):createWithCCBIFile("ccbi/HeroPalaceLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_LIMIT_TIME_SERVER then
    --     node = require("src.layer.promotion.LimitTimeServerActivityLayer"):createWithCCBIFile("ccbi/LimitTimeActivityLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_TEAM_ARENA then
    --     node = require("src.layer.teamarena.TeamArenaLayer"):createWithCCBIFile("ccbi/TeamArenaLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_SUPER_STAGE_MAIN then
    --     node = require("src.layer.superstage.SuperStageMainLayer"):createWithCCBIFile("ccbi/SuperStageMainLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_SUPER_STAGE_TOKEN then
    --     node = require("src.layer.superstage.SuperStageTokenLayer"):createWithCCBIFile("ccbi/SuperStageTokenLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_SUPER_STAGE_LEGEND then
    --     node = require("src.layer.superstage.SuperStageLegendLayer"):createWithCCBIFile("ccbi/SuperStageLegendLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_SUPER_STAGE_MATCH then
    --     node = require("src.layer.superstage.SuperStageMatchLayer"):createWithCCBIFile("ccbi/SuperStageMatchLayer.ccbi")
    -- elseif layer_type == MainSceneType.MAINCITY_FLOATING_ISLANDS_BOSS1 then
    --     node = require("src.layer.floatingislands.FloatingIslandsBossLayer"):createWithCCBIFile("ccbi/FloatingIslandsBossLayer.ccbi")        
    -- end
    return node
end

function MainSceneCtr:getMainSceneLayer(layer_type)
    local main_scene = self:getMainScene()
    if self:getCurLayerType() ~= layer_type or
      (not main_scene) or
      (not self:getCurLayer())  then
        return nil
    end
    return self:getCurLayer()
end

function MainSceneCtr:changeToRechargePage(params)
    -- local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_DAILY_CHECK)
    -- layer:changeToRechargePage()

    -- if require("src.model.Game"):instance().server_id > 800 and device.platform == "ios" then
    --     if not params then 
    --         params = {}
    --         params.cur_id = 102
    --     end 
    --     ex.JumpManager:jumpByAtom("act_recharge", params)
    -- else
    --     ex.JumpManager:jumpByAtom("act_recharge_smart")
    -- end
    ex.JumpManager:jumpByAtom("act_recharge")
end

function MainSceneCtr:setBattle(evt, from, to)
    local main_scene = self:getMainScene()
    if not main_scene then
        return
    end
    main_scene.lbl_attack:setString(to)
end

function MainSceneCtr:setGold(from, to)
    local main_scene = self:getMainScene()
    if not main_scene then
        return
    end
    main_scene:updateResNum()
end

function MainSceneCtr:setGem(from, to)
    local main_scene = self:getMainScene()
    if not main_scene then
        return
    end
    main_scene:updateResNum()
end

function MainSceneCtr:setExp(level, exp)
    local main_scene = self:getMainScene()
    if not main_scene then
        return
    end

    local config = cfg.mainlevel.mainlevel[level]
    if config then
        main_scene.progress_exp:setPercentage(1.0 * exp / config.exp * 100)
    else
        main_scene.progress_exp:setPercentage(0)
    end
    main_scene.lbl_level:setString(level)
end

function MainSceneCtr:setNick(nick)
    local main_scene = self:getMainScene()
    if not main_scene then
        return
    end
    main_scene.lbl_role_nick:setString(nick);
end


function MainSceneCtr:setHeadIcon(head_id)
    local main_scene = self:getMainScene()
    if not main_scene then
        return
    end

    local spr_head = main_scene.spr_head
    local sfc = cc.SpriteFrameCache:getInstance()
    local frame = sfc:getSpriteFrame(string.format("head-icon/%d.png", head_id))
    if frame then
      spr_head:setSpriteFrame(frame)
    end
end

function MainSceneCtr:onRole()
    require("src.layer.SettingCtr"):instance():openWindow()
end

function MainSceneCtr:onAddGold()
    require("src.layer.BuyGoldCtr"):instance():openWindow()
end

function MainSceneCtr:onAddGem()
    ex.MainSceneCtr:changeToRechargePage()
end

function MainSceneCtr:addResEvent(event, item_type)
    -- ex.EventManager:fire(event, item_type)
    if (not event) or (not item_type) then
        print(event, item_type)
        return
    end

    if self.vec_res_evect[item_type] then
        self.vec_res_evect[item_type][event] = true
    else
        -- 事件结构体
        -- self.vec_res_evect = [item_type={event=true} , ... ]

        -- 初始化事件结构体
        local data = {}
        data[event] = true
        self.vec_res_evect[item_type] = data
    end
end

function MainSceneCtr:getTopY()
    if self.layer then
        local world_pos = self.layer.spr_up_bg:convertToWorldSpace(cc.p(0, 0))
        return world_pos.y
    end

    local bottom_height = self:getMenuScaleHeight()
    local height_diff = self:getBottomHeight() - bottom_height
    local top_height = (122 - height_diff) + 22
    return top_height
    -- return ex.p.height - (ex.p.width / 616) * 148 - require("src.model.Game"):instance():getNotchHeight()
end

function MainSceneCtr:getTopHeight()
    local top_y = self:getTopY();
    -- ex.p.height
    return ex.p.height - top_y;
end

function MainSceneCtr:runCloudAnimation(delay, callback)
    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/cloud-1.plist")


    require("src.model.ResManager"):instance():addPlist({"ccbi-res/cloud-1.plist"})

    local spr_cloud1 = cc.Sprite:createWithSpriteFrameName("cloud-1/cloud-1-y-1.png")
    spr_cloud1:setAnchorPoint(cc.p(1, 0.5))
    spr_cloud1:setPosition(0, ex.p.height * 0.5)
    spr_cloud1:setScaleX(ex.p.width / 640)
    spr_cloud1:setScaleY(ex.p.height / 1280)
    self.layer:addChild(spr_cloud1, 999999)

    local spr_cloud2 = cc.Sprite:createWithSpriteFrameName("cloud-1/cloud-1-y-2.png")
    spr_cloud2:setAnchorPoint(cc.p(0, 0.5))
    spr_cloud2:setPosition(ex.p.width, ex.p.height * 0.5)
    spr_cloud2:setScaleX(ex.p.width / 640)
    spr_cloud2:setScaleY(ex.p.height / 1280)
    self.layer:addChild(spr_cloud2, 999999)

    -- 创建一个吞噬节点。禁止点击其他地方
    local touch_node = cc.Node:create()
	self.layer:addChild(touch_node, 999999)

    self.listener_touch = cc.EventListenerTouchOneByOne:create()  --创建一个单点事件监听
    self.listener_touch:setSwallowTouches(true)
    self.listener_touch:registerScriptHandler(function(touch, event)
        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN)

    self.listener_touch:registerScriptHandler(function()
    end, cc.Handler.EVENT_TOUCH_MOVED)

    self.listener_touch:registerScriptHandler(function(touch, event)
    end, cc.Handler.EVENT_TOUCH_ENDED)

    local event_dispatcher = touch_node:getEventDispatcher() 
    event_dispatcher:addEventListenerWithSceneGraphPriority(self.listener_touch, touch_node)

    touch_node:runAction(cc.Sequence:create(cc.DelayTime:create(0.3),
                                            cc.DelayTime:create(delay),
                                            cc.DelayTime:create(0.3),
                                            cc.CallFunc:create(function()
                                                require("src.model.ResManager"):instance():removePlist({"ccbi-res/cloud-1.plist"})
                                                require("src.model.ResManager"):instance():removeImage({})
                                            end),
                                            cc.RemoveSelf:create()
                                        ))

    spr_cloud1:runAction(cc.Sequence:create(cc.EaseExponentialOut:create(cc.MoveTo:create(0.3, cc.p(ex.p.width * 1, ex.p.height * 0.5))),
                                            cc.CallFunc:create(callback),
                                            cc.DelayTime:create(delay),
                                            cc.MoveTo:create(0.2, cc.p(spr_cloud1:getPosition())),
                                            cc.RemoveSelf:create()))
    spr_cloud2:runAction(cc.Sequence:create(cc.EaseExponentialOut:create(cc.MoveTo:create(0.3, cc.p(ex.p.width * 0, ex.p.height * 0.5))),
                                            cc.DelayTime:create(delay),
                                            cc.MoveTo:create(0.2, cc.p(spr_cloud2:getPosition())),
                                            cc.RemoveSelf:create()))


end

return MainSceneCtr

