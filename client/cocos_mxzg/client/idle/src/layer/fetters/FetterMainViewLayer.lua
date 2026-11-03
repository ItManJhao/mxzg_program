local FetterMainViewLayer = class("FetterMainViewLayer",require("src.comp.EventLayer"))
local MAX_LEVEL = ex.Player.fetter_data.vip:getMaxVip()

function FetterMainViewLayer:onCreate()
    self:setAutoClose(false) 
	self:setSwallowTouches(false)
	self.scroll_size = cc.size(478,555)
	self.spr_skill_icon:setScale(1.2)
	-- self.btn_right:setScaleX(-1)
	self.btn_right:getNormalImage():setFlippedX(true)
	self.spine_data = clone(ex.Player.fetter_data.vec_idx)
	local function sor(a,b)
		return a < b 
	end
	table.sort(self.spine_data,sor)
	-- 选择的羁绊类型
	self.selected_idx = self.spine_data[1]
	self.cur_level = ex.Player.fetter_data.vip:getVIP()
	-- self.select_level = self.cur_level == MAX_LEVEL and self.cur_level or self.cur_level + 1

	-- 羁绊动画类型
	self.hero_idx = -1

	-- cell 类型
	self.cur_layer_type = 0

	-- 当前spine精灵
	self.sp_fetter = nil

	self.btn_left:setTag(-1)
	self.btn_right:setTag(1)


	self.btn_left:setPositionX(-ex.p.width * 0.5 + 70)
	self.btn_right:setPositionX(ex.p.width * 0.5 - 70)
	self.btn_vip_info:setPositionX(ex.p.width * 0.5 - 80)


	local viewsize = cc.Director:getInstance():getWinSize()
	local size = self.spr_bg:getContentSize()
	self.cfg_data = ex.Player.fetter_data.vip:getVIPCfg()
	self.spr_bg:setScale(viewsize.width / size.width , viewsize.height / size.height)
	self.viewSize = cc.size(560,245)

	-- self.lbl_vip:setString(string.format("VIP %s",ex.Player.fetter_data.vip:getVIP()))
	-- self:createClippingNode()
	self:setVIPInfoBtn()
	self:addFont()

	self:createProgress()

	-- self.node:setLocalZOrder(1)

	local notch_height = require("src.model.Game"):instance():getNotchHeight()
    self.node:setPositionY(self.node:getPositionY() - notch_height * 0.5)
	self.node:setLocalZOrder(1)

	

	local function sor (a,b)
		return a.idx < b.idx
	end

	table.sort(self.cfg_data,sor)


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
	-- ex.Tools:setSpriteFrame(self.spr_vip_content, str)
	self.spr_vip_content:setScale(0.8)

	self:updateView(self.cfg_data)
	self:upCurLevelSpr()

	-- self:createText()
	self:registerBtnEvent()
	
	self:updateHero()
	self:setDirVisible(1)
	self:addEvent(EVENT.FETTER_EVENT.VIP_UPDATE,handler(self,self.updateLevel))
	self:addEvent(EVENT.FETTER_EVENT.VIP_REWARD,handler(self,self.updateReward))
end

function FetterMainViewLayer:setVIPInfoBtn( )
	local lbl_info = cc.Label:createWithTTF("123123123", FONT_DEFAULT_NAME_BOLD,18)
	lbl_info:setColor(cc.c3b(255,216,60))
	lbl_info:enableOutline(cc.c3b(89,42,20),2)
	self.btn_vip_info:addChild(lbl_info)
	lbl_info:setPosition(self.btn_vip_info:getContentSize().width/2,-15)
	self.btn_vip_info.lbl = lbl_info

	local spr_bg = cc.Sprite:createWithSpriteFrameName("fetters/spr-new.png")
	self.btn_vip_info:addChild(spr_bg)
	spr_bg:setPosition(self.btn_vip_info:getContentSize().width * 0.82,self.btn_vip_info:getContentSize().height +5)
	self.btn_vip_info.new = spr_bg

	self.btn_vip_info:registerScriptTapHandler(handler(self,self.onClickVIPInfo))
end

function FetterMainViewLayer:onClickVIPInfo(tag,pSender)
	require("src.layer.fetters.FetterVipInfoCtr"):instance():openWindow()
end

