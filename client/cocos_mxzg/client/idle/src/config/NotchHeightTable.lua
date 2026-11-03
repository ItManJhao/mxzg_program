local NotchHeightTable = class("NotchHeightTable", require("src.config.CSVLoader"), require("src.common.SingleInstance"))

NotchHeightTable.file_name = "config/notchheight.csv"
NotchHeightTable.main_key = "type"

function NotchHeightTable:ctor()
    self.data = clone({})
    self.keys = clone({})
end


function NotchHeightTable:getHeight(device)
    local config = self:getConfig(device)
    if config and config.height then
        return config.height
    end
    return "0"
end

return NotchHeightTable