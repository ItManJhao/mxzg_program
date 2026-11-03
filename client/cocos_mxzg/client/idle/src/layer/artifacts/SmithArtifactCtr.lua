local SmithArtifactCtr = class("SmithArtifactCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local SmithArtifactLayer = class("SmithArtifactLayer", require("src.comp.EventLayerAdaptiveWidth"))
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")
local UIMenuItemSkill = require("src.comp.menu.UIMenuItemSkill")

function SmithArtifactLayer:onCreate()
	self:addBlackBackground()
    self:setAutoClose(true)
    self:setSwallowTouches(false)
    self.tag = 0

    self.cur_compose_info = nil         -- 当前选中的合成神装信息
    self.god_equip_list = {}            -- 神装列表信息
    self.cur_selected_attr_list = {}    -- 当前选中的属性表
    self.item_lbl_tips = {}
    self.item_select = {}
    self.hero_list = {}
    self.replace_list = {}

    self.god_equip_team_ui = {
        -- 合成材料节点信息
        [1] = {
            btn_null = self.btn_add_1,
            menu = self.menu_equip_1
        },
        [2] = {
            btn_null = self.btn_add_2,
            menu = self.menu_equip_2
        },
        [3] = {
            btn_null = self.btn_add_3,
            menu = self.menu_equip_3
        }
    }

    self.god_equip_compose_ui = {
        btn_null = self.btn_add_0,
        menu = self.menu_equip_0
    }
    
    for i,v in ipairs(self.god_equip_team_ui) do
        local spr_add = cc.Sprite:createWithSpriteFrameName("other/spr-add-1.png")
        spr_add:setPosition(v.btn_null:getContentSize().width / 2, v.btn_null:getContentSize().height / 2)
        spr_add:setVisible(false)
        spr_add:setName("add")
        v.btn_null:getNormalImage():addChild(spr_add)

        v.btn_null:registerScriptTapHandler(handler(self, self.onAdd))
    end


    self.compose_need_res = {
        [1] = {
            btn = self.btn_res_bg_1,
        },
        [2] = {
            btn = self.btn_res_bg_2,
        }
    }

	for i = 1 , 2 do 
        local btn = self["btn_artifact_" ..i]
        btn.rare = cc.Sprite:create()
		btn:addChild(btn.rare)
		btn.rare:setPosition(btn:getContentSize().width/2,btn:getContentSize().height/2)
        btn.rare:setVisible(false)
        
		btn.icon = cc.Sprite:create()
		btn:addChild(btn.icon)
		btn.icon:setPosition(btn:getContentSize().width/2,btn:getContentSize().height/2)
		btn.icon:setVisible(false)
		btn:registerScriptTapHandler(handler(self,self.onClickRoute))
        btn:setTag(i)

        btn.selected = cc.Sprite:createWithSpriteFrameName("other/spr-select.png")
		btn:addChild(btn.selected)
		btn.selected:setPosition(btn:getContentSize().width/2,btn:getContentSize().height/2)
        btn.selected:setVisible(false)
        
    end
    
    self.btn_compose:registerScriptTapHandler(handler(self, self.onCompose))

end

function SmithArtifactLayer:onInfo(tag ,pSender)
	ex.InfoCtr:openWindow(ex.Tools:getLang(42076), ex.Tools:getLang(42077))
end


function SmithArtifactLayer:refresh()
    self:refreshView()
end

function SmithArtifactLayer:refreshView()

    self:refreshGodEquipPanel()

end

function SmithArtifactLayer:refreshGodEquipPanel()
    for i, v in ipairs(self.god_equip_team_ui) do
        local equip = self.need_data[i]
        if equip then
            v.btn_null:setVisible(false)

            if v.btn_item then
                v.btn_item:removeFromParent()
                v.btn_item = nil
            end

            -- v.btn_item = i ~= 3 and ex.Tools:createBackpackItem(equip.item_type or equip.sys_id, 0) or UIMenuItemHero:createWithData(0,0,equip.elem,0,equip.star)
            if i ~= 3 then 
                v.btn_item = ex.Tools:createBackpackItem(equip.item_type or equip.sys_id, 0)
            else
                v.btn_item = UIMenuItemHero:createWithData(0,0,equip.elem,0,equip.star)
            end
            v.btn_item:setEnableAction(true)
            v.btn_item:setScale(0.885)
            v.btn_item:setAnchorPoint(ex.a.center)
            v.btn_item:setPosition(ex.p.zero)
            v.btn_item:setTag(i)
            v.btn_item.data = equip
            v.menu:addChild(v.btn_item)
            if 3 == i then 

                v.btn_item.spr_rare = cc.Sprite:createWithSpriteFrameName(string.format("backpack/rare-6.png", 20005000))
                v.btn_item:addChild(v.btn_item.spr_rare)
                v.btn_item.spr_rare:setPosition(v.btn_item:getContentSize().width / 2,v.btn_item:getContentSize().height / 2)

                v.btn_item.spr_hero_icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", 20005000))
                v.btn_item:addChild(v.btn_item.spr_hero_icon)
                v.btn_item.spr_hero_icon:setPosition(v.btn_item:getContentSize().width / 2,v.btn_item:getContentSize().height / 2)
                v.btn_item.spr_hero_icon:setScale(0.95)

                if v.btn_item.node_star then
                    v.btn_item.node_star:removeFromParent()
                    v.btn_item.node_star = nil
                end
            
                v.btn_item.node_star = cc.Node:create()
                v.btn_item:addChild(v.btn_item.node_star, 100)
            
                if equip.star < 10 then
                    local star_type = math.floor(equip.star / 5)
                    local star_count = 1
                
                    if equip.star % 5 == 0 then 
                        if equip.star <= 5 then
                            star_count = 5
                            star_type = 0
                        end
                    else
                        star_count = equip.star % 5
                    end
                    if equip.star > 10 then star_count = star_count + 1 end
            
                    local diff = 9.0
                    local icon_size = v.btn_item:getContentSize()
                    local start_pos = cc.p(icon_size.width * 0.5 - (star_count - 1) * diff * 0.5, 15)
            
                    for i=1,star_count do
                        local spr_star = nil
                        -- if self.star > 9 then
                        -- 	spr_star = cc.Sprite:createWithSpriteFrameName(string.format("other/star-10-%d.png", self.star - 9))
                        -- 	spr_star:setScale(0.75)
                        -- else
                            spr_star = cc.Sprite:createWithSpriteFrameName(string.format("other/star-%d.png", star_type))
                            spr_star:setScale(0.5)
                        -- end
                        spr_star:setPosition(cc.p(start_pos.x + (i - 1) * diff, start_pos.y))
                        v.btn_item.node_star:addChild(spr_star)
                    end
                else
                    local spr_star_bg = cc.Sprite:createWithSpriteFrameName("backpack/spr-star-bg-2.png")
                    :setPosition(cc.p(v.btn_item:getContentSize().width / 2, 12))
                    v.btn_item.node_star:addChild(spr_star_bg, 5)
                
                    -- 英雄觉醒 add 熊梦 图标修改 如果加到15星需要再次修改
                    if equip.star == ex.Player.awaken_star then
                        spr_star_bg:setSpriteFrame("backpack/spr-star-bg-4.png")
                    elseif equip.star > 10 then
                        local spr_star = cc.Sprite:createWithSpriteFrameName("backpack/lbl-star-"..(equip.star - 10)..".png")
                        :setPosition(spr_star_bg:getPosition())
                        v.btn_item.node_star:addChild(spr_star, 10)
                    end
            
                    -- 播放高星特效
                    local spr_effect_star = ex.EffectFactory:createEffectWithNodeByName("eff_hero_star")
                    spr_effect_star:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
                    v.btn_item.node_star:addChild(spr_effect_star, 100)
                end
            end
            local callback = i == 3 and handler(self, self.onAdd) or handler(self, self.onShowInfo)
            v.btn_item:registerScriptTapHandler(callback)

            if not self.item_lbl_tips[i] then 
                self.item_lbl_tips[i] = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 18)
                self.item_lbl_tips[i]:enableOutline(cc.c3b(0,0,0),1)
                v.btn_item:addChild(self.item_lbl_tips[i])
                self.item_lbl_tips[i]:setAnchorPoint(cc.p(1,1))
                self.item_lbl_tips[i]:setPosition(v.btn_item:getContentSize().width - 5,v.btn_item:getContentSize().height -5)
                self.item_lbl_tips[i]:setLocalZOrder(10000)
            end

            if 1 == i then 
                self.item_lbl_tips[i]:setString(string.format("%s/%s",1,1))
                self.item_lbl_tips[i]:setColor(cc.c3b(128,255,107))
                self.item_lbl_tips[i]:setLocalZOrder(10000)
            elseif 2 == i then 
                local has_num = ex.Player:getItemNum(equip.item_type)
                local color = has_num >= equip.item_num and cc.c3b(128,255,107) or cc.c3b(255,255,255)
                self.item_lbl_tips[i]:setString(string.format("%s/%s",has_num,equip.item_num))
                self.item_lbl_tips[i]:setColor(color)
            elseif 3 == i then 
                local has_num = table.nums(self.item_select)
                local color = has_num >= equip.num and cc.c3b(128,255,107) or cc.c3b(255,255,255)
                self.item_lbl_tips[i]:setString(string.format("%s/%s",has_num,equip.num))
                self.item_lbl_tips[i]:setColor(color)
            end
        else
            if v.btn_item then v.btn_item:setVisible(false) end

            v.btn_null:setVisible(true)
        end
    end

