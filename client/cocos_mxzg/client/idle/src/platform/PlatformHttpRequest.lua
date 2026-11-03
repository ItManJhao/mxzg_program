local PlatformHttpRequest = class("PlatformHttpRequest", require("src.common.SingleInstance"))

-- 获取默认平台角色和服务器信息
function PlatformHttpRequest:getDefaultServerInfo(callback)
    local http_data = {}
    http_data["action"] = "Platform.getUserServer"
    http_data["open_id"] = require("src.model.Game"):instance().user_id
    http_data["c_id"] = cpp.SocialPlatform:instance():getChannelId()
    http_data["c_son_id"] = cpp.SocialPlatform:instance():getPfId()
    http_data["device_type"] = cpp.SocialPlatform:instance():getPlatformStr()
    http_data["uuid"] = cpp.Game:instance():deviceUUID()
    http_data["access_token"] = require("src.model.Game"):instance().user_token or ""
    http_data["game_id"] = require("src.model.Game"):instance().game_id or ""
    http_data["is_test"] = (cpp.SocialPlatform:instance():isDebug() == true) and 1 or 0    -- 是否走sdk验证流程，前端开发环境时未走sdk，验证会不通过，需要跳过验证
    http_data["package_version"] = cpp.SocialPlatform:instance().getPackageVersion and cpp.SocialPlatform:instance():getPackageVersion() or ""

    -- ex.MessageView:add(require("src.model.Game"):instance().game_id)
    -- ex.MessageView:add(cpp.SocialPlatform:instance():getChannelId())
    -- ex.MessageView:add(cpp.SocialPlatform:instance():getPfId())
    local http = require("src.net.PlatformApi"):create()
    http:setCallback(callback)
    http:luaSendGet(json.encode(http_data), 5)
    --[[{"data":{"uid":"100000007","server_url":"182.254.197.214","server_post":"9902","is_new":"1",
        "msg":"\u6d4b\u8bd5\u670d\u52a1\u5668\u63d0\u793a\u4fe1\u606f\u7684","sid":"100001","server_status":"1",
        "is_white":1,"time":1573701277,"sign":"8ca3f3565170e9b4a99869a3f41f87fa"},"msg":"ok","code":200}
        ]]
end

-- 服务器改变时通知平台
function PlatformHttpRequest:loginPlatform(callback, server_id)
    local http_data = {}
    http_data["action"] = "Platform.login"
    http_data["uid"] = tostring(require("src.model.Game"):instance().user_id)
    http_data["c_id"] = cpp.SocialPlatform:instance():getChannelId()
    http_data["c_son_id"] = cpp.SocialPlatform:instance():getPfId()
    http_data["sid"] = server_id
    http_data["package_version"] = cpp.SocialPlatform:instance().getPackageVersion and cpp.SocialPlatform:instance():getPackageVersion() or ""

    local http = require("src.net.PlatformApi"):create()
    http:setCallback(callback)
    http:luaSendGet(json.encode(http_data), 5)

    --[[{"message":"\u64cd\u4f5c\u6210\u529f","code":200,
        "data":{"uid":"100000007","server_url":"182.254.197.214","server_post":"9902","is_new":"1",
        "msg":"\u6d4b\u8bd5\u670d\u52a1\u5668\u63d0\u793a\u4fe1\u606f\u7684","sid":"100001","server_status":"1",
        "is_white":1,"time":1573701277,"sign":"8ca3f3565170e9b4a99869a3f41f87fa"}}
        ]]
end

-- 获取平台服务器大区列表
function PlatformHttpRequest:getServerPageList(callback)
    local http_data = {}
    http_data["action"] = "Platform.serverAll"
    http_data["c_id"] = cpp.SocialPlatform:instance():getChannelId()
    http_data["c_son_id"] = cpp.SocialPlatform:instance():getPfId()
    http_data["device_type"] = "1" -- cpp.SocialPlatform:instance():getPlatformStr()

    local http = require("src.net.PlatformApi"):create()
    http:setCallback(callback)
    http:luaSendGet(json.encode(http_data), 5)

    --[[{"data":[{"server_url":"182.254.197.214","server_post":"9902","is_new":"1",
        "server_name":"\u65e7\u7248\u672c\u6d4b\u8bd5\u670d","msg":"\u6d4b\u8bd5\u670d\u52a1\u5668\u63d0\u793a\u4fe1\u606f\u7684",
        "sid":"100001","server_status":"1","show_name":"\u676d\u52a8\u4e00\u670d","sort":"2"},
        {"server_url":"182.254.197.214","server_post":"9902","is_new":"1","server_name":"\u65e7\u7248\u672c\u6d4b\u8bd5\u670d",
        "msg":"\u6d4b\u8bd5\u670d\u52a1\u5668\u63d0\u793a\u4fe1\u606f\u7684","sid":"100001","server_status":"1",
        "show_name":"\u676d\u52a8\u4e8c\u670d","sort":"3"}],"msg":"ok","code":200}
        ]]
