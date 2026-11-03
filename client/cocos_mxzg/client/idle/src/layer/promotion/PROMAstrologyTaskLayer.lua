local PROMAstrologyTaskLayer = class("PROMAstrologyTaskLayer", require("src.layer.promotion.PromotionBaseLayer"))
local PROMAstrologyTaskCell = class("PROMAstrologyTaskCell", require("src.comp.LuaLayerBase"))

local ExTimer = require("src.ex.ExTimer")

function PROMAstrologyTaskCell:onCreate()
	self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.cur_show_hero = 0
    self.node = {}

    self.node[1] = {}
    self.node[1].node = self.node_1
    self.node[1].star = self.star_1
    self.node[1].btn = self.btn_receive1
    self.node[1].player = nil
    self.node[1].star:setLocalZOrder(30)
    self.node[1].btn:setLocalZOrder(20)

    self.node[2] = {}
    self.node[2].node = self.node_2
    self.node[2].star = self.star_2
    self.node[2].btn = self.btn_receive2
    self.node[2].player = nil
    self.node[2].star:setLocalZOrder(30)
    self.node[2].btn:setLocalZOrder(20)

    self.node[3] = {}
    self.node[3].node = self.node_3
    self.node[3].star = self.star_3
    self.node[3].btn = self.btn_receive3
    self.node[3].player = nil
    self.node[3].star:setLocalZOrder(30)
    self.node[3].btn:setLocalZOrder(20)

    self.btn_receive1:setTag(1)
    self.btn_receive2:setTag(2)
    self.btn_receive3:setTag(3)
    self.btn_receive1:registerScriptTapHandler(handler(self, self.onAcceptTask))
    self.btn_receive2:registerScriptTapHandler(handler(self, self.onAcceptTask))
    self.btn_receive3:registerScriptTapHandler(handler(self, self.onAcceptTask))
end

function PROMAstrologyTaskCell:initDone(data)
    self.data = data
-- dump(self.data, "data", 10)
    self.node[1].node:setVisible(false)
    self.node[2].node:setVisible(false)
    self.node[3].node:setVisible(false)
    for i, v in ipairs(self.data) do
        self.node[i].node:setVisible(true)
        self.node[i].star:setVisible(not v.is_over)
        self.node[i].btn:setEnabled(not v.is_over)

        if self.node[i].player ~= nil and v.config.show_hero == self.cur_show_hero then
            self.node[i].player:setVisible(true)
        else
            if self.node[i].player ~= nil then
                self.node[i].player:removeFromParent()
                self.node[i].player = nil
            end

            self.cur_show_hero = v.config.show_hero
            self.node[i].player = sp.SkeletonAnimation:create("spine/"..v.config.show_hero..".json","spine/"..v.config.show_hero..".atlas", 1)
            self.node[i].player:setAnimation(0, "stand", true);
            self.node[i].player:setScale(0.6)
            self.node[i].player:setPosition(cc.p(0, 10))
            self.node[i].node:addChild(self.node[i].player, 10)
        end
    end
end

function PROMAstrologyTaskCell:onAcceptTask(tag, pSender)
    local index = pSender:getTag()

    require("src.layer.promotion.PROMAstrologyAcceptTaskCtrl"):instance():openWindow(self.data[index].config.idx)
end

-- 设置已领取
function PROMAstrologyTaskCell:setBought()
    self.btn_submit:setLabelText(ex.Tools:getLang(2703))

    self.btn_submit:setEnabled(false)
    ex.Tools:setGray(self.btn_submit:getNormalImage())
end

-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------
function PROMAstrologyTaskLayer:onCreateDone()
	self:setAutoClose(false)
    self:setSwallowTouches(false)

    -- 数据
    self.promotion_id = 38
    self.list = {}
    self.time_info = {}

    self.global_scale = ex.p.width / 640
    self.table_view_size = cc.size(640 * self.global_scale, 670 * self.global_scale)

    self.table_view_idx = 0

    self:updateView()

    self.menu:setLocalZOrder(100)
    -- self.menu:setPosition(cc.p(self.menu:getPositionX() * self.global_scale, self.menu:getPositionY() * (2 - self.global_scale)))
    self.btn_left:registerScriptTapHandler(handler(self, self.onTurnPage))
    self.btn_right:registerScriptTapHandler(handler(self, self.onTurnPage))
    -- self.btn_right:setPositionX(ex.p.width - 30)

    self.spr_bg:setPositionY(self.layer_promotion:getTopY())
    self.spr_bg:setScale(self.global_scale)

    self:addEvent(EVENT.MAIN_CITY_PROMOTION.REFRESH_ASTROLOGY_STATUS, handler(self, self.refreshTaskStatus))
end

function PROMAstrologyTaskLayer:updateCDTime()
    local remain_time = self.time_info.end_time - ex.Game:getServerTime()

    if ex.Game:getServerTime()  <  self.time_info.start_time then 
		self.lbl_time:setString(ex.Tools:getLang(41052));
		return 
	end 

	if remain_time < 0 then 
        self.lbl_time:setString(ex.Tools:getLang(41053));
        
        self:removeTimerByName("act_astrology_task_timer")
		return
    end

    if remain_time > 86400 then
    	-- 大于1天
    	-- 剩余时间：%d天
    	self.lbl_time:setString(string.format("%d%s",
    		math.floor(remain_time / 86400), ex.Tools:getLang(31)))
    else
        remain_time = math.max(0, remain_time)
    	-- 剩余时间：%d小时%d分%d秒
    	self.lbl_time:setString(string.format("%d%s%d%s%d%s", 
        	math.floor(remain_time / 3600), ex.Tools:getLang(32), 
        	math.floor(remain_time / 60 % 60), ex.Tools:getLang(33), 
        	math.floor(remain_time % 60), ex.Tools:getLang(34)))
    end
