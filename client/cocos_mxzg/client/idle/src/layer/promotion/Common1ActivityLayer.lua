--[[
    func:第一号全屏窗口模板
    author:徐东浩
    time:2019-10-12 18:32:10
    版权所有:广州暗耀晶石网络信息科技有限公司
]]


local Common1ActivityLayer = class("Common1ActivityLayer", require("src.comp.EventLayer"))
local Common1ActivityCell = require("src.layer.promotion.Common1ActivityCell")
local CommonUIHelper = require("src.layer.promotion.CommonUIHelper")

-------------------------------------Common1ActivityLayer----------------------------------------------------
-- 界面布局调整
function Common1ActivityLayer:onCreate()
	self.tab_margin = 10
	self.tab_padding = 4
	
	self.atom = ""
	self.select_index = 1
	self.cur_promotion_pages = {}
	self.ui_layout_config = {}
	self.cur_layer = nil

    self:setAutoClose(false)
	self:setSwallowTouches(false)

	-- 铺展到全屏
	ex.Tools:AdjustFullScreenExtend(self.spr_bg)

	self.tab_menu = require("src.comp.menu.UIMenuGeneral"):create()
	self.tab_menu:setPosition(ex.p.zero)
	self.tab_menu:setSwallowsTouches(false)
	self.tab_menu:setTouchCallback(handler(self, self.onSelect))
	self.scroll_view:getContainer():addChild(self.tab_menu)

    self.btn_back:setPosition(self:getContentSize().width / 2 + ex.p.width / 2 / self:getScaleX() - 20 / self:getScaleX() - 60,
                              self:getContentSize().height / 2 + ex.p.height / 2 / self:getScaleY() - 100 / self:getScaleY() - 42 - require("src.model.Game"):instance():getNotchHeight())
							  
	-- self.btn_back:setPosition(110, self:getBottomY());
	self.btn_back:registerScriptTapHandler(handler(self, self.onBack))
	self.btn_back:getParent():setLocalZOrder(10)

	self.vec_reddot = {}

	self:addEvent(EVENT.COMMON_ACTIVITY_EVENT.REFRESH, handler(self, self.refresh))
	self:addEvent(EVENT.COMMON_ACTIVITY_EVENT.REFRESH_RED_POINT, handler(self, self.redPointRefresh))
	self:addEvent(EVENT.COMMON_ACTIVITY_EVENT.SWITCH_TAB, handler(self, self.switchTab))
end

function Common1ActivityLayer:onCreateDone(atom, select_index)
	self.atom = atom
	self.select_index = select_index or 1
	
	-- 加载窗体定制内容
	CommonUIHelper:ParseWinLayoutArgs(self.ui_layout_config.win_layout_args, self)
	
	self:initMenuTable()
	
	-- 选中界面
	self:onSelect(self.select_index, nil, true)
end

function Common1ActivityLayer:refresh(event)
	-- 强制刷新
	self:onSelect(self.select_index, nil, true)
end

function Common1ActivityLayer:redPointRefresh(event)
	print(">>>>>Common1ActivityLayer:redPointRefresh")
end

function Common1ActivityLayer:switchTab(event, idx)
	if idx == nil then
		return
	end

	local tag = self.select_index
	local children = self.tab_menu:getChildren()
	for i,v in ipairs(children) do
		if v ~= nil and v.idx == idx then
			tag = v:getTag()
			break
		end
	end

	self:onSelect(tag)
end

function Common1ActivityLayer:onExit()
	-- 移除红点节点
	local reddot_manager = ex.RedDotManager
	for k,v in pairs(self.vec_reddot) do
		 reddot_manager:removeStickNode(k, v)
	end
end

