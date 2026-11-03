--[[
    func: 通用UI模板窗体辅助类 (窗体类的友元类)
    author:徐东浩
    time:2019-10-13 12:14:18
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

require("src.layer.promotion.CommonUIDefine")

-- 通用UI布局器辅助类
local CommonUIHelper = class("CommonUIHelper", require("src.common.SingleInstance"))

----------------------------------------界面网络数据----------------------------------------
function CommonUIHelper:refreshActivityData(atom)
    local ui_layout = cfg.UILayout.UILayout[atom]
    if ui_layout == nil then
        print(">>>>>CommonUIHelper:refreshActivityData not found atom:"..atom.." in UILayout!")
        return
    end

    local pages = ex.Player.promotion_data:getPromotionByType(ui_layout.sub_layer_type)

    local idxs = {}
    for i,v in ipairs(pages) do
        local ui_sub_layout = cfg.UISubLayout.UISubLayout[v.idx]
        if ui_sub_layout.sub_type ~= CommonUIDefine.UIDefine.UISubLayoutType.EXTERNAL then   -- 去除外部组装界面
            if ui_sub_layout ~= nil then
                table.insert(idxs, ui_sub_layout.id_for_server)
            else
                print(string.format(">>>>>CommonUIHelper:refreshActivityData UISubLayout field idx:%d not found in UISubLayout!", v.idx))
            end
        end
    end
    
    ex.Player.promotion_data:reqCommonActivityData(idxs)
end

----------------------------------------打开界面并注入数据----------------------------------------
function CommonUIHelper:OpenWindow(atom)
    if atom == nil then
        return
    end

    local ui_layout_config = cfg.UILayout.UILayout[atom]
    if ui_layout_config == nil then
        printError(">>>>>CommonUIHelper:OpenWindow UILayout Config is not found atom:%s!", atom)
        return
    end

    local layer_class_name = "Common"..ui_layout_config.win_layer.."ActivityLayer"
    local layer_class_path = "src.layer.promotion."..layer_class_name
    local layer_ccbi_path = "ccbi/"..layer_class_name..".ccbi"
    local layer = require(layer_class_path):createWithCCBIFile(layer_ccbi_path)
    ex.MainSceneCtr:changeLayer(MainSceneType.COMMON1ACTIVITYLAYER,nil , layer)

    layer.ui_layout_config, layer.cur_promotion_pages = self:GenerationDataAndUILayoutConfig(atom)  -- 直接传递引用
    layer:onCreateDone(atom)
end

function CommonUIHelper:GenerationDataAndUILayoutConfig(atom)
    local config_table = {}
    local config_promotion_pages_table = {}
    
    config_table = clone(cfg.UILayout.UILayout[atom])   -- 克隆一下，避免修改配置表

    config_promotion_pages_table = ex.Player.promotion_data:getPromotionByType(config_table.sub_layer_type)

    config_table.sub_layer_config = {}
	for i,v in ipairs(config_promotion_pages_table) do
		local sub_layout = cfg.UISubLayout.UISubLayout[v.idx]
		if sub_layout ~= nil then
			table.insert(config_table.sub_layer_config, clone(sub_layout))
		else
			printError(">>>>>CommonUIHelper:GenerationUILayoutConfig atom=%s and idx=%d in promotionpage config, but not found in UISubLayout!", atom, v.idx)
		end
    end
    
    return config_table, config_promotion_pages_table
end

--[[
    func: 获取活动内容配置表,兼顾轮次
    author:徐东浩
    time:2019-10-23 17:59:18
]]
function CommonUIHelper:getActivityContentConfig(table_name, turns)
    local cur_turn_config = {}

    if cfg[table_name] ~= nil and cfg[table_name][table_name] ~= nil then
        for _,v in pairs(cfg[table_name][table_name]) do
            if turns == -1 or v.turns == turns then
                table.insert(cur_turn_config, v)
            end
        end
    end

    table.sort(cur_turn_config, function(a, b)
        if a == b then
            return false
        end

        return a.idx < b.idx
    end)

    return cur_turn_config
end

----------------------------------------层的定制----------------------------------------

function CommonUIHelper:LoadAtlas(json_arg)
    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/"..json_arg[CommonUIDefine.UIDefine.ComponentAttributeName.ATLAS_PLIST])
end

--[[
    func: 解析ID
    author:徐东浩
    time:2019-10-23 22:24:52
]]
function CommonUIHelper:ParseID(json_arg)
    return json_arg[CommonUIDefine.UIDefine.ComponentAttributeName.ID] or 0
end

--[[
    func: 解析位置值
    author:徐东浩
    time:2019-10-13 17:30:09
    @return: point
]]
function CommonUIHelper:ParsePos(json_arg, container)
    local pos = cc.p(0, 0)

    local origin_type = json_arg[CommonUIDefine.UIDefine.ComponentAttributeName.ORIGIN_TYPE] or CommonUIDefine.UIDefine.ComponentOriginType.LEFT_BOTTOM
    if json_arg[CommonUIDefine.UIDefine.ComponentAttributeName.POSITION_X] ~= nil then
        pos.x = json_arg[CommonUIDefine.UIDefine.ComponentAttributeName.POSITION_X]
    end
    if json_arg[CommonUIDefine.UIDefine.ComponentAttributeName.POSITION_Y] ~= nil then
        pos.y = json_arg[CommonUIDefine.UIDefine.ComponentAttributeName.POSITION_Y]
    end

    return ex.Tools:getAbsolutePosition(pos, origin_type, container)
end

--[[
    func: 解析文字颜色值
    author:徐东浩
    time:2019-10-13 17:29:36
    @return: color
]]
function CommonUIHelper:ParseLabelColor(json_arg)
    local color = cc.c3b(255, 255, 255)

    if json_arg[CommonUIDefine.UIDefine.ComponentAttributeName.LABEL_COLOR_R] ~= nil then
        color.r = json_arg[CommonUIDefine.UIDefine.ComponentAttributeName.LABEL_COLOR_R]
    end
    if json_arg[CommonUIDefine.UIDefine.ComponentAttributeName.LABEL_COLOR_G] ~= nil then
        color.g = json_arg[CommonUIDefine.UIDefine.ComponentAttributeName.LABEL_COLOR_G]
    end
    if json_arg[CommonUIDefine.UIDefine.ComponentAttributeName.LABEL_COLOR_B] ~= nil then
        color.b = json_arg[CommonUIDefine.UIDefine.ComponentAttributeName.LABEL_COLOR_B]
    end

    return color
end

--[[
    func: 解析UIMenuItemLabel的LabelText
    author:徐东浩
    time:2019-10-23 22:22:15
]]
function CommonUIHelper:ParseLabelText(json_arg)
    return json_arg[CommonUIDefine.UIDefine.ComponentAttributeName.LABEL_TEXT] or ""
end

--[[
    func: 解析锚点
    author:徐东浩
    time:2019-10-23 22:12:39
]]
function CommonUIHelper:ParseAnchorPoint(json_arg)
    local anchor = cc.p(0.5, 0.5)

    if json_arg[CommonUIDefine.UIDefine.ComponentAttributeName.ANCHOR_X] ~= nil then
        anchor.x = json_arg[CommonUIDefine.UIDefine.ComponentAttributeName.ANCHOR_X]
    end
    if json_arg[CommonUIDefine.UIDefine.ComponentAttributeName.ANCHOR_Y] ~= nil then
        anchor.y = json_arg[CommonUIDefine.UIDefine.ComponentAttributeName.ANCHOR_Y]
    end

    return anchor
end

--[[
    func: 解析图片
    author:徐东浩
    time:2019-10-23 22:22:48
]]
function CommonUIHelper:ParseImage(json_arg)
    return json_arg[CommonUIDefine.UIDefine.ComponentAttributeName.IMAGE_NAME] or "win-bg/win-bg-2.png"
end

--[[
    func: 解析缩放
    author:徐东浩
    time:2019-10-23 22:23:03
]]
function CommonUIHelper:ParseScale(json_arg)
    return json_arg[CommonUIDefine.UIDefine.ComponentAttributeName.SCALE] or 1
end

--[[
    func: 解析事件类型以及参数
    author:徐东浩
    time:2019-10-23 22:23:15
]]
function CommonUIHelper:ParseEvent(json_arg)
    return json_arg[CommonUIDefine.UIDefine.ComponentAttributeName.EVENT_TYPE], json_arg[CommonUIDefine.UIDefine.ComponentAttributeName.EVENT_ARG]
end

--[[
    func: 解析组件状态处理参数
    author:徐东浩
    time:2019-10-24 22:54:43
]]
function CommonUIHelper:ParseStatusHandle(json_arg)
    local arg = json_arg[CommonUIDefine.UIDefine.ComponentAttributeName.STATUS_HANDLE]
    if type(arg) == "number" then
        return tonumber(arg)
    end
    return nil
end

--[[
    func: 解析父节点id
    author:徐东浩
    time:2019-12-05 11:51:38
]]
function CommonUIHelper:ParseParentID(json_arg)
    return json_arg[CommonUIDefine.UIDefine.ComponentAttributeName.CHILDREN] or 0
end

--[[
    func: 加载子节点
    author:徐东浩
    time:2019-12-04 23:29:19
]]
function CommonUIHelper:_LoadChildren(json_arg, parent_json, parent, data)
    local json_children = {}

    local arg = json_arg[CommonUIDefine.UIDefine.ComponentAttributeName.CHILDREN]
    local parent_id = self:ParseID(parent_json)
    for i,v in ipairs(json_arg) do
        if self:ParseParentID(v) == parent_id then
            table.insert(json_children, v)
        end
    end

    if #json_children > 0 then
        self:ParseWinLayoutArgs(json_children, parent, data, true)
    end
end

--[[
    func: 解析并处理窗体布局参数
    author:徐东浩
    time:2019-10-13 17:32:32
    --@json_arg: json格式组件信息数组 例如:[{"id":1,"type":1,"res":"shop/limit-shop.png","plist":"shop.plist","anchor_type":1,"posx":82,"posy":829,"scale":1},...]
    --@owner: 组件所属窗体(用于事件回调、添加节点)
]]
function CommonUIHelper:ParseWinLayoutArgs(json_arg, owner, data, is_children)
    if json_arg == nil or json_arg == "" or owner == nil then
        return
    end

    for i,v in ipairs(json_arg) do
        if (self:ParseParentID(v) == 0 and not is_children)
            or (self:ParseParentID(v) ~= 0 and is_children) then  -- 加载主节点就只加载主节点，加载子节点就只加载子节点，避免重复加载(因为导表工具不支持嵌套)
            local node = self:GenerationComponent(v, owner, data)
            
            if node ~= nil then self:_LoadChildren(json_arg, v, node, data) end
        end
    end
end

--[[
    func: 生成组件
    author:徐东浩
    time:2019-10-13 12:19:20
    --@json_arg: json格式组件信息 例如:{"id":1,"type":1,"res":"shop/limit-shop.png","plist":"shop.plist","anchor_type":1,"posx":82,"posy":829,"scale":1}
    --@owner: 组件所属窗体(用于事件回调、添加节点)
    @return: 创造的组件
]]
function CommonUIHelper:GenerationComponent(json_arg, owner, data)
    if json_arg == nil then
        return nil
    end
    
    if json_arg[CommonUIDefine.UIDefine.ComponentAttributeName.COMPONENT_TYPE] == CommonUIDefine.UIDefine.ComponentType.BTN then
        return self:_GenerationBtn(json_arg, owner, data)
    elseif json_arg[CommonUIDefine.UIDefine.ComponentAttributeName.COMPONENT_TYPE] == CommonUIDefine.UIDefine.ComponentType.SPRITE then
        return self:_GenerationSprite(json_arg, owner, data)
    elseif json_arg[CommonUIDefine.UIDefine.ComponentAttributeName.COMPONENT_TYPE] == CommonUIDefine.UIDefine.ComponentType.ANIMATION then
        return self:_GenerationAnimation(json_arg, owner, data)
    end
end

--[[
    func: 生成按钮
    author:徐东浩
    time:2019-10-13 12:26:34
    @return: 返回包含按钮的menu
]]
function CommonUIHelper:_GenerationBtn(json_arg, owner, data)
    self:LoadAtlas(json_arg)

    local id = 10 + self:ParseID(json_arg)

    local menu = owner:getChildByTag(id)
    if menu ~= nil then
        menu:removeFromParent()
        menu = nil
    end

    menu = cpp.UIMenu:create()
    menu:setTag(id)
    menu:setPosition(ex.p.zero)
    menu:setContentSize(owner:getContentSize())   -- 默认直接铺满全屏，以便item进行全屏定位
    -- menu:setName("_GenerationMenu")
	menu:setSwallowsTouches(false)
    -- menu:setTouchCallback(handler(self, self.onSelect))
    menu:setLocalZOrder(id)
    owner:addChild(menu)
    
    local item = cpp.UIMenuItemLabel:create(self:ParseImage(json_arg), self:ParseImage(json_arg), "", nil)
    item:setAnchorPoint(self:ParseAnchorPoint(json_arg))
    item:setPosition(self:ParsePos(json_arg, menu))
    item:setScale(self:ParseScale(json_arg))
    item:setLabelText(self:ParseLabelText(json_arg))
    item:setLabelColor(self:ParseLabelColor(json_arg))
    local event_type, event_arg = self:ParseEvent(json_arg)
    item:registerScriptTapHandler(function(tag, pSender)
        self:onEventDispatcher(event_type, event_arg)
    end)
    menu:addChild(item)
    
    local handle_type = self:ParseStatusHandle(json_arg)
    if handle_type ~= nil then
        local handle_table = {}
        handle_table.id = id
        handle_table.type = CommonUIDefine.UIDefine.ComponentType.BTN
        handle_table.handle_type = handle_type
        handle_table.data = data
        handle_table.menu = menu
        handle_table.node = item

        self:ComponentStatueHandle(handle_table)
    end
    print("----------------_GenerationBtn")
    return item
end

--[[
    func: 生成图片
    author:徐东浩
    time:2019-10-13 12:27:06
    @return: 创建的UISprite
]]
function CommonUIHelper:_GenerationSprite(json_arg, owner, data)
    self:LoadAtlas(json_arg)

    local id = 10 + self:ParseID(json_arg)

    local sprite = owner:getChildByTag(id)
    if sprite ~= nil then
        sprite:removeFromParent()
        sprite = nil
    end

    sprite = cc.Sprite:createWithSpriteFrameName(self:ParseImage(json_arg))
    sprite:setTag(id)
    sprite:setAnchorPoint(self:ParseAnchorPoint(json_arg))
    sprite:setScale(self:ParseScale(json_arg))
    sprite:setPosition(self:ParsePos(json_arg, owner))
    sprite:setLocalZOrder(id)
    owner:addChild(sprite)

    local handle_type = self:ParseStatusHandle(json_arg)
    if handle_type ~= nil then
        local handle_table = {}
        handle_table.id = id
        handle_table.type = CommonUIDefine.UIDefine.ComponentType.SPRITE
        handle_table.handle_type = handle_type
        handle_table.data = data
        handle_table.node = sprite

        self:ComponentStatueHandle(handle_table)
    end
    print("----------------_GenerationSprite")
    return sprite
end

--[[
    func:生成动画
    author:徐东浩
    time:2019-11-13 21:17:46
    @return: 创建的动画
]]
function CommonUIHelper:_GenerationAnimation(json_arg, owner, data)
    self:LoadAtlas(json_arg)

    local id = 10 + self:ParseID(json_arg)

    local spr_effect = owner:getChildByTag(id)
    if spr_effect ~= nil then
        spr_effect:removeFromParent()
        spr_effect = nil
    end

    spr_effect = cc.Sprite:createWithSpriteFrameName(string.format(self:ParseImage(json_arg), 1))
    spr_effect:setTag(id)
    spr_effect:setAnchorPoint(self:ParseAnchorPoint(json_arg))
    spr_effect:setScale(self:ParseScale(json_arg))
    spr_effect:setPosition(self:ParsePos(json_arg, owner))
    spr_effect:setLocalZOrder(id)
    owner:addChild(spr_effect)
    
    spr_effect:runAction(cpp.ActionFactory:createRepeatForever("ccbi-res/"..json_arg[CommonUIDefine.UIDefine.ComponentAttributeName.ATLAS_PLIST],
        self:ParseImage(json_arg), 0.08))
    
    local handle_type = self:ParseStatusHandle(json_arg)
    if handle_type ~= nil then
        local handle_table = {}
        handle_table.id = id
        handle_table.type = CommonUIDefine.UIDefine.ComponentType.ANIMATION
        handle_table.handle_type = handle_type
        handle_table.data = data
        handle_table.node = spr_effect

        self:ComponentStatueHandle(handle_table)
    end
    print("----------------_GenerationAnimation")
    return spr_effect
end

--[[
    func: 组件状态处理
    author:徐东浩
    time:2019-10-24 21:30:04
]]
function CommonUIHelper:ComponentStatueHandle(info)
    local handle_type = math.abs(info.handle_type)

    if handle_type == CommonUIDefine.UIDefine.ComponentStatusHandleType.HAPPYMONTH_PRIVILEGE then
        if info.type == CommonUIDefine.UIDefine.ComponentType.BTN then
            local result = ex.Player.promotion_data:isHappyMonthPrivilege()
            info.node:setVisible(info.handle_type > 0 == result)
        elseif info.type == CommonUIDefine.UIDefine.ComponentType.SPRITE then
            local result = ex.Player.promotion_data:isHappyMonthPrivilege()
            info.node:setVisible(info.handle_type > 0 == result)
        elseif info.type == CommonUIDefine.UIDefine.ComponentType.ANIMATION then
            local result = ex.Player.promotion_data:isHappyMonthPrivilege()
            info.node:setVisible(info.handle_type > 0 == result)
        end
    elseif handle_type == CommonUIDefine.UIDefine.ComponentStatusHandleType.LIMIT_SHOP_ACTIVITY then
        -- 一直显示
        info.node:setVisible(true)
    end
end

----------------------------------------组装子界面----------------------------------------
function CommonUIHelper:GenerationSubLayerData(idx)
    return ex.Player.promotion_data:getCommonActivityDataForID(idx)
end

--[[
    func: 加载并组装窗体子层
    author:徐东浩
    time:2019-10-14 15:49:12
    --@ui_sub_layout_config: UISubLayout中的配置
	--@owner: 层所属窗体(用于事件回调、添加节点)
	--@upper_border: 上边界(用于布局)
	--@lower_border: 下边界(用于布局)
]]
function CommonUIHelper:AssemblySubLayer(ui_sub_layout_config, owner, upper_border, lower_border)
    if ui_sub_layout_config == nil or owner == nil then
        return
    end

    -- 准备数据
    local data = clone(self:GenerationSubLayerData(ui_sub_layout_config.id_for_server))

    -- 获取配置
    local content_config = self:getActivityContentConfig(ui_sub_layout_config.cfg_name, data.turns)

    local layer = display.newLayer()
    layer:setContentSize(ex.s.full)
    layer:setPosition(ex.p.zero)
    layer:setLocalZOrder(10000)
    owner:addChild(layer)

    if ui_sub_layout_config.sub_type == CommonUIDefine.UIDefine.UISubLayoutType.VERTICAL_BANNER_TABLE_VIEW then
        self:AssemblyCommon1SubLayer(ui_sub_layout_config, layer, owner, upper_border, lower_border, content_config, data)
    elseif ui_sub_layout_config.sub_type == CommonUIDefine.UIDefine.UISubLayoutType.OVERRALL_POSTER_TYPE then
        self:AssemblyCommon2SubLayer(ui_sub_layout_config, layer, owner, upper_border, lower_border, content_config, data)
    end

    return layer
end

--[[
    func: 加载通用活动1类型窗体子层
    author:徐东浩
    time:2019-10-14 15:30:57
]]
function CommonUIHelper:AssemblyCommon1SubLayer(ui_sub_layout_config, parent, owner, upper_border, lower_border, content_config, data)
    local start_height = upper_border
    local globla_scale = ex.p.width / 640

    -- 添加banner层
    if ui_sub_layout_config.banner_layer ~= 0 then
        start_height = start_height - 0
		local banner_layer_name = "Common"..ui_sub_layout_config.banner_layer.."BannerLayer"
		local banner_class_path = "src.layer.promotion."..banner_layer_name
		local banner_ccbi_path = "ccbi/"..banner_layer_name..".ccbi"

        local banner_layer = require(banner_class_path):createWithCCBIFile(banner_ccbi_path)
        banner_layer:setTag(10000)
        banner_layer:setAnchorPoint(0, 0)

		local banner_size = banner_layer:getContentSize()
        banner_layer:setScale(globla_scale)
        
		local banner_height = start_height - banner_size.height * globla_scale
		banner_layer:setPosition(cc.p(0, banner_height))
        
		parent:addChild(banner_layer)
        banner_layer:onCreateDone(owner, ui_sub_layout_config.banner_layer_arg, data, ui_sub_layout_config.idx)

		start_height = banner_height
	end

	-- 添加内容层
    if ui_sub_layout_config.content_layer ~= 0 then
        -- 创建内容ScrollView
        local start_height = start_height - 6
        local lower_padding = lower_border + 20
        local view_size = cc.size(ex.p.width, start_height - lower_padding)

        local scroll_view = cc.ScrollView:create(view_size)
        scroll_view:setTag(20000)
        scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        scroll_view:setPosition(0, lower_padding)
        parent:addChild(scroll_view)

        local container = scroll_view:getContainer()

        local getData = function(idx)
            for i,v in ipairs(data.list) do
                if v.idx == idx then
                    return v
                end
            end

            return nil
        end

        table.sort(content_config, function(a, b)
            local a_data, b_data = getData(a.idx), getData(b.idx)
            if a_data == nil then a_data = {is_got = false, progress = 0} end
            if b_data == nil then b_data = {is_got = false, progress = 0} end

            if a_data.is_got or b_data.is_got then      -- 有已领取的
                if a_data.is_got == b_data.is_got then return a.idx < b.idx end     -- 都领了排idx
                if a_data.is_got then return false end                              -- a领了，a在后
                return true                                                         -- 否则就是b领了，b在后
            else                            -- 都没有领取的
                local a_total_progress = a.target_num or (a.mission ~= nil and a.mission.target) or 1
                local b_total_progress = b.target_num or (b.mission ~= nil and b.mission.target) or 1
                local a_can_get = a_data.progress >= a_total_progress
                local b_can_get = b_data.progress >= b_total_progress

                if a_can_get or b_can_get then  -- 有可以领的
                    if a_can_get == b_can_get then return a.idx < b.idx end -- 都可领排idx
                    if a_can_get then return true end                       -- a可领，a在前
                    return false                                            -- b可领，b在前
                else
                    return a.idx < b.idx        -- 没有可领的排idx
                end
            end
        end)

        -- 创建item
        local content_class_path = "src.layer.promotion.Common"..ui_sub_layout_config.content_layer.."ContentLayer"
        local content_ccbi_path = "ccbi/Common"..ui_sub_layout_config.content_ccbi_layer.."ContentLayer.ccbi"
        
        local n = #content_config
        local cell_padding = 4
        local cell_h_mergin = 6
        local cell_size = cc.size(100, 100);
        for i,v in ipairs(content_config) do
            local content_layer = require(content_class_path):createWithCCBIFile(content_ccbi_path)
            content_layer:setAnchorPoint(0, 0)
            
            cell_size = content_layer:getContentSize()
            local scale = (view_size.width - cell_h_mergin * 2) / cell_size.width
            -- scale = math.floor(scale * 10) / 10   -- 进行精度处理，设置cell缩放的时候有进行精度处理
            cell_size.width = cell_size.width * scale
            cell_size.height = cell_size.height * scale

            content_layer:setScale(scale)
            content_layer:setPosition(cell_h_mergin * scale, (n - i) * cell_size.height + (n - i + 1) * cell_padding)
            
            container:addChild(content_layer)

            local item_data = getData(v.idx)
            content_layer:onCreateDone(owner, ui_sub_layout_config.content_layer_arg, v, item_data, data.id)
            content_layer:setIsTouchInsideNode(scroll_view)
        end

        local container_height = n * (cell_size.height + cell_padding) + cell_padding
        scroll_view:setContentSize(cc.size(view_size.width, container_height))
        scroll_view:setContentOffset(cc.p(0, view_size.height - container_height))
	end
end

--[[
    func: 加载通用活动2类型窗体子层
    author:徐东浩
    time:2019-10-18 18:01:47
]]
function CommonUIHelper:AssemblyCommon2SubLayer(ui_sub_layout_config, parent, owner, upper_border, lower_border, content_config, data)
    
end


----------------------------------------定制界面事件响应----------------------------------------
function CommonUIHelper:onEventDispatcher(e_type, e_arg)
    if e_type == nil then
        print(">>>>>CommonUIHelper:onEventDispatcher e_type is nil!")
        return
    end

    local type = tonumber(e_type)

    if type == CommonUIDefine.UIDefine.ComponentEventType.JUMP_TO_WINDOW then
        self:onEventOpenWindow(e_arg)
    elseif type == CommonUIDefine.UIDefine.ComponentEventType.OPEN_SHOP_WINDOW then
        self:onEventOpenShop(e_arg)
    elseif type == CommonUIDefine.UIDefine.ComponentEventType.RMB_RECHARGE then
        self:onEventRMBRecharge(e_arg)
    elseif type == CommonUIDefine.UIDefine.ComponentEventType.SWITCH_TAB then
        self:onEventSwitchTab(e_arg)
    else
        print(">>>>>CommonUIHelper:onEventDispatcher not found handler for event_type:"..tostring(e_type))
    end
end

function CommonUIHelper:onEventOpenWindow(e_arg)
    if e_arg == nil then
        print(">>>>>CommonUIHelper:onEventOpenWindow e_arg is nil!")
        return
    end

    ex.JumpManager:jumpByAtom(tostring(e_arg))
end

function CommonUIHelper:onEventOpenShop(e_arg)
    if e_arg == nil then
        print(">>>>>CommonUIHelper:onEventOpenShop e_arg is nil!")
        return
    end

    -- CommonDefine.SHOP_TYPE定义的枚举值
    cfg.funcopen.main_shop.open(SHOP_TYPE[e_arg])
end

function CommonUIHelper:onEventRMBRecharge(e_arg)
    if e_arg == nil then
        print(">>>>>CommonUIHelper:onEventRMBRecharge e_arg is nil!")
        return
    end

    if type(e_arg) ~= "number" then
        print(">>>>>CommonUIHelper:onEventRMBRecharge e_arg is not number!")
        return
    end

    local buygem_idx = tonumber(e_arg)
    local buygem_config = cfg.buygem.buygem[buygem_idx]
    if buygem_config == nil then
        print(">>>>>CommonUIHelper:onEventRMBRecharge not found config in buygem for idx:"..buygem_idx)
        return
    end

    ex.Player:pay(buygem_config.idx)
end

function CommonUIHelper:onEventSwitchTab(e_arg)
    if type(e_arg) == "number" then
        ex.EventManager:fire(EVENT.COMMON_ACTIVITY_EVENT.SWITCH_TAB, tonumber(e_arg))
    else
        print(">>>>>CommonUIHelper:onEventSwitchTab e_arg is not number!")
        return
    end
end


return CommonUIHelper