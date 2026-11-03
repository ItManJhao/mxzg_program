
local BiuLayer = class("BiuLayer", require("src.comp.EventLayer"))

function BiuLayer:onCreate()
    -- 时间累积器
    self.time = 0

    -- 下次刷新的间隔
    self.time_diff = 0

    -- 弹幕数据
    self.vec_text = {}

    self.text_num = 0

    local tmp_color = ex.Tools:getSysCfg("champion_barrage_color")
    self.vec_color = {}
    for i,v in ipairs(tmp_color) do
        local color = v.c
        color = ex.StringUtil.splist(color, "-")
        color = cc.c3b(color[1], color[2], color[3])
        table.insert(self.vec_color, color)
    end
    self.color_num = table.nums(self.vec_color)
end

function BiuLayer:updateRound1()
    for i,v in ipairs(self.vec_text) do
        v.is_show = false
    end

    self:addTimer("updateRound1", 1000 * ex.Tools:getSysCfg("champion_barrage_frequency"), handler(self, self.updateRound2), true)
end

function BiuLayer:updateRound2()
    self:removeTimerByName("updateRound1")
    self:startBiu()
end

function BiuLayer:updateTimer()
    self.time = self.time + 17
    if self.time < self.time_diff then
        return
    end

    -- 所有的字幕都刷过一遍了
    local is_show_all = TableEx.findValueFunction(self.vec_text, function(value)
        return value.is_show == false
    end)

    if is_show_all == nil then
        self:removeTimerByName("timer")
        self:updateRound1()
        return
    end

    -- if #self.vec_text <= 0 then
    if self.text_num <= 0 then
        return
    end

    -- 取出一个数据
    local data = self.vec_text[math.random(0, self.text_num)]
    if data == nil then
        return
    end

    -- 限制出现的次数
    if data.count > 1 then
        data.count = data.count - 1
        return
    end

    if data.is_show then
        return
    end

    -- 随机Y位置
    local height = self:getContentSize().height
    local y = math.random(0, height)

    -- 如果跟上一次的位置差异太小。则不刷新
    -- if math.abs(y - self.pre_y) < 60 then
    --     return
    -- end
    -- 坐标去重
    local is_overlap = false
    local children = self:getChildren()
    for i,v in ipairs(children) do
		if math.abs(v:getPositionY() - y) < 30 then
            is_overlap = true
            break
        end
	end


    if is_overlap then
        return
    end

    -- 出现的间隔
    data.is_show = true
    data.count = math.random(6, 14)
    self.time = 0
    self.time_diff = math.random(900,1500)


    local color = nil -- cc.c3b(math.random(1, 255), math.random(1, 255), math.random(1, 255))
    local color_index = math.random(1, self.color_num) -- self.color_num
    if color_index <= 0 then
        color = cc.c3b(math.random(1, 255), math.random(1, 255), math.random(1, 255))
    else
        color = self.vec_color[color_index]
    end

    local lbl_text = cc.Label:createWithTTF(data.text.content, FONT_DEFAULT_NAME_BOLD, math.random(20, 25))
    lbl_text:setAnchorPoint(cc.p(0, 0.5))
	lbl_text:setTextColor(color)
    lbl_text:enableOutline(ex.c3b.BLACK, 2)

    local node_move = nil
    if data.text.is_my then
        local spr_bg = ccui.Scale9Sprite:createWithSpriteFrameName("championship/spr-select-1.png", cc.rect(20, 20, 112, 22));
        spr_bg:setContentSize(cc.size(math.max(60, lbl_text:getContentSize().width + 60), math.max(42, lbl_text:getContentSize().height + 30) ))
        spr_bg:setAnchorPoint(cc.p(0, 0.5))
        spr_bg:addChild(lbl_text)
        lbl_text:setPosition(cc.p(30, spr_bg:getContentSize().height * 0.5))

        node_move = spr_bg
        self:addChild(spr_bg)
    else
        node_move = lbl_text
        self:addChild(node_move)
    end

    node_move:setPosition(cc.p(ex.p.width + 30, y))

    local move_x = -lbl_text:getContentSize().width - 80
    local offset = node_move:getPositionX() - move_x

    -- 移动速度
    offset = offset / math.random(110, 230)
    node_move:runAction(cc.Sequence:create(cc.MoveTo:create(offset, cc.p(move_x, y)), cc.RemoveSelf:create()))
end

function BiuLayer:setBiuText(vec_text)
    self.vec_text = {}
    for i,v in ipairs(vec_text) do
        local data = {}
        data.text = v
        data.count = 1
        data.is_show = false
        table.insert(self.vec_text, data)
    end

    self.text_num = #self.vec_text
end

function BiuLayer:addBiuText(data)
    if not data then
        return
    end
    local tmp_data = {}
    tmp_data.text = data
    tmp_data.count = 1
    tmp_data.is_show = false
    table.insert(self.vec_text, tmp_data)
    self.text_num = #self.vec_text
end

function BiuLayer:startBiu()
    self:addTimer("timer", 17, handler(self, self.updateTimer), true)
end

function BiuLayer:stopBiu()
    self:removeTimerByName("updateRound1")
    self:removeTimerByName("timer")
    self:removeAllChildren()
end

function BiuLayer:clearBiu()
    self:removeAllChildren()
end

return BiuLayer
