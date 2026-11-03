local RewardLayer = class("RewardLayer", require("src.comp.EventLayer"))

local RewardCell = class("RewardCell", require("src.comp.EventLayer"))

local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

function RewardCell:onCreate()
	--print("RewardCell:onCreate")
	self:setAutoClose(false)
	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/summon-effect.plist")
	sfc:addSpriteFrames("ccbi-res/reward-effect.plist")


	self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)

	self.btn_confirm:setLabelText(ex.Tools:getLang(11)) -- 确定
	self.btn_confirm:setLabelColor(ex.c3b.WHITE)
	self.btn_confirm:setName("summon_confirm")


	self.btn_share:setLabelText(ex.Tools:getLang(47361)) -- 确定
	self.btn_share:setLabelColor(ex.c3b.WHITE)
end

-----------------------------------------------------------------------------

--[[
显示奖品
@award_type	奖品类型 1招募(英雄) 2领取(英雄) 3直接显示(非抽奖获得)
@awardList	奖品列表[{hero_type}]
@is_jump	跳转礼包购买
]]--
function RewardLayer:createAward(award_type, awardList, is_jump, callback, flag)
	local pRet = RewardLayer:create()
	if pRet then
		pRet:addBlackBackground()

		pRet:initAward(award_type, awardList, is_jump, callback, flag)
		return pRet
	end
	pRet = nil
	return nil
end

function RewardLayer:initAward(award_type, awardList, is_jump, callback, flag)
	self.is_jump = is_jump
	self.callback = callback

	local awardCount = #awardList
	if type(awardList) ~= "table" or awardCount == 0 then
		self:onCallback()
		return
	end

	self.awardCount = awardCount
	self.award_type = award_type
	self.awardList = awardList
	self.flag = flag

	--设置当前吞噬
	local listener = cc.EventListenerTouchOneByOne:create()
	listener:setSwallowTouches(true)
	listener:registerScriptHandler(function(touch, event)
		return true
	end, cc.Handler.EVENT_TOUCH_BEGAN)
	self:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self)


	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/skill-icon.plist")
    -- sfc:addSpriteFrames("ccbi-res/pub-effect-10.plist")
    sfc:addSpriteFrames("ccbi-res/summon-big-effect.plist")
	sfc:addSpriteFrames("ccbi-res/reward-layer.plist")
	sfc:addSpriteFrames("ccbi-res/reward-layer-lang.plist")
	sfc:addSpriteFrames("ccbi-res/reward-effect.plist")
	sfc:addSpriteFrames("ccbi-res/reward-effect2.plist")
	
	-- local fullpath = cc.FileUtils:getInstance():fullPathForFilename("ccbi-res/pub-effect-10.plist")
    --招募 有特效
    if self.award_type == 1 then
    	local spr_action = cc.Sprite:create()
		spr_action:setPosition(cc.p(0, 0))		
		self:addChild(spr_action)

		-- 点击时跳过动画
		local listener_touch = cc.EventListenerTouchOneByOne:create()  --创建一个单点事件监听
		listener_touch:setSwallowTouches(true)
		listener_touch:registerScriptHandler(function(touch, event)
			return true
		end, cc.Handler.EVENT_TOUCH_BEGAN)

		listener_touch:registerScriptHandler(function()
		end, cc.Handler.EVENT_TOUCH_MOVED)

		listener_touch:registerScriptHandler(function(touch, event)
			spr_action:stopAllActions()
			self:initDone()
			spr_action:removeFromParent()
		end, cc.Handler.EVENT_TOUCH_ENDED)

		local event_dispatcher = spr_action:getEventDispatcher() 
		event_dispatcher:addEventListenerWithSceneGraphPriority(listener_touch, spr_action)


		local spr_bg = cc.Sprite:create("ccbi-res/map-bg-summon-1.jpg")
		local scale_x = ex.p.width / spr_bg:getContentSize().width
		local scale_y = ex.p.height / spr_bg:getContentSize().height
		spr_bg:setScale(scale_x > scale_y and scale_x or scale_y)
		spr_bg:setPosition(cc.p(ex.p.width * 0.5, ex.p.height * 0.5))
		spr_action:addChild(spr_bg)



		local bsSpine = sp.SkeletonAnimation:create("spine/lizi.json","spine/lizi.atlas", 1)
		bsSpine:setAnimation(0, "stand", false)
		bsSpine:setPosition(ex.p.width * 0.5, 0)
		spr_action:addChild(bsSpine, 0, 10)


		local bsSpine = sp.SkeletonAnimation:create("spine/shangcheng.json","spine/shangcheng.atlas", 1)
		bsSpine:setAnimation(0, "act2", false)
		bsSpine:setPosition(ex.p.width * 0.5, 0)
		spr_action:addChild(bsSpine, 0, 10)

		bsSpine:registerSpineEventHandler(function (event)
			if event.animation == "act2" then
				
			end
		end, sp.EventType.ANIMATION_COMPLETE)

		spr_action:runAction(cc.Sequence:create(cc.DelayTime:create(3), cc.CallFunc:create(handler(self, self.initDone)), cc.RemoveSelf:create()))
		ex.AudioManager:playEffect("music/summon-anime.mp3")
    else
    	--领取 无特效
    	self:initDone()
    end
    
