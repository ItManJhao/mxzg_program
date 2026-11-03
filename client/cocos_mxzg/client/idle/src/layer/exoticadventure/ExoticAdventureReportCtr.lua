--[[
* @Description: 异界冒险-冒险侦查报告
* @Author: 熊梦
* @Date: 2020-07-29 16:13:00
* ]]
local ExoticAdventureReportCtr = class("ExoticAdventureReportCtr",require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ExoticAdventureReportLayer = class("ExoticAdventureReportLayer",require("src.comp.EventLayerAdaptiveWidth"))

local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function ExoticAdventureReportLayer:onCreate()
    self:addBlackBackground()
    self:registerBtnEvent()
end

function ExoticAdventureReportLayer:inidata( tag )
	self.idx = tag
	self.checkpoint_data = cfg.spacetimeadventure.spacetimeadventure[self.idx]

	self.lbl_name:setString(ex.Tools:getLang(self.checkpoint_data.route_name))

	self.lbl_describe:setString(ex.Tools:getLang(self.checkpoint_data.route_dec))

	-- 策划说总路程读表 不乘300
	self.lbl_distance:setString(self.checkpoint_data.distance_traveled) 
 
	local skill = ex.Player.exotic_adventure_data.skill[2]
	local speed_add = 0
	for i,v in pairs(cfg.spacetimefleetskill.spacetimefleetskill) do
		if v.type == skill.skill_type and v.level == skill.skill_level then
			speed_add = math.floor(v.fleet_speed_add / 100)
			break
		end
	end
	local speed = math.floor(cfg.spacetimefleet.spacetimefleet[ex.Player.exotic_adventure_data.level].speed * (1 + speed_add / 100))

	-- self.spr_icon:setSpriteFrame(string.format("exotic-adventure/Checkpoint-%d-2.png", tag))
	ex.Tools:setSpriteFrame(self.spr_icon, string.format("exotic-adventure/Checkpoint-%d-2.png", tag))

	-- 策划说计算的时候总路程乘300
	self.lbl_time:setString(string.format(ex.Tools:getLang(76512), string.format("%d",self.checkpoint_data.distance_traveled * 300 / speed / 3600 / 24)))

	local index = 1
	for k,v in pairs(self.checkpoint_data.fix_reward) do
		local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
		item:setScale(0.8)
		item:setPositionX(index*112 - 330)
		item:registerScriptTapHandler(handler(self, self.onItemInfo))
		self.menu_fixed:addChild(item)
		index = index + 1
	end

	self.scroll_view:setItemSize(cc.size(112, 100))
	self.scroll_view:setItemType(1)
	
	self:updateScrollView()

	self:addEvent(EVENT.EXOTICADVENTURE.START_SAILING,handler(self,self.startSailing))
end

function ExoticAdventureReportLayer:updateScrollView()
	self.scroll_view.createItemFunction = function(data, scale)
		local menu_tab = cpp.UIMenu:create()
		local item = ex.Tools:createBackpackItem(data.item_type, 0)
		item:setScale(0.8)
		item:registerScriptTapHandler(handler(self, self.onItemInfo))
		menu_tab:addChild(item)
		menu_tab:setIsTouchInsideNode(self.scroll_view)
		return menu_tab
    end
    self.scroll_view:reloadData(self.checkpoint_data.random_reward)
end


function ExoticAdventureReportLayer:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-- 关闭按钮
function ExoticAdventureReportLayer:registerBtnEvent( )
	local ctr = ExoticAdventureReportCtr:instance()
	self.btn_close:registerScriptTapHandler(handler(ctr, ctr.closeWindow))
end

-- 开始冒险
function ExoticAdventureReportLayer:onSure(tag, pSender)
	local hero_layer = require("src.layer.HeroSelectCtr"):instance()
	hero_layer:openWindow(ex.Tools:getLang(47524),
                        ex.Tools:getLang(47064),
                        {BattleType.EXOTIC_ADVENTURE_ARMS, BattleType.EXOTIC_ADVENTURE_POWER},
						handler(self, self.onPreFight))
end

-- 布阵成功回调
function ExoticAdventureReportLayer:onPreFight()
	print("=============布阵成功回调==============")
	local req = SpaceTimeAdventure_pb.GReqChooseRoute()
	req.idx = self.idx
	NetManager:sendMessage(ProtocolID.GReqChooseRoute, req)
end

-- 开始冒险回调
function ExoticAdventureReportLayer:startSailing()
	ExoticAdventureReportCtr:instance():closeWindow()
	ex.MainSceneCtr:changeLayer(MainSceneType.EXOTIC_ADVENTURE_SAILING)
end
-----------------------------------------------------------------------------
function ExoticAdventureReportCtr:onCreate()
	self:setCCBIPath("ccbi/ExoticAdventureReportLayer.ccbi")
	self:setIsSingle(false)
end

function ExoticAdventureReportCtr:getLayerClass()
	return ExoticAdventureReportLayer
end

function ExoticAdventureReportCtr:getAchievementLayer()
	return self.layer
end

function ExoticAdventureReportCtr:openWindow(tag)
	if self:isOpened() then
		return
	end
	self:loadLayer()
	self:open()
	self.layer:inidata(tag)
end

function ExoticAdventureReportCtr:initData()

end

return ExoticAdventureReportCtr
