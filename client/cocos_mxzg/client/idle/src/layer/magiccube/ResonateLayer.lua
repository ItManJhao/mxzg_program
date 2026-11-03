local ResonateLayer = class("ResonateLayer", require("src.comp.EventLayer"))
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")
local ITEM_STATUS = {
    HAS_HERO =1 ,
    ADD_HERO =2 ,
    UNLOCK =3,
    LOCK = 4,
    COOL_DOWN = 5
}

function ResonateLayer:onCreate()
    self.viewSize = self.scroll_view:getViewSize()
    self.items = {}
    local win_size = cc.Director:getInstance():getWinSize()
    dump(win_size)
    local bg_size = self.spr_bg:getContentSize()
    dump(bg_size)
    self.spr_bg:setScaleX(win_size.width / bg_size.width)
    self:createCube()
    self:showSpine()
    self:updateRes()
    self:updateScrollView()
    self:updateCubeLevel()
    self:registerEvent()
    self:registerBtnEvent()
    dump(ex.Player:getHeroBattleList())
end

function ResonateLayer:showSpine()
    local max_list = ex.Player.hero_data.magicCube:getRanHeroList()
    if #max_list >= 6 then 
        for i=1,6 do
           self:createSpine(i,max_list[i])
        end
    else 
        local hide_count = 6 - #max_list 
        for i=1,hide_count do
            local node = self["hero_node_" .. i]
            node:setVisible(false)
        end

        for i=1,#max_list do
            self:createSpine(i+hide_count,max_list[i])
        end

    end 
end

function ResonateLayer:registerEvent()
    self:addEvent(EVENT.MAGIC_CUBE.ADD_HERO_BY_CUBE,handler(self,self.onStatus))
    self:addEvent(EVENT.MAGIC_CUBE.DISBOARD_HERO_BY_CUBE,handler(self,self.onStatus))
    self:addEvent(EVENT.MAGIC_CUBE.OPEN_CUBE,handler(self,self.onStatus))
    self:addEvent(EVENT.MAGIC_CUBE.CLEAR_COOL_DOWN,handler(self,self.onStatus))
end

function ResonateLayer:onStatus(event,data)
    self:updateScrollView()
    self:updateRes()
end

function ResonateLayer:registerBtnEvent()
    self.btn_src:registerScriptTapHandler(handler(self,self.itemSrc))
    self.btn_info:registerScriptTapHandler(handler(self,self.onInfo))
end

function ResonateLayer:onInfo(tag,pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(77301), ex.Tools:getLang(77321))
end

function ResonateLayer:itemSrc(tag,pSender)
    local cost_cfg = cfg.tweakcubetrenchopen.tweakcubetrenchopen[2]
    local item_type = cost_cfg.cost[1].item_type
    ex.Tools:onClickItemSrc(item_type)
end 

function ResonateLayer:createCube()
    local spine = sp.SkeletonAnimation:create("spine/mofang.json","spine/mofang.atlas", 1)
    spine:setAnimation(0, "stand", true)
    self.node_cube:addChild(spine)
end


function ResonateLayer:createSpine(idx,hero_data)
	--if self.hero ~= nil then 
		--self.hero:removeFromParent()
		--self.hero = nil
	--end
    local node = self["hero_node_" .. idx]
    local lbl = self["lbl_hero_level_" .. idx]
    local hero = node:getChildByName("hero")

    if hero ~= nil then 
        hero:removeFromParent()
        hero = nil 
    end 
    --dump(hero_data,idx)
    node:setVisible(hero_data ~= nil)
    if not hero_data then 
        return 
    end 
    local fashion_id = ex.Player.hero_data.fashion:getWearByID(hero_data.hero_id) or 0

	if fashion_id == 0 then
		local skin = ex.Tools:getHeroSkinByStar(hero_data.hero_type, hero_data.star, hero_data.evolve)
		hero = require("src.person.Hero"):create("12323", "123213", hero_data.hero_type, hero_data.level, hero_data.star, skin)

	else
		hero = require("src.person.Hero"):create("1", "1", 1, 1, 1, fashion_id)
	end
	hero:setShadowVisible(false)
    hero:setScale(1.1)
    hero:setName("hero")
    hero:setPositionY(-35)
    node:addChild(hero)
    lbl:setString(string.format(ex.Tools:getLang(47061),hero_data.level))
end

