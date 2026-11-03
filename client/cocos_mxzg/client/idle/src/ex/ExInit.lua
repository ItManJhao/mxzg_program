cc.exports.file_cache = {}

cc.exports.Load = function (name)
	local file = cc.exports.file_cache[name]
	if file then
		return require(file)
	end

	for _, root in ipairs(USER_CLASS_PATH) do
		local packageName = string.format("%s.%s", root, name)

		-- local view = require(packageName)
		local status, view = xpcall(function()
			local file =  require(packageName)
			--print("file", file)
			return file
		end, function(msg)
		end)

		local t = type(view)
		if status and (t == "table" or t == "userdata") then
--			ex.log("New " .. packageName)
			cc.exports.file_cache[name] = packageName
			return view
		end
	end
	ex.error("load view error: " .. name)
end


cc.exports.New = function (name, ...)
	local p = Load(name)
	if p then
		return p:create(...)
	else
		ex.log("create error: " .. name)
		return nil
	end
end

cc.exports.Instance = function (name)
	local p = Load(name)
	if p then
		return p:instance()
	else
		ex.log("Instance error: " .. name)
		return nil
	end
end

cc.exports.GetSystemResetTime = function()
	-- 每日重置时间 早上0点
    local reset_time = 0

    local sys_time = ex.Tools:getServerTimeWithUTC()
    local sys_h = os.date("%H",sys_time)
    local sys_m = os.date("%M",sys_time)
    local sys_s = os.date("%S",sys_time)
    sys_time = tonumber(sys_h) * 3600 + tonumber(sys_m) * 60 + tonumber(sys_s)

    if sys_time > reset_time then
        reset_time = 86400 - sys_time + reset_time
    else
        reset_time = reset_time - sys_time
    end

    return reset_time
end

-- 获取今日剩余时间
cc.exports.GetTodayRemainTime = function()
	local sys_time = ex.Tools:getServerTimeWithUTC()
    local sys_h = os.date("%H",sys_time)
    local sys_m = os.date("%M",sys_time)
	local sys_s = os.date("%S",sys_time)

	local passed = tonumber(sys_h) * 3600 + tonumber(sys_m) * 60 + tonumber(sys_s)

	return 86400 - passed
end

-- 获取指定时间之后的第几天
cc.exports.GetAfterDaysForTime = function (specific_time)
	-- local st_h = os.date("%H",specific_time)
    -- local st_m = os.date("%M",specific_time)
	-- local st_s = os.date("%S",specific_time)
	
	-- -- 恢复到指定时间的零点开始计算
	-- local start_time = specific_time - tonumber(st_h) * 3600 - tonumber(st_m) * 60 - tonumber(st_s)
	
	-- local passed = ex.Game:getServerTime() - start_time
	-- local days = math.floor(passed / 86400)

	-- local remainder = passed % 86400
	-- if remainder > 0 then
	-- 	days = days + 1
	-- end

	local days = Maths.getDays(specific_time) 
	local days_now = Maths.getDays(ex.Game:getServerTime()) 
	-- print("GetAfterDaysForTime", specific_time, ex.Game:getServerTime(), days)--, days_now)
	return days_now - days + 1
	-- return days

end

cc.exports.GetWeekResetTime = function()
	-- 每周重置时间 周一 早上4点
	local reset_time = 0
	local reset_day = 1

	local sys_time = ex.Game:getServerTime()
	local sys_h = os.date("%H",sys_time)
    local sys_m = os.date("%M",sys_time)
    local sys_s = os.date("%S",sys_time)

    local sys_w = tonumber(os.date("%w",sys_time)) -- 一星期中的第几天[0 - 6 = 星期天 - 星期六]
    if sys_w > reset_day then
    	reset_day = 7 - sys_w + reset_day
    else
    	reset_day = reset_day - sys_w
    end

    sys_time = tonumber(sys_h) * 3600 + tonumber(sys_m) * 60 + tonumber(sys_s)

    if sys_time > reset_time then
    	if reset_day == 0 then
    		reset_day = 7
    	end
        reset_time = reset_day * 86400 - sys_time + reset_time
    else
    	reset_time = reset_day * 86400 + reset_time - sys_time
    end

    return reset_time
end

cc.exports.GetMouthResetTime = function()
	-- 每月重置时间以30天固定时间计算
	local day30second = 30 * 24 * 60 * 60

	local sys_time = ex.Game:getServerTime()
	local mouth_in_second = (sys_time - ex.Player.server_create_time) % day30second

	return day30second - mouth_in_second
end

cc.exports.DeleteEqualElement = function(tb)
	local exist = {}
    --把相同的元素覆盖掉
    for _, k in pairs(tb) do
         exist[k] = true
    end
    --重新排序表
    local newTable = {}
    for v, k in pairs(exist) do
        table.insert(newTable, v)
     end
    return newTable
