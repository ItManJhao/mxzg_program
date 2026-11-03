local AssetManager = class("AssetManager", require("src.common.SingleInstance"))
local md5 = require("src.lib.md5.md5")

local ADL_STATUS = 
{
    ADL_FAIL = -1,
    ADL_SUCCESS = 1,
    ADL_DOWNLOAD = 2,
    ADL_STOP = 3,
    ADL_FILE_MISS = 4,
}

function AssetManager:ctor()
    -- http://129.204.22.51/idle/100000/100000/src10.0.zip
    local config = require("src.model.Game"):instance():getVersionCfg()


    local download_url = config.download_urls
    local str_splice = cc.FileUtils:getInstance():getStringFromFile("config/splice.ss")
    local channel_id = cpp.SocialPlatform:instance():getChannelId()
    local pf_id = cpp.SocialPlatform:instance():getPfId()

    self.base_url = download_url  .. str_splice .. channel_id .. "/" .. pf_id .. "/"

    self.str_resversion = "resversionex.rvs"
    self.str_version = "version.rvs"
	
    -- 这个需要从服务器中获取
    -- self.version_file self.server_file 已经不再使用
    self.version_file = self.base_url .. self.str_version
    self.server_file = self.base_url .. self.str_resversion
    -- log4autopatch:i{version_file = self.version_file, serverFile = self.server_file}
    print("version_file = self.version_file, serverFile = self.server_file===", self.version_file, self.server_file)

    -- 本地和服务器版本信息
    self.local_version_num = 0
    self.server_version_num = 0


    self.writable_path = cc.FileUtils:getInstance():getWritablePath()

    -- 下载器
    self.asset_manager = cpp.AssetDownload:instance()

    self.callback_finish = nil

    -- 重置下载相关的数据
    self:reset()

    self.is_change_local_data = false

    -- md5校验次数
    self.md5_check_count = 0
    self.md5_check_max = 13

    -- 当前的版本号
    self.comp_version_callback = nil

    -- 下载状态, 0:正在验证资源  1:正在验证下载列表  2:正在下载
    self.download_status = 0

    -- 
    self.is_download_server_list = false

    -- 
    self.download_suffix = ".tmp"

    -- log4autopatch:i{
    --     step            = "init AssetManager",
    --     base_url        = self.base_url,
    --     download_url    = config.download_urls,
    --     writable_path   = self.writable_path,
    --     local_version   = self.local_version_num,
    --     server_version  = self.server_version_num,
    -- }
    print("本地和服务器版本信息step,base_url,download_url,writable_path,local_version ,server_version===", "init AssetManager", self.base_url, config.download_urls, self.writable_path, self.local_version_num, self.server_version_num)
end

-- 重置数据
function AssetManager:reset()
    -- 本地文件信息
    self.local_data = {}

    -- 下载的服务器信息
    self.server_data = {}

    -- 需要下载的文件
    self.download_list = {}

    -- 现在已经下载的字节数
    self.cur_download_size = 0

    -- 总字节数
    self.total_download_size = 0

    -- 下载状态
    self.download_status = 0

    -- 是否已经下载版本文件
    self.is_download_server_list = false
end

function AssetManager:checkDownloadList()
    -- log4autopatch:i("AssetManager:checkDownloadList")
    print("AssetManager:checkDownloadList")
    self.download_status = 0
    self.md5_check_count = 0
    self:reset()

    local http_data = {}
    http_data["action"] = "Platform.getChannelVersion"
    http_data["c_son_id"] = cpp.SocialPlatform:instance():getPfId()
    http_data["package_version"] = cpp.SocialPlatform:instance().getPackageVersion and cpp.SocialPlatform:instance():getPackageVersion() or ""

    local http = require("src.net.PlatformApi"):create()
    http:setCallback(function(json)
        -- log4autopatch:i{"AssetManager:OnCheckDownloadList", json}
        print("AssetManager:OnCheckDownloadList")
        dump(json, "json = ")
        
        if json.msg ~= "ok" then
            self:checkDownloadList()
            return
        end

        if json.data and json.data.is_past ~= "1" then
            self:downloadFinish()
            return
        end

        local server_version = tonumber(json.data.version)
        local local_version = cc.FileUtils:getInstance():getStringFromFile(self.str_version .. ".pre")

        if server_version == nil then
            self:checkDownloadList()
            return
        end
        
        if local_version ~= "" then
            local_version = tonumber(local_version)
        else
            local_version = 0
        end

        self.local_version_num = local_version
        self.server_version_num = server_version
        -- log4autopatch:i{"self.server_version_num", self.server_version_num}
        print("self.server_version_num==", self.server_version_num)

        -- self.server_version_num = 145


        local scheduler_id = nil
        if local_version >= server_version then
            scheduler_id = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
                self:downloadFinish()
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(scheduler_id)
            end, 0.1, false)
            return
        end    

        scheduler_id = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
            self:checkFileDownloadList()
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(scheduler_id)
        end, 0.1, false)
    end)
    http:luaSendGet(json.encode(http_data))
end

