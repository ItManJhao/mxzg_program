local SevenDayTargetLayer = class("SevenDayTargetLayer", require("src.comp.EventLayer"))
-- local TIME = 100000
local TARGET_ITEM = require("src.comp.menu.UIMenuItemSeventTarget")

local redValue = {1006100,1006200,1006300,1009700}

function SevenDayTargetLayer:getAsynImage()
    local vec_image = {
        {image_name = "ccbi-res/map-bg-seven-day-target-1.jpg", remove_type=1},
    }
    return vec_image
end

function SevenDayTargetLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/box-effect.plist")
    
    self.eff = {}

    self.cur_day = ex.Player.seventdaytarget_data.seven_day_target_list.curr_day -- 第几天
    self.cur_tag = 1                                -- 选中活动标签 一共有4个  默认选中第一个
    self.max_task = #ex.Player.promotion_data.promotion7daytarget_value -- 最大的活动数量
    self.select_day = self.cur_day -- 第几天

    local win_size = cc.Director:getInstance():getWinSize()
    self.data = ex.Player.seventdaytarget_data:getDayCfg()
    self.cur_data = ex.Player.seventdaytarget_data.seven_day_target_list.list[self.cur_day]
    self:createTargetItem()

    if win_size.width < 640 then
        self.node_point:setScaleX(win_size.width / self.node_point:getContentSize().width)
    end
    self.node_point:setPositionX(self:getContentSize().width / 2)

    ex.Player.seventdaytarget_data:setSaveSelectDay(self.cur_day)
    ex.Player.seventdaytarget_data:setSaveSelectItem(self.cur_tag)

    self.spr_bg:setScaleX(win_size.width / self.spr_bg:getContentSize().width)
    self.spr_bg:setScaleY(win_size.height / self.spr_bg:getContentSize().height)
    self.welfare_panel = require("src.layer.SevenDayWelfarePanel"):create()
    self.task_panel = require("src.layer.SevenDayTargetPanel"):create()        
    self.reward_ctr = require("src.layer.SevenDayTargetRewardCtr"):instance()  -- 无用

    local bottom_y = ex.MainSceneCtr:getBottomHeight()
    -- self.spr_content:setContentSize(cc.size(self.spr_content:getContentSize().width, self.node_bg:getPositionY() - (90) - bottom_y))
    -- self.spr_yellow_bg:setContentSize(self.spr_content:getContentSize().width + 30, self.spr_content:getContentSize().height + 35)

    self.spr_content:addChild(self.task_panel)
    self.task_panel:setPosition(0,0)
    self:editTableViewData(self.cur_data[1])
    self.task_panel.tableView:initData(self.cur_data[1])
    self.task_panel.tableView:setViewSize(cc.size(self.spr_content:getContentSize().width - 10, self.spr_content:getContentSize().height - 10))


    self.spr_content:addChild(self.welfare_panel)
    self.welfare_panel:setPosition(0,0)
    self:editTableViewData(self.cur_data[4])
    self.welfare_panel.tableView:initData(self.cur_data[4])
    self.welfare_panel.tableView:setViewSize(cc.size(self.spr_content:getContentSize().width - 10, self.spr_content:getContentSize().height - 10))

    self:showPanel(self.cur_tag) --  显示选中的活动   此时self.cur_tag 为默认值为1 即默认显示第一个活动

    -- 播放动画 spine
    local amin = sp.SkeletonAnimation:create("spine/10310007.json","spine/10310007.atlas", 1)
    amin:setAnimation(0, "stand", true);
    amin:setPosition(0,0)
    amin:setScaleX(0.7 * 1.42)
    amin:setScaleY(0.7 * 1.42)
    self.girl_node:addChild(amin)


    self:updateTime()
    self:createTabBtn()
    self:createProgress()
    self:createBox()
    self:addTimer("time",1000,handler(self,self.updateTime),true)
    self.lbl_task_num:setString(0)
    self.btn_back:setPositionY(self.btn_back:getPositionY() - require("src.model.Game"):instance():getNotchHeight() + 25)
    self.btn_back:registerScriptTapHandler(handler(self,self.onBack))

    self.lbl_task_num:setString(tostring(ex.Player.seventdaytarget_data:getPoint()))
    self:registerEvent()
end

