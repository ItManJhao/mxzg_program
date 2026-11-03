local CrusadeGroupMainLayer = class("CrusadeGroupMainLayer", require("src.comp.EventLayer"))
local UISpriteCollect = require("src.comp.UISpriteCollect")

CrusadeGroupMainLayer.ctr = ctr.crusade_group

function CrusadeGroupMainLayer:onCreate()
    self.map_layer = require("src.layer.crusadegroup.map.CrusadeGroupMapLayer"):createWithCCBIFile("ccbi/CrusadeGroupMapLayer.ccbi")
    self.map_layer:setScrollViewDidScrollCallback(handler(self, self.scrollViewDidScroll))
    self:addChild(self.map_layer, -2)

    -- 添加地图缩放按钮
    self.slider_scale = require("src.comp.UISliderVertical"):create()
    self.slider_scale:setPosition(cc.p(ex.p.width - 50, ex.p.height * 0.5 - 50))
    self.slider_scale:setSliderFrame("crusade-group/spr-zoom.png")
    self.slider_scale:setSliderBgFrame("crusade-group/spr-zoom-bg.png", cc.rect(4, 10, 1, 1), cc.size(10, 260))
    self.slider_scale:setScaleCallback(handler(self, self.onMapScale))
    self.slider_scale:setOldScaleCallback(handler(self, self.getMapScale))
    self:addChild(self.slider_scale)

    -- 定位按钮
    self.btn_location:setVisible(false)
    self.spr_location:setVisible(false)

    self.btn_location:getParent():setLocalZOrder(1)
    self.spr_location:setLocalZOrder(1)

    --神兵按钮红点
    self:addRedDotNode(RedDotType.ZCJ_DHZC_TFT_SB, self.btn_weapon)
    self:addRedDotNode(RedDotType.ZCJ_DHZC_TFT_ZJ, self.btn_nobility)
    self:updateLayer()
    
    
    -- 註冊事件
    self:addEvent(EVENT.CRUSADE_GROUP.START_BATTLE, handler(self, self.startBattle))
    self:addEvent(EVENT.CRUSADE_GROUP.BATTLE_REPORT, handler(self, self.startBattle))
    self:addEvent(EVENT.CRUSADE_GROUP.UPDATE_TOWN_LIST, handler(self, self.updateLayer))
    self:addEvent(EVENT.CRUSADE_GROUP.RUN_COLLECT_EFFECT, handler(self, self.runCollectEffect))
    self:addEvent(EVENT.CRUSADE_GROUP.UPDATE_OCCUPATION, handler(self, self.updateOccupation))

    ctr.crusade_group:startGiveupTimer()

    ctr.crusade_group:requestGetInfo()
   
end

function CrusadeGroupMainLayer:scrollViewDidScroll()
     -- 显示定位的按钮
     local show_location = false
     local last_occupation_id = ctr.crusade_group.data.game_data.last_occupation_id

     if last_occupation_id ~= -1 then
         -- 判断是否是现在是屏幕上了
         local pos = self.map_layer.map:getPositionByIdx(ctr.crusade_group.data.game_data.last_occupation_id)
         local target_pos = self.map_layer.map:convertToWorldSpace(pos)

         if cc.rectContainsPoint(cc.rect(0, 0, ex.p.width, ex.p.height), target_pos) ~= true then
            local screen_mid = cc.p(ex.p.width * 0.5, ex.p.height * 0.5)

             -- 求交点。
             local begin_pos = cc.p(70, self.node_bottom:getPositionY() + 80)
             local end_pos = cc.p(ex.p.width - begin_pos.x - 160, ex.MainSceneCtr:getTopY() - begin_pos.y - 150)
             local p = Maths.lineIntersectsRect(screen_mid, target_pos, cc.rect(begin_pos.x, begin_pos.y, end_pos.x, end_pos.y))
             if p then
                show_location = true

                self.btn_location:setRotation(Maths.getRotation(screen_mid, target_pos) - 90)
                -- 计算按钮显示的位置
                self.btn_location:setPosition(p)
                self.spr_location:setPosition(cc.p(p.x + 1.5, p.y - 5))
             end
         end
     end

     self.btn_location:setVisible(show_location)
     self.spr_location:setVisible(show_location)
end

function CrusadeGroupMainLayer:getMapScale()
    return self.map_layer:getMapScale()
end

function CrusadeGroupMainLayer:onMapScale(old_scale, scale)
    self.map_layer:onMapScale(old_scale, scale)
end

