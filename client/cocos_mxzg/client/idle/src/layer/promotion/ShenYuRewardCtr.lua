local ShenYuRewardCtr = class("ShenYuRewardCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ShenYuRewardLayer = class("ShenYuRewardLayer", require("src.comp.EventLayer"))
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

function ShenYuRewardLayer:onCreate()
	self:setAutoClose(true)
	self:addBlackBackground()

	self:setExitCallback(handler(self,self.exitCallBack))

	self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)

    local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_reward")
    spr_effect:setPosition(self.spr_title:getPositionX(), self.spr_title:getPositionY())
    self:addChild(spr_effect, 20, 100)

	local top = self.spr_title:getPositionY() - self.spr_title:getContentSize().height / 2 - 5
	local bottom = 20

	self.scroll_view:setViewSize(cc.size(self.spr_bg:getContentSize().width - 40, top - bottom))
	self.scroll_view:setItemSize(cc.size(124, 134))
	-- self.scroll_view:setCreateInterval(0.1)
	self.scroll_view:setCreateNum(4)
	self.scroll_view:setAlignmentCenter(true)

    ex.Tools:layerEnterAction(self)
    
    -- self.btn_again:addChild()
    -- self.btn_enter:addChild()

    self.lbl_btn_again = cc.Label:createWithTTF(ex.Tools:getLang(77024), FONT_DEFAULT_NAME_BOLD, 24)
    self.btn_again:addChild(self.lbl_btn_again)
    self.lbl_btn_again:setPosition(self.btn_again:getContentSize().width * 0.5, self.btn_again:getContentSize().height * 0.5)
    self.lbl_btn_again:enableOutline(cc.c3b(122,71,45), 2)
    self.btn_again:registerScriptTapHandler(handler(self, self.onAgain))

    self.lbl_btn_enter = cc.Label:createWithTTF(ex.Tools:getLang(80102), FONT_DEFAULT_NAME_BOLD, 24)
    self.btn_enter:addChild(self.lbl_btn_enter)
    self.lbl_btn_enter:setPosition(self.btn_enter:getContentSize().width * 0.5, self.btn_enter:getContentSize().height * 0.5)
    self.lbl_btn_enter:enableOutline(cc.c3b(122,71,45), 2)
    self.btn_enter:registerScriptTapHandler(handler(self, self.onEnter))
end

function ShenYuRewardLayer:onAgain( )
    if self.again_callback then 
        self.again_callback()
    end

    ShenYuRewardCtr:instance():closeWindow()
end

function ShenYuRewardLayer:onEnter( )
    if self.enter_callback then 
        self.enter_callback()
    end

    ShenYuRewardCtr:instance():closeWindow()
end

function ShenYuRewardLayer:exitCallBack()
	if self.eventData ~= nil and self.eventData.event ~= "" then 
		ex.EventManager:fire(self.eventData.event,self.eventData.data)
	end
	self.eventData = nil
end

function ShenYuRewardLayer:addBottomTip(str)
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
		require("src.layer.ShenYuRewardCtr"):instance():closeWindow()
		ex.JumpManager:jumpByAtom(atom)
	end)
	self:addChild(lbl_active)
end


-----------------------------------------------------------------------------
function ShenYuRewardCtr:onCreate()
	self:setCCBIPath("ccbi/ShenYuRewardLayer.ccbi")
	self:setIsSingle(false)
end

function ShenYuRewardCtr:getLayerClass()
	return ShenYuRewardLayer
end

function ShenYuRewardCtr:getShenYuRewardLayer()
	return self.layer
end