end

function RewardLayer:initDone()
	self.spr_bg = cc.Sprite:create("ccbi-res/map-bg-summon-1.jpg")
	local scale_x = ex.p.width / self.spr_bg:getContentSize().width
	local scale_y = ex.p.height / self.spr_bg:getContentSize().height
	self.spr_bg:setScale(scale_x > scale_y and scale_x or scale_y)
	self.spr_bg:setPosition(ex.p.center())
	-- self.spr_bg:setCascadeOpacityEnabled(true)
	self:addChild(self.spr_bg)

    -- 播放彩带爆炸
    self.spr_effect_bomb = ex.EffectFactory:createEffectWithNodeByName("eff_reward_bomb")
    self.spr_effect_bomb:setPosition(self:getContentSize().width / 2, self:getContentSize().height + 100)
    self:addChild(self.spr_effect_bomb, 100)
	-- self:addChild(cc.LayerColor:create(FONT_LIGHT_GRAY_C4B, ex.p.width, ex.p.height))
	
	--cell
	self:initCell()

	if self.award_type > 2 then
		self:orderShow()
	else
		-- 抽奖渠道
		self:updateView()
	end

	self:addEvent(EVENT.SUMMON.CLOSE_CELL, handler(self, self.onClose))
end


function RewardLayer:initCell()
    local cell = RewardCell:createWithCCBIFile("ccbi/RewardCell.ccbi")
	cell:setSwallowTouches(false)
	cell:setIgnoreAnchorPointForPosition(false)
	cell:setAnchorPoint(ex.a.center)
    cell:setPosition(ex.p.center().x, ex.p.center().y - cell:getContentSize().height * 0.5)
    self:addChild(cell)

    local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_reward")
    spr_effect:setPosition(cell.spr_title:getPositionX() - 4, cell.spr_title:getPositionY() - 10)
    cell:addChild(spr_effect, 20, 100)

    if self.award_type == 1 then
    	local cell_item = cfg.lotterypoint.summon[ex.Player.summon_data.last_summon_type].need_item[1]

    	local need_type = cell_item.item_type
    	local need_num = cell_item.item_num
    	local hasNum = ex.Player:getItemNum(need_type)

    	if hasNum < need_num then
	        -- 高级券不够时候 用钻石
			if hasNum > 0  then 
				--need_num = hasNum
			else 
				if need_type == ItemType.IT_TICKET_HIGH then 
					need_num = tonumber(ex.ShopSeniorTicketTable:getConfig(need_num).need_gem)
				elseif need_type == ItemType.IT_MAGIC_BUTTER_TICKET then 
					need_num = cfg.system.nha_summon_10_fixed_prize[1].item_num * self.awardCount
				end
				need_type =  ItemType.IT_GEM
				-- need_num = tonumber(ex.ShopSeniorTicketTable:getConfig(need_num).need_gem)
			end
    	end
    	
    	-- 再次招募
    	local btn_size = cc.Sprite:createWithSpriteFrameName("button/btn-buy-1.png"):getContentSize()
		btn_size.width = btn_size.width / 2
		btn_size.height = btn_size.height / 2

		local str_txt = ex.Tools:getLang(1110)
		if (self.awardCount > 1) then
			str_txt = ex.Tools:getLang(1111)
		end

   		local lbl_btn_txt = cc.Label:createWithTTF(str_txt, FONT_DEFAULT_NAME_BOLD, 26)
		:enableOutline(FONT_BROWN, 2)
		:setPosition(btn_size.width, btn_size.height )
		cell.btn_again:addChild(lbl_btn_txt)


		-- local spr_icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", need_type))
		-- :setScale(0.4)
		-- :setPosition(btn_size.width - 50, btn_size.height + 60)
		-- cell.btn_again:addChild(spr_icon)

		-- local lbl_btn_num = cc.Label:createWithTTF(tostring(need_num), FONT_DEFAULT_NAME_BOLD, 60)
		-- :setScale(0.5)
		-- :setTextColor(FONT_WHITLE)
		-- :setPosition(btn_size.width, btn_size.height + 60)
		-- cell.btn_again:addChild(lbl_btn_num)


		local lbl_btn_refresh = require("src.comp.RichTextEx"):create()
		:setFontSize(30)
		:setFontFace(FONT_DEFAULT_NAME_BOLD)
		:setAnchorTextShadow(true)
		:setWrapMode(1)
	
		cell.btn_again:addChild(lbl_btn_refresh)
		lbl_btn_refresh:setPosition(btn_size.width, btn_size.height + 60)

		if need_type == ItemType.IT_GEM then hasNum = ex.Player.gem end 
        local  str = string.format("<img src='backpack/%s.png' width='40' height='40' /><font color='#ffffff'>%s / %s</font>",need_type,hasNum, need_num)
        if hasNum < need_num then 
            str = string.format("<img src='backpack/%s.png' width='40' height='40' /><font color='#FF0000'>%s</font><font color='#ffffff'>/%s</font>",need_type,hasNum, need_num)
        end 

        lbl_btn_refresh:setXmlTextLua(str)


		cell.btn_again:registerScriptTapHandler(handler(self, self.onSummonAgain))


		cell.btn_share:setVisible(false)

		ex.EffectCtr:playNormalEff(26, cell.btn_again:getContentSize().width * 0.5, cell.btn_again:getContentSize().height * 0.5 + 0, nil, cell.btn_again, 10)


		cell.btn_confirm:setPositionX(206)
		cell.btn_again:setPositionX(437)

	else

		cell.btn_share:setVisible(true)
		cell.btn_share:registerScriptTapHandler(handler(self, self.onBtnShare))

		cell.btn_again:setVisible(false)
		--cell.btn_confirm:setPositionX((cell.btn_again:getPositionX() + cell.btn_confirm:getPositionX()) / 2)
	
	
	end
    
	cell.btn_confirm:registerScriptTapHandler(handler(self, self.onClose))

	cell.btn_confirm:getParent():setLocalZOrder(100)

	self.viewSize = cc.size(ex.p.width, cell:getContentSize().height) 
	
    self.award_node = cc.Node:create()
    :setPosition(0, cell:getPositionY() - self.viewSize.height / 2)
    self:addChild(self.award_node)

	self.lbl_btn_refresh = require("src.comp.RichTextEx"):create()
	:setFontSize(38)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setAnchorTextShadow(true)
    :setWrapMode(1)

	cell.spr_name_bg:addChild(self.lbl_btn_refresh)

	self.lbl_btn_refresh:setPosition(cell.spr_name_bg:getContentSize().width * 0.5 ,cell.spr_name_bg:getContentSize().height * 0.5 - 3)


    self.node_cell = cell
