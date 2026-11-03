local PetInfoIllustratCtr = class("PetInfoIllustratCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PetInfoIllustratLayer = class("PetInfoIllustratLayer", require("src.comp.EventLayerAdaptiveWidth"))
local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBag")

--------------------------------------------

function PetInfoIllustratLayer:onCreate()
    self:addBlackBackground()
end

function PetInfoIllustratLayer:upPetAttr(attr)
    for i=1,4 do
        local node = self["node_attr_" .. i]
        if attr[i] ~= nil then 
            local lbl_name = node:getChildByTag(1)
            local lbl_num = node:getChildByTag(2)

            local name = ex.Tools:getLang(2150000 + attr[i].attr)
            lbl_name:setString(name)

            local num = ex.StringUtil.formatAttrStr(" +"..ex.Tools:getLang(2160000 + attr[i].attr), "##" , attr[i].value)
            lbl_num:setString(num)

            local x = lbl_name:getPositionX() + lbl_name:getContentSize().width
            lbl_num:setPositionX(x)
        end
        node:setVisible(attr[i] ~= nil)
    end
end

function PetInfoIllustratLayer:upPetIcon()
    self.menu_icon:removeAllChildren()
    local item = UIMenuItemBackpack:createWithData(self.pet_data.id,0)
    -- item:registerScriptTapHandler(handler(self,self.onSelectWindow))
    self.menu_icon:addChild(item)
    item:setPosition(cc.p(0,0))
    item:showPetRare()
    item:setLevel(self.pet_data.level)
    local item_cfg = cfg.item.item[self.pet_data.id]
    local name = ex.Tools:getLang(item_cfg.name)
    self.lbl_name:setString(name)
    local color = ex.Tools:getItemRareColor(item_cfg.rare_mark)
    self.lbl_name:setTextColor(color)

    self.lbl_type:setString(ex.Tools:getLang(47086)..ex.Tools:getLang(4811))
end

function PetInfoIllustratLayer:upSkillInfo(skill_id,skill_level)
    self.lbl_skill_tips:setVisible(skill_id == 0 and skill_level == 0)
    self.lbl_skill_desc:setVisible(skill_id ~= 0 and skill_level ~= 0)
    if skill_id ~= 0 then 
        self.lbl_skill_desc:setString(ex.Player.hero_data:getSkillDescription(skill_id, skill_level))
    end
    self.lbl_skill_desc:retain()
    self.lbl_skill_desc:removeFromParent()
    self.scroll_view:getContainer():addChild(self.lbl_skill_desc)
    self.scroll_view:getContainer():setContentSize(self.lbl_skill_desc:getContentSize())
    self.lbl_skill_desc:setPosition(cc.p(-self.lbl_skill_desc:getContentSize().width / 2,0))
    self.scroll_view:setContentOffset(cc.p(self.lbl_skill_desc:getContentSize().width / 2, self.scroll_view:getViewSize().height - self.lbl_skill_desc:getContentSize().height))

end

function PetInfoIllustratLayer:updatePanel(pet_data)
    self.pet_data = pet_data
    self:upPetIcon()
    self:upPetAttr(self.pet_data.attr)
    self:upSkillInfo(self.pet_data.skill,self.pet_data.skill_level)
end


-----------------------------------------------------------------------------
function PetInfoIllustratCtr:onCreate()
	self:setCCBIPath("ccbi/PetInfoIllustratLayer.ccbi")
	self:setIsSingle(false)
end

function PetInfoIllustratCtr:getLayerClass()
	return PetInfoIllustratLayer
end

function PetInfoIllustratCtr:getPetInfoIllustratLayer()
	return self.layer
end

function PetInfoIllustratCtr:openWindow(pet_data)
	if self:isOpened() then
		return
	end

	self:loadLayer()
    self:open()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer:updatePanel(pet_data)
    -- self.layer:changePanelWithStatus(true)
	-- self:initData(data)
end

return PetInfoIllustratCtr
