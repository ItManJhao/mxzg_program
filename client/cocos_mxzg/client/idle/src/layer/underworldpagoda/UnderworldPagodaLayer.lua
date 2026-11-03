--[[
    func: 冥域魔都主界面
    author:熊梦
    time:2021-01-06 17:53:44
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local UnderworldPagodaLayer = class("UnderworldPagodaLayer", require("src.comp.EventLayer"))

-- 1:赫卡忒地狱
-- 2:撒旦地狱
local MODEL = 
{
    MODEL_1 = 1,
    MODEL_2 = 2
}
-------------------------------------UnderworldPagodaLayer----------------------------------------------------
-- 界面布局调整
function UnderworldPagodaLayer:onCreate()
    print("=================")
    -- 铺展到全屏
    ex.Tools:AdjustFullScreenExtend(self.spr_bg)

    local pos_y = ex.p.height - 100 * ex.s.global_scale - require("src.model.Game"):instance():getNotchHeight()
    self.node_top:setPositionY(pos_y)

    self.node_main_left:setPosition(0,ex.p.height/2)
    self.node_main_right:setPosition(ex.p.width,ex.p.height/2)

    
    self:addRedDotNode(RedDotType.ZCJ_DHZC_KFSK_MYMD_HKTDY, self.btn_entrance_1)
    self:addRedDotNode(RedDotType.ZCJ_DHZC_KFSK_MYMD_SDMY, self.btn_entrance_2)

    
    self.lbl_left_limit:setString(string.format(ex.Tools:getLang(6250),cfg.system["underworld_pagoda_1_days"],cfg.system["underworld_pagoda_1_level"]))
    self.lbl_right_limit:setString(string.format(ex.Tools:getLang(6250),cfg.system["underworld_pagoda_2_days"],cfg.system["underworld_pagoda_2_level"]))

    self.lbl_left_limit:setFontSize(32)
    self.lbl_right_limit:setFontSize(32)
    ex.Tools:setLimitWidth(self.lbl_left_limit, 150)
    ex.Tools:setLimitWidth(self.lbl_right_limit, 150)

end

function UnderworldPagodaLayer:onExit()
	-- 移除红点节点
end

function UnderworldPagodaLayer:onBack(tag, pSender)
	if self.callback_back then
		self.callback_back()
	else
		ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
	end
end

-- 进入副本
function UnderworldPagodaLayer:onStart(tag, pSender)
    local day = cc.exports.GetAfterDaysForTime(ex.Player.server_create_time)
    if tag ==  MODEL.MODEL_1 then
        if day < cfg.system.underworld_pagoda_1_days then
            ex.MessageView:add(ex.Tools:getLang(31909))
            return
        end
        if ex.Player.level < cfg.system.underworld_pagoda_1_level then
            ex.MessageView:add(ex.Tools:getLang(31004))
            return
        end
        ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_UNDERWORLD_PAGODA_BOSS)
        if ex.MainSceneCtr:getCurLayerType() == MainSceneType.MAINCITY_UNDERWORLD_PAGODA_BOSS then
            ex.MainSceneCtr:getCurLayer():setHadesType(MODEL.MODEL_1)
        end
    elseif tag ==  MODEL.MODEL_2 then
        if day < cfg.system.underworld_pagoda_2_days then
            ex.MessageView:add(ex.Tools:getLang(31909))
            return
        end
        if ex.Player.level < cfg.system.underworld_pagoda_2_level then
            ex.MessageView:add(ex.Tools:getLang(31004))
            return
        end
        ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_UNDERWORLD_PAGODA_BOSS)
        if ex.MainSceneCtr:getCurLayerType() == MainSceneType.MAINCITY_UNDERWORLD_PAGODA_BOSS then
            ex.MainSceneCtr:getCurLayer():setHadesType(MODEL.MODEL_2)
        end
    end
end

function UnderworldPagodaLayer:onInfo()
    ex.InfoCtr:openWindow(ex.Tools:getLang(6259), ex.Tools:getLang(6256))    
end


return UnderworldPagodaLayer
