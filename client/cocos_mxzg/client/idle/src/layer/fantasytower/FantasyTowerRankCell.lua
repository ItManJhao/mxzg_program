local FantasyTowerRankCell = class("FantasyTowerRankCell", require("src.comp.LuaLayerBase"))


function FantasyTowerRankCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	self.lbl_rank:enableOutline(FONT_BROWN, 2)
	self.lbl_num:enableOutline(FONT_BROWN, 1)

end

function FantasyTowerRankCell:reset(data)
	if not data then print("not data") return end
	if not data.rank then return end
	self.spr_rank:setVisible(false)
	self.lbl_rank:setVisible(true)
	if data.rank > 0 and data.rank < 4 then 
		self.spr_rank:setVisible(true)
		self.lbl_rank:setVisible(false)
		-- self.spr_rank:setSpriteFrame(string.format("rank/spr-paihang-%s.png",data.rank))
		ex.Tools:setSpriteFrame(self.spr_rank, string.format("rank/spr-paihang-%s.png",data.rank))
	end

	self.lbl_rank:setString(data.rank <= 0 and ex.Tools:getLang(47749) or data.rank)
	if not data.score then return end
	self.lbl_num:setString(data.score)
	if not data.name then return end
	self.lbl_name:setString(data.name)
	if not data.level then return end
	self.lbl_level:setString(data.level)
	
	-- level
end

return FantasyTowerRankCell