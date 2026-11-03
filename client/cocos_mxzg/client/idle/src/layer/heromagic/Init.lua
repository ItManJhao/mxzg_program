--[[
    此文件夹下为英雄法阵功能相关

    包换功能界面类及数据结构体

    将在加载此文件夹时进行时间注册，静态变量注册，网络协议注册
]]

EVENT.HERO_MAGIC = {
	UPDATE_LAYER 		= "EVENT.HERO_MAGIC.UPDATE_LAYER",			-- 刷新主界面
}

HERO_MAGIC = {}
HERO_MAGIC.MAIGIC_NUM = 99

function main()
    local response_mgr = require("src.net.ResponseManager"):instance()

    -- response_mgr:addHandlerAuto(ProtocolID.GResRoleInfo, Role_pb.GResRoleInfo, require("src.net.RoleResponse").roleInfo)
end