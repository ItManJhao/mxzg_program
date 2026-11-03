local HeroShareInfoCtr = class("HeroShareInfoCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroShareInfoLayer = class("HeroShareInfoLayer", require("src.comp.EventLayer"))
local HeroShareInfoContentLayer = class("HeroShareInfoContentLayer", require("src.comp.EventLayer"))
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

function HeroShareInfoLayer:onCreate()
	self:setAutoClose(true)
	self:setSwallowTouches(true)
	self:addBlackBackground()
end


function HeroShareInfoLayer:reset(data)
    self.hero_data = data.hero_data 
    self.runes_data = data.runes
    self.equip_data = data.equips
    self.gems = data.gems
	self.talents = data.talents
	self.god_equip = data.god_equip or ex.Player.backpack_data:getGodEquipByHeroid(self.hero_data.hero_id)
	self.reiki_equip = data.reiki_equip_list
	self.pet_data = data.pet_data
	self.totem_data = data.totem_data
	self.magic_wand_data = data.magic_wand_data
	self.unicorn_data = data.unicorn_data
    local is_cube_hero = ex.Player.hero_data.magicCube:isCubeHero(self.hero_data.hero_id)
    local stage 
    if is_cube_hero == true then 
        stage = self.hero_data.tweak_cube_stage
    else 
        stage = self.hero_data.stage
    end 
    self.lbl_hero_name:setString(ex.Tools:getLang(self.hero_data.hero_type))
    self.lbl_bat:setString(ex.Tools:getLang(3201) .. self.hero_data.fighting)
    self:createHeroItem(self.hero_data)
    self:updateStage(stage)
    self:updateAttr(self.hero_data)
	self:updateLevelSkillInfo(self.hero_data)
	
	self:updateHeroAttach(self.equip_data, self.runes_data, self.gems, self.talents, self.god_equip,self.reiki_equip,self.pet_data,self.totem_data,self.magic_wand_data,self.unicorn_data)
end

function HeroShareInfoLayer:updateTotemInfo(root,totem_data)
	root.spr_totem_tag:setVisible(totem_data.isOpen == true)
	root.btn_totem:setVisible(totem_data.isOpen == true)
	if totem_data.isOpen == false then return end 
	local btn = root.btn_totem
	if not btn.rare then 
		btn.rare = cc.Sprite:create()
		btn:addChild(btn.rare)
		btn.rare:setPosition(btn:getContentSize().width / 2,btn:getContentSize().height / 2)
	end

	if not btn.icon then 
		btn.icon = cc.Sprite:create()
		btn:addChild(btn.icon)
		btn.icon:setPosition(btn:getContentSize().width / 2,btn:getContentSize().height / 2)
	end

	btn.icon:setVisible(totem_data.sys_id ~= 0)
	btn.rare:setVisible(totem_data.sys_id ~= 0)
	btn:registerScriptTapHandler(handler(self,self.onClickTotems))

	if totem_data.sys_id ~= 0 then 
		-- btn.icon:setSpriteFrame(string.format("backpack/%d.png",  totem_data.sys_id))
		-- btn.rare:setSpriteFrame(string.format("backpack/rare-%d.png",  cfg.item.item[totem_data.sys_id].rare_mark - 1 + totem_data.quality))
		ex.Tools:setSpriteFrame(btn.icon,string.format("backpack/%d.png",  totem_data.sys_id))
		ex.Tools:setSpriteFrame(btn.rare,string.format(string.format("backpack/rare-%d.png",  cfg.item.item[totem_data.sys_id].rare_mark - 1 + totem_data.quality)))
	end

end

function HeroShareInfoLayer:onClickTotems(tag,pSender)
	if self.totem_data.sys_id == 0 then return end 
	require("src.layer.totems.TotemTipsCtr"):instance():openWindow(self.totem_data)
end

function HeroShareInfoLayer:createHeroItem(hero_data)
	local item = UIMenuItemHero:createWithData()
	item:reset(hero_data)
	if hero_data.fashion_id ~= 0 and hero_data.fashion_id ~= nil then
		item:setFashionShowForce(hero_data.fashion_id)
	end
    self.menu_hero:addChild(item)
    item:setPosition(0,0)
end

function HeroShareInfoLayer:updateStage(stage)
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

function HeroShareInfoLayer:updateAttr(hero_data)
    self.lbl_attack:setString(string.format("%d", hero_data.atk))
	self.lbl_hp:setString(string.format("%d", hero_data.hp))
	self.lbl_defense:setString(string.format("%d", hero_data.def))
	self.lbl_speed:setString(string.format("%d", hero_data.agl))   
end

function HeroShareInfoLayer:updateLevelSkillInfo(hero_data)

    
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
			btn_skill:setPosition(begin_x + icon_width * (i - 1), 412)
			self.menu_skill:addChild(btn_skill)
			self["btn_skill"..i] = btn_skill

			btn_skill.lbl_name:setVisible(false)

			btn_skill.skill_index = i
		else 
			-- 创建一个imgs
			local image = cc.Sprite:createWithSpriteFrameName("hero-info/spr-new-9.png")
			if not icon_width then 
				icon_width = image:getContentSize().width + 20
			end
			image:setPosition(begin_x + icon_width * (i - 1), 487)
			--image:setScaleX(win_size.width / self.spr_banner:getContentSize().width)
			--self.btn_up_grade:getParent():addChild(image)
			self:addChild(image)

		end 
	end


	-- -- 显示英雄技能
	-- -- dump(self.hero_data)
	-- local vec_skill = ex.Player.hero_data:getHeroSkillList(hero_data.hero_type)
	-- local skill_num = table.nums(vec_skill)
	-- for i=1,skill_num do
	-- 	local skill_level = ex.Player.hero_data:getHeroSkillLevel(hero_data.stage, hero_data.star, i)
	-- 	local btn_skill = self["btn_skill"..i]
	-- 	if btn_skill then
	-- 		local config = cfg.heroupgrade.grade[hero_data.stage]
	-- 		local disabled = config["skill" .. i] == 0
	-- 		btn_skill:setLevel(skill_level)
	-- 		btn_skill:setGray(disabled)
	-- 	end
	-- end
end

function HeroShareInfoLayer:onSkillInfo(tag,pSender)
    -- print("HeroInfoUpLevelLayer:onSkillInfo", pSender.skill_level, pSender.skill_index, self.hero_data.hero_type)
	local skill_level_next_need_star = ex.Player.hero_data:getHeroSkillLevelNeedStar(pSender.skill_level + 1, pSender.skill_index, self.hero_data.hero_type)
    require("src.layer.HeroSkillInfoCtr"):instance():openWindow(pSender.skill_type, pSender.skill_level, skill_level_next_need_star)
end

function HeroShareInfoLayer:updateEquip(root, equip_data)
	self.equips = {}
	for i=1,EquipMaxCount do
		self.equips[i] = root["btn_equip_" .. i]
		self.equips[i]:registerScriptTapHandler(handler(self,self.onClickEquip))
		self.equips[i]:setTag(i)
		local node_star = cc.Node:create()
		node_star:setName("node_star")
		self.equips[i]:addChild(node_star)
		node_star:setLocalZOrder(20)
		node_star:setPosition(0, 10)
	end
	self:updateHeroEquip(equip_data)
end

function HeroShareInfoLayer:updataReikiEquip(root, reiki_equip)
	for i=1,2 do
		local place = self.hero_data.reiki_places ~= nil and  self.hero_data.reiki_places[i]
		local active = place ~= nil 
		local btn = root["btn_artifact_" .. i] 
		if not btn.rare then 
			btn.rare = cc.Sprite:create()
			btn:addChild(btn.rare)
			btn.rare:setPosition(btn:getContentSize().width / 2,btn:getContentSize().height / 2)
		end

		if not btn.icon then 
			btn.icon = cc.Sprite:create()
			btn:addChild(btn.icon)
			btn.icon:setPosition(btn:getContentSize().width / 2,btn:getContentSize().height / 2)
		end

		if not btn.lock then 
			btn.lock = cc.Sprite:create()
			btn:addChild(btn.lock)
			btn.lock:setPosition(btn:getContentSize().width / 2,btn:getContentSize().height / 2)
		end
		
		btn.lock:setVisible(not active)
		btn.icon:setVisible(active)
		btn.rare:setVisible(active and (reiki_equip ~= nil and reiki_equip[i] ~= nil))
		btn:registerScriptTapHandler(handler(self,self.onClickReiki))

		if reiki_equip ~= nil and reiki_equip[i] ~= nil then 
			btn.icon:setSpriteFrame(string.format("backpack/%d.png",  reiki_equip[i].sys_id))
			btn.rare:setSpriteFrame(string.format("backpack/rare-%d.png",  cfg.item.item[reiki_equip[i].sys_id].rare_mark))
		end

	end
end

function HeroShareInfoLayer:updatePetInfo(root, pet_data)
	if pet_data.sys_id == 0 then return end
	local btn = root.btn_pet
		if not btn.rare then 
			btn.rare = cc.Sprite:create()
			btn:addChild(btn.rare)
			btn.rare:setPosition(btn:getContentSize().width / 2,btn:getContentSize().height / 2)
			btn.rare:setLocalZOrder(99999)
		end

		if not btn.icon then 
			btn.icon = cc.Sprite:create()
			btn:addChild(btn.icon)
			btn.icon:setPosition(btn:getContentSize().width / 2,btn:getContentSize().height / 2)
		end

		if not btn.level then 
			btn.lbl_level = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 44)
			:setScale(0.5)
			:setAnchorPoint(ex.a.right_center)
			:setPosition(btn:getContentSize().width - 7, 15)
			btn.lbl_level:enableOutline(ex.c3b.BLACK, 2)
			btn:addChild(btn.lbl_level, 100000)
		end

		btn:registerScriptTapHandler(handler(self,self.onClickPet))
		local pet_cfg = cfg.pet.pet[pet_data.sys_id]
		
		btn.icon:setSpriteFrame(string.format("backpack/%d.png",  pet_data.sys_id))
		btn.rare:setSpriteFrame(string.format("other/pet-rare-%d.png",  pet_cfg.rare))
		btn.lbl_level:setString("lv." .. ex.StringUtil.getScientificNumber(pet_data.level))

