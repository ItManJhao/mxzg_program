-- BattleEndCtr

local BattleEndCtr = class("BattleEndCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local BattleEndLayer = class("BattleEndLayer",require("src.comp.EventLayerAdaptiveWidth"))
local ExTimer = require("src.ex.ExTimer")

function BattleEndLayer:onCreate()
	self:setAutoClose(true)
	self:addBlackBackground()
	self.time = 5

	self:setExitCallback(handler(self,self.exitCallBack))

	self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)

    self.scroll_view = require("src.comp.UIScrollViewBackpack"):createWithSize(cc.size(self.spr_bg:getContentSize().width - 40, 260))
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	:setPosition(20, 0)
	self.scroll_view:setItemSize(cc.size(124, 134))
	self.scroll_view:setCreateNum(4)
	self.scroll_view:setAlignmentCenter(true)
    self:addChild(self.scroll_view)

	-- 指引需要
	self.btn_confirm:setName("battle_end_confirm")

	ex.Tools:layerEnterAction(self)
end

function BattleEndLayer:onExit()
	ex.EventManager:fire(EVENT.GUIDE.CLOSE_CHAPTER_END)
end

function BattleEndLayer:startTimer()
	
	self:addTimer("timer",1000,handler(self,self.changTimer),true)
	self:addTimer("timerExp",100,handler(self,self.updateCDTime),true)
end

function BattleEndLayer:changTimer()
	self.time = self.time - 1 

	self.lbl_time:setString(string.format(ex.Tools:getLang(47336),self.time))
	if self.time <= 0 then 
		self:removeTimerByName("timer")
		require("src.layer.BattleEndCtr"):instance():closeWindow()
	end
end


function BattleEndLayer:exitCallBack()
	self:removeTimerByName("timer")
	self:removeTimerByName("timerExp")

	if self.callback then
		self.callback(self.is_win, self.idx)
	end
end


function BattleEndLayer:autoProgressTimer( )

	local need_exp = 0
	local config = cfg.mainlevel.mainlevel[ex.Player.level]


	self:reorderChild(self.lbl_role_exp_num, 10)

	local posBar = cc.p(0, 0)
	posBar.x = self.role_exp:getPositionX() - self.role_exp:getContentSize().width * 0.5 + 2
	posBar.y = self.role_exp:getPositionY()

	self.progressTimer = require("src.comp.UIScale9SpriteEx"):create("battle-end/spr-jdt2.png", cc.rect(16, 16, 16, 16))
	self.progressTimer:setAnchorPoint(cc.p(0, 0.5))
	self.progressTimer:setContentSize(cc.size(self.role_exp:getContentSize().width-4, self.role_exp:getContentSize().height-7))
	self.progressTimer:setPosition(posBar)
	self.progressTimer:setPercentage(0)
	self:addChild(self.progressTimer)

	self.lbl_role_lv:setString("Lv " .. tostring(ex.Player.level))

	--self.progressTimer:setPercentage(1.0 * ex.Player.exp / config.exp * 100)

	self.start_pro = 0
	if ex.Player.exp - ex.Player.last_add_exp < 0 then 
		self.progressTimerType = 1

		self.lbl_role_lv:setString("Lv " .. (tostring(ex.Player.level - 1)))

		local up_level_config = cfg.mainlevel.mainlevel[ex.Player.level]
		local config = cfg.mainlevel.mainlevel[ex.Player.level - 1]
		self.start_pro = ex.Player.exp - ex.Player.last_add_exp + config.exp
		self.progressTimer:setPercentage(1.0 * self.start_pro / config.exp * 100)

	else 
		self.progressTimerType = 2

		local config = cfg.mainlevel.mainlevel[ex.Player.level]
		self.start_pro = ex.Player.exp - ex.Player.last_add_exp
		self.progressTimer:setPercentage(1.0 * self.start_pro / config.exp * 100)

	end 

end


