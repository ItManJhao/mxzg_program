local LogoScene = class("LogoScene", require("src.comp.EventLayer"))
local LogoSceneCtr = class("LogoSceneCtr", require("src.scene.SceneCtr"))

-- 修改本界面需要注意
-- UpdateScene 跟 LogoScene 有部分资源是共用的
-- 共用的资源必须重新加载一次

local LoadingSceneCtr = require("src.scene.LoadingSceneCtr")
local AnimationFactory = require("src.anim.AnimationFactory")

require("src.model.TableEx")

local DS_FAIL = 0
local DS_FINISH = 1
local DS_CHECKING_SERVER = 2
local DS_UNCHECK_SERVER = 3
local DS_NEED_DOWNLOAD_PACKAGE = 4
local DS_WAIT_DOWNLOAD = 5
local DS_WAIT_WIFI_TIP = 6
local DS_WIFI_TIP_INCOMPLETE = 7
local DS_NOT_ENOUGH_DISK = 8 
local DS_DOWNLOAD_INCOMPLETE = 9
local DS_WAIT_DECOMPRESS = 10

function LogoScene:onCreate()
    cc.FileUtils:getInstance():purgeCachedEntries()
    -- 重新加载图片资源
    cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
    cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    cc.FileUtils:getInstance():purgeCachedEntries()

    -- cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444
    -- cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_BGR_A8888)
    -- cc.TEXTURE2_D_PIXEL_FORMAT_BGR_A8888

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:removeSpriteFramesFromFile("ccbi-res/loading.plist")
    sfc:removeSpriteFramesFromFile("ccbi-res/logo-scene.plist")
    sfc:reloadTexture("ccbi-res/loading.plist")
    sfc:reloadTexture("ccbi-res/logo-scene.plist")
    cc.Director:getInstance():getTextureCache():reloadTexture("ccbi-res/loading.pvr.ccz")
    cc.Director:getInstance():getTextureCache():reloadTexture("ccbi-res/logo-scene.pvr.ccz")
    
    sfc:addSpriteFrames("ccbi-res/loading.plist")
    sfc:addSpriteFrames("ccbi-res/logo-scene.plist")
    cc.Director:getInstance():getTextureCache():reloadTexture("spine/jiemian.png")

    -- 重新加载这个界面的资源
    self.cur_config_index = 1
    self.max_config_index = 1

    self:initLayer()
    self:initDownLoad()
end

function LogoScene:initLayer()
    -- 重新加载图片资源
    cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
    cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    cc.Director:getInstance():purgeCachedData()
    cc.FileUtils:getInstance():purgeCachedEntries()

    require("src.model.AudioManager"):instance():playMusic("music/logo.mp3")

    local win_size = cc.Director:getInstance():getWinSize()
    
    local logo = cc.Sprite:create("ccbi-res/map-bg-loading.jpg")
    local scale_x = win_size.width / logo:getContentSize().width
    local scale_y = win_size.height / logo:getContentSize().height
    logo:setScale(scale_x > scale_y and scale_x or scale_y)
    logo:setPosition(cc.p(win_size.width * 0.5, win_size.height * 0.5))
    self:addChild(logo)

    local spine_girl = sp.SkeletonAnimation:create("spine/jiemian.json", "spine/jiemian.atlas", 1)
    spine_girl:setAnimation(0, "stand", true)
    spine_girl:setScale(win_size.width / 770)
    spine_girl:setPosition(win_size.width / 2, win_size.height * 0.55)
    self:addChild(spine_girl, 1)

    -- local spr_parttern_l = cc.Sprite:createWithSpriteFrameName("logo-scene/spr-parttern-l.png")
    -- spr_parttern_l:setAnchorPoint(0, 0.5)
    -- spr_parttern_l:setPosition(-50, win_size.height * 0.6)
    -- self:addChild(spr_parttern_l, 2)

    -- local spr_parttern_r = cc.Sprite:createWithSpriteFrameName("logo-scene/spr-parttern-r.png")
    -- spr_parttern_r:setAnchorPoint(1, 0.5)
    -- spr_parttern_r:setPosition(win_size.width + 50, win_size.height * 0.6)
    -- self:addChild(spr_parttern_r, 2)

    local spr_logo = cc.Sprite:createWithSpriteFrameName("logo-scene/spr-logo.png")
    spr_logo:setPosition(win_size.width / 2, 350)
    -- spr_logo:setScale(0.75)
    self:addChild(spr_logo, 3)

    -- 清除部分数据
	require("src.net.ResponseManager"):instance():clear()
    package.loaded["src.native.Native"] = nil
    package.loaded["src.RegisterGlobal"] = nil
    package.loaded["src.net.ResponseManager"] = nil
    cpp.ResponseManager:instance():clearLuaResponse()
    require("src.native.Native").clearRoleData()
    require("src.native.Native").clearAllFile({"src.scene.LogoSceneCtr", "src.scene.SceneCtr"})

    cpp.MainSceneCtr:instance():reloadConfigOne(8)
    cpp.MainSceneCtr:instance():reloadConfigOne(2)
