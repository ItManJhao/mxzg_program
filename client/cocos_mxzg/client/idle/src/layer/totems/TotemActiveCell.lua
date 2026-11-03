local TotemActiveCell = class("TotemActiveCell", require("src.comp.LuaLayerBase"))
local UIMenuItemBag = require("src.comp.menu.UIMenuItemBag")
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

function TotemActiveCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
    self.y = self.btn_submit:getPositionY()
    self:setBtnString()

end

function TotemActiveCell:setBtnString()
    self.lbl_btn_submit = cc.Label:createWithTTF(ex.Tools:getLang(76811), FONT_DEFAULT_NAME_BOLD, 24)
    self.btn_submit:addChild(self.lbl_btn_submit)
    self.lbl_btn_submit:setPosition(self.btn_submit:getContentSize().width * 0.5, self.btn_submit:getContentSize().height * 0.5)
    self.lbl_btn_submit:enableOutline(FONT_BROWN, 1)
    self.btn_submit:registerScriptTapHandler(handler(self, self.onClickSubmit))
end

function TotemActiveCell:onClickSubmit(tag,pSender)
    if self.data.hero_id == ex.Player.hero_data.promote:getSelectHeroById() then return end 
    local req = Totems_pb.GReqTotemsOprea()
    req.type = self.data.hero_id ~= 0 and 3 or 1
    req.t_id = self.data.t_id
    req.hero_id = ex.Player.hero_data.promote:getSelectHeroById()
    NetManager:sendMessage(ProtocolID.GReqTotemsOprea, req)
end

function TotemActiveCell:createMenuWithItem()
	-- body
    self.menu = cpp.UIMenu:create()
    self:addChild(self.menu)
    self.menu:setPosition(0,0)
end


function TotemActiveCell:onClick(tag,pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function TotemActiveCell:getData( )
    return self.data
end

function TotemActiveCell:reset(data)
    self.data = data
    self.menu_icon:removeAllChildren()
    self.menu_hero:removeAllChildren()
    local item_cfg = cfg.item.item[data.sys_id]
    local item = UIMenuItemBag:createWithData(data.sys_id)
    item:registerScriptTapHandler(handler(self, self.showInfo))
    item:resetBg(nil,item_cfg.rare_mark + data.quality - 1)
    self.menu_icon:addChild(item)
    local item_cfg = cfg.item.item[data.sys_id]
    local name = ex.Tools:getLang(item_cfg.name)
    self.lbl_name:setString(name)
    local desc = ex.Tools:getLang(item_cfg.content)
    self.lbl_desc:setString(desc)
    local active = data.hero_id ~= 0
    self.active_node:setVisible(active)
    if active then 
        local hero_data = ex.Player.hero_data:getHeroDataById(data.hero_id)
        local hero = UIMenuItemHero:createWithData(data.hero_id,hero_data.hero_type,hero_data.elem,hero_data.level,hero_data.star)
        hero:setEnableAction(false)
        hero:setAnchorPoint(cc.p(0.5,0.5))
        hero:setScale(0.5)
        self.menu_hero:addChild(hero)
    end
    local y = active and self.y or self:getContentSize().height / 2
    self.btn_submit:setPositionY(y)
    print(self.__cname,active,ex.Player.hero_data.promote:getSelectHeroById() ~= data.hero_id)
    if ex.Player.hero_data.promote:getSelectHeroById() == data.hero_id then 
        self.lbl_equip:setPositionY(self:getContentSize().height / 2)
        self.menu_hero:setPositionY(self:getContentSize().height / 2)
        self.btn_submit:setVisible(false)
    end

end

function TotemActiveCell:showInfo(tag,pSender)
    require("src.layer.totems.TotemTipsCtr"):instance():openWindow(self.data)
end



return TotemActiveCell