end

cc.exports.GetMainSceneLayer = function (scene_type)
	
	-- require()
	local main_ctr = ex.MainSceneCtr
	local main_scene = main_ctr:getMainScene()

    if main_ctr:getCurLayerType() ~= scene_type or
      (not main_scene) or
      (not main_ctr:getCurLayer())  then
    	return nil, nil
    end

    return main_scene, main_ctr:getCurLayer()
end


cc.exports.ex = {}

local output = function (s)
	if IS_ANDROID then
		luaprint(s)
	else
		print(s)
	end
end

ex.log = function (msg)
	if DEBUG ~= 0 then
		output(msg)
	end
end

ex.warn = function (str)
	if NO_WARNING == 0 then
		output("WARNING:" .. str)
	end
end

ex.error = function (str)
	output("ERROR:" .. str)
	error(str, 1)
end

ex.out_pairs = function (k, v, pre)
	if not pre then
		pre = " "
	end

	if type(v) == "table" then
		output(string.format("%s(%s:%s):table", pre, type(k), tostring(k)))
		for k1,v1 in pairs(v) do
			ex.out_pairs(k1, v1, pre .. "")
		end
	elseif type(t) ~= "userdata" then
		output(string.format("%s(%s:%s)=(%s:%s)", pre, type(k), tostring(k), type(v), tostring(v)))
	end
end

ex.out = function (t)
	if type(t) == "table" then
		output("--->")
		for k,v in pairs(t) do
			ex.out_pairs(k, v ," ")
		end
		output("<---")
	elseif type(t) ~= "userdata" then
		output(type(t) .. ":" .. tostring(t))
	end
end

ex.copy = function (t)
	if t == 'table' then
		local m = {}
		for k,v in pairs(t) do
			m[k] = v
		end
		return m
	else
		return t
	end
end

ex.call = function (func, ...)
	if func then
		func(...)
		return true
	end
	return false
end

ex.lock = function (data)
	local mt = {
		__index = function (t, key)
			error("locked visit: "..key, 2)
			return nil
		end,
		__newindex = function (t, key, value)
			printf(key .. "not set")
			error("locked set:" .. key, 1)
		end
	}
	setmetatable(data, mt)
	return data
end

-- fast color

ex.c3b = {}
	ex.c3b.WHITE	= cc.c3b(255, 255, 255)
	ex.c3b.YELLOW	= cc.c3b(255, 255,   0)
	ex.c3b.GREEN	= cc.c3b(  0, 255,   0)
	ex.c3b.BLUE		= cc.c3b(  0,   0, 255)
	ex.c3b.RED 		= cc.c3b(255,   0,   0)
	ex.c3b.MAGENTA	= cc.c3b(255,   0, 255)
	ex.c3b.BLACK 	= cc.c3b(  0,   0,   0)
	ex.c3b.ORANGE 	= cc.c3b(255, 127,   0)
	ex.c3b.GRAY   	= cc.c3b(166, 166, 166)
	ex.c3b.TAB_SLT	= cc.c3b(255, 255, 255)		-- 通用页面选项卡选中字体颜色（美术指定）
	ex.c3b.TAB_USLT	= cc.c3b(211, 225, 238)		-- 通用页面选项卡未选中字体颜色

ex.c3b = ex.lock(ex.c3b)

-- fast anchor
ex.a = {}

	ex.a.cx                 = 0.5
	ex.a.cy                 = 0.5
	ex.a.left               = 0
	ex.a.right              = 1.0
	ex.a.top                = 1.0
	ex.a.bottom             = 0
	ex.a.center             = cc.p(ex.a.cx, ex.a.cy)
	ex.a.left_top           = cc.p(ex.a.left, ex.a.top)
	ex.a.left_bottom        = cc.p(ex.a.left, ex.a.bottom)
	ex.a.left_center        = cc.p(ex.a.left, ex.a.cy)
	ex.a.right_top          = cc.p(ex.a.right, ex.a.top)
	ex.a.right_bottom       = cc.p(ex.a.right, ex.a.bottom)
	ex.a.right_center       = cc.p(ex.a.right, ex.a.cy)
	ex.a.top_center         = cc.p(ex.a.cx, ex.a.top)
	ex.a.bottom_center      = cc.p(ex.a.cx, ex.a.bottom)
	ex.a.zero				= cc.p(0, 0)

ex.a = ex.lock(ex.a)

local director = cc.Director:getInstance()
local winSize = director:getWinSize()

-- 预定义的size
ex.s = {}
	ex.s.full				= cc.size(winSize.width, winSize.height)
	ex.s.global_scale		= winSize.width / 640
	
ex.s = ex.lock(ex.s)