end

function HeroShareInfoLayer:onClickPet(tag,pSender)
	if self.pet_data.sys_id == 0 then return end 

	-- local data = {}
	-- data.id = self.pet_data.sys_id
	-- data.level = self.pet_data.level
	local pet_cfg = ex.Player.hero_data.pet:getLevelCfgByType(self.pet_data.sys_id,self.pet_data.level)
	require("src.layer.pet.PetInfoIllustratCtr"):instance():openWindow(pet_cfg)
end

function HeroShareInfoLayer:updateMagicWandInfo(root, magic_wand_data)
	if self.magic_wand_data == nil or self.magic_wand_data.magic_id == 0 then return end
	local btn = root.btn_magic_wand
	if not btn.rare then 
		btn.rare = cc.Sprite:create()
		btn:addChild(btn.rare)
		btn.rare:setPosition(btn:getContentSize().width / 2,btn:getContentSize().height / 2)
		btn.rare:setLocalZOrder(99)
	end

	if not btn.icon then 
		btn.icon = cc.Sprite:create()
		btn:addChild(btn.icon)
		btn.icon:setPosition(btn:getContentSize().width / 2,btn:getContentSize().height / 2)
		btn.icon:setLocalZOrder(100)
	end

	if not btn.lbl_strengthen then 
		btn.lbl_strengthen = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 44)
		:setScale(0.5)
		:setAnchorPoint(ex.a.right_center)
		:setPosition(btn:getContentSize().width - 7, btn:getContentSize().height - 15)
		btn.lbl_strengthen:enableOutline(ex.c3b.BLACK, 2)
		btn:addChild(btn.lbl_strengthen, 100000)
	end

	btn:registerScriptTapHandler(handler(self,self.onClickMagicWand))
	
	btn.icon:setSpriteFrame(string.format("backpack/%d.png",  self.magic_wand_data.item_type))
	btn.rare:setSpriteFrame(string.format("backpack/rare-%d.png",  cfg.item.item[self.magic_wand_data.item_type].rare_mark))
	btn.lbl_strengthen:setString(self.magic_wand_data.strengthen_lv > 1 and "+"..self.magic_wand_data.strengthen_lv or "")
