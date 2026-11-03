local SmithRunesLayer = class("SmithRunesLayer", require("src.comp.EventLayer"))

-------------------------------SmithRunesLayer-----------------------------------------------
function SmithRunesLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.statue_compose_act = false

    self.btn_add_1:setEnableAction(false)
    self.btn_add_2:setEnableAction(false)
    
    self.lbl_exp:setLocalZOrder(100)

    -- 添加进度条
    self.progress_now = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("promotion/prog-vip-1.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.prog_bg:addChild(self.progress_now)
    self.progress_now:setPosition(self.prog_bg:getContentSize().width / 2 ,self.prog_bg:getContentSize().height / 2 )

    -- 添加进度条
    self.progress_next = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("promotion/prog-vip-1.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.prog_bg:addChild(self.progress_next)
    self.progress_next:setPosition(self.prog_bg:getContentSize().width / 2 ,self.prog_bg:getContentSize().height / 2 )

    -- self.progress:setPercentage(75)
    -- 设置按钮文字
    self.btn_speed_add:setLabelText(ex.Tools:getLang(47617))
    self.btn_compose:setLabelText(ex.Tools:getLang(47438))

    local view_size = cc.size(self.spr_scroll_view_bg:getContentSize().width, self.spr_scroll_view_bg:getContentSize().height - 10)
    local pos = cc.p(self.spr_scroll_view_bg:getPositionX() - view_size.width * 0.5, self.spr_scroll_view_bg:getPositionY() - view_size.height - 5)

    self.tableView = ex.Tools:initTableView(self, {}, {require("src.layer.runes.RunesSelect2Cell"), "ccbi/RunesSelect2Cell.ccbi"} , view_size, 7 , pos)

    -- print("self.tableView", self.tableView)

    self:initDone()
    
    self:addEvent(EVENT.RUNES_EVENT.COMPOSE, handler(self, self.onRunesComposeDone))
    self:addEvent(EVENT.RUNES_EVENT.SELECT_SMITH_RUNES, handler(self, self.onSelectedRunes))
    self:addEvent(EVENT.RUNES_EVENT.SELECT_SMITH_UPDATE_TABLE, handler(self, self.updateTableView))
    self:addEvent(EVENT.RUNES_EVENT.SELECT_SMITH_UPDATE_LAYER, handler(self, self.updateLayer))
    self:addEvent(EVENT.RUNES_EVENT.REMOVE, handler(self, self.updateTableView))
    self:addEvent(EVENT.RUNES_EVENT.SELECT_SMITH_UPDATE_TABLE, handler(self, self.updateLayer))

    -- ex.EventManager:fire(EVENT.RUNES_EVENT.SELECT_SMITH_UPDATE_TABLE, data)
end

function SmithRunesLayer:initDone()
    -- [item_id, ... ]
    self.selected_id = NULL_ID
    self.vec_selected = {}
    self:updateLayer()
    self:updateTableView()
end

function SmithRunesLayer:getLayerClass()
    return SmithRunesLayer
end

function SmithRunesLayer:getSelectExp()
    -- 增加的经验
    local add_exp = 0
    for k,v in pairs(self.vec_selected) do
        local runes_data = ex.Player.backpack_data:getRunesById(v)
        if runes_data then
            -- 遍历配置表
            local config = ex.Player.backpack_data:getTypeConfig(runes_data.item_type)
            if config then
                add_exp = add_exp + config.point
            end
        end
    end

    return add_exp
end

function SmithRunesLayer:updateLayer()
    local runes_data = self.selected_id ~= NULL_ID and ex.Player.backpack_data:getRunesById(self.selected_id) or nil

    if runes_data ~= nil then
        -- 遍历配置表
        local config = ex.Player.backpack_data:getCombineConfig(runes_data.item_type)

        repeat
            if not config then
                break
            end
            -- 更新成品图片
            -- ex.Tools:setSpriteFrame(self.spr_compose, "backpack/".. config.combine_target ..".png")
            if self.btn_add_2:getChildByTag(300) == nil then
                local spr_tmp = cc.Sprite:create()
                spr_tmp:setPosition(self.btn_add_2:getContentSize().width / 2, self.btn_add_2:getContentSize().height / 2 + 5)
                spr_tmp:setTag(300)
                self.btn_add_2:addChild(spr_tmp, 20)
            end
            local spr_compose = self.btn_add_2:getChildByTag(300)
            ex.Tools:setSpriteFrame(spr_compose, "backpack/".. config.combine_target ..".png")
            spr_compose.item_type = config.combine_target

            -- 更新现在的经验值
            -- print(runes_data.exp , config.need_point)
            self.progress_now:setPercentage(runes_data.exp / config.need_point * 100)

            local add_exp = self:getSelectExp()
            self.progress_next:setPercentage(math.min(100, self.progress_now:getPercentage() + add_exp / config.need_point * 100))

            self.lbl_exp:setString(string.format("%d/%d", runes_data.exp + add_exp, config.need_point))

            self.lbl_gold:setString(string.format("%d", config.cost_gold))
            ex.Tools:setCostColor(self.lbl_gold, ex.Player.gold >= config.cost_gold)
        until true
    else
        self.btn_add_2:removeChildByTag(300)

        -- 更新进度条
        self.progress_now:setPercentage(0)
        -- self.progress_next:setPercentage(0)
        self.lbl_exp:setString("0/0")
        self.lbl_gold:setString("0")
        ex.Tools:setCostColor(self.lbl_gold, true)
    end

    -- 更新被选择的图片
    local i = 1
    self["btn_add_"..i]:removeChildByTag(100)
    if runes_data == nil then
        local spr_add = cc.Sprite:createWithSpriteFrameName("runes/btn-add-1.png")
        spr_add:setPosition(self["btn_add_"..i]:getContentSize().width / 2, self["btn_add_"..i]:getContentSize().height / 2)
        spr_add:setTag(100)
        self["btn_add_"..i]:addChild(spr_add)
    else
        local spr_add = cc.Sprite:create()-- cc.Sprite:createWithSpriteFrameName("backpack/"..data.item_type..".png")
        ex.Tools:setSpriteFrame(spr_add, "backpack/"..runes_data.item_type..".png")
        spr_add:setPosition(self["btn_add_"..i]:getContentSize().width / 2, self["btn_add_"..i]:getContentSize().height / 2 + 5)
        spr_add:setTag(100)
        self["btn_add_"..i]:addChild(spr_add)
    end
end

function SmithRunesLayer:updateTableView()
    local vec_runes = clone(ex.Player.backpack_data:getRunesListNotWear())

    -- 删除当前需要升级的符文
    if table.nums(self.vec_selected) then
        TableEx.removeTableData(vec_runes, function(value)
            return value.item_id == self.selected_id
        end)
    end

    local sort_func = function(a, b)
        local compA = a.item_type >= b.item_type                     and -1000000 or 0
        compA = compA + (tonumber(a.item_id) < tonumber(b.item_id)   and -1000    or 0)

        local compB = b.item_type >= a.item_type                     and -1000000 or 0
        compB = compB + (tonumber(b.item_id) < tonumber(a.item_id)   and -1000    or 0)

        return compA > compB
    end
    table.sort(vec_runes, sort_func)

    local item_count = table.nums(vec_runes)
    local view_size = self.tableView:getViewSize()
    local item_size = cc.Sprite:createWithSpriteFrameName("other/rare-0.png"):getContentSize()
    item_size = cc.size(item_size.width + 10, item_size.height + 12)


    local margin = 10
    local heroLen = item_count
    local col = math.floor((view_size.width - margin * 2) / item_size.width) -- 列数
    local row = math.ceil(1.0 * heroLen / col) -- 行数
    local cont_height = item_size.height * row + margin * 2
    cont_height = math.max(cont_height , view_size.height)
    row = math.ceil((cont_height - margin * 2) / item_size.height) -- 总行数

    local index = 0
    local runes_data = {}
    for k,v in pairs(vec_runes) do
        local nowData = {}
        nowData.tag = 2
        nowData.col = col
        nowData.runes_data = v
        nowData.is_show_select = self.selected_id ~= NULL_ID
        nowData.setSelected = false

        -- dump(v, "v")

        if TableEx.isInTable(self.vec_selected, v.item_id) then
            nowData.setSelected = true
        end
        
        local x = index % col
        local y = math.floor(index / col) + 1

        if not runes_data[y] then 
            runes_data[y] = {}
        end 
        table.insert(runes_data[y] , nowData )

        index = index + 1
    end

    -- local bg_size = layer.tableView:getContentSize()
    self.tableView:initData(runes_data)
    local offsetY = self.tableView:getContainer():getPositionY()
end

function SmithRunesLayer:onRunesSelect(tag, pSender)
    self.select_idx = tag
    require("src.layer.runes.RunesSelect2Ctr"):instance():openWindow({}, handler(self, self.onRunesSelectDone), 1)
end

function SmithRunesLayer:onTargetInfo(tag, pSender)
    local spr_target = pSender:getChildByTag(300)
    if pSender == nil or spr_target == nil then
        return
    end

    require("src.layer.BackpackInfoCtr"):instance():openWindow(spr_target.item_type)
end

function SmithRunesLayer:onSelectedRunes(event, pSender, spr_select)
    local is_select = not spr_select:isVisible()
    if self.selected_id == NULL_ID then
        ex.MessageView:add(ex.Tools:getLang(47310))
        return
    end

    local runes_data = ex.Player.backpack_data:getRunesById(self.selected_id)
    local config = ex.Player.backpack_data:getCombineConfig(pSender.item_type)

    if not config or tonumber(pSender.item_type) > tonumber(runes_data.item_type) then
        ex.MessageView:add(ex.Tools:getLang(47053))
        return
    end

    spr_select:setVisible(is_select)
    pSender.runes_data.setSelected = is_select

    -- 遍历已经选中的精灵
    self.vec_selected = {}
    for k,v in pairs(self.tableView.data) do
        for _,va in pairs(v) do
            if va.setSelected == true then
                table.insert(self.vec_selected, va.runes_data.item_id)
            end
        end
    end

    -- dump(self.vec_selected, "self.vec_selected")
    self:updateLayer()
end

function SmithRunesLayer:onRunesSelectDone(vec_selected, runes_id)
    -- self.vec_selected = vec_selected
    -- 判断该id的符文是否存在
    -- 更新列表

    -- 更新显示
    self.selected_id = runes_id
    self.vec_selected = {}
    self:updateLayer()
    self:updateTableView()
end

function SmithRunesLayer:onSpeedAdd(tag, pSender)
    if self.selected_id == NULL_ID then
        ex.MessageView:add(ex.Tools:getLang(47310))
        return
    end

    -- 筛选五个最低品质符文
    local vec_runes = clone(ex.Player.backpack_data:getRunesListNotWear())

    -- 删除当前需要升级的符文
    if table.nums(self.vec_selected) then
        TableEx.removeTableData(vec_runes, function(value)
            return value.item_id == self.selected_id
        end)
    end


    -- 排序
    -- dump(vec_runes, "vec_runes")
    local sort_func = function(a, b)
        local compA = a.item_type >= b.item_type                     and -1000000 or 0
        compA = compA + (tonumber(a.item_id) < tonumber(b.item_id)   and -1000    or 0)

        local compB = b.item_type >= a.item_type                     and -1000000 or 0
        compB = compB + (tonumber(b.item_id) < tonumber(a.item_id)   and -1000    or 0)

        return compA > compB
    end
    table.sort(vec_runes, sort_func)

    self.vec_selected = {}
    local runes_data = ex.Player.backpack_data:getRunesById(self.selected_id)

    local need_exp = -1
    repeat
        if not runes_data then
            break
        end

        local config = ex.Player.backpack_data:getCombineConfig(runes_data.item_type)
        if not config then
            break
        end

        need_exp = config.need_point - runes_data.exp
    until true

    if need_exp == -1 then
        ex.MessageView:add(ex.Tools:getLang(47341))
        return
    end

    for k,v in pairs(vec_runes) do
        local config_type = ex.Player.backpack_data:getTypeConfig(v.item_type)

        if runes_data.item_type < v.item_type then
            break
        end

        if config_type then
            table.insert(self.vec_selected, v.item_id)
            need_exp = need_exp - config_type.point
        end
        print("need_exp", need_exp)
        if need_exp <= 0 then
            break
        end
    end

    -- local cur_type = 0
    -- local vec_select = {}
    -- for k,v in pairs(vec_runes) do
    --     if v.item_type ~= cur_type then
    --         cur_type = v.item_type
    --         vec_select = {}
    --     end

    --     local config = compose_config_func(v.item_type)
    --     if config then
    --         table.insert(vec_select, v)
    --     end
    --     -- table.insert(vec_select, v)

    --     local select_num = table.nums(vec_select)
    --     if select_num >= 5 then
    --         break
    --     end
    -- end

    -- local select_num = table.nums(vec_select)

    -- -- 符文数量不够。选择最低等级的符文
    -- if select_num < 5 then
    --     vec_select = {}
    --     cur_type = nil
    --     for k,v in pairs(vec_runes) do
    --         if cur_type == nil then
    --             cur_type = v.item_type
    --         end

    --         if v.item_type ~= cur_type then
    --             break
    --         end


    --         local config = compose_config_func(v.item_type)
    --         if config then
    --             table.insert(vec_select, v)
    --         end
    --     end
    -- end

    -- self.vec_selected = {}
    -- for i,v in ipairs(vec_select) do
    --     table.insert(self.vec_selected, v.item_id)
    -- end


    if table.nums(self.vec_selected) <= 0 then
        ex.MessageView:add(ex.Tools:getLang(47116))
    end
    
    self:updateLayer()
    self:updateTableView()
end

function SmithRunesLayer:onRunesCompose(tag, pSender)

    if self.selected_id == NULL_ID then
        ex.MessageView:add(ex.Tools:getLang(47310))
        return
    end

    local select_num = table.nums(self.vec_selected)
    if select_num <= 0 then
        ex.MessageView:add(ex.Tools:getLang(47300))
        return
    end

    -- 必须经验够升一级才能精灵锻造
    local runes_data = ex.Player.backpack_data:getRunesById(self.selected_id)
    if not runes_data then
        return
    end
    local config = ex.Player.backpack_data:getCombineConfig(runes_data.item_type)
    if not config then
        return
    end

    if ex.Player:getItemNum(900001) < config.cost_gold then
        ex.MessageView:add(ex.Tools:getLang(47702))
        return
    end

    local need_exp = config.need_point - runes_data.exp
    for k,v in pairs(self.vec_selected) do
        local tmp_data = ex.Player.backpack_data:getRunesById(v)
        local config_type = ex.Player.backpack_data:getTypeConfig(tmp_data.item_type)

        if tonumber(runes_data.item_type) < tonumber(tmp_data.item_type) then
            break
        end

        if config_type then
            need_exp = need_exp - config_type.point
        end

        if need_exp <= 0 then
            break
        end
    end

    if need_exp > 0 then
        ex.MessageView:add(ex.Tools:getLang(47466))
        return
    end

    -- 播放特效
    if self.statue_compose_act ~= true then
        self:onRunesComposeAct()
    end

    -- -- 向服务器请求合成
    -- local req_compose = Rune_pb.GReqRuneCombine()
    -- req_compose.rune_id = self.selected_id
    -- req_compose.list = self.vec_selected
    -- NetManager:sendMessage(ProtocolID.GReqRuneCombine, req_compose)
end

function SmithRunesLayer:onRunesComposeAct()
    self.statue_compose_act = true
    if self.node_compose_act == nil then
        self.step_compose_act = 1
    else
        self.node_compose_act:removeFromParent()
        self.node_compose_act = nil
    end

    if self.step_compose_act == 4 then
        self.step_compose_act = 1
        self.statue_compose_act = false

        local req_compose = Rune_pb.GReqRuneCombine()
        req_compose.rune_id = self.selected_id

        for i,v in ipairs(self.vec_selected) do
            table.insert(req_compose.list, v)
        end

        NetManager:sendMessage(ProtocolID.GReqRuneCombine, req_compose)

        return
    end

    self.node_compose_act = cc.Sprite:create()
    self:addChild(self.node_compose_act, 200)

    if self.step_compose_act == 1 then
        self.node_compose_act:setPosition(self.node_compose:getPositionX() + self.btn_add_1:getPositionX(), self.node_compose:getPositionY() + self.btn_add_1:getPositionY())
    elseif self.step_compose_act == 2 then
        self.node_compose_act:setPosition(self.node_compose:getPositionX() + (self.btn_add_1:getPositionX() + self.btn_add_2:getPositionX()) / 2, self.node_compose:getPositionY() + self.btn_add_1:getPositionY())
    elseif self.step_compose_act == 3 then
        self.node_compose_act:setPosition(self.node_compose:getPositionX() + self.btn_add_2:getPositionX(), self.node_compose:getPositionY() + self.btn_add_2:getPositionY())
    end

    self.node_compose_act:runAction(ex.EffectFactory:createEffectByName("eff_runes_compose_"..self.step_compose_act, cc.CallFunc:create(handler(self, self.onRunesComposeAct))))

    self.step_compose_act = self.step_compose_act + 1
end

function SmithRunesLayer:onRunesComposeDone(evect)
    -- 如果成功则刷新界面，执行动画
    self.selected_id = NULL_ID
    self.vec_selected = {}

    self:updateLayer()
    self:updateTableView()
end

return SmithRunesLayer

