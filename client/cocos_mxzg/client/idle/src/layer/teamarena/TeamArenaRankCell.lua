local TeamArenaRankCell = class("TeamArenaRankCell", require("src.comp.LuaLayerBase"))

local string_format = string.format
function TeamArenaRankCell:onCreate()
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

end

function TeamArenaRankCell:onClick(tag,pSender)
    

end

function TeamArenaRankCell:onPlayerInfo(tag, pSender)


    if self.rank_data.member[tag].hidden == true  then 
        ex.Tools:showTeamArenaPlayerInfo(0, self.rank_data.member[tag].member.server_id)
        return 
    end 
    ex.Tools:showTeamArenaPlayerInfo(self.rank_data.member[tag].member.player_id, self.rank_data.member[tag].member.server_id)
end



function TeamArenaRankCell:reset(data)
    self:resetTeamData(data)
    self.lbl_message:setString(ex.Tools:getLang(""))
end

function TeamArenaRankCell:updateMyTeam(data)

    if ex.Player.team_arena_data.curr_state == 1 then 
        self.no_start:setVisible(false)
        -- self.lbl_message:setString(ex.Tools:getLang(74003))
        self.lbl_message:setString("")
    else
        if #data.member < 1 then 
            self.no_start:setVisible(false)
            -- self.lbl_message:setString(ex.Tools:getLang(74004))
        else 
            self.no_start:setVisible(true)
            -- self.lbl_message:setString(ex.Tools:getLang(""))
            self:resetTeamData(data)
        end 
    end 
end


function TeamArenaRankCell:resetTeamData(data)
    self.rank_data = data
    self.lbl_sorce_bg:setString(ex.Tools:getLang(74017))

    self.lbl_sorce:setString(data.score)
    self.lbl_teamname:setString(data.team_name)
    self.lbl_fight:setString(data.fighting)  
    -- 显示前面的排名闲
    if data.rank <= 0 then
        self.spr_rank:setVisible(false)
        self.lbl_rank:setVisible(true)
        self.lbl_rank:setString(ex.Tools:getLang(52012))
    else

        self.spr_rank:setVisible(false)
        self.lbl_rank:setVisible(true)
        -- self.lbl_rank:enableShadow(FONT_BLACK_C4B, cc.size(1, -1))
        if data.rank > 0 and data.rank < 4 then 
            self.spr_rank:setVisible(true)
            self.lbl_rank:setVisible(false)
            -- self.spr_rank:setSpriteFrame(string.format("rank/spr-paihang-%s.png", data.rank))
            ex.Tools:setSpriteFrame(self.spr_rank, string.format("rank/spr-paihang-%s.png", data.rank))
        end
        self.lbl_rank:setString(string.format("%d", data.rank))

    end

    -- 显示队伍人员信息
    for i=1,3 do
        
        if data.member[i] then 

            self.shoe_has_role_list[i]:setVisible(true)
            self.shoe_no_role_list[i]:setVisible(false)
            self.lbl_role_level_list[i]:setString(data.member[i].member.level)
            self.spr_photo_list[i]:setSpriteFrame(string.format("head-icon/%d.png", data.member[i].member.head_id))
            ex.Tools:setSpriteFrame(self.spr_frame_list[i], ex.Tools:getBorderIconByIdx(data.member[i].member.border_id))     

            self.btn_photo_list[i]:setContentSize(self.spr_photo_list[i]:getContentSize())
            self.btn_photo_list[i]:setTag(i)  

        else 
            self.shoe_has_role_list[i]:setVisible(false)
            self.shoe_no_role_list[i]:setVisible(true)
        end 


    end

end 

return TeamArenaRankCell