end

function SmithArtifactLayer:onShowInfo(tag ,pSender)
    -- ex.Tools:onClickItemInfo(pSender.item_type)
    print(self.__cname,tag)
    dump(pSender.data)
    
    if not pSender.data then return end
    if 2 == tag then 
        ex.Tools:onClickItemInfo(pSender.data.item_type)
    elseif 1 == tag or -1 == tag then 
        local equip_data = {}
        equip_data.sys_id = pSender.data.idx or pSender.data.sys_id

        local equip_list = {}
        local data = {}
        equip_list[1] = equip_data.sys_id
        -- for k,v in pairs(artifact_data) do
        --     table.insert(equip_list,v.sys_id)
        -- end
        data.equip_list = equip_list
        local equip = {}
        equip.sys_id = equip_data.sys_id
        -- equip.reiki_equip_id = artifact_data[tag].reiki_equip_id
        data.equip = equip
        local ctr = require("src.layer.artifacts.ArtifactTipsCtr"):instance()
        ctr:openWindow()
        :addEquipInfo(data)
    end


end

function SmithArtifactLayer:onAdd(tag, pSender)

    if self.cur_compose_info == nil or 1 == tag then return end
    local item_info = self.need_data[tag]
    
    if item_info == "" or item_info == nil then return end
    dump(item_info)
    local list = ex.Player.hero_data:getHeroByStar(item_info.star)
    local hero_list = {}
    local replace_num = ex.Player:getItemNum(item_info.replace_item)

    if replace_num > 0 then 
        for i=1,replace_num do
            local data = {}
            data.item_type = item_info.replace_item
            data.item_num = 1
            data.is_item = 1
            table.insert(hero_list,data)
        end
    end

    for i,v in ipairs(list) do
        local data = {}
        data.hero_id = v.hero_id 
        data.hero_type = v.hero_type
        data.star = v.star 
        data.is_lock = v.is_lock
        data.elem = v.elem
        data.level = v.level
        -- dump(data)
        table.insert(hero_list,data)
        
    end

    local callback = handler(self,self.selectItem)
    require("src.layer.artifacts.ArtifactItemSelectCtr"):instance():openWindow(hero_list,callback,item_info.num)
