local TeamArenaEndLayer = class("TeamArenaEndLayer", require("src.comp.EventLayer"))
local TeamArenaEndCtr = class("TeamArenaEndCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))


-----------------------------------------------------------------------------
function TeamArenaEndLayer:onCreate()

    self:setAutoClose(true)
    self:setSwallowTouches(false)
    self:addBlackBackground()


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
        self.btn_photo_list[i]:registerScriptTapHandler(handler(self, self.onPlayerInfo))


        table.insert( self.b_shoe_has_role_list,  self["b_shoe_has_role_"..i])
        table.insert( self.b_shoe_no_role_list,  self["b_shoe_no_role_"..i])
        table.insert( self.b_spr_photo_list,  self["b_spr_photo_"..i])
        table.insert( self.b_btn_photo_list,  self["b_btn_photo_"..i])
        table.insert( self.b_lbl_role_level_list,  self["b_lbl_role_level_"..i])
        table.insert( self.b_spr_frame_list,  self["b_spr_frame_"..i])
        table.insert( self.b_menu_list,  self["b_menu_"..i])
        self.b_btn_photo_list[i]:registerScriptTapHandler(handler(self, self.onPlayerInfo))


    end


	self.lbl_score_1 = require("src.comp.RichTextEx"):create()
	:setFontSize(20)
    :setFontFace(FONT_DEFAULT_NAME_BOLD)
    :setAnchorPoint(ex.a.left_bottom)
    :setFontColor("#FFE4A1")
    :setWrapMode(1)
    self.lbl_score_1:setPosition(0,0)
    self.rich1:addChild(self.lbl_score_1)
    

    self.lbl_score_2 = require("src.comp.RichTextEx"):create()
	:setFontSize(20)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
    :setAnchorPoint(ex.a.left_bottom)
    :setFontColor("#FFE4A1")
    :setWrapMode(1)
    self.lbl_score_2:setPosition(0,0)
	self.rich2:addChild(self.lbl_score_2)


    self.btn_battle:setLabelText(ex.Tools:getLang(74421))
    self.btn_battle2:setLabelText(ex.Tools:getLang(74422))


    self.btn_battle:registerScriptTapHandler(handler(self, self.onBtnBattle))

    self.btn_battle2:registerScriptTapHandler(handler(self, self.onBtnBattle2))

end 

function TeamArenaEndLayer:onBtnBattle( tag, pSender)
    
    require("src.layer.teamarena.TeamArenaEndCtr"):instance():closeWindow()

end

function TeamArenaEndLayer:onBtnBattle2( tag, pSender)
    
    require("src.layer.teamarena.TeamArenaEndCtr"):instance():closeWindow()
    ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_TEAM_ARENA)
end



