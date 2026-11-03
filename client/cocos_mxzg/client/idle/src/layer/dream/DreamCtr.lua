local DreamCtr = class("DreamCtr", require("src.comp.EventLayerAdaptiveWidth"))

local DreamBattleType = 
{
    NORMAL = 1,
    BATTLEING = 2, 
    SELECT_BUFF = 3,
}


local string_format = string.format
function DreamCtr:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/rank.plist")

    local last_content_size = self:getContentSize()
    local cur_content_size = cc.size(ex.p.width - 20, ex.p.height - 350)
    local offset = cc.p(cur_content_size.width - last_content_size.width, cur_content_size.height - last_content_size.height)

    self:setContentSize(cur_content_size)
    self:setPosition(ex.p.width / 2 - self:getContentSize().width / 2, ex.p.height / 2 - self:getContentSize().height / 2 + 50)

    print("self:getScaleX()", self:getScaleX(), self:getScaleY())
	local notch_height = require("src.model.Game"):instance():getNotchHeight()
    self.btn_close:setPosition(self:getContentSize().width / 2 + ex.p.width / 2 / self:getScaleX() - 20 / self:getScaleX() - 60,
                              self:getContentSize().height / 2 + ex.p.height / 2 / self:getScaleY() - 100 / self:getScaleY() - 30 - notch_height)

                              
    self.spr_image_bg = cc.Sprite:create("ccbi-res/map-slzmbg.jpg")
    self.spr_image_bg:setScale(ex.p.width / self.spr_image_bg:getContentSize().width / self:getScaleX(), ex.p.height / self.spr_image_bg:getContentSize().height / self:getScaleY())
    self.spr_image_bg:setPosition(ex.p.center().x - self:getPositionX(), ex.p.center().y - self:getPositionY())
    self:addChild(self.spr_image_bg, -1)

    -- 设置所有位置
    self.message:setPosition(self.message:getPositionX() + offset.x / 2, self.message:getPositionY() + offset.y + 70)

    self.btn_close:registerScriptTapHandler(handler(self, self.onBack))
    self.btn_reward_msg:registerScriptTapHandler(handler(self, self.showRewardList))
    self.btn_show_rank:registerScriptTapHandler(handler(self, self.showRank))
    self.btn_get:registerScriptTapHandler(handler(self, self.btnGet))
    self.btn_battle:registerScriptTapHandler(handler(self, self.btnBattle))
    self.btn_select_friend:registerScriptTapHandler(handler(self, self.selectFriend))

    self.btn_exit:registerScriptTapHandler(handler(self, self.exitBattle))
    
    -- self.show_reward_msg:setAnchorPoint(cc.p(0))
    self.show_reward_msg:setLineHeight(33)

    self:addEvent(EVENT.DREAM_EVENT.UPDATE_RANK,handler(self,self.updateRank))
    self:addEvent(EVENT.DREAM_EVENT.LOAD_BATTLE,handler(self,self.onStartBattle))
    self:addEvent(EVENT.DREAM_EVENT.OPEN_SELECT_BUFF,handler(self,self.onSelectBuff))
    self:addEvent(EVENT.DREAM_EVENT.SHOW_REWARD_MESSAGE_PANEL,handler(self,self.onshowRewardPanel))
    self:addEvent(EVENT.DREAM_EVENT.UPDATE_REWARD_MESSAGE_PANEL,handler(self,self.updateData))

    self:addEvent(EVENT.DREAM_EVENT.UPDATE_FRIEND_RED,handler(self,self.showFriendRed))
    self:addEvent(EVENT.DREAM_EVENT.UPDATE_STATUS,handler(self,self.updateStatus))
    self:addEvent(EVENT.DREAM_EVENT.UPDATE_NOW_LEVEL,handler(self,self.updateNowLevel))
    
    self:initDone()

    -- 排行榜
    ex.Player.dream_data:gReqDreamlandWinAddLv()
    ex.Player.dream_data:gReqDreamlandRank()
    ex.Player.dream_data:gReqFriendAssistHeroList()
    ex.Player.dream_data:gReqDreamlandBattleStatus()

    ex.MainSceneCtr:addKeepLayer(MainSceneType.DREAM_LAYER)
    -- ex.MainSceneCtr:removeKeepLayer(MainSceneType.DREAM_LANG_BATTLE)
