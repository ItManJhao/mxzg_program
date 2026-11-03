local LuckRewardCtr = class("LuckRewardCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local LuckRewardLayer = class("LuckRewardLayer", require("src.comp.EventLayer"))

function LuckRewardLayer:onCreate()
	self:setAutoClose(false)
	self:addBlackBackground()

	self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)

    local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_reward")
    spr_effect:setPosition(self.spr_title:getPositionX() - 9, self.spr_title:getPositionY() - 10)
    self:addChild(spr_effect, 20, 100)

	-- local top = self.spr_title:getPositionY() - self.spr_title:getContentSize().height / 2 - 5
	local bottom = self.btn_confirm:getPositionY() + self.btn_confirm:getContentSize().height / 2 + 5
	-- local bottom = 100

    self.scroll_view = cc.ScrollView:create(cc.size(self.spr_bg:getContentSize().width - 40, 250))
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    :setPosition(20, bottom)
    self:addChild(self.scroll_view)

    self.menu:setLocalZOrder(2)
    self.btn_confirm:registerScriptTapHandler(handler(self,self.onClose))
    self.btn_again:registerScriptTapHandler(handler(self,self.onAgain))

	self.btn_confirm:setLabelText(ex.Tools:getLang(11)) -- 确定
	self.btn_confirm:setLabelColor(ex.c3b.WHITE)
end

function LuckRewardLayer:onClose(tag,pSender)
    LuckRewardCtr:instance():closeWindow()
end

function LuckRewardLayer:onAgain(tag,pSender)

	-- 
	if ex.MainSceneCtr:checkNowLayer(MainSceneType.MAINCITY_BLESSING_POOL) == false  then 
		ex.MessageView:add(ex.Tools:getLang(41155))  
		return 
	end 

	if self.again_callback then 
		self.again_callback()
	end
	LuckRewardCtr:instance():closeWindow()
end

function LuckRewardLayer:exitCallBack()
	if self.eventData ~= nil and self.eventData.event ~= "" then 
		ex.EventManager:fire(self.eventData.event,self.eventData.data)
	end
	self.eventData = nil
end

function LuckRewardLayer:initself(btn_content)

    local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_reward")
    spr_effect:setPosition(self.spr_title:getPositionX() - 9, self.spr_title:getPositionY() - 10)
    self:addChild(spr_effect, 20, 100)

    local need_type = btn_content.item.item_type
    local need_num = btn_content.item.item_num

    local is_ten = btn_content.count == 10
    local hasNum = ex.Player:getItemNum(need_type)

    if need_type == ItemType.IT_TICKET_HIGH and hasNum < need_num then
        -- 高级券不够时候 用钻石
        need_type =  ItemType.IT_GEM
        need_num = 10
    end
    	
    -- 再次招募
    local btn_size = cc.Sprite:createWithSpriteFrameName("button/btn-buy-1.png"):getContentSize()
    btn_size.width = btn_size.width / 2
    btn_size.height = btn_size.height / 2

    local str_txt = ex.Tools:getLang(1110)
    if is_ten then
        str_txt = ex.Tools:getLang(1111)
    end

    local lbl_btn_txt = cc.Label:createWithTTF(str_txt, FONT_DEFAULT_NAME_BOLD, 26)
    :enableOutline(FONT_BROWN, 2)
    :setPosition(btn_size.width, btn_size.height + 11)
    self.btn_again:addChild(lbl_btn_txt)

    local spr_icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", need_type))
    :setScale(0.25)
    :setPosition(btn_size.width - 40, btn_size.height - 14)
    self.btn_again:addChild(spr_icon)

    local lbl_btn_num = cc.Label:createWithTTF(tostring(need_num), FONT_DEFAULT_NAME_BOLD, 40)
    :setScale(0.5)
    :setTextColor(FONT_BROWN)
    :setPosition(btn_size.width, btn_size.height - 14)
    self.btn_again:addChild(lbl_btn_num)

    -- self.btn_again:registerScriptTapHandler(handler(self, self.onSummonAgain))
end

-----------------------------------------------------------------------------
function LuckRewardCtr:onCreate()
	self:setCCBIPath("ccbi/LuckRewardLayer.ccbi")
	self:setIsSingle(false)
end

function LuckRewardCtr:getLayerClass()
	return LuckRewardLayer
end

function LuckRewardCtr:getLuckRewardLayer()
	return self.layer
end

