local PROMPveMonsterLayer = class("PROMPveMonsterLayer", require("src.layer.promotion.PromotionBaseLayer"))

local ExTimer = require("src.ex.ExTimer")
local string_format = string.format

------------------------------------------------------------------------------------------

local type_map =
{
    [1] = "map_promotionpve1",
    [2] = "map_promotionpve2",
    [3] = "map_promotionpve3",
    [4] = "map_promotionpve4",

}



function PROMPveMonsterLayer:onCreateDone()
    self:setSwallowTouches(false)
    self:setAutoClose(false)

    self:addBannerImage(ex.Player.promotion_data:getPromotionConfigByIdx(505))
    
    self:addTimeProgress()
    self:initdDone()
    self:showBuyItem()

    self:addEvent(EVENT.MAIN_CITY_LEVEL_UP.ACTIVITY_IS_SUCCESS,handler(self,self.updateList))
    self:addEvent(EVENT.ACTIVE_BATTLE.START_ACTIVE_BATTLE,handler(self,self.onBattleStart))

    -- self:addEvent(EVENT.ACTIVE_BATTLE.START_ACTIVE_BATTLE_START, handler(self,self.onBattleStart))
end

function PROMPveMonsterLayer:updateCDTime()
    self.reset_time = self.reset_time - 1

    if ex.Game:getServerTime()  <  ex.Player.promotion_data.pve_monster_data.stime then 
		self.time_text:setXmlTextLua(ex.Tools:getLang(41052));
		return 
	end 

	if self.reset_time < 0 then 
        self.time_text:setXmlTextLua(ex.Tools:getLang(41053));
        
        self:removeTimerByName("act_pve_monster_timer")
		return
    end

    local show_msg = ""
        --表示倒计是结束，进入清算时间
    if self.reset_time > 86400 then
        show_msg = string_format(ex.Tools:getLang(41130),math.floor(self.reset_time / 86400))
    elseif self.reset_time > 0 and self.reset_time < 86400 then 
        show_msg = string_format(ex.Tools:getLang(41129), 
            math.floor(self.reset_time / 3600),
            math.floor(self.reset_time / 60 % 60),
            math.floor(self.reset_time % 60))
    else 
        show_msg = ex.Tools:getLang(41053)
    end
    self.time_text:setXmlTextLua(show_msg)
end

function PROMPveMonsterLayer:initdDone()

    self.reset_time = ex.Player.promotion_data.pve_monster_data.etime -  ex.Game:getServerTime()
    self:addTimer("act_pve_monster_timer", 1000, handler(self, self.updateCDTime), true)
    self:updateCDTime()

    self:showLIst()
end


function PROMPveMonsterLayer:showLIst(  )
         
    local bg_size = self.list:getContentSize()
    local sub_size = cc.size(60, 60)
    local viewSize = sub_size
    local posx = self.list:getPositionX()
    local posy = self.list:getPositionY()

    local win_size = cc.Director:getInstance():getWinSize()
    if  self.layer_promotion then
        local top_y = self.layer_promotion:getTopY()
        top_y = top_y - 20 - 95	-- banner高106

        viewSize = cc.size(win_size.width  - sub_size.width, top_y - self.layer_promotion:getBottomY() - sub_size.height)
        posx = win_size.width * 0.5 - viewSize.width * 0.5
        posy = self.layer_promotion:getBottomY() + sub_size.height * 0.5
    end

    if viewSize.width > bg_size.width then 
        viewSize.width = bg_size.width
        posx = win_size.width * 0.5 - viewSize.width * 0.5
    end     

    local offset = 5
    local width = viewSize.width * 0.5 
    local height = viewSize.height 

    self.monster_list = {}
    for k,v in pairs(ex.Player.promotion_data.pve_monster_data.data) do
        local pveMonsterCell = require("src.layer.promotion/PROMPveMonsterCell"):createWithCCBIFile("ccbi/PROMPveMonsterCell.ccbi")
        if pveMonsterCell then 
            local pos_x_f, pos_x_r = math.modf(k / 2)    
            local pos_x_r = math.ceil( pos_x_r )
            if pos_x_r == 0 then pos_x_r = 1 else pos_x_r = 0 end 
            local item_width = pveMonsterCell:getContentSize().width
            local item_height = pveMonsterCell:getContentSize().height
            local pos_x = posx + width - item_width + pos_x_r * (item_width + offset) 
            
            local pos_y = posy + height - (item_height + offset) * math.floor( (k + 1)  / 2)

            pveMonsterCell:setData(k)
            self:addChild(pveMonsterCell)
            pveMonsterCell:setPosition(pos_x, pos_y)

            self.monster_list[k] = pveMonsterCell
        end
    end
