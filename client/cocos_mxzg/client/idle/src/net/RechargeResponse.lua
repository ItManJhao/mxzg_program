local RechargeResponse = class("RechargeResponse")

function RechargeResponse:rechargeOrder(data)
    -- local buy_config = cfg.buygem.buygem[data.idx]
    -- if not buy_config then
    --     ex.Tools:showDebugStatus(string.format(ex.Tools:getLang(47742), data.idx))
    --     return
    -- end
    local idx = data.idx
    local product_id = data.product_code
    local bill_no = data.order_id
    local extra_info = data.extra_info
    -- local str_error = json.error
    -- local str_type = json.type

    -- if str_type and tonumber(str_type) == 0 then
    -- 	ex.MessageView:add(ex.Tools:getLang(47041))
    -- 	return
    -- end
	print("device.platform", device.platform)

    if (not product_id) or (not bill_no) then
        return
	end

	if device.platform == "ios" then
		local price = 0
		for k,v in pairs(cfg.buygem.buygem) do
			if v.code == product_id then
				price = v.rmb / 100
				break
			end
		end

		-- 后端定义了透传参数格式
		-- 如果透传参数是json格式，则把BillNo，ProductId，RoleId 插入到json中
		-- 如果透传参数不是json格式，则透传参数变为{"ExtInfo":"XXXXXX"}
		local ext = {}
		ext.BillNo = tostring(bill_no)
		ext.ProductId = tostring(product_id)
		ext.RoleId = tostring(ex.Player.role_id)
		ext.RoleName = tostring(ex.Player.nick)
		ext.RoleLevel = tostring(ex.Player.level)
		ext.ExtInfo = tostring(extra_info)
		ext.ServerId = tostring(require("src.model.Game"):instance().server_id)
		ext.Price = tostring(price)
		ext.Idx = idx and tostring(idx) or nil
		ext.ProductName = ""
		ext.ProductNum = "1"
		cpp.SocialPlatform:instance():payConfirm(product_id, bill_no, json.encode(ext))
	else
		extra_info = extra_info or ""
		cpp.SocialPlatform:instance():payConfirm(product_id, bill_no, extra_info)
    end
    
    -- cpp.SocialPlatform:instance():payConfirm(data.product_code, data.order_id, data.extra_info)
end

return RechargeResponse