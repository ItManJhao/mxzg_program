local ChooseServerCtr = class("ChooseServerCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ChooseServerLayer = class("ChooseServerLayer", require("src.comp.EventLayerAdaptiveWidth"))
local ChooseServerCell = class("ChooseServerCell", require("src.comp.LuaLayerBase"))
local ChooseServerRoleCell = class("ChooseServerRoleCell", require("src.comp.LuaLayerBase"))

function ChooseServerCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	self:setName("cell_layer")

	self:setPosition(cc.p(0, 0))
	self:setAnchorPoint(cc.p(0, 0))

	self.spr_role:setVisible(false)
end

function ChooseServerCell:initData(data)
	self.server_data = data

	self.lbl_server_name:setString(data.server_name)
	self.spr_best:setVisible(data.is_commend == 1)
	self.spr_cell_bg:setVisible(data.is_selected == nil or data.is_selected == false)

	local now = ex.Game:getServerTime()

	if data.server_status == 3 or data.server_status == 0 or data.defend_end_time > now then
		self.spr_server_statue:setSpriteFrame("choose-server/spot-disabled.png")
	elseif data.server_status == 1 then
		self.spr_server_statue:setSpriteFrame("choose-server/spot-full.png")
	else
		self.spr_server_statue:setSpriteFrame("choose-server/spot-normal.png")
	end

	self.spr_role:setVisible(data.role_name ~= nil and string.len(data.role_name) > 0)
end

function ChooseServerRoleCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	self:setName("cell_layer")

	self:setPosition(cc.p(0, 0))
	self:setAnchorPoint(cc.p(0, 0))
end

function ChooseServerRoleCell:initData(data)
	self.data = data

	self.lbl_name:setString(data.role_name)
	self.lbl_level:setString("Lv."..data.role_level)
	self.spr_photo:setSpriteFrame("head-icon/"..data.role_head..".png")
	if data.role_border > 0 then
		self.spr_border:setSpriteFrame("backpack/"..(1005000 + data.role_border)..".png")
	else
		self.spr_border:setSpriteFrame("backpack/border-default.png")
	end
end

function ChooseServerLayer:onCreate()
	self:setAutoClose(false)
	self:addBlackBackground()

	-- local win_size = cc.Director:getInstance():getWinSize()
	-- local height = math.min(self:getContentSize().height, win_size.height)
	-- self:setScale(height / self:getContentSize().height)
    local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/head-icon-lang.plist")
	sfc:addSpriteFrames("ccbi-res/head-icon-1.plist")
	sfc:addSpriteFrames("ccbi-res/hero-icon-other.plist")
	
    -- 初始化tableview
    self.scroll_view:setItemSize(cc.size(self.scroll_view:getViewSize().width, 85))
	self.scroll_view:setItemType(1)
	self.scroll_view.createItemFunction = function(data, scale)
		if data.is_role_info ~= nil and data.is_role_info == true then
			-- 创建ccbi cell
			local cell = ChooseServerRoleCell:createWithCCBIFile("ccbi/ChooseServerRoleCell.ccbi")
			cell:setIgnoreAnchorPointForPosition(false)
			cell:setAnchorPoint(0.5, 0.5)
		
			cell:initData(data)
			cell.data = data
		
			return cell
		else
			-- 创建ccbi cell
			local cell = ChooseServerCell:createWithCCBIFile("ccbi/ChooseServerCell.ccbi")
			cell:setIgnoreAnchorPointForPosition(false)
			cell:setAnchorPoint(0.5, 0.5)

			cell:initData(data)
			cell.data = data

			return cell
		end
    end
end

-----------------------------------------------------------------------------
function ChooseServerCtr:onCreate()
	self:setCCBIPath("ccbi/ChooseServerLayer.ccbi")
	self:setIsSingle(false)

	self.select_range_idx = -1			-- 当前选中页数
    self.select_server_id = -1			-- 当前选中服务器
	
    self.vec_data_server_page = {}		-- 服务器页列表
    self.vec_data_server = {}			-- 服务器分页内的列表
    self.vec_data_role = {}				-- 有创建角色的列表
    self.vec_data_suggest = {}			-- 服务器推荐列表
end

function ChooseServerCtr:getLayerClass()
	return ChooseServerLayer
end

function ChooseServerCtr:getChooseServerLayer()
	return self.layer
end

-- 选择服务器界面 
-- @param is_white: 是否是白名单账号
function ChooseServerCtr:openWindow(is_white)
	if self:isOpened() then
		return
	end

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/backpack-4.plist")
	sfc:addSpriteFrames("ccbi-res/head-icon-1.plist")

	-- self:loadLayer()
	self:open()
	self:initData(is_white)

    ex.PlatformHttpRequest:getServerPageList(handler(self, self.receiveServerPageList))
    ex.PlatformHttpRequest:getServerRoleList(handler(self, self.receiveServerRoleList))
    ex.PlatformHttpRequest:getServerSuggestList(handler(self, self.receiveServerSuggestList))
end

function ChooseServerCtr:initData(is_white)
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

	self.layer.scroll_view.nodeTouched = function(tag, node)
		self:tableCellTouched(node.data)
	end
	
	self.is_white = is_white
	-- self.is_white = 0

	self.vec_data_server_page = {}
	self.select_range_idx = 9999999
	self.select_role_idx = -1

	self:updateScrollViewTab()
	self:updateScrollView()
end

-- 获取服务器大区列表回调
function ChooseServerCtr:receiveServerPageList(value)
	self.vec_data_server_page = {}
	for i,v in ipairs(value.data) do
		local data = {}
		data.page_idx = tonumber(v.sort)
		data.page_id = tonumber(v.id)
		data.page_name = v.name
		table.insert(self.vec_data_server_page, data)
	end

	-- 空出列表前两个位置，加上角色和推荐
	local data = {}
	data.page_idx = 9999998
	data.page_id = -2
	data.page_name = ex.Tools:getLang(47503)
	-- self.vec_data_server_page[1] = clone(data)
	table.insert(self.vec_data_server_page, clone(data))

	data = {}
	data.page_idx = 9999999
	data.page_id = -1
	data.page_name = ex.Tools:getLang(47495)
	-- self.vec_data_server_page[2] = clone(data)
	table.insert(self.vec_data_server_page, clone(data))

	-- 根据page_idx值，对列表进行排序
	table.sort(self.vec_data_server_page, function(a, b)
		return a.page_idx < b.page_idx
	end)

	if self.layer == nil then
		return
	end

	if self.select_range_idx <= 0 then
		self.select_range_idx = table.nums(self.vec_data_server_page)
	end

	self:updateScrollViewTab()
end

-- 获取服务器角色列表回调
function ChooseServerCtr:receiveServerRoleList(value)
	self.vec_data_role = {}
	for i,v in ipairs(value.data) do
		if (self.is_white ~= nil and self.is_white > 0) or tonumber(v.server_status) > 0 then
		local data = {}
			data.role_name = v.role_name
			data.role_level = tonumber(v.level)
			data.role_head = tonumber(v.head_id)
			data.role_border = tonumber(v.border_id)

			data.server_url = v.server_url
			data.server_port = v.server_port
			data.msg = v.msg
			data.server_id = tonumber(v.sid)
			data.server_name = v.show_name
			data.sort = tonumber(v.sort)
			data.server_status = tonumber(v.server_status)
			data.defend_end_time = tonumber(v.defend_end_time)     -- 维护结束时间
			data.is_commend = tonumber(v.is_commend)

			table.insert(self.vec_data_role, data)
		end
	end

	table.sort(self.vec_data_role, function(a, b)
		return a.sort > b.sort
	end)

	if self.layer == nil then
		return
	end

	self:updateScrollView()
end

-- 获取服务器推荐列表回调
function ChooseServerCtr:receiveServerSuggestList(value)
	self.vec_data_suggest = {}
	for i,v in ipairs(value.data) do
		if (self.is_white ~= nil and self.is_white > 0) or tonumber(v.server_status) > 0 then
			local data = {}
			data.server_url = v.server_url
			data.server_port = v.server_port
			data.msg = v.msg
			data.server_id = tonumber(v.sid)
			data.server_name = v.show_name
			data.sort = tonumber(v.sort)
			data.server_status = tonumber(v.server_status)
			data.defend_end_time = tonumber(v.defend_end_time)     -- 维护结束时间
			data.is_commend = tonumber(v.is_commend)

			table.insert(self.vec_data_suggest, data)
		end
	end

	table.sort(self.vec_data_suggest, function(a, b)
		return a.sort > b.sort
	end)

	if self.layer == nil then
		return
	end

	self:updateScrollView()
end

-- 获取分页服务器列表
function ChooseServerCtr:receiveServerListByPage(value)
	local cur_page_id = 0
	for i,v in ipairs(self.vec_data_server_page) do
		if v.page_idx == self.select_range_idx then
			cur_page_id = v.page_id
			break
		end
	end
	if value.data.big_server_id == nil or cur_page_id ~= tonumber(value.data.big_server_id) then
		return
	end

	self.is_show_server_full_tip = value.data.is_server_full_tip ~= nil and tonumber(value.data.is_server_full_tip) == 1

	self.vec_data_server = {}
	for i,v in ipairs(value.data.data) do
		if (self.is_white ~= nil and self.is_white > 0) or tonumber(v.s_s) > 0 then
			local data = {}
			data.server_url = v.s_u
			data.server_port = v.s_p
			data.msg = v.msg or ""
			data.server_id = tonumber(v.sid)
			data.server_name = v.s_name
			data.sort = tonumber(v.sort)
			data.server_status = tonumber(v.s_s)
			data.defend_end_time = tonumber(v.det or 0)     -- 维护结束时间
			data.is_commend = tonumber(v.is_comd or 0)

			table.insert(self.vec_data_server, data)
		end
	end

	table.sort(self.vec_data_server, function(a, b)
		return a.sort > b.sort
	end)

	if self.layer == nil then
		return
	end

	self:updateScrollView()
end

function ChooseServerCtr:updateScrollViewTab()
	if self.layer == nil then
		return
	end

	local layer = self.layer
	if layer.scroll_view_tab then
		layer.scroll_view_tab:removeFromParent()
		layer.scroll_view_tab = nil
	end

	layer.scroll_view_tab = cc.ScrollView:create(cc.size(layer.spr_tab_bg:getContentSize().width  * layer.spr_tab_bg:getScaleX(),
                            							 layer.spr_tab_bg:getContentSize().height * layer.spr_tab_bg:getScaleY() - 10))
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    :setPosition(layer.spr_tab_bg:getPositionX(),
                 layer.spr_tab_bg:getPositionY() + 5)
    layer:addChild(layer.scroll_view_tab)

	local menu_tab = cpp.UIMenu:create()
    menu_tab:setIsTouchInsideNode(layer.scroll_view_tab)
    menu_tab:setSwallowsTouches(false)
    menu_tab:setPosition(cc.p(0, 0))
    layer.scroll_view_tab:addChild(menu_tab)

	local item_size = cc.size(0, 0)
    for i, v in ipairs(self.vec_data_server_page) do
		local btn_tab = cpp.UIMenuItemTab:create("choose-server/btn-server-1.png",
                              	  				  "choose-server/btn-server-2.png",
                              	  				  "",
                              	  				  1,
                              	  				  1)

        btn_tab:setPosition(80, (i - 0.5) * 70)
		btn_tab:setTag(v.page_idx)
		btn_tab.data = v
        btn_tab:registerScriptTapHandler(handler(self, self.onServerTab))
		menu_tab:addChild(btn_tab)
		
		if item_size.width <= 0 then
			item_size = btn_tab:getContentSize()
		end

        btn_tab:setLabelText(v.page_name)

		if self.select_range_idx == v.page_idx then
			btn_tab:setChecked(true)
		end

		-- btn_tab:getLabel():enableShadow()
		btn_tab:setLabelColor(FONT_BROWN)
    end

	local page_count = table.nums(self.vec_data_server_page)
	local view_height = page_count * 70
	local view_size = layer.scroll_view_tab:getViewSize();
    layer.scroll_view_tab:setContentSize(cc.size(view_size.width, view_height))
    layer.scroll_view_tab:setContentOffset(cc.p(0, view_size.height - view_height))
end

function ChooseServerCtr:updateScrollView()
	if self.layer == nil then
		return
	end

	if self.select_range_idx > 9000000 then
		if self.select_range_idx == 9999999 then
			self.layer.scroll_view:reloadData(self.vec_data_suggest)
		else
			local vec_tmp = {}
			for i,v in ipairs(self.vec_data_role) do
				local data = clone(v)
				data.is_role_info = false
				if tonumber(v.sort) == self.select_role_idx then
					data.is_selected = true
				end
				table.insert(vec_tmp, data)
			end

			-- 如果已选中项，则将选中项数据加入数组
			for i,v in ipairs(self.vec_data_role) do
				if tonumber(v.sort) == self.select_role_idx then
					local data = clone(v)
					data.is_role_info = true
					table.insert(vec_tmp, data)
				end
			end

			table.sort(vec_tmp, function(a, b)
				if a.sort ~= b.sort then 
					return tonumber(a.sort) > tonumber(b.sort) 
				end
				return not a.is_role_info
			end)

			self.layer.scroll_view:reloadData(vec_tmp)
		end
	else
		self.layer.scroll_view:reloadData(self.vec_data_server)
	end
end	

function ChooseServerCtr:onServerTab(tag, pSender)
	local data = pSender.data
	if data.page_idx == self.select_range_idx then
		return
	end

	self.select_range_idx = data.page_idx
	self.select_role_idx = -1
	self.vec_data_server = {}

	-- 角色和推荐列表不需要请求分页列表
	if self.select_range_idx <= 9000000 then
		-- 请求分页服务器列表
		ex.PlatformHttpRequest:getServerListByPage(handler(self, self.receiveServerListByPage), data.page_id)
	end

	self:updateScrollView()
end

-- 点击cell回调
function ChooseServerCtr:tableCellTouched(data)
	--[[
		1、如果为我的角色栏
			a、如果点击的是服务器cell
				I、如果该项已选中则隐藏角色cell
				II、如果该项未选中则显示角色cell
			b、如果点击的是角色cell则弹进入服务器确认框
		2、如果该服务器非新服并且爆满，而且该服上没有该角色的账号，则弹出提示，无法进入该服
		3、如果为其他选择栏则弹进入服务器确认框
	]]

	if self.select_range_idx == 9999998 then
		if self.select_role_idx == nil or self.select_role_idx <= 0 or self.select_role_idx ~= tonumber(data.sort) then
			self.select_role_idx = tonumber(data.sort)
			self:updateScrollView()
			return
		else
			if not data.is_role_info then
				self.select_role_idx = -1
				self:updateScrollView()
				return
			end
		end
	end

	if self.select_range_idx < 9000000 and self.is_show_server_full_tip then
		if (self.is_white == nil or self.is_white <= 0) and data.server_status == 1 then
			local is_has_account = false
			for i,v in ipairs(self.vec_data_role) do
				if v.server_id == data.server_id then
					is_has_account = true
					break
				end
			end
			local is_suggest = false
			for i,v in ipairs(self.vec_data_suggest) do
				if v.server_id == data.server_id then
					is_suggest = true
					break
				end
			end
			if is_has_account == false and is_suggest == false then
				ex.MessageView:add(ex.Tools:getLang(5804))
				return
			end
		end
	end

	self.selected_server = data

	local now = ex.Game:getServerTime()
	if (self.selected_server.server_status == 3 or self.selected_server.server_status == 0 or self.selected_server.defend_end_time > now) and 
		(self.is_white == nil or self.is_white <= 0) then
		if self.selected_server.msg and string.len(self.selected_server.msg) >= 0 then
			ex.MessageView:add(self.selected_server.msg)
		else
			ex.MessageView:add(ex.Tools:getLang(47159))
		end
		return
	end

    -- 打开选择服务器确认框
	local str_content = ex.Tools:getLang(47467) .. self.selected_server.server_name .. ex.Tools:getLang(47096)
    require("src.layer.ConfirmCtr"):instance():openWindow(ex.Tools:getLang(47209),
														  str_content,
                                 						  handler(self, self.onConfirmDone))
end

function ChooseServerCtr:onConfirmDone()
	if self.selected_server == nil then
		ex.MessageView:add(ex.Tools:getLang(47496))
		return
	end
	
	local now = ex.Game:getServerTime()

	if (self.selected_server.server_status == 3 or self.selected_server.server_status == 0 or self.selected_server.defend_end_time > now) and 
		(self.is_white == nil or self.is_white <= 0) then
		if self.selected_server.msg and string.len(self.selected_server.msg) >= 0 then
			ex.MessageView:add(self.selected_server.msg)
		else
			ex.MessageView:add(ex.Tools:getLang(47159))
		end
		return
	end

	-- require("src.platform.SocialPlatform"):submitRoleInfoLua("select_server")
	require("src.scene.LogoSceneCtr"):instance():onChooseServerDone(self.selected_server)
	require("src.scene.LogoSceneCtr"):instance():onStartGame()
	self:closeWindow()
end

return ChooseServerCtr
