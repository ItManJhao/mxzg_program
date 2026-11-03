local HeroSuggestCtr = class("HeroSuggestCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroSuggestLayer = class("HeroSuggestLayer", require("src.comp.EventLayerAdaptiveWidth"))
local HeroSuggestCell = class("HeroSuggestCell", require("src.comp.LuaLayerBase"))
local HeroStrongInfoCell = class("HeroStrongInfoCell", require("src.comp.LuaLayerBase"))
local HeroStrongResourceSubCell = class('HeroStrongResourceSubCell', require("src.comp.EventLayer"))

local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

local getstrongConfig = cfg.getstrong.getstrong
local HERO_SCORE_MAP = {
	level = {
		icon = 'hero-strong-icon/hero-level.png',
		config = getstrongConfig[1]
	},

	equip = {
		icon = 'hero-strong-icon/equip.png',
		config = getstrongConfig[2]
	},

	star = {
		icon = 'hero-strong-icon/hero-star.png',
		config = getstrongConfig[3]
	},

	grade = {
		icon = 'hero-strong-icon/hero-grade.png',
		config = getstrongConfig[4]
	},

	fetter = {
		icon = 'hero-strong-icon/fetter.png',
		config = getstrongConfig[5]
	},

	clan_skill = {
		icon = 'hero-strong-icon/clan-skill.png',
		config = getstrongConfig[6]
	},

	runes = {
		icon = 'hero-strong-icon/runes.png',
		config = getstrongConfig[7]
	},
}

function HeroSuggestCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)


	self.menu:setSwallowsTouches(false)

	local scale_label = 0.5
    self.lbl_desc = require("src.comp.RichTextEx"):create()
	:setFontSize(40)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#5A3509")
    :setScale(scale_label)
    :setAnchorPoint(0, 1)
	:setAnchorTextShadow(true)
	:ignoreContentAdaptWithSize(false)
	:setWrapMode(1)
	:setPosition(10, 60)
	self.lbl_desc:setContentSize(cc.size((self:getContentSize().width - 20) / scale_label, 100 / scale_label))
    self:addChild(self.lbl_desc, 10001)
end

function HeroSuggestCell:setTableView(table_view)
	self.menu:setIsTouchInsideNode(table_view)
end

function HeroSuggestCell:reset(data)

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/hero-info-lang.plist")

	self.lbl_title:setString(ex.Tools:getLang(data.name_lang))

	self.lbl_desc:setXmlTextLua(ex.Tools:getLang(data.description_lang))
	self.lbl_desc:formatText()

	for i,v in ipairs(data.line_up) do
		local item = UIMenuItemHero:createWithData("1", v.hero_type, nil, nil, v.star)
		item:setIcon(v.hero_type)
		item:setIconScale(v.hero_type == 0 and 1.3 or nil)
		
		item:removeLevel()
		item:setEnableAction(false)
		item:setScale(0.8)
		item:setPosition(90 * (i - 0.5) + 10, 120)
		self.menu:addChild(item, 1000 - i)

		-- 判断是否有该英雄
		item:showHas(v.hero_type ~= 0 and ex.Player.hero_data:getHeroDataByType(v.hero_type) ~= nil, 1.3)


		item.hero_data = v

		item:registerScriptTapHandler(handler(self, self.onHeroIcon))
	end
end

-- 点击英雄icon需要跳转到对应英雄图鉴
function HeroSuggestCell:onHeroIcon(tag, pSender)
	if pSender.hero_data.hero_type == 0 then
		return
	end

	local callback = function ()
		ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
		HeroSuggestCtr:instance():openWindow()
		HeroSuggestCtr:instance():onChangeLayer(4)
	end

	local layer = ex.MainSceneCtr:changeLayer(MainSceneType.HERO_ILLUSTRAT_INFO_LAYER)
	layer:showData(pSender.hero_data.hero_type, pSender.hero_data.star, callback)
	HeroSuggestCtr:instance():closeWindow()

	require("src.comp.LuaNodeCtr"):closeOtherWindow()
