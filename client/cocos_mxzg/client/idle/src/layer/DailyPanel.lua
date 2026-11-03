local DailyPanel = class("DailyPanel", require("src.comp.EventLayer"))

local EFFECT_SPRITE_TAG = 20031

--------------------------------------------

function DailyPanel:onCreate()
    self:setSwallowTouches(false)
    self:setAutoClose(false)

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/daily-reward-effect.plist")
end

function DailyPanel:initWithContentSize(size) 
    -- self:testData()
    local cur_content_size = size
    self:setContentSize(cur_content_size)

    self:_setUINodePosition(self.spr_progress_bg)
    self:_setUINodePosition(self._bg)
    self:_setUINodePosition(self._taskIcon)
    self:_setUINodePosition(self._progTipsBg)
    self:_setUINodePosition(self._iconContainer)
    self:_setUINodePosition(self._progTextContainer)
    
    -- self.cell_data = cfg.dailytaskmain.daily
    self:editData(cfg.dailytaskmain.daily)
    
    -- self.tableView = self:initTableView(self.cell_data, {require("src.layer.DailyCell"),"ccbi/AchievementCell.ccbi"} , cc.size(488,395), 5)
    self.tableView = ex.Tools:initTableView(self,self.cell_data, {require("src.layer.DailyCell"),"ccbi/DailyCell.ccbi"} , cc.size(cur_content_size.width, cur_content_size.height - 5), 5 , cc.p(8,5))

    self:createProgress()
    self:createBox()
    self:registerEvent()
end

function DailyPanel:editData( data )
    -- body
    self.cell_data = {}
    local achievement_data = ex.Player.achievement_data

    for k,v in pairs(data) do
        if ex.Player.level >= v.open_level then 
            local tmp_data = clone(v)
            tmp_data.server_data = achievement_data:getDailyServerDataById(tmp_data.idx)
            tmp_data.is_red = achievement_data:getDailyIsRedById(tmp_data.idx)
            table.insert(self.cell_data, tmp_data)
        end
    end
    local function sor(a, b)
        local proA = a.server_data.state == 1 and 0 or 50
        local proB = b.server_data.state == 1 and 0 or 50
        proA = a.is_red and 100 or proA
        proB = b.is_red and 100 or proB
        if proA ~= proB then return proA > proB end 
        return a.idx < b.idx
    end
    table.sort(self.cell_data, sor)
end

