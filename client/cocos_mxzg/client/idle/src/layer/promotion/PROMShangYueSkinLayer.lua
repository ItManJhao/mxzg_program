--[[
    func: 中秋活动-皮肤活动
    author:熊梦
    time:2020-09-24 13:56:46
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local PROMShangYueSkinLayer = class("PROMShangYueSkinLayer", require("src.layer.promotion.PromotionBaseLayer"))


local UIMenuItemBag = require("src.comp.menu.UIMenuItemBag")

function PROMShangYueSkinLayer:onCreateDone()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	self:initDone()
	self:registerEvent()
end

function PROMShangYueSkinLayer:initDone()

	self.promotion_id = 76

	self.spr_bg2:setScaleX(ex.p.width / self.spr_bg2:getContentSize().width)
	self.spr_tiao:setScaleX(2)

	self.menu_occlusion:setScaleX(ex.p.width / self.spr_bg2:getContentSize().width)

	self.menu_show:setScaleX(ex.p.width / self.spr_tiao:getContentSize().width)

	self.spr_skin:setScaleX(ex.p.width / self.spr_tiao:getContentSize().width)
	
	self.node_bg:setPosition(0, self.layer_promotion:getTopY()-155)


	for i=1,4 do
		self["spr_guang_"..i]:setScaleX(ex.p.width / self.spr_bg2:getContentSize().width)
		self["btn_show_"..i]:setContentSize(self["btn_occlusion_"..i]:getContentSize())
		self["btn_show_"..i]:setPosition(self["btn_occlusion_"..i]:getPosition())
	end

	self.lbl_time = cpp.RichTextEx:createWithXMLLua("")
	self.lbl_time:setFontSize(36)
	self.lbl_time:setScale(0.5)
	self.lbl_time:setFontFace(FONT_DEFAULT_NAME_BOLD)
	self.lbl_time:setFontColor("#ffffff")
	self.lbl_time:setAnchorTextShadow(false)
	self.lbl_time:setAnchorPoint(ex.a.center)
    self.lbl_time:setPosition(ex.Tools:getAbsolutePosition(cc.p(80, 0), CommonUIDefine.UIDefine.ComponentOriginType.LEFT_BOTTOM, self.time_node))
    self.lbl_time:setLocalZOrder(10)
	self.time_node:addChild(self.lbl_time)

	self.time_info = ex.Player.promotion_data:getPromotionDatas(self.promotion_id)

	self:updateCDTime()

	self:addTimer("colorful_timer", 1000, handler(self, self.updateCDTime), true)

	-- 每个阶段的需要的皮肤碎片的数量
	self.stage_num = {}

	self:createProgress()
	self:UpdataSkinMenu()

	self:addRedDotNode(RedDotType.ZCJ_DHZC_ZQHD_PFHD_PFDH, self.btn_submit)

	--ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZQHD_PFHD_PFDH,true)
end

function PROMShangYueSkinLayer:registerEvent()
    self:addEvent(EVENT.APPRECIATE_SKIN.EVENT_UPDATA,handler(self,self.UpdataSkinMenu))
end


function PROMShangYueSkinLayer:updateCDTime()
	local remain_time = self.time_info.end_time - ex.Game:getServerTime()

	if ex.Game:getServerTime()  <  self.time_info.start_time then 
		self.lbl_time:setXmlTextLua(ex.Tools:getLang(41052));
		return 
	end 

	if remain_time < 0 then 
		self.lbl_time:setXmlTextLua(ex.Tools:getLang(41053));

		self:removeTimerByName("colorful_timer")
		return
	end

	if remain_time > 86400 then
		local remainder = math.fmod( remain_time, 86400)
        self.lbl_time:setXmlTextLua(string.format(ex.Tools:getLang(3906),
			math.floor(remain_time / 86400),
			math.floor(remainder / 3600),
			math.floor(remainder / 60 % 60)))
    else
        self.lbl_time:setXmlTextLua(string.format(ex.Tools:getLang(41129), 
            math.floor(remain_time / 3600),
            math.floor(remain_time / 60 % 60),
            math.floor(remain_time % 60)))
    end
end


function PROMShangYueSkinLayer:createProgress()
    self.progressTimer = require("src.comp.UIProgressTimerEquidistant"):create(cc.Sprite:createWithSpriteFrameName("prom-dragonboat/spr-jdt2.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setScaleX(1)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.spr_progress_bg:addChild(self.progressTimer)
    self.progressTimer:setPosition(self.spr_progress_bg:getContentSize().width / 2 ,self.spr_progress_bg:getContentSize().height / 2 )
end


function PROMShangYueSkinLayer:UpdataSkinMenu()
	local is_show = {true,true,true,true}
	if ex.Player.promotion_data.promotion76_skin_info ~= nil then
		for k,v in pairs(ex.Player.promotion_data.promotion76_skin_info) do
			is_show[v] = false
		end
	end

	for i=1,4 do
		self["lbl_item_num_"..i]:setVisible(true)
		self["btn_show_"..i]:setVisible(false)
		self["btn_occlusion_"..i]:setVisible(true)
	end

	local need_item = cfg.promotionskindatainfo.promotionskindatainfo[1].need_item[1]
	local num = ex.Player:getItemNum(need_item.item_type)
	local max_num = need_item.item_num

	for i=1,4 do
		local need_item = cfg.promotion076fashioncountreward.promotion076fashioncountreward[i].need_item[1]
		self.stage_num[i] = need_item.item_num
		self["lbl_item_num_"..i]:setString(string.format( ex.Tools:getLang(91527),need_item.item_num))
		if num >= need_item.item_num then
			self["lbl_item_num_"..i]:setVisible(false)
			self["btn_occlusion_"..i]:setVisible(false)
			if is_show[i] then
				self["spr_guang_"..i]:setVisible(true)
				self["btn_show_"..i]:setVisible(true)
			else
				self["spr_guang_"..i]:setVisible(false)
			end
		end
	end
	
	local percent = num / max_num * 100
    if percent > 100 then percent = 100 end
	self.progressTimer:setPercentage(percent)

	self.lbl_skin_num:setString(ex.Tools:getLang(91528)..num.."/"..max_num)
end

function PROMShangYueSkinLayer:onRewardPreview(tag, pSender)
    local table_data={}
    local max_weight = 0
	local reward = {}
	for i,v in ipairs(cfg.promotionskindatainfo.promotionskindatainfo) do
		if not whole_skin and v.type == 2 then
			
		else
			local rewardTemp = v.reward[1] 
			rewardTemp.idx = v.idx
			rewardTemp.is_owned = false
			for k,n in pairs(ex.Player.promotion_data.promotion76_forever_active) do
				if n == v.idx then
					rewardTemp.is_owned = true
					break
				end
			end
			table.insert(reward,rewardTemp)
		end
	end

    require("src.layer.PROMShangYueSkinPreviewCtr"):instance():openWindow(reward)
end

function PROMShangYueSkinLayer:onInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42090), ex.Tools:getLang(91536))
end


-- 查看阶段奖励
function PROMShangYueSkinLayer:onOcclusion(tag, pSender)
	print("==============查看阶段奖励=============",tag)
	local reward = cfg.promotion076fashioncountreward.promotion076fashioncountreward[tag].reward
	require("src.layer.ItemExhibitionCtr"):instance():openWindow(reward, nil)
end

-- 领取阶段奖励
function PROMShangYueSkinLayer:onShow(tag, pSender)
	local need_item = cfg.promotionskindatainfo.promotionskindatainfo[1].need_item[1]
	local num = ex.Player:getItemNum(need_item.item_type)
	if num >= self.stage_num[tag] then
		local req = Promotion076_pb.GReqMidFashionGetFashionCount()
		req.idx = tag
		NetManager:sendMessage(ProtocolID.GReqMidFashionGetFashionCount, req)
	else
		ex.MessageView:add(ex.Tools:getLang(91532))
	end
end

-- 兑换皮肤
function PROMShangYueSkinLayer:onExchange(tag, pSender)
	print("==========兑换回调==========")
	local need_item = cfg.promotionskindatainfo.promotionskindatainfo[1].need_item[1]
	local num = ex.Player:getItemNum(need_item.item_type)
	local max_num = need_item.item_num

	if num < max_num then
		ex.MessageView:add(ex.Tools:getLang(91532))
		return
	end

	if ex.Player.promotion_data.promotion76_skin_info ~= nil then
		if #ex.Player.promotion_data.promotion76_skin_info < 4 then
			ex.MessageView:add(ex.Tools:getLang(91535))
			return
		end
	end


	
	-- 计算皮肤是否全部拥有
	local whole_skin = false
	if #ex.Player.promotion_data.promotion76_forever_active >= #cfg.promotionskindatainfo.promotionskindatainfo-1 then
		whole_skin = true
	end

	
	local reward = {}
	for i,v in ipairs(cfg.promotionskindatainfo.promotionskindatainfo) do
		if not whole_skin and v.type == 2 then
			
		else
			local rewardTemp = v.reward[1] 
			rewardTemp.idx = v.idx
			rewardTemp.is_owned = false
			for k,n in pairs(ex.Player.promotion_data.promotion76_forever_active) do
				if n == v.idx then
					rewardTemp.is_owned = true
					break
				end
			end
			table.insert(reward,rewardTemp)
		end
	end
	-- 已经拥有的皮肤列表
	local skin_list = ex.Player.promotion_data.promotion76_forever_active

	require("src.layer.SkinSelectGiftCtr"):instance():openWindow(reward)

end



return PROMShangYueSkinLayer