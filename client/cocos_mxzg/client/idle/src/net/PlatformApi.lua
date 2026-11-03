local PlatformApi = class("PlatformApi", function()
                                return cpp.PlatformApi:create() 
                            end)

local StringUtil = require("src.model.StringUtil")

function PlatformApi:ctor()
	self:retain()
	self:registerHandler(handler(self, self.onHttpEvent))
end

function PlatformApi:onHttpEvent(event, params1, params2, params3, params4)	
	if self[event] then  
		self[event](self, params1, params2, params3, params4)
	end
end

function PlatformApi:setCallback(callback)
	self.callback = callback
end

function PlatformApi:httpCallback(str_json)
	-- print("luaGetHttp", str_json)

	local vec_json = json.decode(str_json)

	local str_code = vec_json["cb"]
	str_code = string.sub(str_code, 12, string.len(str_code))

	local vec_str = StringUtil.decodeBase64(str_code)
	-- local vec_str = StringUtil.unicode_to_utf8(vec_str)

	local vec_str = string.gsub(vec_str, "\\/", "\\\\/")
	-- print("luaGetHttp", vec_str)

	vec_str = json.decode(vec_str)

	for k,v in pairs(vec_str) do
		vec_str[k] = v
	end
	
	if self.callback then
		self.callback(vec_str)
	end
end

function PlatformApi:luaSendGet(http_data)
	local vec_data = json.decode(http_data)

	local url = cfg.version.version[1].platform_urls
	-- local url = "http://192.168.0.184:8080"
	local vec_tmp = {}
	for k,v in pairs(vec_data) do
		if k == "action" then
			local str_tmp = StringUtil.splist(v, '.')
			url = url.."/"..str_tmp[1].."/"..str_tmp[2].."?"
		else
			local data = {}
			data.key = k
			data.value = v
			table.insert(vec_tmp, data)
		end
	end
	vec_data = vec_tmp

	local data = {}
	data.key = "time"
	data.value = cpp.Game:instance():getServerTime()--ex.Game:getServerTime()
    table.insert(vec_data, data)
	table.sort(vec_data, function (a, b)
		return a.key < b.key
	end)

	local str_url = ""
	local is_first = true
	for i,v in ipairs(vec_data) do
		if is_first == true then
			is_first = false
		else
			str_url = str_url.."&"
		end
		str_url = str_url..v.key.."="..v.value
	end

	print("luaSendGet", url..str_url)

	local data = {}
	data.key = "str"
	data.value = StringUtil.encodeBase64(str_url)
	data.value = StringUtil.getrandstr()..data.value

	url = url.."str="..data.value

	print(url)


	self:luaSendGetWithUrl(url)
end

function PlatformApi:luaSendPost(http_data)
	local vec_data = json.decode(http_data)

	local url = cfg.version.version[1].platform_urls
	-- local url = "http://192.168.0.184:8080"
	local vec_tmp = {}
	for k,v in pairs(vec_data) do
		if k == "action" then
			local str_tmp = StringUtil.splist(v, '.')
			url = url.."/"..str_tmp[1].."/"..str_tmp[2].."?"
		else
			local data = {}
			data.key = k
			data.value = v
			table.insert(vec_tmp, data)
		end
	end
	vec_data = vec_tmp

	local data = {}
	data.key = "time"
	data.value = cpp.Game:instance():getServerTime()--ex.Game:getServerTime()
    table.insert(vec_data, data)
	table.sort(vec_data, function (a, b)
		return a.key < b.key
	end)

	local str_url = ""
	local is_first = true
	for i,v in ipairs(vec_data) do
		if is_first == true then
			is_first = false
		else
			str_url = str_url.."&"
		end
		str_url = str_url..v.key.."="..v.value
	end

	print("luaSendPost", url..str_url)

	local data = {}
	data.key = "str"
	data.value = StringUtil.encodeBase64(str_url)
	data.value = StringUtil.getrandstr()..data.value

	url = url.."str="..data.value

	print(url)


	self:luaSendPostWithUrl(url)
end

return PlatformApi