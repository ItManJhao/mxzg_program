--[[
* @Description: 冥域魔都接受数据
* @Author: 熊梦
* @Date: 2021-01-08 16:18:00
* ]]
local UnderworldPagodaResponse = class("UnderworldPagodaResponse")

-- 获取信息 GResHadesInfo
function UnderworldPagodaResponse:setUnderworldPagodaInfo(data)
	ex.Player.underworld_pagoda_data:setUnderworldPagodaInfo(data)
end

-- 挑战 GResHadesChallenge
function UnderworldPagodaResponse:getUnderworldPagodaChallenge(data)
	ex.Player.underworld_pagoda_data:getUnderworldPagodaChallenge(data)
end

-- 挑战 GResHadesSweep
function UnderworldPagodaResponse:getUnderworldPagodaSweep(data)
	ex.Player.underworld_pagoda_data:getUnderworldPagodaSweep(data)
end

-- 挑战 GResHadesRankList
function UnderworldPagodaResponse:getUnderworldPagodaRankList(data)
	ex.Player.underworld_pagoda_data:getUnderworldPagodaRankList(data)
end

return UnderworldPagodaResponse
