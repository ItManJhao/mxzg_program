-- 使用注意
-- 错误1
    -- 如果 is_auto_offset == true and is_auto_scale == false and item:setScale(self.auto_scale)
    -- 如果 self.auto_scale 过大 会导致item.height有部分重合

    -- 如果使用 item:setScale(self.auto_scale)
    -- 请将 self.is_auto_scale = true and is_auto_offset == true

-- 错误2
    -- setAutoFull 如果在TAB界面使用该类。则容易引起数组下标越界问题
    -- 引起错误场景
        -- TAB1界面需要自动铺满显示，
        -- TAB2界面不需要。则切换到TAB2界面时。createItemFunction会传递超出下标的数据，如果没有返回item则会报错
    -- TAB界面切换时应该调用 setAutoFull, TAB1.scrollview:setAutoFull(ture)  TAB2.scrollview:setAutoFull(false)
    -- 正确用法请参考英雄列表界面和英雄图鉴界面的切换

-- 错误3
    -- 横向应用时。如果 is_auto_scale == true and item:setScale(self.auto_scale) 
    -- 如果scrollview.height的值很大且row值很小的时候 。会导致item的缩放值也很大

-- 错误4
    -- 如果createItemFunction返回的不是UIMenuItem需要设置创建类型 setItemType(1) nodeTouched = Function
    
-- 第一次reloadData 是分帧创建一页item
    -- 2-N次的时候是一次创建一页item

-- 使用范例
-- 范例1
-- self.scroll_view:setItemSize(cc.size(80, 80))
-- self.scroll_view_reward1.createItemFunction = function(data, scale)
--     local item = ex.Tools:createBackpackItem(data.item_type, data.item_num)
--     item:setScale(0.6)
--     item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
--     return item
-- end
-- self.scroll_view_reward1:reloadData(reward)


-- 范例2
-- self.scroll_view:setItemType(1)
-- self.scroll_view:setItemSize(cc.size(80, 80))
-- self.scroll_view_reward1.createItemFunction = function(data, scale)
--      local cell = require("xxx"):createWithCCBIFile("ccbi/xxx.ccbi")
--      cell:reset(data)
--      return cell
-- end
-- self.scroll_view_reward1:reloadData(reward)

-- 逐帧创建的ScrollView
local UIScrollViewBackpack = class("UIScrollViewBackpack", function ()
    return cpp.UIScrollViewZoom:create()
end)

local UIMenuGeneral = require("src.comp.menu.UIMenuGeneral")

function UIScrollViewBackpack:ctor()
    -- 创建物品的回调
    self.createItemFunction = nil

    -- 数据源
    self.data = {}

    -- 每个物品的大小
    self.item_size = cc.size(0, 0)

    -- 物品的偏移, item的位置会偏移多少。item.x = item.x + item_offset.x
    self.item_offset = cc.p(0, 0)

    -- 边界。一般不需要设置
    self.margin = 0

    -- 生成物品的定时器
    self.scheduler_item = nil

    -- 自动补满剩余的格子
    self.full_item = false

    -- 多少行
    self.row_num = 0

    -- 多少列
    self.col_num = 0

    -- 需要显示的物品数据 {index = 0, item = UIMenuItem}
    self.vec_item = {}

    -- 总共显示多少个
    self.show_num = 0

    -- 总共有多少个物品
    self.item_num = 0

    -- 单次创建多少个item
    self.create_num = 1

    -- 当前显示到了第几个
    self.show_begin = 0

    -- 需要显示到第几个
    self.show_end = 0

    -- 开始坐标
    self.start = cc.size(0, 0)

    -- 创建方向。1从上往下，-1从下往上
    self.create_step = 1

    -- 设置自动间隔。每行的间隔均匀分布
    self.is_auto_offset = false

    -- 自动间隔
    self.auto_offset = cc.p(0, 0)

    -- 是否开启缩放填补间隔
    self.is_auto_scale = true 

    -- 缩放值
    self.auto_scale = 1

    -- 创建item的函数指针
    self.createItemAuto = self.createItemVertical

    -- reloadData 次数
    self.reload_num = 0

    -- item类型 0：UIMenuItem  1：Node
    self.item_type = 0

    -- 控制刷新内容后。是否回到当前位置
    self.is_reset_offset = false
    self.is_reloaded = false

    -- 居中对齐
    self.is_alignment_center = false

    -- 创建物品间隔
    self.create_interval = 0.02

    -- 是否发送滚动事件
    self.is_fire_scroll_event = false;

    self:registerScriptHandler(handler(self, self.eventHandler), -cc.Handler.SCROLLVIEW_SCROLL + cc.Handler.NODE)
