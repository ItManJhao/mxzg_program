local STMagicTowerRankRewardCtr = class("STMagicTowerRankRewardCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local STMagicTowerRewardLayer = class("STMagicTowerRewardLayer", require("src.comp.EventLayerAdaptiveWidth"))
local STMagicTowerRewardCell = class("STMagicTowerRewardCell", require("src.comp.LuaLayerBase"))

-----------------------------------------------------------------------------
function STMagicTowerRewardLayer:onCreate()
    self:addBlackBackground()
    self:setAutoClose(true)
    self:setSwallowTouches(true)
end

-------------------------------------STMagicTowerRewardCell-------------------------------------
function STMagicTowerRewardCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:setIgnoreAnchorPointForPosition(false)
    self:setAnchorPoint(0.5, 0.5)
end

function STMagicTowerRewardCell:reset(data)
    if not data then
        return
    end

    self.data = data
    if data.rank_min >= 1 and data.rank_min <= 3 then
        self.spr_rank:setVisible(true)
        self.lbl_rank:setVisible(false)
        self.spr_rank:setSpriteFrame(string.format("rank/spr-paihang-%s.png", data.rank_min))
        ex.Tools:setSpriteFrame(self.spr_rank, string.format("rank/spr-paihang-%s.png", data.rank_min))
    else
        self.spr_rank:setVisible(false)
        self.lbl_rank:setVisible(true)
        if data.rank_min ==  data.rank_max then
            self.lbl_rank:setString(data.rank_min)
        else
            self.lbl_rank:setString(string.format("%s-%s", data.rank_max, data.rank_min))
        end
    end

    if data.reward and #data.reward > 0 then
        local offsetX = 2
        local startX = self:getContentSize().width - 28.0
        local scale = 0.7
        for i, v in ipairs(data.reward) do
            local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
            local itemW = item:getContentSize().width * scale
            local itemH = item:getContentSize().height * scale
            if i == 1 then
                startX = startX - (#data.reward - 1) * (itemW + offsetX) - (itemW + offsetX) / 2
            end

            item:setScale(scale)
            item:setPosition(startX + (i - 1) * (itemW + offsetX), self:getContentSize().height / 2)
            item:registerScriptTapHandler(handler(self, self.onItemInfo))
            self.menu:addChild(item)
        end
    end
end

function STMagicTowerRewardCell:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-----------------------------------------------------------------------------
function STMagicTowerRankRewardCtr:onCreate()
    self:setCCBIPath("ccbi/STMagicTowerRankRewardLayer.ccbi")
    self:setIsSingle(false)
end

function STMagicTowerRankRewardCtr:getLayerClass()
    return STMagicTowerRewardLayer
end

function STMagicTowerRankRewardCtr:openWindow()
    if self:isOpened() then
        return
    end

    self:loadLayer()
    self:open()
    self:initData()
    self.layer:addEvent(EVENT.SPACE_TIME_MAGIC_TOWER.UPDATE_RANK, handler(self, self.updateMyRank))
    NetManager:sendMessage(ProtocolID.GReqTimeTowerRankInfo)
end

function STMagicTowerRankRewardCtr:initData(level)
    if not cfg.timetowerreward or not cfg.timetowerreward.timetowerreward or #cfg.timetowerreward.timetowerreward == 0 then
        return
    end

    local configs = cfg.timetowerreward.timetowerreward

    self.layer.scroll_view:setItemType(1)
    local sv_width = self.layer.spr_reward_scroll_view_bg:getContentSize().width - 10
    local sv_height = self.layer.spr_reward_scroll_view_bg:getContentSize().height - 20
    self.layer.scroll_view:setViewSize(cc.size(sv_width, sv_height))
    self.layer.scroll_view:setItemSize(cc.size(self.layer.scroll_view:getViewSize().width, 110))
    self.layer.scroll_view.createItemFunction = function(item_data, scale)
        local cell = STMagicTowerRewardCell:createWithCCBIFile("ccbi/STMagicTowerRankRewardCell.ccbi")
        cell:reset(item_data)
        cell.menu:setSwallowsTouches(false)
        cell.menu:setIsTouchInsideNode(self.layer.scroll_view)
        return cell
    end
    self.layer.scroll_view:reloadData(configs)
    self:updateMyRank()
end

function STMagicTowerRankRewardCtr:updateMyRank()
    local stmt_data = ex.Player.space_time_magic_tower_data
    local my_rank_str = ""
    if stmt_data.my_rank > 0 then
        my_rank_str = string.format(ex.Tools:getLang(72010), stmt_data.my_rank)
    else
        my_rank_str = string.format(ex.Tools:getLang(72010), ex.Tools:getLang(47749))
    end

    self.layer.lbl_my_record:setString(string.format("%s：%s",ex.Tools:getLang(5106), ex.Tools:getLang(75619)))
    self.layer.lbl_my_rank:setString(my_rank_str)
    self.layer.lbl_mission:setString(stmt_data.max_pass)
end

return STMagicTowerRankRewardCtr
