local GuideCtr = class("GuideCtr", require("src.comp.EventLayer"))
local GuideAnimationLayer = class("GuideAnimationLayer", require("src.comp.EventLayer"))

-- local npc_talk_ctr = 
-- require("src.layer.NpcTalkCtr"):instance()
local is_finish = false             -- 是否已经完成
local is_recv_protocol = false      -- 是否在等待数据
local is_send_protocol = false
local is_wait_window_open = false
local is_wait_window_close = false

function GuideAnimationLayer:onCreate()
    self:setAutoClose(false)
    -- self:setSwallowTouches(false)

    self.touch_size = cc.size(0, 0)
    self.touch_position = cc.p(0, 0)
    self.is_wait_touch = false

    self:setPosition(cc.p(0, 0))
    self:setLocalZOrder(999998)
end

function GuideAnimationLayer:onExit()
    local guide_ctr = GuideCtr:instance()
    if guide_ctr then
        guide_ctr.lay_animation = nil
    end
end

function GuideAnimationLayer:getGuideSprite()
    return self:getChildByTag(99)
end

function GuideAnimationLayer:addGuideSprite(bubble_text)
    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/guide.plist")

    local win_size = cc.Director:getInstance():getWinSize()

    local position = cc.p(self.touch_position.x + self.touch_size.width * 0.5, self.touch_position.y + self.touch_size.height * 0.5)

    local node = cc.Node:create()
    node:setTag(99)
    node:setPosition(position)
    self:addChild(node)

    if self.is_mask == true then
        local opacity = 153
        local act_fade = cc.FadeTo:create(0.15, opacity)
    
        -- 添加黑色遮罩
        local spr_mask = cc.Sprite:createWithSpriteFrameName("guide/spr-mask.png")
        spr_mask:setOpacity(0)
        spr_mask:runAction(act_fade:clone())
        node:addChild(spr_mask)
    
        local mask_size = spr_mask:getContentSize()
    
        -- 添加顶部黑色
        local top_y = self.touch_position.y + self.touch_size.height * 0.5 + mask_size.height * 0.5
        if top_y < win_size.height then
            local layer_mask_top = cc.LayerColor:create(cc.c4b(0,0,0,0), win_size.width, win_size.height - top_y)
            -- layer_mask_top:setOpacity(opacity)
            layer_mask_top:setIgnoreAnchorPointForPosition(false)
            layer_mask_top:setAnchorPoint(cc.p(0.5, 0))
            layer_mask_top:setPosition(cc.p(win_size.width * 0.5 - (self.touch_position.x + self.touch_size.width * 0.5), mask_size.height * 0.5))
            layer_mask_top:runAction(act_fade:clone())
            node:addChild(layer_mask_top)
        end
    
        -- 添加底部黑色
        local bottom_y = self.touch_position.y - mask_size.height * 0.5
        if bottom_y > 0 then
            local layer_mask_bottom = cc.LayerColor:create(cc.c4b(0,0,0,0), win_size.width, top_y)
            -- layer_mask_top:setOpacity(opacity)
            layer_mask_bottom:setIgnoreAnchorPointForPosition(false)
            layer_mask_bottom:setAnchorPoint(cc.p(0.5, 1))
            layer_mask_bottom:setPosition(cc.p(win_size.width * 0.5 - (self.touch_position.x + self.touch_size.width * 0.5), -mask_size.height * 0.5))
            layer_mask_bottom:runAction(act_fade:clone())
            node:addChild(layer_mask_bottom)
        end
    
        -- 添加左边黑色
        local left_x = self.touch_position.x + self.touch_size.width * 0.5 - mask_size.width * 0.5
        if left_x > 0 then
            local layer_mask_left = cc.LayerColor:create(cc.c4b(0,0,0,0), left_x, mask_size.height)
            -- layer_mask_top:setOpacity(opacity)
            layer_mask_left:setIgnoreAnchorPointForPosition(false)
            layer_mask_left:setAnchorPoint(cc.p(1, 0.5))
            layer_mask_left:setPosition(cc.p(-mask_size.width * 0.5, 0))
            layer_mask_left:runAction(act_fade:clone())
            node:addChild(layer_mask_left)
        end
    
    
        -- 添加右边黑色
        local right_x = self.touch_position.x + self.touch_size.width * 0.5 + mask_size.width * 0.5
        if right_x > 0 then
            local layer_mask_right = cc.LayerColor:create(cc.c4b(0,0,0,0), win_size.width - right_x, mask_size.height)
            layer_mask_right:setIgnoreAnchorPointForPosition(false)
            layer_mask_right:setAnchorPoint(cc.p(0, 0.5))
            layer_mask_right:setPosition(cc.p(mask_size.width * 0.5, 0))
            layer_mask_right:runAction(act_fade:clone())
            node:addChild(layer_mask_right)
        end
    end
    

    local spr_ring = ex.EffectFactory:createEffectWithNodeByName("eff_guide_ring")
    spr_ring:setTag(99)
    node:addChild(spr_ring)


    local palm = ex.EffectFactory:createEffectWithNodeByName("eff_guide_palm")
    palm:setAnchorPoint(cc.p(0.1, 0.9))
    palm:setPosition(cc.p(spr_ring:getContentSize().width * 0.5, spr_ring:getContentSize().height * 0.5))
    spr_ring:addChild(palm)

    local atc_move = cc.Sequence:create(cc.MoveTo:create(1.2, cc.p(palm:getPositionX(), palm:getPositionY() + 10)),
                                        cc.MoveTo:create(1.2, cc.p(palm:getPositionX(), palm:getPositionY())))
    palm:runAction(cc.RepeatForever:create(atc_move))

    -- 判断是否移动
    if self.old_position then
        spr_ring:setPosition(self.old_position.x - position.x, self.old_position.y - position.y)
        spr_ring:runAction(cc.EaseExponentialOut:create(cc.MoveTo:create(1, cc.p(0, 0))))
    end

    return node