end

-----------------------------------------------------------------------------
function HeroStrongInfoCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	self._iconSprite = cc.Sprite:create()
	self._iconPointer:addChild(self._iconSprite)

	self._progressSprite = self:_createProgress()
	self:addChild(self._progressSprite)

	self._progressLabel = self:_createProgressLabel()
	self:addChild(self._progressLabel)

	self._gotoBtn:registerScriptTapHandler(function()
		if self._config.jump_info.event_type == 1 then
			ex.JumpManager:jumpByAtom(self._config.jump_info.event_arg)
			local ctr = HeroSuggestCtr:instance()
			ctr:closeWindow(nil,ctr.layer)
			require("src.comp.LuaNodeCtr"):closeOtherWindow()
		else
			ex.MessageView:add(ex.Tools:taskString(self._config.jump_info.no_jump_hint))
		end
	end)
end

--[[
	data:
	{
		icon     : 强化图标
		score    : 当前分数
		maxScore : 最大分数
		config   : `getstrong`配置表项
	}
]]
function HeroStrongInfoCell:reset(data)
	self._config = data.config
	self._titleText:setString(ex.Tools:getLang(data.config.title_lang))
	self._descText:setString(ex.Tools:getLang(data.config.description_lang))

	local score = data.score
	local maxScore = data.maxScore

	-- self._iconSprite:setSpriteFrame(data.icon)
	ex.Tools:setSpriteFrame(self._iconSprite, data.icon)

	local scoreText = tostring(score) .. '/' .. tostring(maxScore)
	local percent = 0
	if maxScore > 0 then
		percent = (score / maxScore) * 100
	end
	self._progressLabel:setString(scoreText)

	self._progressSprite:setPercentage(percent)
end

function HeroStrongInfoCell:_createProgress()
	local progressSprite = require("src.comp.UIScale9SpriteEx"):create("other/spr-bg-4.png", cc.rect(10, 6, 400, 2))
	local bgSize = self._progressBg:getContentSize()
	progressSprite:setAnchorPoint(cc.p(0, 0.5))
	progressSprite:setContentSize(cc.size(bgSize.width-2, bgSize.height-2))

	local bgPos = cc.p(
		(self._progressBg:getPositionX() - (bgSize.width / 2)) + 1,
		self._progressBg:getPositionY()+1
	)
	progressSprite:setPosition(bgPos)

	return progressSprite
end

function HeroStrongInfoCell:_createProgressLabel()
	local label = cc.Label:createWithTTF('', FONT_DEFAULT_NAME_BOLD, 18)
	label:enableOutline(FONT_BLACK_C4B, 1)
	label:setAnchorPoint(cc.p(0.5, 0.5))
	label:setPosition(cc.p(
		self._progressBg:getPositionX(),
		self._progressBg:getPositionY()
	))

	return label
end

-----------------------------------------------------------------------------
local HeroStrongResourceMainCell = class('HeroStrongResourceMainCell', require("src.comp.EventLayer"))

function HeroStrongResourceMainCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	self._iconSprite = cc.Sprite:create()
	self._iconPointer:addChild(self._iconSprite)

	self._subItemSize = self:_createSubitem():getContentSize()
	self._subInterval = 3
	self._subMargin = 8
	self._lrSubMargin = self._subMargin * 2
	self._topOffset = 5

	self._expandBtn:registerScriptTapHandler(function()
		self._config.is_extended = not self._config.is_extended
		self._config.extend_height = self:_calcSubContainerHeight()
		
		local tableView = self._tableView
		local offset = tableView:getContentOffset()
		if self._config.is_extended then
			offset.y = offset.y - self._config.extend_height
		else
			offset.y = offset.y + self._config.extend_height
			if offset.y > 0 then offset.y = 0 end
		end
		self._tableView:reloadData()
		tableView:setContentOffset(offset)
	end)
