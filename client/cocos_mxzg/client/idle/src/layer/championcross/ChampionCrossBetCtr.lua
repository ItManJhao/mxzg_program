local ChampionBetCtr = class("ChampionCrossBetCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ChampionBetLayer = class("ChampionCrossBetLayer", require("src.comp.EventLayer"))

function ChampionBetLayer:onCreate()
    self.select_num = 0

	self:addBlackBackground()
	local bet_ctr = ChampionBetCtr:instance()
    self.btn_close:registerScriptTapHandler(handler(bet_ctr, bet_ctr.closeWindow))
    
	self.progress = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("buy/prog-1.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.prog_bg:addChild(self.progress)
    self.progress:setPosition(self.prog_bg:getContentSize().width / 2 ,self.prog_bg:getContentSize().height * 0.5 + 1 )

    self.progress:setPercentage(80)
    self.slider_select = ccui.Slider:create()
    -- :loadBarTexture("buy/prog-1.png", 1)
    self.slider_select:setScale9Enabled(true)
    :loadSlidBallTextures("buy/spr-slider-1.png", "buy/spr-slider-1.png", "buy/spr-slider-1.png", 1)
    :setPosition(self.prog_bg:getPositionX(), self.prog_bg:getPositionY())
    :setContentSize(self.prog_bg:getContentSize().width, self.prog_bg:getContentSize().height)
    :setPercent(80)
    :addTo(self)
    :addEventListener(function(ref, eventType)
        self.progress:setPercentage(ref:getPercent())

        local can_buy_num = self:getCanBuyNum() - 1
        local num = math.min(math.floor(can_buy_num * ref:getPercent() / 100), can_buy_num)
        if num + 1 == self.select_num then
            return
        end

        self.select_num = num + 1
        self:updateSelectNum()
    end)
end



function ChampionBetLayer:updateSelectNum()
    self.lbl_select_num:setString(tostring(self.select_num))
    self.lbl_total_num:setString(tostring(self:getCanBuyNum()))
    self.lbl_win:setString(tostring(math.floor(self.odds * self.select_num)))
    -- self.lbl_win = odds

end

function ChampionBetLayer:getCanBuyNum()
    return self.total_num
end

function ChampionBetLayer:onSub(tag, pSender)
    self.select_num = self.select_num - 1
    if self.select_num < 1 then
        self.select_num = 1
    end

    local can_buy_num = self:getCanBuyNum() - 1
    local percentage = (self.select_num - 1) * 100.0 / can_buy_num
    if can_buy_num <= 0 then
        percentage = 100
    end
    
    self.progress:setPercentage(percentage)
    self.slider_select:setPercent(percentage)

    self:updateSelectNum()
end

function ChampionBetLayer:onAdd(tag, pSender)
    local can_buy_num = self:getCanBuyNum()
    self.select_num = self.select_num + 1
    if self.select_num > can_buy_num then
        self.select_num = can_buy_num
    end
    
    can_buy_num = can_buy_num - 1
    local percentage = (self.select_num - 1) * 100.0 / can_buy_num
    if can_buy_num <= 0 then
        percentage = 100
    end
    
    self.progress:setPercentage(percentage)
    self.slider_select:setPercent(percentage)

    self:updateSelectNum()
end

function ChampionBetLayer:onMax(tag, pSender)
    local can_buy_num = self:getCanBuyNum()
    self.select_num = can_buy_num
    
    self.progress:setPercentage(100)
    self.slider_select:setPercent(100)

    self:updateSelectNum()
end


-----------------------------------------------------------------------------
function ChampionBetCtr:onCreate()
	self:setCCBIPath("ccbi/ChampionCrossBetLayer.ccbi")
	self:setIsSingle(false)
end

function ChampionBetCtr:getLayerClass()
	return ChampionBetLayer
end

function ChampionBetCtr:openWindow(name, odds, num, callback, ext)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(name, odds, num, callback, ext)
end

function ChampionBetCtr:initData(name, odds, num, callback, ext)

    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_cancel:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))


    self.layer.lbl_name:setString(name)
    
    self.callback = callback
    self.layer.ext = ext
    self.layer.total_num = math.min(ex.Tools:getSysCfg("champion_max_guess"), num)
    self.layer.select_num = 0
    self.layer.odds = odds


    self.layer:onAdd()

    if self.layer:getCanBuyNum() <= 1 then
        self.layer.progress:setPercentage(100)
        self.layer.slider_select:setPercent(100)

        self.layer.slider_select:setEnabled(false)
    end
end

function ChampionBetCtr:onConfirm(tag, pSender)
    -- 数量限制是否合法
    if self.layer.select_num <= 0 then
        self:closeWindow(0, nil)
        return
    end

    if self.callback ~= nil then
        self.callback(self.layer.select_num, self.layer.ext)
    end

    self:closeWindow(0, nil)
end


return ChampionBetCtr
