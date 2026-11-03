local HeroInfoUpStoneLayer = class("HeroInfoUpStoneLayer", require("src.comp.EventLayer"))
local HeroInfoUpStoneCell = class("HeroInfoUpStoneCell", require("src.comp.EventLayer"))
function HeroInfoUpStoneCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.text_refresh = require("src.comp.RichTextEx"):create()
    :setFontSize(20)
    :setFontFace(FONT_DEFAULT_NAME_BOLD)
    :setAnchorTextShadow(true)
    :setWrapMode(1)
    :setAnchorPoint(0, 0.5)
    self.show_rich:addChild(self.text_refresh)
    self.text_refresh:setPosition(0,0)

    self.rich_height = 0
end 


function HeroInfoUpStoneCell:initDone(stone_id, status, item_type, need_star)

    local str = ""
    
    if item_type and item_type > 0 then 
        local jeweltype_config = cfg.jeweltype.jeweltype[item_type]
        
        local item_config = cfg.item.item[item_type]

        str = string.format( "<font color='#DF6021'>%s</font>", ex.Tools:getLang(item_config.name)) 

        -- local attstr = ex.Tools:getLang(2140000 + show_data.attr[1].attr)
        -- attstr = ex.StringUtil.formatAttrStr(attstr, "##" , show_data.attr[1].value)
        for i,v in ipairs(jeweltype_config.ability) do

            local attstr = ex.Tools:getLang(2141000 + v.attr)
            attstr = ex.StringUtil.formatAttrStrNum(attstr, "##" , v.value, "<font color='#219A00' size='18'>%s</font>")
            
            str = str ..  string.format( "<br><font color='#7A472D' size='18'>%s</font></br>" , attstr)
        
            --str = str ..  string.format( "<br><font color='#7A472D' size='18'>%s+</font><font color='#219A00' size='18'>%s</font></br>" , ex.Tools:getLang(122000 + v.attr), attstr)
        end

        self.show_item_image:setSpriteFrame(item_config.icon ..".png")

        self.show_item_image:setScale(0.4)
    else

        str =  string.format( "<font color='#7A472D'>%s</font>", string.format(ex.Tools:getLang(54403),ex.Tools:getLang(54410 + stone_id))) 
        if status == 0 then 
            str = str .. string.format( "<font color='#E82D2D' size='18'>%s</font>", string.format( ex.Tools:getLang(54404), need_star))
        
            -- self.show_item_image:setSpriteFrame("runes/lock.png")
            ex.Tools:setSpriteFrame(self.show_item_image, "runes/lock.png")
            self.show_item_image:setScale(0.5)
        end 
        str = str .. string.format( "<br><font color='#A48767' size='18'>%s</font></br>" , ex.Tools:getLang(54420 + stone_id))
    end 

    self.text_refresh:setXmlTextLua(str)
    self.text_refresh:formatText()

    self.rich_height = self.text_refresh:getContentSize().height


    self.text_refresh:setContentSize(cc.size(225, self.text_refresh:getContentSize().height))

    self.text_refresh:setPosition(0,  self.text_refresh:getContentSize().height * 0.5 - 20)
-- self.text_refresh:getContentSize().height / 10 * 0.5

end 


-------------------------------------------------------------------------------------------------------------------


function HeroInfoUpStoneLayer:onCreate()
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/skill-icon.plist")
    sfc:addSpriteFrames("ccbi-res/runes.plist")
    


    self.btn_text = cc.Label:createWithTTF(ex.Tools:getLang(54408), FONT_DEFAULT_NAME_BOLD, 24)
    self.btn_enter:addChild(self.btn_text)
    self.btn_text:setPosition(self.btn_enter:getContentSize().width / 2,self.btn_enter:getContentSize().height / 2)
    self.btn_text:setTextColor(cc.c4b(255, 255, 255, 255))
    self.btn_text:enableOutline(cc.c4b(13, 91, 45,255), 2)

    self.btn_enter:registerScriptTapHandler(handler(self, self.fitstEnter))
    -- 获取按钮
    self.btn_add_list = {}
    self.spr_star_node_list = {}
    self.image_yuan_list = {}
    self.item_image_list = {}
    self.waiyuan_list = {}
    self.play_effect_list = {}
    for i=1,3 do
        table.insert( self.btn_add_list, self["btn_add_"..i])
        table.insert( self.spr_star_node_list, self["spr_star_node_"..i] ) 
        table.insert( self.image_yuan_list, self["image-yuan-"..i] ) 
        table.insert( self.item_image_list, self["item_image_"..i] ) 

        table.insert( self.waiyuan_list, self["waiyuan"..i] ) 
        table.insert( self.play_effect_list, self["play_effect_"..i] ) 
        self["btn_add_"..i]:registerScriptTapHandler(handler(self, self["doneBtn"..i]))

    end

