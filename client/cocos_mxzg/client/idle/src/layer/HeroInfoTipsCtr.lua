local HeroInfoTipsCtr = class("HeroInfoTipsCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroInfoTipsLayer = class("HeroInfoTipsLayer", require("src.comp.EventLayer"))

--------------------------------------------

function HeroInfoTipsLayer:onCreate()
    self:addBlackBackground()
	self:setExitCallback(handler(self,self.onExitCB))

end

function HeroInfoTipsLayer:onExitCB()

end


function HeroInfoTipsLayer:updateView(data)
    -- self.hero_data = {}
    -- self.hero_data.type = data.type
    -- self.hero_data.stage = data.star
    -- self.hero_data.star = data.star
    -- self.hero_data.level = cfg.herostar.star[data.star].level_limit
    self:editHeroData(data)
    self:updateHeroAttr()
    self:updateGradeInfo()
    self:addHeroItem()

    -- y = 50.0
end

function HeroInfoTipsLayer:addHeroItem()
    -- body
    local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")
    local node = UIMenuItemHero:createWithData()
    self.menu:add(node)
    node:reset(self.hero_data)
    local x,y = self.node_hero:getPosition()
    node:setPosition(x,y)
    node:setEnabled(false)
end

function HeroInfoTipsLayer:editHeroData(data)
    self.hero_data = {}
    self.hero_data.hero_type = data.type
    self.hero_data.star = data.star
    self.hero_data.occupation = data.occupation
    self.hero_data.elem = data.elem
    self.hero_data.level = data.level or cfg.herostar.star[data.star].level_limit
    local stage = 0
    for k,v in pairs(cfg.heroupgrade.grade) do
        stage = v.grade > stage and v.grade or stage
    end

    self.hero_data.stage = data.stage or (data.star >= stage and stage or data.star)

end

function HeroInfoTipsLayer:updateHeroAttr()
    local hero_attr = ex.Player.hero_data:getHeroAttribute(self.hero_data.hero_type, self.hero_data.stage, self.hero_data.star, self.hero_data.level)
    self.lbl_profession:setString(ex.Tools:getLang(111000 + self.hero_data.occupation))
    self.lbl_attack:setString(string.format("%d", tonumber(hero_attr.atk)))
    self.lbl_hp:setString(string.format("%d", tonumber(hero_attr.hp)))
    self.lbl_defense:setString(string.format("%d", tonumber(hero_attr.def)))
    self.lbl_speed:setString(string.format("%d", tonumber(hero_attr.spd)))
    self.lbl_bat:setString(string.format("%d", tonumber(hero_attr.bat)))

    self.lbl_name:setLocalZOrder(2)
    self.lbl_name:setString(ex.Tools:getLang(self.hero_data.hero_type))


    local stage = math.min(self.hero_data.star, self.hero_data.stage)
    local icon_width = 80
    local vec_skill = ex.Player.hero_data:getHeroSkillList(self.hero_data.hero_type)
    local skill_num = table.nums(vec_skill)
    local UIMenuItemSkill = require("src.comp.menu.UIMenuItemSkill")
    local begin_x = self:getContentSize().width * 0.5 - (skill_num - 1) * icon_width * 0.5
    for i=1,skill_num do
        local skill_level, is_evolve_skill, skill_id = ex.Player.hero_data:getHeroSkillLevel(stage, self.hero_data.star, i, self.hero_data.hero_type, self.hero_data.evolve)
        local btn_skill = UIMenuItemSkill:createWithIcon(skill_id, skill_level, is_evolve_skill, handler(self, self.onSkillInfo))
        btn_skill:setPosition(begin_x + icon_width * (i - 1), 50)
        self.menu:addChild(btn_skill)

        btn_skill.lbl_name:setVisible(false)

        btn_skill.skill_index = i
    end

    -- local vec_hero_skill = ex.Player.hero_data:getHeroSkillList(self.hero_data.hero_type)
end

function HeroInfoTipsLayer:onSkillInfo(tag, pSender)
    local skill_ctr = require("src.layer.HeroSkillInfoCtr"):instance()
	local skill_level_next_need_star = ex.Player.hero_data:getHeroSkillLevelNeedStar(pSender.skill_level + 1, pSender.skill_index, self.hero_data.hero_type)
    skill_ctr:openWindow(pSender.skill_type, pSender.skill_level, skill_level_next_need_star)

    if skill_ctr.layer then
        skill_ctr.layer:setLocalZOrder(1000002)
    end
end

function HeroInfoTipsLayer:updateGradeInfo()
    if not self.gradeArr then 
        self.gradeArr = {}
        for i=1,6 do
            self.gradeArr[i] = self["sp_grade" .. i]
        end
    end
    local maxStar = self.hero_data.star
    for k,v in pairs(self.gradeArr) do
        v:setVisible(k<=maxStar)
        local path = self.hero_data.stage >= k and "hero-info/spr-quality-2.png" or "hero-info/spr-quality-1.png"
        v:initWithSpriteFrameName(path)
    end
end


-----------------------------------------------------------------------------
function HeroInfoTipsCtr:onCreate()
	self:setCCBIPath("ccbi/HeroInfoTipsLayer.ccbi")
	self:setIsSingle(false)
end

function HeroInfoTipsCtr:getLayerClass()
	return HeroInfoTipsLayer
end

function HeroInfoTipsCtr:getHeroInfoTipsLayer()
	return self.layer
end

function HeroInfoTipsCtr:openWindow(data)
	if self:isOpened() then
		return
	end
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/skill-icon.plist")
	self:loadLayer()
	self:open()
	self:initData(data)
end

function HeroInfoTipsCtr:initData(data)
	self:updateLayer(data)
end

function HeroInfoTipsCtr:onClickUpgrade(tag,pSender)

end

function HeroInfoTipsCtr:updateLayer(data)
    -- dump(data)
	local layer = self.layer
    layer:updateView(data)
    layer.btn_close:registerScriptTapHandler(handler(self,self.closeWindow))
end

return HeroInfoTipsCtr
