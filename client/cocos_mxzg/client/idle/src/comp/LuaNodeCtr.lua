-- local LuaNodeCtr = class("LuaNodeCtr", function()
--                                 return cpp.LuaNodeCtr:create()
--                             end)
--require("src.model.StringUtil")
local LuaNodeCtr = class("LuaNodeCtr")

function LuaNodeCtr:ctor()
    self.layer = nil
    self.ccbi_path = ""
    self.is_open = false
    self.is_new = true
    self.is_single = true
    self.is_always = false
    self.action_running = false
    
	self.is_scroll_view_can_move = false

	self.window_action_duration = 0.16
	
	if self.onNodeEvent and self.registerLoadScriptHandler then
        self:registerLoadScriptHandler(handler(self, self.onNodeEvent))
    end

    if ex then
        if ex.node_list == nil then
            ex.node_list = {}
        end

        table.insert(ex.node_list, self)
    end

	if self.onCreate then
		self:onCreate()
	end
    self:registerCCBLoader()
end


function LuaNodeCtr:open()
    if self:isOpened() == true then
        return
    end
    
    self.is_open = true;
	
    if self.layer == nil then
    	self:loadLayer()
        self.is_new = true
    else
        self.is_new = false
	end
    
    local scene = cc.Director:getInstance():getRunningScene()
    if self.is_single then
        -- // close other window
		local nodes = scene:getChildren()
		for i,v in ipairs(nodes) do
            if  v ~= nil and v.controller ~= nil then
                local controller = v.controller
				if controller ~= self or not controller:isAlways() then
					controller:close(nil)
				end
			end
        end
    end

    if self.layer then
        scene:addChild(self.layer)
        require("src.native.Native").windowsOpen(self, self.ccbi_path)
    else
        print("error open window", self.ccbi_path)
    end

    -- LuaManager::instance()->executeGlobalAutoFunction("windowsOpen", [&](LuaStack * ls) {
    --     ls->pushObject(this, "NodeCtr");
    --     ls->pushString(getCCBIPath());
    --     return 2;
	-- });
end

function LuaNodeCtr:loadLayer()
    local layer = self:getLayerClass()
	local ccbi_file = self.ccbi_path
    
    local tmp_layer = layer:create(ccbi_file, self)
    -- if ex then
    --     ex.Tools:ergodicAllNode(tmp_layer, function(node)
    --         node:setGlobalZOrder(80000000)
    --     end)
    -- end
    self:setLayer(tmp_layer)
    
    -- 创建点击事件
    self:registerTouchListen()


	-- self.layer.close_callback = handler(self, self.close)
	-- self:resolveCCBCCMenuItemSelector()	-- C++，注册按钮事件，暂时注释掉
end

-- 创建点击事件, 在loadLayer里都需要调用一下，否则会导致self.layer无法回收置空，没办法第二次打开界面
function LuaNodeCtr:registerTouchListen()
	local self_p = self.layer;

	local touch_node = cc.Node:create()
	self.layer:addChild(touch_node, -9999999)

    self.listener_touch = cc.EventListenerTouchOneByOne:create()  --创建一个单点事件监听
    self.listener_touch:setSwallowTouches(true)
    self.listener_touch:registerScriptHandler(function(touch, event)
        self.layer.touch_began_inside = self.layer:isTouchInside(touch)
        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN)

    self.listener_touch:registerScriptHandler(function()
    end, cc.Handler.EVENT_TOUCH_MOVED)

    self.listener_touch:registerScriptHandler(function(touch, event)

    	self:onTouchEnded(touch, event)
    end, cc.Handler.EVENT_TOUCH_ENDED)

    local event_dispatcher = touch_node:getEventDispatcher() 
    event_dispatcher:addEventListenerWithSceneGraphPriority(self.listener_touch, touch_node)
end

function LuaNodeCtr:onTouchEnded(pTouch, pEvent)
    -- LayerBase::onTouchEnded(pTouch, pEvent);
    if self.layer.is_auto_close == false then
        return
    end
    
    if not self.layer.touch_began_inside and self.layer:getParent() and not self.layer:isTouchInside(pTouch) then
        -- if ex.Game:isKeyBoardShown() == true then
        --     -- // 键盘打开了，关闭键盘
        --     ex.Game:shutDownKeyBoard()
        -- else
            -- // 关闭窗口
            if self.closeWindow ~= nil then
                -- print("LuaNodeCtr:onTouchEnded close ~~~")
                self:closeWindow(0, nil)
            else
                -- print("LuaNodeCtr:onTouchEnded remove ~~~")
				self.layer:removeFromParent()
                self.layer = nil
                self.is_open = false
            end
        -- end
    end