end

function HeroShareInfoLayer:onClickMagicWand(tag,pSender)
	if self.magic_wand_data.magic_id == 0 then return end 

	-- ex.Tools:onClickItemInfo(self.magic_wand_data.item_type, )
	-- local magic_wand_data = ex.Player.backpack_data:getMagicWand(self.magic_wand_data.magic_id)
	require("src.layer.heromagicwand.HeroMagicWandInfoCtr"):instance():openWindow(self.magic_wand_data, 1)
end

function HeroShareInfoLayer:updateUnicornInfo(root, unicorn_data)
	cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/alice.plist")
	if self.unicorn_data == nil then return end
	local btn = root.btn_unicorn

	if not btn.icon then 
		btn.icon = cc.Sprite:create()
		btn:addChild(btn.icon)
		btn.icon:setPosition(btn:getContentSize().width / 2,btn:getContentSize().height / 2)
		btn.icon:setLocalZOrder(100)
	end

	btn:registerScriptTapHandler(handler(self,self.onClickUnicorn))
	btn.icon:setSpriteFrame(string.format("alice/spr-unicorn-icon-%d.png",  self.unicorn_data.occupation))
end

function HeroShareInfoLayer:onClickUnicorn()
	require("src.layer.alice.AliceUnicornPreviewCtr"):instance():openWindow(self.unicorn_data.occupation, self.unicorn_data)