function BattleEndLayer:updateCDTime()

	self.start_pro =self.start_pro + ex.Player.last_add_exp * 0.1
	if self.progressTimerType ==1 then

		local up_level_config = cfg.mainlevel.mainlevel[ex.Player.level]
		local config = cfg.mainlevel.mainlevel[ex.Player.level - 1]
		
		self.progressTimer:setPercentage(1.0 * self.start_pro / config.exp * 100)

		if self.start_pro > config.exp then 
			self.progressTimerType = 2

			self.start_pro = 0
			self.lbl_role_lv:setString("Lv " .. (tostring(ex.Player.level)))

		end 

		self.lbl_role_exp_num:setString(tostring(self.start_pro).. "/" .. config.exp)

	else  
		local config = cfg.mainlevel.mainlevel[ex.Player.level]
		if self.start_pro < ex.Player.exp then 
			self.progressTimer:setPercentage(1.0 * self.start_pro / config.exp * 100)
			self.lbl_role_exp_num:setString(tostring(self.start_pro).. "/" .. config.exp)

		else
			self:removeTimerByName("timerExp")

			self.progressTimer:setPercentage(1.0 * ex.Player.exp / config.exp * 100)
			self.lbl_role_exp_num:setString(tostring(ex.Player.exp).. "/" .. config.exp)

		end 

	end 

end 




-----------------------------------------------------------------------------
function BattleEndCtr:onCreate()
	self:setCCBIPath("ccbi/BattleEndLayer.ccbi")
	self:setIsSingle(false)
end

function BattleEndCtr:getLayerClass()
	return BattleEndLayer
end

function BattleEndCtr:getChapterEndLayer()
	return self.layer
end

function BattleEndCtr:openWindow(is_win, vec_reward, callback, idx, vec_battle_detail)
	if self:isOpened() then
		return
	end

	local sfc = cc.SpriteFrameCache:getInstance()
	-- sfc:addSpriteFrames("ccbi-res/summon-effect.plist")
	sfc:addSpriteFrames("ccbi-res/main-scene.plist")
	sfc:addSpriteFrames("ccbi-res/main-city.plist")
	sfc:addSpriteFrames("ccbi-res/battle-end-1.plist")
	sfc:addSpriteFrames("ccbi-res/battle-end-lang.plist")
    
	self:loadLayer()
	self:open()
	self:initData(is_win, vec_reward, callback, idx, vec_battle_detail)
end


function BattleEndCtr:setHero(hero_type, level, star, hero_id, evolve)
	local fashion_id = 0
	if hero_id then
		fashion_id = ex.Player.hero_data.fashion:getWearByID(hero_id) or 0
	end
	local show_hero_image = nil
	if fashion_id == 0 then
        local skin = ex.Tools:getHeroSkinByStar(hero_type, star, evolve)
        show_hero_image = require("src.person.Hero"):create("12323", "123213", hero_type,level, star, skin)
    else
        show_hero_image = require("src.person.Hero"):create("1", "1", 1, 1, 1, fashion_id)
    end
    show_hero_image:setScale(1.5 * 1.42)
    show_hero_image:setPosition(0,0)
    self.layer.show_hero:addChild(show_hero_image)

	--self.layer:reorderChild(self.layer.show_hero, 100)

end



function BattleEndCtr:autoProgressTimer( )
	self.layer:autoProgressTimer()
	-- local need_exp = 0
    -- local config = cfg.mainlevel.mainlevel[ex.Player.level]

    -- self.layer.lbl_role_exp_num:setString(tostring(ex.Player.exp).. "/" .. config.exp)

	-- self.layer:reorderChild(self.layer.lbl_role_exp_num, 10)

    -- local posBar = cc.p(0, 0)
    -- posBar.x = self.layer.role_exp:getPositionX() - self.layer.role_exp:getContentSize().width * 0.5 + 2
    -- posBar.y = self.layer.role_exp:getPositionY() + 1
	
	-- self.progressTimer = require("src.comp.UIScale9SpriteEx"):create("battle-end/spr-jdt2.png", cc.rect(16, 16, 16, 16))
	-- self.progressTimer:setAnchorPoint(cc.p(0, 0.5))
	-- --self.progressTimer:setContentSize(self.layer.role_exp:getContentSize())
	-- self.progressTimer:setContentSize(cc.size(self.layer.role_exp:getContentSize().width-4, self.layer.role_exp:getContentSize().height-8))
	-- self.progressTimer:setPosition(posBar)
	-- self.progressTimer:setPercentage(0)
	-- self.layer:addChild(self.progressTimer)

    -- self.layer.lbl_role_lv:setString("Lv " .. tostring(ex.Player.level))

	-- self.progressTimer:setPercentage(1.0 * ex.Player.exp / config.exp * 100)
	-- self.start_pro = 0
	-- if ex.Player.exp - ex.Player.last_add_exp < 0 then 
	-- 	self.progressTimerType = 1

	-- 	self.layer.lbl_role_lv:setString("Lv " .. (tostring(ex.Player.level - 1)))

	-- 	local up_level_config = cfg.mainlevel.mainlevel[ex.Player.level]
	-- 	local config = cfg.mainlevel.mainlevel[ex.Player.level - 1]
	-- 	self.start_pro = ex.Player.exp - ex.Player.last_add_exp + up_level_config.exp

	-- 	self.progressTimer:setPercentage(1.0 * self.start_pro / config.exp * 100)

	-- else 
	-- 	self.progressTimerType = 2

	-- 	local config = cfg.mainlevel.mainlevel[ex.Player.level]
	-- 	self.start_pro = ex.Player.exp - ex.Player.last_add_exp
	-- 	self.progressTimer:setPercentage(1.0 * self.start_pro / config.exp * 100)

	-- end 

