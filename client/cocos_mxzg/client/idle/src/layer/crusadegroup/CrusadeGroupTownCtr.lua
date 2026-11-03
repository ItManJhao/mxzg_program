--[[
    讨伐团城镇列表和爵位界面
    在讨伐团场景调用
]]

local CrusadeGroupTownCtr = class("CrusadeGroupTownCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local CrusadeGroupTownLayer = class("CrusadeGroupTownLayer", require("src.comp.EventLayerAdaptiveWidth"))

local CrusadeGroupTownNobilityLayer = class("CrusadeGroupTownNobilityLayer", require("src.comp.EventLayer"))
local CrusadeGroupTownListLayer = class("CrusadeGroupTownListLayer", require("src.comp.EventLayer"))

local CrusadeGroupTaskCell = class("CrusadeGroupTaskCell", require("src.comp.LuaLayerBase"))
local CrusadeGroupTownCell = class("CrusadeGroupTownCell", require("src.comp.LuaLayerBase"))

-----------------------------------------------------------------------------
local CrusadeGroupTownLayerType = {
    TownList = 1,
    Nobility = 2,
}

-----------------------------------------------------------------------------
function CrusadeGroupTaskCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    
    -- 加成提示
    self.lbl_content = require("src.comp.RichTextEx"):create()
	:setFontSize(40)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#7A472D")
    :setScale(0.5)
    :setAnchorPoint(0, 0.5)
	:setAnchorTextShadow(true)
	:setWrapMode(1)
    :setPosition(20, 85)
    self:addChild(self.lbl_content, 10001)

    -- 添加任务进度进度条
    self.progress_task = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("crusade-group/progress-task.png"))
        :setType(cc.PROGRESS_TIMER_TYPE_BAR)
        :setMidpoint(cc.p(0, 0.5))
        :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.progress_task:setPosition(self.progress_bg:getPosition())
    self:addChild(self.progress_task, 20)

    self.lbl_progress:setLocalZOrder(30)
end

function CrusadeGroupTaskCell:setScrollView(scroll_view)
    self.menu_item:setIsTouchInsideNode(scroll_view)
    self.menu_item:setSwallowsTouches(false)
end

function CrusadeGroupTaskCell:initData(data)
    self.data = data

    self.btn_complete.task_id = data.id
    self.btn_complete:setEnabled(data.state == 1)
    if data.state == 1 then
        ex.Tools:addRedPoint(self.btn_complete, true, cc.p(0.95, 0.8))
    end

    self.lbl_content:setXmlTextLua(ex.Tools:taskString(data.des, data.task.target, data.task.condition))
    self.lbl_content:formatText()
    
    -- local geted = data.state == 1
    -- self.spr_geted:setVisible(geted)
    -- self.lbl_progress:setVisible(not geted)
    -- self.progress_bg:setVisible(not geted)
    self.progress_task:setPercentage(100.0 * data.process / data.task.target)
    self.lbl_progress:setString(data.process.." / "..data.task.target)
end

-----------------------------------------------------------------------------
function CrusadeGroupTownCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end

function CrusadeGroupTownCell:setScrollView(scroll_view)
    self.menu:setIsTouchInsideNode(scroll_view)
    self.menu:setSwallowsTouches(false)
end

function CrusadeGroupTownCell:initData(data)
    self.data = data

    self.btn_find.town_id = data.id

    ex.Tools:setSpriteFrame(self.spr_town, data.icon)
    self.lbl_town_name:setString(ex.Tools:getLang(data.name))
    self.lbl_town_level:setString(RomanNumber[data.level] or RomanNumber[1])
    -- self.lbl_town_time:setPositionX(self.lbl_town_name:getPositionX() + self.lbl_town_name:getContentSize().width * self.lbl_town_name:getScaleX() + 10)
    self.lbl_town_time:setVisible(false)

    local x,y = ctr.crusade_group.data:convertGridIdToPos(data.id)
    self.lbl_town_pos:setString(x .. ", " .. y)

    self.spr_elem:setVisible(data.elem > 0 and data.can_farm)
    ex.Tools:setSpriteFrame(self.spr_elem, "hero-icon/elem-"..data.elem..".png")
    self.btn_farm:setVisible(data.hero_id <= 0 and data.can_farm)
end

function CrusadeGroupTownCell:setGiveUpTime(time)
    if time <= 0 then
        self.lbl_town_time:setVisible(false)
    else
        self.lbl_town_time:setVisible(true)

        self.lbl_town_time:setString("("..ex.StringUtil.convertToTimeFormat(time, 4)..")")
    end

    if self.btn_giveup.is_giveup ~= (time > 0) then
        self.btn_giveup:setNormalImage(cc.Sprite:createWithSpriteFrameName(time <= 0 and "crusade-group/btn-giveup.png" or "crusade-group/btn-giveup-4.png"))
    end
