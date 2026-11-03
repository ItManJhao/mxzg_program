local PROMagicButterflyLayer = class("PROMagicButterflyLayer", require("src.layer.promotion.PromotionBaseLayer"))

function PROMagicButterflyLayer:onCreateDone()
    self._type = {[1] = 8,[2] = 9}
    self.open_data = ex.Player.promotion_data:getPromotionDatas(65)
    self.model = ex.Player.promotion_data.magic_butterfly_data
    self.hero_type = cfg.system.nha_summon_newhero_id
    self.fashion_id = ex.Tools:getHeroSkinByStar(self.hero_type, 13)

    self.spr_bg:setScale(ex.s.global_scale)
    self.spr_bg:setPositionY(self.spr_bg:getPositionY() - require("src.model.Game"):instance():getNotchHeight())

    self.node_need:setPositionY(self.node_need:getPositionY() - require("src.model.Game"):instance():getNotchHeight())
    self.node_sage:setPositionY(self.node_sage:getPositionY() - require("src.model.Game"):instance():getNotchHeight())
    self.node_surplus:setPositionY(self.node_surplus:getPositionY() - require("src.model.Game"):instance():getNotchHeight())
    self.menu_reward:setPositionY(self.menu_reward:getPositionY() - require("src.model.Game"):instance():getNotchHeight())
    self.menu_info:setPositionY(self.menu_info:getPositionY() - require("src.model.Game"):instance():getNotchHeight())

    self.node_main:setScale(math.min(ex.s.global_scale, 1))

    self.item_hero_icon = require("src.comp.menu.UIMenuItemHero"):createWithData(0, self.hero_type, nil, 0, 5)
    self.item_hero_icon:setScale(0.4)
    self.item_hero_icon:setPositionY(20.0)
    self.item_hero_icon:removeLevel()
    self.item_hero_icon:setEnableAction(false)
    self.menu_hero_icon:addChild(self.item_hero_icon)
    -- self.menu_hero_icon:removeStar()

	self.lbl_get = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(18)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#FFFFFF")
	:setPosition(cc.p(201.0, 20))
	:setAnchorPoint(cc.p(1, 0.5))
    self.node_surplus:addChild(self.lbl_get)
    
    self:registerBtnEvent()
    for i,v in ipairs(self._type) do
        self:setGem(v)
    end


    self:createSpine()
    self:changeDateLabel()
    self:createProgress()

    self:updateNextReward()
    self:updataSurplus()
    
    self:changeTime()
    self:startTimer()

    self:addEvent(EVENT.MAGIC_BUTTERFLY.GET_REWARD,handler(self,self.onGetReward))
    self:addEvent(EVENT.MAGIC_BUTTERFLY.GET_REWARD,handler(self,self.updateNextReward))
    self:addEvent(EVENT.MAGIC_BUTTERFLY.UPDATE_SUMMON_NUM,handler(self,self.onSummonNum))
    self:addEvent(EVENT.MAGIC_BUTTERFLY.UPDATE_SUMMON_NUM,handler(self,self.updataSurplus))
    self:addEvent(EVENT.MAGIC_BUTTERFLY.UPDATE_SUMMON_NUM,handler(self,self.updateNextReward))
    -- self:addEvent(EVENT.MAGIC_BUTTERFLY.UPDATE_SUMMON_NUM,handler(self,self.onSummonNum))
    self:addEvent(EVENT.BACK_PACK_EVENT.BACKPACK_UPDATA_LIST,handler(self,self.updateRes))
end

function PROMagicButterflyLayer:updateRes(event,item_type)

    local reward_cfg = cfg.lotterypoint.summon[self._type[1]]

    if reward_cfg.need_item[1].item_type ~= item_type or item_type ~= ItemType.IT_MAGIC_BUTTER_TICKET then 
        return 
    end

    local hasNum = ex.Player:getItemNum(reward_cfg.need_item[1].item_type)

    for i,v in ipairs(self._type) do
        self:setGem(v)
    end

    self.lbl_icon_need:setString(tostring(hasNum))
end

function PROMagicButterflyLayer:onGetReward(event,data)
    self:updateNextReward()
end