end

-- 获取平台服务器分页列表
function PlatformHttpRequest:getServerListByPage(callback, page)
    local http_data = {}
    http_data["action"] = "Platform.serverPage"
    http_data["uid"] = tostring(require("src.model.Game"):instance().user_id)
    http_data["c_id"] = cpp.SocialPlatform:instance():getChannelId()
    http_data["c_son_id"] = cpp.SocialPlatform:instance():getPfId()
    http_data["device_type"] = cpp.SocialPlatform:instance():getPlatformStr()
    http_data["big_server_id"] = page
    http_data["package_version"] = cpp.SocialPlatform:instance().getPackageVersion and cpp.SocialPlatform:instance():getPackageVersion() or ""

    local http = require("src.net.PlatformApi"):create()
    http:setCallback(callback)
    http:luaSendGet(json.encode(http_data), 5)

    --[[{"data":[{"id":"10000001","name":"\u676d\u52a8\u4e8c\u533a","sort":"1"}],"msg":"ok","code":200}
        ]]
end

-- 获取平台服务器角色列表
function PlatformHttpRequest:getServerRoleList(callback)
    local http_data = {}
    http_data["action"] = "Platform.serverRole"
    http_data["open_id"] = require("src.model.Game"):instance().user_id
    http_data["c_id"] = cpp.SocialPlatform:instance():getChannelId()
    http_data["c_son_id"] = cpp.SocialPlatform:instance():getPfId()

    local http = require("src.net.PlatformApi"):create()
    http:setCallback(callback)
    http:luaSendGet(json.encode(http_data), 5)
    
    --[[{"data":[{"role_name":"\u4f60\u662f\u8c01","sid":"1000002"},
        {"role_name":"\u6d4b\u8bd5\u89d2\u8272\u540d","sid":"100001"}],
        "msg":"ok","code":200}
        ]]
end

-- 获取平台服务器角色列表
function PlatformHttpRequest:getServerSuggestList(callback)
    local http_data = {}
    http_data["action"] = "Platform.serverNew"
    http_data["uid"] = tostring(require("src.model.Game"):instance().user_id)
    http_data["c_id"] = cpp.SocialPlatform:instance():getChannelId()
    http_data["c_son_id"] = cpp.SocialPlatform:instance():getPfId()
    http_data["device_type"] = cpp.SocialPlatform:instance():getPlatformStr()
    http_data["package_version"] = cpp.SocialPlatform:instance().getPackageVersion and cpp.SocialPlatform:instance():getPackageVersion() or ""

    local http = require("src.net.PlatformApi"):create()
    http:setCallback(callback)
    http:luaSendGet(json.encode(http_data), 5)
    
    --[[{"data":[{"server_url":"182.254.197.214","server_post":"9902","is_new":"1",
        "server_name":"\u65e7\u7248\u672c\u6d4b\u8bd5\u670d",
        "msg":"\u6d4b\u8bd5\u670d\u52a1\u5668\u63d0\u793a\u4fe1\u606f\u7684","sid":"100001",
        "server_status":"1","show_name":"\u676d\u52a8\u4e00\u670d","sort":"2"},
        {"server_url":"182.254.197.214","server_post":"9902","is_new":"1","server_name":"\u65e7\u7248\u672c\u6d4b\u8bd5\u670d",
        "msg":"\u6d4b\u8bd5\u670d\u52a1\u5668\u63d0\u793a\u4fe1\u606f\u7684","sid":"100001",
        "server_status":"1","show_name":"\u676d\u52a8\u4e8c\u670d","sort":"3"}],"msg":"ok","code":200}
        ]]
end

-- 获取平台公告
function PlatformHttpRequest:getNotice(callback)
    local http_data = {}
    http_data["action"] = "Platform.notice"
    http_data["uid"] = tostring(require("src.model.Game"):instance().user_id)
    http_data["c_id"] = cpp.SocialPlatform:instance():getChannelId()
    http_data["c_son_id"] = cpp.SocialPlatform:instance():getPfId()
    http_data["device_type"] = cpp.SocialPlatform:instance():getPlatformStr()
    
    local res_language, config_idx = require("src.native.Native").getLanguageAdapter()
    if config_idx then
        local config = cfg.languagetype.languagetype[config_idx]
        if config then
            http_data["language"] = config.lang_key
        end
    end

    -- Native.getLanguageAdapter

    local http = require("src.net.PlatformApi"):create()
    http:setCallback(callback)
    http:luaSendGet(json.encode(http_data), 5)

    --[[{"data":{"content":"\u6d4b\u8bd5\u516c\u544a\u5185\u5bb9"},"msg":"ok","code":200}
        ]]
end

return PlatformHttpRequest