end

function LuaNodeCtr:getLayerClass()

end

function LuaNodeCtr:getLayer()
	return self.layer
end

function LuaNodeCtr:setLayer(layer)
    self.layer = layer
    if self.layer then
        self.layer.node_ctr = self
    end
end

function LuaNodeCtr:onNodeEvent(event, params1, params2, params3, params4)
    if event == "onResolveCCBCCMenuItemSelector" then
        if self[params2] then
            params1:registerScriptTapHandler(handler(self, self[params2]))
        else
            print("ctr selector ", params2 , "not found")
        end
    end
end

function LuaNodeCtr:registerCCBLoader()
	local ccbi_file = self.ccbi_path
	local StringUtil = require("src.model.StringUtil")
	--ccbi_file = StringUtil.segment(StringUtil:segment(ccbi_file, "/", true), ".", false)
	ccbi_file = StringUtil.segment(StringUtil.segment(ccbi_file, "/", true), ".", false)
	cpp.CCBLoader:addLuaLoaderLibrary(ccbi_file);
end

function LuaNodeCtr:setCCBIPath(file_path)
    self.ccbi_path = file_path;
end

function LuaNodeCtr:isSingle()
    return self.is_single
end

function LuaNodeCtr:isAlways()
    return self.is_always
end

function LuaNodeCtr:isOpened()
    return self.is_open
end

function LuaNodeCtr:onExit()
    
end

function LuaNodeCtr:remove()
    self:release();
end

function LuaNodeCtr:releaseLayer()
    if tolua.isnull(self.layer) ~= true then
        local tmp_layer = self.layer
        -- self.layer:setVisible(false)
        self.layer = nil
        tmp_layer.controller = nil

        -- local count = tmp_layer:getReferenceCount()
        -- print(count)
        -- tmp_layer:removeFromParent()

        -- tmp_layer:release()
        -- if count > 1 then
        --     tmp_layer:removeFromParent()
        -- end

        -- tmp_layer.controller = nil
        -- local count = tmp_layer:getReferenceCount()
        -- print("count", count)
        -- if count > 2 then
        --     tmp_layer:release()
        -- end
        
        -- builder 有1/4的几率泄露内存

        -- tmp_layer:setVisible(false)
        -- tmp_layer:runAction(cc.RemoveSelf:create())
        -- tmp_layer:removeAllChildren()
        
        tmp_layer:removeFromParent()

        -- local count = tmp_layer:getReferenceCount()
        -- print("LuaNodeCtr:releaseLayer")
        -- tmp_layer:removeFromParent()
    end
-- //    this->retain()
end

function LuaNodeCtr:isOpenWindow(ccbi) 
    local scene = cc.Director:getInstance():getRunningScene()
    local nodes = scene:getChildren()
	local layer_tmp = nil
	for i,v in ipairs(nodes) do
        if v ~= nil and v.controller ~= nil then
            local controller = v.controller
			if controller ~= nil and controller:getCCBIPath() ~= nil and strcmp(ccbi, controller:getCCBIPath()) == 0 then
				return true
			end
		end
    end
    return false
end

function LuaNodeCtr:getCCBIPath()
    return self.ccbi_path
end

function LuaNodeCtr:setIsSingle(b)
    self.is_single = b
end

function LuaNodeCtr:setIsAlways(b)
    self.is_always = b
end

function LuaNodeCtr:closeWindow(params1, params2)
	self:close(params2 or self.layer)
end

function LuaNodeCtr:close(object)
    if self:isOpened() == false then
        return
	end
    
    if self.layer ~= nil then
        local act_ease = self.layer:getActionByTag(-999)
        if act_ease ~= nil then
            return
		end
    end
    
-- //    if (action_running) {
-- //        return;
-- //    }
    self:runAction(false)

    require("src.native.Native").windowsClose(self, self.ccbi_path)
end

function LuaNodeCtr:fastClose()

    -- print("LuaNodeCtr:fastClose()")
    self.is_open = false
    self:releaseLayer() -- 释放layer，下次将重新读取CCBI文件
    
    require("src.native.Native").windowsClose(self, self.ccbi_path)
end

