local StringUtil = {}

StringUtil.unicode_to_utf8 = function(convertStr)

    if type(convertStr)~="string" then
        return convertStr
    end

    local bit = require("bit")
    local resultStr=""
    local i=1
    while true do
        
        local num1=string.byte(convertStr,i)
        local unicode
        
        if num1~=nil and string.sub(convertStr,i,i+1)=="\\u" then
            unicode=tonumber("0x"..string.sub(convertStr,i+2,i+5))
            i=i+6
        elseif num1~=nil then
            unicode=num1
            i=i+1
        else
            break
        end

        if unicode <= 0x007f then
            resultStr=resultStr..string.char(bit.band(unicode,0x7f))
        elseif unicode >= 0x0080 and unicode <= 0x07ff then
            resultStr=resultStr..string.char(bit.bor(0xc0,bit.band(bit.rshift(unicode,6),0x1f)))
            resultStr=resultStr..string.char(bit.bor(0x80,bit.band(unicode,0x3f)))
        elseif unicode >= 0x0800 and unicode <= 0xffff then
            resultStr=resultStr..string.char(bit.bor(0xe0,bit.band(bit.rshift(unicode,12),0x0f)))
            resultStr=resultStr..string.char(bit.bor(0x80,bit.band(bit.rshift(unicode,6),0x3f)))
            resultStr=resultStr..string.char(bit.bor(0x80,bit.band(unicode,0x3f)))
        end
    end
    resultStr=resultStr..'\0'
    return resultStr
end

-- string操作
-- https://blog.csdn.net/freecls/article/details/80264398
---从右侧遍历字符串，取指定字符的前后字符串
-- @param strurl  待解取字符串；
--        strchar 指定字符串；
--        bafter= true 取指定字符后字符串
-- @return 截取后的字符串
-- end --
StringUtil.segment = function(strurl, strchar, bafter)
    local symbol_index = string.find(strurl, strchar, 1, true)
    
    -- 没有找到字符则返回原字符
    if symbol_index == nil then
        return strurl
    end

    local str_len = string.len(strurl)
    if bafter then
        strurl = string.sub(strurl, symbol_index + 1)
    else
        strurl = string.sub(strurl, 1, symbol_index - 1)
    end
    return strurl
end

StringUtil.segmentLast = function(strurl, strchar)
    local last_index = StringUtil.findLast(strurl, strchar)
    if last_index == nil then
        return strurl
    end

    strurl = string.sub(strurl, last_index + 1, string.len(strurl))
    return strurl
end

StringUtil.findLast = function(str, strchar)
    local symbol_index = nil
    while true do
        local index = string.find(str, strchar, 1, true)
        if index == nil then
            break
        end

        str = string.sub(str, index + 1)
        symbol_index = symbol_index and symbol_index + index or index
    end

    -- print("symbol_index", symbol_index)
    return symbol_index
end

StringUtil.sign = function(vec_content)
    local md5 = require("src.lib.md5.md5")

    table.sort(vec_content, function(a, b) 
        return tostring(a.key) < tostring(b.key)
    end)

    local str_values = ""
    for i,v in ipairs(vec_content) do
        str_values = str_values..v.value
    end

    local str_md5 = md5.sumhexa(str_values)
    return str_md5
end

StringUtil.splist = function(str, reps)
    local result = {}
    string.gsub(str, '[^' .. reps ..']+', function(w) table.insert(result, w) end) 
    return result
end

StringUtil.splitStringIntoVector = function(str_token, str_src)
    local vec = {}
    local pos = nil
    str_src = ""..str_src..str_token    -- 扩展字符串以方便操作,截取最后一个子串
    local size = string.len(str_src)
    
    local index = 1
    for i=1,size do
        if index > size then
            break
        end
        pos = string.find(str_src, str_token, index, true)
        if pos <= size then
            local sub = string.sub(str_src, index, pos-index);
            table.insert(vec, sub)
            index = pos + string.len(str_token) - index + 1
        end
    end
    return vec
end

StringUtil.split = function(str, seg)
    local t = {}
    string.gsub(str,'[^'..seg..']+',function (s)
        table.insert(t,s)
    end)
    return t
