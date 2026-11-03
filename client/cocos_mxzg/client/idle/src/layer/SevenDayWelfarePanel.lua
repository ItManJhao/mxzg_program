local SevenDayWelfarePanel = class("SevenDayWelfarePanel", function ()
    return cc.Layer:create()
end)

--------------------------------------------

function SevenDayWelfarePanel:ctor()
    self.cell_data = {}
    self.first = true
    self.tableView = ex.Tools:initTableView(self,self.cell_data, {require("src.layer.SevenDayWelfareCell"),"ccbi/SevenDayWelfareCell.ccbi"} , cc.size(510,310), 5,cc.p(5.5,5),true)
    self:registerScriptHandler(handler(self,self.onNodeEvent))
    self:setContentSize(520.0,320.0)
    self:registerEvent()
end

-- function SevenDayWelfarePanel:initFont()
--     local color = self.lbl_old_price:getColor()
--     self.lbl_old_price_title:enableOutline(color, 1)
-- end

function SevenDayWelfarePanel:registerEvent()
    self.event_list = {

    }
end

function SevenDayWelfarePanel:updateData(data)
    if not data then return end
    if not self.tableView then return end
    self.tableView:initData(data)
end

function SevenDayWelfarePanel:removeEvent()
    if self.event_list ~= nil then 
        for k,v in pairs(self.event_list) do
            ex.EventManager:remove(v)
        end
    end
end

function SevenDayWelfarePanel:onNodeEvent(event)
    if event == "exit" then
        self:onExit()
    end
end

function SevenDayWelfarePanel:onExit()
    print("onExit",self.__cname)
    self:removeEvent()
end

return SevenDayWelfarePanel
