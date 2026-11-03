local PetInfoCtr = class("PetInfoCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PetInfoLayer = class("PetInfoLayer", require("src.comp.EventLayerAdaptiveWidth"))
local UIMenuItemBag = require("src.comp.menu.UIMenuItemBag")

--------------------------------------------

function PetInfoLayer:onCreate()
    -- self.item_type = 1100505
    self.up_level_cost = {}
    self:registerBtnEvent()
    self:upBtnLable()
    -- self:createCheckBox()
    self:addBlackBackground()
    self:addEvent(EVENT.PET.PET_CHANGE,handler(self,self.changePet))
    self:addEvent(EVENT.PET.PET_OUT,handler(self,self.changePet))
    self:addEvent(EVENT.PET.PET_UP_LEVEL,handler(self,self.changePet))
end

function PetInfoLayer:changePet(event,data)
    self:changePanelWithStatus()
end

function PetInfoLayer:registerBtnEvent( )
    self.btn_get:registerScriptTapHandler(handler(self, self.onShowSrc))
    self.btn_ill1:registerScriptTapHandler(handler(self, self.onIllutrast))
    self.btn_ill2:registerScriptTapHandler(handler(self, self.onIllutrast))
    self.btn_icon:registerScriptTapHandler(handler(self, self.onSelectWindow))
    self.btn_max:registerScriptTapHandler(handler(self, self.onShowMax))
    self.btn_disboard:registerScriptTapHandler(handler(self, self.onDisboard))
    self.btn_up_level:registerScriptTapHandler(handler(self, self.onUpLevel))
end

function PetInfoLayer:upBtnLable( )
    local spr_add = cc.Sprite:createWithSpriteFrameName("other/spr-add-1.png")
    self.btn_icon:addChild(spr_add)
    spr_add:setPosition(self.btn_icon:getContentSize().width / 2,self.btn_icon:getContentSize().height / 2)

    local lbl_text = cc.Label:createWithTTF(ex.Tools:getLang(4801), FONT_DEFAULT_NAME_BOLD, 18)
    lbl_text:setAnchorPoint(cc.p(0.5, 0.5))
    lbl_text:setTextColor(cc.c3b(255,255,255))
    lbl_text:enableOutline(cc.c3b(0,75,129),2)
    self.btn_ill1:addChild(lbl_text)
    lbl_text:setPosition(self.btn_ill1:getContentSize().width / 2,0)

    local lbl_text1 = cc.Label:createWithTTF(ex.Tools:getLang(4801), FONT_DEFAULT_NAME_BOLD, 18)
    lbl_text1:setAnchorPoint(cc.p(0.5, 0.5))
    lbl_text1:setTextColor(cc.c3b(255,255,255))
    lbl_text1:enableOutline(cc.c3b(0,75,129),2)
    self.btn_ill2:addChild(lbl_text1)
    lbl_text1:setPosition(self.btn_ill2:getContentSize().width / 2,0)

    local lbl_max = cc.Label:createWithTTF(ex.Tools:getLang(4800), FONT_DEFAULT_NAME_BOLD, 20)
    lbl_max:setAnchorPoint(cc.p(0.5, 0.5))
    lbl_max:setTextColor(cc.c3b(253,228,181))
    lbl_max:enableOutline(cc.c3b(87,56,29),2)
    self.btn_max:addChild(lbl_max)
    lbl_max:setPosition(self.btn_max:getContentSize().width / 2 + 5,self.btn_max:getContentSize().height / 2)

    local lbl_disboard = cc.Label:createWithTTF(ex.Tools:getLang(4805), FONT_DEFAULT_NAME_BOLD, 24)
    lbl_disboard:setAnchorPoint(cc.p(0.5, 0.5))
    lbl_disboard:setTextColor(cc.c3b(255,255,255))
    lbl_disboard:enableOutline(cc.c3b(13,91,45),2)
    self.btn_disboard:addChild(lbl_disboard)
    lbl_disboard:setPosition(self.btn_disboard:getContentSize().width / 2,self.btn_disboard:getContentSize().height / 2)

    local lbl_upLevel = cc.Label:createWithTTF(ex.Tools:getLang(4806), FONT_DEFAULT_NAME_BOLD, 24)
    lbl_upLevel:setAnchorPoint(cc.p(0.5, 0.5))
    lbl_upLevel:setTextColor(cc.c3b(255,255,255))
    lbl_upLevel:enableOutline(cc.c3b(131,43,22),2)
    self.btn_up_level:addChild(lbl_upLevel)
    lbl_upLevel:setPosition(self.btn_up_level:getContentSize().width / 2,self.btn_up_level:getContentSize().height / 2)
end

function PetInfoLayer:onUpLevel(tag,pSender)
    local level_cfg = ex.Player.hero_data.pet:getLevelCfgByType(self.pet_data.sys_id,self.pet_data.level)
    if level_cfg.need_pet > #self.up_level_cost then 
        ex.Tools:onClickItemInfo(self.pet_data.sys_id)
        return 
    end
    for i,v in ipairs(level_cfg.cost) do
        local has_num = ex.Player:getItemNum(v.item_type)
        if has_num < v.item_num then 
            ex.Tools:onClickItemInfo(v.item_type)
            return 
        end
    end
    local req = Pet_pb.GReqPetUpLevel()
    req.pet_id = self.pet_data.pet_id
    for i,v in ipairs(self.up_level_cost) do
        table.insert(req.pet_list,v)
    end
    NetManager:sendMessage(ProtocolID.GReqPetUpLevel, req)

end

function PetInfoLayer:onDisboard(tag,pSender)
    local req = Pet_pb.GReqDisboardPet()
    req.pet_id = self.pet_data.pet_id
    req.hero_id = self.hero_id
    NetManager:sendMessage(ProtocolID.GReqDisboardPet, req)
end

function PetInfoLayer:onShowMax(tag,pSeder)
    local level_cfg = ex.Player.hero_data.pet:getPetMaxCfgByType(self.pet_data.sys_id)
    require("src.layer.pet.PetInfoIllustratCtr"):instance():openWindow(level_cfg)
end

function PetInfoLayer:onItemInfo(tag,pSender)
    ex.Tools:showItemInfo(tag,pSender)
end

function PetInfoLayer:onSelectWindow(tag,pSeder)
    local data = ex.Player.hero_data.pet:canCarryPetByHero(self.hero_id)
    local function sor (a,b)
        local proA = cfg.pet.pet[a.sys_id].rare
        local proB = cfg.pet.pet[b.sys_id].rare
        -- if proA == proB then 
        --     return a.level > b.level
        -- end
        if proA ~= proB then 
            return proA > proB
        end

        if a.level ~= b.level then 
            return a.level > b.level
        end
        
        return a.sys_id > b.sys_id
    end
    table.sort(data,sor)

    local function send_carry (data)
        if #data == 0 then return end
        local req = Pet_pb.GReqCarryPet()
        req.hero_id = self.hero_id
        req.pet_id = data[1]
        NetManager:sendMessage(ProtocolID.GReqCarryPet, req)
    end
    local pet_type = self.pet_data ~= nil and self.pet_data.sys_id or nil 
    require("src.layer.pet.PetSelectCtr"):instance():openWindow(data,pet_type,1,send_carry,true)
end

function PetInfoLayer:onSelectPetWindow(tag,pSeder)
    local callback = function (data)
        self.up_level_cost = {}
        for i,v in ipairs(data) do
            table.insert(self.up_level_cost,v)
        end
        local level_cfg = ex.Player.hero_data.pet:getLevelCfgByType(self.pet_data.sys_id,self.pet_data.level)
        self.pet_item:setNumComp(#self.up_level_cost,level_cfg.need_pet)
        local has_num = #ex.Player.hero_data.pet:notCarryPetListByType(self.pet_data.sys_id)
        local is_red = has_num > level_cfg.need_pet and #self.up_level_cost < level_cfg.need_pet
        ex.Tools:addRedPoint(self.pet_item,is_red)
    end
    local data = ex.Player.hero_data.pet:notCarryPetListByType(self.pet_data.sys_id)
    local tmp_data = clone(data)
    for i,v in ipairs(tmp_data) do
        for i,val in ipairs(self.up_level_cost) do
            v.select = v.pet_id == val
            if v.select == true then break end
        end
    end
    local level_cfg = ex.Player.hero_data.pet:getLevelCfgByType(self.pet_data.sys_id,self.pet_data.level)
    local function sor (a,b)
        local proA = a.select == true and 100 or 0
        local proB = b.select == true and 100 or 0
        if proA ~= proB then return proA > proB end
        return a.level < b.level
    end
    table.sort(tmp_data,sor)
    require("src.layer.pet.PetSelectCtr"):instance():openWindow(tmp_data,self.pet_data.sys_id,level_cfg.need_pet,callback,true,true)
end

function PetInfoLayer:onIllutrast(tag,pSeder)
    require("src.layer.pet.PetIllustratCtr"):instance():openWindow()
end

function PetInfoLayer:onShowSrc(tag,pSender)
    local item_type = self.status and self.pet_data.sys_id or 900503
    ex.Tools:onClickItemSrc(item_type)
end

function PetInfoLayer:changePanelWithStatus()
    
    local pet_data = ex.Player.hero_data.pet:getPetByHeroId(self.hero_id)
    local has_pet = pet_data ~= nil
    self.pet_data = pet_data
    self.status = has_pet
    self.has_pet:setVisible(has_pet == true)
    self.not_pet:setVisible(has_pet ~= true)

    self.btn_disboard:setVisible(has_pet)
    if has_pet then 
        
    -- else
        self:upPetInfoPanel()
    end
    local is_red = ex.Player.hero_data.pet:checkRedPointByHeroId(self.hero_id)
    ex.Tools:addRedPoint(self.btn_icon,is_red,cc.p(0.8,0.8))
end

function PetInfoLayer:upPetInfoPanel( )
    local level_cfg = ex.Player.hero_data.pet:getLevelCfgByType(self.pet_data.sys_id,self.pet_data.level)
    local is_max = ex.Player.hero_data.pet:getLevelCfgByType(self.pet_data.sys_id,self.pet_data.level + 1) == nil 
    self.btn_up_level:setVisible(not is_max)
    self:upPetIcon()
    self:upPetAttr(level_cfg.attr)
    self:upLevelItem(level_cfg.cost,level_cfg.need_pet,is_max)
    self:upSkillInfo(level_cfg.skill,level_cfg.skill_level)
end

function PetInfoLayer:upPetIcon()
    self.menu_icon:removeAllChildren()
    local item = UIMenuItemBag:createWithData(self.pet_data.sys_id)
    item:setLevel(self.pet_data.level)
    item:registerScriptTapHandler(handler(self,self.onSelectWindow))
    -- item:showPetRare()
    self.menu_icon:addChild(item)
    item:setPosition(cc.p(0,0))
    local item_cfg = cfg.item.item[self.pet_data.sys_id]
    local name = ex.Tools:getLang(item_cfg.name)
    self.lbl_pet_name:setString(name)
end

function PetInfoLayer:upPetAttr(attr)
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

function PetInfoLayer:upLevelItem(cost,need_pet,is_max)
    self.lbl_max_tips:setVisible(is_max)
    self.item_name_node:setVisible(not is_max)
    self.menu_item:removeAllChildren()
    if not is_max then 
        self.pet_item = UIMenuItemBag:createWithData(self.pet_data.sys_id,0)
        self.pet_item:registerScriptTapHandler(handler(self,self.onSelectPetWindow))
        self.pet_item:setScale(0.8)
        -- self.pet_item:showPetRare()
        self.menu_item:addChild(self.pet_item)
        self.pet_item:setNumComp(0,need_pet)
        local x,y = self.item_node_1:getPosition()
        self.pet_item:setPosition(cc.p(x,y))
        local lbl_name = self["lbl_name_" .. 1]
        local name = ex.Tools:getLang(cfg.item.item[self.pet_data.sys_id].name)
        lbl_name:setString(name)
        local has_num = #ex.Player.hero_data.pet:notCarryPetListByType(self.pet_data.sys_id)

        ex.Tools:addRedPoint(self.pet_item,has_num >= need_pet)
        for i,v in ipairs(cost) do
            local x,y = self["item_node_" .. i+1]:getPosition()
            local item = UIMenuItemBag:createWithData(v.item_type,v.item_num)
            item:setScale(0.8)
            self.menu_item:addChild(item)
            item:setPosition(cc.p(x,y))
            local lbl_name = self["lbl_name_" .. i+1]
            local name = ex.Tools:getLang(cfg.item.item[v.item_type].name)
            lbl_name:setString(name)
            local has_num = ex.Player:getItemNum(v.item_type)
            item:setNumComp(has_num,v.item_num)
            item:registerScriptTapHandler(handler(self,self.onItemInfo))
        end
    end
end

function PetInfoLayer:upSkillInfo(skill_id,skill_level)
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

function PetInfoLayer:onExit()

end



-----------------------------------------------------------------------------
function PetInfoCtr:onCreate()
	self:setCCBIPath("ccbi/PetInfoLayer.ccbi")
	self:setIsSingle(false)
end

function PetInfoCtr:getLayerClass()
	return PetInfoLayer
end

function PetInfoCtr:getPetInfoLayer()
	return self.layer
end

function PetInfoCtr:openWindow(hero_id)
	if self:isOpened() then
		return
	end
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/achievement.plist")

	self:loadLayer()
    self:open()
    self.layer.hero_id = hero_id
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer:changePanelWithStatus()
	-- self:initData(data)
end

return PetInfoCtr
