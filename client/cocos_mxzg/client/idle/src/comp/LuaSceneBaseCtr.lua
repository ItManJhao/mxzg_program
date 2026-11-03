

--cpp.LuaLayer.__ctype = 1

local LuaSceneBaseCtr = class("LuaSceneBaseCtr", function()
                                return cpp.LuaSceneCtr:create() -- 返回一个 CCNode 对象
                            end)

function LuaSceneBaseCtr:onCreate()
    print("LuaSceneBase:ctor")
end

return LuaSceneBaseCtr