end

function HeroStrongResourceMainCell:reset(data)
	self._config = data
	self._titleText:setString(ex.Tools:getLang(data.title_lang))
	self._descText:setString(ex.Tools:getLang(data.description_lang))

	self._iconSprite:setSpriteFrame(string.format("backpack/%d.png", data.item))
	local bgSize = self._iconBg:getContentSize()
	local iconSize = self._iconSprite:getContentSize()
	local wScale = bgSize.width / iconSize.width
	local hScale = bgSize.height / iconSize.height
	local scale = math.min(wScale, hScale)
	self._iconSprite:setScale(scale * 0.9)

	self._subContainer:removeAllChildren()
	if self._config.is_extended then
		self._expandBtn:setLabelText('收 起')
		self:setPositionY(self._config.extend_height)
		self:_createSubItems()
	else
		self._expandBtn:setLabelText(ex.Tools:getLang(5568))
		self:setPositionY(0)
	end
end

function HeroStrongResourceMainCell:setTableView(table)
	self._tableView = table
end

function HeroStrongResourceMainCell:_createSubItems()
	local sourceIds = ex.StringUtil.split(self._config.source, ',')
	for i,v in ipairs(sourceIds) do
		local item = self:_createSubitem()
		item:setAnchorPoint(cc.p(0,0))

		local itemSize = item:getContentSize()
		local contSize = self._subContainer:getContentSize()
		local scale = (contSize.width-self._lrSubMargin) / (itemSize.width)
		local y = (self._subInterval * (i-1)) + (self._subItemSize.height * scale * i) - self._topOffset
		
		item:setPositionX(self._subMargin)
		item:setPositionY(-y)
		item:setScale(scale)

		item:initData(cfg.itemsource.itemsource[tonumber(v)], self._config.item)
		
		self._subContainer:addChild(item)
	end
end

function HeroStrongResourceMainCell:_calcSubContainerHeight()
	local sourceIds = ex.StringUtil.split(self._config.source, ',')
	local sourceLen = #sourceIds

	local contSize = self._subContainer:getContentSize()
	local scale = (contSize.width*self:getScale()-self._lrSubMargin) / self._subItemSize.width

	local intervalTotalSize = (sourceLen-1) * self._subInterval
	local itemTotalSize = sourceLen * self._subItemSize.height * scale
	local subTotalSize = intervalTotalSize + itemTotalSize
	
	return subTotalSize - self._topOffset
end

function HeroStrongResourceMainCell:_createSubitem()
	return HeroStrongResourceSubCell:createWithCCBIFile('ccbi/HeroStrongResourceSubCell.ccbi')
end

-----------------------------------------------------------------------------
function HeroStrongResourceSubCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	self._iconSprite = cc.Sprite:create()
	self._iconPointer:addChild(self._iconSprite)

	self._gotoBtn:registerScriptTapHandler(function()
		if self._config.jump_info.event_type == 1 then
			ex.JumpManager:jumpByAtom(self._config.jump_info.event_arg)
			local ctr = HeroSuggestCtr:instance()
			ctr:closeWindow(nil,ctr.layer)
			require("src.comp.LuaNodeCtr"):closeOtherWindow()
		else
			ex.MessageView:add(ex.Tools:taskString(self._config.jump_info.no_jump_hint))
		end
	end)
end

function HeroStrongResourceSubCell:initData(data, item)
	self._config = data
	self._titleText:setString(ex.Tools:getLang(data.title_lang))
	self._descText:setString(ex.Tools:getLang(data.description_lang))

	self._iconSprite:setSpriteFrame(string.format("backpack/%d.png", item))
	local bgSize = self._iconBg:getContentSize()
	local iconSize = self._iconSprite:getContentSize()
	local wScale = bgSize.width / iconSize.width
	local hScale = bgSize.height / iconSize.height
	local scale = math.min(wScale, hScale)
	self._iconSprite:setScale(scale)
