--[[
* @Description: 神兵背包
* @Author: 周向阳
* @Date: 2020-09-26 20:00:00
* ]]
local GodArmsBackpackCtr = class("GodArmsBackpackCtr",require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local GodArmsBackpackLayer = class("GodArmsBackpackLayer",require("src.comp.EventLayerAdaptiveWidth"))

local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function GodArmsBackpackLayer:onCreate()
    self:addBlackBackground()
	self:registerBtnEvent()
	self:inidata()
	
end

-- 关闭按钮
function GodArmsBackpackLayer:registerBtnEvent( )
	local ctr = GodArmsBackpackCtr:instance()
	self.btn_close:registerScriptTapHandler(handler(ctr, ctr.closeWindow))
end

function GodArmsBackpackLayer:inidata()
	-- self.god_arms_equip = ctr.crusade_group.data.god_arms_equip
	
	
	self:addEvent(EVENT.CRUSADE_GROUP.UPDATE_GOD_ARMS_BACKPACK, handler(self, self.onOpenBoxReward))

	self:onOpenBoxReward()

end


function GodArmsBackpackLayer:onOpenBoxReward()

	self.cur_data = {}
	local item_table = {}
	local role_god_arms_info = ctr.crusade_group.data.role_god_arms_info.roleShenBins
	local god_arms = cfg.crusadegroupshenbin.crusadegroupshenbin
	
	for i,v in ipairs(role_god_arms_info) do
		if v.itemNum > 0 then
			table.insert( item_table, v )
		end
	end
	for i,v in ipairs(item_table) do
		for j,k in ipairs(god_arms) do
			if v.item_type == k.sb_id then
				v.quality = k.quality
				table.insert( self.cur_data, v )
			end
		end
		if v.item_type == 902048 then
			v.quality = 10
			table.insert( self.cur_data, v )
		end 
		
	end
	local function sor(a, b)
		if a.quality == b.quality then
			return a.item_type > b.item_type
		end		
		return a.quality > b.quality
	end
	table.sort(self.cur_data, sor)

	self:updateScrollView(self.cur_data)
end

function GodArmsBackpackLayer:updateScrollView(vec_data)
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

    self.scroll_view:setLoaded(false)
    
    self.scroll_view.createItemFunction = function(item_data, scale, index, pos)
        local item = nil
        if item_data == nil then
            item = UIItemBackpack:createWithData(0, 0)
            item:setScale(scale * ex.s.global_scale)
        else
			item = UIItemBackpack:createWithData(item_data.item_type, item_data.itemNum)
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



function GodArmsBackpackLayer:onShowInfo(tag, pSender)
	if pSender.item_type == 902048 then
		return
	end
	require("src.layer.crusadegroup.godarms.GodArmsComposeCtr"):instance():openWindow( nil,  nil,  pSender.item_type,  nil, 4)
end

-----------------------------------------------------------------------------
function GodArmsBackpackCtr:onCreate()
	self:setCCBIPath("ccbi/GodArmsBackpackLayer.ccbi")
	self:setIsSingle(false)
end

function GodArmsBackpackCtr:getLayerClass()
	return GodArmsBackpackLayer
end

function GodArmsBackpackCtr:getAchievementLayer()
	return self.layer
end

function GodArmsBackpackCtr:openWindow()
	if self:isOpened() then
		return
	end
	self:loadLayer()
	self:open()
end

function GodArmsBackpackCtr:initData()

end

return GodArmsBackpackCtr