--    ex.Tools:setGrayAuto(self.wai_yuan, true)
    ex.Tools:setGrayAuto(self.ori_image, true)
    

    local viewSize = cc.size(self.attr_list:getContentSize().width, self.attr_list:getContentSize().height - 50 )

    self.scroll_view = cc.ScrollView:create(viewSize)
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    :setPosition(self.attr_list:getPositionX() + 2, self.attr_list:getPositionY() + 10)
    self.node_all:addChild(self.scroll_view)



    self.my_stone_taos_refresh = require("src.comp.RichTextEx"):create()
    :setFontSize(20)
    :setFontFace(FONT_DEFAULT_NAME_BOLD)
    :setAnchorTextShadow(true)
    :setWrapMode(1)
    :setAnchorPoint(0, 1)
    self.show_rich_tao:addChild(self.my_stone_taos_refresh)
    self.my_stone_taos_refresh:setPosition(0,0)


end 


function HeroInfoUpStoneLayer:onBtnInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42058), ex.Tools:getLang(42059))
end


function HeroInfoUpStoneLayer:onBtnGo(tag, pSender)

    local return_data = cfg.system["jewel_get_jump"]

    if not ex.JumpManager:jumpByAtom(return_data.event_arg) then
        ex.MessageView:add(ex.Tools:getLang(return_data.no_jump_hint))
    end

end

function HeroInfoUpStoneLayer:fitstEnter( tag, pSender )

    local update_stone_type_list = ex.Player.hero_data:checkHeroJewelRed(self.hero_id, self.hero_star)
    if #update_stone_type_list > 0 then 

        local item_type_list = {}
        local req = HeroJewel_pb.GReqHeroJewelOneKeyWear()
        req.hero_id = self.hero_id
        for i,v in ipairs(update_stone_type_list) do
            table.insert( req.sys_id, v.item_type )
        end
        NetManager:sendMessage(ProtocolID.GReqHeroJewelOneKeyWear, req)

    else 

        local now_hero_stone_data = ex.Player.hero_data:getHeroJewelListForHeroid(self.hero_id)
        if not now_hero_stone_data.jewel_list or #now_hero_stone_data.jewel_list == 0 then 
            ex.MessageView:add(ex.Tools:getLang(47683) )
            return
        end 


        local req = HeroJewel_pb.GReqHeroJewelOneKeyDisboard()
        req.hero_id = self.hero_id
        NetManager:sendMessage(ProtocolID.GReqHeroJewelOneKeyDisboard, req)

    end 

end 

function HeroInfoUpStoneLayer:checkHeroPlaceStone( ponision )
    local now_hero_stone_data = ex.Player.hero_data:getHeroJewelListForHeroid(self.hero_id)
    if not now_hero_stone_data.jewel_list then now_hero_stone_data.jewel_list = {} end 
    if  now_hero_stone_data.jewel_list or #now_hero_stone_data.jewel_list > 0 then 
        for i,v in ipairs(now_hero_stone_data.jewel_list) do
                if v.place == ponision and v.jewel_type > 0   then 
                    return v.jewel_type, v.jewel_id
                end 
        end
    end 
    return 0
end



function HeroInfoUpStoneLayer:onDoneGo(tag,pSender )
    require("src.layer.BackpackSrcCtr"):instance():openWindow(pSender.data.item_type)
end

