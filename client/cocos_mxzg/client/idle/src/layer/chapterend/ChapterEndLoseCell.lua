local ChapterEndLoseCell = class("ChapterEndLoseCell", require("src.comp.EventLayer"))

function ChapterEndLoseCell:onCreate()
    self:setAutoClose(true)
    self:setSwallowTouches(true)
    
    self.time = 6

    self.btn_summon:setName("main_summon")
    self.btn_up:setName("main_hero")
    self.btn_equip:setName("main_smith_shop")
    self.btn_fetter:setName("main_fetter")
end

function ChapterEndLoseCell:reset(data, is_no_countdown)
    if not is_no_countdown then
        self:updateCloseTime()
        self:addTimer("timer", 1000, handler(self, self.updateCloseTime), true)
    else
        self.lbl_close_time:setVisible(false)
    end 
end

function ChapterEndLoseCell:onJump(tag, pSender)
    ex.JumpManager:jumpByAtom(pSender:getName())
    require("src.comp.LuaNodeCtr"):closeOtherWindow()
end

function ChapterEndLoseCell:updateCloseTime()
    self.time = self.time - 1 
	self.lbl_close_time:setString(string.format(ex.Tools:getLang(47336), self.time))
	if self.time <= 0 then 
		require("src.layer.chapterend.ChapterEndCtr"):instance():closeWindow()
	end
end

function ChapterEndLoseCell:onStrong(tag, pSender)
	ex.JumpManager:jumpByAtom("main_hero_recommend")
end

return ChapterEndLoseCell