--[[
* @Description: 异界冒险-货仓
* @Author: 熊梦
* @Date: 2020-07-30 20:00:00
* ]]
local ExoticAdventureBackpackCtr = class("ExoticAdventureBackpackCtr",require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ExoticAdventureBackpackLayer = class("ExoticAdventureBackpackLayer",require("src.comp.EventLayerAdaptiveWidth"))

local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function ExoticAdventureBackpackLayer:onCreate()
    self:addBlackBackground()
	self:registerBtnEvent()
	self:inidata()
end

-- 关闭按钮
function ExoticAdventureBackpackLayer:registerBtnEvent( )
	local ctr = ExoticAdventureBackpackCtr:instance()
	self.btn_close:registerScriptTapHandler(handler(ctr, ctr.closeWindow))
end

function ExoticAdventureBackpackLayer:inidata()
	-- ex.Player.exotic_adventure_data.level = data.level 			--舰队等级
	-- ex.Player.exotic_adventure_data.exp = data.exp 				--舰队经验
	-- ex.Player.exotic_adventure_data.nick = data.nick 				--舰队名字
	-- ex.Player.exotic_adventure_data.durability = data.durability 	--耐久度
	-- ex.Player.exotic_adventure_data.skill_num = data.skill_num 	--剩余科技点
	-- ex.Player.exotic_adventure_data.skill = data.skill				--科技信息
	--cfg.spacetimefleetskill.spacetimefleetskill[]

	self.spr_box_size_origin = self.spr_box:getContentSize()
	self.scroll_view_size_origin = cc.size(self.spr_box_size_origin.width, self.spr_box_size_origin.height - 10)
	
	self.item_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()
	self.item_size = cc.size(self.item_size.width * ex.s.global_scale , self.item_size.height * ex.s.global_scale + 17 * math.max(1, ex.s.global_scale))
	
	self.scroll_view = require("src.comp.UIScrollViewBackpack"):createWithSize(self.scroll_view_size_origin)
    self.scroll_view:setPosition(0, 5)
    self.scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.scroll_view:setItemSize(cc.size(self.item_size.width + 10, self.item_size.height + 10))
    self.scroll_view:setItemOffset(cc.p(0, 5))
    self.scroll_view:setAutoFull(true)
    self.scroll_view:setCreateNum(4)
	self.spr_box:addChild(self.scroll_view)
	
	local menu_tab = cpp.UIMenu:create()
    menu_tab:setIsTouchInsideNode(self.btn_scroll_view)
    menu_tab:setSwallowsTouches(false)
    menu_tab:setPosition(cc.p(0, 0))
	self.btn_scroll_view:addChild(menu_tab)
	
	 -- 添加导航条
	 local btn_tab_str = {76513, 76514, 76515}
	 local margin_x, space_x, item_size, scale = 4, 10, nil, 1
	 for i= 1, #btn_tab_str do
		 self["btn_tab"..i] = cpp.UIMenuItemTab:create("button/btn-tab-1.png", "button/btn-tab-2.png", "", 1, 1)
		 self["btn_tab"..i]:setScale(scale)
		 if not item_size then 
			 item_size = self["btn_tab"..i]:getContentSize()
			 item_size.width = item_size.width * scale
			 item_size.height = item_size.height * scale
		 end
		 self["btn_tab"..i]:setTag(i)
		 self["btn_tab"..i]:registerScriptTapHandler(handler(self, self.onTabChange))
		 self["btn_tab"..i]:setAnchorPoint(ex.a.bottom_center)
		 self["btn_tab"..i]:setPosition(margin_x + (i - 0.5) * item_size.width + (i - 1) * space_x, 0)
		 menu_tab:addChild(self["btn_tab"..i])
		 self["btn_tab"..i]:setLabelText(ex.Tools:getLang(btn_tab_str[i]))
		 self["btn_tab"..i]:setLabelColor(FONT_BROWN)
		 self["btn_tab"..i]:setLabelOffset(cc.p(0, -2))
	 end
	 self.btn_scroll_view:setContentSize(cc.size(2 * margin_x + #btn_tab_str * item_size.width + (#btn_tab_str - 1) * space_x, self.btn_scroll_view:getViewSize().height))
	 self.btn_scroll_view:setContentOffset(self.btn_scroll_view:maxContainerOffset())

	local checkpoint_data = cfg.spacetimeadventure.spacetimeadventure[ex.Player.exotic_adventure_data.not_route]

	self.backpack1 = checkpoint_data.fix_reward

	
	self:changeLayer(1)

end


function ExoticAdventureBackpackLayer:onTabChange(tag, pSender)
    self:changeLayer(tag)
end

function ExoticAdventureBackpackLayer:changeLayer(tab)
	self.choice_tag = tab
    self.btn_tab1:setChecked(tab == 1)
    self.btn_tab2:setChecked(tab == 2)
    self.btn_tab3:setChecked(tab == 3)

 
    -- 统一入口
    self:onOpenBoxReward(tab)
end

function ExoticAdventureBackpackLayer:onOpenBoxReward(tab)
	local cur_data = {}
	if tab == 1 then
		cur_data = self.backpack1
	elseif tab == 2 then
		for k,v in pairs(ex.Player.exotic_adventure_data.item_list) do
			local data = {}
			data.item_type = v.type
			data.item_num = v.num
			table.insert( cur_data, data)
		end
	elseif tab == 3 then
		for k,v in pairs(ex.Player.exotic_adventure_data.goods_list) do
			for index,value in pairs(cfg.spacetimebox.spacetimebox) do
				if v.idx == value.idx then
					local data = {}
					data.item_type = value.item_id
					data.item_num = 1
					data.reward = value.reward
					data.idx = value.idx
					table.insert( cur_data, data)
				end
			end
		end
	end
	self:updateScrollView(cur_data)
end

function ExoticAdventureBackpackLayer:updateScrollView(vec_data)
    self.scroll_view:setLoaded(false)
    
    self.scroll_view.createItemFunction = function(item_data, scale, index, pos)
        local item = nil
        if item_data == nil then
            item = UIItemBackpack:createWithData(0, 0)
            item:setScale(scale * ex.s.global_scale)
        else
			item = UIItemBackpack:createWithData(item_data.item_type, item_data.item_num)
			item:setScale(scale * ex.s.global_scale)
			item.reward = nil
			if item_data.reward ~= nil then
				item.reward = item_data.reward 
			end
            item:registerScriptTapHandler(handler(self, self.onShowInfo))
        end
        return item
    end
    self.scroll_view:reloadData(vec_data)
end

function ExoticAdventureBackpackLayer:onShowInfo(tag, pSender)
	if pSender.reward ~= nil then
		require("src.layer.exoticadventure.ExoticAdventureBackpackInfoCtr"):instance():openWindow(pSender.item_type,pSender.reward)
	else
		ex.Tools:onClickItemInfo(pSender.item_type)
	end
end

-----------------------------------------------------------------------------
function ExoticAdventureBackpackCtr:onCreate()
	self:setCCBIPath("ccbi/ExoticAdventureBackpackLayer.ccbi")
	self:setIsSingle(false)
end

function ExoticAdventureBackpackCtr:getLayerClass()
	return ExoticAdventureBackpackLayer
end

function ExoticAdventureBackpackCtr:getAchievementLayer()
	return self.layer
end

function ExoticAdventureBackpackCtr:openWindow()
	if self:isOpened() then
		return
	end
	self:loadLayer()
	self:open()
end

function ExoticAdventureBackpackCtr:initData()

end

return ExoticAdventureBackpackCtr
