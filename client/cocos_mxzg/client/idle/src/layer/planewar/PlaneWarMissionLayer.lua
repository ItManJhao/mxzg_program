local PlaneWarMissionLayer = class("PlaneWarMissionLayer", require("src.comp.EventLayerAdaptiveWidthFull"))
local PlaneWarMissionCell = class("PlaneWarMissionCell", require("src.comp.LuaLayerBase"))
PlaneWarMissionLayer.ctr = ctr.plane_war


-------------------------------------PlaneWarMissionCell-------------------------------------
function PlaneWarMissionCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:setIgnoreAnchorPointForPosition(false)
    self:setAnchorPoint(0.5, 0.5)
    self.menu:setSwallowsTouches(false)
    self.btn_clean:setLabelText(ex.Tools:getLang(47040))
    self.btn_battle:setLabelText(ex.Tools:getLang(47412))
    self.btn_clean:registerScriptTapHandler(handler(self, self.onSweep))
    self.btn_battle:registerScriptTapHandler(handler(self, self.onChallenge))
end

function PlaneWarMissionCell:reset(data, width)
    if not data then
        return
    end

    self.data = data

    self:setContentSize(cc.size(width, self.spr_bg:getContentSize().height))
    self.spr_bg:setContentSize(self:getContentSize())
    self.btn_clean:setPositionX(width - 113 - 10)
    self.btn_battle:setPositionX(width - 113 - 10)

    self.btn_clean:setVisible(data.status == 1)
    self.btn_clean:setEnabled(data.status == 1)

    if data.status == -1 then
        self.btn_battle:setLabelText(ex.Tools:getLang(2707))
    else
        self.btn_battle:setLabelText(ex.Tools:getLang(47412))
    end
    self.btn_battle:setVisible(data.status ~= 1)
    self.btn_battle:setEnabled(data.status == 0)
 
    self.lbl_mission:setString(data.mission)
end

function PlaneWarMissionCell:onChallenge()
    if not ctr.plane_war.select_instance then
        return 
    end

    local select_time = ctr.plane_war.select_instance.select_time
    if select_time then
        local curtime = ex.Game:getServerTime()
        local is_same_day = Maths.isSameDay(curtime, select_time)
        if not is_same_day then
            ex.MessageView:add(ex.Tools:getLang(91265))
            ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_PLANE_WAR_MAIN_LAYER)
            return
        end
    end

    local plane_war_data = ctr.plane_war.data
    if not self.data or 
    plane_war_data.challenge_count <= 0 then
        ex.MessageView:add(ex.Tools:getLang(91263))
        return
    end

    local battle_type = self.data.battle_type
    require("src.layer.HeroSelectCtr"):instance():openWindow(
        ex.Tools:getLang(47524),
        ex.Tools:getLang(47064),
        battle_type,
        function()
            ctr.plane_war:requestPlaneWarChallenge(self.data.idx)
        end,
        nil,
        nil,
        nil,
        nil,
        self.data.element
    )
end

function PlaneWarMissionCell:onSweep()
    if not ctr.plane_war.select_instance then
        return 
    end

    local select_time = ctr.plane_war.select_instance.select_time
    if select_time then
        local curtime = ex.Game:getServerTime()
        local is_same_day = Maths.isSameDay(curtime, select_time)
        if not is_same_day then
            ex.MessageView:add(ex.Tools:getLang(91265))
            ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_PLANE_WAR_MAIN_LAYER)
            return
        end
    end
    
    local plane_war_data = ctr.plane_war.data
    if not self.data or 
    plane_war_data.challenge_count <= 0 then
        ex.MessageView:add(ex.Tools:getLang(91263))
        return
    end

    ctr.plane_war:requestPlaneWarSweep(self.data.idx)
end

function PlaneWarMissionLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(true)

    self:initEventListen()
    self:initPlist()

    local pos_y = ex.p.height - 80 * ex.s.global_scale - require("src.model.Game"):instance():getNotchHeight()
    self.node_top:setPositionY(pos_y)
    local mission_height = pos_y - ex.MainSceneCtr:getBottomHeight() - self.node_middle:getContentSize().height - 60
    local mission_size = cc.size(self.spr_mission_bg:getContentSize().width, mission_height)
    self.node_mission:setContentSize(mission_size.width, mission_size.height)
    self.spr_mission_bg:setContentSize(mission_size.width, mission_size.height)
    local sv_width = mission_size.width * 0.875
    local sv_height = mission_size.height * 0.86
    self.scroll_view_bg:setContentSize(sv_width, sv_height)
    self.scroll_view_bg:setPositionY(mission_size.height / 2)
    self.scroll_view:setItemType(1)
    self.scroll_view:setCreateNum(4)
    self.scroll_view:setViewSize(cc.size(sv_width, sv_height))
    self.scroll_view:setItemSize(cc.size(self.scroll_view:getViewSize().width - 10, 124))

    self.menu_skill = cpp.UIMenu:create()
	self.node_middle:addChild(self.menu_skill)
    self.menu_skill:setPosition(self.spr_skill:getPositionX(),self.spr_skill:getPositionY())
    self.spr_skill:setVisible(fasle)
    self.btn_skill = nil

    self.node_mission:setPositionY(ex.MainSceneCtr:getBottomHeight() + 40)
    self.node_middle:setPositionY(ex.MainSceneCtr:getBottomHeight() + 40 + self.node_mission:getContentSize().height)
    self.node_bottom:setPositionY(ex.MainSceneCtr:getBottomHeight() - 20)

    if self.spr_bg:getContentSize().width * self:getScaleX() < ex.p.width then
        self.spr_bg:setScale(ex.p.width / self.spr_bg:getContentSize().width / self:getScaleX())
    end

    if ctr.plane_war.select_instance then
        self.select_time = ctr.plane_war.select_instance.select_time
        self:initData(ctr.plane_war.select_instance.element, ctr.plane_war.select_instance.turn)
    end
end

function PlaneWarMissionLayer:changeLayerInEnd()
    if not ctr.plane_war.select_instance then
        return 
    end

    local select_time = ctr.plane_war.select_instance.select_time
    if select_time then
        local curtime = ex.Game:getServerTime()
        local is_same_day = Maths.isSameDay(curtime, select_time)
        if not is_same_day then
            ex.MessageView:add(ex.Tools:getLang(91265))
            ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_PLANE_WAR_MAIN_LAYER)
            return
        end
    end
end

function PlaneWarMissionLayer:initEventListen()
    self:addEvent(EVENT.PLANE_WAR.CHALLENGE, handler(self, self.handleUpdataMissions))
    self:addEvent(EVENT.PLANE_WAR.SWEEP, handler(self, self.handleUpdataMissions))
    self:addEvent(EVENT.PLANE_WAR.UPDATE_TIMES, handler(self, self.handleUpdataTimes))
end

function PlaneWarMissionLayer:initPlist()
    -- 加载需要的资源
    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/plane-war.plist")
    sfc:addSpriteFrames("ccbi-res/skill-icon.plist")
    sfc:addSpriteFrames("ccbi-res/hero-info.plist")
end

function PlaneWarMissionLayer:initData(element, turn)
    self.element = element
    self.turn = turn

    ctr.plane_war:selectInstance(element, turn)
    local data = ctr.plane_war:getMissionsData(element, turn)
    if not data then
        return
    end

    self:reloadData(data)
end

function PlaneWarMissionLayer:reloadData(data)
    self.data = data
    local plane_war_data = ctr.plane_war.data
    if not self.data or not plane_war_data or not self.data.missions or not self.data.boss_data then
        return
    end

    self:updateTims(plane_war_data)
    self:updateMission(self.data.missions)
    self:updateBossInfo(self.data.boss_data)
end

function PlaneWarMissionLayer:updateTims(plane_war_data)
    if not plane_war_data then
        return
    end

    self.lbl_times:setString(string.format("%s/%s", plane_war_data.challenge_count, plane_war_data.max_challenge_count))
    self.lbl_times_buy:setString(plane_war_data.remaining_buy_count)
end

