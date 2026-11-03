local PlaneWarMainLayer = class("PlaneWarMainLayer", require("src.comp.EventLayerAdaptiveWidthFull"))
local PlaneWarInstance = class("PlaneWarInstance", require("src.comp.EventLayer"))


function PlaneWarInstance:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    -- ctr.plane_war:selectInstance()
end

function PlaneWarInstance:reloadData(data)
    self.data = data
    
    if data.is_open then
        self.lbl_open_day:setVisible(false)
    else
        self.lbl_open_day:setString(data.open_day_str)
        self.lbl_open_day:setVisible(true)
    end

    if data.boss then
        self.spr_boss_icon:setVisible(true)
        ex.Tools:setSpriteFrame(self.spr_boss_icon, string.format("head-icon/%d.png", data.boss.hero_type))
    else
        self.spr_boss_icon:setVisible(false)
    end
    self.lbl_name:setString(data.name)
end

function PlaneWarInstance:refreshTime(remain_time)
    if not self.data.is_open then
        if self.lbl_time:isVisible() then
             self.lbl_time:setVisible(false)
        end

        if not self.lbl_open_day:isVisible() then
             self.lbl_open_day:setVisible(true)
        end
    elseif remain_time > 0 then
        local timestr = string.format(ex.Tools:getLang(52111), ex.Tools:formatTime5(remain_time))
        self.lbl_time:setString(timestr)
        if not self.lbl_time:isVisible() then
             self.lbl_time:setVisible(true)
        end
    else
        if self.lbl_time:isVisible() then
             self.lbl_time:setVisible(false)
        end

        if not self.lbl_open_day:isVisible() then
             self.lbl_open_day:setVisible(true)
        end
    end
end

-------------------------------------PlaneWarMainLayer------------------------------------

function PlaneWarMainLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(true)

    self:initEventListen()
    self:initPlist()

    local pos_y = ex.p.height - 80 * ex.s.global_scale - require("src.model.Game"):instance():getNotchHeight()
    self.node_top:setPositionY(pos_y)
    local middle_height = pos_y - ex.MainSceneCtr:getBottomHeight()
    if middle_height > self.node_map:getContentSize().height then
        self.node_map:setPositionY(ex.p.height / 2 - self.node_map:getContentSize().height / 2)
    else
        self.node_map:setPositionY(ex.MainSceneCtr:getBottomHeight() + 75)
    end

    self.node_bottom:setPositionY(ex.MainSceneCtr:getBottomHeight() - 20)
    
    self.btn_info:registerScriptTapHandler(handler(self, self.onClickInfo))

    if self.spr_bg:getContentSize().width * self:getScaleX() < ex.p.width then
        self.spr_bg:setScale(ex.p.width / self.spr_bg:getContentSize().width / self:getScaleX())
    end

    if self.spr_instance_bg:getContentSize().width * self:getScaleX() < ex.p.width then
        self.spr_instance_bg:setScale(ex.p.width / self.spr_instance_bg:getContentSize().width / self:getScaleX())
    end

    for i = 1, 5 do
        local btn = self["btn_elem_".. i]
        if btn then
             local instance = PlaneWarInstance:createWithCCBIFile("ccbi/PlaneWarInstance.ccbi")
             instance:setPosition(btn:getContentSize().width / 2 - instance:getContentSize().width / 2, 0)
             instance:setName("PlaneWarInstance")
             btn:addChild(instance)
        end
    end

    self:updateLayer()
end

function PlaneWarMainLayer:initEventListen()
    self:addEvent(EVENT.PLANE_WAR.UPDATE_DATA, handler(self, self.updateLayer))
    self:addEvent(EVENT.PLANE_WAR.UPDATE_TIMES, handler(self, self.handleUpdataTimes))
end

function PlaneWarMainLayer:initPlist()
    -- 加载需要的资源
    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/plane-war.plist")
end

