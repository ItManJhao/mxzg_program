

--cpp.LuaLayer.__ctype = 1

local LuaSceneBase = class("LuaSceneBase", function()
                                return cpp.LayerBase:create() -- 返回一个 CCNode 对象
                            end)

function LuaSceneBase:ctor()
    print("LuaSceneBase:ctor")
end

return LuaSceneBase
