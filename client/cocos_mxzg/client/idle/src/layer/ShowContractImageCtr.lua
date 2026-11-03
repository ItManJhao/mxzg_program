-- 

local ShowContractImageLayer = class("ShowContractImageLayer", require("src.comp.EventLayer"))
local ShowContractImageCtr = class("ShowContractImageCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))


-----------------------------------------------------------------------------
function ShowContractImageLayer:onCreate()

    self:setAutoClose(true)
    self:setSwallowTouches(false)
    self:addBlackBackground()

	self:addTimer("timer",1600,handler(self,self.updateTimer),true)


	local qyjs = sp.SkeletonAnimation:create("spine/qyjs.json","spine/qyjs.atlas", 1)
    qyjs:setAnimation(0, "stand", true);
    qyjs:setPosition(0,0)
	self.show_spine:addChild(qyjs)
	
	-- tianjia daojishi 

end 


function ShowContractImageLayer:updateTimer( )
		
	self:removeTimerByName("timer")
	require("src.layer.ShowContractImageCtr"):instance():closeWindow()
	
end



-----------------------------------------------------------------------------
function ShowContractImageCtr:onCreate()
	self:setCCBIPath("ccbi/ShowContractImageLayer.ccbi")
	self:setIsSingle(false)
end

function ShowContractImageCtr:getLayerClass()
	return ShowContractImageLayer
end

function ShowContractImageCtr:getShowContractImageLayer()
	return self.layer
end


function ShowContractImageCtr:openWindow(data)
	if self:isOpened() then
		return
	end
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/contract.plist")
    sfc:addSpriteFrames("ccbi-res/contract-lang.plist")

	self:loadLayer()
	self:open()
	self:initData(data)
end

function ShowContractImageCtr:initData(data)
    -- self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

	--self:updateLayer(data)
end

return ShowContractImageCtr