function SevenDayTargetLayer:editTableViewData(data)
    -- self.cur_day[tag]
    local function sor(a,b)
        
        local astate = a.process >= a.task.targetNum and 1 or 0 
        local bstate = b.process >= b.task.targetNum and 1 or 0

        if a.state ~= b.state then  
            return a.state < b.state
        else 
            if astate ~= bstate then 
                return astate > bstate
            else 
                return a.idx < b.idx
            end 
        end 
    
    end
    table.sort(data,sor)
end

function SevenDayTargetLayer:registerEvent()
    self:addEvent(EVENT.SEVEN_TARGET_DATA_EVENT.UPDATE_SEVEN_DAY_DATA,handler(self,self.updateSevenDayData))
    self:addEvent(EVENT.SEVEN_TARGET_DATA_EVENT.REWARD_RESULT,handler(self,self.onRewardResult))
    self:addEvent(EVENT.SEVEN_TARGET_DATA_EVENT.BOX_REWARD_RESULT,handler(self,self.onBoxRewardResult))
    self:addEvent(EVENT.SEVEN_TARGET_DATA_EVENT.UPDATE_SEVEN_DAY_TARGET_END,handler(self,self.onEnd))
    self:addEvent(EVENT.SEVEN_TARGET_DATA_EVENT.UPDATE_SEVEN_DAY_TARGET_CHANGE,handler(self,self.onChange))
end

function SevenDayTargetLayer:onChange(event,day)
    self.cur_day = day
    local items = self.menu_target:getChildren()
    for k,v in pairs(items) do
        local tag = v:getTag()
        v:setEnabled(tag <= self.cur_day)
        v:setGrayed(tag > self.cur_day)
        local red = self:checkDayRedPoint(v:getTag())
        ex.Tools:addRedPoint(v,red, ex.r.p8)
    end
    -- local red_poins = ex.Player.seventdaytarget_data:getDayRedPoint(self.cur_day)
    -- local reddot_manager = ex.RedDotManager
    -- for i=1,#self.tabs do
    --     if i < 4 then 
    --         local red_id = 1006000
    --         red_id = red_id + i * 100
    --         reddot_manager:setRedNodeVisible(red_id,red_poins[i] == true)
    --     end
    -- end
end

function SevenDayTargetLayer:onEnd(event,data)
    ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
end

function SevenDayTargetLayer:onBoxRewardResult(event,data)
    -- self.reward_ctr:openWindow(data)
    self:removeAllBoxEff()
    self.menu:removeAllChildren()
    local width = self.spr_progress_bg:getContentSize().width
    local data = ex.Player.promotion_data.promotion7daytargetpoint_value

    local ratio = width / self.max_point
    
    local cur_point = ex.Player.seventdaytarget_data:getPoint()

    for i=1,#data do
        local status = ex.Player.seventdaytarget_data:getSevenDayBox(data[i].idx)
        local idx 
        if i == 1 then 
            idx =1 
        elseif #data == i then 
            idx = 4
        else 
            idx = 2
        end
        
        local flag = cur_point >= data[i].task_num

        local str = (status < 1 and flag == false) and "other/spr-box-" .. idx ..".png" or "other/spr-box-open-" .. idx ..".png"
        local box = cpp.UIMenuItemImage:createWithSpriteFrameName(str,str,str)
        box:registerScriptTapHandler(handler(self, self.onClickBox))
        box:setTag(i)
        local posX = ratio * data[i].task_num 
        local posY = 0 
        self.menu:addChild(box)
        box:setPosition(posX, posY + 10)

        local spr_effect = nil
        if status < 1 then
            self:createBoxEff(box,flag)
        end
    end

end

function SevenDayTargetLayer:createBoxEff(box,open)
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

function SevenDayTargetLayer:removeAllBoxEff()
    local items = self.menu:getChildren()
    for k,v in pairs(items) do
        local tag = v:getTag()
        if self.eff[tag] ~= nil then 
            self.eff[tag]:remove()
            self.eff[tag] = nil
        end
    end
end

