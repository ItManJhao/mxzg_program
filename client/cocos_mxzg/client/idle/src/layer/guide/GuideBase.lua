local GuideBase = class("GuideBase", require("src.comp.EventLayer"))


function GuideBase:ctor()
    -- self.super.ctor(self)

    self.scene_ctr_type = 0         -- 
    self.town_scene = nil           -- 当前主场景指针

    self.step_num = 99999           -- 执行到第几步了
    self.guide_num = 0              -- 新手指引序号.
    self.is_save_num = 0            -- 保存序号
    self.is_saved_num = false       -- 是否已经保存过序号
    self.is_loading_scene = false   -- 是否正在等待场景切换
    self.is_wait_touch = false      -- 是否正在等待点击
    self.is_touch_falsifying = false-- 是否伪造一个点击事件

    self.is_listen_open = false     -- 是否在监听窗口打开
    self.is_listen_close = false    -- 是否在监听窗口关闭

    self.step_open_num = 0          -- 窗口打开时step_num跳转到step_open_num
    self.step_close_num = 0         -- 窗口关闭时step_num跳转到step_close_num

    self.vec_guide_data = {}        -- 文件步骤
    self.listener_touch = nil       -- 点击分发器

    self.is_swallow_touch = false   -- 是否吞噬无关的点击

    self.clock_interval = 0         -- 两次点击的时间,预防一帧点击了两次
    self.vec_enabled_rect = {}      -- 设置触摸失效的区域
    self.lay_animation = nil        -- 动画层
    self.old_position = nil         -- 旧的坐标

    self.node_cache = nil           -- 被寻找的节点
    self.mask_size = cc.size(0, 0)  -- 遮罩的大小
    self.node_point = cc.p(0, 0)    -- 物体上一帧的位置
    self.node_scale = 1             -- 物体上一帧的缩放值
    self.comp_true_count = 0        -- 结果正确次数
    
    self.wait_time = 0              -- 等待到什么时候

    self.vec_roll_num = {}          -- 回滚次数

    self.is_skip_finish_event = false
    self.finish_event = nil           -- 等待事件，收到事件时。强制完成当前新手指引
end

function GuideBase:initDone()
    self:setLocalZOrder(999999);

    self.listener_touch = cc.EventListenerTouchOneByOne:create()  --创建一个单点事件监听
    self.listener_touch:setSwallowTouches(true)
    self.listener_touch:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.listener_touch:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.listener_touch:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    self.listener_touch:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_CANCELLED)
    local event_dispatcher = self:getEventDispatcher() 
    event_dispatcher:addEventListenerWithFixedPriority(self.listener_touch, -99999)

    -- if cpp.SocialPlatform:instance():isDebug() then
    --     local onKeyPressed = function (keyCode, event)
    --         -- print("keyCode", keyCode)
    --     end

    --     local onKeyReleased = function(keyCode, event)
    --         print("keyCode", keyCode)
    --         if keyCode == 141 then
    --             ex.MessageView:add(ex.Tools:getLang(47264))
    --             local guide_ctr = require("src.layer.guide.GuideCtr"):instance()
    --             if guide_ctr then
    --                 guide_ctr.guide_num = 9999
    --                 guide_ctr:saveGuideNum()
    --                 guide_ctr:remove(true)

    --             end
    --         end
    --     end

    --     self.listener_key = cc.EventListenerKeyboard:create()
    --     self.listener_key:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED)
    --     self.listener_key:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED)
    --     event_dispatcher:addEventListenerWithFixedPriority(self.listener_key, -999999)
    -- end
end

-- 重置文件数据
function GuideBase:resetData()
    self:resetStepData()
    self.vec_enabled_rect = nil
    self.vec_guide_data = nil

    self.execute_file_name = ""
    self.node_cache = nil
    self.node_point = cc.p(0, 0)
    self.node_scale = 0

    self.is_swallow_touch = true
    self.step_num = 0

    self.is_listen_open = false
    self.is_listen_close = false
    self.step_open_num = 0
    self.step_close_num = 0

    self.vec_roll_num = {}

    self.is_skip_finish_event = false
    self:removeFinishEvent()
end

function GuideBase:addFinishEvent(type)
    if ex then
        self.finish_event = ex.EventManager:add(type, function()
            self:removeFinishEvent()
            if self.is_skip_finish_event ~= true then
                self:finishGuide()
            end
        end)
    end
end

function GuideBase:removeFinishEvent()
    if self.finish_event ~= nil and ex then
        ex.EventManager:remove(self.finish_event)
    end
    self.finish_event = nil
end

