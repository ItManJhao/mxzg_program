local AStar = class("AStar")

function AStar:ctor()
    self.start_pos = nil
    self.end_pos = nil

    self.vec_open = {}
    self.vec_close = {}

    self.width = 0
    self.height = 0

    self.search_callback = nil
    self.find_callback = nil
end

function AStar:findPath(star_id, end_id)
    
end

function AStar:countH(s, e)
    local w = math.abs(s.x - e.x);
    local h = math.abs(s.y - e.y);
    local cost = math.min(w,h)*self.height + math.abs(w-h)*self.width;
    return cost
    -- return 1
end

function AStar:countFGH(s, e, cost)
    local h = self:countH(s, e)
    local g = s.parent.g + cost
    local f = h + g
    s.f = f
    s.h = h
    s.g = g
end

-- 这个函数可能有问题
function AStar:isContains(vd, data)
    -- for i,v in ipairs(vd) do
    --     -- 这里需要改一下
    --     if v.data == data then
    --         return i
    --     end
    -- end
    -- return -1

    for i,v in ipairs(vd) do
        if v.x == data.x and v.y == data.y then
            return i
        end
    end

    return -1
end

-- 将最优结果与第一个结果交换
function AStar:sortOnce(vd)
    if table.nums(vd) <= 0 then
        return
    end

    local f = vd[1].f

    local base_index = nil
    for i,v in ipairs(vd) do
        if v.f < f then
            -- 交换数据,这里可以再优化一下。只取最优结果的下标，减少赋值次数
            -- local tmp_node = vd[1]
            -- vd[1] = v
            -- vd[i] = tmp_node
            base_index = i
        end
    end

    if base_index then
        local tmp_node = vd[1]
        vd[1] = vd[base_index]
        vd[base_index] = tmp_node
    end
end

function AStar:checkMove(data, parent, ends, cost, canmove)
    if canmove ~= true then
        return
    end

    if self:isContains(self.vec_close, data) ~= -1 then
        return
    end

    if data.x < 0 or data.x >= self.width or data.y < 0 or data.y > self.height then
        return
    end


    local index = -1
    index = self:isContains(self.vec_open, data)
    if index ~= -1 then
        local s_node = self.vec_open[index]
        if parent.g + cost < s_node.g then
            s_node.g = parent.g + cost
            s_node.f = s_node.g + s_node.h
        end
    else
        local n = {}
        -- n.data = data
        n.x = data.x
        n.y = data.y
        n.parent = parent
        self:countFGH(n, ends, cost)
        table.insert(self.vec_open, n)
    end
end

function AStar:printPath(n)
    -- if n.parent ~= nil then
    --     self:printPath(n.parent)
    -- end
    -- print(string.format("->%s, %s", n.x, n.y))
end

function AStar:printPathTable(n)
    for i,v in ipairs(n) do
        -- print("x = ", v.x, ", y = ", v.y)
        print(string.format("x = %s, y = %s", v.x, v.y))
    end
end

function AStar:getPath(n, v)
    if n.parent ~= nil then
        self:getPath(n.parent, v)
    end
    -- table.insert(v, n.data.node_id)
    table.insert(v, {x=n.x, y=n.y})
end

function AStar:startSearch(start, ends)
    start.h = self:countH(start, ends)
    start.f = start.h + start.g

    table.insert(self.vec_open, start)

    local root = nil
    local find = 0

    while table.nums(self.vec_open) > 0 do
        root = self.vec_open[1]

        if self.find_callback then
            find = self.find_callback(self, root, ends)
            if find == 1 then
                break
            end
        elseif root.x == ends.x and root.y == ends.y then
            find = 1
            break
        end

        if self.search_callback == nil then
            print("self.search_callback == nil")
            break
        end

        self.search_callback(self, root, ends)

        -- 开始检测
        -- self:checkMove({x=1, y=1}, root, ends, 1)
        -- self:checkMove({x=1, y=1}, root, ends, 1)
        -- self:checkMove({x=1, y=1}, root, ends, 1)
        -- self:checkMove({x=1, y=1}, root, ends, 1)
        -- self:checkMove({x=1, y=1}, root, ends, 1)


        -- for i,v in ipairs(root.data.vec_parent) do
        --     self:checkMove(v, root, ends, ~data.isActivate())
        -- end

        -- for i,v in ipairs(root.data.vec_child) do
        --     self:checkMove(v, root, ends, ~data.isActivate())
        -- end

        -- self.vec_close()
        table.insert(self.vec_close, root)
        table.remove(self.vec_open, 1)

        self:sortOnce(self.vec_open)
    end

    
    self.vec_open = {}
    self.vec_close = {}
    
    if find == 1 then
        local path = {}
        self:getPath(root, path)
        return path
    end

    return nil
end

return AStar