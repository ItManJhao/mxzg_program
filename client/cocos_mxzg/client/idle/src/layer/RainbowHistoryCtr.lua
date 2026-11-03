--[[
    func: 彩虹圣殿挑战记录
    author:徐东浩
    time:2020-03-02 20:10:44
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local RainbowHistoryCtr = class("RainbowHistoryCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local RainbowHistoryLayer = class("RainbowHistoryLayer", require("src.comp.EventLayerAdaptiveWidth"))

local RainbowHistoryCell = class("RainbowHistoryCell", require("src.comp.LuaLayerBase"))
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

function RainbowHistoryCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.replay_callback = nil

    self.lbl_evolution = ex.Tools:createRichText(self, "", 20, false, cc.p(524, 118), CommonUIDefine.UIDefine.ComponentOriginType.LEFT_BOTTOM, "#784100", 1, ex.a.right_center)

    self.btn_replay:registerScriptTapHandler(handler(self, self.onReplay))
    self.item_scroll_view = require("src.comp.UIScrollViewBackpack"):createWithSize(self.item_bg:getContentSize())
    self.item_scroll_view:setPosition(cc.p(self.node_item:getPositionX(),self.node_item:getPositionY() - 40))
    self.item_scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    self.item_scroll_view:setItemOffset(cc.p(20, 0))
    self:addChild(self.item_scroll_view)

end

function RainbowHistoryCell:initData(data, replay_callback)
    self.data = data
    self.replay_callback = replay_callback

    self.lbl_name:setString(ex.Tools:getLang(54302)..self.data.battle_log.attacker_log.name)
    
    self.lbl_time:setString(os.date("%Y-%m-%d %H:%M:%S", self.data.time))
    
    self.lbl_power:setString(self.data.battle_log.attacker_log.fighting)

    self.lbl_evolution:setXmlTextLua(string.format(ex.Tools:getLang(54303), tostring(self.data.evolution)))

    local margin_x, cell_space, item_scale, n = 8, 3, 0.6, #self.data.battle_log.attacker_log.hero_log
    local node_item_size = self.node_item:getContentSize()
    local item_real_size = cc.size(0, 0)
    for i,v in ipairs(self.data.battle_log.attacker_log.hero_log) do
        local item = UIMenuItemHero:createWithData(v.hero_id, v.hero_type, cfg.herotype.star[v.hero_type].elem, v.level, v.star)
        item:setScale(item_scale)
        item:setEnableAction(false)
        
        item_real_size = item:getContentSize()
        item_real_size.width = item_real_size.width * item_scale
        item_real_size.height = item_real_size.height * item_scale

        item:setAnchorPoint(ex.a.center)
        item:setPosition(margin_x + (i - 0.5) * item_real_size.width + (i - 1) * cell_space + i * -2, node_item_size.height / 2)
        -- self.menu:addChild(item)
        self.item_scroll_view:addChild(item)

        -- self.item:registerScriptTapHandler(handler(self, self.onClickHero))
    end

    local content_size = cc.size(margin_x * 2 + n * item_real_size.width + (n - 1) * cell_space, node_item_size.height)
    -- self.node_item:setContentSize(content_size)
    -- self.item_bg:setPreferredSize(content_size)
end

function RainbowHistoryCell:onReplay(tag, pSender)
    if self.replay_callback then
        self.replay_callback(self.data.battle_id)
    end
end

---------------------------------------------------------------------
function RainbowHistoryLayer:onCreate()
    self:setAutoClose(true)
    self:setSwallowTouches(true)
end

function RainbowHistoryLayer:refreshData(list, replay_callback)
    local scroll_view_size = self.scroll_view:getViewSize()

    local cell_space = 4
    local item_real_size = cc.size(0, 0)
    for i,v in ipairs(list) do
        local cell = RainbowHistoryCell:createWithCCBIFile("ccbi/RainbowHistoryCell.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(ex.a.center)
        item_real_size = cell:getContentSize()

        local scale = math.floor(100 * (scroll_view_size.width / item_real_size.width)) / 100
        cell:setScale(scale)
        item_real_size = cc.size(item_real_size.width * scale, item_real_size.height * scale)
        
        if #list * item_real_size.height + (#list - 1) * cell_space > scroll_view_size.height then
            cell:setPosition(scroll_view_size.width / 2, (#list - i + 0.5) * item_real_size.height + (#list - i) * cell_space)
        else
            cell:setPosition(scroll_view_size.width / 2, scroll_view_size.height - (i - 0.5) * item_real_size.height - i * cell_space)
        end
        self.scroll_view:addChild(cell, 10)

        cell:initData(v, replay_callback)

        cell.menu:setIsTouchInsideNode(self.scroll_view)
        cell.menu:setSwallowsTouches(false)
    end

    self.scroll_view:setContentSize(scroll_view_size.width, math.max(#list * item_real_size.height + (#list + 1) * cell_space, scroll_view_size.height))
    self.scroll_view:setContentOffset(self.scroll_view:minContainerOffset())
end

-----------------------------------------------------------------------------
function RainbowHistoryCtr:onCreate()
    self:setCCBIPath("ccbi/RainbowHistoryLayer.ccbi")
    self:setIsSingle(false)

    self.data = {}
    self.id = 0
    self.is_dirty = true

    ex.EventManager:add(EVENT.RAINBOW_EVENT.RECEIVE_RECORD, handler(self, self.receiveData))
end

function RainbowHistoryCtr:getLayerClass()
    return RainbowHistoryLayer
end

function RainbowHistoryCtr:getRainbowHistoryLayer()
    return self.layer
end

function RainbowHistoryCtr:openWindow(id)
    if self:isOpened() then
        return
    end

    self.id = id
    self.is_dirty = true

    ex.Player.rainbow_data:reqRainbowRecord(self.id)
    
    self:loadLayer()
    self:open()
    self:initData()
end

function RainbowHistoryCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    if not self.is_dirty then
        self:refreshView()
    end
end

function RainbowHistoryCtr:refreshView()
    table.sort(self.data, function(a, b)
        if a.time ~= b.time then
            return a.time > b.time
        else
            return a.battle_log.battle_duration < b.battle_log.battle_duration  -- 避免时间相同导致的死循环
        end
    end)

    self.layer:refreshData(self.data, handler(self, self.onRecord))
end

function RainbowHistoryCtr:receiveData(e, data)
    if self.layer == nil then
        return
    end

    self.data = data
    self.is_dirty = false

    self:refreshView()
end

-- 开始挑战
function RainbowHistoryCtr:onRecord(battle_id)
    ex.EventManager:fire(EVENT.RAINBOW_EVENT.BATTLE_HISTORY_ON_REPORT, battle_id)

    self:closeWindow(0, nil)

    if require("src.layer.RainbowChallengeCtrl"):instance():isOpened() then
        require("src.layer.RainbowChallengeCtrl"):instance():closeWindow(0, nil)
    end
end

return RainbowHistoryCtr
