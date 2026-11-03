--[[
    func: 国战 - 战旗任务
    版权所有:广州暗耀晶石网络信息科技有限公司
]]
local CountryWarTaskRewardCtr = class("CountryWarTaskRewardCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local CountryWarTaskRewardLayer = class("CountryWarTaskRewardLayer", require("src.comp.EventLayerAdaptiveWidth"))
local CountryWarTaskRewardCell = class("CountryWarTaskRewardCell", require("src.layer.promotion.PromotionBaseLayer"))

--------------------------------------------CountryWarTaskRewardCell--------------------------------------------
function CountryWarTaskRewardCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end

function CountryWarTaskRewardCell:initData(data)
    self.idx = data.idx
    -- self.jump_info = data.jump_info
    self.lbl_taks_name = cpp.RichTextEx:createWithXMLLua("")
                                       :setFontSize(22):setFontFace(FONT_DEFAULT_NAME_BOLD)
                                       :setFontColor("#7A472D")
                                       :setScale(1)
                                       :setAnchorPoint(ex.a.left_center)

    if data.condition ~= -1 then
        self.lbl_taks_name:setXmlTextLua(ex.Tools:taskString(data.lang, data.target.target, data.target.condition))
    else
        self.lbl_taks_name:setXmlTextLua(ex.Tools:taskString(data.lang, data.target.target))
    end

    self.node_lbl:addChild(self.lbl_taks_name)

    
    -- 繁体适配注释 别的版本就解除掉
    --self.lbl_taks_name:formatText()
    --ex.Tools:setLimitWidth(self.lbl_taks_name, 420)
    --------------------------------------
    
    for i, v in ipairs(data.reward) do
        local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
        item:registerScriptTapHandler(handler(self, self.onItemInfo))
        item:setPosition(18 + (i - 1) * 100, 40)
        item:setScale(0.6)
        self.menu:addChild(item)
    end

    self.lbl_taks_num:setString(string.format("(%s/%s)", ex.Tools:taskNum(data.target.type, data.progress), ex.Tools:taskNum(data.target.type, data.target.target)))

    self.progress = data.progress
    self.target = data.target.target

    if data.progress >= data.target.target then
        if data.had_reward == 0 then
            self.btn_done:setEnabled(true)
            self.btn_done:setVisible(true)  
            -- 固定死的红点
            ex.Tools:addRedPoint(self.btn_done, true, cc.p(0.95, 0.85))
        else
            self.btn_done:setVisible(false)
            self.spr_geted:setVisible(true)
        end
    else
        ex.Tools:setAllGrayAuto(self.btn_done:getNormalImage(), true)
        self.btn_done:setEnabled(false)
    end
end

function CountryWarTaskRewardCell:onDone(event, sender)
    if self.progress < self.target then
        ex.MessageView:add(ex.Tools:getLang(41262))
        return
    end
    sender:setEnabled(false)
    ctr.country_war:gReqCountryWarFlagMissionGet(self.idx)
end

function CountryWarTaskRewardCell:onItemInfo(event, sender)
    ex.Tools:onClickItemInfo(sender.item_type)
end

--------------------------------------------CountryWarTaskRewardLayer--------------------------------------------
function CountryWarTaskRewardLayer:onCreate()
    self:addBlackBackground()

    ex.Tools:setLimitWidth(self.lbl_integral_privilege, 500)
    ex.Tools:setLimitWidth(self.lbl_title, 150)
    for i=1,5 do
        ex.Tools:setAllGrayAuto(self["spr_flag_icon_"..i], true)
    end
    self.spr_geted:setVisible(false)
    self.item_scale = math.min(1, self.task_scroll_view:getViewSize().width / 502)
    self.task_scroll_view:setItemSize(cc.size(502 * self.item_scale, 120 * self.item_scale))
    self.task_scroll_view:setItemType(1)
    local item = cfg.countrywarflagroundreward.countrywarflagroundreward[ctr.country_war.data.type]
    self.lbl_reward_name:setString(ex.Tools:getLang(cfg.item.item[item.reward[1].item_type].name))
    ex.Tools:setLimitWidth(self.lbl_reward_name, 130)
    ex.Tools:setSpriteFrame(self.btn_reward:getNormalImage(), string.format("backpack/%d.png", item.reward[1].item_type))
    self.btn_reward:setLabelText(tostring(item.reward[1].item_num))
    self.btn_reward:setScale(0.8)
    
    self:addEvent(EVENT.COUNTRY_WAR.UPDATA_TASK_REWARD, handler(self, self.updataLayer))
    self:updataLayer()
end

function CountryWarTaskRewardLayer:updataLayer()   
    if not ctr.country_war.data.task_data then
        return
    end
    if ctr.country_war.data:getTaskRewardEndReward() and #ctr.country_war.data.get_reward_num <= 0 then
        self.effect_node:removeAllChildren()
        local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_countrywar_flag_task")
        spr_effect:setScale(2)
        self.effect_node:addChild(spr_effect)
    end
    --是否领取最终奖励
    if #ctr.country_war.data.get_reward_num > 0 then
    self.btn_reward:setEnabled(false)
    self.effect_node:setVisible(false)
    self.spr_geted:setVisible(true)
    end
    self.task_scroll_view.createItemFunction = function(data, scale)
        local cell_layer = CountryWarTaskRewardCell:createWithCCBIFile("ccbi/CountryWarTaskRewardCell.ccbi")
        cell_layer:setIgnoreAnchorPointForPosition(false)
        cell_layer:setAnchorPoint(0.5, 0.5)
        cell_layer:initData(data)
        -- cell_layer:setScale(self.item_scale)
        return cell_layer
    end
    
    local round = ctr.country_war.data.task_round
    for i=1,round do
        local bool = ctr.country_war.data:getRoundTaskStatus(i)
        ex.Tools:setAllGrayAuto(self["spr_flag_icon_"..i], not bool)
    end
    
    local vec_task_data = {}
    for i, v in ipairs(cfg.countrywarflagmission.countrywarflagmission) do
        if round == v.round then
            table.insert(vec_task_data, clone(v))
        end
    end

    for k, v in pairs(vec_task_data) do
        local data = ctr.country_war.data.task_data[v.idx]
        if data then
            v.progress = data.progress
            v.had_reward = data.reward == true and 1 or 0
        else
            v.progress = 0
            v.had_reward = 0
        end
        
		if v.target.type == 'TOTAL_RECHARGE' then 
			v.progress =  v.progress * 0.01
			v.target.target = v.target.target * 0.01
		else 
			v.target.target = v.target.target
		end 
    end

    local function sort_table(a, b)
        local astatus = a.had_reward
        local bstatus = b.had_reward
     
        local aprogress = a.progress >= a.target.target and 0 or 1
        local bsprogress = b.progress >= b.target.target and 0 or 1

        if astatus == bstatus then
            if aprogress == bsprogress then
                return a.idx < b.idx
            else
                return aprogress < bsprogress
            end
        else
            return astatus < bstatus
        end
    end

    table.sort(vec_task_data, sort_table)
    self.task_scroll_view:reloadData(vec_task_data)
end

function CountryWarTaskRewardLayer:getRoundReward(tag, sender)
    local item = cfg.countrywarflagroundreward.countrywarflagroundreward[ctr.country_war.data.type]
    if ctr.country_war.data:getTaskRewardEndReward() then
        sender:setEnabled(false)
        self.spr_geted:setVisible(true)
        ctr.country_war:gReqCountryWarFlagRoundGet(item.idx)
    else 
        ex.Tools:onClickItemInfo(item.reward[1].item_type)
    end   
end


-----------------------------------------------------------------------------
function CountryWarTaskRewardCtr:onCreate()
	self:setCCBIPath("ccbi/CountryWarTaskRewardLayer.ccbi")
	self:setIsSingle(false)
end

function CountryWarTaskRewardCtr:getLayerClass()
	return CountryWarTaskRewardLayer
end

function CountryWarTaskRewardCtr:getAchievementLayer()
	return self.layer
end

function CountryWarTaskRewardCtr:openWindow()
	if self:isOpened() then
		return
	end
	self:loadLayer()
	self:open()
	self:initData()
end

function CountryWarTaskRewardCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
end

return CountryWarTaskRewardCtr