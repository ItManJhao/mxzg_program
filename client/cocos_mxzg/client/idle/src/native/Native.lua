local Native = class("Native")
-- require("src.lib.aes.aeslua")

-- require("src.model.StringUtil")

local audio_manager = require("src.model.AudioManager"):instance()

system_search_path = system_search_path or {}

-- 返回空。则使用默认值。
Native.getLanguageAdapter = function()
    local res_language = nil
    local config_idx = nil
    local font = nil

    local status, msg = xpcall(function()
        if cfg == nil then cfg = {} end
        require("src.config.languagetype")
        if cfg.languagetype == nil then 
            cfg.languagetype = {}
            cfg.languagetype.languagetype = {}
         end

        -- 国家代码查询 https://blog.csdn.net/zhangatm/article/details/84108338
        -- if cpp.Game:instance().getCurrentLanguageCodeFull then
            require("src.model.TableEx")

            -- local language_code = cc.UserDefault:getInstance():getStringForKey("system_language", "")
            -- if language_code == "" then
            --     language_code = cc.Application:getInstance():getCurrentLanguageCodeFull()
            -- end

            -- local code_abb = string.sub(language_code, 1, 2)

            -- -- 香港，澳门，台湾
            -- if language_code == "zh-HK" or language_code == "zh-MO" or language_code == "zh-TW"  then
            --     -- 繁体
            --     res_language = "res/cn-trad/"
            --     config_language = "cn_trad"
            -- elseif code_abb ~= "zh" then
            --     -- 英文
            --     res_language = "res/en/"
            --     config_language = "en"
            -- end
            -- local language_idx = cc.UserDefault:getInstance():getIntegerForKey("system_language", 1)
            -- -- 读取系统默认语言
            -- if language_idx == -1 then
            --     local code = cpp.Game:instance():getCurrentLanguageCodeFull()
            --     local code_config = TableEx.findValueFunction(cfg.languagetype.languagetype, function(value)
            --         return TableEx.findValueFunction(value.code, function(v)
            --             return v == code
            --         end) ~= nil
            --     end)

            --     local code_abb = string.sub(code, 1, 2)

            --     dump(code_config, "code_config")

            --     -- 中国地区用默认的资源目录，返回nil即可

            --     -- 没有找到对应的配置表。而且不是中国地区
            --     if code_config == nil and code_abb ~= "zh" then
            --         -- 英文
            --         code_config = TableEx.findValueFunction(cfg.languagetype.languagetype, function(value)
            --             return TableEx.findValueFunction(value.code, function(v)
            --                 return v == "en"
            --             end) ~= nil
            --         end)
            --     end

            --     if code_config then
            --         res_language = code_config.dir_res ~= "" and code_config.dir_res or nil
            --         config_idx = code_config.idx
            --         font = code_config.font
            --     end
            -- else
                -- local code_config = cfg.languagetype.languagetype[language_idx]
                -- local code_config = cfg.languagetype.languagetype[2]
                local  code_config = TableEx.findValueFunction(cfg.languagetype.languagetype, function(value)
                    return TableEx.findValueFunction(value.code, function(v)
                        return v == cpp.SocialPlatform:instance():getPlatformId()
                    end) ~= nil
                end)
                if code_config then
                    res_language = code_config.dir_res ~= "" and code_config.dir_res or nil
                    config_idx = code_config.idx
                    font = code_config.font
                end
        --     end
        -- end

    end, __G__TRACKBACK__)

    if not status then print(msg) end

    return res_language, config_idx, font
end

