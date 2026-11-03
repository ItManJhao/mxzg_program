-- 梦境秘宝-翻牌
local PROMSecretTreasureGameLayer = class("PROMSecretTreasureGameLayer", require("src.comp.EventLayer"))
local PROMSecretTreasureChooseCell = class("PROMSecretTreasureChooseCell", require("src.comp.EventLayer"))
local PROMSecretTreasureChooseItem = class("PROMSecretTreasureChooseItem", require("src.comp.EventLayer"))
local PROMSecretTreasureGameItem = class("PROMSecretTreasureGameItem", require("src.comp.EventLayer"))
local UIMenuItemBag = require("src.comp.menu.UIMenuItemBag")

------------------------------------ PROMSecretTreasureChooseItem ------------------------------------
function PROMSecretTreasureGameItem:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self.spr_frame:setZOrder(100)
end


function PROMSecretTreasureGameItem:resetData(data)
    -- self.btn_item:setEnabled(false)
    -- self.btn_item:setVisible(false)
    self.data = data

    local item_type = data.item_type
    local item_num = data.item_num or 0

	self.spr_item = UIMenuItemBag:createWithData(item_type, item_num)
    self.spr_item:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
    self:addChild(self.spr_item)
end


------------------------------------ PROMSecretTreasureChooseItem ------------------------------------
function PROMSecretTreasureChooseItem:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self.spr_frame:setZOrder(100)
    self.spr_gray:setZOrder(101)
    self.spr_glow:setZOrder(102)
    self.menu_choose:setZOrder(103)
    self.spr_gou:setZOrder(104)

    self.btn_item:registerScriptTapHandler(handler(self, self.onItemInfo))
end

function PROMSecretTreasureChooseItem:resetData(data)
    self.data = data

    local reward = data.reward
    if not reward or #reward == 0 then
        return
    end

    local item_type = reward[1].item_type
    local item_num = reward[1].item_num or 0
    self.btn_item.item_type = item_type
    self.spr_item = UIMenuItemBag:createWithData(item_type, item_num)
    self.spr_item:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
    self:addChild(self.spr_item)
end

function PROMSecretTreasureChooseItem:setSelect(is_select)
    self.btn_choose.is_select = is_select
    -- -- self.spr_gray:setVisible(not is_select)
    self.spr_gou:setVisible(is_select)
    self.spr_glow:setVisible(is_select)
end

function PROMSecretTreasureChooseItem:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

------------------------------------ PROMSecretTreasureChooseCell ------------------------------------
function PROMSecretTreasureChooseCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end

