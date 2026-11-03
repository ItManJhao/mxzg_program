local ArtifactSummonCtr = class("ArtifactSummonCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ArtifactSummonLayer = class("ArtifactSummonLayer", require("src.comp.EventLayerAdaptiveWidth"))

local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function ArtifactSummonLayer:onCreate()
    self:setAutoClose(true)
    self:addBlackBackground()

    local spine_effect = sp.SkeletonAnimation:create("spine/sqbx.json","spine/sqbx.atlas", 1)
    spine_effect:setAnimation(0, "stand", true)
    spine_effect:setPosition(self:getContentSize().width * 0.5, self:getContentSize().height * 0.5)
    self:addChild(spine_effect, 0, 10)

    self.lbl_go:setString(ex.Tools:getLang(72302))
    self.lbl_go_under:setScaleX(self.lbl_go:getContentSize().width / self.lbl_go_under:getContentSize().width)
    self.btn_go:setContentSize(cc.size(self.lbl_go:getContentSize().width * self.lbl_go:getScaleX(), self.lbl_go:getContentSize().height * self.lbl_go:getScaleY()))

    self.btn_summon_one:setLabelText(ex.Tools:getLang(72304))
    self.btn_summon_ten:setLabelText(ex.Tools:getLang(72305))

    self.lbl_tip:setString(ex.Tools:getLang(72307))
    
    local item_size = cc.size(104 * 0.8 + 15, 104 * 0.8 + 15)
    self.scroll_view.margin = 2.5
    self.scroll_view:setItemSize(item_size)

    -- 创建历史记录文本
    self.lbl_history_1 = require("src.comp.RichTextEx"):create()
	:setFontSize(40)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#FFFFFF")
    :setScale(0.5)
    :setAnchorPoint(0.5, 0.5)
	:setAnchorTextShadow(true)
	:setWrapMode(1)
    :setPosition(self:getContentSize().width / 2, 820)
    self:addChild(self.lbl_history_1, 10001)

    self.lbl_history_2 = require("src.comp.RichTextEx"):create()
	:setFontSize(40)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#FFFFFF")
    :setScale(0.5)
    :setAnchorPoint(0.5, 0.5)
	:setAnchorTextShadow(true)
    :setWrapMode(1)
    :setPosition(self:getContentSize().width / 2, 790)
    self:addChild(self.lbl_history_2, 10001)


    self:addRedDotNode(RedDotType.ZCJ_DHZC_YGZC_ZSYJ_SZTB_ZHAN, self.btn_summon_one)
end

function ArtifactSummonLayer:initDone()

end

function ArtifactSummonLayer:onSummonConfirm(tag, pSender)
    -- ex.Player.summon_data:done(tag, true) -- 1 2 3 4 5 6
    ex.Player.summon_data:done(tag, false)
end

-----------------------------------------------------------------------------
function ArtifactSummonCtr:onCreate()
	self:setCCBIPath("ccbi/ArtifactSummonLayer.ccbi")
	self:setIsSingle(false)
end

function ArtifactSummonCtr:getLayerClass()
	return ArtifactSummonLayer
end

function ArtifactSummonCtr:getArtifactSummonLayer()
	return self.layer
end

function ArtifactSummonCtr:openWindow()
	if self:isOpened() then
		return
    end
    
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/box-effect.plist")

	self:loadLayer()
	self:open()
	self:initData()
end

function ArtifactSummonCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_go:registerScriptTapHandler(handler(self, self.onSummonDetail))
    self.layer.btn_add:registerScriptTapHandler(handler(self, self.onItemSrc))
    self.layer.btn_reward_detail:registerScriptTapHandler(handler(self, self.onRewardDetail))
    self.layer.btn_summon_one:registerScriptTapHandler(handler(self, self.onSummonOne))
    self.layer.btn_summon_ten:registerScriptTapHandler(handler(self, self.onSummonTen))

    self.layer.btn_add.item_type = 901815

    -- 显示奖励预览
    local vec_reward = ex.Tools:getSysCfg("god_equipment_lottery_reward_show")
    self.layer.scroll_view:getContainer():removeAllChildren()
    self.layer.scroll_view.createItemFunction = function(data)
        local item = UIMenuItemBackpack:createWithData(data.item_type, 0)
        item:setScale(0.8)
        item:registerScriptTapHandler(handler(self, self.onItemInfo))
        return item
    end
    self.layer.scroll_view:reloadData(vec_reward)

    self:updateLayer()
    
	NetManager:sendMessage(ProtocolID.GReqScanGodEquipLottery)
end

function ArtifactSummonCtr:updateLayer()
    if self.layer == nil then
        return
    end

    -- 显示爆极品剩余次数
    self.layer.lbl_bubble_times:setString(tonumber(ex.Tools:getSysCfg("god_equipment_lottery_guarantee") - ex.Player.god_equip_data.lottery_lucky_times))

    local jewl_num = ex.Player:getItemNum(901815)
    -- 显示剩余宝珠数
    self.layer.lbl_num:setString(jewl_num)

    -- 显示免费次数
    self.layer.lbl_tip_summon_one_title:setVisible(ex.Player.god_equip_data.lottery_roll_num <= 0)
    self.layer.spr_summon_one_icon:setVisible(ex.Player.god_equip_data.lottery_roll_num <= 0)
    self.layer.lbl_summon_one_num:setVisible(ex.Player.god_equip_data.lottery_roll_num <= 0)
    self.layer.lbl_tip_summon_one:setVisible(ex.Player.god_equip_data.lottery_roll_num > 0)
    if ex.Player.god_equip_data.lottery_roll_num > 0 then
        self.layer.lbl_tip_summon_one:setString(ex.Tools:getLang(72306))
    elseif jewl_num > 0 then
        local item_summon_one_need = ex.Tools:getSysCfg("god_equipment_lottery_one_item")[1]
        self.layer.spr_summon_one_icon:setSpriteFrame("backpack/"..item_summon_one_need.item_type..".png")
        self.layer.lbl_summon_one_num:setString(item_summon_one_need.item_num)
    else
        local item_summon_one_gem = ex.Tools:getSysCfg("god_equipment_lottery_one_gem")[1]
        self.layer.spr_summon_one_icon:setSpriteFrame("backpack/"..item_summon_one_gem.item_type..".png")
        self.layer.lbl_summon_one_num:setString(item_summon_one_gem.item_num)
    end

    -- 显示十连消耗资源
    if jewl_num >= 10 then
        local item_summon_ten_need = ex.Tools:getSysCfg("god_equipment_lottery_ten_item")[1]
        self.layer.spr_summon_ten_icon:setSpriteFrame("backpack/"..item_summon_ten_need.item_type..".png")
        self.layer.lbl_summon_ten_num:setString(item_summon_ten_need.item_num)
    else
        local item_summon_ten_gem = ex.Tools:getSysCfg("god_equipment_lottery_ten_gem")[1]
        self.layer.spr_summon_ten_icon:setSpriteFrame("backpack/"..item_summon_ten_gem.item_type..".png")
        self.layer.lbl_summon_ten_num:setString(item_summon_ten_gem.item_num)
    end

    self:updateHistory()
end

function ArtifactSummonCtr:updateHistory()
    -- 查询头两条历史数据，如果不存在，则隐藏记录文本
    if ex.Player.god_equip_data.lottery_new_records[1] ~= nil then
        local data = ex.Player.god_equip_data.lottery_new_records[1]
        local item_config = cfg.item.item[data.item_type]
        self.layer.lbl_history_1:setVisible(true)
        self.layer.lbl_history_1:setXmlTextLua(string.format(ex.Tools:getLang(72350 + item_config.rare_mark), data.name, ex.Tools:getLang(item_config.name), data.item_num))
        self.layer.lbl_history_1:formatText()
    else
        self.layer.lbl_history_1:setVisible(false)
    end

    if ex.Player.god_equip_data.lottery_new_records[2] ~= nil then
        local data = ex.Player.god_equip_data.lottery_new_records[2]
        local item_config = cfg.item.item[data.item_type]
        self.layer.lbl_history_2:setVisible(true)
        self.layer.lbl_history_2:setXmlTextLua(string.format(ex.Tools:getLang(72350 + item_config.rare_mark), data.name, ex.Tools:getLang(item_config.name), data.item_num))
        self.layer.lbl_history_2:formatText()
    else
        self.layer.lbl_history_2:setVisible(false)
    end
end

function ArtifactSummonCtr:onSummonDetail(tag, pSender)
    require("src.layer.artifact.ArtifactSummonHistoryCtr"):instance():openWindow()
end

function ArtifactSummonCtr:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function ArtifactSummonCtr:onItemSrc(tag, pSender)
    ex.Tools:onClickItemSrc(pSender.item_type)
end

function ArtifactSummonCtr:onRewardDetail(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42066), ex.Tools:getLang(42067))
end