end

function HeroShareInfoLayer:onClickReiki(tag,pSender)
	if not self.reiki_equip then return end
	if self.reiki_equip[tag] then 
		local data = {}
		data.equip = {sys_id = self.reiki_equip[tag].sys_id}
		local equip_list = {}
		-- equip_list[1] = self.data.reiki_equip_id
		for k,v in pairs(self.reiki_equip) do
			table.insert(equip_list,v.sys_id)
		end
		data.equip_list = equip_list
		local ctr = require("src.layer.artifacts.ArtifactTipsCtr"):instance()
		ctr:openWindow()
		:addEquipInfo(data)
	end
end

function HeroShareInfoLayer:updateHeroAttach(equips, runes, gems, talents, god_equip, reiki_equip, pet_data, totem_data, magic_wand_data, unicorn_data)
	self.scroll_view:removeAllChildren()

	local content_layer = HeroShareInfoContentLayer:createWithCCBIFile("ccbi/HeroShareInfoContentLayer.ccbi")
	content_layer:setAutoClose(false)
	content_layer:setSwallowTouches(false)
	content_layer:setIgnoreAnchorPointForPosition(true)
	content_layer:setPosition(0, 0)
	self.scroll_view:setContainer(content_layer)
	
	self:updateEquip(content_layer, equips)
	self:updateRunes(content_layer, runes)
	self:updateTalents(content_layer, talents)
	self:updateGems(content_layer, gems)
	self:updateGodEquip(content_layer, god_equip)
	self:updataReikiEquip(content_layer, reiki_equip)
	self:updatePetInfo(content_layer,pet_data)
	self:updateTotemInfo(content_layer,totem_data)
	self:updateMagicWandInfo(content_layer, magic_wand_data)
	self:updateUnicornInfo(content_layer, unicorn_data)

	content_layer.menu:setIsTouchInsideNode(self.scroll_view)
	content_layer.menu:setSwallowsTouches(false)
	self.scroll_view:setContentSize(content_layer:getContentSize())
	self.scroll_view:setContentOffset(self.scroll_view:minContainerOffset())
end

function HeroShareInfoLayer:onClickEquip(tag,pSender)

    -- local equips = ex.Player.hero_data.equip:getHeroEquip(self.hero_data.hero_id).equip_list
	local equips = self.equip_data
	if equips[tag] ~= nil and equips[tag].equip_type ~= 0 then
		local data = cfg.equipmenttype.equip[equips[tag].equip_type]
		local info_ctr = require("src.layer.AbilityInfoCtr"):instance()
		info_ctr:openWindow()
		:addEquipInfo(data, equips)
		:addBlackBackground()
	end
end

