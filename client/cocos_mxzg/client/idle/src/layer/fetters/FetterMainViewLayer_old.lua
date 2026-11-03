local FetterMainViewLayer = class("FetterMainViewLayer",require("src.comp.EventLayer"))

function FetterMainViewLayer:onCreate()
    self:setAutoClose(false)
	self:setSwallowTouches(false)
	
	-- 选择的羁绊类型
	self.selected_idx = 1

	-- 羁绊动画类型
	self.hero_idx = -1

	-- cell 类型
	self.cur_layer_type = 0

	-- 当前spine精灵
	self.sp_fetter = nil

	self.spine_data = {10101,10201,10301,10401,10501}


	local viewsize = cc.Director:getInstance():getWinSize()
	local size = self.spr_bg:getContentSize()
	self.cfg_data = ex.Player.fetter_data.vip:getVIPCfg()
	self.spr_bg:setScale(viewsize.width / size.width , viewsize.height / size.height)
	self.viewSize = cc.size(560,245)
	self.btn_right:getNormalImage():setFlippedX(true)

	-- self.skill_icon = require("src.layer.fetters.FetterSkillIcon"):createWithData()
	-- local x,y = self.skill:getPosition()
	-- self.menu:addChild(self.skill_icon)
	-- self.skill_icon:setPosition(x,y)

	-- self.reward_icon = require("src.layer.fetters.FetterRewardIcon"):createWithData()
	-- local show = ex.Player.fetter_data.vip:getNextVIPSpine()
	-- self.reward_icon:reset(show)
	-- x,y = self.vip_get:getPosition()
	-- self.menu:addChild(self.reward_icon)
	-- self.reward_icon:setPosition(x,y)
	-- self.lbl_vip:setString(string.format("VIP %s",ex.Player.fetter_data.vip:getVIP()))

	if not show then 
		if self.reward_icon then 
			self.reward_icon:removeFromParent()
			self.reward_icon = nil 
		end
	end

	-- self.cfg_data = {}
	-- for k,v in pairs(cfg.goddessmission.goddessmission) do
	-- 	if v.vip_level == 12 then 
	-- 		table.insert(self.cfg_data,v)
	-- 	end
	-- end

	self:addFont()

	self:createProgress()

	self.node:setLocalZOrder(1)

	

	local function sor (a,b)
		return a.idx < b.idx
	end

	-- for k,v in pairs(cfg.goddessunlock.goddessunlock) do
	-- 	table.insert(self.spine_data,v)
	-- end
	self.max_num = table.nums(self.spine_data)

	-- table.sort(self.spine_data,sor)
	table.sort(self.cfg_data,sor)

	if show ~= nil then 
		for i,v in ipairs(self.spine_data) do
			if v == show.type then 
				self.selected_idx = i
				self.hero_idx = 0
				break
			end
		end
	end

	self:updateHero()

	-- local str = string.format(ex.Tools:getLang(47330),self.spine_data[1].vip_level)
	-- self.lbl_vip_tips:setString(str)
	self.lbl_vip_tips:setString(ex.Tools:getLang(3000000 + self.spine_data[1]))

	local tmp_vip = ex.Player.fetter_data.vip:getVIP() + 1
	if tmp_vip >= 10 then
		self.level_num_2:setVisible(true)
		local tmp_num_ten = math.floor(tmp_vip / 10)
		local str_1 = string.format("fetters/%s.png", tmp_num_ten)
		ex.Tools:setSpriteFrame(self.level_num_1, str_1)
		local str_2 = string.format("fetters/%s.png", tmp_vip - tmp_num_ten * 10)
		ex.Tools:setSpriteFrame(self.level_num_2, str_2)
	else
		self.level_num_2:setVisible(false)
		local str = string.format("fetters/%s.png", tmp_vip)
		ex.Tools:setSpriteFrame(self.level_num_1, str)
	end
	str = string.format("fetters-lang/vip%s.png", tmp_vip)
	ex.Tools:setSpriteFrame(self.spr_vip_content, str)

	self:updateView(self.cfg_data)
	self:registerBtnEvent()
	self:addEvent(EVENT.FETTER_EVENT.VIP_UPDATE,handler(self,self.updateLevel))
	self:addEvent(EVENT.FETTER_EVENT.VIP_REWARD,handler(self,self.updateReward))
