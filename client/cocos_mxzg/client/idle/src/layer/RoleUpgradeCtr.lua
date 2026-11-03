local RoleUpgradeCtr = class("RoleUpgradeCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local RoleUpgradeLayer = class("RoleUpgradeLayer", require("src.comp.EventLayerAdaptiveWidthFull"))

function RoleUpgradeLayer:onCreate()
	self:addBlackBackground()

	self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)

	self.scroll_view = cc.ScrollView:create(cc.size(self.spr_bg:getContentSize().width - 40, 292))
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    :setPosition(20, 38)
	self:addChild(self.scroll_view)
	self.lbl_level:enableOutline(cc.c3b(0,0,0),1)
	self.lbl_level1:enableOutline(cc.c3b(0,0,0),1)
	self.lbl_level2:enableOutline(cc.c3b(0,0,0),1)
	self.lbl_atom:enableOutline(cc.c3b(0,0,0),1)
	self:createRich()
end

function RoleUpgradeLayer:createRich( )
	local x,y = self.lbl_open:getPosition()
	self.base_rich = cpp.RichTextEx:createWithXMLLua("")
	self.base_rich:setFontSize(20)
	self.base_rich:setScale(1)
	self.base_rich:setFontFace(FONT_DEFAULT_NAME_BOLD)
	self.base_rich:setFontColor("#FFE9B3")
	self.base_rich:setAnchorTextShadow(false)
	self.base_rich:setAnchorPoint(cc.p(0,0.5))
    self.base_rich:setPosition(cc.p(x,y))
    self.base_rich:setLocalZOrder(10)
    self.base_rich:enableOutline(cc.c4b(0,0,0,255))
    self:addChild(self.base_rich)
end

function RoleUpgradeLayer:getNextLevelOpen(level)
	local config = ex.JumpManager:getSystemData()
	local data = {}
	for k,v in pairs(config) do
		-- print(k)
		local cf = cfg.opencondition.condition[k]
		if cf.condition_type == 1 and cf.open ~= FUNCTION_OPEN_TYPE.COND_NO_NOTICE_SHOW and cf.open ~= FUNCTION_OPEN_TYPE.COND_NO_NOTICE_NO_SHOW then 
			table.insert(data,cf)
		end
	end
	-- dump(data)
	local function sor(a,b)
		return a.condition_value < b.condition_value
	end
	table.sort(data,sor)
	-- dump(data)
	for i,v in ipairs(data) do
		if v.condition_value > level then 
			return v 
		end
	end

	return nil
end


-----------------------------------------------------------------------------

function RoleUpgradeCtr:onCreate()
	self:setCCBIPath("ccbi/RoleUpgradeLayer.ccbi")
	self:setIsSingle(false)
end

function RoleUpgradeCtr:getLayerClass()
	return RoleUpgradeLayer
end

function RoleUpgradeCtr:openWindow(level_before, level_current, award_list)
	if self:isOpened() then
		return
	end

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/summon-effect.plist")
    sfc:addSpriteFrames("ccbi-res/reward-layer.plist")
    sfc:addSpriteFrames("ccbi-res/main-city.plist")

	self:loadLayer()
	self:open()
	self:initData(level_before, level_current, self:ckeckReward(award_list))

	ex.AudioManager:playEffect("music/item-get.mp3")
end

