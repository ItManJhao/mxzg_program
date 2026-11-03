--[[
    func: 彩虹圣殿
    author:徐东浩
    time:2020-02-28 10:28:44
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local RainbowMainLayer = class("RainbowMainLayer", require("src.comp.EventLayer"))
local RainbowSeat = class("RainbowSeat", require("src.comp.EventLayer"))

-- NPC位置百分比
local SeatPosData = {   -- {x坐标百分比，y坐标百分比，缩放系数}
    {fx = 0.50, fy = 0.76, fs = 1.3},
    {fx = 0.23, fy = 0.59, fs = 1.0},
    {fx = 0.73, fy = 0.59, fs = 1.0},
    {fx = 0.23, fy = 0.29, fs = 1.0},
    {fx = 0.73, fy = 0.29, fs = 1.0},
    {fx = 0.50, fy = 0.13, fs = 1.0},
}

-------------------------------------RainbowSeat----------------------------------------------------
function RainbowSeat:onCreate()
	self:setAutoClose(false)
    self:setSwallowTouches(false)
    
    self.data = {}

    self.node_root:retain()

    self.node_root:removeFromParentAndCleanup(false)

    -- self.node_root:setParent(self.btn_base:getNormalImage())
    self.btn_base:getNormalImage():addChild(self.node_root)

    self.node_root:release()
end

function RainbowSeat:initDone(data)
    self.data = data

    if self.data.rid == 0 then
        self.lbl_name:setTextColor(cc.WHITE)
    else
        self.lbl_name:setTextColor(cc.c3b(255, 223, 44))
    end
    self.lbl_name:setString(tostring(self.data.name))

    ex.Tools:setSpriteFrame(self.spr_title, string.format("rainbow/title-%d.png", self.data.type))

    self.animator = require("src.person.Hero"):create("1", "1", 1, 1, self.data.image.star, self.data.image.skin) --sp.SkeletonAnimation:create("spine/"..self.data.role_info.image_id..".json","spine/"..self.data.role_info.image_id..".atlas", 1)
    self.animator:setAnimation(0, "stand", true);
    self.animator:setScale(1.0)
    self.animator:setPosition(cc.p(0, 50))
    self.animator:setShadowVisible(false)
    self.node_animator:addChild(self.animator, 10)
end

-------------------------------------RainbowMainLayer----------------------------------------------------
-- 界面布局调整
function RainbowMainLayer:onCreate()
    self.data = {}
    self.timer_name = "rainbow_war_timer"
    self.battle_result = {}
    self.battle_result_type = 0

    self:setAutoClose(false)
	self:setSwallowTouches(false)

	-- 铺展到全屏
	ex.Tools:AdjustFullScreenExtend(self.spr_bg)
    
    local pos_y = ex.p.height - 80 * ex.s.global_scale - require("src.model.Game"):instance():getNotchHeight()
    self.node_top:setPositionY(pos_y)
    
    self.node_bottom:setPositionY(self:getBottomY())

    -- 放置npc区域
    pos_y = self.node_bottom:getPositionY() + self.node_bottom:getContentSize().height * self.node_bottom:getScale()
    self.player_rect = cc.rect(
        0, 
        pos_y,
        ex.p.width,
        self.node_top:getPositionY() - self.node_top:getContentSize().height * self.node_top:getScale() - pos_y
    )

    -- 添加npc父节点
    self.node_npc = cc.Node:create()
    self.node_npc:setPosition(self.player_rect.x, self.player_rect.y)
    self:addChild(self.node_npc)

    self.btn_back:registerScriptTapHandler(handler(self, self.onBack))
    self.btn_info:registerScriptTapHandler(handler(self, self.onBtnInfo))

    -- self:addEvent(EVENT.RAINBOW_EVENT.REFRESH_MY_RANK, handler(self, self.refreshRank))
    self:addEvent(EVENT.RAINBOW_EVENT.REFRESH_VS_PLAYER, handler(self, self.refreshNPC))
    self:addEvent(EVENT.RAINBOW_EVENT.BATTLE_HISTORY_ON_REPORT, handler(self, self.onBattleReport))
end

function RainbowMainLayer:onCreateDone()
    if not ex.Player.rainbow_data.rainbow_main_data_is_dirty then
        self:updateView()
    end

    self:refreshRank()
end

function RainbowMainLayer:changeLayerIn()
    -- 刷新排行数据
    -- ex.Player.rank_data:onRefreshRainbow()

    ex.EventManager:fire(EVENT.BATTLE_EVENT.CHANGE_LAYER, self, true)
end

function RainbowMainLayer:changeLayerOutEnd()
    ex.EventManager:fire(EVENT.BATTLE_EVENT.CHANGE_LAYER, self, false)
end

function RainbowMainLayer:updateView()
    self:refreshNPC()
end

function RainbowMainLayer:generateData()
    self.data.list = {}
    
    local getImage = function(data)
        local l_star, l_skin = 0, 0

        if data.rid == 0 then
            l_star = data.npc_list[1].star
            l_skin = ex.Tools:getHeroSkinByStar(data.npc_list[1].type, data.npc_list[1].star)
            if not l_skin then
                l_star, l_skin = ex.Tools:getHeroSkinByImageId(10105006)
            end
        else
            l_star, l_skin = ex.Tools:getHeroSkinByImageId(data.image_id)
        end

        return {star = l_star, skin = l_skin}
    end

    for i,v in ipairs(ex.Player.rainbow_data.rainbow_main_data.defenders) do
        local data = {}
        data.id = v.id
        data.type = v.type
        data.evolution = v.evolution
        data.rid = v.rid
        data.name = v.rid == 0 and ex.Tools:getLang(54202) or v.name
        data.image = getImage(v)
        data.pos = v.pos
        data.level = v.level
        data.head_id = v.head_id
        data.border_id = v.border_id
        data.npc = v.npc_list[1]
    
        table.insert(self.data.list, data)
    end
end

function RainbowMainLayer:refreshRank()
    self.lbl_rank_1:setString(tostring(cfg.rainbow.rainbow[1].need_rank))
    self.lbl_rank_2:setString(tostring(cfg.rainbow.rainbow[2].need_rank))
    self.lbl_rank_3:setString(tostring(cfg.rainbow.rainbow[3].need_rank))
end

function RainbowMainLayer:refreshNPC()
	self.node_npc:removeAllChildren()
	
    self:generateData()
    
    for i,v in ipairs(self.data.list) do
        local seat = RainbowSeat:createWithCCBIFile("ccbi/RainbowSeat.ccbi")
        seat:setPosition(self.player_rect.width * SeatPosData[math.min(6, i)].fx - seat:getContentSize().width / 2, self.player_rect.height * SeatPosData[math.min(6, i)].fy - seat:getContentSize().height / 2)
        seat:setScale(SeatPosData[math.min(6, i)].fs)
        self.node_npc:addChild(seat)
        
        -- 设置cell
        seat:initDone(v)
        seat.btn_base:registerScriptTapHandler(handler(self, self.onClickPlayer))
    end
end

function RainbowMainLayer:getBottomY()
	return ex.MainSceneCtr:getBottomHeight() + 10
end

function RainbowMainLayer:onBack(tag, pSender)
    if not ex.MainSceneCtr:backLastLayer() then
        ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
    end
end

function RainbowMainLayer:onBtnInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42054), ex.Tools:getLang(42055))
end

