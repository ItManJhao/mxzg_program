local PromotionBaseLayer = class("PromotionBaseLayer", require("src.comp.EventLayer"))

function PromotionBaseLayer:resetScrollView(scroll_view, sub_size)
	-- 更改预设的大小（减法）。。固定值
	sub_size = sub_size or cc.size(0, 0)
	scroll_view = scroll_view or self.scroll_view

	if scroll_view and self.layer_promotion then
		local top_y = self.layer_promotion:getTopY()
		top_y = top_y - 20 - 106	-- banner高106
    	local win_size = cc.Director:getInstance():getWinSize()
    	scroll_view:setViewSize(cc.size(win_size.width * 0.9 - sub_size.width, top_y - self.layer_promotion:getBottomY() - sub_size.height - 40))
    	scroll_view:setPosition(win_size.width * 0.5 - scroll_view:getViewSize().width * 0.5, self.layer_promotion:getBottomY() + 40 - 5 + sub_size.height * 0.5)
	end
end

function PromotionBaseLayer:addBannerImage(config, is_big)
	if config == nil then
		print("PromotionBaseLayer:addBannerImage config is nil")
		return
	end
	if config.banner_plist ~= nil and config.banner_plist ~= "" then
		local sfc = cc.SpriteFrameCache:getInstance()
		sfc:addSpriteFrames(config.banner_plist)
	else 
		dump(config, "config plist not found")
	end

	self:removeChildByName("promotion_base_banner")
	self.spr_banner = cc.Sprite:createWithSpriteFrameName(string.format("promotion/spr-banner-%d.png", config.icon))
	if not self.spr_banner then
		print("promotion/spr-banner-"..config.icon..".png not found")
    	return
    end

	local top_y = self.layer_promotion:getTopY()
	top_y = top_y - 20 - 106		-- banner高106
	if is_big ~= nil and is_big == true then
		top_y = top_y - 41
	end

	local win_size = cc.Director:getInstance():getWinSize()
	
	self.spr_banner:setName("promotion_base_banner")
    self.spr_banner:setPosition(win_size.width * 0.5, top_y + self.spr_banner:getContentSize().height * 0.5)
	self.spr_banner:setScaleX(win_size.width / self.spr_banner:getContentSize().width)
	self:addChild(self.spr_banner)


	-- 该代码经过测试没问题
	-- local win_size = cc.Director:getInstance():getWinSize()
	-- local scale = win_size.width / self.spr_banner:getContentSize().width

	-- local top_y = self.layer_promotion:getTopY()
	-- top_y = top_y

    -- self.spr_banner:setPosition(win_size.width * 0.5, top_y - self.spr_banner:getContentSize().height * 0.5 * scale)
	-- self.spr_banner:setScale(scale)
	-- self:addChild(self.spr_banner)



	ex.Tools:try(function()
		self:reseBannerLabel()
	end)

	return self.spr_banner
end

-- 设置广告版上面显示的文字
function PromotionBaseLayer:reseBannerLabel()
	-- for i=1,100 do
	-- 	local lbl = self["lbl_auto_set"..i]
	-- 	if not lbl then
	-- 		break
	-- 	end

	-- 	local str = lbl:getString()
	-- 	if string.sub(str, 1, 2) == "##" then
	-- 		-- print("11111", string.dump(self.addBannerImage))
	-- 		local func = loadstring(string.sub(str, 3)) --将字符串转换为函数
	-- 		local aa = func()
	-- 		aa(lbl) 
	-- 		print("reseBannerLabel")
	-- 	end
	-- 	-- local func = loadstring(func_content) --将字符串转换为函数
	-- 	-- func()
	-- end

	if self.node_banner and self.spr_banner then
		-- print("222")
		self.node_banner:retain()
		self.node_banner:removeFromParentAndCleanup(false)
		self.node_banner:setPosition(self.spr_banner:getContentSize().width * 0.5,  self.spr_banner:getContentSize().height * 0.5)
		self.spr_banner:addChild(self.node_banner)
		self.node_banner:release()

	end
end

function PromotionBaseLayer:addVipExpCell(y)
	if y == nil then
		local top_y = self.layer_promotion:getTopY()
		y = top_y - 20 - 106
	end

	local win_size = cc.Director:getInstance():getWinSize()
	local cell = require("src.layer.promotion.RCGVipCell"):createWithCCBIFile("ccbi/RCGVipCell.ccbi")
	cell:setPosition(win_size.width * 0.5 - cell:getContentSize().width * 0.5, y)
	self:addChild(cell)
	return cell
end



function PromotionBaseLayer:addTimeProgress()
	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/promotion.plist")

    local top_y = self.layer_promotion:getTopY()

	local win_size = cc.Director:getInstance():getWinSize()
	
	self.time_node = cc.Node:create()
	self.time_node:setPosition(win_size.width, top_y - 21)
	self.time_node:setScale(win_size.width / 640)
	self.time_node:setLocalZOrder(10)
	self:addChild(self.time_node)

    self.time_bg = cc.Sprite:createWithSpriteFrameName("promotion/spr-text-bg.png")
	self.time_bg:setAnchorPoint(ex.a.right_center)
    self.time_bg:setPosition(ex.p.zero)
    self.time_node:addChild(self.time_bg)

	self.time_text = cpp.RichTextEx:createWithXMLLua("")
	self.time_text:setFontSize(36)
	self.time_text:setScale(0.5)
	self.time_text:setFontFace(FONT_DEFAULT_NAME_BOLD)
	self.time_text:setFontColor("#ffffff")
	self.time_text:setAnchorTextShadow(false)
	self.time_text:setAnchorPoint(ex.a.right_center)
    self.time_text:setPosition(ex.Tools:getAbsolutePosition(cc.p(5, 0), CommonUIDefine.UIDefine.ComponentOriginType.RIGHT_TOP, self.time_node))
    self.time_text:setLocalZOrder(10)
	self.time_node:addChild(self.time_text)
end


return PromotionBaseLayer