end

function SmithArtifactLayer:selectItem(data)
    self.hero_list = {}
    self.replace_list = {}
    for i,v in ipairs(data) do
        if v.hero_id then 
            table.insert(self.hero_list,v.hero_id)
        elseif v.item_type then 
            table.insert(self.replace_list,v.item_type)
        end
    end

    self.item_lbl_tips[3]:setString(string.format("%s/%s",(table.nums(self.hero_list) + table.nums(self.replace_list)),self.need_data[3].num))
    local has_num = (table.nums(self.hero_list) + table.nums(self.replace_list))
    local color = has_num >= self.need_data[3].num and cc.c3b(128,255,107) or cc.c3b(255,255,255)
    self.item_lbl_tips[3]:setColor(color)
    self:checkBtnStatus()
end

function SmithArtifactLayer:checkBtnStatus()
    -- btn_compose
    local enable = false
    local has_num = ex.Player:getItemNum(self.need_data[2].item_type)
    
    enable = has_num >= self.need_data[2].item_num and (table.nums(self.hero_list) + table.nums(self.replace_list)) >= self.need_data[3].num
    -- self.btn_compose:setEnabled(enable)
    -- local spr = self.btn_compose:getNormalImage()
    -- ex.Tools:setGrayAuto(spr,not enable)
