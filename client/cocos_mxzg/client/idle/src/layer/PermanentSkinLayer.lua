--[[
    func: 永久皮肤商城
    版权所有:广州暗耀晶石网络信息科技有限公司
]]
local PermanentSkinLayer = class("PermanentSkinLayer", require("src.layer.ui.UI_PermanentSkinLayer"))
local PermanentSkinCell = class("PermanentSkinCell", require("src.layer.ui.UI_PermanentSkinCell"))
local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

---------------------------------------------------PermanentSkinCell---------------------------
function PermanentSkinCell:onCreate()
	self.super.onCreate(self)
	self:setName("PermanentSkinCell")
	
	self:setSwallowsTouches(false)
end

function PermanentSkinCell:initData(data, scroll_view)
	self.item_menu = require("src.comp.menu.UIMenuEx"):create()
	self.item_menu:setPosition(cc.p(self.spr_item_bg:getPositionX() - 85, self.spr_item_bg:getPositionY() + 15))
	self.item_menu:setAnchorPoint(cc.p(0,0.5))
	self:addChild(self.item_menu)
	
	self.item_menu:removeAllChildren()
	self.data = data
	ex.Tools:setSpriteFrame(self.btn_skin,string.format("permanent-skin/skin-icon-%s.png", data.fashion_type))
	self.skin_name:setString(ex.Tools:getLang(cfg.herofashion.herofashion[data.fashion_type].fashion_name))
	ex.Tools:setLimitWidth(self.skin_name, 150)
	local gem = cfg.buygem.buygem[data.buy_gem_id].rmb
	self.btn_buy:getLabel():setString((string.format(ex.Tools:getLang(2705), cfg.buygem.buygem[data.buy_gem_id].rmb / 100)))
	if ex.Player.hero_data.hero_skin_list then
		for i,v in ipairs(ex.Player.hero_data.hero_skin_list) do
			if v == data.fashion_type then
				self.btn_buy:getLabel():setString((ex.Tools:getLang(91539)))
				-- ex.Tools:setAllGrayAuto(self.btn_buy:getNormalImage(),true)
				self.btn_buy:setEnabled(false)
				break
			end
		end
	end

	local scale = 0.4
	for i,v in ipairs(data.item_type) do
		local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
		item:setScale(scale)
		item:setPosition(i * (item:getContentSize().width * 0.5 + 5), self.item_menu:getContentSize().height /2)
		item:registerScriptTapHandler(handler(self, self.onItemInfo))
		self.item_menu:addChild(item)
	end

	self.item_menu:setIsTouchInsideNode(scroll_view)
	self.btn_buy_menu:setIsTouchInsideNode(scroll_view)
end

function PermanentSkinCell:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function PermanentSkinCell:onBuy()
	ex.Player:pay(self.data.buy_gem_id)
end

---------------------------------------------------PermanentSkinLayer---------------------------
 
function PermanentSkinLayer:onCreate()
	self.super.onCreate(self)
	self:setName("PermanentSkinLayer")

	self.elem_type = 0
	self.btn_elem_select = require("src.layer.HeroElemSelect"):new()
    self.btn_elem_select:bindSelect(self.btn_elem0)
    self.btn_elem_select:bindSelect(self.btn_elem1)
    self.btn_elem_select:bindSelect(self.btn_elem2)
    self.btn_elem_select:bindSelect(self.btn_elem3)
    self.btn_elem_select:bindSelect(self.btn_elem4)
    self.btn_elem_select:bindSelect(self.btn_elem5)
    
    self.btn_elem_select:setSelected(ElemType.ALL)
	for i=0,5 do
		self["btn_elem"..i]:registerScriptTapHandler(handler(self, self.elemChanger))
	end
	self.scroll_view.nodeTouched = handler(self, self.skinShow)	
	ex.Tools:setLimitWidth(self.lbl_skin, 130)
	ex.Tools:setLimitWidth(self.lbl_permanent, 150)
	
	self:updateLayer()	
	self:addEvent(EVENT.HERO_SKIN.UPADTE_HERO_SKIN_SHOP,handler(self,self.updateLayer))
end

function PermanentSkinLayer:updateLayer()
	self.scroll_view:removeAllChildren()	
	local scale = ex.s.global_scale
	self.scroll_view:setItemSize(cc.size(190 * scale, 270)) 
	if scale >= 1 then
		scale = 1
	end
	local data = self:getElemData(self.elem_type)	
	self.scroll_view.createItemFunction = function(data)	
		local cell = PermanentSkinCell:create()
		cell:setIgnoreAnchorPointForPosition(false)
		cell:setScale(scale)
		cell:initData(data, self.scroll_view)
		return cell
	end
    self.scroll_view:reloadData(data)  
end

function PermanentSkinLayer:elemChanger(tag,pSender)
	if self.elem_type == tag then
		return
	end
	self.elem_type = tag
	self:updateLayer()
	self.btn_elem_select:setSelected(self.elem_type)
end

--获取同一元素数据
function PermanentSkinLayer:getElemData(elem)
	local elem_data = {}
	local config = cfg.heroskinshop.heroskinshop
	
	if elem == 0 then
		elem_data = config
	else
		for k,v in pairs(config) do
			if v.elem == elem then
				table.insert( elem_data, v ) 
			end
		end
	end
	local function testSort(a,b)
        return tonumber(a.fashion_order) < tonumber(b.fashion_order)
    end
    table.sort(elem_data,testSort)

	return elem_data
end

function PermanentSkinLayer:skinShow(tag,pSender)
	ex.Tools:onClickItemInfo(pSender.data.item_type[2].item_type)
end

function PermanentSkinLayer:onBack(tag , pSender)
    if not ex.MainSceneCtr:backLastLayer() then
        ex.MainSceneCtr:changeLayer(MainSceneType.HERO_LAYER)
    end
end


return PermanentSkinLayer