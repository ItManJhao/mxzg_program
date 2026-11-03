local MagicTowerLogCtr = class('MagicTowerLogCtr', require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local MagicTowerLogLayer = class('MagicTowerLogLayer', require("src.layer.ui.UI_MagicTowerLogLayer"))
local MagicTowerLogCell = class("MagicTowerLogCell", require("src.layer.ui.UI_MagicTowerLogCell"))

function MagicTowerLogCell:onCreate()
    self.super.onCreate(self)
	self:setName("MagicTowerLogCell")

    self:setAnchorPoint(cc.p(0, 0.5))
    self:setIgnoreAnchorPointForPosition(false)
end

function MagicTowerLogCell:resetData(data, type)
    if data == nil or data.rid <= 0 then
        self:setVisible(false)
        return
    end

    self.data = data

    if type == 1 then
        ex.Tools:setSpriteFrame(self.spr_rare, "other/mission-rare-5.png")
        self.lbl_rare_tip:setString(ex.Tools:getLang(5178))
        self.btn_share:setVisible(false)

        self.lbl_content:setString(ex.Tools:getLang(5073)..ex.StringUtil.convertToTimeFormat(data.lowest_time, 4))
    elseif type == 2 then
        ex.Tools:setSpriteFrame(self.spr_rare, "other/mission-rare-2.png")
        self.lbl_rare_tip:setString(ex.Tools:getLang(47673))
        self.btn_share:setVisible(false)

        self.lbl_content:setString(ex.Tools:getLang(5574)..data.lowest_power)
    else
        self.spr_cell_bg_self:setVisible(true)
        self.node_tip:setVisible(false)

        self.lbl_content:setString(ex.Tools:getLang(5073)..ex.StringUtil.convertToTimeFormat(data.lowest_time, 4))
    end

    ex.Tools:setSpriteFrame(self.spr_border, ex.Tools:getBorderIconByIdx(data.broad_id or 0))
    ex.Tools:setSpriteFrame(self.spr_photo, string.format("head-icon/%d.png", data.head_id))

    self.lbl_name:setString(ex.StringUtil.getServerName(data.server_id)..data.name)
end

function MagicTowerLogCell:setBattleCallback(callback)
    self.callback = callback
end

function MagicTowerLogCell:onBattle(tag, pSender)
    if self.callback == nil then
        return
    end

    self.callback(self.data.server_id, self.data.battle_id)
end

function MagicTowerLogCell:onBattleShare()
    local pos = {}
    local x,y = self.btn_share:getPosition()
	local world_pos = self:getParent():convertToWorldSpace(cc.p(x,y)) -- pSender:convertToWorldSpace(cc.p(x,y)) -- pSender:getPosition()
	pos.x = world_pos.x - self:getContentSize().width / 2
    pos.y = world_pos.y - self:getContentSize().height / 2
	local ctr = require("src.layer.heroinfo.HeroShareMenuCtr"):instance()--:openWindow(pos)
	local callback = handler(self,self.onShareMenuClick)
	ctr:openWindow(callback)
    -- ctr.layer:setPosition(pos.x,pos.y)
    print(ctr.layer:getContentSize().width, ctr.layer:getContentSize().height)
	local pos_x = pos.x - ctr.layer:getContentSize().width + self:getContentSize().width / 2
    local pos_y = pos.y - ctr.layer:getContentSize().height + self:getContentSize().height / 2
    ctr.layer:setPosition(pos_x,pos_y)
end

function MagicTowerLogCell:onShareMenuClick(tag, pSender)
    if tag == 3 and ex.Player.clan_data.clan_id <= 0  then 
        ex.MessageView:add(ex.Tools:getLang(73024))
    end

    local req = Video_pb.GReqBattleShare()
    req.battleId = self.data.battle_id
    req.channel = tag
    NetManager:sendMessage(ProtocolID.GReqBattleShare,req)
    ex.MessageView:add(ex.Tools:getLang(73023))
end

-----------------------------------------------------------------------------
function MagicTowerLogLayer:onCreate()
	self.super.onCreate(self)
	self:setName("MagicTowerLogLayer")

    self:addBlackBackground()

    self.cell_time = MagicTowerLogCell:create()
    self.cell_time:setPosition(0, 320)
    self.cell_time:setBattleCallback(handler(self, self.onBattle))
    self.node_content:addChild(self.cell_time)

    self.cell_attack = MagicTowerLogCell:create()
    self.cell_attack:setPosition(0, 190)
    self.cell_attack:setBattleCallback(handler(self, self.onBattle))
    self.node_content:addChild(self.cell_attack)

    self.cell_self = MagicTowerLogCell:create()
    self.cell_self:setPosition(0, 60)
    self.cell_self:setBattleCallback(handler(self, self.onBattle))
    self.node_content:addChild(self.cell_self)
end

function MagicTowerLogLayer:updateLayer()
    self.cell_time:resetData(ex.Player.magic_tower_data.stage_log.fast_pass, 1)
    self.cell_attack:resetData(ex.Player.magic_tower_data.stage_log.min_fighting_pass, 2)
    self.cell_self:resetData(ex.Player.magic_tower_data.stage_log.self, 3)
end

function MagicTowerLogLayer:onBattle(server_id, battle_id)
    if self.callback ~= nil then
        self.callback(server_id, battle_id)

        self:onClose()
    end
end

-----------------------------------------------------------------------------
function MagicTowerLogCtr:loadLayer()
	local tmp_layer = MagicTowerLogLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function MagicTowerLogCtr:openWindow(callback)
    if self:isOpened() then
        return
    end
    
    self:loadLayer()
    self:open()
    self:initData(callback)
end

function MagicTowerLogCtr:initData(callback)
    self.layer.callback = callback
    self.layer:updateLayer()
end

return MagicTowerLogCtr