function HeroInfoUpStoneLayer:onDoneUpLevel( tag,pSender)


    ex.JumpManager:jumpByAtom("main_smith_shop_gem") 
    
end

function HeroInfoUpStoneLayer:onDoneChange( tag,pSender)
    require("src.layer.heroinfo.HeroStoneStateCtr"):instance():openWindow(pSender.data.place, pSender.data.hero_id)
end

function HeroInfoUpStoneLayer:onDoneDown(tag,pSender )

	local req = HeroJewel_pb.GReqHeroJewelDisboard()
	req.hero_id = self.hero_id
	req.jewel_id = pSender.data.item_id

	NetManager:sendMessage(ProtocolID.GReqHeroJewelDisboard, req)

end

function HeroInfoUpStoneLayer:toShowTips( place )

    local jewel_type , jewel_id= self:checkHeroPlaceStone(place)

    local send_data = {}
    send_data.hero_id = self.hero_id
    send_data.place = place
    send_data.item_type = jewel_type
    send_data.item_id = jewel_id

    local info_ctr = require("src.layer.heroinfo.StoneAbilityInfoCtr"):instance()
    info_ctr:openWindow()
    :setStoneInfo(jewel_type, self.hero_id)
    :addWearButtion(
                    {str = ex.Tools:getLang(47184), call = handler(self, self.onDoneUpLevel), data = send_data},
                    {str = ex.Tools:getLang(47243), call = handler(self, self.onDoneGo), data = send_data},
                    {str = ex.Tools:getLang(47236), call = handler(self, self.onDoneChange), data = send_data},
                    {str = ex.Tools:getLang(47622), call = handler(self, self.onDoneDown), data = send_data })
    :addBlackBackground()
end


function HeroInfoUpStoneLayer:doneBtn1( tag, pSender )

    -- TEST
    -- require("src.layer.heroinfo.HeroTalentLearnCtr"):instance():openWindow(self.hero_id, 1)


    if tonumber(self.hero_star) < tonumber( self.place_list[1] ) then 
        ex.MessageView:add( string.format( ex.Tools:getLang(54407),self.place_list[1] ))
        return 
    end 

    -- 检测是否存在宝石
    local jewel_type = self:checkHeroPlaceStone(1)
    if jewel_type > 0  then 
        self:toShowTips( 1 )
        return 
    end 

    require("src.layer.heroinfo.HeroStoneStateCtr"):instance():openWindow(1, self.hero_id)

end 

function HeroInfoUpStoneLayer:doneBtn2( tag, pSender )
    if tonumber(self.hero_star) < tonumber( self.place_list[2] ) then 
        ex.MessageView:add( string.format( ex.Tools:getLang(54407),self.place_list[2] ))
        return 
    end 
    local jewel_type = self:checkHeroPlaceStone(2)
    if jewel_type > 0  then 
        self:toShowTips( 2 )
        return 
    end 

    require("src.layer.heroinfo.HeroStoneStateCtr"):instance():openWindow(2, self.hero_id)
end 

function HeroInfoUpStoneLayer:doneBtn3( tag, pSender )

    if tonumber(self.hero_star) < tonumber( self.place_list[3] ) then 
        ex.MessageView:add( string.format(  ex.Tools:getLang(54407),self.place_list[3] ) )
        return 
    end 
    
    local jewel_type = self:checkHeroPlaceStone(3)
    if jewel_type > 0  then 
        self:toShowTips( 3 )
        return 
    end 

    require("src.layer.heroinfo.HeroStoneStateCtr"):instance():openWindow(3, self.hero_id)
end 




function HeroInfoUpStoneLayer:setHeroData( hero_id , hero_star)

    -- 根据hero_id找带对应
    self.hero_id = hero_id
    self.hero_star = hero_star
    self.hero_jewel_data = ex.Player.hero_data:getHeroJewelListForHeroid(hero_id)

    self.place_list = {}
    local vec_dec = ex.Tools:stringSplit( cfg.system.jewel_single_open_star, ";")
    for i,v in ipairs(vec_dec) do
        local position  = ex.Tools:stringSplit( v, "_")
        if position and #position > 1 then 
            self.place_list[tonumber(position[1])] =tonumber(position[2])
        end 
    end

    self:updateStoneStoneData()
    self:updateStoneScroll()
    self:updateStoneFirstenter()
    self:refreshRich( )
