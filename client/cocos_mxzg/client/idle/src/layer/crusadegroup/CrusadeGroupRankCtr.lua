local CrusadeGroupRankCtr = class("CrusadeGroupRankCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local CrusadeGroupRankLayer = class("CrusadeGroupRankLayer", require("src.comp.EventLayerAdaptiveWidth"))

local CrusadeGroupRankCell = class("CrusadeGroupRankCell", require("src.comp.LuaLayerBase"))

-----------------------------------------------------------------------------
function CrusadeGroupRankCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end

function CrusadeGroupRankCell:setTableView(table_view)
    self.menu:setIsTouchInsideNode(table_view)
    self.menu:setSwallowsTouches(false)
end

function CrusadeGroupRankCell:initData(data, cell_type)
    if data == nil or data.rank == nil then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/clan-photo.plist")

    self.btn_rank.group_id = data.cg_id

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

    ex.Tools:setSpriteFrame(self.spr_photo, string.format("clan-photo/%d.png", data.emblem))
    self.lbl_name:setString(data.cg_name)
end


-----------------------------------------------------------------------------
function CrusadeGroupRankLayer:onCreate()
    self:addBlackBackground()

    self.btn_tab_1:setLabelText(ex.Tools:getLang(77752))
    self.btn_tab_2:setLabelText(ex.Tools:getLang(77751))
    
    self.scroll_view:setItemSize(cc.size(544,115))
    self.scroll_view:setItemType(1)
end


-----------------------------------------------------------------------------
function CrusadeGroupRankCtr:onCreate()
    self:setCCBIPath("ccbi/CrusadeGroupRankLayer.ccbi")
    self:setIsSingle(false)
end

function CrusadeGroupRankCtr:getLayerClass()
    return CrusadeGroupRankLayer
end

function CrusadeGroupRankCtr:openWindow()
    if self:isOpened() then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/crusade-group.plist")
    sfc:addSpriteFrames("ccbi-res/rank.plist")
    sfc:addSpriteFrames("ccbi-res/clan-photo.plist")

    self.layer_type = 1

    self:loadLayer()
    self:open()
    self:initData()
end

function CrusadeGroupRankCtr:initData()
    self.layer:addEvent(EVENT.RANK_EVENT.UPDATE_RANK_TOP_LAYER, handler(self, self.updateTableView))

    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    self.layer.btn_tab_1:registerScriptTapHandler(handler(self, self.onTab))
    self.layer.btn_tab_2:registerScriptTapHandler(handler(self, self.onTab))

    self.layer.btn_tab_1:setChecked(true)

    self.layer.cell_self = CrusadeGroupRankCell:createWithCCBIFile("ccbi/CrusadeGroupRankCell.ccbi")
    self.layer.cell_self:setPosition(10, 5)
    self.layer.cell_self:setAnchorPoint(0, 0)
    self.layer.spr_rank_bg_self:addChild(self.layer.cell_self)

    self:updateTableView()

    ex.Player.rank_data:onRefreshCrusadeGroupRank(ctr.crusade_group.data.game_data.crusade_group_info.group_id)
end

function CrusadeGroupRankCtr:updateTableView()
    if not self:getLayer() then
        return
    end

    -- 显示自己和前三名
    local data_self = nil
    local list = nil
    if self.layer_type == 1 then
        list = ex.Player.rank_data.rank_crusade_group_res_list
        data_self = ex.Player.rank_data.rank_crusade_group_res_self
    else
        list = ex.Player.rank_data.rank_crusade_group_damage_list
        data_self = ex.Player.rank_data.rank_crusade_group_damage_self
    end

    self.layer.cell_self:initData(data_self, self.layer_type)
    self.layer.cell_self.btn_rank:registerScriptTapHandler(handler(self, self.onRank))

    self.layer.scroll_view:getContainer():removeAllChildren()
    self.layer.scroll_view.createItemFunction = function(data)
        -- 创建ccbi cell
        local cell = CrusadeGroupRankCell:createWithCCBIFile("ccbi/CrusadeGroupRankCell.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(0.5, 0.5)
    
        cell:initData(data, self.layer_type)
        cell:setTableView(self.layer.scroll_view)

        cell.btn_rank:registerScriptTapHandler(handler(self, self.onRank))
    
        return cell
    end

    self.layer.scroll_view:reloadData(list)
end

function CrusadeGroupRankCtr:onTab(tag, pSender)
    if self.layer_type == tag then
        return
    end

    self.layer_type = tag

    self:updateTableView()
end

function CrusadeGroupRankCtr:onRank(tag, pSender)
    require("src.layer.crusadegroup.CrusadeGroupRankDetailCtr"):instance():openWindow(pSender.group_id, self.layer_type)
end

return CrusadeGroupRankCtr
