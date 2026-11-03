local FettersInfoLayer = class("FettersInfoLayer", require("src.comp.EventLayerAdaptiveWidth"))


-- 按钮标签
local BTN_TAG =
{
	UPDATE = 1, -- 升级
	SKILL = 2,	-- 技能
	BREACH = 3, -- 突破
	REFINE = 4, -- 精炼
	BAPTISM = 5 -- 洗炼
}


function FettersInfoLayer:getAsynImage()
    local vec_image = {
		{image_name = "ccbi-res/map-bg-fetters-mainview-1.jpg", remove_type=1},
    }
    return vec_image
end

function FettersInfoLayer:onCreate()
    self:setAutoClose(false)
	self:setSwallowTouches(false)

	self.btn_vip:setLabelSize(50)
	self.btn_all:setLabelSize(53)

	self.btn_vip:setScale(ex.s.global_scale * 0.85)
	self.btn_all:setScale(ex.s.global_scale * 0.85)
	self.spr_bg:setScaleX(ex.s.global_scale)

	local notch_height = require("src.model.Game"):instance():getNotchHeight()

    self.btn_back:setPosition(self:getContentSize().width / 2 + ex.p.width / 2 / self:getScaleX() - 20 / self:getScaleX() - 60,
                              self:getContentSize().height / 2 + ex.p.height / 2 / self:getScaleY() - 100 / self:getScaleY() - 42 - notch_height)

	self.btn_back:registerScriptTapHandler(handler(self, self.onBack))
	local unlock = ex.Player.fetter_data:isUnlockAll()
	self.btn_back:setVisible(not unlock)

	-- cell容器
	self.vec_layer = {}

	-- 选择的羁绊类型
	self.selected_idx = ex.Player.fetter_data:getFetterIdxByType(ex.Player.fetter_data.vip_selected_type > 0 and ex.Player.fetter_data.vip_selected_type or ex.Player.fetter_data:getSelectedFetterType())

	-- print(self.selected_idx, "self.selected_idx")
	-- 羁绊动画类型
	self.hero_idx = -1

	-- cell 类型
	self.cur_layer_type = 0

	-- 当前spine精灵
	self.sp_fetter = nil

	-- 最大角色数量
	self.max_num = table.nums(cfg.goddessunlock.goddessunlock)

	-- cell对应的tag[1-5]
	self.btn_level:setTag(BTN_TAG.UPDATE)
	self.btn_skill:setTag(BTN_TAG.SKILL)
	self.btn_refine:setTag(BTN_TAG.BREACH)
	self.btn_uplimit:setTag(BTN_TAG.REFINE)
	self.btn_baptism:setTag(BTN_TAG.BAPTISM)

	self.spr_name_bg:setLocalZOrder(10)
	self.lbl_name:setLocalZOrder(11)
	self.node_soul:setLocalZOrder(99999)
	self.spr_bg:setLocalZOrder(-1)

    -- self.spr_name_bg:setPositionY(self.spr_name_bg:getPositionY() - notch_height)
    -- self.lbl_name:setPositionY(self.lbl_name:getPositionY() - notch_height)

	-- 创建cell
	table.insert(self.vec_layer, require("src.layer.fetters.FettersInfoLevelCell"):createWithCCBIFile("ccbi/FettersInfoLevelCell")) 
	table.insert(self.vec_layer, require("src.layer.fetters.FettersInfoSkillCell"):createWithCCBIFile("ccbi/FettersInfoSkillCell")) 
	table.insert(self.vec_layer, require("src.layer.fetters.FettersInfoRefineCell"):createWithCCBIFile("ccbi/FettersInfoRefineCell")) 
	table.insert(self.vec_layer, require("src.layer.fetters.FettersInfoUpLimitCell"):createWithCCBIFile("ccbi/FettersInfoUplimitCell")) 
	table.insert(self.vec_layer, require("src.layer.fetters.FettersInfoBaptismCell"):createWithCCBIFile("ccbi/FettersInfoBaptismCell")) 

	for k,v in pairs(self.vec_layer) do
		self:addChild(v)
	end

	self.btn_right:getNormalImage():setFlippedX(true)
	self.btn_right:setPositionX(ex.p.width - self.btn_left:getPositionX())
	self.btn_right:getParent():setLocalZOrder(1)

	self.btn_level:setChecked(true)
	self:onChangeLayer(self.btn_level:getTag())
	self:updateHero()

	self.lbl_view = cc.Label:createWithTTF(ex.Tools:getLang(47174), FONT_DEFAULT_NAME_BOLD, 40)
	self.lbl_view:setScale(0.5)
	self.lbl_view:enableOutline(cc.c3b(14, 0, 136, 255), 4)
	self.btn_view:addChild(self.lbl_view)
	self.lbl_view:setPosition(self.btn_view:getContentSize().width / 2,self.btn_view:getContentSize().height / 2)
	self.btn_view:registerScriptTapHandler(handler(self, self.onView))

	self.btn_reset:setLabelText(ex.Tools:getLang(47339))
	self.btn_reset:setLabelOutLine(cc.c4b(14, 0, 136, 255), 4)
	self.btn_reset:setLabelSize(40)
	self.btn_reset:getLabel():setTextColor(cc.c3b(255, 255, 255))

	self.spine_data = {}
	local function sor (a, b)
		return a < b
	end

	for k,v in pairs(cfg.goddessunlock.goddessunlock) do
		table.insert(self.spine_data, v.type)
	end
	table.sort(self.spine_data, sor)

	self:addEvent(EVENT.FETTER_EVENT.INFO, handler(self, self.updateLayer))
	self:addEvent(EVENT.FETTER_EVENT.SKIN, handler(self, self.updateSkin))
	self:addEvent(EVENT.BACK_PACK_EVENT.BACKPACK_UPDATA_LIST, handler(self, self.updateItemCost))

	self:addRedDotNode(RedDotType.ZCJ_DHJB_SJT, self.btn_level)
	self:addRedDotNode(RedDotType.ZCJ_DHJB_JNT, self.btn_skill)
	self:addRedDotNode(RedDotType.ZCJ_DHJB_TPT, self.btn_uplimit)
	self:addRedDotNode(RedDotType.ZCJ_DHJB_ZH, self.btn_soul)
	self:addRedDotNode(RedDotType.ZCJ_DHJB_XLT, self.btn_baptism)

	self:addRedDotNode(RedDotType.ZCJ_DHJB_ZBQH, self.btn_left)
	self:addRedDotNode(RedDotType.ZCJ_DHJB_YBQH, self.btn_right)

	self:addRedDotNode(RedDotType.ZCJ_DHJB_HHT, self.btn_Illusion)