end

function LogoScene:initDownLoad()
    local win_size = cc.Director:getInstance():getWinSize()
    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/loading.plist")
    sfc:addSpriteFrames("ccbi-res/logo-scene.plist")

    self.node_progress = cc.Node:create()
    self:addChild(self.node_progress)

-- 进度条背景
    local progress_bg = cc.Sprite:createWithSpriteFrameName("loading/progress-bg.png")
    -- progress_bg:setScale(1.5)
    progress_bg:setPosition(win_size.width / 2, 100)
    self.node_progress:addChild(progress_bg, 10)

-- 进度条
    self.progress = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("loading/progress.png"))
    self.progress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.progress:setMidpoint(cc.p(0, 0.5))
    self.progress:setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.progress:setPosition(progress_bg:getPosition())
    self.progress:setScale(progress_bg:getScale())
    self.node_progress:addChild(self.progress, 20)

    -- self.progress_spine = sp.SkeletonAnimation:create("spine/10201001-1.json","spine/10201001-1.atlas", 1)
    -- self.progress_spine:setAnimation(0, "stand", true);
    -- self.progress_spine:setPosition(self.progress:getPositionX() + self.progress:getContentSize().width * self.progress:getScaleX() * (self.progress:getPercentage() / 100 - 0.5), self.progress:getPositionY())
    -- self.node_progress:addChild(self.progress_spine, 30)


    local progress_pattern_1 = cc.Sprite:createWithSpriteFrameName("loading/progress-pattern.png")
    progress_pattern_1:setPosition(win_size.width / 2 - progress_bg:getContentSize().width / 2, progress_bg:getPositionY())
    self.node_progress:addChild(progress_pattern_1, 25)

    local progress_pattern_2 = cc.Sprite:createWithSpriteFrameName("loading/progress-pattern.png")
    progress_pattern_2:setFlippedX(true)
    progress_pattern_2:setPosition(win_size.width / 2 + progress_bg:getContentSize().width / 2, progress_bg:getPositionY())
    self.node_progress:addChild(progress_pattern_2, 25)

    self.lbl_tip = cc.Label:createWithSystemFont("正在解壓資源中，此過程不消耗流量", "Arial", 36) --cc.Label:createWithTTF("正在加载文件", "font/FZCSJW--GB1-0.ttf", 36)
    self.lbl_tip:setTextColor(cc.c4b(252, 241, 208, 255))
    self.lbl_tip:setScale(0.5)
    self.lbl_tip:enableShadow(cc.c4b(0, 0, 0, 255), cc.size(1, -1), 2)
    self.lbl_tip:enableOutline(cc.c4b(0, 0, 0, 255), 1.5)
    self.lbl_tip:setPosition(cc.p(progress_bg:getPositionX(), progress_bg:getPositionY() + 30))
    -- self.lbl_tip:setVisible(false)
    self.node_progress:addChild(self.lbl_tip, 25)

-- 进度
    self.lbl_percent = cc.Label:createWithSystemFont("0%", "Arial", 36) -- cc.Label:createWithTTF("0%", "font/FZCSJW--GB1-0.ttf", 36)
    self.lbl_percent:setTextColor(cc.c4b(252, 241, 208, 255))
    self.lbl_percent:setScale(0.5)
    self.lbl_percent:enableShadow(cc.c4b(0, 0, 0, 255), cc.size(1, -1), 2)
    self.lbl_percent:enableOutline(cc.c4b(0, 0, 0, 255), 1.5)
    self.lbl_percent:setPosition(cc.p(progress_bg:getPositionX(), progress_bg:getPositionY() + 1))
    self.node_progress:addChild(self.lbl_percent, 200)

