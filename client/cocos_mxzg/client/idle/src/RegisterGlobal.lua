
local vec_error_key = {
    'invalid',
    'stack traceback',
    'error',
    'attempt',
    'bad ',
}

-- local vec_search_paths = {}
-- table.insert(vec_search_paths, cc.FileUtils:getInstance():getWritablePath())
-- cc.FileUtils:getInstance():
-- FileUtils::getInstance()->setSearchPaths(<#const std::vector<std::string> &searchPaths#>);

-- if cpp.SocialPlatform:instance():getPlatformStr() == "1" and cpp.SocialPlatform:instance().is_limit_print == nil then
-- 	cpp.SocialPlatform:instance().is_limit_print = 1
--     old_print = print
--     print = function (...)
--         -- old_print(debug.traceback())
--         if not ... then return end
--         local time = os.date("[%H:%M:%S]", os.time())
--         old_print(...)
--         --写入
--         local args = {...}
--         local s = time
--         if ex and ex.Player then
--             s = s .. ex.Player.nick 
--             s = s .. "  "
--             s = s .. ex.Player.role_id
--         end
    
--         for i , v in ipairs(args) do
--             s = s .. "\t" .. tostring(v)
--         end
    
--         local str = nil
--         -- 如果是报错信息才保存到文件
--         for k,v in pairs(vec_error_key) do
--             str = string.find(tostring(s), v)
--             if str ~= nil then
--                 break
--             end
--         end
    
--         if str ~= nil then
--             old_print("send error", s, #s)
--             local req_error = cpp.ByteArray:create()
--             req_error:writeInt(ProtocolID.GReqError)
--             req_error:writeInt(#s)
--             req_error:writeString(s, #s)
--             cpp.NetManager:instance():sendByteArray(req_error)
--         end
--     end
-- end

-- 兼容旧版本的加载
is_new_load_init = true
require "src.config.Init"
is_new_load_init = nil


require "src.common.SingleInstance"
require "src.common.CommonDefine"
require "src.common.RedDot"

require "src.common.EventDefine"
require "src.autorun.NetManager"
require "src.comp.LuaLayerBase"
--require "src.model.binder"
require "src.model.Maths"
require "src.model.TableEx"
require "src.common.BaseClass"
require "src.common.CommonDefine"
require "src.model.StringUtil"
require "src.ex.ExInit"
require "src.ex.CtrInit"


-- src.battle
require "src.battle.actions"

-- src.factory
require "src.factory.ActionNodeFactory"
require "src.factory.BattleActionFactory"
require "src.factory.BattleInfoFactory"
require "src.factory.BattleHeroFactory"
require "src.factory.EffectFactory"
require "src.factory.BuffFactory"
require "src.factory.HeroSpineFactory"

-- global
require "src.global.GlobalBattleHelper"

-- src.utils
require "src.utils.BattleActionUtils"
require "src.utils.BattleAttrUpdateUtils"
require "src.utils.BattleUtils"
require "src.utils.NodeUtils"

-- 部分红点手动注册

-- 重新加载图片资源
cc.SpriteFrameCache:getInstance():reloadTexture("ccbi-res/common-ui.plist")
cc.SpriteFrameCache:getInstance():reloadTexture("ccbi-res/common-ui-2.plist")
cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
cc.Director:getInstance():getTextureCache():removeUnusedTextures()

-- cpp.CCBLoader:addNodeLoaderLibrary("UIMenuGeneral");

-- cpp.CCBLoader:addNodeLoaderLibrary("UIScale9SpriteEx");
-- ex.RedDotManager:enablePrint(true)

if cpp.UILabelTTF.setDefaultFontName then
    cpp.UILabelTTF:setDefaultFontName(FONT_DEFAULT_NAME_BOLD)
end


is_game_controller = cpp.SocialPlatform:instance():isDebug() == true
is_pass_recharge = is_game_controller
is_show_gm = is_game_controller
is_skip_guide = is_game_controller
is_show_battle_ship = is_game_controller


