--[[
    周向阳
    time:2020-09-21 17:36:13
]]
local GodArmsLayer = class("GodArmsLayer", require("src.comp.EventLayerAdaptiveWidth"))
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")
local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")
local UIMenuItemSkill = require("src.comp.menu.UIMenuItemSkill")

function GodArmsLayer:getAsynImage()
    local vec_image = {
        {image_name = "ccbi-res/crusade-group-2.pvr.ccz", plist_name = "ccbi-res/crusade-group-2.plist", remove_type=2},
        {image_name = "ccbi-res/crusade-group.pvr.ccz", plist_name = "ccbi-res/crusade-group.plist", remove_type=2},
        {image_name = "ccbi-res/crusade-group-effect.pvr.ccz", plist_name = "ccbi-res/crusade-group-effect.plist", remove_type=2},
    }
    return vec_image
end

function GodArmsLayer:onCreate()

    local pos_y = ex.p.height - 100 * ex.s.global_scale - require("src.model.Game"):instance():getNotchHeight()
    self.top:setPositionY(pos_y)

    if self.spr_bg:getContentSize().width * self:getScaleX() < ex.p.width then
        self.spr_bg:setScale(ex.p.width / self.spr_bg:getContentSize().width / self:getScaleX())
    end

    local item_size = cc.Sprite:createWithSpriteFrameName("other/rare-0.png"):getContentSize()
    item_size = cc.size(item_size.width, item_size.height)
    self.scrollview:setItemSize(cc.size(item_size.width, item_size.height))
    self.scrollview:setItemOffset(cc.p(0, 0))
    self.scrollview:setAutoScale(true)

    self:onJob()
    self.btn_up:setVisible(false)

    self:reqFighting()
    self:initData()
    self:updateData()
end

function GodArmsLayer:initData()
    self:addEvent(EVENT.CRUSADE_GROUP.UPDATE_GOD_ARMS, handler(self, self.updateData))
    self:addEvent(EVENT.CRUSADE_GROUP.UPDATE_GOD_ARMS_ISRED, handler(self, self.isRedPoint))
    self.btn_item:registerScriptTapHandler(handler(self, self.showItemInfo))
    self.btn_backpack:registerScriptTapHandler(handler(self, self.onBackPack))
    self.btn_up:registerScriptTapHandler(handler(self, self.onUp))
    self.btn_job_icon:registerScriptTapHandler(handler(self, self.onJobIcon))
    self.btn_attribute:registerScriptTapHandler(handler(self, self.onAttr))

    for i = 1, 4 do
        self["job_" .. i]:registerScriptTapHandler(handler(self, self.onJob))

        self["job_" .. i]:setLabelText(ex.Tools:getLang(111000 + i))
    end
end
--显示属性
function GodArmsLayer:onAttr()
    require("src.layer.crusadegroup.godarms.GodArmsAttrCtr"):instance():openWindow(self:showAttr())
end
--展示合成材料信息
function GodArmsLayer:showItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(tag)
end
--请求战力
function GodArmsLayer:reqFighting(  )
    NetManager:sendMessage(ProtocolID.GReqRoleShenBinInfo)
    NetManager:sendMessage(ProtocolID.GReqShenBinInfo)
end

--选择职业
function GodArmsLayer:onJob(tag, pSender)
    if tag == nil then
        tag = self.job_1:getTag()
    end
    self.type = tag
    self["job_" .. tag]:setChecked(true)
    if self.type == 1 then
        self.lbl_title:setString(ex.Tools:getLang(77849))
    elseif self.type == 2 then
        self.lbl_title:setString(ex.Tools:getLang(77850))
    elseif self.type == 3 then
        self.lbl_title:setString(ex.Tools:getLang(77851))
    elseif self.type == 4 then
        self.lbl_title:setString(ex.Tools:getLang(77852))
    end
    self:updateData()
end
--装备详情
function GodArmsLayer:onEquip(tag, pSender)
    --按钮的状态
    local iscompose = pSender.state
    for i, v in ipairs(self.equip) do
        if pSender.tag == v.hole then
            require("src.layer.crusadegroup.godarms.GodArmsComposeCtr"):instance():openWindow(v.hole, v.job, v.sb_id, v.corelv, iscompose)
        end
    end