function HeroShareInfoLayer:updateHeroEquip(equip_data)
	-- local equips = ex.Player.hero_data.equip:getHeroEquip(self.hero_data.hero_id).equip_list
    -- local redPoints = ex.Player.hero_data.equip:checkHeroEquipRedPoint(self.hero_data.hero_id)
    local equips = equip_data

	for i=1,EquipMaxCount do
		local equip = equips[i]

		local bg = self.equips[i]:getChildByName("bg")
		local icon = self.equips[i]:getChildByName("icon")
		local node_star = self.equips[i]:getChildByName("node_star")
		node_star:removeAllChildren()
		if bg ~= nil then 
	 		self.equips[i]:removeChildByName("bg")
	 		bg = nil 
	 	end
		if icon ~= nil then 
	 		self.equips[i]:removeChildByName("icon")
	 		icon = nil 
	 	end
	 	if equip ~= nil and equip.equip_type ~= 0 then 
	 		local size = self.equips[i]:getContentSize()
	 		local config = cfg.equipmenttype.equip[equip.equip_type]
	 		bg = cc.Sprite:createWithSpriteFrameName(string.format("other/rare-%d.png", cfg.item.item[equip.equip_type].rare_mark))
	 		bg:setName("bg")
	 		local scale = cc.p(size.width / bg:getContentSize().width, size.height / bg:getContentSize().height)
	 		scale = math.min(scale.x, scale.y)
	 		bg:setScale(scale)
	 		bg:setPosition(size.width * 0.5, size.height * 0.5)
	 		self.equips[i]:addChild(bg, 9)
	 		
			icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", equip.equip_type))
			icon:setName("icon")

			scale = cc.p(size.width / icon:getContentSize().width, size.height / icon:getContentSize().height)
			scale = math.min(scale.x, scale.y) * 0.8

			icon:setPosition(size.width * 0.5, size.height * 0.5)
			icon:setScale(scale)
			self.equips[i]:addChild(icon, 10)
			self:createEquipStar(self.equips[i],equip.equip_type)
         end
    end
end

function HeroShareInfoLayer:createEquipStar(parent,equip_type)
	local config = cfg.equipmenttype.equip[equip_type]
	local node_star = parent:getChildByName("node_star")
	node_star:removeAllChildren()

	local star_type = math.floor(config.star / 5)
	local star_count

	if config.star % 5 == 0 then 
		if config.star > 5 then
			star_count = 1
		else 
			star_count = 5
			star_type = 0
		end
	else
		star_count = config.star % 5
	end

	local path = string.format("other/star-%d.png",star_type)

	if config.star > 10 then star_count = star_count + 1 end

	local scale = 0.5
	for i=1,star_count do
		local sp = cc.Sprite:createWithSpriteFrameName(path)
		node_star:addChild(sp,star_count-i)
		local margin = 12
		local width = sp:getContentSize().width * scale-- + margin
		local length = (width / 2 * (star_count - 1))
		local offset = (parent:getContentSize().width - length) / 2
		local posX = offset + (width / 2) * (i - 1)
		sp:setPosition(posX,0)
		sp:setScale(scale)
	end

end

function HeroShareInfoLayer:updateRunes(root, runes_data)
    self.btn_runes = {}
	for i=1, 2 do
		self.btn_runes[i] = root["btn_runes_" .. i]
		self.btn_runes[i]:registerScriptTapHandler(handler(self,self.onClickRunes))
		self.btn_runes[i]:setTag(i)
		local node_star = cc.Node:create()
		node_star:setName("node_star")
		self.btn_runes[i]:addChild(node_star)
		node_star:setLocalZOrder(20)
		node_star:setPosition(0, 10)
    end
    

    local runes = runes_data
	for k,v in pairs(self.btn_runes) do

		local config = nil
		if runes[k] ~= nil then 
			config = ex.Player.backpack_data:getTypeConfig(runes[k].item_type)
			if config ~= nil then
				if v.icon ~= nil then
					v.icon:setSpriteFrame(string.format("backpack/%d.png", runes[k].item_type))
					v.icon_frame:setSpriteFrame(string.format("backpack/rare-%d.png", cfg.item.item[runes[k].item_type].rare_mark))
				else
					v.icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", runes[k].item_type))
					v:addChild(v.icon, 20)
					local size = v:getContentSize()
					v.icon:setPosition(size.width / 2, size.height / 2 - 3)

					v.icon_frame = cc.Sprite:createWithSpriteFrameName(string.format("backpack/rare-%d.png", cfg.item.item[runes[k].item_type].rare_mark))
					v:addChild(v.icon_frame, 10)
					-- v.icon_frame:setScale(0.7)
					local size = v:getContentSize()
					v.icon_frame:setPosition(size.width / 2, size.height / 2 - 3)

					scale = cc.p(size.width / v.icon:getContentSize().width, size.height / v.icon:getContentSize().height)
					scale = math.min(scale.x, scale.y) * 0.8
					v.icon:setScale(scale)
				end
			end
        end
        
		if runes[k] == nil or config == nil then
			if v.icon ~= nil and not tolua.isnull(v.icon) then 
				v.icon:removeFromParent()
				v.icon = nil
			end
			if v.icon_frame ~= nil and not tolua.isnull(v.icon_frame) then 
				v.icon_frame:removeFromParent()
				v.icon_frame = nil
			end
		end
	end

