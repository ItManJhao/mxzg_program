local MailResponse = class("MailResponse")

function MailResponse:mailList(data)
	-- dump(data, "MailResponse:mailList")


	local vec_mail = {}
	for i, v in ipairs(data.list) do
		local mail_data = {}
		mail_data.mail_id = v.mail_id
		mail_data.time = v.time
		mail_data.is_read = v.is_read
		mail_data.is_receive = v.is_receive
		mail_data.str_title = v.str_title
		mail_data.str_content = v.str_content
		-- print("str_title, str_content, ", v.str_title, v.str_content)
		mail_data.vec_reward = {}
		for i,vd in ipairs(v.vec_reward) do
			local reward = {}
			reward.id = vd.id
			reward.item_type = vd.type
			reward.item_num = vd.num
			table.insert(mail_data.vec_reward, reward)
		end

		-- dump(mail_data.vec_reward, "mail_data.vec_reward")
		table.insert(vec_mail, mail_data)
	end

	ex.Player.mail_data.data = vec_mail
	ex.Player.mail_data.last_refresh_time = ex.Game:getServerTime()
	ex.Player.mail_data:sortMailIsRead()
	ex.Player.mail_data:addTimer()

	-- 更新邮件界面
	local mail_ctr = require("src.layer.MailCtr")
	if #data.list > 0 and  mail_ctr:instance():getLayer() then
		mail_ctr:instance():updateLayer()
	end

	ex.Player.mail_data:checkRedDot()
end

function MailResponse:mailDeal(data)

end

function MailResponse:newMail(data)
	-- 邮件
	NetManager:sendMessage(ProtocolID.GReqMailList)
end

function MailResponse:receiveAllMail(data)
	for i,v in ipairs(data.mail_ids) do
		local mail_data = ex.Player.mail_data:getMailData(v)
		if mail_data then
			mail_data.is_receive = 1
			mail_data.is_read = 1
		end
	end
	ex.EventManager:fire(EVENT.MAIL.UPDATE)
	ex.Player.mail_data:checkRedDot()
end

function MailResponse:deleteAllMail(data)
	for i,v in ipairs(data.mail_ids) do
		ex.Player.mail_data:delMailData(v)
	end

	ex.EventManager:fire(EVENT.MAIL.DELETE)
	ex.EventManager:fire(EVENT.MAIL.UPDATE)
	ex.Player.mail_data:checkRedDot()
end

return MailResponse