function PROMagicButterflyLayer:onSummonNum(event,data)
    self:updataSurplus()
    self:startTimer()
    for i,v in ipairs(self._type) do
        self:setGem(v)
    end
end

function PROMagicButterflyLayer:createProgress()
    self.progressTimer = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("magic-butterfly/jdt2.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setScaleX(self.spr_show_progress:getScaleX())
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.spr_show_progress:addChild(self.progressTimer)
    self.progressTimer:setPosition(self.spr_show_progress:getContentSize().width / 2 ,self.spr_show_progress:getContentSize().height / 2 )
    self.progressTimer:setPercentage(40)
end

function PROMagicButterflyLayer:registerBtnEvent( )
    local lbl_btn_reward = cc.Label:createWithTTF(ex.Tools:getLang(41088), FONT_DEFAULT_NAME_BOLD, 18)
    :setTextColor(cc.c3b(255,255,255))
    :setPosition(self.btn_reward:getContentSize().width / 2 , 0)
    :enableOutline(cc.c3b(0,75,129),2)
    self.btn_reward:addChild(lbl_btn_reward)

    local lbl_btn_play = cc.Label:createWithTTF(ex.Tools:getLang(75205), FONT_DEFAULT_NAME_BOLD, 18)
    :setTextColor(cc.c3b(255,255,255))
    :setPosition(self.btn_play:getContentSize().width / 2 ,0)
    :enableOutline(cc.c3b(0,75,129),2)

    self.btn_play:addChild(lbl_btn_play)
    self.btn_one:registerScriptTapHandler(handler(self,self.onClickSummon))
    self.btn_ten:registerScriptTapHandler(handler(self,self.onClickSummon))
    self.btn_reward:registerScriptTapHandler(handler(self,self.onClickReward))
    self.btn_play:registerScriptTapHandler(handler(self,self.onClickPlay))
    self.btn_info:registerScriptTapHandler(handler(self,self.onBtnInfo))
    

end

function PROMagicButterflyLayer:startTimer( )
    self:removeTimer()
    self:addTimer("chang_time",1000,handler(self,self.changeTime),true)
end

function PROMagicButterflyLayer:removeTimer( )
    self:removeTimerByName("chang_time")
end

function PROMagicButterflyLayer:changeTime( )
    local free_time = self.model:getFreeTime()
    local cur_time = ex.Game:getServerTime()
    if cur_time >= free_time then 
        self.lbl_timer:setString(ex.Tools:getLang(1102))
        self:removeTimer()
    else
        self.lbl_timer:setString(ex.Tools:formatTime2(free_time - cur_time)..ex.Tools:getLang(1102))
    end
end

function PROMagicButterflyLayer:updataSurplus( )
    -- local target_num = cfg.system.nha_summon_newhero_mustout
    local target_num = self.model:getHeroOutNum()
    local count = self.model:getSummonNum() % target_num
    -- if count == 0 then 
    -- self.lbl_get:setXmlTextLua(string.format(ex.Tools:getLang(75203), target_num - count))
    self.lbl_get:setXmlTextLua(string.format(ex.Tools:getLang(75203), target_num))
	self.lbl_get:formatText()
    self.item_hero_icon:setPositionX(self.lbl_get:getPositionX() - self.lbl_get:getContentSize().width - 30)
    
    -- -- 完成目标，隐藏目标节点
    -- if self.model:getSummonNum() >= target_num then
    --     self.node_surplus:setVisible(false)
    -- end

end

function PROMagicButterflyLayer:changeDateLabel()
    
    local s_m = os.date("%m",self.open_data.start_time)
    local s_d = os.date("%d",self.open_data.start_time)

    local e_m = os.date("%m",self.open_data.end_time)
    local e_d = os.date("%d",self.open_data.end_time)
    -- self.lbl_date:setString(string.format("%s月%s日-%s月%s日",s_m,s_d,e_m,e_d))
    self.lbl_date:setString(string.format(ex.Tools:getLang(75206),s_m,s_d,e_m,e_d))
end

function PROMagicButterflyLayer:updateNextReward()
    local reward_cfg = cfg.promotionnewherolotter.promotionnewherolotter
    local reward_data 
    for i,v in ipairs(reward_cfg) do
        local geted = self.model:getRewardStatus(v.idx)
        if not geted then 
            reward_data = v
            break
        end
    end

    local is_all_geted = false
    if not reward_data then 
        is_all_geted = true
        for i,v in ipairs(reward_cfg) do
            reward_data = v
        end
    end
    self.item_node:removeAllChildren()
    local menu = cpp.UIMenu:create()
    self.item_node:addChild(menu, 9999)
    menu:setPosition(0,0)


    local item = require("src.comp.menu.UIMenuItemBag"):createWithData(reward_data.box_reward[1].item_type, reward_data.box_reward[1].item_num)
    item:setScale(0.5)
    item:setRewardStatus1(self.model:getBoxRewardStatus(reward_data.idx))
    item:registerScriptTapHandler(handler(self,self.onClickItem))
    item:setTag(reward_data.idx)
    menu:addChild(item)

    if is_all_geted then 
        self.progressTimer:setPercentage(100)
        self.lbl_next:setString(ex.Tools:getLang(75202))
        self.node_sage:setVisible(false)
    else
        local pre_idx = reward_data.idx - 1
        local pre_cfg = reward_cfg[pre_idx]
        local pre_task_count = 0
        if pre_cfg then
            pre_task_count = pre_cfg.task_count
        end

        local target = reward_data.task_count - pre_task_count
        local cur_count = self.model:getSummonNum() - pre_task_count
        self.lbl_next:setString(string.format(ex.Tools:getLang(75201), cur_count, target))
        self.progressTimer:setPercentage(cur_count / target * 100)
    end
end

function PROMagicButterflyLayer:createSpine( )
    if self.hero ~= nil then 
		self.hero:removeFromParent()
		self.hero = nil
    end
    
	if self.fashion_id == 0 then
		self.hero = require("src.person.Hero"):create("12323", "123213", self.hero_type, 250, 13, skin)
	else
		self.hero = require("src.person.Hero"):create("1", "1", 1, 1, 1, self.fashion_id)
	end
	self.hero:setShadowVisible(false)
    self.hero:setScale(1.5 * 1.42)
    self.hero:setPosition(0, -10)
    self.menu_hero:addChild(self.hero)
end

function PROMagicButterflyLayer:onBtnInfo(tag,pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42088), ex.Tools:getLang(42089))
end

