local NewYearTaskLayer = class("HeroLayer", require("src.comp.EventLayer"))
local TASK_TYPE = {
    DAY = 1,
    WEEK = 2,
    QUICK = 3,
}

function NewYearTaskLayer:initCfg( )
    self.cfg = {}
    for i,v in ipairs(cfg.promotiontrafficpermit.task) do
        if not self.cfg[v.task_type] then self.cfg[v.task_type] = {} end 
        table.insert(self.cfg[v.task_type],v)
    end

    local function sor(a,b)
        return a.idx < b.idx
    end
    
    for i,v in ipairs(self.cfg) do
        table.sort( v, sor )
    end
end

function NewYearTaskLayer:onCreate()
    -- self:setBtnText()
    self:initCfg()
    self.cur_tag = 1
    self:registerBtnEvent()
    self:createTableView()
    self:setTabRedPoint()
    self:addEvent(EVENT.NEW_YEAR_ACTIVE.GET_TASK_REWARD,handler(self,self.onReward))
    self:addEvent(EVENT.NEW_YEAR_ACTIVE.UP_TASK_PROGRESS,handler(self,self.upTaskProgress))
end

function NewYearTaskLayer:setTabRedPoint( )
    local bool = ex.Player.promotion_data.new_year_data:getTaskByType()
    for i=1,3 do
        local tab = self["btn_" .. i]
        local bool = ex.Player.promotion_data.new_year_data:getTaskByType(i)
        ex.Tools:addRedPoint(tab,bool)
    end
end

function NewYearTaskLayer:upTaskProgress(event,data)
    self.cell_data = self:editData()
    local posY = self.table_view:getContainer():getPositionY()
    self.table_view:initData(self.cell_data)
    self.table_view:setContentOffset(cc.p(0,posY))
    self:setTabRedPoint()
end

function NewYearTaskLayer:onReward(evemt,data)
    self.cell_data = self:editData()
    self.table_view:initData(self.cell_data)
    self:setTabRedPoint()
end

function NewYearTaskLayer:registerBtnEvent( )
    for i=1,3 do
        local btn = self["btn_".. i]
        local str = ex.Tools:getLang(70604 + i)
        btn:setChecked(i == 1)
        btn:setLabelText(str)
        btn:registerScriptTapHandler(handler(self,self.onChangeLayer))
    end
end

function NewYearTaskLayer:onChangeLayer(tag,pSender)
    if self.cur_tag == tag then return end 
    self.cur_tag = tag 
    -- self.cell_data = self.cfg[self.cur_tag]
    self.cell_data = self:editData()
    self.table_view:initData(self.cell_data)
    ex.EventManager:fire(EVENT.NEW_YEAR_ACTIVE.CHANGE_TASK_TYPE,self.cur_tag)
end

function NewYearTaskLayer:createTableView( )
    self.cell_data = self:editData()
    local obj = {require("src.layer.newyear.NewYearTaskCell"), "ccbi/NewYearTaskCell.ccbi"}
    local size = self.spr_bg:getContentSize()
    size.width = size.width - 10
    size.height = size.height - 10
    self.table_view = ex.Tools:initTableView(self.spr_bg,self.cell_data, obj , size, 5 , cc.p(5,5))
end

function NewYearTaskLayer:editData( )
    local tmp = {}
    local task_list = ex.Player.promotion_data.new_year_data:getTaskList()
    for k,v in pairs(task_list) do
        local task_data = cfg.promotiontrafficpermit.task[k]
        if not task_data then print(self.__cname,k) end
        if task_data.task_type == self.cur_tag then 
            table.insert(tmp,task_data)
        end
    end


    local function sor( a , b )
        -- body
        -- local geted_a = ex.Player.promotion_data.new_year_data:getTaskById(a.idx) or false 
        -- local geted_b = ex.Player.promotion_data.new_year_data:getTaskById(b.idx) or false
        -- local proA = geted_a == true and 0 or 50
        -- local proB = geted_b == true and 0 or 50
        local condition_a = cfg.promotiontrafficpermit.task[a.idx].mission.target or 0
        local condition_b = cfg.promotiontrafficpermit.task[b.idx].mission.target or 0
        local proA = ex.Player.promotion_data.new_year_data:getTaskProgressById(a.idx) >= condition_a and 100 or 50
        local proB = ex.Player.promotion_data.new_year_data:getTaskProgressById(b.idx) >= condition_b and 100 or 50
        local geted_a = ex.Player.promotion_data.new_year_data:getTaskById(a.idx) or false 
        local geted_b = ex.Player.promotion_data.new_year_data:getTaskById(b.idx) or false
        proA = geted_a == true and 0 or proA 
        proB = geted_b == true and 0 or proB
        if proA ~= proB then return proA > proB end 
        return a.idx < b.idx
    end


    table.sort( tmp,sor )
    return tmp
end

return NewYearTaskLayer