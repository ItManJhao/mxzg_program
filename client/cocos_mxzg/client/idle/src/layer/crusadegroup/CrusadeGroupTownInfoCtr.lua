--[[
    讨伐团城镇信息界面
    在讨伐团城镇列表界面调用
]]

local CrusadeGroupTownInfoCtr = class("CrusadeGroupTownInfoCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local CrusadeGroupTownInfoLayer = class("CrusadeGroupTownInfoLayer", require("src.comp.EventLayerAdaptiveWidth"))

local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

-----------------------------------------------------------------------------
function CrusadeGroupTownInfoLayer:onCreate()
    self:addBlackBackground()
    self:setAutoClose(true)
    self:setSwallowTouches(true)

    self.scroll_view:setItemSize(cc.size(120, 150))
    self.scroll_view:setItemOffset(cc.p(0, 5))
    -- self.scroll_view:setAutoFull(true)
    self.scroll_view:setCreateNum(4)
end

function CrusadeGroupTownInfoLayer:setTownInfo(name_lang, element, star, rare_lang, speed, markon)
    self.lbl_title:setString(ex.Tools:getLang(name_lang))

    ex.Tools:setSpriteFrame(self.spr_elem, "hero-icon/elem-"..element..".png")
    self.lbl_star:setString(star)

    self.lbl_des_1:setString(string.format(ex.Tools:getLang(77740), ex.Tools:getLang(rare_lang)))
    ex.Tools:setLimitWidth(self.lbl_des_1, 320)
    self.lbl_des_2:setString(string.format(ex.Tools:getLang(77741), speed * 10))
    self.lbl_des_3:setString(string.format(ex.Tools:getLang(77742), ex.Tools:getLang(2115 + element), star, markon))
end

function CrusadeGroupTownInfoLayer:setMarkonTipColor(has_hero)
    self.lbl_des_1:setColor(cc.c3b(100,66,38))
    self.lbl_des_2:setColor(cc.c3b(100,66,38))
    self.lbl_des_3:setColor(has_hero and cc.c3b(23,148,61) or cc.c3b(100,66,38))
end

function CrusadeGroupTownInfoLayer:setHeroList(vec_hero_list, select_hero_id, handler)
    self.scroll_view.createItemFunction = function(item_data, scale, index, pos)
        local item = UIMenuItemHero:createWithData(item_data.hero.hero_id, item_data.hero.hero_type, nil, item_data.hero.level, item_data.hero.star)
        item:setScale(scale)
        item:registerScriptTapHandler(handler)

        if select_hero_id == item_data.hero.hero_id then
            item:setSelected(true)
        end

        if item_data.is_use then
            item:setGray(false)

            local lbl_use = cc.Label:createWithTTF(ex.Tools:getLang(77746), FONT_DEFAULT_NAME_BOLD, 36)
            lbl_use:setScale(0.5)
            lbl_use:setColor(cc.c3b(171,224,58))
            lbl_use:setPosition(item:getContentSize().width / 2, item:getContentSize().height / 2)
            item:addChild(lbl_use, 100)

            item:setAllGray(true)
        end

        local spr_block = cc.Sprite:createWithSpriteFrameName("crusade-group/block-bg-8.png") or cc.Sprite:create()
        spr_block:setPosition(item:getContentSize().width / 2, -20)
        item:addChild(spr_block, 10)

        local lbl_town_level = cc.Label:createWithTTF(item_data.town_level >= 0 and (RomanNumber[item_data.town_level] or RomanNumber[1]) or ex.Tools:getLang(2002), FONT_DEFAULT_NAME_BOLD, 36)
        lbl_town_level:setScale(0.5)
        lbl_town_level:setColor(FONT_LIGHT_YELLOW)
        lbl_town_level:setPosition(spr_block:getPosition())
        item:addChild(lbl_town_level, 20)

        return item
    end
    self.scroll_view:reloadData(vec_hero_list)
end

function CrusadeGroupTownInfoLayer:setHeroSelected(select_hero_id, vec_hero_list)
    local vec_children = self.scroll_view.menu:getChildren()
    for _,item in ipairs(vec_children) do
        item:setSelected(item.hero_id == select_hero_id)
    end

    if self.item_selected ~= nil then
        self.item_selected:removeFromParent()
        self.item_selected = nil
    end

    self.spr_add:setVisible(select_hero_id <= 0)
    if select_hero_id > 0 then
        local item_data = nil 

        for i,v in ipairs(vec_hero_list) do
            if v.hero.hero_id == select_hero_id then
                item_data = v
                break
            end
        end

        if item_data ~= nil then
            self.item_selected = UIMenuItemHero:createWithData(item_data.hero.hero_id, item_data.hero.hero_type, nil, item_data.hero.level, item_data.hero.star)
            self.item_selected:setScale(1)
            self.item_selected:setPosition(0, 105)
            self.node_hero_selected:addChild(self.item_selected)
        end
    end
end

-----------------------------------------------------------------------------
function CrusadeGroupTownInfoCtr:onCreate()
    self:setCCBIPath("ccbi/CrusadeGroupTownInfoLayer.ccbi")
    self:setIsSingle(false)
end

function CrusadeGroupTownInfoCtr:getLayerClass()
    return CrusadeGroupTownInfoLayer
end

function CrusadeGroupTownInfoCtr:openWindow(town_id)
    if self:isOpened() then
        return
    end
    
    self.town_data = ctr.crusade_group.data:getTownData(town_id)
    if self.town_data == nil then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/crusade-group.plist")

    self:loadLayer()
    self:open()
    self:initData()
end

function CrusadeGroupTownInfoCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))

    -- 默认选中当前已选中英雄id，如果小于0则未选中英雄
    self.select_id = self.town_data.hero_id or 0

    self:updateLayer()
