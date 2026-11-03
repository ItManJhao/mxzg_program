local ArtifactTransformItem = class("ArtifactTransformItem",require("src.comp.EventLayer"))

function ArtifactTransformItem:onCreate()

end

function ArtifactTransformItem:reset(data)
    self:updateAttr(data)
end

function ArtifactTransformItem:updateAttr(data)
    self.data = data

    local ability = data.ability
    local special_ability = data.special_ability
    local suit_ability = cfg.reikiequipsuit.reikiequipsuit[data.suit_id].suit_ability
    self.height = 0
    -- 排序属性 
    local function sortAbility(a, b)
        local compA = TableEx.findValueFunction(cfg.scorecount.equip, function(value)
			return value.mapping == a.attr
		end)
        compA = compA and compA.idx or 100

        local compB = TableEx.findValueFunction(cfg.scorecount.equip, function(value)
			return value.mapping == a.attr
		end)
        compB = compB and compB.idx or 100

        return compA < compB
    end
    table.sort(ability, sortAbility)
    table.sort(special_ability, sortAbility)
    table.sort(suit_ability, sortAbility)
    local bg = cc.Sprite:createWithSpriteFrameName("artifacts/spr-title-bg.png")
    local title_bg_height = bg:getContentSize().height
    local title_size = 20
    local title_margin = 10
    local lbl_size = 18
    local lbl_margin = 15
    self.scroll_view:getContainer():removeAllChildren()

    self:calculateHeight(ability,title_bg_height,title_margin,lbl_size,lbl_margin)
    self:calculateHeight(special_ability,title_bg_height,title_margin,lbl_size,lbl_margin)
    self:calculateHeight(suit_ability,title_bg_height,title_margin,lbl_size,lbl_margin)

    self:updataSkillAttr()
    self.y = self.height-- - 10

    -- local lbl_special_ability_text = cc.Label:createWithTTF(ex.Tools:getLang(75008), FONT_DEFAULT_NAME_BOLD, 20)
    if table.nums(special_ability) > 0 then 
        self:createTitle(ex.Tools:getLang(75008),title_bg_height)

        self:createAttrItems(special_ability,lbl_margin,lbl_size)

    end
    self.y = self.y - 20
    if table.nums(ability) > 0 then 
        self:createTitle(ex.Tools:getLang(75009),title_bg_height)

        self:createAttrItems(ability,lbl_margin,lbl_size)

    end
    self.y = self.y - 20

    if table.nums(suit_ability) > 0 then 
        self:createTitle(ex.Tools:getLang(75011),title_bg_height)
        self:createAttrItems(suit_ability,lbl_margin,lbl_size)
    end
    self.y = self.y - 20
    if self.tips_panel ~= nil then 
        self.y = self.y - self.tips_panel:getContentSize().height
        self.tips_panel:setPositionY(self.y)
        
    end
    -- local rich_size = self.rich_text:getContentSize()
    local view_size = self.scroll_view:getContainer():getContentSize()

    self.scroll_view:setContentSize(view_size.width,self.height)
    self.scroll_view:setContentOffset(cc.p(0, self.scroll_view:getViewSize().height - self.scroll_view:getContentSize().height))
end

function ArtifactTransformItem:createTitle(titile_str,height)
    local title_bg = cc.Sprite:createWithSpriteFrameName("artifacts/spr-title-bg.png")
    :setAnchorPoint(cc.p(0, 0.5))
    title_bg:setPosition(0, self.y - height / 2)
    self.scroll_view:getContainer():addChild(title_bg)

    local lbl_special_ability_text = cc.Label:createWithTTF(titile_str, FONT_DEFAULT_NAME_BOLD, 20)
    :setAnchorPoint(cc.p(0, 0.5))
    :setTextColor(cc.c3b(255, 224, 178))
    lbl_special_ability_text:setPosition(5, self.y - height / 2)
    self.scroll_view:getContainer():addChild(lbl_special_ability_text)
    self.y = self.y - height / 2 - 5
end

function ArtifactTransformItem:createAttrItems(ability,lbl_margin,lbl_size)
    for i,v in ipairs(ability) do
        local spr_icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack-info/spr-attr-%d.png", cfg.attrshow.attrshow[v.attr].icon))
        spr_icon:setScale(0.6)
        :setAnchorPoint(cc.p(0, 0.5))
        spr_icon:setPosition(10, self.y - (lbl_margin + lbl_size))
        self.scroll_view:getContainer():addChild(spr_icon)
        
        local str = ex.Tools:getLang(2150000 + v.attr)..":"
        local lbl_ability = cc.Label:createWithTTF(str, FONT_DEFAULT_NAME_BOLD, 18)
        :setTextColor(cc.c3b(116,77,39))
        :setAnchorPoint(cc.p(0, 0.5))
        :setPosition(0 + 45, self.y - (lbl_margin + lbl_size))
        self.scroll_view:getContainer():addChild(lbl_ability)

        local lbl_ability_num = cc.Label:createWithTTF(ex.StringUtil.formatAttrStr(" "..ex.Tools:getLang(2160000 + v.attr), "##" , v.value), FONT_DEFAULT_NAME_BOLD, 20)
        :setTextColor(cc.c3b(116,77,39))
        :setAnchorPoint(cc.p(0, 0.5))
        :setPosition(lbl_ability:getPositionX() + lbl_ability:getContentSize().width, lbl_ability:getPositionY())
        self.scroll_view:getContainer():addChild(lbl_ability_num)

        self.y = self.y - (lbl_margin + lbl_size)
    end
    self.y = self.y - 5
end

function ArtifactTransformItem:updataSkillAttr()

    local suit_cfg = cfg.reikiequipsuit.reikiequipsuit[self.data.suit_id]

    if suit_cfg.skill ~= 0 then 
        if not self.tips_panel then 
            self.tips_panel = require("src.layer.artifacts.ArtifactTransformSkill"):createWithCCBIFile("ccbi/ArtifactTransformSkill.ccbi")
        end
        self.tips_panel:reset(suit_cfg)
        self.scroll_view:getContainer():addChild(self.tips_panel)
        self.tips_panel:setPosition(0,0)
        self.height = self.height + self.tips_panel:getContentSize().height
    end
end

function ArtifactTransformItem:calculateHeight(ability,title_bg_height,title_margin,lbl_size,lbl_margin)
    if table.nums(ability) > 0 then 
        self.height = self.height + title_bg_height + title_margin
        local len = table.nums(ability)
        self.height = self.height + len * (lbl_size + lbl_margin)
    end
end

return ArtifactTransformItem