end

-----------------------------------------------------------------------------
function CrusadeGroupTownNobilityLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.scroll_view:setItemSize(cc.size(550, 115))
    self.scroll_view:setItemType(1)

    -- 添加任务进度进度条
    self.progress_reward = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("crusade-group/progress-reward.png"))
        :setType(cc.PROGRESS_TIMER_TYPE_BAR)
        :setMidpoint(cc.p(0, 0.5))
        :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.progress_reward:setPosition(self.progress_bg:getPosition())
    self.node_reward_progress:addChild(self.progress_reward, 10)

    self.node_point:setLocalZOrder(30)
    self.spr_nobility_reward_before:setLocalZOrder(20)
    self.spr_nobility_reward_after:setLocalZOrder(20)
    
    self:addRedDotNode(RedDotType.ZCJ_DHZC_TFT_ZJ_RW_JS, self.btn_nobility_up)
end

function CrusadeGroupTownNobilityLayer:setTaskProgress(cur_num, total_num)
    self.node_point:removeAllChildren()

    if total_num <= 0 then
        return
    end

    self.progress_reward:setPercentage(cur_num * 100 / total_num)

    if total_num <= 1 then
        return
    end

    local width = self.progress_bg:getContentSize().width * self.progress_bg:getScaleX()
    for i=1,total_num - 1 do
        local spr_point = nil
        if i <= cur_num then
            spr_point = cc.Sprite:createWithSpriteFrameName("crusade-group/spr-spot-2.png") or cc.Sprite:create()
        else
            spr_point = cc.Sprite:createWithSpriteFrameName("crusade-group/spr-spot-1.png") or cc.Sprite:create()
        end

        spr_point:setPosition(cc.p(width * (i / total_num - 0.5), 0))
        self.node_point:addChild(spr_point)
    end
end

-----------------------------------------------------------------------------
function CrusadeGroupTownListLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.scroll_view:setItemSize(cc.size(560, 125))
    self.scroll_view:setItemType(1)
end

-----------------------------------------------------------------------------
function CrusadeGroupTownLayer:onCreate()
    self:addBlackBackground()
    self:setAutoClose(true)
    self:setSwallowTouches(true)

    self.btn_tab_1:setLabelText(ex.Tools:getLang(77710))
    self.btn_tab_2:setLabelText(ex.Tools:getLang(77711))

    self.menu_close:setLocalZOrder(100)
    self.menu_tab:setLocalZOrder(-1)

    self.layer_nobility = CrusadeGroupTownNobilityLayer:createWithCCBIFile("ccbi/CrusadeGroupTownNobilityLayer.ccbi")
    self.layer_nobility:setPosition(cc.p(0, 40))
    self:addChild(self.layer_nobility)
    self.layer_town_list = CrusadeGroupTownListLayer:createWithCCBIFile("ccbi/CrusadeGroupTownListLayer.ccbi")
    self.layer_town_list:setPosition(cc.p(0, 40))
    self:addChild(self.layer_town_list)
    
    self:addRedDotNode(RedDotType.ZCJ_DHZC_TFT_ZJ_RW, self.btn_tab_1)
end

-----------------------------------------------------------------------------
function CrusadeGroupTownCtr:onCreate()
    self:setCCBIPath("ccbi/CrusadeGroupTownLayer.ccbi")
    self:setIsSingle(false)
end

function CrusadeGroupTownCtr:getLayerClass()
    return CrusadeGroupTownLayer
end

function CrusadeGroupTownCtr:openWindow()
    if self:isOpened() then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/crusade-group.plist")

    self:loadLayer()
    self:open()
    self:initData()
end

