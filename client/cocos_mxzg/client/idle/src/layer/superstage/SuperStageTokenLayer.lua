local SuperStageTokenLayer = class("SuperStageTokenLayer", require("src.comp.EventLayerAdaptiveWidthFull"))
local SuperStageTokenCell = class("SuperStageTokenCell", require("src.comp.LuaLayerBase"))

local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")
local UIMenuItemHeroPiece = require("src.comp.menu.UIMenuItemHeroPiece")

function SuperStageTokenCell:onCreate()
	self:setAutoClose(false)
    self:setSwallowTouches(false)
    
    -- 设置左右切换按钮的灰色状态
    local spr_reward = cc.Sprite:createWithSpriteFrameName("button/btn-orange-big-1.png")
    ex.Tools:setGrayAuto(spr_reward, true)
    self.btn_reward:setDisabledImage(spr_reward)

	self.progress_timer = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("super-stage/progress-2-2.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setMidpoint(cc.p(0, 1))
    :setBarChangeRate(cc.p(0, 1)) --(1, 0)x变化 (0, 1)y变化
    :setAnchorPoint(cc.p(0.5, 0.5))
    self.progress_bg:addChild(self.progress_timer)
    self.progress_timer:setPosition(self.progress_bg:getContentSize().width / 2 ,self.progress_bg:getContentSize().height / 2)
end

function SuperStageTokenCell:setScrollView(scroll_view)
    self.menu:setSwallowsTouches(false)
    self.menu:setIsTouchInsideNode(scroll_view)
    self.menu_reward:setSwallowsTouches(false)
    self.menu_reward:setIsTouchInsideNode(scroll_view)
    self.menu_reward_token:setSwallowsTouches(false)
    self.menu_reward_token:setIsTouchInsideNode(scroll_view)
end

function SuperStageTokenCell:initData(data)
    self:setLocalZOrder(data.idx)

    self.data = data
    self.btn_reward.data = data

    if data.idx == 1 then
        self.progress_bg:setVisible(data.idx ~= 1)
    end

    local item_scale = 0.75

    -- 顯示獎勵
    self.menu_reward:removeAllChildren()
    for i,v in ipairs(data.reward) do
        local item = nil
        if ex.Player.backpack_data:isPiece(v.item_type) then
            item = UIMenuItemHeroPiece:createWithData(v.item_type)
        else
            item = UIMenuItemBackpack:createWithData(v.item_type, v.item_num)
        end
        item:registerScriptTapHandler(handler(self, self.onItemInfo))
        item:setScale(item_scale)
        item:setPosition((i - 0.5) * 120 * item_scale, 0)
        self.menu_reward:addChild(item)
    end

    self.menu_reward_token:removeAllChildren()
    for i,v in ipairs(data.token_reward) do
        local item = nil
        if ex.Player.backpack_data:isPiece(v.item_type) then
            item = UIMenuItemHeroPiece:createWithData(v.item_type)
        else
            item = UIMenuItemBackpack:createWithData(v.item_type, v.item_num)
        end
        item:registerScriptTapHandler(handler(self, self.onItemInfo))
        item:setScale(item_scale)
        item:setPosition((i - 0.5) * 120 * item_scale, 0)
        self.menu_reward_token:addChild(item)

        -- 如果戰令為解鎖，則顯示鎖狀態
        if data.is_lock == nil or data.is_lock == true then
            item:setGrayed()

            local spr_lock = cc.Sprite:createWithSpriteFrameName("other/spr-lock.png")
            spr_lock:setPosition(item:getContentSize().width / 2, item:getContentSize().height / 2)
            item:addChild(spr_lock, 1000)
        end
    end

    self.lbl_win_count:setString(data.win_count)
    self.spr_rank_bg_2:setVisible(data.win_num >= data.win_count)

    local percentage = 0
    if data.win_num >= data.win_count then
        percentage = 100
    elseif data.win_num > data.last_win_count then
        percentage = (data.win_num - data.last_win_count) * 100 / (data.win_count - data.last_win_count)
    end
    self.progress_timer:setPercentage(percentage)

    -- 顯示領獎按鈕狀態
    if data.win_num >= data.win_count and 
       (not data.is_reward or not data.is_token_reward) then
        self.btn_reward:setEnabled(true)
        if not data.is_reward or not data.is_lock then
            ex.Tools:addRedPoint(self.btn_reward, true)
        end
    else
        self.btn_reward:setEnabled(false)
    end
    if data.is_reward and (data.is_lock or data.is_token_reward) then
        if data.is_token_reward then
            self.btn_reward:setLabelText(ex.Tools:getLang(2703))
        elseif data.is_lock and not data.is_token_reward then
            self.btn_reward:setLabelText(ex.Tools:getLang(74849))
        end
    end
end

function SuperStageTokenCell:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function SuperStageTokenLayer:getAsynImage()
    local vec_image = {
        {image_name = "ccbi-res/map-bg-super-stage.jpg", remove_type = 1},
    }
    return vec_image
end

-----------------------------------------------------------------------------

function SuperStageTokenLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(true)

    self.scroll_view:setItemSize(cc.size(600,141))
    self.scroll_view:setItemType(1)
    
    self:initDone()
end

function SuperStageTokenLayer:initDone()
    self:addEvent(EVENT.SUPER_STAGE.TOKEN_INFO, handler(self, self.updateLayer))
    
    -- 請求刷新數據
    ex.Player.super_stage_data:reqInfo()

    self:updateLayer()

    -- 獲取可領獎或者可繼續領獎的項
    local list_num = #cfg.superstagetokenreward.superstagetokenreward
    local is_lock = not ex.Player.super_stage_data.token_info.had_buy

    local cur_idx = list_num + 1
    if is_lock then
        cur_idx = 1
    else
        for i,v in ipairs(cfg.superstagetokenreward.superstagetokenreward) do
            if cur_idx > v.idx and v.win_count <= ex.Player.super_stage_data.token_info.win_count then
                local is_reward = false
                local vec_reward_idx = ex.Player.super_stage_data.token_info.reward_id or {}
                for _,v2 in pairs(vec_reward_idx) do
                    if v2 == v.idx then
                        is_reward = true
                        break
                    end
                end

                if not is_reward then
                    cur_idx = v.idx
                else
                    local is_token_reward = false
                    local vec_reward_idx = ex.Player.super_stage_data.token_info.token_reward_id or {}
                    for _,v2 in pairs(vec_reward_idx) do
                        if v2 == v.idx then
                            is_token_reward = true
                            break
                        end
                    end

                    if not is_token_reward then
                        cur_idx = v.idx
                    end
                end
            end
        end
    end

    if cur_idx > list_num then
        cur_idx = 1
    end

    -- 初始化設置scrollview位置
    -- 先設置為最高位置
    local offset_y = self.scroll_view:getViewSize().height - self.scroll_view:getContentSize().height * (list_num - cur_idx + 1) / list_num
    self.scroll_view:setContentOffset(cc.p(0, offset_y))
end

function SuperStageTokenLayer:updateLayer()
    -- 如果為購買戰令則顯示購買按鈕，否則按鈕上顯示已激活，按鈕不可點擊
    if ex.Player.super_stage_data.token_info.had_buy then
        self.btn_buy:setLabelText(ex.Tools:getLang(74930))
        self.btn_buy:setEnabled(false)
    else
        self.btn_buy:setLabelText(ex.Tools:getLang(74829))
    end

    -- 顯示當前勝場數及重置時間
    self.lbl_win_times:setString(ex.Player.super_stage_data.token_info.win_count)
    self.lbl_cd:setString(ex.StringUtil.convertToTimeFormat(ex.Player.super_stage_data.season_end_time - ex.Game:getServerTime(), 4))

    -- 刷新獎勵顯示
    self:updateScrollView()
end

function SuperStageTokenLayer:updateScrollView()
    local list_num = #cfg.superstagetokenreward.superstagetokenreward

    local item_list = {}
    local is_lock = not ex.Player.super_stage_data.token_info.had_buy
    for i,v in ipairs(cfg.superstagetokenreward.superstagetokenreward) do
        local data = clone(v)
        data.is_lock = is_lock
        data.win_num = ex.Player.super_stage_data.token_info.win_count
        data.last_win_count = cfg.superstagetokenreward.superstagetokenreward[i - 1]
        data.last_win_count = data.last_win_count and data.last_win_count.win_count or 0

        data.is_reward = false
        data.is_token_reward = false

        local vec_reward_idx = ex.Player.super_stage_data.token_info.reward_id or {}
        for _,v2 in pairs(vec_reward_idx) do
            if v2 == data.idx then
                data.is_reward = true
                break
            end
        end
        
        local vec_reward_idx = ex.Player.super_stage_data.token_info.token_reward_id or {}
        for _,v2 in pairs(vec_reward_idx) do
            if v2 == data.idx then
                data.is_token_reward = true
                break
            end
        end

        table.insert(item_list, data)
    end

    local offset = self.scroll_view:getContentOffset()
    self.scroll_view.createItemFunction = function(data)
        -- 创建ccbi cell
        local cell = SuperStageTokenCell:createWithCCBIFile("ccbi/SuperStageTokenCell.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(0.5, 0.5)
    
        cell:setScrollView(self.scroll_view)
        cell:initData(data, list_num)
        cell.btn_reward:registerScriptTapHandler(handler(self, self.onReward))
    
        return cell
    end

    self.scroll_view:reloadData(item_list)
    self.scroll_view:setContentOffset(offset)
end

-- 功能说明
function SuperStageTokenLayer:onBack(tag, pSender)
    ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_SUPER_STAGE_MAIN)
end

-- 功能说明
function SuperStageTokenLayer:onInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42094), ex.Tools:getLang(42095))
end

-- 購買王之戰令
function SuperStageTokenLayer:onBuy(tag, pSender)
    require("src.layer.superstage.SuperStageTokenBuyCtr"):instance():openWindow()
end

-- 領取進度完成獎勵
function SuperStageTokenLayer:onReward(tag, pSender)
    local data = pSender.data

    -- 判斷是否可以領取獎勵
    if data.win_num < data.win_count then
        return
    end
    if data.is_reward and data.is_token_reward then
        return
    end

    if data.is_reward and data.is_lock then
        self:onBuy()
    else
        local req = StageMatchRim_pb.GReqStageTokenGetReward()
        req.idx = data.idx
        NetManager:sendMessage(ProtocolID.GReqStageTokenGetReward, req)
    end
end

function SuperStageTokenLayer:onExit()

end

return SuperStageTokenLayer