end

function GuideAnimationLayer:addBubble(bubble_text, anchor, bubble_pos)
    if bubble_text == nil or bubble_text == "" then
        return
    end

    self.spr_bubble = require("src.comp.UISpriteBubble"):createWithText(bubble_text)
    if anchor then
        self.spr_bubble:setAnchorPoint(anchor)
    end

    if bubble_pos then
        self.spr_bubble:setPosition(bubble_pos.x, bubble_pos.y)
    end
    
    self:getGuideSprite():addChild(self.spr_bubble)
end

function GuideAnimationLayer:remove()
    self:removeGuideSprite()
    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.07), cc.RemoveSelf:create()))
end

function GuideAnimationLayer:removeGuideSprite()
    local arrow = self:getGuideSprite()
    if arrow then
        arrow:setTag(-1)
        arrow:removeChildByTag(99)
        local children = arrow:getChildren()
        for i,v in ipairs(children) do
            local node = v
            local act_fade = cc.FadeTo:create(0.1, 0)
            node:runAction(act_fade)
        end
        arrow:runAction(cc.Sequence:create(cc.DelayTime:create(0.07), cc.RemoveSelf:create()))
    end
end

function GuideCtr:instance()
    if self._instance == nil and (not is_finish) then
        self._instance = self:create()
        self._instance:retain()
        self._instance:init()
    end
    return self._instance
end

function GuideCtr:ctor()
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
end

function GuideCtr:init()
    self:setLocalZOrder(999999);

    self.listener_touch = cc.EventListenerTouchOneByOne:create()  --创建一个单点事件监听
    self.listener_touch:setSwallowTouches(true)
    self.listener_touch:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.listener_touch:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.listener_touch:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    self.listener_touch:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_CANCELLED)
    local event_dispatcher = self:getEventDispatcher() 
    event_dispatcher:addEventListenerWithFixedPriority(self.listener_touch, -99999)

    self.guide_num = self:getGuideNum()
    
    if device.platform == "mac" then
        -- print("guide_num 11111")
        -- self.guide_num = 0
        -- self.guide_num = 400
        -- self.guide_num = 9999
        -- self:saveGuideNum()
    end
end

-----------------------模块------------------------
function GuideCtr:restart()
    local guide_ctr = GuideCtr:instance()
    if guide_ctr and guide_ctr.vec_guide_data ~= nil then
        if  table.nums(guide_ctr.vec_guide_data) > 0 or (guide_ctr:executeEntireFile()) then
            -- guide_ctr.
            guide_ctr:executeGuide()
        end
    end
end


function GuideCtr:isExecutingGuide()

    if is_finish then
        return false
    end

    local guide_ctr = GuideCtr:instance()
    if guide_ctr then
        return table.nums(guide_ctr.vec_guide_data) > 0
    end

    return false