end

function FettersInfoLayer:updateItemCost(event, item_type)
	print("FettersInfoLayer:updateItemCost", event, item_type)
	if item_type == ItemType.IT_FETTER_UNITY then
		-- 更新升级界面
		ex.EventManager:fire(EVENT.FETTER_EVENT.UPLEVEL)
		ex.EventManager:fire(EVENT.FETTER_EVENT.INFO)
	elseif item_type == ItemType.IT_FETTER_SIGNAL then
		-- 更新突破界面
		ex.EventManager:fire(EVENT.FETTER_EVENT.UPLIMIT)
		ex.EventManager:fire(EVENT.FETTER_EVENT.INFO)
		ex.EventManager:fire(EVENT.FETTER_EVENT.SKIN)
	elseif item_type == ItemType.IT_FETTER_STONE then
		-- 更新技能升级界面
		ex.EventManager:fire(EVENT.FETTER_EVENT.UPSKILL)
		ex.EventManager:fire(EVENT.FETTER_EVENT.INFO)
	elseif item_type == ItemType.IT_FETTER_REFINE then 
		--add 熊梦 更新洗炼界面
		ex.EventManager:fire(EVENT.FETTER_EVENT.REFINE)
		ex.EventManager:fire(EVENT.FETTER_EVENT.INFO)
	elseif item_type == ItemType.IT_FETTER_REFINE then
		-- 更新精炼界面
		ex.EventManager:fire(EVENT.FETTER_EVENT.REFINE)
		ex.EventManager:fire(EVENT.FETTER_EVENT.INFO)
	end
