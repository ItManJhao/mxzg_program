local RankCtr = class("RankCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local RankLayer = class("RankLayer", require("src.comp.EventLayer"))

--------------------------------------------

function RankLayer:onCreate()
    self:addBlackBackground()
	self:setExitCallback(handler(self,self.onExitCB))
end

function RankLayer:onExitCB()

end

function RankLayer:init(data)
    self.tableView = ex.Tools:initTableView(self,data.rank_list, data.obj , data.size, data.margin ,cc.p(40,160))

    if data.my_data then
        self.myRank = data.obj[1]:createWithCCBIFile(data.obj[2])
        self.myRank:reset(data.my_data)
        self.spr_my_bg:addChild(self.myRank)
        self.myRank:setAnchorPoint(cc.p(0,0))
        self.myRank:setPosition(cc.p(10,5))
    end
end

-----------------------------------------------------------------------------
function RankCtr:onCreate()
	self:setCCBIPath("ccbi/RankLayer.ccbi")
	self:setIsSingle(false)
end

function RankCtr:getLayerClass()
	return RankLayer
end

function RankCtr:getRankLayer()
	return self.layer
end

function RankCtr:openWindow(data)
	if self:isOpened() then
		return
	end
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/dungeon.plist")
    sfc:addSpriteFrames("ccbi-res/rank.plist")
	self:loadLayer()
	self:open()
	self:initData(data)
end

function RankCtr:initData(data)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    
	self:updateLayer(data)
end

function RankCtr:onClickUpgrade(tag,pSender)

end

function RankCtr:updateLayer(data)
    -- dump(data)
	local layer = self.layer
    layer.tableView = layer:init(data)
    -- dump(layer.tableView)
end

return RankCtr