Native.resetSearchPath = function()
    -- 保存默认的搜索路径。
    local file_utils = cc.FileUtils:getInstance()
    if system_search_path == nil or table.nums(system_search_path) <= 0 then
        system_search_path = file_utils:getSearchPaths()
    end

    local res_manager = cpp.ResManager:instance()
    
    -- 资源目录设置. 默认不使用语言目录
    local res_hd = res_manager:decodeFilename("res/hd/")
    local res_font = res_manager:decodeFilename("res/hd/font/")
    local src = res_manager:decodeFilename("src/")

    local res_language, config_language, font = Native.getLanguageAdapter()

    if res_language then
        res_language = res_manager:decodeFilename(res_language)
    end

    if font then
        font = res_manager:decodeFilename(font)
    end

    
    local vec_path = {}
    local writable_path = file_utils:getWritablePath()

    -- 先搜索下载目录
    table.insert(vec_path,  writable_path)
    if res_language then table.insert(vec_path,  writable_path .. res_language) end
    table.insert(vec_path,  writable_path .. res_hd)
    table.insert(vec_path,  writable_path .. res_font)
    table.insert(vec_path,  writable_path .. src)

    if device.platform == "mac" then
        -- dump(system_search_path)
        local proj_dir_fix = "../../../../../"
        -- dump(system_search_path)
        local app_run_path = system_search_path[table.nums(system_search_path) - 3]
        app_run_path = app_run_path .. proj_dir_fix

        table.insert(vec_path,  app_run_path .. src)
        if res_language then table.insert(vec_path, app_run_path .. res_language) end
        table.insert(vec_path,  app_run_path .. res_hd)
        table.insert(vec_path,  app_run_path .. res_font)
    end

    for i,v in ipairs(system_search_path or {}) do
        table.insert(vec_path, v)
    end

    -- table.insert(vec_path,  writable_path .. res_hd)
    -- table.insert(vec_path,  writable_path .. res_font)

    if res_language then table.insert(vec_path, res_language) end
    table.insert(vec_path,  res_hd)
    table.insert(vec_path,  res_font)
    table.insert(vec_path,  src)

    dump(vec_path)
    file_utils:setSearchPaths(vec_path)
    
    -- 判断该字体文件是否存在
    if font and cc.FileUtils:getInstance():fullPathForFilename(font) then
        
        cc.UserDefault:getInstance():setStringForKey("font_file", font)
    end
end

Native.response = function(byte_array)
    ex.ResponseManager:response(byte_array)
end

Native.loadConfig = function()
    print("Native.loadConfig")
    -- ex.RedDotManager:readRedDotFile("config/reddot.rd")
    require("src.model.RedDotManager"):instance():readRedDotFile("config/reddot.rd")
    ex.ShopSeniorTicketTable:reload()
    ex.BuyTimeTable:reload()
    ex.MainCityTable:reloadNoFormat()
end

Native.registerResponse = function()
    cpp.ResponseManager:instance():clearLuaResponse()
    if ex then
        ex.ResponseManager:clear()
        ex.ResponseManager:registerResponse()
    else
        require("src.net.ResponseManager"):instance():registerResponse()
    end
end

Native.changeToLogoSceneCtr = function(str_json)
    cpp.ResponseManager:instance():clearLuaResponse()

    local function call()
        require("src.scene.UpdateSceneCtr"):instance():enterWithAnimation()
    end

    local status, msg = xpcall(call, __G__TRACKBACK__)
    if not status then
        print(msg)
    end

    return false
end

Native.clearRoleData = function()
    if ex ~= nil then
        ex.Player:clear()
        ex.Player = require("src.data.Player"):instance()
        ex.Timer:stop()
        ex.Timer:start()
        require("src.layer.guide.GuideCtr"):remove(true)
        require("src.layer.guide.GuideLevelCtr"):instance():remove(true)
    end
    
    if ctr then
        ctr:clearAll()
    end
end

Native.registerGlobalFile = function()
    require("src.native.Native").clearAllFile()
    package.loaded["src.RegisterGlobal"] = nil
    -- package.preload["RegisterGlobal"] = nil
    require "src.RegisterGlobal"
    require "src.ex.ExInit"
    registerResponse()
end

Native.clearAllFile = function(vec_exclude)
    vec_exclude = vec_exclude or {}
    cc.FileUtils:getInstance():purgeCachedEntries()

    -- 清除src目录下所有文件的缓存
    local vec_reload = {}
    for k1, v1 in pairs(package.loaded) do

        for k2, v2 in pairs(USER_CLASS_PATH) do
            local len1 = string.len(k1)
            local len2 = string.len(v2)

            if len1 - 1 >= len2 then
                local is_reload = true
                for i=1, len2 do
                    if string.sub(k1, i, i) ~= string.sub(v2, i, i) then
                        is_reload = false
                        break
                    end
                end
    
                if is_reload then
                    table.insert(vec_reload, k1)
                    break
                end
            end
        end
    end

    -- 清除缓存
    for i, v in ipairs(vec_reload) do
        local is_exclude = false

        for k,vex in pairs(vec_exclude) do
            if vex == v then
                is_exclude = true
                break
            end
        end
        
        if is_exclude ~= true then
            package.loaded[v] = nil
        end
    end
end

Native.waitRecvProtocol = function(protocol)
    require("src.layer.guide.GuideCtr"):waitRecvProtocol(protocol)
end

Native.waitSendProtocol = function(protocol)
    require("src.layer.guide.GuideCtr"):waitSendProtocol(protocol)
end

