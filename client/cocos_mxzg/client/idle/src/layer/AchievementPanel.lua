local AchievementPanel = class("AchievementPanel", function ()
    return cc.Layer:create()
end)

--------------------------------------------

function AchievementPanel:ctor()
    -- self:setSwallowTouches(false)
    -- self:setAutoClose(false)
end

function AchievementPanel:initWithContentSize(size) 

    local cur_content_size = size
    self:setContentSize(cur_content_size)
    self.table_size = size
    -- self:testData()
    self.cell_data = ex.Player.achievement_data:getCurAchievementCfg()
    self:editData(self.cell_data)
    self.item_size = cc.size(540, 150)--require("src.layer.AchievementCell"):createWithCCBIFile("ccbi/DailyCell.ccbi"):getContentSize()
    self.tableView = ex.Tools:initTableView(self,self.cell_data, {require("src.layer.AchievementCell"),"ccbi/DailyCell.ccbi"} , cur_content_size, 5,cc.p(8,5))
    self:registerScriptHandler(handler(self,self.onNodeEvent))
    self:registerEvent()
end

function AchievementPanel:registerEvent()
    self.event_list = {
        ex.EventManager:add(EVENT.ACHIEVEMENT_EVENT.REWARD_RESULT,handler(self,self.getRewardResult))
    }
end

function AchievementPanel:getRewardResult(event,data)
    -- local offsetY = self.tableView:getContainer():getPositionY()
    local data = ex.Player.achievement_data:getCurAchievementCfg()
    self:editData(data)
    local num = table.nums(data)
    local cont_height = (self.item_size.height + 5) * num - 28
    self.tableView:initData(data)
    -- self.tableView:setContentOffset(cc.p(0,self.table_size.height - cont_height))
end

function AchievementPanel:editData(data)
    local function sor( a , b )
        local a_data = ex.Player.achievement_data:getAchievementServerDataById(a.idx)
        local b_data = ex.Player.achievement_data:getAchievementServerDataById(b.idx)
        local proA = a_data.state == 1 and 0 or 50
        local proB = b_data.state == 1 and 0 or 50
        proA = ex.Player.achievement_data:getAchievementIsRedById(a.idx) and 100 or proA
        proB = ex.Player.achievement_data:getAchievementIsRedById(b.idx) and 100 or proB
        if proA ~= proB then return proA > proB end 
        return a.idx < b.idx
        -- proA = 
    end
    table.sort(data,sor)
end
-- function AchievementPanel:testData( )
--         local data = {}
--         data.idx = 100100
--         data.process = 1
--         data.state = 0
-- 		ex.Player.achievement_data:updateTask(data)
--         ex.Player.achievement_data:setAchievementRedPoint(data)
        
--         local data1 = {}
--         data1.idx = 104100
--         data1.process = 1
--         data1.state = 0
-- 		ex.Player.achievement_data:updateTask(data1)
--         ex.Player.achievement_data:setAchievementRedPoint(data1)
--         ex.Player.achievement_data:checkAchievementRedPoint()
        
-- end

function AchievementPanel:removeEvent()
    if self.event_list ~= nil then 
        for k,v in pairs(self.event_list) do
            ex.EventManager:remove(v)
        end
    end
end

function AchievementPanel:onNodeEvent(event)
    if event == "exit" then
        self:onExit()
    end
end

function AchievementPanel:onExit()
    print("onExit",self.__cname)
    self:removeEvent()
end

function AchievementPanel:init(data)
    self.cell_data = data
    self:editData(self.cell_data)
    self.tableView:reloadData()
end

return AchievementPanel