function FetterMainViewLayer:upCurLevelSpr( )
	local tmp_vip = ex.Player.fetter_data.vip:getVIP()
	if tmp_vip >= 10 then
		self.level_num_task_2:setVisible(true)
		local tmp_num_ten = math.floor(tmp_vip / 10)
		local str_1 = string.format("fetters/%s.png", tmp_num_ten)
		ex.Tools:setSpriteFrame(self.level_num_task_1, str_1)
		local str_2 = string.format("fetters/%s.png", tmp_vip - tmp_num_ten * 10)
		ex.Tools:setSpriteFrame(self.level_num_task_2, str_2)
	else
		self.level_num_task_2:setVisible(false)
		local str = string.format("fetters/%s.png", tmp_vip)
		ex.Tools:setSpriteFrame(self.level_num_task_1, str)
	end

	self.btn_vip_info.lbl:setString(ex.Tools:getLang(cfg.goddessvip.goddessvip[tmp_vip].announce_lang))
	self.btn_vip_info.new:setVisible(cfg.goddessvip.goddessvip[tmp_vip].announce_lang ~= "")
end

function FetterMainViewLayer:createText()

	if self.text_layer then 
		self.text_layer:removeFromParent()
		self.text_layer = nil
	end

	self.text_layer = self:createTextLayer(self.select_level)
	local win_size = clone(self.scroll_size)
	local height = math.max( win_size.height,self.text_layer:getContentSize().height )
	win_size.height = height

	self.scroll_view1:setContentSize(win_size)
	self.scroll_view1:addChild(self.text_layer)
	self.text_layer:setPosition(0,win_size.height - self.text_layer:getContentSize().height)

	self:showBtn()
end

function FetterMainViewLayer:createClippingNode( )
	local size = self.spr_bg1:getContentSize()
	self.stencil = cc.LayerColor:create(cc.c3b(220, 0, 0))
	self.stencil:setContentSize(size)
	self.stencil:setIgnoreAnchorPointForPosition(false)
	self.stencil:setAnchorPoint(cc.p(0, 0))
	self.clipping_node = cc.ClippingNode:create(self.stencil)
	self.spr_bg1:addChild(self.clipping_node)
end

function FetterMainViewLayer:getLevelText(level)
	self.is_next_level = level == self.cur_level + 1
	local select_cfg = cfg.goddessvip.goddessvip[level]
	local cur_cfg = cfg.goddessvip.goddessvip[self.cur_level]
	local unlock = {}
	local ratio = {}
	local is_new = {}
	for k,v in pairs(select_cfg) do
		if k ~= "vip_level" then 
			-- if self.is_next_level == true then 
				local cur = cur_cfg[k]
				if cur == 0 and v ~= 0 then 
					is_new[k] = true
				end
			-- end
			if v > 0 then 
				local type = cfg.goddessviptext.text[k].type
				if type == 1 then 
					table.insert(unlock,k)
				else
					table.insert(ratio,k)
				end
			end

		end 
	end

	local function sor(a,b)
		local idxA = cfg.goddessviptext.text[a].index
		local idxB = cfg.goddessviptext.text[b].index
		return idxA < idxB
	end 
	table.sort( ratio,sor )
	table.sort( unlock,sor )

	local text_data = {}
	text_data.unlock = unlock 
	text_data.ratio = ratio 
	text_data.is_new = is_new
	return text_data
end

function FetterMainViewLayer:createTextLayer(level)
	local layer = cc.Layer:create()

	local margin = 10

	local text_data = self:getLevelText(level)

	local spr = cc.Sprite:createWithSpriteFrameName("fetters/spr-vip-dot.png")
	local spr_line = cc.Sprite:createWithSpriteFrameName("fetters/spr-line.png")
	local offset = 5

	local total_height = 0
	for i,v in ipairs(text_data.unlock) do
		total_height = total_height + (spr:getContentSize().height + margin)
	end

	for i,v in ipairs(text_data.ratio) do
		total_height = total_height + (spr:getContentSize().height + margin)
	end
	total_height = total_height + (spr:getContentSize().height + margin) + offset
	local layer_size = cc.size(self.scroll_size.width,total_height)
	layer:setContentSize(layer_size)

	local posY = total_height - spr:getContentSize().height
	-- local height = self.spr_title:getContentSize().height / 2
	local startY = posY 
	-- local margin = 10
	local idx = 0

	for i,v in ipairs(text_data.unlock) do
		local str = self:formatText(v)
		posY = startY - idx * (spr:getContentSize().height + margin)
		local is_new =  text_data.is_new[v] == true
		self:createRichText(layer,str,posY,is_new)
		idx = idx + 1
	end

	local line_height = spr_line:getContentSize().height 
	spr_line:setPosition(layer:getContentSize().width / 2,posY - (spr:getContentSize().height + margin)/2)

	layer:addChild(spr_line)
	
	
	posY = posY - (spr:getContentSize().height + margin) - offset

	for i,v in ipairs(text_data.ratio) do
		local str = self:formatText(v)
		posY = startY - idx * (spr:getContentSize().height + margin)
		local is_new =  text_data.is_new[v] == true
		self:createRichText(layer,str,posY,is_new)
		idx = idx + 1
	end
	
	return layer