-- 定时器
    self.loaded_file_list = {}
    is_new_load_init = true
    self.load_file_list = require("src.config.Init")
    is_new_load_init = nil

    print("self.callback_download")
    self.callback_download = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.updateLoadFile), 0.02, false)

    -- 预防更新完成后报错
    local addTip = function()
        require("src.model.Tools"):addLoadingTip(self.node_progress, cc.p(win_size.width * 0.5, 45))
    end
    local status, msg = xpcall(addTip, __G__TRACKBACK__)
    if not status then
        print(msg)
    end
end

function LogoScene:initStartGame()
    local win_size = cc.Director:getInstance():getWinSize()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/logo-scene.plist");
    cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/common-ui.plist");
    cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/common-ui-2.plist");
    -- dump(cc.FileUtils:getInstance():getValueMapFromFile("ccbi-res/logo-scene.plist"))

    local logo_scene_ctr = require("src.scene.LogoSceneCtr")

    self.node_server = cc.Node:create()
    self:addChild(self.node_server, 100)

    local menu = cpp.UIMenu:create()
    menu:setPosition(cc.p(0,0))
    self.node_server:addChild(menu, 10)

    self.btn_choose_server = cpp.UIMenuItemLabel:create("logo-scene/spr-server-bg.png",
                                                        "logo-scene/spr-server-bg.png",
                                                        ex.Tools:getLang(2).."--",
                                                        nil)
    -- self.btn_choose_server:setScale(0.75)
    self.btn_choose_server:setLabelSize(36)
    self.btn_choose_server:setPosition(cc.p(win_size.width / 2, 210))
    self.btn_choose_server:setVisible(true)
    self.btn_choose_server:registerScriptTapHandler(handler(logo_scene_ctr:instance(), logo_scene_ctr:instance().onSelectServer))
    menu:addChild(self.btn_choose_server)

    self.btn_start_game = cpp.UIMenuItemImage:createWithSpriteFrameName("logo-scene/btn-start-game-1.png",
                                                                        "logo-scene/btn-start-game-2.png",
                                                                        nil)
    self.btn_start_game:setVisible(true)
    self.btn_start_game:setPosition(win_size.width / 2, 120)
    self.btn_start_game:registerScriptTapHandler(handler(logo_scene_ctr:instance(), logo_scene_ctr:instance().onStartGame))
    menu:addChild(self.btn_start_game)

    self.btn_change_account = cpp.UIMenuItemImage:createWithSpriteFrameName("logo-scene/btn-change-account.png",
                                                                            "logo-scene/btn-change-account.png",
                                                                            nil)
    self.btn_change_account:setPosition(cc.p(win_size.width - 60, win_size.height - 150))
    self.btn_change_account:setVisible(true)
    self.btn_change_account:registerScriptTapHandler(handler(logo_scene_ctr:instance(), logo_scene_ctr:instance().onChangeAccount))
    menu:addChild(self.btn_change_account)

    self.btn_notice = cpp.UIMenuItemImage:createWithSpriteFrameName("logo-scene/btn-notice.png",
                                                                    "logo-scene/btn-notice.png",
                                                                    nil)
    self.btn_notice:setPosition(cc.p(win_size.width - 60, win_size.height - 450))
    self.btn_notice:setVisible(true)
    self.btn_notice:registerScriptTapHandler(handler(logo_scene_ctr:instance(), logo_scene_ctr:instance().onNotice))
    menu:addChild(self.btn_notice)

    local is_user_center = cfg.socialplatform.isOpen("user_center")
    if is_user_center then
        self.btn_user = cpp.UIMenuItemImage:createWithSpriteFrameName("logo-scene/btn-user.png",
                                                                    "logo-scene/btn-user.png",
                                                                    nil)
        self.btn_user:setPosition(cc.p(win_size.width - 60, win_size.height - 250))
        self.btn_user:setVisible(true)
        self.btn_user:registerScriptTapHandler(handler(logo_scene_ctr:instance(), logo_scene_ctr:instance().onUser))
        menu:addChild(self.btn_user)


        self.btn_service = cpp.UIMenuItemImage:createWithSpriteFrameName("logo-scene/btn-service.png",
                                                                        "logo-scene/btn-service.png",
                                                                        nil)
        self.btn_service:setPosition(cc.p(win_size.width - 60, win_size.height - 350))
        self.btn_service:setVisible(true)
        self.btn_service:registerScriptTapHandler(handler(logo_scene_ctr:instance(), logo_scene_ctr:instance().onService))
        menu:addChild(self.btn_service)
    end

    if cpp.SocialPlatform:instance():isDebug() then
        -- local btn_login = cpp.UIMenuItemLabel:create("button/btn-info.png",
        --                                              "button/btn-info.png",
        --                                              "登",
        --                                              nil)
        -- btn_login:setVisible(true)
        -- btn_login:setLabelColor(FONT_BLACK)
        -- btn_login:setPosition(win_size.width - 250, win_size.height - 150)
        -- btn_login:registerScriptTapHandler(handler(logo_scene_ctr:instance(), logo_scene_ctr:instance().onUserLogin))
        -- menu:addChild(btn_login)


        -- local btn_load = cpp.UIMenuItemLabel:create("button/btn-info.png",
        --                                             "button/btn-info.png",
        --                                             "下",
        --                                             nil)
        -- btn_load:setLabelColor(FONT_BLACK)
        -- btn_load:setVisible(true)
        -- btn_load:setPosition(win_size.width - 250, win_size.height - 150)
        -- btn_load:registerScriptTapHandler(handler(logo_scene_ctr:instance(), logo_scene_ctr:instance().onUserLogin))
        -- menu:addChild(btn_load)

        local btn_login = cpp.UIMenuItemLabel:create("button/btn-info.png",
                                                    "button/btn-info.png",
                                                    "修",
                                                    nil)
        btn_login:setVisible(true)
        btn_login:setLabelColor(FONT_BLACK)
        btn_login:setPosition(win_size.width - 150, win_size.height - 150)
        btn_login:registerScriptTapHandler(handler(logo_scene_ctr:instance(), logo_scene_ctr:instance().onFixRes))
        menu:addChild(btn_login)

        -- 初始化账号输入框
        -- self:initAccountInputBox()
    end

    --切换语言功能
    local is_switch_language = cfg.socialplatform.isOpen("language_select")
    if is_switch_language then
        self.btn_language_select = cpp.UIMenuItemLabel:create("logo-scene/btn-switchlanguage.png",
                                                                        "logo-scene/btn-switchlanguage.png",
                                                                        ex.Tools:getLang(81),
                                                                        nil)

        self.btn_language_select:setVisible(true)
        self.btn_language_select:setLabelColor(cc.c4b(238,221,193,255))
        self.btn_language_select:setLabelSize(44)
        self.btn_language_select:setLabelOutLine(cc.c4b(85,60,43,255),4)
        self.btn_language_select:setLabelOffset(cc.p(0, -30))

        self.btn_language_select:setPosition(cc.p(win_size.width - 60, win_size.height - 550))
        self.btn_language_select:registerScriptTapHandler(handler(logo_scene_ctr:instance(), logo_scene_ctr:instance().onLanguage))
        menu:addChild(self.btn_language_select)
    end
    
