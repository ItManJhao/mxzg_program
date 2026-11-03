local TotemTipsCtr = class("TotemTipsCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local TotemTipsLayer = class("TotemTipsLayer", require("src.comp.EventLayerAdaptiveWidth"))
local UIMenuItemBag = require("src.comp.menu.UIMenuItemBag")

--------------------------------------------

function TotemTipsLayer:onCreate()
    self:addBlackBackground()
    self:registerBtnEvent()
end

function TotemTipsLayer:registerBtnEvent( )

end


function TotemTipsLayer:upAttr(attr)
    for i=1,2 do
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

function TotemTipsLayer:upIcon()
    self.menu:removeAllChildren()
    local item = UIMenuItemBag:createWithData(self.totem_data.sys_id)
    self.menu:addChild(item)
    item:setPosition(cc.p(0,0))
    local item_cfg = cfg.item.item[self.totem_data.sys_id]
    local name = ex.Tools:getLang(item_cfg.name)
    self.lbl_name:setString(name)
    self.lbl_level:setString(string.format(ex.Tools:getLang(47061),self.totem_data.level))
    local quality = item_cfg.rare_mark + self.totem_data.quality - 1
    item:resetBg(nil, quality)
    self.lbl_quality:setTextColor(ex.Tools:getItemRareColor(quality))
    self.lbl_quality:setString(ex.Tools:getLang(self.totem_data.quality + 76851))
end

function TotemTipsLayer:upSkillInfo(grade_cfg)
    for i=1,3 do
        local node = self["skill_" .. i]
        if node ~= nil then 
            local spr = node:getChildByTag(1)
            local lbl = node:getChildByTag(2)
            local path = self.totem_data.quality < grade_cfg[i].quality and "totem/totem-huidian.png" or "totem/totem-huangdian.png"
            local str = ex.Player.hero_data:getSkillDescription(grade_cfg[i].skill, grade_cfg[i].skill_level)
            local x =  0

            local color = self.totem_data.quality < grade_cfg[i].quality and cc.c3b(144,111,72) or cc.c3b(33,154,0)
            lbl:setColor(color)
            -- spr:setSpriteFrame(path)
            ex.Tools:setSpriteFrame(spr, path)
            lbl:setString(str)
        end
    end

end

function TotemTipsLayer:updatePanel(totem_data)
    self.totem_data = totem_data
    local level_cfg = ex.Player.hero_data.totems:getLevelCfgByType(self.totem_data.sys_id,self.totem_data.level)
    local all_grade_cfg = ex.Player.hero_data.totems:getGradeALLCfgByType(self.totem_data.sys_id)
    self:upIcon()

    local base_attr

    if all_grade_cfg[self.totem_data.quality].needlevel ~= 1 and all_grade_cfg[self.totem_data.quality].needlevel == self.totem_data.level then 
        base_attr = clone(all_grade_cfg[self.totem_data.quality].attr)
    else
        base_attr = clone(level_cfg.attr)
    end

    self:upAttr(base_attr)
    self:upSkillInfo(all_grade_cfg)
    self.lbl_prop_type:setString(ex.Tools:getLang(47086)..ex.Tools:getLang(76801))
end


-----------------------------------------------------------------------------
function TotemTipsCtr:onCreate()
	self:setCCBIPath("ccbi/TotemTipsLayer.ccbi")
	self:setIsSingle(false)
end

function TotemTipsCtr:getLayerClass()
	return TotemTipsLayer
end

function TotemTipsCtr:getTotemTipsLayer()
	return self.layer
end

function TotemTipsCtr:openWindow(totem_data)
	if self:isOpened() then
		return
	end

	self:loadLayer()
    self:open()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer:updatePanel(totem_data)
end

return TotemTipsCtr
