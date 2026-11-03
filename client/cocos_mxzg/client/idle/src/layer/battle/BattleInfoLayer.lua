local BattleInfoLayer = class("BattleInfoLayer",require("src.comp.EventLayer"))
function BattleInfoLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    
    self.max_round = 15

    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.lbl_name1:enableOutline(cc.c3b(14,57,113), 1)
    self.lbl_name2:enableOutline(cc.c3b(90,21,12), 1)

    self.btn_speed:getParent():setTag(100000)

    self.menu = cpp.UIMenu:create()
    self:addChild(self.menu)
    self.menu:setPosition(0,0)

    self.spr_contract1:setVisible(false)
    self.spr_contract2:setVisible(false)

    for i=1,2 do
        local spr_name_bg = self["spr_name_bg"..i]
        local size = spr_name_bg:getContentSize()
        local pos = self:convertToNodeSpace(spr_name_bg:convertToWorldSpace(cc.p(size.width * 0.5, size.height * 0.5)))
        -- pos.x = pos.x + 5
        self["lbl_name"..i]:setPosition(pos)
    end
    -- self:addEvent(EVENT.BATTLE_EVENT.UPDATE_ROUND,handler(self,self.setRound))
end

function BattleInfoLayer:reset(data)
    self.data = data
    self.lbl_name1:setString(data.name1)
    if self.lbl_name1:getContentSize().width * self.lbl_name1:getScaleX() > 100 then
        self.lbl_name1:setScale(100 / self.lbl_name1:getContentSize().width)
    end
    local my_x,my_y = self.spr_my_elem:getPosition()
    local en_x,en_y = self.spr_enemy_elem:getPosition()

    -- local icon1 = ex.Player.battle_data:getBattleHaloIcon(data.vec_type[1])
    -- local icon2 = ex.Player.battle_data:getBattleHaloIcon(data.vec_type[2])
    local vec_idx1, vec_attr1, icon1 = ex.Player.battle_data:getBattleHalo(data.vec_type[1])
    local vec_idx2, vec_attr2, icon2 = ex.Player.battle_data:getBattleHalo(data.vec_type[2])

    local btn_my = cpp.UIMenuItemImage:createWithSpriteFrameName(string.format("hero-icon/elem-%d.png", icon1), nil, nil)
    btn_my:setScale(self.spr_my_elem:getScale())
    btn_my:setTag(1)
    btn_my:registerScriptTapHandler(handler(self, self.onShowInfo))
    local btn_enemy = cpp.UIMenuItemImage:createWithSpriteFrameName(string.format("hero-icon/elem-%d.png", icon2), nil, nil)
    btn_my:setScale(self.spr_enemy_elem:getScale())
    btn_enemy:setTag(2)
    btn_enemy:registerScriptTapHandler(handler(self, self.onShowInfo))
    self.menu:addChild(btn_my)
    self.menu:addChild(btn_enemy)
    btn_my:setPosition(my_x,my_y)
    btn_enemy:setPosition(en_x,en_y)

    self.lbl_name2:setString(data.name2)
    if self.lbl_name2:getContentSize().width * self.lbl_name2:getScaleX() > 100 then
        self.lbl_name2:setScale(100 / self.lbl_name2:getContentSize().width)
    end

    self.spr_contract1:setVisible(self.data.contract1 > 0)
    self.spr_contract2:setVisible(self.data.contract2 > 0)

    if self.data.contract1 > 0 then
        ex.Tools:setSpriteFrame (self.spr_contract1, string.format("hero-select/spr-matrix-2-%d.png", self.data.contract1))
        -- self.lbl_name1:setPositionX(ex.p.width * 0.21)
        local i = 1
        local spr_name_bg = self["spr_name_bg"..i]
        local size = spr_name_bg:getContentSize()
        local pos = self:convertToNodeSpace(spr_name_bg:convertToWorldSpace(cc.p(size.width * 0.5 - 21, size.height * 0.5)))
        self["lbl_name"..i]:setPosition(pos)
    end

    if self.data.contract2 > 0 then
        ex.Tools:setSpriteFrame(self.spr_contract2, string.format("hero-select/spr-matrix-2-%d.png", self.data.contract2))
        local i = 2
        local spr_name_bg = self["spr_name_bg"..i]
        local size = spr_name_bg:getContentSize()
        local pos = self:convertToNodeSpace(spr_name_bg:convertToWorldSpace(cc.p(size.width * 0.5 + 21, size.height * 0.5)))
        self["lbl_name"..i]:setPosition(pos)

        -- self.lbl_name2:setPositionX(ex.p.width * 0.79)
    end
end

function BattleInfoLayer:setBattleType(battle_type)
    local config = cfg.battletype.battletype[battle_type]
    if not config then
        return
    end

    self.btn_skip:setVisible(config.skip_battle == 1)
    self.max_round = config.round_max
    self:setRound(nil, {cur_round = 1})

    if is_show_battle_ship and self.btn_skip:isVisible() == false then
        local lbl_level_txt = cc.Label:createWithTTF("GM", FONT_DEFAULT_NAME_BOLD, 36)
        lbl_level_txt:setTextColor(cc.c3b(229,226,226))
        lbl_level_txt:setPosition(self.btn_skip:getContentSize().width * 0.5, self.btn_skip:getContentSize().height * 0.65)
        lbl_level_txt:setAnchorPoint(cc.p(0.5, 0))
        lbl_level_txt:enableOutline(cc.c4b(73,73,73,255), 4)
        self.btn_skip:addChild(lbl_level_txt)
        self.btn_skip:setVisible(true)
    end
end

function BattleInfoLayer:onShowInfo(tag,pSender)
    require("src.layer.HaloCtr"):instance():openWindow(self.data.vec_type[tag])
end

function BattleInfoLayer:setRound(event, data)
    if not data then return end

    local str = string.format(ex.Tools:getLang(1535), data.cur_round, self.max_round)
    self.lbl_round:setString(str)
    self.lbl_round:setVisible(true)
    self.spr_bg:setVisible(true)
end

function BattleInfoLayer:showSpeedBtn(speed, skip)
    
    -- if speed then
        self.btn_speed:setVisible(speed == true)
    -- end

    -- if skip then
        self.btn_skip:setVisible(skip == true)
    -- end
end

function BattleInfoLayer:setSpeedHandler(func)
    self.btn_speed:registerScriptTapHandler(func)
end

function BattleInfoLayer:setSkipHandler(func)
    self.btn_skip:registerScriptTapHandler(func)
end

function BattleInfoLayer:setCloseHandler(func)
    self.btn_close:registerScriptTapHandler(func)
end

function BattleInfoLayer:showCloseBtn(v) 
    self.btn_close:setVisible(v)
    self.btn_close:setPositionY(ex.p.height - 400)
end

return BattleInfoLayer
