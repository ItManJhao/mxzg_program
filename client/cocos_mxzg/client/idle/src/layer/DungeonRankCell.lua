local DungeonRankCell = class("DungeonRankCell", require("src.comp.LuaLayerBase"))


function DungeonRankCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	self.lbl_rank:enableOutline(FONT_BROWN, 2)
	self.lbl_num:enableOutline(FONT_BROWN, 1)
	-- self.menu:setSwallowsTouches(false)

	-- local x,y = self.spr_bg:getPosition()
	-- local sp = cc.Sprite:createWithSpriteFrameName("dungeon/spr-bg-2.png")

	-- self.menu:removeAllChildren()

	-- -- 进度条
 --    self.progressTimer = cc.ProgressTimer:create(sp)
 --    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
 --    :setPosition(x,y)
 --    :setMidpoint(cc.p(0, 0.5))
 --    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
 --    self:addChild(self.progressTimer)
 --    self.progressTimer:setPercentage(75)

end

function DungeonRankCell:reset(data)
	-- print(self.__cname,"onTips")
	-- dump(data)
	if not data then print("not data") return end

	self.spr_rank:setVisible(false)
	self.lbl_rank:setVisible(true)
	if data.rank > 0 and data.rank < 4 then 
		self.spr_rank:setVisible(true)
		self.lbl_rank:setVisible(false)
		self.spr_rank:setSpriteFrame(string.format("rank/spr-paihang-%s.png",data.rank))
	end
	-- self.spr_head:setSpriteFrame(string.format("backpack/%s.png",ItemType.IT_GOLD))
	self.lbl_rank:setString(data.rank <= 0 and ex.Tools:getLang(47749) or data.rank)
	self.lbl_num:setString(data.rank)
	self.lbl_name:setString(data.name)
	-- self.lbl_level:setString(data.name)
	-- self.lbl_time:setString(data.name)
	-- self.lbl_type:setString(data.name)
end

return DungeonRankCell