-- 重置步骤数据
function GuideBase:resetStepData()
    self.clock_interval = 0
    self.node_point = cc.p(0, 0)
    self.comp_true_count = 0

    self.mask_size = cc.p(0, 0)
    self.wait_time = -1

    self.is_wait_touch = false
    self.is_touch_falsifying = false

    if self.scheduler_finish_guide then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler_finish_guide)
    end

    if self.scheduler_wait_touch_target then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler_wait_touch_target)
    end

    if self.lay_animation then
        self.lay_animation:removeGuideSprite()
        self.lay_animation.is_wait_touch = false
    end
end


-----------------------文件------------------------
-- 读取文件
function GuideBase:readFile(file_name)
    return clone(require(file_name))
end


-- 执行子文件
function GuideBase:readGuideFile(file_name)
    self.execute_file_name = file_name
    self.vec_guide_data = self:readFile(file_name)
end

-- 点击间隔是否有效
function GuideBase:isTouchValid()
    return true
end

-- 点击开始
function GuideBase:onTouchBegan(touch, event)
    local pos = touch:getLocation()
    if self:isTouchValid() == false then
        return true
    end
    -- print("self.is_swallow_touch", self.is_swallow_touch)
    return self.is_swallow_touch
end

function GuideBase:onTouchMoved(touch, event)
end


-- 点击结束
function GuideBase:onTouchEnded(touch, event)
    if self:isTouchValid() == false then
        return
    end

    if self:isTouchMask(touch) then
        self:delayTouch()
    elseif require("src.layer.NpcTalkCtr"):instance():canClose() then
        self:finishGuide()
    end
end


-- 用CCEGLView创建一个点击事件.
function GuideBase:createTouch(tp)
    cpp.MainSceneCtr:createTouch(tp)
end


-- 是否点击到有效区域
function GuideBase:isTouchMask(pTouch)
    if self.lay_animation and self.lay_animation.is_wait_touch then
        local tp = pTouch:getLocation()
        local lay_rect = cc.rect(self.lay_animation.touch_position.x, self.lay_animation.touch_position.y,
                                 self.lay_animation.touch_size.width, self.lay_animation.touch_size.height)

        local offset = cc.size(lay_rect.width * 0.15, lay_rect.height * 0.15)
        local point = cc.p(lay_rect.x + offset.width * 0.5, lay_rect.y + offset.height * 0.5)
        lay_rect.x = point.x
        lay_rect.y = point.y
        if cc.rectContainsPoint(lay_rect, tp) then
            return true
        end
    end

    -- return false
end

-- 是否点击到无效区域
function GuideBase:isTouchEnabledRect()
    local point = pTouch:getLocation()
    for k,v in pairs(self.vec_enabled_rect) do
        if cc.rectContainsPoint(v, point) then
            return true
        end
    end
    return false
end

-- 延迟点击
function GuideBase:delayTouch()
    if self.is_touch_falsifying == true then
        -- 伪点击事件
    else
        local tmp_skip = self.is_skip_finish_event
        self.is_skip_finish_event = true
        self.is_swallow_touch = false
        local point = cc.p(self.lay_animation.touch_position.x + self.lay_animation.touch_size.width * 0.5,
                           self.lay_animation.touch_position.y + self.lay_animation.touch_size.height * 0.5)
        self:createTouch(self.lay_animation:convertToWorldSpace(point))
        self.is_swallow_touch = true
        self.is_skip_finish_event = tmp_skip
    end
    self:finishGuide()
end

-- 移除所有数据.并删除自身
function GuideBase:removeAllData()
    print("removeAllData")
    
    self:resetData()
    self:resetStepData()

    if self.lay_animation then
        self.lay_animation:remove()
        self.lay_animation = nil
    end

    self.is_swallow_touch = false

    cc.Director:getInstance():getActionManager():removeAllActionsFromTarget(self)
    local event_dispatcher = self:getEventDispatcher() 
    event_dispatcher:removeEventListener(self.listener_touch)

    -- if self.listener_key then
    --     event_dispatcher:removeEventListener(self.listener_key)
    -- end

    -- self._instance:release()
    -- self._instance:autorelease()

    local act_remove = cc.Sequence:create(cc.DelayTime:create(0.1), cc.DelayTime:create(0.1), cc.RemoveSelf:create())
    cc.Director:getInstance():getActionManager():addAction(act_remove, self, false)
end

-----------------------逻辑------------------------
-- 执行当前步骤
function GuideBase:executeGuide()
    local data = self.vec_guide_data[self.step_num + 1]

    print("guide execute_guide_type =", data.call)
    -- 文件完成标志.保存当前指引序号.并继续执行接下来的步骤
    if data.finial then
        self.is_saved_num = true
        self:saveGuideNum()
    end


    if data.finish_event ~= nil then
        self:addFinishEvent(data.finish_event)
    end

    if data.call then
        -- print("111")
        self[data.call](self, data)
    else
        -- print("222")
        dump(data, "guide error")
    end
end


-- 完成当前步骤.并进行必要的清除
function GuideBase:finishGuide()
    self:resetStepData()
    self.step_num = self.step_num + 1

    self:executeGuide()
