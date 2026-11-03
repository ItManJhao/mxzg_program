local NoticeResponse = class("NoticeResponse")


function NoticeResponse:noticeAdd(data)
	-- GResMarquee
	-- {msg, force, id}

	-- local data = {}
	-- data.id = 85	
	-- data.idx = 211	
	-- data.msg = "<font color='#ef6b00'>純真的藏馬</font>在<font color='#ef6b00'>高級召喚</font>中獲得了5星英雄<font color='#ef6b00'>伊狸</font>！可喜可賀！"	
	-- data.params = {	"1016000662","3","10305021"}	

	-- add 熊梦 直接添加到跑马灯队列中，只有国战可以显示
	if data.idx == 211 or data.idx == 212 then
		if ex.MainSceneCtr:getCurLayerType() == MainSceneType.MAIN_COUNTRY_WAR or
		ex.MainSceneCtr:getCurLayerType() == MainSceneType.MAIN_COUNTRY_WAR_CITY then
			local config = cfg.notice.notice[data.idx]
			if config == nil then
				return
			end
			if ex.Player.battle_state then
				ex.Player.notice_data = nil
				ex.Player.notice_data = data
			else
				ex.MessageView:addNotice(data.msg, config.force, data.id, config.lamp_speed, config.click_jump, data.idx)
			end
		end
	-- 直接添加到跑马灯队列中，只有主场景可以显示
	elseif ex.MainSceneCtr:getCurLayer() ~= nil then
		local config = cfg.notice.notice[data.idx]
		if config == nil then
			return
		end
		ex.MessageView:addNotice(data.msg, config.force, data.id, config.lamp_speed, config.click_jump)
	end


end

return NoticeResponse