end

-----------------------------------------------------------------------------
local HeroRecommendItem = class("HeroRecommendItem", require("src.comp.EventLayer"))

function HeroRecommendItem:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
	
	self:reorderChild(self.spr_rare, 100)
	self:reorderChild(self.spr_strongest, 100)
end

-----------------------------------------------------------------------------
local HeroRecommendItemCell = class("HeroRecommendItemCell", require("src.comp.EventLayer"))

function HeroRecommendItemCell:onCreate()
	self:setAutoClose(false)
    self:setSwallowTouches(false)
	-- self.menu_item:setSwallowsTouches(false)
end

function HeroRecommendItemCell:setTableView(table_view)
    self.tableView = table_view
    -- self.menu_item:setIsTouchInsideNode(table_view)
end

-- 显示一行符文
function HeroRecommendItemCell:reset(data)
    if not data then return end
	self.data = data
	
	local sfc = cc.SpriteFrameCache:getInstance()
	local ratingPath = string.format("other/hero-recommend-t%d.png", self.data.level)
	if sfc:getSpriteFrame(ratingPath) then
		self._ratingSprite:setSpriteFrame(ratingPath)
	end
	self:setPositionY(self.data.extHeight)

    -- tableView会进行缩放
    self:setScale(1)

    local begin = 0
    local margin = 0
    local posY = 0
    local scale = 1
    local offset = 10

    self.node_item:removeAllChildren()

    local config = cfg.herotype.star

	local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

    -- dump(data, "HeroRecommendItemCell:reset")
	for i, hero_data in ipairs(self.data.list) do
        local item = HeroRecommendItem:createWithCCBIFile("ccbi/HeroRecommendItem.ccbi")
        -- item:setScale(0.8)
        item.hero_data = hero_data
        item.type = hero_data.hero_data.hero_type

		item.lbl_name:setString(ex.Tools:getLang(item.type))
		item.spr_rare:setVisible(item.hero_data.hero_data.is_precious == 1)
		item.spr_strongest:setVisible(item.hero_data.hero_data.is_precious == 2)
        item.lbl_desc1:setString(ex.Tools:getLang(5000000 + item.type))
        item.lbl_desc2:setString(ex.Tools:getLang(7000000 + item.type))

        local level = 1
        local config_hero_star = cfg.herostar.star[hero_data.hero_data.star]
        if config_hero_star then
        	level = config_hero_star.level_limit
        end

        local item_hero = UIMenuItemHero:createWithData(0, item.type, nil, '', hero_data.hero_data.star)
		item_hero:setPosition(90.0, 133.0)
		item:add(item_hero)
		
		local itemSize = item:getContentSize()

        item.btn_cell:setContentSize(itemSize)
        item.btn_cell:registerScriptTapHandler(handler(self, self.onSelectedHero))
        item.menu:setSwallowsTouches(false)
        item.menu:setIsTouchInsideNode(self.tableView)

		local item_width = (self.tableView:getViewSize().width / hero_data.col)
		local row = (math.floor((i-1) / hero_data.col) + 1)
		local posX = (self.tableView:getViewSize().width * 0.5 - (hero_data.col - 1) * item_width * 0.5 - itemSize.width * 0.5 + item_width * ((i - 1)%hero_data.col)) 
		local posY = row * itemSize.height
		item:setPosition(cc.p(posX, -posY))
		self.node_item:add(item)
    end
end

function HeroRecommendItemCell:onSelectedHero(tag, pSender)
	local item = pSender:getParent():getParent()
	local callback =function ()
		ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
		HeroSuggestCtr:instance():openWindow()
		HeroSuggestCtr:instance():onChangeLayer(3)
	end

	-- dump(item.hero_data.hero_data)
	-- print(item.hero_data.hero_type, item.hero_data.star, callback)
	local layer = ex.MainSceneCtr:changeLayer(MainSceneType.HERO_ILLUSTRAT_INFO_LAYER)
	layer:showData(item.hero_data.hero_data.hero_type, item.hero_data.hero_data.star, callback)

	HeroSuggestCtr:instance():closeWindow()
	require("src.comp.LuaNodeCtr"):closeOtherWindow()