end


function UIScrollViewBackpack:eventHandler(eventType)
    if eventType == "exit" or eventType == "cleanup" then
        self:onExit()
    elseif eventType == "enterTransitionFinish" then
        self:setDelegate()
    end
end

-- 
function UIScrollViewBackpack:createWithSize(view_size)
    local pRef = UIScrollViewBackpack:create()
    if pRef then
        pRef:setViewSize(view_size)
        pRef:setDelegate()
        pRef:registerScriptHandler(handler(pRef, pRef.scrollViewDidScroll), cc.SCROLLVIEW_SCRIPT_SCROLL) --滚动时的回掉函数
        return pRef
    end
    return nil
end


function UIScrollViewBackpack:addEvent(event,listener)
    if not self.eventList then self.eventList = {} end
    table.insert(self.eventList,ex.EventManager:add(event,listener))
end

function UIScrollViewBackpack:removeEvent()
    if self.eventList then
        for k,v in pairs(self.eventList) do
            ex.EventManager:remove(v)
        end
        self.eventList = nil
    end
end

-- 退出了
function UIScrollViewBackpack:onExit()
    self:stopCreate()
    self:removeEvent()
end

-- 
function UIScrollViewBackpack:scrollViewDidScroll(...)
    if self.show_num <= 0 then
        return
    end

    local view_size = self:getViewSize()
    local content_size = self:getContentSize()
    local content_offset = self:getContentOffset()
    local pre_show_begin = self.show_begin

    content_offset.x = math.min(0, content_offset.x)
    content_offset.y = math.min(0, content_offset.y)

    local direction = self:getDirection()
    -- 纵向
    if direction == cc.SCROLLVIEW_DIRECTION_VERTICAL then
        local show_y = (-content_offset.y) + view_size.height
        local ignore_row = math.floor( (content_size.height - show_y) / (self.item_size.height + self.auto_offset.y) )
        local entity_row = math.ceil( view_size.height / (self.item_size.height + self.auto_offset.y) )
    
        self.show_begin = math.max(1, ignore_row * self.col_num - self.col_num )
        self.show_end = math.max( 0, self.show_begin + entity_row * self.col_num + self.col_num * 2 )
        self.show_end = math.min( self.show_num, self.show_end )
    else
    -- 横向
        local show_x = -content_offset.x
        local ignore_col = math.floor((show_x) / (self.item_size.width + self.auto_offset.x) )
        local entity_col = math.ceil(view_size.width / (self.item_size.width + self.auto_offset.x) )
        
        self.show_begin = math.max(1, ignore_col * self.row_num - self.row_num )
        self.show_end = math.max( 0, self.show_begin + entity_col * self.row_num + self.row_num * 2 )
        self.show_end = math.min( self.show_num, self.show_end )
    end

    self:removeItem(0, self.show_begin - 1)
    self:removeItem(self.show_end + 1, self.show_num)

    self.create_step = pre_show_begin >= self.show_begin and 1 or -1

    self:startCreate()

    self:scrollEventCallback()
end

-- 开始逐帧创建
function UIScrollViewBackpack:startCreate()
    if self.scheduler_item ~= nil then
        return
    end
    
    -- 先创建一次
    self:createItemAuto()

    local scheduler_id = nil
    self.scheduler_item = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
        -- cocos底层有bug。其他代码导致界面创建失败时。ScrollView不会触发任何回调。无法关闭定时器
        if self.createItemAuto then
            self:createItemAuto()
        elseif scheduler_id then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(scheduler_id)
            scheduler_id = nil
        end
    end, self.create_interval, false)
    scheduler_id = self.scheduler_item
end

-- 停止创建
function UIScrollViewBackpack:stopCreate()
    if self.scheduler_item ~= nil then 
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler_item)
		self.scheduler_item = nil
	end
end