-- 职级
function CrusadeGroupMainLayer:onNobility(tag, pSender)
    require("src.layer.crusadegroup.CrusadeGroupTownCtr"):instance():openWindow()
end

-- 排行榜
function CrusadeGroupMainLayer:onRank(tag, pSender)
    require("src.layer.crusadegroup.CrusadeGroupRankCtr"):instance():openWindow()
end

-- 讨伐团
function CrusadeGroupMainLayer:onGroup(tag, pSender)
    require("src.layer.crusadegroup.CrusadeGroupMemberCtr"):instance():openWindow()
end

-- 英雄
function CrusadeGroupMainLayer:onHeroList(tag, pSender)
    if not self.setoff_layer then
        self.setoff_layer = require("src.layer.crusadegroup.CrusadeGroupSetOffLayer"):createWithCCBIFile("ccbi/CrusadeGroupSetOffLayer.ccbi")
        self.setoff_layer:setPositionY(-self.setoff_layer:getContentSize().height)
        self:addChild(self.setoff_layer, 999)
    end

    if self.setoff_layer.is_layer_showing then
        return
    end

    self.setoff_layer.is_layer_showing = true
    self.setoff_layer:refreshHero()
    self.setoff_layer:runAction(cc.Sequence:create(
        cc.MoveTo:create(0.5, cc.p(0, ex.MainSceneCtr:getBottomHeight() - 70)),
        cc.CallFunc:create(function ()
            self.setoff_layer.is_layer_showing = false
        end)
    ))
    self.setoff_layer:setTouchesHandler(true)
end

-- 神兵
function CrusadeGroupMainLayer:onWeapon(tag, pSender)
    ex.JumpManager:jumpByAtom("main_crusade_group_god_arms")
end

-- 聊天
function CrusadeGroupMainLayer:onChat(tag, pSender)
    require("src.layer.ChatCtr"):instance():openWindow({ChatLayerType.CLT_CRUSADE})
end

-- 地图
function CrusadeGroupMainLayer:onMap(tag, pSender)
    self:removeChildByName("CrusadeGroupMapThumbnailLayer")

    local layer_thumbnail = require("src.layer.crusadegroup.map.CrusadeGroupMapThumbnailLayer"):createWithCCBIFile("ccbi/CrusadeGroupMapThumbnailLayer.ccbi")
    layer_thumbnail:setName("CrusadeGroupMapThumbnailLayer")
    layer_thumbnail:setMapSize(self.map_layer.map:getMapTileSize())
    layer_thumbnail:setTileSize(self.map_layer.map:getTileSize())
    layer_thumbnail:setMapLayer(self.map_layer)
    layer_thumbnail:updateLayer()
    layer_thumbnail:setPositionY(ex.MainSceneCtr:getBottomHeight() + 130)
    layer_thumbnail:setTouchCallback(function(x, y)
        ex.EventManager:fire(EVENT.CRUSADE_GROUP.SET_MAP_FOCUS_PERCENT_ANIM, x, y)
        ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATE_THUMBNAIL_FOCUS)
        ex.MainSceneCtr:runCloudAnimation(0.5, function()
            self.map_layer:setFocusPercent(cc.p(x, y))
            layer_thumbnail:updateFocus()
        end)
    end)
    self:addChild(layer_thumbnail)

    -- require("src.layer.crusadegroup.map.CrusadeGroupMapThumbnailCtr"):instance():openWindow(function(x, y)
    --     self.map_layer:setFocusPercent(cc.p(x, y))
    -- end)
end

function CrusadeGroupMainLayer:onLocation()
    self:removeChildByName("CrusadeGroupMapThumbnailLayer")
    self.map_layer:onShowLastTile()
end