end

function FetterMainViewLayer:createProgress()
    self.progressTimer = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("fetters/spr-jdt.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setScaleX(1)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.spr_progress_bg:addChild(self.progressTimer)
    self.progressTimer:setPosition(self.spr_progress_bg:getContentSize().width / 2 ,self.spr_progress_bg:getContentSize().height / 2 )
    self:updateProgress()
end

function FetterMainViewLayer:updateProgress()
	local num = 0 
	local total = 0
	for k,v in pairs(self.cfg_data) do
		local status = ex.Player.fetter_data.vip:getStatus(v.idx)
		if status == 1 then num = num + 1 end
		total = total + 1
	end
    local percent = num / total * 100
    if percent > 100 then percent = 100 end
    self.progressTimer:setPercentage(percent)
end

function FetterMainViewLayer:updateReward(event,data)
	for k,v in pairs(self.cfg_data) do
		self.items[k]:reset(v)
	end
	self:updateProgress()
end

function FetterMainViewLayer:updateLevel(event,data)
	
	self.cfg_data = ex.Player.fetter_data.vip:getVIPCfg()

	local function sor (a,b)
		return a.idx < b.idx
	end

	table.sort(self.cfg_data,sor)

	for k,v in pairs(self.cfg_data) do
		self.items[k]:reset(v)
	end

	if self.reward_icon then 
		local show = ex.Player.fetter_data.vip:getNextVIPSpine()
		self.reward_icon:reset(show)
	end

	local tmp_vip = ex.Player.fetter_data.vip:getVIP() + 1
	if tmp_vip >= 10 then
		self.level_num_2:setVisible(true)
		local tmp_num_ten = math.floor(tmp_vip / 10)
		local str_1 = string.format("fetters/%s.png", tmp_num_ten)
		ex.Tools:setSpriteFrame(self.level_num_1, str_1)
		local str_2 = string.format("fetters/%s.png", tmp_vip - tmp_num_ten * 10)
		ex.Tools:setSpriteFrame(self.level_num_2, str_2)
	else
		self.level_num_2:setVisible(false)
		local str = string.format("fetters/%s.png", tmp_vip)
		ex.Tools:setSpriteFrame(self.level_num_1, str)
	end
	str = string.format("fetters-lang/vip%s.png", tmp_vip)
	ex.Tools:setSpriteFrame(self.spr_vip_content, str)
	self.lbl_vip:setString(string.format("VIP %s", tmp_vip - 1))
	self:updateProgress()

	local vec_spine = {}
	for i,v in ipairs(self.spine_data) do
		table.insert(vec_spine,v)
	end

	local lock
	for k,v in pairs(self.spine_data) do
		if v == vec_spine[self.selected_idx] then 
			local vip_cfg = cfg.goddessvip.goddessvip[ex.Player.fetter_data.vip:getVIP()]
			lock = vip_cfg["unlock_goddess_".. v] == 0
			break
		end
	end

	ex.Tools:setGrayAuto(self.sp_fetter,lock)

	-- dump(data, "data")
end

function FetterMainViewLayer:showRewardIcon(data)
	if data == nil then 
		self.reward_icon:setVisible(false)
		return 
	end
	self.reward_icon:reset(data)
end

-- 创建英雄移动动画
function FetterMainViewLayer:updateHero()
	if self:getActionByTag(10) ~= nil then
		return
	end

	local diff = self.selected_idx - self.hero_idx
	-- 英雄切不动了
	if diff == 0 then
		return
	end

	local str_spine = ""

	-- TEST
	local vec_spine = {}
	for i,v in ipairs(self.spine_data) do
		table.insert(vec_spine,v)
	end
	-- 显示默认的
	if self.hero_idx == -1 then
		str_spine = tostring(vec_spine[1])
	else
		str_spine = tostring(vec_spine[self.selected_idx])
	end

	-- 添加英雄动画
    local spine = sp.SkeletonAnimation:create("spine/"..str_spine..".json","spine/"..str_spine..".atlas", 1)
    spine:setAnimation(0, "stand", true);

    self:addChild(spine)
    spine:update(0.1)
    local default_height = ex.p.height * 0.66 - 130
    -- 移动到屏幕中间
	if self.hero_idx == -1 then
		spine:setPosition(cc.p(ex.p.width * 0.5, default_height))
	else
		spine:setPosition(cc.p(ex.p.width * 0.5 + ex.p.width * diff * 1.5, default_height))
		spine:runAction(cc.EaseExponentialOut:create(cc.MoveTo:create(0.5,
													 cc.p(ex.p.width * 0.5, default_height))))

		local act_tag = cc.DelayTime:create(0.5)
		act_tag:setTag(10)
		self:runAction(act_tag)
	end

	-- 当前的动画退出
	if self.sp_fetter then
		self.sp_fetter:runAction(cc.EaseExponentialOut:create(cc.MoveTo:create(0.5, cc.p(ex.p.width * 0.5 + ex.p.width * -1 * diff * 1.5,
		 																				 default_height))))

		self.sp_fetter:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.RemoveSelf:create()))
	end
	self.sp_fetter = spine

	self.hero_idx = self.selected_idx

	local lock
	for k,v in pairs(self.spine_data) do
		if v == vec_spine[self.selected_idx] then 
			local vip_cfg = cfg.goddessvip.goddessvip[ex.Player.fetter_data.vip:getVIP()]
			lock = vip_cfg["unlock_goddess_".. v] == 0
			break
		end
	end

	ex.Tools:setGrayAuto(self.sp_fetter,lock)

	-- self.skill_icon:reset(vec_spine[self.selected_idx])
	self.lbl_vip_tips:setString(ex.Tools:getLang(3000000 + vec_spine[self.selected_idx]))
