local SevenDayTargetPanel = class("SevenDayTargetPanel", function ()
    return cc.Layer:create()
end)

--------------------------------------------

function SevenDayTargetPanel:ctor()
    self.cell_data = {}
    self.tableView = ex.Tools:initTableView(self,self.cell_data, {require("src.layer.SevenDayTargetCell"),"ccbi/SevenDayTargetCell.ccbi"} , cc.size(550,310), 5,cc.p(5.5,5),true)
    self:registerScriptHandler(handler(self,self.onNodeEvent))
    self:setContentSize(520.0,320.0)
    self:registerEvent()
end

function SevenDayTargetPanel:registerEvent()
    self.event_list = {

    }
end

function SevenDayTargetPanel:updateData(data)
    print(self.__cname,data[1].tag_lan)
    if not data then return end
    if not self.tableView then return end
    self.tableView:initData(data) 
end

function SevenDayTargetPanel:removeEvent()
    if self.event_list ~= nil then 
        for k,v in pairs(self.event_list) do
            ex.EventManager:remove(v)
        end
    end
end

function SevenDayTargetPanel:onNodeEvent(event)
    if event == "exit" then
        self:onExit()
    end
end

function SevenDayTargetPanel:onExit()
    self:removeEvent()
end

return SevenDayTargetPanel
