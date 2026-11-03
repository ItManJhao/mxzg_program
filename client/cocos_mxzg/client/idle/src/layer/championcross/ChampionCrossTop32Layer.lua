local ChampionTop32Layer = class("ChampionCrossTop32Layer", require("src.comp.EventLayer"))

local GroundTitle = {
    ex.Tools:getLang(47419),
    ex.Tools:getLang(47439),
    ex.Tools:getLang(47557),
    ex.Tools:getLang(47624),
    "E组",
    "F组",
    "G组",
    "H组",
}

function ChampionTop32Layer:onCreate()
    -- self.node_info = require("src.layer.championcross.ChampionCrossTop8Cell"):createWithCCBIFile("ccbi/ChampionCrossTop8Cell.ccbi")
    -- self.node_info:setIgnoreAnchorPointForPosition(false)
    -- self.node_info:setAnchorPoint(0.5, 1)
    -- self.node_info:setPosition(ex.p.width * 0.5, ex.p.height * 0.74)
    -- self:addChild(self.node_info)

    self.btn_top32:setChecked(true)
    self.btn_top32:setLabelOffset(cc.p(-15, -3))
    self.btn_top4:setLabelOffset(cc.p(15, -3))

    self.btn_top32:setLabelText(ex.Tools:getLang(71107))
    self.btn_top4:setLabelText(ex.Tools:getLang(73011))

    self:addEvent(EVENT.CHAMPIONCROSS_EVENT.UPDATE_KNOCKOUT, handler(self, self.updateLayer))


    self.btn_left:getParent():setLocalZOrder(1)
    self.btn_right:getParent():setLocalZOrder(1)

    -- 引擎有bug。 从第一页切换到到第0页。不会收到回调
    self:addTimer("update", 100, handler(self, self.updateBtn), true)
end

function ChampionTop32Layer:refresh()
    NetManager:sendMessage(ProtocolID.GReqScanChampionCrossKnockout)
end

function ChampionTop32Layer:resetY(y)
    y = y - 60
    self.node_top:setPositionY(y)
    -- self.node_info:setPositionY(y)
    self.spr_bg:setPositionY(y)

    -- 700.0
    local max_height = self.spr_bg:getPositionY() - (self.node_lineup:getPositionY() + 40)
    local scale =  math.min(1, math.min(ex.p.width / 640, max_height / 700))

    self.btn_left:getParent():setPositionY(self.node_lineup:getPositionY() + 40 + 700 * 0.5 * scale)
    self.btn_right:getParent():setPositionY(self.btn_left:getParent():getPositionY())


    -- 

    self:updateLayer()


    -- local max_height = y - (self.node_lineup:getPositionY() + 40)
    -- self.node_info:setScale(math.min(1, math.min(ex.p.width / self.node_info:getContentSize().width, max_height / self.node_info:getContentSize().height)))
end


