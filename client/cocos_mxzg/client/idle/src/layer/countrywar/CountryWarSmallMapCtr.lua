--[[
    func: 国战 - 小地图
    版权所有:广州暗耀晶石网络信息科技有限公司
]]
local CountryWarSmallMapCtr = class("CountryWarSmallMapCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local CountryWarSmallMapLayer = class("CountryWarSmallMapLayer", require("src.comp.EventLayerAdaptiveWidth"))

local CountryWarSmallMapServerRankCell = class("CountryWarSmallMapServerRankCell", require("src.comp.LuaLayerBase"))
local CountryWarRankRewardCell = class("CountryWarRankRewardCell", require("src.comp.LuaLayerBase"))

local LAYER_TYPE = {
    RANK= 1,                     -- 排行榜  
    RANK_REWARD = 2,             -- 排行榜奖励  
}
local RANK_TYPE = {
    28,
    29,
    30,
    31,
}

local flag = {
    [1] = "spr-green-flag",
    [2] = "spr-purple-flag",
    [4] = "spr-red-flag",
    [8] = "spr-yellow-flag",
}

function CountryWarSmallMapServerRankCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    ex.Tools:setLimitWidth(self.lbl_union, 60)
end

function CountryWarSmallMapServerRankCell:initData(data, scroll_view)
    if data == nil then
        return
    end

    --拿取数据
    local rank = data.rank                                    --排名
    local server_id = data.server_id                          --服务器id
    local scoccupy_countore = data.occupy_count               --占领城池数
    local score = data.score                                  --积分
    local hour_score = data.hour_score                        --积分/小时

    --展示数据
    self.lbl_server_name:setString(string.format(ex.Tools:getLang(55601),ex.StringUtil.getServerName(server_id)))
    ex.Tools:setLimitWidth(self.lbl_server_name, 80)
    self.lbl_union:setVisible(false)  
    local camp = ctr.country_war.data:getCamp(server_id)
    if camp[2] == 16 then   --是否联盟         
        self.lbl_union:setVisible(true)     
    end                         
    self.lbl_city_num:setString(scoccupy_countore)
    self.lbl_integral_num:setString(score)
    self.lbl_occupy_time:setString(string.format("(%d/h)", hour_score))
    ex.Tools:setSpriteFrame(self.spr_flg, string.format("countrywar/%s.png", flag[camp[1]]))
end
--------------------------------------------------------------------------------------------------------------------------------

function CountryWarRankRewardCell:onCreate(  )
    self.item_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()
	self.item_size = cc.size(self.item_size.width * ex.s.global_scale , self.item_size.height * ex.s.global_scale + 17 * math.max(1, ex.s.global_scale))
    self.reward_scroll_view:setItemSize(cc.size(self.item_size.width + 10 , self.item_size.height - 10))
    self.reward_scroll_view:setAlignmentCenter(true)
end

function CountryWarRankRewardCell:initData(data, scroll_view)
    if data == nil then
        return
    end
    if self.spr_rank ~= nil then
        self.spr_rank:setVisible(false)
        self.lbl_rank:setVisible(true)
        self.lbl_rank:enableShadow(FONT_BLACK_C4B, cc.size(1, -1))
        if data.rank_up > 0 and data.rank_down < 4 then 
            self.spr_rank:setVisible(true)
            self.lbl_rank:setVisible(false)
            self.spr_rank:setSpriteFrame(string.format("rank/spr-paihang-%s.png", data.rank_up))
        end
              
        if data.rank_up > 0 then
            self.lbl_rank:setString(string.format("%d~%d", data.rank_up, data.rank_down))
            self.lbl_rank:setScale(0.5)
            if data.rank_up == data.rank_down then
                self.lbl_rank:setString(string.format("%d", data.rank_up))
            end
        else
            self.lbl_rank:setString(ex.Tools:getLang(52012))
            self.lbl_rank:setScale(0.3)
        end
    end
    self.reward_scroll_view.createItemFunction = function(item_data, scale, index, pos)
        local item = nil
        if item_data ~= nil then
            item = ex.Tools:createBackpackItem(item_data.item_type,item_data.item_num)
            item:setScale(0.8)
            item:registerScriptTapHandler(handler(self, self.onItem))
        end
        return item
    end
    
    self.reward_scroll_view:reloadData(data.reward)  

end

function CountryWarRankRewardCell:onItem(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end


-------------------------------------------------------------------------------------------------

function CountryWarSmallMapLayer:onCreate()

    self.map_layer = nil
    -- self:setAutoClose(false)
    self:addBlackBackground()
    
    self.server_rank_scroll_view:setItemSize(cc.size(470,50))
    self.server_rank_scroll_view:setItemType(1)
    self.scroll_view:setItemSize(cc.size(460,115))
    self.scroll_view:setItemType(1)
    --设置文本
    self:setText()
    --初始化数据
    self:initdata()
    --刷新界面
    self:updateTableView()
end

function CountryWarSmallMapLayer:setText( )

    self.btn_rank:setLabelText(ex.Tools:getLang(55523)) 
    self.btn_rank_reward:setLabelText(ex.Tools:getLang(55524))
  
    --适配
    ex.Tools:setLimitWidth(self.lbl_title, 150)
    ex.Tools:setLimitWidth(self.lbl_title_1, 50)
    ex.Tools:setLimitWidth(self.lbl_title_2, 150)
    ex.Tools:setLimitWidth(self.lbl_title_3, 110)
    ex.Tools:setLimitWidth(self.lbl_title_4, 140)
    ex.Tools:setLimitWidth(self.btn_rank:getLabel(), 90)
    ex.Tools:setLimitWidth(self.btn_rank_reward:getLabel(), 90)
    ex.Tools:setLimitWidth(self.lbl_rank_reward_title_1, 75)
        
end

function CountryWarSmallMapLayer:initdata( )
    
    local tab_cities = ctr.country_war.data:getBigCities()
    local big_color = {
        cc.c4b(6, 57, 16,255),
        cc.c4b(95, 6, 114,255),
        cc.c4b(200, 34, 30,255),
        cc.c4b(153, 102, 4,255)
    }
    for k,v in pairs(tab_cities) do
        local camp = cfg.countrywarcity.countrywarcity[v.idx].camp
        self["spr_city_color_"..camp]:setColor(big_color[camp])
    end

    --设置选中的界面，
    self.cut_layer = 1
    self.btn_rank:setChecked(true)
    self.rank_node:setVisible(true)
    self.rank_reward_node:setVisible(false)
    self.server_rank_scroll_view:setTouchEnabled(false)
    self:addEvent(EVENT.COUNTRY_WAR.UPDATE_RANK,handler(self,self.updateTableView))   
    --刷新榜单信息
    self:updateTableView()
end

--界面的切换
function CountryWarSmallMapLayer:onCheckLayer(tag)
    if  self.cut_layer == tag then
       return
    end
    self.cut_layer = tag
    self:updateTableView()
end

function CountryWarSmallMapLayer:updateTableView()
    local city_data = ctr.country_war.data.cities
    local tab_server_data = ctr.country_war.data:getBigCities()

    local spr_color = {
        [tab_server_data[1].server_id] = cc.c4b(6, 57, 16,255),
        [tab_server_data[2].server_id] = cc.c4b(95, 6, 114,255),
        [tab_server_data[3].server_id] = cc.c4b(200, 34, 30,255),
        [tab_server_data[4].server_id] = cc.c4b(153, 102, 4,255),
    }

    local spr_path = {
        [tab_server_data[1].server_id] = "countrywar/spr-green.png",
        [tab_server_data[2].server_id] = "countrywar/spr-purple.png",
        [tab_server_data[3].server_id] = "countrywar/spr-red.png",
        [tab_server_data[4].server_id] = "countrywar/spr-yellow.png",
    }
   
    local city_offset = {
        cc.p(20,20),
        cc.p(0,35),
        cc.p(20,20),
        cc.p(0,35),
    }
    --是否有人上榜
    self.is_rank_node:setVisible(false)
    local rank_num = ctr.country_war.data:getSmallMapData()
    if not ctr.country_war.data:getSmallMapData() or #rank_num <= 0 then
        self.is_rank_node:setVisible(true)
    end

    -- 我的位置
    if cfg.countrywarcity.countrywarcity[ctr.country_war.data:getCurrId()].type == 1 then
        for k,v in pairs(tab_server_data) do
            if v.idx == ctr.country_war.data:getCurrId() then
                local camp = cfg.countrywarcity.countrywarcity[v.idx].camp
                self.spr_my_pos:setPosition(self["btn_city_"..k.."_server"]:getPositionX() + city_offset[camp].x,self["btn_city_"..k.."_server"]:getPositionY() + city_offset[camp].y)   
                break
            end
        end
    else
        self.spr_my_pos:setPosition(self["btn_city_"..ctr.country_war.data:getCurrId()]:getPositionX(), self["btn_city_"..ctr.country_war.data:getCurrId()]:getPositionY() + 20)
    end

    for k,v in pairs(city_data) do
        if v.shop_duration - ex.Game:getServerTime() > 0 then
            self.spr_small_map_shop:setPosition(self["btn_city_"..v.idx]:getPositionX(), self["btn_city_"..v.idx]:getPositionY() - 20)
        end
        if cfg.countrywarcity.countrywarcity[v.idx].type ~= 1 then
            self["spr_city_color_"..v.idx]:setVisible(v.server_id ~= 0)
            if v.server_id == 0 then
                ex.Tools:setAllGrayAuto(self["btn_city_"..v.idx]:getNormalImage(), true)
            else
                self["spr_city_color_"..v.idx]:setColor(spr_color[v.server_id])
                ex.Tools:setSpriteFrame( self["btn_city_"..v.idx]:getNormalImage(), spr_path[v.server_id])
            end
        end
    end
 
   self:showLayer()
end

-- 显示界面
function CountryWarSmallMapLayer:showLayer()
    if self.cut_layer == LAYER_TYPE.RANK then
        self.rank_node:setVisible(true)
        self.rank_reward_node:setVisible(false)
        self.server_rank_scroll_view:setVisible(true)
        self.scroll_view:setVisible(false)
        -- 创建ccbi cell 
        local data_list = {}
        data_list = ctr.country_war.data:getSmallMapData()
        self.server_rank_scroll_view:getContainer():removeAllChildren()
        self.server_rank_scroll_view.createItemFunction = function(data)
        local cell = CountryWarSmallMapServerRankCell:createWithCCBIFile("ccbi/CountryWarSmallMapServerRankCell.ccbi")
            cell:setIgnoreAnchorPointForPosition(false)
            cell:setAnchorPoint(0.5, 0.5)
            cell:initData(data, self.server_rank_scroll_view)
            return cell
        end
        self.server_rank_scroll_view:reloadData(data_list)
    elseif self.cut_layer == LAYER_TYPE.RANK_REWARD then
        self.rank_node:setVisible(false)
        self.rank_reward_node:setVisible(true)
        self.server_rank_scroll_view:setVisible(false)
        self.scroll_view:setVisible(true)
        local data_list = cfg.countrywarscorerankreward.countrywarscorerankreward
        -- 创建ccbi cell
        self.scroll_view:getContainer():removeAllChildren()
        self.scroll_view.createItemFunction = function(data)
        local cell = CountryWarRankRewardCell:createWithCCBIFile("ccbi/CountryWarRankRewardCell.ccbi")
            cell:setIgnoreAnchorPointForPosition(false)
            cell:setAnchorPoint(0.5, 0.5)
            cell:setScale(0.85)
            cell:initData(data, self.scroll_view)
            return cell
        end
        self.scroll_view:reloadData(data_list)
    end
end


function CountryWarSmallMapLayer:onJumpCity(tag)
   self.map_layer:onShowLastTile(tag)
   CountryWarSmallMapCtr:instance():closeWindow()
end

-----------------------------------------------------------------------------
function CountryWarSmallMapCtr:onCreate()
    self:setCCBIPath("ccbi/CountryWarSmallMapLayer.ccbi")
    self:setIsSingle(false)
end

function CountryWarSmallMapCtr:getLayerClass()
    return CountryWarSmallMapLayer
end

function CountryWarSmallMapCtr:getCountryWarRankLayer()
    return self.layer
end

function CountryWarSmallMapCtr:openWindow(map_layer)
    if self:isOpened() then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/rank.plist")
    self:loadLayer()
    self:open()

    self.layer.map_layer = map_layer
    self:initData()
end

function CountryWarSmallMapCtr:initData()
	ctr.country_war:gReqCountryWarRank(28)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
end

return CountryWarSmallMapCtr
