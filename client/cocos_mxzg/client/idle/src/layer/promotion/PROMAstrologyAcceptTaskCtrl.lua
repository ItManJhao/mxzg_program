local PROMAstrologyAcceptTaskCtrl = class("PROMAstrologyAcceptTaskCtrl", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PROMAstrologyAcceptTaskLayer = class("PROMAstrologyAcceptTaskLayer", require("src.comp.LuaLayerBase"))

function PROMAstrologyAcceptTaskLayer:onCreate()
	self:setScale(ex.p.width / 640);
    self:addBlackBackground()
	self.Controller = PROMAstrologyAcceptTaskCtrl:instance()
    self.btn_close:registerScriptTapHandler(handler(self.Controller, self.Controller.closeWindow))
    self.btn_submit:registerScriptTapHandler(handler(self, self.onSubmit))
end

function PROMAstrologyAcceptTaskLayer:setRewardPanel(reward)
    if type(reward) ~= "table" then
        return
    end

    local num = table.nums(reward)

    self.bg_reward:removeAllChildren()

    local menu = cpp.UIMenu:create()
    :setSwallowsTouches(false)
    self.bg_reward:addChild(menu)
    menu:setPosition(cc.p(0, 0))

    local bg_size = self.bg_reward:getPreferredSize()
    for i, v in ipairs(reward) do
        local item = ex.Player.backpack_data:createWithData(v.item_type, v.item_num)
        item:setPosition(bg_size.width * (i / (num + 1)), bg_size.height / 2)
        item:setScale(0.9)
        item:registerScriptTapHandler(handler(self, self.onRewardInfo))
        menu:addChild(item)
    end
end

function PROMAstrologyAcceptTaskLayer:onRewardInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function PROMAstrologyAcceptTaskLayer:setNeedMaterials(need_hero, need_item)
    local item_space = 12
    local item_scale = 1
    local item_size = cc.Sprite:createWithSpriteFrameName("other/rare-0.png"):getContentSize()

    local total_num = (need_hero ~= "" and type(need_hero) == "table") and table.nums(need_hero) or 0
    total_num = total_num + ((need_item ~= "" and type(need_item) == "table") and table.nums(need_item) or 0)

    local total_width = item_size.width * total_num + item_space * (total_num - 1)
    local scroll_view_size = self.scroll_view:getViewSize()
    local order_layout = scroll_view_size.width < total_width   -- 数量多就用顺序布局
    self.scroll_view:setContentSize(cc.size(math.max( total_width, scroll_view_size.width), scroll_view_size.height))
    self.scroll_view:getContainer():removeAllChildren()

    local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")
    
    local menu = cpp.UIMenu:create()
    menu:setName("menu_reward")
    :setSwallowsTouches(false)
    self.scroll_view:getContainer():addChild(menu)
    menu:setPosition(cc.p(0, 0))
    
    if need_hero ~= "" and type(need_hero) == "table" then
        for i,v in ipairs(need_hero) do
            local type = v.type
            local elem = v.elem
            local str = string.format("%s/%s",0,v.num)
            
            local data = {}
            data.num = str
            data.type = type 
            data.elem = elem
            data.star = v.star
            data.occupation = v.occupation
            data.number = v.num
            
            local node = UIMenuItemHero:createWithData(nil , data.type, data.elem, data.num, data.star, nil)
            node:setName("hero")
            node:setScale(item_scale)
            node:setTag(i)
            menu:addChild(node)
            node.data = data
            node:setPosition(order_layout and (node:getContentSize().width * item_scale + item_space) * (i - 1) or (i / (total_num + 1) * scroll_view_size.width), scroll_view_size.height / 2)
            node:registerScriptTapHandler(handler(self, self.onMaterialClick))
            
            node:setRedPoint(false)
            if type == 0 then
                node:removeElem()
                node:setElem(data.elem)
                node:removeElem()
                node:setAllIcon()
            end
        end
    end

    if need_item ~= "" and type(need_item) == "table" then
        local tmp_i = need_hero ~= "" and table.nums(need_hero) or 0
        for i, v in ipairs(need_item) do
            local item = ex.Player.backpack_data:createWithData(v.item_type, v.item_num)
            item:setName("item")
            item:setTag(tmp_i + i)
            item:setPosition(order_layout and (node:getContentSize().width * item_scale + item_space) *(tmp_i + i - 1) or ((tmp_i + i) / (total_num + 1) * scroll_view_size.width), scroll_view_size.height / 2)
            item:setScale(item_scale)
            if ex.Player:getItemNum(v.item_type) < v.item_num then
                item:setGrayed()
            end
            item:registerScriptTapHandler(handler(self, self.onMaterialClick))
            menu:addChild(item)
        end
    end

    self:refreshMaterialsCompleted()
end

function PROMAstrologyAcceptTaskLayer:refreshMaterialsCompleted()
    local menu = self.scroll_view:getContainer():getChildByName("menu_reward")

    local num = menu:getChildrenCount()
    for i = 1, num do
        local item = menu:getChildByTag(i)
        
        if item:getName() == "hero" then
            local heros = self.Controller:getSelectedMaterials(i)
            local count = heros == nil and 0 or table.nums(heros)
            item:setGray(not (count < item.data.number))
            -- item:setCompleted(table.nums(heros), item.data.number)
            item:setLevel(string.format("%s/%s", count, item.data.number))
        end
    end
end

function PROMAstrologyAcceptTaskLayer:onMaterialClick(tag, pSender)
    if pSender:getName() == "item" then
        ex.Tools:onClickItemInfo(pSender.item_type)
    else
        local data = {}
        data.idx = pSender:getTag()
        data.num = pSender.data.number 
        data.type = pSender.data.type 
        data.elem = pSender.data.elem
        data.star = pSender.data.star
        data.occupation = pSender.data.occupation
        data.selected_hero_ids = self.Controller:getSelectedMaterials(data.idx)
        data.close_handle = handler(self.Controller, self.Controller.setMeterials)

        require("src.layer.HeroXSelectCtrl"):instance():openWindow(data)
    end
end

-- 提交任务
function PROMAstrologyAcceptTaskLayer:onSubmit(tag, pSender)
    if not self.Controller:isEnabledConvert() then
        ex.MessageView:add(ex.Tools:getLang(41092))
        return 
    end

    self.Controller:Submit()
end

-----------------------------------------------------------------------------
function PROMAstrologyAcceptTaskCtrl:onCreate()
	self:setCCBIPath("ccbi/PROMAstrologyAcceptTaskLayer.ccbi")
    self:setIsSingle(false)
    
    self.promotion_id = 38
    self.config = {}

    self.materials_data = {}
end

function PROMAstrologyAcceptTaskCtrl:getLayerClass()
	return PROMAstrologyAcceptTaskLayer
end

function PROMAstrologyAcceptTaskCtrl:getConfirmLayer()
	return self.layer
end

function PROMAstrologyAcceptTaskCtrl:openWindow(idx)
	if self:isOpened() then
		return
    end
    
	self:loadLayer()
	self:open()
	self:initData(idx)
end

function PROMAstrologyAcceptTaskCtrl:initData(idx)
    self.materials_data = {}
	self.config = cfg.promotionastrology.promotionastrology[idx]

    self.layer:setRewardPanel(self.config.reward)
    self.layer:setNeedMaterials(self.config.need_hero, self.config.need_item)
end

function PROMAstrologyAcceptTaskCtrl:getSelectedMaterials(idx)
    return self.materials_data[idx]
end

function PROMAstrologyAcceptTaskCtrl:setMeterials(idx, data)
    -- dump(data, "PROMAstrologyAcceptTaskCtrl:setMeterials")
    self.materials_data[idx] = data

    self.layer:refreshMaterialsCompleted()
end

-- 是否转换可用
function PROMAstrologyAcceptTaskCtrl:isEnabledConvert()
    if self.config.need_hero ~= "" then
        for i, v in ipairs(self.config.need_hero) do
            local heros = self:getSelectedMaterials(i)
            if heros == nil or v.num > table.nums(heros) then
                return false
            else
                for j = 1, table.nums(heros) do
                    local hero_id = heros[j]
                    local hero = ex.Player.hero_data:getHeroDataById(hero_id)
                    if hero == nil then
                        return false
                    end
    
                    if (v.star ~= 0 and v.star ~= hero.star) or 
                        (v.type ~= 0 and v.type ~= hero.hero_type) or 
                        (v.occupation ~= 0 and v.occupation ~= hero.occupation) or 
                        (v.elem ~= 0 and v.elem ~= hero.elem) then
                            return false
                    end
                end
            end
        end
    end

    if self.config.need_item ~= "" then
        for i, v in ipairs(self.config.need_item) do
            if ex.Player:getItemNum(v.item_type) < v.item_num then
                return false
            end
        end
    end

    return true
end

function PROMAstrologyAcceptTaskCtrl:Submit()
    if not ex.Player.promotion_data:getTimeIsOpen(self.promotion_id) then
        ex.MessageView:add(ex.Tools:getLang(47324))
        return
    end
    
    local req = Promotion038_pb.GReqAstrologyTaskSubmit()
    req.idx = self.config.idx

    for i = 1, table.nums(self.materials_data) do
        for j = 1, table.nums(self.materials_data[i]) do
            local hero = Object_pb.PSBackpackData()
            hero.id = self.materials_data[i][j]
            hero.type = i
            hero.num = 1

            table.insert(req.heros, hero)
        end
    end

    NetManager:sendMessage(ProtocolID.GReqAstrologyTaskSubmit, req)
end

function PROMAstrologyAcceptTaskCtrl:handleSubmit(idx, is_over)
    if not is_over then
        ex.MessageView:add(ex.Tools:getLang(41092))
        return 
    end

    -- 刷新英雄列表以及背包列表(英雄身上的装备需要脱下)
    ex.Player.hero_data:refreshHeroList()
    ex.Player.backpack_data:refreshBackpack()

    -- if self.config ~= nil and self.config.need_item ~= "" then
    --     for k, v in pairs(self.config.need_item) do
    --         ex.Player:addRes(v.item_type, 0 - v.item_num)
    --     end
    -- end
    
    self:closeWindow()
end

return PROMAstrologyAcceptTaskCtrl
