
--超级大奖
local PROMChristmasSuperRewardCtr = class("PROMChristmasSuperRewardCtr",require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PROMChristmasSuperRewardLayer = class("PROMChristmasSuperRewardLayer", require("src.comp.EventLayer"))
local PROMChristmasSuperRewardItem = class("PROMChristmasSuperRewardItem", require("src.comp.EventLayer"))
local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

------------------------------------ PROMChristmasSuperRewardItem ------------------------------------
function PROMChristmasSuperRewardItem:onCreate()
    self:setSwallowTouches(false)
end

function PROMChristmasSuperRewardItem:resetData(data, turns, item_scroll_view)
    local max_weight = 0
    for i,v in ipairs(data) do
        max_weight = max_weight + v.weight
    end
    for i,v in ipairs(data) do
        self.spr_choose:setVisible(v.turns == turns)
        self.lbl_name:setString(string.format(ex.Tools:getLang(75102), v.turns))
        self["item_weight_"..i]:setString(string.format( "%.2f",(v.weight/max_weight)*100) .."%")
        local reward =  ex.Tools:createBackpackItem(v.reward[1].item_type,v.reward[1].item_num)
        reward:setScale(0.8)
        reward:registerScriptTapHandler(handler(self, self.onItem))
        self["menu_"..i]:addChild(reward)
        self["menu_"..i]:setIsTouchInsideNode(item_scroll_view)
    end
end

function PROMChristmasSuperRewardItem:onItem(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

------------------------------------ PROMChristmasSuperRewardLayer ------------------------------------
function PROMChristmasSuperRewardLayer:onCreate()
    self:addBlackBackground()

    ex.Tools:setLimitWidth(self.lbl_skip, 150)
    ex.Tools:setLimitWidth(self.little_super_big_reward, 200)

    local view_size = cc.size(450, 480)
    self.item_scroll_view:setItemType(1)
    self.item_scroll_view:setViewSize(view_size)
    self.item_scroll_view:setItemSize(cc.size(400,155))  
    self.item_scroll_view:setSwallowsTouches(false)

    self.btn_skip:setChecked(not cc.UserDefault:getInstance():getBoolForKey(string.format("%s_super_reward_is_open", ex.Player.role_id), true))
    self:updateLayer()

end

function PROMChristmasSuperRewardLayer:updateLayer(turns)
    self.item_list = {}
    local item_data = cfg.promotion091Gashaponlotteryreward.promotion091Gashaponlotteryreward
    local max_turns = 0
    for i,v in ipairs(item_data) do 
        if v.turns > max_turns  then
            max_turns = v.turns
        end
    end

    for i=1,max_turns do
        local turns_data = {}
        for j,v in ipairs(item_data) do
            if i == v.turns then
                table.insert(turns_data, v )
            end
        end
        table.insert( self.item_list, turns_data)
    end

    self.item_scroll_view.createItemFunction = function(item_data, scale)
        local cell = PROMChristmasSuperRewardItem:createWithCCBIFile("ccbi/PROMChristmasSuperRewardItem.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(cc.p(0.5, 0.5))
        cell:setPositionX(50)
        cell:resetData(item_data, turns, self.item_scroll_view)
        return cell
    end
    self.item_scroll_view:reloadData(self.item_list)
    if turns == 3 then      
        self.item_scroll_view:setContentOffset(cc.p(0,-120 * 1))
    elseif turns == 4 or turns == 5 then
        self.item_scroll_view:setContentOffset(cc.p(0, 0))
    end
    
end


function PROMChristmasSuperRewardLayer:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

---------------------------------------------PROMChristmasSuperRewardCtr---------------------------------------

function PROMChristmasSuperRewardCtr:onCreate()
	self:setCCBIPath("ccbi/PROMChristmasSuperRewardLayer.ccbi")
    self:setIsSingle(false)
end

function PROMChristmasSuperRewardCtr:getLayerClass()
	return PROMChristmasSuperRewardLayer
end

function PROMChristmasSuperRewardCtr:getAchievementLayer()
	return self.layer
end

function PROMChristmasSuperRewardCtr:openWindow(truns,pos)
	if self:isOpened() then
		return
    end
    
    self.start_pos = pos

    self:loadLayer()
    self:openAction()
    self:open()
    self:initData(truns)
end

function PROMChristmasSuperRewardCtr:initData(truns)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer:updateLayer(truns)
end

-- 打开动画
function PROMChristmasSuperRewardCtr:openAction(  )
    self.layer.node_main:setPosition(self.start_pos)
    self.layer.node_main:setScale(0.01)
    self.layer.node_main:runAction(cc.Sequence:create(
        cc.Spawn:create(
            cc.ScaleTo:create(1, 1),
            cc.JumpTo:create(1, cc.p(self.layer.node_core:getPositionX(),self.layer.node_core:getPositionY()),100, 3)
        ),
        nil))
end

-- 关闭动画
function PROMChristmasSuperRewardCtr:closeAction(  )
    self.layer.node_main:runAction(cc.Sequence:create(
        cc.Spawn:create(
            cc.ScaleTo:create(0.4, 0.01),
            cc.MoveTo:create(0.4, self.start_pos)
        ),
        cc.CallFunc:create(function()
            self.super.closeWindow(self)
        end),
        nil
    ))
end

-- 重写close
function PROMChristmasSuperRewardCtr:closeWindow(  )
    if self.layer.btn_skip:isChecked() then
        cc.UserDefault:getInstance():setIntegerForKey(string.format("%s_super_reward_time", ex.Player.role_id), ex.Game:getServerTime())
        cc.UserDefault:getInstance():setBoolForKey(string.format("%s_super_reward_is_open", ex.Player.role_id), false)
    else
        cc.UserDefault:getInstance():setBoolForKey(string.format("%s_super_reward_is_open", ex.Player.role_id), true)
    end
    self:closeAction()
end


return PROMChristmasSuperRewardCtr
