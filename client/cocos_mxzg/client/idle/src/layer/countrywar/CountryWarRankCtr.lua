--[[
    func: 国战 - 排行榜
    版权所有:广州暗耀晶石网络信息科技有限公司
]]
local CountryWarRankCtr = class("CountryWarRankCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local CountryWarRankLayer = class("CountryWarRankLayer", require("src.comp.EventLayerAdaptiveWidth"))

local CountryWarRankCell = class("CountryWarRankCell", require("src.comp.LuaLayerBase"))
local CountryWarRankRewardCell = class("CountryWarRankRewardCell", require("src.comp.LuaLayerBase"))

local RANK_TYPE = {
    RANK= 1,                    -- 排行榜                     
    HERO_RANK = 2,              -- 英雄排行
    DIE_ENEMY_RANK = 3,         -- 杀敌排行     
    HURT_RANK = 4,              -- 伤害排行
}
--对应后端的字段
local RANK_TYPE_NUM = {
    28,                    -- 排行榜                     
    29,                    -- 英雄排行
    30,                    -- 杀敌排行     
    31,                    -- 伤害排行
}

local LAYER_TYPE = {
    RANK= 1,                     -- 排行榜  
    RANK_REWARD = 2,             -- 排行榜奖励  
}
function CountryWarRankCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    ex.Tools:setLimitWidth(self.lbl_server_name, 100)
    ex.Tools:setLimitWidth(self.lbl_name, 190)
end

function CountryWarRankCell:initData(data, type, scroll_view)
    if data == nil or data.rank == nil then
        return
    end

    --拿取数据
    local rank = data.rank
    local server_id = data.server_id
    local palyer_name = data.name
    if not data.name then
        palyer_name = data.occupy_count 
    end
    local score = 0
    if data.score ~= nil then
        score = data.score
    elseif data.occupy_count ~= nil then
        score = data.occupy_count
    elseif data.kill ~= nil then
        score = data.kill
    elseif data.damage ~= nil then
        score = data.damage
    end
   
    --展示数据
    self.lbl_rank:setString(rank)
    self.lbl_server_name:setString(string.format(ex.Tools:getLang(55601),ex.StringUtil.getServerName(server_id)))
    self.lbl_name:setString(palyer_name)
    self.lbl_num:setString(score )
    self.lbl_num_time:setVisible(false)
    if data.hour_score ~= nil then
        self.lbl_num_time:setVisible(true)
        self.lbl_num_time:setString(string.format("(%s/h)",data.hour_score ))
        self.lbl_num:setPositionX(self.lbl_num_time:getPositionX() - self.lbl_num_time:getContentSize().width - self.lbl_num:getContentSize().width / 2)
    end
    if self.spr_rank ~= nil then
        self.spr_rank:setVisible(false)
        self.lbl_rank:setVisible(true)
        self.lbl_rank:enableShadow(FONT_BLACK_C4B, cc.size(1, -1))
        if data.rank > 0 and data.rank < 4 then 
            self.spr_rank:setVisible(true)
            self.lbl_rank:setVisible(false)
            self.spr_rank:setSpriteFrame(string.format("rank/spr-paihang-%s.png", data.rank))
        end
              
        if data.rank > 0 then
            self.lbl_rank:setString(string.format("%d", data.rank))
            self.lbl_rank:setScale(0.5)
        else
            self.lbl_rank:setString(ex.Tools:getLang(52012))
            self.lbl_rank:setScale(0.3)
        end
    end
    ex.Tools:setLimitWidth(self.lbl_rank, 50)

end
--------------------------------------------------------------------------------------------------------------------------------

function CountryWarRankRewardCell:onCreate(  )
    self.item_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()
	self.item_size = cc.size(self.item_size.width * ex.s.global_scale , self.item_size.height * ex.s.global_scale + 17 * math.max(1, ex.s.global_scale))
    self.reward_scroll_view:setItemSize(cc.size(self.item_size.width + 10 , self.item_size.height - 10))
    self.reward_scroll_view:setAlignmentCenter(true)
end

function CountryWarRankRewardCell:initData(data, scroll_view, rank)
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
        elseif data.rank_up >= 4 then
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

    if rank ~= nil then
        if rank > 0 then
            if rank >= 1 and rank <= 3 then
                self.spr_rank:setVisible(true)
                self.lbl_rank:setVisible(false)
                self.spr_rank:setSpriteFrame(string.format("rank/spr-paihang-%s.png", rank))
            else
                self.lbl_rank:setString(string.format("%d", rank))
            end  
        else
            self.spr_rank:setVisible(false)
            self.lbl_rank:setVisible(true)
            self.lbl_rank:setString(ex.Tools:getLang(52012))
            self.lbl_rank:setPositionX(self.spr_cell_bg:getContentSize().width / 2 - self.lbl_rank:getContentSize().width / 4)
            return
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

function CountryWarRankLayer:onCreate()
    -- self:setAutoClose(false)
    self:addBlackBackground()
    
    self.scroll_view:setItemSize(cc.size(544,115))
    self.scroll_view:setItemType(1)
    self:addEvent(EVENT.COUNTRY_WAR.UPDATE_RANK,handler(self,self.updateTableView))
    --设置文本
    self:setText()
    --初始化数据
    self:initdata()
end

function CountryWarRankLayer:setText( )

    self.btn_rank:setLabelText(ex.Tools:getLang(55523))
    self.btn_rank_reward:setLabelText(ex.Tools:getLang(55524))
    local lang_tab = {55523,55526,55528,55530}
    for i,v in ipairs(lang_tab) do
        self["btn_tab_"..i]:setLabelText(ex.Tools:getLang(v))
        ex.Tools:setLimitWidth(self["btn_tab_"..i]:getLabel(), 110)
    end
    ex.Tools:setLimitWidth(self.lbl_title, 150)
    ex.Tools:setLimitWidth(self.lbl_title_1, 90)
    ex.Tools:setLimitWidth(self.lbl_title_2, 140)
    ex.Tools:setLimitWidth(self.lbl_title_3, 160)
    ex.Tools:setLimitWidth(self.btn_rank:getLabel(), 90)
    ex.Tools:setLimitWidth(self.btn_rank_reward:getLabel(), 90)
    ex.Tools:setLimitWidth(self.lbl_rank_reward_title_1, 90)
        
end

function CountryWarRankLayer:initdata( )
    --设置选中的界面，
    self.cut_layer = 1
    self.btn_rank:setChecked(true)
    self.node_rank_title:setVisible(true)
    --设置选中的榜单
    self.cut_rank_layer = 1
    self.btn_tab_1:setChecked(true)
    self.node_rank_reward_title:setVisible(false)
    
end

--界面的切换
function CountryWarRankLayer:onCheckLayer(tag)
    if  self.cut_layer == tag then
       return
    end
    self.cut_layer = tag
    self:updateTableView()
end

--榜单的切换
function CountryWarRankLayer:onCheckRank(tag)
    if self.cut_rank_layer == tag then
        return
    end
    self.cut_rank_layer = tag
    ctr.country_war:gReqCountryWarRank(RANK_TYPE_NUM[tag])
end

function CountryWarRankLayer:updateTableView()
    self.node_rank_title:setVisible(self.cut_layer == LAYER_TYPE.RANK)
    self.node_rank_reward_title:setVisible(self.cut_layer == LAYER_TYPE.RANK_REWARD)
    if self.cut_rank_layer == 1 then
        self.lbl_title_3:setString(ex.Tools:getLang(55553))
    else
        self.lbl_title_3:setString(ex.Tools:getLang(55535))
    end
    
    local data_list = {};
    --排行数据
    data_list[LAYER_TYPE.RANK] = {};
    data_list[LAYER_TYPE.RANK][RANK_TYPE.RANK] = { data = ctr.country_war.data:getCountryWarRankInfo(RANK_TYPE.RANK), lang = ex.Tools:getLang(55525)}
    data_list[LAYER_TYPE.RANK][RANK_TYPE.HERO_RANK] = {data=ctr.country_war.data:getCountryWarRankInfo(RANK_TYPE.HERO_RANK), lang = ex.Tools:getLang(55527)}
    data_list[LAYER_TYPE.RANK][RANK_TYPE.DIE_ENEMY_RANK] = {data=ctr.country_war.data:getCountryWarRankInfo(RANK_TYPE.DIE_ENEMY_RANK), lang = ex.Tools:getLang(55529)}
    data_list[LAYER_TYPE.RANK][RANK_TYPE.HURT_RANK] = {data=ctr.country_war.data:getCountryWarRankInfo(RANK_TYPE.HURT_RANK), lang = ex.Tools:getLang(55531)}

    --修改每个榜单的奖励数据
    data_list[LAYER_TYPE.RANK_REWARD] = {};
    data_list[LAYER_TYPE.RANK_REWARD][RANK_TYPE.RANK] = {data = cfg.countrywarscorerankreward.countrywarscorerankreward, lang = ex.Tools:getLang(55525)}
    data_list[LAYER_TYPE.RANK_REWARD][RANK_TYPE.HERO_RANK] = {data = cfg.countrywarherorankreward.countrywarherorankreward, lang = ex.Tools:getLang(55527)}
    data_list[LAYER_TYPE.RANK_REWARD][RANK_TYPE.DIE_ENEMY_RANK] = {data = cfg.countrywarkillrankreward.countrywarkillrankreward, lang = ex.Tools:getLang(55529)}
    data_list[LAYER_TYPE.RANK_REWARD][RANK_TYPE.HURT_RANK] = {data = cfg.countrywardamagerankreward.countrywardamagerankreward, lang = ex.Tools:getLang(55531)}

    --显示数据
    self.scroll_view:getContainer():removeAllChildren()
    self.scroll_view.createItemFunction = function(data)
        local cell = nil
        if self.cut_layer == LAYER_TYPE.RANK then
            --排行榜界面，
            -- 创建ccbi cell
            cell = CountryWarRankCell:createWithCCBIFile("ccbi/CountryWarRankCell.ccbi")
            self.node_rank_title:setVisible(true)
            self.node_rank_reward_title:setVisible(false)
            --根据每个榜单修改数据
            self.lbl_title_4:setString(data_list[self.cut_layer][self.cut_rank_layer].lang)
            ex.Tools:setLimitWidth(self.lbl_title_4, 130)
            cell:setIgnoreAnchorPointForPosition(false)
            cell:setAnchorPoint(0.5, 0.5)
            cell:initData(data.ranks, data.rank_type, self.scroll_view)
            return cell
        elseif self.cut_layer == LAYER_TYPE.RANK_REWARD then
            -- 创建ccbi cell
            cell = CountryWarRankRewardCell:createWithCCBIFile("ccbi/CountryWarRankRewardCell.ccbi")
            --排行榜奖励界面
            self.node_rank_title:setVisible(false)
            self.node_rank_reward_title:setVisible(true)
            self.lbl_title_4:setString(data_list[self.cut_layer][self.cut_rank_layer].lang)
            ex.Tools:setLimitWidth(self.lbl_title_4, 130)
            cell:setIgnoreAnchorPointForPosition(false)
            cell:setAnchorPoint(0.5, 0.5)
            cell:initData(data, self.scroll_view)
            return cell
        end
    end
    self.scroll_view:reloadData(data_list[self.cut_layer][self.cut_rank_layer].data)
    --显示我的排行榜单数据
    if self.cut_layer == LAYER_TYPE.RANK  then
        local cell_self = CountryWarRankCell:createWithCCBIFile("ccbi/CountryWarRankCell.ccbi")
        cell_self:setPosition(10, 5)
        cell_self:setAnchorPoint(0, 0)
        local data = ctr.country_war.data:getCountryWarRankMyInfo(self.cut_rank_layer)
        if not data and #data == 0  then
            return
        end
        if data[1] then
            cell_self:initData(data[1].my)
        end
        self.spr_rank_bg_self:addChild(cell_self)
    elseif self.cut_layer == LAYER_TYPE.RANK_REWARD then
         --显示我的奖励榜单数据
         local my_rank = ctr.country_war.data:getCountryWarRankMyInfo(self.cut_rank_layer)
         if not my_rank or #my_rank == 0 then
             return
         end
         local reward_idx = 1
         for i,v in ipairs(data_list[self.cut_layer][self.cut_rank_layer].data) do
             if my_rank[1].my.rank <= v.rank_down and my_rank[1].my.rank >= v.rank_up then
                 reward_idx = v.idx
             end 
         end
         local cell_self  = CountryWarRankRewardCell:createWithCCBIFile("ccbi/CountryWarRankRewardCell.ccbi")
         cell_self:setPosition(10, 5)
         cell_self:setAnchorPoint(0, 0)
         cell_self:initData(data_list[self.cut_layer][self.cut_rank_layer].data[reward_idx], self.scroll_view, my_rank[1].my.rank)
         self.spr_rank_bg_self:addChild(cell_self) 
    end 
    local rank_num = data_list[self.cut_layer][self.cut_rank_layer].data
    self.is_rank_node:setVisible(not rank_num or #rank_num <= 0 )
  
end

-----------------------------------------------------------------------------
function CountryWarRankCtr:onCreate()
    self:setCCBIPath("ccbi/CountryWarRankLayer.ccbi")
    self:setIsSingle(false)
end

function CountryWarRankCtr:getLayerClass()
    return CountryWarRankLayer
end

function CountryWarRankCtr:getCountryWarRankLayer()
    return self.layer
end

function CountryWarRankCtr:openWindow()
    if self:isOpened() then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/rank.plist")

    self:loadLayer()
    self:open()
    self:initData()
end

function CountryWarRankCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
end

return CountryWarRankCtr