end

-------------

function SmithArtifactLayer:setData(data)
    self.data = data 
    self.need_data = {}
    self.need_data[1] = self.data 
    self.god_equip_list[1] = {item_type = data.sys_id,item_num = 1,reiki_equip_id = data.reiki_equip_id}
	-- local conf = cfg.reikiequip.reikiequip[data.sys_id]
    self:updateRoute()
    self:refresh()
    self:checkBtnStatus()
end

function SmithArtifactLayer:updateRoute()
	local conf = cfg.reikiequip.reikiequip[self.data.sys_id]
	local up_target = conf.up_star_target
	local has_route = up_target ~= "" and table.nums(up_target) > 0
	self.menu_route:setVisible(has_route)
	if has_route then 
		for i=1,2 do
			local btn = self["btn_artifact_" ..i]
			local lbl = self["lbl_ring_" ..i]
			lbl:setVisible(table.nums(up_target) > 1)
			btn:setVisible(up_target[i] ~= nil)
            btn.icon:setVisible(up_target[i] ~= nil)
            btn.rare:setVisible(up_target[i] ~= nil)
			if up_target[i] ~= nil then 
                btn.icon:setSpriteFrame(string.format("backpack/%d.png",  up_target[i]))
                btn.rare:setSpriteFrame(string.format("backpack/rare-%d.png",  cfg.item.item[up_target[i]].rare_mark))
			end
		end
	end
    self:selectedRoute(1)
end

function SmithArtifactLayer:onClickRoute(tag,pSender)
    print(self.__cname,tag)
    if not self.can_click then return end 
    if self.tag == tag then return end
    self.tag = tag
    self:selectedRoute(tag)
end

function SmithArtifactLayer:selectedRoute(tag)
    self.can_click = false
	local conf = cfg.reikiequip.reikiequip[self.data.sys_id]
	local up_target = conf.up_star_target
	local up_target_item = up_target[tag]
    self.cur_compose_info = cfg.reikiequip.reikiequip[up_target_item]
    if self.cur_compose_info.up_star_cost ~= "" and self.cur_compose_info.up_star_cost[1] ~= nil then 
        self.need_data[2] = self.cur_compose_info.up_star_cost[1]
    end

    if self.cur_compose_info.cost_star_hero ~= "" and self.cur_compose_info.cost_star_hero[1] ~= nil then 
        self.need_data[3] = self.cur_compose_info.cost_star_hero[1]
    end

    for i=1,2 do
        local btn = self["btn_artifact_" ..i]
        btn.selected:setVisible(btn:getTag() == tag)
    end

    self:updateComposeItem()
    self:updateAttr()
end

function SmithArtifactLayer:updateComposeItem()
    if self.cur_compose_info then
        -- 有合成
        self.god_equip_compose_ui.btn_null:setVisible(false)

        if self.god_equip_compose_ui.btn_item then
            self.god_equip_compose_ui.btn_item:removeFromParent()
            self.god_equip_compose_ui.btn_item = nil
        end

        self.god_equip_compose_ui.btn_item = ex.Tools:createBackpackItem(self.cur_compose_info.idx, 1)
        self.god_equip_compose_ui.btn_item:setEnableAction(true)
        self.god_equip_compose_ui.btn_item:setScale(1.058)
        self.god_equip_compose_ui.btn_item:setAnchorPoint(ex.a.center)
        self.god_equip_compose_ui.btn_item:setPosition(ex.p.zero)
        self.god_equip_compose_ui.btn_item.data = self.cur_compose_info
        self.god_equip_compose_ui.menu:addChild(self.god_equip_compose_ui.btn_item)
        self.lbl_ring_name:setString(ex.Tools:getLang(cfg.item.item[self.cur_compose_info.idx].name))

        self.god_equip_compose_ui.btn_item:registerScriptTapHandler(handler(self, self.onShowInfo))
        -- self:updataComposeNeedItem()
    else
        -- 无合成
        if self.god_equip_compose_ui.btn_item then self.god_equip_compose_ui.btn_item:setVisible(false) end

        self.god_equip_compose_ui.btn_null:setVisible(true)
    end
end

