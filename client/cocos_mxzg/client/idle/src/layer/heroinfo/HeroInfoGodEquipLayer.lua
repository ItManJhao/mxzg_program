
local HeroInfoGodEquipLayer = class("HeroInfoGodEquipLayer", require("src.comp.EventLayer"))

local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")


function HeroInfoGodEquipLayer:onCreate( )
    
    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/god-equip.plist")

    self.item_lists = {}
    self.rare_image_list = {}
    self.equip_item_star_list = {}

    -- 创建item
    self:createBtns()
    self:createRich()
    
end

function HeroInfoGodEquipLayer:createRich( )
   
    -- 4 个超链接   
    local rich_text_1 = require("src.comp.RichTextEx"):create()
	:setFontSize(22)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
    :setWrapMode(1)
    :setAnchorPoint(cc.p(0, 0.5))

    rich_text_1:setCallback(handler(self, self.openRichTextUrl))
    rich_text_1:setXmlTextLua(ex.Tools:getLang(72502))
    rich_text_1:setName("rich_text")
    self.rich_1:addChild(rich_text_1)    
    
    local rich_text_2 = require("src.comp.RichTextEx"):create()
	:setFontSize(22)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
    :setWrapMode(1)
    :setAnchorPoint(cc.p(0, 0.5))

    rich_text_2:setCallback(handler(self, self.openRichTextUrl))
    rich_text_2:setXmlTextLua(ex.Tools:getLang(72504))
    rich_text_2:setName("rich_text")
    self.rich_2:addChild(rich_text_2)    
    
    local rich_text_3 = require("src.comp.RichTextEx"):create()
	:setFontSize(22)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
    :setWrapMode(1)
    :setAnchorPoint(cc.p(0, 0.5))

    rich_text_3:setCallback(handler(self, self.openRichTextUrl))
    rich_text_3:setXmlTextLua(ex.Tools:getLang(72505))
    rich_text_3:setName("rich_text")
    self.rich_3:addChild(rich_text_3)    
    
    local rich_text_4 = require("src.comp.RichTextEx"):create()
	:setFontSize(22)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
    :setWrapMode(1)
    :setAnchorPoint(cc.p(0, 0.5))

    rich_text_4:setCallback(handler(self, self.openRichTextUrl))
    rich_text_4:setXmlTextLua(ex.Tools:getLang(72503))
    rich_text_4:setName("rich_text")
    self.rich_4:addChild(rich_text_4)  

end

function HeroInfoGodEquipLayer:openRichTextUrl(url)
    if string.len(url) <= 0 then
        return
    end

    if url == 'main_god_equip_open_attr' then 

        -- 72509
     
        local now_equip_list = ex.Player.backpack_data:getGodEquipByHeroid(self.hero_id)
        if #now_equip_list > 0 then 
            require("src.layer.heroinfo.HeroGodEquipAttrCtr"):instance():openWindow( self.hero_id)
        else 
            
            ex.MessageView:add(ex.Tools:getLang(72509))
            return
        end 

    else 
        ex.JumpManager:jumpByAtom(url)
    end 
end


function HeroInfoGodEquipLayer:createBtns( )

    -- 创建4个item

    self.btn_enter:registerScriptTapHandler(handler(self, self.onBtnEnter))
    self.btn_promotion:registerScriptTapHandler(handler(self, self.onBtnPromotion))

    for i=1,4 do

        local cur_item = UIItemBackpack:createWithData(0, 0)
        self["equip_item_menu_".. i]:addChild(cur_item)
        
        cur_item:registerScriptTapHandler(handler(self, self['onItemInfo'..i]))

        table.insert(self.item_lists, cur_item)
        
        table.insert(self.rare_image_list, self["image_rate_image_".. i])

        table.insert(self.equip_item_star_list, self["equip_item_star_".. i])

        
    end
    
end

function HeroInfoGodEquipLayer:onDoneGo(tag,pSender )
    ex.JumpManager:jumpByAtom("main_smith_shop_god_equip")
end

function HeroInfoGodEquipLayer:onDoneUpLevel( tag,pSender)

    local equip_ment_config = cfg.godequipment.godequipment[pSender.data.item_type]
    local rare_dat = cfg.godequipmentrare.godequipmentrare[equip_ment_config.rare]

    local need_flag = false
    if rare_dat.random_ability_num == 0 then 
        
        ex.MessageView:add(ex.Tools:getLang(72514))
        return 
    end 

    require("src.layer.GodEquipRareCtr"):instance():openWindow(pSender.data.item_id)
end

function HeroInfoGodEquipLayer:onDoneChange( tag,pSender)
    require("src.layer.heroinfo.HeroGodEquipStateCtr"):instance():openWindow(pSender.data.place, self.hero_id)
end

function HeroInfoGodEquipLayer:onDoneDown(tag,pSender )
    local req = GodEquip_pb.GReqDisboardGodEquip()
	req.equip_id = pSender.data.item_id
	NetManager:sendMessage(ProtocolID.GReqDisboardGodEquip, req)
end