function PlaneWarMainLayer:updateLayer()
    self:removeTimerByName("timer")

    local data = ctr.plane_war.data
    if not data then
        return
    end

    self.data = data
    self:updateTimes(data)

    for k, v in ipairs(data.instance_list) do
        local btn = self["btn_elem_".. v.element]
        if btn then
             local instance = btn:getChildByName("PlaneWarInstance")
             if instance then
                instance:reloadData(v)
             end
             btn.data = v
        end
    end

    self:addTimer("timer", 1000, handler(self, self.updateTimer), true)
    self:updateTimer()
end

function PlaneWarMainLayer:updateTimer()
    local data = ctr.plane_war.data
    if not data then
        return
    end

    local curtime = ex.Game:getServerTime()
    local last_get_info_time = data.last_get_info_time or 0
    local is_same_day = Maths.isSameDay(curtime,last_get_info_time)
    if not is_same_day then
        self:removeTimerByName("timer")
        ctr.plane_war:requestPlaneWarData()
        return
    end
    
    local privilege_expire_time = data.privilege_expire_time or -1
    if privilege_expire_time > 0 and curtime > privilege_expire_time then
        self:removeTimerByName("timer")
        ctr.plane_war:requestPlaneWarData()
        return
    end
    
    local remain_time = Maths.getOneDayRemainTime(curtime)
    for i = 1, 5 do
        local btn = self["btn_elem_".. i]
        if btn then
             local instance = btn:getChildByName("PlaneWarInstance")
             instance:refreshTime(remain_time)
        end
    end
end

function PlaneWarMainLayer:updateTimes(plane_war_data)
    if not plane_war_data then
        return
    end

    self.lbl_times:setString(string.format("%s/%s", plane_war_data.challenge_count, plane_war_data.max_challenge_count))
    self.lbl_times_buy:setString(plane_war_data.remaining_buy_count)
end

------------------------------- 点击事件 -------------------------------

-- 返回
function PlaneWarMainLayer:onBack(tag, pSender)
    ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
end

-- 副本图标被点击
function PlaneWarMainLayer:onInstance(tag, pSender)
    local data = pSender.data
    if not data then
        return
    end

    if not data.is_open then
        ex.MessageView:add(data.open_day_str)
        return
    end

    local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_PLANE_WAR_MISSION_LAYER)
    if ex.MainSceneCtr:getCurLayerType() == MainSceneType.MAINCITY_PLANE_WAR_MISSION_LAYER then
        layer:initData(data.element, data.turn)
    end
end

-- 购买挑战次数
function PlaneWarMainLayer:onAddTimes(tag, pSender)
    local plane_war_data = ctr.plane_war.data
    if not plane_war_data or plane_war_data.remaining_buy_count == 0 then
        ex.MessageView:add(ex.Tools:getLang(74935))
        return
    end

    local res_need = ctr.plane_war:getBuyConsume()
    if res_need == nil then
        ex.MessageView:add(ex.Tools:getLang(74935))
        return
    end

    -- 打开购买确认框
    local layer = ex.ConfirmCtr:openWindow(
        ex.Tools:getLang(16), 
        string.format(ex.Tools:getLang(91257), res_need[1].item_num), 
        function()
            if res_need[1].item_num > ex.Player:getItemNum(res_need[1].item_type) then
                ex.Tools:showEnoughTip(res_need[1].item_type, true)
                return
            end
            NetManager:sendMessage(ProtocolID.GReqPlaneWarBuyCount)
        end,
        nil,
        nil,
        nil,
        nil,
        nil,
        true)
end


function PlaneWarMainLayer:onClickInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(91258), ex.Tools:getLang(91259))
end

function PlaneWarMainLayer:onRankInfo(tag, pSender)
    require("src.layer.planewar.PlaneWarRankCtr"):instance():openWindow()
end

function PlaneWarMainLayer:handleUpdataTimes()
    local plane_war_data = ctr.plane_war.data
    if not plane_war_data then
        return
    end

    self:updateTimes(plane_war_data)
end

return PlaneWarMainLayer
