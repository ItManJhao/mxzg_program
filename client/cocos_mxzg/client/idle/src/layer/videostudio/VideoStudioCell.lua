local VideoStudioCell = class("VideoStudioCell", require("src.comp.EventLayer"))
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

function VideoStudioCell:onCreate()
    self.my_list = {}
    self.enemy_list = {}
    self.btn_info1 = cpp.UIMenuItemImage:createWithSpriteFrameName(nil, nil, nil)
    self.btn_info2 = cpp.UIMenuItemImage:createWithSpriteFrameName(nil, nil, nil)
    self.btn_menu:addChild(self.btn_info1)
    self.btn_menu:addChild(self.btn_info2)

    local x,y = self.spr_frame1:getParent():getPosition()
    -- local pos = self.spr_frame1:getParent():convertToWorldSpace(cc.p(x,y))
    self.btn_info1:setPosition(x,y)
    self.btn_info1:setTag(1)
    local size = self.spr_frame1:getContentSize()
    self.btn_info1:setContentSize(size)

    x,y = self.spr_frame2:getParent():getPosition()
    self.btn_info2:setPosition(x,y)
    self.btn_info2:setTag(2)
    size = self.spr_frame2:getContentSize()
    self.btn_info2:setContentSize(size)
    
    self:registerBtnEvent()
end

function VideoStudioCell:setTableView(table)
    self.tableView = table
    self.btn_menu:setIsTouchInsideNode(self.tableView)
    self.btn_menu:setSwallowsTouches(false)
end

function VideoStudioCell:registerBtnEvent( )
    self.btn_playback:registerScriptTapHandler(handler(self, self.onPlayBack))
    self.btn_share:registerScriptTapHandler(handler(self, self.onShare))
    self.btn_data:registerScriptTapHandler(handler(self, self.onData))
    self.btn_saved:registerScriptTapHandler(handler(self, self.onSaved))
    self.btn_cannel:registerScriptTapHandler(handler(self, self.onCannel))
    self.btn_info1:registerScriptTapHandler(handler(self, self.onInfo))
    self.btn_info2:registerScriptTapHandler(handler(self, self.onInfo))
end

function VideoStudioCell:onInfo( tag,pSender )
    print(self.__cname,tag)
    local rid = tag == 1 and self.data.battle_log.attacker_log.rid or self.data.battle_log.defender_log.rid
    local server_id = tag == 1 and self.data.battle_log.attacker_log.serverId or self.data.battle_log.defender_log.serverId

    ex.Tools:showPlayerInfo(rid, server_id)
end

function VideoStudioCell:onPlayBack( tag,pSender )
    local data = {}
    data.battle_id = self.data.battle_log.battleId
    data.type = EVENT.VIDEO_STUDIO_EVENT.VIDEO_PLAY_BACK
    ex.EventManager:fire(EVENT.VIDEO_STUDIO_EVENT.VIDEO_PLAY_BACK_REQ,data)
end

function VideoStudioCell:onCannel( tag,pSender )
    local req = Video_pb.GReqDeleteFavorite()
    req.keep_id = self.data.keep_id
	NetManager:sendMessage(ProtocolID.GReqDeleteFavorite,req)
end

function VideoStudioCell:onShare( tag,pSender )
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

function VideoStudioCell:onShareMenuClick( tag,pSender )
    if tag == 3 and ex.Player.clan_data.clan_id <= 0  then 
        ex.MessageView:add(ex.Tools:getLang(73024))
    end

    local can_share = ex.Player.video_studio_data:canShare()
    if not can_share then 
        ex.MessageView:add(string.format(ex.Tools:getLang(73026),ex.Player.video_studio_data:getDelayTime()))
        return 
    end
    local req = Video_pb.GReqVideoShare()
    local video_data = ex.Player.video_studio_data:getMyVideos()
    req.type = video_data.kind == 2 and 2 or 1 --self.data.type
    req.id = self.data.id
    req.channel = tag
    NetManager:sendMessage(ProtocolID.GReqVideoShare,req)
    ex.MessageView:add(ex.Tools:getLang(73023))
    ex.Player.video_studio_data:addTimer()
end

function VideoStudioCell:onData( tag,pSender )
    require("src.layer.BattleDetailCtr"):instance():openWindow(self.data.battle_log)
end

function VideoStudioCell:onSaved( tag,pSender )
    local req = Video_pb.GReqKeepFavorite()
    -- local video_data = ex.Player.video_studio_data:getMyVideos()
    -- req.keep_type = video_data.kind == 1 and 2 or 1 --self.data.type
    req.keep_type = 1

    req.id = self.data.id
    -- print(self.__cname,"type",req.keep_type,"id",req.id)
    -- req.id = self.data.hall_id ~= 0 and self.data.hall_id or self.data.vid
	NetManager:sendMessage(ProtocolID.GReqKeepFavorite,req)
    