end

-- 初始化账号输入框
function LogoScene:initAccountInputBox()
    self.input_bg = cc.Scale9Sprite:createWithSpriteFrameName("win-bg/block-bg-29.png",cc.rect(10,10,1,1))
    -- self.input_bg:setRotation(-90)
    self.input_bg:setContentSize(cc.size(240, 50))
    self.input_bg:setIgnoreAnchorPointForPosition(false)
    self.input_bg:setAnchorPoint(cc.p(0.5, 0.5))
    self.input_bg:setPosition(self.btn_choose_server:getPositionX(), self.btn_choose_server:getPositionY() + 50)
    self:addChild(self.input_bg,999)

    local size =  self.input_bg:getContentSize()
	self.input_account = ccui.EditBox:create(size,"other/spr-null.png", 1)
	self.input_account:setPosition(self.input_bg:getPosition())
	self.input_account:setAnchorPoint(cc.p(0.5,0.5))
	self.input_account:setFontSize(18)
	self.input_account:setFontColor(cc.BROWN)
	-- self.input_account:setPlaceHolder(ex.Tools:getLang(47294))
	self.input_account:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
	self.input_account:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC) 
	self.input_account:registerScriptEditBoxHandler(handler(self,self.editboxHandle))
	self:addChild(self.input_account, 1000)

    local user_id = cc.UserDefault:getInstance():getStringForKey("last_login_account", "")
	if user_id == "" then
		user_id = require("src.model.Game"):instance().user_id
	end
    require("src.model.Game"):instance().user_id = user_id
    self.input_account:setText(user_id)
