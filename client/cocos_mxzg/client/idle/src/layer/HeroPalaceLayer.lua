local HeroPalaceLayer = class("HeroPalaceLayer", require("src.comp.EventLayer"))

function HeroPalaceLayer:onCreate()
    self:setAutoClose(false)
    self:setPosition(cc.p(0, 0))

    self.btn_like:setLabelText(ex.Tools:getLang(73403))
    ex.Tools:setGray(self.btn_like:getDisabledImage())

    self.cur_elem_select = ElemType.FIRE
    self.cur_sever_select = cc.UserDefault:getInstance():getIntegerForKey("server_id")

    self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)
    self.spr_bg:setScaleY(ex.p.height / self.spr_bg:getContentSize().height)

    self.content_size = cc.size(self.spr_bg:getContentSize().width * self.spr_bg:getScaleX(), self.spr_bg:getContentSize().height * self.spr_bg:getScaleY())
    self:setContentSize(self.content_size)

    self.tb_sever = {}
    for k,v in ipairs(ex.Player.hero_data.hero_palace_list) do
        local table_temp = {}
        local index = 1
        table_temp[index] = self.cur_sever_select
        index = index + 1
        for j,n in ipairs(v.server_rank_role) do
            if n.server_id ~= self.cur_sever_select then
                table_temp[index]=n.server_id
                index = index + 1
            end
        end
        self.tb_sever[v.type] = table_temp
    end

    -- 播放背景光效
    self.spr_effect_bg_light = ex.EffectFactory:createEffectWithNodeByName("eff_clan_boss_bg")
    self.spr_effect_bg_light:setScale(2.5)
    self.spr_effect_bg_light:setPosition(15, 150)
    self.node_top_1:addChild(self.spr_effect_bg_light)

    self.node_top_1:reorderChild(self.node_animator_1, 10)
    self:reorderChild(self.node_top_1, 50)

    -- 添加头像框特效
    local spr_effect = cc.Sprite:create()
    spr_effect:setPosition(self.spr_reward:getContentSize().width / 2, self.spr_reward:getContentSize().height / 2)
    spr_effect:setScale(1.2)
    self.spr_reward:addChild(spr_effect, 10)
    spr_effect:runAction(cc.RepeatForever:create(ex.EffectFactory:createAnimate("ccbi-res/hero-palace.plist", "hero-palace/effect-%d.png", 0.12)))

    self:reorderChild(self.node_reward, 100)

    -- 添加红点
    self.spr_reward.spr_reddot = cc.Sprite:createWithSpriteFrameName("other/spr-reddot-1.png")
    self.spr_reward.spr_reddot:setPosition(self.spr_reward:getContentSize().width * 0.8, self.spr_reward:getContentSize().height * 0.8)
    self.spr_reward.spr_reddot:setVisible(false)
    self.spr_reward:addChild(self.spr_reward.spr_reddot, 100)

    self.btn_like.spr_reddot = cc.Sprite:createWithSpriteFrameName("other/spr-reddot-1.png")
    self.btn_like.spr_reddot:setPosition(self.btn_like:getContentSize().width * 0.85, self.btn_like:getContentSize().height * 0.8)
    self.btn_like.spr_reddot:setVisible(false)
    self.btn_like:addChild(self.btn_like.spr_reddot, 100)

    self:updateLayer()

    -- 请求刷新数据
    NetManager:sendMessage(ProtocolID.GReqHeroPalaceData)

    self:addEvent(EVENT.HERO_PALACE_EVENT.UPDATE_LAYER, handler(self, self.updateLayer))

    self:addRedDotNode(RedDotType.ZCJ_DHZC_YXDT_HYS, self.btn_tab_1)
    self:addRedDotNode(RedDotType.ZCJ_DHZC_YXDT_SYS, self.btn_tab_2)
    self:addRedDotNode(RedDotType.ZCJ_DHZC_YXDT_MYS, self.btn_tab_3)
    self:addRedDotNode(RedDotType.ZCJ_DHZC_YXDT_GYS, self.btn_tab_4)
    self:addRedDotNode(RedDotType.ZCJ_DHZC_YXDT_AYS, self.btn_tab_5)
    self:addRedDotNode(RedDotType.ZCJ_DHZC_YXDT_SYYS, self.btn_tab_6)