function RoleUpgradeCtr:initData(level_before, level_current, award_list)
	self.layer.lbl_level1:setString(tostring(level_before))
	self.layer.lbl_level2:setString(tostring(level_current))

	self.layer.scroll_view:getContainer():removeAllChildren()

	local menu = cpp.UIMenu:create()
	menu:setIsTouchInsideNode(self.layer.scroll_view)
    menu:setSwallowsTouches(false)
    menu:setPosition(cc.p(0, 0))
    self.layer.scroll_view:addChild(menu)

	local view_size = self.layer.scroll_view:getViewSize()
    local item_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()
	item_size = cc.size(item_size.width + 20,  item_size.height + 25)

	local awardLen = table.nums(award_list)
	local col = math.floor(view_size.width / item_size.width) -- 列数
	col = math.min(col, 4)
	col = math.min(col, awardLen)
	local cont_height = item_size.height * math.ceil(1.0 * awardLen / col)
	cont_height = math.max(cont_height , view_size.height)

	self.layer.scroll_view:setContentSize(cc.size(view_size.width, cont_height))
	self.layer.scroll_view:setContentOffset(cc.p(0, view_size.height - cont_height))

  	cont_height = cont_height - item_size.height * 0.5

 	local start = cc.p(view_size.width * 0.5 - item_size.width * (col - 1) * 0.5, cont_height)

    local index = 0
	for _,v in pairs(award_list) do
		local x = index % col
        local y = math.floor(index / col)

        local pos = cc.p(start.x + x * item_size.width, start.y - y * item_size.height)

		local item = ex.Player.backpack_data:createWithData(v.item_type, v.item_num)
		item:setPosition(pos)
        item:registerScriptTapHandler(handler(self, self.onBtnInfo))
        menu:addChild(item)
  --       item:setCascadeOpacityEnabled(true)
		-- item:setOpacity(0)
		-- item:setScale(2.0)
		-- item:runAction(cc.Sequence:create(cc.DelayTime:create(index * 0.1),
		-- 	cc.FadeIn:create(0.05),
		-- 	cc.EaseBackOut:create(cc.ScaleTo:create(0.15, 1.0)),
		-- 	cc.CallFunc:create(function()
		-- 		self:onceAnim(pos, "summon-effect/3-0.png", "ccbi-res/summon-effect.plist", "summon-effect/3-%d.png")
		-- end)))


		index = index + 1
    end

    local data = self.layer:getNextLevelOpen(level_current)
    local icon = self.layer.spr_icon
    local title = self.layer.lbl_atom
    local desc = self.layer.lbl_desc
    -- local open = self.layer.lbl_open
    icon:setVisible(data ~= nil)
    title:setVisible(data ~= nil)
    desc:setVisible(data ~= nil)
    -- open:setVisible(data ~= nil)
    if not data then return end

	local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("main-city/up-%s.png", data.atom))
	if frame then
		icon:setSpriteFrame(frame)
	else
		-- icon:setSpriteFrame(string.format("main-city/icon-%s.png", data.atom))
		ex.Tools:setSpriteFrame(icon, string.format("main-city/icon-%s.png", data.atom))
	end
	
	title:setString(ex.Tools:getLang(data.name))
    desc:setString(ex.Tools:getLang(data.desc))
	-- open:setString(string.format(ex.Tools:getLang(47032),data.condition_value))
	local str = ex.Tools:getLang(47576)
	self.layer.base_rich:setXmlTextLua(string.format( str,data.condition_value ))
end

function RoleUpgradeCtr:onceAnim(pos, str_spr, str_plist, str_png)
	local spr_effectOnce = cc.Sprite:createWithSpriteFrameName(str_spr)
    spr_effectOnce:setScale(1.35)
    spr_effectOnce:setPosition(pos)
    self.layer.scroll_view:getContainer():addChild(spr_effectOnce)

    local action = cpp.ActionFactory:createLuaAnimate(str_plist, str_png, 0.05)
    spr_effectOnce:runAction(cc.Sequence:create(action, cc.CallFunc:create(function()
    	spr_effectOnce:setVisible(false)
    end)))
end

function RoleUpgradeCtr:onBtnInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function RoleUpgradeCtr:ckeckReward(award_list)
	-- 合并相同项。否则在结尾添加
	local item_list = {}
    local inserItem = function(item_type, item_num)
        local is_add = true
        for _,v in pairs(item_list) do
           if v.item_type == item_type then
              v.item_num = v.item_num + item_num
              is_add = false
              break
           end
        end

        if is_add then
            local item = {}
            item.item_type = item_type
            item.item_num = item_num
            table.insert(item_list, item)
        end
    end

    for _,v in pairs(award_list) do
    	inserItem(v.item_type, v.item_num)
    end

    return item_list
end

return RoleUpgradeCtr