local TrialHelpCtr = class("TrialHelpCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local TrialHelpLayer = class("TrialHelpLayer", require("src.comp.EventLayerAdaptiveWidth"))
local TrialHelpCell = class("TrialHelpCell", require("src.comp.LuaLayerBase"))

local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

local TRIALHELPLAYERTYPE = {}
TRIALHELPLAYERTYPE.SELECTHERO = 10
TRIALHELPLAYERTYPE.MYHERO = 20

------------------------------------------------
function TrialHelpCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self.cell_props = UIMenuItemHero:createWithData()
    self.hero_menu:add(self.cell_props)
    --self.cell_props:registerScriptTapHandler(handler(self,self.onClickHero))
    self.cell_props:setAnchorPoint(0,0)
    self.cell_props:setPosition(40,25)
    self.cell_props:setScale(1)

	local nslc = require("src.layer.TrialHelpCtr"):instance()
    self.btn_enter:setLabelText(ex.Tools:getLang(47606))
    self.btn_enter:setLabelColor(FONT_BROWN)
    self.btn_enter:setLabelSize(48)
	self.btn_enter:registerScriptTapHandler(handler(nslc, nslc.onClick))
	
	ex.Tools:setGray(self.btn_enter:getDisabledImage())
end

function TrialHelpCell:onClickHero(tag,pSender)

end

function TrialHelpCell:reset(data)
    if not data then print("not data") return end
	self.data = data
	self.btn_enter.data = data
	
	local nslc = require("src.layer.TrialHelpCtr"):instance()
	local model_data = ex.Player.trial_data
    
	self.cell_props:reset(data.hero_data)
	if data.hero_data.fashion_id ~= 0 and data.hero_data.fashion_id ~= nil then   -- 有皮肤
		self.cell_props:setFashionShowForce(data.hero_data.fashion_id)
	end

    self.lbl_hero_name:setString(ex.Tools:getLang(data.hero_data.hero_type))
    self.lbl_fight:setString(data.hero_data.fighting)
    self.lbl_friend_name:setString(data.friend_nick)

    if data.type == 1 then 
        local max_flight = model_data:getMyHeroMaxFight()
        
        local battle_limit = cfg.system.infinite_help_battle_limit * 0.0001

        if battle_limit * max_flight < data.hero_data.fighting  then 
            self.show_flight:setVisible(true)
            self.btn_enter:setVisible(false)
        else 
            self.show_flight:setVisible(false)
            self.btn_enter:setVisible(true)
			
			if data.is_select == true then
				self.btn_enter:setLabelText(ex.Tools:getLang(47703))
			else
				self.btn_enter:setLabelText(ex.Tools:getLang(47606))
			end
        end 

        self.lbl_friend_name:setString(ex.Tools:getLang(47517) .. data.friend_nick)
    else 
        self.show_flight:setVisible(false)
        -- 判断是否已经选中
		self.btn_enter:setVisible(true)

		if data.is_select == true then
			self.btn_enter:setLabelText(ex.Tools:getLang(47043))
			self.btn_enter:setEnabled(false)
		else
			self.btn_enter:setLabelText(ex.Tools:getLang(47125))
		end
    end 
end

------------------------------------------------
function TrialHelpLayer:onCreate()
	self:addBlackBackground()
	
	self.lbl_tip:setString(ex.Tools:getLang(72032))

	self.btn_friend:setChecked(true)
    self.btn_friend:setLabelText(ex.Tools:getLang(47577))
	self.btn_reward:setLabelText(ex.Tools:getLang(47254))
	
    self:addRedDotNode(RedDotType.ZCJ_DHFB_YZSLRK_YZSL_ZYRK_WDZY, self.btn_reward)
end

------------------------------------------------
function TrialHelpCtr:onCreate()
	self:setCCBIPath("ccbi/TrialHelpLayer.ccbi")
	self:setIsSingle(false)
end

function TrialHelpCtr:getLayerClass()
	return TrialHelpLayer
end

function TrialHelpCtr:openWindow()
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initDone()
end

function TrialHelpCtr:initDone()
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	self.layer.btn_friend:registerScriptTapHandler(handler(self, self.onFriend))
	self.layer.btn_reward:registerScriptTapHandler(handler(self, self.onMyHero))
	
	ex.Player.trial_data:gReqFriendAssistHeroList()

	self:onFriend()
end

function TrialHelpCtr:onFriend(tag, pSender)
    self:changeLayer(TRIALHELPLAYERTYPE.SELECTHERO)
end

function TrialHelpCtr:onMyHero(tag, pSender)
    self:changeLayer(TRIALHELPLAYERTYPE.MYHERO)
end

function TrialHelpCtr:changeLayer(type)
	if type == self.select_type then return end  
	self.select_type = type

    self.layer.btn_friend:setChecked(self.select_type == TRIALHELPLAYERTYPE.SELECTHERO)
    self.layer.btn_reward:setChecked(self.select_type == TRIALHELPLAYERTYPE.MYHERO)

	if self.layer.friend_hero_lists ~= nil then
		self.layer.friend_hero_lists:setVisible(self.select_type == TRIALHELPLAYERTYPE.SELECTHERO)
	end
	if self.layer.my_hero_list ~= nil then
		self.layer.my_hero_list:setVisible(self.select_type == TRIALHELPLAYERTYPE.MYHERO)
	end
	
	self:updateScroll()
end

function TrialHelpCtr:updateScroll()
	if self.select_type == TRIALHELPLAYERTYPE.SELECTHERO then
		local my_hero_list = clone(ex.Player.trial_data.friend_data_list)
		for i,v in ipairs(my_hero_list) do
			for i2,v2 in ipairs(ex.Player.trial_data.select_friend_hero) do
				v.is_select = (v.hero_data.hero_id == v2.hero.hero_id)
				if v.hero_data.hero_id == v2.hero.hero_id then
					break
				end
			end
		end

		local sort = function ( a,b )
			return a.hero_data.fighting > b.hero_data.fighting
		end
		table.sort(my_hero_list, sort)

		if  not self.layer.friend_hero_lists then 
			local win_size = cc.size(self.layer.my_hero_bg:getContentSize().width,self.layer.my_hero_bg:getContentSize().height - 10)
			self.layer.friend_hero_lists = ex.Tools:initTableView(self.layer,my_hero_list, {TrialHelpCell,"ccbi/TrialHelpCell.ccbi"} , win_size, 5,cc.p(35,70),true)
		else 
			self.layer.friend_hero_lists:initData(my_hero_list)
			self.layer.friend_hero_lists:reloadData()
		end 
	elseif self.select_type == TRIALHELPLAYERTYPE.MYHERO then 
		--获取英雄信息
		local sort = function ( a,b )
			return a.hero_data.fighting > b.hero_data.fighting
		end

		local my_hero_list = {}
		for i,v in ipairs(ex.Player.hero_data.hero_list) do
			-- add 熊梦 勇者试炼助阵英雄等级限制 智睿说写死40级
			if v.level >= 40 then
				local tmp_data = {}
				tmp_data.hero_data = v
				tmp_data.type = 2
				tmp_data.friend_nick = ""
				tmp_data.friend_id = ""
				table.insert(my_hero_list, tmp_data)
			end
		end
		for i,v in ipairs(my_hero_list) do
			for i2,v2 in ipairs(ex.Player.trial_data.my_hero_data) do
				v.is_select = (v.hero_data.hero_id == v2.hero_id)
				if v.hero_data.hero_id == v2.hero_id then
					break
				end
			end
		end

		table.sort( my_hero_list, sort )

		if  not self.layer.my_hero_list then 
			local win_size = cc.size(self.layer.my_hero_bg:getContentSize().width, self.layer.my_hero_bg:getContentSize().height - 10)
			self.layer.my_hero_list = ex.Tools:initTableView(self.layer,my_hero_list, {TrialHelpCell,"ccbi/TrialHelpCell.ccbi"} , win_size, 5,cc.p(35,70),true)
		else 
			self.layer.my_hero_list:initData(my_hero_list)
			self.layer.my_hero_list:reloadData()
		end 
	end 	
end

function TrialHelpCtr:onShowInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function TrialHelpCtr:onClick(tag, pSender)
	local model_data = ex.Player.trial_data
    
    if pSender.data.type == 1 then
		-- 弹出提示不给选择
		local is_select = true
		for i,v in ipairs(ex.Player.trial_data.select_friend_hero) do
			if v.hero.hero_id == pSender.data.hero_data.hero_id then
				is_select = false
				break
			end
		end
		if is_select == true and #ex.Player.trial_data.select_friend_hero >= ex.Tools:getSysCfg("adventure_get_assist_num") then
			ex.MessageView:add(ex.Tools:getLang(41259))
			return
		end
		-- 判断是否已上过阵
		if is_select == false and pSender.data.had_battle ~= nil and pSender.data.had_battle then
			ex.MessageView:add(ex.Tools:getLang(5799))
			return
		end

		model_data:setSelectFriend(pSender.data, is_select)
		if is_select then
			pSender:setLabelText(ex.Tools:getLang(47703))
		else
			pSender:setLabelText(ex.Tools:getLang(47606))
		end
    
        if self:isOpened() then
			-- 重新刷新界面
            self:updateScroll()
        end
    else
		-- 弹出提示不给选择
		if #ex.Player.trial_data.my_hero_data >= ex.Tools:getSysCfg("adventure_assist_num") then
			ex.MessageView:add(ex.Tools:getLang(72037))
			return
		end

        model_data:setDispatchHero(ex.Player.hero_data:getHeroDataById(pSender.data.hero_data.hero_id))
        pSender:setLabelText(ex.Tools:getLang(47043))

        if self:isOpened() then
            -- 重新刷新界面
			self:updateScroll()
        end
    end  
end

return TrialHelpCtr
