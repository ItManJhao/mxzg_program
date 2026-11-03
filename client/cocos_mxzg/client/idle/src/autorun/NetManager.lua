
NetManager = cpp.NetManager:instance()

local is_print_send_data = false

------------------------发送--------------------------
function NetManager:parseByType(byte_array, data_type, data_value, data_len)
    if is_print_send_data then
        if byte_array.lua_data == nil then
            byte_array.lua_data = {}
        end
        table.insert(byte_array.lua_data, data_value)
    end
    
    if data_type == "int32" then
        byte_array:writeInt(data_value)
    elseif data_type == "int64" then
        byte_array:writeInt64(data_value)
    elseif data_type == "bool" then
        byte_array:writeBool(data_value)
    elseif data_type == "byte" then
        byte_array:writeByte(data_value)
    elseif data_type == "int8" then
        byte_array:writeInt8(data_value)
    elseif data_type == "int16" then
        byte_array:writeInt16(data_value)
    elseif data_type == "string" then
        byte_array:writeString(data_value, data_len)
    end
end

function NetManager:sendLuaData(data)
    local tmp_data = {}
    for k,v in pairs(data) do
        if type(v) ~= "function" then
            local index = v["idx"]
            if index then
                v.key = k
                tmp_data[index] = v
            end
        end
    end

    local req = cpp.ByteArray:create()
    for i,v in ipairs(tmp_data) do
        -- 发送特殊数组
        if v.array then
            if v.data then
                -- 调用解析函数
                local len = 0
                if v.len then
                    local is_key = type(v.len) == "string"
                    if is_key then
                        len = data[v.len].value
                    else
                        len = v.len
                    end
                else
                    len = data[tmp_data[i-1].key]
                end
                
                print("len", len)
                -- 解析数据
                for i=1,len do
                    v.data(self, req, v.key, i, data)
                end
            else
                -- 手动解析
                data:arrayCall(self, req, v.key)
            end
        elseif v.struct then
            -- local tmp_v = v.value or v
            v.data(self, req, v)
        else
            self:parseByType(req, v.type, v.value, v.str_len)
        end
        -- if v.array then
        --     data:arrayCall(self, req, v.key)
        -- else
        --     self:parseByType(req, v.type, v.value, v.str_len)
        -- end
    end
    self:sendByteArray(req)

    if is_print_send_data then
        dump(req.lua_data)
        req.lua_data = nil
    end
end

function NetManager:sendMessage(protocol_id, msg)
    if protocol_id == nil then
        return
    end

    print("protocol_id", protocol_id)

    local req = cpp.ByteArray:create()
    req:writeInt(protocol_id)

    if msg ~= nil then
        local str_msg = msg:SerializeToString()
        req:writeByteArray(str_msg, string.len(str_msg))

        -- local byte_str = ">>>>>NetManager:sendMessage protobuf content:["
        -- for i=1,string.len(str_msg) do byte_str = byte_str..string.byte(str_msg, i).."," end
        -- print(byte_str.."]")
    end

    cpp.NetManager:instance():sendByteArray(req)
end

--------------------------接收----------------------------
function NetManager:resParseValue(byte_array, data_type, data_len)
    if data_type == "int32" then
        return byte_array:readInt()
    elseif data_type == "int64" then
        return byte_array:readInt64()
    elseif data_type == "bool" then
        return byte_array:readBool()
    elseif data_type == "byte" then
        return byte_array:readByte()
    elseif data_type == "int8" then
        return byte_array:readInt8()
    elseif data_type == "int16" then
        return byte_array:readInt16()
    elseif data_type == "string" then
        return byte_array:readString(data_len)
    end
end

function NetManager:resLuaData(data, byte_array)
    local tmp_data = {}
    for k,v in pairs(data) do
        if type(v) ~= "function" then
            local index = v["idx"]
            if index then
                v.key = k
                tmp_data[index] = v
            end
        end
    end

    byte_array:resetPos()
    
    local res = {}
    for i,v in ipairs(tmp_data) do
        -- 接受特殊数组
        if v.array then
            if v.data then
                -- 调用解析函数
                local array = {}
                local len = 0
                if v.len then
                    local is_key = type(v.len) == "string"
                    if is_key then
                        len = res[v.len]
                    else
                        len = v.len
                    end
                else
                    len = res[tmp_data[i-1].key]
                end

                -- print("resLuaData", len)
                -- dump(v.data, "v.data")
                -- 解析数据
                for i=1,len do
                    array[i] = v.data(self, res, v.key, byte_array)
                end
                res[v.key] = array
            else
                -- 手动解析
                data:arrayCall(self, res, v.key, byte_array)
            end
        elseif v.struct then
            res[v.key] = v.data(self, res, v.key, byte_array)
        else
            res[v.key] = self:resParseValue(byte_array, v.type, v.str_len)
        end
    end
    return res
end