function Common1ActivityLayer:initMenuTable()
	self:removeRedDotNodeExit()
	
	self.vec_reddot = {}
	self.tab_menu:removeAllChildren()

	cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/promotion-tab-icon-2.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/promotion-2.plist")

	-- 创建顶层按钮
	local tab_cell_h_margin = 2
	local cell_size = cc.size(0, 0)
	local index = 0
	for i, v in ipairs(self.cur_promotion_pages) do
		local isShow = ex.Player.level >= v.checkLevelOpen
		if isShow and v.checkopen ~= "" and self[v.checkopen] then 
			isShow = self[v.checkopen]()
		end
		
		if isShow then 
			local cell = Common1ActivityCell:createWithCCBIFile("ccbi/Common1ActivityCell.ccbi")
			cell_size = cell:getContentSize()
			cell.idx = v.idx
			cell:setTag(i)
			cell:setPosition(self.tab_margin + index * (cell_size.width + self.tab_padding), tab_cell_h_margin)
			self.tab_menu:addChild(cell)
			
			-- 设置cell
			ex.Tools:setSpriteFrame(cell.spr_icon1, string.format("promotion/icon-%d-1.png", v.icon))
			ex.Tools:setSpriteFrame(cell.spr_icon2, string.format("promotion/icon-%d-2.png", v.icon))
			
			-- 设置红点节点
			if v.checkreddot ~= "" and ex.Player.promotion_data[v.checkreddot] then
				local bool = ex.Player.promotion_data[v.checkreddot](ex.Player.promotion_data)
				local reddot = tonumber(v.reddot)
				self.vec_reddot[reddot] = cell
				self:addRedDotNode(tonumber(reddot), cell)
			end
			
			index = index + 1
		end
	end
	
	local view_size = cc.size(ex.p.width, cell_size.height + 2 * tab_cell_h_margin)
	self.scroll_view:setViewSize(view_size)

	local notch_height = require("src.model.Game"):instance():getNotchHeight()
	local height_diff = ex.MainSceneCtr:getBottomHeight() - ex.MainSceneCtr:getMenuScaleHeight();
	local top_height = ex.p.height - (height_diff + 70) - 22 - notch_height;
	self.scroll_view:setPosition(ex.p.width * 0.5 - view_size.width * 0.5, top_height - view_size.height - 50)
	self.scroll_view:setBounceable(false)

	-- 设置列表宽度
	local width = index * cell_size.width + self.tab_margin * 2 + (index - 1) * self.tab_padding
    width = math.max(width , view_size.width)
    self.scroll_view:setContentSize(cc.size(width, view_size.height))
end

function Common1ActivityLayer:repositionTab(idx)
	local view_size = self.scroll_view:getViewSize()
	local content_size = self.scroll_view:getContentSize()
	local cell = self.tab_menu:getChildByTag(1)
	local cell_width = 170
	if cell ~= nil then
		cell_width = cell:getContentSize().width
	end

	self.scroll_view:setContentOffset(cc.p(math.max(view_size.width - content_size.width, -((self.select_index - 1) * (cell_width + self.tab_padding) + (self.select_index > 1 and self.tab_margin or 0))), 0), true)
end

function Common1ActivityLayer:onSelect(tag, pSender, is_force)
	-- 可能是一个空的列表
	ex.AudioManager:playEffect("music/button-click.mp3")
	
	-- 相同界面不创建
	if (is_force == nil or is_force == false) and self.select_index == tag then
		return
	end

	-- 创建对应的界面
	local config = self.cur_promotion_pages[tag]
	if config == nil then
		print("Common1ActivityLayer:onSelect config = NULL")
		return
	end

	if pSender == nil then
		pSender = self.tab_menu:getChildByTag(tag)
		if pSender == nil then
			printError(">>>>>Common1ActivityLayer:onSelect tag=%d menuitem is not found!", tag)
			return
		end
	end

	self.select_index = pSender:getTag()
	self.tab_menu:unselectAll()
	pSender:setSelected(true)

	self:repositionTab(self.select_index)
	
	if self.cur_layer ~= nil then
		self.cur_layer:removeFromParent()
		self.cur_layer = nil
	end

	cc.SpriteFrameCache:getInstance():addSpriteFrames(config.banner_plist)

	local sub_layout_config= self.ui_layout_config.sub_layer_config[self.select_index]
	
	if sub_layout_config.sub_type == CommonUIDefine.UIDefine.UISubLayoutType.EXTERNAL then
		-- 生成layer
		local layer = require("src.layer." .. config.layer):createWithCCBIFile("ccbi/".. ex.StringUtil.segment(config.layer, ".", true) ..".ccbi")
		layer:setLocalZOrder(10000)
		self:addChild(layer)

		self.cur_layer = layer
		layer.layer_promotion = self
		
		if layer.onCreateDone then
			layer:onCreateDone()
		end
	else
		local start_height = self:getTopY()
		local end_height = self:getBottomY()

		-- 添加子层
		self.cur_layer = CommonUIHelper:AssemblySubLayer(sub_layout_config, self, start_height, end_height)
	end
end

function Common1ActivityLayer:getTopY()
	return self.scroll_view:getPositionY()
end

function Common1ActivityLayer:getBottomY()
	return ex.MainSceneCtr:getBottomHeight() + 10
end

function Common1ActivityLayer:onBack(tag, pSender)
	if self.callback_back then
		self.callback_back()
	else
		ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
	end
end

return Common1ActivityLayer