end

function LogoScene:editboxHandle(eventName, sender)
	if eventName == "began" then 

	elseif eventName == "ended" then 
		local str = sender:getText()
		if tonumber(str) ~= nil then 
			if tonumber(str) > 0 then
                local user_id = math.floor(tonumber(str))
                require("src.model.Game"):instance().user_id = user_id
                cc.UserDefault:getInstance():setStringForKey("last_login_account", user_id)

				self.input_account:setText(user_id)
			else
				self.input_account:setText("")
			end
		else
            self.input_account:setText("")
			ex.MessageView:add(ex.Tools:getLang(47294))
		end
	elseif eventName == "changed" then

	end
end

function LogoScene:onExit()
    self:stopTimer()
end

function LogoScene:stopTimer()
    if self.callbackEntry then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.callbackEntry)
        self.callbackEntry = nil
    end

    if self.callback_download then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.callback_download)
        self.callback_download = nil
    end
end

function LogoScene:clearNode()
    if self.node_tip then
        self.node_tip:removeFromParent()
        self.node_tip = nil
    end

    -- if self.node_progress and  not tolua.isnull() then
    if self.node_progress then
        self.node_progress:removeFromParent()
        self.node_progress = nil
    end

    if self.node_server then
        self.node_server:removeFromParent()
        self.node_server = nil
    end
end

function LogoScene:updateLoadFile(dt)
    local loaded_num = table.nums(self.loaded_file_list)
    local load_num = table.nums(self.load_file_list)

    local max_num = 10
    local index = 0
    for k,v in pairs(self.load_file_list) do
        table.insert(self.loaded_file_list, v) 
        require(v)
        self.load_file_list[k] = nil

        if index > max_num then
            break
        end
        index = index + 1
    end

    if load_num <= 0 then
        -- self.cur_config_index = self.cur_config_index + 1
        -- cpp.MainSceneCtr:instance():reloadConfigOne(8)
    end

    if load_num <= 0 and self.cur_config_index >= self.max_config_index then
        self:stopTimer()
        LogoSceneCtr:instance():loadingFinish()
        return
    end

    
    -- 设置进度条属性
    local percentage = (load_num + loaded_num) > 0 and loaded_num / (load_num + loaded_num) * 80 or 80
    percentage = percentage + self.cur_config_index / self.max_config_index * 20

    -- print("self.progress", percentage)

    self.progress:setPercentage(percentage)
    self.lbl_percent:setString(string.format("%d%%", percentage))
    -- self.progress_spine:setPositionX(self.progress:getPositionX() + self.progress:getContentSize().width * self.progress:getScaleX() *
    --                                 (self.progress:getPercentage() / 100 - 0.5))
end

function LogoSceneCtr:ctor()
    self.super:ctor()
end

function LogoSceneCtr:instance()
    if self._instance == nil then
        self._instance = self:create()
    end
    return self._instance
end


function LogoSceneCtr:loadLayer(scene)
    scene.scene_ctr = self
    self.scene = scene
    self.layer = LogoScene:create()
    self.layer:setName("LogoScene")
    scene:addChild(self.layer)
end

function LogoSceneCtr:isRuning()
    return display.getRunningScene():getChildByName("LogoScene") ~= nil
end

function LogoSceneCtr:runOutAnimation(node)
    return 0
end

function LogoSceneCtr:runEnterAnimation(node)
    return 0
end

function LogoSceneCtr:startGame()
    self.layer:clearNode()
    self.layer:initLayer()
    self.layer:initDownLoad()
end

function LogoSceneCtr:changeScene(dt)
    LoadingSceneCtr:instance():enterWithAnimation()
end


