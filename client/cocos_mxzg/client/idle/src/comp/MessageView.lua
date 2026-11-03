local MessageView = class("MessageView", require("src.common.SingleInstance"))

-- local TextElem = class("TextElem")
-- function TextElem:ctor()
--     self.text = ""
--     self.err = 0
-- end

-- local LabelElem = class("LabelElem")
-- function LabelElem:ctor()
--     self.lbl_message = nil
--     self.spr_bg = nil
-- end


function MessageView:ctor()
    -- 提示
    self.is_molding = false
    self.vec_label = {}         -- 提示，存储正在播放的显示节点
    self.vec_text_elem = {}     -- 提示，存储即将播放的公告数据

    self.message_max = 3
    
    -- 公告(跑马灯)
    self.is_noticing = false    -- 是否正在公告
    self.is_noticing_force = 0  -- 正在播放的公告是否是强制播放的公告
    self.spr_notice_bg = nil    -- 公告背景
    self.scroll_view = nil      -- 公告滚动范围
    self.vec_notice = {}        -- 公告，存储即将播放的公告数据
    self.last_show_time = 0     -- 防止动画卡住
end

function MessageView:onExit()

end

-- 添加提示
function MessageView:add(text, err)
    if string.len(text) <= 0 then
        return
    end
    -- text = "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"
    
    local data = {}
    data.text = text
    data.err = err
    table.insert(self.vec_text_elem, data)

    if self.is_molding == false or table.nums(self.vec_text_elem) > self.message_max + 2 then
        self.is_molding = false
        self:showNextMessage()
    end
end

-- 添加公告(跑马灯)
-- @param text: 跑马灯内容；is_force: >0则强制播放；notice_id: 跑马灯唯一识别id，判断是否重复用；speed: 滚屏速度；atom: 跳转关键字 idx: 跑马灯类型
function MessageView:addNotice(text, is_force, notice_id, speed, atom, idx)
    if text == nil or string.len(text) == 0 then
        return
    end
    
    for i,v in ipairs(self.vec_notice) do
        if v.notice_id == notice_id then
            return
        end
    end
    
    local data = {}
    data.text = text
    data.is_force = is_force
    data.notice_id = notice_id
    data.speed = speed
    data.atom = atom
    data.idx = idx
    table.insert(self.vec_notice, data)
    
    -- 将强制播放的放在队列前方
    table.sort(self.vec_notice, function(a, b)
        return a.is_force > b.is_force
    end)
    
    self:showNextNotice(is_force)
end