end

function RewardLayer:onBtnShare( tag, pSender)
	local pos = {}
	local x,y = pSender:getPosition()
	-- pos.x = x - pSender:getContentSize().width / 2
	-- pos.y = y - pSender:getContentSize().height / 2

	pos.x = x + pSender:getContentSize().width / 2
	pos.y = y + pSender:getContentSize().height / 2 + 48

	local ctr = require("src.layer.heroinfo.HeroShareMenuCtr"):instance()--:openWindow(pos)
	local callback = handler(self,self.onShareMenuClick)
	ctr:openWindow(callback)
	ctr.layer:setLocalZOrder(1000001)

	local pos_x = pos.x - ctr.layer:getContentSize().width
    local pos_y = pos.y + ctr.layer:getContentSize().height
	ctr.layer:setPosition(pos_x,pos_y)

end


function RewardLayer:onShareMenuClick(tag,pSender)
	local hero_id = 0
	for i, v in ipairs(ex.Player.hero_data.hero_list) do
		if v.hero_type == self.local_hero_type and v.level == 1 and v.is_lock == false then
			hero_id = v.hero_id
		end
	end

	if hero_id == 0 then return end 	

    local req = HeroShare_pb.GReqHeroShare()
    
    req.hero_id = hero_id
    req.channel_type = tag
	NetManager:sendMessage(ProtocolID.GReqHeroShare,req)
	