end

function VideoStudioCell:createMenuItem(idx, formation_id, hero_list)
    local node = self["node_list_"..idx]
    if node == nil then
        return
    end

	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/hero-select.plist")
    
    local menu = cpp.UIMenu:create()
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    :setName("menu_hero")
    node:addChild(menu)

    if formation_id <= 0 then formation_id = 1 end

    local config_matrix = cfg.battlematrixaddition.battlematrixaddition
    for pos=1,LineupNum do
        local is_open = false
        for _,matrix in pairs(config_matrix) do
            if matrix.type == formation_id and matrix.position == pos then
                is_open = matrix.is_open == 1
                break
            end
        end
  
        
        local item = nil
        if is_open == false then
            local sfc = cc.SpriteFrameCache:getInstance()
            sfc:addSpriteFrames("ccbi-res/hero-select.plist")
            
            item = cc.Sprite:createWithSpriteFrameName("hero-select/spr-lock.png")
            item:setScale(0.8)
            node:addChild(item)
        else
            item = UIMenuItemHero:createWithData()
            item:setEnableAction(false)
            item:setScale(0.6)
            menu:addChild(item)

            local hero_data = nil
            for _,tmp_data in pairs(hero_list) do
                if tmp_data.position == pos then
                    hero_data = tmp_data
                    break
                end
            end

            if hero_data ~= nil then
                item:reset(hero_data)
                if hero_data.fashion_id ~= 0 and hero_data.fashion_id ~= nil then   -- 有皮肤
                    item:setFashionShowForce(hero_data.fashion_id)
                end
            end
        end
        
        local pos_idx_x = pos > 4 and -1 or 1
        pos_idx_x = idx > 1 and -pos_idx_x or pos_idx_x
        local pos_idx_y = (pos > 4) and pos - 4 or pos
        item:setPosition(pos_idx_x * 0.5 * 65,
                        (2 - pos_idx_y + 0.5) * 65)
    end
end

function VideoStudioCell:refreshList(idx)
    local list = idx == 1 and self.my_list or self.enemy_list
    local data = idx == 1 and self.data.battle_log.attacker_log or self.data.battle_log.defender_log

    self:createMenuItem(idx, data.formation_id, data.hero_log)
    self:createMenuItem(idx, data.formation_id, data.hero_log)

    local lbl_name = self["lbl_name" .. idx]
    lbl_name:setString(data.name)
    local lbl_clan = self["lbl_clan" .. idx]
    lbl_clan:setString(ex.StringUtil.getServerName(data.serverId))
    local lbl_battle = self["lbl_battle" .. idx]
    lbl_battle:setString(data.fighting)
    local lbl_level = self["lbl_level" .. idx]
    lbl_level:setString(data.level)

    local spr_frame = self["spr_frame" .. idx]
    spr_frame:setSpriteFrame(ex.Tools:getBorderIconByIdx(data.border_id))

    local spr_photo = self["spr_photo" .. idx]
    spr_photo:setSpriteFrame(string.format("head-icon/%d.png", data.head_id))

    local spr_win = self["spr_win" .. idx]
    local path = self.data.battle_log.win_id == data.rid and "compare-share-lang/spr-win.png" or "compare-share-lang/spr-icon-fail.png"
    -- spr_win:setSpriteFrame(path)
    ex.Tools:setSpriteFrame(spr_win, path)
end

function VideoStudioCell:reset(data)
    if not data then return end
    self.data = data
    -- self.my_list = self.data.attacker_log
    -- self.enemy_list = self.data.defender_log

    self:refreshList(1)
    self:refreshList(2)
    
    local time = os.date("%Y-%m-%d %H:%M:%S", data.time)
    self.lbl_time:setString(time)
    local cur_type = data.subtype == 0 and data.type or data.subtype
    local str = ex.Tools:getLang(73001 + cur_type)
    self.lbl_type:setString(str)

    local is_favorite = data.keep_id ~= 0
    self.btn_saved:setVisible(not is_favorite)
    self.btn_cannel:setVisible(is_favorite)
end

function VideoStudioCell:resetSuperStageHistory(data)
    if not data then return end
    self.data = data
    -- self.my_list = self.data.attacker_log
    -- self.enemy_list = self.data.defender_log

    self:refreshList(1)
    self:refreshList(2)
    
    local time = os.date("%Y-%m-%d %H:%M:%S", data.time)
    self.lbl_time:setString(time)
    local cur_type = data.subtype == 0 and data.type or data.subtype
    local str = ex.Tools:getLang(73001 + cur_type)
    self.lbl_type:setString(str)

    self.btn_saved:setVisible(false)
    self.btn_cannel:setVisible(false)
    self.btn_share:setVisible(false)
end

return VideoStudioCell