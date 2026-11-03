--
-- Author: windy
-- Date: 2018-06-15 18:33:02
--
local LoadingScene = class("LoadingScene", require("src.comp.EventLayer"))
local LoadingSceneCtr = class("LoadingSceneCtr", require("src.scene.SceneCtr"))

local AnimationFactory = require("src.anim.AnimationFactory")

function LoadingScene:ctor()
    self:onCreate()
   -- self.super.ctor(self, nil, "LoadingScene")
end

function LoadingScene:onCreate()
	print("LoadingScene:onCreate")

    local win_size = cc.Director:getInstance():getWinSize()
    -- 添加logo背景
    local logo = cc.Sprite:create("ccbi-res/map-bg-loading.jpg")
    local scale_x = win_size.width / logo:getContentSize().width
    local scale_y = win_size.height / logo:getContentSize().height
    logo:setScale(scale_x > scale_y and scale_x or scale_y)
    logo:setPosition(cc.p(win_size.width * 0.5, win_size.height * 0.5))
    self:addChild(logo)

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/loading.plist")
    sfc:addSpriteFrames("ccbi-res/logo-scene.plist")
    sfc:addSpriteFrames("ccbi-res/common-ui.plist")
    sfc:addSpriteFrames("ccbi-res/common-ui-2.plist")

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

    self.node_progress = cc.Node:create()
    self:addChild(self.node_progress)

-- 进度条背景
    local progress_bg = cc.Sprite:createWithSpriteFrameName("loading/progress-bg.png")
    -- progress_bg:setBlendFunc({src = gl.ZERO, dst = gl.ONE_MINUS_SRC_ALPHA})
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

    self.lbl_tip = cc.Label:createWithSystemFont("正在加载資源，此過程不消耗流量", "Arial", 36)
    self.lbl_tip:setTextColor(cc.c4b(252, 241, 208, 255))
    self.lbl_tip:setScale(0.5)
    self.lbl_tip:enableShadow(cc.c4b(0, 0, 0, 255), cc.size(1, -1), 2)
    self.lbl_tip:enableOutline(cc.c4b(0, 0, 0, 255), 1.5)
    self.lbl_tip:setPosition(cc.p(progress_bg:getPositionX(), progress_bg:getPositionY() + 30))
    -- self.lbl_tip:setVisible(false)
    self.node_progress:addChild(self.lbl_tip, 25)

-- 进度
    self.lbl_percent = cc.Label:createWithTTF(ex.Tools:getLang(47270), FONT_DEFAULT_NAME_BOLD, 48)
    self.lbl_percent:setTextColor(cc.c4b(252, 241, 208, 255))
    self.lbl_percent:setScale(0.5)
    self.lbl_percent:enableShadow(cc.c4b(0, 0, 0, 255), cc.size(1, -1), 2)
    self.lbl_percent:enableOutline(cc.c4b(0, 0, 0, 255), 1.5)
    self.lbl_percent:setPosition(cc.p(progress_bg:getPositionX(), progress_bg:getPositionY() + 1))
    self.node_progress:addChild(self.lbl_percent, 200)


-- 预防更新完成后报错
    local addTip = function()
        require("src.model.Tools"):addLoadingTip(self.node_progress, cc.p(win_size.width * 0.5, 45))
    end
    local status, msg = xpcall(addTip, __G__TRACKBACK__)
    if not status then
        print(msg)
    end
end

function LoadingScene:onExit()
    -- print("LoadingScene:onExit")
    self:stopUpdate()
end

function LoadingScene:startUpdate()
    if self.callback_update then
        return
    end
    -- 定时器
    self.callback_update = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.update), 0.017, false)
end


function LoadingScene:stopUpdate()
    if self.callback_update then
      cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.callback_update)
      self.callback_update = nil
  end
end