end

function RewardLayer:getHero(hero_type)
    local item_type = hero_type
    local item_elem = 0
    local item_level = 0
    local item_star = 0

    local config = cfg.herotype.star[hero_type]
	if config then
		item_elem = config.elem
		item_level = 1
		item_star = config.star
	else
		item_type = 0
	end

	print("RewardLayer:getHero", item_type)
    return UIMenuItemHero:createWithData("0", item_type, item_elem, item_level, item_star)
end

function RewardLayer:addEffectForEverHero(node, pos)
    local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_summon_1")
    spr_effect:setPosition(pos)
    node:addChild(spr_effect)
end

function RewardLayer:onceAnim(node, pos, str_spr, str_plist, str_png)
	-- local sfc = cc.SpriteFrameCache:getInstance()
	-- sfc:addSpriteFrames(str_plist)
	local spr_effectOnce = cc.Sprite:createWithSpriteFrameName(str_spr)
    spr_effectOnce:setScale(1)
    spr_effectOnce:setPosition(pos)
    node:addChild(spr_effectOnce)

    local action = cpp.ActionFactory:createLuaAnimate(str_plist, str_png, 0.06)
    spr_effectOnce:runAction(cc.Sequence:create(action, cc.CallFunc:create(function()
    	spr_effectOnce:setVisible(false)
    end)))
end

function RewardLayer:addEffectForOneHero(node, pos, star)
	-- cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_BGR_A8888)

	if star == 5 then
     	local spr_effect5 = ex.EffectFactory:createEffectWithNodeByName("eff_summon_big_5")
     	spr_effect5:setPosition(cc.p(pos.x, pos.y + 7))
    	node:addChild(spr_effect5, 99999)

    	self:onceAnim(node, pos, "summon-big-effect/5b-0.png", "ccbi-res/summon-big-effect.plist", "summon-big-effect/5b-%d.png")
     elseif star == 4 then
     	local spr_effect4 = ex.EffectFactory:createEffectWithNodeByName("eff_summon_big_4")
     	spr_effect4:setPosition(cc.p(pos.x - 2, pos.y))
    	self.award_node:addChild(spr_effect4, 99999)

    	self:onceAnim(node, pos, "summon-big-effect/4b-0.png", "ccbi-res/summon-big-effect.plist", "summon-big-effect/4b-%d.png")
     else
     	-- 三星以下
    	--self:onceAnim(node, pos, "summon-effect/3-0.png", "ccbi-res/summon-effect.plist", "summon-effect/3-%d.png")
     end
	-- cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_BGR_A8888)
	ex.AudioManager:playEffect("music/summonlist.mp3")
end