end

function HeroPalaceLayer:onExit()

end

function HeroPalaceLayer:updateLayer()
    local server_id = ex.StringUtil.getServerName(self.cur_sever_select)
    self.lbl_title:setString(string.format(ex.Tools:getLang(73439), server_id)) 

    local type = self.cur_elem_select == ElemType.ALL and 6 or self.cur_elem_select
    local hero_palace_data = nil
	for k,v in pairs(ex.Player.hero_data.hero_palace_list) do
        if v.type == type then
            local table_data = {}
            table_data.is_reward = v.is_reward
            table_data.is_worship = v.is_worship
            for j,n in pairs(v.server_rank_role) do
                if n.server_id == self.cur_sever_select then
                    table_data.rank_role = n.rank_role
                    hero_palace_data = table_data
                    break
                end
            end
			break
		end
    end
    
    -- 刷新背景
    local texture = cc.Director:getInstance():getTextureCache():addImage(string.format("ccbi-res/map-bg-hero-palace-%d.jpg", type))
    if texture then
        self.spr_bg:setTexture(texture)
    end

    -- 刷新奖励显示
    local reward_config = nil
    for k,v in pairs(cfg.heropalace.heropalace) do
		if v.elem == self.cur_elem_select and v.rank == 1 then
            reward_config = v
            break
		end
    end
    if reward_config ~= nil then
        self.spr_reward:setVisible(true)
        ex.Tools:setSpriteFrame(self.spr_reward, "backpack/"..reward_config.reward[1].item_type..".png")
    else
        if self.item_reward ~= nil then
            self.item_reward:setVisible(false)
        end
    end

    -- 刷新前三玩家信息显示
    -- self.cur_sever_select

    for i=1,3 do
        if hero_palace_data == nil or hero_palace_data.rank_role[i] == nil then
            self["lbl_name_"..i]:setString(ex.Tools:getLang(73402))
            self["node_animator_"..i]:setVisible(false)
            self["btn_player_info_"..i]:setVisible(false)
        else
            self["lbl_name_"..i]:setString(hero_palace_data.rank_role[i].nick)
            self["node_animator_"..i]:setVisible(true)
            self["btn_player_info_"..i]:setVisible(true)
            self["btn_player_info_"..i].player_id = hero_palace_data.rank_role[i].player_id

            local spine_hero = self["spine_hero_"..i]
            if spine_hero ~= nil then
                spine_hero:removeFromParent()
                spine_hero = nil
                self["spine_hero_"..i] = nil
            end

            spine_hero = require("src.person.Hero"):create("1", "1", 1, 1, ex.Tools:getHeroSkinByImageId(hero_palace_data.rank_role[i].image_id))
            spine_hero:setAnimation(0, "stand", true);
            spine_hero:setScale(i <= 1 and 1.5 or 1)
            spine_hero:setPosition(cc.p(0, i <= 1 and 80 or 50))
            self["node_animator_"..i]:addChild(spine_hero, 10)

            self["spine_hero_"..i] = spine_hero
        end
    end

    -- 刷新提示
    if self.cur_elem_select == ElemType.ALL then
        -- self.spr_tip_1:setSpriteFrame("hero-palace-lang/lbl-tip-2.png")
        ex.Tools:setSpriteFrame(self.spr_tip_1, "hero-palace-lang/lbl-tip-2.png")
    else
        ex.Tools:setSpriteFrame(self.spr_tip_1, "hero-palace-lang/lbl-tip-elem-"..self.cur_elem_select..".png")
        -- self.spr_tip_1:setSpriteFrame("hero-palace-lang/lbl-tip-elem-"..self.cur_elem_select..".png")
    end

    -- 刷新膜拜按钮状态显示
    self.btn_like:setEnabled(hero_palace_data == nil or hero_palace_data.is_worship ~= true)

    -- 刷新红点显示
    self.spr_reward.spr_reddot:setVisible(ex.Player.hero_data:isCanHeroPalaceRewawrd(type,self.cur_sever_select) == 0)
    self.btn_like.spr_reddot:setVisible(ex.Player.hero_data:isCanHeroPalaceWorship(type,self.cur_sever_select) == 0)
    ex.Player.hero_data:updateHeroPalaceReddot(self.cur_sever_select)
    ex.Player.hero_data:updateHeroPalacehallReddot()

    -- 设置当前选中的tab按钮状态
    for i=1,6 do
        self["btn_tab_"..i]:setChecked(type == i)
    end
    self.spr_selected:setPosition(self["btn_tab_"..type]:getPosition())
