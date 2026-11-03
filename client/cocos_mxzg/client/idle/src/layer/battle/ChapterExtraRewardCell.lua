local ChapterExtraRewardCell = class("ChapterExtraRewardCell", require("src.comp.EventLayer"))

-- local oldSetVisible = ChapterExtraRewardCell.setVisible
-- function ChapterExtraRewardCell:setVisible(b)
--     if b == true then
        
--         oldSetVisible(self, ex.Player.guide_serial >= 1850 and b)
--     else
--         oldSetVisible(self, false)
--     end
-- end

function ChapterExtraRewardCell:onCreate()
    -- 当前的奖励形象
    self.chapter_id = nil


    self.progress = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("chapter-reward/spr-prog-2.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    :setAnchorPoint(cc.p(0, 0.5))
    :setContentSize(self.spr_prog_bg:getContentSize())
    self.spr_prog_bg:getParent():addChild(self.progress, -1)

    self.progress:setPosition(cc.p(self.spr_prog_bg:getPositionX() - self.spr_prog_bg:getContentSize().width * 0.5 + 3,
                                   self.spr_prog_bg:getPositionY() + 3))
    self.progress:setPercentage(0)

    self.lbl_tip = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(28)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#ffe1b2")
	:setScale(0.5)
	-- :ignoreContentAdaptWithSize(false)
	-- :setWrapMode(1)
	-- :setContentSize(cc.size((self.spr_content_bg:getContentSize().width - 30) / 0.5, self.spr_content_bg:getContentSize().height / 0.5))
	:setPosition(cc.p(self.node_prog:getPositionX(), self.spr_text_bg:getPositionY()))
    :setAnchorPoint(cc.p(0.5, 0.5))
    self.lbl_tip:enableOutline(cc.c4b(65,29,10,255), 2)
    self:addChild(self.lbl_tip, 1)

    self.node_prog:setLocalZOrder(1)
    self.spr_top_tip:setLocalZOrder(1)


    self.lbl_content = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(36)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#7A472D")
	:ignoreContentAdaptWithSize(false)
    :setWrapMode(1)
    :setScale(0.5)
	:setContentSize(cc.size((self.spr_content_bg:getContentSize().width - 30) / 0.5, 0))
	:setPosition(cc.p(self.spr_content_bg:getPositionX() + 30, self.spr_content_bg:getPositionY() + 35))
    :setAnchorPoint(cc.p(0, 0))
    -- self.lbl_content:enableOutline(cc.c4b(65,29,10,255), 2)
    self.spr_content_bg:getParent():addChild(self.lbl_content)
    
    self.spr_prog_bg:setLocalZOrder(-2)
    self:addEvent(EVENT.BATTLE_EVENT.EXTRA_REWARD, handler(self, self.reset))
    self:addEvent(EVENT.BATTLE_EVENT.BATTLE_END, handler(self, self.battleEnd))
    self:addEvent(EVENT.FETTER_EVENT.REMOVE_ICON, handler(self, self.fetterIconRemove))
    self:addEvent(EVENT.ONLINE_REWARD.CLOSE_OTHER, handler(self, self.onlineRewardRemove))
    -- ex.EventManager:add(EVENT.ONLINE_REWARD.CLOSE,handler(self,self.onClose))

    -- self.spr_content_bg:getParent():setCascadeOpacityEnabled(true)

    self.listener_touch = cc.EventListenerTouchOneByOne:create()  --创建一个单点事件监听
    self.listener_touch:setSwallowTouches(false)
    self.listener_touch:registerScriptHandler(function() return true end, cc.Handler.EVENT_TOUCH_BEGAN)
    self.listener_touch:registerScriptHandler(function() end, cc.Handler.EVENT_TOUCH_MOVED)
    self.listener_touch:registerScriptHandler(function(touch, event)
        self:hideBubble()
    end, cc.Handler.EVENT_TOUCH_ENDED)
    local event_dispatcher = self:getEventDispatcher() 
    event_dispatcher:addEventListenerWithSceneGraphPriority(self.listener_touch, self)

    self:addRedDotNode(RedDotType.ZCJ_DHZD_STJL, self.btn_reward)
end

function ChapterExtraRewardCell:battleEnd()
    self:showBubble()
    self:reset()  
end



function ChapterExtraRewardCell:reset()
    local now_idx = ex.Player.chapter_data:getNowExtraReward()
    local chapter_id = ex.Player.chapter_data.chapter_id
    if now_idx == nil then
        self:getParent():removeFromParent()
        ex.EventManager:fire(EVENT.BATTLE_EVENT.EXTRA_REMOVE)
        return false
    end
    
    local extra_config = cfg.chapterextrareward.chapterextrareward[now_idx]
    -- local chapter_config = cfg.clanbossrankreward.clanbossrankreward[chapter_id]
    ex.Tools:setSpriteFrame(self.spr_top_tip, string.format("chapter-reward-lang/%s.png", extra_config.tip_img))
    
    -- 更新物品形象
    if self.chapter_id == nil or self.chapter_id ~= now_idx then
        -- self.spr_reward_bg:removeAllChildren()
        self.menu:removeChildByTag(999)
        local item_mode = cfg.item.item[extra_config.show_model].mode
        if item_mode == ItemData.IT_HERO then
            local hero = require("src.person.Hero"):create("1", "1",extra_config.show_model, 1, 1, 0)
            hero:setScale(0.67 * 0.8 * 1.42)
            hero:setShadowVisible(false)
            hero:setPosition(self.spr_reward_bg:getPositionX() - 75, self.spr_reward_bg:getPositionY() - 10)
            hero:setTag(999)
            hero:registerScriptTapHandler(handler(self, self.onItem))
            self.menu:addChild(hero)
        else
            local item =  cpp.UIMenuItemImage:createWithSpriteFrameName(string.format("%s.png", cfg.item.item[extra_config.show_model].icon), nil, nil) --ex.Tools:createBackpackItem(extra_config.show_model, 0)
            item.item_type = extra_config.show_model
            item:setPosition(0, self.spr_reward_bg:getPositionY() - 20)
            item:setScale(0.8 * 0.8)
            item:setTag(999)
            item:registerScriptTapHandler(handler(self, self.onItem))
            self.menu:addChild(item)
        end
        self.lbl_tip:setXmlTextLua(string.format(ex.Tools:getLang(extra_config.tips_lang), extra_config.chapter))
    end
    self.chapter_id = now_idx

    -- 可以领取
    if chapter_id >= extra_config.chapter then
        self.node_prog:setVisible(false)
        self.btn_reward:setVisible(true)
    else
        -- 进度条
        self.node_prog:setVisible(true)
        self.btn_reward:setVisible(false)
        self.lbl_mission:setString(string.format("%s/%s", chapter_id, extra_config.chapter) )
        self.progress:setPercentage(chapter_id * 100 / extra_config.chapter)
    end
    self.lbl_tip:setVisible(self.node_prog:isVisible())
    self.spr_text_bg:setVisible(self.node_prog:isVisible())
    return true
end

function ChapterExtraRewardCell:canReward(is_show_tip)
    local now_idx = ex.Player.chapter_data:getNowExtraReward()
    local chapter_id = ex.Player.chapter_data.chapter_id
    if now_idx == nil then
        return false
    end

    local extra_config = cfg.chapterextrareward.chapterextrareward[now_idx]
    if chapter_id < extra_config.chapter then
        if is_show_tip then
            ex.MessageView:add(string.format(ex.Tools:getLang(52851), extra_config.chapter - chapter_id, cfg.item.item[extra_config.show_model].name))
        end
        return false
    end
    return true
end

-- 显示气泡
function ChapterExtraRewardCell:showBubble()
    if self:canReward(false) == false then
        self.spr_content_bg:getParent():setVisible(true)

        local now_idx = ex.Player.chapter_data:getNowExtraReward()
        local chapter_id = ex.Player.chapter_data.chapter_id
        if now_idx then
            local extra_config = cfg.chapterextrareward.chapterextrareward[now_idx]
            local str = string.format(ex.Tools:getLang(52851), extra_config.chapter - chapter_id,ex.Tools:getLang(cfg.item.item[extra_config.show_model].name))
            self.lbl_content:setXmlTextLua(str)
            self.lbl_content:formatText()

            local contentSize = self.lbl_content:getContentSize()
            local scale = self.lbl_content:getScale()
            self.spr_content_bg:setContentSize(cc.size(contentSize.width * scale + 50, 
                                                       contentSize.height * scale + 45))

            ex.Tools:ergodicAllNode(self.spr_content_bg:getParent(), function(node)
                -- local act_hide = cc.Sequence:create(cc.FadeTo:create(0.1, 255),
                --                                     cc.DelayTime:create(5),
                --                                     cc.FadeTo:create(0.1, 0))

                local act_hide = cc.Sequence:create(cc.FadeTo:create(0.1, 255))
                act_hide:setTag(999)
                node:stopActionByTag(999)
                node:runAction(act_hide)
            end)
        end
    else
        self.spr_content_bg:getParent():setVisible(false)
    end
end

function ChapterExtraRewardCell:hideBubble()
    ex.Tools:ergodicAllNode(self.spr_content_bg:getParent(), function(node)
        local act_hide = cc.Sequence:create(cc.FadeTo:create(0.1, 0))
        act_hide:setTag(999)
        node:stopActionByTag(999)
        node:runAction(act_hide)
    end)
end 


function ChapterExtraRewardCell:onReward()
    if self:canReward(true) ~= true then
        return
    end
    local now_idx = ex.Player.chapter_data:getNowExtraReward()

    local req_reward = Battle_pb.GReqExtraReward()
    req_reward.rewardId = now_idx
    NetManager:sendMessage(ProtocolID.GReqExtraReward, req_reward)
end

function ChapterExtraRewardCell:onItem(tag, pSender)
    local now_idx = ex.Player.chapter_data:getNowExtraReward()    
    local extra_config = cfg.chapterextrareward.chapterextrareward[now_idx]
    local item_mode = cfg.item.item[extra_config.show_model].mode
    if item_mode == ItemData.IT_HERO then
        
        local item = pSender:getParent():getParent()
        local callback =function ()
            ex.MainSceneCtr:changeLayer(MainSceneType.MLT_BATTLE)
        end

        local layer = ex.MainSceneCtr:changeLayer(MainSceneType.HERO_ILLUSTRAT_INFO_LAYER)
        layer:showData(extra_config.show_model, 5, callback)
    else
        ex.Tools:showItemInfo(tag, pSender)
    end
end

function ChapterExtraRewardCell:fetterIconRemove()
    -- local parent = self:getParent()
    -- parent:setPositionY(parent:getPositionY() + 170)
end

function ChapterExtraRewardCell:onlineRewardRemove()
    local parent = self:getParent()
    parent:setPositionY(parent:getPositionY() + 140)
end


return ChapterExtraRewardCell