function CrusadeGroupTownCtr:initData()
    self.layer:addEvent(EVENT.CRUSADE_GROUP.UPDATE_TASK_LIST, handler(self, self.receiveEvent))
    self.layer:addEvent(EVENT.CRUSADE_GROUP.UPDATE_TOWN_LIST, handler(self, self.receiveEvent))
    self.layer:addEvent(EVENT.CRUSADE_GROUP.UPDATE_OCCUPATION, handler(self, self.receiveEvent))
    self.layer:addEvent(EVENT.CRUSADE_GROUP.UPDATE_GIVEUP_VIEW, handler(self, self.receiveEvent))
    self.layer:addEvent(EVENT.CRUSADE_GROUP.UPDATE_GIVEUP, handler(self, self.receiveEvent))
    
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    self.layer.btn_tab_1:registerScriptTapHandler(handler(self, self.onTab))
    self.layer.btn_tab_2:registerScriptTapHandler(handler(self, self.onTab))

    self.layer.layer_nobility.btn_nobility_up:registerScriptTapHandler(handler(self, self.onNobilityLevelup))

    self.layer.layer_town_list.btn_tab_town_0:registerScriptTapHandler(handler(self, self.onTabTown))
    self.layer.layer_town_list.btn_tab_town_1:registerScriptTapHandler(handler(self, self.onTabTown))
    self.layer.layer_town_list.btn_tab_town_2:registerScriptTapHandler(handler(self, self.onTabTown))
    self.layer.layer_town_list.btn_tab_town_3:registerScriptTapHandler(handler(self, self.onTabTown))

    self.layer_type = CrusadeGroupTownLayerType.Nobility
    self.town_type = 0

    self:updateLayer()

    -- 请求领地列表
    NetManager:sendMessage(ProtocolID.GReqTerritory)

    -- 请求任务列表
    NetManager:sendMessage(ProtocolID.GReqGetOccupationInfo)
end

function CrusadeGroupTownCtr:updateLayer()
    self.layer.layer_nobility:setVisible(self.layer_type == CrusadeGroupTownLayerType.Nobility)
    self.layer.layer_town_list:setVisible(self.layer_type == CrusadeGroupTownLayerType.TownList)
    
    self.layer.layer_nobility:setLocalZOrder(self.layer_type == CrusadeGroupTownLayerType.Nobility and 100 or 50)
    self.layer.layer_town_list:setLocalZOrder(self.layer_type == CrusadeGroupTownLayerType.TownList and 100 or 50)

    self.layer.btn_tab_1:setChecked(self.layer_type == CrusadeGroupTownLayerType.TownList)
    self.layer.btn_tab_2:setChecked(self.layer_type == CrusadeGroupTownLayerType.Nobility)

    self.layer.lbl_title:setString(ex.Tools:getLang((self.layer_type == CrusadeGroupTownLayerType.TownList) and 77710 or 77711))

    local crusade_group_data = ctr.crusade_group.data.game_data

    if self.layer_type == CrusadeGroupTownLayerType.Nobility then
        local cur_nobility = crusade_group_data.self_occupation_id
        local config_nobility = cfg.crusadegroupoccupation.crusadegroupoccupation[cur_nobility]

        -- 显示当前职级
        ex.Tools:setSpriteFrame(self.layer.layer_nobility.spr_nobility, "crusade-group/spr-nobility-" .. cur_nobility .. ".png")
        self.layer.layer_nobility.lbl_nobility:setString(ex.Tools:getLang(config_nobility.des))

        -- 显示当前职级加成
        self.layer.layer_nobility.lbl_num_1:setString(config_nobility.landNum)
        self.layer.layer_nobility.lbl_num_2:setString(config_nobility.shenbinCore)
        self.layer.layer_nobility.lbl_num_3:setString(config_nobility.heroNum)

        -- 獲取當前職級任務列表
        local task_num_max = 0
        local item_list = {}
        local complete_num = 0
        local cur_nobility = crusade_group_data.self_occupation_id
        for _,task_item in ipairs(cfg.crusadegroupoccupationtask.crusadegroupoccupationtask) do
            if task_item.oc_id == cur_nobility then
                task_num_max = task_num_max + 1

                local data = clone(task_item)
                data.process = 0
                data.state = 0  -- 0：未完成；1：可完成；2：已完成

                for i,v in ipairs(crusade_group_data.tasklist) do
                    if v.taskId == task_item.id then
                        data.process = v.targetCount
                        if v.complete_type == 0 then
                            data.state = 2
                            complete_num = complete_num + 1
                        elseif v.condition == 0 and data.process >= data.task.target then
                            data.state = 1
                        end
                        break
                    end
                end

                if data.state ~= 2 then
                    table.insert(item_list, data)
                end
            end
        end
        if task_num_max <= 0 then
            -- 滿級
            self.layer.layer_nobility.node_task_list:setVisible(false)
            self.layer.layer_nobility.node_nobility_up_confirm:setVisible(true)
            self.layer.layer_nobility.node_nobility_after:setVisible(false)
            self.layer.layer_nobility.btn_nobility_up:setVisible(false)
            self.layer.layer_nobility.lbl_nobility_max_tip:setVisible(true)
        elseif task_num_max <= complete_num then
            -- 如果当前职级所有任务已经完成，则显示职级升级界面
            self.layer.layer_nobility.node_task_list:setVisible(false)
            self.layer.layer_nobility.node_nobility_up_confirm:setVisible(true)
            self.layer.layer_nobility.lbl_nobility_max_tip:setVisible(false)
            self.layer.layer_nobility.node_task_list:setLocalZOrder(50)
            self.layer.layer_nobility.node_nobility_up_confirm:setLocalZOrder(100)

            local config_nobility_after = cfg.crusadegroupoccupation.crusadegroupoccupation[cur_nobility + 1]

            if config_nobility_after ~= nil then
                -- 显示下一职级
                ex.Tools:setSpriteFrame(self.layer.layer_nobility.spr_nobility_after, "crusade-group/spr-nobility-" .. cur_nobility + 1 .. ".png")
                self.layer.layer_nobility.lbl_nobility_after:setString(ex.Tools:getLang(config_nobility_after.des))
            else
                -- 显示满级

            end
        else
            -- 刷新奖励进度条
            self.layer.layer_nobility.lbl_title_task:setString(string.format(ex.Tools:getLang(77719), task_num_max - complete_num))
            self.layer.layer_nobility:setTaskProgress(complete_num, task_num_max)
                    
            -- 如果当前职级有任务未完成，则显示职级任务列表界面
            self.layer.layer_nobility.node_task_list:setVisible(true)
            self.layer.layer_nobility.node_nobility_up_confirm:setVisible(false)
            self.layer.layer_nobility.node_task_list:setLocalZOrder(100)
            self.layer.layer_nobility.node_nobility_up_confirm:setLocalZOrder(50)
            
            ex.Tools:setSpriteFrame(self.layer.layer_nobility.spr_nobility_reward_before, "crusade-group/spr-nobility-" .. cur_nobility .. ".png")
            ex.Tools:setSpriteFrame(self.layer.layer_nobility.spr_nobility_reward_after, "crusade-group/spr-nobility-" .. cur_nobility + 1 .. ".png")

            -- 刷新任务列表
            self:updateScrollViewTaskList(item_list)
        end
    else
        self.layer.layer_town_list.btn_tab_town_0:setChecked(self.town_type == 0)
        self.layer.layer_town_list.btn_tab_town_1:setChecked(self.town_type == 1)
        self.layer.layer_town_list.btn_tab_town_2:setChecked(self.town_type == 2)
        self.layer.layer_town_list.btn_tab_town_3:setChecked(self.town_type == 3)

        self:updateScrollViewTownList()
    end
