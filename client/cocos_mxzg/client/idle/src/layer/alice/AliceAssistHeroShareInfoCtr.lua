local AliceAssistHeroShareInfoCtr = class("AliceAssistHeroShareInfoCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local AliceAssistHeroShareInfoLayer = class("AliceAssistHeroShareInfoLayer", require("src.comp.EventLayer"))
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

function AliceAssistHeroShareInfoLayer:onCreate()
	self:setAutoClose(true)
	self:setSwallowTouches(true)
	self:addBlackBackground()
    self:addEvent(EVENT.ALICE.ALICE_ASSIST_HERO_INFO, handler(self,self.updateLayer))
   
end


function AliceAssistHeroShareInfoLayer:reset(hero_data)
    self.hero_data = hero_data 
    self.lbl_hero_name:setString(ex.Tools:getLang(self.hero_data.hero_type))
    self:createHeroItem(self.hero_data)
    self:updateStage(self.hero_data.stage)
    -- self:updateAttr(self.hero_data)
	self:updateLevelSkillInfo(self.hero_data)
	
end

function AliceAssistHeroShareInfoLayer:createHeroItem(hero_data)
	local item = UIMenuItemHero:createWithData()
	item:reset(hero_data)
	if hero_data.fashion_id ~= 0 and hero_data.fashion_id ~= nil then
		item:setFashionShowForce(hero_data.fashion_id)
	end
    self.menu_hero:addChild(item)
    item:setPosition(0,0)
end

function AliceAssistHeroShareInfoLayer:updateStage(stage)
	if not self.gradeArr then 
		self.gradeArr = {}
		for i=1,6 do
			self.gradeArr[i] = self["sp_grade" .. i]
		end
	end


	local maxStar = self.hero_data.star
	for k,v in pairs(self.gradeArr) do
		v:setVisible(k<=maxStar)
		local path = stage >= k and "hero-info/spr-quality-2.png" or "hero-info/spr-quality-1.png"
		v:initWithSpriteFrameName(path)
	end
end

function AliceAssistHeroShareInfoLayer:updateAttr(hero_data)
    self.lbl_attack:setString(string.format("%d", hero_data.atk))
	self.lbl_hp:setString(string.format("%d", hero_data.hp))
	self.lbl_defense:setString(string.format("%d", hero_data.def))
	self.lbl_speed:setString(string.format("%d", hero_data.spd))   
end

function AliceAssistHeroShareInfoLayer:updateLevelSkillInfo(hero_data)

	local vec_skill = ex.Player.hero_data:getHeroSkillList(hero_data.hero_type)
	local skill_num = table.nums(vec_skill)
	local max_skill_num = 4
    local UIMenuItemSkill = require("src.comp.menu.UIMenuItemSkill")
    
	local begin_x = 170--self:getContentSize().width * 0.5 - (max_skill_num - 1) * icon_width * 0.5 + 16
	local icon_width --= --btn_skill:getContentSize().width + 20

    local is_cube_hero = ex.Player.hero_data.magicCube:isCubeHero(hero_data.hero_id)
    local stage = is_cube_hero == true and hero_data.tweak_cube_stage or hero_data.stage 
	for i=1,4 do
		if i <= skill_num then  
			local skill_level, is_evolve_skill, skill_id  = ex.Player.hero_data:getHeroSkillLevel(stage, hero_data.star, i, hero_data.hero_type, hero_data.evolve)
            local btn_skill = UIMenuItemSkill:createWithIcon(skill_id, skill_level, is_evolve_skill, handler(self, self.onSkillInfo))
			if not icon_width then 
				icon_width = btn_skill:getContentSize().width + 20
			end
			btn_skill:setPosition(begin_x + icon_width * (i - 1), 415)
			self.menu_skill:addChild(btn_skill)
			self["btn_skill"..i] = btn_skill

			btn_skill.lbl_name:setVisible(false)

			btn_skill.skill_index = i
		else 
		-- 	-- 创建一个imgs
		-- 	local image = cc.Sprite:createWithSpriteFrameName("hero-info/spr-new-9.png")
		-- 	if not icon_width then 
		-- 		icon_width = image:getContentSize().width + 20
		-- 	end
		-- 	image:setPosition(begin_x + icon_width * (i - 1), 545)
		-- 	self:addChild(image)

		end 
	end

end

function AliceAssistHeroShareInfoLayer:onSkillInfo(tag,pSender)
    -- print("HeroInfoUpLevelLayer:onSkillInfo", pSender.skill_level, pSender.skill_index, self.hero_data.hero_type)
	local skill_level_next_need_star = ex.Player.hero_data:getHeroSkillLevelNeedStar(pSender.skill_level + 1, pSender.skill_index, self.hero_data.hero_type)
    require("src.layer.HeroSkillInfoCtr"):instance():openWindow(pSender.skill_type, pSender.skill_level, skill_level_next_need_star)
end

function AliceAssistHeroShareInfoLayer:updateLayer(evt, hero_data)
	self:updateAttr(hero_data.detail)
    self.lbl_bat:setString(ex.Tools:getLang(3201)..hero_data.fighting)
    local width_half = self.spr_bg:getContentSize().width / 2
    local cell = require("src.layer.alice.AliceHeroInfoAttrLayer"):create()
    local cell_height = cell:getContentSize().height
    cell:updateLayer(hero_data)
    cell:setAnchorPoint(0,0)
    cell:setPosition(width_half,0)
	local offset_height = cell:getContentSize().height - self.lbl_attr_bg:getContentSize().height + 20
	self.scroll_view:setContentSize(cell:getContentSize())
    self.scroll_view:setViewSize(cc.size(self.lbl_attr_bg:getContentSize().width, self.lbl_attr_bg:getContentSize().height - 20))
    self.scroll_view:setItemSize(cell:getContentSize())
	self.scroll_view:setContentOffset(cc.p(0, -offset_height))
    self.scroll_view:addChild(cell)
end


--------
function AliceAssistHeroShareInfoCtr:onCreate()
	self:setCCBIPath("ccbi/AliceAssistHeroShareInfoLayer.ccbi")
	
    self:setIsSingle(false)
end

function AliceAssistHeroShareInfoCtr:getLayerClass()
    return AliceAssistHeroShareInfoLayer
end

function AliceAssistHeroShareInfoCtr:getLayer()
    return self.layer
end

function AliceAssistHeroShareInfoCtr:openWindow(hero_data, hero_id)
    if self:isOpened() then
        return
    end
	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/skill-icon.plist")
	
    self:loadLayer()
    self:open()
    self:initData(hero_data, hero_id)
    self.layer:reset(hero_data)
end

function AliceAssistHeroShareInfoCtr:initData(hero_data, hero_id)
	if hero_id and hero_id ~= 10 then
		local req = Alice_pb.GReqAliceHeroDetail()
		req.hero_id = hero_id
		req.star = ctr.alice.data.star
   		NetManager:sendMessage(ProtocolID.GReqAliceHeroDetail, req)
	else
		local req_detail = Alice_pb.GReqAliceAssistDetail()
		req_detail.idx = hero_data.idx
		NetManager:sendMessage(ProtocolID.GReqAliceAssistDetail, req_detail)
	end
  
end

return AliceAssistHeroShareInfoCtr
