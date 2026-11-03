--[[
* @Description: 异界冒险-事件图鉴
* @Author: 熊梦
* @Date: 2020-07-30 21:00:00
* ]]
local ExoticAdventureIllustratedBooksCtr = class("ExoticAdventureIllustratedBooksCtr",require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ExoticAdventureIllustratedBooksLayer = class("ExoticAdventureIllustratedBooksLayer",require("src.comp.EventLayerAdaptiveWidth"))

local ExoticAdventureIllustratedBooksCell = class("ExoticAdventureIllustratedBooksCell", require("src.comp.LuaLayerBase"))


---------------------------------------------------------------------
function ExoticAdventureIllustratedBooksCell:onCreate()
	self:setAutoClose(false)
    self:setSwallowTouches(false)
end

function ExoticAdventureIllustratedBooksCell:initData(data)
	self.lbl_name:setString(ex.Tools:getLang(data.nick_language_id))
  
	self.lbl_describe:setString(ex.Tools:getLang(data.details_language_id))

	-- self.image:setSpriteFrame(string.format("exotic-adventure/exotic-adventure-spr-shijian-%d.png", data.event_id))
	ex.Tools:setSpriteFrame(self.image, string.format("exotic-adventure/exotic-adventure-spr-shijian-%d.png", data.event_id))
	self.image:setScale(0.3)
end
---------------------------------------------------------------------
function ExoticAdventureIllustratedBooksLayer:onCreate()
    self:addBlackBackground()
	self:registerBtnEvent()
	self:inidata()
end

-- 关闭按钮
function ExoticAdventureIllustratedBooksLayer:registerBtnEvent( )
	local ctr = ExoticAdventureIllustratedBooksCtr:instance()
	self.btn_close:registerScriptTapHandler(handler(ctr, ctr.closeWindow))
end

function ExoticAdventureIllustratedBooksLayer:inidata()
	-- ex.Player.exotic_adventure_data.level = data.level 			--舰队等级
	-- ex.Player.exotic_adventure_data.exp = data.exp 				--舰队经验
	-- ex.Player.exotic_adventure_data.nick = data.nick 				--舰队名字
	-- ex.Player.exotic_adventure_data.durability = data.durability 	--耐久度
	-- ex.Player.exotic_adventure_data.skill_num = data.skill_num 	--剩余科技点
	-- ex.Player.exotic_adventure_data.skill = data.skill				--科技信息
	--cfg.spacetimefleetskill.spacetimefleetskill[]
	self.scroll_view:setItemSize(cc.size(550, 126))
    self.scroll_view:setItemType(1)
	self:updateLayer()

	self:addEvent(EVENT.EXOTICADVENTURE.UPDATA_ILLUSTRATED_BOOKS,handler(self,self.updateLayer))
	
end

function ExoticAdventureIllustratedBooksLayer:updateLayer()
	self.data = {}
	for k,v in pairs(cfg.spacetimeevent.spacetimeevent) do
		if v.is_show == 1 then
			for index,value in pairs(ex.Player.exotic_adventure_data.unlock_event) do
				if value == v.event_id then
					table.insert(self.data,v)
				end
			end
		end
	end

	local function sort_table (a,b)
        return a.event_id < b.event_id
    end

    table.sort( self.data, sort_table ) 

	self.scroll_view.createItemFunction = function(data, scale)
		-- 创建ccbi cell
		local cell_layer = ExoticAdventureIllustratedBooksCell:createWithCCBIFile("ccbi/ExoticAdventureIllustratedBooksCell.ccbi")
		cell_layer:setIgnoreAnchorPointForPosition(false)
		cell_layer:setAnchorPoint(0.5, 0.5)
		cell_layer:setScale(scale)
		cell_layer:initData(data)
	
		return cell_layer
	end
	
	self.scroll_view:reloadData(self.data)

end


-----------------------------------------------------------------------------
function ExoticAdventureIllustratedBooksCtr:onCreate()
	self:setCCBIPath("ccbi/ExoticAdventureIllustratedBooksLayer.ccbi")
	self:setIsSingle(false)
end

function ExoticAdventureIllustratedBooksCtr:getLayerClass()
	return ExoticAdventureIllustratedBooksLayer
end

function ExoticAdventureIllustratedBooksCtr:getAchievementLayer()
	return self.layer
end

function ExoticAdventureIllustratedBooksCtr:openWindow()
	if self:isOpened() then
		return
	end
	self:loadLayer()
	self:open()
end

function ExoticAdventureIllustratedBooksCtr:initData()

end

return ExoticAdventureIllustratedBooksCtr
