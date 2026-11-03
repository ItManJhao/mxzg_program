local ChapterEndCtr = class("ChapterEndCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ChapterEndLayer = class("ChapterEndLayer", require("src.comp.EventLayerAdaptiveWidth"))

local SHOW_TYPE = {
	TOWER_END = 1
}

function ChapterEndLayer:onCreate()
	self:setAutoClose(true)
	self:addBlackBackground()
	self.time = 5

	self:setExitCallback(handler(self,self.exitCallBack))

	self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)

    self.scroll_view = cc.ScrollView:create(cc.size(self.spr_bg:getContentSize().width - 40, 300))
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    :setPosition(20, 20)
    self:addChild(self.scroll_view)

	self.scroll_view:addChild(cc.LayerColor:create(FONT_WHITE_C4B, 1000, 1000))

	self.menu_main:setLocalZOrder(100)
	
	ex.Tools:layerEnterAction(self)
end

function ChapterEndLayer:startTimer()
	
	self:addTimer("timer",1000,handler(self,self.changTimer),true)
end

function ChapterEndLayer:changTimer()
	self.time = self.time - 1 

	self.lbl_time:setString(string.format(ex.Tools:getLang(47336),self.time))
	if self.time <= 0 then 
		self:removeTimerByName("timer")
		require("src.layer.ChapterEndCtr"):instance():closeWindow()
	end
end

function ChapterEndLayer:exitCallBack()
	self:removeTimerByName("timer")
	if self.callback then
		self.callback(self.is_win, self.idx)
	end
end


-----------------------------------------------------------------------------
function ChapterEndCtr:onCreate()
	self:setCCBIPath("ccbi/ChapterEndLayer.ccbi")
	self:setIsSingle(false)
end

function ChapterEndCtr:getLayerClass()
	return ChapterEndLayer
end

function ChapterEndCtr:getChapterEndLayer()
	return self.layer
end

function ChapterEndCtr:openWindow(is_win, vec_reward, callback, idx, vec_battle_detail, layer_type)
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
	self:initData(is_win, vec_reward, callback, idx, vec_battle_detail, layer_type)
end

function ChapterEndCtr:openWindowWithTower(is_win, vec_reward, callback, idx, vec_battle_detail)
	self:openWindow(is_win, vec_reward, callback, idx, vec_battle_detail, SHOW_TYPE.TOWER_END)
end

function ChapterEndCtr:initData(is_win, vec_reward, callback, idx, vec_battle_detail, layer_type)
	self.layer.btn_report:registerScriptTapHandler(handler(self, self.onBattleDetail))
	self.layer.btn_limit_gift:registerScriptTapHandler(handler(self, self.onLimitGift))
	self.layer.btn_buy_gift:registerScriptTapHandler(handler(self, self.onLimitGift))
	self.layer.btn_strong:registerScriptTapHandler(handler(self, self.onStrong))

	local layer = self.layer
	layer.is_win = is_win
	layer.callback = callback
	layer.idx = idx
	vec_reward = vec_reward or {}
	self.vec_battle_detail = vec_battle_detail
	self.vec_reward = vec_reward

	self:updateScrollView()

    -- 更改显示
	ex.Tools:setSpriteFrame(layer.spr_wing, string.format("battle-end/spr-wing-%d.png", is_win and 1 or 0))
	ex.Tools:setSpriteFrame(layer.spr_result, string.format("battle-end-lang/lbl-result-%d.png", is_win and 1 or 0))

	layer.spr_result2:setVisible(false)
	layer.lbl_faild:setVisible(is_win == false)
    layer.btn_strong:setVisible(is_win == false)
    layer.menu:setVisible(is_win == false)
    layer.lbl_time:setVisible(is_win == false)
    layer.lbl_faild:enableOutline(cc.c3b(92,54,35), 1)

    layer.menu:setLocalZOrder(100)
	layer.btn_limit_gift:setVisible(false)
	layer.btn_buy_gift:setVisible(false)

    if is_win == true then
    	local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_battle_end")
    	spr_effect:setPosition(layer.spr_wing:getContentSize().width / 2, layer.spr_wing:getContentSize().height / 2 + 40)
    	spr_effect:setScale(1)
		layer.spr_wing:addChild(spr_effect, 0, 10)	
		
		local chibang = sp.SkeletonAnimation:create("spine/chibang.json","spine/chibang.atlas", 1)
        chibang:setAnimation(0, "idle", true);
	    chibang:setPosition(layer.spr_wing:getPositionX(), layer.spr_wing:getPositionY())
	    layer:addChild(chibang)

		layer.spr_result:setVisible(false)
		layer.spr_wing:setVisible(false)

	else
		local is_normal = true

		if layer_type == SHOW_TYPE.TOWER_END then
			if cfg.funcopen["act_limit_gift"].isVisible() then
				is_normal = false
				layer.btn_limit_gift:setVisible(true)
				layer.btn_buy_gift:setVisible(true)
				layer.lbl_time:setVisible(false)
				-- layer.scroll_view:setVisible(false)
			end
		end

		
		if is_normal then
			layer.btn_strong:setPositionX(320)
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
    end

    ex.AudioManager:playEffect(string.format("music/battle-end-%d.mp3", is_win and 1 or 0))
end