function SmithArtifactLayer:updateAttr( )
    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/backpack-info.plist")
    
    local ability = self.cur_compose_info.ability
    local special_ability = self.cur_compose_info.special_ability
    local suit_ability = cfg.reikiequipsuit.reikiequipsuit[self.cur_compose_info.suit_id].suit_ability
    self.height = 0
    -- 排序属性
    local function sortAbility(a, b)
        -- local compA = cfg.scorecount.mapping[a.attr]
        local compA = TableEx.findValueFunction(cfg.scorecount.equip, function(value)
			return value.mapping == a.attr
		end)
        compA = compA and compA.idx or 100

        -- local compB = cfg.scorecount.mapping[b.attr]
        local compB = TableEx.findValueFunction(cfg.scorecount.equip, function(value)
			return value.mapping == b.attr
		end)
        compB = compB and compB.idx or 100

        return compA < compB
    end
    table.sort(ability, sortAbility)
    table.sort(special_ability, sortAbility)
    table.sort(suit_ability, sortAbility)
    local title_size = 20
    local title_margin = 15
    local lbl_size = 18
    local lbl_margin = 15
    self.scroll_view:getContainer():removeAllChildren()

    if table.nums(ability) > 0 then 
        self.height = self.height + title_size + title_margin
        local len = table.nums(ability)
        self.height = self.height + len * (lbl_size + lbl_margin)
    end

    if table.nums(special_ability) > 0 then 
        self.height = self.height + title_size + title_margin
        local len = table.nums(special_ability)
        self.height = self.height + len * (lbl_size + lbl_margin)
    end

    if table.nums(suit_ability) > 0 then 
        self.height = self.height + title_size + title_margin
        local len = table.nums(suit_ability)
        self.height = self.height + len * (lbl_size + lbl_margin)
    end
    self.height = self.height + 40
    self:updataSkillAttr()
    self.y = self.height - 10

    -- local lbl_special_ability_text = cc.Label:createWithTTF(ex.Tools:getLang(75008), FONT_DEFAULT_NAME_BOLD, 20)
    if table.nums(special_ability) > 0 then 
        local lbl_special_ability_text = cc.Label:createWithTTF(ex.Tools:getLang(75008), FONT_DEFAULT_NAME_BOLD, 20)
        :setAnchorPoint(cc.p(0, 0.5))
        :setTextColor(cc.c3b(223, 96, 33))
        lbl_special_ability_text:setPosition(0, self.y - 20)
        self.scroll_view:getContainer():addChild(lbl_special_ability_text)
        self.y = self.y - 20
        
    
        for i,v in ipairs(special_ability) do
            local spr_icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack-info/spr-attr-%d.png", cfg.attrshow.attrshow[v.attr].icon))
            if spr_icon == nil then 
                dump(v)
            end
            spr_icon:setScale(0.6)
            :setAnchorPoint(cc.p(0, 0.5))
            spr_icon:setPosition(0, self.y - (lbl_margin + lbl_size))
            self.scroll_view:getContainer():addChild(spr_icon)
            
            local str = ex.Tools:getLang(2150000 + v.attr)..":"
            local lbl_ability = cc.Label:createWithTTF(str, FONT_DEFAULT_NAME_BOLD, 18)
            :setTextColor(cc.c3b(116,77,39))
            :setAnchorPoint(cc.p(0, 0.5))
            :setPosition(0 + 35, self.y - (lbl_margin + lbl_size))
            self.scroll_view:getContainer():addChild(lbl_ability)
    
            local lbl_ability_num = cc.Label:createWithTTF(ex.StringUtil.formatAttrStr(" "..ex.Tools:getLang(2160000 + v.attr), "##" , v.value), FONT_DEFAULT_NAME_BOLD, 20)
            :setTextColor(cc.c3b(116,77,39))
            :setAnchorPoint(cc.p(0, 0.5))
            :setPosition(lbl_ability:getPositionX() + lbl_ability:getContentSize().width + 10, lbl_ability:getPositionY())
            self.scroll_view:getContainer():addChild(lbl_ability_num)
    
            self.y = self.y - (lbl_margin + lbl_size)
        end
    end
    self.y = self.y - 20
    if table.nums(ability) > 0 then 
        local lbl_special_ability_text = cc.Label:createWithTTF(ex.Tools:getLang(75009), FONT_DEFAULT_NAME_BOLD, 20)
        :setAnchorPoint(cc.p(0, 0.5))
        :setTextColor(cc.c3b(223, 96, 33))
        lbl_special_ability_text:setPosition(0, self.y - 20)
        self.scroll_view:getContainer():addChild(lbl_special_ability_text)
        self.y = self.y - 20
        
    
        for i,v in ipairs(ability) do
            local spr_icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack-info/spr-attr-%d.png", cfg.attrshow.attrshow[v.attr].icon))
            spr_icon:setScale(0.6)
            :setAnchorPoint(cc.p(0, 0.5))
            spr_icon:setPosition(0, self.y - (lbl_margin + lbl_size))
            self.scroll_view:getContainer():addChild(spr_icon)
            
            local str = ex.Tools:getLang(2150000 + v.attr)..":"
            local lbl_ability = cc.Label:createWithTTF(str, FONT_DEFAULT_NAME_BOLD, 18)
            :setTextColor(cc.c3b(116,77,39))
            :setAnchorPoint(cc.p(0, 0.5))
            :setPosition(0 + 35, self.y - (lbl_margin + lbl_size))
            self.scroll_view:getContainer():addChild(lbl_ability)
    
            local lbl_ability_num = cc.Label:createWithTTF(ex.StringUtil.formatAttrStr(" "..ex.Tools:getLang(2160000 + v.attr), "##" , v.value), FONT_DEFAULT_NAME_BOLD, 20)
            :setTextColor(cc.c3b(116,77,39))
            :setAnchorPoint(cc.p(0, 0.5))
            :setPosition(lbl_ability:getPositionX() + lbl_ability:getContentSize().width + 10, lbl_ability:getPositionY())
            self.scroll_view:getContainer():addChild(lbl_ability_num)
    
            self.y = self.y - (lbl_margin + lbl_size)
        end
    end
    self.y = self.y - 20
    if table.nums(suit_ability) > 0 then 
        local lbl_special_ability_text = cc.Label:createWithTTF(ex.Tools:getLang(75011), FONT_DEFAULT_NAME_BOLD, 20)
        :setAnchorPoint(cc.p(0, 0.5))
        :setTextColor(cc.c3b(223, 96, 33))
        lbl_special_ability_text:setPosition(0, self.y - 20)
        self.scroll_view:getContainer():addChild(lbl_special_ability_text)
        self.y = self.y - 20
        
    
        for i,v in ipairs(suit_ability) do
            local spr_icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack-info/spr-attr-%d.png", cfg.attrshow.attrshow[v.attr].icon))
            spr_icon:setScale(0.6)
            :setAnchorPoint(cc.p(0, 0.5))
            spr_icon:setPosition(0, self.y - (lbl_margin + lbl_size))
            self.scroll_view:getContainer():addChild(spr_icon)
            
            local str = ex.Tools:getLang(2150000 + v.attr)..":"
            local lbl_ability = cc.Label:createWithTTF(str, FONT_DEFAULT_NAME_BOLD, 18)
            :setTextColor(cc.c3b(116,77,39))
            :setAnchorPoint(cc.p(0, 0.5))
            :setPosition(0 + 35, self.y - (lbl_margin + lbl_size))
            self.scroll_view:getContainer():addChild(lbl_ability)
    
            local lbl_ability_num = cc.Label:createWithTTF(ex.StringUtil.formatAttrStr(" "..ex.Tools:getLang(2160000 + v.attr), "##" , v.value), FONT_DEFAULT_NAME_BOLD, 20)
            :setTextColor(cc.c3b(116,77,39))
            :setAnchorPoint(cc.p(0, 0.5))
            :setPosition(lbl_ability:getPositionX() + lbl_ability:getContentSize().width + 10, lbl_ability:getPositionY())
            self.scroll_view:getContainer():addChild(lbl_ability_num)
    
            self.y = self.y - (lbl_margin + lbl_size)
        end
    end
    self.y = self.y - 20
    -- local rich_size = self.rich_text:getContentSize()
    local view_size = self.scroll_view:getContainer():getContentSize()

    self.scroll_view:setContentSize(view_size.width,self.height)
    self.scroll_view:setContentOffset(cc.p(0, self.scroll_view:getViewSize().height - self.scroll_view:getContentSize().height))
    self.can_click = true
