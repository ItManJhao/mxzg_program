local DreamRankCell = class("DreamRankCell", require("src.comp.LuaLayerBase"))

local string_format = string.format
function DreamRankCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.spr_photo_btn:registerScriptTapHandler(handler(self, self.onFriendInfo))

end


function DreamRankCell:reset(data)

    if not data then print("not data") return end
    self.data = data
    
    self.spr_photo:setSpriteFrame(string_format("head-icon/%d.png", self.data.head_id))
    self.spr_frame:setSpriteFrame(ex.Tools:getBorderIconByIdx(self.data.border_id))
    self.lbl_name:setString(ex.StringUtil.getServerName(self.data.server_id)..self.data.name)
    self.lbl_fight:setString(self.data.combat_num)



    if self.data.rank > 0 and  self.data.rank < 4 then 

        self.spr_rank:setVisible(true)
        self.lbl_rank:setVisible(false)
        -- self.spr_rank:setSpriteFrame(string_format("rank/spr-paihang-%s.png",self.data.rank))
        ex.Tools:setSpriteFrame(self.spr_rank, string_format("rank/spr-paihang-%s.png",self.data.rank))

    else 
        self.spr_rank:setVisible(false)
        self.lbl_rank:setVisible(true)
        if self.data.rank < 0 then 
            self.lbl_rank:setString(ex.Tools:getLang(47749))
        else 
            self.lbl_rank:setString(self.data.rank)
        end 
        self.lbl_rank:enableOutline(FONT_BLACK_C4B, 2)

    end 


    self.lbl_max:setString(string_format( ex.Tools:getLang(47526),self.data.score ))
    self.lbl_max:enableOutline(FONT_BLACK_C4B, 2)

    -- 
end

function DreamRankCell:onFriendInfo(tag,pSender)
    ex.Tools:showPlayerInfo(self.data.player_id, cc.UserDefault:getInstance():getIntegerForKey("server_id"))
end


return DreamRankCell