end

function FetterMainViewLayer:registerBtnEvent()
	self.btn_vipinfo:registerScriptTapHandler(handler(self, self.onVipInfo))
	self.btn_info:registerScriptTapHandler(handler(self, self.onInfo))
	self.btn_left:registerScriptTapHandler(handler(self, self.onLeft))
	self.btn_right:registerScriptTapHandler(handler(self, self.onRight))
	self.btn_view:registerScriptTapHandler(handler(self, self.onView))
	-- if self.reward_icon then 
	-- 	self.reward_icon:registerScriptTapHandler(handler(self, self.onShowReward))
	-- end
	-- self.skill_icon:registerScriptTapHandler(handler(self, self.onShowSkill))
end

function FetterMainViewLayer:onVipInfo(tag,pSender)
	-- ex.MainSceneCtr:changeLayer(MainSceneType.FETTER_VIP_INFO)
	require("src.layer.fetters.FetterVipInfoCtr"):instance():openWindow()
end

function FetterMainViewLayer:onInfo(tag,pSender)
	ex.MainSceneCtr:changeLayer(MainSceneType.DRAGON_VIEW)
end

function FetterMainViewLayer:onLeft(tag,pSender)
	if self:getActionByTag(10) ~= nil then
		return
	end

	self.selected_idx = math.max(1, self.selected_idx - 1)
	self:updateHero()
	
	local level = 999
	for i,v in ipairs(cfg.goddessvip.goddessvip) do
		if v["unlock_goddess_" .. self.spine_data[self.selected_idx]] == 1 then 
			level = v.vip_level
			break
		end
	end

	local str = string.format(ex.Tools:getLang(47330),level)
	self.lbl_vip_tips:setString(ex.Tools:getLang(3000000 + self.spine_data[self.selected_idx]))
	self.skill_icon:reset(self.spine_data[self.selected_idx])
end

