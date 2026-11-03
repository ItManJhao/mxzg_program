--[[
* @Description: 端午节活动界面一：龙舟任务
* @Author: 熊梦
* @Date: 2020-06-13 17:45:00
* ]]

local PROMDragonBoatTaksLayer = class("PROMDragonBoatTaksLayer", require("src.layer.promotion.PromotionBaseLayer"))
local PROMDragonBoatTaksCell = class("PROMDragonBoatTaksCell", require("src.layer.promotion.PromotionBaseLayer"))
-----------------------------------------------------------------------
function PROMDragonBoatTaksCell:onCreate()
	self:setAutoClose(false)
    self:setSwallowTouches(false)
end


function PROMDragonBoatTaksCell:initData(data)
    self.idx = data.idx
    self.jump_info = data.jump_info
    self.lbl_taks_name = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(22)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#7A472D")
    :setScale(1)
    :setPosition(18,113)
    :setAnchorPoint(ex.a.zero)

    if data.condition~= -1 then
        self.lbl_taks_name:setXmlTextLua(ex.Tools:taskString(data.name_lang, data.target, data.condition))
    else
        self.lbl_taks_name:setXmlTextLua(ex.Tools:taskString(data.name_lang, data.target))
    end

    self.node_lbl:addChild(self.lbl_taks_name)

    for i,v in ipairs(data.task_reward) do
        local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
        item:registerScriptTapHandler(handler(self, self.onItemInfo))
        item:setPosition(18+(i-1)*100,50)
        item:setScale(0.8)
        self.menu:addChild(item)
    end

    self.lbl_taks_num:setString(string.format("(%s/%s)",tostring(data.progress),tostring(data.target)))

    self.progress = data.progress
    self.target = data.target

    if data.progress >= data.target then
        if data.iscomplete == 0 then
            self.btn_goto:setVisible(false)
            self.btn_done:setVisible(true)
            -- 固定死的红点
            ex.Tools:addRedPoint(self.btn_done, true, cc.p(0.95, 0.85))
        else
            self.btn_goto:setVisible(false)
            self.btn_done:setVisible(false)
            self.spr_geted:setVisible(true)
        end
    else
        self.btn_goto:setVisible(true)
        self.btn_done:setVisible(false)
    end
end

function PROMDragonBoatTaksCell:onGoto(event, sender)
    -- 回调函数
    local backToLayer =  function ( layer )
        -- require("src.layer.MainTaskCtr"):instance():openWindow()
        -- cfg.funcopen["act_limit_time_server"].open()
        local vec_idx = ex.Player.promotion_data:getPromotionByType(PromotionPageType.LIMIT_TIME_SERVER_ACTIVITY)
        local select_idx = ActivityPanelIdxType.BUY_DRAGONBOAT
        -- for i,v in ipairs(vec_idx) do
        --     if v.idx == ActivityPanelIdxType.BUY_DRAGONBOAT then
        --         select_idx = i.idx
        --         break
        --     end
        -- end
        if layer ~= nil then
            layer:initWithTable(nil, vec_idx, 707,{}, 1)
        end
    end
    local params = {}
    params.backToLayer = backToLayer

    ex.JumpManager:jumpByAtom(self.jump_info.event_arg,params)
end


function PROMDragonBoatTaksCell:onDone(event, sender)
    if  self.progress < self.target then
        ex.MessageView:add(ex.Tools:getLang(41262))
        return
    end
    sender:setEnabled(false)
    local req = Promotion064_pb.GReqGetTaskReward()
    req.idx = self.idx
    NetManager:sendMessage(ProtocolID.GReqGetTaskReward, req)
end

function PROMDragonBoatTaksCell:onItemInfo(event, sender)
    ex.Tools:onClickItemInfo(sender.item_type)
end

function PROMDragonBoatTaksCell:onCollect(event, sender)


end
--------------------------------------------------------------------------------------------
function PROMDragonBoatTaksLayer:onCreate()
	self:setAutoClose(false)
    self:setSwallowTouches(false)


    self.node_point:setPositionY(self.node_point:getPositionY() - require("src.model.Game"):instance():getNotchHeight())
    self.node_bg:setPositionY(self.node_bg:getPositionY() - require("src.model.Game"):instance():getNotchHeight())


    
    self.scroll_view:setItemSize(cc.size(550, 155))
    self.scroll_view:setItemType(1)


    self.lbl_taks_name = cc.Label:createWithTTF(ex.Tools:getLang(70612),FONT_DEFAULT_NAME_BOLD,18)
    self.lbl_taks_name:setColor(cc.c3b(253,228,181,255))
    self.lbl_taks_name:enableOutline(cc.c3b(87,56,29),2)
    self.lbl_taks_name:setLocalZOrder(1)
    self.lbl_taks_name:setPositionY(-35)
    self.node_total_point:addChild(self.lbl_taks_name)

    self.eff = {}
    self:createProgress()
    self:createBox()
    self:updataCell()
    self:registerEvent()


