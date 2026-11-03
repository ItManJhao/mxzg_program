local QuickBattleCtr = class("QuickBattleCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local QuickBattleLayer = class("QuickBattleLayer", require("src.comp.EventLayerAdaptiveWidth"))

function QuickBattleLayer:onCreate()
	if ex.Player.level < ex.Tools:getSysCfg("quick_battle_level_need") then
		self.lbl_tip_1:setString(ex.Tools:getLang(3505))
		self.lbl_tip_2:setString(ex.Tools:getLang(3506))
		self.spr_suggest:setPositionX(self.lbl_tip_2:getPositionX() + self.lbl_tip_2:getContentSize().width * self.lbl_tip_2:getScaleX())
	else
		self.lbl_tip_1:setVisible(false)
		self.lbl_tip_2:setVisible(false)
		self.spr_suggest:setVisible(false)
	end

	self.menu = cpp.UIMenu:create()
	self:addChild(self.menu)
	self.menu:setPosition(0,0)

	self.btn_quick:setName("btn_quick")

	self.lbl_btn_quick = require("src.comp.RichTextEx"):create() -- cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(22)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	-- :setFontColor("#5E3E16")
	-- :setAnchorTextShadow(false)
	-- :ignoreContentAdaptWithSize(false)
	-- :setWrapMode(1)
	:setContentSize((self.btn_quick:getContentSize().width - 35), self.btn_quick:getContentSize().height)
	:setAnchorPoint(ex.a.top_center)
	self.btn_quick:addChild(self.lbl_btn_quick)
	self.lbl_btn_quick:setPosition(self.btn_quick:getContentSize().width / 2,42)
   	-- self.btn_quick:setLabelText(ex.Tools:getLang(2305)) -- 常规
    -- self.btn_quick:setLabelColor(ex.c3b.WHITE)
    -- self.btn_quick:getLabel():enableOutline(FONT_LIGHT_BLUE, 2)
    self.btn_quick:registerScriptTapHandler(handler(self, self.onClickQuick))
	self.btn_jump:registerScriptTapHandler(handler(self, self.onClickJump))
	-- self.btn_info:registerScriptTapHandler(handler(self, self.onClickInfo))
	self.btn_info:registerScriptTapHandler(handler(self, self.onInfo))
	self.btn_jump:setContentSize(cc.size(100, 50))
    local spine = sp.SkeletonAnimation:create("spine/lijijihuo.json","spine/lijijihuo.atlas", 1)
    spine:setAnimation(0, "idle", true)
    spine:setPosition(self.btn_jump:getContentSize().width / 2, self.btn_jump:getContentSize().height / 2)
    self.btn_jump:addChild(spine, 10)

    local active = ex.Player.promotion_data:isExistSpeedBattlePrivilege()

	self.btn_jump:setVisible(not active)
	self.spr_activate:setVisible(active)

    self:setRichTips()
	self:addEvent(EVENT.QUICK_BATTLE_EVENT.QUICK_BATTLE_REWARD,handler(self,self.onReward))
	self:addBlackBackground()

	NetManager:sendMessage(ProtocolID.GReqQuickBattleInitData)

	self:addRedDotNode(RedDotType.ZCJ_DHZD_KSZD_KSZD, self.btn_quick)
end

function QuickBattleLayer:onReward(event,data)
	self:setRichTips()
end

function QuickBattleLayer:setRichTips()
	if not self.rich_text then 
		self.rich_text = cpp.RichTextEx:createWithXMLLua("")
		:setFontSize(36)
		:setFontFace(FONT_DEFAULT_NAME_BOLD)
		:setFontColor("#5E3E16")
		:setScale(0.5)
		:setAnchorTextShadow(true)
		:ignoreContentAdaptWithSize(false)
		:setWrapMode(1)
		:setContentSize(400, 48)
		:setAnchorPoint(ex.a.top_center)
		:setName("lbl_count_left")
		self:addChild(self.rich_text)
		self.rich_text:setPosition(540, 65)
	end

	local cost_gem, cur_count, max_count = ex.Player.battle_data:getQuickBattleData()
	local str = string.format(ex.Tools:getLang(47414), max_count - cur_count)
	
	
	if GUIDE_STEP_CONTROL == "quick_battle_free" or cost_gem <= 0 then
		self.rich_text:setXmlTextLua(ex.Tools:getLang(47667))
	else
		self.rich_text:setXmlTextLua(str)
	end
	


	if cost_gem > 0 and GUIDE_STEP_CONTROL ~= "quick_battle_free" then 
		str = string.format(ex.Tools:getLang(47365), cost_gem)
	else
		str = ex.Tools:getLang(47366)
	end


	self.lbl_btn_quick:setXmlTextLua(str)
	self.btn_quick:setEnabled(cost_gem >= 0)
end

function QuickBattleLayer:onClickJump(tag,pSender)
	local open,layer = ex.JumpManager:jumpByAtom("act_privilege_shop")
	if not open then return end
	QuickBattleCtr:instance():closeWindow()
end

function QuickBattleLayer:onClickQuick(tag,pSender)
	local chapter_data = cfg.chapterreward.chapterreward[ex.Player.chapter_data.chapter_id]
    if chapter_data == nil then
        return
    end

	local cost_gem, cur_count, max_count = ex.Player.battle_data:getQuickBattleData()
	local callback = function ()
	    local req_quick = Battle_pb.GReqQuickBattleReward()
	    req_quick.idx = cur_count
    	NetManager:sendMessage(ProtocolID.GReqQuickBattleReward, req_quick)
	end

	if ex.Player.pub_task.adventure_count >= chapter_data.tavern_point_max then
		--require("src.layer.GoCoffeeCtr"):instance():openWindow(ex.Tools:getLang(3500),ex.Tools:getLang(2220), callback)
		ex.ConfirmCtr:instance():openWindow(ex.Tools:getLang(3500),ex.Tools:getLang(2220), callback)
		return
	end

	if cost_gem < 0 then
		ex.MessageView:add(ex.Tools:getLang(47441))
		return
	end

	if ex.Player.gem < cost_gem then 
		ex.MessageView:add(ex.Tools:getLang(47428))
		return 
	end

	if GUIDE_STEP_CONTROL == "quick_battle_free" then
		callback()
	elseif cost_gem > 0 then 
		local title = ex.Tools:getLang(47682)--ex.Tools:getLang(41002)
        local content = string.format(ex.Tools:getLang(41064), cost_gem)
        require("src.layer.ConfirmCtr"):instance():openWindow(title, content, callback)
	else
		callback()
	end
end

function QuickBattleLayer:onInfo()
	ex.InfoCtr:openWindow(ex.Tools:getLang(3510), ex.Tools:getLang(3509))
end

function QuickBattleLayer:updateScrollView(data)
	local menu = cpp.UIMenu:create()
    menu:setSwallowsTouches(false)
    menu:setPosition(cc.p(0, 0))
    menu:setIsTouchInsideNode(self.scrollView)
    self.scrollView:getContainer():addChild(menu)

    local view_size = self.scrollView:getViewSize()
    local item_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()
	item_size = cc.size(item_size.width + 20,  item_size.height + 30)
	
	local num = table.nums(data)
	local col = math.floor(view_size.width / item_size.width) -- 列数
	col = math.min(col, num)
	local cont_height = item_size.height * math.ceil(1.0 * num / col)
	cont_height = math.max(cont_height , view_size.height)

	self.scrollView:setContentSize(cc.size(view_size.width, cont_height))
	self.scrollView:setContentOffset(cc.p(0, view_size.height - cont_height))

  	cont_height = cont_height - item_size.height * 0.5

 	local start = cc.p(view_size.width * 0.5 - item_size.width * (col - 1) * 0.5, cont_height)

    local index = 0
	for _,v in pairs(data) do
		local x = index % col
        local y = math.floor(index / col)

        local pos = cc.p(start.x + x * item_size.width, start.y - y * item_size.height)

		local item = ex.Player.backpack_data:createWithData(v.item_type, 0)

		item:setPosition(pos)
        item:registerScriptTapHandler(handler(self, self.onItemInfo))
        menu:addChild(item)

		index = index + 1
    end
end

function QuickBattleLayer:createSpine()
	if self.hero ~= nil then 
		self.hero:removeFromParent()
		self.hero = nil
	end
	self.hero = require("src.person.Hero"):create("12323", "123213",10104004,0,0)
	self.hero:setScale(1.42)
    self.hero:setPosition(100,400)
	self.hero:registerScriptTapHandler(handler(self, self.onTouchHero))
    self.menu:addChild(self.hero)
end

function QuickBattleLayer:onItemInfo(tag, pSender)
	-- dump(pSender.item_type, "pSender")
	ex.Tools:onClickItemInfo(pSender.item_type)
end

function QuickBattleLayer:onClickInfo(tag, pSender)
	local title = ex.Tools:getLang(42032)
	local content = ex.Tools:getLang(42033)
	require("src.layer.InfoCtr"):instance():openWindow(title,content)
end

-----------------------------------------------------------------------------
function QuickBattleCtr:onCreate()
	self:setCCBIPath("ccbi/QuickBattleLayer.ccbi")
	self:setIsSingle(false)
end

function QuickBattleCtr:getLayerClass()
	return QuickBattleLayer
end

function QuickBattleCtr:getQuickBattleLayer()
	return self.layer
end

function QuickBattleCtr:openWindow()
	if self:isOpened() then
		return
	end
	
    ex.Player.battle_data:QuickNums()
	self:loadLayer()
	self:open()
	self:initData()

end

function QuickBattleCtr:initData()
	local layer = self.layer

	self:updateLayer()

end

function QuickBattleCtr:updateLayer()
	if not self:getLayer() then
		return
	end
	local layer = self.layer
    layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    
	local chapter_idx = Maths.clampf(ex.Player.chapter_data.chapter_id, 1, ex.Player.chapter_data.max_chapter_id)
    ex.Player.chapter_data:sortReward()
    local data = cfg.chapterreward.chapterreward[chapter_idx]
    local show_data = {}
	for k,v in pairs(data.reward_base) do
		local data = {}

		data.item_type = v.item_type 
		data.item_num = 0
    	table.insert(show_data,data)
    end

    for k,v in pairs(data.reward_unique) do
    	local dt = {}
    	dt.item_type = v.type
    	dt.item_num = v.num or 1
    	table.insert(show_data,dt)
    end
    layer:updateScrollView(show_data)
end



return QuickBattleCtr
