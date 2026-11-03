local HeroPrayerResponse = class("HeroPrayerResponse")


function HeroPrayerResponse:heroPrayerData(data)
	ex.Player.summon_data.is_buy_hero_prayer = data.privilege == 1
	ex.Player.summon_data.hero_prayer_end_time = data.end_time

	ex.EventManager:fire(EVENT.SUMMON.HEROPRAYER_UPDATE)
	ex.Player.summon_data:checkHeroPrayerRedDot()
end

function HeroPrayerResponse:heroPrayer(data)
	ex.EventManager:fire(EVENT.SUMMON.HEROPRAYER_UPDATE)
	
	ex.Player.summon_data:checkHeroPrayerRedDot()
end

return HeroPrayerResponse