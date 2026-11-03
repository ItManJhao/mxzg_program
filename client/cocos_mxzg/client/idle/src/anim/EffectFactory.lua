--
-- Author: windy
-- Date: 2018-06-14 14:59:15
--

local EffectFactory = class("EffectFactory", require("src.common.SingleInstance"))

local res_manager = require("src.model.ResManager"):instance() 
--[[创建动画
	@param plist: 加载动作纹理
	@param format: 动作纹理资源格式str
	@param speed: 每帧间隔时间
	@param start_index: 开始帧idx
]]
function EffectFactory:createAnimate(plist, format, speed, start_index)
	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames(plist)

	local array = {}
	local str_frame
    local i = 0
    local frame = nil
    
    repeat
		str_frame = string.format(format, i)
		i = i + 1
        frame = sfc:getSpriteFrame(str_frame)
        if frame == nil then
            break
		end
		table.insert(array, frame)
    until false
	
	if start_index ~= nil and start_index > 0 and table.nums(array) > 0 then
		local max_num = table.nums(array)
        start_index = start_index % max_num
        local tmp_array = {}

		for i = start_index,max_num do
			table.insert(tmp_array, array[i])
		end
		
		for i = 1,start_index do
			table.insert(tmp_array, array[i])
		end
		
		array = tmp_array
    end
	
	local animation = cc.Animation:createWithSpriteFrames(array, speed)
	local animate = cc.Animate:create(animation)
	return animate
end

function EffectFactory:createEffectWithNodeByNameAsyn(name, parent, pos, z)
	-- 查找配置
	local config = cfg.effect2.effect[name]
	if not config then
		return
	end

	local pvrccz_file = config.plist:gsub(".plist", ".pvr.ccz")
	display.loadImage(pvrccz_file, function()
		if tolua.isnull(parent) == true then
			return
		end
		-- 创建节点
		local node_effect = cc.Sprite:create()
		node_effect:setScaleX(config.scalex / 100.0)
		node_effect:setScaleY(config.scaley / 100.0)
		node_effect:setAnchorPoint(cc.p(config.anchorx, config.anchory))
		node_effect:setGLProgram(cpp.ShaderFactory:instance():getGLProgram(1))
		node_effect.plist = config.plist
		res_manager:addPlist({config.plist})
		node_effect:registerScriptHandler(function(event)
			if event == "exit" then
				res_manager:removePlist({node_effect.plist})
			end
		end)

		-- 创建帧动画
		local action = nil
		if config.speed > 0 then
			action = self:createAnimate(config.plist, config.format, config.speed / 100.0)
			-- action = cpp.ActionFactory:createLuaAnimate(config.plist, config.format, config.speed / 100.0)
		else
			action = self:createAnimate(config.plist, config.format, 0.06)
			-- action = cpp.ActionFactory:createLuaAnimate(config.plist, config.format, 0.06)
		end

		-- 是否循环播放
		if config.is_loop > 0 then
			if config.delay > 0 then
				action = cc.Sequence:create(action, cc.DelayTime:create(config.delay / 1000), nil)
			end
			action = cc.RepeatForever:create(action)
		else
			if callback then
				if config.delay > 0 then
					action = cc.Sequence:create(action, cc.DelayTime:create(config.delay / 1000), callback, nil)
				else
					action = cc.Sequence:create(action, callback, nil)
				end
			else
				if config.delay > 0 then
					action = cc.Sequence:create(action, cc.DelayTime:create(config.delay / 1000), cc.RemoveSelf:create(), nil)
				else
					action = cc.Sequence:create(action, cc.RemoveSelf:create(), nil)
				end
			end
		end

		node_effect:runAction(action)
		node_effect:setPosition(pos)

		if z then
			node_effect:setLocalZOrder(z)
		end

		parent:addChild(node_effect)
	end)
end