end



function DreamCtr:getAsynImage()
    local vec_image = {
        {image_name = "ccbi-res/map-slzmbg.jpg", remove_type=1},
    }
    return vec_image
end

function DreamCtr:updateStatus()

    if ex.Player.dream_data.status == 1 then
        -- ex.Player.dream_data:gReqDreamlandStartBattle()
        -- require("src.layer.dream.DreamSelectCtr"):instance():closeWindow()
    elseif ex.Player.dream_data.status == 2 then
        -- GReqDreamlandStartBattle
        self:getNextBattleData()
        require("src.layer.dream.DreamSelectCtr"):instance():closeWindow()
    else
        require("src.layer.dream.DreamSelectCtr"):instance():openWindow()
    end

    ex.EventManager:fire(EVENT.DREAM_EVENT.SHOW_REWARD_MESSAGE_PANEL)
end

function DreamCtr:updateRank(event,data)

    self:refreshRankList()
    self:setMyRank( )
end

function DreamCtr:onClick(tag,pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end


function DreamCtr:onBtnInfo(tag,pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42042), ex.Tools:getLang(42043))
end 

function DreamCtr:exitBattle(tag,pSender)


    ex.ConfirmCtr:openWindow(ex.Tools:getLang(72124), ex.Tools:getLang(72125), function()
 
        ex.Player.dream_data:gReqDreamlandEndBattle()
        self:removeBattleLayer( )
        -- 退出战斗
    end)


end 

function DreamCtr:showReward( )

    local menu = cpp.UIMenu:create()
    :setPosition(cc.p(0, 0))
    self.play_reward:addChild(menu)

    local award_list = cfg.infiniterewardshow.infiniterewardshow[1].value
    local begin = 0
    local margin = 5
    local posY = 0
    local scale = 0.75

    for i,v in ipairs(award_list) do
        local item = ex.Player.backpack_data:createWithData(v.item_type, v.item_num)
        local posX = (begin + item:getContentSize().width * scale / 2) + (i - 1) * ((item:getContentSize().width * scale) + margin)
    	
        item:setPosition(posX, posY)
        item:setScale(scale)
        item:registerScriptTapHandler(handler(self, self.onClick))
        menu:addChild(item)
    end

end

function DreamCtr:refreshRankList( )
    local list_data = ex.Player.dream_data.rank_list_data.list

    self.lab_no_rank:setVisible(false)

    local max_num = 3
    -- 拿前三
    local show_list_data = {}
    for i,v in ipairs(list_data) do
        if i <= max_num then  
            table.insert( show_list_data, v )
        end 
    end
    if not self.main_rank_list then 
        self.main_rank_list = ex.Tools:initTableView(self.rank_scroll_view,show_list_data, {require("src.layer.dream.DreamMainRankCell"),"ccbi/DreamMainRankCell.ccbi"} , self.rank_scroll_view:getContentSize(), 5,cc.p(0,0),true)
    else
        self.main_rank_list:initData(show_list_data)
        self.main_rank_list:reloadData()
    end 
end