-- 播放新的提示
function MessageView:showNextMessage()
    if self.is_molding == true or table.nums(self.vec_text_elem) <= 0 then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/common-ui-2.plist")
    
    self.is_molding = true
    
    local iter_text_elem = self.vec_text_elem[1]
    
    local running_scene = cc.Director:getInstance():getRunningScene()
    
    -- 创建UILabelTTF对象，并初始化
    local scale_label = 0.5
    local faceFont = FONT_DEFAULT_NAME_BOLD
    local languageConfig = cfg.languagetype.languagetype[ex.Player.server_lang]
    if languageConfig and languageConfig.font then
        faceFont = languageConfig.font
    end
    local label = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(42)
	:setFontFace(faceFont)
    :setFontColor("#FFFAB9")
	:setScale(scale_label)
	:setAnchorTextShadow(true)
	:setWrapMode(1)
	-- label:setContentSize(cc.size(350 / scale_label, 55 * 2 / scale_label))
    label:setVisible(false)
    running_scene:addChild(label, 1100001)

    label:setXmlTextLua(iter_text_elem.text)
    label:formatText()

    if label:getContentSize().width > 590 then
        label:setAnchorPoint(cc.p(0, 0.5))
        label:ignoreContentAdaptWithSize(false)
        -- label:setContentSize(cc.size(350 / scale_label, 55 * 2 / scale_label))
        label:formatText()
        label:setPosition(cc.p(ex.p.width * 0.5 - label:getContentSize().width * 0.5 * scale_label, ex.p.height * 0.5))
    else
        label:setPosition(cc.p(ex.p.width / 2, ex.p.height * 0.5))
    end
    
    -- err码，如果为1则为正常提示，
    if iter_text_elem.err == 1 then
        label:setColor(FONT_LIGHT_YELLOW)
    end
    
    -- 创建提示背景
    local bg = ccui.Scale9Sprite:createWithSpriteFrameName("win-bg/block-bg-messageview.png")
    :setCapInsets(cc.rect(35, 10, 1, 1))
    :setIgnoreAnchorPointForPosition(false)
    -- bg:setInsetLeft(35)
    -- bg:setInsetTop(10)
    -- bg:setInsetRight(35)
    -- bg:setInsetBottom(10)
    bg:setAnchorPoint(cc.p(0.5, 0.5))
    bg:setVisible(false)
    bg:setPosition(ex.p.width / 2, label:getPositionY() + 5 / 2)
    bg:setContentSize(cc.size(math.max(300, label:getContentSize().width * scale_label + 15) / bg:getScale(),
                            (label:getContentSize().height * scale_label + 10) / bg:getScale()))
    running_scene:addChild(bg, 1100000)
    
    table.remove(self.vec_text_elem, 1)
    
    -- 所有标签上移
    local height = bg:getPositionY() + bg:getContentSize().height * bg:getScale() * 0.5
    local nums = table.nums(self.vec_label)
    for i=1,nums do
        local tmp_elem = self.vec_label[nums - i + 1]
        
        if tolua.isnull(tmp_elem.spr_bg) == false and tolua.isnull(tmp_elem.lbl_message) == false then
            local act_move_bg = cc.EaseExponentialOut:create(cc.MoveTo:create(0.1, 
                cc.p(tmp_elem.spr_bg:getPositionX(), height + tmp_elem.spr_bg:getContentSize().height * tmp_elem.spr_bg:getScale() * 0.5)));
            local act_move_msg = cc.EaseExponentialOut:create(cc.MoveTo:create(0.1, 
                cc.p(tmp_elem.lbl_message:getPositionX(), height + tmp_elem.spr_bg:getContentSize().height * tmp_elem.spr_bg:getScale() * 0.5)));
            
            act_move_bg:setTag(1000)
            act_move_msg:setTag(1000)
            tmp_elem.spr_bg:stopActionByTag(1000)
            tmp_elem.lbl_message:stopActionByTag(1000)

            tmp_elem.spr_bg:runAction(act_move_bg)
            tmp_elem.lbl_message:runAction(act_move_msg)
            
            height = height + tmp_elem.spr_bg:getContentSize().height * bg:getScale()
        end
    end
    
    local lbl_elem = {}
    lbl_elem.lbl_message = label
    lbl_elem.spr_bg = bg
    table.insert(self.vec_label, lbl_elem)

    local act_show_end = cc.Sequence:create(cc.EaseExponentialOut:create(
        cc.FadeTo:create(0.1, 255)), cc.CallFunc:create(handler(self, self.showMessageActionEnd)), nil);
    
    local act_show = cc.EaseExponentialOut:create(cc.FadeTo:create(0.1, 255))
    
    lbl_elem.spr_bg:setVisible(true)
    lbl_elem.lbl_message:setVisible(true)
    
    lbl_elem.spr_bg:setOpacity(0)
    lbl_elem.lbl_message:setOpacity(0)
    
    lbl_elem.spr_bg:runAction(act_show)
    lbl_elem.lbl_message:runAction(act_show_end)

    -- 超出范围则直接删除旧的数据
    repeat
        if table.nums(self.vec_label) <= self.message_max then
            break
        end

        local tmp_node = self.vec_label[1]
        tmp_node.spr_bg:removeFromParent()
        tmp_node.lbl_message:removeFromParent()

        table.remove(self.vec_label, 1)
    until false
end

-- 提示播放完成后的回调，播放消失动画，消失动画完成后移除节点，并播放新的提示
-- 因为最新的节点永远在队列末尾，所以只需要获取队列末尾节点来播放消失动画就好
function MessageView:showMessageActionEnd()
    if table.nums(self.vec_label) <= 0 then
        self.is_molding = false
        return
    end

    local lbl_elem = self.vec_label[table.nums(self.vec_label)]
    if lbl_elem ~= nil then
        lbl_elem.spr_bg:stopAllActions()
        lbl_elem.lbl_message:stopAllActions()

        lbl_elem.spr_bg:runAction(cc.Sequence:create(cc.MoveBy:create(3, cc.p(0, 30)),
                                                     cc.FadeOut:create(0.5),
                                                     cc.DelayTime:create(0.02),
                                                     cc.RemoveSelf:create(),
                                                     nil))

        
        lbl_elem.spr_bg:runAction(cc.Sequence:create(cc.DelayTime:create(2.5),
                                                     cc.FadeOut:create(0.5),
                                                     nil))
        
        
        lbl_elem.lbl_message:runAction(cc.Sequence:create(cc.MoveBy:create(3, cc.p(0, 30)),
                                                          cc.FadeOut:create(0.5),
                                                          cc.CallFunc:create(handler(self, self.showMessageEnd)),
                                                          cc.DelayTime:create(0.02),
                                                          cc.RemoveSelf:create(),
                                                          nil))
        
        lbl_elem.lbl_message:runAction(cc.Sequence:create(cc.DelayTime:create(2.5),
                                                          cc.FadeOut:create(0.5),
                                                          nil))
    end

    self.is_molding = false
    self:showNextMessage()
