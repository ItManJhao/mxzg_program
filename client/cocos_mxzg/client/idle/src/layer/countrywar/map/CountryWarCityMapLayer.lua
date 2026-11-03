--[[
    func: 国战 - 城市地图界面
    author:熊梦
    time:2021-04-13 10:16:44
    版权所有:广州暗耀晶石网络信息科技有限公司
]]
local CountryWarCityMapLayer = class("CountryWarCityMapLayer", require("src.comp.EventLayer"))

local MAX_USER = 20
function CountryWarCityMapLayer:onCreate()
    self.city_id = 0
    self.architecture_data = {}
    self.occupy_time = 0

    -- 城市用户信息
    self.city_user_data = {}
end

function CountryWarCityMapLayer:setCityid(city_id,architecture_data,city_user_data,occupy_time)
    self.city_id = city_id
    self.architecture_data = architecture_data
    self.city_user_data = city_user_data
    self.occupy_time = occupy_time

    if #self.city_user_data > MAX_USER then return end
    if self.city_id == 0 then return end

    self:inidata()
end

function CountryWarCityMapLayer:inidata()
      self.map = require("src.layer.countrywar.map.CountryWarCityMapBlockLayer"):create()
      self.map:loadWithFile(50,50,46,26,self.architecture_data,self.city_user_data,self.occupy_time)
      self.map:setTouchCallBack(handler(self, self.onPlayerInfo))      -- 点击回调

      -- 设置滑动视图属性
      self.scroll_view:getContainer():addChild(self.map)
      self.scroll_view:setContentSize(cc.size(self.map:getMapSize().width - self.map:getTileSize().width, self.map:getMapSize().height))
      self.scroll_view:setMinScale(0.5)
      self.scroll_view:setMaxScale(1)
      self.scroll_view:setShowMinScale(0.5)
      self.scroll_view:setShowMaxScale(1)
      self.scroll_view:setMoveSpeed(0.7)
      self.scroll_view:setDelegate()
  
      self:setFocusWithIdx(cc.p(1110,970))
end

function CountryWarCityMapLayer:setFocusWithIdx(pos)
    self:setFocus(cc.p(pos.x + self.map:getPositionX(), pos.y + self.map:getPositionY()))
end

function CountryWarCityMapLayer:setFocus(pos)
    local center = self.scroll_view:convertToWorldSpace(cc.p(self.scroll_view:getViewSize().width * 0.5, self.scroll_view:getViewSize().height * 0.5))
    local newCenter = self.scroll_view:getContainer():convertToWorldSpace(pos)
    local offset = self.scroll_view:getContentOffset()

    self.scroll_view:setContentOffset(cc.p(offset.x + (center.x - newCenter.x), offset.y + (center.y - newCenter.y)))
end

-- 玩家详细
function CountryWarCityMapLayer:onPlayerInfo(player_id,server_id)
    ex.Tools:showPlayerInfo(player_id,server_id)
end

-- 刷新页面信息
function CountryWarCityMapLayer:UpdateCityLayer(architecture_data, user_data, time)
    self.architecture_data = architecture_data

    self:UpdateCityUser(user_data)

    self.occupy_time = time
    self.map:setOccupyTime(self.occupy_time)
end

function CountryWarCityMapLayer:UpdateCityUser(user_data)
    self.city_user_data = user_data
    self.map:UpdateCityUser(self.city_user_data)
end

return CountryWarCityMapLayer