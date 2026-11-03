
local func = function()
    -- 初始化控制器
    if ctr ~= nil then
        -- ctr:clearAll()
        ctr = nil
    end
    ctr = require("src.ex.CtrMgr"):create()
end

local status, msg = xpcall(func, __G__TRACKBACK__)
if not status then
    print(msg)
end