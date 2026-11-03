local VideoStudioRecordCtr = class("VideoStudioRecordCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local VideoStudioRecordLayer = class("VideoStudioRecordLayer", require("src.comp.LuaLayerBase"))

function VideoStudioRecordLayer:onCreate()
	self:addBlackBackground()
	self.lbl_title:setString(ex.Tools:getLang(73008))
	self.lbl_tips:setString(ex.Tools:getLang(73006))
	self:registerBtnEvent()
	self:createTableView()
end

function VideoStudioRecordLayer:registerBtnEvent( )
	-- self.btn_record:registerScriptTapHandler(handler(self, self.onRecord))
	-- self.btn_saved:registerScriptTapHandler(handler(self, self.onSaved))
	self.btn_close:registerScriptTapHandler(handler(self, self.onClose))
	-- for i=1,4 do
	-- 	local btn = self["btn_"..i]
	-- 	btn:registerScriptTapHandler(handler(self, self.onChangeLayer))
	-- 	btn:setTag(i)
	-- 	local str = ex.Tools:getLang(73001 + i)
	-- 	btn:setLabelText(str)
	-- end	
end

function VideoStudioRecordLayer:onChangeLayer(tag,pSender)
	print(self.__cname,tag)
end

function VideoStudioRecordLayer:createTableView( )
	self.cell_data = {}
    for i=1,10 do
        table.insert(self.cell_data,i)
    end

    local size = self.spr_bg:getContentSize()
    
    self.tableView = ex.Tools:initTableView(self.spr_bg,self.cell_data, {require("src.layer.videostudio.VideoStudioCell"),"ccbi/VideoStudioCell.ccbi"} , cc.size(size.width,size.height - 15), 10,cc.p(0,5))
	self.tableView:initData(self.cell_data)
end

function VideoStudioRecordLayer:onSaved(tag,pSender)
    
end

function VideoStudioRecordLayer:onRecord(tag,pSender)
    
end

function VideoStudioRecordLayer:onClose(tag,pSender)
    VideoStudioRecordCtr:instance():closeWindow()
end


-----------------------------------------------------------------------------
function VideoStudioRecordCtr:onCreate()
	self:setCCBIPath("ccbi/VideoStudioRecordLayer.ccbi")
	self:setIsSingle(false)
end

function VideoStudioRecordCtr:getLayerClass()
	return VideoStudioRecordLayer
end

function VideoStudioRecordCtr:getPvpEndLayer()
	return self.layer
end

function VideoStudioRecordCtr:openWindow()
	if self:isOpened() then
		return
	end

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/summon-effect.plist")
	sfc:addSpriteFrames("ccbi-res/hero-select.plist")

	self:loadLayer()
	self:open()
	-- self:initData(is_win, enemy_id, vec_reward, ext, callback)
end

function VideoStudioRecordCtr:initData(is_win, enemy_id, vec_reward, ext, callback)

	
end


return VideoStudioRecordCtr