end


-- 完成当前步骤.并进行必要的清除
function GuideBase:finishGuideDt(dt)
    self:finishGuide()
end

-- 保存文件进度.
function GuideBase:saveGuideNum()

end


-- 获取文件进度
function GuideBase:getGuideNum()

end

-- 
function GuideBase:getGuideDataByStep(step)
    return self.vec_guide_data[step + 1]
end

-- 关闭其他的窗口
function GuideBase:closeOtherWindow()
    -- cpp.NodeCtr:closeOtherWindow()
    require("src.comp.LuaNodeCtr"):closeOtherWindow()
    -- require("src.comp.LuaNodeCtr"):closeOtherWindow()
    self:finishGuide()
end

function GuideBase:checkFile(data)
end

-- 处理错误文件
function GuideBase:executeFailFile(fail_file)

end


-- 删除多余的步骤
function GuideBase:removeMissStep(data)
    self:eraseObject(data.r_beg, data.r_end)
end

-- 安全删除数组数据.
function GuideBase:eraseObject(r_beg, r_end)
    if (not r_beg) or r_beg <= 0 then
        r_beg = 0
    end

    local table_num = table.nums(self.vec_guide_data)
    if self.step_num + r_end > table_num then
        r_end = table_num - self.step_num
    end

    r_end = math.max(r_beg, r_end)
    TableEx.removeTableDataByIndex(self.vec_guide_data, self.step_num + r_beg, self.step_num + r_end)
end

-- 检查是否可以执行该文件
function GuideBase:checkLayerType(data)
    local layer = ex.MainSceneCtr:getMainSceneLayer(data.layer_type)
    if layer == nil then
        self:finishGuide()
        return
    end

    -- 移除失效的步骤
    self:removeMissStep(data)
    self:finishGuide()
end

-----------------------功能------------------------
-- 让node处于scroll_view中间
function GuideBase:stayInMiddleStep(data)
    self:stayInMiddle(self.node_cache)
    self:finishGuide()
end

--
function GuideBase:stayInMiddle(node)
    if not node then
        return
    end

    local scroll_view = nil
    local node_parent = node

    while true do
        local tmp_node = node_parent:getParent()
        if tmp_node == nil then
            break
        end

        if tmp_node.setContentOffset ~= nil then
            scroll_view = tmp_node
            break
        end

        node_parent = node_parent:getParent()
        if not node_parent then
            break
        end
    end

    if scroll_view and scroll_view:getParent() and node:getParent() then
        local node_point = cc.p(node:getPositionX(), node:getPositionY())
        node_point = node:getParent():convertToWorldSpace(node_point)
        local tmp_point = cc.p(scroll_view:getPositionX() + scroll_view:getViewSize().width * 0.5,
                               scroll_view:getPositionY() + scroll_view:getViewSize().height * 0.5)

        local scroll_view_point = scroll_view:getParent():convertToWorldSpace(cc.p(tmp_point.x, tmp_point.y))
        local point_offset = cc.p(node_point.x - scroll_view_point.x,  node_point.y - scroll_view_point.y)

        local content_offset = cc.p(scroll_view:getContentOffset().x - point_offset.x,
                                    scroll_view:getContentOffset().y - point_offset.y)

        content_offset.x = Maths.clampf(content_offset.x, scroll_view:getViewSize().width  - scroll_view:getContentSize().width, 0)
        content_offset.y = Maths.clampf(content_offset.y, scroll_view:getViewSize().height - scroll_view:getContentSize().height, 0)
        scroll_view:setContentOffset(content_offset);
    end
end

-- 
function GuideBase:setScrollOffset(data)
    if self.node_cache.__cname == "cc.ScrollView" then
        self.node_cache:setContentOffset(cc.p(data.x, data.y))
    end
    self:finishGuide()
end

-- 判断某个窗口是否打开
function GuideBase:isOpenWindow(data)
    local is_open = false

    if data.ccbi_path and cpp.NodeCtr:isOpenWindow(data.ccbi_path) then
        is_open = true
    end

    if is_open == false and data.ctr_name then
        is_open = require(data.ctr_name):instance():getLayer()
    end

    local is_reverse = true
    if data.reverse ~= nil then
        is_reverse = data.reverse
    end

    if is_open == is_reverse then
        self:eraseObject(data.r_beg, data.r_end)
    end

    self:finishGuide()
end




-- 判断某个窗口是否打开
function GuideBase:isOpenWindowLua(data)
    local is_open = false

    if data.ctr_name and require(data.ctr_name):instance():getLayer() then
        is_open = true
    end
    
    -- if is_open == false and data.ctr_name then
    --     is_open = require(data.ctr_name):instance():getLayer()
    -- end

    local is_reverse = true
    if data.reverse ~= nil then
        is_reverse = data.reverse
    end

    print("isOpenWindowLua", is_open, is_reverse)
    if is_open == is_reverse then
        if data.jump == true then
            self.step_num = self.step_num + data.r_end
        else
            self:eraseObject(data.r_beg, data.r_end)
        end
    end

    self:finishGuide()
