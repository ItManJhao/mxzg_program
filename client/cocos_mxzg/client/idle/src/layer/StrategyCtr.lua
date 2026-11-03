local StrategyCtr = class("StrategyCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local StrategyLayer = class("StrategyLayer", require("src.comp.EventLayer"))

function StrategyLayer:onCreate()
    self:addBlackBackground()
end

-----------------------------------------------------------------------------
function StrategyCtr:onCreate()
    self:setCCBIPath("ccbi/StrategyLayer.ccbi")
    self:setIsSingle(false)
end

function StrategyCtr:getLayerClass()
    return StrategyLayer
end

function StrategyCtr:getStrategyLayer()
    return self.layer
end

function StrategyCtr:openWindow(method)
    if self:isOpened() then
        return
    end
    
    self:loadLayer()
    self:open()
    self:initData(method)
end

function StrategyCtr:initData(method)
    self.method = method

    self:updateContent()
end

function StrategyCtr:updateContent()
    if self.layer == nil then
        return
    end

    self.vec_content = {}
    for i,v in ipairs(cfg[self.method][self.method]) do
        table.insert(self.vec_content, clone(v))
    end
    table.sort(self.vec_content, function(a, b)
        if a.section ~= b.section then return a.section < b.section end
        if a.section_type ~= b.section_type then return a.section_type < b.section_type end
        if a.idx ~= b.idx then return a.idx < b.idx end
        return true
    end)

    -- 清空已有显示
    self.layer.scroll_view:getContainer():removeAllChildren()

    self.vec_lbl_content = {}

    -- 逐个显示数组里的字符串，防止卡顿
    self:addContentStepByStep(1, 0)
end

function StrategyCtr:addContentStepByStep(step, offset_y)
    if self.layer == nil then
        return
    end

    local size_width = self.layer.scroll_view:getViewSize().width - 10
    local size_height = self.layer.scroll_view:getViewSize().height
    if step > table.nums(self.vec_content) then
        return
    end

    local str_content = ex.Tools:getLang(self.vec_content[step].lang)

    -- local lbl_content = cpp.RichTextEx:createWithXMLLua("")
    -- :setFontSize(40)
    -- :setFontFace(FONT_DEFAULT_NAME_BOLD)
    -- :setAnchorPoint(cc.p(0.5, 1))
    -- :setScale(0.5)
    -- :ignoreContentAdaptWithSize(false)
    -- :setWrapMode(1)
    -- self.layer.scroll_view:addChild(lbl_content)

    -- if self.vec_content[step].section_type > 1 then
    --     lbl_content:setFontColor("#6C4D34")
    --     lbl_content:setContentSize(size_width * 2 - 20, 0)
    --     lbl_content:setPosition(size_width / 2 + 20, offset_y)
    -- else
    --     lbl_content:setFontColor("#8A3926")
    --     lbl_content:setContentSize(size_width * 2, 0)
    --     lbl_content:setPosition(size_width / 2, offset_y)
    -- end

    -- lbl_content:setXmlTextLua(str_content)
    -- lbl_content:formatText()

    local lbl_content = cc.Label:createWithTTF(str_content, FONT_DEFAULT_NAME_BOLD, 40)
    :setLineHeight(60)
    :setScale(0.5)
    :setAnchorPoint(cc.p(0.5, 1))
    self.layer.scroll_view:addChild(lbl_content)

    if self.vec_content[step].section_type == 1 then
        lbl_content:setColor(cc.c3b(138,57,38))
        lbl_content:setPosition(size_width / 2, offset_y)
        lbl_content:setDimensions(size_width * 2, 0)
    else
        lbl_content:setColor(cc.c3b(108,77,52))
        lbl_content:setPosition(size_width / 2 + 20, offset_y)
        lbl_content:setDimensions(size_width * 2 - 20, 0)
    end

    table.insert(self.vec_lbl_content, lbl_content)

    offset_y = offset_y + lbl_content:getContentSize().height * lbl_content:getScaleY() + 30

    self:updateContentPos()

    -- 延迟一定时间再次添加下一段话
    self.layer:runAction(cc.Sequence:create(cc.DelayTime:create(0.01), cc.CallFunc:create(function()
        self:addContentStepByStep(step + 1, offset_y)
    end), nil))
end

function StrategyCtr:updateContentPos()
    if self.layer == nil or self.vec_lbl_content == nil or table.nums(self.vec_lbl_content) <= 0 then
        return
    end

    local last_content_height = 0
    for i,v in ipairs(self.vec_lbl_content) do
        v:setPositionY(last_content_height)
        if v:getContentSize().height <= 0 then
            last_content_height = last_content_height - 25
        else
            last_content_height = last_content_height - v:getContentSize().height * v:getScaleY() - 5
        end
    end

    for i,v in ipairs(self.vec_lbl_content) do
        v:setPositionY(v:getPositionY() - last_content_height)
    end

    self.layer.scroll_view:setContentSize(cc.size(self.layer.scroll_view:getViewSize().width, -last_content_height))
    self.layer.scroll_view:setContentOffset(cc.p(0, self.layer.scroll_view:getViewSize().height - self.layer.scroll_view:getContentSize().height))
end

return StrategyCtr