end

function PROMAstrologyTaskLayer:generateData()
    self.time_info = ex.Player.promotion_data:getPromotionDatas(self.promotion_id)
    if self.time_info == nil then
        self.time_info = {start_time = 0, end_time = 0, clear_time = 0}
    end

    -- 生成数据并排序
    local list_key = {}
    for k, v in pairs(cfg.promotionastrology.promotionastrology) do
        table.insert(list_key, k)
    end

    table.sort(list_key)

    self.list = {}
    for i, v in ipairs(list_key) do
        local index = math.floor((i - 1) / 3 + 1)
        local sublist = self.list[index] or {}
        
        local data = {}
        data.config = cfg.promotionastrology.promotionastrology[v]
        data.is_over = false

        local info = ex.Player.promotion_data:getAstrologyTaskDataForIdx(data.config.idx)
        if info ~= nil then
            data.is_over = info.is_over
        end

        table.insert(sublist, data)
        self.list[index] = sublist
    end
end

function PROMAstrologyTaskLayer:createTableView()
    -- print(">>>>>PROMAstrologyTaskLayer:createTableView create table view!")
    self.table_view = cpp.UITableViewEx:create(self.table_view_size)
    self.table_view:setScale(self.global_scale)
    self.table_view:setPosition(0, 160 * (2 - self.global_scale))
    self.table_view:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    self.table_view:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.table_view:setBounceable(true)
    self.table_view:setDelegate()
    self.table_view:setDataSource()
    self.table_view:setMoveSpeed(0.7)
    self.table_view:setTouchEnabled(false)
    self:addChild(self.table_view, 10)

    self.table_view:registerScriptHandler(handler(self, self.scrollViewDidScroll), cc.SCROLLVIEW_SCRIPT_SCROLL) --滚动时的回掉函数
    self.table_view:registerScriptHandler(handler(self, self.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX) --列表项的尺寸
    self.table_view:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX) --创建列表项
    self.table_view:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW) --列表项的数量
    self.table_view:registerScriptHandler(handler(self, self.tableCellTouched), cc.TABLECELL_TOUCHED) --列表项被点击
end

function PROMAstrologyTaskLayer:updateView()
    -- 生成数据
    self:generateData()

    -- 活动刷新时间
    self:addTimer("act_astrology_task_timer", 1000, handler(self, self.updateCDTime), true)
    self:updateCDTime()
    
    -- dump(self.list, "list=======", 10)
    -- print(">>>>>PROMAstrologyTaskLayer:updateView num:", table.nums(self.list))

    if self.table_view == nil then
        self:createTableView()
        self.table_view_idx = 0
    else
        -- 记录位置，刷新后保留位置
    end

    self:refreshTurnBtnStatus()
    self.table_view:reloadData()
end

function PROMAstrologyTaskLayer:refreshTaskStatus()
    -- print(">>>>>PROMAstrologyTaskLayer:refreshTaskStatus")
    -- dump(self.list, "list========")
    for i = 1, table.nums(self.list) do
        for j = 1, table.nums(self.list[i]) do
            local info = ex.Player.promotion_data:getAstrologyTaskDataForIdx(self.list[i][j].config.idx)
            if info ~= nil then
                -- print("============================")
                self.list[i][j].is_over = info.is_over
            end
        end

        local cell = self.table_view:cellAtIndex(i - 1)
        -- print("cell idx:", i - 1, ", cell:", cell)
        if cell ~= nil then
            -- dump(self.list[i], "cell:initDone")
            local task_cell = cell:getChildByName("task_cell")
            task_cell:initDone(self.list[i])
        end
    end
end

------------------------------------
function PROMAstrologyTaskLayer:scrollViewDidScroll(table_view)
end

function PROMAstrologyTaskLayer:cellSizeForTable(table_view, idx)
    return self.table_view_size.width, self.table_view_size.height
end

function PROMAstrologyTaskLayer:tableCellAtIndex(table_view, idx)
    -- print(">>>>>PROMAstrologyTaskLayer:tableCellAtIndex idx:", idx)
    -- 获取循环可用的Cell
    local cell = self.table_view:dequeueCell()
    local task_cell = nil
    if cell == nil then
        cell = cc.TableViewCell:create()
    else
        cell:removeAllChildren()
	end
    
    task_cell = PROMAstrologyTaskCell:createWithCCBIFile("ccbi/PROMAstrologyTaskCell.ccbi")
    task_cell:setAnchorPoint(0, 0)
    task_cell:setPosition(0, 0)
    task_cell:setName("task_cell")
    task_cell:setScale(self.global_scale)
    cell:addChild(task_cell)

    cell:setLocalZOrder(-idx)
    
    local data = self.list[idx + 1]
    task_cell:initDone(data)

    return cell
end

function PROMAstrologyTaskLayer:numberOfCellsInTableView(table_view)
    return table.nums(self.list)
end

function PROMAstrologyTaskLayer:tableCellTouched(table_view, cell)
    
end

function PROMAstrologyTaskLayer:refreshTurnBtnStatus()
    self.btn_left:setVisible(self.table_view_idx > 0)
    self.btn_right:setVisible(self.table_view_idx < table.nums(self.list) - 1)
end
-------------------------------------

function PROMAstrologyTaskLayer:onTurnPage(tag, pSender)
    if pSender == self.btn_left then
        self.table_view_idx = self.table_view_idx - 1
    else
        self.table_view_idx = self.table_view_idx + 1
    end

    self.table_view:setContentOffsetInDuration(cc.p(0 - self.table_view_idx * self.table_view_size.width, 0), 0.3)
    self:refreshTurnBtnStatus()
end

return PROMAstrologyTaskLayer