TableEx = {}

-- 查找某个值是否在table里面
TableEx.isInTable = function(tab, value)
	if not tab then
		return nil
	end

	local index = 1
	for k,v in pairs(tab) do
		if v == value then
			return index
		end
		index = index + 1
	end
	
	return nil
end

-- 将table 里面值为value1的全部替换成value2
TableEx.replace = function(tab, value1, value2)
	if not tab then
		return false
	end

	for i,v in ipairs(tab) do
		if v == value1 then
			tab[i] = value2
			return true
		end
	end

	return false
end

-- 查找某个值。callback返回true则停止查找
TableEx.isInTableFunction = function (tab, callback)
	if (not tab) or (not callback) then
		return false
	end

	for k,v in pairs(tab) do
		if callback(v) then
			return true
		end
	end

	return false
end

TableEx.findFunction = function(tab, callback)
	if (not tab) or (not callback) then
		return false
	end
	for k,v in pairs(tab) do
		if callback(v) then
			return true
		end
	end
	return false
end

-- 查找某个值。callback返回true则停止查找 返回值为被查找的值
TableEx.findValueFunction = function(tab, callback)
	if (not tab) or (not callback) then
		return nil
	end
	for k,v in pairs(tab) do
		if callback(v) then
			return v
		end
	end
	return nil
end


-- 查找某个值。callback返回true则停止查找 返回值为对应的下标
TableEx.getIndexFunction = function(tab, callback)
	if (not tab) or (not callback) then
		return -1
	end

	local index = 1
	for k,v in pairs(tab) do
		if callback(v) then
			return index
		end
		index = index + 1
	end
	return -1
end

-- 
TableEx.getTableByTag = function(tab, c)
	local result = {}
	if (not tab) or (not c) then
		return result
	end

	for k,v in pairs(tab) do
		if c(v) then
			table.insert(result, v)
		end
	end
	return result
end

-- 查找某个值。callback返回true则停止查找 返回值为对应的下标
TableEx.getIndexIpairsFunction = function(tab, callback)
	if (not tab) or (not callback) then
		return -1
	end
	for i,v in ipairs(tab) do
		if callback(v) then
			return i
		end
	end
	return -1
end

-- 将tab_src的属性复制给tab_des.没有的属性值才会赋值
TableEx.parasitize = function(tab_src, tab_des)
	for k,v in pairs(tab_src) do
		if not tab_des[k]  then
			tab_des[k] = tab_src[k]
		end
	end
end



-- 合并两个table
TableEx.mergeTables = function(...)
	local tabs = {...}
    if not tabs then
        return {}
    end
    local origin = tabs[1]
    for i = 2,#tabs do
        if origin then
            if tabs[i] then
                for k,v in pairs(tabs[i]) do
                    table.insert(origin,v)
                end
            end
        else
            origin = tabs[i]
        end
    end
    return origin
end

-- 将表中同类项合并
TableEx.mergeTableValue = function(tab, key, callback)
	local tmp_tab = {}
	for k,v in pairs(tab) do
		-- 寻找是否有相同节点的
		local tmp_v = TableEx.findValueFunction(tmp_tab, function(value)
				if v[key] == value[key] then
					return true
				end
			end)
		-- dump(tmp_v)
		if tmp_v then
			callback(tmp_v, v)
		else
			tmp_tab[k] = clone(v)
		end
	end
	return tmp_tab
end




-- 删除table表中符合callback的数据
-- 使用方法
-- vec_data = {{aa = 1}, {aa = 2},{aa = 1},{aa = 3} }
-- TableEx.removeTableData(vec_data, function( value )
-- 	if value.aa == 1 then
-- 		return true
-- 	end
-- end)
TableEx.removeTableData = function(tab, callback)
    if tab ~= nil and next(tab) ~= nil then
        for i = #tab, 1, -1 do
            if callback(tab[i]) then
                table.remove(tab, i)
            end
        end
    end
end