end


function FettersInfoLayer:onBack(tag,pSender)
	ex.MainSceneCtr:changeLayer(MainSceneType.DRAGON_VIEW)
end

-- 切换cell
function FettersInfoLayer:onChangeLayer(tag)
	if self.cur_layer_type ~= tag then
		ex.EventManager:fire(EVENT.FETTER_EVENT.CHANGE_TYPE)
	end
	-- ex.EventManager:fire(EVENT.FETTER_EVENT.CHANGE_TYPE)
	self.cur_layer_type = tag
	self:updateLayer()
end

function FettersInfoLayer:onView(tag,pSender)
	require("src.layer.fetters.FetterPreviewCtr"):instance():openWindow(self.spine_data[self.selected_idx])
end

-- 更新cell
function FettersInfoLayer:updateLayer()

	

	for k,v in pairs(self.vec_layer) do
		v:setVisible(false)
	end

	self.vec_layer[self.cur_layer_type]:setVisible(false)
	self.vec_layer[self.cur_layer_type]:updateLayer(self.selected_idx)

	self.btn_right:setVisible(self.selected_idx ~= self.max_num)
	self.btn_left:setVisible(self.selected_idx ~= 1)

	-- 更新羁绊名称
	local fetter_data = ex.Player.fetter_data:getFetterDataByIdx(self.selected_idx)
	local str_name = ex.Tools:getLang(3000000 + fetter_data.type)
	str_name = str_name .. (fetter_data.level > 0 and ("+" .. fetter_data.level) or "" )
	str_name = str_name .. (fetter_data.uplimit_level > 0 and (ex.Tools:getLang(47148) .. fetter_data.uplimit_level .. "]") or "" )
	str_name = str_name .. (fetter_data.refine_level > 0 and (ex.Tools:getLang(47235) .. fetter_data.refine_level .. "]") or "" )
	str_name = str_name .. (fetter_data.wash_level > 0 and (ex.Tools:getLang(47777) .. fetter_data.wash_level .. "]") or "" )
	self.lbl_name:setString(str_name)
	self.spr_name_bg:setContentSize(cc.size(self.lbl_name:getContentSize().width + 100, self.spr_name_bg:getContentSize().height))

	for i=1,10 do
		local lbl_skill = self["lbl_skill"..i]
		if lbl_skill then
			lbl_skill:setVisible(false)
		else
			break
		end
	end

	local vec_skill_attr = ex.Player.fetter_data:getTeamAttr(fetter_data.type)
	for i,v in ipairs(vec_skill_attr) do
		local str = ex.Tools:getLang(2140000 + v.attr[1].attr)
		str = ex.StringUtil.formatAttrStr(str, "##" , v.attr[1].value)

		local lbl_skill = self["lbl_skill"..i]
		lbl_skill:setString(string.format(ex.Tools:getLang(47674), v.skill_level) .. str)
		lbl_skill:setColor(fetter_data.skill_level >= v.skill_level and cc.c3b(77, 208, 40) or cc.c3b(255, 224, 178))
		lbl_skill:setVisible(true)
	end
	

	self.node_attr:setVisible(false)
	self.node_up:setVisible(false)
	self.node_skill_info:setVisible(false)
	self.node_baptism_info:setVisible(false)
	self.node_skill:setVisible(false)
	self.node_unlock:setVisible(false)
	self.node_bg:setVisible(false)
	self.node_vip:setVisible(false)
	self.node_view:setVisible(false)
	self.node_soul:setVisible(false)

	local is_unlock_all = ex.Player.fetter_data:isUnlockAll()
	local is_unlock_select = ex.Player.fetter_data:isUnlock(fetter_data.type)

	if is_unlock_all == true then
		-- 全部解锁
		self.vec_layer[self.cur_layer_type]:setVisible(true)
		self.node_skill_info:setVisible(true)
		self.node_up:setVisible(true)
		self.node_vip:setVisible(true)
		self.node_view:setVisible(true)
		self.node_soul:setVisible(true)
	elseif is_unlock_select ~= true then
		-- 没有解锁
		self.node_bg:setVisible(true)
		self.node_skill:setVisible(true)
		self.node_unlock:setVisible(true)
		
		local skill_type = ex.Player.fetter_data:getSkillType(fetter_data.type)	
		self.lbl_skill_name:setString(ex.Player.hero_data:getSkillName(skill_type))
		self.lbl_des:setString(ex.Player.hero_data:getSkillDescription(skill_type, 1))
	
	else
		-- 当前的已经解锁。但是不能养成
		self.node_bg:setVisible(true)
		self.node_vip:setVisible(true)
		-- self.node_view:setVisible(true)
		self.node_attr:setVisible(true)

		local vec_attr = ex.Player.fetter_data:getLevelAttr(fetter_data.level, fetter_data.exp)
		self.lbl_hp:setString(string.format("%d", vec_attr[AbilityType.AT_HP_ADD]))
		self.lbl_attack:setString(string.format("%d", vec_attr[AbilityType.AT_ATTACK_ADD]))
	end

	-- 洗练功能屏蔽
	self.btn_reset:setVisible(false)

	if self.cur_layer_type == BTN_TAG.BAPTISM then
		self.node_baptism_info:setVisible(true)

		self.node_skill_info:setVisible(false)
		self.btn_view:setVisible(false)
		-- self.btn_reset:setVisible(false)
		self.node_vip:setVisible(false)
	else
		self.node_baptism_info:setVisible(false)

		self.node_skill_info:setVisible(self.node_skill_info:isVisible() and true or false)
		self.btn_view:setVisible(self.node_view:isVisible() and true or false)
		-- self.btn_reset:setVisible(self.node_view:isVisible() and true or false)
		self.node_vip:setVisible(self.node_vip:isVisible() and true or false)
	end
	--add 熊梦 显示洗炼增加数据
	local vec_baptism_attr = ex.Player.fetter_data:getBaptismTeamAttr(fetter_data.wash_level)
	for i,v in ipairs(vec_baptism_attr) do
		local str = ex.Tools:getLang(2140000 + v.attr)
		str = ex.StringUtil.formatAttrStr(str, "##" , v.value)

		local lbl_baptism = self["lbl_baptism"..i]
		lbl_baptism:setString(str)
		--lbl_baptism:setColor(fetter_data.skill_level >= v.skill_level and cc.c3b(77, 208, 40) or cc.c3b(255, 224, 178))
		lbl_baptism:setVisible(true)
	end

	ex.Player.fetter_data:saveSelectedFetterType(fetter_data.type)

	if ex.Player.fetter_data:isUnlockAll() == true then
		-- 更新当前羁绊红点信息
		ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHJB_SJT_JBSJ, ex.Player.fetter_data:checkLevelReddot(fetter_data.type))
		ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHJB_JNT_JBJN, ex.Player.fetter_data:checkSkillReddot(fetter_data.type))
		ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHJB_TPT_JBTP, ex.Player.fetter_data:checkUplimitReddot(fetter_data.type))
		ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHJB_XLT_JBXL, ex.Player.fetter_data:checkBaptismReddot(fetter_data.type))
		-- 更新左边羁绊红点信息
		for k,v in pairs(ex.Player.fetter_data.vec_fetter) do
			if v.type < fetter_data.type then
				local is_visible = ex.Player.fetter_data:checkLevelReddot(v.type)
				is_visible = (is_visible == true) or ex.Player.fetter_data:checkSkillReddot(v.type)
				is_visible = (is_visible == true) or ex.Player.fetter_data:checkUplimitReddot(v.type)
				is_visible = (is_visible == true) or ex.Player.fetter_data:checkSoulReddot(v.type)
				ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHJB_ZBQH, is_visible)
				if is_visible then
					break
				end
			end
		end

		-- 更新右边羁绊红点信息
		for k,v in pairs(ex.Player.fetter_data.vec_fetter) do
			if v.type > fetter_data.type then
				local is_visible = ex.Player.fetter_data:checkLevelReddot(v.type)
				is_visible = (is_visible == true) or ex.Player.fetter_data:checkSkillReddot(v.type)
				is_visible = (is_visible == true) or ex.Player.fetter_data:checkUplimitReddot(v.type)
				is_visible = (is_visible == true) or ex.Player.fetter_data:checkSoulReddot(v.type)
				ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHJB_YBQH, is_visible)
				if is_visible then
					break
				end
			end
		end

		ex.Player.fetter_data:checkReddot()

		local is_soul_visible = ex.Player.fetter_data:checkSoulReddot(fetter_data.type)
		ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHJB_ZH, is_soul_visible)
	end