end

-- 点击间隔是否有效
function GuideCtr:isTouchValid()
    return true
end

-- 点击开始
function GuideCtr:onTouchBegan(touch, event)
    local pos = touch:getLocation()
    if self:isTouchValid() == false then
        return true
    end
    -- print("self.is_swallow_touch", self.is_swallow_touch)
    return self.is_swallow_touch
end

function GuideCtr:onTouchMoved(touch, event)
end


-- 点击结束
function GuideCtr:onTouchEnded(touch, event)
    if self:isTouchValid() == false then
        return
    end

    if self:isTouchMask(touch) then
        self:delayTouch()
    elseif require("src.layer.NpcTalkCtr"):instance():canClose() then
        self:finishGuide()
    end
end

-- 是否点击到有效区域
function GuideCtr:isTouchMask(pTouch)
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
function GuideCtr:isTouchEnabledRect()
    local point = pTouch:getLocation()
    for k,v in pairs(self.vec_enabled_rect) do
        if cc.rectContainsPoint(v, point) then
            return true
        end
    end
    return false
end

-- 延迟点击
function GuideCtr:delayTouch()

    if self.is_touch_falsifying == true then
        -- 伪点击事件
    else
        self.is_swallow_touch = false
        local point = cc.p(self.lay_animation.touch_position.x + self.lay_animation.touch_size.width * 0.5,
                           self.lay_animation.touch_position.y + self.lay_animation.touch_size.height * 0.5)
        self:createTouch(self.lay_animation:convertToWorldSpace(point))
        self.is_swallow_touch = true
    end
    self:finishGuide()
end

-- 用CCEGLView创建一个点击事件.
function GuideCtr:createTouch(tp)
    cpp.MainSceneCtr:createTouch(tp)
end

-- 移除自己
function GuideCtr:remove(is_reset)
    print("GuideCtr:remove")
    is_recv_protocol = false
    is_send_protocol = false
    is_wait_window_open = false
    is_wait_window_close = false
    
    if is_finish then
        return
    end

    local guide_ctr = GuideCtr:instance()
    if guide_ctr then
        guide_ctr:removeAllData()
    end

    if is_reset then
        is_finish = false
    end
end

-----------------------删除------------------------
-- 移除所有数据.并删除自身
function GuideCtr:removeAllData()
    print("removeAllData")
    
    self:resetData()
    self:resetStepData()

    if self.lay_animation then
        self.lay_animation:remove()
        self.lay_animation = nil
    end

    self.is_swallow_touch = false
    self._instance = nil

    cc.Director:getInstance():getActionManager():removeAllActionsFromTarget(self)
    local event_dispatcher = self:getEventDispatcher() 
    event_dispatcher:removeEventListener(self.listener_touch)

    -- self._instance:release()
    -- self._instance:autorelease()

    local act_remove = cc.Sequence:create(cc.DelayTime:create(0.1), cc.DelayTime:create(0.1), cc.RemoveSelf:create())
    cc.Director:getInstance():getActionManager():addAction(act_remove, self, false)
end

-- 重置文件数据
function GuideCtr:resetData()
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

    is_recv_protocol = false
    is_send_protocol = false
    is_wait_window_open = false
    is_wait_window_close = false
end

-- 重置步骤数据
function GuideCtr:resetStepData()
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
function GuideCtr:readFile(file_name)
    return clone(require(file_name))
end

-- 读取文件队列.并执行对应的文件.
function GuideCtr:executeEntireFile()
    self:resetData()

    if self.guide_num ~= 0 and (not self.is_saved_num) then
        self:saveGuideNum()
    end

    local file_num = 0
    local is_succeed = false

    self.is_loading_scene = true
    self.is_saved_num = false

    local file_name = "src.config.guide.guideentire"

    local file_content = self:readFile(file_name)
    if file_content then
        for i,v in ipairs(file_content) do
            file_num = v.serial
            if file_num == self.guide_num then
                local data = file_content[i + 1]
                if data then
                    file_name = data.branch_guide
                    self.guide_num = data.serial
                    is_succeed = true
                end
                break
            end
        end
    end


    if is_succeed then
        self:readGuideFile(file_name)
        print("guide execute_file_name =", file_name)
    else
        is_finish = true
        self:removeAllData()
        print(ex.Tools:getLang(47459))
    end

    return is_succeed
