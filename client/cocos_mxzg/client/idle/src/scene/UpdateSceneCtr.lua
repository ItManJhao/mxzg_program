local UpdateScene = class("UpdateScene", function()
    return cc.Layer:create()
end)

local UpdateSceneCtr = class("UpdateSceneCtr", require("src.scene.SceneCtr"))
function UpdateScene:ctor()

    -- if true then
    --     return
    -- end
    
    print("UpdateScene:onCreate")
    self.disk_tip_time = 0
    local viewsize = cc.Director:getInstance():getWinSize()
    self.node_tip = cc.Node:create()
    self:addChild(self.node_tip)

    -- add backgound
    display.newLayer(cc.c4b(255, 255, 255, 255), cc.size(viewsize.width, viewsize.height)):addTo(self.node_tip)

    local status, msg = xpcall(function()
        local spr_anti = cc.Sprite:create("ccbi-res/anti-addiction.jpg")
        spr_anti:setPosition(cc.p(viewsize.width * 0.5, viewsize.height * 0.5))
        spr_anti:setScale(0.6)
        self.node_tip:addChild(spr_anti)
        spr_anti:setVisible(device.platform == "android")
    end, __G__TRACKBACK__)

    -- -- add tip
    -- local str_tip = {
    --     "《健康游戏忠告》",
    --     "抵制不良游戏，拒绝盗版游戏。",
    --     "注意自我保护，谨防受骗上当。",
    --     "适度游戏益脑，沉迷游戏伤身。",
    --     "合理安排时间，享受健康生活。"
    -- }

    -- -- add tip label
    -- local vec_len = table.getn(str_tip)
    -- for i = 1, vec_len do
    --     local lbl_tip = cc.Label:createWithSystemFont(str_tip[i], "Arial", 60) --cc.Label:createWithTTF(str_tip[i], "res/hd/font/FZCSJW--GB1-0.ttf", 60)
    --     lbl_tip:setPosition(viewsize.width * 0.5, viewsize.height * 0.5 + 100 * vec_len * 0.5 - 100 * i)
    --     lbl_tip:setColor(display.COLOR_BLACK)
    --     lbl_tip:enableShadow(cc.c3b(0, 0, 0), cc.p(1, 1), 10)
    --     lbl_tip:setScale(0.5)
    --     self.node_tip:addChild(lbl_tip)
    -- end
    -- 

    self:stopActionByTag(9999)
    local atc_init = cc.Sequence:create(cc.DelayTime:create(device.platform == "android" and 3 or 0),
                                        cc.CallFunc:create(function()
                                            self:stopTimer()
                                            self:initLayer()
                                        end))
    atc_init:setTag(9999)
    self:runAction(atc_init)

    self.download_speed = 0
    self.start_update_time = 0
    self.pre_download_size = 0
    self.asset_manager = require("src.model.AssetManager"):instance()
    self.asset_manager:reset()
    
    
    local net_manager = cpp.NetManager:instance()
    net_manager:stop()
    net_manager:close()
    net_manager:clearHosts()

    local status, msg = xpcall(function()
        require("src.model.AudioManager"):instance():playEffect("music/start-game.mp3")
    end, __G__TRACKBACK__)
    if not status then print(msg) end
    
    self:registerScriptHandler(function(eventType)
        if eventType == "exit" then
            self:stopTimer()
        end
    end)

end


function UpdateScene:onExit()
    print(" UpdateScene:onExit()")
    self:stopTimer()
end

function UpdateScene:stopTimer()
    if self.callbackEntry then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.callbackEntry)
        self.callbackEntry = nil
    end

    if self.callback_download then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.callback_download)
        self.callback_download = nil
    end
end

function UpdateScene:initLayer()
    require("src.model.AudioManager"):instance():playMusic("music/logo.mp3")

    local win_size = cc.Director:getInstance():getWinSize()
    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/loading.plist")
    sfc:addSpriteFrames("ccbi-res/logo-scene.plist")

    local new_view = function()
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
    end
    
    local status, msg = xpcall(new_view, __G__TRACKBACK__)
    if not status then print(msg) end

    self:initDownLoad()
end


function UpdateScene:initDownLoad()
    local win_size = cc.Director:getInstance():getWinSize()
    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/loading.plist")

    self.node_progress = cc.Node:create()
    self:addChild(self.node_progress)

-- 预防更新完成后报错
    local addTip = function()
-- 进度条背景
        local progress_bg = cc.Sprite:createWithSpriteFrameName("loading/progress-bg.png")
        -- progress_bg:setScale(1.5)
        progress_bg:setPosition(win_size.width / 2, 100)
        self.node_progress:addChild(progress_bg, 10)

        self.speed_time = 0
        self.now_speed = 0
        self.pre_download_lenght = 0
        self.now_download_lenght = 0

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

        self.lbl_tip = cc.Label:createWithSystemFont(" ", "Arial", 36) --cc.Label:createWithTTF(" ", "font/FZCSJW--GB1-0.ttf", 36)
        self.lbl_tip:setTextColor(cc.c4b(252, 241, 208, 255))
        self.lbl_tip:setScale(0.5)
        self.lbl_tip:enableShadow(cc.c4b(0, 0, 0, 255), cc.size(1, -1), 2)
        self.lbl_tip:enableOutline(cc.c4b(0, 0, 0, 255), 1.5)
        self.lbl_tip:setPosition(cc.p(progress_bg:getPositionX(), progress_bg:getPositionY() - 25))
        self.node_progress:addChild(self.lbl_tip, 200)

