-- 
local DreamSelectCell = class("DreamSelectCell", require("src.comp.LuaLayerBase"))

local string_format = string.format
function DreamSelectCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.btn_open:setLabelText(ex.Tools:getLang(47255))
    self.btn_open:setLabelColor(FONT_BROWN)
    self.btn_open:setLabelSize(48)
    self.btn_open:registerScriptTapHandler(handler(self,self.openBattle))

end


function DreamSelectCell:reset(id)

    if not id then print("not id") return end
    self.id = id
    
    local cfg_data = cfg.infinitebuff.infinitebuff[id]
    if not cfg_data then print("not cfg_data") return end 
    
 
    self.show_msg:setString(ex.Tools:getLang(cfg_data.lan_title))

    ex.Tools:setSpriteFrame(self.buff_image, string_format("dream/%s.png", cfg_data.icon))

end


function DreamSelectCell:openBattle(tag,pSender)

    -- 如果是
    ex.Player.dream_data:gReqDreamlandSelectBuff(self.id)
    
    ex.EventManager:fire(EVENT.DREAM_EVENT.LOAD_BATTLE)

    --ex.Player.dream_data:gReqDreamlandData()

    require("src.layer.dream.DreamSelectCtr"):instance():closeWindow()

end


return DreamSelectCell