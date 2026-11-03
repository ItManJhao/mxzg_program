local SuperStageTop32Layer = class("SuperStageTop32Layer", require("src.comp.EventLayer"))

local GroundTitle = {
    ex.Tools:getLang(76033),
    ex.Tools:getLang(76034),
    ex.Tools:getLang(76035),
    ex.Tools:getLang(76036),
    ex.Tools:getLang(76037),
    ex.Tools:getLang(76038),
    ex.Tools:getLang(76039),
    ex.Tools:getLang(76040),
    ex.Tools:getLang(76041),
    ex.Tools:getLang(76042),
    ex.Tools:getLang(76043),
    ex.Tools:getLang(76044),
    ex.Tools:getLang(76045),
    ex.Tools:getLang(76046),
    ex.Tools:getLang(76047),
    ex.Tools:getLang(76048),
}

function SuperStageTop32Layer:onCreate()
    self.btn_top32:setChecked(true)
    self.btn_top32:setLabelOffset(cc.p(-15, -3))
    self.btn_top4:setLabelOffset(cc.p(15, -3))

    self.btn_top32:setLabelText(ex.Tools:getLang(76025))
    self.btn_top4:setLabelText(ex.Tools:getLang(76030))

    self:addEvent(EVENT.SUPER_STAGE.UPDATE_KNOCKOUT, handler(self, self.updateLayer))

    self.btn_left:getParent():setLocalZOrder(1)
    self.btn_right:getParent():setLocalZOrder(1)

    -- 引擎有bug。 从第一页切换到到第0页。不会收到回调
    self:addTimer("update", 100, handler(self, self.updateBtn), true)
end

function SuperStageTop32Layer:refresh()
    NetManager:sendMessage(ProtocolID.GReqScanPinnacleKnockout)
end

function SuperStageTop32Layer:resetY(y)
    y = y - 60
    self.node_top:setPositionY(y)
    -- self.node_info:setPositionY(y)
    self.spr_bg:setPositionY(y)

    -- 700.0
    local max_height = self.spr_bg:getPositionY() - (self.node_lineup:getPositionY() + 40)
    local scale =  math.min(1, math.min(ex.p.width / 640, max_height / 700))

    self.btn_left:getParent():setPositionY(self.node_lineup:getPositionY() + 40 + 700 * 0.5 * scale)
    self.btn_right:getParent():setPositionY(self.btn_left:getParent():getPositionY())

    self:updateLayer()
end


function SuperStageTop32Layer:updateLayer()
    self.btn_top32:setLabelColor(self.btn_top32:isChecked() and cc.c3b(128,61,20) or cc.c3b(20,89,128))
    self.btn_top4:setLabelColor(self.btn_top4:isChecked() and cc.c3b(128,61,20) or cc.c3b(20,89,128))

    if self.page_info ~= nil then
        self.page_info:removeFromParent()
        self.page_info = nil
    end
    -- 700.0
    local max_height = self.spr_bg:getPositionY() - (self.node_lineup:getPositionY() + 40)
    local scale =  math.min(1, math.min(ex.p.width / 640, max_height / 700))

    -- page view 128强有16页
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

    -- self.lbl_groud:setVisible(self.btn_top32:isChecked())
    -- self.btn_left:setVisible(self.btn_top32:isChecked())
    -- self.btn_right:setVisible(self.btn_top32:isChecked())

    local super_stage_data = ex.Player.super_stage_data
    if self.btn_top32:isChecked() then
        -- 创建128强比赛信息
        for i=1,16 do
            local node_info = require("src.layer.superstage.SuperStageTop8Cell"):createWithCCBIFile("ccbi/SuperStageTop8Cell.ccbi")
            node_info:setPosition(self.page_info:getContentSize().width * 0.5, self.page_info:getContentSize().height * 0.5)
            node_info:setScale(scale)
            -- node_info:setAnchorPoint(0, 0)

            local layout = ccui.Layout:create()
            layout:setContentSize(node_info:getContentSize().width * scale, node_info:getContentSize().height * scale)
            layout:setPosition(0,0)
            layout:addChild(node_info)

            self.page_info:addPage(layout)
            node_info:reset(super_stage_data.knockout_block1[i], 
                            super_stage_data.battle_stage, 
                            super_stage_data.battle_round,
                            table.nums(super_stage_data.knockout_block2) > 0)
        end
    else
        -- 创建前16强比赛信息
        for i=1,2 do
            local node_info = require("src.layer.superstage.SuperStageTop8Cell"):createWithCCBIFile("ccbi/SuperStageTop8Cell.ccbi")
            node_info:setPosition(self.page_info:getContentSize().width * 0.5, self.page_info:getContentSize().height * 0.5)
            node_info:setScale(scale)

            local layout = ccui.Layout:create()
            layout:setContentSize(node_info:getContentSize().width * scale, node_info:getContentSize().height * scale)
            layout:setPosition(0,0)
            layout:addChild(node_info)

            self.page_info:addPage(layout)
            node_info:reset(super_stage_data.knockout_block2[i],
                            super_stage_data.battle_stage, 
                            super_stage_data.battle_round,
                            table.nums(super_stage_data.knockout_block3) > 0)
        end
    end
    
    self.page_info:setCurrentPageIndex(0)
    self.page_info:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)

    self:updateBtn()
end

function SuperStageTop32Layer:onChangeLayer()
    self:updateLayer()
end

function SuperStageTop32Layer:onGuessList()
    require("src.layer.BetListCtr"):instance():openWindow({title = ex.Tools:getLang(47034),
                                                            data_func = function()
                                                                return ex.Player.super_stage_data.guess_record
                                                            end,
                                                            replay_func = function(bid)
                                                                local req_bid = Pinnacle_pb.GReqGetPinnacleBattle()
                                                                req_bid.bid = bid
                                                                NetManager:sendMessage(ProtocolID.GReqGetPinnacleBattle, req_bid)
                                                            end,
                                                            round_func = function(round)
                                                                return ex.Player.super_stage_data:getTopTitle(round)
                                                            end,
                                                            event = EVENT.SUPER_STAGE.UPDATE_GUESS_LIST})
    NetManager:sendMessage(ProtocolID.GReqPinnacleGuessList)
end

function SuperStageTop32Layer:onLeft()
    self.page_info:scrollToPage(math.max(0, self.page_info:getCurrentPageIndex() - 1), 1)
    self:updateBtn()
end

function SuperStageTop32Layer:onRight()
    local num = table.nums(self.page_info:getItems())
    -- math.min(num - 1, self.page_info:getCurrentPageIndex() + 1)
    self.page_info:scrollToPage(math.min(num - 1, self.page_info:getCurrentPageIndex() + 1), 1)
    -- self.page_info:setCurrentPageIndex(math.min(num - 1, self.page_info:getCurrentPageIndex() + 1))
    self:updateBtn()
end

function SuperStageTop32Layer:updateBtn()
    local page_index = self.page_info:getCurrentPageIndex()
    local page_num = table.nums(self.page_info:getItems())
    self.lbl_groud:setString(GroundTitle[page_index + 1])
    self.btn_left:setVisible(page_index ~= 0)
    self.btn_right:setVisible(page_index ~= (page_num - 1))
end

return SuperStageTop32Layer
