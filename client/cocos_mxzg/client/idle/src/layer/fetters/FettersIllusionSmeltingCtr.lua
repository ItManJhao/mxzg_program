--[[
* @Description: 羁绊幻化- 熔炼
* @Author: 熊梦
* @Date: 2020-07-21 16:40:00
* ]]
local FettersIllusionSmeltingCtr = class("FettersIllusionSmeltingCtr",require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local FettersIllusionSmeltingLayer = class("FettersIllusionSmeltingLayer",require("src.comp.EventLayerAdaptiveWidth"))

function FettersIllusionSmeltingLayer:onCreate()
    self:addBlackBackground()
    self:registerBtnEvent()
    self:inidata()
end

function FettersIllusionSmeltingLayer:inidata(  )
	local config = cfg.goddessfashiontype.goddessfashiontype[2].need_item[1]

	self.spr_icon:setSpriteFrame(string.format("%s.png", cfg.item.item[config.item_type].icon))
	self.btn_iteminfo.item_type = config.item_type
	self.btn_iteminfo:setContentSize(cc.size(self.spr_icon:getContentSize().width * self.spr_icon:getScaleX(), 
	self.spr_icon:getContentSize().height * self.spr_icon:getScaleY()))

	for i,v in ipairs(cfg.goddessfashiontype.goddessfashiontype) do
		if v.type == 2 then
			self.lbl_num:setString(ex.Player:getItemNum(v.need_item[1].item_type))
			break
		end
	end

	-- 是否添加道具
	self.isItem = false

	self:addEvent(EVENT.FETTER_EVENT.ILLUSION_UPDATE_ITEM,handler(self,self.updataItemNum))

	self:checkIllusionReddot()
end

function FettersIllusionSmeltingLayer:checkIllusionReddot()
	local origin_config = cfg.goddessfashionsmelt.goddessfashionsmelt[1].origin_item[1]
	local target_config = cfg.goddessfashionsmelt.goddessfashionsmelt[1].target_item[1]
	local origin_num = ex.Player:getItemNum(origin_config.item_type)
	local target_num = math.floor((origin_num / origin_config.item_num) * target_config.item_num)
	local is_visible = true
	if target_num <= 0 then
		is_visible = false
	end
	ex.Tools:addRedPoint(self.btn_add, is_visible, cc.p(0.95, 0.85))
end

function FettersIllusionSmeltingLayer:updataItemNum()
	self:checkIllusionReddot()
	for i,v in ipairs(cfg.goddessfashiontype.goddessfashiontype) do
		if v.type == 2 then
			self.lbl_num:setString(ex.Player:getItemNum(v.need_item[1].item_type))
			return
		end
	end
end

function FettersIllusionSmeltingLayer:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-- 关闭按钮
function FettersIllusionSmeltingLayer:registerBtnEvent( )
	local ctr = FettersIllusionSmeltingCtr:instance()
	self.btn_close:registerScriptTapHandler(handler(ctr, ctr.closeWindow))
end

function FettersIllusionSmeltingLayer:onAdd( )

--	if self.isItem then ex.MessageView:add(ex.Tools:getLang(76219)) end

	local origin_config = cfg.goddessfashionsmelt.goddessfashionsmelt[1].origin_item[1]
	local target_config = cfg.goddessfashionsmelt.goddessfashionsmelt[1].target_item[1]
	local origin_num = ex.Player:getItemNum(origin_config.item_type)
	local target_num = math.floor((origin_num / origin_config.item_num) * target_config.item_num) 

	if origin_num <= 0 then
		ex.MessageView:add(ex.Tools:getLang(76219))
		return
	else
		self.menu_item:removeAllChildren()
		local origin_item = ex.Tools:createBackpackItem(origin_config.item_type, origin_num)
		origin_item:setScale(0.9)
		origin_item:setPositionX(-118)
		origin_item:registerScriptTapHandler(handler(self, self.onItemInfo))
		self.menu_item:addChild(origin_item)
	
		local target_item = ex.Tools:createBackpackItem(target_config.item_type, target_num)
		target_item:setScale(0.9)
		target_item:setPositionX(134)
		target_item:registerScriptTapHandler(handler(self, self.onItemInfo))
		self.menu_item:addChild(target_item)
		self.isItem = true
	end

end

function FettersIllusionSmeltingLayer:onSure( )
	if not self.isItem then ex.MessageView:add(ex.Tools:getLang(76220)) return end
	local origin_config = cfg.goddessfashionsmelt.goddessfashionsmelt[1].origin_item[1]
	local target_config = cfg.goddessfashionsmelt.goddessfashionsmelt[1].target_item[1]
	local origin_num = ex.Player:getItemNum(origin_config.item_type)
	local req = Fetter_pb.GReqFashionSmelt()
	req.idx = 1
	req.num = origin_num
	NetManager:sendMessage(ProtocolID.GReqFashionSmelt, req)
	self.isItem = false
	self.menu_item:removeAllChildren()
end
-----------------------------------------------------------------------------
function FettersIllusionSmeltingCtr:onCreate()
	self:setCCBIPath("ccbi/FettersIllusionSmeltingLayer.ccbi")
	self:setIsSingle(false)
end

function FettersIllusionSmeltingCtr:getLayerClass()
	return FettersIllusionSmeltingLayer
end

function FettersIllusionSmeltingCtr:openWindow()
	if self:isOpened() then
		return
	end
	self:loadLayer()
	self:open()
end

function FettersIllusionSmeltingCtr:initData()

end

return FettersIllusionSmeltingCtr
