local CardTable = class("CardTable", require("src.config.CSVLoader"), require("src.common.SingleInstance"))

CardTable.file_name = "config/cardtype.csv"
CardTable.main_key = "idx"

-- 这个表做特殊处理
local CardConfig = {card_type = nil,
                    rare = nil,
                    equip_place = nil,
                    map_ability = {}}

local CardStarData = {star = nil,
                      upstar_need = nil,
                      type = nil,
                      num = nil}


function CardTable:ctor()
    self.data = clone({})
    self.keys = clone({})
end

function CardTable:reload()
    fileData = cc.FileUtils:getInstance():getStringFromFile(self.file_name)
    local lineStr = self:splist(fileData, '\n\r')
    self.keys = self:splist(lineStr[1], ",")

    local main_index = self:getIndex("card_type")
    for i,v in ipairs(lineStr) do
        if i>=2 then
            local va = self:splist(v, ",")
            local config = self.data[va[main_index]]
            if config == nil then
                local key = va[main_index];
                self.data[key] = clone(CardConfig)
                config = self.data[key]
            end

            config.card_type = va[self:getIndex("card_type")]
            config.rare = va[self:getIndex("rare")]
            config.equip_place = va[self:getIndex("equip_place")]

            local data = clone(CardStarData)
            data.star = va[self:getIndex("star")]
            data.upstar_need = va[self:getIndex("upstar_need")]
            data.type = va[self:getIndex("type")]
            data.num = va[self:getIndex("num")]

            config.map_ability[data.star] = data
        end
    end
end

function CardTable:getConfig(card_type)
    card_type = tostring(card_type)
    local result = self.data[card_type]
    if result == nil then
        return nil
    end
    return result
end

function CardTable:getCardAbilityData(card_type, card_star)

    card_type = tostring(card_type)
    card_star = tostring(card_star)

    local result = self.data[card_type]

    if result == nil then
        return nil
    end

    local map_ability = result.map_ability[card_star]
    if map_ability == nil then
        return nil
    end

    return map_ability
end

function CardTable:getCardStarMax(card_type)
    local star_max = 0
    local result = self.data[card_type]
    if result == nil then
        return star_max
    end

    for index, value in ipairs(result.map_ability) do
        if value.star > star_max then
            star_max = value.star
        end
    end

    return star_max
end


function CardTable:getCardStarMin(card_type)
    local star_min = 99
    local result = self.data[card_type]
    if result == nil then
        return star_min
    end

    for index, value in ipairs(result.map_ability) do
        if value.star < star_min then
            star_min = value.star
        end
    end
    return star_min
end


function CardTable:getNumByEquipPlace(equip_place)
    local star_min = 99
    local result = self.data[card_type]
    if result == nil then
        return star_min
    end

    for index, value in ipairs(result.map_ability) do
        if value.star < star_min then
            star_min = value.star
        end
    end
    return star_min
end


return CardTable