end
--升级
function GodArmsLayer:onUp()
    local config = cfg.crusadegroupshenbincore.crusadegroupshenbincore
    for i,v in ipairs(config) do
        if self.type == v.job and self.god_arms_info.coreLv == v.corelv then
            if self.god_arms_info.coreLv >= 5 then
                ex.MessageView:add(ex.Tools:getLang(v.teamlv_lan))
            end
            for i,j in ipairs(config) do
                if self.god_arms_info.coreLv + 1 == j.corelv  then
                    if ctr.crusade_group.data.game_data.self_occupation_id >= j.teamlv then
                        local req = CrusadeGroupShenBin_pb.GReqShenBinCoreUp()
                        req.job = self.type
                        NetManager:sendMessage(ProtocolID.GReqShenBinCoreUp, req)
                    else
                        ex.MessageView:add( string.format(ex.Tools:getLang(77960),ex.Tools:getLang(v.teamlv_lan)))
                    end
                    break
                end
            end
        end
    end  
end
--中心位置的职业图标按钮
function GodArmsLayer:onJobIcon()
    if self.btn_up:isVisible() == false then
        if self.god_arms_info.coreLv == 5 then
            ex.MessageView:add(ex.Tools:getLang(77846))
        else
            ex.MessageView:add(ex.Tools:getLang(77847))
        end
    end
end

function GodArmsLayer:isRedPoint()
    --添加红点
    -- local red = ctr.crusade_group.data.god_arms_isred
    -- -- local red = ctr.crusade_group.data:godArmsAddRed()
    -- for i, v in ipairs(red) do
    --     ex.Tools:addRedPoint(self["job_" .. i], v, ex.r.p9)
    -- end
    -- ctr.crusade_group.data:getJobReddot(1)

    for i=1,4 do
        local reddot = ctr.crusade_group.data:getJobReddot(i)
        ex.Tools:addRedPoint(self["job_" .. i], reddot, ex.r.p9)
    end
end

