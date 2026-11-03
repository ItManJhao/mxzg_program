Maths = {}


-------------------------------数学-------------------------------
-- 最小值
Maths.min = function (x, y)
    if x > y then
       return y
    end
    return x
end

-- 距离
Maths.distance = function (x1, y1, x2, y2)
	return math.sqrt( math.pow((y2-y1), 2) + math.pow((x2-x1), 2))
end

-- 将数据保持在区间之内
Maths.clampf = function(value, min_inclusive, max_inclusive)
    if min_inclusive > max_inclusive then
        local tmp_value = min_inclusive
        min_inclusive = max_inclusive
        max_inclusive = tmp_value
    end    
    return value < min_inclusive and min_inclusive or (value < max_inclusive and value or max_inclusive)
end

--[[
    将弧度转换成角度
]]
Maths.radiansToDegrees = function(radians)
    return radians * 57.29577951 -- 180 / PI
end

-- 贝塞尔曲线
Maths.bezierat = function(a, b, c, d, t)
    return (math.pow(1-t,3) * a +
           3*t*(math.pow(1-t,2))*b + 
           3*math.pow(t,2)*(1-t)*c +
           math.pow(t,3)*d);
end

Maths.getIntersectPoint = function(pt1,pt2,pt3,pt4)
    local s,t, ret = 0,0,false
    ret,s,t = cc.pIsLineIntersect(pt1,pt2,pt3,pt4,s,t)
    if ret then
        return cc.p(pt1.x + s * (pt2.x - pt1.x), pt1.y + s * (pt2.y - pt1.y))
    else
        return cc.p(0,0)
    end
end

-- 判断线段跟矩形的交点
Maths.lineIntersectsRect = function(a, b, rect)
    -- pIsSegmentIntersect
    -- 将矩形变成4个线段。然后计算线段和线段的交点
    local lines = {
        {a = cc.p(rect.x, rect.y), b = cc.p(rect.x + rect.width, rect.y)},
        {a = cc.p(rect.x, rect.y), b = cc.p(rect.x , rect.y + rect.height)},
        {a = cc.p(rect.x, rect.y + rect.height), b = cc.p(rect.x + rect.width, rect.y + rect.height)},
        {a = cc.p(rect.x + rect.width, rect.y), b = cc.p(rect.x + rect.width, rect.y + rect.height)},
    }

    for i,v in ipairs(lines) do
        local is_intersect = cc.pIsSegmentIntersect(a, b, v.a, v.b)
        if is_intersect then
            return Maths.getIntersectPoint(v.a, v.b, a, b)
        end
    end
    
    return nil
end

Maths.getRotation = function(s, e)
    -- 计算出朝向
    local dx = e.x - s.x;
    local dy = e.y - s.y;
    local dir = cc.p(dx, dy);

    -- 根据朝向计算出夹角弧度
    local angle = cc.pGetAngle(dir, cc.p(1, 0)) --dir.signAngle(cc.v2(1,0));

    -- 将弧度转换为欧拉角
    local degree = angle / math.pi * 180;

    return degree
end

Maths.smoothDamp = function(current,
                            target,
                            currentVelocity,
                            smoothTime,
                            maxSpeed,
                            deltaTime)
    smoothTime = math.max(0.0001, smoothTime)
    local num = 2.0 / smoothTime
    local num2 = num * deltaTime
    local num3 = 1.0 / (1.0 + num2 + 0.48 * num2 * num2 + 0.235 * num2 * num2 * num2)
    local num4 = current - target
    local num5 = target
    local num6 = maxSpeed * smoothTime
    num4 = Maths.clampf(num4, -num6, num6)
    target = current - num4
    local num7 = (currentVelocity + num * num4) * deltaTime
    
    currentVelocity = (currentVelocity - num * num7) * num3
    
    local num8 = target + (num4 + num7) * num3

    local c1 = num5 - current > 0.0
    local c2 = num8 > num5
    if c1 == c2 then
        num8 = num5
        currentVelocity = (num8 - num5) / deltaTime
    end
    return num8, currentVelocity
end

-----------------------------时间-------------------------

-- 是否是同一天
Maths.isSameDay = function (timestamp1, timestamp2)
    local day1 = Maths.getDays(timestamp1) 
	local day2 = Maths.getDays(timestamp2) 
	if day1 == day2 then
		return true
	else
		return false;
	end	
end

-- 是否是润年
Maths.isLeap = function(year)
    if year%400 == 0 then
        return true
    end

    if year%100 == 0 then
        return false
    end

    if year%4 == 0 then
        return true
    end

    return false
end

-- 获取天数
Maths.getDays = function(time_stamp)
    local num = {0,31,28,31,30,31,30,31,31,30,31,30,31} -- 平年每月的天数 

    local time_data = os.date("*t", time_stamp)
    -- dump(time_data)
    local y = time_data.year - 1900
    local m = time_data.month
    local d = time_data.day

    y = y - 1
    local ret = 365*y + math.floor(y/4) - math.floor(y/100) + math.floor(y/400) + d
    for i=1,m-1 do
        ret = ret + num[i + 1]
        if i == 2 and Maths.isLeap(y + 1) then
            ret = ret + 1
        end
    end
    
    return ret
end

Maths.getOneDayPastTime = function (time)
    local seconds = 60
    local minutes = 60
    local hour = minutes * seconds

    local offset_utc = ex.Player.offset_utc
    local tab = os.date("!*t", time + offset_utc)
   
    return (tab.hour * hour + tab.min * seconds + tab.sec)
end

Maths.getOneDayRemainTime = function(time)
    local seconds = 60
    local minutes = 60
    local hour = minutes * seconds
    local day = 24 * hour
    return day - Maths.getOneDayPastTime(time)
end

-- 值选择
Maths.selection = function(value,...)
    local arg = {...}
    for i,v in ipairs(arg) do
        if value == v[1] then
            return v[2]
        end
    end
    return nil
end

-- 区间选择
Maths.section = function(value,...)
    local arg = {...}
    for i,v in ipairs(arg) do
        if value >= v[1] and value <= v[2] then
            return v[3]
        end
    end

    return nil
end


--[[
    r ： 半径
    eir ：排除的半径
]]
Maths.getHexRangeByRadius = function(x, y, r, eir)
    local result = {}


    for j=-r,r do
        -- if eir == nil or j > eir then
            local bx = -r + math.ceil(math.abs(j) / 2)
            local bl = r * 2 - math.abs(j)
            for i=bx, bx+bl do
                local is_continue = false
                if eir and math.abs(j) <= eir then
                    local ex = -eir + math.ceil(math.abs(j) / 2)
                    local el = eir * 2 - math.abs(j)
                    if i >= ex and i <= ex + el then
                        is_continue = true
                    end
                end

                if is_continue ~= true then
                    table.insert(result, cc.p(x + i, y + j))
                end
            end
        -- end
    end
    return result
end