end

-----------------------------------------------------------------------------

function HeroSuggestLayer:getAsynImage()
    local vec_image = {
    }
    return vec_image
end

function HeroSuggestLayer:onCreate()
	self:addBlackBackground()

    self.btn_elem_select = require("src.layer.HeroElemSelect"):new()
    for i=1,5 do
        self["btn_elem"..i]:setTag(ElemType.ALL + i)
        self.btn_elem_select:bindSelect(self["btn_elem"..i])
    end
	
	self.btn_strong:setTag(1)
	self.btn_strong:setChecked(true)
	self.btn_resource:setTag(2)
	self.btn_hero:setTag(3)
	self.btn_lineup:setTag(4)

    self.btn_strong:setLabelText(ex.Tools:getLang(5737))
    self.btn_resource:setLabelText(ex.Tools:getLang(5738))
    self.btn_hero:setLabelText(ex.Tools:getLang(5739))
    self.btn_lineup:setLabelText(ex.Tools:getLang(5740))

	


end

function HeroSuggestCtr:onCreate()
	self:setCCBIPath("ccbi/HeroSuggestLayer.ccbi")
	self:setIsSingle(false)

	ex.EventManager:add(EVENT.HERO_SCORE_EVENT.HERO_SCORE, handler(self, self._onHeroScore))
end

function HeroSuggestCtr:getLayerClass()
	return HeroSuggestLayer
end

function HeroSuggestCtr:openWindow()
	if self:isOpened() then
		return
	end

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/hero-info.plist")
	sfc:addSpriteFrames("ccbi-res/hero-info-lang.plist")
	sfc:addSpriteFrames("ccbi-res/battle-detail.plist")

	self:loadLayer()
	self:open()
	self:initData()

	NetManager:sendMessage(ProtocolID.GReqScanHeroScore)
end

function HeroSuggestCtr:initData()
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	self.layer.btn_strong:registerScriptTapHandler(handler(self, self.onChangeLayer))
	self.layer.btn_resource:registerScriptTapHandler(handler(self, self.onChangeLayer))
	self.layer.btn_hero:registerScriptTapHandler(handler(self, self.onChangeLayer))
	self.layer.btn_lineup:registerScriptTapHandler(handler(self, self.onChangeLayer))
	self.layer.btn_strategy:registerScriptTapHandler(handler(self, self.onStrategy))

	self._heroScoreProgress = self:_createHeroStrongProgress()
	self._heroScoreProgress:setVisible(false)
	self.layer.node_strong:addChild(self._heroScoreProgress)
	self._heroScoreLabel = self:_createHeroStrongProgressLabel()
	self.layer.node_strong:addChild(self._heroScoreLabel)

	
	self.cur_hero_elem = ElemType.FIRE
    for i=1,5 do
        self.layer["btn_elem"..i]:registerScriptTapHandler(handler(self, self.onElem))
	end
	self.layer.btn_elem_select:setSelected(self.cur_hero_elem)
	
	self.layer_type = 0
	self:onChangeLayer(1)
end

function HeroSuggestCtr:onElem(tag, pSender)
    if not self:isOpened() then
        return
    end

    self.layer.btn_elem_select:setSelected(tag)
	self.cur_hero_elem = tag

	self:updateTableView()
end

function HeroSuggestCtr:onChangeLayer(tag, pSender)
	if tag == self.layer_type then
		return
	end
	
    self.layer.btn_elem_select:setSelected(self.cur_hero_elem)

	self.layer_type = tag

	self.layer.btn_strong:setChecked(self.layer_type == 1)
	self.layer.btn_resource:setChecked(self.layer_type == 2)
	self.layer.btn_hero:setChecked(self.layer_type == 3)
	self.layer.btn_lineup:setChecked(self.layer_type == 4)

	if self.layer.table_view ~= nil then
		self.layer.table_view:removeFromParent()
		self.layer.table_view = nil
	end

	self:updateTableView()
