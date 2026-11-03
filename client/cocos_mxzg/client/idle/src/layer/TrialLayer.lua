local TrialLayer = class("TrialLayer", require("src.comp.EventLayer"))
local TrialMapLayer = class("TrialMapLayer", require("src.comp.EventLayer"))
local UIMenuItemTrial = require("src.comp.menu.UIMenuItemTrial")


function TrialMapLayer:getAsynImage()
    local vec_image = {
        {image_name = "ccbi-res/map-bg-trial-1.jpg", remove_type=1},
    }
    return vec_image
end

function TrialMapLayer:onCreate()
    self:setAutoClose(false)
    self:setPosition(cc.p(0, 0))

    self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)
    self.spr_bg:setScaleY(ex.p.height / self.spr_bg:getContentSize().height)

    self.content_size = cc.size(self.spr_bg:getContentSize().width * self.spr_bg:getScaleX(), self.spr_bg:getContentSize().height * self.spr_bg:getScaleY())
    self:setContentSize(self.content_size)
end

function TrialLayer:onCreate()
    self.spr_title:setPositionX(self:getContentSize().width / 2)
    self.spr_title:setPositionY(self.spr_title:getPositionY() - require("src.model.Game"):instance():getNotchHeight() )

    self.lbl_title:setString(ex.Tools:getLang(41251 + ex.Player.trial_data.hard_lv))
    self:reorderChild(self.spr_title, 20)
    self:reorderChild(self.node_reward_info, 20)
    self:reorderChild(self.node_top, 20)

    

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/trial.plist")
    
    self:setAutoClose(false)
    self.layer_map = TrialMapLayer:createWithCCBIFile("ccbi/TrialMapLayer.ccbi")
    self.scroll_view:setContainer(self.layer_map)
    self.scroll_view:setContentSize(self.layer_map:getContentSize())

    local notch_height = require("src.model.Game"):instance():getNotchHeight()
    self.node_top:setPositionY(self.node_top:getPositionY() - notch_height)

    self.menu = cpp.UIMenu:create()
    self.menu:setPosition(0,0)
    self:addChild(self.menu)

    self:createMenuItem()
    self:addEvent(EVENT.TRIAL_EVENT.TRIAL_END, handler(self, self.onBattleEnd))
    self:addEvent(EVENT.TRIAL_EVENT.TRIAL_GET_BOX, handler(self, self.updateMenu))
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHFB_YZSLRK_YZSL, false)

    self:addCloudAction()

    self:updateRewardInfo()
    self:moveToFocus()

    NetManager:sendMessage(ProtocolID.GReqAdvenAssistHeroList)

    self:addRedDotNode(RedDotType.ZCJ_DHFB_YZSLRK_YZSL_ZYRK, self.btn_help)
end

function TrialLayer:addCloudAction()
    local win_size = self:getContentSize()
    if self.layer_cloud == nil then
        self.layer_cloud = cc.Layer:create()
        self.layer_cloud:setPosition(0, 0)
        self:addChild(self.layer_cloud, 10)
    end
    self.layer_cloud:removeAllChildren()

    for i=1,10 do
        local spr_cloud = cc.Sprite:create()
        spr_cloud:setPosition(win_size.width * 1.5, win_size.height * 0.8)
        self.layer_cloud:addChild(spr_cloud, 20, 100)

        local act_delay = cc.DelayTime:create(math.random(1, 60))
        -- local act_delay = cc.DelayTime:create(math.random(1, 2))
        local act_callback = cc.CallFunc:create(handler(self, self.cloudActionEnd))
        spr_cloud:runAction(cc.Sequence:create(act_delay, act_callback, cc.RemoveSelf:create(), nil))
    end
end

function TrialLayer:cloudActionEnd(pSender)
    if self.layer_cloud == nil or table.nums(self.layer_cloud:getChildren()) > 10 then
        return
    end

    local win_size = self:getContentSize()

    local str_cloud = string.format("main-city-effect/spr-cloud-%d.png", math.random(1, 4))
    local spr_cloud = cc.Sprite:createWithSpriteFrameName(str_cloud)
    self.layer_cloud:addChild(spr_cloud, 20, 100)

    spr_cloud:setPosition(win_size.width * 1.5, win_size.height * math.random(5, 9) / 10.0)

    local act_move_by = cc.MoveBy:create(math.random(50, 100), cc.p(-win_size.width * 2, 0))
    local act_delay = cc.DelayTime:create(math.random(1, 20))
    -- local act_delay = cc.DelayTime:create(math.random(1, 2))
    local act_callback = cc.CallFunc:create(handler(self, self.cloudActionEnd))
    spr_cloud:runAction(cc.Sequence:create(act_move_by, act_delay, act_callback, cc.RemoveSelf:create(), nil))

    if table.nums(self.layer_cloud:getChildren()) < 10 then
        local spr_cloud = cc.Sprite:create()
        spr_cloud:setPosition(win_size.width * 1.5, win_size.height * 0.8)
        self.layer_cloud:addChild(spr_cloud, 20, 100)

        local act_delay = cc.DelayTime:create(math.random(1, 60))
        -- local act_delay = cc.DelayTime:create(math.random(1, 2))
        local act_callback = cc.CallFunc:create(handler(self, self.cloudActionEnd))
        spr_cloud:runAction(cc.Sequence:create(act_delay, act_callback, cc.RemoveSelf:create(), nil))
    end
end

