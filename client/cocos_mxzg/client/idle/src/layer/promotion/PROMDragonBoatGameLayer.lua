--[[
* @Description: 端午节活动界面二：龙舟翻牌游戏 划龙舟
* @Author: 熊梦
* @Date: 2020-06-13 17:45:00
* ]]

local PROMDragonBoatGameLayer = class("PROMDragonBoatGameLayer", require("src.layer.promotion.PromotionBaseLayer"))
local PROMDragonBoatGameCell = class("PROMDragonBoatGameCell", require("src.comp.LuaLayerBase"))

-- 当前轮数的状态
local STATUS =
{
    NOTFINISHED = 0, -- 未翻完
    END = 1          -- 已经翻完
}
-----------------------------------------------------------------------------------------------------------------------
function PROMDragonBoatGameCell:onCreate()
	self:setAutoClose(false)
    self:setSwallowTouches(false)
end

function PROMDragonBoatGameCell:initData(data)
    -- grid_turns 网格轮数
    local grid_turns = ex.Player.promotion_data.promotiondragonboattaskinfo_value.grid_turns
    for key,value in ipairs(data) do
        self["btn_card_"..key]:setTag(value.idx)
        self["btn_card_"..key].key = key
        if value.reward_idx ~= 0 then
           for i,v in ipairs(cfg.promotiondragonboatcard.promotiondragonboatcard) do
               if grid_turns == v.turns and value.reward_idx == v.idx then
                    self["btn_card_"..key]:setVisible(false)
                    local item = ex.Tools:createBackpackItem(v.reward[1].item_type, v.reward[1].item_num)
                    item:setScale(0.9)
                    item:registerScriptTapHandler(handler(self, self.onItemInfo))
                    self["menu_prop"..key]:addChild(item)
               end
           end
       end
    end
end

function PROMDragonBoatGameCell:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function PROMDragonBoatGameCell:onFlip(event, sender)
    local cost = cfg.system.promotiondragonboat_cost
    if ex.Player:getItemNum(cost[1].item_type) < cost[1].item_num then
        sender:setEnabled(true)
        ex.MessageView:add(ex.Tools:getLang(75105))
        return
    end
    print("====================发送翻牌消息======================")
    sender:setEnabled(false)
    local req = Promotion064_pb.GReqTurnOverCard()
    req.grid_idx = sender:getTag()
    NetManager:sendMessage(ProtocolID.GReqTurnOverCard, req)
end

-----------------------------------------------------------------------------------------------------------------------


function PROMDragonBoatGameLayer:onCreate()
	self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.spr_bg1:setScaleX(ex.s.global_scale)
    self.spr_bg2:setScaleX(ex.s.global_scale)


    self.spr_bg1:setPositionY(self.spr_bg1:getPositionY() - require("src.model.Game"):instance():getNotchHeight())
    self.spr_bg2:setPositionY(self.spr_bg2:getPositionY() - require("src.model.Game"):instance():getNotchHeight())
    self.node_up:setPositionY(self.node_up:getPositionY() - require("src.model.Game"):instance():getNotchHeight())
    self.scroll_view:setPositionY(self.scroll_view:getPositionY() - require("src.model.Game"):instance():getNotchHeight())

    self.scroll_view:setViewSize(cc.size(self.scroll_view:getViewSize().width, self.scroll_view:getViewSize().height - require("src.model.Game"):instance():getNotchHeight()))
    self.scroll_view:setPositionY(self.scroll_view:getPositionY() + require("src.model.Game"):instance():getNotchHeight())


    self.node_xia:setScaleX(ex.s.global_scale)
  
    self.scroll_view:setItemSize(cc.size(640, 110))
    self.scroll_view:setItemType(1)

    -- 是否可以选择大奖  如果中了大奖 就不能选择大奖了
    self.bopenChoice = true
    
    self.grid_turns = ex.Player.promotion_data.promotiondragonboattaskinfo_value.grid_turns
    self.lbl_grid_turns:setString(string.format( ex.Tools:getLang(75102),self.grid_turns))

    local cost = cfg.system.promotiondragonboat_cost[1]
    self.spr_icon:setSpriteFrame(string.format("%s.png", cfg.item.item[cost.item_type].icon))
    self.lbl_num_1:setString(ex.Player:getItemNum(cost.item_type))

    --当前轮卡牌是否已全部翻完，1为是，0为否。
    self.status = 0    

    -- 最大轮数
    self.max_turns = 0   
    for i,v in ipairs(cfg.promotiondragonboatcard.promotiondragonboatcard) do
        self.max_turns = v.turns > self.max_turns and v.turns or self.max_turns
    end

    -- 设置皮肤预览的item_type
    self.btn_skin.item_type = 906231

    -- 翻牌消息返回
    self:addEvent(EVENT.PROMOTION_DRAGON_BOAT.GAME_UPDATE,handler(self,self.updateCell))

    -- 第二轮消息返回
    self:addEvent(EVENT.PROMOTION_DRAGON_BOAT.NEXT_GAME_UPDATE,handler(self,self.updateNextCell))

    -- 选择大奖后修改大奖图标
    self:addEvent(EVENT.PROMOTION_DRAGON_BOAT.GAME_ULTIMATE_UPDATE,handler(self,self.updateUltimate))

    if ex.Player.promotion_data.promotiondragonboattaskinfo_value.ultimate_id == 0 then
        require("src.layer.promotion.PROMDragonBoatGameChoiceCtr"):instance():openWindow()
    else
        for i,v in ipairs(cfg.promotiondragonboatcard.promotiondragonboatcard) do
            if v.type == 1 and v.turns == self.grid_turns and v.idx == ex.Player.promotion_data.promotiondragonboattaskinfo_value.ultimate_id then
                local item = ex.Tools:createBackpackItem(v.reward[1].item_type, v.reward[1].item_num)
                item:registerScriptTapHandler(handler(self, self.openChoice))
                --item:setPositionX(PropLeftPosX+Propinterval*index)
                --item:setScale(PropScale)
                self.menu_grand_prix:addChild(item)
                break
            end
        end
    end

    self:updateLayer()