end

-- 执行子文件
function GuideCtr:readGuideFile(file_name)
    self.execute_file_name = file_name
    self.vec_guide_data = self:readFile(file_name)
end

-----------------------逻辑------------------------
-- 执行当前步骤
function GuideCtr:executeGuide()

    -- 判断当前文件步骤是否执行完毕
    if self.step_num >= table.nums(self.vec_guide_data) then
        -- 不处于分离任务中..并且有剩余文件未执行
        -- 执行下一个文件
        if self:executeEntireFile() then
            self:executeGuide()
        end
        return
    end

    local data = self.vec_guide_data[self.step_num + 1]

    print("guide execute_guide_type =", data.call)

    -- 文件完成标志.保存当前指引序号.并继续执行接下来的步骤
    if data.finial then
        self.is_saved_num = true
        self:saveGuideNum()
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
function GuideCtr:finishGuide()
    self:resetStepData()
    self.step_num = self.step_num + 1

    self:executeGuide()
end

-- 完成当前步骤.并进行必要的清除
function GuideCtr:finishGuideDt(dt)
    self:finishGuide()
end

-- 保存文件进度.
function GuideCtr:saveGuideNum()
    -- local req_serial = cpp.ByteArray:create()
    -- req_serial:writeInt(ProtocolID.GReqGuideSerial)
    -- req_serial:writeInt(self.guide_num)
    -- cpp.NetManager:instance():sendByteArray(req_serial)
    local req_serial = Role_pb.GReqGuideSerial()
    req_serial.serial = self.guide_num
    NetManager:sendMessage(ProtocolID.GReqGuideSerial, req_serial)



    require("src.data.Player"):instance().guide_serial = self.guide_num
    require("src.platform.SocialPlatform"):submitRoleInfoLua("guide_num")
    
    print("guide saveGuideNum =", self.guide_num)
end

-- 获取文件进度
function GuideCtr:getGuideNum()
    return require("src.data.Player"):instance().guide_serial
end

-- 
function GuideCtr:getGuideDataByStep(step)
    return self.vec_guide_data[step + 1]
end

-- 关闭其他的窗口
function GuideCtr:closeOtherWindow()
    -- cpp.NodeCtr:closeOtherWindow()
    require("src.comp.LuaNodeCtr"):closeOtherWindow()
    -- require("src.comp.LuaNodeCtr"):closeOtherWindow()
    self:finishGuide()
end

-- 检查是否可以执行该文件
function GuideCtr:checkFile(data)
    if data.check_type == "rename" then
        if ex.Player.is_rename == 0 then
            self:finishGuide()
            return
        end
    elseif data.check_type == "summon_num" then
        local has_summon_num = ex.Player:getItemNum(ItemType.IT_SUMMON_POINT)
        if has_summon_num < data.num then
            self:finishGuide()
            return
        end
    elseif data.check_type == "hero_num" then
        if table.nums(ex.Player.hero_data.hero_list) <= data.num then
            self:executeFailFile(data.fail_file)
            return
        else
            self:finishGuide()
            return
        end
    elseif data.check_type == "altar" then
        local num = ex.Player.hero_data:getHeroNum(data.hero_type)
        if num >= data.num then
            self:finishGuide()
            return 
        end
    elseif data.check_type == "usepieces" then
        local num = ex.Player:getItemNum(data.item_type)
        if num >= data.num then
            self:finishGuide()
            return 
        end
    elseif data.check_type == "hero_lineup" then
        local is_lineup = ex.Player.lineup_data:isNullBattleList(LineupType.CHAPTER)
        if is_lineup == false then
            self:executeFailFile(data.fail_file)
            return
        else
            self:finishGuide()
            return 
        end
    elseif data.check_type == "gem_num" then
        if ex.Player.gem < data.num then
        else
            self:finishGuide()
            return
        end
    elseif data.check_type == "battle_num" then
        if ex.Player.battle_data:getBattleCount() < data.num then
            self:finishGuide()
            return
        end
    elseif data.check_type == "fetter_unlock" then
        local fetter_data = ex.Player.fetter_data:getFetterDataByIdx(data.idx)
        -- dump(fetter_data, "fetter_data")
        if fetter_data and fetter_data.level < 1 then
            self:finishGuide()
            return
        end
    elseif data.check_type == "findNode" then
        if self.node_cache ~= nil then
            self:finishGuide()
            return
        end
    elseif data.check_type == "fetter_lineup" then
        local fetter_type = ex.Player.lineup_data:getFettersType(LineupType.CHAPTER)
        if fetter_type == 0 then
            self:finishGuide()
            return
        end
    end
    
    -- 移除失效的步骤
    self:removeMissStep(data)
    self:finishGuide()