Native.windowsOpen = function(node_ctr, ccbi_file)
    require("src.layer.guide.GuideCtr"):windowsOpen(node_ctr, ccbi_file)
end

Native.windowsClose = function(node_ctr, ccbi_file)
    -- print("windowsClose", node_ctr, ccbi_file)
    require("src.layer.guide.GuideCtr"):windowsClose(node_ctr, ccbi_file)
end

Native.closeOtherWindow = function(str_json)
    -- dump(json)
    json_value = json.decode(str_json)
    if json_value.ccbi_file == "ccbi-res/ccbi/ChatLayer.ccbi" then
        print("Native.closeOtherWindow", json_value)
        return false
    end

    return true
end

Native.loginCallback = function(str_json)
    -- print("loginCallback", str_json)
    local tmp_json = json.decode(str_json)
    -- local user_id = aeslua.encrypt(tmp_json.user_id, tmp_json.user_id)
    -- cc.UserDefault:getInstance():setStringForKey("server_name", tmp_json.name)
    if tmp_json.is_success == true then
        require("src.scene.LogoSceneCtr"):instance():loginCallback(tmp_json.is_success, tmp_json.user_id, tmp_json.user_token, tmp_json.user_name, tmp_json.game_id)
    else
        require("src.scene.UpdateSceneCtr"):instance():enterWithAnimation()
    end
end

Native.createLuaNode = function(node_name)
    -- local node_name = json.decode(node_name).node_name
    -- if node_name == "UIMenuGeneral" then
    --     -- print("Native.createLuaNode")
    --     return require("src.comp.menu.UIMenuGeneral"):create()
    -- elseif node_name == "UIScale9SpriteEx" then
    --     return require("src.comp.UIScale9SpriteEx"):create()
    -- end
    return nil
end

Native.updateXingeToken = function(str_json)
    local tmp_json = json.decode(str_json)
end

-- 
Native.realName = function(str_json)
    local tmp_json = json.decode(str_json)

    local game = require("src.model.Game"):instance()
    game.is_realname = tmp_json.is_success        -- 0：未实名；1：已实名
    game.is_adult = tmp_json.adult      -- 0：未成年；1：已成年
    -- require("src.native.Native").updateXingeToken(str_json)

    print("Native.realName", tmp_json.is_success, tmp_json.adult)
    local game = require("src.model.Game"):instance()
    game.is_realname = tmp_json.is_success      -- 0：未实名；1：已实名
    game.is_adult = tmp_json.adult              -- 1：未成年；0：已成年
end

Native.deleteAsset = function()
    print("Native.deleteAsset")
    
    local del_func = function()
        local version_file = "resversion.rvs"
        local file_suffix = ".prelua"

        -- 获取刚下载的版本文件
        local writable_path = cc.FileUtils:getInstance():getWritablePath()
        local str_server_file = cc.FileUtils:getInstance():getStringFromFile(writable_path .. version_file)
        local json_server_file = json.decode(str_server_file)
        local server_delete_files = {}
        if not json_server_file then
            print("server_file is null")
            return
        end

        if json_server_file and json_server_file.deletelua then
            for k,v in pairs(json_server_file.deletelua) do
                table.insert(server_delete_files, v)
            end
        end

        -- 获取本地的版本文件
        local str_local_file = cc.FileUtils:getInstance():getStringFromFile(writable_path .. version_file .. file_suffix)
        if #str_local_file <= 0 then
            str_local_file = "{}"
        end

        local json_local_file = json.decode(str_local_file)
        local local_delete_files = {}
        if json_local_file and json_local_file.deletelua then
            for k,v in pairs(json_local_file.deletelua) do
                table.insert(local_delete_files, v)
            end
        end

        require("src.model.TableEx")
    -- 
        for k,v in pairs(server_delete_files) do
            local local_version = TableEx.findValueFunction(local_delete_files, function(value)
                return (v.file == value.file and value.version ~= v.version)
            end)

            if local_version ~= nil then
            -- dump(local_version)

                local file = v.file
                local str_len = string.len(file)
                local is_dir = string.sub(file, str_len, str_len)
                is_dir = (is_dir == '/') and true or false
                if is_dir then
                    cc.FileUtils:getInstance():removeDirectory(writable_path .. file)
                else
                    cc.FileUtils:getInstance():removeFile(writable_path .. file)
                end
            end
        end

        if json_local_file then
            json_local_file.deletelua = json_server_file.deletelua
        end

        str_local_file = json.encode(json_local_file)

        cc.FileUtils:getInstance():writeStringToFile(str_local_file, writable_path .. version_file .. file_suffix)
    end

    local status, msg = xpcall(del_func, __G__TRACKBACK__)
    if not status then
        print(msg)
    end