function SevenDayTargetLayer:onRewardResult(event,data)
    -- self.reward_ctr:openWindow(data)
    local tableView = self.cur_tag == 4 and self.welfare_panel.tableView or self.task_panel.tableView
    self:updateTableView(tableView)
    self.lbl_task_num:setString(tostring(ex.Player.seventdaytarget_data:getPoint()))
    self.progressTimer:setPercentage(ex.Player.seventdaytarget_data:getPoint() / self.max_point * 100)

    local red_poins = ex.Player.seventdaytarget_data:getDayRedPoint(self.select_day)
    local reddot_manager = ex.RedDotManager
    for i=1,#self.tabs do
        if i < 5 then 
            -- local red_id = 1006000
            -- red_id = red_id + i * 100
            local red_id = redValue[i]
            reddot_manager:setRedNodeVisible(red_id,red_poins[i] == true)
        end
    end

    local type_red = ex.Player.seventdaytarget_data:getSevenDayRedPoint()
    local box_red = ex.Player.seventdaytarget_data:getBoxRedPoint()
    local red = type_red or box_red
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZCQTMB, red)
    for k,v in pairs(self.day_items) do
        if v:getTag() <= self.cur_day then 
            local red = self:checkDayRedPoint(v:getTag())
            ex.Tools:addRedPoint(v,red, ex.r.p8)
        end 
    end

    self:onBoxRewardResult()
end

function SevenDayTargetLayer:updateSevenDayData(event,tag)
    if tag ~= self.cur_tag then return end
    local tableView = self.cur_tag == 4 and self.welfare_panel.tableView or self.task_panel.tableView
    self:updateTableView(tableView)
end

function SevenDayTargetLayer:updateTableView(tableView)

    local offsetY = tableView:getContainer():getPositionY()
    local data = self.cur_data[self.cur_tag]

    self:editTableViewData(data)
    tableView:initData(data)
    tableView:setContentOffset(cc.p(0,offsetY))

end

function SevenDayTargetLayer:onBack(tag , pSender)
    if not ex.MainSceneCtr:backLastLayer() then
        ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
    end
end

function SevenDayTargetLayer:createTargetItem()
	self.menu_target = cpp.UIMenu:create()
	self.menu_items:addChild(self.menu_target)
	self.menu_target:setPosition(0,0)
    local margin  = -10
    -- local start_pos_x = -self.spr_yellow_bg:getContentSize().width / 2
    local start_pos_x = 0

    self.menu_items:setPositionX(ex.p.width / 2 - self.spr_yellow_bg:getContentSize().width / 2 + 20)

    self.day_items = {}
	local config = ex.Player.promotion_data.promotion7daytargeticon_value -- 7天展示道具
	for i=1,#config do
		local stardX = start_pos_x
		local stardY = i < 4 and 200 or 30
        local item = TARGET_ITEM:createWithData(config[i])
        item:setEnableAction(false)
		local idx = i < 4 and i + 1 or i - 3
		local posX = math.abs(margin) + (stardX + (idx - 0.5) * item:getContentSize().width * 1.2) + (idx - 0.5) * margin
		self.menu_target:addChild(item)
		item:setPosition(posX,stardY)
        -- item:setScale(1.2)
		item:setTag(config[i].day)
		item:registerScriptTapHandler(handler(self,self.onClickItem))
        item:setEnabled(config[i].day <= self.cur_day)
        item:setSelected(config[i].day == self.cur_day)
        item:setGrayed(config[i].day > self.cur_day)
        self.day_items[i] = item

        if config[i].day <= self.cur_day then 
            local red = self:checkDayRedPoint(config[i].day)
            ex.Tools:addRedPoint(item,red, ex.r.p8)
        end 
        
        -- print("setGrayed",config[i].day > self.cur_day,"setEnabled",config[i].day <= self.cur_day , config[i].day)
	end
	self.cur_data = self.data[self.cur_day]
end

function SevenDayTargetLayer:checkDayRedPoint(day)

    local red_points = ex.Player.seventdaytarget_data:getDayRedPoint(day)
    local red = false
    for k,v in pairs(red_points) do
        if v == true then 
            red = true
            break
        end
    end
    return red
end