end

-- 处理错误文件
function GuideCtr:executeFailFile(fail_file)
    local file = "src.config.guide.guideentire"
    local file_content = self:readFile(file)

    local pre_guide_num = 99999
    for i,v in ipairs(file_content) do
        if v.branch_guide == fail_file then
            self.guide_num = pre_guide_num
            break
        end
        pre_guide_num = v.serial
    end

    self:executeEntireFile()
    self:executeGuide()
end

-- 删除多余的步骤
function GuideCtr:removeMissStep(data)
    self:eraseObject(data.r_beg, data.r_end)
end

-- 安全删除数组数据.
function GuideCtr:eraseObject(r_beg, r_end)
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
function GuideCtr:checkLayerType(data)
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
function GuideCtr:stayInMiddleStep(data)
    self:stayInMiddle(self.node_cache)
    self:finishGuide()
end

--
function GuideCtr:stayInMiddle(node)
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
function GuideCtr:setScrollOffset(data)
    if self.node_cache.__cname == "cc.ScrollView" then
        self.node_cache:setContentOffset(cc.p(data.x, data.y))
    end
    self:finishGuide()
end

-- 判断某个窗口是否打开
function GuideCtr:isOpenWindow(data)
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
function GuideCtr:isOpenWindowLua(data)
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
function GuideCtr:openWindow(data)
    if data.file then
        require(data.file):instance():openWindow(data.params1, data.params2, data.params3, data.params4)
    end

    self:finishGuide()
end

-- 判断物体移动状态
function GuideCtr:compFloat(value1, value2)
    if math.floor(value1 * 1000) == math.floor(value2 * 1000) then
        return true
    end
    return false
end

function GuideCtr:compPoint(value1, value2)
    if self:compFloat(value1.x, value2.x) and self:compFloat(value1.y, value2.y) then
        return true
    end
    return false
end

-----------------------窗口------------------------
-- 监听窗口打开.
function GuideCtr:addOpenWindowListen(data)
    is_wait_window_open = true
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
function GuideCtr:removeOpenWindowListen(data)
    is_wait_window_open = false
    self.is_listen_open = false
    self:finishGuide()
end

-- 监听窗口关闭.
function GuideCtr:addCloseWindowListen(data)
    is_wait_window_close = true
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
function GuideCtr:removeCloseWindowListen(data)
    is_wait_window_close = false
    self.is_listen_close = false
    self:finishGuide()
end

-- 窗口打开
function GuideCtr:windowsOpen(window, ccbi_path)
    if is_finish then
        return
    end

    if is_wait_window_open == false then
        return
    end

    local scene = require("src.scene.SceneCtr"):getRunningSceneCtr()
    if not scene then
        return
    end

    local guide_ctr = GuideCtr:instance()
    if guide_ctr and guide_ctr.is_listen_open then
        local data = guide_ctr.vec_guide_data[guide_ctr.step_open_num]
        local window_ccbi_path = data.ccbi_path

        if window_ccbi_path == ccbi_path then
            guide_ctr.step_num = data.step - 1
            guide_ctr:finishGuide()
        end
    end
end

-- 窗口关闭
function GuideCtr:windowsClose(window, ccbi_path)
    -- print("GuideCtr:windowsClose111")
    if is_finish then
        return
    end
        -- print("GuideCtr:windowsClose222")
    if is_wait_window_close == false then
        return
    end
        -- print("GuideCtr:windowsClose333")

    local scene = require("src.scene.SceneCtr"):getRunningSceneCtr()
    if not scene then
        return
    end
        -- print("GuideCtr:windowsClose333")

    local guide_ctr = GuideCtr:instance()
    if guide_ctr and guide_ctr.is_listen_close then
        local data = guide_ctr:getGuideDataByStep(guide_ctr.step_close_num)
        local window_ccbi_path = data.ccbi_path
        print("window_ccbi_path == ccbi_path", window_ccbi_path, ccbi_path)
        if window_ccbi_path == ccbi_path then
            guide_ctr.step_num = data.step - 1
            guide_ctr.is_listen_close = false;
            guide_ctr:finishGuide()
        end
    end