end

function FettersInfoLayer:updateSkin()
	local fetter_data = ex.Player.fetter_data:getFetterDataByIdx(self.selected_idx)
	local skin = ex.Player.fetter_data:getSkin(fetter_data.type)
	if self.sp_fetter and skin ~= self.sp_fetter.spine_type then
		self.sp_fetter:removeFromParent()
		self.sp_fetter = nil
		self.sp_fetter = self:createSpine(skin)
		self.sp_fetter:setPosition(cc.p(ex.p.width * 0.5, ex.p.height * 0.66 - 130))
		self:addChild(self.sp_fetter, -1)
	end
end

function FettersInfoLayer:createSpine(spine_type)
	-- 添加英雄动画
    local spine = sp.SkeletonAnimation:create("spine/"..spine_type..".json","spine/"..spine_type..".atlas", 1)
    spine.spine_type = spine_type
    spine:setAnimation(0, "stand", true);
    spine:update(0.1)
    return spine
end


-- 创建英雄移动动画
function FettersInfoLayer:updateHero()
	if self:getActionByTag(10) ~= nil then
		return
	end

	local diff = self.selected_idx - self.hero_idx
	-- 英雄切不动了
	if diff == 0 then
		return
	end

	local fetter_data = ex.Player.fetter_data:getFetterDataByIdx(self.selected_idx)
	local skin = ex.Player.fetter_data:getSkin(fetter_data.type)
	dump(fetter_data)
	-- 显示默认的
	-- if self.hero_idx == -1 then
		-- spine_type = tostring(vec_spine[1])
	-- else
		-- spine_type = skin-- tostring(vec_spine[self.selected_idx])
	-- end

	local spine = self:createSpine(skin)
    self:addChild(spine, -1)


    -- 移动到屏幕中间
	if self.hero_idx == -1 then
		spine:setPosition(cc.p(ex.p.width * 0.5, ex.p.height * 0.66 - 140))
	else
		spine:setPosition(cc.p(ex.p.width * 0.5 + ex.p.width * diff * 1.5, ex.p.height * 0.66 - 140))
		spine:runAction(cc.EaseExponentialOut:create(cc.MoveTo:create(0.5,
													 cc.p(ex.p.width * 0.5, spine:getPositionY()))))

		local act_tag = cc.DelayTime:create(0.5)
		act_tag:setTag(10)
		self:runAction(act_tag)
	end

	-- 当前的动画退出
	if self.sp_fetter then
		self.sp_fetter:runAction(cc.EaseExponentialOut:create(cc.MoveTo:create(0.5, cc.p(ex.p.width * 0.5 + ex.p.width * -1 * diff * 1.5,
		 																				 self.btn_right:getPositionY()))))

		self.sp_fetter:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.RemoveSelf:create()))
	end
	self.sp_fetter = spine

	self.hero_idx = self.selected_idx
