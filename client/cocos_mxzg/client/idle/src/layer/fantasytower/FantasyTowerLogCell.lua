local FantasyTowerLogCell = class("FantasyTowerLogCell", require("src.comp.LuaLayerBase"))

function FantasyTowerLogCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
end

function FantasyTowerLogCell:reset(data, index)
    if not data or data.battle_id == "" then
        return
    end

    self.data = data

    -- 刷新数据较小，放在这里避免占用缓存
    local vec_title = {
        {title = ex.Tools:getLang(47380), img = "mission-cell-bg/bg5.png", type = ex.Tools:getLang(47155), show = ex.StringUtil.convertToHowLongHour(data.duration / 1000)},
        {title = ex.Tools:getLang(47673), img = "mission-cell-bg/bg2.png", type = ex.Tools:getLang(47768), show = data.ability},
        {title = "", img = "", type = ex.Tools:getLang(47155), show = ex.StringUtil.convertToHowLongHour(data.duration / 1000)}
    }

    local title_data = vec_title[index]

    self.spr_ribbon:setVisible(title_data.title ~= "")
    self.lbl_title:setVisible(title_data.title ~= "")
    self.btn_share:setVisible(title_data.title == "")

    self.lbl_name:setString(data.role_name)
    self.lbl_type:setString(title_data.type)
    self.lbl_num:setString(title_data.show)
    self.lbl_title:setString(title_data.title)

    ex.Tools:setSpriteFrame(self.spr_ribbon, title_data.img)
    ex.Tools:setSpriteFrame(self.spr_head, string.format("head-icon/%d.png", data.head_id))
    ex.Tools:setSpriteFrame(self.spr_frame, ex.Tools:getBorderIconByIdx(data.border_id))

    if title_data.title == "" then
        local size = self.spr_bg10:getContentSize()
        self.spr_bg10:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("win-bg/block-bg-28.png"), cc.rect(15, 15, 15, 15))  
        -- ex.Tools:setSpriteFrame(self.spr_bg10, )
        self.spr_bg10:setContentSize(size)
    end
end

function FantasyTowerLogCell:onReport()
    require("src.layer.battle.BattleReportCtr"):instance():openWindow(self.data.battle_id, EVENT.TOWER_EVENT.TOWER_LOG_RRPORT, BattleType.TOWER)
    -- local req_bid = Champion_pb.GReqGetChampionBattle()
    -- req_bid.bid = self.bid--ex.Player.champion_data.guess.bid
    -- NetManager:sendMessage(ProtocolID.GReqGetChampionBattle, req_bid)
end

function FantasyTowerLogCell:onShare(tag, pSender)
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
end

function FantasyTowerLogCell:onShareMenuClick(tag, pSender)
    if tag == 3 and ex.Player.clan_data.clan_id <= 0  then 
        ex.MessageView:add(ex.Tools:getLang(73024))
    end

    local req = Video_pb.GReqBattleShare()
    req.battleId = self.data.battle_id
    req.channel = tag
    NetManager:sendMessage(ProtocolID.GReqBattleShare,req)
    ex.MessageView:add(ex.Tools:getLang(73023))
end


return FantasyTowerLogCell