local SlzmLayer = class("SlzmLayer", require("src.comp.EventLayer"))
local SlzmContentLayer = class("SlzmContentLayer", require("src.comp.EventLayer"))

function SlzmContentLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.last_click_reward_time = 0 -- 是否是无效的点击
    self.menu_item_array = {}
    
    self:setFuncUnlockInfo(self.btn_daily, "main_mission")
    self:setFuncUnlockInfo(self.btn_dream, "main_infinite")
    self:setFuncUnlockInfo(self.btn_test, "main_proving_lang")
    self:setFuncUnlockInfo(self.btn_chsd, "main_chsd")

    self.btn_daily:registerScriptTapHandler(handler(self, self.onClickDaily))
    self.btn_dream:registerScriptTapHandler(handler(self, self.onClickDream))
    self.btn_test:registerScriptTapHandler(handler(self, self.onClickTrial))
    self.btn_chsd:registerScriptTapHandler(handler(self, self.onClinkChsd))

    -- self:addRedDotNode(RedDotType.ZCJ_DHZC_YZSL, self.btn_test)

    -- 刷新勇者试炼数据，特别是当前难度
    NetManager:sendMessage(ProtocolID.GReqTrialCfg)
    self:initDone()
end

function SlzmContentLayer:initDone()
    local config = cfg.gamerewardshow.getConfigByTypeId(1,1)
    local lbl_normal = cc.Label:createWithTTF(ex.Tools:getLang(72231), FONT_DEFAULT_NAME_BOLD, 20)
    lbl_normal:setColor(cc.c3b(253,228,181))
    lbl_normal:setPosition(240, 52)
    lbl_normal:setAnchorPoint(ex.a.left_center)
    self.btn_daily:addChild(lbl_normal)
    self.btn_daily:setName(config.atom)
    
    -- local flag2 = ex.Player.trial_data:returnCheckRedDot()--TODO 要修改数据源
    -- ex.Tools:addRedPoint(self.btn_daily, self.btn_daily:isEnabled() and flag2, cc.p(0.96, 0.9))

    self:createItem(self.btn_daily, config, self.btn_daily:isEnabled())

    config = cfg.gamerewardshow.getConfigByTypeId(1,2)
    local lbl_normal_1 = cc.Label:createWithTTF(ex.Tools:getLang(72119), FONT_DEFAULT_NAME_BOLD, 20)
    lbl_normal_1:setColor(cc.c3b(253,228,181))
    lbl_normal_1:setPosition(240, 52)
    lbl_normal_1:setAnchorPoint(ex.a.left_center)
    self.btn_dream:addChild(lbl_normal_1)
    self.btn_dream:setName(config.atom)


    -- add 熊梦 永恒梦境添加等级判断 等级达到了才判断红点显示 
    -- 判断永恒梦境是否达到等级开启 
    local is_unlock = ex.JumpManager:checkOpenConditionByAtomNoMsg("main_infinite")
    if is_unlock then
        local flag = ex.Player.dream_data:checkRedDot()
        ex.Tools:addRedPoint(self.btn_dream, self.btn_dream:isEnabled() and flag, cc.p(0.96, 0.9))
    end

    -- 添加一排物品
    self:createItem(self.btn_dream, config, self.btn_dream:isEnabled())

    config = cfg.gamerewardshow.getConfigByTypeId(1,3)
    local lbl_normal_2 = cc.Label:createWithTTF(ex.Tools:getLang(72120), FONT_DEFAULT_NAME_BOLD, 20)
    lbl_normal_2:setColor(cc.c3b(253,228,181))
    lbl_normal_2:setPosition(240, 52)
    lbl_normal_2:setAnchorPoint(ex.a.left_center)
    self.btn_test:addChild(lbl_normal_2)
    self.btn_test:setName(config.atom)

    -- local flag2 = ex.Player.trial_data:returnCheckRedDot()
    -- ex.Tools:addRedPoint(self.btn_test, flag2, cc.p(0.96, 0.9))

    self:createItem(self.btn_test, config, self.btn_test:isEnabled())

    -- 彩虹圣殿
    config = cfg.gamerewardshow.getConfigByTypeId(1,4)
    local lbl_normal_2 = cc.Label:createWithTTF(ex.Tools:getLang(54307), FONT_DEFAULT_NAME_BOLD, 20)
    lbl_normal_2:setColor(cc.c3b(253,228,181))
    lbl_normal_2:setPosition(240, 52)
    lbl_normal_2:setAnchorPoint(ex.a.left_center)
    self.btn_chsd:addChild(lbl_normal_2)
    self.btn_chsd:setName(config.atom)

    -- 彩虹圣殿用错了红点。家立说彩虹圣殿没有红点
    -- local flag2 = ex.Player.trial_data:returnCheckRedDot()  --TODO 要修改数据源
    -- ex.Tools:addRedPoint(self.btn_chsd, self.btn_chsd:isEnabled() and flag2, cc.p(0.96, 0.9))

    self:createItem(self.btn_chsd, config, self.btn_chsd:isEnabled())

    self:addRedDotNode(RedDotType.ZCJ_DHFB_RCFBRK, self.btn_daily)
    -- self:addRedDotNode(RedDotType.ZCJ_DHFB_YHMJRK_YHMJ, self.btn_dream)
    self:addRedDotNode(RedDotType.ZCJ_DHFB_YZSLRK, self.btn_test)
    -- self:addRedDotNode(RedDotType.ZCJ_DHFB_CHSDRK, self.btn_chsd)