-- 进度
        self.lbl_percent = cc.Label:createWithSystemFont("正在驗證資源，此過程不消耗流量，請耐心等候", "Arial", 36)
        self.lbl_percent:setTextColor(cc.c4b(252, 241, 208, 255))
        self.lbl_percent:setScale(0.5)
        self.lbl_percent:enableShadow(cc.c4b(0, 0, 0, 255), cc.size(1, -1), 2)
        self.lbl_percent:enableOutline(cc.c4b(0, 0, 0, 255), 1.5)
        self.lbl_percent:setPosition(cc.p(progress_bg:getPositionX(), progress_bg:getPositionY() + 1))
        self.node_progress:addChild(self.lbl_percent, 200)

        require("src.model.Tools"):addLoadingTip(self.node_progress, cc.p(win_size.width * 0.5, 45))
    end

    local status, msg = xpcall(addTip, __G__TRACKBACK__)
    if not status then
        print(msg)
    end


-- 定时器
    self.download_speed = 0
    self.start_update_time = 0
    self.pre_download_size = 0
    self.save_staus_time = 0

    self:stopTimer()
    self.callback_download = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.updateDownload), 0.017, false)
end

function UpdateScene:updateDownload(dt)
    local download_size = self.asset_manager.cur_download_size + self.asset_manager.asset_manager:getNowDownloaded()
    local total_download_size = self.asset_manager.total_download_size

    -- 设置进度条属性
    local percentage = self.asset_manager.total_download_size > 0 and math.min(download_size / total_download_size * 100, 100) or 0
    self.progress:setPercentage(percentage)
    self.lbl_percent:setString(string.format("%d%%", percentage))
    -- self.progress_spine:setPositionX(self.progress:getPositionX() + self.progress:getContentSize().width * self.progress:getScaleX() *
    --                                 (self.progress:getPercentage() / 100 - 0.5))
    -- 

    if self.start_update_time - self.save_staus_time > 1 then
        self.save_staus_time = self.start_update_time

        self.download_speed = math.max(0, download_size - self.pre_download_size)
        self.pre_download_size = download_size
        self.asset_manager:saveDownloadStatus()
    end

    self.start_update_time = self.start_update_time + dt

    local str_speed = ""
    -- print(download_size, total_download_size, self.start_update_time, self.download_speed)
    str_speed = self.download_speed >= 1000 * 1000 and string.format("%dM", self.download_speed / 1000 / 1000) or string.format("%dK", self.download_speed / 1000)
    self.lbl_tip:setString(string.format("資源下載中...[%s,%.2fMB/%.2f/MB]", str_speed, download_size / 1000 / 1000, total_download_size / 1000 / 1000))

    self.lbl_tip:setVisible(self.asset_manager.download_status >= 2)
    if self.asset_manager.download_status < 2 then
        self.lbl_percent:setString("正在驗證資源，請耐心等候")
    end
end

-- 加载完成
function UpdateScene:downloadFinish()
    print("UpdateScene:downloadFinish")
    self:stopTimer()
    self.asset_manager:saveDownloadStatus(true, true, true)
    -- print("222222")

    -- 进入登录界面。登录界面会重新加载所有文件
    require("src.scene.LogoSceneCtr"):instance():enterWithAnimation()
end

function UpdateScene:clearNode()
    if self.node_tip then
        self.node_tip:removeFromParent()
        self.node_tip = nil
    end

    if self.node_progress then
        self.node_progress:removeFromParent()
        self.node_progress = nil
    end
end

function UpdateSceneCtr:ctor()
    self.super.ctor(self)
end

function UpdateSceneCtr:instance()
    if self._instance == nil then
        self._instance = self:create()
    end
    return self._instance
end

function UpdateSceneCtr:runOutAnimation(node)
    return 0
end

function UpdateSceneCtr:runEnterAnimation(node)
    return 0
end

function UpdateSceneCtr:loadLayer(scene)
    scene.scene_ctr = self
    self.scene = scene
    self.layer = UpdateScene:create()
    self.layer:setName("UpdateScene")
    scene:addChild(self.layer)
end

function UpdateSceneCtr:enter()
    self.super.enter(self)
    -- require("src.native.Native").loadConfig()
    -- require("src.native.Native").registerResponse()
    package.loaded["src.native.Native"] = nil
    require("src.native.Native").clearRoleData()
    require("src.native.Native").clearAllFile({"src.scene.UpgradeSuccessCtr", "src.scene.SceneCtr"})
end

function UpdateSceneCtr:didEnter()
    self.super.didEnter(self)

    self.layer.asset_manager.callback_finish = handler(self.layer, self.layer.downloadFinish)
    if device.platform == "mac" then
        -- self.asset_manager:downloadFinish()
        -- self.layer.asset_manager:checkDownloadList()
        self.layer:downloadFinish()
        -- dump(cc.Director:getInstance():getTextureCache():getCachedTextureInfo())
        -- self.layer:runAction(cc.Sequence:create(cc.DelayTime:create(3), cc.CallFunc:create(function()
        --     self.layer:downloadFinish()
        -- end)))
    else
        -- self.layer:downloadFinish()
        -- self.layer.asset_manager:checkDownloadList()
        self.layer:runAction(cc.Sequence:create(cc.DelayTime:create(device.platform == "android" and 3.5 or 0.1), cc.CallFunc:create(function()
            self.layer.asset_manager:checkDownloadList()
        end)))
    end
end

function UpdateSceneCtr:onExit()
    cc.FileUtils:getInstance():purgeCachedEntries()
    cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
    cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    cc.FileUtils:getInstance():purgeCachedEntries()
end

return UpdateSceneCtr