end


function PROMDragonBoatTaksLayer:updataCelldata(event,data)
    ex.Player.promotion_data.promotiondragonboattaskinfo_value.reward_ids = data.reward_ids
    self:updataCell()
    self:createBox()
end

function PROMDragonBoatTaksLayer:updataTask(event,data)
    self:updataCell()
    self:createBox()
end

function PROMDragonBoatTaksLayer:onBoxRewardResult(event,data)
    ex.Player.promotion_data.promotiondragonboattaskinfo_value.box_rewards = data.box_rewards
    self:createBox()
end

function PROMDragonBoatTaksLayer:registerEvent()
    self:addEvent(EVENT.PROMOTION_DRAGON_BOAT.RECEIVE_TASK_REWARD,handler(self,self.updataCelldata))
    self:addEvent(EVENT.PROMOTION_DRAGON_BOAT.BOX_REWARD_UPDATE,handler(self,self.onBoxRewardResult))
    self:addEvent(EVENT.PROMOTION_DRAGON_BOAT.TASK_UPDAYTE,handler(self,self.updataTask))
end

function PROMDragonBoatTaksLayer:createBox()

    if self.menu == nil then
        self.menu = cpp.UIMenu:create()
        self.menu:setSwallowsTouches(false)
        self.menu:setPosition(0,0)
        self.spr_progress_bg:addChild(self.menu)
    end

    self:removeAllBoxEff()
    self.menu:removeAllChildren()
    
    local width = self.spr_progress_bg:getContentSize().width
    self.lbls = {}

    local data = self:arrangementData()
    local vec_progress_data = {}

    self.max_point = 0

    for k,v in pairs(data) do
        if v.task_count > self.max_point then self.max_point = v.task_count end
    end
    local ratio = width 
    --local cur_point = ex.Player.seventdaytarget_data:getPoint()
    --print("cur_point", cur_point)
    for i=1,#data do
        local flag = data[i].flag
        local status = data[i].isget
        local idx 
        if i == 1 then 
        	idx =1 
        elseif #data == i then 
        	idx = 4
        else 
        	idx = 2
        end
        local str = (status < 1 and not flag) and "other/spr-box-" .. idx ..".png" or "other/spr-box-open-" .. idx ..".png"
        local box = cpp.UIMenuItemImage:createWithSpriteFrameName(str,str,str)
        box:registerScriptTapHandler(handler(self, self.onClickBox))
        box.idx = data[i].idx
        box:setTag(i)
        local posX = i / #data -- ratio * data[i].task_count 
        local posY = 0 
        self.menu:addChild(box)
        box:setPosition(posX * ratio, posY + 10)

        local spr_effect = nil
        if flag then
            self:createBoxEff(box,flag)
             -- 固定死的红点
             ex.Tools:addRedPoint(box, true, cc.p(0.95, 0.85))
        end
        
        self.lbls[i] = cc.Label:createWithTTF(string.format(ex.Tools:getLang(75103),data[i].task_count),FONT_DEFAULT_NAME_BOLD,18)
        self.spr_progress_bg:addChild(self.lbls[i])
        self.lbls[i]:setColor(cc.c3b(253,228,181,255))
        self.lbls[i]:enableOutline(cc.c3b(87,56,29),2)
        self.lbls[i]:setPosition(posX * ratio, posY - 25)
        self.lbls[i]:setLocalZOrder(1)
        table.insert(vec_progress_data, {pos = posX * 100, count = data[i].task_count })
    end
    self.menu:setLocalZOrder(1)
    self.progressTimer:setPositionList(vec_progress_data)
    self.progressTimer:setPercentageCount(#ex.Player.promotion_data.promotiondragonboattaskinfo_value.reward_ids)
end

function PROMDragonBoatTaksLayer:createProgress()
    self.progressTimer = require("src.comp.UIProgressTimerEquidistant"):create(cc.Sprite:createWithSpriteFrameName("prom-dragonboat/spr-jdt2.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setScaleX(self.spr_progress_bg:getScaleX())
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.spr_progress_bg:addChild(self.progressTimer)
    self.progressTimer:setPosition(self.spr_progress_bg:getContentSize().width / 2 - 8 ,self.spr_progress_bg:getContentSize().height / 2 )
end

function PROMDragonBoatTaksLayer:onClickBox(tag , pSender)
    -- body
    local data_list = self:arrangementData()

	local data = data_list[tag]
    local can_get = data.flag
    local function callback()
        -- 点击领取BOX
        local req = Promotion064_pb.GReqGetBoxReward()
        req.idx = pSender.idx
        NetManager:sendMessage(ProtocolID.GReqGetBoxReward, req)
    end
    data.reward = data.box_reward
	require("src.layer.SevenTargetRewardInfoCtr"):instance():openWindow(data, can_get, callback)
end

function PROMDragonBoatTaksLayer:createBoxEff(box,open)
    local effId = open and 11 or 10
    local x = open and box:getContentSize().width / 2 - 3 or box:getContentSize().width / 2
    local y = open and box:getContentSize().height / 2 - 12 or box:getContentSize().height / 2
    local tag = box:getTag()
    if open then 
        print(x,y)
    end
    self.eff[tag] = ex.EffectCtr:playNormalEff(effId,x,y,nil,box,10)
    self.eff[tag]:setAnchorPoint(0.5,0)
end

function PROMDragonBoatTaksLayer:removeAllBoxEff()
    local items = self.menu:getChildren()
    for k,v in pairs(items) do
        local tag = v:getTag()
        if self.eff[tag] ~= nil then 
            self.eff[tag]:remove()
            self.eff[tag] = nil
        end
    end
end

function PROMDragonBoatTaksLayer:arrangementData()
    local data = {}
    -- day_turns：轮数 天数
    local day_turns = ex.Player.promotion_data.promotiondragonboattaskinfo_value.day_turns
    -- box_rewards：已经领取的宝箱
    local box_rewards = ex.Player.promotion_data.promotiondragonboattaskinfo_value.box_rewards
    -- task_count: 已经完成的任务个数
    local task_count = #ex.Player.promotion_data.promotiondragonboattaskinfo_value.reward_ids
    for k,v in ipairs(cfg.promotiondragonboatboxreward.promotiondragonboatboxreward) do
        if v.day_turns == day_turns then
            v.isget = 0
            v.flag = false
            for i,h in ipairs(box_rewards) do
                if v.idx == h then
                    v.isget = 1
                    break
                end
            end 
            if v.isget == 0 then
                if v.task_count <= task_count then
                    v.flag = true
                end
            end
            table.insert( data, v )
        end
    end

    local function sort_table (a,b)
        return a.idx < b.idx
    end
    table.sort( data, sort_table )
    
    return data
end

function PROMDragonBoatTaksLayer:updataCell()
    -- day_turns：轮数 天数
    local day_turns = ex.Player.promotion_data.promotiondragonboattaskinfo_value.day_turns

    -- 任务进度
    local task_list = ex.Player.promotion_data.promotiondragonboattaskinfo_value.task_list

    -- 已经完成的任务
    local reward_ids = ex.Player.promotion_data.promotiondragonboattaskinfo_value.reward_ids

    self.progressTimer:setPercentageCount(#reward_ids)
  
    local table_list = {}
    for i,v in ipairs(cfg.promotiondragonboattask.promotiondragonboattask) do
        local data = {}
        if day_turns == v.day_turns then
            data.task_reward = v.task_reward
            data.target = v.task_target.target
            data.name_lang = v.lang
            data.idx = v.idx
            data.iscomplete = 0
            data.condition = v.condition~=nil and v.condition or -1
            data.jump_info = v.jump_info
            for k,h in ipairs(task_list) do
                if h.idx == data.idx then
                    data.progress = h.progress  
                    break         
                end
            end
            for o,p in ipairs(reward_ids) do
                if p == data.idx then
                    data.iscomplete = 1
                    break         
                end
            end
            -- 充值类型除100倍
            if v.task_target.type == "RECHARGE" then
                data.target = tonumber( data.target ) * 0.01
                data.progress = tonumber( data.progress ) * 0.01
            end
            table.insert( table_list, data )
        end
    end

    self.scroll_view.createItemFunction = function(data, scale)
        -- 创建ccbi cell
        local cell_layer = PROMDragonBoatTaksCell:createWithCCBIFile("ccbi/PROMDragonBoatTaksCell.ccbi")
        cell_layer:setIgnoreAnchorPointForPosition(false)
        cell_layer:setAnchorPoint(0.5, 0.5)

        cell_layer:initData(data)

        return cell_layer
    end

    -- 完成度排序 可以領取的放在最上面 已經領取的放在最下面 其餘的按照活動id排序
    local function sort_table (a,b)
        local astatus = a.iscomplete
        local bstatus = b.iscomplete
        local aprogress = a.progress>=a.target and 0 or 1
        local bsprogress = b.progress>=b.target and 0 or 1
        
        if astatus == bstatus then
            if aprogress == bsprogress then
                return a.idx < b.idx
            else
                return aprogress < bsprogress
            end
        else 
            return astatus < bstatus
        end 
    end 

    table.sort( table_list, sort_table )
        
    self.scroll_view:reloadData(table_list)

end


return PROMDragonBoatTaksLayer
