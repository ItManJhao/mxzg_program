
-- 用九宫格实现的伪进度条
-- type : 1 横向， type：2 纵向

local UIScale9SpriteEx = class("UIScale9SpriteEx", function(...)
								    local params = {...}
    								local c = #params
									local tmp_node
    								if c == 0 then
    									tmp_node = ccui.Scale9Sprite:create()
    								else
    									tmp_node = ccui.Scale9Sprite:createWithSpriteFrameName(...)
    								end
								-- ccui.Scale9Sprite:createWithSpriteFrameName("fetters/jdt3.png", cc.rect(16, 16, 1, 1))
								-- tmp_node.old_setContentSize = tmp_node.setContentSize
                                return tmp_node
                            end)

function UIScale9SpriteEx:ctor(...)
	self.type = 1
	self.percentage = 0
	self.size = cc.size(0, 0)

	-- self.old_setContentSize = ccui.Scale9Sprite.setContentSize
	self.old_setContentSize = cc.Node.setContentSize
	-- print("11111", self.old_setContentSize)
	-- self.()
end

function UIScale9SpriteEx:setContentSize( ... )
	self.size = ...
end

function UIScale9SpriteEx:setType(type)
	self.type = type
end

function UIScale9SpriteEx:setPercentage(percentage)
	self.percentage = percentage
	self:updatePercentage()
end

function UIScale9SpriteEx:getPercentage(percentage)
	return self.percentage
end

function UIScale9SpriteEx:updatePercentage()
	local percentage = Maths.clampf(self.percentage, 0, 100) * 0.01
	if self.type == 1 then
		-- print("xxx", percentage, self.size.width * percentage)
		self.old_setContentSize(self, cc.size(self.size.width * percentage, self.size.height))
	else
		self.old_setContentSize(self, cc.size(self.size.width, self.size.height * percentage))
	end
end

return UIScale9SpriteEx