function GodArmsLayer:updateData()

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/skill-icon.plist")
    sfc:addSpriteFrames("ccbi-res/crusade-group.plist")
    -- 
    -- dump(cc.Director:getInstance():getTextureCache():getCachedTextureInfo())
    self.next = 0
    self.material = 0
    self.role_god_arms_table = {}
    self.btn_up:setVisible(false)
   

    self:isRedPoint()

    --刷新英雄列表
    self:updateScrollView(self.type)

    --神兵信息
    if ctr.crusade_group.data.god_arms_info ~= nil then
        if ctr.crusade_group.data.god_arms_info ~= nil and ctr.crusade_group.data.god_arms_info.shenBinInfos ~= nil then
            self.god_arms_info = ctr.crusade_group.data.god_arms_info.shenBinInfos[self.type]
        end

        -- 背包里拥有的神兵以及道具
        self.role_god_arms_info = ctr.crusade_group.data.role_god_arms_info.roleShenBins
        --获取基础材料
        for k, v in pairs(self.role_god_arms_info) do
            if v.item_type == 902048 then
                self.material = v.itemNum
            else
                table.insert(self.role_god_arms_table, v)
            end
        end

        -- 合成材料的总数
        self.material_num:setString(string.format(self.material))
        -- 职业背景图案
        -- self.job_bg:setSpriteFrame((string.format("crusade-group/spr-shade-%d.png", self.type)))
        ex.Tools:setSpriteFrame(self.job_bg, (string.format("crusade-group/spr-shade-%d.png", self.type)))
        --战力百分比
        local fighting = math.floor(self.god_arms_info.fighting / self:battlePercentage() * 10000)
        if self.god_arms_info.fighting == 0 then
            self.att_percentage:setString(0 .. "%")
        else
            self.att_percentage:setString(fighting / 100 .. "%")
        end

        -- 重置
        for i = 1, 6 do
            self["btn_equip_" .. i]:removeAllChildren()
            self["lbl_compose_" .. i]:setVisible(false)
            self["item_need_num_node_" .. i]:setVisible(false)
        end
        self.effect_node:removeAllChildren()

        self.lbl_lv:setString(string.format(ex.Tools:getLang(19), self.god_arms_info.coreLv))
        -- self.spr_job:setSpriteFrame((string.format("crusade-group/job-%d-%d.png", self.god_arms_info.job, self.god_arms_info.coreLv)))
        ex.Tools:setSpriteFrame(self.spr_job, (string.format("crusade-group/job-%d-%d.png", self.god_arms_info.job, self.god_arms_info.coreLv)))
        -- local spr = cc.Sprite:createWithSpriteFrameName(string.format("crusade-group/job-%d-%d.png", self.god_arms_info.job, self.god_arms_info.coreLv))
        -- self.btn_job_icon:setNormalImage(spr)
        ex.Tools:setSpriteFrame(self.btn_job_icon:getNormalImage(), string.format("crusade-group/job-%d-%d.png", self.god_arms_info.job, self.god_arms_info.coreLv))

        --  特效相关
        if self.god_arms_info.coreLv ~= 1 then
            local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_god_arms_5")
            spr_effect:setPosition(0, 50)
            if self.god_arms_info.coreLv == 2 then
                spr_effect:setScale(0.7)
            elseif self.god_arms_info.coreLv == 3 then
                spr_effect:setScale(1)
            elseif self.god_arms_info.coreLv == 4 then
                spr_effect:setScale(1.5)
            else
                spr_effect:setScale(2)
            end
            self.effect_node:addChild(spr_effect)
        end

        self.equip = {}
        if self.god_arms_info ~= nil and self.god_arms_info ~= "" then
            for j, k in ipairs(cfg.crusadegroupshenbinhole.crusadegroupshenbinhole) do
                if k.job == self.god_arms_info.job and k.corelv == self.god_arms_info.coreLv then
                    table.insert(self.equip, k)
                end
            end
        end

        for i, v in ipairs(self.equip) do
            --查找某个值。callback返回true则停止查找 返回值为被查找的值 即获取装备对应的位置
            local server_equip_data =
                TableEx.findValueFunction(
                self.god_arms_info.equipData.equip_list,
                function(value)
                    return v.hole == value.place
                end
            )

            --和服务端发过来的数据做对比，有数据说明 已经点亮
            local is_max_level = server_equip_data and (server_equip_data.equip_type == v.sb_id) or false
            -- 先把所有装备显示并置灰 即为 不可合成状态
            local item = UIItemBackpack:createWithData(v.sb_id, 0)
            item:setScale(0.8)
            -- state 这个参数代表当前装备的状态 0 不可合成 1 可合成但未合成 2 可装备 3 已经穿戴装备，即为已经点亮
            item.state = 0
            -- 装备部位
            item.tag = v.hole
            item:registerScriptTapHandler(handler(self, self.onEquip))
            self["btn_equip_" .. i]:add(item)
            item:setAllGray(true)

            --点亮已有的装备 取消置灰
            if is_max_level and server_equip_data.equip_type == v.sb_id then
                item.state = 3
                item:setAllGray(false)
            else
                local can_comopse = ctr.crusade_group.data:getComposeEquip(v.sb_id, 1)
                if can_comopse <= self.material then
                    -- 可合成时 显示文本节点
                    item.state = 1
                    self["lbl_compose_" .. i]:setString(ex.Tools:getLang(77856))
                    self["item_need_num_node_" .. i]:setVisible(true)
                    self["item_need_num_" .. i]:setString(can_comopse)
                end
                -- 判断是否拥有该装备 有 显示文本提示 可装备   没有 判断是否可合成
                for j, k in ipairs(self.role_god_arms_table) do
                    if k.itemNum > 0 then
                        if k.item_type == v.sb_id then
                            item.state = 2
                            self["lbl_compose_" .. i]:setString(ex.Tools:getLang(77862))
                            self["item_need_num_node_" .. i]:setVisible(false)
                            break
                        end
                    end
                end
            end

            if item.state == 1 or item.state == 2 then
                self["lbl_compose_" .. i]:setVisible(true)
            end

            --判断是否所有装备都己经穿戴
            if item.state == 3 then
                self.next = self.next + 1
            end
            if item.state == 1 or item.state == 2 then
                -- ex.Tools:addRedPoint(self["job_" .. self.type], true, ex.r.p9)
            end
        end
        --如果都穿戴了并且讨伐团职级大于神兵核心等级显示升级按钮
        if self.next == 6 then
            self.btn_up:setVisible(true)         
        end
        -----------------
        --技能
        self:showSkill()
        self:showAttr()
    end
