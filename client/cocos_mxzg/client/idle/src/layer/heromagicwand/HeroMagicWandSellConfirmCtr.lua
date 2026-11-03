local HeroMagicWandSellConfirmCtr = class("HeroMagicWandSellConfirmCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroMagicWandSellConfirmLayer = class("HeroMagicWandSellConfirmLayer", require("src.layer.ui.UI_HeroMagicWandSellConfirmLayer"))
------------------------------------------------
function HeroMagicWandSellConfirmLayer:onCreate()
	self.super.onCreate(self)
	self:setName("HeroMagicWandSellConfirmLayer")

    self.col_num = 4

    self.lbl_desc = ex.Tools:createRichText(self.node_desc, "", 18, false, cc.tex2F(0, 0), CommonUIDefine.UIDefine.ComponentOriginType.LEFT_TOP, nil, 1, ex.a.left_top)
    self.lbl_desc:ignoreContentAdaptWithSize(false)
	-- self.lbl_desc:setWrapMode(1)
    self.lbl_desc:setContentSize(cc.size(self.node_desc:getContentSize().width , 0))
    ex.Tools:setLimitWidth(self.lbl_title, 150)

    self.menu = cpp.UIMenu:create()
    -- self.menu:setIsTouchInsideNode(self.scroll_view)
    -- self.menu:setSwallowsTouches(false)
    self.menu:setPosition(cc.p(0, 0))
    self.scroll_view:addChild(self.menu)
end

function HeroMagicWandSellConfirmLayer:updateLayer()
    self:refershTip(#self.sale_list)

    local res_list = self:getRecycleRes(self.sale_list)
    self:refreshRewardList(res_list)
end

function HeroMagicWandSellConfirmLayer:refershTip(num)
    self.lbl_desc:setXmlTextLua(string.format(ex.Tools:getLang(57104), num))
end

function HeroMagicWandSellConfirmLayer:refreshRewardList(reward_list)
    self.scroll_view.createItemFunction = function(data, scale)
        local item = ex.Tools:createBackpackItem(data.item_type, data.item_num)
        item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
        return item
    end
    self.scroll_view:reloadData(reward_list)
end

function HeroMagicWandSellConfirmLayer:onItem(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function HeroMagicWandSellConfirmLayer:getRecycleRes(list)
    local res_list = {}

    local add_res = function(type, num)
        for i,v in ipairs(res_list) do
            if v.item_type == type then
                v.item_num = v.item_num + num
                return
            end
        end

        table.insert(res_list, {item_type = type, item_num = num})
    end

    for i,v in ipairs(list) do
        local config = cfg.magicwandtype.magicwandtype[v.item_type]
        local res_list = ex.Player.backpack_data:getMagicWandSourceCost(v.magic_id)
        for i2,v2 in ipairs(res_list) do
            add_res(v2.item_type, v2.item_num)
        end
    end

    return res_list
end

function HeroMagicWandSellConfirmLayer:onConfirm(tag ,pSender)
    if self.confirm_callback then
        self.confirm_callback(self.sale_list)
    end

    self:onClose()
end

-----------------------------------------------
function HeroMagicWandSellConfirmCtr:loadLayer()
	local tmp_layer = HeroMagicWandSellConfirmLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function HeroMagicWandSellConfirmCtr:onCreate()
	self:setIsSingle(false)
end

function HeroMagicWandSellConfirmCtr:openWindow(item_list, callback)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()

    self.layer.sale_list = item_list
    self.layer.confirm_callback = callback

    self.layer:updateLayer()
end

return HeroMagicWandSellConfirmCtr