-- 下载版本文件
function AssetManager:checkFileDownloadList()
    self.md5_check_count = 0
    self:reset()

    local url = string.format("%s%s.%s", self.base_url,
                                         self.str_resversion,
                                         self.server_version_num)
    local path = string.format("%s%s", self.writable_path, self.str_resversion)
    self:downloadFile(url, path, function(status)
        if status == ADL_STATUS.ADL_FILE_MISS
            or status == ADL_STATUS.ADL_FAIL then
            self:checkFileDownloadList()
            return
        end

        self.download_list = self:getDownloadList()
        if self.local_version_num >= self.server_version_num then
            self:downloadFinish()
            return
        end

        self.is_download_server_list = true
        self.download_status = ADL_STATUS.ADL_DOWNLOAD
        self:starUpdateNewFile()
    end)
end

function AssetManager:starUpdateNewFile()
    -- log4autopatch:i{"AssetManager:starUpdateNewFile"}
    print("AssetManager:starUpdateNewFile")
    self.asset_manager:setNowDownloaded(0)

    local func_download_call = function(v)
        local url = string.format("%s%s.%s", self.base_url,
                                             v.file,
                                             v.m)
        local path = string.format("%s%s", self.writable_path, v.file)
        local tmpPath = path .. self.download_suffix
        self:downloadFile(url, tmpPath, function(status)
            if status ~= ADL_STATUS.ADL_SUCCESS then
                -- log4autopatch:w("error miss file %s", v.file)
                print("error miss file %s", v.file)
                self:starUpdateNewFile()
                return
            end

            if not self:checkFileMd5(tmpPath, v.m) then
                self.md5_check_count = self.md5_check_count + 1
                if self.md5_check_count > self.md5_check_max then
                    self:checkFileDownloadList()
                    return
                end
                self:starUpdateNewFile()
                return
            end

            self.md5_check_count = 0
            if not cc.FileUtils:getInstance():renameFile(tmpPath, path) then
                self:starUpdateNewFile()
                return
            end

            v.is_download = true
            self.cur_download_size = self.cur_download_size + v.s
            self:changeDownloadStatus(v.file, v.m)
            self:starUpdateNewFile()
        end)
    end

    local need_download_data = nil
    for k,v in pairs(self.download_list) do
        if v.is_download ~= true then
            need_download_data = v
            need_download_data.file = k
            break
        end
    end

    if need_download_data ~= nil then
        func_download_call(need_download_data)
    else
        self:downloadFinish()
    end
end

function AssetManager:downloadFinish()
    if self.callback_finish then
        self.callback_finish()
    end
end

-- 改变文件下载状态.文件下载完成时会调用该函数
function AssetManager:changeDownloadStatus(fileName, str_md5)
    if not fileName then
        fileName = ""
    end
    self.is_change_local_data = true
    local file_data = self.local_data[fileName]

    if file_data then
        file_data.m = str_md5
    else
        self.local_data[fileName] = {file=fileName,m=str_md5}
    end
end

-- 保存已下载的文件列表。1秒钟保存一次
function AssetManager:saveDownloadStatus(is_enforce, save_version, reset)
    if is_enforce ~= true and self.is_change_local_data ~= true then
        return
    end

    if save_version == true then
        self.local_version_num = self.server_version_num
        -- self.local_data.version = self.server_data.version
    end

    if self.is_download_server_list == true then
        local str_local = ""
        local lenght = table.nums(self.local_data)
        local index = 1
        for k,v in pairs(self.local_data) do
            str_local = str_local .. k .. "|" .. v.m .. "|" .. (index == lenght and "" or '\n')
            index = index + 1
        end

        if str_local ~= "" then
            cc.FileUtils:getInstance():writeStringToFile(str_local, self.writable_path .. self.str_resversion .. ".pre")
            cc.FileUtils:getInstance():writeStringToFile(tostring(self.local_version_num), self.writable_path .. self.str_version .. ".pre")
        end
    end
    
    if reset then
        self:reset()
    end
end

-- 新版验证
function AssetManager:getFileData(file)
    local StringUtil = require("src.model.StringUtil")
    local data = {}
    local file_data = cc.FileUtils:getInstance():getStringFromFile(file)
    local vec_line = StringUtil.splist(file_data, "\n")
    for i,v in ipairs(vec_line) do
        local plist = StringUtil.splist(v, "|")
        data[plist[1]] = {m=plist[2],s=plist[3]}
    end
    return data
end

-- 兼容旧版, 2020-01-18号更新新版
function AssetManager:getJsonFileData(file)
    local data = {}
    local local_data = cc.FileUtils:getInstance():getStringFromFile(file)
    if local_data == "" then
        return data
    end

    local_data = json.decode(local_data)

    for i,v in pairs(local_data.downloads) do
        data[v.file] = {m=v.md5}
    end

    return data
end