--	

end

function BattleEndCtr:updateCDTime()

	self.start_pro =self.start_pro + 50
	if self.progressTimerType ==1 then

		local up_level_config = cfg.mainlevel.mainlevel[ex.Player.level]
		local config = cfg.mainlevel.mainlevel[ex.Player.level - 1]
		self.start_pro = ex.Player.exp - ex.Player.last_add_exp + up_level_config.exp
		
		self.progressTimer:setPercentage(1.0 * self.start_pro / config.exp * 100)

	else  

		local config = cfg.mainlevel.mainlevel[ex.Player.level]
		self.start_pro = ex.Player.exp - ex.Player.last_add_exp
		self.progressTimer:setPercentage(1.0 * self.start_pro / config.exp * 100)
	end 

end 



function BattleEndCtr:initData(is_win, vec_reward, callback, idx, vec_battle_detail)
	self.layer.btn_report:registerScriptTapHandler(handler(self, self.onBattleDetail))
	self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onBtnConfirm))

    local max_damage = 0
    local max_damage_hero_data = nil
	for i,v in ipairs(vec_battle_detail.attacker_log.hero_log) do
		if v.total_damage > max_damage then
            max_damage = v.total_damage
            max_damage_hero_data = clone(v)
		end
	end

	if max_damage_hero_data == nil then
		max_damage_hero_data = vec_battle_detail.attacker_log.hero_log[1]
	end

    self:setHero(max_damage_hero_data.hero_type, max_damage_hero_data.level, max_damage_hero_data.star, max_damage_hero_data.hero_id, max_damage_hero_data.evolve)

    self.layer.lbl_hero_nums:setString(max_damage)
    self.layer.lbl_hero_name:setString(ex.Tools:getLang(max_damage_hero_data.hero_type))

    local lbl_btn_refresh = require("src.comp.RichTextEx"):create()
	:setFontSize(20)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setAnchorTextShadow(true)
    :setWrapMode(1)

	self.layer.show_rich:addChild(lbl_btn_refresh)
    lbl_btn_refresh:setPosition(0,0)
    
    --now lev
    local show_tip_language = 0
    local need_chapter = 0

	-- local list_chapter = clone(cfg.chapterextrareward.chapterextrareward)
	-- local sort_list = function(a,b) 
	-- 	return a.idx < b.idx
	-- end 
	-- table.sort( list_chapter, sort_list )

    local now_idx = ex.Player.chapter_data:getNowExtraReward()

	local  chapter_data = cfg.chapterextrareward.chapterextrareward[now_idx]
	if chapter_data then 
		show_tip_language = chapter_data.tips_lang
		need_chapter = chapter_data.chapter - ex.Player.chapter_data.chapter_id

		local str = ""
		if need_chapter <= 0 then 
			str = ex.Tools:getLang(chapter_data.other_tip_language)
		else 
			str = string.format(ex.Tools:getLang(show_tip_language), need_chapter )
		end 
		lbl_btn_refresh:setXmlTextLua(str)
	end 

	ex.Tools:setSpriteFrame(self.layer.spr_photo, string.format("head-icon/%d.png", ex.Player.head_id))
	ex.Tools:setSpriteFrame(self.layer.spr_photo_bg, ex.Tools:getBorderIconByIdx(ex.Player.border_id))

    -- self.layer.spr_photo:setSpriteFrame(string.format("head-icon/%d.png", ex.Player.head_id))
    -- self.layer.spr_photo_bg:setSpriteFrame(ex.Tools:getBorderIconByIdx(ex.Player.border_id))

    -- cfg.herolevel.level
    -- local need_exp = cfg.herolevel.level[ex.Player.level + 1]
    -- if not need_exp then need_exp = cfg.herolevel.level[ex.Player.level] end 
	
	self:autoProgressTimer()

	local layer = self.layer
	layer.is_win = is_win
	layer.callback = callback
	layer.idx = idx
	vec_reward = vec_reward or {}
	self.vec_battle_detail = vec_battle_detail
	
    -- layer.scroll_view:getContainer():removeAllChildren()

	-- local menu = cpp.UIMenu:create()
    -- menu:setSwallowsTouches(false)
    -- menu:setPosition(cc.p(0, 0))
    -- menu:setIsTouchInsideNode(layer.scroll_view)
    -- layer.scroll_view:getContainer():addChild(menu)

    -- local view_size = layer.scroll_view:getViewSize()
    -- local item_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()
	-- item_size = cc.size(item_size.width + 20,  item_size.height + 15)

	-- local num = table.nums(vec_reward)
	-- local col = math.floor(view_size.width / item_size.width) -- 列数
	-- col = math.min(col, num)
	-- local row =  math.ceil(1.0 * num / col) -- 行数
	-- local cont_height = item_size.height * row
	-- cont_height = math.max(cont_height , view_size.height)

	-- layer.scroll_view:setContentSize(cc.size(view_size.width, cont_height))
	-- layer.scroll_view:setContentOffset(cc.p(0, view_size.height - cont_height))

  	-- cont_height = cont_height - item_size.height * 0.5
  	-- if row == 1 then
    -- 	cont_height = cont_height - 20
    -- end

 	-- local start = cc.p(view_size.width * 0.5 - item_size.width * (col - 1) * 0.5, cont_height)

    -- local index = 0
	-- for _,v in ipairs(vec_reward) do
	-- 	local x = index % col
    --     local y = math.floor(index / col)

    --     local pos = cc.p(start.x + x * item_size.width, start.y - y * item_size.height)

	-- 	local item = ex.Player.backpack_data:createWithData(v.item_type, v.item_num)
	-- 	item:setPosition(pos)
    --     item:registerScriptTapHandler(handler(self, self.onItem))
    --     menu:addChild(item)

	-- 	index = index + 1
    -- end

	layer.scroll_view.createItemFunction = function(v, scale)
		local item = ex.Player.backpack_data:createWithData(v.item_type, v.item_num)
		item:registerScriptTapHandler(handler(self, self.onItem))
		ex.Tools:itemEnterAction(item)
		return item
	end
	layer.scroll_view:reloadData(vec_reward)


    -- 更改显示
	ex.Tools:setSpriteFrame(layer.spr_wing, string.format("battle-end/spr-wing-%d.png", is_win and 1 or 0))
	ex.Tools:setSpriteFrame(layer.spr_result, string.format("battle-end-lang/lbl-result-%d.png", is_win and 1 or 0))

    layer.spr_result2:setVisible(false)
	layer.lbl_faild:setVisible(is_win == false)
    layer.menu:setVisible(is_win == false)
    --layer.lbl_time:setVisible(is_win == false)
    layer.lbl_faild:enableOutline(cc.c3b(92,54,35), 1)

    layer.menu:setLocalZOrder(100)
    
	if is_win == true then
		ex.EffectFactory:createEffectWithNodeByNameAsyn("eff_battle_end", layer.spr_wing, cc.p(layer.spr_wing:getContentSize().width / 2, layer.spr_wing:getContentSize().height / 2 + 40), 0)

    	-- local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_battle_end")
    	-- spr_effect:setPosition(layer.spr_wing:getContentSize().width / 2, layer.spr_wing:getContentSize().height / 2 + 40)
    	-- spr_effect:setScale(1)
        -- layer.spr_wing:addChild(spr_effect, 0, 10)	

		ex.EffectFactory:createEffectWithSpineByNameAsyn("spine/chibang", nil, layer, cc.p(layer.spr_wing:getPositionX(), layer.spr_wing:getPositionY()), 0)

    --     local chibang = sp.SkeletonAnimation:create("spine/chibang.json","spine/chibang.atlas", 1)
    --     chibang:setAnimation(0, "idle", true);
    --    -- chibang:setPosition(layer.spr_wing:getPositionX() + layer.spr_wing:getContentSize().width / 2, layer.spr_wing:getPositionY() +  layer.spr_wing:getContentSize().height / 2)
	--    chibang:setPosition(layer.spr_wing:getPositionX(), layer.spr_wing:getPositionY())
	--    layer:addChild(chibang)

		layer.spr_result:setVisible(false)
		layer.spr_wing:setVisible(false)

		layer:changTimer()
    	layer:startTimer()

    else
		local btn1 = self:createBtn("main-city/up-main_summon.png","main_summon",ex.Tools:getLang(47600))
    	local size = btn1:getContentSize()
    	local margin = 50
    	local win_size = layer:getContentSize()
    	local offsetX = win_size.width / 2 - ((size.width*4 + margin*4) / 2)
    	layer.menu:addChild(btn1)
    	btn1:setPosition(offsetX + size.width / 2 + margin / 2,180)
    	local btn2 = self:createBtn("main-scene-lang/spr-hero.png","main_hero",ex.Tools:getLang(47334))
    	layer.menu:addChild(btn2)
    	btn2:setPosition(offsetX + size.width / 2 + margin / 2 + size.width + margin,180)
		local btn3 = self:createBtn("main-city/up-main_smith_shop.png","main_smith_shop",ex.Tools:getLang(47302))
    	layer.menu:addChild(btn3)
    	btn3:setPosition(offsetX + size.width / 2 + margin / 2 + (size.width + margin) * 2,180)
    	local btn4 = self:createBtn("main-scene/spr-fetter.png","main_fetter",ex.Tools:getLang(47110))
    	layer.menu:addChild(btn4)
    	btn4:setPosition(offsetX + size.width / 2 + margin / 2 + (size.width + margin) * 3,180)

    	layer:changTimer()
    	layer:startTimer()
    end

	ex.AudioManager:playEffect(string.format("music/battle-main-end-%d.mp3", is_win and 1 or 0))
    ex.AudioManager:playEffect(string.format("music/battle-end-%d.mp3", is_win and 1 or 0))