function SevenDayTargetLayer:onClickItem(tag , pSender)
    if tag > self.cur_day then return end
    self.cur_data = self.data[tag]
    local items = self.menu_target:getChildren()
    self.select_day = tag

    for i,v in ipairs(items) do
        local tags = v:getTag()
        v:setSelected(tags == tag)
    end
    self.cur_tag = 1
    local data = self.cur_data[self.cur_tag]
    self:editTableViewData(data)

    if self.cur_tag == 4 then 
        self.welfare_panel:updateData(data)
    else
        --local tableView = self.cur_tag == 4 and self.welfare_panel.tableView or self.task_panel.tableView

        self.welfare_panel:setVisible(false)
        self.task_panel:setVisible(true)

        self.task_panel:updateData(data) 
    end

    ex.Player.seventdaytarget_data:setSaveSelectDay(self.select_day)
    local red_poins = ex.Player.seventdaytarget_data:getDayRedPoint(self.select_day)
    local reddot_manager = ex.RedDotManager
    for i=1,#self.tabs do
        if i < 5 then 
            local red_id = redValue[i]
            reddot_manager:setRedNodeVisible(red_id,red_poins[i] == true)
        end
    end

    self:createTabBtn()

    -- for i=1,#self.cur_data do
    --     local str = ex.Tools:getLang(self.cur_data[i][1].tag_lan)
    --     local item = self.menu:getChildByTag(i)
    --     item:setLabelText(str)
    -- end

    -- setLabelText
end

function SevenDayTargetLayer:updateTime(data)
    if self.lbl_time then  
        local time = ex.Player.seventdaytarget_data:getEndTime() - ex.Game:getServerTime()
        if time > 0 then 
    		local d,h,m,s = ex.Tools:formatTime(time)
    		local str = string.format(ex.Tools:getLang(47199),d,h,m,s)
    		self.lbl_time:setString(str)
    		-- self.time = self.time - 1
        else
            self:removeTimerByName("time")
        end
	else
		self:removeTimerByName("time")
	end
end

