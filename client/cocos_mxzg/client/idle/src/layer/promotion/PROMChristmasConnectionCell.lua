--[[
* @Description: 圣诞节活动 - 圣诞连线 - 任务预制体
* @Author: 熊梦
* @Date: 2020-12-14 10:31:00
* ]]
local PROMChristmasConnectionCell = class("PROMChristmasConnectionCell", require("src.layer.promotion.PromotionBaseLayer"))
-----------------------------------------------------------------------
function PROMChristmasConnectionCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end

function PROMChristmasConnectionCell:initData(data, ScrollView)
    self.idx = data.idx
    self.jump_info = data.jump_info
    self.lbl_taks_name = cpp.RichTextEx:createWithXMLLua(""):setFontSize(22):setFontFace(FONT_DEFAULT_NAME_BOLD):setFontColor("#7A472D"):setScale(1):setPosition(18, 113):setAnchorPoint(ex.a.zero)

    if data.condition ~= -1 then
        self.lbl_taks_name:setXmlTextLua(ex.Tools:taskString(data.land, data.target.target, data.target.condition))
    else
        self.lbl_taks_name:setXmlTextLua(ex.Tools:taskString(data.land, data.target.target))
    end

    self.node_lbl:addChild(self.lbl_taks_name)

    for i, v in ipairs(data.reward) do
        local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
        item:registerScriptTapHandler(handler(self, self.onItemInfo))
        item:setPosition(18 + (i - 1) * 100, 50)
        item:setScale(0.8)
        self.menu:addChild(item)
    end
    self.menu:setIsTouchInsideNode(ScrollView)

    self.lbl_taks_num:setString(string.format("(%s/%s)", ex.Tools:taskNum(data.target.type, data.progress), ex.Tools:taskNum(data.target.type, data.target.target)))

    self.progress = data.progress
    self.target = data.target.target

    if data.progress >= data.target.target then
        if data.had_reward == 0 then
            self.btn_goto:setVisible(false)
            self.btn_done:setVisible(true)
            -- 固定死的红点
            ex.Tools:addRedPoint(self.btn_done, true, cc.p(0.95, 0.85))
        else
            self.btn_goto:setVisible(false)
            self.btn_done:setVisible(false)
            self.spr_geted:setVisible(true)
        end
    else
        self.btn_goto:setVisible(true)
        self.btn_done:setVisible(false)
    end
end

function PROMChristmasConnectionCell:onGoto(event, sender)
    -- 回调函数
    local backToLayer = function(layer)
        layer:resetSelectLayer(1402)
    end
    local params = {}
    params.backToLayer = backToLayer

    ex.JumpManager:jumpByAtom(self.jump_info.event_arg, params)
end

function PROMChristmasConnectionCell:onDone(event, sender)
    if self.progress < self.target then
        ex.MessageView:add(ex.Tools:getLang(41262))
        return
    end
    sender:setEnabled(false)

    local req = Promotion085_pb.GReqChristmasMissionGetMission()
    req.idx = self.idx
    NetManager:sendMessage(ProtocolID.GReqChristmasMissionGetMission, req)
end

function PROMChristmasConnectionCell:onItemInfo(event, sender)
    ex.Tools:onClickItemInfo(sender.item_type)
end

return PROMChristmasConnectionCell
