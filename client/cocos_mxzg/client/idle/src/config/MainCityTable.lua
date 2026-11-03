local MainCityTable = class("MainCityTable", require("src.config.CSVLoader"), require("src.common.SingleInstance"))

MainCityTable.file_name = "config/maincitypos.csv"
MainCityTable.main_key = "idx"

function MainCityTable:ctor()
    self.data = clone({})
    self.keys = clone({})
end


function MainCityTable:reloadDone()
	--dump(self.data)
end

return MainCityTable