end

-- 城镇列表和爵位界面切换
function CrusadeGroupTownCtr:onTab(tag, pSender)
    if self.layer_type == tag then
        return
    end

    self.layer_type = tag

    self:updateLayer()
end

-- 城镇类型间切换
function CrusadeGroupTownCtr:onTabTown(tag, pSender)
    if self.layer_type ~= CrusadeGroupTownLayerType.TownList then
        return
    end
    if self.town_type == tag then
        return
    end

    self.town_type = tag

    self:updateLayer()
end

-- 刷新任务列表
function CrusadeGroupTownCtr:updateScrollViewTaskList(item_list)
    table.sort(item_list, function(a, b)
        return a.state == b.state and a.id < b.id or a.state > b.state
    end)

    self.layer.layer_nobility.scroll_view:getContainer():removeAllChildren()
    self.layer.layer_nobility.scroll_view.createItemFunction = function(data)
        -- 创建ccbi cell
        local cell = CrusadeGroupTaskCell:createWithCCBIFile("ccbi/CrusadeGroupTaskCell.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(0.5, 0.5)

        cell.btn_complete:registerScriptTapHandler(handler(self, self.onTaskComplete))
    
        cell:initData(data)
        cell:setScrollView(self.layer.layer_nobility.scroll_view)
    
        return cell
    end

    self.layer.layer_nobility.scroll_view:reloadData(item_list)
end

-- 刷新城镇列表
function CrusadeGroupTownCtr:updateScrollViewTownList()
    local item_list = {}

    for _,town_data in ipairs(ctr.crusade_group.data.game_data.occupied_list) do
        local config_town = cfg.crusadegroupbuild.getConfig(town_data.id)
        if config_town.building_type == self.town_type or self.town_type == 0 then
            local tmp_data = clone(town_data)
            tmp_data.icon = config_town.building_icon
            tmp_data.name = config_town.name
            tmp_data.level = config_town.building_level
            tmp_data.can_farm = config_town.defend_is > 0
            tmp_data.elem = 0
            if town_data.hero_id > 0 then
                local hero_data = ctr.crusade_group.data:getSetOffHero(town_data.hero_id)
                if hero_data ~= nil then
                    tmp_data.elem = cfg.herotype.star[hero_data.hero.hero_type].elem
                end
            end
            table.insert(item_list, tmp_data)
        end
    end

    table.sort(item_list, function(a, b)
        return a.level == b.level and a.id > b.id or a.level > b.level
    end)

    self.layer.layer_town_list.scroll_view:getContainer():removeAllChildren()
    self.layer.layer_town_list.scroll_view.createItemFunction = function(data)
        -- 创建ccbi cell
        local cell = CrusadeGroupTownCell:createWithCCBIFile("ccbi/CrusadeGroupTownCell.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(0.5, 0.5)

        cell.btn_farm:registerScriptTapHandler(handler(self, self.onTownFarm))
        cell.btn_giveup:registerScriptTapHandler(handler(self, self.onTownGiveup))
        cell.btn_find:registerScriptTapHandler(handler(self, self.onTownFind))

        cell.btn_farm.town_id = data.id
        cell.btn_giveup.town_id = data.id
        cell.btn_find.town_id = data.id
    
        cell:initData(data)
        cell:setScrollView(self.layer.layer_town_list.scroll_view)
    
        return cell
    end

    self.layer.layer_town_list.scroll_view:reloadData(item_list)
end

-- 获得事件回调
function CrusadeGroupTownCtr:receiveEvent(event, data)
    if event == EVENT.CRUSADE_GROUP.UPDATE_TASK_LIST or event == EVENT.CRUSADE_GROUP.UPDATE_OCCUPATION then
        if self.layer_type == CrusadeGroupTownLayerType.Nobility then
            self:updateLayer()
        end
    elseif event == EVENT.CRUSADE_GROUP.UPDATE_TOWN_LIST or event == EVENT.CRUSADE_GROUP.UPDATE_GIVEUP_VIEW then
        if self.layer_type == CrusadeGroupTownLayerType.TownList then
            self:updateLayer()
        end
    elseif event == EVENT.CRUSADE_GROUP.UPDATE_GIVEUP then
        if self.layer_type == CrusadeGroupTownLayerType.TownList then
            local vec_children = self.layer.layer_town_list.scroll_view.menu:getChildren()
            -- 刷新時間顯示
            for _,cell in ipairs(vec_children) do
                local time = 0
                for _,time_data in pairs(ctr.crusade_group.data.map_giveup) do
                    if time_data.id == cell.data.id then
                        time = time_data.time
                    end
                end
                cell:setGiveUpTime(time > 0 and time - ex.Game:getServerTime() or 0)
            end 
        end
    end
end

-- 职级任务完成回调
function CrusadeGroupTownCtr:onTaskComplete(tag, pSender)
    local req = CrusadeGroupOccupation_pb.GReqOpreaOccupationTask()
    req.taskId = pSender.task_id
    NetManager:sendMessage(ProtocolID.GReqOpreaOccupationTask, req)
end

-- 职级升级回调
function CrusadeGroupTownCtr:onNobilityLevelup(tag, pSender)
    NetManager:sendMessage(ProtocolID.GReqOccupationUp)
end

-- 城镇开垦回调
function CrusadeGroupTownCtr:onTownFarm(tag, pSender)
    -- 打开英雄选择界面选择英雄进行开垦
    require("src.layer.crusadegroup.CrusadeGroupTownInfoCtr"):instance():openWindow(pSender.town_id)
end

-- 城镇放弃回调
function CrusadeGroupTownCtr:onTownGiveup(tag, pSender)
    local time = 0
    for _,time_data in pairs(ctr.crusade_group.data.map_giveup) do
        if time_data.id == pSender.town_id then
            time = time_data.time
        end
    end
    if time <= 0 then
        ex.ConfirmCtr:openWindow(ex.Tools:getLang(77635), ex.Tools:getLang(77636), function()
            ctr.crusade_group:addGiveupData(pSender.town_id)
        end, ex.Tools:getLang(77637))
    else
        ctr.crusade_group:removeGiveupData(pSender.town_id)
        ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATE_GIVEUP_REVOKE, pSender.town_id)
    end
end

-- 城镇查找回调
function CrusadeGroupTownCtr:onTownFind(tag, pSender)
    ex.EventManager:fire(EVENT.CRUSADE_GROUP.SET_MAP_FOCUS_ID_ANIM, pSender.town_id)
    self:closeWindow(0, nil)
end

return CrusadeGroupTownCtr