-- 我的排名
function DreamCtr:setMyRank( )
    self.lank_reward:removeAllChildren()
    local my_rank_reward = nil
    -- 我的排名的奖励
    for i,v in ipairs(cfg.infiniterankreward.infiniterankreward) do
        if v.rank_min <= ex.Player.dream_data.my_rank and ex.Player.dream_data.my_rank <= v.rank_max then 
            my_rank_reward = v.reward
            break
        end 
    end 

    if my_rank_reward then 
        self.lab_no_reward:setVisible(false)

        local menu = cpp.UIMenu:create()
        :setPosition(cc.p(0, 0))
        self.lank_reward:addChild(menu)
        
        local goods_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()
        goods_size.width = goods_size.width * 0.75 + 10
    
        local begin = 0
        local margin = 5
        local posY = 0
        local scale = 0.75
        for i,v in ipairs(my_rank_reward) do
            local item = ex.Player.backpack_data:createWithData(v.item_type, v.item_num)
            local posX = (begin + item:getContentSize().width * scale / 2) + (i - 1) * ((item:getContentSize().width * scale) + margin) 
            
            item:setPosition(posX, posY)
            item:setScale(scale)
            item:registerScriptTapHandler(handler(self, self.onClick))
            menu:addChild(item)
        end

        self.my_lank:setString( string_format(ex.Tools:getLang(72010), ex.Player.dream_data.my_rank) )
    else 

        self.lab_no_reward:setVisible(true)

        self.my_lank:setString( string_format(ex.Tools:getLang(72010), ex.Tools:getLang(47749)) )
    end 

end



function DreamCtr:updateData( )
    
    self:showReward()
    self:setFirstReward( )

    ex.Player.dream_data:gReqDreamlandRank()
    ex.Player.dream_data:gReqFriendAssistHeroList()
    ex.Player.dream_data:gReqDreamlandData()
end


function DreamCtr:initDone()
    self:showReward()
    self:setFirstReward( )
    
    self.show_rewards:setVisible(false)
    self:reorderChild(self.show_rewards, 10000)


    if not self.battle_layer and   ex.Player.dream_data.status == DreamBattleType.BATTLEING then 
        -- 获得当前战斗

        ex.Player.dream_data:gReqDreamlandBattleReport()
        ex.EventManager:fire(EVENT.DREAM_EVENT.LOAD_BATTLE)
    end 

    self:showFriendRed( )

end 



-- 首通信息
function DreamCtr:setFirstReward( )
    self.lank_num:setString(ex.Player.dream_data.max_lv)  

    self.pro_reward:removeAllChildren()
    local reward_config = ex.Player.dream_data:showNowFirstReward()
    if reward_config then
        self.reward_lab:setString( string_format(ex.Tools:getLang(72014), reward_config.idx) )
    else
        self.reward_lab:setString(string_format(ex.Tools:getLang(72232), ex.Player.dream_data:showMaxPass()) )  
    end
    local menu = cpp.UIMenu:create()
    :setPosition(cc.p(0, 0))
    self.pro_reward:addChild(menu)
    
    local goods_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()
    goods_size.width = goods_size.width * 0.75 + 10

    local begin = 0
    local margin = 5
    local posY = 0
    local scale = 0.75
    for i,v in ipairs(reward_config and reward_config.reward or {}) do
        local item = ex.Player.backpack_data:createWithData(v.item_type, v.item_num)
        local posX = (begin + item:getContentSize().width * scale / 2) + (i - 1) * ((item:getContentSize().width * scale) + margin) 
    	
        item:setPosition(posX, posY)
        item:setScale(scale)
        item:registerScriptTapHandler(handler(self, self.onClick))
        menu:addChild(item)
    end

    if reward_config then
        if ex.Player.dream_data.max_lv >= reward_config.idx then 
            self.btn_get:setVisible(true)
            self:setRedPoint(true)
            self.lab_need:setVisible(false)
        else 
            self.lab_need:setVisible(true)
            self.lab_need:setString(string_format( ex.Tools:getLang(47208), reward_config.idx))
            self.btn_get:setVisible(false)
            self:setRedPoint(false)
        end
    else
        self.lab_need:setVisible(false)
        self.btn_get:setVisible(false)
        self:setRedPoint(false)
    end
    self.start_lab:setString( string_format(ex.Tools:getLang(72022), ex.Player.dream_data.today_init_lv + 1) )
    self.now_lab:setString( string_format(ex.Tools:getLang(72024), (ex.Player.dream_data.today_max_lv)) )

    -- 

end


function DreamCtr:setRedPoint(bool)
	ex.Tools:addRedPoint(self.btn_get,bool)