function ChampionTop32Layer:updateLayer()

    self.btn_top32:setLabelColor(self.btn_top32:isChecked() and cc.c3b(128,61,20) or cc.c3b(20,89,128))
    self.btn_top4:setLabelColor(self.btn_top4:isChecked() and cc.c3b(128,61,20) or cc.c3b(20,89,128))


    if self.page_info ~= nil then
        self.page_info:removeFromParent()
        self.page_info = nil
    end
    -- 700.0
    local max_height = self.spr_bg:getPositionY() - (self.node_lineup:getPositionY() + 40)
    local scale =  math.min(1, math.min(ex.p.width / 640, max_height / 700))

    -- page view 32强有4页
    self.page_info = ccui.PageView:create()
    self.page_info:setContentSize(ex.p.width, 700 * scale)
    self.page_info:setTouchEnabled(true)
    self.page_info:setPosition(cc.p(0, self.node_lineup:getPositionY() + 40))
    self.page_info:setCustomScrollThreshold(20)
    self:addChild(self.page_info)


    self.page_info:addEventListener(function(sender,event)
        -- print("event", event)
        -- print(sender:getCurrentPageIndex())
        -- self:updateBtn()
        -- ccui.PageViewEventType.turning
    end)

    self.lbl_groud:setVisible(self.btn_top32:isChecked())
    self.btn_left:setVisible(self.btn_top32:isChecked())
    self.btn_right:setVisible(self.btn_top32:isChecked())

    if self.btn_top32:isChecked() then
        -- 创建64强比赛信息
        for i=1,8 do        
            local node_info = require("src.layer.championcross.ChampionCrossTop8Cell"):createWithCCBIFile("ccbi/ChampionCrossTop8Cell.ccbi")
            node_info:setPosition(self.page_info:getContentSize().width * 0.5, self.page_info:getContentSize().height * 0.5)
            node_info:setScale(scale)
            -- node_info:setAnchorPoint(0, 0)

            local layout = ccui.Layout:create()
            layout:setContentSize(node_info:getContentSize().width * scale, node_info:getContentSize().height * scale)
            layout:setPosition(0,0)
            layout:addChild(node_info)

            self.page_info:addPage(layout)

            node_info:reset(ex.Player.championcross_data.knockout_block[i], ex.Player.championcross_data.battle_stage, ex.Player.championcross_data.battle_round)
        end
    else
        -- 创建前8强比赛信息 
        local node_info = require("src.layer.championcross.ChampionCrossTop8FinalsCell"):createWithCCBIFile("ccbi/ChampionCrossTop8FinalsCell.ccbi")
        node_info:setPosition(self.page_info:getContentSize().width * 0.5, self.page_info:getContentSize().height * 0.5)
        node_info:setScale(scale)

        local layout = ccui.Layout:create()
        layout:setContentSize(node_info:getContentSize().width * scale, node_info:getContentSize().height * scale)
        layout:setPosition(0,0)
        layout:addChild(node_info)

        self.page_info:addPage(layout)
        node_info:reset(ex.Player.championcross_data.knockout_block4, ex.Player.championcross_data.battle_stage, ex.Player.championcross_data.battle_round)
    end
    self.page_info:setCurrentPageIndex(0)
    self.page_info:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)

    self:updateBtn()
end

function ChampionTop32Layer:onChangeLayer()
    self:updateLayer()
end

function ChampionTop32Layer:onGuessList()
    require("src.layer.championcross.ChampionCrossListCtr"):instance():openWindow({title=ex.Tools:getLang(47034),
                                                                         class=require("src.layer.championcross.ChampionCrossMyGuessCell"),
                                                                         file="ccbi/ChampionCrossMyGuessCell.ccbi",
                                                                         data_func=function()
                                                                             return ex.Player.championcross_data.guess_record
                                                                         end,
                                                                         event=EVENT.CHAMPIONCROSS_EVENT.UPDATE_GUESS_LIST})
    NetManager:sendMessage(ProtocolID.GReqChampionCrossGuessList)
end

function ChampionTop32Layer:onLeft()
    self.page_info:scrollToPage(math.max(0, self.page_info:getCurrentPageIndex() - 1), 1)
    self:updateBtn()
end

function ChampionTop32Layer:onRight()
    local num = table.nums(self.page_info:getItems())
    -- math.min(num - 1, self.page_info:getCurrentPageIndex() + 1)
    self.page_info:scrollToPage(math.min(num - 1, self.page_info:getCurrentPageIndex() + 1), 1)
    -- self.page_info:setCurrentPageIndex(math.min(num - 1, self.page_info:getCurrentPageIndex() + 1))
    self:updateBtn()
end

function ChampionTop32Layer:updateBtn()
    local page_index = self.page_info:getCurrentPageIndex()
    local page_num = table.nums(self.page_info:getItems())
    self.lbl_groud:setString(GroundTitle[page_index + 1])
    self.btn_left:setVisible(page_index ~= 0)
    self.btn_right:setVisible(page_index ~= (page_num - 1))
end

return ChampionTop32Layer