function FetterMainViewLayer:onRight(tag,pSender)
	if self:getActionByTag(10) ~= nil then
		return
	end

	self.selected_idx = math.min(self.max_num, self.selected_idx + 1)
	self:updateHero()

	local level = 999
	for i,v in ipairs(cfg.goddessvip.goddessvip) do
		if v["unlock_goddess_" .. self.spine_data[self.selected_idx]] == 1 then 
			level = v.vip_level
			break
		end
	end

	local str = string.format(ex.Tools:getLang(47330),level)
	self.lbl_vip_tips:setString(str)

	self.lbl_vip_tips:setString(ex.Tools:getLang(3000000 + self.spine_data[self.selected_idx]))
	self.skill_icon:reset(self.spine_data[self.selected_idx])
end

function FetterMainViewLayer:onView(tag,pSender)
	require("src.layer.fetters.FetterPreviewCtr"):instance():openWindow(self.spine_data[self.selected_idx])
end

function FetterMainViewLayer:onShowReward(tag,pSender)

end

function FetterMainViewLayer:onShowSkill(tag, pSender)
	require("src.layer.HeroSkillInfoCtr"):instance():openWindowWithFetter(pSender.fetter_type, pSender.skill_type, 1)
end

function FetterMainViewLayer:addFont()
	local color = cc.c3b(14,0,136)
	self.lbl_level:setString(ex.Tools:getLang(47058))
	self.lbl_level:enableOutline(cc.c3b(185,51,37), 2)
	self.lbl_vip:enableOutline(FONT_BROWN, 1)

	self.lbl_vip_tips = cc.Label:createWithTTF(ex.Tools:getLang(47022), FONT_DEFAULT_NAME_BOLD, 26)
	self.lbl_vip_tips:enableOutline(cc.c3b(146,97,21), 2)
	self.spr_tips:addChild(self.lbl_vip_tips)
	self.lbl_vip_tips:setPosition(self.spr_tips:getContentSize().width / 2,self.spr_tips:getContentSize().height / 2)

	self.lbl_info = cc.Label:createWithTTF(ex.Tools:getLang(47204), FONT_DEFAULT_NAME_BOLD, 24)
	self.lbl_info:enableOutline(color, 1)
	self.btn_info:addChild(self.lbl_info)
	self.lbl_info:setPosition(self.btn_info:getContentSize().width / 2,self.btn_info:getContentSize().height / 2 + 3)

	self.lbl_view = cc.Label:createWithTTF(ex.Tools:getLang(47174), FONT_DEFAULT_NAME_BOLD, 20)
	self.lbl_view:enableOutline(color, 1)
	self.btn_view:addChild(self.lbl_view)
	self.lbl_view:setPosition(self.btn_view:getContentSize().width / 2,self.btn_view:getContentSize().height / 2)

	self.lbl_vipinfo = cc.Label:createWithTTF(ex.Tools:getLang(47319), FONT_DEFAULT_NAME_BOLD, 24)
	self.lbl_vipinfo:enableOutline(color, 1)
	self.btn_vipinfo:addChild(self.lbl_vipinfo)
	self.lbl_vipinfo:setPosition(self.btn_vipinfo:getContentSize().width / 2,self.btn_vipinfo:getContentSize().height / 2)

    local spr_effect = cc.Sprite:create()
    spr_effect:setPosition(self.btn_vipinfo:getContentSize().width * 0.5, self.btn_vipinfo:getContentSize().height * 0.5)
    spr_effect:setScale(1)
    self.btn_vipinfo:addChild(spr_effect, 0, 10)

    local action = cpp.ActionFactory:createLuaAnimate("ccbi-res/fetters-effect-2.plist",
                                                      "fetters-effect-2/2-%d.png", 0.06)
	spr_effect:runAction(cc.RepeatForever:create(action))
end

function FetterMainViewLayer:updateView(data)

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
        local item = require("src.layer.fetters.FetterTaskItem"):createWithCCBIFile("ccbi/FetterTaskItem.ccbi")
        item:setAnchorPoint(0,0)
        item:reset(v)
        -- item.lbl_level:setString(v)
        self.scroll_view:addChild(item)
        item:setPosition(posX, posY)
        self.items[k] = item
        index = index + 1
    end

end

function FetterMainViewLayer:onExit()
	
end


return FetterMainViewLayer