end

function SmithArtifactLayer:updataSkillAttr()
    -- local str = ex.Tools:getLang(2150000 + self.cur_compose_info.special_ability[1].attr)..":"
    -- self.lbl_attr_name:setString(str)
    -- self.lbl_attr_value:setString(self.cur_compose_info.special_ability[1].value)
    -- local x = self.lbl_attr_name:getPositionX() + self.lbl_attr_name:getContentSize().width + 10
    -- self.lbl_attr_value:setPositionX(x)

    local suit_cfg = cfg.reikiequipsuit.reikiequipsuit[self.cur_compose_info.suit_id]
    -- local suit_cfg = cfg.reikiequipsuit.reikiequipsuit[3]
    -- self.lbl_skill_name:setVisible(suit_cfg.skill ~= 0)
    -- self.lbl_skill_desc:setVisible(suit_cfg.skill ~= 0)
    -- self.lbl_skill_name:setString(ex.Player.hero_data:getSkillName(suit_cfg.skill, suit_cfg.skill_level))
    -- self.lbl_skill_desc:setString(ex.Player.hero_data:getSkillDescription(suit_cfg.skill, suit_cfg.skill_level))
    -- if suit_cfg.skill ~= 0 then 
    --     self.skill_menu:removeAllChildren()
    --     local item = UIMenuItemSkill:createWithIcon(suit_cfg.skill, suit_cfg.skill_level)
    --     self.skill_menu:addChild(item)
    --     item.lbl_name:setVisible(false)
    --     item:removeLevel()
    -- end

    if suit_cfg.skill ~= 0 then 
        local tips_panel = require("src.layer.artifacts.ArtifactSkillPanel"):createWithCCBIFile("ccbi/ArtifactSkillPanel.ccbi")
        tips_panel:reset(suit_cfg)
        self.scroll_view:getContainer():addChild(tips_panel)
        tips_panel:setPosition(0,0)
        self.height = self.height + tips_panel:getContentSize().height
    end