function PROMSecretTreasureChooseCell:initDone(type, data)
    self.data = data
    self.type = type

    if type == 1 then
        -- self.spr_choose_lv:setSpriteFrame("promotion-secret-treasure-lang/icon-word-s.png")
        ex.Tools:setSpriteFrame(self.spr_choose_lv, "promotion-secret-treasure-lang/icon-word-s.png")
    elseif type == 2 then
        -- self.spr_choose_lv:setSpriteFrame("promotion-secret-treasure-lang/icon-word-a.png")
        ex.Tools:setSpriteFrame(self.spr_choose_lv, "promotion-secret-treasure-lang/icon-word-a.png")
    elseif type == 3 then
        -- self.spr_choose_lv:setSpriteFrame("promotion-secret-treasure-lang/icon-word-b.png")
        ex.Tools:setSpriteFrame(self.spr_choose_lv, "promotion-secret-treasure-lang/icon-word-b.png")
    end

    self.max_num = ex.Player.promotion_data:getChooseNumByType(type)
    self.choose_list = {}
    local view_size = cc.size(480.0, 144.0)
    self.scroll_view:setItemType(1)
    self.scroll_view:setCreateNum(1)
    self.scroll_view:setViewSize(view_size)
    self.scroll_view:setItemSize(cc.size(118, 118))
    local con_width = view_size.width
    if #data * 118 > con_width then
        con_width = #data * 118
    end

    self.select_label = cpp.RichTextEx:createWithXMLLua("")
        :setFontSize(40)
        :setFontFace(FONT_DEFAULT_NAME_BOLD)
        :setFontColor("#FFFFFF")
        :setAnchorTextShadow(true)
        :setScale(0.5)
        :setWrapMode(1)
    self.node_choose_tip:addChild(self.select_label)
    local str = string.format(ex.Tools:getLang(91005), #self.choose_list, self.max_num)
    self.select_label:setXmlTextLua(str)

    self.scroll_view:setContentSize(cc.size(con_width, view_size.height))
    self.scroll_view.createItemFunction = function(item_data, scale)
        local cell = PROMSecretTreasureChooseItem:createWithCCBIFile("ccbi/PROMSecretTreasureChooseItem.ccbi")
        cell:resetData(item_data, self.scroll_view:getViewSize().width)
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(cc.p(0.5, 0.5))
        cell:resetData(item_data)
        cell.btn_choose:registerScriptTapHandler(handler(self, self.onSelect))
        return cell
    end

    self.scroll_view:setTouchEnabled(false)
    self.scroll_view:reloadData(data)
end

function PROMSecretTreasureChooseCell:onSelect(tag, pSender)
    local item = pSender:getParent():getParent()
    if not item then
        return
    end

    if not pSender.is_select then
        if #self.choose_list < self.max_num then
            table.insert(self.choose_list, item.data.idx)
            if #self.choose_list == self.max_num then
                self.is_select_max = true
            end
            item:setSelect(true)
        else
            ex.MessageView:add(ex.Tools:getLang(91025))
        end
    else
        for k, v in ipairs(self.choose_list) do
            if v == item.data.idx then
                table.remove(self.choose_list, k)
                break
            end
        end

        self.is_select_max = false
        item:setSelect(false)
    end

    local str = string.format(ex.Tools:getLang(91005), #self.choose_list, self.max_num)
    self.select_label:setXmlTextLua(str)
end

------------------------------------ PROMSecretTreasureGameLayer ------------------------------------
function PROMSecretTreasureGameLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:initEventListen()
    self:addPlist()
    self:initView()
end

function PROMSecretTreasureGameLayer:initEventListen()
    self:addEvent(EVENT.SECRET_TREASURE.EVENT_REWARD_SELECT, handler(self,self.updateLayer))
    self:addEvent(EVENT.SECRET_TREASURE.EVENT_ITEM_OPEN, handler(self, self.handleOpenItem))
    self:addEvent(EVENT.SECRET_TREASURE.EVENT_GAME_RESET, handler(self, self.updateLayer))
    self:addEvent(EVENT.SECRET_TREASURE.EVENT_COUNT_REWARD_GET, handler(self, self.updateLayer))
    self:addEvent(EVENT.BACKPACK_RES_CHANGE.CHANGE_ITEM,handler(self,self.updateItem))
end

function PROMSecretTreasureGameLayer:addPlist()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/prom-dragonboat.plist")
end

function PROMSecretTreasureGameLayer:initView()
    self.btn_certain:registerScriptTapHandler(handler(self, self.onCertain))
    self.btn_reset:registerScriptTapHandler(handler(self, self.onReset))
    self.btn_reward:registerScriptTapHandler(handler(self, self.onRewardPreview))
    self.btn_add:registerScriptTapHandler(handler(self, self.onClickAdd))
    self.btn_choose_info:registerScriptTapHandler(handler(self, self.onChooseInfo))
    self.btn_game_info:registerScriptTapHandler(handler(self, self.onGameInfo))

    self.eff = {}

    self:updateLayer()
end

function PROMSecretTreasureGameLayer:updateLayer()
    self.is_updating = true
    local choose_rewards = ex.Player.promotion_data.promotion70_choose_rewards
    if not choose_rewards or #choose_rewards == 0 then
        self:updateChooseView()
        self.node_choose:setVisible(true)
        self.node_game:setVisible(false)
       
    else
        self:updateGameView()
        self.node_choose:setVisible(false)
        self.node_game:setVisible(true)
    end

    self.is_updating = false
end

function PROMSecretTreasureGameLayer:updateChooseView()
    local rewards = {}
    local types = {}
    self.choose_cells = {}
    for k, v in ipairs(cfg.promotion070reward.promotion070reward) do
        if v.type > 0 and v.type < 4 then
            if not rewards[v.type] then
                rewards[v.type] = {}
                table.insert(types, v.type)
            end
            table.insert(rewards[v.type], v)
        end
    end

    local index = 0
    self.node_reward:removeAllChildren()
    for k, v in ipairs(types) do
        local rewards = rewards[v]
        if rewards and #rewards > 0 then
            local cell = PROMSecretTreasureChooseCell:createWithCCBIFile("ccbi/PROMSecretTreasureChooseCell.ccbi")
            cell:setPosition(-cell:getContentSize().width / 2 , -(index + 0.5) * cell:getContentSize().height + index * 30)
            if cell:getContentSize().width > ex.p.width then
                cell:setScale(ex.p.width / cell:getContentSize().width)
            end
            cell:initDone(v, rewards)
            self.node_reward:addChild(cell)
            table.insert(self.choose_cells, cell)
            index = index + 1
        end
    end
end

function PROMSecretTreasureGameLayer:updateGameView()
    self.node_items:removeAllChildren()
    self:removeAllBoxEff()
    self.eff = {}
    self.can_reset_game = false
    self.is_init_game = true

    local offset = 6
    local item_size = cc.size(112, 112)
    local start_x =  0 + item_size.width / 2
    local start_y = self.node_items:getContentSize().height - item_size.height / 2
    local game_info = ex.Player.promotion_data.promotion70_game_info
    local open_record = game_info.open_record or {}

    local open_num = 0
    for i = 1, 16 do
        local item = PROMSecretTreasureGameItem:createWithCCBIFile("ccbi/PROMSecretTreasureGameItem.ccbi")
        item:setIgnoreAnchorPointForPosition(false)
        item:setAnchorPoint(0.5, 0.5)
        local row = math.ceil(i / 4)
        local col = math.floor((i + 4) % 4)
        if col == 0 then
            col = 4
        end
        item:setPosition(start_x + (col - 1) * (item_size.width + offset), start_y - (row - 1) * (item_size.height + offset))
        if open_record[i] then
            open_num = open_num + 1
            item:resetData(open_record[i].reward)
            if not self.can_reset_game and open_record[i].is_top_reward then
                self.can_reset_game = true
            end
            if self.is_init_game then
                self.is_init_game = false
            end
            item.btn_item.reward = open_record[i].reward
        end
        item.btn_item.item_index = i
        item.btn_item:registerScriptTapHandler(handler(self, self.onOpen))
        item:setName("item_" .. i)
        self.node_items:addChild(item)
    end

    self.lbl_open_times:setString(string.format(ex.Tools:getLang(91001), open_num))

    local total_open_times = ex.Player.promotion_data.promotion70_game_info.open_count or 0
    self.lbl_total_open_times:setString(total_open_times)

    if not self.lbl_ower then
        self.lbl_ower = cpp.RichTextEx:createWithXMLLua("")
            :setFontSize(44)
            :setFontFace(FONT_DEFAULT_NAME_BOLD)
            :setFontColor("#FFFFFF")
            :setAnchorTextShadow(true)
            :setScale(0.5)
            :setWrapMode(1)
            :setAnchorPoint(cc.p(0, 0.5))
        self.node_ower:addChild(self.lbl_ower)
    end

    local str = string.format(ex.Tools:getLang(91002), ex.Player:getItemNum(902041))
    self.lbl_ower:setXmlTextLua(str)

    if not self.progressTimer then
        self.progressTimer = require("src.comp.UIProgressTimerEquidistant"):create(cc.Sprite:createWithSpriteFrameName("prom-dragonboat/spr-jdt2.png"))
            :setType(cc.PROGRESS_TIMER_TYPE_BAR)
            :setScaleX(self.spr_progress_bg:getScaleX())
            :setMidpoint(cc.p(0, 0.5))
            :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
        self.spr_progress_bg:addChild(self.progressTimer)
        self.progressTimer:setPosition(self.spr_progress_bg:getContentSize().width / 2 - 8 ,self.spr_progress_bg:getContentSize().height / 2 )
    end

    self.node_times:setZOrder(100)
    local open_config = cfg.promotion070opencountreward.promotion070opencountreward
    local vec_progress_data = {}
    for k, v in ipairs(open_config) do
        local lbl = self["lbl_progress_reward_" .. k]
        lbl:setString(string.format("%s%s", v.count, ex.Tools:getLang(47180)))
        lbl:setZOrder(100)
        local node_reward = self["node_progress_reward_" .. k]
        node_reward:setZOrder(100)
        node_reward.idx = v.idx
        local percent = node_reward:getPositionX() / self.spr_progress_bg:getContentSize().width * 100

        local is_get_reward = false
        if game_info.count_reward and #game_info.count_reward > 0 then
            for k1, v1 in ipairs(game_info.count_reward) do
                if v1 == v.idx then
                    is_get_reward = true
                end
            end
        end

        local menu_reward = self["menu_progress_" .. k]
        menu_reward:removeAllChildren()
        local box_str
        if v.count <= total_open_times then
            if v.idx < 4 then
                box_str = "other/spr-box-open-" .. k .. ".png"
            end
        else
            if v.idx < 4 then
                box_str = "other/spr-box-" .. k .. ".png"
            end
        end

        local y = 20
        if v.idx == 4 then
            box_str = "promotion-secret-treasure-lang/btn-max-award.png"
            y = 6
        end

        local box = cpp.UIMenuItemImage:createWithSpriteFrameName(box_str, nil, nil)
        box.data = v
        box.can_get = v.count <= total_open_times and not is_get_reward
        box:registerScriptTapHandler(handler(self, self.onClickBox))
        box:setTag(v.idx)
        box:setAnchorPoint(0.5, 0)
        menu_reward:addChild(box, 1)
        box:setPosition(menu_reward:getContentSize().width / 2, y)
        if v.count <= total_open_times then
  
        else
     
        end
        self:createBoxEff(box, is_get_reward, v.idx, v.count, total_open_times)

        table.insert(vec_progress_data, {pos = percent, count = v.count} )
    end

    self.progressTimer:setPositionList(vec_progress_data)
    self.progressTimer:setPercentageCount(total_open_times)
end

function PROMSecretTreasureGameLayer:handleOpenItem(event, data)
    if data and data.key and data.value then
        local item = self.node_items:getChildByName("item_"..data.key)
        if item then
            item:runAction(cc.Sequence:create(
                cc.ScaleTo:create(0.3, 0, 1),
                cc.CallFunc:create(function ()
                    local reward_data = ex.Player.promotion_data:getPromotion70RewardItem(data.value)
                    if reward_data.reward and #reward_data.reward > 0 then
                        item:resetData(reward_data.reward[1])
                    end
                end),
                cc.ScaleTo:create(0.3, 1, 1),
                cc.CallFunc:create(function ()
                    self:updateLayer()
                end)
            ))
        else
            self:updateLayer()
        end
    else
        self:updateLayer()
    end
end

function PROMSecretTreasureGameLayer:createBoxEff(box, is_get, idx, count, open_time)
    if self.eff[idx] then
        return
    end

    if idx == 4 then
        if not is_get and count <= open_time then
            self.eff[idx] = ex.EffectCtr:playNormalEff(17, box:getContentSize().width * 0.5, box:getContentSize().height * 0.5, nil, box, 1000)
            self.eff[idx]:setAnchorPoint(0.5, 0.5)
        end
    elseif count <= open_time then
        local effId = not is_get and 11 or 10
        local x = not is_get and box:getContentSize().width / 2 - 3 or box:getContentSize().width / 2
        local y = not is_get and box:getContentSize().height / 2 - 12 or box:getContentSize().height / 2

        self.eff[idx] = ex.EffectCtr:playNormalEff(effId, x, y, nil, box, 10)
        self.eff[idx]:setAnchorPoint(0.5, 0)
    end
end

function PROMSecretTreasureGameLayer:removeAllBoxEff()
    local open_config = cfg.promotion070opencountreward.promotion070opencountreward
    for k, v in ipairs(open_config) do
        local idx = v.idx
        if self.eff[idx] ~= nil then
            self.eff[idx]:remove()
            self.eff[idx] = nil
        end
    end
end

function PROMSecretTreasureGameLayer:resetBg(width, height)
    local bg_size = self.spr_game_bg:getContentSize()
    if height > bg_size.height then
        self.spr_game_bg:setScaleY(height  / bg_size.height)
        self.spr_choose_bg:setScaleY(height  / bg_size.height)
    end
    
    if width > bg_size.width then
        self.spr_game_bg:setScaleX(width / bg_size.width)
        self.spr_choose_bg:setScaleX(width / bg_size.width)
    end
end

function PROMSecretTreasureGameLayer:updateItem(event)
    if self.lbl_ower then
        local str = string.format(ex.Tools:getLang(91002), ex.Player:getItemNum(902041))
        self.lbl_ower:setXmlTextLua(str)
    end
end

function PROMSecretTreasureGameLayer:onCertain(tag, pSender)
    local select_list = {}
    for k, v in ipairs(self.choose_cells) do
        if not v.is_select_max then
            ex.MessageView:add(ex.Tools:getLang(91011 + k))
            return
        end
        
        local type = v.type
        local choose_list = v.choose_list
        select_list[type] = choose_list
    end

    ex.ConfirmCtr:openWindow(
        ex.Tools:getLang(76818),
        ex.Tools:getLang(91016),
        function()
            local req = Promotion070_pb.GReqSelect()

            for k, v in pairs(select_list) do
                if v and #v > 0 then
                    local model = req.select_info:add()
                    model.idx = k
                    for i = 1, #v do
                        local reward_id = v[i]
                        table.insert(model.reward_id, reward_id)
                    end
                end
            end

            NetManager:sendMessage(ProtocolID.GReqSelect, req)
        end
    )
end

function PROMSecretTreasureGameLayer:onOpen(tag, pSender)
    if self.is_updating then
        return
    end

    if pSender.reward then
        ex.Tools:onClickItemInfo(pSender.reward.item_type)
        return
    end

    local index = pSender.item_index
    if not index then
        return
    end

    if ex.Player:getItemNum(902041) <= 0 then
        ex.MessageView:add(ex.Tools:getLang(91020))
        return
    end

    ex.ConfirmCtr:openWindow(
        ex.Tools:getLang(76818),
        ex.Tools:getLang(91019),
        function()
            local req = Promotion070_pb.GReqOpen()
            req.open_index = index
            NetManager:sendMessage(ProtocolID.GReqOpen, req)
        end
    )
end

function PROMSecretTreasureGameLayer:onReset(tag, pSender)
    if self.is_init_game then
        ex.MessageView:add(ex.Tools:getLang(91022))
        return
    end

    if not self.can_reset_game then
        ex.MessageView:add(ex.Tools:getLang(91023))
        return
    end

    ex.ConfirmCtr:openWindow(
        ex.Tools:getLang(76818),
        ex.Tools:getLang(91021),
        function()
            local req = Promotion070_pb.GReqResetSelect()
            NetManager:sendMessage(ProtocolID.GReqResetSelect, req)
        end
    )
end

function PROMSecretTreasureGameLayer:onClickBox(tag, pSender)
    local data = clone(pSender.data)
    local can_get = pSender.can_get
    local function callback()
        local req = Promotion070_pb.GReqGetCountReward()
        req.idx = data.idx
        NetManager:sendMessage(ProtocolID.GReqGetCountReward, req)
    end
	require("src.layer.SevenTargetRewardInfoCtr"):instance():openWindow(data, can_get, callback)
    
end

function PROMSecretTreasureGameLayer:onRewardPreview(tag, pSender)
    require("src.layer.promotion.PROMSecretTreasureRewardCtr"):instance():openWindow()
end

function PROMSecretTreasureGameLayer:onClickAdd(tag, pSender)
    require("src.layer.BackpackSrcCtr"):instance():openWindow(902041)
end

function PROMSecretTreasureGameLayer:onGameInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(91009), ex.Tools:getLang(91010))
end

function PROMSecretTreasureGameLayer:onChooseInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(91007), ex.Tools:getLang(91008))
end


return PROMSecretTreasureGameLayer