end

function HeroShareInfoLayer:onClickRunes(tag,pSender)
	if pSender.isOpen == false then
		local key = tag == 1 and "elf_1_unlock_level" or "elf_2_unlock_star"
		local value = ex.Tools:getSysCfg(key)
		if tag == 1 then 
			if self.hero_data.level < (value or 100) then
				ex.MessageView:add(ex.Tools:getLang(47188)..(value or 100))
			end
		else 
			if self.hero_data.star < (value or 8) then
				ex.MessageView:add(ex.Tools:getLang(47280)..(value or 8))
			end
		end
		return 
	end

	local runes = self.runes_data
	if runes[tag] ~= nil then 
		local ctr = require("src.layer.runes.RunesTipsCtr"):instance()
		ctr:openWindow()
		:addEquipInfo(runes[tag])
	end
end

function HeroShareInfoLayer:updateTalents(root, talents)
	for i,v in ipairs(talents) do
		if v.skill_id ~= 0 then
			local btn = root["btn_talent_"..v.slot]
			btn:registerScriptTapHandler(handler(self, self.onClickTalent))
			btn.local_data = v

			local btn_size = btn:getContentSize()
			local skill = cc.Sprite:createWithSpriteFrameName(string.format("skill-icon/%d.png", v.skill_id + math.max(0, v.level - 1)))  --cc.Sprite:createWithSpriteFrameName(string.format("skill-icon/%d.png", talent.skill_id))
			skill:setScale(1.645)
			skill:setAnchorPoint(ex.a.center)
			skill:setPosition(btn_size.width / 2, btn_size.height / 2)
			btn:getNormalImage():addChild(skill, 1)

			local pos = cc.p(btn_size.width * 0.15, btn_size.height * 0.85)
			local bg_level = cc.Sprite:createWithSpriteFrameName("win-bg/block-bg-29.png")
			bg_level:setPosition(pos)
			btn:getNormalImage():addChild(bg_level, 2)

			local lbl_level = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 40)
			lbl_level:setColor(cc.c3b(122, 71, 45))
			lbl_level:setAnchorPoint(0.5, 0.5)
			lbl_level:setScale(0.5)
			lbl_level:setPosition(pos)
			btn:getNormalImage():addChild(lbl_level, 3)

			lbl_level:setString(tostring(v.level))
		end
	end
end

function HeroShareInfoLayer:updateGems(root, gems)
	for i,v in ipairs(gems) do
		if v.jewel_type ~= 0 then
			local btn = root["btn_gem_"..v.place]
			btn:setVisible(false)

			local item = ex.Tools:createBackpackItem(v.jewel_type, 0)
			item:setEnableAction(true)
			item:setScale(0.7)
			item.local_data = v
			item:setPosition(btn:getPosition())
			root.menu:add(item)
			
			item:registerScriptTapHandler(handler(self, self.onGem))
		end
	end
end

function HeroShareInfoLayer:updateGodEquip(root, god_equip)
	for i,v in ipairs(god_equip) do
		if v.item_type ~= 0 and cfg.godequipment.godequipment[v.item_type] then

			local equip_ment_config = cfg.godequipment.godequipment[v.item_type]
			local btn = root["btn_god_equip_"..equip_ment_config.place]
			btn:setVisible(false)

			local item = ex.Tools:createBackpackItem(v.item_type, 0)
			item:setEnableAction(true)
			item:setScale(0.7)
			item.local_data = v
			item:setPosition(btn:getPosition())
			root.menu:add(item)
			
			item:registerScriptTapHandler(handler(self, self.onGodEquip))
		end
	end
end



function HeroShareInfoLayer:onClickTalent(tag, pSender)
	local local_data = pSender.local_data

	require("src.layer.HeroSkillInfoCtr"):instance():openWindow(local_data.skill_id, local_data.level)
end

function HeroShareInfoLayer:onGem(tag, pSender)
	local info_ctr = require("src.layer.heroinfo.StoneAbilityInfoCtr"):instance()
	info_ctr:openWindow()
	info_ctr:setStoneInfo(pSender.item_type)
