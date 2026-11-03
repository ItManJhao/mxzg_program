local ClanGvgBattleInfoCtr = class("ClanGvgBattleInfoCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ClanGvgBattleInfoLayer = class("ClanGvgBattleInfoLayer", require("src.comp.LuaLayerBase"))

local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

function ClanGvgBattleInfoLayer:onCreate()
    self:addBlackBackground()

end

function ClanGvgBattleInfoLayer:initData(data)
    self.menu_role_1:removeAllChildren()
    self.menu_role_2:removeAllChildren()

    -- 执行音效
    ex.AudioManager:playEffect("music/audio-ready.mp3")

    -- 上下两个阵容节点做上下移动动作
    self.node_role_1:setPosition(300, 90)
    self.node_role_2:setPosition(300, 314)

    self.node_role_1:runAction(cc.Sequence:create(cc.MoveTo:create(0.2, cc.p(300, -50)), cc.MoveTo:create(0.15, cc.p(300, 0)), nil))
    self.node_role_2:runAction(cc.Sequence:create(cc.MoveTo:create(0.2, cc.p(300, 454)), cc.MoveTo:create(0.15, cc.p(300, 404)), nil))

    -- 显示特效
    self.spr_magic:setScale(0.1)
    self.spr_magic:setOpacity(0)
    self:reorderChild(self.spr_magic, 100)
    self.spr_magic:stopAllActions()
    self.spr_magic:runAction(cc.RepeatForever:create(cc.RotateBy:create(10, 360)))

    self.spr_magic:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.FadeIn:create(0.2), nil))
    self.spr_magic:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.ScaleTo:create(0.2, 1), nil))

    self:reorderChild(self.spr_vs, 100)
    self.spr_vs:runAction(ex.EffectFactory:createEffectByName("eff_clan_gvg_vs"))

    -- 显示英雄
    for i,v in ipairs(data.players) do
        if v.clan_id ~= ex.Player.clan_data.clan_id then
            self.lbl_name_1:setString(v.name)
            self.lbl_attack_1:setString(tostring(v.fighting))

            local index = 1
            for i2,v2 in ipairs(v.heros) do
                if v2.hero_type > 0 then
                    local item = UIMenuItemHero:createWithData("1", v2.hero_type, cfg.herotype.star[v2.hero_type].elem, v2.level, v2.star)
                    if v2.fashion_id ~= 0 and v2.fashion_id ~= nil then   -- 有皮肤
                        item:setFashionShowForce(v2.fashion_id)
                    end
                    item:setScale(0.8)
                    item:setPosition((index - 0.5) * (item:getContentSize().width * item:getScaleX() + 5) + 10, 55)
                    self.menu_role_1:addChild(item)

                    if v2.alive > 0 then
                        local spr_die = cc.Sprite:createWithSpriteFrameName("other/lbl-dead.png")
                        spr_die:setPosition(item:getContentSize().width / 2, item:getContentSize().height / 2)
                        spr_die:setLocalZOrder(100)
                        item:addChild(spr_die)
                        if item.spr_hero_icon then
                            item.spr_hero_icon:setColor(FONT_GRAY)
                        end
                        
                        item:setEnabled(false)
                    end
                    
                    index = index + 1
                end
            end
        else
            self.lbl_name_2:setString(v.name)
            self.lbl_attack_2:setString(tostring(v.fighting))

            local index = 1
            for i2,v2 in ipairs(v.heros) do
                if v2.hero_type > 0 then
                    local item = UIMenuItemHero:createWithData("1", v2.hero_type, cfg.herotype.star[v2.hero_type].elem, v2.level, v2.star)
                    if v2.fashion_id ~= 0 and v2.fashion_id ~= nil then   -- 有皮肤
                        item:setFashionShowForce(v2.fashion_id)
                    end
                    item:setScale(0.8)
                    item:setPosition((index - 0.5) * (item:getContentSize().width * item:getScaleX() + 5) + 10, 55)
                    self.menu_role_2:addChild(item)

                    if v2.alive > 0 then
                        local spr_die = cc.Sprite:createWithSpriteFrameName("other/lbl-dead.png")
                        spr_die:setPosition(item:getContentSize().width / 2, item:getContentSize().height / 2)
                        spr_die:setLocalZOrder(100)
                        item:addChild(spr_die)
                        if item.spr_hero_icon then
                            item.spr_hero_icon:setColor(FONT_GRAY)
                        end
                        
                        item:setEnabled(false)
                    end
                    
                    index = index + 1
                end
            end
        end
    end
end

-----------------------------------------------------------------------------
function ClanGvgBattleInfoCtr:onCreate()
	self:setCCBIPath("ccbi/ClanGvgBattleInfoLayer.ccbi")
	self:setIsSingle(false)
end

function ClanGvgBattleInfoCtr:getLayerClass()
	return ClanGvgBattleInfoLayer
end

function ClanGvgBattleInfoCtr:getClanGvgBattleInfoLayer()
	return self.layer
end

function ClanGvgBattleInfoCtr:openWindow(data)
	if self:isOpened() then
		return
	end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/clan-gvg.plist")
    sfc:addSpriteFrames("ccbi-res/clan-gvg-lang.plist")

	self:loadLayer()
	self:open()
	self:initData(data)
end

function ClanGvgBattleInfoCtr:initData(data)
    self.layer.btn_report:registerScriptTapHandler(handler(self, self.onReport))

    self.data = data

    self:updateLayer()
end

function ClanGvgBattleInfoCtr:updateLayer()
    if not self:getLayer() then
        return
    end

    self.layer:initData(self.data)
end

-- 点击战报回放按钮回调
function ClanGvgBattleInfoCtr:onReport(tag, pSender)
    if self.data == nil or self.data.battle_id == nil then
        return
    end

    self:onBattle(self.data.battle_id)
end

-- 播放战报
function ClanGvgBattleInfoCtr:onBattle(battle_id)
    ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_GVG_ON_BATTLE, battle_id)

    self:closeWindow(0, nil)

    local history_ctr = require("src.layer.clan.ClanGvgHistoryCtr"):instance()
    if history_ctr.layer ~= nil then
        history_ctr:closeWindow(0, nil)
    end
end

return ClanGvgBattleInfoCtr
