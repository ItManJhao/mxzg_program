local ResManager = class("ResManager", require("src.common.SingleInstance"))



local remove_res_scheduler_id = nil

local keep_res = {
    ["ccbi-res/backpack.plist"] = true,
    ["ccbi-res/backpack-4.plist"] = true,
    ["ccbi-res/backpack-5.plist"] = true,
    ["ccbi-res/head-icon-lang.plist"] = true,
    ["ccbi-res/head-icon-1.plist"] = true,
    ["ccbi-res/hero-icon-lang.plist"] = true,
    ["ccbi-res/hero-icon-1.plist"] = true,
    ["ccbi-res/hero-icon-2.plist"] = true,
    ["ccbi-res/hero-icon-3.plist"] = true,
    ["ccbi-res/hero-icon-4.plist"] = true,
    ["ccbi-res/hero-icon-5.plist"] = true,
    ["ccbi-res/hero-icon-other.plist"] = true,
    ["ccbi-res/main-city.plist"] = true,
    ["ccbi-res/main-scene.plist"] = true,
    ["ccbi-res/main-scene-lang.plist"] = true,
    ["ccbi-res/common-ui.plist"] = true,
    ["ccbi-res/common-ui-2.plist"] = true,
    ["ccbi-res/skill-icon.plist"] = true,
    ["ccbi-res/backpack-effect.plist"] = true,
    ["ccbi-res/touch-effect.plist"] = true,    
}

function ResManager:ctor()
    self.window_res = {}
    self.other_res_tab = {}
end


function ResManager:removeRes(type, plist, image)

    if keep_res[plist] ~= nil then
        return
    end

    -- 释放帧缓存
    if type == 2 then
        cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile(plist)
    end

    if image then
        local texture = cc.Director:getInstance():getTextureCache():getTextureForKey(image)

        -- if texture then
        --     print("getReferenceCount", image,  texture:getReferenceCount())
        -- end
        
        if texture and texture:getReferenceCount() == 1 then

            cc.Director:getInstance():getTextureCache():removeTextureForKey(image)

            print("remove file", image)
            if plist then
                self.window_res[plist] = nil
            end
        end
    end
end

function ResManager:addPlist(vec_plist)
    -- 添加资源引用数
    for i,v in ipairs(vec_plist) do
        if  self.window_res[v] == nil then
            self.window_res[v] = 0
        end
        self.window_res[v] = self.window_res[v] + 1
    end
    -- dump(self.window_res)
end

function ResManager:removePlist(vec_plist)
    for i,v in ipairs(vec_plist) do
        self:removePlistFile(v);
        -- if self.window_res[v] then
        --     self.window_res[v] = self.window_res[v] - 1
        -- end
    end
end


function ResManager:removePlistFile(plist)
    if self.window_res[plist] then
        self.window_res[plist] = self.window_res[plist] - 1
    end
end


function ResManager:removeImage(vec_image)
    for k,v in pairs(vec_image) do
        table.insert(self.other_res_tab, v)
    end

    if remove_res_scheduler_id == nil then
        remove_res_scheduler_id = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()             
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(remove_res_scheduler_id)

            remove_res_scheduler_id = nil

            -- dump(self.other_res_tab)
            -- 删除jgp文件会有bug  用到的时候再修改
            for k,v in pairs(self.other_res_tab) do
                -- self:removeRes(v.remove_type, v.plist_name, v.image_name)
                -- self:removePlist();
                if v.remove_type == 2 then
                    self:removePlistFile(v.plist_name);
                else
                    self:removeRes(v.remove_type, v.plist_name, v.image_name)
                end
            end
            -- 修复bug 清除上一次删除的记录
            self.other_res_tab = {}

            for k,v in pairs(self.window_res) do
                if v == 0 then
                    local image =  string.sub(k,1, string.len(k) - 5) .. "pvr.ccz"
                    self:removeRes(2, k, image)
                end
            end
            -- dump(self.window_res)
            -- Xcode下内存统计不会减少。 cocos-info里面的内存占用确实减少了。原因未知
            -- dump(cc.Director:getInstance():getTextureCache():getCachedTextureInfo())
            -- cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("ccbi-res/hero-icon.plist")
            -- local texture = cc.Director:getInstance():getTextureCache():getTextureForKey("ccbi-res/hero-icon.pvr.ccz")
            -- print("texture count", texture:getReferenceCount())
            -- cc.Director:getInstance():getTextureCache():removeTextureForKey("ccbi-res/hero-icon.pvr.ccz")
            -- dump(cc.Director:getInstance():getTextureCache():getCachedTextureInfo())
        end, 3, false)
    end
end

return ResManager