function RewardLayer:showHeroForBigStar()
	if table.nums(self.show_hero) == 0 then
		self:orderShow()
		return
	end

	local awardList = {}
	table.insert(awardList, self.show_hero[1].type)
	self:addChild(RewardLayer:createAward(2, awardList, false, handler(self, self.showHeroForBigStar), true))

	table.remove(self.show_hero, 1)
end


function RewardLayer:setHero(hero_type, level, star)

	self.node_cell.spr_light_left:setVisible(true)

    self.spine_effect_left_2 = sp.SkeletonAnimation:create("spine/prophet-tree-effect-2.json","spine/prophet-tree-effect-2.atlas", 1)
    self.spine_effect_left_2:setAnimation(0, "stand", true);
	self.spine_effect_left_2:setPosition(0,-120)
	self.spine_effect_left_2:setScale(1.4)
    self.node_cell.hero:addChild(self.spine_effect_left_2, 50)


    self.spine_effect_left_1 = sp.SkeletonAnimation:create("spine/prophet-tree-effect-1.json","spine/prophet-tree-effect-1.atlas", 1)
    self.spine_effect_left_1:setAnimation(0, "stand", true);
	self.spine_effect_left_1:setPosition(0,-120)
	self.spine_effect_left_1:setScale(1.4)

    self.node_cell.hero:addChild(self.spine_effect_left_1, 10)


	if self.local_select_star == 4 then 
		ex.EffectCtr:playNormalEff(34, 0,0 , nil, self.node_cell.hero, 100)
	elseif self.local_select_star == 5 then
		ex.EffectCtr:playNormalEff(33, 0,0 , nil, self.node_cell.hero, 100)
	end 


    local skin = ex.Tools:getHeroSkinByStar(hero_type, star)
    self.hero_left = require("src.person.Hero"):create("12323", "123213", hero_type,level, star, skin)
    self.hero_left:setScale(1.5 * 1.4)
    self.hero_left:setPosition(0,0)
	self.node_cell.hero:addChild(self.hero_left, 60)
	self.hero_left:setShadowVisible(false)
	self.node_cell:reorderChild(self.node_cell.spr_light_left, 1000)




end


function RewardLayer:onSkillInfo(tag, pSender)
	local ctr = require("src.layer.HeroSkillInfoCtr"):instance()
	ctr:openWindow(pSender.skill_type, pSender.skill_level)
	ctr.layer:setLocalZOrder(1000001)
end


function RewardLayer:getSkillPowerMark(skill_type)
	for i,v in pairs(cfg.heroskill.heroskill) do
		if v.type == skill_type  then
			return v.power_mark 
		end
	end
	return 0
end

function RewardLayer:createSkill( stage, hero_type ,star)

	local icon_width = 110
	local vec_skill = ex.Player.hero_data:getHeroSkillList(hero_type)
	local skill_num = table.nums(vec_skill)
	local UIMenuItemSkill = require("src.comp.menu.UIMenuItemSkill")
	local max_skill_num = 4
	
	local menu = cpp.UIMenu:create()
	menu:setPosition(cc.p(0, 0))
	self.node_cell.hero_skill:addChild(menu)

	local scale = 1
	for i=1,max_skill_num do
		if i <= skill_num then  
			local skill_level = ex.Player.hero_data:getHeroSkillLevel(stage, star, i, hero_type)

			local btn_skill = UIMenuItemSkill:createWithIcon(vec_skill[i], skill_level, false, handler(self, self.onSkillInfo))
			btn_skill:setGray(false)
			btn_skill:setScale(scale)
			btn_skill:setPosition(icon_width * (i - 1), 0)

			if self:getSkillPowerMark(skill_id) == 1 then 
				local spr_banner = cc.Sprite:createWithSpriteFrameName("reward-layer-lang/spr-qiangli.png")
				spr_banner:setPosition(btn_skill:getContentSize().width,btn_skill:getContentSize().height)
				btn_skill:addChild(spr_banner)
			end 
			btn_skill:resetLblName()
			menu:addChild(btn_skill)
		end 
	end

	self.node_cell.hero_skill:setPosition(self.node_cell.hero_skill:getPositionX() - icon_width * skill_num * 0.5 + 60, self.node_cell.hero_skill:getPositionY())

