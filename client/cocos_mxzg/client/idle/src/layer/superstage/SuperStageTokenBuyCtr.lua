local SuperStageTokenBuyCtr = class("SuperStageTokenBuyCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local SuperStageTokenBuyLayer = class("SuperStageTokenBuyLayer", require("src.comp.EventLayer"))

local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

-----------------------------------------------------------------------------
function SuperStageTokenBuyLayer:onCreate()
    self:addBlackBackground()
    self:setAutoClose(true)
    self:setSwallowTouches(true)

    -- 设置購買按钮的灰色状态
    local spr_buy = cc.Sprite:createWithSpriteFrameName("button/btn-peach-2.png")
    ex.Tools:setGrayAuto(spr_buy, true)
    self.btn_confirm:setDisabledImage(spr_buy)
end

-----------------------------------------------------------------------------
function SuperStageTokenBuyCtr:onCreate()
    self:setCCBIPath("ccbi/SuperStageTokenBuyLayer.ccbi")
    self:setIsSingle(false)
end

function SuperStageTokenBuyCtr:getLayerClass()
    return SuperStageTokenBuyLayer
end

function SuperStageTokenBuyCtr:openWindow()
    if self:isOpened() then
        return
    end

    self:loadLayer()
    self:open()
    self:initData()
end

function SuperStageTokenBuyCtr:initData()
    self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))

    -- 商品配置
    self.config_buy_gem = cfg.buygem.buygem[2009]

    -- 獎勵item縮放
    local item_scale = 0.75

    -- 顯示激活獎勵
    self.layer.menu_reward_1:removeAllChildren()
    local reward_num_1 = #self.config_buy_gem.item
    for i,v in ipairs(self.config_buy_gem.item) do
        local item = UIMenuItemBackpack:createWithData(v.item_type, v.item_num)
        item:registerScriptTapHandler(handler(self, self.onItemInfo))
        item:setScale(item_scale)
        item:setPosition((i - reward_num_1 / 2 - 0.5) * 120 * item_scale, 0)
        self.layer.menu_reward_1:addChild(item)
    end

    -- 顯示激活特殊獎勵
    self.layer.menu_reward_2:removeAllChildren()
    local vec_token_reward = ex.Tools:getSysCfg("superstagetoken_reward_show")
    local reward_num_2 = #vec_token_reward
    for i,v in ipairs(vec_token_reward) do
        local item = UIMenuItemBackpack:createWithData(v.item_type, v.item_num)
        item:registerScriptTapHandler(handler(self, self.onItemInfo))
        item:setScale(item_scale)
        item:setPosition((i - reward_num_2 / 2 - 0.5) * 120 * item_scale, 0)
        self.layer.menu_reward_2:addChild(item)
    end

    self:updateLayer()
end

function SuperStageTokenBuyCtr:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function SuperStageTokenBuyCtr:updateLayer()
    -- 刷新顯示購買按鈕狀態
    self.layer.btn_confirm:setLabelText(string.format(ex.Tools:getLang(70610), self.config_buy_gem.rmb / 100))

    self.layer.btn_confirm:setEnabled(not ex.Player.super_stage_data.token_info.has_buy)
end

-- 購買回調
function SuperStageTokenBuyCtr:onConfirm(tag, pSender)
    if ex.Player.super_stage_data.token_info.has_buy then
        return
    end

    ex.Player:pay(self.config_buy_gem.idx)

    self:closeWindow(0, nil)
end

return SuperStageTokenBuyCtr