end

-- 打开一个窗口
function GuideBase:openWindow(data)
    if data.file then
        require(data.file):instance():openWindow(data.params1, data.params2, data.params3, data.params4)
    end

    self:finishGuide()
end

-- 判断物体移动状态
function GuideBase:compFloat(value1, value2)
    if math.floor(value1 * 1000) == math.floor(value2 * 1000) then
        return true
    end
    return false
end

function GuideBase:compPoint(value1, value2)
    if self:compFloat(value1.x, value2.x) and self:compFloat(value1.y, value2.y) then
        return true
    end
    return false
end


-----------------------窗口------------------------
-- 监听窗口打开.
function GuideBase:addOpenWindowListen(data)
    self.is_listen_open = true
    self.step_open_num = self.step_num

    if data.next then
        if data.next == 1 then
            self:finishGuide()
        end
    else
        self:finishGuide()
    end
end

-- 取消窗口监听.
function GuideBase:removeOpenWindowListen(data)
    self.is_listen_open = false
    self:finishGuide()
end



-- 监听窗口关闭.
function GuideBase:addCloseWindowListen(data)
    self.is_listen_close = true
    self.step_close_num = self.step_num

    if data.next ~= nil then
        if data.next == 1 then
            self:finishGuide()
        end
    else
        self:finishGuide()
    end
end

-- 取消窗口监听.
function GuideBase:removeCloseWindowListen(data)
    self.is_listen_close = false
    self:finishGuide()
end


-----------------------动画------------------------
-- 创建箭头动画.
function GuideBase:createMask(data)
    if not self.node_cache then
        self:finishGuide()
        return
    end

    local action_manager = cc.Director:getInstance():getActionManager()

    local delay_time = 0
    if self.node_cache.__cname == "Unit" then
        -- 这是一个unit.要滑动当前的视图,保证物体出现在屏幕中
        self:cameraMoveToTarget(delay_time, self.mask_size)
    else
        -- 
        self.mask_size = cc.size(self.node_cache:getContentSize().width * self.node_cache:getScaleX(),
                                 self.node_cache:getContentSize().height * self.node_cache:getScaleY())
    end


    -- 默认最小尺寸为200像素
    -- if not data.extend_x then
    --     data.extend_x = 200 / self.mask_size.width * 100
    -- end

    -- -- 默认最小尺寸为200像素
    -- if not data.extend_y then
    --     data.extend_y = 200 / self.mask_size.height * 100
    -- end


    self.bubble_text = ex.Tools:getLang(data.bubble) ~= "" and ex.Tools:getLang(data.bubble) or data.bubble
    self.bubble_anchor = data.anchor
    self.bubble_dimensions = data.dimensions

    self.mask_size.width = data.extend_x and (self.mask_size.width * ((100 + data.extend_x)* 0.01)) or self.mask_size.width
    self.mask_size.height = data.extend_y and (self.mask_size.height * ((100 + data.extend_y)* 0.01)) or self.mask_size.height

    local act_delay_mask = cc.Sequence:create(cc.DelayTime:create(0.01),
                                              cc.DelayTime:create(0.01),
                                              cc.DelayTime:create(0.01),
                                              cc.DelayTime:create(0.01),
                                              cc.DelayTime:create(0.01),
                                              cc.DelayTime:create(0.01),
                                              cc.DelayTime:create(0.01),
                                              cc.DelayTime:create(0.01),
                                              cc.CallFunc:create(handler(self, self.maskTarget)))

    action_manager:addAction(act_delay_mask, self, false)
end


-- 镜头移动到目标出.并计算目标占据屏幕的大小
function GuideBase:cameraMoveToTarget(time, target_size)
    if not self.node_cache then
        return
    end

    local tp = cc.p(0, 0)
    local destination = cc.p(0, 0)
end