end

function SlzmContentLayer:createItem(parent_layer, award_list, isEnabled)
    local menu = cpp.UIMenu:create()
    menu:setPosition(cc.p(5, 40))
    parent_layer:addChild(menu)
    table.insert(self.menu_item_array, menu)

    local begin = 234
    local margin = 6
    local posY = 110
    local scale = 0.65
    for i,v in ipairs(award_list.reward_show) do
        local item = ex.Player.backpack_data:createWithData(v.item_type, v.item_num)
        local item_size = item:getContentSize()
        local posX = begin + (i - 1) * (item_size.width * scale + margin)
        
        item:setAnchorPoint(ex.a.left_center)
        item:setPosition(posX, posY - item_size.height * scale / 2)
        item:setScale(scale)
        item:setAllGray(not isEnabled)
        item:registerScriptTapHandler(handler(self, self.onClickItem))
        menu:addChild(item)
    end
end

function SlzmContentLayer:setFuncUnlockInfo(btn, atom)
    local str_text = ex.Tools:getLang(47032)

    local is_unlock = ex.JumpManager:checkOpenConditionByAtomNoMsg(atom)
    btn:setEnabled(is_unlock)

    if not is_unlock then
        local config = cfg.opencondition.condition[atom]

        local btn_size= btn:getContentSize()
        local spr_bg = ccui.Scale9Sprite:createWithSpriteFrameName("win-bg/block-bg-23.png", cc.rect(0, 0, 0, 0))
        spr_bg:setAnchorPoint(cc.p(0.5, 0.5))
        spr_bg:setIgnoreAnchorPointForPosition(false)
        spr_bg:setPosition(btn_size.width / 2, btn_size.height / 2)
        btn:addChild(spr_bg, 10)

        local tip_lbl = cc.Label:createWithTTF(string.format(str_text, config.condition_value), FONT_DEFAULT_NAME_BOLD, 56)
        tip_lbl:setScale(0.5)
        tip_lbl:setAnchorPoint(cc.p(0.5, 0.5))
        local real_size = spr_bg:getPreferredSize()
        tip_lbl:setPosition(real_size.width / 2, real_size.height / 2)
        tip_lbl:enableOutline(FONT_BLACK_C4B, 3)
        spr_bg:addChild(tip_lbl)
    end
end

function SlzmContentLayer:setTouchInside(scroll_view)
    self.menu:setIsTouchInsideNode(scroll_view)
    self.menu:setSwallowsTouches(false)

    for i,v in ipairs(self.menu_item_array) do
        v:setIsTouchInsideNode(scroll_view)
        v:setSwallowsTouches(false)
    end
end

-- 是否是无效的点击，因为有上下两层menu，而又要保证上层menu可以拖动，又不能点击穿透到下一层，故在代码中加限制，如果连续两次点击相隔时间过短(0.5秒)，则视为后一次点击无效
function SlzmContentLayer:isInvalidTouch()
    return ex.Game:getServerMillisecond() < self.last_click_reward_time + 500
end

function SlzmContentLayer:onClickDaily(tag, pSender)
    if self:isInvalidTouch() then return end

    if ex.JumpManager:checkOpenConditionByAtomNoMsg("main_mission") then
        ex.MainSceneCtr:changeLayer(MainSceneType.MISSION)
    end 
end

function SlzmContentLayer:onClickDream(tag , pSender)
    if self:isInvalidTouch() then return end

    if ex.JumpManager:checkOpenConditionByAtomNoMsg("main_infinite") then 
        ex.MainSceneCtr:changeLayer(MainSceneType.DREAM_LAYER)
    end 
