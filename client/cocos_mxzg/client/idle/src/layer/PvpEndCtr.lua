local PvpEndCtr = class("PvpEndCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PvpEndLayer = class("PvpEndLayer", require("src.comp.LuaLayerBase"))

function PvpEndLayer:onCreate()
	self:addBlackBackground()

	self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)

	self.btn_report:setPositionX(self:getContentSize().width - 60)


    self.scroll_view = cc.ScrollView:create(cc.size(self.spr_bg:getContentSize().width - 40, 140))
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    :setPosition(20, 54)
    self:addChild(self.scroll_view)

	self.scroll_view:addChild(cc.LayerColor:create(FONT_WHITE_C4B, 1000, 1000))
end

function PvpEndLayer:addBottomTip(str)
	local lbl_active = require("src.comp.RichTextEx"):create()
	lbl_active:setFontSize(20)
	lbl_active:setFontFace(FONT_DEFAULT_NAME_BOLD)
	lbl_active:setAnchorTextShadow(false)
	lbl_active:setWrapMode(1)
	lbl_active:setIgnoreAnchorPointForPosition(false)
	lbl_active:setAnchorPoint(ex.a.center)
	lbl_active:setPosition(self:getContentSize().width / 2, 36)
	lbl_active:setXmlTextLua(str)
	lbl_active:setCallback(function(atom)
		require("src.layer.PvpCtr"):instance():closeWindow()
		require("src.layer.PvpEndCtr"):instance():closeWindow()
		ex.JumpManager:jumpByAtom(atom)
	end)
	self:addChild(lbl_active)
end


-----------------------------------------------------------------------------
function PvpEndCtr:onCreate()
	self:setCCBIPath("ccbi/PvpEndLayer.ccbi")
	self:setIsSingle(false)
end

function PvpEndCtr:getLayerClass()
	return PvpEndLayer
end

function PvpEndCtr:getPvpEndLayer()
	return self.layer
end

function PvpEndCtr:openWindow(is_win, enemy_id, vec_reward, ext, callback)
	if self:isOpened() then
		return
	end

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/summon-effect.plist")

	self:loadLayer()
	self:open()
	self:initData(is_win, enemy_id, vec_reward, ext, callback)
end