function TrialLayer:updateRewardInfo()
    local cur_mission_id = ex.Player.trial_data:getMissionId()
    local vec_reward = {}
    if ex.Player.trial_data.vec_today_reward ~= nil then
        for i,v in ipairs(ex.Player.trial_data.vec_today_reward) do
            if vec_reward[v.type] == nil then
                    vec_reward[v.type] = v.num
            else
                vec_reward[v.type] = vec_reward[v.type] + v.num
            end
        end
    end

    self.lbl_res_num_1:setString(tostring(vec_reward[900001] or 0))
    self.lbl_res_num_2:setString(tostring(vec_reward[901201] or 0))
end

function TrialLayer:moveToFocus()
    local config = cfg.mainadventurepos.pos[ex.Player.trial_data:getMissionId()]
    if not config then
        return
    end

    local pos = cc.p(config.x, config.y)

    -- 居中显示地图
    local offset_x = -(pos.x * self.layer_map.spr_bg:getScaleX() - self.scroll_view:getViewSize().width * 0.5)
    offset_x = math.min(0, offset_x)
    self.scroll_view:setContentOffset(cc.p(offset_x, 0))
end

function TrialLayer:createMenuItem()
	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/box-effect.plist")
    

    local config = cfg.mainadventurepos.pos 
    local battle_count = 0
    local box_count = 0

    local scale_x = self.layer_map.spr_bg:getScaleX()
    local scale_y = self.layer_map.spr_bg:getScaleY()

    local vec_pos = {}
    vec_pos[1] = {idx = 1, x = 250, y = 994}
    vec_pos[2] = {idx = 2, x = 380, y = 980}
    vec_pos[3] = {idx = 3, x = 494, y = 940}
    vec_pos[4] = {idx = 4, x = 540, y = 760}
    vec_pos[5] = {idx = 5, x = 424, y = 760}
    vec_pos[6] = {idx = 6, x = 270, y = 814}
    vec_pos[7] = {idx = 7, x = 120, y = 856}
    vec_pos[8] = {idx = 8, x = 59, y = 774}
    vec_pos[9] = {idx = 9, x = 122, y = 640}
    vec_pos[10] = {idx = 10, x = 273, y = 610}
    vec_pos[11] = {idx = 11, x = 425, y = 630}
    vec_pos[12] = {idx = 12, x = 535, y = 559}
    vec_pos[13] = {idx = 13, x = 461, y = 450}
    vec_pos[14] = {idx = 14, x = 294, y = 440}
    vec_pos[15] = {idx = 15, x = 145, y = 410}
    vec_pos[16] = {idx = 16, x = 61, y = 294}
    vec_pos[17] = {idx = 17, x = 191, y = 220}
    vec_pos[18] = {idx = 18, x = 321, y = 260}
    vec_pos[19] = {idx = 19, x = 476, y = 310}
    vec_pos[20] = {idx = 20, x = 551, y = 159}

    for i=1,#config do
        local item = UIMenuItemTrial:createWithData(nil, config[i].idx)
        self.menu:add(item)
        -- item:setPosition(config[i].x * scale_x, config[i].y * scale_y)
        item:setPosition(vec_pos[i].x * scale_x, vec_pos[i].y * scale_y)
        item:registerScriptTapHandler(handler(self, self.onClickFight))
        item.config_index = i
        if config[i].type == TRIAL_TYPE.BTN then
            item:setAnchorPoint(0.5, 0.2)
            item:reset(ex.Player.trial_data:getBattleData(i))
            battle_count = battle_count + 1
        elseif config[i].type == TRIAL_TYPE.BOX then
            item:reset(config[i], i >= #config)
        end
    end
end

function TrialLayer:updateMenu()
    self:updateRewardInfo()

    local list = self.menu:getChildren()

    for k,v in pairs(list) do
        if v.type == TRIAL_TYPE.BTN then
            v:reset(ex.Player.trial_data:getBattleData(v.config_index))
        end
        v:resetImg()
    end
end

function TrialLayer:onClickFight(tag, pSender)
    local item_type = cfg.mainadventurepos.pos[tag].type
    if item_type == TRIAL_TYPE.BTN then
        local battle_data = ex.Player.trial_data:getBattleData(tag)
        if battle_data == nil then
            ex.MessageView:add(ex.Tools:getLang(47153))
            return
        end

        local hero_data = pSender:getData()
        self.emeny_data = hero_data
        require("src.layer.TrialInfoCtr"):instance():openWindow(hero_data, tag, handler(self, self.onBattle))
    elseif item_type == TRIAL_TYPE.BOX then 
        require("src.layer.TrialBoxInfoCtr"):instance():openWindow(tag)
    end
end

function TrialLayer:onBattle(vec_battle, fetter_type)
    local req_pass = Adven_pb.GReqTrialPass()
    req_pass.mission_id = ex.Player.trial_data:getMissionId()
    NetManager:sendMessage(ProtocolID.GReqTrialPass, req_pass)
    
    if self.addBattleLayerAuto ~= nil then
        self:addBattleLayerAuto(BattleType.TRIAL, MainSceneType.MAINCITY_TRIAL, MainSceneType.MAINCITY_TRIAL_BATTLE, "", EVENT.TRIAL_EVENT.TRIAL_START)
    end
end

function TrialLayer:onBattleEnd(event, is_win)
    self:updateMenu()
end

function TrialLayer:onBack(tag, pSender)
    --ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
    ex.MainSceneCtr:instance():changeLayer(MainSceneType.MAINCITY_SLZM)

end

function TrialLayer:onInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42022), ex.Tools:getLang(42023))
end

function TrialLayer:onClickShop(tag,pSender)
    cfg.funcopen.main_shop.open(SHOP_TYPE.ADVENTURE)
end

function TrialLayer:onClickHelp(tag,pSender)
    require("src.layer.TrialHelpCtr"):instance():openWindow()
end

function TrialLayer:onExit()

end

return TrialLayer
