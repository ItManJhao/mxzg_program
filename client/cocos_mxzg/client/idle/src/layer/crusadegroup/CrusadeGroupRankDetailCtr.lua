local CrusadeGroupRankDetailCtr = class("CrusadeGroupRankDetailCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local CrusadeGroupRankDetailLayer = class("CrusadeGroupRankDetailLayer", require("src.comp.EventLayerAdaptiveWidth"))

local CrusadeGroupRankDetailCell = class("CrusadeGroupRankDetailCell", require("src.comp.LuaLayerBase"))

-----------------------------------------------------------------------------
function CrusadeGroupRankDetailCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.btn_photo:setContentSize(self.spr_photo:getContentSize())
end

function CrusadeGroupRankDetailCell:setTableView(table_view)
    self.menu:setIsTouchInsideNode(table_view)
    self.menu:setSwallowsTouches(false)
end

function CrusadeGroupRankDetailCell:initData(data, cell_type)
    if data == nil or data.rank == nil then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/clan-photo.plist")

    self.btn_photo.role_id = data.player_id
    self.btn_photo.player_server_id = data.server_id

    if ((data.player_id ~= nil and 
        data.player_id > 0 and 
        data.player_id == ex.Player.role_id) or
        (data.clan_id ~= nil and 
         data.clan_id > 0 and 
         data.clan_id == ex.Player.clan_data.clan_id)) and
        data.server_id ~= nil and 
        data.server_id == cc.UserDefault:getInstance():getIntegerForKey("server_id", -1) then
        
        self.spr_cell_bg:setVisible(false)
    end
    
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

    if cell_type == 1 then
        self.lbl_num_tip:setString(ex.Tools:getLang(77753))
        self.lbl_num:setString(string.format("%d", data.shenBinJh))
    else
        self.lbl_num_tip:setString(ex.Tools:getLang(77754))
        self.lbl_num:setString(string.format("%d", data.bossHurt))
    end
    self.lbl_num:setPositionX(self.lbl_num_tip:getPositionX() + self.lbl_num_tip:getContentSize().width * self.lbl_num_tip:getScaleX() + 10)

    ex.Tools:setSpriteFrame(self.spr_photo, string.format("head-icon/%d.png", data.headId))
    ex.Tools:setSpriteFrame(self.spr_frame, ex.Tools:getBorderIconByIdx(data.borderId))
    self.lbl_name:setString(data.name)
    self.lbl_server:setPositionX(self.lbl_name:getPositionX() + self.lbl_name:getContentSize().width * self.lbl_name:getScaleX() + 10)
    self.lbl_server:setString(ex.StringUtil.getServerName(data.server_id))
end


-----------------------------------------------------------------------------
function CrusadeGroupRankDetailLayer:onCreate()
    self:addBlackBackground()
    
    self.scroll_view:setItemSize(cc.size(544,115))
    self.scroll_view:setItemType(1)
end


-----------------------------------------------------------------------------
function CrusadeGroupRankDetailCtr:onCreate()
    self:setCCBIPath("ccbi/CrusadeGroupRankDetailLayer.ccbi")
    self:setIsSingle(false)
end

function CrusadeGroupRankDetailCtr:getLayerClass()
    return CrusadeGroupRankDetailLayer
end

function CrusadeGroupRankDetailCtr:openWindow(group_id, layer_type)
    if self:isOpened() then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/crusade-group.plist")
    sfc:addSpriteFrames("ccbi-res/rank.plist")
    sfc:addSpriteFrames("ccbi-res/clan-photo.plist")

    self.layer_type = layer_type
    self.group_id = group_id

    self:loadLayer()
    self:open()
    self:initData()
end

function CrusadeGroupRankDetailCtr:initData()
    self.layer:addEvent(EVENT.RANK_EVENT.UPDATE_RANK_TOP_LAYER, handler(self, self.updateTableView))

    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    self.layer.cell_self = CrusadeGroupRankDetailCell:createWithCCBIFile("ccbi/CrusadeGroupRankDetailCell.ccbi")
    self.layer.cell_self:setPosition(10, 5)
    self.layer.cell_self:setAnchorPoint(0, 0)
    self.layer.spr_rank_bg_self:addChild(self.layer.cell_self)

    self:updateTableView()

    ex.Player.rank_data:onRefreshCrusadeMemberRank(self.group_id, self.layer_type)
end

function CrusadeGroupRankDetailCtr:updateTableView()
    if not self:getLayer() then
        return
    end

    -- 显示自己和前三名
    local data_self = nil
    local list = nil
    if self.layer_type == 1 then
        list = ex.Player.rank_data.rank_crusade_member_res_list
        data_self = ex.Player.rank_data.rank_crusade_member_res_self
    else
        list = ex.Player.rank_data.rank_crusade_member_damage_list
        data_self = ex.Player.rank_data.rank_crusade_member_damage_self
    end

    self.layer.cell_self:initData(data_self, self.layer_type)

    self.layer.scroll_view:getContainer():removeAllChildren()
    self.layer.scroll_view.createItemFunction = function(data)
        -- 创建ccbi cell
        local cell = CrusadeGroupRankDetailCell:createWithCCBIFile("ccbi/CrusadeGroupRankDetailCell.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(0.5, 0.5)
    
        cell:initData(data, self.layer_type)
        cell:setTableView(self.layer.scroll_view)
    
        cell.btn_photo:registerScriptTapHandler(handler(self, self.onPlayerInfo))

        return cell
    end

    self.layer.scroll_view:reloadData(list)
end

function CrusadeGroupRankDetailCtr:onPlayerInfo(tag, pSender)
    ex.Tools:showPlayerInfo(pSender.role_id, pSender.player_server_id)
end

return CrusadeGroupRankDetailCtr
