--[[
* @Description: 异界冒险-科技升级
* @Author: 熊梦
* @Date: 2020-07-29 20:00:00
* ]]
local ExoticAdventureUpgradeCtr = class("ExoticAdventureUpgradeCtr",require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ExoticAdventureUpgradeLayer = class("ExoticAdventureUpgradeLayer",require("src.comp.EventLayerAdaptiveWidth"))

function ExoticAdventureUpgradeLayer:onCreate()
    self:addBlackBackground()
	self:registerBtnEvent()
end
 
-- 关闭按钮
function ExoticAdventureUpgradeLayer:registerBtnEvent( )
	local ctr = ExoticAdventureUpgradeCtr:instance()
	self.btn_close:registerScriptTapHandler(handler(ctr, ctr.closeWindow))
end

function ExoticAdventureUpgradeLayer:inidata( idx )
	-- ex.Player.exotic_adventure_data.level = data.level 			--舰队等级
	-- ex.Player.exotic_adventure_data.exp = data.exp 				--舰队经验
	-- ex.Player.exotic_adventure_data.nick = data.nick 				--舰队名字
	-- ex.Player.exotic_adventure_data.durability = data.durability 	--耐久度
	-- ex.Player.exotic_adventure_data.skill_num = data.skill_num 	--剩余科技点
	-- ex.Player.exotic_adventure_data.skill = data.skill				--科技信息
	--cfg.spacetimefleetskill.spacetimefleetskill[]
	self.type = idx
	local name_lang = 76502 + self.type
	self.lbl_name:setString(ex.Tools:getLang(name_lang))

	local describe_lang = 76520
	if self.type == 2 then
		describe_lang = 76522
	elseif self.type == 3 then
		describe_lang = 76528
	elseif self.type == 4 then
		describe_lang = 76524
	end
	self.lbl_describe:setString(ex.Tools:getLang(describe_lang))

	-- 图标
	-- self.spr_icon:setSpriteFrame(string.format("exotic-adventure/spr-upgrade-%d.png", idx))
	ex.Tools:setSpriteFrame(self.spr_icon, string.format("exotic-adventure/spr-upgrade-%d.png", idx))
	self:setAttrStr()

	self:addEvent(EVENT.EXOTICADVENTURE.UPDATA_SKILL,handler(self,self.updataSkill))
	
end

function ExoticAdventureUpgradeLayer:setAttrStr()

	self.lbl_skill_num:setString(string.format(ex.Tools:getLang(76509),ex.Player.exotic_adventure_data.skill_num))

	local skill = ex.Player.exotic_adventure_data.skill[self.type]
	local str1_lang =  0
	-- 计算最大等级
	local max_level = 1
	for i,v in pairs(cfg.spacetimefleetskill.spacetimefleetskill) do
		if v.type == skill.skill_type then 
			if v.level > max_level then
				max_level = v.level
			end
		end
	end
	-- 修改显示属性
	local str_attr_fix = ""
	for i,v in pairs(cfg.spacetimefleetskill.spacetimefleetskill) do
		if v.type == skill.skill_type then 
			local continue = false
			local lbl = self.lbl_markup
			if v.level == skill.skill_level then
				continue = true
				lbl = self.lbl_markup
			end
			if v.level == skill.skill_level+1 then
				continue = true
				lbl = self.lbl_next_markup
			end
			if continue then
				if self.type == 1 then
					str1_lang = 76521
					str_attr_fix = v.fleet_endurance
					lbl:setString(string.format(ex.Tools:getLang(str1_lang),str_attr_fix))
					str_attr_fix = ""
				elseif self.type == 2 then
					str1_lang = 76523
					str_attr_fix = (v.fleet_speed_add/100).."%"
					lbl:setString(string.format(ex.Tools:getLang(str1_lang),str_attr_fix))
					str_attr_fix = ""
				elseif self.type == 3 then
					str1_lang = 76529
					str_attr_fix = (v.fleet_item/100).."%"
					lbl:setString(string.format(ex.Tools:getLang(str1_lang),str_attr_fix))
					str_attr_fix = ""
				elseif self.type == 4 then
					for index,value in ipairs(v.ability) do
						local str = ex.Tools:getLang(2140000 + value.attr)		
						str = ex.StringUtil.formatAttrStr(str, "##" , value.value)
						str_attr_fix = str_attr_fix .. str.."\n"
					end
					
					if v.level == skill.skill_level+1 and skill.skill_level == 1 then
						local str_attr_fix2 = ""
						for index,value in ipairs(v.ability) do
							local str = ex.Tools:getLang(2140000 + value.attr)		
							str = ex.StringUtil.formatAttrStr(str, "##" , 0)
							str_attr_fix2 = str_attr_fix2 .. str.."\n"
						end
						self.lbl_markup:setString(str_attr_fix2)
					end
					lbl:setString(str_attr_fix)
					str_attr_fix = ""
				end
			end
			if skill.skill_level == max_level then
				self.lbl_next_markup:setString(ex.Tools:getLang(100052))
			end
		end
	end
end

function ExoticAdventureUpgradeLayer:updataSkill()
	self:setAttrStr()
	ex.MessageView:add(ex.Tools:getLang(76568))
end

function ExoticAdventureUpgradeLayer:onUpgrade(tag,pScene)
	if ex.Player.exotic_adventure_data.skill_num <= 0 then
		ex.MessageView:add(ex.Tools:getLang(76567))
		return
	end

	if ex.Player.exotic_adventure_data.not_route ~= 0 then
		ex.MessageView:add(ex.Tools:getLang(76559))
		return
	end
	
	local req = SpaceTimeAdventure_pb.GReqFleetUpSkill()
	req.skill_type = self.type
	NetManager:sendMessage(ProtocolID.GReqFleetUpSkill, req)

end

-----------------------------------------------------------------------------
function ExoticAdventureUpgradeCtr:onCreate()
	self:setCCBIPath("ccbi/ExoticAdventureUpgradeLayer.ccbi")
	self:setIsSingle(false)
end

function ExoticAdventureUpgradeCtr:getLayerClass()
	return ExoticAdventureUpgradeLayer
end

function ExoticAdventureUpgradeCtr:getAchievementLayer()
	return self.layer
end

function ExoticAdventureUpgradeCtr:openWindow(idx)
	if self:isOpened() then
		return
	end
	self:loadLayer()
	self:open()
	self.layer:inidata(idx)
end

function ExoticAdventureUpgradeCtr:initData()

end

return ExoticAdventureUpgradeCtr
