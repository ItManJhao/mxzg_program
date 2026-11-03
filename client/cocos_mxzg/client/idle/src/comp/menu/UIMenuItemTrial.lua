local UIMenuItemTrial = class("UIMenuItemTrial", function (params1, params2, params3)
	return cpp.UIMenuItemImage:createWithSpriteFrameName(params1, params2, params3)
end)

function UIMenuItemTrial:reset(data, is_big_box)
	self.data = data or {}
	self.is_big_box = is_big_box
	self:onInit(data)
	self:resetImg()
end

function UIMenuItemTrial:getData()
	return self.data 
end

function UIMenuItemTrial:onInit()

end

function UIMenuItemTrial:initNode()
	self.spr_bg = nil
	self.lbl_level = nil
	self.node_star = nil
	self.lbl_shop_count = nil
	self.spr_select = nil
end

function UIMenuItemTrial:createWithData(data, tag)
	local pRet = UIMenuItemTrial:create("trial/spr-box-open.png", nil, nil)
	if pRet then
		pRet:initNode()
		pRet:setTag(tag or -1)
		return pRet
	end
	pRet = nil
	return nil
end

function UIMenuItemTrial:resetImg()
	local tag = self:getTag()

	-- 关卡的战斗数据
	local battle_data = ex.Player.trial_data:getBattleData(tag)

	-- 是否是当前关卡
	local cur_mission = ex.Player.trial_data:getMissionId()

	-- 
	self.type = cfg.mainadventurepos.pos[tag].type
	self:getNormalImage():removeAllChildren()

	local file_name =  ""
	if self.type ~= 1 then
		local box_status = ex.Player.trial_data:getBoxStatus(tag)
		if self.is_big_box == true then
			file_name = box_status >= 0 and "trial/spr-box-open-2.png" or ("trial/spr-box-2.png")
		else
			file_name = box_status >= 0 and "trial/spr-box-open.png" or ("trial/spr-box.png")
		end
	else
		file_name = (battle_data and battle_data.status == 1) and ("trial/btn-destroy.png") or "trial/btn-unbroken.png"
	end

	local normal_image = self:getNormalImage()
	ex.Tools:setSpriteFrame(normal_image, file_name)
	self:setContentSize(normal_image:getContentSize())
	normal_image:setPosition(self:getContentSize().width * 0.5 - normal_image:getContentSize().width * 0.5,  self:getContentSize().height * 0.5 - normal_image:getContentSize().height * 0.5)

	-- print("file_name", file_name,tag , cur_mission, self.type)


	if self.type == 1 then
		if tag == cur_mission and (battle_data == nil or battle_data.status ~= 1) then
			-- 添加刀剑特效
			local spine_sword = sp.SkeletonAnimation:create("spine/battle-sword.json","spine/battle-sword.atlas", 1)
			spine_sword:setAnimation(0, "stand", true);
			self:getNormalImage():addChild(spine_sword, 9999)
			
			spine_sword:setScale(0.5)
			spine_sword:setPosition(self:getContentSize().width * 0.5, self:getContentSize().height * 0.8)
		end
	else
		local box_status = ex.Player.trial_data:getBoxStatus(tag)

		if box_status == 0 then
			local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_box_open")
			spr_effect:setPosition(self:getContentSize().width / 2 - 10, self:getContentSize().height / 2 - 15)
			spr_effect:setAnchorPoint(cc.p(0.5, 0))
			self:getNormalImage():addChild(spr_effect, 10, 10)

			if self.is_big_box == true then
				spr_effect:setScaleX(spr_effect:getScaleX() * 1.6)
				spr_effect:setScaleY(spr_effect:getScaleY() * 1.3)
				spr_effect:setPosition(self:getContentSize().width / 2 - 10, self:getContentSize().height / 2 - 25)
			end
		elseif box_status == -1 then
			local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_trial_box_unopen")
			spr_effect:setPosition(self:getContentSize().width / 2 - 5, 15         )
			spr_effect:setAnchorPoint(cc.p(0.5, 0.25))
			spr_effect:setOpacity(200)
			self:getNormalImage():addChild(spr_effect, -1, 10)

			local spr_effect_2 = ex.EffectFactory:createEffectWithNodeByName("eff_trial_box_unopen")
			spr_effect_2:setPosition(self:getContentSize().width / 2 - 5, 15)
			spr_effect_2:setAnchorPoint(cc.p(0.5, 0.25))
			spr_effect_2:setOpacity(120)
			self:getNormalImage():addChild(spr_effect_2, 10, 10)

			if self.is_big_box == true then
				spr_effect:setScaleX(spr_effect:getScaleX() * 1.3)
				spr_effect:setScaleY(spr_effect:getScaleY() * 1.3)
				spr_effect_2:setScaleX(spr_effect_2:getScaleX() * 1.3)
				spr_effect_2:setScaleY(spr_effect_2:getScaleY() * 1.3)
			end
		else 
			local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_box_unopen")
			spr_effect:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
			spr_effect:setAnchorPoint(cc.p(0.5, 0))
			self:getNormalImage():addChild(spr_effect, 10, 10)
		end
	end
end

function UIMenuItemTrial:getData()
	return self.data 
end

function UIMenuItemTrial:getType()
	return self.type 
end

function UIMenuItemTrial:getMissionId()
	return self.data[1].mission_id
end

return UIMenuItemTrial
