local BuyTimeTable = class("BuyTimeTable", require("src.config.CSVLoader"), require("src.common.SingleInstance"))

BuyTimeTable.file_name = "config/buytime.csv"
BuyTimeTable.main_key = "idx"

function BuyTimeTable:ctor()
    self.data = clone({})
    self.keys = clone({})
end


return BuyTimeTable
