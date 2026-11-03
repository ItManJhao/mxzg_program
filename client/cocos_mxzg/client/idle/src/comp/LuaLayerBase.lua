local LuaLayerBase = class("LuaLayerBase", function(params1, params2)
                                if params1 then
                                    print(params1)
                                    return cpp.LuaLayer:createWithCCBIFile(params1)
                                else
                                    return cpp.LuaLayer:create()
                                end
                            end)

local StringUtil = require("src.model.StringUtil")
local AsynNode = require("src.comp.AsynNode")

local res_manager = nil -- require("src.model.ResManager"):instance()

local init_manager = function()
    res_manager = require("src.model.ResManager"):instance()
end

local status, msg = xpcall(init_manager, __G__TRACKBACK__)

function LuaLayerBase:createWithCCBIFile(ccbi_file)
    self.ccbi_file = ccbi_file

    self:registerCCBLoader()
    return self:create(self.ccbi_file)
end


function LuaLayerBase:ctor()
    local event_dispatcher = self:getEventDispatcher() 
    event_dispatcher:removeEventListenersForTarget(self)
    -- event_dispatcher:addEventListenerWithSceneGraphPriority(self.listener_touch, touch_node)
    -- self:setTouchEnabled(false) 

    self:addPlist()

    self:onLayerEvent()

    if self.onNodeEvent and self.registerLoadScriptHandler then
        self:registerLoadScriptHandler(handler(self, self.onNodeEvent))
    end

    self:resolveCCBMember()

    if self.assignCCBMemberVariable then
        self:assignCCBMemberVariable()
    end

    if self.getAsynImage then
        self:startAsynRes()
    end

    -- dump(self.__cname)
    
    if self.onCreate then
        self:onCreate()
    end

    --self:setTag(9090)
    --self:registerLoadScriptHandler(handler(self, self.onNodeEvent))
end

function LuaLayerBase:onLayerEvent()
    self:registerScriptHandler(handler(self, self.eventHandler))
end


function LuaLayerBase:eventHandler(eventType)
    if eventType == "enter" then
        self:onEventLayerEnter()
    elseif eventType == "exit" then
        self:onEventExit()
    -- elseif eventType == "cleanup" then
    --     -- 恶心的TABLE_VIEW创建的第一个节点会把界面的事件消除
    --     self:removePlist()
    -- else
    --     print(eventType)
    elseif eventType == "enterTransitionFinish" then
        self:onEnterFinish()
    end
end

function LuaLayerBase:onEventExit()
    if self.onEventLayerExit then
        self:onEventLayerExit()
    end

    if self.ctr ~= nil then
        self.ctr:removeLayer(self)
    end

    self:removePlist()
    self:removeImage()
end

function LuaLayerBase:onEventLayerEnter()
    if self.ctr ~= nil then
        self.ctr:setLayer(self)
    end
end

function LuaLayerBase:onEnterFinish()
        
end

function LuaLayerBase:addPlist()
    if res_manager then
        res_manager:addPlist(self:getLoadedPlist())
    end
end

function LuaLayerBase:removePlist()
    if res_manager then
        res_manager:removePlist(self:getLoadedPlist())
    end
end

function LuaLayerBase:removeImage()
    if res_manager then
        if self.getAsynImage then
            res_manager:removeImage(self:getAsynImage())
        end
    end
end

function LuaLayerBase:resolveCCBMember()
    local vec_member = self:getMemberList()
    for k,v in pairs(vec_member) do
        self[v:getName()] = v
    end

    local vec_function = self:getFunctionList()
    local vec_item = self:getItemList()

    for i,v in ipairs(vec_function) do
        -- local node = self:getChildByName(str_plist[1])
        local node = vec_item[i]
        if node then
            node:registerScriptTapHandler(handler(self, self[v]))
        end
    end

    self:clearFunctionList()
    self:clearItemList()
    self:clearMemberList()
end

