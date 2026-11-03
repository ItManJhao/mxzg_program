local MagicButterViewCtr = class("MagicButterViewCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local MagicButterViewLayer = class("MagicButterViewLayer", require("src.comp.EventLayerAdaptiveWidth"))
local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBag")

function MagicButterViewLayer:onCreate()
    self:addBlackBackground()
    self.progressLabels = {}
    self:createProgress()

    ex.Tools:setLabelOffset(self.lbl_sumom_num_text, self.lbl_summon_num, 5)
    self:addEvent(EVENT.MAGIC_BUTTERFLY.GET_REWARD,handler(self, self.updateView))
end

function MagicButterViewLayer:createProgress()
    local reward_cfg = cfg.promotionnewherolotter.promotionnewherolotter

    -- 进度条节点数
    local progress_count = #reward_cfg
    local vec_progress_data = {}
    local pos_x = self.spr_progress_bg:getPositionX() - self.spr_progress_bg:getContentSize().width * 0.5
    for k,v in ipairs(reward_cfg) do
        local lbl = self["lbl_num" .. k]
        lbl:setString(v.task_count)
        
        local percent = (lbl:getPositionX() - pos_x) / self.spr_progress_bg:getContentSize().width * 100

        table.insert(vec_progress_data, {pos = percent, count = v.task_count} )
    end

    self.progressTimer = require("src.comp.UIProgressTimerEquidistant"):create(cc.Sprite:createWithSpriteFrameName("magic-butterfly/jdt2-2.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0))
    self.spr_progress_bg:addChild(self.progressTimer)
    self.progressTimer:setPosition(self.spr_progress_bg:getContentSize().width / 2 ,self.spr_progress_bg:getContentSize().height / 2 )
    self.progressTimer:setPositionList(vec_progress_data)

    self:createMenu()
end

function MagicButterViewLayer:createMenu()
    self.menu = cpp.UIMenu:create()
	self:addChild(self.menu, 9999)
    self.menu:setPosition(0,0)
    
    local reward_cfg = cfg.promotionnewherolotter.promotionnewherolotter
    local max_progress = reward_cfg[#reward_cfg].task_count
    for k,v in pairs(reward_cfg) do
        local item_data = v.box_reward[1]
        local percent = v.task_count / max_progress
        local item = UIMenuItemBackpack:createWithData(item_data.item_type, item_data.item_num)--ex.Tools:createBackpackItem(item_data.item_type, item_data.item_num)
        item:setScale(0.8)
        item:setTag(v.idx)
        item:registerScriptTapHandler(handler(self,self.onClickItem))
        self.menu:addChild(item)
        item:setPosition( self["lbl_num"..k]:getPositionX(), 215)
    end

end

function MagicButterViewLayer:onClickItem(tag, pSender)
    local magic_butterfly_data = ex.Player.promotion_data.magic_butterfly_data
    local status = magic_butterfly_data:getBoxRewardStatus(tag)
    if status ~= 1 then
        ex.Tools:showItemInfo(tag, pSender)
        return
    end

    self:sendProto(tag)
end

function MagicButterViewLayer:sendProto(tag)
    local req = Promotion065_pb.GReqHeroRollingReward()
    req.idx = tag
    NetManager:sendMessage(ProtocolID.GReqHeroRollingReward, req)
end

function MagicButterViewLayer:updateView()
    local magic_butterfly_data = ex.Player.promotion_data.magic_butterfly_data
    self.lbl_summon_num:setString(magic_butterfly_data:getSummonNum())

    local reward_cfg = cfg.promotionnewherolotter.promotionnewherolotter
    self.progressTimer:setPercentageCount(magic_butterfly_data:getSummonNum())

    -- 更新奖励状态
    for i,v in pairs(reward_cfg) do
        local item = self.menu:getChildByTag(v.idx)
        if item then
            local status = magic_butterfly_data:getBoxRewardStatus(v.idx)
            item:setRewardStatus1(status)
        end
    end
end

-----------------------------------------------------------------------------
function MagicButterViewCtr:onCreate()
    self:setCCBIPath("ccbi/MagicButterViewLayer.ccbi")
    self:setIsSingle(false)
end

function MagicButterViewCtr:getLayerClass()
    return MagicButterViewLayer
end

function MagicButterViewCtr:getClanRankLayer()
    return self.layer
end

function MagicButterViewCtr:openWindow(data)
    if self:isOpened() then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/magic-butterfly.plist")

    self:loadLayer()
    self:open()
    self:initData(data)
end

function MagicButterViewCtr:initData(data)
    self.layer:updateView()
end


return MagicButterViewCtr