end
--技能相关
function GodArmsLayer:showSkill()
    for i = 1, 3 do
        self["skill_" .. i]:removeAllChildren()
    end
    self.skill_table = {}
    local config_skill = cfg.crusadegroupshenbincore.crusadegroupshenbincore
    for i, v in ipairs(config_skill) do
        if self.type == v.job and #v.skills ~= 0 then
            table.insert(self.skill_table, v)
        end
    end

    for i, v in ipairs(self.skill_table) do
        local item = UIMenuItemSkill:createWithIcon(v.skills[1].id, v.skills[1].lv, false, handler(self, self.onSkillInfo))
        item:setGray(true)
        self["skill_" .. i]:add(item)
        if self.god_arms_info.coreLv >= v.corelv then
            item:setGray(false)
        end
    end
end

function GodArmsLayer:onSkillInfo(tag, pSender)
    require("src.layer.HeroSkillInfoCtr"):instance():openWindow(pSender.skill_type, pSender.skill_level)
end

--该职业的上阵英雄
function GodArmsLayer:battleHero()
    -- local battle_list = ex.Player.hero_data.promote:getBattleList()
    local battle_list = ctr.crusade_group.data.game_data.set_off_hero_list
    local battle_data = {}
    local battle_hero_list = {}
    local vec_hero = self:getHeroList(self.type)
    if vec_hero ~= nil and #vec_hero ~= 0 then
        for i, v in ipairs(self.vec_hero) do
            for j, k in pairs(battle_list) do
                if v.hero_id == k.hero.hero_id and self.type == v.occupation then
                    table.insert(battle_hero_list, v)
                end
            end
        end
    end
    return battle_hero_list
end

--该职业所有英雄的基础战力
function GodArmsLayer:battlePercentage()
    local battle_hero_list = self:battleHero()
    --当前职业所有英雄的基础战力
    local atk = 0
    for i, v in ipairs(battle_hero_list) do
        atk = v.fighting + atk
    end

    return atk
end

--该职业属性显示
function GodArmsLayer:showAttr()
    local battle_hero_list = self:battleHero()
    local god_arms_id_list = {} --所有穿在身上的装备id
    local god_arms_attr = {} --所有穿在身上的神兵属性
    local god_arms_core = {} --所有穿在身上的神兵核心
    --测试数据，实际应该为 0
    local atk = 0
    local hp = 0
    local def = 0
    local atk_percentage = 0
    local hp_percentage = 0
    local def_percentage = 0

    local function add_attr_core(data)
        for k, v in pairs(data) do
            if v.attr ~= nil and #v.attr ~= 0 then
                for i, j in pairs(v.attr) do
                    if j ~= nil then
                        local attr = clone(j)
                        table.insert(god_arms_attr, attr)
                    end
                end
            end
        end
    end

    local function add_attr_id_list(data)
        for i, v in ipairs(data) do
            for k, j in pairs(cfg.crusadegroupshenbin.crusadegroupshenbin) do
                if v == j.sb_id and j.attr ~= nil and #j.attr ~= 0 then
                    for e, q in pairs(j.attr) do
                        if q ~= nil then
                            local attr = clone(q)
                            table.insert(god_arms_attr, attr)
                        end
                    end
                end
            end
        end
    end

    -------当前等级穿在身上的装备，即显示的
    if self.god_arms_info.equipData.equip_list ~= nil and #self.god_arms_info.equipData.equip_list ~= 0 then
        for k, v in pairs(self.god_arms_info.equipData.equip_list) do
            table.insert(god_arms_id_list, v.equip_type)
        end
    end

    add_attr_id_list(god_arms_id_list)

    ------当前的核心等级
    for k, v in pairs(cfg.crusadegroupshenbincore.crusadegroupshenbincore) do
        if self.type == v.job and self.god_arms_info.coreLv == v.corelv then
            table.insert(god_arms_core, v)
        end
    end

    add_attr_core(god_arms_core)

    if self.god_arms_info.coreLv > 1 then
        for i = 1, self.god_arms_info.coreLv - 1 do
            --找到所有已经装备的职业核心的属性
            for k, v in pairs(cfg.crusadegroupshenbincore.crusadegroupshenbincore) do
                if self.type == v.job and self.god_arms_info.coreLv - i == v.corelv then
                    table.insert(god_arms_core, v)
                end
            end

            --找到所有穿在身上的装备id
            for k, v in pairs(cfg.crusadegroupshenbinhole.crusadegroupshenbinhole) do
                if self.type == v.job and self.god_arms_info.coreLv - i == v.corelv then
                    table.insert(god_arms_id_list, v.sb_id)
                end
            end
        end

        add_attr_id_list(god_arms_id_list)
        add_attr_core(god_arms_core)
    end

    for k, v in pairs(god_arms_attr) do
        if v.attr == 102 then
            hp_percentage = hp_percentage + v.value / 10000.0
        elseif v.attr == 201 then
            atk_percentage = atk_percentage + v.value / 10000.0
        elseif v.attr == 202 then
            def_percentage = def_percentage + v.value / 10000.0
        elseif v.attr == 220 then
            atk = atk + v.value
        elseif v.attr == 223 then
            hp = hp + v.value
        elseif v.attr == 224 then
            def = def + v.value
        end
    end

    atk = atk * (1 + atk_percentage)
    hp = hp * (1 + hp_percentage)
    def = def * (1 + def_percentage)

    self.atk_num:setString(atk)
    self.atk_num:setPositionX(self.lbl_atk:getPositionX() + self.lbl_atk:getContentSize().width + 5)
    self.hp_num:setString(hp)
    self.hp_num:setPositionX(self.lbl_hp:getPositionX() + self.lbl_hp:getContentSize().width + 5)
    self.defence_num:setString(def)
    self.defence_num:setPositionX(self.lbl_defence:getPositionX() + self.lbl_defence:getContentSize().width + 5)
    return god_arms_attr
