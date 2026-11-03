local MagicTowerBattleEndCtr = class('MagicTowerBattleEndCtr', require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local MagicTowerBattleEndLayer = class('MagicTowerBattleEndLayer', require("src.layer.ui.UI_MagicTowerBattleEndLayer"))

function MagicTowerBattleEndLayer:onCreate()
	self.super.onCreate(self)
	self:setName("MagicTowerBattleEndLayer")

    self:addBlackBackground()
end

function MagicTowerBattleEndLayer:updateLayer(is_win, stage, report, star_num)
    self.battle_report = report

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/battle-end.plist")
    sfc:addSpriteFrames("ccbi-res/battle-end-lang.plist")

    self.node_win:setVisible(is_win)
    self.node_title_win:setVisible(is_win)
    self.node_lose:setVisible(not is_win)
    self.node_title_lose:setVisible(not is_win)

    if is_win then
        self.node_win:setPositionY(self:getContentSize().height / 2 - 80)

        self.lbl_name:setString(ex.Player.nick)
        ex.Tools:setSpriteFrame(self.spr_border, ex.Tools:getBorderIconByIdx(ex.Player.border_id or 0))
        ex.Tools:setSpriteFrame(self.spr_photo, string.format("head-icon/%d.png", ex.Player.head_id))

        self.lbl_tip:setString(string.format(ex.Tools:getLang(57544), stage))

        for i=1,3 do
            self["spr_star_"..i]:setVisible(i <= star_num)
        end
    else
        local cell = require("src.layer.chapterend.ChapterEndLoseCell"):createWithCCBIFile("ccbi/ChapterEndLoseCell.ccbi")
        cell:setPosition(cc.p(-cell:getContentSize().width / 2, -cell:getContentSize().height / 2))
        self.node_lose:addChild(cell)
        cell:reset(nil, true)
    end
end

function MagicTowerBattleEndLayer:onReport(tag, pSender)
    if not self.battle_report then
        return
    end

    require("src.layer.BattleDetailCtr"):instance():openWindow(self.battle_report.log)
end

-----------------------------------------------------------------------------
function MagicTowerBattleEndCtr:loadLayer()
	local tmp_layer = MagicTowerBattleEndLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function MagicTowerBattleEndCtr:openWindow(is_win, stage, report, star_num)
    if self:isOpened() then
        return
    end
    
    self:loadLayer()
    self:open()
    self:initData(is_win, stage, report, star_num)
end

function MagicTowerBattleEndCtr:initData(is_win, stage, report, star_num)
    self.layer:updateLayer(is_win, stage, report, star_num)
end

return MagicTowerBattleEndCtr