end

function FetterMainViewLayer:createRichText(parent,str,posY,is_new)
	local spr = cc.Sprite:createWithSpriteFrameName("fetters/spr-vip-dot.png")
	spr:setAnchorPoint(0, 0.5)
	parent:addChild(spr)

	local lbl = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(22)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#996a0d")
	:setAnchorPoint(0, 0.5)
	:setXmlTextLua(str)
	:formatText()
	parent:addChild(lbl)
	lbl:setPosition(85,posY)
	spr:setPosition(50,posY)
	if is_new == true then  
		local spr_new = cc.Sprite:createWithSpriteFrameName("fetters/spr-new.png")
		spr_new:setAnchorPoint(0, 0.5)
		parent:addChild(spr_new)
		spr_new:setPosition(lbl:getPositionX() + lbl:getContentSize().width + 10,posY)
	end
end

function FetterMainViewLayer:showBtn( )
	self.btn_left:setVisible(self.select_level > 1)
	self.btn_right:setVisible(self.select_level < MAX_LEVEL)
end

function FetterMainViewLayer:changeTitle()
	self.spr_vip_content:setSpriteFrame(string.format("fetters-lang/fetter-%s.png",self.selected_idx))
	self.spr_vip_content:setScale(0.8)

	local tmp_vip = cfg.goddessunlock.goddessunlock[self.selected_idx].vip_level
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
end

-- 创建移动动画
function FetterMainViewLayer:updateTextLayer(tag)
	if self.text_layer:getActionByTag(10) ~= nil then
		return
	end

	self.select_level = self.select_level + tag

	local view_size = self.scroll_view1:getViewSize()
	local text_layer = self:createTextLayer(self.select_level)
	local content_size = clone(self.scroll_size)
	local height = math.max(content_size.height, text_layer:getContentSize().height )
	content_size.height = height
	-- self.scroll_view1:setContentSize(content_size)
	self.scroll_view1:addChild(text_layer)

	local posX = 0
	if tag > 0 then 
		posX = -(content_size.width + 100)
	else
		posX = (content_size.width + 100)
	end

	text_layer:setPosition(posX, self.scroll_view1:getContentSize().height - text_layer:getContentSize().height)
	local atc_move_end = cc.CallFunc:create(function()
		self.text_layer = text_layer
		self.scroll_view1:setContentSize(cc.size(content_size.width, math.max(view_size.height, text_layer:getContentSize().height)))
		self.scroll_view1:setContentOffset(cc.p(self.scroll_view1:getContentOffset().x, view_size.height - self.scroll_view1:getContentSize().height))
		text_layer:setPositionY(self.scroll_view1:getContentSize().height - text_layer:getContentSize().height)
	end)
	text_layer:runAction(cc.EaseExponentialOut:create(cc.MoveTo:create(0.5, cc.p(0, text_layer:getPositionY()))))


	-- 当前的动画退出
	if self.text_layer then
		local posX = 0
		if tag > 0 then 
			posX = (content_size.width + 100)
		else
			posX = -(text_layer:getContentSize().width + 100)
		end
		-- local act_move = cc.EaseExponentialOut:create(cc.MoveBy:create(0.5, cc.p(content_size.width, 0)))
		local act_move = cc.EaseExponentialOut:create(cc.MoveBy:create(0.5, cc.p(posX, 0)))
		local act_seq = cc.Sequence:create(act_move, atc_move_end, cc.RemoveSelf:create())
		act_seq:setTag(10)
		self.text_layer:runAction(act_seq)
	end


	self:showBtn()
	-- self:changeTitle()
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
	self.lbl_vip:setString(string.format( "%s/%s",num,total ))
end

function FetterMainViewLayer:updateReward(event,data)
	for k,v in pairs(self.cfg_data) do
		self.items[k]:reset(v)
	end
	self:updateProgress()
end

function FetterMainViewLayer:updateLevel(event,data)
	self.cur_level = ex.Player.fetter_data.vip:getVIP()
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
	self.spr_vip_content:setScale(0.8)
	self.lbl_vip:setString(string.format("VIP %s", tmp_vip - 1))
	self:updateProgress()

	self:upCurLevelSpr()

	-- self:createText()
end

function FetterMainViewLayer:showRewardIcon(data)
	if data == nil then 
		self.reward_icon:setVisible(false)
		return 
	end
	self.reward_icon:reset(data)
end