function SevenDayTargetLayer:createProgress()
    self.progressTimer = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("seven-day-target/spr-progress-2.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setScaleX(self.spr_progress_bg:getScaleX())
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.spr_progress_bg:addChild(self.progressTimer)
    self.progressTimer:setPosition(self.spr_progress_bg:getContentSize().width / 2 ,self.spr_progress_bg:getContentSize().height / 2 )
end

function SevenDayTargetLayer:createBox()
    self.menu = cpp.UIMenu:create()
    self.menu:setSwallowsTouches(false)
    self.spr_progress_bg:addChild(self.menu)
    self.menu:setPosition(0,0)
    self:removeAllBoxEff()
    local width = self.spr_progress_bg:getContentSize().width
    self.lbls = {}
    local data = ex.Player.promotion_data.promotion7daytargetpoint_value
    self.max_point = 0

    for k,v in pairs(data) do
        if v.task_num > self.max_point then self.max_point = v.task_num end
    end
    local ratio = width / self.max_point
    local cur_point = ex.Player.seventdaytarget_data:getPoint()
    --print("cur_point", cur_point)
    for i=1,#data do
        local status = ex.Player.seventdaytarget_data:getSevenDayBox(data[i].idx)
        local flag = cur_point >= data[i].task_num
        local idx 
        if i == 1 then 
        	idx =1 
        elseif #data == i then 
        	idx = 4
        else 
        	idx = 2
        end

        local str = (status < 1 and flag == false) and "other/spr-box-" .. idx ..".png" or "other/spr-box-open-" .. idx ..".png"
        local box = cpp.UIMenuItemImage:createWithSpriteFrameName(str,str,str)
        box:registerScriptTapHandler(handler(self, self.onClickBox))
        box:setTag(i)
        local posX = ratio * data[i].task_num 
        local posY = 0 
        self.menu:addChild(box)
        box:setPosition(posX, posY + 10)

        local spr_effect = nil
        if status < 1 then
            self:createBoxEff(box,flag)
        end

        self.lbls[i] = cc.Label:createWithTTF(data[i].task_num,FONT_DEFAULT_NAME_BOLD,20)
        self.spr_progress_bg:addChild(self.lbls[i])
        -- self.lbls[i]:enableOutline(FONT_BLACK, 2)
        self.lbls[i]:setPosition(posX, posY - 30)
        self.lbls[i]:setLocalZOrder(1)

        self.lbls[i].spr_point_bg = cc.Sprite:createWithSpriteFrameName("seven-day-target/spr-point-bg.png")
        self.lbls[i].spr_point_bg:setScaleX(1.3)
        self.lbls[i].spr_point_bg:setPosition(self.lbls[i]:getContentSize().width / 2, self.lbls[i]:getContentSize().height / 2)
        self.lbls[i]:addChild(self.lbls[i].spr_point_bg, -1)
    end
    self.menu:setLocalZOrder(1)
    self.progressTimer:setPercentage(ex.Player.seventdaytarget_data:getPoint() / self.max_point * 100)
end

function SevenDayTargetLayer:onClickBox(tag , pSender)
    -- body

	local data = ex.Player.promotion_data.promotion7daytargetpoint_value[tag]
    local can_get = data.task_num <= ex.Player.seventdaytarget_data:getPoint() and ex.Player.seventdaytarget_data:getSevenDayBox(data.idx) == 0
    local function callback()
        --    点击领取BOX
        ex.Player.seventdaytarget_data:gReqSevenDayTargetBoxGetReward(data.idx)
    end

	require("src.layer.SevenTargetRewardInfoCtr"):instance():openWindow(data,can_get,callback)
end

function SevenDayTargetLayer:showPanel()
	self.welfare_panel:setVisible(self.cur_tag == 4)
	self.task_panel:setVisible(self.cur_tag ~= 4)
    local data = self.cur_data[self.cur_tag]
    self:editTableViewData(data)
	if self.cur_tag == 4 then 
        self.welfare_panel:updateData(data) 
    else
        self.task_panel:updateData(data) 
    end
    -- dump(self.cur_data[self.cur_tag])
end

function SevenDayTargetLayer:createTabBtn()
	local margin = 0
    local offset = 5
    if self.tab_menu then 
        self.tab_menu:removeFromParent()
        self.tab_menu = nil 
    end
	self.tab_menu = cpp.UIMenu:create()
	self.node_tab:addChild(self.tab_menu)
	self.tab_menu:setPosition(0,0)
    self.tabs = {}
    -- local red_poins = ex.Player.seventdaytarget_data:getCurDayRedPoint()
    local red_poins = ex.Player.seventdaytarget_data:getDayRedPoint(self.select_day)
    local total_width = self.spr_yellow_bg:getContentSize().width - 60
    local diff = total_width / #self.cur_data
    local start_pos_x = -total_width / 2
	for i=1,#self.cur_data do
		local str = ex.Tools:getLang(self.cur_data[i][1].tag_lan)
		-- print(self.__cname,str)
		local item = cpp.UIMenuItemTab:create("button/btn-tab-3.png",
                                              "button/btn-tab-4.png",
                                              str,
                                              1,
                                              nil)
        local item_size = item:getContentSize()
        
        item:setAnchorPoint(0.5, 0)
        -- item:setScale(diff / (item_size.width + 5))

		local posY = 0
		local posX = start_pos_x + diff * (i - 0.5)
        item:setLabelColor(cc.c3b(122,71,45))
        -- item:getLabel():setLabelSize(48)
        item:setLabelOffset(cc.p(0, -3))
        item:setScale(0.9)
        item:setPosition(posX, posY)
        item:setTag(i)
        item:registerScriptTapHandler(handler(self, self.onClickTab))
        item:setChecked(i==1)
        -- item:setLabelScale(0.7,0.7)
        self.tabs[i] = item

        local ttf_config = item:getLabel():getTTFConfig()
        ttf_config.fontSize = 48
        item:getLabel():setTTFConfig(ttf_config)
        
        local reddot_manager = ex.RedDotManager
        if i < 5 then 
            -- local red_id = 1006000
            -- red_id = red_id + i * 100
            local red_id = redValue[i]
            reddot_manager:setStickNode(red_id , item)
            reddot_manager:setRedNodeVisible(red_id,red_poins[i] == true)
        end
        self.tab_menu:addChild(item)
	end
    
end

function SevenDayTargetLayer:onExit()
    self:removeAllBoxEff()
    local reddot_manager = ex.RedDotManager
    for i=1,#self.tabs do
        if i < 5 then 
            -- local red_id = 1006000
            -- red_id = red_id + i * 100
            local red_id = redValue[i]
            reddot_manager:removeStickNode(red_id , self.tabs[i])
        end
    end
end

function SevenDayTargetLayer:onClickTab(tag,pSender)
    if tag == self.cur_tag then return end
    self.cur_tag = tag
    self:showPanel(self.cur_data)
    ex.Player.seventdaytarget_data:setSaveSelectItem(self.cur_tag)

end


return SevenDayTargetLayer