function LuaNodeCtr:allChildrenFade(node, duration, flag)
    local children = node:getChildren()
    if table.nums(children) <= 0 then
        return
	end
	
	for i,v in ipairs(children) do
        if v ~= nil and v:isVisible() then
            self:allChildrenFade(v, duration, flag)
        
			if flag then
				local opacity = v:getOpacity()
				v:setOpacity(0)
				v:runAction(cc.EaseExponentialOut:create(cc.FadeTo:create(duration, opacity)))
			else
				v:runAction(cc.EaseExponentialOut:create(cc.FadeOut:create(duration * 0.3)))
			end
        end
    end
end

function LuaNodeCtr:runAction(flag)
    self.action_running = true
    
--     // 加一个最高优先级的事件响应，以使在动画过程中，其他事件被屏蔽掉，在动画结束后恢复
-- //    Director::getInstance()->getTouchDispatcher()->addTargetedDelegate(this, -3, true);
    
    local action = nil
    if flag == true then
        local scale = self.layer:getScale()
        self.layer:setScale(scale * 0.8)
        -- action = cc.Sequence:create(cc.ScaleTo:create(self.window_action_duration * 0.5, scale), cc.CallFunc:create(handler(self, self.openActionEnd)), nil)

        self:openActionEnd()
    else
        -- print("LuaNodeCtr:runAction() close")
        -- action = cc.Sequence:create(cc.ScaleTo:create(self.window_action_duration * 0.5, 0.1), cc.CallFunc:create(handler(self, self.closeActionEnd)), nil)

        self:closeActionEnd()
	end
    -- local act_ease = cc.EaseExponentialOut:create(action)
    -- act_ease:setTag(-999)
    -- self.layer:runAction(act_ease)
    -- self:allChildrenFade(self.layer, self.window_action_duration, flag)
end

function LuaNodeCtr:closeActionEnd()
-- //    Director::getInstance()->getTouchDispatcher()->removeDelegate(this);
	self:fastClose(nil)
    self.action_running = false
end

function LuaNodeCtr:openActionEnd()
-- //    Director::getInstance()->getTouchDispatcher()->removeDelegate(this);
	self.action_running = false
end

-- function LuaNodeCtr:runAction(executor, type, open, call_func)
--     self.action_running = true
-- -- //    Director::getInstance()->getTouchDispatcher()->addTargetedDelegate(this, -3, true);
    
--     local duration = 0.0
--     local p = cc.p(0, 0)
    
--     local action = nil
--     if type == 1 then
--         duration = self.window_action_duration;
--         action = cc.Sequence:create(cc.ScaleTo:create(duration / 2, 1.14),
--                                   cc.ScaleTo:create(duration / 2, 1.0),
--                                   cc.CallFunc:create(call_func),
--                                   nil)
--     elseif type == 2 then
--         if open then
--             duration = 0.05
--             p = executor:getPosition()
--             executor:setPositionX(executor:getPositionX() + 35.0)
--             executor:setVisible(false)
            
--             action = cc.Sequence:create(cc.DelayTime:create(0.016),
--                                       cc.Show:create(),
--                                       cc.MoveTo:create(duration, p),
--                                       cc.CallFunc:create(call_func),
--                                       nil)
            
--         else
--             duration = 0.05
--             p = cc.p(executor:getPositionX() - 35.0, executor:getPositionY())
            
--             action = cc.Sequence:create(cc.MoveTo:create(duration, p),
--                                       cc.CallFunc:create(call_func),
--                                       nil)
-- 		end
        
        
--     else
--         if open then
--             duration = 0.05
--             p = executor:getPosition()
--             executor:setPositionX(executor:getPositionX() - 35.0)
--             executor:setVisible(false)
          
--             action = cc.Sequence:create(cc.DelayTime:create(0.016),
-- 										cc.Show:create(),
-- 										cc.MoveTo:create(duration, p),
-- 										cc.CallFunc:create(call_func),
--                                       	nil)
--         else
--             duration = 0.05
--             p = cc.p(executor:getPositionX() + 35.0, executor:getPositionY())
            
--             action = cc.Sequence:create(cc.MoveTo:create(duration, p),
-- 										cc.CallFunc:create(call_func),
--                                       	nil)
-- 		end
--     end
    
--     executor:runAction(action)
--     self:allChildrenFade(executor, duration, open)
-- end


function LuaNodeCtr:closeOtherWindow()
    if ex == nil or ex.node_list == nil then
        return
    end

    for i,v in ipairs(ex.node_list) do
        if v:isOpened() == true then
            v:fastClose()
        end
    end
end


return LuaNodeCtr
