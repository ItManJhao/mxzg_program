local DreamFriendCtr = class("DreamFriendCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local DreamFriendLayer = class("DreamFriendLayer", require("src.comp.EventLayerAdaptiveWidth"))
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

------------------------------------------------
local FRIENDTYPE = {}
FRIENDTYPE.SELECTHERO = 10
FRIENDTYPE.MYHERO = 20
function DreamFriendLayer:onCreate()
	self:addBlackBackground()

end

function DreamFriendLayer:initDone()
	self.cell_props = UIMenuItemHero:createWithData()

    self.my_hero_menu:add(self.cell_props)
    --self.cell_props:registerScriptTapHandler(handler(self,self.onClickHero))
    self.cell_props:setAnchorPoint(0,0)
    self.cell_props:setPosition(40,25)
    self.cell_props:setScale(1)
    -- self.spr_scroll_bg

	self.friend_cell_props = UIMenuItemHero:createWithData()
    self.friend_hero_menu:add(self.friend_cell_props)
    --self.friend_cell_props:registerScriptTapHandler(handler(self,self.onClickHero))
    self.friend_cell_props:setAnchorPoint(0,0)
    self.friend_cell_props:setPosition(40,25)
	self.friend_cell_props:setScale(1)
	

    self.btn_friend:registerScriptTapHandler(handler(self, self.onFriend))
	self.btn_reward:registerScriptTapHandler(handler(self, self.onMyHero))
	
	self.message_tip:setString(ex.Tools:getLang(72032))

    self.btn_friend:setLabelText(ex.Tools:getLang(47577))
    self.btn_reward:setLabelText(ex.Tools:getLang(47254))

	ex.Player.dream_data:gReqFriendAssistHeroList()

	self.friend_hero:setVisible(false)
	self.my_hero:setVisible(false)

	self:reshrefRed()	
end

function DreamFriendLayer:setRedPoint(btn,bool)
	ex.Tools:addRedPoint(btn,bool)
end

function DreamFriendLayer:reshrefRed( )
	
	self:setRedPoint(self.btn_friend, false)

	self:setRedPoint(self.btn_reward, false)
	if ex.Player.dream_data.my_hero_data.hero_id == 0 then 
		self:setRedPoint(self.btn_reward, true)
	end 

end


function DreamFriendLayer:firstUpdate( )
	self:changeLayer(FRIENDTYPE.SELECTHERO)
end

function DreamFriendLayer:onFriend(tag, pSender)
    self:changeLayer(FRIENDTYPE.SELECTHERO)
end

function DreamFriendLayer:onMyHero(tag, pSender)
    self:changeLayer(FRIENDTYPE.MYHERO)
end


function DreamFriendLayer:changeLayer( type )
	
	if type == self.select_type then return end  
	self.select_type = type

    self.btn_friend:setChecked(self.select_type == FRIENDTYPE.SELECTHERO)
    self.btn_reward:setChecked(self.select_type == FRIENDTYPE.MYHERO)


	if type == FRIENDTYPE.SELECTHERO then 
		self.friend_hero:setVisible(true)
		self.my_hero:setVisible(false)

	elseif type == FRIENDTYPE.MYHERO then 
		self.friend_hero:setVisible(false)
		self.my_hero:setVisible(true)

	end 
	
	self:updateScroll()
end


function DreamFriendLayer:updateFriendList( )
	self:reshrefScroll()
end


function DreamFriendLayer:reshrefScroll( )
	if self.select_type == FRIENDTYPE.SELECTHERO then 

		-- 处理数据
		-- self.friend_hero_lists

	else 




	end 
end

function DreamFriendLayer:setFriendBattle(data )
	
	local select_hero_data = data
	ex.Player.dream_data:setFriendHeroData(data.hero_data)
	if select_hero_data then 
		self.select_list:setVisible(true)
		self.no_select_my_hero:setVisible(false)
		self.cell_props:reset(select_hero_data.hero_data)
		if select_hero_data.hero_data.fashion_id ~= 0 and select_hero_data.hero_data.fashion_id ~= nil then   -- 有皮肤
			self.cell_props:setFashionShowForce(select_hero_data.hero_data.fashion_id)
		end
		self.lbl_hero_name:setString(ex.Tools:getLang(select_hero_data.hero_data.hero_type))
		self.my_lbl_fight:setString(select_hero_data.hero_data.fighting)
		self.my_lbl_friend_name:setString(select_hero_data.friend_nick)
	else 
		self.select_list:setVisible(false)
		self.no_select_my_hero:setVisible(true)
	end 

	-- 
	self:updateScroll()
end 



function DreamFriendLayer:setSelectFriendBattle(  data )
	ex.Player.dream_data:setSelectFriendHeroData(data)

	if data then 
		self.friend_select_list:setVisible(true)
		self.no_select_friend_hero:setVisible(false)

		self.friend_cell_props:reset(data.hero)
		if data.hero.fashion_id ~= 0 and data.hero.fashion_id ~= nil then   -- 有皮肤
			self.friend_cell_props:setFashionShowForce(data.hero.fashion_id)
		end

		self.friend_hero_name:setString(ex.Tools:getLang(data.hero.hero_type))
		self.friend_lbl_fight:setString(data.hero.fighting)
		self.friend_lbl_friend_name:setString(ex.Tools:getLang(47517) .. data.friend_nick)

	else 
		self.friend_select_list:setVisible(false)

		self.no_select_friend_hero:setVisible(true)
	end 
	self:updateScroll()
end

function DreamFriendLayer:updateScroll( )

	if self.select_type == FRIENDTYPE.SELECTHERO then 

		local my_hero_list = ex.Player.dream_data.friend_data_list
		-- for i,v in ipairs(ex.Player.hero_data.hero_list) do

		-- 	local my_hero_data = {}
		-- 	my_hero_data.hero_data = v
		-- 	my_hero_data.type = 1
		-- 	my_hero_data.friend_nick = ex.Tools:getLang(47009)
		-- 	my_hero_data.friend_id = ""
		-- 	table.insert(my_hero_list, my_hero_data)
		-- end

		local sort = function ( a,b )
			return a.hero_data.fighting > b.hero_data.fighting
		end
		table.sort( my_hero_list, sort )

		if  not self.friend_hero_lists then 
			local win_size = cc.size(self.now_friend_select:getContentSize().width,self.now_friend_select:getContentSize().height - 10)
			self.friend_hero_lists = ex.Tools:initTableView(self.now_friend_select,my_hero_list, {require("src.layer.dream.DreamFriendCell"),"ccbi/DreamFriendCell.ccbi"} , win_size, 5,cc.p(0,5),true)
		else 
			self.friend_hero_lists:initData(my_hero_list)
			self.friend_hero_lists:reloadData()
		end 

		local  now_friend_data = ex.Player.dream_data.select_friend_hero.hero 
		if now_friend_data  and  now_friend_data.hero_type ~= 0  then 
			self.friend_select_list:setVisible(true)
			self.no_select_friend_hero:setVisible(false)

			self.friend_cell_props:reset(now_friend_data)
			if now_friend_data.fashion_id ~= 0 and now_friend_data.fashion_id ~= nil then   -- 有皮肤
				self.friend_cell_props:setFashionShowForce(now_friend_data.fashion_id)
			end

			self.friend_hero_name:setString(ex.Tools:getLang(now_friend_data.hero_type))
			self.friend_lbl_fight:setString(now_friend_data.fighting)
			self.friend_lbl_friend_name:setString(ex.Tools:getLang(47517) .. ex.Player.dream_data.select_friend_hero.friend_nick)
		else 
			self.friend_select_list:setVisible(false)
			self.no_select_friend_hero:setVisible(true)
		end 


	elseif self.select_type == FRIENDTYPE.MYHERO then 


		--获取英雄信息
		local select_hero_data = ex.Player.dream_data.my_hero_data

		local sort = function ( a,b )
			return a.hero_data.fighting > b.hero_data.fighting
		end

		local my_hero_list = {}
		for i,v in ipairs(ex.Player.hero_data.hero_list) do

			local my_hero_data = {}
			my_hero_data.hero_data = v
			my_hero_data.type = 2
			my_hero_data.friend_nick = ""
			my_hero_data.friend_id = ""
			--select_hero_data = my_hero_data
			table.insert(my_hero_list, my_hero_data)
		end

		table.sort( my_hero_list, sort )

		if  not self.my_hero_list then 
			local win_size = cc.size(self.now_select:getContentSize().width,self.now_select:getContentSize().height - 10)
			self.my_hero_list = ex.Tools:initTableView(self.now_select,my_hero_list, {require("src.layer.dream.DreamFriendCell"),"ccbi/DreamFriendCell.ccbi"} , win_size, 5,cc.p(0,5),true)
		else 
			self.my_hero_list:initData(my_hero_list)
			self.my_hero_list:reloadData()
		end 


		if select_hero_data  and  select_hero_data.hero_type ~= 0  then 
			self.select_list:setVisible(true)
			self.no_select_my_hero:setVisible(false)

			self.cell_props:reset(select_hero_data)
			if select_hero_data.fashion_id ~= 0 and select_hero_data.fashion_id ~= nil then   -- 有皮肤
				self.cell_props:setFashionShowForce(select_hero_data.fashion_id)
			end

			self.lbl_hero_name:setString(ex.Tools:getLang(select_hero_data.hero_type))
			self.my_lbl_fight:setString(select_hero_data.fighting)
			self.my_lbl_friend_name:setString("")
		else 
			self.select_list:setVisible(false)
			self.no_select_my_hero:setVisible(true)
		end 


	end 	

end




function DreamFriendLayer:onShowInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

------------------------------------------------


function DreamFriendCtr:onCreate()
	self:setCCBIPath("ccbi/DreamFriendLayer.ccbi")
	self:setIsSingle(false)
end

function DreamFriendCtr:getLayerClass()
	return DreamFriendLayer
end



function DreamFriendCtr:updateFriendList( )
	self.layer:updateFriendList()
end

function DreamFriendCtr:setSelectFriendBattle(data )
	self.layer:setSelectFriendBattle(data)
end


function DreamFriendCtr:setFriendBattle(data )
	self.layer:setFriendBattle(data)
end


function DreamFriendCtr:firstUpdate( )
	self.layer:firstUpdate()
end

function DreamFriendCtr:reshrefRed( )
	self.layer:reshrefRed()
end


function DreamFriendCtr:openWindow()
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
    self.layer:initDone()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

end

return DreamFriendCtr