end

function PROMDragonBoatGameLayer:updateUltimate(event, data)
    self.menu_grand_prix:removeAllChildren()
    for i,v in ipairs(cfg.promotiondragonboatcard.promotiondragonboatcard) do
        if v.type == 1 and v.turns == ex.Player.promotion_data.promotiondragonboattaskinfo_value.grid_turns and v.idx == data.idx then
            local item = ex.Tools:createBackpackItem(v.reward[1].item_type, v.reward[1].item_num)
            item:registerScriptTapHandler(handler(self, self.openChoice))
            --item:setPositionX(PropLeftPosX+Propinterval*index)
            --item:setScale(PropScale)
            self.menu_grand_prix:addChild(item)
            break
        end
    end
end

-- 显示道具来源
function PROMDragonBoatGameLayer:onConfirm()
    local cost = cfg.system.promotiondragonboat_cost[1]
	ex.Tools:onClickItemSrc(cost.item_type)	
end

-- 打开大奖选择界面
function PROMDragonBoatGameLayer:openChoice(event, sender)
    if not self.bopenChoice then
        ex.MessageView:add(ex.Tools:getLang(75106))
        return
    end

    require("src.layer.promotion.PROMDragonBoatGameChoiceCtr"):instance():openWindow()
    
end

function PROMDragonBoatGameLayer:updateNextCell(event,data)
    -- optional int32 grid_turns = 1;//网格轮次
    -- optional int32 ultimate_id = 2;//特殊奖励idx
    -- repeated PSGridInfo grids = 3;//已翻牌网格信息
    ex.Player.promotion_data.promotiondragonboattaskinfo_value.grid_turns = data.grid_turns
    ex.Player.promotion_data.promotiondragonboattaskinfo_value.ultimate_id = data.ultimate_id
    ex.Player.promotion_data.promotiondragonboattaskinfo_value.grids = data.grids
    self.grid_turns = ex.Player.promotion_data.promotiondragonboattaskinfo_value.grid_turns
    self.lbl_grid_turns:setString(string.format( ex.Tools:getLang(75102),self.grid_turns))
    self.bopenChoice = true
    require("src.layer.promotion.PROMDragonBoatGameChoiceCtr"):instance():openWindow()
    self:updateLayer()
end


function PROMDragonBoatGameLayer:updateCell(event,data)
    ex.Player.promotion_data.promotiondragonboattaskinfo_value.grids = data.grids

    --修改剩余的道具
    local cost = cfg.system.promotiondragonboat_cost[1]
    self.lbl_num_1:setString(ex.Player:getItemNum(cost.item_type))

    --当前轮卡牌是否已全部翻完，1为是，0为否。
    self.status = data.status   
    
     -- grid_turns 网格轮数
    local grid_turns = ex.Player.promotion_data.promotiondragonboattaskinfo_value.grid_turns
    local vec_children = self.scroll_view.menu:getChildren()
    for _,v in pairs(vec_children) do
        for i=1,6 do
            local btn = v["btn_card_"..i]
            if btn:getTag() == data.grid_id then
                local menu_prop = v["menu_prop"..btn.key]
                for h,j in ipairs(cfg.promotiondragonboatcard.promotiondragonboatcard) do
                    if grid_turns == j.turns and data.reward_idx == j.idx then
                        local item_type = j.reward[1].item_type
                        local item_num = j.reward[1].item_num
                        local item = ex.Tools:createBackpackItem(item_type, item_num)
                        item:setScale(0.9)
                        item:registerScriptTapHandler(handler(self, self.onItemInfo))
                        menu_prop:addChild(item)
                        menu_prop:hide()
                        self:openCard(btn,menu_prop,j.type,item_type,item_num)
                        return
                    end
                end
            end
        end 
    end
end

