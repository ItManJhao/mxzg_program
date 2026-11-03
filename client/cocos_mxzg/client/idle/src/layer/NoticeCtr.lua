local NoticeCtr = class("NoticeCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local NoticeLayer = class("NoticeLayer", require("src.comp.EventLayerAdaptiveWidth"))

function NoticeLayer:onCreate()
    self:addBlackBackground()
	print("NoticeLayer:onCreate")
	-- self:setAutoClose(false)

    -- self.btn_confirm:setLabelText(ex.Tools:getLang(47589))
    self.lbl_pre:enableOutline(FONT_BROWN, 4)
end

-----------------------------------------------------------------------------
function NoticeCtr:onCreate()
    self:setCCBIPath("ccbi/NoticeLayer.ccbi")
    self:setIsSingle(false)
end

function NoticeCtr:getLayerClass()
    return NoticeLayer
end

function NoticeCtr:getClanRankLayer()
    return self.layer
end

function NoticeCtr:openWindow(str_content, str_title)
    if self:isOpened() then
        return
    end

    self.str_content = str_content
    self.str_title = str_title

    self:loadLayer()
    self:open()
    self:initData()
end

function NoticeCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.closeWindow))

    self:updateContent()
end

function NoticeCtr:onConfirm(tag, pSender)
    self:closeWindow(tag, pSender)
end

function NoticeCtr:receiveRes(event)
    self:closeWindow(0, nil)
end

function NoticeCtr:updateContent()
    if self.layer == nil then
        return
    end

    self.layer.lbl_pre:setString(self.str_title or "")

    -- 以换行符为切割符，切割字符串为数组
    self.vec_content = {}
    local str_token = "\\n"
    local str_src = self.str_content
    str_src = string.gsub(self.str_content, "\\r", "", 1000000)
    local size = string.len(str_src)
    -- if str_src ~= nil then
    --     size = table.nums.len(str_src)
    -- end

    -- print(str_src)
    
    local cur_pos = 1
    local pos = nil
    for i=1,size do
        pos = string.find(str_src, str_token, cur_pos)
        if pos ~= nil and pos <= size then
            local sub = string.sub(str_src, cur_pos, pos - 1)
            table.insert(self.vec_content, sub)
            -- print(cur_pos, table.nums(self.vec_content), sub)
            cur_pos = pos + string.len(str_token)
        elseif pos == nil and cur_pos < size then
            local sub = string.sub(str_src, cur_pos, size)
            table.insert(self.vec_content, sub)
            -- print(cur_pos, table.nums(self.vec_content), sub)
            break
        end
        if cur_pos > size then
            break
        end
    end

    -- 清空已有显示
    self.layer.scroll_view_text:getContainer():removeAllChildren()

    self.vec_lbl_content = {}

    -- 逐个显示数组里的字符串，防止卡顿
    self:addContentStepByStep(1, 0)
end

function NoticeCtr:addContentStepByStep(step, offset_y)
    if self.layer == nil then
        return
    end

    local size_width = self.layer.scroll_view_text:getViewSize().width
    local size_height = self.layer.scroll_view_text:getViewSize().height
    if step > table.nums(self.vec_content) then
        return
    end

    local str_content = self.vec_content[step]

    str_content = string.gsub(str_content, "\\", "", 1000000)

    -- print("addContentStepByStep", str_content)

    local lbl_content = require("src.comp.RichTextEx"):create()
    :setFontSize(40)
    :setFontFace(FONT_DEFAULT_NAME_BOLD)
    :setFontColor("#5A3509")
    :setScale(0.5)
    :ignoreContentAdaptWithSize(false)
    :setWrapMode(1)
    lbl_content:setContentSize(size_width * 2, 0)

    lbl_content:setCallback(handler(self, self.openRichTextUrl))

    lbl_content:setXmlTextLua(str_content)
    lbl_content:formatText()

    lbl_content:setPosition(size_width / 2, offset_y)
    lbl_content:setAnchorPoint(cc.p(0.5, 1))
    self.layer.scroll_view_text:addChild(lbl_content)

    table.insert(self.vec_lbl_content, lbl_content)

    offset_y = offset_y + lbl_content:getContentSize().height * lbl_content:getScaleY()

    self:updateContentPos()

    -- 延迟一定时间再次添加下一段话
    self.layer:runAction(cc.Sequence:create(cc.DelayTime:create(0.01), cc.CallFunc:create(function()
        self:addContentStepByStep(step + 1, offset_y)
    end), nil))
end

function NoticeCtr:updateContentPos()
    if self.layer == nil or self.vec_lbl_content == nil or table.nums(self.vec_lbl_content) <= 0 then
        return
    end

    local last_content_height = 0
    for i,v in ipairs(self.vec_lbl_content) do
        v:setPositionY(last_content_height)
        if v:getContentSize().height <= 0 then
            last_content_height = last_content_height - 25
        else
            last_content_height = last_content_height - v:getContentSize().height * v:getScaleY()
        end
    end

    for i,v in ipairs(self.vec_lbl_content) do
        v:setPositionY(v:getPositionY() - last_content_height)
    end

    self.layer.scroll_view_text:setContentSize(cc.size(self.layer.scroll_view_text:getViewSize().width, -last_content_height))
    self.layer.scroll_view_text:setContentOffset(cc.p(0, self.layer.scroll_view_text:getViewSize().height - self.layer.scroll_view_text:getContentSize().height))
end

function NoticeCtr:openRichTextUrl(url)
    local vec_str = string.split(url, SPLIT_CHAR)
    if vec_str[1] == "safari" then
        cpp.Game:instance():openURL(vec_str[2])
    end
end

return NoticeCtr
