--[[
* @Description: 异界冒险接受数据
* @Author: 熊梦
* @Date: 2020-07-29 15:18:00
* ]]
local ExoticAdventureResponse = class("ExoticAdventureResponse")

function ExoticAdventureResponse:adventureData(data)
	ex.Player.exotic_adventure_data:setExoticAdventureInfo(data)
end

function ExoticAdventureResponse:adventureFleetData(data)
	ex.Player.exotic_adventure_data:setExoticAdventureFleetInfo(data)
end

function ExoticAdventureResponse:modifyNick(data)
	ex.Player.exotic_adventure_data:setNick(data)
end

function ExoticAdventureResponse:repair(data)
	ex.Player.exotic_adventure_data:setDurability(data)
end

function ExoticAdventureResponse:upSkill(data)
	ex.Player.exotic_adventure_data:setSkill(data)
end

function ExoticAdventureResponse:startsailing(data)
	ex.Player.exotic_adventure_data:startsailing(data)
end

function ExoticAdventureResponse:setBackpack(data)
	ex.Player.exotic_adventure_data:setBackpack(data)
end

function ExoticAdventureResponse:setIllustratedBooks(data)
	ex.Player.exotic_adventure_data:setIllustratedBooks(data)
end

function ExoticAdventureResponse:updataIllustratedBooks(data)
	ex.Player.exotic_adventure_data:updataIllustratedBooks(data)
end

function ExoticAdventureResponse:setSailingEnd(data)
	ex.Player.exotic_adventure_data:setSailingEnd(data)
end

function ExoticAdventureResponse:updataSailingProgress(data)
	ex.Player.exotic_adventure_data:updataSailingProgress(data)
end

function ExoticAdventureResponse:setFleetExplore(data)
	ex.Player.exotic_adventure_data:setFleetExplore(data)
end

function ExoticAdventureResponse:setFleetQuitEvent(data)
	ex.Player.exotic_adventure_data:setFleetQuitEvent(data)
end

function ExoticAdventureResponse:setFleetEventOne(data)
	ex.Player.exotic_adventure_data:setFleetEventOne(data)
end

function ExoticAdventureResponse:setFleetEventTwo(data)
	ex.Player.exotic_adventure_data:setFleetEventTwo(data)
end

function ExoticAdventureResponse:setFleetEventThree(data)
	ex.Player.exotic_adventure_data:setFleetEventThree(data)
end

function ExoticAdventureResponse:setFleetEventFour(data)
	ex.Player.exotic_adventure_data:setFleetEventFour(data)
end

function ExoticAdventureResponse:setFleetEventFive(data)
	ex.Player.exotic_adventure_data:setFleetEventFive(data)
end

function ExoticAdventureResponse:setFleetEventSix(data)
	ex.Player.exotic_adventure_data:setFleetEventSix(data)
end

function ExoticAdventureResponse:setFleetEventSeven(data)
	ex.Player.exotic_adventure_data:setFleetEventSeven(data)
end

function ExoticAdventureResponse:setFleetEventEight(data)
	ex.Player.exotic_adventure_data:setFleetEventEight(data)
end

function ExoticAdventureResponse:setFleetEventNine(data)
	ex.Player.exotic_adventure_data:setFleetEventNine(data)
end

function ExoticAdventureResponse:setFleetEventTen(data)
	ex.Player.exotic_adventure_data:setFleetEventTen(data)
end

function ExoticAdventureResponse:setFleetEventEleven(data)
	ex.Player.exotic_adventure_data:setFleetEventEleven(data)
end

function ExoticAdventureResponse:setEnemyInfo(data)
	ex.Player.exotic_adventure_data:setEnemyInfo(data)
end

function ExoticAdventureResponse:setShopInfo(data)
	ex.Player.exotic_adventure_data:setShopInfo(data)
end

function ExoticAdventureResponse:setSailingInfo(data)
	ex.Player.exotic_adventure_data:setSailingInfo(data)
end

function ExoticAdventureResponse:setFleetGiftBuy(data)
	ex.Player.exotic_adventure_data:setFleetGiftBuy(data)
end

return ExoticAdventureResponse
