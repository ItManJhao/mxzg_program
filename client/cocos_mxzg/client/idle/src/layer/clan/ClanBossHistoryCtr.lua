local ClanBossHistoryCtr = class("ClanBossHistoryCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ClanBossHistoryLayer = class("ClanBossHistoryLayer", require("src.comp.EventLayerAdaptiveWidth"))

local ClanBossHistoryCell = class("ClanBossHistoryCell", require("src.comp.LuaLayerBase"))

function ClanBossHistoryCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.menu:setSwallowsTouches(true)
    self.btn_photo:setContentSize(self.spr_photo:getContentSize())

    self.btn_share:registerScriptTapHandler(handler(self, self.onShare))
end

function ClanBossHistoryCell:onShare(tag,pSender)
    local pos = {}
    local x,y = pSender:getPosition()
	local world_pos = pSender:getParent():convertToWorldSpace(cc.p(x,y)) -- pSender:convertToWorldSpace(cc.p(x,y)) -- pSender:getPosition()
	pos.x = world_pos.x - pSender:getContentSize().width / 2
    pos.y = world_pos.y - pSender:getContentSize().height / 2
	local ctr = require("src.layer.heroinfo.HeroShareMenuCtr"):instance()--:openWindow(pos)
	local callback = handler(self,self.onShareMenuClick)
	ctr:openWindow(callback)
    -- ctr.layer:setPosition(pos.x,pos.y)
	local pos_x = pos.x - ctr.layer:getContentSize().width
    local pos_y = pos.y - ctr.layer:getContentSize().height / 2 + pSender:getContentSize().height / 2
    ctr.layer:setPosition(pos_x,pos_y)
    print(self.__cname,pos_x,pos_y)
    -- for i=1,3 do
    --     local btn = ctr.layer["btn_" .. i]
    --     btn:registerScriptTapHandler(callback)
    -- end
end

function ClanBossHistoryCell:onShareMenuClick(tag,pSender)
    
end

function ClanBossHistoryCell:initData(data)
    self.data = data
    self.btn_photo.role_id = data.rid
    self.btn_photo.server_id = data.server_id
    self.btn_report.battle_id = data.battle_id

    -- self.spr_photo:setSpriteFrame(string.format("head-icon/%d.png", data.head_id))
    -- self.spr_frame:setSpriteFrame(ex.Tools:getBorderIconByIdx(data.border_id))
    ex.Tools:setSpriteFrame(self.spr_photo, string.format("head-icon/%d.png", data.head_id))
    ex.Tools:setSpriteFrame(self.spr_frame, ex.Tools:getBorderIconByIdx(data.border_id))

    self.lbl_name:setString(data.nick)
    self.lbl_server_name:setString(ex.StringUtil.getServerName(data.server_id))
    self.lbl_fighting:setString(data.strength)
    self.lbl_level:setString(data.level)

    ex.Tools:setSpriteFrame(self.spr_result, string.format("clan-boss-lang/spr-rob-%d.png", (data.type - 1) * 2 + data.win))

    -- self.spr_result:setSpriteFrame(string.format("clan-boss-lang/spr-rob-%d.png", (data.type - 1) * 2 + data.win))
    
    self.spr_cell_bg:setVisible(data.win == 1)
    self.lbl_time:setString(os.date("%Y-%m-%d %H:%M:%S", ex.Tools:getTimeWithUTC(data.time)))
    if data.delta == 0 then
        self.lbl_point:setString(ex.Tools:getLang(47371))
    elseif data.win == 1 then
        self.lbl_point:setString(ex.Tools:getLang(52205).." +"..data.delta)
    else
        self.lbl_point:setString(ex.Tools:getLang(52205).." -"..data.delta)
    end
end

function ClanBossHistoryLayer:onCreate()
    self:setAutoClose(true)
    self:setSwallowTouches(true)
    self:addBlackBackground()

    -- self.lbl_rank:enableOutline(ex.c3b.BLACK, 1)

    self.scroll_view:setItemSize(cc.size(self.scroll_view:getViewSize().width, 155))
    self.scroll_view:setItemType(1)
    self.scroll_view:setCreateNum(2)
end

-----------------------------------------------------------------------------
function ClanBossHistoryCtr:onCreate()
    self:setCCBIPath("ccbi/ClanBossHistoryLayer.ccbi")
    self:setIsSingle(false)
end

function ClanBossHistoryCtr:getLayerClass()
    return ClanBossHistoryLayer
end

function ClanBossHistoryCtr:getClanBossHistoryLayer()
    return self.layer
end

function ClanBossHistoryCtr:openWindow()
    if self:isOpened() then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/clan.plist")
    sfc:addSpriteFrames("ccbi-res/clan-boss.plist")

    self:loadLayer()
    self:open()
    self:initData()
end

function ClanBossHistoryCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    NetManager:sendMessage(ProtocolID.GReqScanRobHis)

    self:updateTableView()
end

function ClanBossHistoryCtr:updateLayer()
    if self.layer == nil then
        return
    end

    NetManager:sendMessage(ProtocolID.GReqReadNewRecord)

    self:updateTableView()
end

function ClanBossHistoryCtr:updateTableView()
    self.layer.scroll_view.createItemFunction = function(data, scale)
        -- 创建ccbi cell
        local cell_rank = ClanBossHistoryCell:createWithCCBIFile("ccbi/ClanBossHistoryCell.ccbi")
        cell_rank:setIgnoreAnchorPointForPosition(false)
        cell_rank:setAnchorPoint(0.5, 0.5)

        -- 2.1版本才有战斗分享
        cell_rank.btn_share:setVisible(false)

        cell_rank:initData(data)
        cell_rank.menu:setIsTouchInsideNode(self.layer.scroll_view)
        cell_rank.btn_photo:registerScriptTapHandler(handler(self, self.onPlayerInfo))
        cell_rank.btn_report:registerScriptTapHandler(handler(self, self.onRecord))
        return cell_rank
    end
    self.layer.scroll_view:reloadData(ex.Player.clan_data.clan_boss_history_list)
    -- local data = {}
    -- for i=1,10 do
    --     table.insert(data,i)
    -- end
    -- self.layer.scroll_view:reloadData(data)
end

-- 查看角色信息
function ClanBossHistoryCtr:onPlayerInfo(tag, pSender)
    ex.Tools:showPlayerInfo(pSender.role_id, pSender.server_id)
end

-- 开始挑战
function ClanBossHistoryCtr:onRecord(tag, pSender)
    ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_BOSS_ON_BATTLE, pSender.battle_id)

    self:closeWindow(0, nil)
end

return ClanBossHistoryCtr
