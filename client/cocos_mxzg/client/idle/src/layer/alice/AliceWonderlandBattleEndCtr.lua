--[[
* @Description: 爱丽丝-战斗结算页面
* @Author: 周向阳
* @Date: 2021-01-14 10:13:00
* ]]
local AliceWonderlandBattleEndCtr = class("AliceWonderlandBattleEndCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local AliceBattleEndLayer = class("AliceBattleEndLayer",require("src.layer.ui.UI_AliceBattleEndLayer"))

local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function AliceBattleEndLayer:onCreate()
	self.super.onCreate(self)
end

function AliceBattleEndLayer:initData(is_win,had_pass,vec_reward,skill_point,ext,callback) 
	self.vec_reward = vec_reward
	self.callback = callback
	self.scroll_view:setAlignmentCenter(true)

	ex.Tools:setSpriteFrame(self.spr_wing, string.format("battle-end/spr-wing-%d.png", is_win and 1 or 0))
	ex.Tools:setSpriteFrame(self.spr_result, string.format("battle-end-lang/lbl-result-%d.png", is_win and 1 or 0))

	self.scroll_view:setVisible(false)
	self.lbl_title:setVisible(false)
	self.spr_lbl_cell_rank_bg:setVisible(false)
	self.lbl_cell_rank:setVisible(false)
	
	self.lbl_round_num:setString(ext.level_round)
	self.lbl_hero_die_num:setString(ext.level_dead)
	if is_win == true then
		if ext.rank ~= 0 and had_pass then
			self.lbl_title:setString(string.format(ex.Tools:getLang(580068), ctr.alice.data.star))
			self.lbl_title:setVisible(true)
			self.spr_lbl_cell_rank_bg:setVisible(true)
			self.lbl_cell_rank:setVisible(true)
			self.lbl_round:setString(ex.Tools:getLang(580070))
			self.lbl_round_num:setString(ext.star_round)
			self.lbl_hero_die_num:setString(ext.star_dead)
			self.lbl_cell_rank_num:setString(ext.rank)
			self.lbl_hero_die:setString(ex.Tools:getLang(580034))
			if vec_reward and #self.vec_reward ~= 0 then
				self.scroll_view.createItemFunction = function(data, scale)
					local item = ex.Tools:createBackpackItem(data.type, data.num)
					item:setScale(0.8)
					item:registerScriptTapHandler(handler(self, self.onItemInfo))
					return item
				end
		
				self.scroll_view:reloadData(self.vec_reward)
				self.scroll_view:setVisible(true)
			else
				self.lbl_win_tips:setString(ex.Tools:getLang(580074))
			end
		else
			if skill_point then
				self.lbl_win_tips:setString(string.format(ex.Tools:getLang(580075),skill_point,skill_point))
				local win_size = self:getContentSize()
				local item = ex.Tools:createBackpackItem(1300005, skill_point)
				item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
				item:setPosition(win_size.width / 2,0)
				self.menu:addChild(item)
			end	
		end

		local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_battle_end")
    	spr_effect:setPosition(self.spr_wing:getContentSize().width / 2, self.spr_wing:getContentSize().height / 2 + 40)
    	spr_effect:setScale(1)
		self.spr_wing:addChild(spr_effect, 0, 10)	
		
		local chibang = sp.SkeletonAnimation:create("spine/chibang.json","spine/chibang.atlas", 1)
        chibang:setAnimation(0, "idle", true);
	    chibang:setPosition(self.spr_wing:getPositionX(), self.spr_wing:getPositionY())
	    self:addChild(chibang)
		self.spr_wing:setVisible(false)
		self.lbl_fail_tips:setVisible(false)

	else
		self.lbl_win_tips:setVisible(false)

		local btn1 = self:createBtn("main-city/up-main_summon.png","main_summon",ex.Tools:getLang(47600))
		local size = btn1:getContentSize()
		local margin = 50
		local win_size = self:getContentSize()
		local offsetX = win_size.width / 2  - ((size.width*3 + margin*3) / 2 )
		self.menu:addChild(btn1)
		btn1:setPosition(offsetX + size.width + margin ,0)
		local btn2 = self:createBtn("main-scene-lang/spr-hero.png","main_hero",ex.Tools:getLang(47334))
		self.menu:addChild(btn2)
		btn2:setPosition(offsetX + size.width + margin + size.width + margin,0)
		-- local btn3 = self:createBtn("main-city/up-main_smith_shop.png","main_smith_shop",ex.Tools:getLang(47302))
		-- self.menu:addChild(btn3)
		-- btn3:setPosition(offsetX + size.width / 2 + margin / 2 + (size.width + margin) * 2,0)
		-- local btn4 = self:createBtn("main-scene/spr-fetter.png","main_fetter",ex.Tools:getLang(47110))
		-- self.menu:addChild(btn4)
		-- btn4:setPosition(offsetX + size.width / 2 + margin / 2 + (size.width + margin) * 3,0)
	end
	self.lbl_cell_rank_num:setPosition(self.lbl_cell_rank:getPositionX() + self.lbl_cell_rank:getContentSize().width , self.lbl_cell_rank:getPositionY())
	self.lbl_round_num:setPosition(self.lbl_round:getPositionX() + self.lbl_round:getContentSize().width , self.lbl_round:getPositionY())
	self.lbl_hero_die_num:setPosition(self.lbl_hero_die:getPositionX() + self.lbl_hero_die:getContentSize().width , self.lbl_hero_die:getPositionY())

end

function AliceBattleEndLayer:createBtn(path,atom,name)
	-- body
	local btn = cpp.UIMenuItemImage:createWithSpriteFrameName("main-scene/btn-bg.png", nil, nil)
	btn:setName(atom)
	btn:registerScriptTapHandler(handler(self,self.onclick))
	local sp = cc.Sprite:createWithSpriteFrameName(path)
	local size = btn:getContentSize()
	sp:setScaleX(size.width / sp:getContentSize().width)
	sp:setScaleY(size.height / sp:getContentSize().height)
	btn:addChild(sp)
	sp:setPosition(size.width / 2,size.height / 2)
	local lbl = cc.Label:createWithTTF(name, FONT_DEFAULT_NAME_BOLD, 24)
	lbl:enableOutline(cc.c3b(92,54,35), 1)
	btn:addChild(lbl)
	lbl:setPosition(size.width/2,0)
	return btn
end

function AliceBattleEndLayer:onclick(tag,pSender)
	print(self.__cname,"click")
	self:onClose()
    local atom = pSender:getName()
    ex.JumpManager:jumpByAtom(atom)
end

function AliceBattleEndLayer:onItemInfo(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

function AliceBattleEndLayer:onConfirm()
	ctr.alice:requestGetInfo()
	self:onClose()
	-- local ctr = AliceWonderlandBattleEndCtr:instance()
	-- ctr:closeWindow()
end

function AliceBattleEndLayer:onExit()
	ctr.alice:requestGetInfo()
end
-----------------------------------------------------------------------------
function AliceWonderlandBattleEndCtr:loadLayer()
	local tmp_layer = AliceBattleEndLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function AliceWonderlandBattleEndCtr:onCreate()
	self:setIsSingle(false)
end

function AliceWonderlandBattleEndCtr:openWindow(ext, round, callback)
	if self:isOpened() then
		return
	end

	local sfc = cc.SpriteFrameCache:getInstance()
	
	sfc:addSpriteFrames("ccbi-res/battle-end.plist")
	sfc:addSpriteFrames("ccbi-res/battle-end-lang.plist")
    
	self:loadLayer()
	self:open()

	local is_win = ext.report[round].win_id ~= -1
	for i,v in ipairs(ext.report) do
		if v.win_id == -1 then
			is_win = false
			break
		end
	end
	local vec_reward = ext.reward
	-- local is_first_pass = ctr.alice.data:getIsFirstPass()
	local had_pass = ext.had_pass
	local skill_point = ext.curr_add_skill
	self.vec_battle_detail = ext
	if ext == nil then
		self.layer.btn_report:setVisible(false)
	end
	self.layer.btn_report:registerScriptTapHandler(handler(self, self.onBattleDetail))
	self.layer:initData(is_win,had_pass,vec_reward,skill_point,ext,callback)
end

function AliceWonderlandBattleEndCtr:onBattleDetail(tag, pSender)
	local report = {}
	for i,v in ipairs(self.vec_battle_detail.report) do
		table.insert(report, v.log)
	end
	require("src.layer.BattleDetailCtr"):instance():openWindow(report)
end


return AliceWonderlandBattleEndCtr
