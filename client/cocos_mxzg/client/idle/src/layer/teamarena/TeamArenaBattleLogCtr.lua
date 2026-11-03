-- 


local TeamArenaBattleLogLayer = class("TeamArenaBattleLogLayer", require("src.comp.EventLayerAdaptiveWidth"))
local TeamArenaBattleLogCtr = class("TeamArenaBattleLogCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local TeamArenaBattleLogCell = class("TeamArenaBattleLogCell", require("src.comp.EventLayer"))


-----------------------------------------------------------------------------
function TeamArenaBattleLogCell:onCreate()

    self:setAutoClose(false)
    self:setSwallowTouches(false)



    self.shoe_has_role_list = {}
    self.shoe_no_role_list = {}
    self.spr_photo_list = {}
    self.btn_photo_list = {}
    self.lbl_role_level_list = {}
    self.spr_frame_list = {}
    self.menu_list = {}


    self.b_shoe_has_role_list = {}
    self.b_shoe_no_role_list = {}
    self.b_spr_photo_list = {}
    self.b_btn_photo_list = {}
    self.b_lbl_role_level_list = {}
    self.b_spr_frame_list = {}
    self.b_menu_list = {}
    -- 注册信息
    for i=1,3 do
        table.insert( self.shoe_has_role_list,  self["shoe_has_role_"..i])
        table.insert( self.shoe_no_role_list,  self["shoe_no_role_"..i])
        table.insert( self.spr_photo_list,  self["spr_photo_"..i])
        table.insert( self.btn_photo_list,  self["btn_photo_"..i])
        table.insert( self.lbl_role_level_list,  self["lbl_role_level_"..i])
        table.insert( self.spr_frame_list,  self["spr_frame_"..i])
        table.insert( self.menu_list,  self["menu_"..i])
        self.btn_photo_list[i]:registerScriptTapHandler(handler(self, self.onAttrPlayerInfo))


        table.insert( self.b_shoe_has_role_list,  self["b_shoe_has_role_"..i])
        table.insert( self.b_shoe_no_role_list,  self["b_shoe_no_role_"..i])
        table.insert( self.b_spr_photo_list,  self["b_spr_photo_"..i])
        table.insert( self.b_btn_photo_list,  self["b_btn_photo_"..i])
        table.insert( self.b_lbl_role_level_list,  self["b_lbl_role_level_"..i])
        table.insert( self.b_spr_frame_list,  self["b_spr_frame_"..i])
        table.insert( self.b_menu_list,  self["b_menu_"..i])
        self.b_btn_photo_list[i]:registerScriptTapHandler(handler(self, self.onDefPlayerInfo))


    end

    -- self.btn_battle:setLabelText("挑战")
    
    self.btn_message:registerScriptTapHandler(handler(self, self.onBtnMessage))
end 

function TeamArenaBattleLogCell:onBtnMessage( tag, pSender)

    -- fasong zhandou xieyi 
    -- local req = TeamArena_pb.GReqTeamArenaBattle()
	-- req.defend_team_id = self.team_data.team_id
    -- NetManager:sendMessage(ProtocolID.GReqTeamArenaBattle, req)     

    require("src.layer.teamarena.TeamArenaVideoCtr"):instance():openWindow(self.battle_data)

end


function TeamArenaBattleLogCell:initDone(battle_data,  scroll_view)
    self.battle_data = battle_data

    -- if battle_data.win_team_id  then 

    -- else 
    
    -- end 

    if battle_data.win_team_id == ex.Player.team_arena_data.curr_my_team_data.team_id then 
        if ex.Player.team_arena_data.curr_my_team_data.team_id ==  battle_data.attack_team.team_id then 
            self.lbl_result:setString(ex.Tools:getLang(74417))
        else 
            self.lbl_result:setString(ex.Tools:getLang(74418))
        end 
    else 
        if ex.Player.team_arena_data.curr_my_team_data.team_id ==  battle_data.attack_team.team_id then 
            self.lbl_result:setString(ex.Tools:getLang(74419))
        else 
            self.lbl_result:setString(ex.Tools:getLang(74420))
        end 
    end 

    -- if battle_data.win_team_id == battle_data.attack_team.team_id then 
    --     if ex.Player.team_arena_data.curr_my_team_data.captain_id ==  battle_data.attack_team.team_id then 

    --     else 

    --     end 

    --     self.lbl_result:setString("进攻胜利")
    -- else 
    --     self.lbl_result:setString("进攻失败")
    -- end 


    local show_time = os.date("%Y-%m-%d %H:%M:%S", battle_data.battle_time)
    self.lbl_time:setString(show_time)

    self.lbl_name1:setString(battle_data.attack_team.team_name)
    self.lbl_name2:setString(battle_data.defend_team.team_name)

    self.lbl_battlebg1:setString(ex.Tools:getLang(74407))
    self.lbl_battlebg2:setString(ex.Tools:getLang(74407))
    self.lbl_scorebg1:setString(ex.Tools:getLang(74408))
    self.lbl_scorebg2:setString(ex.Tools:getLang(74408))
    self.lbl_rankbg1:setString(ex.Tools:getLang(74409))
    self.lbl_rankbg2:setString(ex.Tools:getLang(74409))


    self.lbl_battle1:setString(battle_data.attack_team.fighting)
    self.lbl_battle2:setString(battle_data.defend_team.fighting)


    -- 创建富文本
    if battle_data.add_score == 0  then 
        self.lbl_score1:setString(battle_data.attack_team.score )

    else 
        self.lbl_score1:setString("")

        self.lbl_score1_rich = require("src.comp.RichTextEx"):create()
        :setFontSize(20)
        :setFontFace(FONT_DEFAULT_NAME_BOLD)
        :setAnchorPoint(ex.a.left_bottom)
        :setWrapMode(1)
        self.lbl_score1_rich:setPosition(0,-15)
        self.lbl_score1:addChild(self.lbl_score1_rich)

        if battle_data.add_score > 0 then 
            local rich_text = "<font color='#7a472d'>" .. battle_data.attack_team.score .. "(</font><img src='team-arena/spr-up.png' width='30' height='30' /><font color='#7a472d'>+" .. battle_data.add_score ..")" .. "</font>"
            self.lbl_score1_rich:setXmlTextLua(rich_text)
        else 
            local rich_text = "<font color='#7a472d'>" .. battle_data.attack_team.score .. "(</font><img src='team-arena/spr-down.png' width='30' height='30' /><font color='#7a472d'>" .. battle_data.add_score ..")" .. "</font>"
            self.lbl_score1_rich:setXmlTextLua(rich_text)
        end 
    end 
    
    -- 创建富文本
    if battle_data.defend_reduce_score == 0  then 
        self.lbl_score2:setString(battle_data.attack_team.score )

    else 
        self.lbl_score2:setString("")

        self.lbl_score2_rich = require("src.comp.RichTextEx"):create()
        :setFontSize(20)
        :setFontFace(FONT_DEFAULT_NAME_BOLD)
        :setAnchorPoint(ex.a.left_bottom)
        :setWrapMode(1)
        self.lbl_score2_rich:setPosition(0,-15)
        self.lbl_score2:addChild(self.lbl_score2_rich)

        if battle_data.defend_reduce_score > 0 then 
            local rich_text = "<font color='#7a472d'>" .. battle_data.defend_team.score .. "(</font><img src='team-arena/spr-up.png' width='30' height='30' /><font color='#7a472d'>+" .. battle_data.defend_reduce_score ..")" .. "</font>"
            self.lbl_score2_rich:setXmlTextLua(rich_text)
        else 
            local rich_text = "<font color='#7a472d'>" .. battle_data.defend_team.score .. "(</font><img src='team-arena/spr-down.png' width='30' height='30' /><font color='#7a472d'>" .. battle_data.defend_reduce_score ..")" .. "</font>"
            self.lbl_score2_rich:setXmlTextLua(rich_text)
        end 
    end 



    if battle_data.attack_add_rank == 0  then 
        self.lbl_rank1:setString(battle_data.attack_team.rank )
    else 
        self.lbl_rank1:setString("")

        self.lbl_rank1_rich = require("src.comp.RichTextEx"):create()
        :setFontSize(20)
        :setFontFace(FONT_DEFAULT_NAME_BOLD)
        :setAnchorPoint(ex.a.left_bottom)
        :setWrapMode(1)
        self.lbl_rank1_rich:setPosition(0,-15)
        self.lbl_rank1:addChild(self.lbl_rank1_rich)

        if battle_data.attack_add_rank > 0 then 
            local rich_text = "<font color='#7a472d'>" .. battle_data.attack_team.rank .. "(</font><img src='team-arena/spr-up.png' width='30' height='30' /><font color='#7a472d'>+" .. battle_data.attack_add_rank ..")" .. "</font>"
            self.lbl_rank1_rich:setXmlTextLua(rich_text)

        else 
            local rich_text = "<font color='#7a472d'>" .. battle_data.attack_team.rank .. "(</font><img src='team-arena/spr-down.png' width='30' height='30' /><font color='#7a472d'>" .. battle_data.attack_add_rank ..")" .. "</font>"
            self.lbl_rank1_rich:setXmlTextLua(rich_text)
        end 
    end 


    if battle_data.defend_add_rank == 0  then 
        self.lbl_rank2:setString(battle_data.defend_team.rank )
    else 
        self.lbl_rank2:setString("")

        self.lbl_rank2_rich = require("src.comp.RichTextEx"):create()
        :setFontSize(20)
        :setFontFace(FONT_DEFAULT_NAME_BOLD)
        :setAnchorPoint(ex.a.left_bottom)
        :setWrapMode(1)
        self.lbl_rank2_rich:setPosition(0,-15)
        self.lbl_rank2:addChild(self.lbl_rank2_rich)

        if battle_data.defend_add_rank > 0 then 
            local rich_text = "<font color='#7a472d'>" .. battle_data.defend_team.rank .. "(</font><img src='team-arena/spr-up.png' width='30' height='30' /><font color='#7a472d'>+" .. battle_data.defend_add_rank ..")" .. "</font>"
            self.lbl_rank2_rich:setXmlTextLua(rich_text)

        else 
            local rich_text = "<font color='#7a472d'>" .. battle_data.defend_team.rank .. "(</font><img src='team-arena/spr-down.png' width='30' height='30' /><font color='#7a472d'>" .. battle_data.defend_add_rank ..")" .. "</font>"
            self.lbl_rank2_rich:setXmlTextLua(rich_text)
        end 
    end 


    -- self.lbl_rank2:setString(battle_data.defend_team.rank .. "(" .. battle_data.defend_add_rank ..")" )

    local sfc = cc.SpriteFrameCache:getInstance() 
    sfc:addSpriteFrames("ccbi-res/clan-gvg-lang.plist")

    -- 处理那了两个东西
    if battle_data.win_team_id == battle_data.attack_team.team_id then 
        -- self.team_result_1:setSpriteFrame("clan-gvg-lang/spr-gvg-win.png")
        -- self.team_result_2:setSpriteFrame("clan-gvg-lang/spr-gvg-fail.png")

        ex.Tools:setSpriteFrame(self.team_result_1, "clan-gvg-lang/spr-gvg-win.png")
        ex.Tools:setSpriteFrame(self.team_result_2, "clan-gvg-lang/spr-gvg-fail.png")
    else 
        -- self.team_result_1:setSpriteFrame("clan-gvg-lang/spr-gvg-fail.png")
        -- self.team_result_2:setSpriteFrame("clan-gvg-lang/spr-gvg-win.png")

        ex.Tools:setSpriteFrame(self.team_result_1, "clan-gvg-lang/spr-gvg-fail.png")
        ex.Tools:setSpriteFrame(self.team_result_2, "clan-gvg-lang/spr-gvg-win.png")
    end 

    self.team_result_1:setScale(0.5)
    self.team_result_2:setScale(0.5)

    for i=1,3 do

        self.menu_list[i]:setIsTouchInsideNode(scroll_view)
        self.menu_list[i]:setSwallowsTouches(false)
    
        if battle_data.attack_team.member[i] then 

            self.shoe_has_role_list[i]:setVisible(true)
            self.shoe_no_role_list[i]:setVisible(false)
            self.lbl_role_level_list[i]:setString(battle_data.attack_team.member[i].member.level)
            self.spr_photo_list[i]:setSpriteFrame(string.format("head-icon/%d.png", battle_data.attack_team.member[i].member.head_id))
            ex.Tools:setSpriteFrame(self.spr_frame_list[i], ex.Tools:getBorderIconByIdx(battle_data.attack_team.member[i].member.border_id))            

            self.btn_photo_list[i]:setContentSize(self.spr_photo_list[i]:getContentSize())
            -- self.btn_photo_list[i]:setTag(battle_data.attack_team.member[i].member.player_id)  
            self.btn_photo_list[i]:setTag(i)  
        
        else 
            self.shoe_has_role_list[i]:setVisible(false)
            self.shoe_no_role_list[i]:setVisible(true)
        end
        


        self.b_menu_list[i]:setIsTouchInsideNode(scroll_view)
        self.b_menu_list[i]:setSwallowsTouches(false)
        if battle_data.defend_team.member[i] then 

            self.b_shoe_has_role_list[i]:setVisible(true)
            self.b_shoe_no_role_list[i]:setVisible(false)
            self.b_lbl_role_level_list[i]:setString(battle_data.defend_team.member[i].member.level)
            self.b_spr_photo_list[i]:setSpriteFrame(string.format("head-icon/%d.png", battle_data.defend_team.member[i].member.head_id))
            ex.Tools:setSpriteFrame(self.b_spr_frame_list[i], ex.Tools:getBorderIconByIdx(battle_data.defend_team.member[i].member.border_id))            

            self.b_btn_photo_list[i]:setContentSize(self.b_spr_photo_list[i]:getContentSize())
            self.b_btn_photo_list[i]:setTag(i)  
            -- self.b_btn_photo_list[i]:setTag(battle_data.defend_team.member[i].member.player_id)  
        
        else 
            self.b_shoe_has_role_list[i]:setVisible(false)
            self.b_shoe_no_role_list[i]:setVisible(true)
        end

    end
end 

function TeamArenaBattleLogCell:onDefPlayerInfo(tag, pSender)


    if self.battle_data.defend_team.member[tag].hidden == true  then 
        ex.Tools:showTeamArenaPlayerInfo(0, self.battle_data.defend_team.member[tag].member.server_id)
        return 
    end 
    ex.Tools:showTeamArenaPlayerInfo(self.battle_data.defend_team.member[tag].member.player_id, self.battle_data.defend_team.member[tag].member.server_id)

end


function TeamArenaBattleLogCell:onAttrPlayerInfo(tag, pSender)

    if self.battle_data.attack_team.member[tag].hidden == true  then 
        ex.Tools:showTeamArenaPlayerInfo(0, self.battle_data.attack_team.member[tag].member.server_id)
        return 
    end 
    ex.Tools:showTeamArenaPlayerInfo(self.battle_data.attack_team.member[tag].member.player_id, self.battle_data.attack_team.member[tag].member.server_id)

end



-----------------------------------------------------------------------------
function TeamArenaBattleLogLayer:onCreate()

    self:setAutoClose(true)
    self:setSwallowTouches(false)
    self:addBlackBackground()


    -- 发送拉起数据协议
    self:sendMessageData()
    self.lbl_title:setString(ex.Tools:getLang(74401))

    self.lbl_tips:setString(ex.Tools:getLang(74402))
    local viewSize = cc.size(self.spr_bg:getContentSize().width, self.spr_bg:getContentSize().height - 20 )

    self.scroll_view = cc.ScrollView:create(viewSize)
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    :setPosition(self.spr_bg:getPositionX() + 2, self.spr_bg:getPositionY() + 10)
    self:addChild(self.scroll_view)

end 

function TeamArenaBattleLogLayer:onDone(tag,pSender)
    self:sendMessageData( )
end

function TeamArenaBattleLogLayer:sendMessageData( )
    
    -- 发送比赛记录协议

    NetManager:sendMessage(ProtocolID.GReqTeamArenaBattleRecord)     
end


function TeamArenaBattleLogLayer:showList(data )
-- dump(data)
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
    table.sort(self.cellList, function(a, b)
        return a.battle_data.battle_time > b.battle_data.battle_time
    end)

    local viewSize = self.scroll_view:getViewSize()
    --cc.size(480, 150)
    local item_size = TeamArenaBattleLogCell:createWithCCBIFile("ccbi/TeamArenaBattleLogCell.ccbi"):getContentSize()
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


function TeamArenaBattleLogLayer:addCell( v )
    local cell = TeamArenaBattleLogCell:createWithCCBIFile("ccbi/TeamArenaBattleLogCell.ccbi")
	cell:setSwallowTouches(false)
	cell:setIgnoreAnchorPointForPosition(false)
    cell:setAnchorPoint(ex.a.center)
    cell:initDone(v, self.scroll_view)
    return cell
end





-----------------------------------------------------------------------------
function TeamArenaBattleLogCtr:onCreate()
	self:setCCBIPath("ccbi/TeamArenaBattleLogLayer.ccbi")
	self:setIsSingle(false)
end

function TeamArenaBattleLogCtr:getLayerClass()
	return TeamArenaBattleLogLayer
end

function TeamArenaBattleLogCtr:getTeamArenaBattleLogLayer()
	return self.layer
end


function TeamArenaBattleLogCtr:openWindow()
	if self:isOpened() then
		return
	end
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/team-arena.plist")
    sfc:addSpriteFrames("ccbi-res/clan-gvg.plist")
    
	self:loadLayer()
	self:open()
    self:initData()
    
end

function TeamArenaBattleLogCtr:showList(data)
    self.layer:showList(data)
end


function TeamArenaBattleLogCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
end


return TeamArenaBattleLogCtr