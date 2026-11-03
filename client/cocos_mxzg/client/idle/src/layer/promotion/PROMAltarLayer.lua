local PROMAltarLayer = class("PROMAltarLayer", require("src.layer.promotion.PromotionBaseLayer"))
local string_format = string.format

function PROMAltarLayer:onCreateDone()
    self:setSwallowTouches(false)
    self:setAutoClose(false)
    
    self.time_info = {}
    self.promotion_id = 42

    self:addTimeProgress()
    self:initdDone() 

    self.btn_done:registerScriptTapHandler(handler(self, self.onClickSubmit))

    --  设置线的位置
    local top_y = self.layer_promotion:getTopY()
    self.ling_bg:setPosition(0, top_y)
    self.spr_bg:setPosition(0, top_y)
    self.time_node:setPositionY(top_y-29)
    self.hero_bg:setPosition(ex.p.width * 0.5, top_y - 50)


end

function PROMAltarLayer:onClickSubmit(tag,pSender)
    cfg.funcopen.main_shop.open(SHOP_TYPE.SACRIFICE)
end 

function PROMAltarLayer:updateCDTime()
    local remain_time = self.time_info.end_time - ex.Game:getServerTime()

    if ex.Game:getServerTime()  <  self.time_info.start_time then 
		self.time_text:setXmlTextLua(ex.Tools:getLang(41052));
		return 
	end 

	if remain_time < 0 then 
        self.time_text:setXmlTextLua(ex.Tools:getLang(41053));
        
        self:removeTimerByName("act_alter_timer")
		return
    end

    local show_msg = ""
        --表示倒计是结束，进入清算时间
    if remain_time > 86400 then
        show_msg = string_format(ex.Tools:getLang(41130),math.floor(remain_time / 86400))
    else
        show_msg = string_format(ex.Tools:getLang(41129), 
            math.floor(remain_time / 3600),
            math.floor(remain_time / 60 % 60),
            math.floor(remain_time % 60))
    end
    self.time_text:setXmlTextLua(show_msg)
end

function PROMAltarLayer:refreshTime()
    self.time_info = ex.Player.promotion_data:getPromotionDatas(self.promotion_id)
    if self.time_info == nil then
        self.time_info = {start_time = 0, end_time = 0, clear_time = 0}
    end
end

function PROMAltarLayer:initdDone()
    self:refreshTime()

    self.hero_menu = cpp.UIMenu:create()
    :setPosition(cc.p(0, 0))

    local shop_list = {}
    for k,v in pairs(cfg.promotionsacrificeshop.promotionsacrificeshop) do        
        for i,data in ipairs(v.item_type) do
            table.insert( shop_list, data)
        end
	end

    self:createHeroItems(shop_list)

    self:addTimer("act_alter_timer", 1000, handler(self, self.updateCDTime), true)
    self:updateCDTime()
end 



function PROMAltarLayer:onClick(tag,pSender)
	-- print(self.__cname,"onClick")
    ex.Tools:onClickItemInfo(pSender.item_type)
end


function PROMAltarLayer:createHeroItems(shop_list)

    if shop_list == nil then return end
    local hero_count = #shop_list
    local hero_image_size = cc.Sprite:createWithSpriteFrameName("promotion/spr-altar-5.png"):getContentSize()
    local heros_size = (hero_image_size.width ) * hero_count
    -- 计算开始的位置
    local win_size_width = cc.Director:getInstance():getWinSize().width
    local spos = win_size_width * 0.5 -  heros_size * 0.5
    
    for i=1,hero_count do
        
        local nowImageBg = cc.Sprite:createWithSpriteFrameName("promotion/spr-altar-5.png")
        self.hero_list:addChild(nowImageBg);
        nowImageBg:setPosition( -spos + (i - 1) * hero_image_size.width  -20 , - 30)
       
        local node = ex.Player.backpack_data:createWithData(shop_list[i].item_type, shop_list[i].item_num)
        if node then 
            --local bg_size = nowImageBg:getContentSize()
            self.hero_menu:addChild(node)
            node:setPosition(-spos + (i - 1) * hero_image_size.width  -20 , - 30 )
            node:registerScriptTapHandler(handler(self, self.onClick))
            local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_promotion_1")
            spr_effect:setPosition(node:getContentSize().width * 0.5, node:getContentSize().height * 0.5 + 2)
            node:addChild(spr_effect, 0, 10)
        end 
    end

    self.hero_list:addChild(self.hero_menu)
end 

return PROMAltarLayer;