end


function RewardLayer:createStar(hero_type, star)
	local typeData = cfg.herotype.star[hero_type]
	local curStar = star
	self.node_cell.node_star:removeAllChildren()

	local star_type = math.floor(star / 5)
	local star_count

	if star % 5 == 0 then 
		if star > 5 then
			star_count = 1
		else 
			star_count = 5
			star_type = 0
		end
	else
		star_count = star % 5
	end

	local path = string.format("other/star-%d.png",star_type)

	if star > 10 then star_count = star_count + 1 end

	for i=1,star_count do
		local sp = cc.Sprite:createWithSpriteFrameName(path)
		self.node_cell.node_star:addChild(sp,star_count-i)
		local margin = 12
		local width = sp:getContentSize().width + margin
		local posX = -(width / 2 * star_count) / 2 + width / 2 * (i - 0.5) 
		sp:setPosition(posX,0)
	end

end



function RewardLayer:allChildrenFade(node, duration, flag)
    local children = node:getChildren()
    if table.nums(children) <= 0 then
        return
	end
	
	for i,v in ipairs(children) do
        if v ~= nil and v:isVisible() then
            self:allChildrenFade(v, duration, flag)
        
			if flag then
				local opacity = v:getOpacity()
				v:setOpacity(0)
				v:runAction(cc.EaseExponentialOut:create(cc.FadeTo:create(duration, opacity)))
			else
				v:runAction(cc.EaseExponentialOut:create(cc.FadeOut:create(duration * 0.3)))
			end
        end
    end
end


function RewardLayer:showHeroImage(  )
	
	self:setHero(self.awardList[1], 1, self.local_select_star)

	self:allChildrenFade(self.hero_left, 2, true )



	if self.spr_action then self.spr_action:setVisible(false) end 


end



function RewardLayer:updateView()
	-- 英雄特
	if self.awardCount == 1  and self.flag  and self.flag == true then

		local config = cfg.herotype.star[self.awardList[1]]
		if config then 
			self.local_hero_type = self.awardList[1]
			self.local_select_star = config.star
			self.node_cell.show_hero:setVisible(false)
			self.node_cell.spr_light_left:setVisible(false)

			self.node_cell.spr_light_bottom_right:setVisible(false)

			if config.star > 3 then 
				self.node_cell.show_hero:setVisible(true)

				local str = string.format( "<outline color='#283793' size='2'><font color='#ffffff'>%s</font></outline>", ex.Tools:getLang(self.awardList[1]) ) 
				self.lbl_btn_refresh:setXmlTextLua(str)
				self.node_cell.lbl_hero_name:setString(ex.Tools:getLang(config.describe))
				self:createSkill(0, self.awardList[1], config.star)


				local conf = cfg.herotype.star[self.local_hero_type]
				self.node_cell.icon_occupat:setSpriteFrame("hero-icon/elem-" .. conf.elem .. ".png")
				self.node_cell.icon_occupat:setScale(1)
				
				self:createStar(self.awardList[1], config.star)

				-- donghua

				--self.node_cell.test_scale:runAction(cc.ScaleTo:create(0.1, 1))

				local show_hero_image_ypng = ""
				local show_hero_image_png = ""
				local show_hero_image_plist = ""
				
				if config.star ==  5  then 
	
					show_hero_image_ypng = "reward-effect2/jin-0.png"
					show_hero_image_png = "reward-effect2/jin-%d.png"
					show_hero_image_plist = "ccbi-res/reward-effect2.plist"

					ex.AudioManager:playEffect("music/summon5.mp3")
				else 
				
					show_hero_image_ypng = "reward-effect2/zi-0.png"
					show_hero_image_png = "reward-effect2/zi-%d.png"
					show_hero_image_plist = "ccbi-res/reward-effect2.plist"

					ex.AudioManager:playEffect("music/summon4.mp3")

				end 
			

				self.spr_action = cc.Sprite:createWithSpriteFrameName(show_hero_image_ypng)
				self.spr_action:setPosition(0,0)		
				self.spr_action:setScale(4)
				self.node_cell.hero:addChild(self.spr_action, 0,10)
				self.spr_action:setGLProgram(cpp.ShaderFactory:instance():getGLProgram(1))
		
				local action = cpp.ActionFactory:createLuaAnimate(show_hero_image_plist,
				show_hero_image_png, 0.06)
				self.spr_action:runAction(cc.Sequence:create(action, cc.CallFunc:create(handler(self, self.showHeroImage))))
			else
				local pos = cc.p(self.viewSize.width / 2, self.viewSize.height / 2 + 140)
				local node = self:getHero(self.awardList[1])
				node:registerScriptTapHandler(handler(self, self.onItem))
				node:setPosition(pos)
				node:setScale(1)
				local menu = cpp.UIMenu:create()
				menu:setPosition(cc.p(0, 0))
				menu:addChild(node)
				self.award_node:addChild(menu)
				self:addEffectForOneHero(self.award_node, pos, node.star)
			end 
		end 
	else
		-- 多个英雄中有4星5星时候 先单独显示
		self.show_hero = {}
		for _,v in pairs(self.awardList) do
			local config = cfg.herotype.star[v]
			if config then
				if config.star > 3 then
					table.insert(self.show_hero, config)
				end
			end
		end

		table.sort(self.show_hero, function(a, b)
			return a.star > b.star
		end)

		self:showHeroForBigStar()
	end