end

function FettersInfoLayer:onLeft()
	if self:getActionByTag(10) ~= nil then
		return
	end

	self.selected_idx = math.max(1, self.selected_idx - 1)
	self:updateHero()
	self:updateLayer()

	ex.EventManager:fire(EVENT.FETTER_EVENT.CHANGE_TYPE)
end

function FettersInfoLayer:onRight()
	if self:getActionByTag(10) ~= nil then
		return
	end

	self.selected_idx = math.min(self.max_num, self.selected_idx + 1)
	self:updateHero()
	self:updateLayer()

	ex.EventManager:fire(EVENT.FETTER_EVENT.CHANGE_TYPE)
end

function FettersInfoLayer:onVip()
	require("src.layer.fetters.FetterVipInfoCtr"):instance():openWindow()
end

function FettersInfoLayer:onAll()
	ex.MainSceneCtr:changeLayer(MainSceneType.DRAGON_VIEW)
end

function FettersInfoLayer:onBattle()
	ex.MainSceneCtr:changeLayer(MainSceneType.MLT_BATTLE)
end

function FettersInfoLayer:onReset()
	local fetter_data = ex.Player.fetter_data:getFetterDataByIdx(self.selected_idx)
	if not fetter_data then
		return
	end

	if fetter_data.level <= 1 and
	   fetter_data.exp <= 0 and
	   fetter_data.skill_level <= 1 and
	   fetter_data.uplimit_level <= 0 then

		ex.MessageView:add(ex.Tools:getLang(41133))
		return
	end
	
	-- 
	local vec_back = ex.Player.fetter_data:getResetBack(fetter_data.type)
	local reset_cost = ex.Player.fetter_data:getResetCost()

	require("src.layer.AltarConfirmCtr"):instance():openWindow(ex.Tools:getLang(41131), 
	 string.format(ex.Tools:getLang(41132),
	 			   reset_cost[1].item_type,
				   ex.Tools:getLang(cfg.item.item[ reset_cost[1].item_type].name),
				   reset_cost[1].item_num,
				   ex.Tools:getLang(3000000 + fetter_data.type)),
				   vec_back,
				   function()
		self:onResetDone()
	end)