end

StringUtil.segmentlast = function(strurl, strchar, bafter)
    local symbol_index = StringUtil.findLast(strurl, strchar)
    
    -- 没有找到字符则返回原字符
    if symbol_index == nil then
        return strurl
    end

    local str_len = string.len(strurl)
    if bafter then
        strurl = string.sub(strurl, symbol_index + 1)
    else
        strurl = string.sub(strurl, 1, symbol_index - 1)
    end
    return strurl
end


StringUtil.checkName = function(str)
    if (not str) or (#str) <= 0 then
        return false
    end

    local bad_char = {"/", ".", " ", ",", ":", "[", "]"}
    for k,v in pairs(bad_char) do
        local char_index = string.find(str, v, 1, true)
        if char_index ~= nil then
            return false
        end
    end
    return true
end

--截取中英混合的UTF8字符串，endIndex可缺省
StringUtil.subStringUTF8 = function(str, startIndex, endIndex)
    if startIndex < 0 or endIndex < 0 then
        return str
    end
    if endIndex == nil then
        return string.sub(str, StringUtil.subStringUTF8(str, startIndex));
    else
        return string.sub(str, StringUtil.subStringUTF8(str, startIndex), StringUtil.subStringUTF8(str, endIndex ) - 1);
    end
end


--获取字符串中在不超过一定字节的中文字节数
StringUtil.subStringLimitSize = function(str, index)
    local curIndex = 0;
    local i = 1;
    local lastCount = 1;
    repeat
        lastCount = StringUtil.subStringGetByteCount(str, i)
        i = i + lastCount;
        curIndex = curIndex + 1;
    until(i >= index);
    return i - lastCount;
end


--返回当前字符实际占用的字符数
StringUtil.subStringGetByteCount = function(str, index)
    local curByte = string.byte(str, index)
    local byteCount = 1;
    if curByte < 128 then
        return 1
    elseif curByte < 2048 then
        return 2
    elseif curByte < 65536 then
        return 3
    elseif curByte < 2097152 then
        return 4
    elseif curByte < 67108864 then
        return 5
    else
            return 6
    end
    return byteCount;
end

-- 将一个整数型时间转换成距离现在的时间有多久了
StringUtil.convertToHowLong = function(time)
    local units = StringUtil.getUnits(time)
    if time < 60 then
        return string.format("%d", time) .. units
    elseif time < 3600 then
        return string.format("%d", time / 60) .. units
    elseif time < 86400 then
        return string.format("%d", time / 3600) .. units
    else
        return string.format("%d", time / 86400) .. units
    end
    return ""
end

-- 配合上面的函数使用 text = convertToHowLong("%d", "%d", "%d", "%d")
StringUtil.getUnits = function(time)
    if time < 60 then
        return ex.Tools:getLang(47069)
    elseif time < 3600 then
        return ex.Tools:getLang(47292)
    elseif time < 86400 then
        return ex.Tools:getLang(47019)
    else
        return ex.Tools:getLang(47528)
    end
    return ""
end


StringUtil.convertToHowLongHour = function(time)
    local hour = math.floor(time / 3600)
    local minute = math.floor((time - (hour) * 3600) / 60)
    local second = time % 60
    if hour > 0 then
        return string.format(ex.Tools:getLang(47470), hour, minute)
    end
    return string.format(ex.Tools:getLang(47168), minute, second)
end

-- 
StringUtil.convertToTimeFormat = function(time, type)
    local day = math.floor(time / 86400)
    local hour = math.floor(time / 3600) - day * 24
    local minute = math.floor((time - (hour + day * 24) * 3600) / 60)
    local second = time % 60
    
    -- print(time, hour, minute, second)
    if type == nil then
        -- 有天数则显示天数。否则显示多少小时。多少分钟。多少秒
        if day > 0 then
            return string.format("%02d%s %02d:%02d:%02d", day, ex.Tools:getLang(31), hour, minute, second)
        end
        return string.format("%02d:%02d:%02d", hour, minute, second)
    elseif type == 2 then
        -- 只显示多少小时。多少分钟
        return string.format("%02d:%02d", hour, minute)
    elseif type == 3 then
        -- 只显示多少分钟。多少秒
        return string.format("%02d:%02d", minute, second)
    elseif type == 4 then
        -- 只显示两位
        if day > 0 then
            return string.format("%02d%s%02d%s", day, ex.Tools:getLang(31), hour, ex.Tools:getLang(32))
        elseif hour > 0 then
            return string.format("%02d%s%02d%s", hour, ex.Tools:getLang(32), minute, ex.Tools:getLang(33))
        else 
            return string.format("%02d%s%02d%s", minute, ex.Tools:getLang(33), second, ex.Tools:getLang(34))
        end
    elseif type == 5 then
        -- 有天数则显示天数。否则显示多少小时。多少分钟。多少秒
        return string.format("%02d:%02d:%02d", day * 24 + hour, minute, second)
    elseif type == 6 then
        -- 只顯示最大的一個時間刻度
        if day > 0 then
            return string.format(ex.Tools:getLang(1500), day)
        elseif hour > 0 then
            return string.format(ex.Tools:getLang(1501), hour)
        elseif minute > 0 then
            return string.format(ex.Tools:getLang(1502), minute)
        elseif second > 0 then
            return string.format(ex.Tools:getLang(1503), second)
        end
    end

    return ""
end

--字符串分割
-- StringUtil.splist = function(str, reps)
--     local result = {}
--     string.gsub(str, '[^' .. reps ..']+', function(w) table.insert(result, w) end) 
--     return result
-- end

--格式化属性描述
-- StringUtil.formatAttrStr = function( str , reps , value)
--     -- body
--     if not value then 
--         print("value is nil !")
--         value = ""
--     end
    
--     local strings = StringUtil.splist(str,reps)
--     local result = ""
--     if #strings == 1 then 
--         result = string.format(strings[1],value)
--         return result
--     end

--     for i,v in ipairs(strings) do
--         if i == 2 then 
--             if v == "i" then 
--                 result = result .. value
--             elseif v == "p" then 
--                 result = result .. (value / 100)
--             end
--         elseif i == 3 then 
--             result = result .. string.sub(v, 1,1)
--         else
--             result = result .. v
--         end
--     end
--     return result
-- end

StringUtil.getAttrNumBool = function(key, value)
    if key == "p" then
        return true
    end
    return false
end

StringUtil.formatAttrStrBool = function( str , reps, value)
    -- body
    if not value then 
        value = ""
    end

    local strings = StringUtil.splist(str,reps)

    if #strings == 1 then 
        return false
    end
    
    for i,v in ipairs(strings) do
        local index = (i - 1) % 2
        if index == 1 then
            return StringUtil.getAttrNumBool(v, value)
        end
    end
    return false
end

StringUtil.splistFull = function(str, seg)
    local t = {}
    for s in string.gmatch(str..seg, "(.-)"..seg) do
        table.insert(t, s)
    end
    return t
end

StringUtil.formatAttrStrNum = function( str , reps, value, colorStr)
    -- body
    if not value then 
        value = ""
    end

    local strings = StringUtil.splist(str,reps)
    local result = ""

    if #strings == 1 then 
        result = string.format(strings[1],string.format(colorStr,value )    )  
        return result
    end
    
    for i,v in ipairs(strings) do
        local index = (i - 1) % 2
        if index == 1 then
            result = result .. string.format(colorStr, StringUtil.getAttrNumOrder(v, value)) 
        else
            result = result .. v
        end
    end
    return result
end

StringUtil.getAttrNumOrder = function(key, value)
    if key == "p" then
        return string.format("%.1f", value / 100) .. "%"
    end
    return value
end




StringUtil.getAttrNum = function(key, value)
    if key == "p" then
        return string.format("%.1f", value / 100)
    end
    return value
end

StringUtil.formatAttrNum = function(str, value)
    local strings = StringUtil.splist(str, "##")
    if strings[1] == "p" then
        return string.format("%g", value / 100) .. (strings[2] ~= nil and strings[2] or "")
    end
    return value
end

--格式化属性描述
StringUtil.formatAttrStr = function( str , reps , value)
    -- body
    if not value then 
        print("value is nil !")
        value = ""
    end

    local strings = StringUtil.splistFull(str,reps)
    local result = ""

    if #strings == 1 then 
        result = string.format(strings[1],value)
        return result
    end
    
    for i,v in ipairs(strings) do
        local index = (i - 1) % 2
        if index == 1 then
            result = result .. StringUtil.getAttrNum(v, value)
        else
            result = result .. v
        end
    end
    return result
end

-- 数字添加单位,美式单位
StringUtil.getSimpleNumber = function(number)
    if number == nil or type(number) ~= "number" then
        return number
    end

    local num_b = math.floor(number / 1000000000)
    local num_m = math.floor(number % 1000000000 / 1000000)
    local num_k = math.floor(number % 1000000 / 1000)
    local num_o = math.floor(number % 1000)

    return num_b ~= 0 and num_b.."B" or num_m ~= 0 and num_m.."M" or num_k ~= 0 and num_k.."K" or num_o
end


StringUtil.getScientificNumber = function(number)
    if number == nil or type(number) ~= "number" then
        return number
    end

    -- number = 12345678903
    -- local num_b = math.floor(number / 100000000)
    -- local num_w = math.floor(number % 100000000 / 100000)
    -- local num_o = math.floor(number % 100000)
    local str = ""
    if number >= 100000000 then
        str = string.format(ex.Tools:getLang(47744), number / 100000000)
    elseif number >= 100000 then
        str = string.format(ex.Tools:getLang(47376), number / 10000)
    else
        str = tostring(number)
    end

    -- local str = 
    -- print("str", str, number)
    return str
end

StringUtil.getScientificNumberG = function(number)
    if number == nil or type(number) ~= "number" then
        return number
    end
    -- number = 12345678903
    -- local num_b = math.floor(number / 100000000)
    -- local num_w = math.floor(number % 100000000 / 100000)
    -- local num_o = math.floor(number % 100000)
    local str = ""
    if number >= 100000000 then
        local tmp_num = math.floor(number / 10000000)
        tmp_num = 1.0 * tmp_num / 10.0
        str = string.format(ex.Tools:getLang(5791), tmp_num)
    elseif number >= 100000 then
        local tmp_num = math.floor(number / 1000)
        tmp_num = 1.0 * tmp_num / 10.0
        str = string.format(ex.Tools:getLang(5790), tmp_num)
    else
        str = tostring(number)
    end

    -- local str = 
    -- print("str", str, number)
    return str
end

StringUtil.getServerName = function(server_id)
    if not server_id then
        return ""
    end
    
    local str_server_name = "[S"..server_id.."]"
    return str_server_name
end

StringUtil.encodeBase64 = function(source_str)
    local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    local s64 = ''
    local str = source_str

    while #str > 0 do
        local bytes_num = 0
        local buf = 0

        for byte_cnt=1,3 do
            buf = (buf * 256)
            if #str > 0 then
                buf = buf + string.byte(str, 1, 1)
                str = string.sub(str, 2)
                bytes_num = bytes_num + 1
            end
        end

        for group_cnt=1,(bytes_num+1) do
            local b64char = math.fmod(math.floor(buf/262144), 64) + 1
            s64 = s64 .. string.sub(b64chars, b64char, b64char)
            buf = buf * 64
        end

        for fill_cnt=1,(3-bytes_num) do
            s64 = s64 .. '='
        end
    end

    return s64
end

StringUtil.decodeBase64 = function(str64)
    local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    
    str64 = string.gsub(str64, '[^'..b..'=]', '')
    return (str64:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
            return string.char(c)
    end))
end

StringUtil.getrandstr = function()
    local str = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 
                 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 
                 '1', '2', '3', '4', '5', '6', '7', '8', '9', '0'}
    local str_rand = ""
    for i=1,11 do
        str_rand = str_rand..str[math.random(1, 62)]
    end
    return str_rand
end

return StringUtil

