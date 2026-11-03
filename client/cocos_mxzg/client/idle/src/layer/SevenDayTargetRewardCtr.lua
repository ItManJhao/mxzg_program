local SevenDayTargetRewardCtr = class("SevenDayTargetRewardCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local SevenDayTargetRewardCell = class("SevenDayTargetRewardCell", require("src.comp.LuaLayerBase"))

local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function SevenDayTargetRewardCell:onCreate()
	--print("SevenDayTargetRewardCell:onCreate")
	self:setAutoClose(true)
	self:addBlackBackground()

	self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)

	self.btn_confirm:setLabelText(ex.Tools:getLang(11)) -- 确定
	self.btn_confirm:setLabelColor(ex.c3b.WHITE)
	
    local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_reward")
    spr_effect:setPosition(self.spr_title:getPositionX() - 9, self.spr_title:getPositionY() - 10)
    self:addChild(spr_effect, 20, 100)
end

-----------------------------------------------------------------------------
function SevenDayTargetRewardCtr:onCreate()
	self:setCCBIPath("ccbi/SevenDayTargetRewardCell.ccbi")
	self:setIsSingle(false)
end


function SevenDayTargetRewardCtr:getLayerClass()
	return SevenDayTargetRewardCell
end

function SevenDayTargetRewardCtr:openWindow(awardList, callback)
	if self:isOpened() then
		return
	end

	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/reward-layer.plist")

	self.callback = callback or nil
	self:loadLayer()
	self:open()
	self:initAward(awardList,callback)
	print(self.__cname)
end


function SevenDayTargetRewardCtr:initAward(awardList, callback)
	self.callback = callback

	local awardCount = #awardList
	if type(awardList) ~= "table" or awardCount == 0 then
		self:onCallback()
		return
	end

	self.awardList = awardList

	local sfc = cc.SpriteFrameCache:getInstance()

    self:initDone()

    
end

function SevenDayTargetRewardCtr:initDone()

	self:initCell()

	self.node_list = {}

	local num = 0
	for _,v in pairs(self.awardList) do

			self:getBackpack(v)
		
		num = num + 1
	end

	self:updateView(num)


end

function SevenDayTargetRewardCtr:initCell()

	self.item_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()
    self.item_size = cc.size(self.item_size.width + 33, self.item_size.height + 31)
    
    self.viewSize = self.layer:getContentSize()

	self.award_node = cc.Node:create()
	self.layer:addChild(self.award_node)
	
end

function SevenDayTargetRewardCtr:getBackpack(backpack)
	local node = ex.Player.backpack_data:createWithData(backpack.item_type, backpack.item_num)
	self.award_node:addChild(node)
	table.insert(self.node_list, node)
end


function SevenDayTargetRewardCtr:updateView(num)
	-- 求最大列数
	local col = math.min(5, num)
    local row = math.ceil(1.0 * num / col) -- 行数

    local start = cc.p(self.viewSize.width * 0.5 - self.item_size.width * (col - 1) * 0.5,
    	self.viewSize.height * 0.5 + self.item_size.height * (row - 1) * 0.5)
    start.y = start.y + 15 -- 向上偏移按钮的坐标

    local index = 0
    for _,v in pairs(self.node_list) do
    	local x = index % col
        local y = math.floor(index / col)

        local pos = cc.p(start.x + x * self.item_size.width, start.y - y * self.item_size.height)
		v:setPosition(pos)
		index = index + 1
	end
end

function SevenDayTargetRewardCtr:onCallback()
	if self.callback then
		self.callback()
	end

	self:close()
end

function SevenDayTargetRewardCtr:onClose(tag, pSender)
	self:onCallback()
end

return SevenDayTargetRewardCtr
