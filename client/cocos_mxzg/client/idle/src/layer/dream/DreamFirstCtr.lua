-- DreamFirstLayerCtr

local DreamFirstCtr = class("DreamFirstCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local DreamFirstLayer = class("DreamFirstLayer", require("src.comp.EventLayerAdaptiveWidth"))
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

local string_format = string.format


------------------------------------------------

function DreamFirstLayer:onCreate()
	self:addBlackBackground()
    -- self:setAutoClose(false)
    -- self:setSwallowTouches(false)
	self.callback =nil
end

function DreamFirstLayer:initDone()

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/dream.plist")
	sfc:addSpriteFrames("ccbi-res/dream-lang.plist")

	self.btn_get:registerScriptTapHandler(handler(self, self.onGetFirst))

	self:setRewardList()
end


function DreamFirstLayer:onGetFirst(tag , pSender)
        
	local reward_config = ex.Player.dream_data:showNowFirstReward()

    if not reward_config or ex.Player.dream_data.max_lv < reward_config.idx then 
        ex.MessageView:add(ex.Tools:getLang(47582))
        return
    end 
	
	-- 检测领取那个
    ex.Player.dream_data:gReqDreamlandGetLevel(reward_config.idx)

	if self.callback then 
		self.callback()
	end 
	
end 

function DreamFirstLayer:setClose( callback)
	self.callback = callback;
end

function DreamFirstLayer:setRewardList( )

	-- 获得当前官卡
	local reward_config = ex.Player.dream_data:showNowFirstReward()

	if not reward_config then
		self.lab1:setVisible(false)
		self.btn_get:setVisible(false)
	elseif ex.Player.dream_data.max_lv < reward_config.idx then 
		self.lab1:setVisible(true)
		self.btn_get:setVisible(false)
	else 
		self.lab1:setVisible(false)
		self.btn_get:setVisible(true)
	end 

	self:createMenuWithItem()

end

function DreamFirstLayer:createMenuWithItem()
	-- body
	local reward_config = ex.Player.dream_data:showNowFirstReward()
	if not reward_config then
		return
	end

    local menu = cpp.UIMenu:create()
    self.item_bg:addChild(menu)
    menu:setPosition(0,0)
    local UIItemBackpack = require("src.comp/menu/UIMenuItemBackpack")
    local begin = 24
    local margin = 5
    local posY = 68
	local scale = 1
	
	local size = #reward_config.reward * (margin + 106) / 2 
	local max_width = self.item_bg:getContentSize().width / 2
	begin = max_width - size 
    for i,v in ipairs(reward_config.reward) do
        local item = ex.Player.backpack_data:createWithData(v.item_type, v.item_num)
        local posX = (begin + item:getContentSize().width * scale / 2) + (i - 1) * ((item:getContentSize().width * scale) + margin) 

		item:setPosition(posX, posY)
        item:setScale(scale)
        item:registerScriptTapHandler(handler(self, self.onClick))
        menu:addChild(item)
	end
	
end

function DreamFirstLayer:onClick(tag,pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end


function DreamFirstLayer:onShowInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

------------------------------------------------

function DreamFirstCtr:onCreate()
	self:setCCBIPath("ccbi/DreamFirstLayer.ccbi")
	self:setIsSingle(false)
end

function DreamFirstCtr:getLayerClass()
	return DreamFirstLayer
end

function DreamFirstCtr:openWindow()
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
    self.layer:initDone()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	self.layer:setClose(handler(self, self.closeWindow))

end

return DreamFirstCtr