end


function DreamCtr:onBack(tag , pSender)
    ex.MainSceneCtr:instance():changeLayer(MainSceneType.MAINCITY_SLZM)
    --ex.MainSceneCtr:instance():changeLayer(MainSceneType.MAINCITY_LAYER)
end

-- 奖励详情
function DreamCtr:showRewardList(tag , pSender)
    
    -- 
    require("src.layer.dream.DreamRewardCtr"):instance():openWindow()
end

-- 排名详情
function DreamCtr:showRank(tag , pSender)
    
    require("src.layer.dream.DreamRankCtr"):instance():openWindow()
end

-- 领取奖励
function DreamCtr:btnGet(tag , pSender)
    local reward_config = ex.Player.dream_data:showNowFirstReward()

    if reward_config == nil or ex.Player.dream_data.max_lv < reward_config.idx then 
        ex.MessageView:add(ex.Tools:getLang(47582))
        return
    end 

        -- 检测领取那个
    ex.Player.dream_data:gReqDreamlandGetLevel(reward_config.idx)
    -- 重新刷新
    self:setFirstReward( )
end


function DreamCtr:startBattle( )
        -- 如果未开始战斗，就是什么什么什么
        if ex.Player.dream_data.status == DreamBattleType.NORMAL then 
            local battle_type= 11
            local vec_friend_hero = {}
            table.insert(vec_friend_hero, ex.Player.dream_data.select_friend_hero_data)
            require('src.layer.HeroSelectCtr'):instance():openWindow(ex.Tools:getLang(47524),
                                                                     ex.Tools:getLang(47064),
                                                                     battle_type,
                                                                     handler(self, self.onBattleDone),
                                                                    nil,
                                                                    vec_friend_hero
                                                                    )
    
        elseif ex.Player.dream_data.status == DreamBattleType.BATTLEING then 
            -- 获得当前战斗
            ex.Player.dream_data:gReqDreamlandBattleReport()
            ex.EventManager:fire(EVENT.DREAM_EVENT.LOAD_BATTLE)
    
        elseif ex.Player.dream_data.status == DreamBattleType.SELECT_BUFF then 
    
            require("src.layer.dream.DreamSelectCtr"):instance():openWindow()
        else
            ex.Player.dream_data:gReqDreamlandWinAddLv()
        end 

end


-- 选择增益
function DreamCtr:btnBattle(tag , pSender)
    ex.Tools:checkReddotStatusOnceDay(RedDotType.ZCJ_DHFB_YHMJRK_YHMJ, true)
    ex.Tools:addRedPoint(self.btn_battle,false)
    if ex.Player.dream_data.today_challenge_count > 0 then 
        -- 弹框
        ex.ConfirmCtr:openWindow(ex.Tools:getLang(72016), ex.Tools:getLang(72017), function()
            self:startBattle()
        end)

    else 
        self:startBattle()
    end 
end





function DreamCtr:showFriendRed( )
    ex.Tools:addRedPoint(self.btn_battle,false)
    -- if ex.Player.dream_data.today_challenge_count == 0 then 
    if ex.Tools:checkReddotStatusOnceDay(RedDotType.ZCJ_DHFB_YHMJRK_YHMJ, false) then
        ex.Tools:addRedPoint(self.btn_battle,true,cc.p(0.9, 0.92))
    end



    ex.Tools:addRedPoint(self.btn_select_friend,false)
    -- if not ex.Player.dream_data.select_friend_hero or not ex.Player.dream_data.my_hero_data then 
    if not ex.Player.dream_data.my_hero_data then 
        ex.Tools:addRedPoint(self.btn_select_friend,true,cc.p(0.9, 0.92))
        return 
    end 
    -- if ex.Player.dream_data.select_friend_hero.hero.hero_id == 0 or ex.Player.dream_data.my_hero_data.hero_id == 0  then 
    if ex.Player.dream_data.my_hero_data.hero_id == 0 then 
        ex.Tools:addRedPoint(self.btn_select_friend,true,cc.p(0.9, 0.92))
	end 





