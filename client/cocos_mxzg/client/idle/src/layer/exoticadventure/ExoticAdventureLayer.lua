--[[
* @Description: 异界冒险-选择关卡主界面
* @Author: 熊梦
* @Date: 2020-07-27 10:30:00
* ]]
local ExoticAdventureLayer = class("ExoticAdventureLayer", require("src.comp.EventLayer"))
local UIMenu = require("src.comp.menu.UIMenu")
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")
--------------------------------------------

function ExoticAdventureLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    
	--self:setExitCallback(handler(self,self.onExitCB))

    self:setContentSize(cc.size(ex.p.width, ex.p.height))

    self:registerEvent()

    local win_size = cc.Director:getInstance():getWinSize()
    self.spr_bg:setScaleX(win_size.width / self.spr_bg:getContentSize().width)
    self.spr_bg:setScaleY(win_size.height / self.spr_bg:getContentSize().height)
    self.node_bg:setScaleX(win_size.width / self.spr_bg:getContentSize().width)
    self.node_bg:setScaleY(win_size.height / self.spr_bg:getContentSize().height)
    self.node_back:setPositionY(self.node_back:getPositionY() - require("src.model.Game"):instance():getNotchHeight() + 25)
    -- -- 添加时间倒计时定时器
    -- self.lbl_left_time:setLocalZOrder(150)
    -- self.lbl_left_time:enableOutline(FONT_BROWN_C4B, 1)
    -- self.lbl_left_time:setPosition(ex.p.cx, self.btn_buff_list:getPositionY() - 10)
    -- self:addTimer()
    self.checkpoint_data = cfg.spacetimeadventure.spacetimeadventure
    self.max_checkpoint = #self.checkpoint_data
    self:updataView()
end

-- 层切入时会被调用
function ExoticAdventureLayer:changeLayerIn()
   
end

function ExoticAdventureLayer:registerEvent()
    self:addEvent(EVENT.EXOTICADVENTURE.UPDATA,handler(self,self.updataView))
end


function ExoticAdventureLayer:updataView()
     -- 关卡名字
     for i,v in ipairs(self.checkpoint_data) do
        self["bnt_checkpoint_"..i]:setLabelText(ex.Tools:getLang(v.route_name))
        self["bnt_checkpoint_"..i].type = v.route_type
        self["bnt_checkpoint_"..i].open = false
        self["bnt_checkpoint_"..i].idx = v.idx
        self["bnt_checkpoint_"..i].fleet_level = v.fleet_level
        local is_unlock = false
        for index,value in pairs(ex.Player.exotic_adventure_data.unlock_route) do
            if value == v.idx then
                is_unlock = true
                break
            end
        end
        if (ex.Player.exotic_adventure_data.level >= v.fleet_level and v.route_type == 1) or is_unlock then
            self["bnt_checkpoint_"..i]:setNormalImage(cc.Sprite:createWithSpriteFrameName(string.format("exotic-adventure/Checkpoint-%s-2.png",v.idx)))
            self["bnt_checkpoint_"..i].open = true
        else
            self["bnt_checkpoint_"..i]:setNormalImage(cc.Sprite:createWithSpriteFrameName(string.format("exotic-adventure/Checkpoint-%s-1.png",v.idx)))
        end
    end
    ex.Player.exotic_adventure_data:sendFleet()
end

-- 添加时间倒计时定时器
function ExoticAdventureLayer:addTimer()
	local scheduler = cc.Director:getInstance():getScheduler()
    self.schedulerID = scheduler:scheduleScriptFunc(handler(self, self.handleSchedule),1,false)
    self:handleSchedule()
end

function ExoticAdventureLayer:handleSchedule()
    local time = ex.Player.dungeon_data.end_time - ex.Game:getServerTime()
    self.lbl_left_time:setString(ex.Tools:getLang(47401)..ex.StringUtil.convertToTimeFormat(time))
    if time <= 0 then 
        self:removeTimer()
    end
end

function ExoticAdventureLayer:removeTimer()
	if self.schedulerID ~= nil then 
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
		self.schedulerID = nil
	end
end

function ExoticAdventureLayer:onExitCB()
	self:removeTimer()
end

function ExoticAdventureLayer:onBack(tag , pSender)
    ex.MainSceneCtr:instance():changeLayer(MainSceneType.MAINCITY_LAYER)
end

-- 舰队信息
function ExoticAdventureLayer:onShioInfo(tag , pSender)
    require("src.layer.exoticadventure.ExoticAdventureShioInfoCtr"):instance():openWindow()
end

-- 选择关卡
function ExoticAdventureLayer:onCheckpoint(tag , pSender)
    if tag == 0 then return end
    print("==========================",tag)
    if pSender.open then
        require("src.layer.exoticadventure.ExoticAdventureReportCtr"):instance():openWindow(tag)
    else
        if pSender.type == 1 then
            ex.MessageView:add(string.format( ex.Tools:getLang(76562),pSender.fleet_level))
        else
            ex.MessageView:add(ex.Tools:getLang(76563))
        end
    end
end

return ExoticAdventureLayer
