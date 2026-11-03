local HeroElemSelect = class("HeroElemSelect")

function HeroElemSelect:ctor()
	self.select_list = {}
end

function HeroElemSelect:bindSelect(node)
	local btn = {}
	btn.elem = node:getTag()

	local size = node:getContentSize()
	btn.spr_select = cc.Sprite:createWithSpriteFrameName("other/spr-btn-select.png")
	btn.spr_select:setPosition(size.width / 2, size.height / 2)
	node:addChild(btn.spr_select, 1)

	btn.spr_select:setVisible(false)

	table.insert(self.select_list, btn)
end

function HeroElemSelect:setSelected(elem)
	for _,v in pairs(self.select_list) do
		v.spr_select:setVisible(v.elem == elem)
	end
end

return HeroElemSelect