function ChapterEndCtr:updateScrollView()
	local layer = self.layer
	
    layer.scroll_view:getContainer():removeAllChildren()

	local menu = cpp.UIMenu:create()
    menu:setSwallowsTouches(false)
    menu:setPosition(cc.p(0, 0))
    menu:setIsTouchInsideNode(layer.scroll_view)
    layer.scroll_view:getContainer():addChild(menu)

    local view_size = layer.scroll_view:getViewSize()
    local item_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()
	item_size = cc.size(item_size.width + 20,  item_size.height + 30)

	local num = table.nums(self.vec_reward)
	local col = math.floor(view_size.width / item_size.width) -- 列数
	col = math.min(col, num)
	local row =  math.ceil(1.0 * num / col) -- 行数
	local cont_height = item_size.height * row
	cont_height = math.max(cont_height , view_size.height)

	layer.scroll_view:setContentSize(cc.size(view_size.width, cont_height))
	layer.scroll_view:setContentOffset(cc.p(0, view_size.height - cont_height))

  	cont_height = cont_height - item_size.height * 0.5
  	if row == 1 then
    	cont_height = cont_height - 20
    end

 	local start = cc.p(view_size.width * 0.5 - item_size.width * (col - 1) * 0.5, cont_height)

    local index = 0
	for _,v in ipairs(self.vec_reward) do
		local x = index % col
        local y = math.floor(index / col)

        local pos = cc.p(start.x + x * item_size.width, start.y - y * item_size.height)

		local item = ex.Player.backpack_data:createWithData(v.item_type, v.item_num)
		item:setPosition(pos)
        item:registerScriptTapHandler(handler(self, self.onItem))
        menu:addChild(item)

  --       item:setCascadeOpacityEnabled(true)
		-- item:setOpacity(0)
		-- item:setScale(2.0)
		-- item:runAction(cc.Sequence:create(cc.DelayTime:create(index * 0.1),
		-- 	cc.FadeIn:create(0.05),
		-- 	cc.EaseBackOut:create(cc.ScaleTo:create(0.15, 1.0)),
		-- 	cc.CallFunc:create(function()
		-- 		--self:onceAnim(pos, "summon-effect/3-0.png", "ccbi-res/summon-effect.plist", "summon-effect/3-%d.png")
		-- end)))
		ex.Tools:itemEnterAction(item)

		index = index + 1
    end
end

function ChapterEndCtr:enableBtnNextStage(str_tips, battle_time, callback)
	if self.layer == nil then
		return
	end

	self.layer:reorderChild(self.layer.node_tower_next_stage, 1000)
	self.layer.node_tower_next_stage:setVisible(true)

	local view_size = self.layer.scroll_view:getViewSize()
	self.layer.scroll_view:setViewSize(cc.size(view_size.width, view_size.height - 40))
	self:updateScrollView()
	self.layer.scroll_view:setTouchEnabled(false)

	self.layer.lbl_battle_time:setString(ex.Tools:getLang(47155)..ex.StringUtil.convertToTimeFormat(math.floor(battle_time / 1000), 5))

	self.layer.btn_next_stage:registerScriptTapHandler(callback)
	self.layer.btn_next_stage_done:registerScriptTapHandler(handler(self, self.closeWindow))

	local lbl_tip = require("src.comp.RichTextEx"):create()
	:setFontSize(48)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
    -- :setFontColor("#613C19")
	:setFontColor("#FFFFFF")
    :setScale(0.5)
    :setAnchorPoint(0.5, 1)
	:setAnchorTextShadow(true)
	-- :ignoreContentAdaptWithSize(false)
	:setWrapMode(1)

	lbl_tip:setXmlTextLua(str_tips)
	lbl_tip:formatText()

	lbl_tip:setPosition(self.layer:getContentSize().width / 2, 120)
	
	self.layer.node_tower_next_stage:addChild(lbl_tip, 10001)
end

function ChapterEndCtr:createBtn(path,atom,name)
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

function ChapterEndCtr:onclick(tag,pSender)
	print(self.__cname,"click")
	self:closeWindow()
    local atom = pSender:getName()
    ex.JumpManager:jumpByAtom(atom)
end

function ChapterEndCtr:onceAnim(pos, str_spr, str_plist, str_png)
	local spr_effectOnce = cc.Sprite:createWithSpriteFrameName(str_spr)
    spr_effectOnce:setScale(1.35)
    spr_effectOnce:setPosition(pos)
    self.layer.scroll_view:getContainer():addChild(spr_effectOnce)

    local action = cpp.ActionFactory:createLuaAnimate(str_plist, str_png, 0.05)
    spr_effectOnce:runAction(cc.Sequence:create(action, cc.CallFunc:create(function()
    	spr_effectOnce:setVisible(false)
    end)))
end

function ChapterEndCtr:onItem(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function ChapterEndCtr:onConfirm(tag, pSender)
	local layer = self.layer

	if layer.callback then
		layer.callback(layer.is_win, layer.idx)
	end
	
	self:closeWindow(tag, pSender)
end

function ChapterEndCtr:onBattleDetail(tag, pSender)
	require("src.layer.BattleDetailCtr"):instance():openWindow(self.vec_battle_detail)
end

function ChapterEndCtr:onLimitGift(tag, pSender)
	if cfg.funcopen["act_limit_gift"].isVisible() ~= true then
		ex.MessageView:add(ex.Tools:getLang(47536))
		pSender:setVisible(false)
		return
	end
	ex.JumpManager:jumpByAtom("act_limit_gift")
	self:closeWindow()
end

function ChapterEndCtr:onStrong(tag, pSender)
	ex.JumpManager:jumpByAtom("main_hero_recommend")
end

return ChapterEndCtr