function LoadingScene:update()
    local loading_scene_ctr = LoadingSceneCtr:instance()
    local img_percentage = loading_scene_ctr.count_image ~= 0 and (loading_scene_ctr.cur_image /  loading_scene_ctr.count_image * 100) or 0

    if cpp.NetManager:instance():getHostsNum() <= 0 then
        -- ex.MessageView:add("111111")
        return
    end

    -- 计算进度
    local net_count = 0
    for k,v in pairs(loading_scene_ctr.vec_protocol) do
        if v == true then
            net_count = net_count + 1
        elseif img_percentage > 80 then
            -- print("wait protocol:", k)
            -- ex.MessageView:add(string.format("wait protocol: %d", k))
        end
    end
    
    local net_percentage = net_count / table.nums(loading_scene_ctr.vec_protocol) * 100

    -- 如果有异步资源需要加载
    if loading_scene_ctr.count_image ~= 0 then
        local percentage = net_percentage * 0.3 + img_percentage * 0.7
        self.progress:setPercentage(percentage)
        -- self.progress_spine:setPositionX(self.progress:getPositionX() + self.progress:getContentSize().width * self.progress:getScaleX() * (self.progress:getPercentage() / 100 - 0.5))
        self.lbl_percent:setString(string.format("%d%%", percentage))
    else
        local percentage = net_percentage
        self.progress:setPercentage(percentage)
        -- self.progress_spine:setPositionX(self.progress:getPositionX() + self.progress:getContentSize().width * self.progress:getScaleX() * (self.progress:getPercentage() / 100 - 0.5))
        self.lbl_percent:setString(string.format("%d%%", percentage))
    end


    if net_percentage >= 100 and img_percentage >= 100 then
        self:stopUpdate()
        require("src.scene.MainSceneCtr"):instance():enterWithAnimation()
    end
end

function LoadingSceneCtr:ctor()
    self.super:ctor()
    self.cur_image = 0
    self.count_image = 0
end

function LoadingSceneCtr:instance()
    if self._instance == nil then
        self._instance = self:create()
    end
    return self._instance
end

function LoadingSceneCtr:getLayerClass()
    return LoadingScene
end

function LoadingSceneCtr:isLoadingFinish()
    -- return false
    return true
end

function LoadingSceneCtr:didEnter()
    self.super.didEnter(self)

    -- TEST 测试网络不好时.为什么会进入到这个界面
    if cpp.NetManager:instance():getHostsNum() <= 0 then
        dump(debug.traceback())
        require("src.scene.UpdateSceneCtr"):instance():enterWithAnimation()
        return
    end

    -- print("LoadingSceneCtr:didEnter")

    -- 清除部分数据
    require("src.net.ResponseManager"):instance():clear()
    require("src.net.ResponseManager")._instance = nil
    ex.ResponseManager = nil
    package.loaded["src.net.BattleResponse"] = nil
    
    require("src.model.AudioManager"):instance():playMusic("music/logo.mp3")

    -- 重新加载数据
    ex.ResponseManager = require("src.net.ResponseManager"):instance()

    ex.ResponseManager:registerResponse()
    -- print(ex.Tools:getLang(47347))

    self.vec_protocol = {}

    self:addProtocolWaiting(ProtocolID.GResRoleInfo)

    self:addProtocolWaiting(ProtocolID.GResHeroList)

    self:addProtocolWaiting(ProtocolID.GResBackPackList)

    -- self:addProtocolWaiting(ProtocolID.GResTrialCfg)

    -- self:addProtocolWaiting(ProtocolID.GResAchievementLevel)

    -- self:addProtocolWaiting(ProtocolID.GResDailyData)

    -- self:addProtocolWaiting(ProtocolID.GResRunesList)

    -- self:addProtocolWaiting(ProtocolID.GResChapterItemList)
        
    -- self:addProtocolWaiting(ProtocolID.GResExtraReward)

    self.layer:startUpdate()

    self.super.loadImageFile(self)

    local net_manager = cpp.NetManager:instance()
    net_manager:start()
    
    -- ctr:startTimer()
end

function LoadingSceneCtr:onExit()
    print("LoadingSceneCtr:onExit")
    if self:isRuning() then
        self.layer:stopUpdate()
    end
end

-- 屏蔽父节点的异步资源加载
function LoadingSceneCtr:loadImageFile()
end

