local AchievementGetCtr = class("AchievementGetCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local AchievementGetLayer = class("AchievementGetLayer", require("src.comp.EventLayer"))

local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

--------------------------------------------

function AchievementGetLayer:onCreate()
	self:setAutoClose(false)
    self:setSwallowTouches(false)

    self:setIgnoreAnchorPointForPosition(false)
    self:setAnchorPoint(0.5, 1)

    self.btn_go:setContentSize(self:getContentSize())
    
    local scale_label = 0.5
    self.lbl_task_desc = require("src.comp.RichTextEx"):create()
	:setFontSize(36)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#DFBFB2")
    :setScale(scale_label)
    :setAnchorPoint(0, 0.5)
    :setPosition(self.node_desc:getPosition())
	:setWrapMode(1)
    self:addChild(self.lbl_task_desc, 10001)
end

function AchievementGetLayer:startTimer(total_delay, callback)
    local now_time = ex.Game:getServerMillisecond()
    local end_time = now_time + total_delay * 1000
    local action_time = end_time - 700
    local is_action = false
    self:addTimer("timer", 100, function()
        local now = ex.Game:getServerMillisecond()
        if not is_action and action_time <= now then
            is_action = true
            self:runAction(cc.MoveTo:create(0.5, cc.p(ex.p.width / 2, ex.p.height + 300)))
        end
        if end_time <= now then
            self:removeTimerByName("timer")

            callback()
        end
    end, true)
end

-----------------------------------------------------------------------------
function AchievementGetCtr:show(task_type, task_idx)
    local running_scene = cc.Director:getInstance():getRunningScene()
    local layer_get = running_scene:getChildByTag(12000)

    -- 获取对应任务配置
    local config = nil
    if task_type == 1 then
        config = cfg.achievement.achievement[task_idx]
    else
        config = cfg.dailytaskmain.daily[task_idx]
    end

    if config == nil then
        return
    end

    if self.vec_data == nil then
        self.vec_data = {}
    end

    if layer_get ~= nil then
        local data = {}
        data.task_type = task_type
        data.task_idx = task_idx
        table.insert(self.vec_data, data)

		return
    end
    
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/achievement.plist")

    self.task_type = task_type
    self.task_idx = task_idx

	self:initData()
end

function AchievementGetCtr:initData()
    -- 获取对应任务配置
    self.config = nil
    if self.task_type == 1 then
        self.config = cfg.achievement.achievement[self.task_idx]
    else
        self.config = cfg.dailytaskmain.daily[self.task_idx]
    end

    if self.config == nil then
        return
    end

    local running_scene = cc.Director:getInstance():getRunningScene()

    local layer_get = running_scene:getChildByTag(12000)
    if layer_get == nil then
        layer_get = AchievementGetLayer:createWithCCBIFile("ccbi/AchievementGetLayer.ccbi")
        layer_get:setTag(12000)
        running_scene:addChild(layer_get, 3)
    end

    layer_get:setPosition(ex.p.width / 2, ex.p.height + 300)
    layer_get:runAction(cc.MoveTo:create(0.5, cc.p(ex.p.width / 2, ex.p.height)))

    layer_get.btn_go:registerScriptTapHandler(handler(self, self.onGo))

    -- 添加定时器，定时执行淡出动画，过后关闭界面
    layer_get:startTimer(4, function()
        if self.vec_data == nil or table.nums(self.vec_data) <= 0 then
            running_scene:removeChildByTag(12000)
        else
            self.task_type = self.vec_data[1].task_type
            self.task_idx = self.vec_data[1].task_idx

            table.remove(self.vec_data, 1)

            self:initData()
        end
    end)

    -- 更新界面显示
    if self.task_type == 1 then
        layer_get.lbl_task_type:setString(ex.Tools:getLang(5754))
    else
        layer_get.lbl_task_type:setString(ex.Tools:getLang(5753))
    end
    layer_get.lbl_task_desc:setXmlTextLua(ex.Tools:taskString(self.config.lang, self.config.task.target, self.config.task.condition))
    layer_get.lbl_task_desc:formatText()
    layer_get.spr_arrow:setPositionX(layer_get.lbl_task_desc:getPositionX() + layer_get.lbl_task_desc:getContentSize().width * layer_get.lbl_task_desc:getScaleX() + 15)
end

-- 跳转响应
function AchievementGetCtr:onGo(tag, pSender)
    print("AchievementGetCtr onGo")

    local achievement_ctr = require("src.layer.AchievementCtr"):instance()
    achievement_ctr:openWindow()
    if self.task_type == 1 then
        achievement_ctr:selectAchievement()
    else
        achievement_ctr:selectDaily()
    end
end

return AchievementGetCtr