-- 对目标进行遮罩
function GuideBase:maskTarget()
    local data = self:getGuideDataByStep(self.step_num)
    local win_size = cc.Director:getInstance():getWinSize()

    local offset = cc.p(0.5, 0.5)
    offset = cc.p(offset.x - self.node_cache:getAnchorPoint().x, offset.y - self.node_cache:getAnchorPoint().y)
    offset.x = self.mask_size.width * offset.x
    offset.y = self.mask_size.height * offset.y

    if data then
        -- print("11111")
        -- dump(data)
        if data.offset_x then
            -- print("22222")
            offset.x = offset.x + data.offset_x
        end

        if data.offset_y then
            offset.y = offset.y + data.offset_y
        end
    end

    -- 预防新手指引出错时...新手指引无法执行下去..
    local point = self.node_cache:convertToWorldSpaceAR(cc.p(0, 0))
    point = cc.p(point.x + offset.x, point.y + offset.y)

    local tmp_value = (point.x + self.mask_size.width * 0.1 > win_size.width) and (win_size.width - self.mask_size.width * 0.7) or point.x
    point.x = (point.x + self.mask_size.width * 0.2 < 0) and (self.mask_size.width * 0.2) or (tmp_value)


    tmp_value = (point.y + self.mask_size.height * 0.1 > win_size.height) and win_size.height - self.mask_size.height * 0.7 or point.y
    point.y =  (point.y + self.mask_size.height * 0.2) < 0 and self.mask_size.height * 0.2 or tmp_value


    -- 限制最小尺寸.. 这里可能会出bug。。如果限时的位置不是在图片中间。请屏蔽该代码
    self.mask_size.width = math.max(200, self.mask_size.width)
    self.mask_size.height = math.max(200, self.mask_size.height)


    self:createArrow(point, self.mask_size, self.bubble_text, self.bubble_anchor)
end


-- 时间到了.将箭头回收
function GuideBase:stopWaitTouchTarget(dt)

end


-- 将箭头动画添加到动画层上
function GuideBase:createArrow(target_point, activities_size, bubble_text, bubble_anchor)
    local data = self:getGuideDataByStep(self.step_num)

    if not self.lay_animation then
        self.lay_animation = require("src.layer.guide.GuideAnimationLayer"):create()
        self.lay_animation.guide_ctr = self
        cc.Director:getInstance():getRunningScene():addChild(self.lay_animation)
    end

    self.is_touch_falsifying = data.falsifying 
    self.lay_animation.touch_size = activities_size
    self.lay_animation.touch_position = cc.p(target_point.x - activities_size.width * 0.5, target_point.y - activities_size.height * 0.5)
    self.lay_animation.is_wait_touch = true
    self.lay_animation.old_position = self.old_position
    self.lay_animation.is_mask = data.mask == nil and true or data.mask
    -- self.lay_animation.bubble_pos = data.bubble_pos

    self.lay_animation:addGuideSprite()
    if bubble_text ~= nil then
        self.lay_animation:addBubble(bubble_text, bubble_anchor, data.bubble_pos, data.dimensions)
    end
    
    local guide_node = self.lay_animation:getGuideSprite()
    if data.angle then
        -- 旋转
    end

    if data.scale then
        guide_node:setScaleX(guide_node:getScaleX() * data.scale)
        guide_node:setScaleY(guide_node:getScaleY() * data.scale)
    end

    if data.scale_x then
        guide_node:setScaleX(guide_node:getScaleX() * data.scale_x)
    end

    if data.scale_y then
        guide_node:setScaleY(guide_node:getScaleY() * data.scale_Y)
    end

    self.old_position = cc.p(self.lay_animation.touch_position.x + activities_size.width * 0.5, self.lay_animation.touch_position.y + activities_size.height * 0.5)
end

-- 
function GuideBase:openNPCLayer(data)

    local audio_effect = "music/guide-" .. data.content .. ".mp3"

    local str_content = ex.Tools:getLang(data.content)
    if str_content == "" then
        str_content = data.content
    end

    if data.auto == 1 then
        require("src.layer.NpcTalkCtr"):instance():openWindowAuto(data.npc_name,
                                                                  str_content,
                                                                  audio_effect)
    else
        require("src.layer.NpcTalkCtr"):instance():openWindow(data.npc_name,
                                                              str_content,
                                                              audio_effect)
        self:finishGuide()
    end
end

-----------------------设置------------------------
-- 设置触摸
function GuideBase:setSwallow(data)
    -- dump(data, "GuideBase:setSwallow")
    if data.is_swallow_touch ~= nil then
        self.is_swallow_touch = data.is_swallow_touch
        -- print("GuideBase:setSwallow", self.is_swallow_touch)
    end
    self:finishGuide()
end



-- 设置失效区域
function GuideBase:setEnabledRect(data)
    if data.target_x then
        local per = cc.Director:getInstance():getWinSize()
        per.width = per.width * 0.01
        per.height = per.height * 0.01

        local rect = cc.rect(0, 0, 0, 0)
        rect.size.width = data.width * per.x
        rect.size.height = data.height * per.y

        rect.origin.x = data.target_x * per.x - rect.size.width * 0.5
        rect.origin.y = data.target_y * per.y - rect.size.height * 0.5

        table.insert(self.vec_enabled_rect, rect)
    end

    self:finishGuide()
end



-- 清除失效区域
function GuideBase:removeEnabledRect()
    self.vec_enabled_rect = {}
    self:finishGuide()
end