function LoadingSceneCtr:getAsynImage()
    -- 重新加载图片资源
    cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
    cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    cc.FileUtils:getInstance():purgeCachedEntries()

    cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("ccbi-res/backpack.plist")
    cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("ccbi-res/backpack-4.plist")
    cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("ccbi-res/backpack-5.plist")
    cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("ccbi-res/common-ui.plist")
    cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("ccbi-res/common-ui-2.plist")

    cc.Director:getInstance():getTextureCache():removeTextureForKey("ccbi-res/backpack.pvr.ccz")
    cc.Director:getInstance():getTextureCache():removeTextureForKey("ccbi-res/backpack-4.pvr.ccz")
    cc.Director:getInstance():getTextureCache():removeTextureForKey("ccbi-res/backpack-5.pvr.ccz")
    cc.Director:getInstance():getTextureCache():removeTextureForKey("ccbi-res/common-ui.pvr.ccz")
    cc.Director:getInstance():getTextureCache():removeTextureForKey("ccbi-res/common-ui-2.pvr.ccz")

    local vec_image = {
                        {image_name = "ccbi-res/reload.png"},
                        -- {image_name = "ccbi-res/backpack-effect.pvr.ccz", plist_name="ccbi-res/backpack-effect.plist"},
                        {image_name = "ccbi-res/battle-scene.pvr.ccz", plist_name = "ccbi-res/battle-scene.plist"},

                        -- {image_name = "ccbi-res/box-effect.pvr.ccz"},
                        -- {image_name = "ccbi-res/chat.pvr.ccz"},
                        -- {image_name = "ccbi-res/clan.pvr.ccz"},
                        -- {image_name = "ccbi-res/clan-photo.pvr.ccz"},
                        -- {image_name = "ccbi-res/fantasy-tower.pvr.ccz"},
                        -- {image_name = "ccbi-res/fetters.pvr.ccz"},
                        -- {image_name = "ccbi-res/fetters-effect.pvr.ccz"},
                        -- {image_name = "ccbi-res/fetters-effect-2.pvr.ccz"},
                        {image_name = "ccbi-res/head-icon-lang.pvr.ccz", plist_name = "ccbi-res/head-icon-lang.plist"},
                        {image_name = "ccbi-res/head-icon-1.pvr.ccz", plist_name = "ccbi-res/head-icon-1.plist"},
                        {image_name = "ccbi-res/hero-icon-lang.pvr.ccz", plist_name = "ccbi-res/hero-icon-lang.plist"},
                        {image_name = "ccbi-res/hero-icon-1.pvr.ccz", plist_name = "ccbi-res/hero-icon-1.plist"},
                        {image_name = "ccbi-res/hero-icon-2.pvr.ccz", plist_name = "ccbi-res/hero-icon-2.plist"},
                        {image_name = "ccbi-res/hero-icon-3.pvr.ccz", plist_name = "ccbi-res/hero-icon-3.plist"},
                        {image_name = "ccbi-res/hero-icon-4.pvr.ccz", plist_name = "ccbi-res/hero-icon-4.plist"},
                        {image_name = "ccbi-res/hero-icon-5.pvr.ccz", plist_name = "ccbi-res/hero-icon-5.plist"},
                        {image_name = "ccbi-res/hero-icon-other.pvr.ccz", plist_name = "ccbi-res/hero-icon-other.plist"},
                        -- {image_name = "ccbi-res/hero-info.pvr.ccz", plist_name = "ccbi-res/hero-info.plist"},
                        -- {image_name = "ccbi-res/hero-info-effect.pvr.ccz"},
                        {image_name = "ccbi-res/main-city.pvr.ccz", plist_name = "ccbi-res/main-city.plist"},
                        -- {image_name = "ccbi-res/main-city-effect.pvr.ccz", plist_name = "ccbi-res/main-city-effect.plist"},
                        {image_name = "ccbi-res/main-scene.pvr.ccz", plist_name = "ccbi-res/main-scene.plist"},
                        {image_name = "ccbi-res/main-scene-lang.pvr.ccz", plist_name = "ccbi-res/main-scene-lang.plist"},
                        -- {image_name = "ccbi-res/main-summon.pvr.ccz", plist_name = "ccbi-res/main-summon.plist"},
                        -- {image_name = "ccbi-res/main-summon-big-effect.pvr.ccz"},
                        -- {image_name = "ccbi-res/main-summon-effect.pvr.ccz"},
                        -- {image_name = "ccbi-res/main-task.pvr.ccz", plist_name = "ccbi-res/main-task.plist"},
                        -- {image_name = "ccbi-res/make-equip.pvr.ccz"},
                        -- {image_name = "ccbi-res/mission-bg.pvr.ccz", plist_name = "ccbi-res/mission-bg.plist"},
                        -- {image_name = "ccbi-res/mission-cell-bg.pvr.ccz", plist_name = "ccbi-res/mission-cell-bg.plist"},
                        -- {image_name = "ccbi-res/online-reward.pvr.ccz"},
                        -- {image_name = "ccbi-res/power.pvr.ccz", plist_name = "ccbi-res/power.plist"},
                        -- {image_name = "ccbi-res/promotion.pvr.ccz", plist_name = "ccbi-res/promotion.plist"},
                        -- {image_name = "ccbi-res/promotion-effect.pvr.ccz", plist_name = "ccbi-res/promotion-effect.plist"},
                        -- {image_name = "ccbi-res/pub-effect-1.pvr.ccz"},
                        -- {image_name = "ccbi-res/pub-effect-10.pvr.ccz"},
                        -- {image_name = "ccbi-res/rank.pvr.ccz"},
                        -- {image_name = "ccbi-res/skill-icon.pvr.ccz", plist_name = "ccbi-res/skill-icon.plist"},
                        -- {image_name = "ccbi-res/chapter-reward.pvr.ccz", plist_name = "ccbi-res/chapter-reward.plist"},
                        -- {image_name = "ccbi-res/battle-end-1.pvr.ccz", plist_name = "ccbi-res/battle-end-1.plist"},
                        -- {image_name = "hero/hero.pvr.ccz", plist_name = "hero/hero.plist"},
                        -- {image_name = "ccbi-res/hero-skill.pvr.ccz", plist_name = "ccbi-res/hero-skill.plist"},
                        -- {image_name = "ccbi-res/skill-effect-slient.pvr.ccz", plist_name = "ccbi-res/skill-effect-slient.plist"},
                        -- {image_name = "ccbi-res/skill-effect-revive.pvr.ccz", plist_name = "ccbi-res/skill-effect-revive.plist"},
                        {image_name = "ccbi-res/battle-appear-left.pvr.ccz", plist_name = "ccbi-res/battle-appear-left.plist"},
                        {image_name = "ccbi-res/battle-appear-right.pvr.ccz", plist_name = "ccbi-res/battle-appear-right.plist"},
                        -- {image_name = "ccbi-res/hero-beattack.pvr.ccz", plist_name = "ccbi-res/hero-beattack.plist"},
                        -- {image_name = "ccbi-res/main-scene-effect.pvr.ccz", plist_name = "ccbi-res/main-scene-effect.plist"},
                        {image_name = "ccbi-res/common-ui.pvr.ccz", plist_name = "ccbi-res/common-ui.plist"},
                        {image_name = "ccbi-res/common-ui-2.pvr.ccz", plist_name = "ccbi-res/common-ui-2.plist"},
                        {image_name = "ccbi-res/backpack.pvr.ccz", plist_name = "ccbi-res/backpack.plist"},
                        {image_name = "ccbi-res/backpack-4.pvr.ccz", plist_name = "ccbi-res/backpack-4.plist"},
                        {image_name = "ccbi-res/backpack-5.pvr.ccz", plist_name = "ccbi-res/backpack-5.plist"},
                        -- {image_name = "ccbi-res/summon-effect.pvr.ccz"},
                        -- {image_name = "ccbi-res/summon-big-effect.pvr.ccz"},
                        -- {image_name = "ccbi-res/seven-day-gift.pvr.ccz"},
                        -- {image_name = "ccbi-res/seven-day-target.pvr.ccz"},
                        -- {image_name = "ccbi-res/trial.pvr.ccz"},
                       }
    return vec_image
end

function LoadingSceneCtr:asynCallback(cur, count, is_finish)
    self.cur_image = cur
    self.count_image = count
    self.is_finish = is_finish
    -- print("cur, count, is_finish", cur, count, is_finish)
end

return LoadingSceneCtr