function DailyPanel:createProgress()
    self.progressTimer = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("achievement/total-progress.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setScaleX(1)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.spr_progress_bg:addChild(self.progressTimer)
    self.progressTimer:setPosition(self.spr_progress_bg:getContentSize().width / 2 ,self.spr_progress_bg:getContentSize().height / 2 )
    self:updateProgress()
end

function DailyPanel:updateProgress()
    local point = ex.Player.achievement_data:getDailyPoint()
    local config = cfg.dailytaskpoint.box
    local max = 0 
    for k,v in pairs(config) do
        if v.point > max then 
            max = v.point
        end
    end
    local percent = point / max * 100
    if percent > 100 then percent = 100 end
    self.progressTimer:setPercentage(percent)
    self.lbl_act_point:setString(tostring(percent))
end

function DailyPanel:createBox()
    self.menu = cpp.UIMenu:create()
    self.menu:setSwallowsTouches(false)
    self.spr_progress_bg:addChild(self.menu)
    self.menu:setPosition(0,0)
    local width = self.spr_progress_bg:getContentSize().width
    local ratio = width / 100
    self.boxes = {}
    self.lbls = {}
    local data = cfg.dailytaskpoint.box
    local point = ex.Player.achievement_data:getDailyPoint()
    for i=1,#data do
        local rewardData = cfg.dailytaskpoint.box[i]
        local rewardInfos = rewardData.reward
        local reward = rewardInfos[1]

        local path = string.format("backpack/%d.png", reward.item_type)
        local item = cpp.UIMenuItemImage:createWithSpriteFrameName(path, path, path)
        item:setTag(i)
        local iconPointer = self['_iconPointer' .. i]
        
        local menu = cpp.UIMenu:create()
        menu:setSwallowsTouches(false)
        iconPointer:addChild(menu)
        menu:setPosition(0,0)
        menu:addChild(item)

        local scale = 48 / item:getContentSize().width
        item:setScale(scale)

        local iconNum = self['_iconNum' .. i]
        iconNum:setVisible(true)
        iconNum:setString('x' .. reward.item_num)

        item:registerScriptTapHandler(handler(self, self.onClickBox))

        local geted = ex.Player.achievement_data:checkBoxIsGeted(i)
        local flag = point >= data[i].point

        if not geted then
            if flag then
                local effSpr = EffectFactory.createSprite('daily-reward-effect/%d.png', 0.1, {
                    isForever = true
                })
                effSpr:setTag(EFFECT_SPRITE_TAG)
                iconPointer:addChild(effSpr)
            end
        else
            cpp.ShaderFactory:instance():setAllChildren(iconPointer, ShaderType.ST_POSITION_TEXTURE_GRAY or ShaderType.ST_POSITION_TEXTURE_DEFAULT)
        end

        -- local geted = ex.Player.achievement_data:checkBoxIsGeted(i)
        -- local flag = point >= data[i].point
        -- local str = (not geted and flag == false) and "other/spr-box-" .. i ..".png" or "other/spr-box-open-" .. i ..".png"
        -- self.boxes[i] = cpp.UIMenuItemImage:createWithSpriteFrameName(str,str,str)
        -- self.boxes[i]:registerScriptTapHandler(handler(self, self.onClickBox))
        -- self.boxes[i]:setTag(i)
        -- local posX = ratio * data[i].point 
        -- local posY = 0 
        -- self.menu:addChild(self.boxes[i])
        -- self.boxes[i]:setPosition(posX, posY + 10)

        -- local spr_effect = nil
        -- if not geted then
        --     if flag == false then
        --         spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_box_unopen")
        --         spr_effect:setPosition(self.boxes[i]:getContentSize().width / 2, self.boxes[i]:getContentSize().height / 2)
        --         spr_effect:setAnchorPoint(cc.p(0.5, 0))
        --         self.boxes[i]:addChild(spr_effect, 10, 10)
        --     else
        --         spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_box_open")
        --         spr_effect:setPosition(self.boxes[i]:getContentSize().width / 2 - 3, self.boxes[i]:getContentSize().height / 2 - 12)
        --         spr_effect:setAnchorPoint(cc.p(0.5, 0))
        --         self.boxes[i]:addChild(spr_effect, 10, 10)
        --     end
        -- end
    end
    self.menu:setLocalZOrder(1)
end

function DailyPanel:onClickBox(tag , pSender)

    local data = cfg.dailytaskpoint.box
    local geted = ex.Player.achievement_data:checkBoxIsGeted(tag)
    local point = ex.Player.achievement_data:getDailyPoint()

    local function callback()
        local req_daily_box = Achievement_pb.GReqDailyTaskBoxGetReward()
        req_daily_box.box_id = tag
        NetManager:sendMessage(ProtocolID.GReqDailyTaskBoxGetReward,req_daily_box)
    end

    if point >= data[tag].point and not geted then
        callback(data[tag].idx, pSender)
    else
        require("src.layer.SevenTargetRewardInfoCtr"):instance():openWindow(data[tag],point >= data[tag].point and not geted,callback)
    end
end

function DailyPanel:registerEvent()
    self:addEvent(EVENT.ACHIEVEMENT_EVENT.DAILY_REWARD_RESULT,handler(self,self.updateList))
    -- self:addEvent(EVENT.ACHIEVEMENT_EVENT.DAILY_BOX,handler(self,self.updateBox))
    self:addEvent(EVENT.ACHIEVEMENT_EVENT.DAILY_DATA,handler(self,self.updateList))
end

function DailyPanel:updateBox(event,data)
    print("DailyPanel:updateBox")

    if self.menu == nil then 
        self.menu = cpp.UIMenu:create()
        self.menu:setSwallowsTouches(false)
        self.spr_progress_bg:addChild(self.menu)
        self.menu:setPosition(0,0)
    else
        self.menu:removeAllChildren()
    end

    local width = self.spr_progress_bg:getContentSize().width
    local ratio = width / 100
    local data = cfg.dailytaskpoint.box
    local point = ex.Player.achievement_data:getDailyPoint()
    for i=1,#data do
        -- local geted = ex.Player.achievement_data:checkBoxIsGeted(i)
        -- local flag = point >= data[i].point
        -- local str = (not geted and flag == false) and "other/spr-box-" .. i ..".png" or "other/spr-box-open-" .. i ..".png"
        -- self.boxes[i] = cpp.UIMenuItemImage:createWithSpriteFrameName(str,str,str)
        -- self.boxes[i]:registerScriptTapHandler(handler(self, self.onClickBox))
        -- self.boxes[i]:setTag(i)
        -- local posX = ratio * data[i].point 
        -- local posY = 0 
        -- self.menu:addChild(self.boxes[i])
        -- self.boxes[i]:setPosition(posX, posY + 10)

        -- if not geted then
        --     local spr_effect = nil
        --     if flag == false then
        --         spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_box_unopen")
        --         spr_effect:setPosition(self.boxes[i]:getContentSize().width / 2, self.boxes[i]:getContentSize().height / 2)
        --         spr_effect:setAnchorPoint(cc.p(0.5, 0))
        --         self.boxes[i]:addChild(spr_effect, 10, 10)
        --     else
        --         spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_box_open")
        --         spr_effect:setPosition(self.boxes[i]:getContentSize().width / 2 - 3, self.boxes[i]:getContentSize().height / 2 - 12)
        --         spr_effect:setAnchorPoint(cc.p(0.5, 0))
        --         self.boxes[i]:addChild(spr_effect, 10, 10)
        --     end
        -- end

        local iconPointer = self['_iconPointer' .. i]

        local geted = ex.Player.achievement_data:checkBoxIsGeted(i)
        local flag = point >= data[i].point

        if geted then
            iconPointer:removeChildByTag(EFFECT_SPRITE_TAG)
            cpp.ShaderFactory:instance():setAllChildren(iconPointer, ShaderType.ST_POSITION_TEXTURE_GRAY or ShaderType.ST_POSITION_TEXTURE_DEFAULT)
        else
            if flag then
                local effSpr = iconPointer:getChildByTag(EFFECT_SPRITE_TAG)
                if not effSpr then
                    local effSpr = EffectFactory.createSprite('daily-reward-effect/%d.png', 0.1, {
                        isForever = true
                    })
                    effSpr:setTag(EFFECT_SPRITE_TAG)
                    iconPointer:addChild(effSpr)
                end
            end
        end
    end
end

function DailyPanel:updateList(event,data)
    if not self.tableView then return end
    -- print(self.__cname,event)
    local offsetY = self.tableView:getContainer():getPositionY()
    self:editData(cfg.dailytaskmain.daily)
    -- self.tableView:reloadData()
    self.tableView:initData(self.cell_data)
    self.tableView:setContentOffset(cc.p(0,offsetY))
    self:updateProgress()
    self:updateBox()
end

function DailyPanel:onExit()
    -- self:removeTimer()
end

function DailyPanel:removeEvent()
    if self.event_list ~= nil then 
        for k,v in pairs(self.event_list) do
            ex.EventManager:remove(v)
        end
    end
end

function DailyPanel:_setUINodePosition(node)
    local offsetX = 8
    local offsetY = 0

    local cur_content_size = self:getContentSize()

    node:setPosition(
        node:getPositionX() + offsetX,
        node:getPositionY() + cur_content_size.height + offsetY
    )
end

return DailyPanel
