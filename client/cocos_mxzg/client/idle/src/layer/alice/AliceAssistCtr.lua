local AliceAssistCtr = class("AliceAssistCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local AliceAssistLayer = class("AliceAssistLayer", require("src.layer.ui.UI_AliceAssistLayer"))
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero") -- require("src.comp.menu.UIMenuItemHero")

function AliceAssistLayer:onCreate()
    self.super.onCreate(self)
	self:setName("AliceAssistLayer")  
end

function AliceAssistLayer:initData(callback)
    self.callback = callback
    self.btn_elem_select = require("src.layer.HeroElemSelect"):new()
    self.btn_elem_select:bindSelect(self.btn_elem0)
    self.btn_elem_select:bindSelect(self.btn_elem1)
    self.btn_elem_select:bindSelect(self.btn_elem2)
    self.btn_elem_select:bindSelect(self.btn_elem3)
    self.btn_elem_select:bindSelect(self.btn_elem4)
    self.btn_elem_select:bindSelect(self.btn_elem5)
    self.btn_elem_select:setSelected(ElemType.ALL)
    self.cur_hero_elem = ElemType.ALL  

    self.scroll_view = require("src.comp.UIScrollViewBackpack"):createWithSize(cc.size(560, 490))
    self.scroll_view:setIgnoreAnchorPointForPosition(false)
    self.scroll_view:setAnchorPoint(0.5, 1)
    self.scroll_view:setPosition(self.spr_box:getContentSize().width / 2, self.lbl_tips_1:getPositionY() - 30)
    self.scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.scroll_view:setItemSize(cc.size(135, 110))
    self.scroll_view:setItemOffset(cc.p(0, 0))
    self.scroll_view:setAutoFull(true)
    self.spr_box:addChild(self.scroll_view)
    self:changeHeroElem(self.cur_hero_elem)
end

function AliceAssistLayer:changeHeroElem(elem)
    self.btn_elem_select:setSelected(elem)
    -- local list = ctr.alice.data:getHeroAssistList(elem)
    -- self:updateTableView(list)
    self:updateTableView(elem)
end

function AliceAssistLayer:updateTableView(elem)
    local list = ctr.alice.data:getHeroAssistList(elem)
    self.scroll_view.createItemFunction = function(data)
        -- local hero_data = {}
        -- hero_data.hero_id = data.hero_id or 0
        -- hero_data.hero_type = data.hero_type
        -- hero_data.elem = data.elem or cfg.herotype.star[ data.hero_type].elem
        -- hero_data.level = data.hero_level
        -- hero_data.star = data.hero_star

        local item = UIMenuItemHero:createWithData()
        -- item:reset(hero_data)
        item:reset(data)

        item:registerScriptTapHandler(handler(self, self.onBackpackIcon))
        item:setScale(1)

        return item
    end
    self.scroll_view:reloadData(list)
    self.scroll_view.menu:setLuaModel(true)
    self.scroll_view.menu:enableLongPress(true)
    self.scroll_view.menu:setLongPressCallback(handler(self, self.longTouch))

end

function AliceAssistLayer:onElem(tag, pSender)
    --设置属性的点击状态呢
    if self.cur_hero_elem == tag then
        return
    end
    self.cur_hero_elem = tag
    self:changeHeroElem(self.cur_hero_elem)
end

function AliceAssistLayer:onConfirm()
    self.assist_hero_idx = TableEx.getIndexIpairsFunction(cfg.aliceplayerhero.aliceplayerhero,function (v)
        return v.hero_type == self.hero_type and v.hero_star == ctr.alice.data.star
    end)
    if self.assist_hero_idx ~= -1 then
        local req = Alice_pb.GReqAliceSelectAssist()
        req.star = ctr.alice.data.star
        req.idx = self.assist_hero_idx
        NetManager:sendMessage(ProtocolID.GReqAliceSelectAssist, req)	
        ex.MessageView:add(ex.Tools:getLang(580065))
        -- if self.callback then
        --     self.callback(true)
        -- end
        self:onClose() 
    end 
end

function AliceAssistLayer:onBackpackIcon(tag, pSender)
    if pSender.hero_type == 0 then
        return
    end
    if pSender.hero_type == self.hero_type then
        pSender:setSelected(false)
        self.hero_type = nil
        return
    end
    local childrens = self.scroll_view.menu:getChildren()
    for i,v in ipairs(childrens) do
        v:setSelected(false)
    end
   
    pSender:setSelected(true)
    self.hero_type = pSender.hero_type 
end

function AliceAssistLayer:longTouch(tag, pSender)

    if pSender.friend_type and pSender.friend_type >= 1 then
        return
    end
    -- local req_detail = Alice_pb.GReqAliceHeroDetail()
    -- req_detail.hero_id = -1
    -- req_detail.star = pSender.data.star
    -- NetManager:sendMessage(ProtocolID.GReqAliceHeroDetail, req_detail)

    require("src.layer.alice.AliceAssistHeroShareInfoCtr"):instance():openWindow(pSender.data)
end

-----------------------------------------------------------------------------
function AliceAssistCtr:loadLayer()
	local tmp_layer = AliceAssistLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function AliceAssistCtr:onCreate()
	self:setIsSingle(false)
end

function AliceAssistCtr:openWindow(callback)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
    self.layer:initData(callback)
end

return AliceAssistCtr
