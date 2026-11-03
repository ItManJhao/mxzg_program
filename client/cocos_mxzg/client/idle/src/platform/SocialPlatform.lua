local SocialPlatform = cpp.SocialPlatform:instance()


-- 这个文件不可以热更。请不要在这里添加新的代码
cpp.SocialPlatform:instance().pay = nil
cpp.SocialPlatform:instance().payConfirmLua = nil
cpp.SocialPlatform:instance().submitRoleInfoLua = nil
cpp.SocialPlatform:instance().updateExtraDataLua = nil


function SocialPlatform:pay(product_id, amount, info)
    
end


function SocialPlatform:payConfirmLua(json)
    local product_id = json.productId
    local bill_no = json.billNo
    local extra_info = json.extraInfo
    
    if (not product_id) or (not bill_no) then
        return
    end
    extra_info = extra_info or ""
    self:payConfirm(product_id, bill_no, extra_info)
end

function SocialPlatform:submitRoleInfoLua(type)
    self:updateExtraDataLua()
    self:submitRoleInfo(type)
end

function SocialPlatform:updateExtraDataLua()
    local guide_num = "1"
    local role_id = ex and ex.Player.role_id or "0"
    local role_name = ex and ex.Player.nick or "0"
    local role_level = ex and tostring(ex.Player.level) or "0"
    local server_id = tostring(cc.UserDefault:getInstance():getIntegerForKey("server_id", -1))
    local server_name = cc.UserDefault:getInstance():getStringForKey("server_name", "")
    local balance = ex and tostring(ex.Player.gold_num) or "0"
    local vip_level = 0 --ex and tostring(ex.Player.vip_level) or "0"
    local gem_num = ex and tostring(ex.Player.gem_num) or "0"
    local attack_num = ex and tostring(ex.Player.fighting) or "0"
    local extra_info = ""
    local clan_name = ex and ex.Player.clan_data.clan_name or "0"

    self:updateExtraData(guide_num,
                         role_id,
                         role_name,
                         role_level,
                         server_id,
                         server_name,
                         balance,
                         vip_level,
                         gem_num,
                         attack_num,
                         extra_info,
                         clan_name)
end

return SocialPlatform