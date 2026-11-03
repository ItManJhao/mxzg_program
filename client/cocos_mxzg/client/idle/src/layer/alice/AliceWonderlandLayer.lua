local AliceWonderlandLayer = class("AliceWonderlandLayer", require("src.layer.ui.UI_AliceWonderlandLayer"))

local BattleRoundCell = require("src.layer.battle.BattleRoundCell")

AliceWonderlandLayer.ctr = ctr.alice

local BTN_ELEM_CITY = {
    elem_1 = 1,
    elem_2 = 2,
    elem_3 = 3,
    elem_4 = 4,
    elem_5 = 5,
}

function AliceWonderlandLayer:onCreate()
    self.super.onCreate(self)
    
    ctr.alice:requestGetInfo()

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/alice.plist")
    -- sfc:addSpriteFrames("ccbi-res/alice.plist")
    -- 
    -- 註冊事件
    self:addEvent(EVENT.ALICE.ALICE_UPDATE, handler(self, self.updateLayer))
    self:addEvent(EVENT.ALICE.ALICE_START_BATTLE, handler(self, self.startBattle))
    self:addEvent(EVENT.ALICE.ALICE_UPDATE_LAYER, handler(self, self.updateLayer))
    self:addEvent(EVENT.ALICE.ALICE_RANK, handler(self, self.updateRank))

	self:addTimer("alice_open_time", 1000, handler(self, self.updateTime), true)
    self:updateTime()
    self:onAdaptation()
    self:initData()
    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.2), cc.CallFunc:create(handler(self, self.updateLayer))))
    -- self:updateLayer()
end

--界面适配
function AliceWonderlandLayer:onAdaptation()
    local notch_height = require("src.model.Game"):instance():getNotchHeight()
	local pos_y = ex.p.height - 230 * ex.s.global_scale - notch_height
    self.node_top:setPositionY(pos_y)
    self.menu_right_top:setPositionY(self.menu_right_top:getPositionY() - notch_height)
    self.spr_bg_3:setPosition(self.spr_bg_2:getPosition())
    -- local scale = ex.p.width / self.spr_bg_2:getContentSize().width
    self.spr_bg_2:setScaleX(ex.s.global_scale)
    -- print(ex.s.global_scale)
    -- print(self.menu_right_top:getPositionY())
    
end

function AliceWonderlandLayer:initData()
    self.now_star_data = nil    --当前关卡的数据
end

function AliceWonderlandLayer:updateTime()
    if ex.Game:getServerTime() > ctr.alice.data.end_time then
        cfg.funcopen["main_fantasy_land"].open()
    end
end

function AliceWonderlandLayer:updateLayer()
    -- local spr_left = cc.Sprite:createWithSpriteFrameName("alice/btn-left-right.png")
    -- spr_left:setFlippedX(true)
    -- self.btn_left:setNormalImage(spr_left)
    ctr.alice.data.cut_star = ctr.alice.data.star         --临时的层级
    self.btn_reset:setEnabled(ctr.alice.data:getLevelIsReset())
    ex.Tools:setAllGrayAuto(self.btn_reset:getNormalImage(), not ctr.alice.data:getLevelIsReset())
    
    self.select_tag = 5
    self.now_star_data = ctr.alice.data:getNowStarData()
    if self.now_star_data == nil then
        return
    end
    self.star_num:setString(string.format(ex.Tools:getLang(580001), ctr.alice.data.star))
    self.btn_left:setVisible(ctr.alice.data.star ~= ctr.alice.data:getMinimumStar())
    self.btn_right:setVisible(ctr.alice.data.star ~= ctr.alice.data:getMaxStar())
    print(self.now_star_data.assist_idx)
    self.btn_system_assis:setEnabled(self.now_star_data.assist_idx == 0)
    ex.Tools:setAllGrayAuto(self.btn_system_assis:getNormalImage(),self.now_star_data.assist_idx ~= 0) 
    self:updateRank()
    self:updateArea()
end

