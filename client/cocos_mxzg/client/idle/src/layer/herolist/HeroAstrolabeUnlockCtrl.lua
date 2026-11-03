--[[
    func: 星盘解锁界面
    author:徐东浩
    time:2020-04-28 22:46:12
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local HeroAstrolabeUnlockCtrl = class("HeroAstrolabeUnlockCtrl", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroAstrolabeUnlockLayer = class("HeroAstrolabeUnlockLayer", require("src.comp.EventLayer"))

function HeroAstrolabeUnlockLayer:onCreate()
    self:addBlackBackground()

    self.btn_elem_callback = nil

    self.ui_nodes = {
        [1] = {
            elem = 1,
            btn = self.btn_elem_1,
            border = nil,
            line = {
                {
                    other_elem = 2,
                    spr_line = self.spr_path_3,
                },
                {
                    other_elem = 3,
                    spr_line = self.spr_path_4,
                }
            }
        },
        [2] = {
            elem = 2,
            btn = self.btn_elem_2,
            border = nil,
            line = {
                {
                    other_elem = 1,
                    spr_line = self.spr_path_3,
                },
                {
                    other_elem = 5,
                    spr_line = self.spr_path_2,
                }
            }
        },
        [3] = {
            elem = 3,
            btn = self.btn_elem_3,
            border = nil,
            line = {
                {
                    other_elem = 1,
                    spr_line = self.spr_path_4,
                },
                {
                    other_elem = 4,
                    spr_line = self.spr_path_5,
                }
            },
        },
        [4] = {
            elem = 4,
            btn = self.btn_elem_4,
            border = nil,
            line = {
                {
                    other_elem = 3,
                    spr_line = self.spr_path_5,
                },
                {
                    other_elem = 5,
                    spr_line = self.spr_path_1,
                }
            },
        },
        [5] = {
            elem = 5,
            btn = self.btn_elem_5,
            border = nil,
            line = {
                {
                    other_elem = 2,
                    spr_line = self.spr_path_2,
                },
                {
                    other_elem = 4,
                    spr_line = self.spr_path_1,
                }
            },
        },
    }

    local btn_size = self.ui_nodes[1].btn:getContentSize()
    for i, v in ipairs(self.ui_nodes) do
        v.btn:registerScriptTapHandler(handler(self, self.onElem))
        v.btn.local_data = {elem = v.elem}

        v.border = cc.Sprite:createWithSpriteFrameName("astrolabe/spr_star_border.png")
		v.border:setScale(1)
		v.border:setPosition(cc.p(btn_size.width / 2, btn_size.height / 2))
        v.btn:getNormalImage():addChild(v.border, 10)

        v.spr_select = cc.Sprite:createWithSpriteFrameName("astrolabe/spr_select.png")
        v.spr_select:setScale(1)
        -- v.spr_select:setBlendFunc({src = gl.ONE, dst = gl.ONE_MINUS_SRC_ALPHA})
		v.spr_select:setPosition(cc.p(btn_size.width / 2, btn_size.height / 2))
        v.btn:getNormalImage():addChild(v.spr_select, 20)

        v.spr_select:setVisible(false)
    end

    -- 转圈动画精灵数组
    self.roll_anim_sprs = {
        [1] = {
            elem = 1,
            spr = self.ui_nodes[1].spr_select,
        },
        [2] = {
            elem = 3,
            spr = self.ui_nodes[3].spr_select,
        },
        [3] = {
            elem = 4,
            spr = self.ui_nodes[4].spr_select,
        },
        [4] = {
            elem = 5,
            spr = self.ui_nodes[5].spr_select,
        },
        [5] = {
            elem = 2,
            spr = self.ui_nodes[2].spr_select,
        },
    }

    -- 转圈动画字段表
    self.roll_anim_fields = {
        timer_name = "astrolabe_timer",
        last_millisecond = 0,
        last_select_spr = nil,
        _elapsed = 0,
        duration = 3000,    -- 3秒
        interval = 35,      -- 35毫秒，接近于一帧一调用
        start_idx = 0,
        end_idx = 0,
        roll_time = 4,      -- 转动圈数
        callback =  nil,
    }

    self:addRedDotNode(RedDotType.ZCJ_DHYX_XP_JSXP, self.btn_active)
end

function HeroAstrolabeUnlockLayer:refershStarPanel(elems, is_unlock)
    local is_exist = function(t, value)
        for k,v in pairs(t) do
            if v == value then
                return true
            end
        end
        return false
    end

    local is_all_active = true
    for i, v in ipairs(self.ui_nodes) do
        local is_active = is_exist(elems, v.elem)
        is_all_active = is_all_active and is_active

        ex.Tools:setGrayAuto(v.btn:getNormalImage(), not is_active)

        for i, v in ipairs(v.line) do
            local is_active_2 = is_exist(elems, v.other_elem)
            v.spr_line:setVisible(is_active and is_active_2)
        end
    end

    if is_all_active and not is_unlock then
        self.menu_unlock = cpp.UIMenu:create()
        self.menu_unlock:setSwallowsTouches(false)
        self.menu_unlock:setPosition(cc.p(0, 0))
        self.node_unlock:addChild(self.menu_unlock)

        local btn_touming = cpp.UIMenuItemImage:createWithSpriteFrameName("astrolabe/touming.png", "", "")
        btn_touming:registerScriptTapHandler(handler(self, self.onUnlock))
        btn_touming:setAnchorPoint(ex.a.center)
        btn_touming:setPosition(0,0)
        self.menu_unlock:addChild(btn_touming)

        -- 显示解锁特效
        local btn_size = btn_touming:getContentSize()
        local spr_spine = sp.SkeletonAnimation:create("spine/djjs.json", "spine/djjs.atlas", 1)
        spr_spine:setAnimation(0, "stand", true)
        spr_spine:setPosition(btn_size.width / 2, btn_size.height / 2)
        btn_touming:getNormalImage():addChild(spr_spine)
    end
    
    self.node_line:setVisible(not is_unlock)
end

function HeroAstrolabeUnlockLayer:onUnlock(tag ,pSender)
    NetManager:sendMessage(ProtocolID.GReqAstrolabeUnlockElem)
end

function HeroAstrolabeUnlockLayer:setNeedMaterials(item_type, cur_num, need_num)
    if self.btn_need_materials then
        self.btn_need_materials:removeFromParent()
        self.btn_need_materials = nil
    end
    
    self.btn_need_materials = ex.Tools:createBackpackItem(item_type, 0)
    self.btn_need_materials:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
    self.btn_need_materials:setPosition(self.node_item:getPosition())
    self.btn_need_materials:setScale(0.75)
    self.menu:addChild(self.btn_need_materials)
    
    local lbl_num = cc.Label:createWithTTF(string.format("%d/%d", cur_num, need_num), FONT_DEFAULT_NAME_BOLD, 44)
    lbl_num:setScale(0.5)
    lbl_num:setColor(cur_num < need_num and cc.c3b(255, 0, 0) or cc.c3b(0, 255, 0))
    lbl_num:enableOutline(FONT_BLACK, 2)
    lbl_num:setAnchorPoint(ex.a.right_bottom)
    lbl_num:setPosition(self.btn_need_materials:getContentSize().width - 9, 5)
    self.btn_need_materials:addChild(lbl_num, 1000)
end

function HeroAstrolabeUnlockLayer:setSelectElem(elem)
    elem = elem or 1
    
    for i, v in ipairs(self.ui_nodes) do
        v.spr_select:setVisible(v.elem == elem)
    end
end

function HeroAstrolabeUnlockLayer:refreshAttrs(attr_list)
    self.scroll_view:getContainer():removeAllChildren()
    
    local view_size = self.scroll_view:getViewSize()
    local font_size, font_scale, line_height, margin, space = 44, 0.5, 28, 3, 3
    local n = 1
    for i = #attr_list, 1, -1 do
        local data = attr_list[i]
        
        local str = string.format(ex.Tools:getLang(4101), ex.Tools:getLang(2100 + data.element), ex.Tools:getLang(122000 + data.attr), data.value)
        
        local lbl_attr = cc.Label:createWithTTF(str, FONT_DEFAULT_NAME_BOLD, font_size)
        lbl_attr:setScale(font_scale)
        lbl_attr:setColor(cc.c3b(219, 239, 255))
        lbl_attr:setAnchorPoint(ex.a.center)
        lbl_attr:setPosition(view_size.width / 2, margin + (n - 1) * space + (n - 0.5) * line_height)
        self.scroll_view:getContainer():addChild(lbl_attr)
        
        n = n + 1
    end
    
    self.scroll_view:setContentSize(cc.size(view_size.width, 2 * margin + (#attr_list - 1) * space + #attr_list * line_height))
    self.scroll_view:setContentOffset(self.scroll_view:minContainerOffset())
end

function HeroAstrolabeUnlockLayer:setActived(is_actived)
    self.node_item:setVisible(not is_actived)
    self.btn_active:setVisible(not is_actived)
    if self.btn_need_materials then
        self.btn_need_materials:setVisible(not is_actived)
    end
end

function HeroAstrolabeUnlockLayer:onElem(tag ,pSender)
    if self.btn_elem_callback then
        self.btn_elem_callback(pSender.local_data.elem)
    end
end

function HeroAstrolabeUnlockLayer:showUnlockAnim()
    if self.menu_unlock then
        self.menu_unlock:setVisible(false)
    end

    self.node_line:setVisible(false)

    -- 显示解锁特效
    self.line_effect = cc.Sprite:create()
    self.line_effect:setPosition(ex.p.zero)
    self.line_effect:setAnchorPoint(ex.a.center)
    self.node_unlock:addChild(self.line_effect, 10)
    self.line_effect:runAction(cc.Sequence:create(ex.EffectFactory:createAnimate("ccbi-res/astrolabe.plist", "astrolabe/line_effect_%d.png", 0.12), cc.CallFunc:create(function()
        self.line_effect:setVisible(false)
    end), cc.DelayTime:create(0.2), cc.CallFunc:create(function()
        HeroAstrolabeUnlockCtrl:instance():closeWindow()

        ex.JumpManager:jumpByAtom("hero_astrolabe")
    end)))
end

function HeroAstrolabeUnlockLayer:showUnlockElem(start_elem, end_elem, callback)
    self.roll_anim_fields.start_idx = self:_getRollElemIdx(start_elem)
    self.roll_anim_fields.end_idx = self:_getRollElemIdx(end_elem)
    self.roll_anim_fields.end_idx = self.roll_anim_fields.end_idx + self.roll_anim_fields.roll_time * 5 -- 5个元素，3是转两圈的值

    self.roll_anim_fields.callback = callback

    self:removeTimerByName(self.roll_anim_fields.timer_name)

    self.roll_anim_fields.last_millisecond = ex.Game:getServerMillisecond()
    
    self.roll_anim_fields.last_select_spr = self.roll_anim_sprs[self.roll_anim_fields.start_idx].spr
    
    self.roll_anim_fields._elapsed = 0
    self:addTimer(self.roll_anim_fields.timer_name, self.roll_anim_fields.interval, handler(self, self.unlockElemCallback), true)
end

function HeroAstrolabeUnlockLayer:unlockElemCallback()
    local delta_time = ex.Game:getServerMillisecond() - self.roll_anim_fields.last_millisecond
    self.roll_anim_fields.last_millisecond = ex.Game:getServerMillisecond()

    self.roll_anim_fields._elapsed = self.roll_anim_fields._elapsed + delta_time;

    delta_time = math.max(0, math.min(1, self.roll_anim_fields._elapsed / self.roll_anim_fields.duration));

    -- 使用ease动画变换时间
    delta_time = self:_cubicEaseInOut(delta_time)
    -- 使用actionfloat计算对应时间中的idx变换
    local value = self:_actionFloat(self.roll_anim_fields.end_idx, self.roll_anim_fields.end_idx - self.roll_anim_fields.start_idx, delta_time)

    local idx = math.round(value)
    idx = ((idx - 1) % 5) + 1
    
    self.roll_anim_fields.last_select_spr:setVisible(false)
    self.roll_anim_fields.last_select_spr = self.roll_anim_sprs[idx].spr
    self.roll_anim_fields.last_select_spr:setVisible(true)

    if self.roll_anim_fields._elapsed >= self.roll_anim_fields.duration then
        self:removeTimerByName(self.roll_anim_fields.timer_name)

        if self.roll_anim_fields.callback then self.roll_anim_fields.callback() end
    end
end

function HeroAstrolabeUnlockLayer:_getRollElemIdx(elem)
    for i,v in ipairs(self.roll_anim_sprs) do
        if v.elem == elem then
            return i
        end
    end
end

function HeroAstrolabeUnlockLayer:_actionFloat(end_idx, length, delta_time)
    return end_idx - length * (1 - delta_time);
end

function HeroAstrolabeUnlockLayer:_cubicEaseInOut(delta_time)
    delta_time = delta_time * 2;
    if delta_time < 1 then
        return 0.5 * delta_time * delta_time * delta_time;
    end

    delta_time = delta_time - 2;
    return 0.5 * (delta_time * delta_time * delta_time + 2);
end

-----------------------------------------------------------------------------
function HeroAstrolabeUnlockCtrl:onCreate()
    self:setCCBIPath("ccbi/HeroAstrolabeUnlockLayer.ccbi")
    
    self:setIsSingle(false)
    
    self.cur_select_elem = 0
    self.actionable_elem = 0
    self.need_materials = cfg.system.astrolabe_active_elem_cost[1]
end

function HeroAstrolabeUnlockCtrl:openWindow(hero_id)
	if self:isOpened() then
		return
    end

	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/hero-info.plist")
    sfc:addSpriteFrames("ccbi-res/hero-info-lang.plist")

	self:loadLayer()
    self:open()

    self:refreshData()

	self:init()
end

function HeroAstrolabeUnlockCtrl:getLayerClass()
	return HeroAstrolabeUnlockLayer
end

function HeroAstrolabeUnlockCtrl:closeWindow()
    self:close(self.layer)
end

function HeroAstrolabeUnlockCtrl:init()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_active:registerScriptTapHandler(handler(self, self.onActive))

    self.layer:addEvent(EVENT.ASTROLABE.ACTIVE_ELEM, handler(self, self.eventActiveElem))
    self.layer:addEvent(EVENT.ASTROLABE.UNLOCK_ELEM, handler(self, self.eventUnlockElem))

    self.layer.btn_elem_callback = handler(self, self.onElem)

	self:updateLayer()
end

function HeroAstrolabeUnlockCtrl:refreshData()
    self.cur_select_elem = 0
    self.actionable_elem = 0

    -- 首次选中低级未激活元素
    local elem_set = cfg.astrolabeelement.getSetForIdx()
    for i, v in ipairs(elem_set) do
        if not ex.Player.hero_data.astrolabe:isActivedByElem(v) then
            self.cur_select_elem = v

            local cur_num = ex.Player:getItemNum(self.need_materials.item_type)
            if cur_num >= self.need_materials.item_num then
                self.actionable_elem = v
            end
            break
        end
    end
    -- 都激活了，则选中最后一个元素
    if self.cur_select_elem == 0 then
        self.cur_select_elem = elem_set[#elem_set]
    end
end

function HeroAstrolabeUnlockCtrl:updateLayer()
    self.layer:setSelectElem(self.cur_select_elem)

    local cur_num = ex.Player:getItemNum(self.need_materials.item_type)
    self.layer:setNeedMaterials(self.need_materials.item_type, cur_num, self.need_materials.item_num)

    local config = cfg.astrolabeelement.getConfigByElem(self.cur_select_elem)
    self.layer:refreshAttrs(config.attrs)

    self.layer:refershStarPanel(ex.Player.hero_data.astrolabe.actived_elem, ex.Player.hero_data.astrolabe:isEnabled())

    self.layer:setActived(ex.Player.hero_data.astrolabe:isAllElemActived())
end

--------------------------响应处理--------------------------
function HeroAstrolabeUnlockCtrl:onActive()
    local cur_num = ex.Player:getItemNum(self.need_materials.item_type)
    if cur_num < self.need_materials.item_num then
        ex.MessageView:add(ex.Tools:getLang(4102))
        return
    end

    NetManager:sendMessage(ProtocolID.GReqAstrolabeActiveElem)
end

function HeroAstrolabeUnlockCtrl:onElem(elem)
    if self.cur_select_elem == elem then return end

    self.cur_select_elem = elem

    self:updateLayer()
end

--------------------------事件处理--------------------------
function HeroAstrolabeUnlockCtrl:eventActiveElem(event, elem)
    self.layer:showUnlockElem(self.cur_select_elem, elem, function()
        self:refreshData()
        
        self.cur_select_elem = elem

        self:updateLayer()
    end)
end

function HeroAstrolabeUnlockCtrl:eventUnlockElem()
    self.layer:showUnlockAnim()
end

return HeroAstrolabeUnlockCtrl
