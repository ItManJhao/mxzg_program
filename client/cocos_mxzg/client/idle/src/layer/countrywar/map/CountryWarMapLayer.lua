--[[
    func: 国战 - 地图界面
    author:熊梦
    time:2021-04-13 10:16:44
    版权所有:广州暗耀晶石网络信息科技有限公司
]]
local CountryWarMapLayer = class("CountryWarMapLayer", require("src.comp.EventLayer"))

function CountryWarMapLayer:onCreate()
    self:registerEvent()
    
    self.choice_idx = ctr.country_war.data:getChoiceidx()  					   -- 选择的城市的id
   
    local architecture_data = cfg.countrywarcity.countrywarcity
    for k,v in pairs(architecture_data) do
        local data = cfg.countrywarcityrelation.countrywarcityrelation[v.idx]
        v.connect_city_id = data.connect_city_id
        v.x = data.x
        v.y = data.y
    end

    self.map = require("src.layer.countrywar.map.CountryWarMapBlockLayer"):create()
    self.map:loadWithFile(50,50,70,40,3500,2000,architecture_data)
    self.map:setTouchCallBack(handler(self, self.onTouchArchitecture))      -- 点击回调

    -- 设置滑动视图属性
    self.scroll_view:getContainer():addChild(self.map)
    self.scroll_view:setContentSize(cc.size(self.map:getMapSize().width - self.map:getTileSize().width, self.map:getMapSize().height))
    self.scroll_view:setMinScale(0.5)
    self.scroll_view:setMaxScale(1)
    self.scroll_view:setShowMinScale(0.5)
    self.scroll_view:setShowMaxScale(1)
    self.scroll_view:setMoveSpeed(0.7)
    self.scroll_view:setDelegate()

    self:onShowLastTile(self.choice_idx)
end

function CountryWarMapLayer:updataLayer()
    self.choice_idx = ctr.country_war.data:getChoiceidx()  					   -- 选择的城市的id
   
    local map_config = {}
    map_config.curr_id = ctr.country_war.data:getCurrId()
    map_config.cities = ctr.country_war.data.cities
    map_config.servers = ctr.country_war.data.servers
    map_config.server_id = ctr.country_war.data:getMainServer()

    self.map:updataMap(map_config)
end

function CountryWarMapLayer:registerEvent()
    -- self:addEvent(EVENT.COUNTRY_WAR.ALONE_CITY,handler(self,self.JumpCity))   -- 跳转到城内界面
end

function CountryWarMapLayer:onShowLastTile(id)
    if id == 0 or id == nil then return end
    self:setFocusWithIdx(nil, id)
end

function CountryWarMapLayer:setFocusWithIdx(n, idx)
    local city_info = cfg.countrywarcityrelation.countrywarcityrelation[idx]
    self:setFocus(cc.p(city_info.x + self.map:getPositionX(), city_info.y + self.map:getPositionY()))
end

function CountryWarMapLayer:setFocus(pos)
    local center = self.scroll_view:convertToWorldSpace(cc.p(self.scroll_view:getViewSize().width * 0.5, self.scroll_view:getViewSize().height * 0.5))
    local newCenter = self.scroll_view:getContainer():convertToWorldSpace(pos)
    local offset = self.scroll_view:getContentOffset()

    self.scroll_view:setContentOffset(cc.p(offset.x + (center.x - newCenter.x), offset.y + (center.y - newCenter.y)))
end

-- 跳转城市
function CountryWarMapLayer:JumpCity()
    ex.MainSceneCtr:runCloudAnimation(0.3, function()
        ex.MainSceneCtr:changeLayer(MainSceneType.MAIN_COUNTRY_WAR_CITY)
    end)
end

-------------------------------------------功能-----------------------------------------------------
-- 点击城市
function CountryWarMapLayer:onTouchArchitecture(idx)
    ctr.country_war.data:setChoiceidx(idx)
    if ctr.country_war.data:isOpen() then
        ctr.country_war:gReqCountryWarSmallCity(idx)
    end
    self:JumpCity()
end

return CountryWarMapLayer