function PROMagicButterflyLayer:onClickReward(tag,pSender)
    require("src.layer.promotion.MagicButterViewCtr"):instance():openWindow()
end

function PROMagicButterflyLayer:onClickPlay(tag, pSender)

	if self.battle_layer ~= nil then
		return
	end

    local battle_end = function(layer, data)
        -- ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LIMIT_TIME_SERVER)
        return true, false
    end
    local time_out = function()
        ex.EventManager:fire(EVENT.BATTLE_EVENT.BATTLE_END)
	end

	local battle_layer = self:getParent():addBattleLayerAuto(BattleType.TRIAL,
							MainSceneType.MAINCITY_LIMIT_TIME_SERVER,
							MainSceneType.MAINCITY_TRIAL_BATTLE,
							"",
							EVENT.TRIAL_EVENT.TRIAL_START,
							battle_end)
	battle_layer:setRecoveryType(RecoveryType.RT_CO_EXIST)
	ex.EventManager:fire(EVENT.TRIAL_EVENT.TRIAL_START, json.decode(cc.FileUtils:getInstance():getStringFromFile("config/fashion-"..self.hero_type..".txt")))

    ex.AudioManager:playMusic(string.format("music/battle-%d.mp3", 1))
end

function PROMagicButterflyLayer:onClickSummon(tag,pSender)
    local function sendProtoBuf()
        local req_summon = Hero_pb.GReqHeroSummon()
        req_summon.type = self._type[tag]
        ex.Player.summon_data.last_summon_type = req_summon.type
        NetManager:sendMessage(ProtocolID.GReqHeroSummon, req_summon)
    end
    if tag == 1 then 
        sendProtoBuf()
    else
        local conf = cfg.lotterypoint.summon[self._type[tag]]
        local need_item = conf.need_item[1]
        local has_num = ex.Player:getItemNum(need_item.item_type)
        local lack_num = need_item.item_num - has_num
        local need_gems = (lack_num) * cfg.system["nha_summon_10_fixed_prize"][1].item_num
        local item_name = ex.Tools:getLang(cfg.item.item[need_item.item_type].name)
        if has_num > 0 and has_num < need_item.item_num then 
            local show_str = string.format( ex.Tools:getLang(75212), need_gems,lack_num, item_name)
            ex.ConfirmCtr:openWindow(ex.Tools:getLang(16), show_str, sendProtoBuf) 
        else
            sendProtoBuf()
        end
    end
    -- :done(req_summon.type, false)