end

function HeroShareInfoLayer:onGodEquip(tag, pSender)
	local info_ctr = require("src.layer.heroinfo.HeroGodEquipAbilityInfoCtr"):instance()
	info_ctr:openWindow()
	:setDataInfo(pSender.local_data)
	:addBlackBackground()
end

--------
function HeroShareInfoCtr:onCreate()
	self:setCCBIPath("ccbi/HeroShareInfoLayer.ccbi")
	
    self:setIsSingle(false)
end

function HeroShareInfoCtr:getLayerClass()
    return HeroShareInfoLayer
end

function HeroShareInfoCtr:getLayer()
    return self.layer
end

function HeroShareInfoCtr:openWindow(hero_data,
									 equips,
									 runes, 
									 gems, 
									 talents, 
									 god_equip,
									 reiki_equip_list,
									 pet_data,
									 totem_data, 
									 magic_wand_data,
									 unicorn_data)
    if self:isOpened() then
        return
    end
    print(totem_data.sys_id)
	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/skill-icon.plist")
	
    -- self.delete_status = false
    self:loadLayer()
    self:open()
    local data = {}
    data.hero_data = hero_data
    data.equips = equips or {}
	data.runes = runes or {}
	data.gems = gems or {}
	data.talents = talents or {}
	data.god_equip = god_equip or {}
	data.reiki_equip_list = reiki_equip_list or {}
	data.pet_data = pet_data
	local is_totem_open = ex.Player.hero_data.totems:checkTotemOpenByHeroData(hero_data)
	if totem_data then
		totem_data.isOpen = is_totem_open
	end
	data.totem_data = totem_data
	data.magic_wand_data = magic_wand_data
	data.unicorn_data = unicorn_data
	-- dump(data, "openWindow.data")
    self.layer:reset(data)
end

function HeroShareInfoCtr:openWindowById(hero_id)
    if self:isOpened() then
        return
	end
	
	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/skill-icon.plist")
	sfc:addSpriteFrames("ccbi-res/hero-share.plist")
    
    -- self.delete_status = false
    self:loadLayer()
    self:open()
	local data = clone(ex.Player.hero_data:getHeroDataById(hero_id))
	-- data:updateAbility()
	data.atk = data:getAtk()
	data.hp = data:getHp()
	data.def = data:getDef()
	data.agl = data:getSpd()

    data.hero_data = data
	data.equips = ex.Player.hero_data.equip:getHeroEquip(hero_id).equip_list or {}
	data.reiki_equip_list = ex.Player.hero_data.artifact:getArtifactDataByHeroId(hero_id)
	local pet_data = ex.Player.hero_data.pet:getPetByHeroId(hero_id)
	local totem_data = ex.Player.hero_data.totems:getTotemByHero(hero_id)
	local isOpen = ex.Player.hero_data.totems:checkTotemOpen(hero_id)
	if pet_data == nil  then 
		pet_data = {}
		pet_data.sys_id = 0
		pet_data.level = 0
	end

	if not totem_data then 
		totem_data = {}
		totem_data.sys_id = 0
		totem_data.lelvel = 0
		totem_data.quality = 0
	end
	totem_data.isOpen = isOpen
	data.pet_data = pet_data
	data.totem_data = totem_data
	-- data.pet_data = ex.Player.hero_data.pet:getPetByHeroId(hero_id)
	
	for k,v in pairs(data.equips) do
		v.equip_type = v.item_type
	end

	data.runes = ex.Player.backpack_data:getRunesDataByHeroId(hero_id) or {}
	data.gems = ex.Player.hero_data:getHeroJewelListForHeroid(data.hero_id)
	if data.gems == nil or data.gems.jewel_list == nil then
		data.gems = {}
	else
		data.gems = data.gems.jewel_list
	end

	local magic_data = ex.Player.hero_data.magic_wand:getMagicWandByHeroId(data.hero_id)
	data.magic_wand_data = magic_data
	local unicorn_data = ctr.alice.data:getUnicornDataByHeroId(hero_id)
	local occupation = cfg.herotype.star[data.hero_type].occupation
	data.unicorn_data = unicorn_data
	data.unicorn_data.occupation = occupation
	-- dump(data, "openWindowById.data", 10)
    self.layer:reset(data)
end

return HeroShareInfoCtr