function EffectFactory:createEffectWithSpineByNameAsyn(name, func, parent, pos, z)
	name = name or ""
	display.loadImage(name .. ".png", function()
		if tolua.isnull(parent) == true then
			return
		end
		-- 创建节点
		local node_effect = sp.SkeletonAnimation:create(name .. ".json", name .. ".atlas", 1)
		node_effect.spine_res = name .. ".png"
		node_effect:registerScriptHandler(function(event)
			if event == "exit" then
				res_manager:removeImage({
					{image_name = node_effect.spine_res, remove_type=1},
				})
			end
		end)
		node_effect:setPosition(pos)
		parent:addChild(node_effect)

		if z then
			node_effect:setLocalZOrder(z)
		end
		
		if func then
			func(node_effect)
		else
			node_effect:setAnimation(0, "idle", true);
		end
	end)
end

function EffectFactory:createEffectWithNodeByName(name, callback)
	-- 查找配置
	local config = cfg.effect2.effect[name]
	if not config then
		return
	end

	-- 创建节点
	local node_effect = cc.Sprite:create()
	node_effect:setScaleX(config.scalex / 100.0)
	node_effect:setScaleY(config.scaley / 100.0)
	node_effect:setAnchorPoint(cc.p(config.anchorx, config.anchory))
	node_effect:setGLProgram(cpp.ShaderFactory:instance():getGLProgram(1))
	node_effect.plist = config.plist
	res_manager:addPlist({config.plist})
	node_effect:registerScriptHandler(function(event)
		if event == "exit" then
			res_manager:removePlist({node_effect.plist})
		end
	end)

	-- 创建帧动画
	local action = nil
	if config.speed > 0 then
		action = self:createAnimate(config.plist, config.format, config.speed / 100.0)
		-- action = cpp.ActionFactory:createLuaAnimate(config.plist, config.format, config.speed / 100.0)
	else
		action = self:createAnimate(config.plist, config.format, 0.06)
		-- action = cpp.ActionFactory:createLuaAnimate(config.plist, config.format, 0.06)
	end

	-- 是否循环播放
	if config.is_loop > 0 then
		if config.delay > 0 then
			action = cc.Sequence:create(action, cc.DelayTime:create(config.delay / 1000), nil)
		end
		action = cc.RepeatForever:create(action)
	else
		if callback then
			if config.delay > 0 then
				action = cc.Sequence:create(action, cc.DelayTime:create(config.delay / 1000), callback, nil)
			else
				action = cc.Sequence:create(action, callback, nil)
			end
		else
			if config.delay > 0 then
				action = cc.Sequence:create(action, cc.DelayTime:create(config.delay / 1000), cc.RemoveSelf:create(), nil)
			else
				action = cc.Sequence:create(action, cc.RemoveSelf:create(), nil)
			end
		end
	end
	node_effect:runAction(action)

	return node_effect
end

function EffectFactory:createEffectByName(name, callback)
	-- 查找配置
	local config = cfg.effect2.effect[name]
	if not config then
		return
	end

	-- 创建帧动画
	local action = nil
	if config.speed > 0 then
		action = self:createAnimate(config.plist, config.format, config.speed / 100.0)
		-- action = cpp.ActionFactory:createLuaAnimate(config.plist, config.format, config.speed / 100.0)
	else
		action = self:createAnimate(config.plist, config.format, 0.06)
		-- action = cpp.ActionFactory:createLuaAnimate(config.plist, config.format, 0.06)
	end

	-- 是否循环播放
	if config.is_loop > 0 then
		if config.delay > 0 then
			action = cc.Sequence:create(action, cc.DelayTime:create(config.delay / 1000), nil)
		end
		action = cc.RepeatForever:create(action)
	else
		if callback then
			if config.delay > 0 then
				action = cc.Sequence:create(action, cc.DelayTime:create(config.delay / 1000), callback, nil)
			else
				action = cc.Sequence:create(action, callback, nil)
			end
		else
			if config.delay > 0 then
				action = cc.Sequence:create(action, cc.DelayTime:create(config.delay / 1000), nil)
			end
		end
	end

	return action
end

return EffectFactory