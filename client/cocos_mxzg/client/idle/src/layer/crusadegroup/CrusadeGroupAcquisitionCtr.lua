local CrusadeGroupAcquisitionCtr = class("CrusadeGroupAcquisitionCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local CrusadeGroupAcquisitionLayer = class("CrusadeGroupAcquisitionLayer", require("src.comp.EventLayerAdaptiveWidth"))

function CrusadeGroupAcquisitionLayer:onCreate()
    self:addBlackBackground()
    
    self.scroll_view:setItemSize(cc.size(95, 95))
end

function CrusadeGroupAcquisitionLayer:onConfirm()
    CrusadeGroupAcquisitionCtr:instance():closeWindow()
end

-----------------------------------------------------------------------------
function CrusadeGroupAcquisitionCtr:onCreate()
	self:setCCBIPath("ccbi/CrusadeGroupAcquisitionLayer.ccbi")
	self:setIsSingle(false)
end

function CrusadeGroupAcquisitionCtr:getLayerClass()
	return CrusadeGroupAcquisitionLayer
end

function CrusadeGroupAcquisitionCtr:getCrusadeGroupAcquisitionLayer()
	return self.layer
end

function CrusadeGroupAcquisitionCtr:openWindow(data)
	if self:isOpened() then
		return
	end
	
	self:loadLayer()
    self:open()

    self:initData(data)
end

function CrusadeGroupAcquisitionCtr:initData(data)
    self.layer.lbl_time:setString(ex.Tools:formatTime3(ex.Game:getServerTime() - ctr.crusade_group.data.last_acquisition_time_old))
    self.layer.scroll_view.createItemFunction = function(data, scale)
        local item = ex.Tools:createBackpackItem(data.id, data.num)
        item:setScale(0.8)
        item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
        return item
    end
    self.layer.scroll_view:reloadData(data.shenBin)

    self.layer.lbl_res_num:setString(data.force_nature)
end

return CrusadeGroupAcquisitionCtr