end

function BattleEndCtr:createBtn(path,atom,name)
	-- body
	local btn = cpp.UIMenuItemImage:createWithSpriteFrameName("main-scene/btn-bg.png", nil, nil)
	btn:setName(atom)
	btn:registerScriptTapHandler(handler(self,self.onclick))
	local sp = cc.Sprite:createWithSpriteFrameName(path)
	local size = btn:getContentSize()
	sp:setScaleX(size.width / sp:getContentSize().width)
	sp:setScaleY(size.height / sp:getContentSize().height)
	btn:addChild(sp)
	sp:setPosition(size.width / 2,size.height / 2)
	local lbl = cc.Label:createWithTTF(name, FONT_DEFAULT_NAME_BOLD, 24)
	lbl:enableOutline(cc.c3b(92,54,35), 1)
	btn:addChild(lbl)
	lbl:setPosition(size.width/2,0)
	return btn
end

function BattleEndCtr:onclick(tag,pSender)
	print(self.__cname,"click")
	self:closeWindow()
    local atom = pSender:getName()
    ex.JumpManager:jumpByAtom(atom)
end

function BattleEndCtr:onceAnim(pos, str_spr, str_plist, str_png)
	local spr_effectOnce = cc.Sprite:createWithSpriteFrameName(str_spr)
    spr_effectOnce:setScale(1.35)
    spr_effectOnce:setPosition(pos)
    self.layer.scroll_view:getContainer():addChild(spr_effectOnce)

    local action = cpp.ActionFactory:createLuaAnimate(str_plist, str_png, 0.05)
    spr_effectOnce:runAction(cc.Sequence:create(action, cc.CallFunc:create(function()
    	spr_effectOnce:setVisible(false)
    end)))
end

function BattleEndCtr:onItem(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function BattleEndCtr:onConfirm(tag, pSender)
	local layer = self.layer

	if layer.callback then
		layer.callback(layer.is_win, layer.idx)
	end
	
	self:closeWindow(tag, pSender)
end

function BattleEndCtr:onBattleDetail(tag, pSender)
	require("src.layer.BattleDetailCtr"):instance():openWindow(self.vec_battle_detail)
end


function BattleEndCtr:onBtnConfirm(tag, pSender)
    self:closeWindow()
end

return BattleEndCtr