end

-----------

function SmithArtifactLayer:onCompose(tag ,pSender)

    local enable = false
    local has_num = ex.Player:getItemNum(self.need_data[2].item_type)
    
    enable = has_num >= self.need_data[2].item_num and (table.nums(self.hero_list) + table.nums(self.replace_list)) >= self.need_data[3].num
    local has_item = has_num >= self.need_data[2].item_num 
    local has_hero = (table.nums(self.hero_list) + table.nums(self.replace_list)) >= self.need_data[3].num

    if not has_item then 
        ex.MessageView:add(string.format(ex.Tools:getLang(1108),ex.Tools:getLang(cfg.item.item[self.need_data[2].item_type].name)))
    end

    if not has_hero then 
        ex.MessageView:add(string.format(ex.Tools:getLang(75020),self.need_data[3].star))
    end

    if has_item and has_hero then 

        local req = ReikiEquip_pb.GReqCombineReikiEquip()
        req.sys_id = self.cur_compose_info.idx 
        req.reiki_id = self.need_data[1].reiki_equip_id


        for i,v in ipairs(self.hero_list) do
            table.insert(req.heroes,v)
        end

        for i,v in ipairs(self.replace_list) do
            table.insert(req.replace_item,v)
        end
        -- -- req.reiki_equip_ids = 
        -- -- req.heroes = 
        -- -- req.replace_item = 
        NetManager:sendMessage(ProtocolID.GReqCombineReikiEquip,req)
        SmithArtifactCtr:instance():closeWindow()
    end
end

-----------------------------------------------------------------------------
function SmithArtifactCtr:onCreate()
	self:setCCBIPath("ccbi/SmithArtifactLayer.ccbi")
	self:setIsSingle(false)
end

function SmithArtifactCtr:getLayerClass()
	return SmithArtifactLayer
end

function SmithArtifactCtr:getArtifactActiveLayer()
	return self.layer
end

function SmithArtifactCtr:openWindow(data)
	if self:isOpened() then
		return
	end
	
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/backpack-info.plist")
    
	self:loadLayer()
	self:open()
	self:initData(data)

end

function SmithArtifactCtr:initData(data)
    local layer = self.layer
    layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

	self:updateLayer(data)

end

function SmithArtifactCtr:updateLayer(data)
	if not self:getLayer() then
		return
	end
	local layer = self.layer
	-- layer.data = data
	layer:setData(data)

end

return SmithArtifactCtr