-- 异步加载资源图片
function LuaLayerBase:startAsynRes()
    if not self.node_asyn then
        self.node_asyn = AsynNode:create()
        self:addChild(self.node_asyn)
    end
    
    local vec_res = self:getAsynImage()
	self.node_asyn.vec_image = vec_res
    self.node_asyn:startAsynLoad()
    
    if res_manager then
        for k,v in pairs(vec_res) do
            if v.remove_type == 2 then
                res_manager:addPlist({v.plist_name})
            end
        end
    end
end

function LuaLayerBase:asynCallback(cur, count, is_finish)

end

function LuaLayerBase:findNodeByNameRecursion(node, name, count)
    local vec_child = node:getChildren()
    if table.nums(vec_child) <= 0 then
        return nil
    end

    local nums = table.nums(vec_child)
    for i,v in ipairs(vec_child) do
        local tmp_node = v
        local is_match = tmp_node:getName() == name
        if is_match then
            count.num = count.num - 1
        end


        if is_match and count.num <= 0 then
            return tmp_node
        else
            local tmp_node2 = self:findNodeByNameRecursion(tmp_node, name, count)
            if tmp_node2 ~= nil then
                return tmp_node2
            end
        end
    end
    
    return nil
end

function LuaLayerBase:registerCCBLoader()
    local ccbi_file = self.ccbi_file
    ccbi_file = StringUtil.segment(StringUtil.segment(ccbi_file, "/", true), ".", false)
    cpp.CCBLoader:addLuaLoaderLibrary(ccbi_file);
end

function LuaLayerBase:onCreate()
    
end

function LuaLayerBase:setAutoClose(is_auto)
    self.is_auto_close = is_auto
end

-- function LuaLayerBase:isTouchInside(touch)
--     if touch == nil then
--         return false
--     end
    
--     local parent = self:getParent()
--     if parent == nil then
--         return false
--     end

--     local touchLocation = touch:getLocation()   -- Get the touch position
--     touchLocation = parent:convertToNodeSpace(touchLocation)
--     local bBox = self:getBoundingBox()
--     return (touchLocation.x >= bBox.x and touchLocation.x <= bBox.x + bBox.width and touchLocation.y >= bBox.y and touchLocation.y <= bBox.y + bBox.height)
-- end

function LuaLayerBase:addBlackBackground()
    local win_size = cc.Director:getInstance():getWinSize()
 
    local layer_color = cc.LayerColor:create(FONT_BLACK_HALF_C4B, win_size.width * 1.5 / self:getScaleX(), win_size.height * 1.5 / self:getScaleY())
    -- layer_color:setScale(1.5)
    layer_color:setIgnoreAnchorPointForPosition(false)
    -- layer_color:setContentSize(win_size)
    layer_color:setAnchorPoint(cc.p(0.5, 0.5))
    layer_color:setPosition(self:getContentSize().width * 0.5, self:getContentSize().height * 0.5)
    self:addChild(layer_color, -99)

    -- dump(win_size)
    -- dump(layer_color:getPosition())
    -- dump(self:getContentSize())
    -- dump(self:getPosition())

    layer_color:runAction(cc.ScaleTo:create(0.2, 1))

    -- layer_color:setScale(2)
    
    -- layer_color:runAction( cc.CallFunc:create(handler(layer_color, layer_color.resetScale)))

    -- self:runAction(cc.CallFunc:create(handler(self, self.fixedCreate)))
    return layer_color
end

-- function LuaLayerBase:fixedCreate()
    
-- end

function LuaLayerBase:onNodeEvent(event, params1, params2, params3, params4)
    if event == "onAssignCCBMemberVariable" then
        self[params1] = params2;
    elseif event == "onResolveCCBCCMenuItemSelector" then
        --print(params1, params2, params3)
        if self[params2] then
            params1:registerScriptTapHandler(handler(self, self[params2]))
        else
            print("layer selector ", params2 , "not found")
        end
    end
end

return LuaLayerBase