end

function CrusadeGroupTownInfoCtr:updateLayer()
    self.vec_hero_list = {}
    local area_level = cfg.crusadegrouptilelevel.getAreaLevel(self.town_data.id)
    local building_level = cfg.crusadegrouptilelevel.getBuildingLevel(self.town_data.id)

    local config_build = cfg.crusadegroupbuild.getConfig(self.town_data.id)
    local elem = self.town_data.element
    local star = config_build.defend_star

    for _,hero_data in ipairs(ctr.crusade_group.data.game_data.set_off_hero_list) do
        if cfg.herotype.star[hero_data.hero.hero_type].elem == elem and hero_data.hero.star >= star then
            local tmp_data = clone(hero_data)
            tmp_data.is_use = false
            tmp_data.town_level = -1
            for _,town_data in ipairs(ctr.crusade_group.data.game_data.occupied_list) do
                if town_data.hero_id == tmp_data.hero.hero_id then
                    if town_data.id ~= self.town_data.id then
                        tmp_data.is_use = true
                        tmp_data.town_level = cfg.crusadegrouptilelevel.getBuildingLevel(town_data.id)
                    end
                    break
                end
            end
            table.insert(self.vec_hero_list, tmp_data)
        end
    end

    local markon = tonumber(ex.Tools:getSysCfg("production_increase_ratio")) * 100 - 100

    self.layer:setTownInfo(config_build.name, elem, star, config_build.shenbing_des, config_build.cream_output, markon)
    self.layer:setMarkonTipColor(self.select_id > 0)
    self.layer:setHeroList(self.vec_hero_list, self.select_id, handler(self, self.onSelect))
    self.layer:setHeroSelected(self.select_id, self.vec_hero_list)
end

-- 英雄选中
function CrusadeGroupTownInfoCtr:onSelect(tag, pSender)
    -- 如果是未选中英雄id，则选中该英雄，否则取消选中
    if self.select_id == pSender.hero_id then
        self.select_id = 0
    else
        self.select_id = pSender.hero_id
    end

    self.layer:setHeroSelected(self.select_id, self.vec_hero_list)
    self.layer:setMarkonTipColor(self.select_id > 0)
end

-- 确定
function CrusadeGroupTownInfoCtr:onConfirm(tag, pSender)
    -- 如果开垦英雄改变则发送协议
    local select_id = self.town_data.hero_id or 0
    if select_id ~= self.select_id then
        if self.select_id > 0 then
            local req = CrusadeGroup_pb.GReqDevelopment()
            req.territory_id = self.town_data.id
            req.hero_id = self.select_id
            NetManager:sendMessage(ProtocolID.GReqDevelopment, req)
        else
            local req = CrusadeGroup_pb.GReqCancelDevelopment()
            req.territory_id = self.town_data.id
            NetManager:sendMessage(ProtocolID.GReqCancelDevelopment, req)
        end
    end

    self:closeWindow()
end

return CrusadeGroupTownInfoCtr