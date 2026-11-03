--[[
* @Description: 评论有礼界面
* @Author: 熊梦
* @Date: 2020-04-16 15:42:00
* ]]

local DiscussCtr = class("DiscussCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local DiscussLayer = class("DiscussLayer", require("src.comp.EventLayerAdaptiveWidthFull"))
local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

-----------------------------------------------------------------------
local Propinterval = 110   --道具之间的间隔
local PropLeftPosX = 360   --最左边的横坐标
local PropLeftPosY = 260   --纵坐标 所有道具纵坐标相同
local PropScale = 0.85	   --道具缩放比例
-- 所有道具的位置 从左到右 通过上述值控制
local PropPos = {
	cc.p(PropLeftPosX,PropLeftPosY),
	cc.p(PropLeftPosX+Propinterval,PropLeftPosY),
	cc.p(PropLeftPosX+2*Propinterval,PropLeftPosY),
}

-----------------------------------------------------------------------

function DiscussLayer:onCreate()
	self:addBlackBackground()
	self:registerBtnEvent()

	self.layer_type = 0

	
	-- local vec_Prop = ex.Tools:getSysCfg("comments_reward")

	--[["<var>" = {
	     1 = {
	         "item_num"  = 3
	         "item_type" = 901815
	     }
	     2 = {
	         "item_num"  = 1
	         "item_type" = 910200
	    }
	     3 = {
	         "item_num"  = 1
	         "item_type" = 901814
	     }
	 }]]

	--  cfg.commentsharedreward.commentsharedreward[]

	-- if next(ex.Player.comment_list) == nil then 
		local req = Role_pb.GReqCommentSharedComment()
		--完成类型100:app store 评价,200:facebook 评价,300:facebook 分享
		--评论类型暂时写死为 200 即为facebook 评价
		req.type = 200
		NetManager:sendMessage(ProtocolID.GReqCommentSharedComment, req)


		req.type = 100
		NetManager:sendMessage(ProtocolID.GReqCommentSharedComment, req)

		req.type = 300
		NetManager:sendMessage(ProtocolID.GReqCommentSharedComment, req)

	-- end 

	-- for i,v in ipairs(vec_Prop) do
	-- 	 local item = UIMenuItemBackpack:createWithData(v.item_type, v.item_num)
	-- 	 item:registerScriptTapHandler(handler(self, self.onItemInfo))
	-- 	 item:setPosition(PropPos[i])
	-- 	 item:setScale(PropScale)
	-- 	 self.PropMenu:addChild(item)
	-- end
end

function DiscussLayer:onItemInfo(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

-- 关闭按钮
function DiscussLayer:registerBtnEvent( )
	local discuss_ctr = DiscussCtr:instance()
	self.btn_close:registerScriptTapHandler(handler(discuss_ctr, discuss_ctr.closeWindow))
end


function DiscussLayer:updateLayer()

	local config = cfg.commentsharedreward.commentsharedreward[self.layer_type]
	if config then
		for i,v in ipairs(config.reward) do
			local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
			item:registerScriptTapHandler(handler(self, self.onItemInfo))
			item:setPosition(PropPos[i])
			item:setScale(PropScale)
			self.PropMenu:addChild(item)
	   end
	end

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/discuss.plist")
	
	ex.Tools:setSpriteFrame(self.btn_go:getNormalImage(), string.format("discuss/btn-go-%d.png", self.layer_type))
	ex.Tools:setSpriteFrame(self.btn_go:getSelectedImage(), string.format("discuss/btn-go-%d.png", self.layer_type))
	ex.Tools:setSpriteFrame(self.spr_bg, string.format("discuss/spr-bg-%d.png", self.layer_type))

	if next(ex.Player.comment_list) == nil and self.layer_type == 200 then
		local req = Role_pb.GReqCommentSharedComment()
		--完成类型100:app store 评价,200:facebook 评价,300:facebook 分享
		--评论类型暂时写死为 200 即为facebook 评价
		req.type = 200
		NetManager:sendMessage(ProtocolID.GReqCommentSharedComment, req)
	end

	-- if next(ex.Player.comment_list) == nil then 
	-- 	local req = Role_pb.GReqCommentSharedComment()
	-- 	--完成类型100:app store 评价,200:facebook 评价,300:facebook 分享
	-- 	--评论类型暂时写死为 200 即为facebook 评价
	-- 	req.type = 200
	-- 	NetManager:sendMessage(ProtocolID.GReqCommentSharedComment, req)
	-- end 
end

-- 立即前往
function DiscussLayer:onClickEventGo( )
	
	--完成类型100:app store 评价,200:facebook 评价,300:facebook 分享
	--评论类型暂时写死为 200 即为facebook 评价

	self:runAction(cc.Sequence:create(cc.DelayTime:create(2), cc.CallFunc:create(function()
		local req = Role_pb.GReqCommentSharedComment()
		req.type = self.layer_type
		NetManager:sendMessage(ProtocolID.GReqCommentSharedComment, req)

		local req = Role_pb.GReqCommentSharedReward()
		req.type = self.layer_type
		NetManager:sendMessage(ProtocolID.GReqCommentSharedReward, req)
	end)))
	
	if self.layer_type == 200 then
		-- 调用sdk，唤起评论窗口
		-- cpp.SocialPlatform:instance():discuss()
		if device.platform == "android" then
			-- cpp.SocialPlatform:instance():giftBag()
			cpp.SocialPlatform:instance():discuss()
		else
			ex.Tools:openComments()
		end
	elseif self.layer_type == 100 then
		cpp.SocialPlatform:instance():dz()
	elseif self.layer_type == 300 then
		cpp.SocialPlatform:instance():shareLink()
	end
	-- 隐藏大厅按钮
	-- if ex.MainSceneCtr:getCurLayerType() == MainSceneType.MAINCITY_LAYER then
	-- 	local layer = ex.MainSceneCtr:getCurLayer()
	-- 	layer.btn_discuss_gift:setVisible(false)
	-- end

	ex.Tools:setAllGrayAuto(self.btn_go, true)
	self.btn_go:setEnabled(false)
end

-----------------------------------------------------------------------------
function DiscussCtr:onCreate()
	self:setCCBIPath("ccbi/DiscussLayer.ccbi")
	self:setIsSingle(false)
end

function DiscussCtr:getLayerClass()
	return DiscussLayer
end

function DiscussCtr:getDiscussLayer()
	return self.layer
end

function DiscussCtr:openWindow(type)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self.layer.layer_type = type
	self.layer:updateLayer()
end

return DiscussCtr