function RainbowMainLayer:onClickPlayer(tag, pSender)
    local seat = pSender:getParent():getParent()
    require("src.layer.RainbowChallengeCtrl"):instance():openWindow(seat.data, self, ex.Player.rainbow_data.rainbow_main_data.my_rank)
end

function RainbowMainLayer:onBattle()
    local battle_layer = self:addBattleLayer(BattleType.RAINBOW_ATTACKER,
                                            MainSceneType.MAINCITY_CHSD,
                                            "", 
                                            EVENT.RAINBOW_EVENT.BATTLE_REPORT,
                                            function(layer, data, vec_reward, ext)
                                                ex.Tools:autoPlaySceneMusic(0.1)

                                                if data.isWin then
                                                    require("src.layer.RainbowBattleEndCtrl"):instance():openWindow(self.battle_result, self.battle_result_type)
                                                -- else
                                                --     require("src.layer.chapterend.ChapterEndCtr"):instance():openWindow({is_win = false})
                                                end

                                                return true, not data.isWin
                                            end)
    battle_layer:setScale(1.0 / self:getParent():getScale())
    battle_layer:setPosition(self:getContentSize().width * 0.5 / battle_layer:getScale()  - ex.p.width * 0.5,
                                self:getContentSize().height * 0.5 / battle_layer:getScale() - ex.p.height * 0.5)
    ex.Tools:autoPlaySceneMusic()
end

function RainbowMainLayer:onBattleReport(event, battle_id)
    local req_battle = Battle_pb.GReqBattleReport()
    req_battle.battle_id = battle_id
    req_battle.type = EVENT.RAINBOW_EVENT.BATTLE_HISTORY_REPORT
    NetManager:sendMessage(ProtocolID.GReqBattleReport, req_battle)

    local battle_layer = self:addBattleLayer(BattleType.RAINBOW_REPORT,
                                            MainSceneType.MAINCITY_CHSD,
                                            "", 
                                            EVENT.RAINBOW_EVENT.BATTLE_HISTORY_REPORT,
                                            function(layer, data, vec_reward, ext)
                                                return true, false
                                            end)
    battle_layer:setScale(1.0 / self:getParent():getScale())
    battle_layer:setPosition(self:getContentSize().width * 0.5 / battle_layer:getScale()  - ex.p.width * 0.5,
                                self:getContentSize().height * 0.5 / battle_layer:getScale() - ex.p.height * 0.5)
end

return RainbowMainLayer