end

Native.sendReqLogin = function()
    local player = require("src.data.Player"):instance()
    local game = require("src.model.Game"):instance()
    
    local user_id = game.user_id
    local server_id = game.server_id
    local platfrom = cpp.SocialPlatform:instance():getPlatformStr()

    local req_login = Login_pb.GReqLogin()
    req_login.server_id = tonumber(server_id)
    req_login.user_id = tonumber(user_id)
    req_login.platform = tonumber(platfrom)
    req_login.device_id = cpp.Game:instance():deviceUUID()
    --LogoSceneCtr 中获取验证码和开始时间 来源于 首次获取默认服务器信息
    req_login.sign = game.login_sign
    req_login.login_token = tostring(game.login_time)
    print("sendReqLogin", server_id, user_id, platfrom)

    NetManager:sendMessage(ProtocolID.GReqLogin, req_login)
end

Native.sendReqHeartbeat = function()
    NetManager:sendMessage(ProtocolID.GReqHeartBeat)
end

Native.itemActivate = function()
    audio_manager:playEffect("music/button-click.mp3")
end


Native.createBuilderNode = function(str_json)
    local json = json.decode(str_json)
    local node = nil
    if json.class_name == "UIScrollViewBackpack" then
        node = require("src.comp.UIScrollViewBackpack"):createWithSize(cc.size(50, 50))
    end

    print("createBuilderNode", node)
    return node or cc.Node:create()
end

Native.labelCustom = function(lbl)
    local vec_custom = lbl:getCustom()
    for i,v in ipairs(vec_custom) do
        local vec_text = ex.StringUtil.splist(v, "###")
        local key = vec_text[1]
        local text = vec_text[2]
        if key == "lang" then
            -- lbl:setScale(5)
            lbl:setString(ex.Tools:getLang(tonumber(text)))
        end
    end

    lbl:clearCustom()
end

-- .classname:"UILabelTTF"
local FUNC_DEFINE = {
    ["UILabelTTF"] = {
        ["lang"] = function(lbl, value)
            lbl:setString(ex.Tools:getLang(tonumber(value)))
        end
    },
    ["UIMenuItemLabel"] = {
        ["lang"] = function(lbl, value)
            lbl:setLabelText(ex.Tools:getLang(tonumber(value)))
        end
    },
    ["UIMenuItemTab"] = {
        ["lang"] = function(lbl, value)
            lbl:setLabelText(ex.Tools:getLang(tonumber(value)))
        end
    }
}

Native.nodeCustoms = function(node, str)
    local vec_text = ex.StringUtil.splist(str, "###")
    local class_name = node[".classname"]
    local key = vec_text[1]
    local text = vec_text[2]
    
    if class_name and key and text then
        FUNC_DEFINE[class_name][key](node, text)
    else
        print(class_name, key)
    end
end

Native.getNotchHeight = function(str_json)
    print("getNotchHeight", str_json)

    local data = {}
    data.height = "0"
    local func = function()
        local notch_table = require("src.config.NotchHeightTable"):instance()
        notch_table:reload()
        local tab_device = json.decode(str_json)
        data.height = notch_table:getHeight(tab_device.device)
    end
    
    xpcall(func, __G__TRACKBACK__)
    return json.encode(data)
end


Native.payCallback = function(str_json)
    local json = json.decode(str_json)

    if json.is_success == true then
        ex.MessageView:add("支付成功")
        return
    end
    
    ex.MessageView:add(json.msg)
end

Native.logOutCallback = function(str_json)
    cpp.SocialPlatform:instance():loginCallback(false, "")
    return true
end

Native.dzCallback = function(str_json)
    -- local json = json.decode(str_json)
    -- ex.MessageView:add(str_json)
end

Native.giftBagCallback = function(str_json)
    -- local json = json.decode(str_json)
    -- ex.MessageView:add(str_json)
end

Native.showAdCallback = function(str_json)
    -- local json = json.decode(str_json)
    -- ex.MessageView:add(str_json)
end

Native.shareLinkCallback = function(str_json)
    -- local json = json.decode(str_json)
    -- ex.MessageView:add(str_json)
end


Native.fileChange = function(file)
    -- file = string.gsub(file,"/", ".")
    file = ex.StringUtil.segmentLast(file, "/", true)
    file = string.gsub(file,".lua", "")  
    print("fileChange", file);  

    ex.Tools:clearCite(file)
end

return Native
