-- 读取proto文件，生成协议对应的协议号

local lfs = require "lfs"
local k_v_dir = require "ProtocolID2"

local sreach_paths = {}
table.insert(sreach_paths, "../client/idle/src")
-- table.insert(sreach_paths, "../client/idle/frameworks/runtime-src/Classes")

local exclude_path_pattern_strs = {}
table.insert( exclude_path_pattern_strs, "/config/")
table.insert( exclude_path_pattern_strs, "ProtocolID.lua")
table.insert( exclude_path_pattern_strs, "ProtocolID2.lua")

local allFilePath = {}

local number_pattern = "%d+"     -- 16001

function PrintCurrrentDir( ... )
    local rootPath = lfs.currentdir()
    print(rootPath)
end

function GetAllFiles(rootPath)
    for entry in lfs.dir(rootPath) do
        if entry~='.' and entry~='..' then
            local path = rootPath.."/"..entry
            local attr = lfs.attributes(path)
            assert(type(attr)=="table") --如果获取不到属性表则报错
            -- PrintTable(attr)
            if(attr.mode == "directory") then
                -- print("Dir:",path)
                GetAllFiles(path) --自调用遍历子目录
            elseif attr.mode=="file" then
                -- print(attr.mode,path)
                table.insert(allFilePath,path)
            end
        end
    end
end

function GetProtocolNameByID(id)
    for k,v in pairs(ProtocolID) do
        if v == tonumber(id) then
            return "ProtocolID."..k
        end
    end

    return nil
end

function IsFilterFile(file_path)
    for i,v in ipairs(exclude_path_pattern_strs) do
        if string.match(file_path, v) ~= nil then
            return true
        end
    end

    return false
end

PrintCurrrentDir()

for i,sreach_path in ipairs(sreach_paths) do
    print(">>>>>搜索目录:", sreach_path)
    
    allFilePath = {}
    GetAllFiles(sreach_path)
    print(">>>>>搜寻到文件"..#allFilePath.."个")
    
    local modified_files = {}
    local line_str_cur = ""
    
    local is_modified = false
    local cur_file_content = ""
    for n, file_path in ipairs(allFilePath) do
        if not IsFilterFile(file_path) then
            local file = io.open(file_path, "r+")
            print("+++++读取文件:", file_path)
            local line = 0
            while (true)
            do
                line_str_cur = file:read()
                
                if line_str_cur == nil then
                    print("=====文件读取完毕,读取行数:", line)
                    break
                end
                
                line = line + 1
                local line_temp = line_str_cur
                for match_num in string.gmatch(line_str_cur, number_pattern) do
                    print("=====line:"..line..", 匹配到数字:"..match_num)
                    local protocol_name = GetProtocolNameByID(match_num)
                    if protocol_name ~= nil then
                        print("#####替换协议号数字:"..match_num.." ->"..protocol_name)
                        line_temp = string.gsub(line_temp, tostring(match_num), tostring(protocol_name))
                        print("源字符串:"..line_str_cur)
                        print("替换后字符串:"..line_temp)
                        is_modified = true
                    else
                        print("~~~~~跳过非协议号数字:"..match_num)
                    end
                end
    
                cur_file_content = cur_file_content..line_temp.."\n"
            end
            file:close()
    
            if is_modified then
                local len = string.len("修改文件:") + string.len(file_path)
                print("┏━"..string.rep("━", len).."━┓")
                print("┃   修改文件:"..file_path.."   ┃")
                print("┗━"..string.rep("━", len).."━┛")
    
                new_file = io.open(file_path, "w+")
    
                new_file:write(cur_file_content)
    
                new_file:close()

                table.insert(modified_files, file_path)
            end

            cur_file_content = ""
            line_str_cur = ""
            is_modified = false
        else
            print("-----过滤文件:", file_path)
        end
    end

    for count, file_path in ipairs(modified_files) do
        local len = string.len("修改文件:") + string.len(file_path)
        print("██"..string.rep("█", len).."██")
        print("█  修改文件:"..count.."."..file_path.."  █")
        print("██"..string.rep("█", len).."██")
    end
    print("\n\n============================================================================================================================================================\n\n")
end