-- 常用红点位置
ex.r = {}
	ex.r.p8 = cc.p(0.8, 0.8)
	ex.r.p9 = cc.p(0.9, 0.9)
	ex.r.p92 = cc.p(0.92, 0.92)
	ex.r.p95 = cc.p(0.95, 0.95)
	ex.r.p1 = cc.p(1, 1)

	ex.r.p1_9 = cc.p(1, 0.9)
	ex.r.p9_1 = cc.p(0.9, 1)
ex.r = ex.lock(ex.r)

-- fast window size and position
ex.p = {}
	ex.p.width 				= winSize.width
	ex.p.height 			= winSize.height
	ex.p.cx                 = ex.p.width / 2
	ex.p.cy                 = ex.p.height / 2
	ex.p.left               = 0
	ex.p.right              = ex.p.width
	ex.p.top                = ex.p.height
	ex.p.bottom             = 0
	-- ex.p.center             = cc.p(ex.p.cx, ex.p.cy)
	-- ex.p.left_top           = cc.p(ex.p.left, ex.p.top)
	-- ex.p.left_bottom        = cc.p(ex.p.left, ex.p.bottom)
	-- ex.p.left_center        = cc.p(ex.p.left, ex.p.cy)
	-- ex.p.right_top          = cc.p(ex.p.right, ex.p.top)
	-- ex.p.right_bottom       = cc.p(ex.p.right, ex.p.bottom)
	-- ex.p.right_center       = cc.p(ex.p.right, ex.p.cy)
	-- ex.p.top_center         = cc.p(ex.p.cx, ex.p.top)
	-- ex.p.bottom_center      = cc.p(ex.p.cx, ex.p.bottom)
	ex.p.zero               = cc.p(0, 0)

	ex.p.center = function (x, y)
		x = x or 0
		y = y or 0
		return cc.p(ex.p.cx + x, ex.p.cy + y)
	end
	ex.p.left_top = function (x, y)
		x = x or 0
		y = y or 0
		return cc.p(ex.p.left + x, ex.p.top + y)
	end
	ex.p.left_bottom = function (x, y)
		x = x or 0
		y = y or 0
		return cc.p(ex.p.left + x, ex.p.bottom + y)
	end
	ex.p.left_center = function (x, y)
		x = x or 0
		y = y or 0
		return cc.p(ex.p.left + x, ex.p.cy + y)
	end
	ex.p.right_top = function (x, y)
		x = x or 0
		y = y or 0
		return cc.p(ex.p.right + x, ex.p.top + y)
	end
	ex.p.right_bottom = function (x, y)
		x = x or 0
		y = y or 0
		return cc.p(ex.p.right + x, ex.p.bottom + y)
	end
	ex.p.right_center = function (x, y)
		x = x or 0
		y = y or 0
		return cc.p(ex.p.right + x, ex.p.cy + y)
	end
	ex.p.top_center = function (x, y)
		x = x or 0
		y = y or 0
		return cc.p(ex.p.cx + x, ex.p.top + y)
	end
	ex.p.bottom_center = function (x, y)
		x = x or 0
		y = y or 0
		return cc.p(ex.p.cx + x, ex.p.bottom + y)
	end

ex.p = ex.lock(ex.p)


-- definition instance
ex.window_res = {}

ex.Game = cpp.Game:instance()
ex.AudioManager = require("src.model.AudioManager"):instance()

ex.EffectFactory = require("src.anim.EffectFactory"):instance()

-- 管理器相关
ex.EventManager = require("src.ex.EventManager"):create()
ex.Timer = require("src.ex.TimerManager"):create()
ex.JumpManager = require("src.ex.JumpManager"):create()
ex.EffectCtr = require("src.effect.EffectCtr"):create()
ex.ResponseManager = require("src.net.ResponseManager"):instance()
ex.MessageView = require("src.comp.MessageView"):instance()
ex.RedDotManager = require("src.model.RedDotManager"):instance()
ex.Tools = require("src.model.Tools"):create()
ex.Tools:resetLangKey()

-- 数据相关
ex.Player = require("src.data.Player"):instance()
ex.SocialPlatform = require("src.platform.SocialPlatform")
ex.PlatformHttpRequest = require("src.platform.PlatformHttpRequest"):instance()

-- 工具相关

ex.StringUtil = require("src.model.StringUtil")


-- 配置表相关
ex.ShopSeniorTicketTable = require("src.config.ShopSeniorTicketTable"):instance()
ex.BuyTimeTable = require("src.config.BuyTimeTable"):instance()
ex.MainCityTable = require("src.config.MainCityTable"):instance()

-- 界面相关
ex.ConfirmCtr = require("src.layer.ConfirmCtr"):instance()
ex.InfoCtr = require("src.layer.InfoCtr"):instance()
ex.MainSceneCtr = require("src.scene.MainSceneCtr"):instance()


-- cc.exports.ex = ex.lock(ex)