end

function FettersInfoLayer:onResetDone()
	local fetter_data = ex.Player.fetter_data:getFetterDataByIdx(self.selected_idx)
	if not fetter_data then
		return
	end

	local reset_cost = ex.Player.fetter_data:getResetCost()
	for i,v in ipairs(reset_cost) do
		local has_material = ex.Player:getItemNum(v.item_type)
		if has_material < v.item_num then
			ex.Tools:showEnoughTip(v.item_type)
			-- ex.MessageView:add(string.format(ex.Tools:getLang(47098), ex.Tools:getLang(v.type)))
			return
		end
	end

	local req_reset = Fetter_pb.GReqFetterReset()
	req_reset.idx = fetter_data.type
	NetManager:sendMessage(ProtocolID.GReqFetterReset, req_reset)
	-- ex.MainSceneCtr:changeLayer(MainSceneType.MLT_BATTLE)
end

function FettersInfoLayer:onSoul()
	local fetter_data = ex.Player.fetter_data:getFetterDataByIdx(self.selected_idx)
	if not fetter_data then
		return
	end 
	local has, need, soul_level, level_max = ex.Player.fetter_data:getSoulData(fetter_data.type)

	require("src.layer.fetters.FettersCastSoulCtr"):instance():openWindow(fetter_data.type, has, need, soul_level, level_max,
	function(type, num)
		local has, need, soul_level, level_max = ex.Player.fetter_data:getSoulData(type)
		if soul_level >= level_max then
			ex.MessageView:add(ex.Tools:getLang(41260))
			return
		end

		if has <= 0 then
			ex.Tools:showEnoughTip(ItemType.IT_FETTERS_SOUL)
			return
		end

		if num > 0 then
			local req_soul = Fetter_pb.GReqFetterMakeSoul()
			req_soul.idx = type
			req_soul.num = num
			NetManager:sendMessage(ProtocolID.GReqFetterMakeSoul, req_soul)
		end
	end)
end

function FettersInfoLayer:onLllusion()
	local open_config = cfg.opencondition.condition["main_fetter_Illusion"]
	if not open_config then
		return
	end
	if ex.Player.level < open_config.condition_value then
		ex.MessageView:add(string.format( ex.Tools:getLang(1341),open_config.condition_value ) )
		return
	end

	require("src.layer.fetters.FettersIllusionCtr"):instance():openWindow()

end

return FettersInfoLayer
