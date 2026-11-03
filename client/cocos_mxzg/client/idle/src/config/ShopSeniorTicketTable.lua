local ShopSeniorTicketTable = class("ShopSeniorTicketTable", require("src.config.CSVLoader"), require("src.common.SingleInstance"))

ShopSeniorTicketTable.file_name = "config/shopseniorticket.csv"
ShopSeniorTicketTable.main_key = "item_num"

function ShopSeniorTicketTable:ctor()
    self.data = clone({})
    self.keys = clone({})
end


return ShopSeniorTicketTable