end

function RewardLayer:orderShow()

	self.node_cell.show_hero:setVisible(false)
	local top = self.node_cell.spr_title:getPositionY() - self.node_cell.spr_title:getContentSize().height / 2
	local bottom = self.node_cell.btn_again:getPositionY() + self.node_cell.btn_again:getContentSize().height / 2 + 5
    self.viewSize.height = top - bottom - 45

    local item_size = cc.Sprite:createWithSpriteFrameName("other/rare-0.png"):getContentSize()
    item_size = cc.size(item_size.width + 35, item_size.height + 45)

    local scroll_view = cc.ScrollView:create(self.viewSize)
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    :setPosition(0, self.award_node:getPositionY() + bottom + 45)
	self:addChild(scroll_view)
	
	local menu = cpp.UIMenu:create()
	menu:setPosition(cc.p(0, 0))
	scroll_view:getContainer():addChild(menu)


	-- 求最大列数
	local margin = 40
	local col = math.min(4, self.awardCount)
    local row = math.ceil(1.0 * self.awardCount / col) -- 行数
    local cont_height = item_size.height * row
    cont_height = math.max(cont_height + margin, self.viewSize.height)

    scroll_view:setContentSize(cc.size(self.viewSize.width, cont_height))
    scroll_view:setContentOffset(cc.p(0, self.viewSize.height - cont_height))

    cont_height = cont_height - item_size.height * 0.5
	if row == 1 then
		margin = 0
    	cont_height = cont_height - item_size.height * 0.5
    end

    local start = cc.p(self.viewSize.width * 0.5 - (item_size.width * col * 0.5), cont_height - margin)
    start.x = start.x + item_size.width * 0.5

	local index = 0
	for _,v in pairs(self.awardList) do
		local x = index % col
        local y = math.floor(index / col)

        local pos = cc.p(start.x + x * item_size.width, start.y - y * item_size.height)

		local node = self:getHero(v)
		node:registerScriptTapHandler(handler(self, self.onItem))
        menu:addChild(node)

        node:setPosition(pos)
		node:setScale(0)
		-- 每个物品延迟显示
		node:runAction(cc.Sequence:create(cc.DelayTime:create(index * 0.05),
			cc.EaseBackOut:create(cc.ScaleTo:create(0.15, 1)),
			cc.CallFunc:create(function()
			-- self:addEffectForEverHero(scroll_view, pos)
			--self:onceAnim(scroll_view, pos, "summon-effect/3-0.png", "ccbi-res/summon-effect.plist", "summon-effect/3-%d.png")
			self:playHeroEffeft(scroll_view, pos, v)
		end)))

		index = index + 1
	end
