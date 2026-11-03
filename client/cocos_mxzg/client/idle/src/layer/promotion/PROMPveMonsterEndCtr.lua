local PROMPveMonsterEndCtr = class("PROMPveMonsterEndCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PROMPveMonsterEndLayer = class("PROMPveMonsterEndLayer", require("src.comp.EventLayer"))

function PROMPveMonsterEndLayer:onCreate()
	self:setAutoClose(true)
	self:addBlackBackground()
	self.time = 5

	self:setExitCallback(handler(self,self.exitCallBack))

	self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)

    self.scroll_view = cc.ScrollView:create(cc.size(self.spr_bg:getContentSize().width - 40, 230))
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    :setPosition(20, 20)
    self:addChild(self.scroll_view)

	self.scroll_view:addChild(cc.LayerColor:create(FONT_WHITE_C4B, 1000, 1000))
end

function PROMPveMonsterEndLayer:startTimer()
	
	self:addTimer("timer",1000,handler(self,self.changTimer),true)
end

function PROMPveMonsterEndLayer:changTimer()
	self.time = self.time - 1 

	self.lbl_time:setString(string.format(ex.Tools:getLang(47336),self.time))
	if self.time <= 0 then 
		self:removeTimerByName("timer")
		require("src.layer.promotion.PROMPveMonsterEndCtr"):instance():closeWindow()
	end
end

function PROMPveMonsterEndLayer:exitCallBack()
	self:removeTimerByName("timer")
	if self.callback then
		self.callback(self.is_win, self.idx)
	end
end


-----------------------------------------------------------------------------
function PROMPveMonsterEndCtr:onCreate()
	self:setCCBIPath("ccbi/PROMPveMonsterEndLayer.ccbi")
	self:setIsSingle(false)
end

function PROMPveMonsterEndCtr:getLayerClass()
	return PROMPveMonsterEndLayer
end

function PROMPveMonsterEndCtr:getPROMPveMonsterEndLayer()
	return self.layer
end

function PROMPveMonsterEndCtr:openWindow(data, is_sweep)
	if self:isOpened() then
		return
	end
	self.battle_data = data
	self.is_sweep = is_sweep

	self:loadLayer()
	self:open()
	self:initData()
end

function PROMPveMonsterEndCtr:initData()
	self.layer.btn_report:registerScriptTapHandler(handler(self, self.onBattleDetail))

	local layer = self.layer
	layer.is_win = self.battle_data.is_win
	local vec_reward = self.battle_data.vec_reward or {}
	self.vec_battle_detail = self.battle_data.vec_battle_detail

	if self.is_sweep then
		self.layer.btn_report:setVisible(false)
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
    	cont_height = cont_height - 20
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

		index = index + 1
    end

    -- 更改显示
	ex.Tools:setSpriteFrame(layer.spr_wing, string.format("battle-end/spr-wing-%d.png", self.battle_data.is_win ))
	ex.Tools:setSpriteFrame(layer.spr_result, string.format("battle-end-lang/lbl-result-%d.png", self.battle_data.is_win ))


    if self.battle_data.is_win == true then
    	-- print("play effect wing")
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
    end


    layer.lbl_faild:setString( ex.Tools:getLang(52317) .. self.battle_data.damage_value)

    layer.menu:setLocalZOrder(100)

    layer:changTimer()
    layer:startTimer()

    ex.AudioManager:playEffect(string.format("music/battle-end-%d.mp3", self.battle_data.is_win ))
end


function PROMPveMonsterEndCtr:onItem(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function PROMPveMonsterEndCtr:onConfirm(tag, pSender)
	local layer = self.layer

	if layer.callback then
		layer.callback(layer.is_win, layer.idx)
	end
	
	self:closeWindow(tag, pSender)
end

function PROMPveMonsterEndCtr:onBattleDetail(tag, pSender)
	if self.is_sweep then
		return
	end
	require("src.layer.BattleDetailCtr"):instance():openWindow(self.vec_battle_detail)
end

return PROMPveMonsterEndCtr