function PlaneWarMissionLayer:updateMission(missions)
    if not missions or #missions == 0 then
        return
    end

    self.scroll_view.createItemFunction = function(item_data, scale)
        local cell = PlaneWarMissionCell:createWithCCBIFile("ccbi/PlaneWarMissionCell.ccbi")
        cell:reset(item_data, self.scroll_view:getViewSize().width -  10)

        -- 显示奖励
        if item_data.reward then
            for i,v in ipairs(item_data.reward) do
                local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
                item:setPosition(120 + 88 * (i - 1), 62)
                item:setScale(0.75)
                item:registerScriptTapHandler(handler(self, self.onItemInfo))
                cell.menu:addChild(item)
            end
        end
        
        return cell
    end
    
    self.scroll_view:reloadData(missions)
end

function PlaneWarMissionLayer:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function PlaneWarMissionLayer:updateBossInfo(boss_data)
    self.node_boss:removeAllChildren()
    local boss_animator = require("src.person.Hero"):create("1", "1", boss_data.hero_type, boss_data.hero_level, boss_data.hero_star)
    boss_animator:setAnimation(0, "stand", true)
    boss_animator:setScale(2)
    boss_animator:setPosition(cc.p(0, 120))
    boss_animator:setShadowVisible(false)
    self.node_boss:addChild(boss_animator, 10)

    local heroName = ex.Tools:getLang(boss_data.hero_type)
    self.lbl_boss_name:setString(heroName)
    self.lbl_desc:setString(ex.Tools:getLang(boss_data.hero_introduce))

    -- ex.Tools:setSpriteFrame(self.spr_skill, "skill-icon/" .. boss_data.hero_skillid .. ".png")
    if self.btn_skill then
        self.btn_skill:removeFromParent()
        self.btn_skill = nil
    end

    cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/hero-info.plist")

    local UIMenuItemSkill = require("src.comp.menu.UIMenuItemSkill")
    self.btn_skill = UIMenuItemSkill:createWithIcon(boss_data.hero_skillid, 0, fasle, handler(self, self.onSkillInfo))
    self.btn_skill:setGray(false)
	self.menu_skill:addChild(self.btn_skill)
    self.btn_skill.lbl_name:setVisible(false)
end

------------------------------ 点击事件 ------------------------------

function PlaneWarMissionLayer:onSkillInfo(tag, pSender)
    require("src.layer.HeroSkillInfoCtr"):instance():openWindow(pSender.skill_type, pSender.skill_level)
end

-- 返回
function PlaneWarMissionLayer:onBack(tag, pSender)
    ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_PLANE_WAR_MAIN_LAYER)
end

-- 购买挑战次数
function PlaneWarMissionLayer:onAddTimes(tag, pSender)
    local plane_war_data = ctr.plane_war.data
    if not plane_war_data or plane_war_data.remaining_buy_count == 0 then
        ex.MessageView:add(ex.Tools:getLang(74935))
        return
    end

    local res_need = ctr.plane_war:getBuyConsume()
    if res_need == nil then
        ex.MessageView:add(ex.Tools:getLang(74935))
        return
    end

    -- 打开购买确认框
    local layer =
        ex.ConfirmCtr:openWindow(
        ex.Tools:getLang(16),
        string.format(ex.Tools:getLang(91257), res_need[1].item_num),
        function()
            if res_need[1].item_num > ex.Player:getItemNum(res_need[1].item_type) then
                ex.Tools:showEnoughTip(res_need[1].item_type, true)
                return
            end
            NetManager:sendMessage(ProtocolID.GReqPlaneWarBuyCount)
        end,
        nil,
        nil,
        nil,
        nil,
        nil,
        true
    )
end

------------------------------ 事件监听 ------------------------------
function PlaneWarMissionLayer:handleUpdataMissions()
    local element = self.element
    local turn = self.turn

    local data = ctr.plane_war:getMissionsData(element, turn)
    if not data then
        return
    end

    self:reloadData(data)
end

function PlaneWarMissionLayer:handleUpdataTimes()
    local plane_war_data = ctr.plane_war.data
    if not plane_war_data then
        return
    end

    self:updateTims(plane_war_data)
end


return PlaneWarMissionLayer