-----------------------等待------------------------
-- 等待场景加载完毕
function GuideBase:waitSceneLoadingEnd()
    local action_manager = cc.Director:getInstance():getActionManager()

    -- require("aaaa")
    -- TODO
    local scene_ctr = require("src.scene.SceneCtr"):getRunningSceneCtr() --cpp.SceneCtr:getRunningSceneCtr()

    -- print("xxx", scene_ctr, scene_ctr:isLoadingFinish() )
    -- if not scene_ctr or scene_ctr:isDidEnter() == false then
    if not scene_ctr or scene_ctr:isLoadingFinish() == false then
        local act_delay = cc.Sequence:create(cc.DelayTime:create(0.04),
                                             cc.CallFunc:create(handler(self, self.waitSceneLoadingEnd)))
        action_manager:addAction(act_delay, self, false)
        return
    end

    self.scene_ctr_type = scene_ctr:getSceneCtrType()
    -- self.town_scene = scene_ctr:getTownScene()
    self.town_scene = scene_ctr:getScene()
    self:finishGuide()
end

-- 等到场景切换
function GuideBase:waitChangeScene()
    local action_manager = cc.Director:getInstance():getActionManager()
    local scene_ctr = require("src.scene.SceneCtr"):getRunningSceneCtr()

    if scene_ctr and scene_ctr:isDidEnter() and self.scene_ctr_type ~= scene_ctr:getSceneCtrType() then
        self:finishGuide()
    else
        local act_delay = cc.Sequence:create(cc.DelayTime:create(0.04),
                                             cc.CallFunc:create(handler(self, self.waitChangeScene)))
        act_delay:setTag(9999999)
        action_manager:removeActionByTag(9999999, self)
        action_manager:addAction(act_delay, self, false)
    end
end


-- 延时一段时间.
function GuideBase:wait(data)
    local time = 1.0 * data.time / 1000
    local action_manager = cc.Director:getInstance():getActionManager()
    local act_delay = cc.Sequence:create(cc.DelayTime:create(0.001),
                                         cc.DelayTime:create(0.001),
                                         cc.DelayTime:create(0.001),
                                         cc.DelayTime:create(0.001),
                                         cc.DelayTime:create(0.001),
                                         cc.DelayTime:create(0.001),
                                         cc.DelayTime:create(0.001),
                                         cc.DelayTime:create(time),
                                         cc.DelayTime:create(0.001),
                                         cc.DelayTime:create(0.001),
                                         cc.DelayTime:create(0.001),
                                         cc.DelayTime:create(0.001),
                                         cc.CallFunc:create(handler(self, self.finishGuide)),
                                         cc.DelayTime:create(0.001),
                                         cc.DelayTime:create(0.001),
                                         cc.DelayTime:create(0.001),
                                         cc.DelayTime:create(0.001),
                                         cc.DelayTime:create(0.001))
    act_delay:setTag(9999)
    action_manager:removeActionByTag(9999, self)
    action_manager:addAction(act_delay, self, false)
end


-- 等待屏幕被点击
function GuideBase:waitTouch()
    
end

-- 让节点显示或隐藏
function GuideBase:setNodeVisible(data)
    if self.node_cache then
        self.node_cache:setVisible(data.visible == 1)
    end
    self:finishGuide()
end



-- 等待物体停止
function GuideBase:waitMove(dt)
    
end

-- 新手指引停止在这里.
function GuideBase:waitSend(data)

end

-- 等待某个事件
function GuideBase:waitEvent()
    
end

function GuideBase:rollStep(data)
    if data.type == "hero_level" then
        local cfg = cfg.herolevel.level[data.value]

        -- 材料不足。。直接跳过指引
        if ex.Player:getItemNum(ItemType.IT_GOLD) < cfg.gold_need or ex.Player:getItemNum(ItemType.IT_HERO_EXP) < cfg.exp_need then
            self:finishGuide()
            return
        end

        local layer_info = ex.MainSceneCtr:getMainSceneLayer(MainSceneType.HERO_INFO_LAYER)
        if layer_info and layer_info.hero_data then
            if layer_info.hero_data.level < data.value then
                self.step_num = self.step_num + data.step_back - 1
                self:finishGuide()
                return
            end
        end
    elseif data.type == "fetter_level" then

        -- 限制回滚次数
        self.vec_roll_num[data.key] = self.vec_roll_num[data.key] and self.vec_roll_num[data.key] + 1 or 1
        local roll_num = self.vec_roll_num[data.key]

        print("fetter_level", roll_num, data.num)

        -- 回滚次数达到上限
        if roll_num - 1 >= data.num then
            self:finishGuide()
            return
        end

        local fetter_data = ex.Player.fetter_data:getFetterDataByIdx(data.idx)
        if fetter_data and fetter_data.level >= 1 then
            self:finishGuide()
            return
        end

        -- 回滚到指定步骤
        self.step_num = self.step_num + data.step_back - 1
        self:finishGuide()
        return
    end
    self:finishGuide()
end


function GuideBase:rollStep(data)


end




