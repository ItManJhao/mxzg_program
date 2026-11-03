
local GuideLevelCtr = class("GuideLevelCtr", require("src.layer.guide.GuideBase"))

local _instance = nil

function GuideLevelCtr:instance()
    if _instance == nil then
        _instance= GuideLevelCtr:create()
        _instance:retain()
        _instance:initDone()
    end
    return _instance
end


function GuideLevelCtr:remove()
    self:removeAllData()
    _instance = nil
    self:release()
end

-- 只支持执行一次
function GuideLevelCtr:executeFile(old_level, new_level)
    
    -- -- 执行过的文件
    -- local save_key = "guide_level_"
    -- if ex then
    --     save_key = save_key .. ex.Player.role_id
    -- end

    -- local executed_level = cc.UserDefault:getInstance():getIntegerForKey(save_key, 0)
    -- if executed_level >= new_level then
    --     return
    -- end

    -- cc.UserDefault:getInstance():setIntegerForKey(save_key, new_level)

    local file_data = require("src.config.guide.guidelevel.guideentire")
    local vec_execute = {}
    for i, v in ipairs(file_data) do
        -- 是否已经执行过了
        local executed_key = v.type == "function" and v.atom or string.format("level_"..v.level)
        local is_executed  = TableEx.findValueFunction(ex.Player.serial_str, function(value)
            return value == executed_key
        end)

        if is_executed == nil then
            if v.type == "function" then
                local config = cfg.opencondition.condition[v.atom]
                if config and config.condition_type == 1 and config.condition_value > old_level and config.condition_value <= new_level then
                    -- 需要执行的文件
                    table.insert(vec_execute, {key = executed_key, file=v.file})
                end
            elseif v.type == "level" and v.level > old_level and v.level <= new_level then
                -- 需要执行的文件
                table.insert(vec_execute, {key = executed_key, file=v.file})
            end
        end
    end

    -- 执行最后一个新手指引
    local file_name = ""
    local data =  vec_execute[#vec_execute]
    if data then
        file_name = data.file
    end

    if file_name ~= "" then
        local req_serial = Role_pb.GReqGuideSerial()
        for i,v in ipairs(vec_execute) do
            table.insert(req_serial.serial_str, v.key)
            table.insert(ex.Player.serial_str, v.key)
        end
        NetManager:sendMessage(ProtocolID.GReqGuideSerial, req_serial)

        print("guide execute_file_name = ", file_name)
        self:resetData()
        self:readGuideFile(file_name)
        self:executeGuide()
    end
end

function GuideLevelCtr:executeGuide()
    -- 判断当前文件步骤是否执行完毕
    if self.step_num >= table.nums(self.vec_guide_data) then
        self:remove()
        return
    end
    self.super.executeGuide(self)
end

return GuideLevelCtr