end

function PROMPveMonsterLayer:showBuyItem()
    
    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/main-summon.plist")
    sfc:addSpriteFrames("ccbi-res/main-summon-lang.plist")
    
    local top_y = self.layer_promotion:getTopY()

    local win_size = cc.Director:getInstance():getWinSize()
    self.num_bg = cc.Sprite:createWithSpriteFrameName("main-summon/buy-num-bg-1.png")

    self.num_bg:setPosition(win_size.width * 0.5 , top_y - self.spr_banner:getContentSize().height  + self.num_bg:getContentSize().height * 0.5 + 10)
    self.num_bg:setScaleX(win_size.width / self.spr_banner:getContentSize().width)
    self:addChild(self.num_bg)

    --提供显示数字
    local num_str = 100
    self.num_text = cc.Label:createWithTTF(num_str, FONT_DEFAULT_NAME_BOLD, 36)
    self.num_text:setScale(0.6)
    self.num_bg:addChild(self.num_text)
    self.num_text:setPosition(self.num_bg:getContentSize().width * 0.5, self.num_bg:getContentSize().height * 0.5)
    self.num_text:setTextColor(FONT_WHITE_C4B)
    --self.num_text:enableOutline(FONT_RED, 3) 

    self:refreshNumData()
    
    -- 提供左边物品窗口
    self:setIcnoBg()

    --提供显示物品图片
    self:setItemIcno()

    ----右边 + 号    
    self:setAddItemIcno()
end

function PROMPveMonsterLayer:setIcnoBg( )

    local spr_icon = cc.Sprite:createWithSpriteFrameName("res-icon/res-bg.png")
    self.num_bg:addChild(spr_icon)
    --spr_icon:setScale(0.6)
    spr_icon:setPosition( spr_icon:getContentSize().width * 0.5 ,spr_icon:getContentSize().height * 0.5 )

end



function PROMPveMonsterLayer:setAddItemIcno( )
    
    local menu = cpp.UIMenu:create()
    menu:setPosition(self.num_bg:getPositionX(), self.num_bg:getPositionY())
    self:addChild(menu)
    
    local add_btn = cpp.UIMenuItemImage:createWithSpriteFrameName("promotion/spr-pve-jia.png", "promotion/spr-pve-jia.png", nil)
    add_btn:registerScriptTapHandler(handler(self, self.onClickAdd))
    add_btn:setPosition(self.num_bg:getContentSize().width * 0.5 - add_btn:getContentSize().width * 0.5, 0)
    menu:addChild(add_btn)

end


function PROMPveMonsterLayer:onClickAdd(tag,pSender)

    local ori_item_data =  ex.Tools:getSysCfg("promotion_pve_fight_need_item") 
    local need_gem =  ex.Tools:getSysCfg("promotion_pve_item_need_gem")  
    
    -- 购买的类型
    local need_item_data = {}
    need_item_data.item_type = ItemType.IT_GEM
    need_item_data.item_num = need_gem
    
    local item_data = {}
    item_data.item_type = ori_item_data[1].item_type
    item_data.item_num = ori_item_data[1].item_num

    require("src.layer.promotion.PROMPayInfoCtr"):instance():openWindow(item_data, need_item_data, handler(self, self.sendData), handler(self, self.refreshNumData))
end 


function PROMPveMonsterLayer:sendData(num)
    
    local item_data =  ex.Tools:getSysCfg("promotion_pve_fight_need_item") 
    local need_gem =  ex.Tools:getSysCfg("promotion_pve_item_need_gem")  

    local count = num * need_gem 

    if 	count > ex.Player:getItemNum(ItemType.IT_GEM) then 
        --  道具不租
        local str = ex.Tools:getLang(1109)
        ex.MessageView:add(str)
        return
    end 

    ex.Player.promotion_data:reqBuyItem(num)
    
end

function PROMPveMonsterLayer:updateList(event, data)



    self:refreshNumData()

    self:refreshMonsterItenData()

end 


function PROMPveMonsterLayer:refreshMonsterItenData( )
    
    -- self.monster_list[k] 
    for k,v in pairs(ex.Player.promotion_data.pve_monster_data.data) do
        if self.monster_list[k] then 

            self.monster_list[k]:setData(k)
        end 
    end 
end 

function PROMPveMonsterLayer:setItemIcno( )
    local item_data =  ex.Tools:getSysCfg("promotion_pve_fight_need_item")
    local spr_icon = cc.Sprite:createWithSpriteFrameName(string_format("backpack/%d.png", item_data[1].item_type))
    self.num_bg:addChild(spr_icon)
    spr_icon:setScale(0.6)

    spr_icon:setPosition( spr_icon:getContentSize().width * 0.23 ,spr_icon:getContentSize().height * 0.3 )
