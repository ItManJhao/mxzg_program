local HeroInfoUnfoldCtr = class("HeroInfoUnfoldCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroInfoUnfoldLayer = class("HeroInfoUnfoldLayer", require("src.layer.ui.UI_HeroInfoUnfoldLayer"))
------------------------------------------------
function HeroInfoUnfoldLayer:onCreate()
	self.super.onCreate(self)
	self:setName("HeroInfoUnfoldLayer")

	self:addEvent(EVENT.PET.PET_CHANGE,handler(self,self.updatePet))
	self:addEvent(EVENT.PET.PET_OUT,handler(self,self.updatePet))
	self:addEvent(EVENT.PET.PET_UP_LEVEL,handler(self,self.updatePet))
	self:addEvent(EVENT.HERO_INFO_EVENT.HERO_UP_STAR,handler(self,self.updatePet))

	self:addEvent(EVENT.HERO_INFO_EVENT.HERO_UP_STAR,handler(self,self.updateTotem))
	self:addEvent(EVENT.TOTEM.UP_GRADE,handler(self,self.updateTotem))
	self:addEvent(EVENT.TOTEM.UP_LEVEL,handler(self,self.updateTotem))
	self:addEvent(EVENT.TOTEM.UPDATA_EQUIP_INFO,handler(self,self.updateTotem))
	self:addEvent(EVENT.TOTEM.RESET,handler(self,self.updateTotem))

	self:addEvent(EVENT.HERO_INFO_EVENT.SOUL, handler(self, self.updateSoul))

	self:addEvent(EVENT.FASHION_SETTING.WEAR, handler(self, self.updateSkin))
	self:addEvent(EVENT.FASHION_SETTING.DATA_DIRTY, handler(self, self.updateSkin))

	self:addEvent(EVENT.HERO_HEXAGRAM_EVENT.UPDATE, handler(self, self.updateHexagram))
	self:addEvent(EVENT.HERO_HEXAGRAM_EVENT.UPGRADE, handler(self, self.updateHexagram))
	self:addEvent(EVENT.HERO_HEXAGRAM_EVENT.RESET, handler(self, self.updateHexagram))

	self:addEvent(EVENT.HERO_INFO_EVENT.MAGIC_WAND_WEAR, handler(self, self.updateMagicWand))
	self:addEvent(EVENT.HERO_INFO_EVENT.MAGIC_WAND_STRENGTHEN, handler(self, self.updateMagicWand))
	self:addEvent(EVENT.HERO_INFO_EVENT.MAGIC_WAND_REFINE, handler(self, self.updateMagicWand))
	
	self:addEvent(EVENT.HERO_INFO_EVENT.EXIT_HREO_RESET,handler(self,self.onCloseReset))
end

function HeroInfoUnfoldLayer:onCloseReset()
	require("src.layer.heroinfo.HeroResetLifeCtr"):instance():closeWindow()
	self:onClose()
end

function HeroInfoUnfoldLayer:onEnterFinish()

end

function HeroInfoUnfoldLayer:resetData(position, hero_data)
	self.hero_data = hero_data
	self:setPosition(math.min(ex.p.width - self:getContentSize().width, position.x), position.y)

	self:updateSkin()

	self:updateSoul()

	self:updatePet()

	self:updateTotem()

	self:updateReset()

	self:updateHexagram()

	self:updateMagicWand()


	self:resetLyt()
end

function HeroInfoUnfoldLayer:updateSkin()
	local fashion_list = cfg.herofashion.getConfigsByHeroType(self.hero_data.hero_type)
	self.btn_skin:setVisible(#fashion_list > 0)
	ex.Tools:addRedPoint(self.btn_skin, ex.Player.hero_data.fashion:checkSkinReddot(self.hero_data.hero_type), ex.r.p8)
end

function HeroInfoUnfoldLayer:updateSoul( )
	local need_star = cfg.heroequipsoulextra.heroequipsoulextra[1].need_star
	self.btn_soul:setVisible(self.hero_data.star >= need_star)
	ex.Tools:addRedPoint(self.btn_soul, ex.Player.hero_data.equip:checkSoulReddot(self.hero_data.hero_id), ex.r.p8)
end

function HeroInfoUnfoldLayer:updatePet()
	local open = ex.Player.hero_data.pet:isOpenPetByHero(self.hero_data.hero_id)
	self.btn_pet:setVisible(open)

	local pet_data = ex.Player.hero_data.pet:getPetByHeroId(self.hero_data.hero_id)
	local is_red = ex.Player.hero_data.pet:checkRedPointByHeroId(self.hero_data.hero_id)
	ex.Tools:addRedPoint(self.btn_pet, is_red, cc.p(0.9,0.9))

	if not pet_data then
		self.spr_pet_icon:setVisible(false)
	else
		self.spr_pet_icon:setVisible(true)
		ex.Tools:setSpriteFrame(self.spr_pet_icon, string.format("backpack/%s.png", pet_data.sys_id));
	end
end

function HeroInfoUnfoldLayer:updateTotem()
	local is_open = ex.Player.hero_data.totems:checkTotemOpen(self.hero_data.hero_id)
	self.btn_totem:setVisible(is_open)

	if not is_open then return end
	
	local totem_data = ex.Player.hero_data.totems:getTotemByHero(self.hero_data.hero_id)
	local red = ex.Player.hero_data.totems:checkRedPointByHeroId(self.hero_data.hero_id)
	ex.Tools:addRedPoint(self.btn_totem, red, cc.p(0.9,0.9))

	self.spr_totem_icon:setVisible(totem_data ~= nil)
	self.spr_totem_rare:setVisible(totem_data ~= nil)
	if totem_data == nil then 
		return
	end

	ex.Tools:setSpriteFrame(self.spr_totem_icon, string.format("backpack/%d.png",  totem_data.sys_id))
	ex.Tools:setSpriteFrame(self.spr_totem_rare, string.format("backpack/rare-%d.png",  cfg.item.item[totem_data.sys_id].rare_mark - 1 + totem_data.quality))
end

function HeroInfoUnfoldLayer:updateReset()
	local is_open = ex.Player.hero_data:isShowReset(self.hero_data)	
	self.btn_reset:setVisible(is_open)
end

function HeroInfoUnfoldLayer:updateMagicWand()
	local is_open = ex.Player.hero_data.magic_wand:isVisibleMagicWand(self.hero_data.hero_id)
	self.btn_magic_wand:setVisible(is_open)
	if not is_open then return end

	local red = ex.Player.hero_data.magic_wand:checkReddot(self.hero_data.hero_id)
	ex.Tools:addRedPoint(self.btn_magic_wand, red, cc.p(0.9,0.9))

	local magic_data = ex.Player.hero_data.magic_wand:getMagicWandByHeroId(self.hero_data.hero_id)
	self.spr_magic_wand_icon:setVisible(magic_data ~= nil)
	self.spr_magic_wand_rare:setVisible(magic_data ~= nil)
	if magic_data == nil then 
		return
	end

	self.lbl_magic_wand_level:setString(string.format("+%s", magic_data.strengthen_lv))

	self:removeNodeLoadRes(self.spr_magic_wand_icon)
	self:removeNodeLoadRes(self.spr_magic_wand_rare)
	ex.Tools:setSpriteFrame(self.spr_magic_wand_icon, string.format("backpack/%d.png",  magic_data.item_type))
	ex.Tools:setSpriteFrame(self.spr_magic_wand_rare, string.format("backpack/rare-%d.png", cfg.magicwandtype.magicwandtype[magic_data.item_type].rare ))
end

function HeroInfoUnfoldLayer:updateHexagram()
	local is_open = ex.Player.hero_data.hexagram:isVisibleHexagram(self.hero_data.hero_id)
	self.btn_hexagram:setVisible(is_open)
	if not is_open then return end
	
	local red = ex.Player.hero_data.hexagram:checkReddot(self.hero_data.hero_id)
	ex.Tools:addRedPoint(self.btn_hexagram, red, cc.p(0.9,0.9))
end

function HeroInfoUnfoldLayer:onSoul()
	require("src.layer.heroinfo.HeroSoulCtr"):instance():openWindow()
end

function HeroInfoUnfoldLayer:onSkin()
	require("src.layer.skinsystem.HeroSkinSettingCtrl"):instance():openWindow(self.hero_data.hero_id)
end

function HeroInfoUnfoldLayer:onPet()
	require("src.layer.pet.PetInfoCtr"):instance():openWindow(self.hero_data.hero_id)
end

function HeroInfoUnfoldLayer:onTotem()
	local totem_data = ex.Player.hero_data.totems:getTotemByHero(self.hero_data.hero_id)
	if not totem_data then 
		local data = ex.Player.hero_data.totems:getTotemsList()
		require("src.layer.totems.TotemListCtr"):instance():openWindow(data)
	else
		require("src.layer.totems.TotemInfoCtr"):instance():openWindow(self.hero_data.hero_id)
	end
end

function HeroInfoUnfoldLayer:onResetLife()	
	if self.hero_data.star > cfg.system.hero_level_reset_limit then
		ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
		ex.JumpManager:jumpByAtom("act_altar_reborn")
	else
		require("src.layer.heroinfo.HeroResetLifeCtr"):instance():openWindow(self.hero_data)
		NetManager:sendMessage(ProtocolID.GReqHeroLevelResetTimes)
	end
end

function HeroInfoUnfoldLayer:onHexagram()
	if ex.JumpManager:checkOpenConditionByAtom("hero_hexagram") ~= true then
		return
	end

	require("src.layer.herohexagram.HeroHexagramCtr"):instance():openWindow(self.hero_data.hero_id)
end

function HeroInfoUnfoldLayer:onMagicWand()
	if ex.JumpManager:checkOpenConditionByAtom("hero_magic_wand") ~= true then
		return
	end

	require("src.layer.heromagicwand.HeroMagicWandWearCtr"):instance():openWindow(self.hero_data.hero_id)
end

-----------------------------------------------
function HeroInfoUnfoldCtr:loadLayer()
    local tmp_layer = HeroInfoUnfoldLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function HeroInfoUnfoldCtr:onCreate()
	self:setIsSingle(false)
end

function HeroInfoUnfoldCtr:getLayerClass()
	return HeroInfoUnfoldLayer
end

function HeroInfoUnfoldCtr:openWindow(position, hero_data)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
    self.layer:resetData(position, hero_data)
end

return HeroInfoUnfoldCtr

