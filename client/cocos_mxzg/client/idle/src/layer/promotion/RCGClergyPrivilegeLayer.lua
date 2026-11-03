--[[
    func: 神职特权
    author:徐东浩
    time:2020-04-08 17:23:12
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local RCGClergyPrivilegeLayer = class("RCGClergyPrivilegeLayer", require("src.layer.promotion.PromotionBaseLayer"))
local RCGClergyPrivilegePos = class("RCGClergyPrivilegePos", require("src.comp.LuaLayerBase"))

local ExTimer = require("src.ex.ExTimer")

function RCGClergyPrivilegePos:onCreate()
	self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.data = nil
    self.click_callback = nil

    self.lbl_desc = ex.Tools:createRichText(self.node_desc, "", 18, false, ex.p.zero, nil, nil, nil, ex.a.center)

    self.btn_clergy_pos:registerScriptTapHandler(handler(self, self.onClick))

    self.menu:setSwallowsTouches(false)

    local btn_size = self.btn_clergy_pos:getContentSize()
    self.spr_clergy_pos_border = cc.Sprite:createWithSpriteFrameName("promotion-3/clergy-pos-border.png")
    self.spr_clergy_pos_border:setAnchorPoint(ex.a.center)
    self.spr_clergy_pos_border:setPosition(cc.p(btn_size.width / 2, btn_size.height / 2))
    self.btn_clergy_pos:addChild(self.spr_clergy_pos_border)

    self.spr_clergy_title = cc.Sprite:createWithSpriteFrameName("promotion-3/clergy-pos-border.png")
    self.spr_clergy_title:setAnchorPoint(ex.a.center)
    self.spr_clergy_title:setPosition(cc.p(btn_size.width / 2, btn_size.height / 2 + 55))
    self.btn_clergy_pos:addChild(self.spr_clergy_title)
end

function RCGClergyPrivilegePos:initDone(data)
    self.data = data

    ex.Tools:setSpriteFrame(self.btn_clergy_pos:getNormalImage(), string.format("promotion-3/clergy-pos-%d.png", self.data.config.clergy_level))
    ex.Tools:setSpriteFrame(self.spr_clergy_title, string.format("promotion-3/clergy-title-%d.png", self.data.config.clergy_level))

    self.lbl_desc:setXmlTextLua(ex.Tools:getLang(self.data.config.lan))

    self.node_res:setVisible(not self.data.is_active and #self.data.config.reward > 0)
    self.node_active:setVisible(self.data.is_active)

    if not self.data.is_active and #self.data.config.reward > 0 then
        ex.Tools:setSpriteFrame(self.spr_res, string.format("backpack/%d.png", self.data.config.reward[1].item_type))

        self.lbl_res:setString(string.format("x%d", self.data.config.reward[1].item_num))
    end

    ex.Tools:setGrayAuto(self.btn_clergy_pos:getNormalImage(), not self.data.is_active)
end

function RCGClergyPrivilegePos:setSelected(is_select)
    self.spr_clergy_pos_border:setVisible(is_select)
end

function RCGClergyPrivilegePos:onClick(tag, pSender)
    if self.click_callback then
        self.click_callback(self.data)
    end
end

-----------------------------------------------------------------------

function RCGClergyPrivilegeLayer:onCreateDone()
	self:setAutoClose(false)
    self:setSwallowTouches(false)

    -- 数据
    self.cur_select_info = nil
    self.cur_unlock_info = nil
    self.list = {}
    self.cell_list = {}

    ex.Tools:AdjustFullScreenExtend(self.spr_bg)
    self.spr_bg:setPositionY(self.spr_bg:getPositionY() - require("src.model.Game"):instance():getNotchHeight())

    self:setAnchorPoint(ex.a.left_top)
    self:setPosition(0, (self.layer_promotion:getTopY() + require("src.model.Game"):instance():getNotchHeight() - self:getContentSize().height) / 2)

    local banner_size = self.node_banner:getContentSize()
    banner_size.height = banner_size.height * ex.s.global_scale
    self.node_banner:setContentSize(banner_size)
    self.spr_banner:setContentSize(banner_size)
    self.spr_banner_top:setContentSize(cc.size(banner_size.width * 2, 14.0))
    self.spr_banner_top:setPositionY(banner_size.height + 3.5)

    self.node_clergy_title:setPositionY(banner_size.height * 0.533)
    self.node_clergy_title:setLocalZOrder(10)
    self.lbl_title_desc:setPositionY(banner_size.height * 0.208)
    self.lbl_title_desc:setLocalZOrder(10)
    self.node_bottom:setScale(ex.s.global_scale)

    local top = self.node_banner:getPositionY() - banner_size.height - require("src.model.Game"):instance():getNotchHeight()
    local bottom = self.node_bottom:getPositionY() + self.node_bottom:getContentSize().height * ex.s.global_scale
    local content_size = cc.size(ex.p.width, top - bottom)


    self.node_content:setPositionY(top)
    self.node_content:setContentSize(content_size)
    self.scroll_view:setViewSize(content_size)

    self.node_banner:setPositionY(self.node_banner:getPositionY() - require("src.model.Game"):instance():getNotchHeight())

    self.lbl_exp_progressbar = ex.Tools:createRichText(self.node_clergy_exp, "", 20, false, ex.p.zero, nil, nil, nil, ex.a.left_center)

    self.exp_progressbar = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("other/progressbar-fg.png"))
    self.exp_progressbar:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.exp_progressbar:setMidpoint(cc.p(0, 0.5))
    self.exp_progressbar:setAnchorPoint(ex.a.center)
    self.exp_progressbar:setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.node_progressbar:addChild(self.exp_progressbar)
    self.exp_progressbar:setPosition(ex.p.zero)
    
    -- 生成数据
    self:refreshData()
    self:refreshView()
    self:adjustScrollViewPos(self.cur_select_info)

	self:addRedDotNode(RedDotType.ZCJ_DHZC_CZ_SZTQ_JH, self.btn_active)
    self:addEvent(EVENT.MAIN_CITY_PROMOTION.CLERGY_REFRESH_FOR_UP, handler(self, self.eventRefreshForUP))

    self.btn_active:registerScriptTapHandler(handler(self, self.onActive))
    self.lbl_progressbar:setLocalZOrder(10)
    self.lbl_title_desc:setString(ex.Tools:getLang(49314))
end

function RCGClergyPrivilegeLayer:eventRefreshForUP()
    ex.Player.promotion_data:checkClergyPrivilegeRedDot()

    self:refreshData()

    local offset = self.scroll_view:getContentOffset()
    self:refreshView()
    self.scroll_view:setContentOffset(offset)
end

function RCGClergyPrivilegeLayer:refreshData()
    self.cur_select_info = nil
    self.cur_unlock_info = nil
    self.list = {}

    local last_info = nil
    local sort_list = cfg.clergyprivilege.getSortConfigs()
    for i, v in ipairs(sort_list) do
        local data = {}
        data.config = v
        data.is_active = ex.Player.clergy_level >= v.clergy_level
        data.wait_active = last_info and (not data.is_active and last_info.is_active) or false
        
        table.insert(self.list, data)

        last_info = data
        
        if not self.cur_select_info or self.cur_select_info.config.clergy_level < v.clergy_level then
            -- 选择最大等级，满级显示用
            self.cur_select_info = data
        end

        if not data.is_active and (not self.cur_unlock_info or self.cur_unlock_info.config.clergy_level > v.clergy_level) then
            -- 找到最小未解锁
            self.cur_unlock_info = data
        end
    end

    if self.cur_unlock_info then
        self.cur_select_info = self.cur_unlock_info
    end
end

function RCGClergyPrivilegeLayer:refreshView()
    self:refreshScrollView()

    self:refreshBottom(self.cur_select_info)

    self:setSelected(self.cur_select_info)

    self:refreshCurClergy()
end

function RCGClergyPrivilegeLayer:refreshScrollView()
    local container = self.scroll_view:getContainer()
    container:removeAllChildren()

    self.cell_list = {}
    local item_size, max_height = nil, 0
    for i,v in ipairs(self.list) do
        if v.config.clergy_level > 0 then
            local item = RCGClergyPrivilegePos:createWithCCBIFile("ccbi/RCGClergyPrivilegePos.ccbi")
            item:setAnchorPoint(ex.a.center)
            if not item_size then
                item_size = item:getContentSize()
            end
            item:setPosition(v.config.pos.px * 0.01 * ex.p.width - item_size.width / 2, v.config.pos.y - item_size.height / 2)
            -- item:setScale(1)
            item.menu:setIsTouchInsideNode(self.scroll_view)
            item:setLocalZOrder(20)
            self.scroll_view:addChild(item)
        
            item.click_callback = handler(self, self.changeSelected)
            item:initDone(v)

            table.insert(self.cell_list, item)

            max_height = v.config.pos.y
        end
    end

    -- 画线
    local last_item = nil
    for i,v in ipairs(self.cell_list) do
        if last_item then
            local line_file = last_item.data.is_active and "other/line-2.png" or "other/line-1.png"
            local world_space_point = v.menu:convertToWorldSpace(cc.p(v.btn_clergy_pos:getPosition()))
            local cur_pos = container:convertToNodeSpace(world_space_point)
            -- local cur_pos = cc.p(v.data.config.pos.px * 0.01 * ex.p.width, v.data.config.pos.y)
            world_space_point = last_item.menu:convertToWorldSpace(cc.p(last_item.btn_clergy_pos:getPosition()))
            local last_pos = container:convertToNodeSpace(world_space_point)
            -- local last_pos = cc.p(last_item.data.config.pos.px * 0.01 * ex.p.width, last_item.data.config.pos.y)
            local line_lenght = cc.pGetDistance(cur_pos, last_pos)
            local targetVec = cc.pSub(last_pos, cur_pos)
            local rotation = Maths.radiansToDegrees(cc.pGetAngle(targetVec, cc.p(1, 0)))
            
            local spr_bg = ccui.Scale9Sprite:createWithSpriteFrameName(line_file, cc.rect(20, 0, 44, 32));
            spr_bg:setContentSize(cc.size(line_lenght, 32))
            spr_bg:setAnchorPoint(cc.p(0, 0.5))
            spr_bg:setRotation(rotation)
            spr_bg:setPosition(cur_pos)
            spr_bg:setLocalZOrder(10)
            self.scroll_view:addChild(spr_bg)
        end

        last_item = v
    end

    self.scroll_view:setContentSize(cc.size(self.scroll_view:getViewSize().width, max_height + 160))
    self.scroll_view:setContentOffset(self.scroll_view:maxContainerOffset())
end

function RCGClergyPrivilegeLayer:adjustScrollViewPos(select_info)
    local pos_y = 0
    for i,v in ipairs(self.cell_list) do
        if v.data.config.clergy_level == select_info.config.clergy_level then
            pos_y = v.data.config.pos.y
            break
        end
    end

    local content_size = self.scroll_view:getContentSize()
    local view_size = self.scroll_view:getViewSize()
    if pos_y + view_size.height / 2 >= content_size.height then
        self.scroll_view:setContentOffset(self.scroll_view:minContainerOffset())
        return
    end
    if pos_y - view_size.height / 2 <= 0 then
        self.scroll_view:setContentOffset(self.scroll_view:maxContainerOffset())
        return
    end

    self.scroll_view:setContentOffset(cc.p(0, 0 - (pos_y - view_size.height / 2)))
end

function RCGClergyPrivilegeLayer:refreshBottom(select_info)
    self.lbl_clergy_title:setString(ex.Tools:getLang(select_info.config.lan_2))
    self.lbl_clergy_privilege_desc:setString(ex.Tools:getLang(select_info.config.lan_3))

    self.node_clergy_exp:setVisible(select_info.wait_active)
    self.node_progressbar:setVisible(select_info.wait_active)
    self.btn_active:setVisible(select_info.wait_active)

    self.node_no_active:setVisible(not select_info.wait_active and not select_info.is_active)
    self.node_active:setVisible(select_info.is_active)

    if select_info.wait_active then
        local lan_id = ex.Player.clergy_exp >= select_info.config.unlock_need_exp and 49302 or 49301

        self.lbl_exp_progressbar:setXmlTextLua(string.format(ex.Tools:getLang(lan_id), tostring(ex.Player.clergy_exp), tostring(select_info.config.unlock_need_exp)))
        self.exp_progressbar:setPercentage(100.0 * ex.Player.clergy_exp / select_info.config.unlock_need_exp)
        self.lbl_progressbar:setString(string.format("%d/%d", ex.Player.clergy_exp, select_info.config.unlock_need_exp))
    end
end

function RCGClergyPrivilegeLayer:refreshCurClergy()
    self.node_clergy_title:setVisible(ex.Player.clergy_level > 0)

    if ex.Player.clergy_level > 0 then
        ex.Tools:setSpriteFrame(self.spr_clergy_title, string.format("promotion-3/clergy-title-%d.png", ex.Player.clergy_level))
    end
end

function RCGClergyPrivilegeLayer:changeSelected(select_info)
    if select_info.config.clergy_level == self.cur_select_info.config.clergy_level then return end

    self.cur_select_info = select_info

    self:refreshBottom(self.cur_select_info)

    self:setSelected(self.cur_select_info)
end

function RCGClergyPrivilegeLayer:setSelected(select_info)
    for i,v in ipairs(self.cell_list) do
        v:setSelected(v.data.config.clergy_level == select_info.config.clergy_level)
    end
end

function RCGClergyPrivilegeLayer:onActive(tag, pSender)
    if not self.cur_select_info.wait_active then
        printError("RCGClergyPrivilegeLayer:onActive 当前不是等待激活状态")
        return
    end

    if ex.Player.clergy_exp < self.cur_select_info.config.unlock_need_exp then
        ex.ConfirmCtr:openWindow(ex.Tools:getLang(49305), ex.Tools:getLang(49306), function()
            ex.JumpManager:jumpByAtom("act_recharge_smart")
        end)
        return
    end

    local req = Clergy_pb.GReqUnlockClergyLevel()
    req.clergy_level = self.cur_select_info.config.clergy_level
    NetManager:sendMessage(ProtocolID.GReqUnlockClergyLevel, req)
end

return RCGClergyPrivilegeLayer