end

function HeroSuggestCtr:updateTableView()
	if not self:getLayer() then
		return
	end

	self.layer.node_strong:setVisible(self.layer_type == 1)
	self.layer.node_resource:setVisible(self.layer_type == 2)
	self.layer.node_hero:setVisible(self.layer_type == 3)
	self.layer.node_lineup:setVisible(self.layer_type == 4)

	if self.layer_type == 1 then
		self:_updateWantStrong()
	elseif self.layer_type == 2 then
		self:_updateGetResource()
	elseif self.layer_type == 3 then
		self:_updateHeroRecommend()
	elseif self.layer_type == 4 then
		self:_updateLineupRecommend()
	end
end

function HeroSuggestCtr:_updateWantStrong()
	if self.layer.table_view == nil then
		-- 初始化tableview
		local view_size = cc.size(self.layer.spr_strong_scroll_bg:getContentSize().width - 10, self.layer.spr_strong_scroll_bg:getContentSize().height - 10)
		local pos = cc.p(self.layer.spr_strong_scroll_bg:getPositionX() + 5, self.layer.spr_strong_scroll_bg:getPositionY() + 5)
		self.layer.table_view = ex.Tools:initTableView(self.layer, {}, {HeroStrongInfoCell, "ccbi/HeroStrongInfoCell.ccbi"}, view_size, 2, pos)
	end

	if self._heroScoreData then
		local initialId = nil
		for i,v in pairs(self._heroScoreData) do
			initialId = v.pos
			break
		end

		if initialId then
			self:_updateHeroStrongData(initialId)
		end
	end
end

function HeroSuggestCtr:_updateGetResource()
	if self.layer.table_view == nil then
		-- 初始化tableview
		local view_size = cc.size(self.layer.spr_resource_scroll_bg:getContentSize().width - 10, self.layer.spr_resource_scroll_bg:getContentSize().height - 10)
		local pos = cc.p(self.layer.spr_resource_scroll_bg:getPositionX() + 5, self.layer.spr_resource_scroll_bg:getPositionY() + 5)
		self.layer.table_view = ex.Tools:initTableView(self.layer, {}, {HeroStrongResourceMainCell, "ccbi/HeroStrongResourceMainCell.ccbi"}, view_size, 2, pos)
	end

	local resourceConfig = clone(cfg.getstrongsource.getstrongsource)
	local itemSize = HeroStrongResourceMainCell:createWithCCBIFile('ccbi/HeroStrongResourceMainCell.ccbi'):getContentSize()
	
	self.layer.table_view:registerScriptHandler(function(table, idx)
		local config = resourceConfig[idx+1]
		if config.is_extended then
			return itemSize.width, itemSize.height + config.extend_height
		end
		return itemSize.width, itemSize.height + 20
	end, cc.TABLECELL_SIZE_FOR_INDEX)
	self.layer.table_view:initData(resourceConfig)
end

