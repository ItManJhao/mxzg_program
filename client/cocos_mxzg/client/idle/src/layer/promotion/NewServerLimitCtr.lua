local NewServerLimitCtr = class("NewServerLimitCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local NewServerLimitLayer = class("NewServerLimitLayer", require("src.comp.EventLayerAdaptiveWidth"))
local ExTimer = require("src.ex.ExTimer")
--------------------------------------------

function NewServerLimitLayer:onCreate()
    -- local bg_size = cc.size(ex.p.width - 18, ex.p.height - 100)

    -- self:setContentSize(cc.size(ex.p.width, ex.p.height))
    local content_size = self:getContentSize()
    self:setPosition(cc.p(ex.p.width / 2 - content_size.width / 2, ex.p.height / 2 - content_size.height / 2))

    -- self.spr_bg:setPreferredSize(bg_size)
    for i = 1, 3 do
        self.layer["btn_cell_"..i.."_buy"]:setLabelSize(48)
    end

    -- 活动刷新时间
    self.end_time = 0
    
    self:addBlackBackground()
end

function NewServerLimitLayer:startTimer(endtime)
    self.end_time = cc.exports.GetTodayRemainTime()

    if self.timer == nil then
        self.timer = ExTimer:new():bind(self):run(handler(self, self.updateCDTime), 1.0)
        self:updateCDTime()
    end
end

function NewServerLimitLayer:updateCDTime()
    self.end_time = self.end_time - 1
    if self.end_time <= 0 then
        self.end_time = self.end_time + 86400

        -- 时间到了，更新数据
        ex.Player.promotion_data:reqNewServerLimit()
    end

    if self.end_time > 86400 then
    	-- 大于1天
    	-- %d天
        self.layer.remain_time:setString(string.format("%d%s", math.floor(self.end_time / 86400), ex.Tools:getLang(31)))
        self.layer.remain_time:setTextColor(cc.GREEN)
    else
    	-- %d:%d:%d
    	self.layer.remain_time:setString(string.format("%d:%d:%d", math.floor(self.end_time / 3600), math.floor(self.end_time / 60 % 60), math.floor(self.end_time % 60)))
        self.layer.remain_time:setTextColor(cc.BROWN)
    end
end

function NewServerLimitLayer:onExit()
    -- 停止计时器
    self.timer:stop()
end

-----------------------------------------------------------------------------
function NewServerLimitCtr:onCreate()
	self:setCCBIPath("ccbi/NewServerLimitLayer.ccbi")
    self:setIsSingle(false)
    
    self.list = {}
end

function NewServerLimitCtr:getLayerClass()
	return NewServerLimitLayer
end

function NewServerLimitCtr:getNewServerLimitLayer()
	return self.layer
end

function NewServerLimitCtr:openWindow()
	if self:isOpened() then
		return
    end
    
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/promotion-new-server.plist")

	self:loadLayer()
	self:open()
	self:initData()
end

function NewServerLimitCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    
    self.list = {}
    --local total_list = ex.Player.shop_data:getRechargeList(RechargeKindType.NEW_SERVER_LIMIT)

    --local day_th = math.floor((ex.Game:getServerTime() - ex.Player.server_create_time) / 86400) + 1
    -- local day_th = cc.exports.GetAfterDaysForTime(ex.Player.server_create_time)
    -- print("total len:", table.nums(total_list), ", day_th:", day_th)
    -- dump(total_list)
    -- for i,v in ipairs(total_list) do
    --     if v.level == day_th then
    --         table.insert(self.list, v)
    --     end
    -- end
    -- dump(self.list, ex.Tools:getLang(47692))

    self.list = ex.Player.promotion_data:getNewServerListData()
    self.layer:startTimer(ex.Player.promotion_data.new_server_limit_end_time)

	self:updateTableView()
end

function NewServerLimitCtr:updateTableView()
    print("NewServerLimitCtr:updateTableView")

    local UIItemBackpack = require("src.comp/menu/UIMenuItemBackpack")

    if self.layer.menu_reward == nil then
        self.layer.menu_reward = cpp.UIMenu:create()
        self.layer.menu_reward:setPosition(cc.p(0, 0))
        self.layer:addChild(self.layer.menu_reward)
    end
    self.layer.menu_reward:removeAllChildren()

    local i = 0
    for k,v in pairs(self.list) do
        i = i + 1
        if i <= 3 then
            local buy_data = ex.Player.promotion_data:getNewServerLimit(v.idx)
            local buy_time = 0
            if buy_data then
                buy_time = buy_data.bought_num
            end
                
            self.layer["lbl_cell_"..i.."_title"]:setString(ex.Tools:getLang(v.tag_language))
            self.layer["lbl_cell_"..i.."_desc"]:setString(ex.Tools:getLang(v.item_language))
            self.layer["lbl_cell_"..i.."_original_price"]:setString(string.format( ex.Tools:getLang(47251), v.original_cost / 100))
            self.layer["btn_cell_"..i.."_buy"]:setLabelText(string.format(ex.Tools:getLang(47309), v.rmb / 100))
            self.layer["lbl_cell_"..i.."_limit_label"]:setString(string.format(ex.Tools:getLang(47213), buy_time, v.limit_times))
            self.layer["btn_cell_"..i.."_buy"]:setVisible(buy_time < v.limit_times)
            self.layer["btn_cell_"..i.."_buy"]:setEnabled(buy_time < v.limit_times)
            ex.Tools:delGray(self.layer["btn_cell_"..i.."_buy"]:getNormalImage())
    
            self.layer["btn_cell_"..i.."_buy"].data = v
            self.layer["btn_cell_"..i.."_buy"].index = i
            self.layer["btn_cell_"..i.."_buy"]:registerScriptTapHandler(handler(self, self.onBuyBtn))
    
            local item_num = table.nums(v.item)
            if item_num > 3 then
                item_num = 3
            end
            local star_pos_x = 290 - item_num * 120 / 2 - 60
            for i2,v in ipairs(v.item) do
                if i2 > 3 then
                    break
                end
        
                local item = ex.Player.backpack_data:createWithData(v.item_type, v.item_num)
                item:registerScriptTapHandler(handler(self, self.onItemInfo))
                item:setScale(0.85)
                item:setPosition(star_pos_x + 120 * i2, 960 - 267 * i)
                self.layer.menu_reward:addChild(item)
            end 
        end
    end
end

function NewServerLimitCtr:onItemInfo(tag,pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function NewServerLimitCtr:onBuyBtn(tag,pSender)
    local data = pSender.data

    local buy_data = ex.Player.promotion_data:getNewServerLimit(data.idx)
    if buy_data ~= nil then
        if buy_data.bought_num >= data.limit_times then
            ex.MessageView:add(ex.Tools:getLang(47551))
            return 
        end
    end

    ex.Player:pay(data.production_id)

    ex.Tools:setGray(pSender:getNormalImage())
    pSender:setEnabled(false)
end

return NewServerLimitCtr