end

function GodArmsLayer:getHeroList( type )
    self.hero_list = ex.Player.hero_data:getHeroList()

    local temp_dict = {}
    for i, v in ipairs( self.hero_list) do
        if v.star >= 6 then
            if not temp_dict[v.hero_type] or temp_dict[v.hero_type].star < v.star or (temp_dict[v.hero_type].star == v.star and temp_dict[v.hero_type].fighting < v.fighting) then
                temp_dict[v.hero_type] = v
                -- table.insert( temp_dict, v )
            end
        end
    end
    local temp_dict1 = {}
    for k,v in pairs(temp_dict) do
        if k == v.hero_type then
            table.insert( temp_dict1,v )
        end
    end

    local function find(id)
        for i, v in ipairs(ctr.crusade_group.data.game_data.set_off_hero_list) do
            if v.hero.hero_id == id then
                return true
            end
        end
        return false
    end

    local function sor(a, b)
        local score_a = 1
        local score_b = 1
        if find(a.hero_id) then
            score_a = 1
        else
            score_a = 0
        end
        if find(b.hero_id) then
            score_b = 1
        else
            score_b = 0
        end
        if score_a == score_b then
            if a.star == b.star then
                if a.level == b.level then
                    return a.hero_type > b.hero_type
                else
                    return a.level > b.level
                end
            else
                return a.star > b.star
            end
        end
        return score_a > score_b
    end

    table.sort(temp_dict1, sor)

    self.vec_hero = {}
    for i, v in pairs(temp_dict1) do
        if type == v.occupation then
            table.insert(self.vec_hero, v)
        end
    end
    return self.vec_hero
end

--英雄展示框
function GodArmsLayer:updateScrollView(type)


    self.scrollview:setData(self:getHeroList(type))
    self.scrollview.createItemFunction = function(hero_data, scale)
        local isshow = false
        local item = UIMenuItemHero:createWithData(hero_data.hero_id, hero_data.hero_type, hero_data.elem, hero_data.level, hero_data.star)
        -- item:registerScriptTapHandler(handler(self, self.onBackpackIcon))
        item.hero_id = hero_data.hero_id
        item:setScale(0.8)
        for i, v in ipairs(ctr.crusade_group.data.game_data.set_off_hero_list) do
            if v.hero.hero_id == item.hero_id then
                isshow = true
            end
        end
        if isshow then
            item:setGray(true)
        else
            item:setGray(false)
        end
        return item
    end
    self.scrollview:reloadData(self:getHeroList(type))
end

--神兵背包
function GodArmsLayer:onBackPack()
    require("src.layer.crusadegroup.godarms.GodArmsBackpackCtr"):instance():openWindow()
end

function GodArmsLayer:onBack()
    ex.JumpManager:jumpByAtom("main_crusade_group")
end

--战力信息显示
function GodArmsLayer:showFighting()
    require("src.layer.crusadegroup.godarms.GodArmsFightingShowCtr"):instance():openWindow(self:battlePercentage(), self.god_arms_info.fighting)
end

return GodArmsLayer