function FetterMainViewLayer:formatText(v)

	local str_idx = cfg.goddessviptext.text[v].text
	local str = ex.Tools:getLang(str_idx)
	if cfg.goddessviptext.text[v].type == 2 then 
		local conf = cfg.goddessvip.goddessvip[self.select_level]
		str = string.format( str,conf[v] )
	elseif cfg.goddessviptext.text[v].type == 3 then 
		local conf = cfg.goddessvip.goddessvip[self.select_level]
		local hour = conf[v] / 3600
		str = string.format( str,hour )
	end

	return str
end


function FetterMainViewLayer:registerBtnEvent()
	self.btn_vipinfo:registerScriptTapHandler(handler(self, self.onVipInfo))
	self.btn_info:registerScriptTapHandler(handler(self, self.onInfo))
	self.btn_left:registerScriptTapHandler(handler(self, self.onLeft))
	self.btn_right:registerScriptTapHandler(handler(self, self.onRight))
	self.btn_view:registerScriptTapHandler(handler(self, self.onView))
end

function FetterMainViewLayer:onVipInfo(tag,pSender)
	require("src.layer.fetters.FetterVipInfoCtr"):instance():openWindow()
end

function FetterMainViewLayer:onInfo(tag,pSender)
	ex.MainSceneCtr:changeLayer(MainSceneType.DRAGON_VIEW)
end

function FetterMainViewLayer:onLeft(tag,pSender)
	if self:getActionByTag(10) ~= nil then
		return
	end
	local idx = 1
	for i,v in ipairs(self.spine_data) do
		if v == self.selected_idx then 
			idx = i 
			break
		end
	end
	local spine = self.spine_data[idx - 1]
	if not spine then return end 
	self.selected_idx = self.spine_data[idx - 1]
	self:updateHero()
	self:setDirVisible(idx - 1)
	-- self:updateTextLayer(tag)
end

function FetterMainViewLayer:onRight(tag,pSender)
	if self:getActionByTag(10) ~= nil then
		return
	end
	local idx = 1
	for i,v in ipairs(self.spine_data) do
		if v == self.selected_idx then 
			idx = i 
			break
		end
	end
	local spine = self.spine_data[idx + 1]
	if not spine then return end 
	self.selected_idx = self.spine_data[idx + 1]
	self:updateHero()
	self:setDirVisible(idx + 1)
	-- self:updateTextLayer(tag)
end

function FetterMainViewLayer:setDirVisible(idx)
	self.btn_left:setVisible(idx ~= 1)
	self.btn_right:setVisible(idx ~= table.nums(self.spine_data))
end

function FetterMainViewLayer:onView(tag,pSender)
	-- require("src.layer.fetters.FetterPreviewCtr"):instance():openWindow(self.spine_data[self.selected_idx])
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
	self.lbl_progress:enableOutline(cc.c3b(81,46,28), 2)

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

    local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_fetters_btn_2")
    spr_effect:setPosition(self.btn_vipinfo:getContentSize().width * 0.5, self.btn_vipinfo:getContentSize().height * 0.5)
    spr_effect:setScale(1)
    self.btn_vipinfo:addChild(spr_effect, 0, 10)
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
		str_spine = tostring(self.spine_data[1])
	else
		str_spine = tostring(self.selected_idx)
	end
	print(self.selected_idx,">>>>???")
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
		spine:setPosition(cc.p(ex.p.width * 0.5 + ex.p.width * diff * 1.5 / 100, default_height))
		spine:runAction(cc.EaseExponentialOut:create(cc.MoveTo:create(0.5,
													 cc.p(ex.p.width * 0.5, default_height))))

		local act_tag = cc.DelayTime:create(0.5)
		act_tag:setTag(10)
		self:runAction(act_tag)
	end

	-- 当前的动画退出
	if self.sp_fetter then
		self.sp_fetter:runAction(cc.EaseExponentialOut:create(cc.MoveTo:create(0.5, cc.p(ex.p.width * 0.5 + ex.p.width * -1 * diff * 1.5 / 100,
		 																				 default_height))))

		self.sp_fetter:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.RemoveSelf:create()))
	end
	self.sp_fetter = spine

	self.hero_idx = self.selected_idx
	self:upSkillInfo()
	self:changeTitle()
end

function FetterMainViewLayer:upSkillInfo( )
	local skill_type = ex.Player.fetter_data:getSkillType(self.selected_idx)
	ex.Tools:setSpriteFrame(self.spr_skill_desc, string.format("fetters-lang/spr-skill-%d.png", self.selected_idx))
	ex.Tools:setSpriteFrame(self.spr_skill_icon, string.format("fetters/skill/%d.png", skill_type))
end

function FetterMainViewLayer:onExit()
	
end


return FetterMainViewLayer