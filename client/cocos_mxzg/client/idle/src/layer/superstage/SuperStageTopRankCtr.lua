local SuperStageTopRankCtr = class("SuperStageTopRankCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local SuperStageTopRankLayer = class("SuperStageTopRankLayer", require("src.comp.EventLayerAdaptiveWidth"))

local SuperStageTopRankCell = class("SuperStageRankCell", require("src.comp.LuaLayerBase"))
function SuperStageTopRankCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.btn_photo:setContentSize(self.spr_photo:getContentSize())
end

function SuperStageTopRankCell:setTableView(table_view)
    self.menu:setIsTouchInsideNode(table_view)
    self.menu:setSwallowsTouches(false)
end

function SuperStageTopRankCell:initData(data, cell_type)
    if data == nil or data.rank == nil then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/rank.plist")
    sfc:addSpriteFrames("ccbi-res/super-stage-icon.plist")

    self.data = data

    self.btn_photo.role_id = data.rid
    self.btn_photo.player_server_id = data.server_id

    self.btn_like.rid = data.rid

    if self.spr_rank ~= nil then
        self.spr_rank:setVisible(false)
        self.lbl_rank:setVisible(true)
        self.lbl_rank:enableShadow(FONT_BLACK_C4B, cc.size(1, -1))
        if data.rank > 0 and data.rank < 4 then 
            self.spr_rank:setVisible(true)
            self.lbl_rank:setVisible(false)
            -- self.spr_rank:setSpriteFrame(string.format("rank/spr-paihang-%s.png", data.rank))
            ex.Tools:setSpriteFrame(self.spr_rank, string.format("rank/spr-paihang-%s.png", data.rank))
        end
              
        if data.rank > 0 then
            self.lbl_rank:setString(string.format("%d", data.rank))
            self.lbl_rank:setScale(0.5)
        else
            self.lbl_rank:setString(ex.Tools:getLang(52012))
            self.lbl_rank:setScale(0.3)
        end
    end

    ex.Tools:setSpriteFrame(self.spr_photo, string.format("head-icon/%d.png", data.head_id))
    ex.Tools:setSpriteFrame(self.spr_frame, ex.Tools:getBorderIconByIdx(data.border_id))

    local config_stage = cfg.superstage.superstage[data.stage_id]
    config_stage = config_stage and config_stage or cfg.superstage.superstage[1]
    ex.Tools:setSpriteFrame(self.spr_stage, string.format("super-stage-icon/rank-2-%d.png", config_stage.icon_idx))
    self.lbl_stage_name:setString(ex.Tools:getLang(config_stage.name_lang))

    self.lbl_name:setString(data.name)
    self.lbl_server_name:setString(ex.StringUtil.getServerName(data.server_id))
    self.lbl_level:setString(string.format("%d", data.level))
    self.lbl_fighting:setString(string.format("%d", data.fighting))
    self.lbl_like:setString(string.format("%d", data.like))
    
    local is_limit = ex.Player.super_stage_data:isLimitLike()
    local is_like = ex.Player.super_stage_data:isLike(data.rid)
    ex.Tools:setGrayAuto(self.btn_like:getNormalImage(), is_like)
    self.btn_like:setEnabled(not is_like)
    ex.Tools:addRedPoint(self.btn_like, not is_like and not is_limit)

    self.lbl_name:setPositionX(self.lbl_server_name:getPositionX() + self.lbl_server_name:getContentSize().width * self.lbl_server_name:getScaleX() + 5)
            
    local config_stage = cfg.superstage.superstage[data.stage_id]
    if config_stage ~= nil then
        self.lbl_stage_name:setString(ex.Tools:getLang(config_stage.name_lang))
    end
end

-----------------------------------------------------------------------------
function SuperStageTopRankLayer:onCreate()
    -- self:setAutoClose(false)
    self:addBlackBackground()
    
    self.scroll_view:setItemSize(cc.size(540, 135))
    self.scroll_view:setItemType(1)
end

-----------------------------------------------------------------------------
function SuperStageTopRankCtr:onCreate()
    self:setCCBIPath("ccbi/SuperStageTopRankLayer.ccbi")
    self:setIsSingle(false)
end

function SuperStageTopRankCtr:getLayerClass()
    return SuperStageTopRankLayer
end

function SuperStageTopRankCtr:openWindow()
    if self:isOpened() then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/rank.plist")

    self:loadLayer()
    self:open()
    self:initData()
end

function SuperStageTopRankCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    self.layer:addEvent(EVENT.SUPER_STAGE.RANK_INFO, handler(self, self.updateTableView))
    self.layer:addEvent(EVENT.SUPER_STAGE.UPDATE_LIKE, handler(self, self.updateLike))

    if ex.Player.super_stage_data.pinnacle_stage == 5 then
        NetManager:sendMessage(ProtocolID.GReqPreliminariesRank)
    else
        NetManager:sendMessage(ProtocolID.GReqPinnacleRank)
    end

    self:updateTableView()
end

function SuperStageTopRankCtr:updateTableView()
    if not self:getLayer() then
        return
    end

    local super_stage_data = ex.Player.super_stage_data
    local config_stage = cfg.superstage.superstage[super_stage_data.cur_stage_id]
    if config_stage == nil then
        return
    end

    -- 更新我的排名
    local rank = super_stage_data.top_rank
    if ex.Player.super_stage_data.pinnacle_stage == 5 then
        rank = super_stage_data.ladder_main_data.rank
    end
    if rank <= 0 then
        self.layer.lbl_rank_self:setString(ex.Tools:getLang(74811)..ex.Tools:getLang(74812))
    else
        self.layer.lbl_rank_self:setString(ex.Tools:getLang(74811)..rank)
    end
    -- 更新我的段位
    self.layer.lbl_stage_self:setString(ex.Tools:getLang(config_stage.name_lang))

    -- 显示前三名形象
    local is_limit = ex.Player.super_stage_data:isLimitLike()
    for i=1,3 do
        local data = super_stage_data.vec_top_rank[i]
        local node = self.layer["node_spine_"..i]
        node:setVisible(data ~= nil)
        node:removeAllChildren()
        if data ~= nil then
            -- data.image_id = ex.Player:getImageId()
            local hero_type = math.floor(data.image_id % 100000000)
            local star = math.floor(data.image_id / 100000000)
            
            local hero_skin = ex.Tools:getHeroSkinByStar(hero_type, star)
            local spine_hero = require("src.person.Hero"):create("1", "1", hero_type, 1, star, hero_skin)
            spine_hero:setAnimation(0, "stand", true);
            spine_hero:setScale(1.0)
            spine_hero:setPosition(cc.p(0, 50))
            spine_hero:setShadowVisible(false)
            node:addChild(spine_hero, 10)

            local config_stage = cfg.superstage.superstage[data.stage_id]
            if config_stage == nil then
                config_stage = cfg.superstage.superstage[1]
            end
    
            self.layer["lbl_like"..i]:setString(data.like)
            self.layer["lbl_stage_name_"..i]:setString(ex.Tools:getLang(config_stage.name_lang))

            self.layer["lbl_name_"..i]:setString(data.name)
            self.layer["lbl_fighting_"..i]:setString(string.format("%d", data.fighting))
            self.layer["lbl_like"..i]:setString(data.like)

            local config_stage = cfg.superstage.superstage[data.stage_id]
            if config_stage ~= nil then
                self.layer["lbl_stage_name_"..i]:setString(ex.Tools:getLang(config_stage.name_lang))
            end

            self.layer["node_fighting_"..i]:setVisible(true)
            self.layer["node_like_"..i]:setVisible(true)

            self.layer["btn_like"..i].rid = data.rid
            self.layer["btn_like"..i]:registerScriptTapHandler(handler(self, self.onLike))

            local is_like = ex.Player.super_stage_data:isLike(data.rid)
            ex.Tools:setGrayAuto(self.layer["btn_like"..i]:getNormalImage(), is_like)
            self.layer["btn_like"..i]:setEnabled(not is_like)

            ex.Tools:addRedPoint(self.layer["btn_like"..i], not is_like and not is_limit, cc.p(0.75, 0.75))
        else
            self.layer["lbl_name_"..i]:setString(ex.Tools:getLang(5067))
            self.layer["lbl_stage_name_"..i]:setString("")
            self.layer["node_fighting_"..i]:setVisible(false)
            self.layer["node_like_"..i]:setVisible(false)
        end
    end
    
    -- 显示自己和前三名
    local list = {}
    for i,v in ipairs(super_stage_data.vec_top_rank) do
        if v.rank > 3 then
            table.insert(list, v)
        end
    end
    table.sort(list, function(a, b)
        return a.rank < b.rank
    end)

    self.layer.scroll_view.createItemFunction = function(data)
        -- 创建ccbi cell
        local cell = SuperStageTopRankCell:createWithCCBIFile("ccbi/SuperStageTopRankCell.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(0.5, 0.5)
    
        cell:initData(data, self.layer_type)
        cell:setTableView(self.layer.scroll_view)
    
        cell.btn_photo:registerScriptTapHandler(handler(self, self.onPlayerInfo))
        cell.btn_like:registerScriptTapHandler(handler(self, self.onLike))

        return cell
    end

    self.layer.scroll_view:reloadData(list)
end

function SuperStageTopRankCtr:updateLike()
    if self.layer == nil then
        return
    end

    local super_stage_data = ex.Player.super_stage_data

    for i=1,3 do
        local data = super_stage_data.vec_top_rank[i]
        if data ~= nil then
            local config_stage = cfg.superstage.superstage[data.stage_id]
            if config_stage == nil then
                config_stage = cfg.superstage.superstage[1]
            end

            self.layer["lbl_like"..i]:setString(data.like)
            self.layer["lbl_stage_name_"..i]:setString(ex.Tools:getLang(config_stage.name_lang))

            local is_limit = super_stage_data:isLimitLike()
            local is_like = super_stage_data:isLike(data.rid)
            ex.Tools:setGrayAuto(self.layer["btn_like"..i]:getNormalImage(), is_like)
            self.layer["btn_like"..i]:setEnabled(not is_like)

            ex.Tools:addRedPoint(self.layer["btn_like"..i], not is_like and not is_limit, cc.p(0.75, 0.75))
        end
    end

    local vec_children = self.layer.scroll_view.menu:getChildren()
    for k,v in pairs(vec_children) do
        for i,v2 in ipairs(super_stage_data.vec_top_rank) do
            if v2.rid == v.data.rid then
                v.data.like = v2.like
                v.lbl_like:setString(string.format("%d", v2.like))

                local is_limit = super_stage_data:isLimitLike()
                local is_like = super_stage_data:isLike(v2.rid)
                ex.Tools:setGrayAuto(v.btn_like:getNormalImage(), is_like)
                v.btn_like:setEnabled(not is_like)

                ex.Tools:addRedPoint(v.btn_like, not is_like and not is_limit)
            end
        end
    end
end

function SuperStageTopRankCtr:onPlayerInfo(tag, pSender)
    ex.Tools:showPlayerInfo(pSender.role_id, pSender.player_server_id)
end

function SuperStageTopRankCtr:onLike(tag, pSender)
    if ex.Player.super_stage_data:isLike(pSender.rid) then
        return
    end

    if ex.Player.super_stage_data:isLimitLike() then
        ex.MessageView:add(ex.Tools:getLang(70768))
        return
    end

    if ex.Player.super_stage_data.pinnacle_stage == 5 then
        local req_like = Pinnacle_pb.GReqPreliminariesLike()
        req_like.rid = pSender.rid
        NetManager:sendMessage(ProtocolID.GReqPreliminariesLike, req_like)
    else
        local req_like = Pinnacle_pb.GReqPinnacleLike()
        req_like.rid = pSender.rid
        NetManager:sendMessage(ProtocolID.GReqPinnacleLike, req_like)
    end
end

return SuperStageTopRankCtr