function HeroSuggestCtr:_updateHeroRecommend()
	if self.layer.table_view == nil then
		-- 初始化tableview
		local view_size = cc.size(self.layer.spr_box:getContentSize().width - 10 , self.layer.spr_box:getContentSize().height - 105)
		local pos = cc.p(self.layer.spr_box:getPositionX() + 5, self.layer.spr_box:getPositionY() + 10)
		self.layer.table_view = ex.Tools:initTableView(self.layer, {}, {HeroRecommendItemCell, "ccbi/HeroRecommendItemCell.ccbi"}, view_size, 5, pos)
	end

	local vec_hero_all = cfg.herorecommendation.herorecommendation

	local vec_hero = {}

	if self.cur_hero_elem == ElemType.ALL then
		vec_hero = vec_hero_all
	else
		for i,v in ipairs(vec_hero_all) do
			local config_hero_type = cfg.herotype.star[v.hero_type]
			if config_hero_type and config_hero_type.elem == self.cur_hero_elem then
				table.insert(vec_hero, v)
			end
		end
	end

	local item_count = table.nums(vec_hero)
	local view_size = self.layer.table_view:getViewSize()
	local orig_item_size = HeroRecommendItem:createWithCCBIFile("ccbi/HeroRecommendItem.ccbi"):getContentSize()
	item_size = cc.size(orig_item_size.width, orig_item_size.height + 12)

	local margin = 0
	local col = math.floor((view_size.width - margin * 2) / item_size.width) -- 列数

	local hero_data = {}
	for k,v in ipairs(vec_hero) do
		local nowData = {}
		nowData.col = col
		nowData.hero_data = v

		local groupKey = v.level + 1
		if not hero_data[groupKey] then 
			hero_data[groupKey] = {
				level = v.level,
				list = {}
			}
		end
		table.insert(hero_data[groupKey].list, nowData)
	end

	local normalHeroData = {}
	local itemCellSize = HeroRecommendItemCell:createWithCCBIFile("ccbi/HeroRecommendItemCell.ccbi"):getContentSize()
	for k,v in pairs(hero_data) do
		local len = #v.list
		local row = math.ceil(len / col)

		local extHeight = row * orig_item_size.height
		v.extHeight = extHeight

		table.insert(normalHeroData, v)
	end

	self.layer.table_view:registerScriptHandler(function(table, idx)
		local data = normalHeroData[idx+1]
		return itemCellSize.width, itemCellSize.height+data.extHeight
	end, cc.TABLECELL_SIZE_FOR_INDEX)
	
	self.layer.table_view:initData(normalHeroData)
end

function HeroSuggestCtr:_updateLineupRecommend()
	if self.layer.table_view == nil then
		-- 初始化tableview
		local view_size = cc.size(self.layer.spr_scroll_bg:getContentSize().width - 10, self.layer.spr_scroll_bg:getContentSize().height - 10)
		local pos = cc.p(self.layer.spr_scroll_bg:getPositionX() + 5, self.layer.spr_scroll_bg:getPositionY() + 5)
		self.layer.table_view = ex.Tools:initTableView(self.layer, {}, {HeroSuggestCell, "ccbi/HeroSuggestCell.ccbi"}, view_size, 5, pos)
	end

	self.layer.table_view:initData(cfg.herolineupsuggestion.list)
end

function HeroSuggestCtr:_onTapHeroStrongIcon(tag, pSender)
	self:_updateHeroStrongData(tag)
end

function HeroSuggestCtr:_updateHeroStrongData(id)
	if self.layer_type == 1 and self._heroScoreData and self._heroScoreData[id] then
		local heroScoreData = self._heroScoreData[id]
		self.layer.table_view:initData(heroScoreData.infos)

		self.layer._heroStrongName:setString(ex.Tools:getLang(heroScoreData.type))
		ex.Tools:setLimitWidth(self.layer._heroStrongName, 170)

		local nodePointer = self.layer['_heroItem'..id]
		local x = nodePointer:getPositionX()
		local action = cc.EaseBounceOut:create(cc.MoveTo:create(0.3, cc.p(
			x,
			self.layer._heroStrongSelected:getPositionY()
		)))
		self.layer._heroStrongSelected:stopAllActions()
		self.layer._heroStrongSelected:runAction(action)

		local score = heroScoreData.score
		local maxScore = heroScoreData.maxScore
		local str = tostring(score) .. '/' .. tostring(maxScore)
		local percent = 0
		if maxScore > 0 then
			percent = (score / maxScore) * 100
		end
		self._heroScoreProgress:setVisible(true)
		self._heroScoreProgress:setPercentage(percent)
		self._heroScoreLabel:setString(str)
	end
