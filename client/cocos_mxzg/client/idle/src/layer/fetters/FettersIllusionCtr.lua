--[[
* @Description: 羁绊幻化
* @Author: 熊梦
* @Date: 2020-07-20 10:40:00
* ]]

local FettersIllusionCtr = class("FettersIllusionCtr",require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local FettersIllusionLayer = class("FettersIllusionLayer",require("src.comp.EventLayerAdaptiveWidth"))

function FettersIllusionLayer:onCreate()
    self:addBlackBackground()
    self:registerBtnEvent()
	

	self:iniData()

end

function FettersIllusionLayer:iniData()
	self.btn_right:getNormalImage():setFlippedX(true)
	self.btn_right:getParent():setLocalZOrder(1)
   	-- 选择的羁绊类型
	self.selected_idx = ex.Player.fetter_data.fetterIllusionInfo.use_type == 0 and 1 or ex.Player.fetter_data.fetterIllusionInfo.use_type
	-- 羁绊动画类型
    self.hero_idx = -1
	-- 当前spine精灵
	self.sp_fetter = nil
	-- 最大角色数量
	
	self.max_num = #cfg.goddessfashiontype.goddessfashiontype
	self.bShowView = {}
	for i=1,2 do 
		self.bShowView[i] = false
	end
	if ex.Player.fetter_data.fetterIllusionInfo.active_type ~= nil then
		for i,v in ipairs(ex.Player.fetter_data.fetterIllusionInfo.active_type) do
			self.bShowView[v] = true
		end	
	end
	

	
	self:addEvent(EVENT.FETTER_EVENT.ILLUSION_UPDATE_TASK,handler(self,self.updateViewTask))
	self:addEvent(EVENT.FETTER_EVENT.ILLUSION_UPDATE_ITEM,handler(self,self.updateView2Progress))
	self:addEvent(EVENT.FETTER_EVENT.ILLUSION_SKIN_ACTIVATION,handler(self,self.skinActivation))
	self:addEvent(EVENT.FETTER_EVENT.ILLUSION_SKIN_WRAR,handler(self,self.skinWear))
	

	self:addRedDotNode(RedDotType.ZCJ_DHJB_HHT_RL, self.btn_Illusion)
	self:addRedDotNode(RedDotType.ZCJ_DHJB_HHT_HHZBQH, self.btn_left)
	self:addRedDotNode(RedDotType.ZCJ_DHJB_HHT_HHYBQH, self.btn_right)
	self:addRedDotNode(RedDotType.ZCJ_DHJB_HHT_HHZBQH_PFYJH, self.btn_view1_activation)
	self:addRedDotNode(RedDotType.ZCJ_DHJB_HHT_HHYBQH_PFEJH, self.btn_view2_activation)

	self:updateHero()
	self:updateLayer()
	self:iniDataView1()
	self:iniDataView2()
	self:iniDataView3()
end


function FettersIllusionLayer:iniDataView1()
	if self.bShowView[1] then return end
	
	local viewsize = cc.Director:getInstance():getWinSize()
	local size = self.spr_bg:getContentSize()
    self.viewSize = cc.size(560,245)
	self.scroll_size = cc.size(478,555)

	-- 最大任务数目
	self.task_max_progress = #ex.Player.fetter_data.lllusion_task_cfg
	
	self:createView1Progress()
	self:updateViewTask()
end


function FettersIllusionLayer:iniDataView2()
	--if self.bShowView[2] then return end

	self:createView2Progress()

end


function FettersIllusionLayer:iniDataView3()
	if not self.bShowView[1] and not self.bShowView[2] and not self.bShowView[3] then return end
	if not self.bShowView[self.selected_idx] then return end
	self:updateView3Layer()
end

function FettersIllusionLayer:createView1Progress()
    self.progressTimer_view1 = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("fetters/spr-jdt.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setScaleX(1)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.spr_view1_progress_bg:addChild(self.progressTimer_view1)
    self.progressTimer_view1:setPosition(self.spr_view1_progress_bg:getContentSize().width / 2 ,self.spr_view1_progress_bg:getContentSize().height / 2 )
    self:updateView1Progress()
end

function FettersIllusionLayer:updateView1Progress()
	local num = 0
	for k,v in pairs(ex.Player.fetter_data.fetterIllusionTaskInfo) do
		if v.had_reward == true then	
			num = num + 1
		end
	end
    local percent = num / self.task_max_progress * 100
    if percent > 100 then percent = 100 end
	self.progressTimer_view1:setPercentage(percent)
	self.lbl_view1_progress:setString(string.format( "%s/%s",num,self.task_max_progress ))
end

function FettersIllusionLayer:createView2Progress()
    self.progressTimer_view2 = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("dragon/progress.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setScaleX(1)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.spr_view2_progress_bg:addChild(self.progressTimer_view2)
    self.progressTimer_view2:setPosition(self.spr_view2_progress_bg:getContentSize().width / 2 ,self.spr_view2_progress_bg:getContentSize().height / 2 )
    self:updateView2Progress()
end

function FettersIllusionLayer:updateView2Progress()
	if self.bShowView[self.selected_idx] then return end 
	local task = 0
	local num = 0
	for i,v in ipairs(cfg.goddessfashiontype.goddessfashiontype) do
		if v.type == 2 or v.type == 3 then
			if self.selected_idx == v.type then
				task = v.need_item[1].item_num
				num = ex.Player:getItemNum(v.need_item[1].item_type)
			end
		end
	end

    local percent = num / task * 100
    if percent > 100 then percent = 100 end
	self.progressTimer_view2:setPercentage(percent)
	self.lbl_view2_progress:setString(string.format( "%s/%s",num,task ))
end

function FettersIllusionLayer:updateLayer()
    self.btn_right:setVisible(self.selected_idx ~= self.max_num)
	self.btn_left:setVisible(self.selected_idx ~= 1)

	if self.selected_idx == 1 then
		if self.bShowView[1] then
			self.node_view1:setVisible(false)
			self.node_view2:setVisible(false)
			self.node_view3:setVisible(true)
		else
			self.node_view1:setVisible(true)
			self.node_view2:setVisible(false)
			self.node_view3:setVisible(false)
		end
		self.lbl_name:setString(ex.Tools:getLang(76221))
	elseif self.selected_idx == 2 or self.selected_idx == 3 then
		if self.bShowView[self.selected_idx] then
			self.node_view1:setVisible(false)
			self.node_view2:setVisible(false)
			self.node_view3:setVisible(true)
		else
			self.node_view1:setVisible(false)
			self.node_view2:setVisible(true)
			self.node_view3:setVisible(false)
		end
		if self.selected_idx == 3 then
			self.lbl_name:setString(ex.Tools:getLang(76224))
		else
			self.lbl_name:setString(ex.Tools:getLang(76222))
		end
		self:updateView2Progress()
	end

	-- 修改显示属性
	local str_attr_fix = ""
	for k,v in ipairs(cfg.goddessfashiontype.goddessfashiontype) do
		if v.type == self.selected_idx then
			for index,value in ipairs(v.attr) do
				local str = ex.Tools:getLang(2140000 + value.attr)		
				str = ex.StringUtil.formatAttrStr(str, "##" , value.value)
				str_attr_fix = str_attr_fix .. str.." "
			end
		end
	end
	self.lbl_unlock_effect:setString(str_attr_fix)

	self.lbl_time:setString(ex.Tools:getLang(3813))
	if self.bShowView[self.selected_idx] then
		self.lbl_time:setString(ex.Tools:getLang(3802))
	end
	-- 修改界面3 激活界面的数据
	self:updateView3Layer()
end


function FettersIllusionLayer:updateView3Layer()
	-- 修改显示属性
	for k,v in ipairs(cfg.goddessfashiontype.goddessfashiontype) do
		if v.type == self.selected_idx then
			for index,value in ipairs(v.attr) do
				local str = ex.Tools:getLang(2140000 + value.attr)		
				str = ex.StringUtil.formatAttrStr(str, "##" , value.value)
				if index == 1 then
					self.lbl_attack:setString(str)
				elseif index == 2 then
					self.lbl_hp:setString(str)
				end
			end
		end
	end

	if ex.Player.fetter_data.fetterIllusionInfo.use_type == self.selected_idx then
		self.btn_cancelwear:setVisible(true)
		self.btn_wear:setVisible(false)
		self.lbl_wear_name:setVisible(true)
	else
		self.btn_cancelwear:setVisible(false)
		self.btn_wear:setVisible(true)
		self.lbl_wear_name:setVisible(false)
	end

	local namelang = 76221
	if self.selected_idx == 3 then
		namelang = 76224
	elseif self.selected_idx == 2 then
		namelang = 76222
	end
	self.lbl_wear_name:setString(ex.Tools:getLang(76306)..ex.Tools:getLang(namelang))
end

function FettersIllusionLayer:onRight()
	if self:getActionByTag(10) ~= nil then
		return
	end

	self.selected_idx = math.min(self.max_num, self.selected_idx + 1)
	self:updateHero()
	self:updateLayer()

end

function FettersIllusionLayer:onLeft()
	if self:getActionByTag(10) ~= nil then
		return
	end

	self.selected_idx = math.max(1, self.selected_idx - 1)
	self:updateHero()
	self:updateLayer()

end

-- 创建英雄移动动画
function FettersIllusionLayer:updateHero()
	if self:getActionByTag(10) ~= nil then
		return
	end

	local diff = self.selected_idx - self.hero_idx
	-- 英雄切不动了
	if diff == 0 then
		return
	end

	local skin = cfg.goddessfashiontype.goddessfashiontype[self.selected_idx].goddess_type

	local spine = self:createSpine(skin)
    self.node_spin:addChild(spine)

    -- 移动到屏幕中间
	if self.hero_idx == -1 then
		spine:setPosition(cc.p(0, 0))
	else
		spine:setPosition(cc.p(0 + ex.p.width * diff * 1.5, 0))
		spine:runAction(cc.EaseExponentialOut:create(cc.MoveTo:create(0.5,
													 cc.p(0, 0))))

		local act_tag = cc.DelayTime:create(0.5)
		act_tag:setTag(10)
		self:runAction(act_tag)
	end

	-- 当前的动画退出
	if self.sp_fetter then
		self.sp_fetter:runAction(cc.EaseExponentialOut:create(cc.MoveTo:create(0.5, cc.p(0 + ex.p.width * -1 * diff * 1.5,
		 																				 0))))

		self.sp_fetter:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.RemoveSelf:create()))
	end
	self.sp_fetter = spine

	self.hero_idx = self.selected_idx
end

function FettersIllusionLayer:createSpine(spine_type)
	-- 添加英雄动画
    local spine = sp.SkeletonAnimation:create("spine/"..spine_type..".json","spine/"..spine_type..".atlas", 1)
    spine.spine_type = spine_type
    spine:setAnimation(0, "stand", true);
    spine:update(0.1)
    return spine
end

function FettersIllusionLayer:onGoto(tag,pSender)

	local ctr = FettersIllusionCtr:instance()
	ctr:closeWindow()

	ex.JumpManager:jumpByAtom(tostring(pSender.event_arg))
end

function FettersIllusionLayer:updateViewTask()
	self:updateView1Progress()
	-- 所有任务都完成的话 显示激活页面
	local suretask = 0
	for i,v in ipairs(ex.Player.fetter_data.fetterIllusionTaskInfo) do
		if v.had_reward then
			suretask = suretask + 1
		end
	end

	if suretask == self.task_max_progress then
		self.scroll_view:setVisible(false)
		self.node_view1_btn:setVisible(true)
		return
	end

    local data = ex.Player.fetter_data.lllusion_task_cfg
	local node = require("src.layer.fetters.FetterTaskItem"):createWithCCBIFile("ccbi/FetterTaskItem.ccbi")
	local size = node:getContentSize()
    self.scroll_view:getContainer():removeAllChildren()
    self.items = {}
    local margin = 8
    local Len = table.nums(data)
    local col = math.floor((self.viewSize.width - margin * 2) / size.width) -- 列数
    local row = math.ceil(1.0 * Len / col) -- 行数
    local cont_height = size.height * row + margin * 2
    cont_height = math.max(cont_height , self.viewSize.height)
    row = math.ceil((cont_height - margin * 2) / size.height) -- 总行数

    self.scroll_view:setContentSize(cc.size(self.viewSize.width, cont_height))
    self.scroll_view:setContentOffset(cc.p(0, self.viewSize.height - cont_height))
    local index = 0
    for k,v in pairs(data) do
        local x = index % col
        local y = math.floor(index / col)
        local posX = margin + (size.width + margin) * (x)
        local posY = self.viewSize.height - (size.height + margin) * (y + 1) + margin
        local item = require("src.layer.fetters.FetterTasklllusionItem"):createWithCCBIFile("ccbi/FetterTaskItem.ccbi")
        --item:setScale(1.3)
        item:setAnchorPoint(0,0)
		item:reset(v)
		item.btn_goto.event_arg = tostring(v.jump_info.event_arg)
		item.btn_goto:registerScriptTapHandler(handler(self, self.onGoto))
        -- item.lbl_level:setString(v)
        self.scroll_view:addChild(item)
        item:setPosition(posX, posY)
        self.items[k] = item
        index = index + 1
	end
end

-- 关闭按钮
function FettersIllusionLayer:registerBtnEvent( )
	local ctr = FettersIllusionCtr:instance()
	self.btn_close:registerScriptTapHandler(handler(ctr, ctr.closeWindow))
end

-- 熔炼
function FettersIllusionLayer:onLllusion()
    require("src.layer.fetters.FettersIllusionSmeltingCtr"):instance():openWindow()

end

function FettersIllusionLayer:skinActivation()
	if ex.Player.fetter_data.fetterIllusionInfo.active_type ~= nil then
		for i,v in ipairs(ex.Player.fetter_data.fetterIllusionInfo.active_type) do
			self.bShowView[v] = true
		end	
	end
	self:updateLayer()
end

-- 激活皮肤按钮
function FettersIllusionLayer:onActivation(tag,pSender)
	local bactivation = false
	if self.selected_idx == 1 then
		-- 所有任务都完成的话 才可以激活
		local suretask = 0
		for i,v in ipairs(ex.Player.fetter_data.fetterIllusionTaskInfo) do
			if v.had_reward then
				suretask = suretask + 1
			end
		end
		if suretask == self.task_max_progress then
			bactivation = true
		end 
	elseif self.selected_idx == 2 or self.selected_idx == 3 then
		local config = cfg.goddessfashiontype.goddessfashiontype[self.selected_idx].need_item[1]
		if ex.Player:getItemNum(config.item_type) >= config.item_num then
			bactivation = true
		end
	end
	
	if not bactivation then ex.MessageView:add(ex.Tools:getLang(5014)) return end

	local req = Fetter_pb.GReqFashionActive()
	req.type = self.selected_idx
	NetManager:sendMessage(ProtocolID.GReqFashionActive, req)
	
end

-- 穿戴按钮
function FettersIllusionLayer:onWear(tag,pSender)
	self.btn_cancelwear:setVisible(false)
	self.btn_wear:setVisible(false)
	self.btn_cancelwear:setEnabled(false)
	self.btn_wear:setEnabled(false)
	local req = Fetter_pb.GReqFashionUse()
	req.fashion_type = self.selected_idx
	-- 0为卸下
	if tag == 0 then
		req.fashion_type = 0
		self.btn_wear:setVisible(true)
	else
		self.btn_cancelwear:setVisible(true)
	end
	NetManager:sendMessage(ProtocolID.GReqFashionUse, req)
end

-- 皮肤穿戴服务器回调
function FettersIllusionLayer:skinWear()
	self.btn_cancelwear:setEnabled(true)
	self.btn_wear:setEnabled(true)
	if ex.Player.fetter_data.fetterIllusionInfo.use_type == 0 then
		self.btn_wear:setVisible(true)
		self.btn_cancelwear:setVisible(false)
	elseif ex.Player.fetter_data.fetterIllusionInfo.use_type ~= self.selected_idx then
		if self.bShowView[self.selected_idx] then
			self.btn_wear:setVisible(true)
			self.btn_cancelwear:setVisible(false)
		end
	elseif ex.Player.fetter_data.fetterIllusionInfo.use_type == self.selected_idx then
		self.btn_wear:setVisible(false)
		self.btn_cancelwear:setVisible(true)
	end
	self:updateView3Layer()
end
-----------------------------------------------------------------------------
function FettersIllusionCtr:onCreate()
	self:setCCBIPath("ccbi/FettersIllusionLayer.ccbi")
	self:setIsSingle(false)
end

function FettersIllusionCtr:getLayerClass()
	return FettersIllusionLayer
end

function FettersIllusionCtr:openWindow()
	if self:isOpened() then
		return
	end
	self:loadLayer()
	self:open()
end

function FettersIllusionCtr:initData(type, total_num, need, level, level_max, callback)

end


return FettersIllusionCtr