function ArtifactSummonCtr:onSummonOne(tag, pSender)
    if ex.Player.god_equip_data.lottery_roll_num <= 0 then
        local item_summon_one_need = ex.Tools:getSysCfg("god_equipment_lottery_one_item")[1]
        local jewl_num = ex.Player:getItemNum(item_summon_one_need.item_type)
        if jewl_num < item_summon_one_need.item_num then
            local item_summon_one_gem = ex.Tools:getSysCfg("god_equipment_lottery_one_gem")[1]
            local gem_num = ex.Player:getItemNum(item_summon_one_gem.item_type)
            if gem_num < item_summon_one_gem.item_num then
                ex.Tools:showEnoughTip(item_summon_one_gem.item_type, true)
                return
            end
        end
    end

    local req = GodEquip_pb.GReqLotteryGodEquip()
    req.type = 1
    NetManager:sendMessage(ProtocolID.GReqLotteryGodEquip, req)
end

function ArtifactSummonCtr:onSummonTen(tag, pSender)
        local item_summon_ten_need = ex.Tools:getSysCfg("god_equipment_lottery_ten_item")[1]
        local jewl_num = ex.Player:getItemNum(item_summon_ten_need.item_type)
        if jewl_num < item_summon_ten_need.item_num then
            local item_summon_ten_gem = ex.Tools:getSysCfg("god_equipment_lottery_ten_gem")[1]
            local gem_num = ex.Player:getItemNum(item_summon_ten_gem.item_type)
            if gem_num < item_summon_ten_gem.item_num then
                ex.Tools:showEnoughTip(item_summon_ten_gem.item_type, true)
                return
            end
        end

    local req = GodEquip_pb.GReqLotteryGodEquip()
    req.type = 10
    NetManager:sendMessage(ProtocolID.GReqLotteryGodEquip, req)
end

return ArtifactSummonCtr