end 


function HeroInfoUpStoneLayer:refreshRich( )

    -- 检测我的建树
    local hero_star_num, hero_min_star = ex.Player.hero_data:checkHeroStoneTao(self.hero_id)
    
    local min_star = cfg.jewelsettype.jewelsettype[1]
    local max_star = cfg.jewelsettype.jewelsettype[#cfg.jewelsettype.jewelsettype]
    
    local show_data = {}
    local show_num = 0

    if min_star.star > hero_min_star then 
        show_data = min_star
    end 

    if max_star.star < hero_min_star then 
        show_data = max_star
    end 

    for i,v in ipairs(cfg.jewelsettype.jewelsettype) do
        if v.star == hero_min_star then 
            show_data = v
            show_num = hero_star_num
        end 
    end

   -- print("-=-=-=-----------", 2141000 , show_data.attr[1].attr)
    local attstr = ex.Tools:getLang(2141000 + show_data.attr[1].attr)
    attstr = ex.StringUtil.formatAttrStrNum(attstr, "##" , show_data.attr[1].value, "<font color='#219A00' size='18'>%s</font>")
    
    local str = string.format( "<font color='#7A472D'>%s %s</font>",  string.format(ex.Tools:getLang(54406), show_data.star, show_num),  attstr ) 


    -- local attstr = ex.Tools:getLang(2140000 + show_data.attr[1].attr)
    -- attstr = ex.StringUtil.formatAttrStr(attstr, "##" , show_data.attr[1].value)
        
    -- local str = string.format( "<font color='#7A472D'>%s </font><font color='#219A00'>%s</font>",  string.format(ex.Tools:getLang(54406), show_data.star, show_num),  attstr ) 

    self.my_stone_taos_refresh:setXmlTextLua(str)
    --self.text_refresh:formatText()

end


function HeroInfoUpStoneLayer:updateStoneFirstenter( )

    -- 判断红点
    local update_stone_type_list = ex.Player.hero_data:checkHeroJewelRed(self.hero_id, self.hero_star)

    if #update_stone_type_list > 0 then 
        self.btn_text:setString(ex.Tools:getLang(54408))
        
        --ex.Tools:addRedPoint(self.btn_enter,true, ex.r.p8)
        ex.Tools:addRedPoint(self.btn_enter,true)

    else 
        ex.Tools:addRedPoint(self.btn_enter,false)

        local now_hero_stone_data = ex.Player.hero_data:getHeroJewelListForHeroid(self.hero_id)
        if not now_hero_stone_data.jewel_list or #now_hero_stone_data.jewel_list == 0 then 
            self.btn_text:setString(ex.Tools:getLang(54408))

        else 
            self.btn_text:setString(ex.Tools:getLang(54409))
    
        end 

    end 

end
-- 

function HeroInfoUpStoneLayer:checkNowPlace(place)
    local hero_jewel_data = ex.Player.hero_data:getHeroJewelListForHeroid(self.hero_id)
    if not hero_jewel_data.jewel_list then return end 
    for i,v in ipairs(hero_jewel_data.jewel_list) do
        if v.place == place then 
            return v.jewel_type
        end 
    end
    return nil
end


function HeroInfoUpStoneLayer:updateStoneStoneData( )
    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/runes.plist")

    -- 设置所有按钮
    local update_stone_type_list = ex.Player.hero_data:checkHeroJewelRed(self.hero_id, self.hero_star)
    for i=1,3 do
        self.image_yuan_list[i]:setVisible(false)
        self.waiyuan_list[i]:setVisible(false)

        self:removeStar(self.spr_star_node_list[i])
        ex.Tools:addRedPoint(self.btn_add_list[i],false)
        if #update_stone_type_list > 0  then 
            for si,v in ipairs(update_stone_type_list) do
                if i == v.place then 
                    ex.Tools:addRedPoint(self.btn_add_list[i],true, ex.r.p8)
                end 
            end
        end

        if tonumber(self.hero_star) >= tonumber( self.place_list[i] ) then 
            local has_jewel_type = self:checkNowPlace(i)
            
            if  has_jewel_type and has_jewel_type > 0  then 
                -- xianshi shitou 
                self.image_yuan_list[i]:setVisible(true)
                self.waiyuan_list[i]:setVisible(true)

                local item_config = cfg.item.item[has_jewel_type]
                self.item_image_list[i]:setSpriteFrame(item_config.icon ..".png")

                local jeweltype_config = cfg.jeweltype.jeweltype[has_jewel_type]
                -- showstar
                self:showStar(self.spr_star_node_list[i], jeweltype_config.star)
                self:playNodeEffect(self.play_effect_list[i], i)
            else 
                -- self.item_image_list[i]:setSpriteFrame("runes/btn-add-2.png")
                ex.Tools:setSpriteFrame(self.item_image_list[i], "runes/btn-add-2.png")
            end 
        else
            -- self.item_image_list[i]:setSpriteFrame("runes/lock.png")
            ex.Tools:setSpriteFrame(self.item_image_list[i], "runes/lock.png")
        end 
    end
end


function HeroInfoUpStoneLayer:playNodeEffect(node, place)
    node:removeAllChildren()
    if place == 1 then 
        ex.EffectCtr:playNormalEff(37, 0,0, nil, node, 10)
    elseif place == 2 then 
        ex.EffectCtr:playNormalEff(37, 0,0, nil, node, 10)
    elseif place == 3 then 
        ex.EffectCtr:playNormalEff(37, 0,0, nil, node, 10)
    end 

    
end



function HeroInfoUpStoneLayer:removeStar(node)
    node:removeAllChildren()
end

function HeroInfoUpStoneLayer:showStar(node, star)
    self:removeStar(node)
    ex.Tools:generationStar(node, star, "other/star-%d.png", 0.6, -10)
end

function HeroInfoUpStoneLayer:updateStoneScroll( )
    self.scroll_view:getContainer():removeAllChildren()

    local index = 0
    self.cellList = {}

    for i=1,3 do

        -- 根据位置获取状态
        local show_statue = 0
        if tonumber(self.hero_star) >= tonumber( self.place_list[i] ) then 
            show_statue = 1
        end 
        local has_jewel_type = self:checkNowPlace(i)

        local attr_cell_node = self:addStoneCellScroll(i, show_statue, has_jewel_type, self.place_list[i])
        attr_cell_node:setName("stone_cell" .. index)
        attr_cell_node:setPosition(0,0)
        self.scroll_view:addChild(attr_cell_node)
        table.insert(self.cellList, attr_cell_node)
        index = index + 1
    end
        

    local viewSize = self.scroll_view:getViewSize()
    local item_size = HeroInfoUpStoneCell:createWithCCBIFile("ccbi/HeroInfoUpStoneAttrCell.ccbi"):getContentSize()
    item_size.height = item_size.height + 5

    local cont_height = item_size.height * table.nums(self.cellList)
    cont_height = math.max(cont_height , viewSize.height)

    self.scroll_view:setContentSize(cc.size(viewSize.width, cont_height))
    self.scroll_view:setContentOffset(cc.p(0, viewSize.height - cont_height))


    -- 按排好的顺序显示
    local start = cc.p(viewSize.width * 0.5 , cont_height - item_size.height * 0.5)

    local show_height = 0
    for i,v in ipairs(self.cellList) do

        --v:setPosition(start.x, start.y - (i - 1) * item_size.height)
        v:setPosition(start.x, start.y - show_height)
        show_height = show_height + v.rich_height + 20
    end
    

end

function HeroInfoUpStoneLayer:addStoneCellScroll( place, status, type , need_star)
    local cell = HeroInfoUpStoneCell:createWithCCBIFile("ccbi/HeroInfoUpStoneAttrCell.ccbi")
	cell:setSwallowTouches(false)
	cell:setIgnoreAnchorPointForPosition(false)
    cell:setAnchorPoint(ex.a.center)
	
    cell:initDone(place, status, type, need_star)
    return cell
    
end

return HeroInfoUpStoneLayer
