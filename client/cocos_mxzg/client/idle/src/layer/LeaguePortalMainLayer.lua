--[[
    func: 跨服时空主界面
    author:徐东浩
    time:2020-01-02 15:11:44
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local LeaguePortalMainLayer = class("LeaguePortalMainLayer", require("src.comp.EventLayer"))
local LeaguePortalMainCell = class("LeaguePortalMainCell", require("src.comp.EventLayer"))

-------------------------------------LeaguePortalMainCell----------------------------------------------------
function LeaguePortalMainCell:onCreate()
	self:setAutoClose(false)
    self:setSwallowTouches(false)
    
    self.data = {}
    self.start_pos = cc.p(36, 100)

    -- self.container = self.bg:getNormalImage()

    self.menu:setSwallowsTouches(false)

    self.lbl_desc = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 36)
    self.lbl_desc:setColor(cc.c3b(253, 232, 193))
    self.lbl_desc:setScale(0.5)
    self.lbl_desc:setAnchorPoint(ex.a.left_center)
	self.lbl_desc:setPosition(36, 34)
	self:addChild(self.lbl_desc)

    self.menu_item = cpp.UIMenu:create()
    self.menu_item:setSwallowsTouches(true)
    self.menu_item:setPosition(cc.p(0, 0))
    self.menu_item:setLocalZOrder(10)
    self:addChild(self.menu_item)

    self.bg:registerScriptTapHandler(handler(self, self.onEnter))
    self.bg:setEnableAction(false)
end

function LeaguePortalMainCell:initDone(data)
    self.data = data

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/fantasy-land-lang.plist")

    if self.data.game_id ~= 1000 then
        self.lbl_desc:setVisible(true)
        -- if self.data.game_id == 2 then
        --     self.lbl_desc:setString(ex.Tools:getLang(70301))
        -- elseif self.data.game_id == 1 then
        --     self.lbl_desc:setString(ex.Tools:getLang(52016))
        -- end
        if self.data.tip1 ~= "" then
            self.lbl_desc:setString(ex.Tools:getLang(self.data.tip1))
        end
    
        ex.Tools:setSpriteFrame(self.bg:getNormalImage(), string.format("fantasy-land-lang/fantasy-land-%d.png", self.data.game_id))


        for i,v in ipairs(self.data.reward_show) do
            local item = nil
            if v.item_num > 1 then
                item = ex.Player.backpack_data:createWithData(v.item_type, v.item_num)
            else
                item = ex.Player.backpack_data:createWithData(v.item_type, 0)
            end
            item:setPosition(self.start_pos.x + (item:getContentSize().width * 0.75) * (i - 0.5) + 10 * (i - 1), self.start_pos.y)
            item:setScale(0.75)
            item:registerScriptTapHandler(handler(self, self.onBtnInfo))
            self.menu_item:addChild(item)
        end
    else    -- game_id=1000,为敬请期待
        self.lbl_desc:setVisible(false)

        cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/slzm.plist")

        ex.Tools:setSpriteFrame(self.bg:getNormalImage(), "slzm/jqqd.png")
    end
end

function LeaguePortalMainCell:onEnter(tag, pSender)
    if self.data.game_id ~= 1000 then
        ex.JumpManager:jumpByAtom(self.data.atom)
    end
end

function LeaguePortalMainCell:onBtnInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-------------------------------------LeaguePortalMainLayer----------------------------------------------------
-- 界面布局调整
function LeaguePortalMainLayer:onCreate()
    self.cell_padding = 16
    
    self.config_type = 2
    self.data = {}
    
    self:setAutoClose(false)
	self:setSwallowTouches(false)
    ctr.alice:requestGetInfo()
	-- 铺展到全屏
	ex.Tools:AdjustFullScreenExtend(self.spr_bg)
    
    local pos_y = ex.p.height - 100 * ex.s.global_scale - require("src.model.Game"):instance():getNotchHeight()
    self.node_top:setPositionY(pos_y)
    
    self.cell_size = cc.size(552 * ex.s.global_scale, 212 * ex.s.global_scale)
    self.cell_margin = (ex.p.width - self.cell_size.width) / 2
    self.scroll_view_size = cc.size(ex.p.width, pos_y - self.node_top:getContentSize().height - 20 - self:getBottomY() - 20)
    self.scroll_view_position = cc.p(0, self:getBottomY() + 20)

    self.scroll_view = cc.ScrollView:create(self.scroll_view_size)
    self.scroll_view:setAnchorPoint(ex.a.left_bottom)
    self.scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.scroll_view:setPosition(self.scroll_view_position)
    self.scroll_view:setBounceable(false)
    self.scroll_view:setLocalZOrder(10)
    self:addChild(self.scroll_view)

    self.btn_back:registerScriptTapHandler(handler(self, self.onBack))
    
    self:onCreateDone()
end

function LeaguePortalMainLayer:onCreateDone()
	self:updateView()
end

function LeaguePortalMainLayer:updateView()
    self:generateData()
    
    self:refreshPortals()

    ex.Player.super_stage_data:reqInfo()
end

function LeaguePortalMainLayer:onExit()
	-- 移除红点节点
end

function LeaguePortalMainLayer:generateData()
    self.data.list = cfg.gamerewardshow.getConfigListByType(self.config_type)
end

function LeaguePortalMainLayer:refreshPortals()
    local sfc = cc.SpriteFrameCache:getInstance() 
    sfc:addSpriteFrames("ccbi-res/fantasy-land.plist")

    -- 创建顶层按钮
    local count = #self.data.list
    local real_height = self.cell_padding * 2 + count * self.cell_size.height + (count - 1) * self.cell_padding
    local content_size = cc.size(self.scroll_view_size.width, math.max(self.scroll_view_size.height, real_height))
    self.scroll_view:setContentSize(content_size)
    self.scroll_view:setContentOffset(self.scroll_view:minContainerOffset())

    self.scroll_view:setTouchEnabled(real_height > self.scroll_view_size.height)

    local container = self.scroll_view:getContainer()
	container:removeAllChildren()



	for i, v in ipairs(self.data.list) do
        local cell = LeaguePortalMainCell:createWithCCBIFile("ccbi/LeaguePortalMainCell.ccbi")
        cell:setAnchorPoint(ex.p.zero)
        cell:setScale(ex.s.global_scale)
        cell:setPosition(self.cell_margin, content_size.height - i * (self.cell_size.height + self.cell_padding))
        container:addChild(cell)

        -- 设置cell
        cell:initDone(v)

        if v.reddot ~= "" then
            self:addRedDotNode(tonumber(v.reddot), cell.bg)
        end
        
        cell.menu:setIsTouchInsideNode(self.scroll_view)
        cell.menu_item:setIsTouchInsideNode(self.scroll_view)
	end
end

function LeaguePortalMainLayer:getBottomY()
	return ex.MainSceneCtr:getBottomHeight() + 10
end

function LeaguePortalMainLayer:onBack(tag, pSender)
	if self.callback_back then
		self.callback_back()
	else
		ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
	end
end

return LeaguePortalMainLayer
