local CSVLoader = class("CSVLoader")

CSVLoader.file_name = ""
CSVLoader.main_key = ""

function CSVLoader:ctor()
    CSVLoader.data = clone({})
    CSVLoader.keys = clone({})
end

local trim = '"'

function CSVLoader:splist(str, reps)
    local result = {}
    string.gsub(str, '[^' .. reps ..']+', function(w) table.insert(result, w) end) 
    return result
end


function CSVLoader:rowParse(str)
    local result = {}
    local strCurWorld = ""
    local trim_num = 0
    for i=1,#str do
        local ch = string.sub(str,i,i)
        if ch == "\0" then
            if i >= 2 and string.sub(str,i-1,i-1) == ',' then
                strCurWorld = ' '
            end

            break
        end
        -- print("trim_num", trim_num, "x", math.floor(trim_num % 2)) 

        local is_add_ch = true
        if ch == ',' and math.floor(trim_num % 2) == 0 then
            is_add_ch = false
            table.insert(result, strCurWorld)
            strCurWorld = ""
            trim_num = 0
        elseif ch == '"' then
            trim_num = trim_num + 1
            local next_ch = string.sub(str,i+1, i+1)
            if next_ch ~= '"' then
                is_add_ch = false
            end
        end

        if is_add_ch then
            strCurWorld = strCurWorld .. ch
        end
    end

    if strCurWorld ~= "" then
        table.insert(result, strCurWorld)
    end

    return result
end

function CSVLoader:getData(key,value)
    for i,v in ipairs(self.data) do
        for x,y in pairs(v) do
            if x == key and y == value then
                return v    --返回符合条件的第一行
            end
        end
    end
end

function CSVLoader:print()

    print("CSVLoader:print", json.encode(self.data))
    for k, v in pairs(self.data) do  
        print(k .. " : " .. json.encode(v))

        -- for x,y in pairs(v) do
        --     print(x .. " : " .. y)
        -- end
    end

end

function CSVLoader:getIndex(key)
    for i,v in ipairs(self.keys) do
        if v == key then
            return i
        end
    end
    return 0
end

function CSVLoader:getIndexString(key)
    print("CSVLoader:getIndexString", json.encode(self.keys))
    for i,v in pairs(self.keys) do
        if v == key then
            return i
        end
    end
    return 0
end

function CSVLoader:reload()
    fileData = cc.FileUtils:getInstance():getStringFromFile(self.file_name)
    print("self.file_name", self.file_name)
    if string.len(fileData) <= 0 then
        print("ERROR : CSVLoader load file ", self.file_name , "not found")
    end

    local lineStr = self:splist(fileData, '\n\r')

    --print("lineStr" , json.encode(lineStr) )
    local key_list = clone(self:rowParse(lineStr[1], ","))
    --print("key_list" , json.encode(key_list))

    for i,v in ipairs(key_list) do
        --print("key_list.v", v)
        self.keys[i] = v
    end

    local main_index = self:getIndex(self.main_key)
    for i,v in ipairs(lineStr) do
        if i>=2 then
            local va = self:rowParse(v, ",")

            local tmp_main_key = va[main_index]
            --self.data[i-1] = va
            --print("va", va, "tmp_main_key", tmp_main_key, "va", json.encode(va), "main_index", main_index)
            self.data[tmp_main_key] = va
            -- for j,b in ipairs(va) do
            --     self:data[i-1][keys[j]] = b
            -- end
        end
    end
    self:reloadDone()
    --print("self.data = ", json.encode(self.data))
    --self:print()
end

function CSVLoader:reloadNoFormat()
    fileData = cc.FileUtils:getInstance():getStringFromFile(self.file_name)
    print("self.file_name", self.file_name)
    if string.len(fileData) <= 0 then
        print("ERROR : CSVLoader load file ", self.file_name , "not found")
    end

    local lineStr = self:splist(fileData, '\n\r')

    --print("lineStr", json.encode(lineStr) )
    local key_list = clone(self:rowParse(lineStr[1], ","))
    --print("key_list", json.encode(key_list))

    for i,v in ipairs(key_list) do
        self.keys[i] = v
    end

    local main_index = self:getIndex(self.main_key)
    for i,v in ipairs(lineStr) do
        if i>=2 then
            local va = self:rowParse(v, ",")
            local value = {}
            for i,v in ipairs(key_list) do
                value[v] = va[i]
            end
            self.data[tonumber(value[self.main_key])] = value
        end
    end
    self:reloadDone()
end


function CSVLoader:reloadDone()

end

function CSVLoader:loadData(idx, va)
    -- body
    -- print("idx =", idx, json.encode(keys), json.encode(va))

    for j,b in ipairs(va) do
        self.data[idx] = b
    end
end

function CSVLoader:removeTrim(str)
    local has_trim = false

    if str == nil then
        return str
    end

    -- 应该要在解析的时候进行处理。暂时先这样处理
    -- 处理""字符。  比如 -"7" 变成 7-   -"[{""900001"":1}]" 变成 [{"900001":1}]
    if string.sub(str,-1) == trim and string.sub(str, 1, 1) == trim then
        str = string.sub(str, 2, #str - 1)
        str = string.gsub(str, "\"\"", "\"")
    end
    return str
end

function CSVLoader:getConfig(key)

    if type(key) ~= "string" then
        key = tostring(key)
    end

    local result = nil

    local config = nil
    for k,v in pairs(self.data) do
        if k == key then
            config = v
            break
        end
    end

    if config then
        result = {}
        for index, value in ipairs(config) do
            result[self.keys[index]] = self:removeTrim(value)
        end
    end
     -- local trim_index = string.find(w, trim, 1, true)
     --        -- 没有找到字符则返回原字符
     --        print("1111trim_index = ", trim_index, w)
     --        if trim_index == nil then
     --            return
     --        end
     --        print("2222trim_index = ", w[1], trim_index, w)
    return result
end

function CSVLoader:parseJsonTable(key, str_item)
    local config =  self:getConfig(key)
    if config == nil then
        return {}
    end

    --ex.log(">>>>>>>>parseJsonTable: "..json.encode(config))

    local function func(value)
        local vec_result = {}
        local vec_json = json.decode(tostring(value))
        for i,v in ipairs(vec_json) do
            for k,num in pairs(v) do
                local temp = {}
                temp.item_type = tonumber(k)
                temp.item_num = num
                table.insert(vec_result, temp)
            end
        end

        --ex.out(vec_result)

        return vec_result
    end

    for k,v in pairs(config) do
        if k == str_item then
            return func(v)
        end
    end

    return {}
end

return CSVLoader