function LogoSceneCtr:loadingFinish()
    print("LogoSceneCtr:loadingFinish")

    require("src.native.Native").registerResponse()
    require "src.RegisterGlobal"
    require "src.ex.ExInit"
    require("src.native.Native").loadConfig()
    
    collectgarbage("collect")
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)


    -- 重新加载自己的数据
    local logo_scene_ctr = LogoSceneCtr:instance()
    logo_scene_ctr.layer:clearNode()
    cpp.SocialPlatform:instance():login(false)
    -- cpp.AssetManager:instance():destroy()
end

-- sdk登陆成功回调
function LogoSceneCtr:loginCallback(is_success, user_id, user_token, user_name, game_id)

    -- user_id = "Ky511563845555be124932dc"     
    if user_id == nil or user_id == "" then
        user_id = cpp.Game:instance():deviceUUID()
    end

    print("loginCallback", is_success, user_id, user_token, user_name)
    require("src.model.Game"):instance().user_id = user_id
    require("src.model.Game"):instance().user_token = user_token or ""
    require("src.model.Game"):instance().user_name = user_name or ""
    require("src.model.Game"):instance().game_id = game_id or ""
    
    cpp.NetManager:instance():setUserId(user_id)

    self.login_sign = ""
    -- 请求平台公告
    ex.PlatformHttpRequest:getDefaultServerInfo(handler(self, self.receiveDefaultServerInfo))
end

-- 获取默认服务器信息
function LogoSceneCtr:receiveDefaultServerInfo(value)
    self.selected_server = {}
    -- for k,v in pairs(value.data) do
        self.selected_server.server_url = value.data.server_url
        self.selected_server.server_port = value.data.server_port
        self.selected_server.msg = value.data.msg
        self.selected_server.server_id = tonumber(value.data.sid)
        self.selected_server.server_name = value.data.show_name
        self.selected_server.server_status = tonumber(value.data.server_status)
        self.selected_server.defend_end_time = tonumber(value.data.defend_end_time or "0")     -- 维护结束时间
        self.selected_server.is_new = tonumber(value.data.is_new)

        require("src.model.Game"):instance().user_id = tonumber(value.data.uid)
        self.login_sign = value.data.sign   -- 存储socket链接登陆所需的sign密钥，初始化NetManager时需要
        self.login_time = value.data.time
        self.is_white = tonumber(value.data.is_white) --角色是否处于白名单
        self.total_online_time = tonumber(value.data.online_time)           -- 总在线时间
        self.today_online_time = tonumber(value.data.today_online_time)     -- 今日在线时间

        -- break
    -- end

    if tonumber(value.data.uid) == nil then
        ex.MessageView:add("平台uid错误:"..value.msg)
        return
    end

    if table.nums(self.selected_server) < 0 then
        return
    end

    self.init_server_id = self.selected_server.server_id

    -- 初始化按钮节点显示
    self.layer:clearNode()
    self.layer:initStartGame()

    -- 请求默认服务器信息
    ex.PlatformHttpRequest:getNotice(handler(self, self.receiveNotice))

    -- print("self:isRuning()", self:isRuning(), display.getRunningScene():getChildByName("LogoScene"))
    if self:isRuning() ~= true then
        return
    end

    self.layer = display.getRunningScene():getChildByName("LogoScene")
    self.layer.btn_start_game:setVisible(true)
    self.layer.btn_choose_server:setVisible(true)

    cc.UserDefault:getInstance():setIntegerForKey("server_id", self.selected_server.server_id)
    cc.UserDefault:getInstance():setStringForKey("server_name", self.selected_server.server_name)

    -- require("src.platform.SocialPlatform"):submitRoleInfoLua("select_server")
  
    self.layer.btn_choose_server:setLabelText(ex.Tools:getLang(2) .. self.selected_server.server_name)
end

-- 获取平台公告回调
function LogoSceneCtr:receiveNotice(json)
    local str_content = ""
    local str_title = ""
    if json ~= nil and json.data ~= nil and json.data.content ~= nil then
        str_content = json.data.content
        str_title = json.data.label
    end
    
    -- 如果无内容则不自动弹出公告界面
    if str_content == nil or string.len(str_content) <= 0 then
        return
    end

    require("src.layer.NoticeCtr"):instance():closeWindow(0, nil)
    require("src.layer.NoticeCtr"):instance():openWindow(str_content, str_title)
