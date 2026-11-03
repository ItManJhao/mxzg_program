cc.FileUtils:getInstance():setPopupNotify(false)
local writable_path = cc.FileUtils:getInstance():getWritablePath()
cc.FileUtils:getInstance():addSearchPath(writable_path .. "src")
cc.FileUtils:getInstance():addSearchPath("src/")
-- cc.FileUtils:getInstance():addSearchPath(writable_path .. "res/")

require "src.config"
require "src.cocos.init"
require "src.cocos.cocos2d.json"

-- require "src.common.ProtocolID"
-- require "src.net.Protocols"

-- require "src.layer.SummonLayer"   
--require "src.layer.BackpackLayer"

--[[
-- error attempt  [bad argument] [stack traceback:]
--把打印的log写入文件
LOG_FILE_NAME = "/Users/windy/Documents/GAME_LOG.txt"

LOG_FILE_PATH = io.open(LOG_FILE_NAME,'w+')
--重写print 让打印的东西能同时写入到文件里
old_print = print
print = function (...)
    if not ... then return end
    local time = os.date("[%H:%M:%S]", os.time())
    old_print(...)
    --写入
    local args = {...}
    local s = time
    for i , v in ipairs(args) do
        s = s .. "\t" .. tostring(v)
    end
    -- 如果是报错信息才保存到文件
    --string.find(tostring(s), 'stack traceback:')
    LOG_FILE_PATH:write(tostring(s).."\n")
    LOG_FILE_PATH:flush()
end
]]





function response(byte_array)
    -- ex.ResponseManager:response(byte_array)
    require("src.native.Native").response(byte_array)
end

function loadConfig()
    -- ex.RedDotManager:readRedDotFile("config/reddot.rd")

    -- ex.ShopSeniorTicketTable:reload()
    -- ex.BuyTimeTable:reload()
    -- ex.MainCityTable:reloadNoFormat()
    require("src.native.Native").loadConfig()
end

function registerResponse()
    -- ex.ResponseManager:registerResponse()
    require("src.native.Native").registerResponse()
end


function sceneCtrLoadScene(scene_ctr, scene_type)
    -- scene_ctr:loadSceneLua()
    require("src.native.Native").sceneCtrLoadScene(scene_ctr, scene_type)
end

-- status is_success
function changeToLogoSceneCtr(str_json)
    -- print("windowsClose", node_ctr, ccbi_file)
    -- cpp.ResponseManager:instance():clearLuaResponse()
    -- return true
    return require("src.native.Native").changeToLogoSceneCtr(str_json)
end

function clearRoleData()
    require("src.native.Native").clearRoleData()
end

-- -- C++ call Lua 入口函数
-- function registerGlobalFile()
--    require("src.native.Native").registerGlobalFile()
--     package.loaded["src.native.Native"] = nil
-- end

function waitRecvProtocol(protocol)
    -- print("waitRecvProtocol", protocol)
    require("src.native.Native").waitRecvProtocol(protocol)
end

function waitSendProtocol(protocol)
    -- print("waitSendProtocol", protocol)
    require("src.native.Native").waitSendProtocol(protocol)
end

function windowsOpen(node_ctr, ccbi_file)
    -- print("windowsOpen", node_ctr, ccbi_file)
    require("src.native.Native").windowsOpen(node_ctr, ccbi_file)
end

function windowsClose(node_ctr, ccbi_file)
    -- print("windowsClose", node_ctr, ccbi_file)
    require("src.native.Native").windowsClose(node_ctr, ccbi_file)
end

function closeOtherWindow(json)
    return require("src.native.Native").closeOtherWindow(json)
end

function loginCallback(json)
    require("src.native.Native").loginCallback(json)
end

function logOutCallback()
    require("src.native.Native").logOutCallback()
end

function createLuaNode(node_name)
    return require("src.native.Native").createLuaNode(node_name)
end


function deleteAsset()
    return require("src.native.Native").deleteAsset()
end

function luaNodeOnHandlePropTypeString(node_name, pNode, pParent, pPropertyName)
    require("src.native.Native").luaNodeOnHandlePropTypeString(node_name, pNode, pParent, pPropertyName)
end


function updateXingeToken(str_json)
    require("src.native.Native").updateXingeToken(str_json)
end

function realName(str_json)
    require("src.native.Native").realName(str_json)
end


function sendReqLogin()
    require("src.native.Native").sendReqLogin()
end

function sendReqHeartbeat()
    require("src.native.Native").sendReqHeartbeat()
end

function itemActivate()
    require("src.native.Native").itemActivate()
end

function createBuilderNode(str_json)
    return require("src.native.Native").createBuilderNode(str_json)
end

function labelCustom(lbl)
    return require("src.native.Native").labelCustom(lbl)
end

function nodeCustoms(lbl, str)
    return require("src.native.Native").nodeCustoms(lbl, str)
end

function resetSearchPath()
    return require("src.native.Native").resetSearchPath()
end

function getNotchHeight(str_json)
    return require("src.native.Native").getNotchHeight(str_json)
end


function payCallback(str_json)
    return require("src.native.Native").payCallback(str_json)
end

function dzCallback(str_json)
    return require("src.native.Native").dzCallback(str_json)
end

function giftBagCallback(str_json)
    return require("src.native.Native").giftBagCallback(str_json)
end

function shareLinkCallback(str_json)
    return require("src.native.Native").shareLinkCallback(str_json)
end

function showAdCallback(str_json)
    return require("src.native.Native").showAdCallback(str_json)
end

function fileChange(file)
    return require("src.native.Native").fileChange(file)
end

local function main()

end

-- 开启断点调试等功能
local enable_debug = cpp.SocialPlatform:instance():isDebug()
if enable_debug then
    -- 2.程序异常监听

    old___G__TRACKBACK__ = __G__TRACKBACK__
    __G__TRACKBACK__ = function(errorMessage)
        old___G__TRACKBACK__(errorMessage)
        
        xpcallFun()

        print("----------------------------------------")
        local msg = debug.traceback(errorMessage, 3)
        print(msg)
        print("----------------------------------------")
    end

    local breakInfoFun,xpcallFun = require("LuaDebugjit")("localhost",7003)
    cc.Director:getInstance():getScheduler():scheduleScriptFunc(breakInfoFun, 0.3, false)
else
    -- 开启bugly等功能
    local enable_bugly = buglySetUserId ~= nil
        if enable_bugly then
            old___G__TRACKBACK__ = __G__TRACKBACK__
            __G__TRACKBACK__ = function(msg) 
                old___G__TRACKBACK__(msg)
                -- record the message
                local message = msg;    
                -- auto genretated
                local msg = debug.traceback(msg, 3)
                -- print(msg)  -- report lua exception
                local user_name = ex and (ex.Player.nick .. "\n") or ""
                -- print("user_name ", user_name)
                buglyReportLuaException(tostring(message), user_name .. debug.traceback())
            return msg
        end
        buglySetUserId("000000") 
    end
end


local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end




-- print("main_version1.0")