-- 重新加载所有item. data=nil时则需要调用setData
-- 应用场景
--  data不需要更新。则调用reloadData(nil)
--  data需要更新。则调用reloadData(data)
function UIScrollViewBackpack:reloadData(data)
    self:getContainer():removeAllChildren()

    if self.item_size.width <= 0 or self.item_size.height <= 0 then
    	print("item_size error, reloadData the form before calling setItemSize(cc.size(width, height))")
    	return
    end

    -- 创建一个menu
    self.menu = nil
    if self.item_type == 0 then
        self.menu = require("src.comp.menu.UIMenu"):create()--cpp.UIMenu:create()
    else
        self.menu = UIMenuGeneral:create()
        self.menu:setTouchCallback(self.nodeTouched)
    end

    self.menu:setIsTouchInsideNode(self)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    :setName("menu_backpack")
    self:getContainer():addChild(self.menu)

    self:stopCreate()
    -- cocosbuilder 会重新设置这个值
    self:setDelegate()
    self:registerScriptHandler(handler(self, self.eventHandler), -cc.Handler.SCROLLVIEW_SCROLL + cc.Handler.NODE)
    self:registerScriptHandler(handler(self, self.scrollViewDidScroll), cc.SCROLLVIEW_SCRIPT_SCROLL) --滚动时的回掉函数

    if data ~= nil then
        self:setData(data)
    end

    self.item_num = table.nums(self.data)
    self.vec_item = {}
    self.show_begin = 0
    self.show_end = 0
    self.show_num = 0

    -- 数据或者回调函数是空.
    if self.data == nil or (self.item_num <= 0 and self.full_item ~= true) or self.createItemFunction == nil then
        if self.createItemFunction == nil then
            print("createItemFunction is nil")
        end
        return
    end

    local direction = self:getDirection()
    local view_size = self:getViewSize()
    local item_size = self.item_size

    -- 计算行列
    local margin = self.margin
    local len = self.item_num

    -- 纵向
    if direction == cc.SCROLLVIEW_DIRECTION_VERTICAL then
        self.createItemAuto = self.createItemVertical

        local col = math.max(1, math.floor((view_size.width - margin * 2) / self.item_size.width))  -- 列数
        local row = math.ceil(1.0 * len / col) -- 行数
    
        -- 是否用空格子填满
        local row_max = math.ceil((view_size.height - margin * 2) / self.item_size.height)
        if self.full_item == true then
            row = math.max(row, row_max)
            self.show_num = row * col
        else
            self.show_num = self.item_num
        end
    
        self.col_num = col
        self.row_num = row
    
        -- 计算位置自动适配
        if self.is_auto_offset then
            col = math.min(self.show_num, col)
            local item_width = (view_size.width - margin * 2) / (col)
            self.auto_scale = item_width / self.item_size.width
            self.auto_offset.x = item_width - self.item_size.width 
            self.auto_offset.y = self.is_auto_scale and (self.auto_scale * self.item_size.height - self.item_size.height) or 0
        end


    
        -- 设置显示范围
        local cont_height = (self.item_size.height + self.auto_offset.y) * (row) + margin * 2
        cont_height = math.max(cont_height, view_size.height)
    
        -- 物品创建的开始点。优化创建速度
        self.start = cc.p(view_size.width * 0.5 - ((self.item_size.width + self.auto_offset.x) * (col - 1) * 0.5), cont_height - ((self.item_size.height + self.auto_offset.y) * 0.5 + margin * 0.5))

        if self.is_alignment_center then
            if self.show_num < self.col_num then
                self.start.x = view_size.width * 0.5 - ((self.item_size.width + self.auto_offset.x) * (self.show_num - 1) * 0.5)
            end
        end

        self.show_begin = 1
        -- self.show_end = self.show_num

        -- 这里会执行scrollViewDidScroll
        self:setContentSize(cc.size(view_size.width, cont_height))
        -- self:setContentOffset(cc.p(0, view_size.height - cont_height))
        self:resetOffset()
    else
        self.createItemAuto = self.createItemHorizontal

        -- 横向
        local row = math.max(1, math.floor((view_size.height - margin * 2) / self.item_size.height)) -- 行数
        local col = math.ceil(1.0 * len / row) -- 列数
        
        -- 计算可以显示多少列
        local show_col = math.max(1, math.floor((view_size.width - margin * 2) / self.item_size.width)) 

        -- 横向的不是左上对齐方式
        row = math.min(self.item_num, row)

        self.show_num = self.item_num

        self.col_num = col
        self.row_num = row
        
        -- 计算位置自动适配
        if self.is_auto_offset then
            local item_height = (view_size.height - margin * 2) / (row)
            self.auto_scale = item_height / self.item_size.height
            self.auto_offset.x = self.is_auto_scale and (self.auto_scale * self.item_size.width - self.item_size.width) or 0
            self.auto_offset.y = item_height - self.item_size.height  
        end   
    
        -- 设置显示范围
        local cont_width = (self.item_size.width + self.auto_offset.x) * (col) + margin * 2
        cont_width = math.max(cont_width, view_size.width)
    
        -- 物品创建的开始点。优化创建速度
        self.start = cc.p(margin + (self.item_size.width + self.auto_offset.x) * 0.5 , view_size.height * 0.5 + ((self.item_size.height + self.auto_offset.y) * (row - 1) * 0.5))

        if self.is_alignment_center then
            if self.show_num <= show_col then
                self.start.x = view_size.width * 0.5 - ((self.item_size.width + self.auto_offset.x) * (self.show_num - 1) * 0.5)
            end
        end

        self.show_begin = 1
        -- self.show_end = self.show_num

        -- 这里会执行scrollViewDidScroll
        self:setContentSize(cc.size(cont_width, view_size.height))
        -- self:setContentOffset(cc.p(0, 0))

        self:resetOffset()
    end

    self:startCreate()
