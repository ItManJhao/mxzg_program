--[[
    func: 国战 - 积分奖励
    版权所有:广州暗耀晶石网络信息科技有限公司
]]
local CountryWarIntegralRewardCtr = class("CountryWarIntegralRewardCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local CountryWarIntegralRewardLayer = class("CountryWarIntegralRewardLayer", require("src.comp.EventLayerAdaptiveWidth"))
local CountryWarIntegralRewardCell = class("CountryWarIntegralRewardCell",require("src.comp.EventLayer"))
local CountryWarIntegralTaskCell = class("CountryWarIntegralTaskCell",require("src.comp.LuaLayerBase"))

---------------------------------------------------CountryWarIntegralTaskCell---------------------------------------------------------
function CountryWarIntegralTaskCell:onCreate()
    self.menu = cpp.UIMenu:create()
    self:addChild(self.menu)
    self.menu:setPosition(0,0)
    self:setBtnString()
    self:createRichTitle()
end

function CountryWarIntegralTaskCell:createRichTitle( )
    local x,y = self.rich_node:getPosition()
    self.lbl_title = cpp.RichTextEx:createWithXMLLua("")
	self.lbl_title:setFontSize(44)
	self.lbl_title:setScale(0.5)
	self.lbl_title:setFontFace(FONT_DEFAULT_NAME_BOLD)
	self.lbl_title:setFontColor("#7A472D")
	self.lbl_title:setAnchorTextShadow(false)
	self.lbl_title:setAnchorPoint(ex.a.left_center)
    self.lbl_title:setPosition(cc.p(x,y))
    self.lbl_title:setLocalZOrder(10)
    self:addChild(self.lbl_title)
end

function CountryWarIntegralTaskCell:setBtnString()
    self.lbl_btn_submit = cc.Label:createWithTTF(ex.Tools:getLang(2214), FONT_DEFAULT_NAME_BOLD, 21)
    self.btn_submit:addChild(self.lbl_btn_submit)
    self.lbl_btn_submit:setPosition(self.btn_submit:getContentSize().width * 0.5, self.btn_submit:getContentSize().height * 0.5)
    self.lbl_btn_submit:enableOutline(FONT_BROWN, 1)
    self.btn_submit:registerScriptTapHandler(handler(self, self.onClickSubmit))
end

--点击领取
function CountryWarIntegralTaskCell:onClickSubmit(tag,pSender)
    ctr.country_war:gReqCountryWarScoreMissionGet(self.data.idx)
end

function CountryWarIntegralTaskCell:resetData(data, item_scroll_view)
    if not data then return end 
    self.data = data

    self.menu:removeAllChildren()
   
    local task_data = ctr.country_war.data:getTaskProgressById(data.idx)
    if not task_data then
        return
    end
    --获取进度判断是否能够可领取
    --不可领取
    if task_data.progress < data.target.target then
        ex.Tools:setAllGrayAuto(self.btn_submit:getNormalImage(), true)
        self.btn_submit:setEnabled(false)
        ex.Tools:addRedPoint(self.btn_submit, false, ex.r.p9)   
    end
    --可领取
    if task_data.progress >= data.target.target and not task_data.reward then
        ex.Tools:setAllGrayAuto(self.btn_submit:getNormalImage(), false)
        self.btn_submit:setEnabled(true)
        ex.Tools:addRedPoint(self.btn_submit, true, ex.r.p9)   
    end
    --已领取
    if task_data.reward then
        self.btn_submit:setVisible(false)
        self.spr_geted:setVisible(task_data.reward)
    end

    local str = ex.Tools:taskString(data.lang,data.target.target,data.target.condition)
    self.lbl_title:setXmlTextLua(str)
    self.lbl_title:formatText()
    ex.Tools:setLimitWidth(self.lbl_title,250)
  
    

    local pos_x,pos_y = self.reward_node:getPosition()
    local base_item = ex.Tools:createBackpackItem(data.reward[1].item_type, data.reward[1].item_num)
    self.menu:addChild(base_item)
    base_item:setPosition(pos_x,pos_y)
    base_item:registerScriptTapHandler(handler(self,self.onBase))
    base_item:setScale(0.7)

    local str = string.format( "(%s/%s)",task_data.progress, data.target.target)
    self.lbl_desc:setString(str)
    self.menu:setIsTouchInsideNode(item_scroll_view)
    self.btn_menu:setIsTouchInsideNode(item_scroll_view)
end

function CountryWarIntegralTaskCell:onBase(tag,pSender)
    ex.Tools:showItemInfo(tag, pSender)
end

---------------------------------------------------CountryWarIntegralRewardCell---------------------------------------------------------
local ITEM_SCALE = 0.8

function CountryWarIntegralRewardCell:onCreate()
    self.menu = cpp.UIMenu:create()
    self:addChild(self.menu)
    self.menu:setPosition(0,0)
end

function CountryWarIntegralRewardCell:setTableView(table)
    self.menu:setIsTouchInsideNode(table)
    self.menu:setSwallowsTouches(false)
end

function CountryWarIntegralRewardCell:resetData(data, reward_scroll_view)
    if not data or not ctr.country_war.data.score_data then return end 
    self.data = data
    self.menu:removeAllChildren()
    self.lbl_level:setString(self.data.level)
    --普通奖励
    local pos_x ,pos_y = self.base_node:getPosition() 
    --是否以领取普通奖励
    local geted = ctr.country_war.data:getIsGetedReward(data.idx)
    local lock = data.level > ctr.country_war.data:getScoreLevel(ctr.country_war.data.score_data.score)
    
    if self.data.finish_reward ~= "" and table.nums(self.data.reward) > 0 then 
        local base_data = self.data.reward[1]
        local base_item = ex.Tools:createBackpackItem(base_data.item_type, base_data.item_num)
        self.menu:addChild(base_item)

        base_item:setPosition(pos_x,pos_y)
        base_item:registerScriptTapHandler(handler(self,self.onBase))
        base_item:setScale(ITEM_SCALE)
        base_item:setSelected(geted)
        if geted then base_item:setGrayed() end 
        local sp_lock = cc.Sprite:createWithSpriteFrameName("new-year/spr-lock.png")
        base_item:addChild(sp_lock)
        sp_lock:setPositionY(base_item:getContentSize().height)
        sp_lock:setVisible(lock)
        sp_lock:setLocalZOrder(1000)
    end

    -- local item_size = base_item:getContentSize()
    local margin = 10
    -- item_size.width = item_size.width * ITEM_SCALE + margin
    -- item_size.height = item_size.height * ITEM_SCALE
    local begin_x  = self.special_node:getPositionX()
    local special_data = self.data.mystery_reward
    local geted = ctr.country_war.data:getIsGetedMysteryReward(data.idx)
    lock = data.level > ctr.country_war.data:getScoreLevel(ctr.country_war.data.score_data.score) or not ctr.country_war.data.score_buy_gem
    if special_data ~= "" then 
        for i,v in ipairs(special_data) do
            local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
            self.menu:addChild(item)
            local item_size = item:getContentSize()
            item_size.width = item_size.width * ITEM_SCALE + margin
            item:registerScriptTapHandler(handler(self,self.onSpecial))
            item:setScale(ITEM_SCALE)
            local x = begin_x + (i - 1) * item_size.width
            item:setPosition(x,pos_y)
            item:setSelected(geted)
            if geted then item:setGrayed() end 

            local sp_lock = cc.Sprite:createWithSpriteFrameName("new-year/spr-lock.png")
            item:addChild(sp_lock)
            sp_lock:setPositionY(item:getContentSize().height)
            sp_lock:setVisible(lock)
            sp_lock:setLocalZOrder(1000)
        end
    end
    self.menu:setIsTouchInsideNode(reward_scroll_view)
    
end

function CountryWarIntegralRewardCell:onBase(tag,pSender)
    if ctr.country_war.data:getScoreLevel(ctr.country_war.data.score_data.score) < self.data.level then 
        ex.Tools:showItemInfo(tag, pSender)
    else
        if not ctr.country_war.data:getIsGetedReward(self.data.idx) then 
            ctr.country_war:gReqCountryWarScoreGet(self.data.idx)
        end 
    end 
end

function CountryWarIntegralRewardCell:onSpecial(tag,pSender)
    local is_lock = not ctr.country_war.data.score_buy_gem
    if is_lock or ctr.country_war.data:getScoreLevel(ctr.country_war.data.score_data.score) < self.data.level then 
        ex.Tools:showItemInfo(tag, pSender)
    else
        if not ctr.country_war.data:getIsGetedMysteryReward(self.data.idx) then
            ctr.country_war:gReqCountryWarScoreGet(self.data.idx)
        end
    end
end


---------------------------------------------------CountryWarIntegralRewardLayer---------------------------------------------------------
local LAYER_TYPE = {
    REWARD = 1,
    TASK = 2
}

function CountryWarIntegralRewardLayer:onCreate()
    self:addBlackBackground()

    self.task_end_time = 0
    self.lbl_exp:setLocalZOrder(1)
    self.btn_reward:setChecked(true)
    self.reward_node:setVisible(true)
    self.task_node:setVisible(false)
    self.unlock_panel:setVisible(not ctr.country_war.data.score_buy_gem)
    self.spr_lbl_lock:setVisible(not ctr.country_war.data.score_buy_gem)  
    self.lbl_task_time:setPositionX(self.lbl_time_name:getPositionX() + self.lbl_time_name:getContentSize().width)
    local is_show_red = cc.UserDefault:getInstance():getBoolForKey(string.format("%sintegral_gift_red", ex.Player.role_id), true)
    if is_show_red then
        ex.Tools:addRedPoint(self.btn_buy, is_show_red, ex.r.p9)   
    end
    --其他版本的适配
    ex.Tools:setLimitWidth(self.lbl_title,120)
    ex.Tools:setLimitWidth(self.lbl_integral_lv,130)
    ex.Tools:setLimitWidth(self.lbl_integral_privilege,340)
    ex.Tools:setLimitWidth(self.lbl_lv,100)
    ex.Tools:setLimitWidth(self.lbl_reward,100)
    ex.Tools:setLimitWidth(self.llbl_mystical_reward,140)
    ex.Tools:setLimitWidth(self.btn_buy:getLabel(), 140)
    ex.Tools:setLimitWidth(self.btn_receive_reward:getLabel(), 140)
    
    
    self:initData()
    self:createProgress()
    -- self:setTabRedPoint()
    self:createRewardTableView()
    self:createTaskTableView()

end

function CountryWarIntegralRewardLayer:initData(  )
    --奖励 1 和 任务界面 2
    self.cur_tag = 1
    --任务界面的不同任务 1 2 3
    self.task_tag = 1

    self.reward_scroll_view:setItemType(1)
    self.reward_scroll_view:setItemSize(cc.size(470,110))  
    self.reward_scroll_view:setResetOffset(true)
    self.reward_scroll_view:setSwallowsTouches(false)

    self.task_scroll_view:setItemType(1)
    self.task_scroll_view:setItemSize(cc.size(470,110))  
    self.task_scroll_view:setSwallowsTouches(false)

    self.btn_reward:setLabelText(ex.Tools:getLang(55505))
    ex.Tools:setLimitWidth(self.btn_reward:getLabel(), 90)
    self.btn_task:setLabelText(ex.Tools:getLang(55506))
    ex.Tools:setLimitWidth(self.btn_task:getLabel(), 110)
    self.btn_tab_1:setLabelText(ex.Tools:getLang(55513))
    self.btn_tab_2:setLabelText(ex.Tools:getLang(55514))
    self.btn_tab_3:setLabelText(ex.Tools:getLang(55515))
   for i=1,3 do
    ex.Tools:setLimitWidth(self["btn_tab_"..i]:getLabel(), 120)
   end

    self.btn_buy:registerScriptTapHandler(handler(self,self.onBuyReward))
    self.btn_reward:registerScriptTapHandler(handler(self,self.onChangeLayer))
    self.btn_task:registerScriptTapHandler(handler(self,self.onChangeLayer))

    --红点
    ex.Tools:addRedPoint(self.btn_receive_reward, ctr.country_war.data:getIsHasRewardGet(), ex.r.p9)   
    

    self:addEvent(EVENT.COUNTRY_WAR.UPDATE_SCORE_REWARD_TASK_AND_SCORE,handler(self,self.updateProgress))
    self:addEvent(EVENT.COUNTRY_WAR.UPDATE_SCORE_REWARD_TASK,handler(self,self.updateTask))
    self:addEvent(EVENT.COUNTRY_WAR.UPDATE_SCORE_REWARD_LAYER,handler(self,self.updateReward))
    
end

function CountryWarIntegralRewardLayer:onExit( )
    self:removeTaskTimer()
end
--添加定时器
function CountryWarIntegralRewardLayer:addTaskTimer( )
    self:removeTaskTimer()
    self.task_timer = ex.Timer:addTimer(1000,function () 
        self:upTaskTimer()
    end,true)
end
--刷新时间
function CountryWarIntegralRewardLayer:upTaskTimer( )
    local time = self.task_end_time - ex.Game:getServerTime()
    local d,h,m,s =  ex.Tools:formatTime(time)
    self.lbl_task_time:setString(ex.Tools:formatTime4(time))
    if time <= 0 then 
        self:removeTaskTimer()
    end
end
--移除定时器
function CountryWarIntegralRewardLayer:removeTaskTimer( )
    if self.task_timer ~= nil then 
        ex.Timer:removeTimerById(self.task_timer)
    end
    self.task_timer = nil
end
--展示倒计时
function CountryWarIntegralRewardLayer:showTime( )
    if self.cur_tag == LAYER_TYPE.TASK then 
        self.task_end_time = ctr.country_war.data:getTime(self.task_tag)
        if not self.task_end_time then
            return
        end
        self:upTaskTimer()
        self:addTaskTimer()  
    else
        self:removeTaskTimer()
    end
end

--切换界面
function CountryWarIntegralRewardLayer:onChangeLayer(tag,pSender)
    if tag == self.cur_tag then return end 
    self.cur_tag = tag
    self.reward_node:setVisible(self.cur_tag == LAYER_TYPE.REWARD)
    self.task_node:setVisible(self.cur_tag == LAYER_TYPE.TASK)
    if self.cur_tag == 2 then
        self.btn_tab_1:setChecked(true)
        self.btn_tab_2:setChecked(false)
        self.btn_tab_3:setChecked(false)
        self:showTime()
    end
end
--切换任务
function CountryWarIntegralRewardLayer:onChangeTask(tag,pSender)
    if self.task_tag == tag then return end 
    self.task_tag = tag 
    self.task_list_data = self:editData()
    self.task_scroll_view:reloadData(self.task_list_data)
    self:showTime()
end

--创建进度条
function CountryWarIntegralRewardLayer:createProgress()
    self.progressTimer = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("exotic-adventure/exotic-adventure-spr-jdt2-2.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setScaleX(1)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.spr_progress_bg:addChild(self.progressTimer)
    self.progressTimer:setPosition(self.spr_progress_bg:getContentSize().width / 2 ,self.spr_progress_bg:getContentSize().height / 2 )
    self:updateProgress()
end

--更新积分进度条并更新任务
function CountryWarIntegralRewardLayer:updateProgress()
    if not ctr.country_war.data.score_data then
        return
    end
    ex.Tools:addRedPoint(self.btn_receive_reward, ctr.country_war.data:getIsHasRewardGet(), ex.r.p9)   
    self.unlock_panel:setVisible(not ctr.country_war.data.score_buy_gem)
    self.spr_lbl_lock:setVisible(not ctr.country_war.data.score_buy_gem)
    --当前积分
    local cur_score = ctr.country_war.data.score_data.score
    --当前等级
    local level = ctr.country_war.data:getScoreLevel(cur_score)
    local max_level = #ctr.country_war.data:getNowRoundReward()
    local score 
    if level == max_level then 
        score = ctr.country_war.data:getLevelScore(level)
    else
        score = ctr.country_war.data:getLevelScore(level+ 1)
    end
    local percent = (cur_score / score) * 100
    if percent > 100 then percent = 100 end
    self.progressTimer:setPercentage(percent)

    self.lbl_exp:setString(string.format("%s / %s",cur_score,score))
    self.lbl_task_time:enableOutline(cc.c3b(144,35,16,255), 1)
    self.lbl_integral_num:setString(level)

    self.task_list_data = self:editData()
    self.task_scroll_view:reloadData(self.task_list_data)
    self.reward_list_data = ctr.country_war.data:getNowRoundReward()
    self.reward_scroll_view:reloadData(self.reward_list_data)
    self:addBtnRed()
end
--更新任务
function CountryWarIntegralRewardLayer:updateTask( )
    ex.Tools:addRedPoint(self.btn_receive_reward, ctr.country_war.data:getIsHasRewardGet(), ex.r.p9)   
    self.task_list_data = self:editData()
    self.task_scroll_view:reloadData(self.task_list_data)
    self:addBtnRed()
end
--更新奖励状态
function CountryWarIntegralRewardLayer:updateReward(  )
    ex.Tools:addRedPoint(self.btn_receive_reward, ctr.country_war.data:getIsHasRewardGet(), ex.r.p9)   
    self.reward_list_data = ctr.country_war.data:getNowRoundReward()
    self.reward_scroll_view:reloadData(self.reward_list_data)
    self:addBtnRed()
end

--创建奖励cell
function CountryWarIntegralRewardLayer:createRewardTableView(  ) 
    self.reward_list_data = ctr.country_war.data:getNowRoundReward()
    self.reward_scroll_view.createItemFunction = function(item_data, scale)
        local cell = CountryWarIntegralRewardCell:createWithCCBIFile("ccbi/CountryWarIntegralRewardCell.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(cc.p(0.5, 0.5))
        cell:setPositionX(50)
        cell:resetData(item_data, self.reward_scroll_view)
        return cell
    end
    self.reward_scroll_view:reloadData(self.reward_list_data)
end
--创建任务cell
function CountryWarIntegralRewardLayer:createTaskTableView(  )
    self.task_list_data = self:editData()
    self.task_scroll_view.createItemFunction = function(item_data, scale)
        local cell = CountryWarIntegralTaskCell:createWithCCBIFile("ccbi/CountryWarIntegralTaskCell.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(cc.p(0.5, 0.5))
        cell:setPositionX(50)
        cell:resetData(item_data, self.task_scroll_view)
        return cell
    end
    self.task_scroll_view:reloadData(self.task_list_data)
end
--任务数据处理
function CountryWarIntegralRewardLayer:editData( )
    local tmp = {}
    local task_list = ctr.country_war.data:getScoreTask(self.task_tag)
    local function sor( a , b )
        local is_get_a = ctr.country_war.data:getTaskGetStatus(a.idx)
        local is_get_b = ctr.country_war.data:getTaskGetStatus(b.idx)
        local progress_a = ctr.country_war.data:getTaskProgressStatus(a)
        local progress_b = ctr.country_war.data:getTaskProgressStatus(b)
        if is_get_a == is_get_b then
            if progress_a == progress_b then
                return a.idx < b.idx 
            end
            return progress_a > progress_b
        end
        return is_get_a < is_get_b   
    end
    table.sort( task_list,sor )
    return task_list
end

--一键领取奖励
function CountryWarIntegralRewardLayer:onReward()
    if ctr.country_war.data:getIsHasRewardGet() then
        ctr.country_war:gReqCountryWarScoreGet(0)
    end
end

function CountryWarIntegralRewardLayer:onBuyReward(tag,pSender)
    local is_show_red = cc.UserDefault:getInstance():getBoolForKey(string.format("%sintegral_gift_red", ex.Player.role_id), true)
    if is_show_red then
        ex.Tools:addRedPoint(self.btn_buy, false, ex.r.p9) 
        cc.UserDefault:getInstance():setBoolForKey(string.format("%sintegral_gift_red", ex.Player.role_id), false) 
    end
    require("src.layer.countrywar.CountryWarBuyRewardCtr"):instance():openWindow()
end

function CountryWarIntegralRewardLayer:onInfo(tag,pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(55504), ex.Tools:getLang(55571))    
end

function CountryWarIntegralRewardLayer:addBtnRed()
    ex.Tools:addRedPoint(self.btn_reward, ctr.country_war.data:getIsHasRewardGet(), ex.r.p9)  
    ex.Tools:addRedPoint(self.btn_task, ctr.country_war.data:getIsHasTaskGet(), ex.r.p9)  
end
---------------------------------------------------CountryWarIntegralRewardCtr------------------------------------------------------------------
function CountryWarIntegralRewardCtr:onCreate()
    self:setCCBIPath("ccbi/CountryWarIntegralRewardLayer.ccbi")
    self:setIsSingle(false)
end

function CountryWarIntegralRewardCtr:getLayerClass()
    return CountryWarIntegralRewardLayer
end

function CountryWarIntegralRewardCtr:getClanRankLayer()
    return self.layer
end

function CountryWarIntegralRewardCtr:openWindow(str_content)
    if self:isOpened() then
        return
    end

    self:loadLayer()
    self:open()
    self:initData()
end

function CountryWarIntegralRewardCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
end

return CountryWarIntegralRewardCtr
