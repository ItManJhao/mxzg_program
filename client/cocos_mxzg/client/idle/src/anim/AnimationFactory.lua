--
-- Author: windy
-- Date: 2018-06-14 14:59:15
--

local AnimationFactory = class()


function AnimationFactory:createAnimate(str_format, speed, more)
	local sfc = cc.SpriteFrameCache:getInstance()

	local i = 0
	local array = {}

	while true do
		local frame_name = string.format(str_format, i)

		local frame = sfc:getSpriteFrame(frame_name)
		if not frame then
			break
		end

		array[i] = frame 
		i = i + 1
	end

	-- 返回一个动作时间
	if more ~= nil then
		more[0] = speed * table.getn(array)
	end

	-- print("frame num: ", table.getn(array))

	local animation = cc.Animation:createWithSpriteFrames(array, speed)
	local animate = cc.Animate:create(animation)
	return animate
end

function AnimationFactory:createAnimateRepeatForever(plist, format, speed, more)
	local animate = self:createAnimate(plist, format, speed)
	return cc.RepeatForever:create(animate)
end

function AnimationFactory:allChildrenFade(node, time, opacity)
	local vec_children = node:getChildren()
	local len = table.getn(vec_children)
	for i=1,len do
		local child = vec_children[i]
		child:runAction(cc.FadeTo:create(time, opacity))
		self:allChildrenFade(child, time, opacity)
	end
	node:runAction(cc.FadeTo:create(time, opacity))
end


return AnimationFactory