end

function UIScrollViewBackpack:resetOffset()
    local direction = self:getDirection()
    local is_reloaded = self.is_reloaded
    if direction == cc.SCROLLVIEW_DIRECTION_VERTICAL then
        local offset = self:getContentOffset()
        local y = self:getViewSize().height - self:getContentSize().height
        self:setContentOffset(cc.p(offset.x, (self.is_reset_offset and is_reloaded) and cc.clampf(offset.y, 0, y) or y))
    else
        local offset = self:getContentOffset()
        local x = self:getViewSize().width - self:getContentSize().width
        self:setContentOffset(cc.p((self.is_reset_offset and is_reloaded) and cc.clampf(offset.x, 0, x) or 0, offset.y))
    end
    self.is_reloaded = true
end

function UIScrollViewBackpack:setData(data)             self.data = data end
function UIScrollViewBackpack:setItemSize(item_size)    self.item_size = item_size end
function UIScrollViewBackpack:setItemOffset(offset)     self.item_offset = offset end
function UIScrollViewBackpack:setCreateNum(num)         self.create_num = num end
function UIScrollViewBackpack:setAutoFull(b)            self.full_item = b end
function UIScrollViewBackpack:setAutoOffset(b)          self.is_auto_offset = b end
function UIScrollViewBackpack:setAutoScale(b)           self.is_auto_scale = b end
function UIScrollViewBackpack:setItemType(type)         self.item_type = type end
function UIScrollViewBackpack:setResetOffset(b)         self.is_reset_offset = b end
function UIScrollViewBackpack:setLoaded(b)              self.is_reloaded = b end
function UIScrollViewBackpack:setAlignmentCenter(b)     self.is_alignment_center = b end
function UIScrollViewBackpack:setCreateInterval(t)      self.create_interval = t end
function UIScrollViewBackpack:setFireScrollEvent(b)      self.is_fire_scroll_event = b end

-- create_interval

-- 关联另外一个scrollview，如果当前的视图滑动了。关联的视图也会跟着滑动
function UIScrollViewBackpack:setOffsetLink(scroll_view, speed)
    if not self.offset_pre then
        self.offset_pre = cc.p(0, 0)
    end

    self.link_speed = speed
    self.scroll_view_link = scroll_view
    self:addEvent(EVENT.UIControl.SCROLLVIEW_SCROLL_LINK, handler(self, self.offsetLinkEvent))
end

--让指定的item聚焦
function UIScrollViewBackpack:setFocus(index)

    if index > self.show_num or index < 0 then
        print("index not legal")
        return
    end

    local direction = self:getDirection()
    -- 纵向
    if direction == cc.SCROLLVIEW_DIRECTION_VERTICAL then
        -- 算出第几行
        local row = math.ceil(index / self.col_num)
        local offset = self:getContentOffset()
        local y = self:getViewSize().height - self:getContentSize().height
        self:setContentOffset(cc.p(offset.x, cc.clampf((row + 0.5) * self.item_size.width + self:getViewSize().height * 0.5 - self:getContentSize().height, 0, y)))
    else
    -- 横向
        -- 算出第几列
        local col = math.ceil(index / self.row_num) 
        local offset = self:getContentOffset()
        local x = self:getViewSize().width - self:getContentSize().width
        self:setContentOffset(cc.p(cc.clampf((col + 0.5) * self.item_size.height - self:getViewSize().width * 0.5 - self:getContentSize().width, 0, x), offset.y))
    end
