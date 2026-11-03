local AltarResponse = class("AltarResponse")


function AltarResponse:altarList(data)
    -- 
	-- local _, cur_layer = GetMainSceneLayer(MainSceneType.MAINCITY_ALTAR)
    -- if cur_layer then
    -- 	cur_layer:altarOK()
    -- end

    ex.EventManager:fire(EVENT.HERO_EVENT.ALTER_OK)


    ex.Player.hero_data:initRedPoint()
end

return AltarResponse