end



function RewardLayer:playHeroEffeft( node, pos, index )
	local config = cfg.herotype.star[index]

	if config.star == 5 then
		-- local spr_effect5 = ex.EffectFactory:createEffectWithNodeByName("eff_summon_big_5")
		-- spr_effect5:setPosition(cc.p(pos.x, pos.y + 7))
		-- node:addChild(spr_effect5)
		--self:onceAnim(node, pos, "reward-layer/zhaohuan-jin-0.png", "ccbi-res/reward-layer.plist", "reward-layer/zhaohuan-jin-%d.png")

		ex.EffectCtr:playNormalEff(29, pos.x - 2, pos.y + 2 , nil, node, 10)

		--ex.AudioManager:playEffect("music/summon5.mp3")

	elseif config.star == 4 then
		-- local spr_effect4 = ex.EffectFactory:createEffectWithNodeByName("eff_summon_big_4")
		-- spr_effect4:setPosition(cc.p(pos.x - 2, pos.y))
		-- node:addChild(spr_effect4)
		--self:onceAnim(node, pos, "reward-layer/zhaohuan-zi-0.png", "ccbi-res/reward-layer.plist", "reward-layer/zhaohuan-zi-%d.png")
		ex.EffectCtr:playNormalEff(30, pos.x - 2, pos.y + 2, nil, node, 10)

		--ex.AudioManager:playEffect("music/summon4.mp3")

	else
		
	end
	ex.AudioManager:playEffect("music/summonlist.mp3")
end


function RewardLayer:onSummonAgain(tag, pSender)
	ex.Player.summon_data:doneAgain()
	self:close()
end

function RewardLayer:onCallback()
	if self.callback then
		self.callback()
	end

	self:close()
end

function RewardLayer:onClose(tag, pSender)
	-- 评论有礼状态
	local shared_isVisible = false
    if ex.Player.level >= cfg.opencondition.condition["comments_reward"].condition_value and cfg.socialplatform.isOpen("comments_reward") then
        local comment_data =
            TableEx.findValueFunction(
            ex.Player.comment_list,
            function(value)
                return value.type == 200 and value.state == 2
            end
        )
        shared_isVisible = cfg.funcopen["comments_reward"].isVisible() and comment_data == nil
	end
	
	if self.is_jump then
		for _,v in pairs(self.awardList) do
			local config = cfg.herotype.star[v]
			if config then
				if config.star > 4 and GUIDE_STEP_CONTROL ~= "skip" then
					local is_show = ex.Player.promotion_data:isExistStarGiftForStar(config.star)
					-- 检查显示礼包是否解锁并开启
					if is_show then
						-- 获得5星以上英雄 限时礼包跳转
						ex.ConfirmCtr:openWindow("", string.format(ex.Tools:getLang(2725), config.star), function()
							ex.EventManager:fire(EVENT.OPEN_LAYER_CLOSE_OTHER.OPEN_HERO_STAR_GIFT)	-- 关闭其他打开controller，底层功能缺陷，先这样
							ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LIMIT_GIFT)
						end,nil,nil,nil,nil,
						function()
							-- 获得5星以上的英雄并且还未领取评论有礼 add 熊梦
							if shared_isVisible then
								cfg.funcopen.comments_reward.open()
							end
						end)

						break
					-- 获得5星以上的英雄并且还未领取评论有礼 add 熊梦
					elseif shared_isVisible then
						cfg.funcopen.comments_reward.open()
						break
					end
				end
			end
		end
	end

	self:onCallback()
end

function RewardLayer:onItem(tag, pSender)
	local item_type = pSender.item_type or pSender.hero_type
	ex.Tools:onClickItemInfo(item_type, NULL_ID, nil, 1000002)
end

return RewardLayer