end

function UIScrollViewBackpack:offsetLinkEvent(evt, caller, offset)
    if self ~= caller then
        return
    end

    local self_offset = self.scroll_view_link:getContentOffset()
    self_offset.x = self_offset.x + offset.x * self.link_speed
    self_offset.y = self_offset.y + offset.y * self.link_speed
    self.scroll_view_link:setContentOffset(self_offset)
end

function UIScrollViewBackpack:scrollEventCallback()
    if self.scroll_view_link == nil then
        if self.is_fire_scroll_event then
            ex.EventManager:fire(EVENT.UIControl.SCROLLVIEW_SCROLL, self)
        end
        return
    end
    
    local offset = self:getContentOffset()
    offset.x = offset.x - self.offset_pre.x
    offset.y = offset.y - self.offset_pre.y
    self.offset_pre = self:getContentOffset()
    ex.EventManager:fire(EVENT.UIControl.SCROLLVIEW_SCROLL_LINK, self, offset)
end

-- 删除显示区域外的item
function UIScrollViewBackpack:removeItem(begin_index, end_index)
    for i = begin_index, end_index do
        local item_showed = self.vec_item[i]
        if item_showed ~= nil then
            item_showed:removeFromParent()
        end
        self.vec_item[i] = nil
    end
end

-- 添加item。如果重复了则把之前的移除了
function UIScrollViewBackpack:addItem(index, item)
    local item_showed = self.vec_item[index]
    if item_showed ~= nil then
        item_showed:removeFromParent()
    end

    self.vec_item[index] = item
    self.menu:addChild(item)
end

-- 由定时器调用
function UIScrollViewBackpack:createItemVertical()
    local show_num = 0
    
    -- 判断是正向创建还是反向创建
    local begin_index = self.create_step == 1 and self.show_begin or self.show_end
    local end_index = self.create_step == 1 and self.show_end or self.show_begin

    for i = begin_index, end_index, self.create_step do
        if self.vec_item[i] == nil then

            local x = (i - 1) % self.col_num
            local y = math.floor((i - 1) / self.col_num)
            local pos = cc.p(self.start.x + x * (self.item_size.width + self.auto_offset.x) +  self.item_offset.x,
                             self.start.y - y * (self.item_size.height+ self.auto_offset.y) +  self.item_offset.y)

            local item = self.createItemFunction(self.data[i], self.auto_scale, i, pos)

            if item then
                item:setPosition(pos)
                self:addItem(i, item)
            else
                print("UIScrollViewBackpack:createItemHorizontal item is nil")
            end

            show_num = show_num + 1

            if self.reload_num <= 0 and show_num >= self.create_num then
                break
            end
        end
    end

    -- 已经创建完成
    if show_num <= 0 then
        self.reload_num = self.reload_num + 1
        self:stopCreate()
    end
end

-- 由定时器调用
function UIScrollViewBackpack:createItemHorizontal()
    local show_num = 0
    
    -- 判断是正向创建还是反向创建
    local begin_index = self.create_step == 1 and self.show_begin or self.show_end
    local end_index = self.create_step == 1 and self.show_end or self.show_begin

    for i = begin_index, end_index, self.create_step do
        if self.vec_item[i] == nil then
            local x = math.floor((i - 1) / self.row_num)
            local y = (i - 1) % self.row_num
            local pos = cc.p(self.start.x + x * (self.item_size.width + self.auto_offset.x) + self.item_offset.x,
                             self.start.y - y * (self.item_size.height+ self.auto_offset.y) + self.item_offset.y)
                             
            local item = self.createItemFunction(self.data[i], self.auto_scale, i, pos)

            if item then
                item:setPosition(pos)
                self:addItem(i, item)
            else
                print("UIScrollViewBackpack:createItemHorizontal item is nil")
            end
            show_num = show_num + 1
            if self.reload_num <= 0 and show_num >= self.create_num then
                break
            end
        end
    end

    -- 已经创建完成
    if show_num <= 0 then
        self.reload_num = self.reload_num + 1
        self:stopCreate()
    end
end

return UIScrollViewBackpack