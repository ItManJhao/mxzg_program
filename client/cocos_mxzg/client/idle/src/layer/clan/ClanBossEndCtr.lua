local ClanBossEndCtr = class("ClanBossEndCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ClanBossEndLayer = class("ClanBossEndLayer", require("src.comp.EventLayer"))

function ClanBossEndLayer:onCreate()
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
end

function ClanBossEndLayer:startTimer()
	self:addTimer("timer", 1000, handler(self,self.changTimer), true)
end

function ClanBossEndLayer:changTimer()
	self.time = self.time - 1 

	self.lbl_time:setString(string.format(ex.Tools:getLang(47336),self.time))
	if self.time <= 0 then 
		self:removeTimerByName("timer")
		ClanBossEndCtr:instance():closeWindow()
	end
end

function ClanBossEndLayer:exitCallBack()
	self:removeTimerByName("timer")
	if self.callback then
		self.callback(self.is_win, self.idx)
	end
end


-----------------------------------------------------------------------------
function ClanBossEndCtr:onCreate()
	self:setCCBIPath("ccbi/ClanBossEndLayer.ccbi")
	self:setIsSingle(false)
end

function ClanBossEndCtr:getLayerClass()
	return ClanBossEndLayer
end

function ClanBossEndCtr:getClanBossEndLayer()
	return self.layer
end

function ClanBossEndCtr:openWindow(is_win, vec_reward, component, data)
	if self:isOpened() then
		return
	end

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/main-scene.plist")
	sfc:addSpriteFrames("ccbi-res/main-city.plist")

	self:loadLayer()
	self:open()
	self:initData(is_win, vec_reward, component, data)
end

function ClanBossEndCtr:initData(is_win, vec_reward, component, data)
	self.layer.btn_report:registerScriptTapHandler(handler(self, self.onBattleDetail))

	local layer = self.layer
	layer.is_win = is_win
	-- layer.callback = callback
	-- layer.idx = idx
	vec_reward = vec_reward or {}
	self.vec_battle_detail = data.log
	
    layer.scroll_view:getContainer():removeAllChildren()

	local menu = cpp.UIMenu:create()
    menu:setSwallowsTouches(false)
    menu:setPosition(cc.p(0, 0))
    menu:setIsTouchInsideNode(layer.scroll_view)
    layer.scroll_view:getContainer():addChild(menu)

    local view_size = layer.scroll_view:getViewSize()
    local item_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()
	item_size = cc.size(item_size.width + 20,  item_size.height + 30)

	local num = table.nums(vec_reward)
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
	for _,v in ipairs(vec_reward) do
		local x = index % col
        local y = math.floor(index / col)

        local pos = cc.p(start.x + x * item_size.width, start.y - y * item_size.height)

		local item = ex.Player.backpack_data:createWithData(v.item_type, v.item_num)
		item:setPosition(pos)
        item:registerScriptTapHandler(handler(self, self.onItem))
        menu:addChild(item)

		index = index + 1
    end

	if is_win then
	-- if true then	
		local cell_file = ex.StringUtil.segmentLast(component, ".", true)
		local cell = require(component):createWithCCBIFile("ccbi/" .. cell_file .. ".ccbi")
		cell:initData(vec_reward)
		cell:setPosition(cc.p(0, 0))
		layer.node_panel:addChild(cell)
	end

    -- 更改显示
	ex.Tools:setSpriteFrame(layer.spr_wing, string.format("battle-end/spr-wing-%d.png", is_win and 1 or 0))
	ex.Tools:setSpriteFrame(layer.spr_result, string.format("battle-end-lang/lbl-result-%d.png", is_win and 1 or 0))

	
    layer.lbl_faild:setVisible(is_win == false)
    layer.menu:setVisible(is_win == false)
    layer.lbl_time:setVisible(is_win == false)
    layer.lbl_faild:enableOutline(cc.c3b(92,54,35), 1)

    layer.menu:setLocalZOrder(100)
    
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

	if is_win then
		
	end

		
    ex.AudioManager:playEffect(string.format("music/battle-end-%d.mp3", is_win and 1 or 0))
end

function ClanBossEndCtr:createBtn(path, atom, name)

	local btn = cpp.UIMenuItemImage:createWithSpriteFrameName("main-scene/btn-bg.png", nil, nil)
	btn:setName(atom)
	btn:registerScriptTapHandler(handler(self,self.onclick))
	local sp = cc.Sprite:createWithSpriteFrameName(path)
	local size = btn:getContentSize()
	sp:setScaleX(size.width / sp:getContentSize().width)
	sp:setScaleY(size.height / sp:getContentSize().height)
	btn:addChild(sp)
	sp:setPosition(size.width / 2, size.height / 2)
	local lbl = cc.Label:createWithTTF(name, FONT_DEFAULT_NAME_BOLD, 24)
	lbl:enableOutline(cc.c3b(92,54,35), 1)
	btn:addChild(lbl)
	lbl:setPosition(size.width/2,0)
	return btn
end

function ClanBossEndCtr:onclick(tag,pSender)
	print(self.__cname,"click")
	self:closeWindow()
    local atom = pSender:getName()
    ex.JumpManager:jumpByAtom(atom)
end

function ClanBossEndCtr:onceAnim(pos, str_spr, str_plist, str_png)
	local spr_effectOnce = cc.Sprite:createWithSpriteFrameName(str_spr)
    spr_effectOnce:setScale(1.35)
    spr_effectOnce:setPosition(pos)
    self.layer.scroll_view:getContainer():addChild(spr_effectOnce)

    local action = cpp.ActionFactory:createLuaAnimate(str_plist, str_png, 0.05)
    spr_effectOnce:runAction(cc.Sequence:create(action, cc.CallFunc:create(function()
    	spr_effectOnce:setVisible(false)
    end)))
end

function ClanBossEndCtr:onItem(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function ClanBossEndCtr:onConfirm(tag, pSender)
	local layer = self.layer

	if layer.callback then
		layer.callback(layer.is_win, layer.idx)
	end
	
	self:closeWindow(tag, pSender)
end

function ClanBossEndCtr:onBattleDetail(tag, pSender)
	require("src.layer.BattleDetailCtr"):instance():openWindow(self.vec_battle_detail)
end

return ClanBossEndCtr
