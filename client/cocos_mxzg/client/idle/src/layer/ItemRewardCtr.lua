local ItemRewardCtr = class("ItemRewardCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ItemRewardLayer = class("ItemRewardLayer", require("src.comp.EventLayer"))
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

function ItemRewardLayer:onCreate()
	self:setAutoClose(true)
	self:addBlackBackground()

	self:setExitCallback(handler(self,self.exitCallBack))

	self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)

	ex.EffectFactory:createEffectWithNodeByNameAsyn("eff_reward", self, cc.p(self.spr_title:getPositionX(), self.spr_title:getPositionY()), 20)
    -- local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_reward")
    -- spr_effect:setPosition(self.spr_title:getPositionX(), self.spr_title:getPositionY())
    -- self:addChild(spr_effect, 20, 100)

	local top = self.spr_title:getPositionY() - self.spr_title:getContentSize().height / 2 - 5
	local bottom = 20

	self.scroll_view:setViewSize(cc.size(self.spr_bg:getContentSize().width - 40, top - bottom))
	self.scroll_view:setItemSize(cc.size(124, 134))
	-- self.scroll_view:setCreateInterval(0.1)
	self.scroll_view:setCreateNum(4)
	self.scroll_view:setAlignmentCenter(true)

	ex.Tools:layerEnterAction(self)
	-- ex.Tools:ergodicAllNode(self, function(node)

	-- 	local opacity = node:getOpacity()
	-- 	node:runAction(cc.FadeTo:create(20, 255))
	-- 	node:setOpacity(0)

	-- end)
	-- ItemRewardCtr.allChildrenFade(ItemRewardCtr, self, 0.1, true)
    -- self.scroll_view = cc.ScrollView:create()
    -- :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    -- :setPosition(20, bottom)
    -- self:addChild(self.scroll_view)
end

function ItemRewardLayer:exitCallBack()
	if self.eventData ~= nil and self.eventData.event ~= "" then 
		ex.EventManager:fire(self.eventData.event,self.eventData.data)
	end
	self.eventData = nil
end

function ItemRewardLayer:addBottomTip(str)
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
		require("src.layer.ItemRewardCtr"):instance():closeWindow()
		ex.JumpManager:jumpByAtom(atom)
	end)
	self:addChild(lbl_active)
end


-----------------------------------------------------------------------------
function ItemRewardCtr:onCreate()
	self:setCCBIPath("ccbi/ItemRewardLayer.ccbi")
	self:setIsSingle(false)
end

function ItemRewardCtr:getLayerClass()
	return ItemRewardLayer
end

function ItemRewardCtr:getItemRewardLayer()
	return self.layer
end

function ItemRewardCtr:openWindow(vec_reward, is_not_combine)
	vec_reward = clone(vec_reward)
	self.closeRewardData = vec_reward
	if self:isOpened() then
		self:addReward(vec_reward, is_not_combine)
		return
	end

	-- local sfc = cc.SpriteFrameCache:getInstance()
	-- sfc:addSpriteFrames("ccbi-res/summon-effect.plist")
    -- sfc:addSpriteFrames("ccbi-res/reward-layer.plist")

	self:loadLayer()
	self:open()
	-- 更新标题
	-- self.layer.lbl_title:setString(str_title)
	self:updateReward(vec_reward)

	ex.AudioManager:playEffect("music/item-get.mp3")
		--self:openActionEnd()
end

function ItemRewardCtr:updateReward(vec_reward)
	-- dump(debug.traceback())
	-- dump(vec_reward, "vec_reward")

	local layer = self.layer

    -- 播放彩带爆炸
    -- self.layer.spr_effect_bomb = ex.EffectFactory:createEffectWithNodeByName("eff_reward_bomb")
    -- self.layer.spr_effect_bomb:setPosition(self.layer:getContentSize().width / 2, self.layer:getContentSize().height + 100)
	-- self.layer:addChild(self.layer.spr_effect_bomb, 100)
	ex.EffectFactory:createEffectWithNodeByNameAsyn("eff_reward_bomb", self.layer, cc.p(self.layer:getContentSize().width / 2, self.layer:getContentSize().height + 100), 100)

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
			dump(vec_reward, "ItemRewardCtr:updateReward item_config "..v.item_type.."is nil")
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
			local now_hero_id = "0"
			if v.hero_id ~= nil then
				now_hero_id = v.hero_id
			elseif v.item_id ~= nil then
				now_hero_id = v.item_id
			end

        	item = UIMenuItemHero:createWithData(now_hero_id , config.type, config.elem, now_level, now_star)
			item:setEnableAction(false)
		end
		
		item.item_id = v.item_id
		item:registerScriptTapHandler(handler(self, self.onItem))
		ex.Tools:itemEnterAction(item)
		return item
	end
	layer.scroll_view:reloadData(reward)
	
end

function ItemRewardCtr:onItem(tag, pSender)
	-- 精灵不显示详细信息，只显示简介
	local type = pSender.item_type or pSender.hero_type
	local tag = ex.Player.backpack_data:getPropType(type)
	if tag == ItemData.IT_HERO or tag == ItemData.IT_HERO_MATERIAL then
		ex.Tools:onClickItemInfo(pSender.item_type or pSender.hero_type, pSender.item_id, nil, nil, pSender.hero_id)
	else
		ex.Tools:onClickItemInfo(pSender.item_type or pSender.hero_type, pSender.item_id)
	end
end

-- 额外增加奖励
function ItemRewardCtr:addReward(data, is_not_combine)
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

function ItemRewardCtr:addBottomTip(tip)
	if not self:isOpened() then
		return
	end

	self.layer:addBottomTip(tip)
end

function  ItemRewardCtr:closeWindow( )
	local fashionData = {}
	local haveFashionData = ex.Player.hero_data.fashion
	if (haveFashionData and haveFashionData.fashion_list and next(haveFashionData.fashion_list)) then
		for i, v in ipairs(self.closeRewardData) do
			local item_config = cfg.item.item[v.item_type]
			if (item_config and ItemData.IT_HERO_FASHION == item_config.type) then
				local configFashion = cfg.herofashionunlock.getConfigByType(v.item_type)
				for a, b in ipairs(haveFashionData.fashion_list) do
					if (configFashion and configFashion.fashion_id == b.fashion_id and b.end_time == 0 and b.status == 0) then
						table.insert(fashionData, v)
						break
					end
				end
			end
		end
	end
	self:close(self.layer)
	if (next(fashionData)) then
		table.sort(fashionData, function (a, b)
			return a.item_num > b.item_num
		end)
		if (fashionData[1]) then
			local decompos_cfg = cfg.decompositionitem.decompositionitem[fashionData[1].item_type]
			if not decompos_cfg then
				ex.MessageView:add("没有找到分解配置item_type:" .. fashionData[1].item_type)
				return 
			end
			require("src.layer.decomposeItem.DecomposeSelectCtr"):instance():openWindow(fashionData[1])
		end
	end
end

return ItemRewardCtr