-- 显示道具详情
function PROMDragonBoatGameLayer:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-- 请求下一轮数据
function PROMDragonBoatGameLayer:sendDragonBoatCards()
    local req = Promotion064_pb.GReqDragonBoatCards()
    NetManager:sendMessage(ProtocolID.GReqDragonBoatCards, req)
end

-- 开奖效果 翻牌
function PROMDragonBoatGameLayer:openCard(cardBg, cardFg,type,item_type,item_num,item)
    local grid_turns = ex.Player.promotion_data.promotiondragonboattaskinfo_value.grid_turns
    if self.status == STATUS.END and type ~= 1 and grid_turns < self.max_turns then
        self:sendDragonBoatCards()
    end

    if type == 1 then
        self.bopenChoice = false
    end
    local time = 0.1
    cc.Director:getInstance():setProjection(cc.DIRECTOR_PROJECTION2_D)
    cardBg:runAction(cc.Sequence:create(cc.OrbitCamera:create(time,1,0,0,90,0,0),cc.Hide:create(),cc.CallFunc:create(
        function()
            --开始角度是270，旋转90度
            cardBg:setVisible(false)
            cardFg:runAction(cc.Sequence:create(cc.Show:create(),cc.OrbitCamera:create(1,1,0,270,90,0,0),cc.CallFunc:create(
            function()
                -- 出的是大奖 显示大奖专用的中奖特效
                if type == 1 then
                    require("src.layer.promotion.PROMDragonBoatRewardCtr"):instance():openWindow(item_type,item_num)
                    if self.status == STATUS.END and grid_turns < self.max_turns then
                        self:sendDragonBoatCards()
                    end
                end
            end)))
        end
    )))
end

function PROMDragonBoatGameLayer:updateLayer()
    local list = {}
    -- grids : 已经翻牌的网格信息
    local grids = ex.Player.promotion_data.promotiondragonboattaskinfo_value.grids 
    -- 处理数据
    local index = 0
    local listTemp = {}
    for i=1,24 do
        local cell_data = {}
        --reward_idx = 开启的奖励配置idx
        cell_data.idx = i
        cell_data.reward_idx = 0
        for key,value in ipairs(grids) do
            if cell_data.idx == value.grid_idx then
                cell_data.reward_idx = value.reward_idx
                for g,p in ipairs(cfg.promotiondragonboatcard.promotiondragonboatcard) do
                    if cell_data.reward_idx == p.idx and p.type == 1 then
                        self.bopenChoice = false
                    end
                end
                break
            end
        end
        table.insert( listTemp, cell_data )
    end

    local function sort_table (a,b)
        return a.idx < b.idx
    end

    table.sort( listTemp, sort_table )

    local temp = {}
    for i,v in ipairs(listTemp) do
        table.insert( temp, v )
        index = index + 1
        if index == 6 then
            table.insert( list, self:DeepCopy(temp))
            temp = {}
            index = 0
        end
    end
    

    self.scroll_view.createItemFunction = function(data, scale)
        -- 创建ccbi cell
        local cell_layer = PROMDragonBoatGameCell:createWithCCBIFile("ccbi/PROMDragonBoatGameCell.ccbi")
        cell_layer:setIgnoreAnchorPointForPosition(false)
        cell_layer:setAnchorPoint(0.5, 0.5)
        cell_layer:setScale(scale)
        cell_layer:initData(data)

        return cell_layer
    end

    self.scroll_view:reloadData(list)

end

-- table深拷贝接口
function PROMDragonBoatGameLayer:DeepCopy(t)
    if nil == t then return nil end
    local table = {}
    for k,v in pairs(t) do
        if 'table' == type(v) then
            table[k] = self:DeepCopy(v)
        else
            table[k] = v
		end
	end
    return table
end

-- 皮肤界面预览
function PROMDragonBoatGameLayer:onSkinItem(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-- 皮肤战报预览
function PROMDragonBoatGameLayer:onSkinPreview(tag, pSender)
	if self.battle_layer ~= nil then
		return
	end

    local battle_end = function(layer, data)
        --ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LIMIT_TIME_SERVER)
        return true, false
    end
    local time_out = function()
        ex.EventManager:fire(EVENT.BATTLE_EVENT.BATTLE_END)
	end

	local battle_layer = self:getParent():getParent():addBattleLayerAuto(BattleType.TRIAL,
							MainSceneType.MAINCITY_LIMIT_TIME_SERVER,
							MainSceneType.MAINCITY_TRIAL_BATTLE,
							"",
							EVENT.TRIAL_EVENT.TRIAL_START,
							battle_end)
    battle_layer:setRecoveryType(RecoveryType.RT_CO_EXIST)
   
    local fashion_id = cfg.promotioneldragonboatprop.promotioneldragonboatprop[1].fashion_id

	ex.EventManager:fire(EVENT.TRIAL_EVENT.TRIAL_START, json.decode(cc.FileUtils:getInstance():getStringFromFile("config/fashion-"..fashion_id..".txt")))

    ex.AudioManager:playMusic(string.format("music/battle-%d.mp3", 1))
end

return PROMDragonBoatGameLayer