-----------------------寻找------------------------
-- 寻找文件对应的精灵.
function GuideBase:findSpriteByFileName(data)
    local tmp_node_cache = self.node_cache
    self.node_cache = nil

    local file_name = nil
    if data.system_hero_config then
        local config = cfg.system[data.system_hero_config]
        if config then
            file_name =  string.format("hero-icon/%s.png", tonumber(config) + 10000000 )
        end
    elseif data.mission_hero_config then
        local config = cfg.chapterreward.chapterreward[data.mission_hero_config]
        if config then
            for k,v in pairs(config.first_reward) do
                if v.item_type >= 20000000 then
                    file_name =  string.format("hero-icon/%s.png", v.item_type)
                    break
                end
            end
        end

    else
        file_name = data.file
    end

    if file_name then
        local sfc = cc.SpriteFrameCache:getInstance()
        -- 重新加载plist文件.因为SpriteFrame有可能已经被释放了,会查找不到.
        if data.plist ~= nil then
            sfc:addSpriteFrames(data.plist)
        end

        -- 根据文件名查找节点.
        -- local file_name = data.file
        local frame = sfc:getSpriteFrame(file_name)
        if frame then
            local count = {}
            count.num = data.count or 0

            local first_node = nil

            -- 是否从指定节点开始寻找
            if data.node_cache ~= nil then
                first_node = tmp_node_cache
            else
                first_node = cc.Director:getInstance():getRunningScene()
            end

            if first_node then
                -- 开始递归查找
                self.node_cache = self:findSpriteByFileNameRecursion(first_node, frame, count)
                -- dump(ex.StringUtil.checkName("asdhsjd127"))
                -- dump(self:getAllChild(first_node))
            end

            if self.node_cache ~= nil then
                if data.getParent ~= nil then
                    local parent_count = data.getParent
                    while parent_count > 0 do
                        self.node_cache = self.node_cache:getParent()
                        parent_count = parent_count - 1
                    end
                end
            else
                print("GuideBase::findSpriteByFileName1 : miss file = ", file_name)
            end
        else
            print("GuideBase::findSpriteByFileName2 : miss file = ", file_name)
        end
    end

    self:finishGuide()
end


function GuideBase:findSpriteByFileNameRecursion(node, frame, count)
    local vec_child = node:getChildren()
    if table.nums(vec_child) <= 0 then
        return nil
    end

    local nums = table.nums(vec_child)
    for i,v in ipairs(vec_child) do
        local tmp_node = v

        local sprite = (tmp_node.isFrameDisplayed ~= nil) and tmp_node or nil
        local is_match = sprite and sprite:isFrameDisplayed(frame)
        if is_match then
            count.num = count.num - 1
        end

        if is_match and count.num <= 0 then
            return sprite
        else
            local tmp_node2 = self:findSpriteByFileNameRecursion(tmp_node, frame, count)
            if tmp_node2 ~= nil then
                return tmp_node2
            end
        end
    end
    
    return nil
end

function GuideBase:findHeroIcon(data)
    self.node_cache = nil
    -- 是否从指定节点开始寻找
    local first_node = nil
    local count = {}
    count.num = data.count or 0

    if data.node_cache ~= nil then
        first_node = tmp_node_cache
    else
        first_node = cc.Director:getInstance():getRunningScene()
    end

    self.node_cache = self:findHeroIconRecursion(first_node, data.type, count)

    if self.node_cache ~= nil then
        if data.getParent ~= nil then
            local parent_count = data.getParent
            while parent_count > 0 do
                self.node_cache = self.node_cache:getParent()
                parent_count = parent_count - 1
            end
        end
    else
        print("GuideBase::findHeroIcon : miss file = ", data.type)
    end

    self:finishGuide()
end


function GuideBase:findHeroIconRecursion(node, type, count)
    local type = type or 0

    local vec_child = node:getChildren()
    if table.nums(vec_child) <= 0 then
        return nil
    end

    local nums = table.nums(vec_child)
    for i,v in ipairs(vec_child) do
        local tmp_node = v

        local sprite = (tmp_node.__cname == "UIMenuItemHero" and (type == 0 or tmp_node.hero_type == type)) and tmp_node or nil
        local is_match = sprite ~= nil

        if is_match then
            count.num = count.num - 1
        end

        -- print("sprite", sprite)
        if is_match and count.num <= 0 then
            return sprite
        else
            local tmp_node2 = self:findHeroIconRecursion(tmp_node, type, count)
            if tmp_node2 ~= nil then
                return tmp_node2
            end
        end
    end
    
    return nil
end