end

function PROMagicButterflyLayer:setGem(type)
    -- 招募一次 按钮文字 数字
    local config_type1 = type
    local cell_item = cfg.lotterypoint.summon[config_type1].need_item[1]

    local need_type = cell_item.item_type
    local need_num = cell_item.item_num

    local hasNum = ex.Player:getItemNum(need_type)

    self.lbl_icon_need:setString(tostring(hasNum))
    ex.Tools:setSpriteFrame(self.spr_icon_need, string.format("backpack/%d.png", need_type))



    local btn_size = cc.Sprite:createWithSpriteFrameName("button/btn-buy-1.png"):getContentSize()
    btn_size.width = btn_size.width / 2
    btn_size.height = btn_size.height / 2

    local key = type == self._type[1] and "one" or "ten"
    local btn = self["btn_"..key]
    if hasNum < need_num and hasNum <= 0 then
        -- 高级券不够时候 用钻石
        need_type =  ItemType.IT_GEM
        local count = type == self._type[1] and 1 or 10
        need_num = type == self._type[1] and ex.ShopSeniorTicketTable:getConfig(cfg.lotterypoint.summon[config_type1].summon_times).need_gem or cfg.system.nha_summon_10_fixed_prize[1].item_num * count
    else

    end

    local spr_icon1 = btn:getChildByTag(10)
    if spr_icon1 then
        spr_icon1:removeFromParent()
        spr_icon1 = nil
    end

    spr_icon1 = cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", need_type))
    :setScale(0.25)
    :setPosition(btn_size.width - 40, btn_size.height - 14)
    btn:addChild(spr_icon1, 10, 10)
    btn:setName("summon_one")

    local lbl_btn_num1 = btn:getChildByTag(100)
    if lbl_btn_num1 then
        lbl_btn_num1:setString(tostring(need_num))
    else
        local color = self._type[1] == type and FONT_BROWN or FONT_WHITLE
        local lbl_btn_num1 = cc.Label:createWithTTF(need_num, FONT_DEFAULT_NAME_BOLD, 40)
        :setTextColor(color)
        :setScale(0.5)
        :setPosition(btn_size.width, btn_size.height - 14)
        btn:addChild(lbl_btn_num1, 100, 100)
    end

    -- 召唤一次
    local lbl_btn_txt1 = btn:getChildByTag(20)
    if not lbl_btn_txt1 then 
        local language_id = self._type[1] == type and 70004 or 70005
        lbl_btn_txt1 = cc.Label:createWithTTF(ex.Tools:getLang(language_id), FONT_DEFAULT_NAME_BOLD, 24)
        :enableOutline(FONT_BROWN, 1)
        :enableShadow(FONT_BROWN, cc.size(1, -1))
        :setPosition(btn_size.width, btn_size.height + 11)
        :setTag(20)
        btn:addChild(lbl_btn_txt1)
    end

    if not self.lbl_timer and type == self._type[1] then 
        self.lbl_timer = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD,16)
        self.lbl_timer:setColor(FONT_GREEN)
        btn:addChild(self.lbl_timer)
        self.lbl_timer:setPosition(btn_size.width,btn_size.height * 2 + 8)
    end

end

function PROMagicButterflyLayer:onClickItem(tag, pSender)
    local status = self.model:getBoxRewardStatus(tag)

    if status ~= 1 then
        ex.Tools:showItemInfo(tag, pSender)
        return
    end

    self:sendProto(tag)

end

function PROMagicButterflyLayer:sendProto(tag)
    local req = Promotion065_pb.GReqHeroRollingReward()
    req.idx = tag
    NetManager:sendMessage(ProtocolID.GReqHeroRollingReward, req)
end


return PROMagicButterflyLayer
