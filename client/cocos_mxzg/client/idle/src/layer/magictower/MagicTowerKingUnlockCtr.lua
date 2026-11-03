local MagicTowerKingUnlockCtr = class('MagicTowerKingUnlockCtr', require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local MagicTowerKingUnlockLayer = class('MagicTowerKingUnlockLayer', require("src.layer.ui.UI_MagicTowerKingUnlockLayer"))

local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function MagicTowerKingUnlockLayer:onCreate()
	self.super.onCreate(self)
	self:setName("MagicTowerKingUnlockLayer")

    self:addBlackBackground()

    self:addEvent(EVENT.MAGIC_TOWER_EVENT.ROAD_INFO, handler(self, self.updateLayer))
end

-- 刷新显示解锁后可立刻获得的奖励
function MagicTowerKingUnlockLayer:updateUnlockReward(vec_reward)
    self.menu_reward_1:removeAllChildren()

    for i,item_data in ipairs(vec_reward) do
        local item = UIItemBackpack:createWithData(item_data.item_type, item_data.item_num)
        self.menu_reward_1:addChild(item)
    end

	self:resetLyt()
end

-- 刷新显示解锁后的星级奖励
function MagicTowerKingUnlockLayer:updateStarReward(vec_reward)
    self.menu_reward_2:removeAllChildren()

    for i,item_data in ipairs(vec_reward) do
        local item = UIItemBackpack:createWithData(item_data.item_type, item_data.item_num)
        self.menu_reward_2:addChild(item)
    end

	self:resetLyt()
end

function MagicTowerKingUnlockLayer:updateLayer()
    if ex.Player.magic_tower_data:getStarTotalNum() < cfg.system.magic_tower_king_gift_star or 
        ex.Player.magic_tower_data.is_buy_king then
        self:onClose()
        return
    end

    local buy_gem_idx = ex.Tools:getSysCfg("magic_tower_king_buy_gem_id")
    local buy_gem_config = cfg.buygem.buygem[buy_gem_idx]
    if buy_gem_config == nil then
        return
    end

    self:updateUnlockReward(buy_gem_config.item)

    local star_reward = {}
    for _,v in pairs(cfg.magictowerkingreward.magictowerkingreward) do
        for _,item in ipairs(v.reward) do
            local reward_data = clone(item)
            local is_have = false
            for _,v2 in ipairs(star_reward) do
                if v2.item_type == reward_data.item_type then
                    v2.item_num = v2.item_num + reward_data.item_num
                    is_have = true
                    break
                end
            end

            if not is_have then
                table.insert(star_reward, reward_data)
            end
        end
    end
    
    self:updateStarReward(star_reward)

    self.btn_buy:setLabelText(string.format(ex.Tools:getLang(70610), buy_gem_config.rmb / 100))
end

function MagicTowerKingUnlockLayer:onBuy()
    if ex.Player.magic_tower_data:getStarTotalNum() < cfg.system.magic_tower_king_gift_star then
        ex.MessageView:add(string.format(ex.Tools:getLang(57543), cfg.system.magic_tower_king_gift_star))
        return
    end

    local buy_gem_idx = ex.Tools:getSysCfg("magic_tower_king_buy_gem_id")
    ex.Player:pay(buy_gem_idx)
end

function MagicTowerKingUnlockCtr:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-----------------------------------------------------------------------------
function MagicTowerKingUnlockCtr:loadLayer()
	local tmp_layer = MagicTowerKingUnlockLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function MagicTowerKingUnlockCtr:openWindow()
    if self:isOpened() then
        return
    end
    
    self:loadLayer()
    self:open()

    self.layer:updateLayer()
end

return MagicTowerKingUnlockCtr