function GuideBase:findLabel(data)
    self.node_cache = nil
    -- 是否从指定节点开始寻找
    local first_node = nil
    local count = {}
    count.num = data.count or 0

    if data.node_cache ~= nil then
        first_node = tmp_node_cache
    else
        first_node = cc.Director:getInstance():getRunningScene()
    end

    self.node_cache = self:findLabelRecursion(first_node, data.text, count, data.visible)

    if self.node_cache ~= nil then
        if data.getParent ~= nil then
            local parent_count = data.getParent
            while parent_count > 0 do
                self.node_cache = self.node_cache:getParent()
                parent_count = parent_count - 1
            end
        end
    else
        print("GuideBase::findLabel : miss = ", data.text)
    end

    self:finishGuide()
end


function GuideBase:findLabelRecursion(node, text, count, visible)
    local text = text or ""

    local vec_child = node:getChildren()
    if table.nums(vec_child) <= 0 then
        return nil
    end

    local nums = table.nums(vec_child)
    for i,v in ipairs(vec_child) do
        local tmp_node = v

        local label = tmp_node.getString and tmp_node or nil

        local is_visible = visible == nil or (cpp.Game:isInVisible(tmp_node) == visible)

        local is_match = label ~= nil and (label:getString() == text and is_visible == true) or nil
        -- print(label, is_match, visible, is_visible, (cpp.Game:isInVisible(tmp_node) == visible), cpp.Game:isInVisible(tmp_node))

        if is_match then
            count.num = count.num - 1
        end

        if is_match and count.num <= 0 then
            return label
        else
            local tmp_node2 = self:findLabelRecursion(tmp_node, text, count, visible)
            if tmp_node2 ~= nil then
                return tmp_node2
            end
        end
    end
    
    return nil
end


function GuideBase:findNodeByName(data)
    self.node_cache = nil
    -- 是否从指定节点开始寻找
    local first_node = nil
    local count = {}
    count.num = data.count or 0

    if data.node_cache ~= nil then
        first_node = tmp_node_cache
    else
        first_node = cc.Director:getInstance():getRunningScene()
    end

    self.node_cache = self:findNodeByNameRecursion(first_node, data.name, count)

    if self.node_cache ~= nil then
        if data.getParent ~= nil then
            local parent_count = data.getParent
            while parent_count > 0 do
                self.node_cache = self.node_cache:getParent()
                parent_count = parent_count - 1
            end
        end
    else
        print("GuideBase::findNodeByName : miss file = ", data.name)
    end

    self:finishGuide()
end

function GuideBase:findNodeByNameRecursion(node, name, count)
    local vec_child = node:getChildren()
    if table.nums(vec_child) <= 0 then
        return nil
    end

    local nums = table.nums(vec_child)
    for i,v in ipairs(vec_child) do
        local tmp_node = v
        local is_match = tmp_node:getName() == name
        if is_match then
            count.num = count.num - 1
        end


        if is_match and count.num <= 0 then
            return tmp_node
        else
            local tmp_node2 = self:findNodeByNameRecursion(tmp_node, name, count)
            if tmp_node2 ~= nil then
                return tmp_node2
            end
        end
    end
    
    return nil
end

function GuideBase:getNodeChildren(data)
    if self.node_cache ~= nil then
        self.node_cache = self.node_cache:getChildren()[data.index]
    end
    self:finishGuide()
end

function GuideBase:checkWindowOpen(data)
    if self.node_cache ~= nil then

    end
    self:finishGuide() 
end

function GuideBase:showSubtitle(data)
    -- print("GuideBase:showSubtitle", data.is_quick or false, data.movie)
    if data.movie ~= nil then
        require("src.layer.SubmovieCtr"):instance():openWindow(data.movie)
    else
        require("src.layer.SubtitleCtr"):instance():openWindow(data.vec_text, data.is_quick or false)
    end
    self:finishGuide()
end


function GuideBase:sendEvent(data)
    ex.EventManager:fire(data.type, data.data)
    self:finishGuide()
end

function GuideBase:enabledAllChildren(data)
    -- self:setEnabled(false)
    if self.node_cache ~= nil and data.enabled ~= nil then
        local vec_children = self.node_cache:getChildren()
        local len = table.getn(vec_children)
        for i=1,len do
            local child = vec_children[i]
            if child.setEnabled then
                child:setEnabled(data.enabled)
            end
        end
    end
    self:finishGuide()
end

function GuideBase:enabledNode(data)
    if self.node_cache ~= nil and data.enabled ~= nil then
        self.node_cache:setEnabled(data.enabled)
    end
    self:finishGuide()
end

function GuideBase:setStepControl(data)
    if data.step ~= nil then
        GUIDE_STEP_CONTROL = data.step
    end
    self:finishGuide()
end


function GuideBase:setRichText(data)
    if self.node_cache and self.node_cache.setXmlTextLua then
        self.node_cache:setXmlTextLua(data.text)
    end
    self:finishGuide()
end

 function GuideBase:changeMainLayer(data)
    if data.layer_type then
        ex.MainSceneCtr:changeLayer(data.layer_type, nil,nil, data.is_fast)
    end
    self:finishGuide()
 end


return GuideBase