end

-- 点击公告按钮的回调
function LogoSceneCtr:onNotice(tag, pSender)
    -- 请求默认服务器信息
    ex.PlatformHttpRequest:getNotice(function(json)
        local str_content = ""
        local str_title = ""
        if json ~= nil and json.data ~= nil and json.data.content ~= nil then
            str_content = json.data.content
            str_title = json.data.label
        end
    
        require("src.layer.NoticeCtr"):instance():closeWindow(0, nil)
        require("src.layer.NoticeCtr"):instance():openWindow(str_content, str_title)
    end)
end

-- 点击切换账号按钮的回调
function LogoSceneCtr:onChangeAccount(tag, pSender)
	-- 切换账号
	cpp.SocialPlatform:instance():logout()
    cc.UserDefault:getInstance():setStringForKey("last_login_account", "")
end

function LogoSceneCtr:onSelectServer()
    require("src.layer.ChooseServerCtr"):instance():openWindow(self.is_white)
end

function LogoSceneCtr:onChooseServerDone(server_data)
    self.selected_server = server_data

    self.layer.btn_choose_server:setLabelText(ex.Tools:getLang(2)..self.selected_server.server_name)
end

function LogoSceneCtr:onStartGame()
    -- print("selfxxx", self)
    if self.selected_server == nil or table.nums(self.selected_server) <= 0 then
        ex.MessageView:add("正在努力加载服务器列表")
        return
    end

    local now = ex.Game:getServerTime()
	if (self.selected_server.server_status == 3 or self.selected_server.server_status == 0 or self.selected_server.defend_end_time > now) and 
		self.is_white ~= nil and self.is_white <= 0 then
        if self.selected_server.msg and string.len(self.selected_server.msg) > 0 then
            ex.MessageView:add(self.selected_server.msg)
        else
            ex.MessageView:add("服务器正在维护中，请冒险者大人稍后再打开登陆传送门喵～")
        end
		return
	end

    if require("src.model.Game"):instance().user_id == nil then
        -- print("111")
        ex.MessageView:add("未知错误.")
        return
    end

    local ntime = os.time()
    if self.touch_start_time ~= nil and math.abs(ntime - self.touch_start_time) < 1 then
        -- 点的太快了
        return
    end

    self.touch_start_time = ntime

    -- print("user_id", require("src.model.Game"):instance().user_id)

    local player = require("src.data.Player"):instance()
    local game = require("src.model.Game"):instance()

    -- 未成年不允许进入游戏
    if game.is_adult ~= nil and game.is_adult == 1 then
        ex.MessageView:add(ex.Tools:getLang(41211))
        return
    end

    player.user_id = game.user_id
    game.server_id = self.selected_server.server_id

    cc.UserDefault:getInstance():setIntegerForKey("server_id", self.selected_server.server_id)
    cc.UserDefault:getInstance():setStringForKey("server_name", self.selected_server.server_name)
    
    -- if self.init_server_id == self.selected_server.server_id then
    --     self:loginDone()
    -- else
        ex.PlatformHttpRequest:loginPlatform(handler(self, self.loginDone), tostring(self.selected_server.server_id))
    -- end
end

