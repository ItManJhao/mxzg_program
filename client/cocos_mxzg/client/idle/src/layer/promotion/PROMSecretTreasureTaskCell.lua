--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2020-08-11 14:44:24
]]

local PROMSecretTreasureTaskCell = class("PROMSecretTreasureTaskCell", require("src.layer.promotion.PromotionBaseLayer"))
-----------------------------------------------------------------------
function PROMSecretTreasureTaskCell:onCreate()
	self:setAutoClose(false)
    self:setSwallowTouches(false)
end


function PROMSecretTreasureTaskCell:initData(data)
    self.idx = data.idx
    self.jump_info = data.jump_info
    self.lbl_taks_name = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(22)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#7A472D")
    :setScale(1)
    :setPosition(18,113)
    :setAnchorPoint(ex.a.zero)

    if data.condition~= -1 then
        self.lbl_taks_name:setXmlTextLua(ex.Tools:taskString(data.land, data.target.target, data.target.condition))
    else
        self.lbl_taks_name:setXmlTextLua(ex.Tools:taskString(data.land, data.target.target))
    end

    self.node_lbl:addChild(self.lbl_taks_name)

    for i,v in ipairs(data.reward) do
        local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
        item:registerScriptTapHandler(handler(self, self.onItemInfo))
        item:setPosition(18+(i-1)*100,50)
        item:setScale(0.8)
        self.menu:addChild(item)
    end

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

function PROMSecretTreasureTaskCell:onGoto(event, sender)
    -- 回调函数
    local backToLayer =  function ( layer )
        layer:resetSelectLayer(803)
    end
    local params = {}
    params.backToLayer = backToLayer

    ex.JumpManager:jumpByAtom(self.jump_info.event_arg,params)
end


function PROMSecretTreasureTaskCell:onDone(event, sender)
    if  self.progress < self.target then
        ex.MessageView:add(ex.Tools:getLang(41262))
        return
    end
    sender:setEnabled(false)

    local req = Promotion070_pb.GReqGetMission()
    req.idx = self.idx
    NetManager:sendMessage(ProtocolID.GReqGetMission, req)
end

function PROMSecretTreasureTaskCell:onItemInfo(event, sender)
    ex.Tools:onClickItemInfo(sender.item_type)
end


return PROMSecretTreasureTaskCell