function HeroInfoGodEquipLayer:toShowTips( place )

    local now_equip_id = ex.Player.backpack_data:getGodEquipData(self.hero_id, place)

    if now_equip_id > 0 then 
        
        local now_equip_data = ex.Player.backpack_data:getGodEquipDataByID(now_equip_id)

        local equip_ment_config = cfg.godequipment.godequipment[now_equip_data.item_type]
        local rare_dat = cfg.godequipmentrare.godequipmentrare[equip_ment_config.rare]

        local need_flag = false
        if rare_dat.random_ability_num == 0 then 
            need_flag = true
        end 
            
        local info_ctr = require("src.layer.heroinfo.HeroGodEquipAbilityInfoCtr"):instance()
        info_ctr:openWindow()
        :setDataInfo(now_equip_data)
        :addWearButtion(
            {str = ex.Tools:getLang(47622), call = handler(self, self.onDoneDown), gray_flag = false,  data = now_equip_data }    ,            
            {str = ex.Tools:getLang(47618), call = handler(self, self.onDoneUpLevel),gray_flag = need_flag,  data = now_equip_data},    
            {str = ex.Tools:getLang(47236), call = handler(self, self.onDoneChange),  gray_flag = false,data = now_equip_data},            
            {str = ex.Tools:getLang(47438), call = handler(self, self.onDoneGo), gray_flag = false, data = now_equip_data}
            )
        :addBlackBackground()



    end 
end

function HeroInfoGodEquipLayer:onItemInfo1( tag, pSender)
    local now_equip_id = ex.Player.backpack_data:getGodEquipData(self.hero_id, 1)
    if now_equip_id > 0 then 
        self:toShowTips( 1 )
        return 
    end 
    require("src.layer.heroinfo.HeroGodEquipStateCtr"):instance():openWindow(1, self.hero_id)

end

function HeroInfoGodEquipLayer:onItemInfo2( tag, pSender)
    local now_equip_id = ex.Player.backpack_data:getGodEquipData(self.hero_id, 2)
    if now_equip_id > 0 then 
        self:toShowTips( 2 )
        return 
    end 
    require("src.layer.heroinfo.HeroGodEquipStateCtr"):instance():openWindow(2, self.hero_id)

end

function HeroInfoGodEquipLayer:onItemInfo3( tag, pSender)
    local now_equip_id = ex.Player.backpack_data:getGodEquipData(self.hero_id, 3)
    if now_equip_id > 0 then 
        self:toShowTips( 3 )
        return 
    end 
    require("src.layer.heroinfo.HeroGodEquipStateCtr"):instance():openWindow(3, self.hero_id)

end

function HeroInfoGodEquipLayer:onItemInfo4( tag, pSender)
    local now_equip_id = ex.Player.backpack_data:getGodEquipData(self.hero_id, 4)
    if now_equip_id > 0 then 
        self:toShowTips( 4 )
        return 
    end 
    require("src.layer.heroinfo.HeroGodEquipStateCtr"):instance():openWindow(4, self.hero_id)

end

function HeroInfoGodEquipLayer:updateItems( hero_id , hero_star)

    self.hero_id = hero_id
    self.hero_star = hero_star

    for i=1,4 do
        local now_equip_id = ex.Player.backpack_data:getGodEquipData(self.hero_id, i)
        if now_equip_id > 0  then 

            local now_equip_data = ex.Player.backpack_data:getGodEquipDataByID(now_equip_id)
            self.item_lists[i]:onInit(now_equip_data.item_type, 0)
            self.item_lists[i]:initDone()


            self.equip_item_star_list[i]:removeAllChildren()

            local config = cfg.godequipment.godequipment[now_equip_data.item_type]

            -- ex.Tools:generationStar(self.equip_item_star_list[i], config.star, "other/star-%d.png", 0.6, -10, cc.p(0, -self.item_lists[i]:getContentSize().height * 0.5 + 15), 1000)

            local equip_ment_config = cfg.godequipment.godequipment[now_equip_data.item_type]

            self.rare_image_list[i]:setVisible(true)

            ex.Tools:setSpriteFrame(self.rare_image_list[i], string.format("god-equip/spr-rare-%d-%d.png",config.settype ,i))

            -- 或者检测红点

            self.item_lists[i]:setRedPoint(false)
            
        else

            self.item_lists[i]:removeItemData()
            self.item_lists[i]:setRedPoint(false)
            self.rare_image_list[i]:setVisible(false)
            self.equip_item_star_list[i]:removeAllChildren()

            local list_size = ex.Player.god_equip_data:checkPlaceRed(i)
            if #list_size > 0 then 
                self.item_lists[i]:setRedPoint(true)
            end 
        end 

    end


end


function HeroInfoGodEquipLayer:onBtnPromotion(tag, pSender )       
    local info_ctr = require("src.layer.GodEquipPromotionCtr"):instance():openWindow()
end



function HeroInfoGodEquipLayer:onBtnEnter(tag, pSender )
    -- 前往神装管理
    

end


function HeroInfoGodEquipLayer:onBtnInfo(tag, pSender )
    ex.InfoCtr:openWindow(ex.Tools:getLang(42070), ex.Tools:getLang(42071))
end

return HeroInfoGodEquipLayer
