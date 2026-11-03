local Game = class("Game", require("src.common.SingleInstance"))

-- 这个文件第一次更新会失败。暂未修复

function Game:ctor()
    self.server_id = -1
    self.user_id = ""
    self.user_token = ""
    self.user_name = ""
    self.game_id = ""
    
    -- jni在循环中调用会崩溃
    -- 48 -- 
    if device.platform == "mac" then
        self.notch_height = 48
    else
        self.notch_height = cpp.Game:instance():getNotchHeight()
    end
end

-- 预防配置表出错导致热更失败
function Game:getVersionCfg()
    if cfg == nil then
        cfg = {}
    end

    if cfg.version == nil or cfg.version.version == nil then
        local status, msg = xpcall(function()
            require("src.config.version")
        end, __G__TRACKBACK__)
        if not status then
            print(msg)
        end
    end

    if cfg.version == nil or cfg.version.version == nil or #cfg.version.version <= 0 then
        local config = {}
        config.idx = 1
        config.version = 1
        config.platform_urls = "http://platform-mxzg.anyaojs.com/"
        config.config_type = 1
        config.lang = 1
        config.run_guide = 1
        config.download_urls = "http://cdn-mxzg.anyaojs.com/release/idle/"
        config.download_urls_test = "http://182.254.197.214/hxqy/"
        cfg.version = {}
        cfg.version.version = {}
        cfg.version.version[1] = config
        return config
    else
        return cfg.version.version[1]
    end
end

function Game:getNotchHeight()
    return self.notch_height
end

return Game