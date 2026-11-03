local PROMpveSweepCtr = class("PROMpveSweepCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PROMpveSweepLayer = class("PROMpveSweepLayer", require("src.comp.LuaLayerBase"))

local string_format = string.format
function PROMpveSweepLayer:onCreate()
	self:addBlackBackground()
	-- local info_ctr = PROMpveSweepCtr:instance()
	-- self.btn_close:registerScriptTapHandler(handler(info_ctr, info_ctr.closeWindow))
end


-----------------------------------------------------------------------------
function PROMpveSweepCtr:onCreate()
	self:setCCBIPath("ccbi/PROMpveSweepLayer.ccbi")
	self:setIsSingle(false)

	self.now_index = 1
end


function PROMpveSweepCtr:getLayerClass()
	return PROMpveSweepLayer
end

function PROMpveSweepCtr:openWindow(callback)
	if self:isOpened() then
		return
	end

	self.callback = callback or nil
	self:loadLayer()
	self:open()
	self:initDone()
end

function PROMpveSweepCtr:initDone()
	self.now_index = 1
	if self.now_index > self:getMax() then 
		self.now_index = self:getMax()
	end 

	local str_text = ex.Tools:getLang(52312)
	local text_obj = cc.Label:createWithTTF(str_text, FONT_DEFAULT_NAME_BOLD, 36)
	text_obj:setScale(0.6)
	self.layer.btn_submit:addChild(text_obj)
	text_obj:setPosition(self.layer.btn_submit:getContentSize().width * 0.5, self.layer.btn_submit:getContentSize().height * 0.5)
	text_obj:setTextColor(FONT_BLACK_C4B)
	--text_obj:enableOutline(FONT_RED, 3)

	self.layer.btn_submit:registerScriptTapHandler(handler(self,self.onSubmit))
	self.layer.btn_close:registerScriptTapHandler(handler(self,self.closeWindow))

	self.layer.btn_sub2:registerScriptTapHandler(handler(self,self.onSubAll))
	self.layer.btn_sub1:registerScriptTapHandler(handler(self,self.onSubOne))

	self.layer.btn_add1:registerScriptTapHandler(handler(self,self.onAddOne))
	self.layer.btn_add2:registerScriptTapHandler(handler(self,self.onAddAll))

	self.layer.lbl_reward_tip:setString(ex.Tools:getLang(52316))
	--ex.Tools:setSpriteFrame(self.layer.spr_icon, config.icon .. ".png")
	--self.layer.btn_enter:registerScriptTapHandler(handler(self,self.onOpen))

	-- use_item_image
	local ori_item_data =  ex.Tools:getSysCfg("promotion_pve_fight_need_item") 
    local spr_icon = cc.Sprite:createWithSpriteFrameName(string_format("backpack/%d.png", ori_item_data[1].item_type))
    self.layer.use_item_image:addChild(spr_icon)
    spr_icon:setScale(0.6)
    spr_icon:setPosition( spr_icon:getContentSize().width * 0.2,spr_icon:getContentSize().height * 0.2 )

	
	self.layer.lbl_num:setString(ex.Player:getItemNum(ori_item_data[1].item_type) )

	self:setIndex()

end

function PROMpveSweepCtr:getMax( )
	local ori_item_data =  ex.Tools:getSysCfg("promotion_pve_fight_need_item") 
	return ex.Player:getItemNum(ori_item_data[1].item_type)
end


function PROMpveSweepCtr:setIndex( )
	self.layer.lbl_select_num:setString(self.now_index)
end

function PROMpveSweepCtr:onSubOne(tag,pSender)
	self.now_index = self.now_index - 1 
	self.now_index = self.now_index < 0 and 0 or self.now_index
	self:setIndex()
end

function PROMpveSweepCtr:onSubAll(tag,pSender)
	self.now_index = 1 
	self:setIndex()
end

function PROMpveSweepCtr:onAddOne(tag,pSender)
	local max_num = self:getMax()
	self.now_index = self.now_index + 1 
	self.now_index = self.now_index >= max_num and max_num or self.now_index
	self:setIndex()
end

function PROMpveSweepCtr:onAddAll(tag,pSender)
	local max_num = self:getMax()
	self.now_index = max_num
	self:setIndex()
end

function PROMpveSweepCtr:onSubmit(tag,pSender)
	-- 扫荡
	--判断数量是否足够

	self:closeWindow()

	if self.callback then 
		self.callback(self.now_index)
	end 
	
end

return PROMpveSweepCtr