function LogoSceneCtr:loginDone(json)
    if json ~= nil then
        if table.nums(json) <= 0 then
            return
        end
        if json.code ~= 200 then
            cpp.MessageView:instance():add("LogoSceneCtr:loginDone error_code: "..json.code)
            return
        end
    end

    if require("src.scene.LoadingSceneCtr"):instance():isRuning() == true then
        return
    end

    local game = require("src.model.Game"):instance()

    -- 重新刷一遍服务器信息
    self.selected_server.server_url = json.data.server_url
    self.selected_server.server_port = json.data.server_port
    self.selected_server.msg = json.data.msg
    self.selected_server.server_id = tonumber(json.data.sid)
    self.selected_server.server_name = json.data.show_name
    self.selected_server.server_status = tonumber(json.data.server_status)
    self.selected_server.defend_end_time = tonumber(json.data.defend_end_time or "0")     -- 维护结束时间
    self.selected_server.is_new = tonumber(json.data.is_new)

    game.user_id = tonumber(json.data.uid)
    -- self.login_sign = json.data.sign   -- 存储socket链接登陆所需的sign密钥，初始化NetManager时需要
    self.is_white = tonumber(json.data.is_white) --角色是否处于白名单
    self.total_online_time = tonumber(json.data.online_time)           -- 总在线时间
    self.today_online_time = tonumber(json.data.today_online_time)     -- 今日在线时间

    if json.msg and string.len(json.msg) >= 0 and json.msg ~= "ok" then
        ex.MessageView:add(json.msg)
        return
    end

    local now = ex.Game:getServerTime()
    -- 重新验证服务器状态
	if (self.selected_server.server_status == 3 or self.selected_server.server_status == 0 or self.selected_server.defend_end_time > now) and 
		self.is_white ~= nil and self.is_white <= 0 then
        if self.selected_server.msg and string.len(self.selected_server.msg) > 0 then
            ex.MessageView:add(self.selected_server.msg)
        else
            ex.MessageView:add("服务器正在维护中，请冒险者大人稍后再打开登陆传送门喵～")
        end
		return
    end
    
    if self.total_online_time ~= nil then
        cc.UserDefault:getInstance():setIntegerForKey("total_online_time", self.total_online_time)
    end

    -- 保存当前服务器名字
    cc.UserDefault:getInstance():setIntegerForKey("server_id", self.selected_server.server_id)
    cc.UserDefault:getInstance():setStringForKey("server_name", self.selected_server.server_name)

    -- clearRoleData
    -- 保存数据
    local player = require("src.data.Player"):instance()

    local game = require("src.model.Game"):instance()
    player.user_id = game.uid
    game.server_id = self.selected_server.server_id

    local net_manager = cpp.NetManager:instance()
    net_manager:stop()
    net_manager:close()
    net_manager:clearHosts()

    local server_ip = self.selected_server.server_url
    local hosts = self.selected_server.server_port
    -- local fine_index = string.find(self.selected_server.server_url, ":", 1, true)
    -- if fine_index then
    --     server_ip = string.sub(self.selected_server.server_url, 1, fine_index - 1)
    --     hosts = string.sub(self.selected_server.server_ip, fine_index + 1, string.len(self.selected_server.server_url))
    -- end

    if server_ip == nil or hosts == nil then
        ex.MessageView:add("错误：服务器不存在")
        return
    end
    -- print("loginDone", server_ip, tonumber(hosts))

    net_manager:addHosts(server_ip, tonumber(hosts))
    net_manager:setUserId(game.user_id)
    -- net_manager:setTimeStamp(tonumber(json.time))
    net_manager:setSign(self.login_sign)
    game.login_sign = self.login_sign
    game.login_time = self.login_time
    require("src.scene.LoadingSceneCtr"):instance():enterWithAnimation()

    require("src.platform.SocialPlatform"):submitRoleInfoLua("select_server")
  
    if buglySetUserId then
        buglySetUserId(game.user_id) 
    end
end

function LogoSceneCtr:onExit()
    cc.FileUtils:getInstance():purgeCachedEntries()
    cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
    cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    cc.FileUtils:getInstance():purgeCachedEntries()
end

function LogoSceneCtr:onUserLogin()
    require("src.layer.UserLoginCtr"):instance():openWindow()
end


function LogoSceneCtr:onUser()
	cpp.SocialPlatform:instance():showUserCenter()
end

function LogoSceneCtr:onService()
	cpp.SocialPlatform:instance():showCustomerService()
end

function LogoSceneCtr:onFixRes()
    ex.ConfirmCtr:openWindow("资源修复", "确定要修复本地资源吗？", function()
        local file_utils = cc.FileUtils:getInstance()
        local writable_path = file_utils:getWritablePath()
        cc.FileUtils:getInstance():removeDirectory(writable_path .. "res")
        cc.FileUtils:getInstance():removeDirectory(writable_path .. "src")
        cc.FileUtils:getInstance():removeDirectory(writable_path .. "version.rvs.pre")
        cc.FileUtils:getInstance():removeDirectory(writable_path .. "resversionex.rvs.pre")
        
        require("src.native.Native").changeToLogoSceneCtr()
    end)
end

function LogoSceneCtr:onLanguage()
    require("src.layer.LanguageSelectCtr"):instance():openWindow()
end

return LogoSceneCtr