function ResonateLayer:updateRes()

    local all_cube_num = table.nums(cfg.tweakcubetrenchopen.tweakcubetrenchopen)
    local has_cube = ex.Player.hero_data.magicCube:getOpenCount()
    self.lbl_cube_num:setString(string.format("%s/%s",has_cube,all_cube_num))
    
    local cost_cfg = cfg.tweakcubetrenchopen.tweakcubetrenchopen[2]
    --dump(cost_cfg,has_cube)
    local item_type = cost_cfg.cost[1].item_type 
    local has_item = ex.Player:getItemNum(item_type)
    self.spr_icon:setSpriteFrame(string.format("backpack/%d.png",item_type))
    self.lbl_item_num:setString(has_item)
end

function ResonateLayer:updateCubeLevel()
    local level = ex.Player.hero_data.magicCube:getMagicCubeLevel()
    local min_level_str = string.format(ex.Tools:getLang(77303),level)
    self.lbl_cube_min_level:setString(min_level_str) 
end

function ResonateLayer:updateScrollView(data)
    local scroll_view = self.scroll_view
    scroll_view:getContainer():removeAllChildren()

	local menu = cpp.UIMenu:create()
    :setIsTouchInsideNode(scroll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    scroll_view:getContainer():addChild(menu)
    local height 
    local data = {}
    local scale = 0.8
    local row_num = 5
    local length = table.nums(cfg.tweakcubetrenchopen.tweakcubetrenchopen)
    for i=length,1,-1 do
        local item = UIMenuItemHero:createWithData()
        menu:addChild(item)
        local save_cell_props = item:getContentSize()
        item:setTag(i)

        if not height then height = math.ceil((length / row_num)) * (save_cell_props.height * scale+10) + (10 * scale) end
        local idx = (i - 1) % row_num
        local posX = (save_cell_props.width + 25) * scale * (idx) + 25 + save_cell_props.width / 2 * scale 
        local posY = height - (math.ceil(i / row_num)) * scale * (save_cell_props.height + 10) + save_cell_props.height / 2 * scale
        item:setPosition(posX,posY)
        item:setScale(scale)
        item:registerScriptTapHandler(handler(self,self.onItem))
        item.spr_add = cc.Sprite:createWithSpriteFrameName("other/spr-add-1.png")
        item:addChild(item.spr_add)
        item.spr_add:setVisible(false)
        item.spr_add:setPosition(cc.p(save_cell_props.width / 2,save_cell_props.height / 2))

        item.spr_lock = cc.Sprite:createWithSpriteFrameName("magic-cube/mf_suo1.png")
        item:addChild(item.spr_lock)
        item.spr_lock:setVisible(false)
        item.spr_lock:setPosition(cc.p(save_cell_props.width / 2,save_cell_props.height / 2))

        item.spr_unlock = cc.Sprite:createWithSpriteFrameName("magic-cube/mf_suo2.png")
        item:addChild(item.spr_unlock)
        item.spr_unlock:setVisible(false)
        item.spr_unlock:setPosition(cc.p(save_cell_props.width / 2,save_cell_props.height / 2))


        item.spr_timer = cc.Sprite:createWithSpriteFrameName("magic-cube/mf_sl.png")
        item:addChild(item.spr_timer)
        item.spr_timer:setVisible(false)
        item.spr_timer:setPosition(cc.p(save_cell_props.width / 2,save_cell_props.height / 2 + 8))

        item.lbl_time = cc.Label:createWithTTF("",FONT_DEFAULT_NAME_BOLD,18)
        item.lbl_time:setPosition(cc.p(save_cell_props.width / 2, save_cell_props.height / 2 - 20))
        item.lbl_time:setColor(cc.c3b(126,255,48))
        item.lbl_time:enableOutline(cc.c3b(0,0,0),2)
        item.lbl_time:setVisible(false)
        item:addChild(item.lbl_time)

        item.changeTime = function(item)
            local cube_data = ex.Player.hero_data.magicCube:getCubeDataByIdx(item:getTag())
            if not cube_data then 
                item:removeTimer()
            end 
            local cur_time = ex.Game:getServerTime()
            local cool_down_time = cfg.system.tweak_cube_trench_cd - 1
            local target_time = cube_data.last_change_time + cool_down_time
            if cur_time >= (target_time) then 
                item:removeTimer()
                ex.EventManager:fire(EVENT.MAGIC_CUBE.CLEAR_COOL_DOWN)
            else 
                local d,h,m,s = ex.Tools:formatTime(target_time - cur_time)
                local str = string.format("%02d:%02d:%02d",h,m,s)
                item.lbl_time:setString(str)
            end 
        end 
        item.onExit = function (item,eventType)
            if eventType == "exit" then 
                item:removeTimer()
            end 
        end
        item:registerScriptHandler(handler(item,item.onExit))

        item.starTimer = function(item)
            item:removeTimer()
            item:changeTime()
            item.timer_id = ex.Timer:addTimer(1000,function ()
                item.changeTime(item)
            end,true)
        end 

        item.removeTimer = function(item)
            if item.timer_id ~= nil then 
                ex.Timer:removeTimerById(item.timer_id)
            end 
            item.timer_id = nil 
        end 

        self.items[item:getTag()] = item

        cell_content = item:getContentSize()

    end


    local size = cc.size(self.viewSize.width,height)
    scroll_view:setContentSize(size)
    scroll_view:setContentOffset(cc.p(0,self.viewSize.height - (height or 0))) 
    self:updateItems()
end

function ResonateLayer:updateItems()
    local open_count = ex.Player.hero_data.magicCube:getOpenCount()    
    for i,v in ipairs(self.items) do
        local index = v:getTag()
        local cube_data = ex.Player.hero_data.magicCube:getCubeDataByIdx(index)
        if not cube_data then 
            if index == (open_count + 1) then 
                v.status = ITEM_STATUS.UNLOCK 
            else 
                v.status = ITEM_STATUS.LOCK 
            end 
        else 
            if cube_data.hero_id == 0 then 
                local cur_time = ex.Game:getServerTime() 
                local cool_down = cfg.system.tweak_cube_trench_cd - 1
                if cur_time >= (cube_data.last_change_time + cool_down) then 
                    v.status = ITEM_STATUS.ADD_HERO
                else 
                    v.status = ITEM_STATUS.COOL_DOWN
                end 
                
            else 
                v.status = ITEM_STATUS.HAS_HERO 
            end 
        end

        v.spr_add:setVisible(v.status == ITEM_STATUS.ADD_HERO)
        v.spr_unlock:setVisible(v.status == ITEM_STATUS.UNLOCK)
        v.spr_lock:setVisible(v.status == ITEM_STATUS.LOCK)
        v.spr_timer:setVisible(v.status == ITEM_STATUS.COOL_DOWN)
        v.lbl_time:setVisible(v.status == ITEM_STATUS.COOL_DOWN)

        if ITEM_STATUS.HAS_HERO == v.status then 
            local hero_data = ex.Player.hero_data:getHeroDataById(cube_data.hero_id)
            if hero_data then 
                v:reset(hero_data)
            end 

        elseif ITEM_STATUS.COOL_DOWN == v.status then 
            
            v:starTimer()

        end 
    end
end

function ResonateLayer:onItem(tag,pSender) 

    if pSender.status == ITEM_STATUS.ADD_HERO then 

        local hero_list = ex.Player.hero_data.magicCube:getSelectList()
        local callback = function (hero_id)
            local proto = TweakCube_pb.GReqTrenchAddHero()
            proto.trench_index = tag
            proto.hero_id = hero_id 
            NetManager:sendMessage(ProtocolID.GReqTrenchAddHero,proto)
        end
        require("src.layer.magiccube.MagicCubeSelectHeroCtr"):instance():openWindow(hero_list,callback)
    elseif pSender.status == ITEM_STATUS.HAS_HERO then 
        local callback = function ()
            local proto = TweakCube_pb.GReqTrenchRemoveHero()
            proto.trench_index = tag 
            NetManager:sendMessage(ProtocolID.GReqTrenchRemoveHero,proto)
        end
        require("src.layer.magiccube.MagicCubeDisboardCtr"):instance():openWindow(pSender.data,callback)

    elseif pSender.status == ITEM_STATUS.COOL_DOWN then

        local title = ex.Tools:getLang(77313)
        local cost_data = cfg.system.tweak_cube_clear_cd_cost[1]

        local item_type = cost_data.item_type
        local content = string.format(ex.Tools:getLang(77316),item_type)
        local callback_confirm = function ()
            local has_num = ex.Player:getItemNum(item_type)
            if has_num >= cost_data.item_num then 
                local proto = TweakCube_pb.GReqTrenchClearCd()
                proto.trench_index = tag
                NetManager:sendMessage(ProtocolID.GReqTrenchClearCd,proto)  
            else 
                ex.MessageView:add(ex.Tools:getLang(77323))
            end 
        end

         require("src.layer.ConfirmCtr"):instance():openWindow(title, content, callback_confirm)

     elseif pSender.status == ITEM_STATUS.UNLOCK then

         local cost_cfg = cfg.tweakcubetrenchopen.tweakcubetrenchopen[tag]
         dump(cost_cfg)
         require("src.layer.magiccube.UnlockCubeCtr"):instance():openWindow(cost_cfg)

     elseif pSender.status == ITEM_STATUS.LOCK then 

        ex.MessageView:add(ex.Tools:getLang(77305))

    end 
end

return ResonateLayer 
