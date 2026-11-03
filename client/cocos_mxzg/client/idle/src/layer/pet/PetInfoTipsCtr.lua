local PetInfoTipsCtr = class("PetInfoTipsCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PetInfoTipsLayer = class("PetInfoTipsLayer", require("src.comp.EventLayerAdaptiveWidth"))
local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBag")

--------------------------------------------

function PetInfoTipsLayer:onCreate()
    self:addBlackBackground()
    self:registerBtnEvent()
end

function PetInfoTipsLayer:registerBtnEvent( )

    self.lbl_btn_use = cc.Label:createWithTTF(ex.Tools:getLang(4814), FONT_DEFAULT_NAME_BOLD, 24)
    self.lbl_btn_use:setTextColor(cc.c3b(122,71,45))
    self.btn_use:addChild(self.lbl_btn_use)
    self.lbl_btn_use:setPosition(self.btn_use:getContentSize().width * 0.5, self.btn_use:getContentSize().height * 0.5)

    self.lbl_btn_src = cc.Label:createWithTTF(ex.Tools:getLang(4815), FONT_DEFAULT_NAME_BOLD, 24)
    self.btn_src:addChild(self.lbl_btn_src)
    self.lbl_btn_src:setTextColor(cc.c3b(122,71,45))
    self.lbl_btn_src:setPosition(self.btn_src:getContentSize().width * 0.5, self.btn_src:getContentSize().height * 0.5)

    self.btn_use:registerScriptTapHandler(handler(self,self.onJump))
    self.btn_src:registerScriptTapHandler(handler(self,self.onSrc))
end

function PetInfoTipsLayer:onSrc(tag,pSender)
    ex.Tools:onClickItemSrc(self.pet_data.item_type)
    PetInfoTipsCtr:instance():closeWindow()
end

function PetInfoTipsLayer:onJump(tag,pSender)
    ex.MainSceneCtr:changeLayer(MainSceneType.HERO_LAYER)
    PetInfoTipsCtr:instance():closeWindow()
end

function PetInfoTipsLayer:upPetAttr(attr)
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

function PetInfoTipsLayer:upPetIcon()
    self.menu_icon:removeAllChildren()
    local item = UIMenuItemBackpack:createWithData(self.pet_data.item_type,0)
    -- item:registerScriptTapHandler(handler(self,self.onSelectWindow))
    self.menu_icon:addChild(item)
    item:setPosition(cc.p(0,0))
    item:showPetRare()
    item:setLevel(self.pet_data.level)
    local item_cfg = cfg.item.item[self.pet_data.item_type]
    local name = ex.Tools:getLang(item_cfg.name)
    self.lbl_name:setString(name)
    local color = ex.Tools:getItemRareColor(item_cfg.rare_mark)
    self.lbl_name:setTextColor(color)

    self.lbl_type:setString(ex.Tools:getLang(47086)..ex.Tools:getLang(4811))
end

function PetInfoTipsLayer:upSkillInfo(skill_id,skill_level)
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

function PetInfoTipsLayer:updatePanel(pet_data)
    local pet_cfg = ex.Player.hero_data.pet:getLevelCfgByType(pet_data.item_type,pet_data.level)
    self.pet_data = pet_data
    self:upPetIcon()
    self:upPetAttr(pet_cfg.attr)
    self:upSkillInfo(pet_cfg.skill,pet_cfg.skill_level)
end


-----------------------------------------------------------------------------
function PetInfoTipsCtr:onCreate()
	self:setCCBIPath("ccbi/PetInfoTipsLayer.ccbi")
	self:setIsSingle(false)
end

function PetInfoTipsCtr:getLayerClass()
	return PetInfoTipsLayer
end

function PetInfoTipsCtr:getPetInfoTipsLayer()
	return self.layer
end

function PetInfoTipsCtr:openWindow(pet_data)
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

return PetInfoTipsCtr
