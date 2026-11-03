local SuperStageRankCtr = class("SuperStageRankCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local SuperStageRankLayer = class("SuperStageRankLayer", require("src.comp.EventLayerAdaptiveWidth"))

local SuperStageRankCell = class("SuperStageRankCell", require("src.comp.LuaLayerBase"))
function SuperStageRankCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.btn_photo:setContentSize(self.spr_photo:getContentSize())
end

function SuperStageRankCell:setTableView(table_view)
    self.menu:setIsTouchInsideNode(table_view)
    self.menu:setSwallowsTouches(false)
end

function SuperStageRankCell:initData(data, cell_type)
    if data == nil or data.rank == nil then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/rank.plist")
    sfc:addSpriteFrames("ccbi-res/super-stage-icon.plist")

    self.btn_photo.role_id = data.player_id
    self.btn_photo.player_server_id = data.server_id

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
    self.lbl_score:setString(string.format("%s %d", ex.Tools:getLang(74820), data.elite_integral))

    self.lbl_name:setPositionX(self.lbl_server_name:getPositionX() + self.lbl_server_name:getContentSize().width * self.lbl_server_name:getScaleX() + 5)
end

-----------------------------------------------------------------------------
function SuperStageRankLayer:getAsynImage()
    local vec_image = {
    }
    return vec_image
end

function SuperStageRankLayer:onCreate()
    -- self:setAutoClose(false)
    self:addBlackBackground()
    
    self.scroll_view:setItemSize(cc.size(540, 135))
    self.scroll_view:setItemType(1)
end

-----------------------------------------------------------------------------
function SuperStageRankCtr:onCreate()
    self:setCCBIPath("ccbi/SuperStageRankLayer.ccbi")
    self:setIsSingle(false)
end

function SuperStageRankCtr:getLayerClass()
    return SuperStageRankLayer
end

function SuperStageRankCtr:openWindow()
    if self:isOpened() then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/rank.plist")

    self:loadLayer()
    self:open()
    self:initData()
end

function SuperStageRankCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    self.layer:addEvent(EVENT.SUPER_STAGE.RANK_INFO, handler(self, self.updateTableView))

    NetManager:sendMessage(ProtocolID.GReqRankInfo)

    self:updateTableView()
end

function SuperStageRankCtr:updateTableView()
    if not self:getLayer() then
        return
    end

    local super_stage_data = ex.Player.super_stage_data
    local config_stage = cfg.superstage.superstage[super_stage_data.cur_stage_id]
    if config_stage == nil then
        return
    end

    -- 更新我的排名
    if super_stage_data.rank <= 0 then
        self.layer.lbl_rank_self:setString(ex.Tools:getLang(74811)..ex.Tools:getLang(74812))
    else
        self.layer.lbl_rank_self:setString(ex.Tools:getLang(74811)..super_stage_data.rank)
    end
    -- 更新我的段位
    self.layer.lbl_stage_self:setString(ex.Tools:getLang(config_stage.name_lang))

    -- 显示前三名形象
    for i=1,3 do
        local data = super_stage_data.rank_list[i]
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

            self.layer["lbl_name_"..i]:setString(data.name)
            self.layer["lbl_stage_name_"..i]:setString(ex.Tools:getLang(cfg.superstage.superstage[data.stage_id].name_lang))
            self.layer["lbl_fighting_"..i]:setString(string.format("%d", data.fighting))
        else
            self.layer["lbl_name_"..i]:setString(ex.Tools:getLang(5067))
            self.layer["lbl_stage_name_"..i]:setString("")
            self.layer["lbl_fighting_"..i]:setString("--")
        end
    end
    
    -- 显示自己和前三名
    local list = {}
    for i,v in ipairs(super_stage_data.rank_list) do
        if v.rank > 3 then
            table.insert(list, v)
        end
    end
    table.sort(list, function(a, b)
        return a.rank < b.rank
    end)

    self.layer.scroll_view.createItemFunction = function(data)
        -- 创建ccbi cell
        local cell = SuperStageRankCell:createWithCCBIFile("ccbi/SuperStageRankCell.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(0.5, 0.5)
    
        cell:initData(data, self.layer_type)
        cell:setTableView(self.layer.scroll_view)
    
        cell.btn_photo:registerScriptTapHandler(handler(self, self.onPlayerInfo))

        return cell
    end

    self.layer.scroll_view:reloadData(list)
end

function SuperStageRankCtr:onPlayerInfo(tag, pSender)
    -- ex.Tools:showPlayerInfo(pSender.role_id, pSender.player_server_id)
end

return SuperStageRankCtr
