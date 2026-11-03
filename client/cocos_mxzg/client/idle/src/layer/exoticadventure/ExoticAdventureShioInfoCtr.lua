--[[
* @Description: 异界冒险-船长室
* @Author: 熊梦
* @Date: 2020-07-27 18:00:00
* ]]
local ExoticAdventureShioInfoCtr = class("ExoticAdventureShioInfoCtr",require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ExoticAdventureShioInfoLayer = class("ExoticAdventureShioInfoLayer",require("src.comp.EventLayerAdaptiveWidth"))

function ExoticAdventureShioInfoLayer:onCreate()
    self:addBlackBackground()
    self:registerBtnEvent()
    self:inidata()
end

function ExoticAdventureShioInfoLayer:inidata(  )
	-- ex.Player.exotic_adventure_data.level = data.level 			--舰队等级
	-- ex.Player.exotic_adventure_data.exp = data.exp 				--舰队经验
	-- ex.Player.exotic_adventure_data.nick = data.nick 				--舰队名字
	-- ex.Player.exotic_adventure_data.durability = data.durability 	--耐久度
	-- ex.Player.exotic_adventure_data.skill_num = data.skill_num 	--剩余科技点
	-- ex.Player.exotic_adventure_data.skill = data.skill				--科技信息

	self.max_level = cfg.spacetimefleet.spacetimefleet[#cfg.spacetimefleet.spacetimefleet].level

	
	local level_data = cfg.spacetimefleet.spacetimefleet[ex.Player.exotic_adventure_data.level]
	self.max_level_progress = level_data.need_exp


	self.max_durability_progress = level_data.durability
	self:createLevelProgress()
	self:createDurabilityProgress()
	self:updataView()
	self:updataSkill()

	self:addEvent(EVENT.EXOTICADVENTURE.UPDATA_NICK,handler(self,self.updataNick))
	self:addEvent(EVENT.EXOTICADVENTURE.UPDATA_REPAIR,handler(self,self.updataRepair))
	self:addEvent(EVENT.EXOTICADVENTURE.UPDATA_SKILL,handler(self,self.updataSkill))
	self:addEvent(EVENT.EXOTICADVENTURE.FLEET_UPDATA,handler(self,self.updataView))
	
end

function ExoticAdventureShioInfoLayer:updataView()
	self.lbl_nick:setString(ex.Player.exotic_adventure_data.nick)
	local level_data = cfg.spacetimefleet.spacetimefleet[ex.Player.exotic_adventure_data.level]
	self.lbl_level:setString(ex.Tools:getLang(76508)..ex.Player.exotic_adventure_data.level.."/"..self.max_level)

	self.lbl_skillpoints:setString(string.format( ex.Tools:getLang(76509),ex.Player.exotic_adventure_data.skill_num))

	self.max_level_progress = level_data.need_exp
	self.max_durability_progress = level_data.durability
	
	self:updateLevelProgress()
	self:updateDurabilityProgress()
end


function ExoticAdventureShioInfoLayer:createLevelProgress()
    self.progressTimer_level = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("exotic-adventure/exotic-adventure-spr-jdt2-2.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setScaleX(1)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.spr_progress_bg1:addChild(self.progressTimer_level)
    self.progressTimer_level:setPosition(self.spr_progress_bg1:getContentSize().width / 2 ,self.spr_progress_bg1:getContentSize().height / 2 )
    self:updateLevelProgress()
end

function ExoticAdventureShioInfoLayer:createDurabilityProgress()
    self.progressTimer_durability = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("exotic-adventure/exotic-adventure-spr-jdt2-2.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setScaleX(1)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.spr_progress_bg2:addChild(self.progressTimer_durability)
    self.progressTimer_durability:setPosition(self.spr_progress_bg2:getContentSize().width / 2 ,self.spr_progress_bg2:getContentSize().height / 2 )
    self:updateDurabilityProgress()
end

function ExoticAdventureShioInfoLayer:updateLevelProgress()
    local percent = ex.Player.exotic_adventure_data.exp / self.max_level_progress * 100
    if percent > 100 then percent = 100 end
	self.progressTimer_level:setPercentage(percent)
	self.lbl_lv:setString(ex.Player.exotic_adventure_data.exp.."/"..self.max_level_progress)
end

function ExoticAdventureShioInfoLayer:updateDurabilityProgress()
	local percent = ex.Player.exotic_adventure_data.durability / self.max_durability_progress * 100
    if percent > 100 then percent = 100 end
	self.progressTimer_durability:setPercentage(percent)
	self.lbl_durability:setString(ex.Player.exotic_adventure_data.durability.."/"..self.max_durability_progress)
end

function ExoticAdventureShioInfoLayer:updataNick()
	self.lbl_nick:setString(ex.Player.exotic_adventure_data.nick)
	ex.MessageView:add(ex.Tools:getLang(54107))
end

function ExoticAdventureShioInfoLayer:updataRepair()
	self:updateDurabilityProgress()
	
	ex.MessageView:add(ex.Tools:getLang(76565))
end

function ExoticAdventureShioInfoLayer:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-- 关闭按钮
function ExoticAdventureShioInfoLayer:registerBtnEvent( )
	local ctr = ExoticAdventureShioInfoCtr:instance()
	self.btn_close:registerScriptTapHandler(handler(ctr, ctr.closeWindow))
end

-- 修改名字
function ExoticAdventureShioInfoLayer:onName(tag , pSender)
	require("src.layer.exoticadventure.ExoticAdventureChangeNickCtr"):instance():openWindow()
end

-- 修理
function ExoticAdventureShioInfoLayer:onRepair(tag , pSender)
	-- 耐久度已经满了 无需修理
	if ex.Player.exotic_adventure_data.durability == self.max_durability_progress then 
		ex.MessageView:add(ex.Tools:getLang(76566))
		return
	end

	-- 舰队航行时才能修理
	if ex.Player.exotic_adventure_data.not_route == 0 then
		ex.MessageView:add(ex.Tools:getLang(76559))
		return
	end

	local data = cfg.spacetimefleet.spacetimefleet[ex.Player.exotic_adventure_data.level]
	ex.ConfirmCtr:openWindow(ex.Tools:getLang(76564), string.format(ex.Tools:getLang(76561), data.repair_cost[1].item_type, data.repair_cost[1].item_num,data.regain_durability), function()
		local req = SpaceTimeAdventure_pb.GReqFleetRepair()
		NetManager:sendMessage(ProtocolID.GReqFleetRepair, req)
	end)
end

-- 技能升级
function ExoticAdventureShioInfoLayer:onSkill(tag , pSender)
	require("src.layer.exoticadventure.ExoticAdventureUpgradeCtr"):instance():openWindow(tag)
end

function ExoticAdventureShioInfoLayer:updataSkill()
	self.lbl_skillpoints:setString(string.format( ex.Tools:getLang(76509),ex.Player.exotic_adventure_data.skill_num))
	
	self.btn_skill1:setLabelText(ex.Tools:getLang(76508)..ex.Player.exotic_adventure_data.skill[1].skill_level)
	self.btn_skill2:setLabelText(ex.Tools:getLang(76508)..ex.Player.exotic_adventure_data.skill[2].skill_level)
	self.btn_skill3:setLabelText(ex.Tools:getLang(76508)..ex.Player.exotic_adventure_data.skill[3].skill_level)
	self.btn_skill4:setLabelText(ex.Tools:getLang(76508)..ex.Player.exotic_adventure_data.skill[4].skill_level)

	for i,v in pairs(cfg.spacetimefleetskill.spacetimefleetskill) do
		if v.type == 1 and v.level == ex.Player.exotic_adventure_data.skill[1].skill_level then 
			self.max_durability_progress = v.fleet_endurance
		end
	end
	
	self:updateDurabilityProgress()
end


-----------------------------------------------------------------------------
function ExoticAdventureShioInfoCtr:onCreate()
	self:setCCBIPath("ccbi/ExoticAdventureShioInfoLayer.ccbi")
	self:setIsSingle(false)
end

function ExoticAdventureShioInfoCtr:getLayerClass()
	return ExoticAdventureShioInfoLayer
end

function ExoticAdventureShioInfoCtr:openWindow()
	if self:isOpened() then
		return
	end
	self:loadLayer()
	self:open()
end

function ExoticAdventureShioInfoCtr:initData()

end

return ExoticAdventureShioInfoCtr
