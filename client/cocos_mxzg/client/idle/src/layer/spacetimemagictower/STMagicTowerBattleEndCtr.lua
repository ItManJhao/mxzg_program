local STMagicTowerBattleEndCtr = class("STMagicTowerBattleEndCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local STMagicTowerBattleEndLayer = class("STMagicTowerBattleEndLayer", require("src.comp.EventLayerAdaptiveWidth"))
local STMagicTowerEndLoseCell = class("STMagicTowerEndLoseCell", require("src.comp.EventLayer"))
-----------------------------------------------------------------------------


function STMagicTowerEndLoseCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:setPosition(cc.p(0, 0))
end

function STMagicTowerEndLoseCell:reset(data)
    local lbl_condition = cpp.RichTextEx:createWithXMLLua("")
        :setFontSize(44)
        :setFontFace(FONT_DEFAULT_NAME_BOLD)
        :setScale(0.5)
        :setAnchorPoint(cc.p(0.5, 1))
        :setPosition(self.spr_top_bg:getContentSize().width / 2, self.spr_top_bg:getContentSize().height - 10)
    self.spr_top_bg:addChild(lbl_condition)
    local conditions = cfg.timetowermisson.getMissionCondition(data.info.mission_id + 1)
    if conditions and #conditions > 0 then
        local condition = conditions[1]
        lbl_condition:setXmlTextLua(string.format("<font color='#ffdf91'>%s：%s</font><font color='#df3b3b'>%s</font>", ex.Tools:getLang(75610), condition.str, condition.value_str))
    end
    
    local lbl_heart = cpp.RichTextEx:createWithXMLLua("")
        :setFontSize(44)
        :setFontFace(FONT_DEFAULT_NAME_BOLD)
        :setScale(0.5)
        :setAnchorPoint(cc.p(0.5, 0))
        :setPosition(self.spr_top_bg:getContentSize().width / 2, 10)
    self.spr_top_bg:addChild(lbl_heart)
    local heart_str = string.format( "<font color='#ffdf91'>%s：</font>", ex.Tools:getLang(75613))

    local heart = 0
    if data and data.info and data.info.heart then
        heart = data.info.heart
    end

    for i = 1, 3 do
        if i <= heart then
            heart_str = heart_str .. "<img src='time-tower/heart-red.png' width='70' height='70' />"
        else
            heart_str = heart_str .. "<img src='time-tower/heart-gray.png' width='70' height='70' />"
        end
    end
    lbl_heart:setXmlTextLua(heart_str)

    local cell = require("src.layer.chapterend.ChapterEndLoseCell"):createWithCCBIFile("ccbi/ChapterEndLoseCell.ccbi")
    cell:setPosition(cc.p(0, -25))
    self:addChild(cell)
    cell:reset(data, true)
end

function STMagicTowerEndLoseCell:onClose()
    STMagicTowerBattleEndCtr:instance():closeWindow()
end


-----------------------------------------------------------------------------
function STMagicTowerBattleEndLayer:onCreate()
    self:addBlackBackground()
    self:setAutoClose(true)
    self:setSwallowTouches(true)

    self.menu:setZOrder(999)
end

function STMagicTowerBattleEndLayer:updateLayer(data)
    local settle_data = data.settle_data
    local is_win = settle_data.report.win_id == ex.Player.role_id
    ex.Tools:setSpriteFrame(self.spr_wing, string.format("battle-end/spr-wing-%d.png", is_win and 1 or 0))
    ex.Tools:setSpriteFrame(self.spr_result, string.format("battle-end-lang/lbl-result-%d.png", is_win and 1 or 0))

    if is_win then
        local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_battle_end")
        spr_effect:setPosition(self.spr_wing:getContentSize().width / 2, self.spr_wing:getContentSize().height / 2 + 40)
        spr_effect:setScale(1)
        self.spr_wing:addChild(spr_effect, 0, 10)

        local chibang = sp.SkeletonAnimation:create("spine/chibang.json", "spine/chibang.atlas", 1)
        chibang:setAnimation(0, "idle", true)
        chibang:setPosition(self.spr_wing:getPositionX(), self.spr_wing:getPositionY())
        self:addChild(chibang)

        self.spr_result:setVisible(false)
        self.spr_wing:setVisible(false)
        self:showWin(settle_data, data.is_jump, data.info)
    else
        self:showLose(data)
    end
end

function STMagicTowerBattleEndLayer:showLose(data)
    self.node_win:setVisible(false)
    local cell = STMagicTowerEndLoseCell:createWithCCBIFile("ccbi/STMagicTowerEndLoseCell")
    cell:setPosition(0, 50)
    self:addChild(cell)
    cell:reset(data)
end

function STMagicTowerBattleEndLayer:showWin(result, is_jump, data)
    self.node_win:setVisible(true)
    if not result.reward or #result.reward == 0 then
        return
    end

    local comment
    if result.comment then
        if result.comment == 1 then
            comment = "sss"
        elseif result.comment == 2 then
            comment = "ss"
        elseif result.comment == 3 then
            comment = "s"
        elseif result.comment == 4 then
            comment = "a"
        elseif result.comment == 5 then
            comment = "b"
        end
    end

    if comment then
        -- self.spr_comment:setSpriteFrame(string.format("time-tower/word-%s.png", string.lower(comment)))
        ex.Tools:setSpriteFrame(self.spr_comment, string.format("time-tower/word-%s.png", string.lower(comment)))
        self.spr_comment:setVisible(true)
    else
        self.spr_comment:setVisible(false)
    end

    local lbl_comment = cpp.RichTextEx:createWithXMLLua("")
        :setFontSize(44)
        :setScale(0.5)
        :setFontFace(FONT_DEFAULT_NAME_BOLD)
        :setFontColor("FFDF91")
        :setAnchorPoint(0.5, 0.5)
        :setAnchorTextShadow(true)
        :setWrapMode(1)
        :setPosition(self.spr_top_bg:getPositionX(), self.spr_top_bg:getPositionY())
    self.node_win:addChild(lbl_comment)
    local rounds = 0
    if result and result.report and result.report.rounds then
        rounds = #result.report.rounds
    end
    local str = string.format(ex.Tools:getLang(75601), rounds)
    if is_jump then
        str = str .. string.format(ex.Tools:getLang(75602), data.mission_id + 1)
    end

    lbl_comment:setXmlTextLua(str)
    lbl_comment:formatText()

    if not result.reward or #result.reward == 0 then
        return
    end

    local startX = 0
    local scale = 1
    local offsetX = 30
    for i, v in ipairs(result.reward) do
        local item = ex.Tools:createBackpackItem(v.type, v.num)
        local itemW = item:getContentSize().width * scale
        local itemH = item:getContentSize().height * scale

        if i == 1 then
            local halfNum = math.floor(#result.reward / 2)
            if #result.reward % 2 == 0 then
                startX = startX - (halfNum - 1) * (itemW + offsetX) - (itemW + offsetX) / 2
            else
                startX = startX - halfNum * (itemW + offsetX)
            end
        end

        item:setScale(scale)
        item:setPosition(startX + (i - 1) * (itemW + offsetX), 0)
        item:registerScriptTapHandler(handler(self, self.onItemInfo))
        self.win_menu:addChild(item)
    end
end

function STMagicTowerBattleEndLayer:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end


-----------------------------------------------------------------------------
function STMagicTowerBattleEndCtr:onCreate()
    self:setCCBIPath("ccbi/STMagicTowerBattleEndLayer.ccbi")
    self:setIsSingle(false)
end

function STMagicTowerBattleEndCtr:getLayerClass()
    return STMagicTowerBattleEndLayer
end

function STMagicTowerBattleEndCtr:openWindow(battle_type, data)
    if self:isOpened() then
        return
    end

    self.data = data

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/battle-end-1.plist")
    sfc:addSpriteFrames("ccbi-res/lang-1.plist")
    sfc:addSpriteFrames("ccbi-res/time-tower.plist")

    self:loadLayer()
    self:open()
    self:initData(data)
end

function STMagicTowerBattleEndCtr:closeWindow(params1, params2)
    self.super.closeWindow(self, params1, params2)
    ex.EventManager:fire(EVENT.SPACE_TIME_MAGIC_TOWER.BATTLE_END_CLOSE, self.data)
end


function STMagicTowerBattleEndCtr:initData(data)
    self.layer.btn_report:registerScriptTapHandler(handler(self, self.onReport))

    local settle_data = data.settle_data
    if not settle_data or not settle_data.report then
        return
    end

    self.layer:updateLayer(data)
end

function STMagicTowerBattleEndCtr:onReport(tag, pSender)
    if not self.data or not self.data.settle_data or not self.data.settle_data.report then
        return
    end

    require("src.layer.BattleDetailCtr"):instance():openWindow(self.data.settle_data.report.log)
end

return STMagicTowerBattleEndCtr
