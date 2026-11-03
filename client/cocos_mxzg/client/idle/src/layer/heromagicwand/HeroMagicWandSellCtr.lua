local HeroMagicWandSellCtr = class("HeroMagicWandSellCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroMagicWandSellLayer = class("HeroMagicWandSellLayer", require("src.layer.ui.UI_HeroMagicWandSellLayer"))
------------------------------------------------
function HeroMagicWandSellLayer:onCreate()
	self.super.onCreate(self)
	self:setName("HeroMagicWandSellLayer")

    self.btn_rare_array = {}
    for i = 1, 99 do
        local btn = self["btn_rare"..i]

		if btn == nil then
			break
		end

        btn:setChecked(i == 1)
		
        table.insert(self.btn_rare_array, btn)
        
        local lbl_tips = self["lbl_tip"..i]
        if lbl_tips then
            ex.Tools:setLimitWidth(lbl_tips, 80)
        end
    end
    ex.Tools:setLimitWidth(self.lbl_title, 150)
end

function HeroMagicWandSellLayer:updateLayer()

end

function HeroMagicWandSellLayer:getSelected()
	local rare_list = {}

	for i,v in ipairs(self.btn_rare_array) do
        if v:isChecked() then
            table.insert(rare_list, v:getTag())
        end
    end

	return rare_list
end

function HeroMagicWandSellLayer:onConfirm(tag ,pSender)
    local rare_list = self:getSelected()

    -- 获得选择出售的神装
    local item_list = ex.Player.backpack_data:getFreeMagicWandForRare(rare_list)
    if not item_list or #item_list <= 0 then
        -- 没有选中的物品
        ex.MessageView:add(ex.Tools:getLang(72756))
        return 
    end

    require("src.layer.heromagicwand.HeroMagicWandSellConfirmCtr"):instance():openWindow(item_list, self.confirm_callback)

    self:onClose()
end

-----------------------------------------------
function HeroMagicWandSellCtr:loadLayer()
	local tmp_layer = HeroMagicWandSellLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function HeroMagicWandSellCtr:onCreate()
	self:setIsSingle(false)
end

function HeroMagicWandSellCtr:openWindow(callback)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()

	self.layer.confirm_callback = callback

    self.layer:updateLayer()
end

return HeroMagicWandSellCtr