end


-----------------------动画------------------------
-- 创建箭头动画.
function GuideCtr:createMask(data)
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


    self.bubble_text = data.bubble
    self.bubble_anchor = data.anchor

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
function GuideCtr:cameraMoveToTarget(time, target_size)
    if not self.node_cache then
        return
    end

    local tp = cc.p(0, 0)
    local destination = cc.p(0, 0)
end


-- 对目标进行遮罩
function GuideCtr:maskTarget()
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
function GuideCtr:stopWaitTouchTarget(dt)

end

-- 将箭头动画添加到动画层上
function GuideCtr:createArrow(target_point, activities_size, bubble_text, bubble_anchor)
    local data = self:getGuideDataByStep(self.step_num)

    if not self.lay_animation then
        self.lay_animation = GuideAnimationLayer:create()
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
        self.lay_animation:addBubble(bubble_text, bubble_anchor, data.bubble_pos)
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
function GuideCtr:openNPCLayer(data)

    if data.music then
        ex.AudioManager:playEffect(data.music)
    end

    if data.auto == 1 then
        require("src.layer.NpcTalkCtr"):instance():openWindowAuto(data.npc_name,
                                                                  data.content)
    else
        require("src.layer.NpcTalkCtr"):instance():openWindow(data.npc_name,
                                                              data.content)
        self:finishGuide()
    end
end

-----------------------设置------------------------
-- 设置触摸
function GuideCtr:setSwallow(data)
    -- dump(data, "GuideCtr:setSwallow")
    if data.is_swallow_touch ~= nil then
        self.is_swallow_touch = data.is_swallow_touch
        -- print("GuideCtr:setSwallow", self.is_swallow_touch)
    end
    self:finishGuide()
end

-- 设置失效区域
function GuideCtr:setEnabledRect(data)
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
function GuideCtr:removeEnabledRect()
    self.vec_enabled_rect = {}
    self:finishGuide()
end


-- 让节点显示或隐藏
function GuideCtr:setNodeVisible()

end

-----------------------等待------------------------
-- 等待场景加载完毕
function GuideCtr:waitSceneLoadingEnd()
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
function GuideCtr:waitChangeScene()
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
function GuideCtr:wait(data)
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
function GuideCtr:waitTouch()
    
end

-- 让节点显示或隐藏
function GuideCtr:setNodeVisible(data)
    if self.node_cache then
        self.node_cache:setVisible(data.visible == 1)
    end
    self:finishGuide()
end


-- 等待物体停止
function GuideCtr:waitMove(dt)
    
end

-- 新手指引停止在这里.
function GuideCtr:waitRecv(data)
    is_recv_protocol = true
end

-- 等待收到某个协议
function GuideCtr:waitRecvProtocol(protocol, tag1, tag2)
    if is_finish then
        return
    end

    if is_recv_protocol == false then
        return
    end

    local guide_ctr = GuideCtr:instance()
    if guide_ctr then
        local data = guide_ctr:getGuideDataByStep(guide_ctr.step_num)
        if data and data.protocol then
            print(data.protocol, protocol)
            local wait_protocol = data.protocol
            local is_tag1 = data.tag1 and (data.tag1 == tag1) or true
            local is_tag2 = data.tag2 and (data.tag2 == tag2) or true
            if wait_protocol == protocol and is_tag1 and is_tag2 then
                -- scheduler->unschedule(schedule_selector(GuideCtr::finishGuideDt),guide_ctr);
                guide_ctr:finishGuide()
            end
        end
    end
end

-- 新手指引停止在这里.
function GuideCtr:waitSend(data)

end

-- 等待发送某个协议
function GuideCtr:waitSendProtocol(protocol, tag1, tag2)
    if is_finish then
        return
    end

    if is_send_protocol == false then
        return
    end

    local scene_ctr = require("src.scene.SceneCtr"):getRunningSceneCtr()
    if not scene_ctr then
        return
    end

    local guide_ctr = GuideCtr:instance()
    if guide_ctr then
        local data = guide_ctr:getGuideDataByStep(guide_ctr.step_num)
        if data and data.protocol then
            local wait_protocol = data.protocol
            if  wait_protocol == protocol then
                guide_ctr:finishGuide()
            end
        end
    end
end

