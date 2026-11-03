local SuperStageLegendLayer = class("SuperStageLegendLayer", require("src.comp.EventLayer"))
local SuperStageLegendSeat = class("SuperStageLegendSeat", require("src.comp.EventLayer"))

-- NPC位置百分比
local SeatPosData = {   -- {x坐标百分比，y坐标百分比，缩放系数}
    {fx = 0.50, fy = 0.72, fs = 1.1},
    {fx = 0.20, fy = 0.55, fs = 0.9},
    {fx = 0.80, fy = 0.55, fs = 0.9},
    {fx = 0.20, fy = 0.30, fs = 0.9},
    {fx = 0.80, fy = 0.30, fs = 0.9},
    {fx = 0.50, fy = 0.17, fs = 0.9},
}

-------------------------------------SuperStageLegendSeat----------------------------------------------------
function SuperStageLegendSeat:onCreate()
	self:setAutoClose(false)
    self:setSwallowTouches(false)
    
    self.data = {}
end

function SuperStageLegendSeat:initDone(data)
    self.data = data

    self.spr_title:setVisible(self.data.fighting > 0)
    self.node_fighting:setVisible(self.data.fighting > 0)

    if self.data.fighting <= 0 then
        self.lbl_name:setColor(cc.WHITE)
        self.lbl_name:setString(ex.Tools:getLang(5067))
    else
        self.lbl_name:setColor(cc.c3b(255, 223, 44))
        self.lbl_name:setString(self.data.name)

        ex.Tools:setSpriteFrame(self.spr_title, string.format("role-title/title%d.png", self.data.title_id))

        self.lbl_fighting:setString(self.data.fighting)

        local hero_type = math.floor(self.data.image_id % 100000000)
        local star = math.floor(self.data.image_id / 100000000)
        
        local hero_skin = ex.Tools:getHeroSkinByStar(hero_type, star)
        self.animator = require("src.person.Hero"):create("12323", "123213", hero_type, 1, star, hero_skin)
        self.animator:setAnimation(0, "stand", true);
        self.animator:setScale(1.0)
        self.animator:setPosition(cc.p(0, 50))
        self.animator:setShadowVisible(false)
        self.node_animator:addChild(self.animator, 10)
    end
end

----------------------------------------------------------------------------------

function SuperStageLegendLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

	-- 铺展到全屏
	ex.Tools:AdjustFullScreenExtend(self.spr_bg)
    
    -- 设置左右切换按钮的灰色状态
    local spr_left = cc.Sprite:createWithSpriteFrameName("button/btn-left.png")
    ex.Tools:setGrayAuto(spr_left, true)
    self.btn_left:setDisabledImage(spr_left)
    local spr_right = cc.Sprite:createWithSpriteFrameName("button/btn-right.png")
    ex.Tools:setGrayAuto(spr_right, true)
    self.btn_right:setDisabledImage(spr_right)

    local pos_y = ex.p.height - 80 * ex.s.global_scale - require("src.model.Game"):instance():getNotchHeight()
    self.node_top:setPositionY(pos_y)
    
    local bottom_y = ex.MainSceneCtr:getBottomHeight() + 10

    -- 放置npc区域
    pos_y = self.node_top:getPositionY() - self.node_top:getContentSize().height * self.node_top:getScale()
    self.player_rect = cc.rect(
        0, 
        (self:getContentSize().height - pos_y) / 2,
        ex.p.width,
        pos_y
    )

    -- 添加npc父节点
    self.node_npc = cc.Node:create()
    self.node_npc:setPosition(self.player_rect.x, self.player_rect.y)
    self:addChild(self.node_npc)

    self:initDone()
end

function SuperStageLegendLayer:onExit()

end

function SuperStageLegendLayer:initDone()
    self:addEvent(EVENT.SUPER_STAGE.LEGEND_LIST, handler(self, self.receiveData))

    self.data = {}
    self.select_season_id = ex.Player.super_stage_data.cur_season

    -- 如果當前賽季還未進入結算階段，則默認進入上一個賽季
    if ex.Game:getServerTime() < ex.Player.super_stage_data.match_end_time then
        self.select_season_id = ex.Player.super_stage_data.cur_season - 1
        if self.select_season_id < 1 then
            self.select_season_id = 1
        end
    end

    -- 請求數據
    local req = StageMatch_pb.GReqSeasonLegend()
    req.season = self.select_season_id
    NetManager:sendMessage(ProtocolID.GReqSeasonLegend, req)

    self:updateLayer()
end

-- 开始匹配
function SuperStageLegendLayer:receiveData(event, data)
    if data == nil or data.season == nil or data.season ~= self.select_season_id then
        return
    end

    self.data = {}
    for i=1,6 do
        local rank = cfg.superstagerank.superstagerank[i]
        local legend_data = nil
        for _,v2 in ipairs(data.legendInfo) do
            if v2.rank == rank.idx then
                legend_data = v2
                legend_data.title_id = rank.title_id
                break
            end
        end

        if legend_data == nil then
            legend_data = {}
            legend_data.title_id = rank.title_id
            legend_data.fighting = 0
        end

        table.insert(self.data, legend_data)
    end

    table.sort(self.data, function(a, b)
        return a.title_id < b.title_id
    end)

    self:updateLayer()
end

function SuperStageLegendLayer:updateLayer()
    self.lbl_title:setString(string.format(ex.Tools:getLang(74834), self.select_season_id))

    self.btn_left:setVisible(self.select_season_id > 1)
    self.btn_right:setVisible(self.select_season_id < ex.Player.super_stage_data.cur_season)

	self.node_npc:removeAllChildren()
	
    for i,v in ipairs(self.data) do
        local seat = SuperStageLegendSeat:createWithCCBIFile("ccbi/SuperStageLegendSeat.ccbi")
        seat:setPosition(self.player_rect.width * SeatPosData[math.min(6, i)].fx - seat:getContentSize().width / 2, self.player_rect.height * SeatPosData[math.min(6, i)].fy - seat:getContentSize().height / 2)
        seat:setScale(SeatPosData[math.min(6, i)].fs)
        self.node_npc:addChild(seat)
        
        -- 设置cell
        seat:initDone(v)
    end
end

function SuperStageLegendLayer:onBack(tag, pSender)
    ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_SUPER_STAGE_MAIN)
end

function SuperStageLegendLayer:onLeft(tag, pSender)
    if self.select_season_id <= 2 then
        self.select_season_id = 1
    else
        self.select_season_id = self.select_season_id - 1
    end

    -- 發送協議
    local req = StageMatch_pb.GReqSeasonLegend()
    req.season = self.select_season_id
    NetManager:sendMessage(ProtocolID.GReqSeasonLegend, req)

    self.data = {}
    self:updateLayer()
end

function SuperStageLegendLayer:onRight(tag, pSender)
    local super_stage_data = ex.Player.super_stage_data
    if self.select_season_id >= super_stage_data.cur_season - 1 then
        self.select_season_id = super_stage_data.cur_season
    else
        self.select_season_id = self.select_season_id + 1
    end

    -- 發送協議
    local req = StageMatch_pb.GReqSeasonLegend()
    req.season = self.select_season_id
    NetManager:sendMessage(ProtocolID.GReqSeasonLegend, req)
    
    self.data = {}
    self:updateLayer()
end

return SuperStageLegendLayer
