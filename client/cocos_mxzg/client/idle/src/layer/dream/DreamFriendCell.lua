local DreamFriendCell = class("DreamFriendCell", require("src.comp.LuaLayerBase"))
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

local string_format = string.format
function DreamFriendCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self.cell_props = UIMenuItemHero:createWithData()
    self.hero_menu:add(self.cell_props)
    --self.cell_props:registerScriptTapHandler(handler(self,self.onClickHero))
    self.cell_props:setAnchorPoint(0,0)
    self.cell_props:setPosition(40,25)
    self.cell_props:setScale(1)


    self.btn_enter:setLabelText(ex.Tools:getLang(47255))
    self.btn_enter:setLabelColor(FONT_BROWN)
    self.btn_enter:setLabelSize(48)
    self.btn_enter:registerScriptTapHandler(handler(self,self.onClick))

    self.lbl_select:setVisible(false)
end

function DreamFriendCell:onClick(tag,pSender)

    if self.data.type == 1  then 

        ex.Player.dream_data:gReqDreamlandSelectFriend(self.data.friend_id)
        ex.Player.dream_data:setSelectFriend(self.data)
        self.btn_enter:setVisible(false)
        self.lbl_select:setVisible(true)
    
        local nslc = require("src.layer.dream.DreamFriendCtr"):instance()
        if nslc:isOpened() then
            -- 重新刷新界面
            nslc:setSelectFriendBattle(self.data)
            nslc:reshrefRed()
        end

    else 

        -- 弹出提示不给选择
        if ex.Player.dream_data.my_hero_data.hero_id ~= 0 then 
            ex.MessageView:add(ex.Tools:getLang(72037))
            return
        end 
        
        -- self.btn_enter:setLabelText(ex.Tools:getLang(47191))
        ex.Player.dream_data:setDreamlandDispatchHero(self.data.hero_data.hero_id)
        ex.Player.dream_data:gReqDreamlandDispatchHero(self.data.hero_data.hero_id)


        self.btn_enter:setVisible(false)
        self.lbl_select:setVisible(true)

        local nslc = require("src.layer.dream.DreamFriendCtr"):instance()
        if nslc:isOpened() then
            -- 重新刷新界面
            nslc:setFriendBattle(self.data)
            
            nslc:reshrefRed()
        end
    end  



end


function DreamFriendCell:onClickHero(tag,pSender)

end

function DreamFriendCell:reset(data)

    if not data then print("not data") return end
    self.data = data
    
    self.cell_props:reset(data.hero_data)
    if data.hero_data.fashion_id ~= 0 and data.hero_data.fashion_id ~= nil then   -- 有皮肤
        self.cell_props:setFashionShowForce(data.hero_data.fashion_id)
    end

    self.lbl_hero_name:setString(ex.Tools:getLang(data.hero_data.hero_type))
    self.lbl_fight:setString(data.hero_data.fighting)
    self.lbl_friend_name:setString(data.friend_nick)

    if data.type == 1 then 

        local max_flight = ex.Player.dream_data:getMyHeroMaxFight()
        
        local battle_limit = cfg.system.infinite_help_battle_limit * 0.0001

        if battle_limit * max_flight < data.hero_data.fighting  then 
            self.show_flight:setVisible(true)
            self.btn_enter:setVisible(false)
            self.lbl_select:setVisible(false)
        else 
            self.show_flight:setVisible(false)
            self.btn_enter:setVisible(true)
            self.lbl_select:setVisible(false)
        end 

        -- self.btn_enter:setVisible(true)
        -- self.lbl_select:setVisible(false)

        self.lbl_friend_name:setString(ex.Tools:getLang(47517) .. data.friend_nick)
        if ex.Player.dream_data.select_friend_hero.friend_id ==  data.friend_id then 
            self.btn_enter:setVisible(false)
            self.btn_enter:setLabelText(ex.Tools:getLang(47191))
            self.lbl_select:setVisible(true)
            self.show_flight:setVisible(false)
        end 

    else 
        self.show_flight:setVisible(false)
        -- 判断是否已经选中
        self.btn_enter:setLabelText(ex.Tools:getLang(47255))

        self.btn_enter:setVisible(true)
        self.lbl_select:setVisible(false)

        if ex.Player.dream_data.my_hero_data then 
            if ex.Player.dream_data.my_hero_data.hero_id == self.data.hero_data.hero_id then 
                self.btn_enter:setVisible(false)
                self.lbl_select:setVisible(true)
            end 
        end 

    end 
    
end
return DreamFriendCell