function CrusadeGroupMainLayer:startBattle(event, battle_type)
    local callback = function(layer, data, vec_reward, ext)
        if event == EVENT.CRUSADE_GROUP.BATTLE_REPORT then
            return true, false
        else
            if layer.ext.boss_total_damage <= 0 then
                -- 領地攻擊
                if layer.ext.report.win_id == ex.Player.role_id then
                    require("src.layer.crusadegroup.CrusadeGroupBattleEndTownWinCtr"):instance():openWindow(
                        {
                            is_win = layer.ext.report.win_id == ex.Player.role_id,
                            town_id = layer.ext.territory_id,
                            vec_addition_result = layer.ext.start,
                            vec_self = layer.ext.report.log.attacker_log.hero_log,
                            cur_round = layer.ext.num,
                            total_round = layer.ext.totalNum,
                            is_occupied = layer.ext.occupied,
                            detail = layer.report.log
                        }
                    )
                else
                    require("src.layer.crusadegroup.CrusadeGroupBattleEndTownLoseCtr"):instance():openWindow(
                        {
                            is_win = layer.ext.report.win_id == ex.Player.role_id,
                            town_id = layer.ext.territory_id,
                            recover_time = layer.ext.refresh_countdown,
                            vec_enermy = layer.ext.report.log.defender_log.hero_log,
                            detail = layer.report.log
                        }
                    )
                end
                return true, false
            else
                -- boss攻擊
                require("src.layer.crusadegroup.CrusadeGroupBattleEndBossCtr"):instance():openWindow(
                    {
                        town_id = layer.ext.territory_id,
                        cur_hp = layer.ext.report.log.defender_log.hero_log[1].hp,
                        total_hp = layer.ext.report.log.defender_log.hero_log[1].max_hp,
                        cur_damage = layer.ext.boss_damage,
                        total_damage = layer.ext.boss_total_damage,
                        detail = layer.report.log
                    }
                )
                return true, false
            end
        end
    end

    local battle_layer = self:addBattleLayer(battle_type,
                                             MainSceneType.MAINCITY_CRUSADE_GROUP_LAYER,
                                             "map_adventure", 
                                             EVENT.CRUSADE_GROUP.BATTLE,
                                             callback)
end

function CrusadeGroupMainLayer:updateLayer()
    local config_occupation = TableEx.findValueFunction(cfg.crusadegroupoccupation.crusadegroupoccupation, function(value)
        return ctr.crusade_group.data.game_data.self_occupation_id == value.id
    end)
    self.lbl_territory_num:setString(string.format("%d/%d", table.nums(ctr.crusade_group.data.game_data.occupied_list), config_occupation.landNum))
    
    local res1 = 0
    local ratio = 3600 / ex.Tools:getSysCfg("essence_production_interval_s")
    local res_ext = 0
    local ratio_coe = ex.Tools:getSysCfg("production_increase_ratio") - 1

    for i,v in ipairs(ctr.crusade_group.data.game_data.occupied_list) do
        local building_config = cfg.crusadegroupbuild.getConfig(v.id)
        if building_config then
            res1 = res1 + building_config.cream_output
            if v.hero_id > 0 then
                res_ext = res_ext + building_config.cream_output * ratio * ratio_coe
            end
        end
    end

    self.lbl_res_num1:setString(math.floor(res1 * ratio))
    self.lbl_res_num2:setString(string.format(ex.Tools:getLang(77628), math.floor(res_ext)))

    local width = ex.Tools:setLabelAlignmentMiddleX(self.lbl_res_num1, self.lbl_res_num2, 0)
    if width > 120 then
        self.node_res:setScale(120 / width)
    end

    self:updateOccupation()
end

function CrusadeGroupMainLayer:updateOccupation()
    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/crusade-group.plist")

    local cur_nobility = ctr.crusade_group.data.game_data.self_occupation_id
    local str_nobility = "crusade-group/spr-nobility-"..cur_nobility..".png"
    self.btn_nobility:setNormalImage(cc.Sprite:createWithSpriteFrameName(str_nobility))
    self.btn_nobility:setSelectedImage(cc.Sprite:createWithSpriteFrameName(str_nobility))

    -- local config_nobility = cfg.crusadegroupoccupation.crusadegroupoccupation[cur_nobility]
    -- self.layer.layer_nobility.lbl_nobility:setString(ex.Tools:getLang(config_nobility.des))
end

function CrusadeGroupMainLayer:runCollectEffect()
    
    local res_pos = self.spr_res_bg:convertToWorldSpace(cc.p(0, 0))
    for k,v in pairs(ctr.crusade_group.data.game_data.occupied_list) do
        local x, y = ctr.crusade_group.data:convertGridIdToPos(v.id)
        local node_ui = self.map_layer.map:getOrCreateUINode(x, y)
        if node_ui then
            node_ui:showCollect(false)
        end

        local pos =  self.map_layer.map:getPositionByTile(x, y)
        pos = self.map_layer.map:convertToWorldSpace(pos)
        local rand_num = math.random(3)
        for i=1,rand_num do
            local spr_collect = UISpriteCollect:create("backpack/902048.png")
            spr_collect:setOpacity(0)
            spr_collect:setScale(0.5)
            spr_collect:setPosition(pos)
            self:addChild(spr_collect, -1)

            spr_collect:runAnim(pos, res_pos)
        end
    end
end

return CrusadeGroupMainLayer