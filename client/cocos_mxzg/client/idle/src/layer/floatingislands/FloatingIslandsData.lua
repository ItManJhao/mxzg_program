--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2020-07-04 15:43:57
]]

local FloatingIslandsData = class("FloatingIslandsData")

function FloatingIslandsData:ctor()
    self.next_time = 0
    self.stage = 0
    
    self.self_max_dmg = 0
    self.total_dmg = "0"
    self.challenge_count = 0
    self.can_buy_count = 0
end


function FloatingIslandsData:checkReddot()
    local isOpen = ex.JumpManager:checkOpenConditionByAtomNoMsg("main_floating_islands")
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KFSK_FKD_KSTZ, isOpen and self.stage == 2 and self.challenge_count > 0)
end


return FloatingIslandsData


