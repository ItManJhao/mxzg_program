local CustomizedResponse = class("CustomizedResponse")

function CustomizedResponse:buyRecord(data)
    ex.Player.promotion_data.customized_data:setBuyRecord(data)
    ex.EventManager:fire(EVENT.CUSTOMIZED.UPDATE_BUY_RECORD_DATA)
end

function CustomizedResponse:customizedReward(data)
    ex.Player.promotion_data.customized_data:setCustom(data)
    ex.EventManager:fire(EVENT.CUSTOMIZED.UPDATE_CUSTOMIZED_ITEM)
end

return CustomizedResponse