end

function DreamCtr:onSelectBuff(tag , pSender)
    require("src.layer.dream.DreamSelectCtr"):instance():openWindow()
end


function DreamCtr:onBattleDone(tag , pSender)
    ex.Player.dream_data.today_challenge_count = ex.Player.dream_data.today_challenge_count + 1

    ex.Player.trial_data:checkRedDot()

    require("src.layer.dream.DreamSelectCtr"):instance():openWindow()
end

function DreamCtr:selectFriend(tag , pSender)
    require("src.layer.dream.DreamFriendCtr"):instance():openWindow(1)
end

function DreamCtr:updateNowLevel()
    local cfg_data = cfg.infinitebuff.infinitebuff[ex.Player.dream_data.curr_buff_id]
    if cfg_data then
        self.now_buff:setString(ex.Tools:getLang(72046) .. ex.Tools:getLang(cfg_data.lan_battle))
    else
        print("cfg_data is nil")
    end

    self.now_level:setString(string.format( ex.Tools:getLang(72045), tostring(ex.Player.dream_data.curr_battle_lv)))
        if ex.Player.dream_data.rewards then 
            -- 
            if ex.Player.dream_data.today_max_lv + ex.Player.dream_data.today_init_lv - ex.Player.dream_data.curr_battle_lv <= 0 then 
                self.show_reward_msg:setVisible(false)

                self.img_1:setVisible(true)
                self.img_2:setVisible(true)

                local lab_1 = 0
                local lab_2 = 0
                for i,v in ipairs(ex.Player.dream_data.rewards) do
                    if v.type == 900001 then 
                        lab_1 = v.num
                    end 
    
                    if v.type == 900101 then 
                        lab_2 = v.num
                    end 
                end
    
                self.lab_1:setString(lab_1)
                self.lab_2:setString(lab_2)

            else 
                self.show_reward_msg:setVisible(true)
                self.lab_1:setString("")
                self.lab_2:setString("")
                self.img_1:setVisible(false)
                self.img_2:setVisible(false)
                
                local show_lv = ex.Player.dream_data.today_max_lv + ex.Player.dream_data.today_init_lv + 1 - ex.Player.dream_data.curr_battle_lv
                local hsow_msg = string.format(ex.Tools:getLang(72048), show_lv, ex.Player.dream_data.today_max_lv + ex.Player.dream_data.today_init_lv)
                self.show_reward_msg:setString(hsow_msg)

            end 

        end 


        self.first_btn:removeAllChildren()
        -- 获取下一个奖励
        local reward_config = ex.Player.dream_data:showNowFirstReward()
        if reward_config then
            local item = ex.Player.backpack_data:createWithData(reward_config.reward[1].item_type, nil)

            item:setPosition(0, 0)
            item:setScale(0.75)
            item:registerScriptTapHandler(handler(self, self.onShowFirstPanel))
            self.first_btn:addChild(item)
    
            ex.Tools:addRedPoint(item,false)
    
            local show_text = string.format( ex.Tools:getLang(72049), reward_config.idx)
            if reward_config.idx <= ex.Player.dream_data.max_lv then 
                show_text = ex.Tools:getLang(47078)
                ex.Tools:addRedPoint(item,true)
            end 
    
    
            local text_lab = cc.Label:createWithTTF( show_text, FONT_DEFAULT_NAME_BOLD, 48)
    
            text_lab:setScale(0.5)
            item:addChild(text_lab, 10001)
            text_lab:setPosition(item:getContentSize().width * 0.5, 0)
            text_lab:setTextColor(cc.c4b(255, 255, 255, 255))
            text_lab:enableOutline(cc.c4b(107, 60, 10, 255), 3)
    
            item:setPosition(ex.p.width - 60, -60)
        end
        -- self:setFirstReward()
        self.btn_exit:setPosition(ex.p.width - 60, -60)
        self.start_lab:setString( string_format(ex.Tools:getLang(72022), ex.Player.dream_data.today_init_lv + 1) )
        self.now_lab:setString( string_format(ex.Tools:getLang(72024), (ex.Player.dream_data.today_max_lv)) )
