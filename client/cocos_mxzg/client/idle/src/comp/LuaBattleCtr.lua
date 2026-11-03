local LuaBattleCtr = class("LuaBattleCtr", function()
                                return cpp.LuaBattleLayer:create() 
                            end)

-- 注意事项 如果重新绑定cpp.LuaBattleLayer 。则需要将x修改为x
-- tolua_cclass(tolua_S,"BattleCtr","BattleCtr","",nullptr);
-- tolua_cclass(tolua_S,"BattleCtr","BattleCtr","cc.Node",nullptr);

function LuaBattleCtr:onCreate()
	
end

function LuaBattleCtr:updateHeroAblitity(hero_id)

end

return LuaBattleCtr