end

function SlzmContentLayer:onClickTrial(tag , pSender)
    if self:isInvalidTouch() then return end

    if not ex.JumpManager:checkOpenConditionByAtomNoMsg("main_proving_lang") then 
        return
    end

    if ex.Player.trial_data.today_select ~= true then
        local callback = function(idx)
            local req_hard_select = Adven_pb.GReqAdvenSelectLv()
            req_hard_select.lv = idx
            NetManager:sendMessage(ProtocolID.GReqAdvenSelectLv, req_hard_select)
        end
        
        local vec_hard_cell = {}
        for i,v in ipairs(cfg.adventurelevel.adventurelevel) do
            local data = clone(v)
            data.is_unlock = (ex.Player.trial_data.pass_lv >= data.idx--[[and v.bat <= ex.Player.fighting]])
            table.insert(vec_hard_cell, data)
        end
        require("src.layer.HardSelectCtr"):instance():openWindow(vec_hard_cell, callback)
    else
        ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_TRIAL)
    end
end

function SlzmContentLayer:onClinkTest(tag , pSender)
    if self:isInvalidTouch() then return end

    if ex.JumpManager:checkOpenConditionByAtomNoMsg("main_proving_lang") then
        ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_TRIAL)
    end 
end

function SlzmContentLayer:onClinkChsd(tag, pSender)
    if self:isInvalidTouch() then return end

    local atom = self.btn_chsd:getName()
    if not atom then
        print("config gamerewardshow not atom filed!")
        return
    end

    if ex.JumpManager:checkOpenConditionByAtomNoMsg(atom) then
        ex.JumpManager:jumpByAtom(atom)
    end
end

function SlzmContentLayer:onClickItem(tag,pSender)
    self.last_click_reward_time = ex.Game:getServerMillisecond()
    
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function SlzmContentLayer:relocalMenu()
    local size = self.layer:getContentSize()
    self.menu:setPosition(size.width / 2, 0)
end

---------------------------------------------------------------------------------------------
function SlzmLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    ex.Tools:AdjustFullScreenExtend(self.spr_bg)
    local scale = self.spr_bg:getScale()

    self.top:setPosition(ex.p.width / 2, ex.p.height - 180 * ex.s.global_scale - require("src.model.Game"):instance():getNotchHeight())

    self:initDone()
end

function SlzmLayer:initDone()
    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/slzm.plist")
    
    local title = cc.Label:createWithTTF(ex.Tools:getLang(72122), FONT_DEFAULT_NAME_BOLD, 36)
    title:setColor(cc.WHITE)
    title:setPosition(self.top:getContentSize().width * 0.5, self.top:getContentSize().height * 0.5 - 3)
    title:enableOutline(cc.c3b(40,55,81), 2)
    title:setOpacity(200)
    self.top:addChild(title)
    
    local content_layer = SlzmContentLayer:createWithCCBIFile("ccbi/SlzmContentLayer.ccbi")
    self.scroll_view:setContainer(content_layer)
    
    local rect = cc.rect(0, 0, self.scroll_view_rect:getContentSize().width, self.scroll_view_rect:getContentSize().height)
    local node_pos = self.layer:convertToNodeSpace(self.scroll_view_rect:convertToWorldSpace(cc.p(rect.x, rect.y)))
    node_pos.y = math.max(ex.MainSceneCtr:getBottomHeight() + 30, node_pos.y)

    local pos_x, pos_y = self.scroll_view_rect:getPosition()
    local node_top = self.layer:convertToNodeSpace(self.spr_bg:convertToWorldSpace(cc.p(pos_x, pos_y)))
    node_top.y = math.min(rect.height * self.spr_bg:getScale(), node_top.y - node_pos.y)

    self.scroll_view:setPosition(cc.p(ex.p.width * 0.5, node_pos.y))
    self.scroll_view:setViewSize(cc.size(rect.width * self.spr_bg:getScale(), node_top.y))
    self.scroll_view:setContentSize(cc.size(rect.width * self.spr_bg:getScale(), content_layer:getContentSize().height))
    self.scroll_view:setContentOffset(self.scroll_view:minContainerOffset(), false)
    
    content_layer:setTouchInside(self.scroll_view)
    -- for i,v in ipairs(content_layer.menu_item_array) do
    --     v:setSwallowsTouches(false)
    --     v:setIsTouchInsideNode(self.scroll_view)
    -- end

    content_layer:relocalMenu()
end 

return SlzmLayer