function PvpEndCtr:initData(is_win, enemy_id, vec_reward, ext, callback)
	self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))
	self.layer.btn_back:registerScriptTapHandler(handler(self, self.onConfirm))
	-- self.layer.btn_back:registerScriptTapHandler(handler(self, self.onBack))
	self.layer.btn_report:registerScriptTapHandler(handler(self, self.onReport))

	local layer = self.layer
	layer.is_win = is_win
	layer.callback = callback
	vec_reward = vec_reward or {}
	self.data = ext

	if require("src.layer.PvpCtr"):instance():isOpened() then
		-- layer.btn_confirm:setPositionX(layer:getContentSize().width / 2)
		-- layer.btn_back:setVisible(false)
	else
		self.layer.btn_back:registerScriptTapHandler(handler(self, self.onBack))
	end
	
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
    	-- cont_height = cont_height - 20
    end

 	local start = cc.p(view_size.width * 0.5 - item_size.width * (col - 1) * 0.5, cont_height)

    local index = 0
	for _,v in pairs(vec_reward) do
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

		index = index + 1
    end

    -- 更改显示
    -- layer.spr_wing:setSpriteFrame(string.format("battle-end/spr-wing-%d.png", is_win and 3 or 2))
    -- layer.spr_result:setSpriteFrame(string.format("battle-end-lang/lbl-result-%d.png", is_win and 3 or 2))
	ex.Tools:setSpriteFrame(layer.spr_wing, string.format("battle-end/spr-wing-%d.png", is_win and 3 or 2))
	ex.Tools:setSpriteFrame(layer.spr_result, string.format("battle-end-lang/lbl-result-%d.png", is_win and 3 or 2))
    -- if is_win == true then
    -- 	-- print("play effect wing")
    -- 	local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_battle_end")
    -- 	spr_effect:setPosition(layer.spr_wing:getContentSize().width / 2, layer.spr_wing:getContentSize().height / 2 + 40)
    -- 	spr_effect:setScale(1)
	-- 	layer.spr_wing:addChild(spr_effect, 0, 10)
		
	-- 	local chibang = sp.SkeletonAnimation:create("spine/chibang.json","spine/chibang.atlas", 1)
    --     chibang:setAnimation(0, "idle", true);
	--    chibang:setPosition(layer.spr_wing:getPositionX(), layer.spr_wing:getPositionY())
	--    layer:addChild(chibang)

	-- 	layer.spr_result:setVisible(false)
	-- 	layer.spr_wing:setVisible(false)
    -- end

	ex.AudioManager:playEffect(string.format("music/battle-end-%d.mp3", is_win and 1 or 0))
	
    -- 显示角色信息
	local sfc = cc.SpriteFrameCache:getInstance()
	-- layer.spr_head1:setSpriteFrame()
	ex.Tools:setSpriteFrame(layer.spr_head1, string.format("head-icon/%d.png", ex.Player.head_id))
	ex.Tools:setSpriteFrame(layer.spr_border1, ex.Tools:getBorderIconByIdx(ex.Player.border_id))
    layer.lbl_name1:setString(ex.Player.nick)
	layer.lbl_score1:setString(ext.self_cup)
	layer.lbl_add_score1:setString(ext.self_score)
	layer.lbl_add_score1:setColor(is_win and cc.c3b(255,225,187) or cc.c3b(242,15,15))
	-- layer.spr_up_down_1:setSpriteFrame(is_win and "pvp/spr-up.png" or "pvp/spr-down.png")
	ex.Tools:setSpriteFrame(layer.spr_up_down_1, is_win and "pvp/spr-up.png" or "pvp/spr-down.png")
	-- local enemy_data = ex.Player.pvp_data:getEnemyData(enemy_id)
	-- layer.spr_head2:setSpriteFrame(string.format("head-icon/%d.png", enemy_data.head_id))
	ex.Tools:setSpriteFrame(layer.spr_head2, string.format("head-icon/%d.png", ext.head_id))
	ex.Tools:setSpriteFrame(layer.spr_border2, ex.Tools:getBorderIconByIdx(ext.border_id))
    layer.lbl_name2:setString(ext.enemy_name)
	layer.lbl_score2:setString(ext.enemy_cup)
	layer.lbl_add_score2:setString(ext.enemy_score)
	layer.lbl_add_score2:setColor((not is_win) and cc.c3b(255,225,187) or cc.c3b(242,15,15))
	-- layer.spr_up_down_2:setSpriteFrame((not is_win) and "pvp/spr-up.png" or "pvp/spr-down.png")
	ex.Tools:setSpriteFrame(layer.spr_up_down_2, (not is_win) and "pvp/spr-up.png" or "pvp/spr-down.png")
end

function PvpEndCtr:onceAnim(pos, str_spr, str_plist, str_png)
	local spr_effectOnce = cc.Sprite:createWithSpriteFrameName(str_spr)
    spr_effectOnce:setScale(1.35)
    spr_effectOnce:setPosition(pos)
    self.layer.scroll_view:getContainer():addChild(spr_effectOnce)

    local action = cpp.ActionFactory:createLuaAnimate(str_plist, str_png, 0.05)
    spr_effectOnce:runAction(cc.Sequence:create(action, cc.CallFunc:create(function()
    	spr_effectOnce:setVisible(false)
    end)))
end

function PvpEndCtr:onItem(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function PvpEndCtr:onConfirm(tag, pSender)
	local layer = self.layer

	if layer.callback then
		layer.callback(layer.is_win)
	end
	
	self:closeWindow(tag, pSender)
end

function PvpEndCtr:onBack(tag, pSender)
	local layer = self.layer

	if layer.callback then
		layer.callback(layer.is_win)
	end
	
	self:closeWindow(tag, pSender)

	ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
	require("src.layer.PvpCtr"):instance():openWindow()
end

function PvpEndCtr:onReport(tag, pSender)
    require("src.layer.BattleDetailCtr"):instance():openWindow(self.data.report.log)
end

function PvpEndCtr:addBottomTip(tip)
	if not self:isOpened() then
		return
	end

	self.layer:addBottomTip(tip)
end

return PvpEndCtr