-- 等待某个事件
function GuideCtr:waitEvent()
    
end


function GuideCtr:rollStep(data)
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

-----------------------寻找------------------------
-- 寻找文件对应的精灵.
function GuideCtr:findSpriteByFileName(data)
    local tmp_node_cache = self.node_cache
    self.node_cache = nil

    if data.file then
        local sfc = cc.SpriteFrameCache:getInstance()
        -- 重新加载plist文件.因为SpriteFrame有可能已经被释放了,会查找不到.
        if data.plist ~= nil then
            sfc:addSpriteFrames(data.plist)
        end

        -- 根据文件名查找节点.
        local file_name = data.file
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
                print("GuideCtr::findSpriteByFileName1 : miss file = ", file_name)
            end
        else
            print("GuideCtr::findSpriteByFileName2 : miss file = ", file_name)
        end
    end

    self:finishGuide()
end


function GuideCtr:findSpriteByFileNameRecursion(node, frame, count)
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

function GuideCtr:findHeroIcon(data)
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
        print("GuideCtr::findHeroIcon : miss file = ", data.type)
    end

    self:finishGuide()
end


function GuideCtr:findHeroIconRecursion(node, type, count)
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


function GuideCtr:findLabel(data)
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
        print("GuideCtr::findLabel : miss = ", data.text)
    end

    self:finishGuide()
end


function GuideCtr:findLabelRecursion(node, text, count, visible)
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


function GuideCtr:findNodeByName(data)
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
        print("GuideCtr::findNodeByName : miss file = ", data.name)
    end

    self:finishGuide()
end

function GuideCtr:findNodeByNameRecursion(node, name, count)
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

function GuideCtr:getNodeChildren(data)
    if self.node_cache ~= nil then
        self.node_cache = self.node_cache:getChildren()[data.index]
    end
    self:finishGuide()
end

function GuideCtr:checkWindowOpen(data)
    if self.node_cache ~= nil then

    end
    self:finishGuide() 
end


function GuideCtr:createBattlePreview(data)
    local layer_main_battle = ex.MainSceneCtr:getKeepBuffer(MainSceneType.MLT_BATTLE)
    if layer_main_battle then
        layer_main_battle:createBattlePreview()
    end
    self:finishGuide() 
end


function GuideCtr:startBattlePreview(data)
    -- local layer_main_battle = ex.MainSceneCtr:getKeepBuffer(MainSceneType.MLT_BATTLE)
    -- if layer_main_battle then
    --     layer_main_battle:startBattlePreview()
    -- end
    ex.EventManager:fire(EVENT.BATTLE_EVENT.GUIDE_BATTLE_START)
    self:finishGuide() 
end

function GuideCtr:waitBattlePreviewEnd(data)

end

function GuideCtr:battlePreviewEnd()
     if is_finish then
        return
    end

    local scene_ctr = require("src.scene.SceneCtr"):getRunningSceneCtr()
    if not scene_ctr then
        return
    end

    local guide_ctr = GuideCtr:instance()
    if guide_ctr then
        guide_ctr:finishGuide()
    end
end

function GuideCtr:showSubtitle(data)
    print("GuideCtr:showSubtitle", data.is_quick or false)
    require("src.layer.SubtitleCtr"):instance():openWindow(data.vec_text, data.is_quick or false)
    self:finishGuide()
end


function GuideCtr:clearBattle(data)
    local layer_main_battle = ex.MainSceneCtr:getKeepBuffer(MainSceneType.MLT_BATTLE)
    if layer_main_battle and layer_main_battle.clearBattle then
        layer_main_battle:clearBattle()
    end
    self:finishGuide()
end

function GuideCtr:updateMainBattle(data)
    local layer_main_battle = ex.MainSceneCtr:getKeepBuffer(MainSceneType.MLT_BATTLE)
    if layer_main_battle and layer_main_battle.battleMissionEnd then
        layer_main_battle:battleMissionEnd()
    end
    self:finishGuide()
end

function GuideCtr:sendEvent(data)
    ex.EventManager:fire(data.type, data.data)
    self:finishGuide()
end

function GuideCtr:enabledAllChildren(data)
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


function GuideCtr:enabledNode(data)
    if self.node_cache ~= nil and data.enabled ~= nil then
        self.node_cache:setEnabled(data.enabled)
    end
    self:finishGuide()
end

return GuideCtr