function ShenYuRewardCtr:openWindow(vec_reward,again_data,enter_data)
	vec_reward = clone(vec_reward)

	if self:isOpened() then
		self:addReward(vec_reward)
		return
	end


	-- local sfc = cc.SpriteFrameCache:getInstance()
	-- sfc:addSpriteFrames("ccbi-res/summon-effect.plist")
    -- sfc:addSpriteFrames("ccbi-res/reward-layer.plist")

	self:loadLayer()
    self:open()
	
	if again_data ~= nil then 
		self.layer.again_callback = again_data.callback
		if again_data.title ~= nil then 
			self.layer.lbl_btn_again:setString(again_data.title)
		end
	end

	if enter_data ~= nil then 
		self.layer.enter_callback = enter_data.callback
		if enter_data.title ~= nil then 
			self.layer.lbl_btn_enter:setString(enter_data.title)
		end
	end
	-- 更新标题
	-- self.layer.lbl_title:setString(str_title)
	self:updateReward(vec_reward)

	ex.AudioManager:playEffect("music/item-get.mp3")
		--self:openActionEnd()
end

function ShenYuRewardCtr:updateReward(vec_reward)
	-- dump(debug.traceback())
	-- dump(vec_reward, "vec_reward")

	local layer = self.layer

    -- 播放彩带爆炸
    self.layer.spr_effect_bomb = ex.EffectFactory:createEffectWithNodeByName("eff_reward_bomb")
    self.layer.spr_effect_bomb:setPosition(self.layer:getContentSize().width / 2, self.layer:getContentSize().height + 100)
    self.layer:addChild(self.layer.spr_effect_bomb, 100)
	-- self:addChild(cc.LayerColor:create(FONT_LIGHT_GRAY_C4B, ex.p.width, ex.p.height))
	
	layer.vec_reward = {}
	local rewards = vec_reward
	if vec_reward.reward ~= nil then 
		rewards = vec_reward.reward
	end 

	local reward = layer.vec_reward
	if vec_reward.eventData ~= nil then 
		reward = rewards
		layer.eventData = vec_reward.eventData
	end

	if layer.vec_reward.title ~= nil then 
		-- layer.lbl_title:setString(vec_reward.title)
	end

	reward = rewards -- layer.vec_reward.reward ~= nil and layer.vec_reward.reward or layer.vec_reward

	layer.scroll_view.createItemFunction = function(v, scale)
		local item = nil
		local item_config = cfg.item.item[v.item_type]
		if item_config == nil then
			dump(vec_reward, "ShenYuRewardCtr:updateReward item_config "..v.item_type.."is nil")
		end

        if item_config.mode ~= ItemData.IT_HERO and item_config.mode ~= ItemData.IT_HERO_MATERIAL then 
			item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
			if item_config.mode == ItemData.PET then 
				item:showPetRare()
				item:setLevel(1)
			end
		elseif item_config.mode == ItemData.IT_HERO_MATERIAL then
			local config = cfg.herotype.star[item_config.use_value]
			item = UIMenuItemHero:createWithData("0" , config.type, config.elem, 1, item_config.star)
			item.item_type = v.item_type
			item:setEnableAction(false)
        else
			local config = cfg.herotype.star[v.item_type]
			
			local now_star = v.star and v.star or config.star  
			local now_level = v.level and v.level or 1  

        	item = UIMenuItemHero:createWithData("0" , config.type, config.elem, now_level, now_star)
			item:setEnableAction(false)
		end
		
		item.item_id = v.item_id
		item:registerScriptTapHandler(handler(self, self.onItem))
		ex.Tools:itemEnterAction(item)
		return item
	end
	layer.scroll_view:reloadData(reward)
	
end

function ShenYuRewardCtr:onItem(tag, pSender)
	-- 精灵不显示详细信息，只显示简介
	ex.Tools:onClickItemInfo(pSender.item_type or pSender.hero_type, pSender.item_id)
end

-- 额外增加奖励
function ShenYuRewardCtr:addReward(data, is_not_combine)
	if not self:getLayer() then
		return
	end

	local layer = self.layer
	-- 合并相同项。否则在结尾添加
	if is_not_combine == nil or is_not_combine == false then
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
	else
		layer.vec_reward = data
	end
	
	self:updateReward(layer.vec_reward)
end

function ShenYuRewardCtr:addBottomTip(tip)
	if not self:isOpened() then
		return
	end

	self.layer:addBottomTip(tip)
end

return ShenYuRewardCtr