function TeamArenaEndLayer:initData(data)
    
    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/team-arena-lang.plist")

    NetManager:sendMessage(ProtocolID.GReqTeamArenaData)    -- 组队竞技场数据

    dump(ex.Player.team_arena_data.battle_data)
    self.lbl_fight:setString(ex.Tools:getLang(74423))

    local is_win = ex.Player.team_arena_data.battle_data.attack_add_score > 0  
    

    ex.Tools:setSpriteFrame(self.spr_wing, string.format("battle-end/spr-wing-%d.png", is_win and 1 or 0))
	ex.Tools:setSpriteFrame(self.spr_result, string.format("battle-end-lang/lbl-result-%d.png", is_win and 1 or 0))

    self.lbl_teamname1:setString(ex.Player.team_arena_data.battle_data.attack_team.team_name)
    self.lbl_teamname2:setString(ex.Player.team_arena_data.battle_data.defend_team.team_name)
    
    -- self.lbl_rank1:setString(ex.Tools:getLang(5245) ..  ex.Player.team_arena_data.battle_data.attack_rank)
    -- self.lbl_rank2:setString(ex.Tools:getLang(5245) .. ex.Player.team_arena_data.battle_data.defend_rank)

    self.lbl_rank1:setString("")
    self.lbl_rank2:setString("")

    if ex.Player.team_arena_data.battle_data.defend_add_rank == 0  then 
        self.lbl_rank2:setString(ex.Tools:getLang(5245) ..  ex.Player.team_arena_data.battle_data.defend_rank)
    else 
        self.lbl_rank2:setString("")

        self.lbl_rank2_rich = require("src.comp.RichTextEx"):create()
        :setFontSize(20)
        :setFontFace(FONT_DEFAULT_NAME_BOLD)
        :setAnchorPoint(ex.a.left_bottom)
        :setFontColor("#FFE4A1")
        :setWrapMode(1)
        self.lbl_rank2_rich:setPosition(0,-15)
        self.lbl_rank2:addChild(self.lbl_rank2_rich)

        if ex.Player.team_arena_data.battle_data.defend_add_rank > 0 then 
            local rich_text =  ex.Player.team_arena_data.battle_data.defend_rank .. "(<img src='team-arena/spr-up.png' width='30' height='30' />+" .. ex.Player.team_arena_data.battle_data.defend_add_rank ..")" 
            self.lbl_rank2_rich:setXmlTextLua(rich_text)
        else 
            local rich_text =  ex.Player.team_arena_data.battle_data.defend_rank .. "(<img src='team-arena/spr-down.png' width='30' height='30' />" .. ex.Player.team_arena_data.battle_data.defend_add_rank ..")" 
            self.lbl_rank2_rich:setXmlTextLua(rich_text)
        end 
    end 




    if ex.Player.team_arena_data.battle_data.attack_add_rank == 0  then 
        self.lbl_rank1:setString(ex.Tools:getLang(5245) ..  ex.Player.team_arena_data.battle_data.attack_rank)
    else 
        self.lbl_rank1:setString("")

        self.lbl_rank1_rich = require("src.comp.RichTextEx"):create()
        :setFontSize(20)
        :setFontFace(FONT_DEFAULT_NAME_BOLD)
        :setAnchorPoint(ex.a.left_bottom)
        :setWrapMode(1)
        :setFontColor("#FFE4A1")
        self.lbl_rank1_rich:setPosition(0,-15)
        self.lbl_rank1:addChild(self.lbl_rank1_rich)

        if ex.Player.team_arena_data.battle_data.attack_add_rank > 0 then 
            local rich_text = ex.Player.team_arena_data.battle_data.attack_rank .. "(<img src='team-arena/spr-up.png' width='30' height='30' />+" .. ex.Player.team_arena_data.battle_data.attack_add_rank ..")" 
            self.lbl_rank1_rich:setXmlTextLua(rich_text)

        else 
            local rich_text =  ex.Player.team_arena_data.battle_data.attack_rank .. "(<img src='team-arena/spr-down.png' width='30' height='30' />" .. ex.Player.team_arena_data.battle_data.attack_add_rank ..")" 
            self.lbl_rank1_rich:setXmlTextLua(rich_text)
        end 
    end 









    -- xianshi shangshengy xiajiang 
    -- 

    if ex.Player.team_arena_data.battle_data.attack_add_score == 0  then 
        local rich_text = ex.Tools:getLang(5134) ..  ex.Player.team_arena_data.battle_data.attack_score  
        self.lbl_score_1:setXmlTextLua(rich_text)
    else 
        if ex.Player.team_arena_data.battle_data.attack_add_score > 0 then 
            local rich_text = ex.Tools:getLang(5134) ..  ex.Player.team_arena_data.battle_data.attack_score .. "(<img src='team-arena/spr-up.png' width='30' height='30' />+" .. ex.Player.team_arena_data.battle_data.attack_add_score ..")" 
            self.lbl_score_1:setXmlTextLua(rich_text)
        else 
            local rich_text = ex.Tools:getLang(5134) ..  ex.Player.team_arena_data.battle_data.attack_score .. "(<img src='team-arena/spr-down.png' width='30' height='30' />" .. ex.Player.team_arena_data.battle_data.attack_add_score ..")" 
            self.lbl_score_1:setXmlTextLua(rich_text)
        end 
    end 

    if ex.Player.team_arena_data.battle_data.defend_reduce_score == 0  then 
        local rich_text = ex.Tools:getLang(5134) ..  ex.Player.team_arena_data.battle_data.defend_score  
        self.lbl_score_2:setXmlTextLua(rich_text)
    else 
        if ex.Player.team_arena_data.battle_data.defend_reduce_score > 0 then 
            local rich_text = ex.Tools:getLang(5134) ..  ex.Player.team_arena_data.battle_data.defend_score .. "(<img src='team-arena/spr-up.png' width='30' height='30' />+" .. ex.Player.team_arena_data.battle_data.defend_reduce_score ..")" 
            self.lbl_score_2:setXmlTextLua(rich_text)
        else 
            local rich_text = ex.Tools:getLang(5134) ..  ex.Player.team_arena_data.battle_data.defend_score .. "(<img src='team-arena/spr-down.png' width='30' height='30' />" .. ex.Player.team_arena_data.battle_data.defend_reduce_score ..")" 
            self.lbl_score_2:setXmlTextLua(rich_text)
        end 
    end 

    for i=1,3 do
        if ex.Player.team_arena_data.battle_data.attack_team.member[i] then 
            self.shoe_has_role_list[i]:setVisible(true)
            self.shoe_no_role_list[i]:setVisible(false)
            self.lbl_role_level_list[i]:setString(ex.Player.team_arena_data.battle_data.attack_team.member[i].member.level)
            self.spr_photo_list[i]:setSpriteFrame(string.format("head-icon/%d.png", ex.Player.team_arena_data.battle_data.attack_team.member[i].member.head_id))
            ex.Tools:setSpriteFrame(self.spr_frame_list[i], ex.Tools:getBorderIconByIdx(ex.Player.team_arena_data.battle_data.attack_team.member[i].member.border_id))            

            self.btn_photo_list[i]:setContentSize(self.spr_photo_list[i]:getContentSize())
            -- self.btn_photo_list[i]:setTag(ex.Player.team_arena_data.battle_data.attack_team.member[i].member.player_id)  
            self.btn_photo_list[i].data = ex.Player.team_arena_data.battle_data.attack_team.member[i].member
        else 
            self.shoe_has_role_list[i]:setVisible(false)
            self.shoe_no_role_list[i]:setVisible(true)
        end
        

        if ex.Player.team_arena_data.battle_data.defend_team.member[i] then 

            self.b_shoe_has_role_list[i]:setVisible(true)
            self.b_shoe_no_role_list[i]:setVisible(false)
            self.b_lbl_role_level_list[i]:setString(ex.Player.team_arena_data.battle_data.defend_team.member[i].member.level)
            self.b_spr_photo_list[i]:setSpriteFrame(string.format("head-icon/%d.png", ex.Player.team_arena_data.battle_data.defend_team.member[i].member.head_id))
            ex.Tools:setSpriteFrame(self.b_spr_frame_list[i], ex.Tools:getBorderIconByIdx(ex.Player.team_arena_data.battle_data.defend_team.member[i].member.border_id))            

            self.b_btn_photo_list[i]:setContentSize(self.b_spr_photo_list[i]:getContentSize())
            self.b_btn_photo_list[i].data = ex.Player.team_arena_data.battle_data.defend_team.member[i].member

            -- self.b_btn_photo_list[i]:setTag(ex.Player.team_arena_data.battle_data.defend_team.member[i].member.player_id)
        else 
            self.b_shoe_has_role_list[i]:setVisible(false)
            self.b_shoe_no_role_list[i]:setVisible(true)
        end

    end

end

function TeamArenaEndLayer:onPlayerInfo(tag, pSender)
    ex.Tools:showPlayerInfo(pSender.data.player_id, pSender.data.server_id)
end

-----------------------------------------------------------------------------
function TeamArenaEndCtr:onCreate()
	self:setCCBIPath("ccbi/TeamArenaEndLayer.ccbi")
	self:setIsSingle(false)
end

function TeamArenaEndCtr:getLayerClass()
	return TeamArenaEndLayer
end

function TeamArenaEndCtr:getTeamArenaEndLayer()
	return self.layer
end

function TeamArenaEndCtr:openWindow(data)
	if self:isOpened() then
		return
	end
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/team-arena.plist")

	self:loadLayer()
	self:open()
    self:initData()
    self.layer:initData(data)
end

function TeamArenaEndCtr:initData()
    -- self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
end


return TeamArenaEndCtr