-- 解析前端跟服务器的文件
function AssetManager:getDownloadList()
    self.server_data = self:getFileData(self.writable_path .. self.str_resversion)

    self.local_data = self:getFileData(self.writable_path .. self.str_resversion .. ".pre")
    if table.nums(self.local_data) <= 0 then
        self.local_data = self:getFileData(self.str_resversion .. ".pre")
    end

    local download_list = {}
    self.cur_download_size = 0
    for k, v in pairs(self.server_data) do
        -- 判断是否已经下载过该文件
        local file_data = self.local_data[k]
        -- 加入到下载列表中
        if file_data == nil or file_data.m ~= v.m then
            self.total_download_size = self.total_download_size + v.s
            download_list[k] = v
        end
    end
    
    -- log4autopatch:i{"getDownloadList", download_list}
    print("getDownloadList")
    dump(download_list)
    return download_list
    -- local server_data = cc.FileUtils:getInstance():getStringFromFile(self.writable_path .. self.str_resversion)

    -- local local_data = cc.FileUtils:getInstance():getStringFromFile(self.writable_path .. self.str_resversion .. ".pre")
    -- if local_data == "" then
    --     local_data = cc.FileUtils:getInstance():getStringFromFile(self.str_resversion .. ".pre")
    -- end

    -- local_data = json.decode(local_data ~= "" and local_data or self.defalut_config)
    -- server_data = json.decode(server_data ~= "" and server_data or self.defalut_config)

    -- if local_data then
    --     self.local_data = local_data
    -- end

    -- if self.local_data.version == nil then
    --     self.local_data.version = 100
    -- end
    
    -- if server_data then
    --     self.server_data = server_data
    -- end

    -- if self.server_data.version == nil then
    --     self.server_data.version = 100
    -- end

    -- require("src.model.TableEx")

    -- local download_list = {}
    -- self.cur_download_size = 0

    -- -- 需要下载的列表
    -- for k, v in ipairs(self.server_data.downloads) do
    --     -- 判断是否已经下载过该文件
    --     local file_data = TableEx.findValueFunction(self.local_data.downloads, function(value)
    --         return (value.file == v.file)
    --     end)

    --     -- 加入到下载列表中
    --     if file_data == nil or file_data.md5 ~= v.md5 then
    --         -- if file_data then
    --         --     print(file_data.file, file_data.md5 , v.md5)
    --         -- end

    --         self.total_download_size = self.total_download_size + v.file_size
    --         table.insert(download_list, v)
    --     end
    -- end

    -- return download_list
end

-- 下载单个文件
function AssetManager:downloadFile(url, save_path, callback)
    -- log4autopatch:i{"downloadFile", url = url, save_path = save_path}
    print("downloadFile  url = , save_path =",url,save_path)
    -- 删除原有文件
    self:removeFileOnly(save_path)

    self.callback_download = callback
    self.asset_manager:setUrl(url)
    self.asset_manager:setSaveFile(save_path)
    self.asset_manager:startDownload()
    self.asset_manager:setNowDownloaded(0)
    self.asset_manager:setMd5("")
    self:startDownloadTimer()
end

function AssetManager:removeFileOnly(file)
    if (file == nil) or (type(file) ~= "string") then
        return
    end

    local str_len = string.len(file)
    local is_dir = string.sub(file, str_len, str_len)
    is_dir = (is_dir == '/') and true or false
    if is_dir then
        cc.FileUtils:getInstance():removeDirectory(file)
    else
        cc.FileUtils:getInstance():removeFile(file)
    end
end

-- 开始下载检测
function AssetManager:startDownloadTimer()
    if self.scheduler_id ~= nil then
        print("定时器正在检测中")
        return
    end

    local scheduler = cc.Director:getInstance():getScheduler()
	self.scheduler_id = scheduler:scheduleScriptFunc(handler(self, self.checkDownload), 0.03, false)
end

-- 结束下载检测
function AssetManager:stopDownloadTimer()
	if self.scheduler_id ~= nil then 
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler_id)
		self.scheduler_id = nil
	end
end

-- 检查异步下载状态
function AssetManager:checkDownload()
    if self.asset_manager:getDownloadStatus() == ADL_STATUS.ADL_SUCCESS then
        self:stopDownloadTimer()
        -- 下载完成
        if self.callback_download then
            self.callback_download(self.asset_manager:getDownloadStatus(), self.asset_manager:getUrl())
        end
    elseif self.asset_manager:getDownloadStatus() ~= ADL_STATUS.ADL_DOWNLOAD then
        self:stopDownloadTimer()

        -- 下载失败
        if self.callback_download then
            self.callback_download(self.asset_manager:getDownloadStatus(), self.asset_manager:getUrl())
        end
    end
end

-- 检查文件的md5.。
function AssetManager:checkFileMd5(file, src_md5)
    local file_md5 = self.asset_manager:getMd5()
    if file == "" or src_md5 == "" or src_md5 == nil then
        -- log4autopatch:w("checkFileMd5 %s %s %s", file, file_md5, src_md5)
        print("checkFileMd5 %s %s %s", file, file_md5, src_md5)
        return false
    end

    if file_md5 ~= src_md5 then
        -- log4autopatch:w("checkFileMd5 %s %s %s", file, file_md5, src_md5)
        print("checkFileMd5 %s %s %s", file, file_md5, src_md5)
        return false
    end

    return true
end


return AssetManager