-- 删除table表指定范围的数据
TableEx.removeTableDataByIndex = function(tab, beg_index, end_index)
	-- 判断大小进行交换
	if beg_index > end_index then
		local tmp_v = beg
		beg_index = end_index
		end_index = tmp_v
	end

	for i=end_index,beg_index,-1 do
		table.remove(tab, i)
	end
end


-- 删除数组元素  quick 版本
TableEx.removeItem = function(list, item, removeAll)
	local rmCount = 0
	for i = 1, #list do
	  if list[i - rmCount] == item then
		table.remove(list, i - rmCount)
		if removeAll then
		  rmCount = rmCount + 1
		else
		  break
		end
	  end
	end
end

-- 去重
TableEx.unique = function(t) 
    local check = {}
    local n = {}
    for key , value in pairs(t) do
        if not check[value] then
            n[key] = value
            check[value] = value
        end
    end
    return n
end

-- 插入并去重
TableEx.insertAndUnique = function(t, s, func)
	for k,v in pairs(s) do
		local is_find = TableEx.findValueFunction(t, function(value)
			return func(value, v)
		end)
		table.insert(t, v)
	end
end 


--[[
提取二维table的指定字段值，并返回新的列表

params:
	t       : 源table
	colName : 需要提取的列名

sample:
	local t = {
		{ name = "XNan1", desc = "1111" },
		{ name = "XNan2", desc = "2222" },
		{ name = "XNan3", desc = "3333" },
		{ name = "XNan4", desc = "4444" },
	}
	res = TableEx.fields(t, "name")

	res -> { "XNan1", "XNan2", "XNan3", "XNan4" }
]]
TableEx.fields = function( t, colName, castFunc )
	r = {}
	
	for k,v in pairs(t) do
		if v[colName] ~= nil then
			table.insert( r, v[colName] )
		end
	end

	return r
end

--[[
根据字段列表提取字段值，并且返回一个新的table

sample:
	local t = {
		k1 = "v1",
		k2 = "v2",
		k3 = "v3",
		k4 = "v4"
	}
	local f = {'k1', 'k2'}
	res = TableEx.only(t, f)

	res -> {
		k1 = "v1",
		k2 = "v2"
	}
]]
TableEx.only = function(t, fields)
	res = {}
	
	for k,v in pairs(fields) do
		res[v] = t[v]
	end

	return res
end


TableEx.reverseTable = function(tab)
	if not tab then
		return nil
	end

	local tmp = {}
	for i = 1, #tab do
		local key = #tab
		tmp[i] = table.remove(tab)
	end
	return tmp
end


--[[1）选择一个基准元素,通常选择第一个元素或者最后一个元素,
2）通过一趟排序讲待排序的记录分割成独立的两部分，其中一部分记录的元素值均比基准元素值小。另一部分记录的 元素值比基准值大。
3）此时基准元素在其排好序后的正确位置
4）然后分别对这两部分记录用同样的方法继续进行排序，直到整个序列有序。--]]

function swap(i1, i2, arr)
	local tmp = arr[i2]
	arr[i2] = arr[i1]
	arr[i1] = tmp
end 

function partition(arr, low, high, compCb)
	-- local privotKey
	-- privotKey = arr[low]
	local privot = arr[low]
	while(low < high)do
		--从表的两端交替地向中间扫描,
		--从high 所指位置向前搜索 --将比基准元素小的交换到低端                                     
        while(low < high and compCb(arr[high], privot) == false ) do  
			high = high - 1
		end	
		swap(low,high,arr)
		--从low 所指位置向后搜索          
        while(low < high and compCb(arr[low], privot)  ) do 
			low = low + 1
		end 
		swap(low, high,arr)
	end 
	return low
end  


function quickSort(arr, low, high, compCb)
	if low < high then 
		local privotLoc = partition(arr,low, high, compCb);	--将表一分为二  
		quickSort(arr,low,privotLoc -1, compCb);          	--递归对低子表递归排序  
		quickSort(arr,privotLoc + 1, high, compCb);       	--递归对高子表递归排序  
	end 
end

TableEx.quickSort = function(tab, compCb)
	quickSort(tab, 1, #tab, compCb)
end