-- 更新小区块地图
function AliceWonderlandLayer:updateArea()
    local now_leve_data = ctr.alice.data:getNowStarCongigData()
    self.btn_start_battle:setEnabled(false)
    ex.Tools:setAllGrayAuto(self.btn_start_battle:getNormalImage(),true)
    for i=1,5 do
        self["map_shadow_"..i]:setVisible(false)
        self["effect_node_"..i.."_1"]:removeAllChildren()
        self["effect_node_"..i.."_2"]:removeAllChildren()
        self["pass_node_"..i]:setVisible(false)
        self["pass_line_left_"..i]:setPosition(self["lbl_pass_"..i]:getPositionX() - self["lbl_pass_"..i]:getContentSize().width / 2 - 10, self["lbl_pass_"..i]:getPositionY())
        self["pass_line_right_"..i]:setPosition(self["lbl_pass_"..i]:getPositionX() + self["lbl_pass_"..i]:getContentSize().width / 2 + 10, self["lbl_pass_"..i]:getPositionY())
        self["btn_city_"..i]:setEnabled(true)
    end

    for k,v in pairs(self.now_star_data.level_info) do
        for i,level_data in ipairs(now_leve_data) do
            if level_data.idx == v.level then
                self["btn_city_"..level_data.elem]:setEnabled( not v.kill)
                if v.kill then
                    self["effect_node_"..level_data.elem.."_1"]:removeAllChildren()
                    self["effect_node_"..level_data.elem.."_2"]:removeAllChildren()
                    self["btn_city_"..level_data.elem]:setEnabled(false)
                    -- self["map_shadow_"..level_data.elem]:setVisible(false)
                    --添加烟雾特效
                    local spr_effect_list = {}
                    for i=1,2 do
                        local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_alice_smoke_"..level_data.elem)
                        spr_effect:setPosition(0, 90)
                        table.insert( spr_effect_list,spr_effect )
                    end
                    self["effect_node_"..level_data.elem.."_2"]:setScale(0.5)
                    self["effect_node_"..level_data.elem.."_1"]:addChild(spr_effect_list[1])
                    self["effect_node_"..level_data.elem.."_2"]:addChild(spr_effect_list[2])
                    self["pass_node_"..level_data.elem]:setVisible(true)
                end
            end
        end
    end


    for k,v in ipairs(self.now_star_data.level_info) do
        if not v.kill then
            self.select_tag = k
            self["map_shadow_"..k]:setVisible(true)
            self["btn_city_"..k]:setEnabled(true)
            self.btn_start_battle:setEnabled(true)
            ex.Tools:setAllGrayAuto(self.btn_start_battle:getNormalImage(),false)
            break
        end 
    end
    
end

-- 更新小排行榜显示
function AliceWonderlandLayer:updateRank()
    -- dump(self.now_star_data)
    -- dump(ctr.alice.data.rank_data)
    local my_rank_data = nil
    if ctr.alice.data.rank_data then
        my_rank_data = ctr.alice.data.rank_data.self
    end
    
    self.node_left_reward:setVisible(false)
    self.node_left_rank:setVisible(false)
    local is_pass = true

    local function creatreward()
        self.node_left_reward:setVisible(true)
        local reward_data = cfg.alicestarreward.alicestarreward[ctr.alice.data.star]
        self.reward_scroll_view.createItemFunction = function (item_data)
            local item = nil
			if item_data ~= nil then
				item = ex.Tools:createBackpackItem(item_data.item_type,item_data.item_num)
				item:setScale(0.5)
				item:registerScriptTapHandler(handler(self, self.onItem))
			end
            return item
        end
        self.reward_scroll_view:reloadData(reward_data.reward)
    end
        if self.now_star_data.had_first then
            self.node_left_rank:setVisible(true)
            if my_rank_data.rank then
                self.lbl_rank_num:setString(my_rank_data.rank)
            end
            if my_rank_data.battle_round then
                self.lbl_consume_round_num:setString(my_rank_data.battle_round)
            end
            if my_rank_data.battle_dead then
                self.lbl_hero_die_num:setString(my_rank_data.battle_dead)
            end   
        else
            creatreward()
        end

end

function AliceWonderlandLayer:onLeft()
    ctr.alice.data.star = ctr.alice.data.star - 1
    ctr.alice.data.cut_star =  ctr.alice.data.star
    ctr.alice:reqRankData(ctr.alice.data.star)
    self:updateLayer()
end

