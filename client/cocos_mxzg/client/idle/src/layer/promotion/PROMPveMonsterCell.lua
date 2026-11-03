--  
local PROMPveMonsterCell = class("PROMPveMonsterCell", require("src.comp.LuaLayerBase"))
local TrialBattleLayer = class("TrialBattleLayer", require("src.comp.LuaBattleLayer"))

local string_format = string.format
function PROMPveMonsterCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end


function PROMPveMonsterCell:setData(pos)
    self.pos = pos

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/promotion-2.plist")
    sfc:addSpriteFrames("ccbi-res/promotion-lang.plist")
    --  ex.Tools:getSysCfg("promotion_pve_fight_level")

    local flag = ex.Player.promotion_data:checkMissionSuccess(pos)
    local monster_image = cc.Sprite:createWithSpriteFrameName(string_format("promotion-lang/monster%d.png", pos))
    if not monster_image then return end 
    local win_size = cc.Director:getInstance():getWinSize()

    local width = monster_image:getContentSize().width
    local height = monster_image:getContentSize().height
    monster_image:setPosition(width * 0.5,height * 0.5)
    monster_image:setScaleX(1)
    self.image:addChild(monster_image) 

    if flag == false then 
        --未通关
        --self.btn_start
        self.btn_confirm:setVisible(false)
        self.btn_start:setVisible(true)
        local str_text = ex.Tools:getLang(52301)
        local text_obj = cc.Label:createWithTTF(str_text, FONT_DEFAULT_NAME_BOLD, 48)
        text_obj:setScale(0.6)
        self.btn_start:addChild(text_obj)
        text_obj:setPosition(self.btn_start:getContentSize().width * 0.5, self.btn_start:getContentSize().height * 0.5)
        text_obj:setTextColor(FONT_WHITE_C4B)
        text_obj:enableOutline(cc.c4b(31, 86, 167, 255), 4)
        self.btn_start:registerScriptTapHandler(handler(self, self.onClickBattle))
        
    else 
        --通关
        --self.btn_confirm
        self.btn_confirm:setVisible(true)
        self.btn_start:setVisible(false)
        local str_text = ex.Tools:getLang(52302)
        local text_obj = cc.Label:createWithTTF(str_text, FONT_DEFAULT_NAME_BOLD, 48)
        text_obj:setScale(0.6)
        self.btn_confirm:addChild(text_obj)
        text_obj:setPosition(self.btn_confirm:getContentSize().width * 0.5, self.btn_confirm:getContentSize().height * 0.5)
        text_obj:setTextColor(FONT_WHITE_C4B)
        text_obj:enableOutline(cc.c4b(98, 27, 215, 255), 4) 
    end
end

function PROMPveMonsterCell:onClickBattle(tag,pSender)
    
    local emeny_data, index = ex.Player.promotion_data:getMissionFromid(self.pos)
    self.emeny_data = emeny_data
        
    local reward_data = ex.Player.promotion_data:getMissionForReward(self.pos, index)

    require("src.layer.promotion.PROMPveMonsterInfoCtr"):instance():openWindow(self.pos, emeny_data, reward_data, handler(self, self.onBattle))
end


function PROMPveMonsterCell:onBattle(vec_battle, fetter_type)

    
end

return PROMPveMonsterCell