function LuckRewardCtr:openWindow(vec_reward,btn_content,callback)
	vec_reward = clone(vec_reward)
	-- dump(vec_reward, "vec_reward")
	
	if self:isOpened() then
		self:addReward(vec_reward)
		return
	end

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/summon-effect.plist")
    sfc:addSpriteFrames("ccbi-res/reward-layer.plist")

	self:loadLayer()
	self:open()
	-- 更新标题
	-- self.layer.lbl_title:setString(str_title)
	self:updateReward(vec_reward,btn_content,callback)

	ex.AudioManager:playEffect("music/item-get.mp3")
		--self:openActionEnd()
end

function LuckRewardCtr:updateReward(vec_reward,btn_content,callback)
    local layer = self.layer
    
    layer.again_callback = callback 
    layer:initself(btn_content)
	layer.vec_reward = {}
	for _,v in pairs(vec_reward) do
		local tag = ex.Player.backpack_data:getPropType(v.item_type)
        if tag ~= ItemData.IT_INVALID and tag ~= ItemData.IT_RUNES then 
			item = ex.Tools:createBackpackItem(v.item_type, v.item_num)

			-- local is_have = false
			-- for i, v2 in ipairs(layer.vec_reward) do
			-- 	if v2.item_type == v.item_type then
			-- 		is_have = true
			-- 		v2.item_num = v2.item_num + v.item_num
			-- 		break
			-- 	end
			-- end
			
			-- if is_have == false then
			 	table.insert(layer.vec_reward, v)
			-- end
		else
			table.insert(layer.vec_reward, v)
		end
	end

	-- layer.vec_reward = vec_reward

	local reward = layer.vec_reward
	if layer.vec_reward.eventData ~= nil then 
		reward = layer.vec_reward.reward
		layer.eventData = layer.vec_reward.eventData
	end

	if layer.vec_reward.title ~= nil then 
		-- layer.lbl_title:setString(vec_reward.title)
	end

	reward = layer.vec_reward.reward ~= nil and layer.vec_reward.reward or layer.vec_reward

    layer.scroll_view:getContainer():removeAllChildren()

	local menu = cpp.UIMenu:create()
    menu:setSwallowsTouches(false)
    menu:setPosition(cc.p(0, 0))
    menu:setIsTouchInsideNode(layer.scroll_view)
    layer.scroll_view:getContainer():addChild(menu)

    local view_size = layer.scroll_view:getViewSize()
    local item_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()
	item_size = cc.size(item_size.width + 20,  item_size.height + 30)
	
	local num = table.nums(reward)
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
	for _,v in pairs(reward) do
		local x = index % col
        local y = math.floor(index / col)

        local pos = cc.p(start.x + x * item_size.width, start.y - y * item_size.height)

		-- local item = ex.Player.backpack_data:createWithData(v.item_type, v.item_num)
		local item = nil
		local tag = ex.Player.backpack_data:getPropType(v.item_type)
        if tag ~= ItemData.IT_INVALID then 
        	item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
        else
        	local config = cfg.herotype.star[v.item_type]
        	item = UIMenuItemHero:createWithData("0" , config.type, config.elem, 1, config.star)
        	item:setEnableAction(false)
        end
		item:setPosition(pos)
        item:registerScriptTapHandler(handler(self, self.onItem))
		menu:addChild(item)
		
		item.item_id = v.item_id

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
end

function LuckRewardCtr:onceAnim(pos, str_spr, str_plist, str_png)
	local spr_effectOnce = cc.Sprite:createWithSpriteFrameName(str_spr)
    spr_effectOnce:setScale(1.35)
    spr_effectOnce:setPosition(pos)
    self.layer.scroll_view:getContainer():addChild(spr_effectOnce)

    local action = cpp.ActionFactory:createLuaAnimate(str_plist, str_png, 0.05)
    spr_effectOnce:runAction(cc.Sequence:create(action, cc.CallFunc:create(function()
    	spr_effectOnce:setVisible(false)
    end)))
end

function LuckRewardCtr:onItem(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type, pSender.item_id)
end

-- 额外增加奖励
function LuckRewardCtr:addReward(data)
	if not self:getLayer() then
		return
	end

	local layer = self.layer

	-- 合并相同项。否则在结尾添加
	for k,v in pairs(data) do
		local value = TableEx.findValueFunction(layer.vec_reward, function(value)
			if value.item_type == v.item_type then
				return true
			end
		end)

		if value and tag ~= ItemData.IT_INVALID and tag ~= ItemData.IT_RUNES then
			value.item_num = value.item_num + v.item_num
		else
			table.insert(layer.vec_reward, v)
		end
	end
	
	self:updateReward(layer.vec_reward)
end

return LuckRewardCtr
