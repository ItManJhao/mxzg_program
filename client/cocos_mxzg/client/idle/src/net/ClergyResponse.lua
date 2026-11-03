local ClergyResponse = class("ClergyResponse")

function ClergyResponse:handleUnlockClergyLevel(data)
	ex.Player.clergy_level = data.clergy_level

	ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.CLERGY_REFRESH_FOR_UP)
end

function ClergyResponse:handleClergyExpChange(data)
	ex.Player.clergy_exp = data.clergy_exp

	ex.Player.promotion_data:checkClergyPrivilegeRedDot()
	ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.CLERGY_REFRESH)
end

return ClergyResponse
