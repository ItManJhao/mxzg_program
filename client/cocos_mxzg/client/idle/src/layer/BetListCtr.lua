local BetListCtr = class("BetListCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local BetListLayer = class("BetListLayer", require("src.comp.EventLayer"))

-----------------------------------------------------------------------------
local BetListCell = class("BetListCell", require("src.comp.LuaLayerBase"))

function BetListCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:setIgnoreAnchorPointForPosition(false)
    self:setAnchorPoint(0.5, 0.5)
end

function BetListCell:initData(data)
    self.data = data
    if not self.data then
        return
    end

    self.btn_report.data = data
    self.btn_replay.data = data

    local player_data = {self.data.attacker, self.data.defender}

    for i,v in ipairs(player_data) do
        self["lbl_name"..i]:setString(v.name)
        ex.Tools:setSpriteFrame(self["spr_head"..i], string.format("head-icon/%d.png", v.head_id))
        ex.Tools:setSpriteFrame(self["spr_border"..i], ex.Tools:getBorderIconByIdx(v.border_id))
    end

    self.lbl_bet_name:setString(player_data[self.data.guess_type].name)
    if self.data.which_win == 0 then
        self.lbl_bet_text:setString(ex.Tools:getLang(47169))
        ex.Tools:setLabelCostColor(self.lbl_bet_num, true)
        self.lbl_bet_num:setString(self.data.guess_coin)
    else
        self.lbl_bet_text:setString(self.data.which_win == self.data.guess_type and ex.Tools:getLang(47538) or ex.Tools:getLang(47758))
        ex.Tools:setLabelCostColor(self.lbl_bet_num, self.data.which_win == self.data.guess_type)
        self.lbl_bet_num:setString(math.abs(self.data.delta))
    end

    self.lbl_round:setString(self.data.round_func(self.data.battle_round, self.data.period))
    
    self.btn_report:setVisible(self.data.battle_id ~= "")
    self.btn_replay:setVisible(self.data.battle_id ~= "")

    self.spr_win1:setVisible(self.data.which_win == 1)
    self.spr_win2:setVisible(self.data.which_win == 2)
end

-----------------------------------------------------------------------------
function BetListLayer:onCreate()
    self:addBlackBackground()
    
    local win_size = cc.Director:getInstance():getWinSize();
	local width = Maths.min(self:getContentSize().width, win_size.width);
    self:setScale(width / self:getContentSize().width);
    
    self.scroll_view:setItemSize(cc.size(540, 140))
    self.scroll_view:setItemType(1)
    self.scroll_view:setCreateNum(4)
end

-----------------------------------------------------------------------------
function BetListCtr:onCreate()
	self:setCCBIPath("ccbi/BetListLayer.ccbi")
	self:setIsSingle(false)
end

function BetListCtr:getLayerClass()
	return BetListLayer
end

function BetListCtr:openWindow(data)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(data)
end

function BetListCtr:initData(data)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    
    self.layer:addEvent(EVENT.MAIN_SCENE.CLOSE_LIST_VIEW, handler(self, self.closeWindow))
    self.layer:addEvent(data.event, handler(self, self.updateLayer))

    self.data = data

    self:updateLayer()

    self.layer.lbl_title:setString(data.title)
end

function BetListCtr:updateLayer()
    local data = self.data.data_func()
    if data == nil then
        return
    end

    self.layer.scroll_view.createItemFunction = function(item_data, scale)
        local cell = BetListCell:createWithCCBIFile("ccbi/BetListCell.ccbi")

        item_data.round_func = self.data.round_func
        cell:initData(item_data)

        cell.btn_report:registerScriptTapHandler(handler(self, self.onReport))
        cell.btn_replay:registerScriptTapHandler(handler(self, self.onReplay))

        return cell
    end

    self.layer.scroll_view:reloadData(data)
end

function BetListCtr:onReplay(tag, pSender)
    if not pSender.data then
        return
    end
    
    self.data.replay_func(pSender.data.bid)

    self:closeWindow()
end

function BetListCtr:onReport(tag, pSender)
    if not pSender.data then
        return
    end

    require("src.layer.BattleDetailCtr"):instance():openWindow(pSender.data.battle_log)
end

return BetListCtr
