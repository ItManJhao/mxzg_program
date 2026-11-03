local PROMPveMonsterInfoCtr = class("PROMPveMonsterInfoCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PROMPveMonsterInfoLayer = class("PROMPveMonsterInfoLayer", require("src.comp.LuaLayerBase"))

local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")


function PROMPveMonsterInfoLayer:onCreate()
    self:addBlackBackground()
end

function PROMPveMonsterInfoLayer:showBtnString(language_id)
    local str = ex.Tools:getLang(52313)
	local start_btn_size = self.btn_start:getContentSize()
	local start_btn_txt = cc.Label:createWithTTF(str, FONT_DEFAULT_NAME_BOLD, 26)
	:enableOutline(FONT_DARK_BLUE, 2)
	:setPosition(start_btn_size.width/2, start_btn_size.height/2 + 3)
    self.btn_start:addChild(start_btn_txt)
    
    local str1 = ex.Tools:getLang(52312)
	local confirm_btn_size = self.btn_confirm:getContentSize()
	local confirm_btn_txt = cc.Label:createWithTTF(str1, FONT_DEFAULT_NAME_BOLD, 26)
	:enableOutline(FONT_DARK_BLUE, 2)
	:setPosition(confirm_btn_size.width/2, confirm_btn_size.height/2 + 3)
    self.btn_confirm:addChild(confirm_btn_txt)

    self.lbl_tltle:setString(ex.Tools:getLang(language_id))
    
end

function PROMPveMonsterInfoLayer:createEmenyHero(data)
	if not data then return end
    local menu = cpp.UIMenu:create()
    :setSwallowsTouches(false)
    :setName("hero_menu")
    :setPosition(cc.p(0, 0))
    self:addChild(menu)
    local scale = 1
    for i=1,6 do
        local x,y = self["node_hero_" .. i]:getPosition()
        local item = UIMenuItemHero:createWithData(0, 0, 0, 0)
        item:setPosition(x,y)
        menu:addChild(item)

        if data[i] then 
            local hero_data = {}
            hero_data.level = data[i].hero_level
            hero_data.hero_star = data[i].hero_star
            hero_data.hero_type = data[i].hero_type
    
            hero_data.elem = cfg.herotype.star[data[i].hero_type].elem
            item:reset(hero_data)

        end 

        item:resetBg(nil, nil)
        item:setScale(scale)
    end
end

function PROMPveMonsterInfoLayer:createReward(reward)
	if not reward then return end
	local posY = 170
    local margin = 6
    local menu = self:getChildByName("hero_menu")
	local max_width = self.spr_bg:getContentSize().width
    local item_size = UIMenuItemHero:createWithData(0, 0, 0, 0)
    item_size = item_size:getContentSize()
    local length = #reward
    local reward_data = reward

    local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")
    local scale = 0.8
    local posX = (max_width - (item_size.width * scale + margin) * length) / 2

    for i=1,length do
    	local item = UIMenuItemBackpack:createWithData(reward_data[i].item_type, reward_data[i].item_num)
        item:setPosition(posX + (item_size.width * scale+ margin) * (i - 1) + margin + scale * item_size.width/2,posY)
        item:registerScriptTapHandler(handler(self, self.onClickItem))
        item:setScale(scale)
        menu:add(item)
    end
end

function PROMPveMonsterInfoLayer:onClickItem(tag , pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-----------------------------------------------------------------------------
function PROMPveMonsterInfoCtr:onCreate()
	self:setCCBIPath("ccbi/PROMPveMonster.ccbi")
    self:setIsSingle(false)
    
    self.sweep_num = 0
end

function PROMPveMonsterInfoCtr:getLayerClass()
	return PROMPveMonsterInfoLayer
end


function PROMPveMonsterInfoCtr:openWindow(pos, emeny_data, reward_data, callback)
    if self:isOpened() then
        return
    end
    
    self.pos = pos
    self.sweep_num = 0
    
    self:loadLayer()
    self:open()
    self:initData(pos,emeny_data, reward_data, callback)

end 


function PROMPveMonsterInfoCtr:initData(pos,emeny_data,reward_data,callback)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

	self.layer.emeny_data = emeny_data
	self.layer.callback = callback
	self.layer:showBtnString(reward_data.name_lang)
	self.layer:createEmenyHero(emeny_data)
    self.layer:createReward(reward_data.reward)


    self.reward_reward = reward_data

    local emeny_data, index = ex.Player.promotion_data:getMissionFromid(pos)

    local posBar = cc.p(0, 0)
    posBar.x = self.layer.spr_progress_mask:getPositionX()
    posBar.y = self.layer.spr_progress_mask:getPositionY() + 1
    --设置血量
    self.progressTimer = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("other/spr-bg-2.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setPosition(posBar)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.layer:addChild(self.progressTimer)

    self.progressTimer:setScaleX(self.layer.spr_progress_mask:getContentSize().width / self.progressTimer:getContentSize().width)

    local show_progree_text = emeny_data.hp * 0.01
    self.progressTimer:setPercentage(show_progree_text)
    -- 进度数字
    self.lbl_completed = cc.Label:createWithTTF("0%", FONT_DEFAULT_NAME_BOLD, 28)
    :setAnchorPoint(ex.a.center)
    :setPosition(posBar)
    :enableOutline(FONT_BROWN, 1)
    self.layer:addChild(self.lbl_completed)
    
    self.lbl_completed:setString( show_progree_text.."%")

    self.layer.btn_start:registerScriptTapHandler(handler(self, self.onBattle))

    self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onSweep))
end



function PROMPveMonsterInfoCtr:onSweep(tag, pSender)
    require('src.layer.promotion.PROMpveSweepCtr'):instance():openWindow(handler(self, self.setSweepCount))
end 

function PROMPveMonsterInfoCtr:setSweepCount( num)
    self.sweep_num = num

    self:onBattle()
end

function PROMPveMonsterInfoCtr:onBattle(tag, pSender)

    -- 检测数量
    local ori_item_data =  ex.Tools:getSysCfg("promotion_pve_fight_need_item") 

    local count = ori_item_data[1].item_num

    if 	count > ex.Player:getItemNum(ori_item_data[1].item_type) then 
        --  道具不租
        local str = ex.Tools:getLang(30503)
        ex.MessageView:add(str)
        return
    end 

    local battle_type= 50 + self.pos
    require('src.layer.HeroSelectCtr'):instance():openWindow(ex.Tools:getLang(47524),
                                                             ex.Tools:getLang(47064),
                                                             battle_type,
                                                             handler(self, self.onBattleDone))

end

function PROMPveMonsterInfoCtr:onBattleDone(vec_hero, fetter_type)
    -- local layer = self.layer
    -- if layer.is_battle then
    --     self:closeWindow(0, nil)
    --     return
    -- end

    -- local send_vec_hero = {}
    -- for k, v in pairs(vec_hero) do
    --     local data = {}
    --     data.hero_id = v
    --     data.hp = 10000
    --     table.insert(send_vec_hero, data)
    -- end

    local battle_type = 10 + self.pos

    --layer.is_battle = true
    -- 获得战斗洁面
    
    local emeny_data, index = ex.Player.promotion_data:getMissionFromid(self.pos)
    local req = Promotion034_pb.GReqZhuShenBattle()
    req.mission_type = self.pos
	req.mission_id = index
	req.sweep_count = self.sweep_num
    NetManager:sendMessage(ProtocolID.GReqZhuShenBattle, req)

    ex.EventManager:fire(EVENT.ACTIVE_BATTLE.START_ACTIVE_BATTLE, self.pos, index, self.sweep_num)
    self:closeWindow(0, nil)
end


return PROMPveMonsterInfoCtr