end

-- 提示消失动画完成后移除节点
-- 因为永远是第一个节点最先消失，所以只需要移除第一个节点就好
function MessageView:showMessageEnd()
    local tmp_node = self.vec_label[1]
    if tmp_node == nil then
        return
    end

    table.remove(self.vec_label, 1)
end

-- 添加新的公告(跑马灯)
function MessageView:showNextNotice(is_force)
    -- 防止动画卡住
    local running_scene = cc.Director:getInstance():getRunningScene()

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/common-ui-2.plist")
    
    local now = ex.Game:getServerTime()
    if self.is_noticing == true then
        local tmp_bg = running_scene:getChildByTag(11000)
        local tmp_view = running_scene:getChildByTag(11001)

        -- 如果上次显示时间已经过来3分钟，或则之前的公告显示节点已经不存在了，则转为未公告状态，并继续执行，否则直接return
        if now - self.last_show_time > 180 or (tmp_bg == nil and tmp_view == nil) then
            self.is_noticing = false

            if tmp_bg ~= nil then
                tmp_bg:removeFromParent()
                tmp_bg = nil
            end
            if tmp_view ~= nil then
                tmp_view:removeFromParent()
                tmp_view = nil
            end
        elseif self.is_noticing_force <= 0 and is_force > 0 then
            -- 如果正在播放的不是强制跑马灯，将要播放的是强制的，则进入中断并进入下一条播放流程
            if tmp_bg ~= nil then
                tmp_bg:removeFromParent()
                tmp_bg = nil
            end
            if tmp_view ~= nil then
                tmp_view:removeFromParent()
                tmp_view = nil
            end
        else
            return
        end
    elseif table.nums(self.vec_notice) <= 0 then
        -- 如果已经没有新的公告了，则移除已存在的节点，并return
        local tmp_bg = running_scene:getChildByTag(11000)
        if tmp_bg ~= nil then
            tmp_bg:removeFromParent()
            tmp_bg = nil
        end
            
        local tmp_view = running_scene:getChildByTag(11001)
        if tmp_view ~= nil then
            tmp_view:removeFromParent()
            tmp_view = nil
        end
            
        return
    end
    
    self.is_noticing = true
    self.is_noticing_force = self.vec_notice[1].is_force
    self.notice_atom = self.vec_notice[1].atom
    
    self.last_show_time = now
    
    -- 获取公告内容队列第一条
    local iter_text_elem = self.vec_notice[1].text
    
    local notch_height = require("src.model.Game"):instance():getNotchHeight()

    -- 创建公告滚动范围
    local tmp_bg = running_scene:getChildByTag(11000)
    local tmp_view = running_scene:getChildByTag(11001)

    if tmp_view == nil or self.vec_notice[1].idx == 211 or self.vec_notice[1].idx == 212 then
        if tmp_view ~= nil then 
            tmp_view:removeFromParent()  
            tmp_view = nil
        end
        local scrollview_size = cc.size(500, 30)
        local pos_y = ex.p.height * 0.9 - notch_height
        if self.vec_notice[1].idx == 211 or self.vec_notice[1].idx == 212 then
            scrollview_size = cc.size(350, 30)
            pos_y = ex.p.height * 0.86 - notch_height
        end
        tmp_view = cc.ScrollView:create(scrollview_size)
        :setTouchEnabled(false)
        :setBounceable(false)
        :setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)

        tmp_view:setPosition(ex.p.width / 2 - tmp_view:getViewSize().width / 2, pos_y)
        running_scene:addChild(tmp_view, 11001)

        tmp_view:setTag(11001)
    end

	local menu = cpp.UIMenu:create()
	tmp_view:addChild(menu)
    menu:setPosition(0,0)

    local item_label = cpp.UIMenuItemImage:create()
    item_label:setEnableAction(false)
    item_label:setAnchorPoint(0, 0)
    item_label:setPosition(tmp_view:getViewSize().width, 5)
    menu:addChild(item_label)

    item_label.atom = self.vec_notice[1].atom
    item_label:registerScriptTapHandler(handler(self, self.onItemNotice))
    
    -- 创建UILabelTTF对象，并初始化
    local lbl_size = 35
    if self.vec_notice[1].idx == 211 or self.vec_notice[1].idx == 212 then
        lbl_size = 40
    end
    local faceFont = FONT_DEFAULT_NAME_BOLD
    local languageConfig = cfg.languagetype.languagetype[ex.Player.server_lang]
    if languageConfig and languageConfig.font then
        faceFont = languageConfig.font
    end
    local label = require("src.comp.RichTextEx"):create()
    :setScale(0.5)
    :setAnchorPoint(0, 0)
    :setPosition(0, 0)
    :setFontSize(lbl_size)
	:setFontFace(faceFont)
    :setFontColor("#FFFAB9")
    :setXmlTextLua(iter_text_elem)
    :formatText()
    :setVisible(false)

    label:setCallback(handler(self, self.openRichTextUrl))

    item_label:addChild(label)
    item_label:setContentSize(cc.size(label:getContentSize().width * label:getScaleX(), label:getContentSize().height * label:getScaleY() + 10))

    -- 根据label大小，调整scroll_view高度
    local tmp_view_pos_y = label:getContentSize().height * label:getScaleY() + 10
    if self.vec_notice[1].idx == 211 or self.vec_notice[1].idx == 212 then
        tmp_view_pos_y = label:getContentSize().height * label:getScaleY() + 30
    end
    tmp_view:setViewSize(cc.size(tmp_view:getViewSize().width,tmp_view_pos_y))
    
    -- 创建公告背景显示
    if self.vec_notice[1].idx == 211 or self.vec_notice[1].idx == 212 then  -- 更改背景图
        if tmp_bg ~= nil then
            tmp_bg:removeFromParent()
        end
        tmp_bg = cc.Sprite:createWithSpriteFrameName("win-bg/block-bg-notice-2.png")
        :setAnchorPoint(cc.p(0.5, 0.5))
        :setVisible(false)
        :setPosition(ex.p.width * 0.5, tmp_view:getPositionY() + tmp_view:getViewSize().height / 2)
        running_scene:addChild(tmp_bg, 11000)
    else
        if tmp_bg == nil then
            tmp_bg = ccui.Scale9Sprite:createWithSpriteFrameName("win-bg/block-bg-notice.png")
            :setCapInsets(cc.rect(290, 10, 1, 1))
            :setIgnoreAnchorPointForPosition(false)
            :setAnchorPoint(cc.p(0.5, 0.5))
            :setVisible(false)
            :setPosition(ex.p.width * 0.5, tmp_view:getPositionY() + tmp_view:getViewSize().height / 2)
            :setContentSize(cc.size(tmp_view:getViewSize().width + 50, tmp_view:getViewSize().height))
            running_scene:addChild(tmp_bg, 11000)
    
            tmp_bg:setTag(11000)
        else
            tmp_bg:setVisible(true)
            tmp_bg:stopAllActions()
            tmp_bg:setOpacity(255)
        end
    end


    -- 执行公告动画
    print("item_label width: "..item_label:getContentSize().width..", view width: "..tmp_view:getViewSize().width..", speed: "..self.vec_notice[1].speed)
    local duration = (item_label:getContentSize().width + tmp_view:getViewSize().width) / self.vec_notice[1].speed
    local act_show_end = cc.Sequence:create(cc.MoveTo:create(duration, cc.p(-item_label:getContentSize().width, item_label:getPositionY())),
                        cc.RemoveSelf:create(),
                        cc.CallFunc:create(handler(self, self.showNoticeActionEnd)),
                        nil);
    
    local act_show = cc.Sequence:create(cc.FadeTo:create(0.1, 255),
                                        cc.DelayTime:create(duration + 0.1),
                                        cc.RemoveSelf:create(),
                                        nil)
    
    tmp_bg:setVisible(true)
    label:setVisible(true)
    
    tmp_bg:setOpacity(0)
    
    -- 移除公告内容队列中的第一条
    table.remove(self.vec_notice, 1)
    
    tmp_bg:runAction(act_show)

    item_label:runAction(act_show_end)
end

function MessageView:showNoticeActionEnd()
    self.is_noticing = false
    
    self:showNextNotice()
end

function MessageView:clear()
    self.is_molding = false

    self.vec_label = {}
    
    self.vec_notice = {}
end

function MessageView:onItemNotice(tag, pSender)
    if pSender == nil or pSender.atom == nil or string.len(pSender.atom) <= 0 then
        return
    end

    self:openRichTextUrl(pSender.atom)
end

function MessageView:openRichTextUrl(url)
    if string.len(url) <= 0 then
        return
    end

    ex.JumpManager:jumpByAtom(url)
end

return MessageView