function AliceWonderlandLayer:onRight()
    if self.now_star_data.had_first then
        ctr.alice.data.star = ctr.alice.data.star + 1
        ctr.alice.data.cut_star =  ctr.alice.data.star
        ctr.alice:reqRankData(ctr.alice.data.star)
        self:updateLayer()
    else
        ex.MessageView:add(ex.Tools:getLang(580038))
    end
end

function AliceWonderlandLayer:onCity(tag, pSender)
    if ctr.alice.data:getCityStage(tag) then
        ex.MessageView:add(ex.Tools:getLang(580022))
    else
        self.select_tag = tag
        for i=1,5 do
            self["map_shadow_"..i]:setVisible(i == tag)
        end
    end
    require("src.layer.alice.AliceWonderlandChallengeCtr"):instance():openWindow(self.select_tag)
end

function AliceWonderlandLayer:onBack()
    cfg.funcopen["main_fantasy_land"].open()
end

function AliceWonderlandLayer:onItem(tag, pSender)
    ex.Tools:onClickItemSrc(pSender.item_type)
end

-- 信息
function AliceWonderlandLayer:onInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(580040), ex.Tools:getLang(580041))
end

-- 排行榜
function AliceWonderlandLayer:onRank(tag, pSender)
    ctr.alice:reqRankData(ctr.alice.data.star)

    require("src.layer.alice.AliceRankCtr"):instance():openWindow(ctr.alice.data.star)
end

-- 奖励预览
function AliceWonderlandLayer:onReward(tag, pSender)
    require("src.layer.alice.AliceRewardCtr"):instance():openWindow(ctr.alice.data.star)
end

-- 商店
function AliceWonderlandLayer:onShop(tag, pSender)
    require("src.layer.alice.AliceShopCtr"):instance():openWindow()
end

-- 重置本层
function AliceWonderlandLayer:onReset(tag, pSender)
    require("src.layer.alice.AliceWonderlandLevelResetCtr"):instance():openWindow()
end

-- 挑战
function AliceWonderlandLayer:onChallenge(tag, pSender)
    require("src.layer.alice.AliceWonderlandChallengeCtr"):instance():openWindow(self.select_tag)
end

-- 助战
function AliceWonderlandLayer:onAssist(tag, pSender)
    require("src.layer.alice.AliceAssistCtr"):instance():openWindow(function (isselected)
        if isselected then
            self.btn_system_assis:setEnabled(false)
            ex.Tools:setAllGrayAuto(self.btn_system_assis:getNormalImage(),true) 
        end
       
    end)
end

function AliceWonderlandLayer:startBattle(event, battle_type, round)
    
    local callback = function(layer, data, vec_reward, ext)
        if self.round ~= nil and self.round >= #ext.report then
            require("src.layer.alice.AliceWonderlandBattleEndCtr"):instance():openWindow(ext, self.round)
            return true, false
        else
            self:startBattle(event, battle_type + 1, self.round + 1)
            ex.EventManager:fire(EVENT.ALICE.ALICE_BATTLE_INFO, ext.report[self.round], nil, ext)
        end         
    end

    if round == nil then 
        self.round = 1
    else
        self.round = round
    end
    print("self.round",self.round)
    local battle_layer = self:addBattleLayer(battle_type,
                                             MainSceneType.ALICE_WONDERLAND,
                                             "map_adventure", 
                                             EVENT.ALICE.ALICE_BATTLE_INFO,
                                             callback)

    if #ctr.alice.data.iswin > 1 then
        local cell = BattleRoundCell:create()
        local is_win = ctr.alice.data:getRound(self.round - 1)
        cell:resetData(is_win, #ctr.alice.data.iswin)
        cell:setPosition(battle_layer:getContentSize().width / 2, battle_layer:getContentSize().height - 100 -  require("src.model.Game"):instance():getNotchHeight() - 20 )
        battle_layer:addChild(cell, 1000)
    end
    
end

function AliceWonderlandLayer:onExit()
    --发送请求
    -- print("退出@@@@@@@@@@@@@@@@@@")
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KFSK_ALSXJ, ctr.alice.data:checkAliceRed()) 
    if ctr.alice.data:getIsAllFirstPass() then
        local req = Alice_pb.GReqAliceChangeStar()
        req.star = ctr.alice.data.star
        NetManager:sendMessage(ProtocolID.GReqAliceChangeStar, req)
    end
end


return AliceWonderlandLayer