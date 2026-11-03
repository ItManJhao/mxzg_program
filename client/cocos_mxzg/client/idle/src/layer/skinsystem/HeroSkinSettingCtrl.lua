--[[
    func: 英雄皮肤设置界面
    author:徐东浩
    time:2020-03-20 16:46:12
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local HeroSkinSettingCtrl = class("HeroSkinSettingCtrl", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroSkinSettingLayer = class("HeroSkinSettingLayer", require("src.comp.EventLayer"))
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

function HeroSkinSettingLayer:onCreate()
    self:addBlackBackground()

    self.change_callback = nil              -- 更换皮肤回调
    self.get_fashion_data_callback = nil    -- 获取皮肤数据回调
    self.is_fashion_active_callback = nil   -- 获取皮肤是否激活的回调

    self:setScale(ex.s.global_scale)
    if not ex.Player.hero_data:isOpenHeroSkinShop(true) then 
        ex.Tools:setGrayAuto(self.btn_skin_shop:getNormalImage(), true)
    end
    self.menu_fashion = cpp.UIMenu:create()
    self.menu_fashion:setPosition(0, self.scroll_view:getViewSize().height / 2)
    self.menu_fashion:setIsTouchInsideNode(self.scroll_view)
    self.menu_fashion:setSwallowsTouches(false)
    self.scroll_view:addChild(self.menu_fashion)
end

function HeroSkinSettingLayer:refreshShowGirl(hero_type, level, star, fashion_id)
    self.node_animator:removeAllChildren()

    if fashion_id == 0 then
        local skin = ex.Tools:getHeroSkinByStar(hero_type, star)
        self.animator = require("src.person.Hero"):create("1", "1", hero_type, level, star, skin)
    else
        self.animator = require("src.person.Hero"):create("1", "1", 1, 1, 1, fashion_id)
    end
    self.animator:setAnimation(0, "stand", true);
    self.animator:setScale(1.8)
    self.animator:setPosition(cc.p(0, 80))
    self.animator:setShadowVisible(false)
    self.node_animator:addChild(self.animator, 10)
end

function HeroSkinSettingLayer:refreshFashionBar(hero_data, configs, wear_id, select_id)
    self.menu_fashion:removeAllChildren()

    local item_size, space_x, scale, margin_x = nil, 10, 0.8, 16
    for i,v in ipairs(configs) do
        local item = UIMenuItemHero:createWithData(hero_data.hero_id, hero_data.hero_type, hero_data.elem, hero_data.level, hero_data.star)
        if v.fashion_id ~= 0 then   -- 有皮肤
            item:setFashionShowForce(v.fashion_id)
        else
            item:setFashionShow(false)
        end
        item._fashion_id = v.fashion_id
        item:setScale(scale)
        item:registerScriptTapHandler(handler(self, self.onClickHero))

        --add 熊梦 英雄皮肤界面的皮肤红点是否显示
        if self:HeroskinShowRed(item._fashion_id) then
            ex.Tools:addRedPoint(item, true, cc.p(1, 0.95))
        end
        
        if not item_size then 
            item_size = item:getContentSize()
            item_size.width = item_size.width * scale
            item_size.height = item_size.height * scale
        end

        item:setPosition(cc.p((i - 0.5) * item_size.width + (i - 1) * space_x + margin_x, 0))
        self.menu_fashion:addChild(item)

        -- 增加使用中标志
        local spr_using = cc.Sprite:createWithSpriteFrameName("hero-info-lang/spr-using.png")
        spr_using:setPosition(14, item:getContentSize().height - 10)
        spr_using:setName("spr-using")
        item:addChild(spr_using, 1000)
        spr_using:setVisible(v.fashion_id == wear_id)

        local spr_select = cc.Sprite:createWithSpriteFrameName("backpack/spr-select.png")
        spr_select:setPosition(item:getContentSize().width / 2 ,item:getContentSize().height / 2)
        spr_select:setScale(0.96)
        spr_select:setName("spr-select")
		item:addChild(spr_select, 900)
		spr_select:setVisible(v.fashion_id == select_id)

        if v.fashion_id ~= 0 and not self.is_fashion_active_callback(v.fashion_id) then
            -- 未激活，则置灰
            -- ex.Tools:setAllGrayAuto(item, true)
            item:setAllGray(true)
        end
    end

    self.scroll_view:setContentSize(cc.size(math.min(self.scroll_view:getViewSize().width, #configs * item_size.width + (#configs - 1) * space_x + 2 * margin_x), self.scroll_view:getViewSize().height))
    self.scroll_view:setContentOffset(self.scroll_view:maxContainerOffset())
end

-- add 熊梦 英雄皮肤按钮是否显示红点
function HeroSkinSettingLayer:HeroskinShowRed(fashion_id)
    local fashion_info = self.get_fashion_data_callback(fashion_id)
    local is_active_show = not fashion_info.is_default and not fashion_info.is_active
    if is_active_show and fashion_info.is_actionable then
        return true
    end

    local is_upgrade_show = not fashion_info.is_default and fashion_info.is_active and fashion_info.data.status == 0 and fashion_info.up_config.level < fashion_info.max_level 
    if is_upgrade_show and fashion_info.is_upgrade then
        return true
    end
    return false
end

function HeroSkinSettingLayer:refreshAttrAndBtn(fashion_id)
    local fashion_info = self.get_fashion_data_callback(fashion_id)

    self.node_attr:setVisible(not fashion_info.is_default)
    self.node_default:setVisible(fashion_info.is_default)

    if fashion_info.is_default then
        self.lbl_skin_name:setString(fashion_info.hero_name)

        self.node_skill_extra:setVisible(false)
    else
        self.lbl_skin_name:setString(ex.Tools:getLang(fashion_info.config.fashion_name))

        if fashion_info.is_active then
            -- 激活
            if fashion_info.data.status == 0 then
                self.lbl_skin_time:setString(ex.Tools:getLang(3802))
            else
                local remain_time = fashion_info.data.end_time - ex.Game:getServerTime()
                if remain_time > 0 and remain_time < 60 then
                    remain_time = 60
                end
                self.lbl_skin_time:setString(ex.Tools:formatTime4(remain_time))
            end

            self.lbl_skin_level:setString(string.format("%d/%d", fashion_info.data.level, fashion_info.max_level))
        else
            -- 未激活
            self.lbl_skin_time:setString(ex.Tools:getLang(3813))
            self.lbl_skin_level:setString(string.format("%d/%d", 0, fashion_info.max_level))
        end

        self:_setAddition(self.lbl_attr_1, self.lbl_attr_extra_1, fashion_info.up_config, fashion_info.next_up_config, 1)
        self:_setAddition(self.lbl_attr_2, self.lbl_attr_extra_2, fashion_info.up_config, fashion_info.next_up_config, 2)
        self:_setAddition(self.lbl_attr_3, self.lbl_attr_extra_3, fashion_info.up_config, fashion_info.next_up_config, 3)
        self:_setAddition(self.lbl_attr_4, self.lbl_attr_extra_4, fashion_info.up_config, fashion_info.next_up_config, 4)

        if fashion_info.config.skill == nil or fashion_info.config.skill == "" or fashion_info.config.skill <= 0 then
            self.node_skill_extra:setVisible(false)
        else
            self.node_skill_extra:setVisible(true)

            local str_skill_name =  ex.Player.hero_data:getSkillName(fashion_info.config.skill, fashion_info.config.skill_level)
            self.lbl_skill_name:setString(str_skill_name)
            ex.Tools:setSpriteFrame(self.spr_skill_icon, "skill-icon/"..(fashion_info.config.skill + fashion_info.config.skill_level - 1)..".png")
            self.btn_skill_info:setContentSize(self.spr_skill_icon:getContentSize())
            self.btn_skill_info:registerScriptTapHandler(handler(self, self.onSkillInfo))
            self.btn_skill_info.skill_type = fashion_info.config.skill
            self.btn_skill_info.skill_level = fashion_info.config.skill_level
            if fashion_info.is_active then
                self.spr_skill_mask:setVisible(false)
                self.lbl_skill_unlock_tip:setVisible(false)
            else
                self.spr_skill_mask:setVisible(true)
                self.lbl_skill_unlock_tip:setVisible(true)
            end
        end
    end

    self.btn_max_preview:setVisible(not fashion_info.is_default)
    local is_wear_show = fashion_info.is_default or fashion_info.is_active
    self.btn_wear:setVisible(is_wear_show)
    local is_active_show = not fashion_info.is_default and not fashion_info.is_active
    self.btn_active:setVisible(is_active_show)
    local is_upgrade_show = not fashion_info.is_default and fashion_info.is_active and fashion_info.data.status == 0 and fashion_info.up_config.level < fashion_info.max_level
    self.btn_upgrade:setVisible(is_upgrade_show)
    self.node_need:setVisible(is_upgrade_show)

    if is_active_show then
        self.btn_active:setEnabled(fashion_info.is_actionable)
        ex.Tools:setGrayAuto(self.btn_active:getNormalImage(), not fashion_info.is_actionable)
        ex.Tools:addRedPoint(self.btn_active, fashion_info.is_actionable, ex.r.p1_9)

        if fashion_info.is_actionable then
            self.btn_active:setLabelColor(FONT_WHITLE)
            self.btn_active:setLabelOutLine(FONT_BTN_OUTLINE_GREEN, 4)
        else
            self.btn_active:setLabelColor(FONT_WHITE_2_GRAY)
            self.btn_active:setLabelOutLine(FONT_OUTLINE_2_GRAY, 4)
        end
    end
    if is_upgrade_show then
        self.btn_upgrade:setEnabled(fashion_info.is_upgrade)
        ex.Tools:setGrayAuto(self.btn_upgrade:getNormalImage(), not fashion_info.is_upgrade)
        ex.Tools:addRedPoint(self.btn_upgrade, fashion_info.is_upgrade, ex.r.p1_9)

        if fashion_info.is_upgrade then
            self.btn_upgrade:setLabelColor(FONT_WHITLE)
            self.btn_upgrade:setLabelOutLine(FONT_BTN_OUTLINE_ZI, 4)
        else
            self.btn_upgrade:setLabelColor(FONT_WHITE_2_GRAY)
            self.btn_upgrade:setLabelOutLine(FONT_OUTLINE_2_GRAY, 4)
        end

        ex.Tools:setSpriteFrame(self.spr_need_res, string.format("backpack/%d.png", fashion_info.up_config.need_item[1].item_type))
        
        self.lbl_need_res:setString(string.format("%d/%d", ex.Player:getItemNum(fashion_info.up_config.need_item[1].item_type), fashion_info.up_config.need_item[1].item_num))
    end

    if is_wear_show and not is_activi_show and not is_upgrade_show then
        self.btn_wear:setPositionX(self.menu:getContentSize().width / 2)
    else
        self.btn_wear:setPositionX(182)
    end
end

function HeroSkinSettingLayer:onSkillInfo(tag, pSender)
    require("src.layer.HeroSkillInfoCtr"):instance():openWindow(pSender.skill_type, pSender.skill_level, -1)
end

function HeroSkinSettingLayer:_setAddition(label, label_extra, config, next_config, ability_idx)
    local cur_value = clone(cfg.herofashionup.getAddition(config.fashion_id, config.level, ability_idx))
    local next_value = clone(cfg.herofashionup.getAddition(config.fashion_id, next_config.level, ability_idx))
    local str_value_cur = cur_value.value
    local str_value_next = next_value.value - cur_value.value
    if cur_value.attr ~= AbilityType.AT_SPEED_BASE then
        str_value_cur = (cur_value.value / 100).."%"
        str_value_next = ((next_value.value - cur_value.value) / 100).."%"
    end
    if next_value.value > cur_value.value then
        label_extra:setVisible(true)
        label:setString(ex.Tools:getLang(122000 + cur_value.attr)..": +"..str_value_cur)
        label_extra:setPositionX(label:getPositionX() + label:getContentSize().width * label:getScaleX())
        label_extra:setString("+"..str_value_next)
    else
        label_extra:setVisible(false)
        label:setString(ex.Tools:getLang(122000 + cur_value.attr)..": +"..str_value_cur)
    end
end

function HeroSkinSettingLayer:onClickHero(tag, pSender)
    self.change_callback(pSender._fashion_id)
end

function HeroSkinSettingLayer:setSelectedFashionBtn(fashion_id)
    local children = self.menu_fashion:getChildren()
    for k, v in pairs(children) do
        local spr_select = v:getChildByName("spr-select")
        spr_select:setVisible(v._fashion_id == fashion_id)
    end
end

function HeroSkinSettingLayer:setUsingFashionBtn(fashion_id)
    local children = self.menu_fashion:getChildren()
    for k, v in pairs(children) do
        local spr_using = v:getChildByName("spr-using")
        spr_using:setVisible(v._fashion_id == fashion_id)
    end
end


-----------------------------------------------------------------------------
function HeroSkinSettingCtrl:onCreate()
    self:setCCBIPath("ccbi/HeroSkinSettingLayer.ccbi")
    
    self:setIsSingle(false)

    self.hero_data = {}
    self.cur_fashion_id = 0
    self.cur_select_id = 0
    self.fashion_configs = {}
    -- self.hero_ability = {}
end

function HeroSkinSettingCtrl:openWindow(hero_id)
	if self:isOpened() then
		return
    end
    
    self.hero_data = ex.Player.hero_data:getHeroDataById(hero_id)
    self.fashion_configs = cfg.herofashion.getConfigsByHeroType(self.hero_data.hero_type)
    table.insert(self.fashion_configs, 1, {fashion_id = 0})     -- 增加一个默认形象
    -- self.hero_ability = require("src.data.HeroAbilityData"):getAbilityData(self.hero_data.hero_type, self.hero_data.stage, self.hero_data.star, self.hero_data.level)

	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/hero-info.plist")
    sfc:addSpriteFrames("ccbi-res/hero-info-lang.plist")

    self:refreshData(hero_id)
    
	self:loadLayer()
    self:open()

	self:init()
end

function HeroSkinSettingCtrl:getLayerClass()
	return HeroSkinSettingLayer
end

function HeroSkinSettingCtrl:closeWindow()
    self:close(self.layer)
end

function HeroSkinSettingCtrl:init()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_max_preview:registerScriptTapHandler(handler(self, self.onMaxPreview))
    self.layer.btn_wear:registerScriptTapHandler(handler(self, self.onWear))
    self.layer.btn_upgrade:registerScriptTapHandler(handler(self, self.onUpgrade))
    self.layer.btn_active:registerScriptTapHandler(handler(self, self.onActive))
    self.layer.btn_skin_shop:registerScriptTapHandler(handler(self, self.goSkinShop))

    self.layer.change_callback = handler(self, self.onChangeFashion)
    self.layer.get_fashion_data_callback = handler(self, self.getFashionData)
    self.layer.is_fashion_active_callback = handler(ex.Player.hero_data.fashion, ex.Player.hero_data.fashion.isActive)
    
    self.layer:addEvent(EVENT.FASHION_SETTING.DATA_DIRTY, handler(self, self.eventDataDirty))
    self.layer:addEvent(EVENT.FASHION_SETTING.WEAR, handler(self, self.eventWearFashion))
    self.layer:addEvent(EVENT.FASHION_SETTING.UPGRADE, handler(self, self.eventUpgradeFashion))
    -- self.layer:addEvent(EVENT.HERO_INFO_EVENT.HERO_FIGHTING_CHANGE, handler(self, self.eventPowerChange))
    
    -- 默认选中已穿戴
    self.cur_select_id = self.cur_fashion_id

	self:updateLayer()
end

function HeroSkinSettingCtrl:refreshData(hero_id)
    self.cur_fashion_id = ex.Player.hero_data.fashion:getWearByID(hero_id) or 0
end

function HeroSkinSettingCtrl:updateLayer()
    self.layer:refreshShowGirl(self.hero_data.hero_type, self.hero_data.level, self.hero_data.star, self.cur_select_id)

    self.layer:refreshAttrAndBtn(self.cur_select_id)

    self.layer:refreshFashionBar(self.hero_data, self.fashion_configs, self.cur_fashion_id, self.cur_select_id)
end

function HeroSkinSettingCtrl:getFashionData(fashion_id)
    local fashion_info = {}

    if fashion_id == 0 then     -- 原始形象
        fashion_info.is_default = true
        fashion_info.hero_name = ex.Tools:getLang(self.hero_data.hero_type)
    else
        fashion_info.is_default = false
        fashion_info.data = ex.Player.hero_data.fashion:getFashionDataByID(fashion_id)
        fashion_info.is_active = ex.Player.hero_data.fashion:isActive(fashion_id)
        
        fashion_info.config = cfg.herofashion.getConfigByType(fashion_id)

        local max_config = cfg.herofashionup.getMaxConfigByType(fashion_id)
        fashion_info.max_level = max_config.level

        local level = fashion_info.is_active and fashion_info.data.level or 0

        fashion_info.up_config = cfg.herofashionup.getConfigByTypeAndLevel(fashion_id, math.max(0, math.min(fashion_info.max_level, level)))
        fashion_info.next_up_config = cfg.herofashionup.getConfigByTypeAndLevel(fashion_id, math.max(0, math.min(fashion_info.max_level, level + 1)))

        if fashion_info.is_active then
            -- 激活皮肤
            -- fashion_info.attr = {}
            -- fashion_info.attr.hp = self.hero_ability:getHp()
            -- fashion_info.attr.attack = self.hero_ability:getAtk()
            -- fashion_info.attr.defense = self.hero_ability:getDef()
            -- fashion_info.attr.speed = self.hero_ability:getSpd()
            fashion_info.is_upgrade = ex.Player.hero_data.fashion:isCanUpgrade(fashion_id, level)
        else
            -- 未激活
            fashion_info.is_actionable = ex.Player.hero_data.fashion:isActionable(fashion_id)
        end
    end

    return fashion_info
end

--------------------------响应处理--------------------------
function HeroSkinSettingCtrl:onChangeFashion(fashion_id)
    if self.cur_select_id == fashion_id then return end

    self.cur_select_id = fashion_id

    self.layer:setSelectedFashionBtn(self.cur_select_id)

    self.layer:refreshShowGirl(self.hero_data.hero_type, self.hero_data.level, self.hero_data.star, self.cur_select_id)

    self.layer:refreshAttrAndBtn(self.cur_select_id)
end

function HeroSkinSettingCtrl:onMaxPreview(tap, pSender)
    require("src.layer.skinsystem.HeroMaxSkinCtr"):instance():openWindow(self.cur_select_id)
end

function HeroSkinSettingCtrl:onWear(tap, pSender)
    if self.cur_fashion_id == self.cur_select_id then
        ex.MessageView:add(ex.Tools:getLang(3815))
        return
    end

    -- self.ori_fighting = self.hero_data.fighting
    if self.cur_select_id ~= 0 and not ex.Player.hero_data.fashion:isActive(self.cur_select_id) then
        ex.MessageView:add(ex.Tools:getLang(3821))
        return
    end

    local req = HeroFashion_pb.GReqHeroFashionChange()
    req.hero_id = self.hero_data.hero_id
    req.fashion_id = self.cur_select_id
    NetManager:sendMessage(ProtocolID.GReqHeroFashionChange, req)
end

function HeroSkinSettingCtrl:onUpgrade(tap, pSender)
    local data = ex.Player.hero_data.fashion:getFashionDataByID(self.cur_select_id)
    if not data then
        printError("Fashion id:%d not data!", self.cur_select_id)
        return
    end

    if ex.Player.hero_data.fashion:isCanUpgrade(self.cur_select_id, data.level, true) then
        local req = HeroFashion_pb.GReqHeroFashionUp()
        req.fashion_id = self.cur_select_id
        NetManager:sendMessage(ProtocolID.GReqHeroFashionUp, req)
    end
end

function HeroSkinSettingCtrl:onActive(tap, pSender)
    if not ex.Player.hero_data.fashion:isActionable(self.cur_select_id, true) then return end

    local item_type = ex.Player.hero_data.fashion:getItemTypeForActiveFashion(self.cur_select_id)

    if item_type then
        local req = HeroFashion_pb.GReqActiveHeroFashion()
        req.item_type = item_type
        NetManager:sendMessage(ProtocolID.GReqActiveHeroFashion, req)
    end
end

--------------------------事件处理--------------------------
function HeroSkinSettingCtrl:eventDataDirty()
    self.layer:refreshAttrAndBtn(self.cur_select_id)

    self.layer:refreshFashionBar(self.hero_data, self.fashion_configs, self.cur_fashion_id, self.cur_select_id)
end

function HeroSkinSettingCtrl:eventWearFashion()
    self:refreshData(self.hero_data.hero_id)

    self.layer:setUsingFashionBtn(self.cur_fashion_id)
end

function HeroSkinSettingCtrl:eventPowerChange(evt, new_fighting)
    ex.EventManager:fire(EVENT.HERO_INFO_EVENT.HERO_ATTACKUP, self.ori_fighting, new_fighting - self.ori_fighting, new_fighting)
end

function HeroSkinSettingCtrl:eventUpgradeFashion()
    self.layer:refreshAttrAndBtn(self.cur_select_id)
    -- add 熊梦 升级成功后 刷新红点的状态
    local item_list = self.layer.menu_fashion:getChildren()
    for i,item in pairs(item_list) do
        --add 熊梦 英雄皮肤界面的皮肤红点是否显示
        ex.Tools:addRedPoint(item, false, cc.p(1, 0.95))
        if self.layer:HeroskinShowRed(item._fashion_id) then
            ex.Tools:addRedPoint(item, true, cc.p(1, 0.95))
        end
    end
     
end

function HeroSkinSettingCtrl:goSkinShop()
    if ex.Player.hero_data:isOpenHeroSkinShop() then
        self:closeWindow()
        NetManager:sendMessage(ProtocolID.GReqHeroSkinList)
        ex.MainSceneCtr:changeLayer(MainSceneType.HERO_SKIN_SHOP)
        
   end 
    
end

return HeroSkinSettingCtrl
