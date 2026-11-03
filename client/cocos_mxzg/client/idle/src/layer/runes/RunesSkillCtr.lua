local RunesSkillCtr = class("RunesSkillCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local RunesSkillLayer = class("RunesSkillLayer", require("src.comp.EventLayer"))
local UIMenuItemRunesSkill = require("src.comp.menu.UIMenuItemRunesSkill")

function RunesSkillLayer:onCreate()
    self:addBlackBackground()
    self.btn_skill_1:setTag(1)
    self.btn_skill_2:setTag(2)
    self.btn_skill_3:setTag(3)
    self.btn_skill_4:setTag(4)

    self.btn_skill_1:setLabelText(ex.Tools:getLang(5009))
    self.btn_skill_2:setLabelText(ex.Tools:getLang(5481))
    self.btn_skill_3:setLabelText(ex.Tools:getLang(5019))
    self.btn_skill_4:setLabelText(ex.Tools:getLang(5809))
    

    self.btn_skill_1:registerScriptTapHandler(handler(self,self.onChange))
    self.btn_skill_2:registerScriptTapHandler(handler(self,self.onChange))
    self.btn_skill_3:registerScriptTapHandler(handler(self,self.onChange))
    self.btn_skill_4:registerScriptTapHandler(handler(self,self.onChange))
    self.btn_skill_1:setChecked(true)
    self.skill_level = 1

    -- self.btn_info:registerScriptTapHandler(handler(self,self.onInfo))

    self.viewSize = self.spr_bg:getContentSize()
    self.scroll_view = cc.ScrollView:create(self.viewSize)
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.spr_bg:addChild(self.scroll_view)
    self.scroll_view:setPosition(0,0)
    self:addFont()
    self:getSkillDataByLevel(1)
    self:updateView()
end

function RunesSkillLayer:getSkillDataByLevel( level )
    self.skill_data = {}
    for k,v in pairs(cfg.runeskilltype.skill) do
        if v.level == level then 
            table.insert(self.skill_data,v)
        end
    end

    local function sor(a,b)
        if a.tag ~= b.tag then return a.tag > b.tag end
        return a.idx < b.idx
    end

    table.sort(self.skill_data, sor)
    self.skill_level = level
end

function RunesSkillLayer:onInfo(tag,pSender)
    dump(pSender)
end

function RunesSkillLayer:onChange(tag,pSender)
    for i=1,3 do
        local item = self["btn_skill_" .. i ]
        item:setChecked(tag == i)
    end
    self:getSkillDataByLevel(tag)
    self:updateView()
end

function RunesSkillLayer:updateView()
    self.scroll_view:getContainer():removeAllChildren()

    local menu = cpp.UIMenu:create()
    :setIsTouchInsideNode(self.scroll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    :setName("menu_hero")
    self.scroll_view:addChild(menu)


    self.item_size = UIMenuItemRunesSkill:createWithIcon(self.skill_data[1]):getContentSize()
    self.item_size.width = self.item_size.width + 0
    self.item_size.height = self.item_size.height + 15
    local margin = 10
    local heroLen = table.nums(self.skill_data)  -- ex.Player.hero_data:getCapacity()
    local col = math.floor((self.viewSize.width - margin * 2) / self.item_size.width) -- 列数
    local row = math.ceil(1.0 * heroLen / col) -- 行数
    local cont_height = (self.item_size.height + margin) * row + margin * 2

    row = math.ceil((cont_height - margin * 2) / self.item_size.height) -- 总行数

    local row_max = math.ceil((self.viewSize.height - margin * 2) / self.item_size.height)
    row = math.max(row, row_max)

    cont_height = math.max(self.item_size.height * row + margin * 2 , self.viewSize.height)


    self.scroll_view:setContentSize(cc.size(self.viewSize.width, cont_height + 10))
    self.scroll_view:setContentOffset(cc.p(0, self.viewSize.height - cont_height - 10))

    cont_height = cont_height - (self.item_size.height * 0.5 + margin * 0.5)

    local start = cc.p((self.viewSize.width + margin) * 0.5 - ((self.item_size.width + margin) * col * 0.5), cont_height)
    start.x = start.x + self.item_size.width * 0.5

    local index = 0
    local ctr = require("src.layer.runes.RunesSkillCtr"):instance()
    for k,v in pairs(self.skill_data) do

        local x = index % col
        local y = math.floor(index / col)
        local item = UIMenuItemRunesSkill:createWithIcon(v)
        item.skill_type = v.skill_id
        item.skill_level = self.skill_level
        item:registerScriptTapHandler(handler(ctr, ctr.onRunesIcon))

        item:setSkillRare(cfg.runeskilltype.skill[v.idx].tag)

        item:setPosition(start.x + x * (self.item_size.width + margin), start.y - y * (self.item_size.height + margin))

        menu:add(item)

        index = index + 1
    end
end

function RunesSkillLayer:addFont()
    -- local lbl_skill_1 = cc.Label:createWithTTF(ex.Tools:getLang(41105), FONT_DEFAULT_NAME_BOLD, 24)
    -- self.btn_skill_1:addChild(lbl_skill_1)
    -- lbl_skill_1:enableOutline(cc.c4b(68,30,3,255), 2)
    -- lbl_skill_1:setPosition(self.btn_skill_1:getContentSize().width / 2,self.btn_skill_1:getContentSize().height / 2)

    -- local lbl_skill_2 = cc.Label:createWithTTF(ex.Tools:getLang(41106), FONT_DEFAULT_NAME_BOLD, 24)
    -- self.btn_skill_2:addChild(lbl_skill_2)
    -- lbl_skill_2:enableOutline(cc.c4b(68,30,3,255), 2)
    -- lbl_skill_2:setPosition(self.btn_skill_2:getContentSize().width / 2,self.btn_skill_2:getContentSize().height / 2)

    -- local lbl_skill_3 = cc.Label:createWithTTF(ex.Tools:getLang(41107), FONT_DEFAULT_NAME_BOLD, 24)
    -- self.btn_skill_3:addChild(lbl_skill_3)
    -- lbl_skill_3:enableOutline(cc.c4b(68,30,3,255), 2)
    -- lbl_skill_3:setPosition(self.btn_skill_3:getContentSize().width / 2-5,self.btn_skill_3:getContentSize().height / 2)
end

-----------------------------------------------------------------------------
function RunesSkillCtr:onCreate()
	self:setCCBIPath("ccbi/RunesSkillLayer.ccbi")
    self:setIsSingle(false)
    
end

function RunesSkillCtr:getLayerClass()
	return RunesSkillLayer
end

function RunesSkillCtr:getRunesSkillLayer()
	return self.layer
end

function RunesSkillCtr:openWindow(str_title)
	if self:isOpened() then
		return
	end
	
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/runes.plist")
    sfc:addSpriteFrames("ccbi-res/skill-icon.plist")

	self:loadLayer()
	self:open()
	self:initData(str_title)
end

function RunesSkillCtr:initData(str_title)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    self.layer.lbl_title:setString(str_title)
	
	self:updateTableView()
end

function RunesSkillCtr:updateTableView()
    if not self:getLayer() then
        return
    end
end


function RunesSkillCtr:onRunesIcon(tag, pSender)
    print("RunesSkillCtr:onRunesIcon", pSender.skill_type, pSender.skill_level)
    require("src.layer.HeroSkillInfoCtr"):instance():openWindow(pSender.skill_type, pSender.skill_level)
end


return RunesSkillCtr