end

function HeroPalaceLayer:onBack(tag, pSender)
    ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
end

-- 查看奖励
function HeroPalaceLayer:onReward(tag, pSender)
    require("src.layer.HeroPalaceRewardCtr"):instance():openWindow(self.cur_elem_select == ElemType.ALL and 6 or self.cur_elem_select,self.cur_sever_select)
end

-- 玩家详细
function HeroPalaceLayer:onPlayerInfo(tag, pSender)
    ex.Tools:showPlayerInfo(pSender.player_id, cc.UserDefault:getInstance():getIntegerForKey("server_id", 0))
end

-- 膜拜
function HeroPalaceLayer:onLike(tag, pSender)
    local type = self.cur_elem_select == ElemType.ALL and 6 or self.cur_elem_select
    local hero_palace_data = nil
	for k,v in pairs(ex.Player.hero_data.hero_palace_list) do
        if v.type == type then
            local table_data = {}
            table_data.is_reward = v.is_reward
            table_data.is_worship = v.is_worship
            for j,n in pairs(v.server_rank_role) do
                if n.server_id == self.cur_sever_select then
                    table_data.rank_role = n.rank_role
                    hero_palace_data = table_data
                    break
                end
            end
			break
		end
    end
    if hero_palace_data == nil or hero_palace_data.rank_role == nil or table.nums(hero_palace_data.rank_role) <= 0 then
        ex.MessageView:add(ex.Tools:getLang(73404))
        return
    end

    local req = HeroPalace_pb.GReqHeroPalaceWorship()
    req.type = self.cur_elem_select == ElemType.ALL and 6 or self.cur_elem_select
    NetManager:sendMessage(ProtocolID.GReqHeroPalaceWorship, req)
end

-- 切换属性
function HeroPalaceLayer:onTab(tag, pSender)
    if tag == nil or self.cur_elem_select == tag then
        return
    end

    self.cur_elem_select = tag
    self:updateLayer()
end

function HeroPalaceLayer:onInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42084), ex.Tools:getLang(42085))
end

-- add 熊梦 合服后的功能
function HeroPalaceLayer:onLeft(tag, pSender)
    if self.cur_sever_select == cc.UserDefault:getInstance():getIntegerForKey("server_id") then 
        return
    end
    local type = self.cur_elem_select == ElemType.ALL and 6 or self.cur_elem_select
    for i,v in ipairs(self.tb_sever) do
        if type == i then
            for k,n in ipairs(v) do
                if self.cur_sever_select == n then
                    if k == 1 then return end
                    self.cur_sever_select = v[k - 1]
                    break
                end
            end
            break
        end
    end
    self:updateLayer()
end

function HeroPalaceLayer:onRight(tag, pSender)
    local type = self.cur_elem_select == ElemType.ALL and 6 or self.cur_elem_select
    for i,v in ipairs(self.tb_sever) do
        if type == i then
            for k,n in ipairs(v) do
                if self.cur_sever_select == n then
                    if k == #v then
                       return
                    else
                        self.cur_sever_select = v[k + 1]
                        break
                    end
                end
            end
            break
        end
    end
    self:updateLayer()
end

return HeroPalaceLayer
