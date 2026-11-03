-- 创建一个文字气泡
-- 角标会指向锚点

local UISpriteBubble = class("UISpriteBubble", function()
                                return cc.Node:create()
                            end)

UISpriteBubble.setAnchorPointOld = cc.Node.setAnchorPoint

function UISpriteBubble:createWithText(text, dimensions)
   	local pRet = UISpriteBubble:create()
	if pRet then
		pRet:onInit(text, dimensions)
		return pRet
	end
	pRet = nil
	return nil
end

function UISpriteBubble:ctor()
   
end

function UISpriteBubble:onInit(text, dimensions)
	self:setIgnoreAnchorPointForPosition(false)

	-- 暂时取屏幕宽度的0.9
    local win_size = cc.Director:getInstance():getWinSize()
	local margin = 33
	local margin_text = 20

    -- -- 生成文字
	-- local lbl_bubble = cc.Label:createWithTTF(text, FONT_DEFAULT_NAME_BOLD, 50)
    -- lbl_bubble:setScale(0.5)
    -- lbl_bubble:setAnchorPoint(cc.p(0.5, 1))
	-- lbl_bubble:setTextColor(FONT_BROWN)
	-- lbl_bubble:enableOutline(ex.c3b.WHITE, 1)
	local lbl_bubble = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(50)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#5A3509")
	:setScale(0.5)
	-- :setContentSize(cc.size(self.viewSize.width  / 0.5, self.viewSize.height / 0.5))
	-- :setPosition(cc.p(self.viewSize.width * 0.5, self.viewSize.height))
	:setAnchorPoint(cc.p(0.5, 1))
    -- lbl_bubble:setScale(99)
    self:addChild(lbl_bubble, 1)

	if dimensions then
		lbl_bubble:ignoreContentAdaptWithSize(false)
		:setWrapMode(1)
		:setContentSize(cc.size(dimensions.width  / 0.5, dimensions.height / 0.5))
	end

	lbl_bubble:setXmlTextLua(text)
	lbl_bubble:formatText()
	-- 计算宽度
	local max_width = win_size.width * 0.9
	max_width = math.min(lbl_bubble:getContentSize().width * lbl_bubble:getScale() + 10, max_width)
	print("max_width", max_width, lbl_bubble:getContentSize().width * lbl_bubble:getScale())


    -- 设置最大宽度
    -- lbl_bubble:setDimensions(max_width / lbl_bubble:getScale(), 0)

    -- 设置自身大小
    self:setContentSize(max_width + margin * 2 + margin_text * 2, lbl_bubble:getContentSize().height * lbl_bubble:getScale() + margin * 2 + margin_text * 2)

    -- 设置文字位置
    -- lbl_bubble:setPosition(cc.p(self:getContentSize().width * 0.5 - margin - margin_text, self:getContentSize().height - margin - margin_text))
	lbl_bubble:setPosition(cc.p(self:getContentSize().width * 0.5, self:getContentSize().height - margin - margin_text))

	-- 生成气泡背景
	self.spr_bubble = ccui.Scale9Sprite:createWithSpriteFrameName("other/spr-bubble-4.png", cc.rect(16, 16, 1, 1))
	self.spr_bubble:setContentSize(cc.size(self:getContentSize().width - margin * 2, self:getContentSize().height - margin * 2))
	-- self.spr_bubble:setPosition(cc.p(self:getContentSize().width * 0.5 - margin - margin_text, self:getContentSize().height * 0.5))
	self.spr_bubble:setPosition(cc.p(self:getContentSize().width * 0.5 , self:getContentSize().height * 0.5))
	self:addChild(self.spr_bubble)

	-- 角标
	self.spr_foot = cc.Sprite:createWithSpriteFrameName("other/spr-foot-1.png")
	self.spr_foot:setAnchorPoint(cc.p(0, 0))
	-- self.spr_foot:setPosition(10, 5)
	self.spr_foot:setPosition(margin + margin_text + 10, 5)
	self:addChild(self.spr_foot)
	
	self:setAnchorPoint(cc.p(self.spr_foot:getPositionX() / self:getContentSize().width, 0))
	-- self:setAnchorPoint(cc.p(0.3, 1))
end

function UISpriteBubble:setAnchorPoint(point)

	print("point", point.x, point.y)
	-- 设置角标的位置
	local offset_x = 0.5 - point.x
	local offset_y = 0.5 - point.y

	-- 偏移位置
	local add_x = 0
	local add_y = 0
	local rotation = 0

	-- if math.abs(offset_x) < math.abs(offset_y) then
	-- 	-- x轴任意位置。y锁定在0和1
	-- 	offset_x = 0.5
	-- 	offset_y = point.y
	-- else
	-- 	print("11")
	-- 	-- y轴任意位置。x锁定在0和1
	-- 	offset_x = offset_x > 0 and 0 or 1
	-- 	offset_y = offset_x > 0 and 1 or 0
	-- end
	-- print("point", offset_x, offset_y)
	local fit_y = math.abs(offset_x) < math.abs(offset_y)
	if fit_y then
		-- x轴任意位置。y锁定在0和1

		-- print("11")
		rotation = offset_y > 0 and 0 or (-180)
		add_y = offset_y > 0 and 5 or -5
	else
		print("22")
		-- y轴任意位置。x锁定在0和1
		offset_x = offset_x > 0 and 0 or 1
		offset_y = offset_x > 0 and 1 or 0
		rotation = offset_y > 0 and -90 or (90)
		add_x = offset_y > 0 and -5 or 5
	end
	print("point", offset_x, offset_y)


	-- 设置角标的位置
	self.spr_foot:setRotation(rotation)
	-- self.spr_foot:setAnchorPoint(cc.p(offset_x, offset_y))
	self.spr_foot:setPosition(self:getContentSize().width * point.x + add_x, self:getContentSize().height * point.y + add_y)
	self:setAnchorPointOld(cc.p(point.x, point.y))
end

return UISpriteBubble
