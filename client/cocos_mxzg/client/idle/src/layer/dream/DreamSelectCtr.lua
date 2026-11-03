local DreamSelectCtr = class("DreamSelectCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local DreamSelectLayer = class("DreamSelectLayer", require("src.comp.EventLayerAdaptiveWidth"))
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

local string_format = string.format


------------------------------------------------

function DreamSelectLayer:onCreate()
	self:addBlackBackground()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

end

function DreamSelectLayer:initDone()

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/dream.plist")
	sfc:addSpriteFrames("ccbi-res/dream-lang.plist")

	-- -- 需要发送通知后端
	ex.Player.dream_data:gReqDreamlandStartBattle()
	-- ex.Player.dream_data:gReqDreamlandBattleStatus()

    -- self.spr_scroll_bg

	self.lbl_1:enableOutline(cc.c4b(68, 32, 11, 255), 2)
	self.lbl_2:enableOutline(cc.c4b(122, 71, 45, 255), 2)
	
	self:updateScroll()
	self:updateNowLevel()
	self:addEvent(EVENT.DREAM_EVENT.UPDATE_NOW_LEVEL,handler(self,self.updateNowLevel))
	self:addEvent(EVENT.DREAM_EVENT.MAIN_SHOW_BTN,handler(self,self.updateNowLevel))
end

function DreamSelectLayer:updateNowLevel()
	self.lbl_2:setString(string_format(ex.Tools:getLang(72041), math.max(ex.Player.dream_data.cur_lv + 1, ex.Player.dream_data.curr_battle_lv)) )
end

function DreamSelectLayer:updateHeroData( )
	self:setHeroList()
end

function DreamSelectLayer:setHeroList( )
	
    local menu = cpp.UIMenu:create()
    :setSwallowsTouches(false)
    :setName("hero_menu")
    :setPosition(cc.p(0, 0))
    self.hero_list:addChild(menu)

    local begin = 8
    local margin = 5
    local posY = 70
	local scale = 0.8

	local index = 1
	for i=1,LineupNum do
		local data = ex.Player.dream_data.hero_list[i]
		if data ~= nil and data.type > 0 then
			local hero_data = {}
			hero_data.level = data.level
			hero_data.star = data.star
			hero_data.hero_type = data.type
			hero_data.elem = data.elem
			hero_data.evolve = data.evolve

			local item = UIMenuItemHero:createWithData(0, 0, 0, 0)
			item:reset(hero_data)
			
			local posX = (begin + item:getContentSize().width * scale / 2) + (index - 1) * ((item:getContentSize().width * scale) + margin)

			item:setPosition(posX,posY)
			menu:addChild(item)

			if data.fashion_id ~= 0 and data.fashion_id ~= nil then   -- 有皮肤
				item:setFashionShowForce(data.fashion_id)
			end

			item:setCompleted(data.hp, data.max_hp, true)

			if data.hp < 1 then 
				item:setDeath(true)
			end

			item:resetBg(nil, nil)
			item:setScale(scale)

			index = index + 1
		end
    end	
end

function DreamSelectLayer:updateScroll( )

	local cell_data = {}

	for i,v in ipairs(ex.Player.dream_data.next_buff_id) do
		table.insert( cell_data, v )
	end

	if not self.reward_list then 
		local win_size = cc.size(self.buff_list:getContentSize().width,self.buff_list:getContentSize().height - 10)

		self.reward_list = ex.Tools:initTableView(self.buff_list,cell_data, {require("src.layer.dream.DreamSelectCell"),"ccbi/DreamSelectCell.ccbi"} , win_size, 5,cc.p(0,5),true)
	else 
		self.reward_list:initData(cell_data)
		self.reward_list:reloadData()
	end 	

end


function DreamSelectLayer:onShowInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

------------------------------------------------
function DreamSelectCtr:updateHeroData()

    self.layer:updateHeroData()
end

function DreamSelectCtr:onCreate()
	self:setCCBIPath("ccbi/DreamSelectLayer.ccbi")
	self:setIsSingle(false)
end

function DreamSelectCtr:getLayerClass()
	return DreamSelectLayer
end

function DreamSelectCtr:openWindow()
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
    self.layer:initDone()
    --self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

end

return DreamSelectCtr











