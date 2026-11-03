local TeamArenaBattleLayer = class("TeamArenaBattleLayer", require("src.comp.EventLayerAdaptiveWidth"))
local TeamArenaBattleCtr = class("TeamArenaBattleCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local TeamArenaBattleCell = class("TeamArenaBattleCell", require("src.comp.EventLayer"))


-----------------------------------------------------------------------------
function TeamArenaBattleCell:onCreate()

    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.shoe_has_role_list = {}
    self.shoe_no_role_list = {}
    self.spr_photo_list = {}
    self.btn_photo_list = {}
    self.lbl_role_level_list = {}
    self.spr_frame_list = {}
    -- 注册信息
    for i=1,3 do
        table.insert( self.shoe_has_role_list,  self["shoe_has_role_"..i])
        table.insert( self.shoe_no_role_list,  self["shoe_no_role_"..i])
        table.insert( self.spr_photo_list,  self["spr_photo_"..i])
        table.insert( self.btn_photo_list,  self["btn_photo_"..i])
        table.insert( self.lbl_role_level_list,  self["lbl_role_level_"..i])
        table.insert( self.spr_frame_list,  self["spr_frame_"..i])
        self.btn_photo_list[i]:registerScriptTapHandler(handler(self, self.onPlayerInfo))
    end

    self.btn_battle:setLabelText(ex.Tools:getLang(74415))
    self.btn_battle:registerScriptTapHandler(handler(self, self.onBtnBattle))
end 

function TeamArenaBattleCell:onBtnBattle( tag, pSender)

    -- fasong zhandou xieyi 
    local req = TeamArena_pb.GReqTeamArenaBattle()
	req.defend_team_id = self.team_data.team_id
    NetManager:sendMessage(ProtocolID.GReqTeamArenaBattle, req)     

    ex.Player.team_arena_data.cur_battle_team_id = self.team_data.team_id
    -- tongzhji zhujiemian 
	ex.EventManager:fire(EVENT.TEAM_AEENA_INFO_EVENT.CREATE_TEAM_ARENA_BATTLE)


    NetManager:sendMessage(ProtocolID.GReqTeamArenaData) -- 组队竞技场数据

    
end


function TeamArenaBattleCell:initDone(team_data,  scroll_view)
    self.team_data = team_data
    self.lbl_teamname:setString(team_data.team_name)
    self.lbl_sorce:setString(team_data.score)
    self.lbl_fight:setString(team_data.fighting)  

    self.lbl_sorce_bg:setString(ex.Tools:getLang(74017))

    for i=1,3 do
        if team_data.member[i] then 

            self.shoe_has_role_list[i]:setVisible(true)
            self.shoe_no_role_list[i]:setVisible(false)
            self.lbl_role_level_list[i]:setString(team_data.member[i].member.level)
            self.spr_photo_list[i]:setSpriteFrame(string.format("head-icon/%d.png", team_data.member[i].member.head_id))
            ex.Tools:setSpriteFrame(self.spr_frame_list[i], ex.Tools:getBorderIconByIdx(team_data.member[i].member.border_id))            

            self.btn_photo_list[i]:setContentSize(self.spr_photo_list[i]:getContentSize())
            self.btn_photo_list[i]:setTag(i)  
        else 
            self.shoe_has_role_list[i]:setVisible(false)
            self.shoe_no_role_list[i]:setVisible(true)
        end 
    end
end 

function TeamArenaBattleCell:onPlayerInfo(tag, pSender)

    if self.team_data.member[tag].hidden == true  then 
        ex.Tools:showTeamArenaPlayerInfo(0, self.team_data.member[tag].member.server_id)
        return 
    end 
    ex.Tools:showTeamArenaPlayerInfo(self.team_data.member[tag].member.player_id, self.team_data.member[tag].member.server_id)


    -- ex.Tools:showTeamArenaPlayerInfo(tag, cc.UserDefault:getInstance():getIntegerForKey("server_id"))
end



-----------------------------------------------------------------------------
function TeamArenaBattleLayer:onCreate()

    self:setAutoClose(true)
    self:setSwallowTouches(false)
    self:addBlackBackground()

    self.btn_done:registerScriptTapHandler(handler(self, self.onDone))

    -- 发送拉起数据协议
    self:sendMessageData()
    self.lbl_title:setString(ex.Tools:getLang(74415))

    self.btn_done:setLabelText(ex.Tools:getLang(74416))
    self.btn_done:setLabelColor(FONT_BROWN)

    local viewSize = cc.size(self.spr_list_bg:getContentSize().width, self.spr_list_bg:getContentSize().height - 20 )

    self.scroll_view = cc.ScrollView:create(viewSize)
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    :setPosition(self.spr_list_bg:getPositionX() + 2, self.spr_list_bg:getPositionY() + 10)
    self:addChild(self.scroll_view)


    -- local show_list = {}
    -- table.insert( show_list, {})
    -- table.insert( show_list, {})
    -- table.insert( show_list, {})
    -- table.insert( show_list, {})
    -- self:showList( show_list)

end 

function TeamArenaBattleLayer:onDone(tag,pSender)
    self:sendMessageData( )
end

function TeamArenaBattleLayer:sendMessageData( )
    
    NetManager:sendMessage(ProtocolID.GReqTeamArenaRefreshDefend)     
end


function TeamArenaBattleLayer:showList(data )
    
    self.scroll_view:getContainer():removeAllChildren()

    self.cellList = {}
    local index = 0
    for i,v in ipairs(data) do
        local task_node = self:addCell(v)
        task_node:setName("task_cell" .. index)
        self.scroll_view:addChild(task_node)
        table.insert(self.cellList, task_node)
        index = index + 1
    end


    -- 排序顺序 已完成 可以接取 正在进行
    -- table.sort(self.cellList, function(a, b)
    --     return a.reward_id < b.reward_id
    -- end)

    local viewSize = self.scroll_view:getViewSize()
    --cc.size(480, 150)
    local item_size = TeamArenaBattleCell:createWithCCBIFile("ccbi/TeamArenaBattleCell.ccbi"):getContentSize()
    item_size.height = item_size.height + 5

    -- 调整ScrollView
    local cont_height = item_size.height * table.nums(self.cellList)
    cont_height = math.max(cont_height , viewSize.height)

    self.scroll_view:setContentSize(cc.size(viewSize.width, cont_height))
    self.scroll_view:setContentOffset(cc.p(0, viewSize.height - cont_height))


    -- 按排好的顺序显示
    local start = cc.p(viewSize.width * 0.5 - 2, cont_height - item_size.height * 0.5)

    for i,v in ipairs(self.cellList) do
        v:setPosition(start.x, start.y - (i - 1) * item_size.height)
    end

end 


function TeamArenaBattleLayer:addCell( v )
    local cell = TeamArenaBattleCell:createWithCCBIFile("ccbi/TeamArenaBattleCell.ccbi")
	cell:setSwallowTouches(false)
	cell:setIgnoreAnchorPointForPosition(false)
    cell:setAnchorPoint(ex.a.center)
    cell:initDone(v, self.scroll_view)
    return cell
end





-----------------------------------------------------------------------------
function TeamArenaBattleCtr:onCreate()
	self:setCCBIPath("ccbi/TeamArenaBattleLayer.ccbi")
	self:setIsSingle(false)
end

function TeamArenaBattleCtr:getLayerClass()
	return TeamArenaBattleLayer
end

function TeamArenaBattleCtr:getTeamArenaBattleLayer()
	return self.layer
end


function TeamArenaBattleCtr:openWindow()
	if self:isOpened() then
		return
	end
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/team-arena.plist")

	self:loadLayer()
	self:open()
    self:initData()
    
end

function TeamArenaBattleCtr:showTeamList(data)
    if self.layer == nil then
        return
    end

    self.layer:showList(data)
end


function TeamArenaBattleCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
end


return TeamArenaBattleCtr