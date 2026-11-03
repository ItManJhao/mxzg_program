local CrusadeGroupHeroItem = class("CrusadeGroupHeroItem", require("src.comp.EventLayer"))

function CrusadeGroupHeroItem:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end

function CrusadeGroupHeroItem:reloadData(data, type)
    self.data = data
    local hero_data
    if type == CRUSADE_GROUP_HERO_ITEM_TYPE.SET_OFF then
        hero_data = data.hero

        if (not hero_data or hero_data.hero_id == 0) and not data.box_id then
            self.spr_lock:setVisible(true)
        elseif not hero_data or hero_data.hero_id == 0 then
            self.spr_add:setVisible(true)
        else
            self.spr_local:setVisible(hero_data.development_status)
        end
        
    elseif type == CRUSADE_GROUP_HERO_ITEM_TYPE.SET_OFF_SELECT then
        hero_data = data
    elseif type == CRUSADE_GROUP_HERO_ITEM_TYPE.UNLOAD then
        hero_data = data.hero
    elseif type == CRUSADE_GROUP_HERO_ITEM_TYPE.BATTLE then
        hero_data = data.hero
        self.spr_death:setVisible(data.is_death)
    end

    if hero_data and hero_data.hero_id > 0 then
        self:setIcon(hero_data)
        self:setStar(hero_data)
        self:setLevel(hero_data)
        self:setOccupation(hero_data)
    end
end


function CrusadeGroupHeroItem:setIcon(data)
    -- 处理皮肤
	local icon = nil
	icon = ex.Player.hero_data.fashion:getWearByID(data.hero_id)

    -- 处理进化
	-- if not icon and hero_data and hero_data.evolve and hero_data.evolve.type > 0 then
	-- 	local config = cfg.heroevolvelevel.getEvolutionConfig(hero_type, hero_data.evolve.level, hero_data.evolve.type)
	-- 	if config and type(config.evolve_icon_id) == "number" then
	-- 		icon = config.evolve_icon_id
	-- 	end
	-- end

	if icon == nil or icon == 0 then
		icon = ex.Tools:getHeroIconByStar(data.hero_type , data.star) + 10000000
	end

    self.hero_icon:setSpriteFrame(string.format("hero-icon/%d.png", icon))
    self.hero_icon:setVisible(true)
end

function CrusadeGroupHeroItem:setStar(data)
    local star = data.star or 0

    self.node_star:removeAllChildren()

    if star < 10 then
        local star_type = math.floor(star / 5)
        local star_count = 1

        if star % 5 == 0 then
            if star <= 5 then
                star_count = 5
                star_type = 0
            end
        else
            star_count = star % 5
        end
        if star > 10 then
            star_count = star_count + 1
        end

        local diff = 9.0
        local icon_size = self:getContentSize()
        local start_pos = cc.p(icon_size.width * 0.5 - (star_count - 1) * diff * 0.5, 15)

        for i = 1, star_count do
            local spr_star = nil
            spr_star = cc.Sprite:createWithSpriteFrameName(string.format("other/star-%d.png", star_type))
            spr_star:setScale(0.5)
            spr_star:setPosition(cc.p(start_pos.x + (i - 1) * diff, start_pos.y))
            self.node_star:addChild(spr_star)
        end
    else
        local spr_star_bg = cc.Sprite:createWithSpriteFrameName("backpack/spr-star-bg-2.png"):setPosition(cc.p(self:getContentSize().width / 2, 12))
        self.node_star:addChild(spr_star_bg, 5)

        -- 英雄觉醒 add 熊梦 图标修改 如果加到15星需要再次修改
        if star == ex.Player.awaken_star then
            spr_star_bg:setSpriteFrame("backpack/spr-star-bg-4.png")
        elseif star > 10 then
            local spr_star = cc.Sprite:createWithSpriteFrameName("backpack/lbl-star-" .. (star - 10) .. ".png"):setPosition(spr_star_bg:getPosition())
            self.node_star:addChild(spr_star, 10)
        end

        -- 播放高星特效
        local spr_effect_star = ex.EffectFactory:createEffectWithNodeByName("eff_hero_star")
        spr_effect_star:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
        self.node_star:addChild(spr_effect_star, 100)
    end
end

function CrusadeGroupHeroItem:setOccupation(data)
    local config = cfg.herotype.star[data.hero_type]
   
	if not config then
        self.hero_occup_border:setVisible(false)
        self.spr_occupation:setVisible(false)
        return
    end

    self.hero_occup_border:setVisible(true)
    -- self.spr_occupation:setSpriteFrame(string.format("hero-info/icon-occup-%d.png", config.occupation))
    ex.Tools:setSpriteFrame(self.spr_occupation, string.format("hero-info/icon-occup-%d.png", config.occupation))
end

function CrusadeGroupHeroItem:setLevel(data)
    local level = data.level or 0
    self.lbl_num:setString(level)
    self.lbl_num:setVisible(true)
end

function CrusadeGroupHeroItem:getHeroId()
    return self.hero_id
end

function CrusadeGroupHeroItem:setHeroId(hero_id)
    self.hero_id = hero_id
end

return CrusadeGroupHeroItem