end

function DreamCtr:onshowRewardPanel()
    if ex.Player.dream_data.status == DreamBattleType.NORMAL then 
        self.show_rewards:setVisible(false)
        self:removeBattleLayer()
    elseif ex.Player.dream_data.status == DreamBattleType.BATTLEING then 
        self.show_rewards:setVisible(true)
        
        self.lab_1:setString("0")
        self.lab_2:setString("0")
        -- print("ex.Player.dream_data.cur_lv", ex.Player.dream_data.cur_lv)
        -- self.now_level:setString(string.format( ex.Tools:getLang(72045), tostring(ex.Player.dream_data.curr_battle_lv))  )
        self:updateNowLevel()
        
    elseif ex.Player.dream_data.status == DreamBattleType.SELECT_BUFF then 
        self:removeBattleLayer( )

        self.show_rewards:setVisible(false)
    end 

end


function DreamCtr:onShowFirstPanel(tag , pSender)
        
        require("src.layer.dream.DreamFirstCtr"):instance():openWindow()

end 




function DreamCtr:onStartBattle(tag , pSender)
    -- self:removeBattleLayer()
    if self.battle_layer then
        self.battle_layer:removeFromParent()
        self.battle_layer = nil
    end

    -- if not self.battle_layer then 
        local time_out = function()
            NetManager:sendMessage(ProtocolID.GReqDreamlandBattle)
        end
        -- dump(self.__cname)
        self.battle_layer = self:addBattleLayerAuto(11,
                                                        MainSceneType.DREAM_LAYER,
                                                        MainSceneType.DREAM_LANG_BATTLE,
                                                        "", 
                                                        EVENT.DREAM_EVENT.START_BATTLE,
                                                        function(layer )
                                                                ex.Player.dream_data.wait_next = true
                                                                ex.Player.dream_data:gReqDreamlandWinAddLv()
                                                                return  false, false
                                                        end)
        self.battle_layer:setRecoveryType(RecoveryType.RT_CO_EXIST)
        self.battle_layer:setScale(1.0 / self:getScaleX())
        self.battle_layer:setPosition(self:getContentSize().width * 0.5   - ex.p.width  * 0.5,
                                      self:getContentSize().height * 0.5  - ex.p.height * 0.5)
        
        self.battle_layer.time_out = time_out
        self.battle_layer.isbattle = true

    local main_scene_type = ex.MainSceneCtr:getCurLayerType()
    if main_scene_type ~= MainSceneType.DREAM_LAYER then
        ex.EventManager:fire(EVENT.BATTLE_EVENT.CHANGE_LAYER, self, false)
    end

    -- end 
    ex.Tools:autoPlaySceneMusic()


end

function DreamCtr:removeBattleLayer( )
    if not self.battle_layer then return end 
    self.battle_layer:removeFromParent()
    self.battle_layer = nil

    self.show_rewards:setVisible(false)
    self:updateData()
end


function DreamCtr:getNextBattleData( )
    if ex.Player.dream_data.wait_next == false then
        return
    end

    -- 获取返回的战斗状态
    ex.Player.dream_data:gReqDreamlandBattle()

    --打开那啥

    ex.Player.dream_data:gReqDreamlandRank()
    ex.Player.dream_data:gReqFriendAssistHeroList()

end

-- 层切入时会被调用
function DreamCtr:changeLayerIn()
    ex.EventManager:fire(EVENT.BATTLE_EVENT.CHANGE_LAYER, self, true)
end

function DreamCtr:changeLayerOutEnd()
    if ex.Player.dream_data.status == 3 then
        ex.MainSceneCtr:removeKeepLayer(MainSceneType.DREAM_LAYER)
    end
    ex.EventManager:fire(EVENT.BATTLE_EVENT.CHANGE_LAYER, self, false)
end

return DreamCtr