end

function HeroSuggestCtr:_updateHeroScoreData()
	self.layer._heroStrongMenu:removeAllChildren()
	
	local initialId = nil
	for i,v in pairs(self._heroScoreData) do
		if v.pos > 6 then break end
		local item = self:_createStrongHeroItem(v.type, v.level, v.star, v.evolve)
		if v.fashion_id ~= 0 and v.fashion_id ~= nil then   -- 有皮肤
			item:setFashionShowForce(v.fashion_id)
		end
		item:setEnableAction(false)
		item:setTag(v.pos)
		local nodePointer = self.layer['_heroItem'..v.pos]
		item:setPosition(cc.p(
			nodePointer:getPositionX(),
			nodePointer:getPositionY()
		))
		self.layer._heroStrongMenu:addChild(item)

		local heroItemBg = self.layer['_heroItemBg'..v.pos]
		heroItemBg:setVisible(false)

		if not initialId then
			initialId = v.pos
		end

		item:registerScriptTapHandler(handler(self, self._onTapHeroStrongIcon))
	end

	self:_updateHeroStrongData(initialId)
end

function HeroSuggestCtr:_onHeroScore(evt, data)
	if self.layer == nil then
		return
	end
	
	self._heroScoreData = self:_parseHeroScore(data)
	self:_updateHeroScoreData()
end

function HeroSuggestCtr:_createHeroStrongProgress()
	local progressSprite = require("src.comp.UIScale9SpriteEx"):create("other/spr-bg-4.png", cc.rect(10, 6, 400, 2))
	local bgSize = self.layer._heroStrongScoreBg:getContentSize()
	progressSprite:setAnchorPoint(cc.p(0, 0.5))
	progressSprite:setContentSize(cc.size(bgSize.width-2, bgSize.height-2))

	local pos = cc.p(
		(self.layer._heroStrongScoreBg:getPositionX() - (bgSize.width / 2)) + 1,
		self.layer._heroStrongScoreBg:getPositionY()+1
	)
	progressSprite:setPosition(pos)

	return progressSprite
end

function HeroSuggestCtr:_createHeroStrongProgressLabel()
	local label = cc.Label:createWithTTF('', FONT_DEFAULT_NAME_BOLD, 18)
	label:enableOutline(FONT_BLACK_C4B, 1)
	label:setAnchorPoint(cc.p(0.5, 0.5))
	label:setPosition(cc.p(
		self.layer._heroStrongScoreBg:getPositionX(),
		self.layer._heroStrongScoreBg:getPositionY()
	))

	return label
end

function HeroSuggestCtr:_parseHeroScore(data)
	local heroScoreData = {}

	for i,hero in ipairs(data.heros) do
		local top = hero.top
		local mine = hero.mine

		local heroData = {
			type = mine.type,
			pos = i,
			level = hero.level,
			star = hero.star,
			score = mine.score,
			maxScore = top.score,
			infos = {},
			evolve = hero.evolve
		}

		for k,heroScoreInfo in pairs(HERO_SCORE_MAP) do
			local info = {
				icon = heroScoreInfo.icon,
				score = mine[k],
				maxScore = top[k],
				config = heroScoreInfo.config
			}

			table.insert(heroData.infos, info)
		end

		heroScoreData[i] = heroData
	end

	return heroScoreData
end

function HeroSuggestCtr:_createStrongHeroItem(heroType, level, star, evolve)
	local hero_data = {
		hero_type = heroType,
		level = level,
		star = star,
		evolve = evolve
	}
	local item = UIMenuItemHero:createWithData()
	item:reset(hero_data)
	item:setScale(0.78)
	return item
end

function HeroSuggestCtr:onStrategy(tag, pSender)
	require("src.layer.StrategyCtr"):instance():openWindow("methodlang")
end

return HeroSuggestCtr