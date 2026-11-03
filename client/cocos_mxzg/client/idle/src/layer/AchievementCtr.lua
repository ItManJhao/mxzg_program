local AchievementCtr = class("AchievementCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local AchievementLayer = class("AchievementLayer", require("src.comp.EventLayerAdaptiveWidth"))

--------------------------------------------

function AchievementLayer:onCreate()

    -- local last_content_size = self:getContentSize()
    local cur_content_size = self:getContentSize()
    -- local offset = cc.p(cur_content_size.width - last_content_size.width, cur_content_size.height - last_content_size.height)

    -- self:setContentSize(cur_content_size)
    -- self:setPosition(ex.p.width / 2 - self:getContentSize().width / 2, ex.p.height / 2 - self:getContentSize().height / 2 + 20)

    -- self.spr_bg:setContentSize(self.spr_bg:getContentSize().width + offset.x, self.spr_bg:getContentSize().height + offset.y)
    -- self.btn_close:setPosition(self.btn_close:getPositionX() + offset.x, self.btn_close:getPositionY() + offset.y)

    -- self.btn_daily:setPosition(self.btn_daily:getPositionX() + offset.x / 2, self.btn_daily:getPositionY() + offset.y)
    -- self.btn_achievement:setPosition(self.btn_achievement:getPositionX() + offset.x / 2, self.btn_achievement:getPositionY() + offset.y)

    -- self.spr_panel_bg:setPosition(self.spr_panel_bg:getPositionX() + offset.x / 2, self.spr_panel_bg:getPositionY())
    -- self.spr_panel_bg:setContentSize(self.spr_panel_bg:getContentSize().width, self.spr_panel_bg:getContentSize().height + offset.y)

	-- self:setExitCallback(handler(self,self.onExitCB))
    self.achievementPanel = require("src.layer.AchievementPanel"):create()
    self.achievementPanel:initWithContentSize(cc.size(554, cur_content_size.height - 152))
    self.dailyPanel = require("src.layer.DailyPanel"):createWithCCBIFile("ccbi/DailyPanel.ccbi")
    self.dailyPanel:initWithContentSize(cc.size(554, cur_content_size.height - 292))
    self.node_layer:addChild(self.achievementPanel)
    self.node_layer:addChild(self.dailyPanel)
    self.dailyPanel:setPosition(0, 0)
    self.achievementPanel:setPosition(0, 0)
    self:showBtnTitle()
    self.btn_daily:registerScriptTapHandler(handler(self, self.onClickDaily))
    self.btn_achievement:registerScriptTapHandler(handler(self, self.onClickAchievement))
    self.btn_daily:setLocalZOrder(2)
    self.btn_daily:setLocalZOrder(2)
    self.achievementPanel:setLocalZOrder(2)
    self.dailyPanel:setLocalZOrder(2)

    self.btn_daily:setLabelText(ex.Tools:getLang(5008))
    self.btn_achievement:setLabelText(ex.Tools:getLang(5037))

    -- ex.RedDotManager:setStickNode(RedDotType.ZCJ_DHZC_ZCCJ_ZCCJCJT,self.btn_achievement)
    -- ex.RedDotManager:setStickNode(RedDotType.ZCJ_DHZC_ZCCJ_ZCCJRCT,self.btn_daily)
    self:addRedDotNode(RedDotType.ZCJ_DHZC_ZCCJ_ZCCJCJT, self.btn_achievement)
    self:addRedDotNode(RedDotType.ZCJ_DHZD_RCCJ_CJ, self.btn_achievement)

    self:addRedDotNode(RedDotType.ZCJ_DHZC_ZCCJ_ZCCJRCT, self.btn_daily)
    self:addRedDotNode(RedDotType.ZCJ_DHZD_RCCJ_RC, self.btn_daily)

    self:addEvent(EVENT.ACHIEVEMENT_EVENT.DAILY_BOX,handler(self,self.updateBox))
    self:addBlackBackground()
end

function AchievementLayer:updateBox(event,data)
    self.dailyPanel:updateBox(event,data)
end

function AchievementLayer:showBtnTitle()
    self.btn_daily:setLabelText(ex.Tools:getLang(47364))
    self.btn_achievement:setLabelText(ex.Tools:getLang(47012))
end

function AchievementLayer:onClickDaily(tag , pSender)
    self.dailyPanel:setVisible(true)
    self.achievementPanel:setVisible(false)
end

function AchievementLayer:onClickAchievement(tag , pSender)
    self.dailyPanel:setVisible(false)
    self.achievementPanel:setVisible(true)
end

function AchievementLayer:onExit()
    print("AchievementLayer:onExit")
    -- ex.RedDotManager:removeStickNode(RedDotType.ZCJ_DHZC_ZCCJ_ZCCJCJT,self.btn_achievement)
    ex.RedDotManager:setStickNode(RedDotType.ZCJ_DHZC_ZCCJ_ZCCJRCT, nil)
    ex.RedDotManager:setStickNode(RedDotType.ZCJ_DHZC_ZCCJ_ZCCJCJT, nil)

    ex.RedDotManager:setStickNode(RedDotType.ZCJ_DHZD_RCCJ_CJ, nil)
    ex.RedDotManager:setStickNode(RedDotType.ZCJ_DHZD_RCCJ_RC, nil)
end

-----------------------------------------------------------------------------
function AchievementCtr:onCreate()
	self:setCCBIPath("ccbi/AchievementLayer.ccbi")
	self:setIsSingle(false)
end

function AchievementCtr:getLayerClass()
	return AchievementLayer
end

function AchievementCtr:getAchievementLayer()
	return self.layer
end

function AchievementCtr:openWindow(data)
	if self:isOpened() then
		return
	end
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/achievement.plist")
    sfc:addSpriteFrames("ccbi-res/box-effect.plist")
    -- sfc:addSpriteFrames("ccbi-res/rank.plist")
	self:loadLayer()
	self:open()
	self:initData(data)
end

function AchievementCtr:initData(data)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    
    ex.Player.achievement_data:reqAchievement()

	self:updateLayer(data)
end

function AchievementCtr:onClickUpgrade(tag,pSender)

end

function AchievementCtr:updateLayer(data)
    self.layer.btn_daily:setChecked(true)
    self.layer.achievementPanel:setVisible(false)
end

function AchievementCtr:selectDaily()
    self.layer.btn_daily:setChecked(true)
    self.layer.btn_achievement:setChecked(false)
    self.layer.dailyPanel:setVisible(true)
    self.layer.achievementPanel:setVisible(false)
end

function AchievementCtr:selectAchievement()
    self.layer.btn_daily:setChecked(false)
    self.layer.btn_achievement:setChecked(true)
    self.layer.dailyPanel:setVisible(false)
    self.layer.achievementPanel:setVisible(true)
end

return AchievementCtr