end


function PROMPveMonsterLayer:refreshNumData( )

    local item_data =  ex.Tools:getSysCfg("promotion_pve_fight_need_item")
	self.hasItemNum = ex.Player:getItemNum(item_data[1].item_type)
    self.num_text:setString(tostring(self.hasItemNum))
end



function PROMPveMonsterLayer:onBattleStart(event, pos, index, sweep_num)
    -- if battle_data.report == nil then
    --     print("ClanMissionLayer:onBattleStart battle report is nil")
    --     return
    -- end

    -- self.battle_data = battle_data
    -- -- 创建战斗层
    -- local battle_layer = cc.Layer:create()
    -- battle_layer:setContentSize(ex.p)
    -- battle_layer:setScale(1.0 / self:getParent():getScale())
    -- battle_layer:setPosition(self:getContentSize().width * 0.5 / battle_layer:getScale()  - ex.p.width * 0.5,
    --                          self:getContentSize().height * 0.5 / battle_layer:getScale() - ex.p.height * 0.5)
    -- self:getParent():addChild(battle_layer, 9999)


    -- -- 创建背景图
    -- local str_map_bg = ex.Player.battle_data:getBattleMap(type_map[battle_data.type])
    -- local spr_battle_bg = cc.Sprite:create(str_map_bg)
    -- if not spr_battle_bg then
    --     spr_battle_bg = cc.Sprite:createWithSpriteFrameName(str_map_bg)
    -- end

    -- if not spr_battle_bg then
    --     spr_battle_bg = cc.Sprite:create()
    -- end
    
    -- local win_size = cc.Director:getInstance():getWinSize()
    -- spr_battle_bg:setScale(ex.p.width / spr_battle_bg:getContentSize().width, ex.p.height / spr_battle_bg:getContentSize().height)
    -- spr_battle_bg:setPosition(win_size.width * 0.5 ,win_size.height * 0.5)
    -- battle_layer:addChild(spr_battle_bg, -1)

    -- -- 设置战斗层保持，不会被释放
    -- ex.MainSceneCtr:addKeepLayer(MainSceneType.ACTIVE_ZHUSHEN)
    -- self.layer_battle = battle_layer
    -- ex.Tools:autoPlaySceneMusic()

    -- local battle_ctr = require("src.controller.BattleController")
    -- local btController = battle_ctr.new(self.layer_battle)
    -- btController:play(battle_data.report)
    -- btController:addEventListener(battle_ctr.Event.BattleEnd, handler(self, self.onBattleEnd))

    if sweep_num > 0 then
        return
    end


    local battle_layer =  self:addBattleLayerAuto(BattleType.ZHU_SHEN_BOSS_1 + pos - 1,
                                                  nil,
                                                  MainSceneType.ACTIVE_ZHUSHEN,
                                                  "",--type_map[pos], 
                                                  EVENT.ACTIVE_BATTLE.START_ACTIVE_BATTLE_START,
                                                  function(layer, is_win, vec_reward, ext )
                                                    local result_data = {}
                                                    result_data.is_win = ext.is_win
                                                    result_data.damage_value = ext.damage_value
                                                    result_data.vec_reward = ext.vec_reward
                                                    result_data.vec_battle_detail = ext.report.log
                                                    require("src.layer.promotion.PROMPveMonsterEndCtr"):instance():openWindow(result_data, false)
                                                    ex.Tools:autoPlaySceneMusic()
                                                    return  true, false
                                                  end)
    battle_layer:setRecoveryType(RecoveryType.RT_CO_EXIST)
    -- battle_layer:setMusic("music/battle-fantasy-tower.mp3")
    -- ex.AudioManager:playMusic(0.02, "music/battle-fantasy-tower.mp3")
    ex.Tools:autoPlaySceneMusic(0.03, "music/battle-fantasy-tower.mp3")

end

function PROMPveMonsterLayer:onBattleEnd(data)

    if self.layer_battle ~= nil then
        self.layer_battle:removeFromParent()
        self.layer_battle = nil
    end
    ex.MainSceneCtr:removeKeepLayer(MainSceneType.ACTIVE_ZHUSHEN)
    ex.Tools:autoPlaySceneMusic()

    local result_data = {}
    result_data.is_win = self.battle_data.is_win
    result_data.damage_value = self.battle_data.damage_value
    result_data.vec_reward = self.battle_data.vec_reward
    result_data.vec_battle_detail = self.battle_data.report.log
    
    require("src.layer.promotion.PROMPveMonsterEndCtr"):instance():openWindow(result_data, false)

end

return PROMPveMonsterLayer
