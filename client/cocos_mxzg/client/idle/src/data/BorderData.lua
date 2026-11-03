local BorderData = class("BorderData")

function BorderData:ctor()
    self.active_list = {}  --激活列表
    self.head_actice_list = {} --头像激活了列表
end

function BorderData:resetActiveList( )
    self.active_list = {}
end

function BorderData:setActiveData(data)
    self.active_list[data.id] = data.active_state == 1
end

function BorderData:borderActiveById(id)
    return self.active_list[id] == true
end


----头像
function BorderData:setHeadActiveById(id)
    self.head_actice_list[id] = true
end

function BorderData:resetHeadActiveList()
    self.head_actice_list = {}
end

function BorderData:headActiveById(id)
    return self.head_actice_list[id] == true
end

return BorderData
