--[[
* @Description: 黑色星期五 - 英雄排行 英雄选择界面 元素選擇
* @Author: 熊梦
* @Date: 2021-3-2 1:26:00
* ]]

local PROMBlackFridayHeroRankHeroChoicePanelCtr = class("PROMBlackFridayHeroRankHeroChoicePanelCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PROMBlackFridayHeroRankHeroChoicePanelLayer = class("PROMBlackFridayHeroRankHeroChoicePanelLayer", require("src.comp.EventLayerAdaptiveWidth"))
local UIItemHero = require("src.comp.menu.UIMenuItemHero")
---------------------------------------------------------------------------------

function PROMBlackFridayHeroRankHeroChoicePanelLayer:onCreate()
    self:addBlackBackground()
	self:registerBtnEvent()
end

-- 关闭按钮
function PROMBlackFridayHeroRankHeroChoicePanelLayer:registerBtnEvent( )
	local ctr = PROMBlackFridayHeroRankHeroChoicePanelCtr:instance()
	self.btn_close:registerScriptTapHandler(handler(ctr, ctr.closeWindow))
end

function PROMBlackFridayHeroRankHeroChoicePanelLayer:createScrollView( )
	-- 英雄列表scroll_view
	self.viewSize = self.spr_hero_bg:getContentSize()
    self.viewSize.height = self.viewSize.height - 110

    self.item_size = cc.Sprite:createWithSpriteFrameName("other/rare-0.png"):getContentSize()
    self.item_size = cc.size(self.item_size.width + 15, self.item_size.height + 12)
	self.scroll_view = require("src.comp.UIScrollViewBackpack"):createWithSize(self.viewSize)
    self.scroll_view:setPosition(cc.p(self.spr_hero_bg:getPositionX(), self.spr_hero_bg:getPositionY() + 5))
    self.scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.scroll_view:setItemSize(cc.size(self.item_size.width + 10, self.item_size.height))
    self.scroll_view:setItemOffset(cc.p(0, 5))
    self:addChild(self.scroll_view)
end

function PROMBlackFridayHeroRankHeroChoicePanelLayer:initData(tag,callback,hero_data)
    self.elem = 0
	self.hero_list_view = {}
	self.elem_data = {{},{},{},{},{}}
	self.current_data = {}
	self.tag = tag
	self.callback = callback
	self.btn_elem_select = require("src.layer.HeroElemSelect"):new()
	self.already_hero_data = hero_data

	self:createScrollView()

	for i,v in ipairs(cfg.promotion092config.promotion092config[1].select_hero) do
		local ischoice = true
		for j,k in pairs(self.already_hero_data) do
			if cfg.herotype.star[v].type == k.type then
				ischoice = false
				break
			end
		end
		if ischoice then	
			table.insert( self.elem_data[cfg.herotype.star[v].elem], cfg.herotype.star[v])
		end
	end

    for i=1,5 do
        local btn = self["btn_elem"..i]
        btn:setTag(i)
        btn:registerScriptTapHandler(handler(self, self.onElem))
		self.btn_elem_select:bindSelect(btn)
    end
	self.btn_elem_select:setSelected(ElemType.FIRE)

	self:onElem(1)
end

function PROMBlackFridayHeroRankHeroChoicePanelLayer:onElem(tag,pSender)
    if tag == self.elem then return end 
	self.current_data = {}
    self.elem = tag 
	self.btn_elem_select:setSelected(self.elem)
    local data = self.elem_data[self.elem]
	self.hero_list_view = {}
	self.scroll_view.createItemFunction = function(item_data, scale)
        local item = UIItemHero:createWithData("0", item_data.type, item_data.elem, 1, item_data.star)
        item:registerScriptTapHandler(function(tag, pSender)
            self:onSelectHero(item_data,pSender)
        end)
		item.type = item_data.type
        item:autoLocked()
        item:setSelected(false)
		table.insert( self.hero_list_view, item )
        return item
    end
    self.scroll_view:reloadData(data)
end

function PROMBlackFridayHeroRankHeroChoicePanelLayer:onSelectHero( item_data , pSender)
	dump(item_data)
	if self.current_data.type == item_data.type then
		return
	end

	for i,v in pairs(self.hero_list_view) do
       if v.type ~= item_data.type then
			v:setSelected(false)
	   end
    end

	pSender:setSelected(not pSender:isSelected())
	self.current_data = item_data
end

function PROMBlackFridayHeroRankHeroChoicePanelLayer:onChoice(tag, pSender)
	if self.current_data.type == nil then
		ex.MessageView:add(ex.Tools:getLang(2210))
		return
	end

	if self.callback ~= nil then
		self.callback(self.current_data,self.tag)
		local ctr = PROMBlackFridayHeroRankHeroChoicePanelCtr:instance()
		ctr:closeWindow()
	end
end
---------------------------------------------------------------------------------

function PROMBlackFridayHeroRankHeroChoicePanelCtr:onCreate()
	self:setCCBIPath("ccbi/PROMBlackFridayHeroRankHeroChoicePanelLayer.ccbi")
	self:setIsSingle(false)
end

function PROMBlackFridayHeroRankHeroChoicePanelCtr:getLayerClass()
	return PROMBlackFridayHeroRankHeroChoicePanelLayer
end

function PROMBlackFridayHeroRankHeroChoicePanelCtr:openWindow(tag,callback,hero_data)
	if self:isOpened() then
		return
	end
	self:loadLayer()
	self:open()
	self.layer:initData(tag, callback,hero_data)
end

return PROMBlackFridayHeroRankHeroChoicePanelCtr
