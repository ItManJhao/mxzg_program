local FettersSelectCtr = class("FettersSelectCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local FettersSelectLayer = class("FettersSelectLayer", require("src.comp.LuaLayerBase"))
local FetterDescLayer = class("FetterDescLayer", require("src.comp.LuaLayerBase"))
local FettersSelectCell = class("FettersSelectCell", require("src.comp.LuaLayerBase"))

function FetterDescLayer:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
end

function FettersSelectCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	self.btn_select:setLabelSize(42)
end


function FettersSelectLayer:onCreate()
	local win_size = cc.Director:getInstance():getWinSize()
	local height = Maths.min(self:getContentSize().height, win_size.height)
	self:setScale(height / self:getContentSize().height)
	self:addBlackBackground()
end

-----------------------------------------------------------------------------
function FettersSelectCtr:onCreate()
	self:setCCBIPath("ccbi/FettersSelectLayer.ccbi")
	self:setIsSingle(false)
end

function FettersSelectCtr:getLayerClass()
	return FettersSelectLayer
end

function FettersSelectCtr:getFettersSelectLayer()
	return self.layer
end

function FettersSelectCtr:openWindow(callback,
									select_type)
	if self:isOpened() then
		return
	end

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/fetters-select-lang.plist")
	
	self:loadLayer()
	self:open()
	self:initData(callback, select_type)
end

function FettersSelectCtr:initData(callback,
								   select_type)
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

	self.select_type = select_type

	-- 
	local vec_fetters = {}
	for k,v in pairs(cfg.goddessunlock.goddessunlock) do
		table.insert(vec_fetters, v.type)
	end

	local sort = function(a,b)
		return a.type > b.type
	end

	table.sort(vec_fetters)
	
	local evtLayer = cc.Layer:create()
	evtLayer:setVisible(false)
    evtLayer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    evtLayer:registerScriptTouchHandler(function(event)
		if event == "began" then
			evtLayer:setTouchEnabled(false)
			evtLayer:setVisible(false)
            return true
        end
	end)

	self.layer:addChild(evtLayer)
	
	local skillDescLayer = FetterDescLayer:createWithCCBIFile("ccbi/FetterDescLayer.ccbi")
	skillDescLayer:setPosition(
		(self.layer:getContentSize().width - skillDescLayer:getContentSize().width) / 2,
		self.layer:getContentSize().height / 2
	)
	evtLayer:addChild(skillDescLayer)

	local layer = self.layer
    local sfc = cc.SpriteFrameCache:getInstance()
    local vec_halo = vec_fetters
    local cell_size = FettersSelectCell:createWithCCBIFile("ccbi/FettersSelectCell.ccbi"):getContentSize()

    layer.callback = callback

    cell_size.height = cell_size.height + 5
    local scale = layer.scroll_view:getViewSize().width / cell_size.width
    cell_size.height = cell_size.height * scale + 5

    local height = table.nums(vec_halo) * cell_size.height
    height = math.max(height , layer.scroll_view:getViewSize().height)
    layer.scroll_view:getContainer():removeAllChildren()
    layer.scroll_view:setContentSize(cc.size(layer.scroll_view:getViewSize().width, height))
	layer.scroll_view:setContentOffset(cc.p(0, layer.scroll_view:getViewSize().height - height))

	for i,v in ipairs(vec_fetters) do
    	local data = cfg.goddessunlock.goddessunlock[v]
		local fetter_data = ex.Player.fetter_data:getFetterData(data.type)
		local cell = FettersSelectCell:createWithCCBIFile("ccbi/FettersSelectCell.ccbi")
        cell.data = data
        cell:setScale(scale)
		cell:setAnchorPoint(0, 0)
        cell:setPosition(0, height - i * cell_size.height)
        layer.scroll_view:getContainer():addChild(cell)

        --ex.Tools:setSpriteFrame(cell.spr_icon, string.format("fetters/%d.png", cell.data.type))
		
		local banner_image = cc.Sprite:createWithSpriteFrameName(string.format("fetters-lang/%d.png", cell.data.type))
		if not banner_image then
			banner_image = cc.Sprite:createWithSpriteFrameName(string.format("fetters-lang/%d.png", cell.data.type))
		end

		local bannerScale = cell:getContentSize().width / banner_image:getContentSize().width
		banner_image:setScale(bannerScale)
		banner_image:setPosition(cell:getContentSize().width * 0.5, cell:getContentSize().height * 0.5)

		local num0Spr = cc.Sprite:createWithSpriteFrameName('fetters/n0.png')

		local levelIndex = 0
		local fetterLevel = fetter_data.level
		while fetterLevel > 0 do
			local mod = math.fmod(fetterLevel, 10)
			local path = string.format("fetters/n%d.png", mod)
			local nSprite = cc.Sprite:createWithSpriteFrameName(path)
			nSprite:setPositionX(-levelIndex * num0Spr:getContentSize().width)
			cell._levelStartPointer:addChild(nSprite)

			fetterLevel = math.floor(fetterLevel / 10)
			levelIndex = levelIndex + 1
		end

		cell.spr_image:addChild(banner_image)

		-- cell.lbl_name:setString(ex.Tools:getLang(3000000 + cell.data.type))
		-- cell.lbl_des:setString(ex.Player.fetter_data:getSkillInfo(cell.data.type, math.max(fetter_data and fetter_data.skill_level or 1, 1)))

		-- cell.lbl_name:setString(ex.Player.hero_data:getSkillName(ex.Player.fetter_data:getSkillType(cell.data.type)))
		-- cell.lbl_des:setString(ex.Player.hero_data:getSkillDescription(ex.Player.fetter_data:getSkillType(cell.data.type), math.max(fetter_data and fetter_data.skill_level or 1, 1)))


		--cell.lbl_name:enableOutline(FONT_BLACK_C4B,3)
		--cell.lbl_des:enableOutline(FONT_BLACK_C4B,3)

		local skillName = ex.Player.hero_data:getSkillName(ex.Player.fetter_data:getSkillType(cell.data.type))
		local skillDesc = ex.Player.hero_data:getSkillDescription(ex.Player.fetter_data:getSkillType(cell.data.type), math.max(fetter_data and fetter_data.skill_level or 1, 1))

		cell.btn_select:registerScriptTapHandler(handler(self, self.onSelect))
		cell._viewDescBtn:registerScriptTapHandler(function()
			skillDescLayer._skillNameLabel:setString(skillName)
			skillDescLayer._skillDescLabel:setString(skillDesc)
			evtLayer:setVisible(true)
			evtLayer:setTouchEnabled(true)
		end)

        if not fetter_data or fetter_data.level <= 0 then
			-- cell.btn_select:setLabelText(ex.Tools:getLang(47479))
			-- cell.btn_select:setNormalImage(cc.Sprite:createWithSpriteFrameName("button/btn-green-big-2.png"))
			-- cell.btn_select:setSelectedImage(cc.Sprite:createWithSpriteFrameName("button/btn-green-big-2.png"))
			cell.btn_select:setVisible(false)
			cell._unlockVipTips:setVisible(true)
			cpp.ShaderFactory:instance():setAllChildren(cell._unlockVipTips, ShaderType.ST_POSITION_TEXTURE_GRAY)
			if data.vip_level >= 10 then
				cell._vipNum2:setVisible(true)
				local num1 = math.floor(data.vip_level / 10)
				local num2 = math.fmod(data.vip_level, 10)
				ex.Tools:setSpriteFrame(cell._vipNum1, string.format('fetters/%d.png', num1))
				ex.Tools:setSpriteFrame(cell._vipNum2, string.format('fetters/%d.png', num2))

				-- cell._vipNum1:setSpriteFrame(string.format('fetters/%d.png', num1))
				-- cell._vipNum2:setSpriteFrame(string.format('fetters/%d.png', num2))

				local vipNum1Width = cell._vipNum1:getContentSize().width
				local vipNum2Width = cell._vipNum2:getContentSize().width
				cell._vipNum1:setPositionX(cell._vipNum1:getPositionX() - vipNum2Width)
				local vipLabelX = cell._vipLabel:getPositionX()
				cell._vipLabel:setPositionX(vipLabelX - vipNum2Width)
			else
				ex.Tools:setSpriteFrame(cell._vipNum1, string.format('fetters/%d.png', data.vip_level))
				-- cell._vipNum1:setSpriteFrame(string.format('fetters/%d.png', data.vip_level))
			end
		elseif cell.data.type == self.select_type then
			-- cell.btn_select:setVisible(false)
        	cell.btn_select:setLabelText(ex.Tools:getLang(47029))
			cell.btn_select:setNormalImage(cc.Sprite:createWithSpriteFrameName("button/btn-orange-big-1.png"))
			cell.btn_select:setSelectedImage(cc.Sprite:createWithSpriteFrameName("button/btn-orange-big-1.png"))
			cell._descViewContainer:setVisible(true)
        else
			cell.btn_select:setLabelText(ex.Tools:getLang(47232))
			cell.btn_select:setNormalImage(cc.Sprite:createWithSpriteFrameName("button/btn-green-big-1.png"))
			cell.btn_select:setSelectedImage(cc.Sprite:createWithSpriteFrameName("button/btn-green-big-1.png"))
			cell._descViewContainer:setVisible(true)
		end
    end
end

function FettersSelectCtr:onSelect(tag, pSender)
	local cell = pSender:getParent():getParent()
	local type = cell.data.type

	local fetter_data = ex.Player.fetter_data:getFetterData(cell.data.type)
	if not fetter_data or fetter_data.level <= 0 then
		ex.MessageView:add(ex.Tools:getLang(47479))
		return
	end

	if type == self.select_type then
		-- type = 0
		return
	end
	
	-- 判断是否解锁。
	print("type", type)

	-- TEST
	local vip_level = 1

	if self.layer.callback ~= nil then
		self.layer.callback(type)
	end
	ex.MessageView:add(ex.Tools:getLang(41323))
	self:closeWindow()
end

return FettersSelectCtr
