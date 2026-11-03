local HeroStoneStateCtr = class("HeroStoneStateCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local HeroStoneStateLayer = class("HeroStoneStateLayer", require("src.comp.EventLayerAdaptiveWidth"))


local HeroStoneStateCell = class("HeroStoneStateCell", require("src.comp.EventLayer"))
function HeroStoneStateCell:onCreate()
    self:setAutoClose(false)
	self:setSwallowTouches(false)
	
	self.text_refresh = require("src.comp.RichTextEx"):create()
    :setFontSize(20)
    :setFontFace(FONT_DEFAULT_NAME_BOLD)
    :setAnchorTextShadow(true)
    :setWrapMode(1)
    :setAnchorPoint(0, 0.5)
    self.show_attr_rich:addChild(self.text_refresh)
    self.text_refresh:setPosition(0,0)
	

    self.btn_enter:registerScriptTapHandler(handler(self, self.onDoneEnter))
    self.btn_stone_down:registerScriptTapHandler(handler(self, self.onStoneDown))
    self.btn_stone_up:registerScriptTapHandler(handler(self, self.onStoneUp))

	self.btn_stone_up:setLabelSize(48)
	self.btn_stone_up:setLabelColor(cc.WHITE)
    self.btn_stone_up:setLabelOutLine(FONT_BLACK_C4B)

	self.btn_stone_down:setLabelSize(48)
	self.btn_stone_down:setLabelColor(cc.WHITE)
	self.btn_stone_down:setLabelOutLine(FONT_BLACK_C4B)
	
	self.btn_enter:setLabelSize(48)
	self.btn_enter:setLabelColor(cc.WHITE)
    self.btn_enter:setLabelOutLine(FONT_BLACK_C4B)
	
end 

function HeroStoneStateCell:setCallBack( enter_callback, stone_down_callback, stone_up_callback )
	self.btn_enter_callback = enter_callback
	self.btn_stone_down_callback = stone_down_callback
	self.btn_stone_up_callback = stone_up_callback
end


function HeroStoneStateCell:onClick(tag,pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function HeroStoneStateCell:onDoneEnter( tag,pSender)
	if self.btn_enter_callback then 
		self.btn_enter_callback(self.item_type)
	end 
end

function HeroStoneStateCell:onStoneDown( tag,pSender)
	if self.btn_stone_down_callback then 

		self.btn_stone_down_callback(self.hero_now_place_data.jewel_id)
	end 
end
function HeroStoneStateCell:onStoneUp( tag,pSender)
	if self.btn_stone_up_callback then 
		self.btn_stone_up_callback(self.item_type)
	end 
end

function HeroStoneStateCell:initDone(item_type, item_num, state, hero_now_place_data)
	--             self.hero_now_place_data = clone(v)
	self.hero_now_place_data = hero_now_place_data
	self.item_type = item_type
	self.state = state
	local config = cfg.item.item[item_type]
	if not config then return end 

	local jeweltype_config = cfg.jeweltype.jeweltype[item_type]
	if not jeweltype_config then return end 

	if state == 1 then 
		self.btn_enter:setVisible(false)
		self.btn_stone_down:setVisible(true)
		self.btn_stone_up:setVisible(true)
	else 
		self.btn_enter:setVisible(true)
		self.btn_stone_down:setVisible(false)
		self.btn_stone_up:setVisible(false)
	end 


	--加一个显示五片
	-- 显示基础信息
	--self.stone_item = ex.Player.backpack_data:createWithData(item_type,item_num)

	self.stone_item = ex.Player.backpack_data:createWithData(item_type,item_num)
	self.stone_item:setPosition(80, 80)
	self.stone_item:setScale(1)
	self.stone_item:registerScriptTapHandler(handler(self, self.onClick))
	self.menu:addChild(self.stone_item)

	--mingcheng 
	self.lbl_name:setString(ex.Tools:getLang(config.name))
	self.lbl_score:setString(string.format( ex.Tools:getLang(54431), jeweltype_config.score))
	
	-- shexian suxing 

    -- ex.Tools:generationStar(self.stone_item, jeweltype_config.star, "other/star-%d.png", 0.6, -10, cc.p(self.stone_item:getContentSize().width * 0.5, 15), 1000)


	local str = ""
	for i,v in ipairs(jeweltype_config.ability) do

		local attstr = ex.Tools:getLang(2141000 + v.attr)
		attstr = ex.StringUtil.formatAttrStrNum(attstr, "##" , v.value, "<font color='#219A00'>%s</font>")
		
		str = str ..  string.format( "<br><font color='#7A472D'>%s</font></br>" , attstr)
		-- str = str ..  string.format( "<br><font color='#7A472D'>%s+%s</font></br>" , ex.Tools:getLang(122000 + v.attr), v.value)
	end
    self.item_star = jeweltype_config.star

    self.text_refresh:setXmlTextLua(str)
    self.text_refresh:formatText()

    self.rich_height = self.text_refresh:getContentSize().height

    self.text_refresh:setContentSize(cc.size(225, self.text_refresh:getContentSize().height))

    self.text_refresh:setPosition(0,  self.text_refresh:getContentSize().height * 0.5 - 34)

end 


------------------------------------------------
function HeroStoneStateLayer:onCreate()
	self:addBlackBackground()

	local item_size = cc.size(550, 180)


    local viewSize = cc.size(self.spr_scroll_bg:getContentSize().width, self.spr_scroll_bg:getContentSize().height - 10 )

    self.scroll_view = cc.ScrollView:create(viewSize)
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    :setPosition(self.spr_scroll_bg:getPositionX() + 2, self.spr_scroll_bg:getPositionY() + 10)
    self:addChild(self.scroll_view)

end

function HeroStoneStateLayer:initDone(position, hero_id)

	self.position = position
	self.hero_id = hero_id
	self:updateScroll()
end


function HeroStoneStateLayer:checkNowPlace( )
	local hero_jewel_data = ex.Player.hero_data:getHeroJewelListForHeroid(self.hero_id)
	if not hero_jewel_data.jewel_list then hero_jewel_data.jewel_list = {} end 
	
	for i,v in ipairs(hero_jewel_data.jewel_list) do
		if v.place == self.position then 
			self.place_data = clone(v)
			return v.jewel_type
		end 
	end
	return nil
end


function HeroStoneStateLayer:updateScroll( )
    self.scroll_view:getContainer():removeAllChildren()

	local cur_jewel_type = 0
	if self:checkNowPlace( ) then 
		cur_jewel_type = self:checkNowPlace( )
	end 

	local stone_list = ex.Player.backpack_data:getStoneByPlace(self.position)
    local index = 0
	self.cellList = {}

	local is_master = false
	for i,v in ipairs(stone_list) do
		local now_status = 0
		local show_nums = v.item_num
		if cur_jewel_type == v.item_type then 
			now_status = 1
			is_master = true 
			show_nums = show_nums + 1
		end 

		local attr_cell_node = self:addCellScroll(v.item_type, show_nums , now_status, self.place_data)
        attr_cell_node:setName("stone_cell" .. index)
        attr_cell_node:setPosition(0,0)
        self.scroll_view:addChild(attr_cell_node)
        table.insert(self.cellList, attr_cell_node)
		index = index + 1
	end

	if is_master == false and cur_jewel_type > 0 then 

		local attr_cell_node = self:addCellScroll(cur_jewel_type, 1, 1, self.place_data)
        attr_cell_node:setName("stone_cell" .. index)
        attr_cell_node:setPosition(0,0)
        self.scroll_view:addChild(attr_cell_node)
        table.insert(self.cellList, attr_cell_node)
		index = index + 1
	end 


	table.sort(self.cellList, function(a, b)
		if a.state == b.state then 
			return a.item_star > b.item_star
		else 
			return a.state > b.state
		end 
    end)


    local viewSize = self.scroll_view:getViewSize()
    local item_size = HeroStoneStateCell:createWithCCBIFile("ccbi/HeroStoneStateCell.ccbi"):getContentSize()
    item_size.height = item_size.height + 5

    local cont_height = item_size.height * table.nums(self.cellList)
    cont_height = math.max(cont_height , viewSize.height)

    self.scroll_view:setContentSize(cc.size(viewSize.width, cont_height))
    self.scroll_view:setContentOffset(cc.p(0, viewSize.height - cont_height))


    -- 按排好的顺序显示
    local start = cc.p(viewSize.width * 0.5 , cont_height - item_size.height * 0.5)

    for i,v in ipairs(self.cellList) do
        v:setPosition(start.x, start.y - (i - 1) * item_size.height)
    end
end

function HeroStoneStateLayer:addCellScroll(  item_type, item_num, status, place_data)
    local cell = HeroStoneStateCell:createWithCCBIFile("ccbi/HeroStoneStateCell.ccbi")
	cell:setSwallowTouches(false)
	cell:setIgnoreAnchorPointForPosition(false)
    cell:setAnchorPoint(ex.a.center)
	
	-- 绑定三个按钮
	cell:initDone(item_type, item_num, status, place_data)
	cell:setCallBack(handler(self, self.enterCallBack), handler(self, self.downCallBack), handler(self, self.upCallBack))
    return cell
    
end

function HeroStoneStateLayer:enterCallBack(item_type )
	local req = HeroJewel_pb.GReqHeroJewelChange()
	req.hero_id = self.hero_id
	req.sys_id = item_type
	NetManager:sendMessage(ProtocolID.GReqHeroJewelChange, req)

	require("src.layer.heroinfo.HeroStoneStateCtr"):instance():closeWindow()

end

function HeroStoneStateLayer:downCallBack(item_type )

	local req = HeroJewel_pb.GReqHeroJewelDisboard()
	req.hero_id = self.hero_id
	req.jewel_id = item_type

	NetManager:sendMessage(ProtocolID.GReqHeroJewelDisboard, req)
	require("src.layer.heroinfo.HeroStoneStateCtr"):instance():closeWindow()

end

function HeroStoneStateLayer:upCallBack( )	
	ex.JumpManager:jumpByAtom("main_smith_shop_gem") 
	require("src.layer.heroinfo.HeroStoneStateCtr"):instance():closeWindow()

end



function HeroStoneStateLayer:onShowInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

------------------------------------------------
function HeroStoneStateCtr:onCreate()
	self:setCCBIPath("ccbi/HeroStoneStateLayer.ccbi")
	self:setIsSingle(false)
end

function HeroStoneStateCtr:getLayerClass()
	return HeroStoneStateLayer
end

function HeroStoneStateCtr:openWindow(position, hero_id)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
    self.layer:initDone(position, hero_id)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

end

return HeroStoneStateCtr











