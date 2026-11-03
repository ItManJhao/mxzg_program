local FettersCastSoulCtr = class("FettersCastSoulCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local FettersCastSoulLayer = class("FettersCastSoulLayer", require("src.comp.EventLayer"))

function FettersCastSoulLayer:onCreate()
    self.select_num = 0

	self:addBlackBackground()
	local bet_ctr = FettersCastSoulCtr:instance()
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
    :loadSlidBallTextures("fetters-cast-soul/spr-slider-1.png", "fetters-cast-soul/spr-slider-1.png", "fetters-cast-soul/spr-slider-1.png", 1)
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

    self.item = require("src.comp.menu.UIMenuItemBag"):createWithData(ItemType.IT_FETTERS_SOUL, 0)
    self.item:setPosition(self.btn_confirm:getPositionX(), 230)
    self.item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))

    self.btn_add:getParent():addChild(self.item)

    self:addEvent(EVENT.FETTER_EVENT.SOUL_UPDATE, handler(self, self.updateLayer))
    self:addEvent(EVENT.FETTER_EVENT.SOUL_UPDATE_LEVEL, handler(self, self.updateLevel))
end

function FettersCastSoulLayer:updateLayer(evt, has, need)
    need = need or self.need
    has = has or self.total_num
    self.has_num = has
    self.total_num = has
    -- self.item:setNumComp(has, self.select_num)
    self:updateSelectNum()
end

function FettersCastSoulLayer:updateLevel(evt, type, level, max_level)
    self.total_num = math.max(0, max_level - level)
    self.lbl_select_num:setString(string.format("%d/%d", level, max_level))
    self:updateSelectNum()

    -- level = 20
    local vec_attr = ex.Player.fetter_data:getSoulLevelAttr(type, level)

    for k,v in pairs(vec_attr) do
        local lbl = self["lbl_attr_" .. k]
        if lbl then
            lbl:setString(ex.StringUtil.formatAttrStr("+"..ex.Tools:getLang(2160000 + k), "##" , v))
        end
    end
end

function FettersCastSoulLayer:updateSelectNum()

    local can_buy_num = self:getCanBuyNum()
    self.select_num = math.min(self.select_num, can_buy_num)
    local percentage = can_buy_num <= 0 and 0 or self.select_num * 100.0 / can_buy_num
    self.progress:setPercentage(percentage)
    self.slider_select:setPercent(percentage)

    self.item:setNumComp(self.has_num, self.select_num)
    self.item:setNumVisible(self.has_num > 0)

    
    -- self.layer.slider_select:setPercent(100)
    -- self.layer.slider_select:setEnabled(false)

    -- self.lbl_select_num:setString(tostring(self.select_num))
    -- self.lbl_win:setString(tostring(math.floor(self.odds * self.select_num)))
    -- self.lbl_total_num:setString(tostring(self:getCanBuyNum()))
    -- self.lbl_win = odds
end

function FettersCastSoulLayer:getCanBuyNum()
    return math.min(self.total_num, self.has_num)
end

function FettersCastSoulLayer:onSub(tag, pSender)
    self.select_num = self.select_num - 1
    self.select_num = math.max(0, self.select_num)
    self:updateSelectNum()
end

function FettersCastSoulLayer:onAdd(tag, pSender)
    local can_buy_num = self:getCanBuyNum()
    self.select_num = self.select_num + 1
    self.select_num = math.min(can_buy_num, self.select_num)

    self:updateSelectNum()
end

function FettersCastSoulLayer:onMax(tag, pSender)
    local can_buy_num = self:getCanBuyNum()
    self.select_num = can_buy_num
    
    self.progress:setPercentage(100)
    self.slider_select:setPercent(100)

    self:updateSelectNum()
end


-----------------------------------------------------------------------------
function FettersCastSoulCtr:onCreate()
	self:setCCBIPath("ccbi/FettersCastSoulLayer.ccbi")
	self:setIsSingle(false)
end

function FettersCastSoulCtr:getLayerClass()
	return FettersCastSoulLayer
end

function FettersCastSoulCtr:openWindow(type, total_num, need, level, level_max, callback)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(type, total_num, need, level, level_max, callback)
end

function FettersCastSoulCtr:initData(type, total_num, need, level, level_max, callback)

    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))

    self.layer.total_num = math.max(0, level_max - level)  --total_num
    self.layer.select_num = 0
    self.layer.has_num = total_num
    self.layer.need = need
    self.layer.callback = callback
    self.layer.type = type


    self.layer:onAdd()

    if self.layer:getCanBuyNum() <= 1 then
        self.layer.progress:setPercentage(100)
        self.layer.slider_select:setPercent(100)
        self.layer.slider_select:setEnabled(false)
    end

    self.layer:updateLayer(nil, total_num, need)
    self.layer:updateLevel(nil, type, level, level_max)
end

function FettersCastSoulCtr:onConfirm(tag, pSender)
    -- 数量限制是否合法
    if self.layer.callback ~= nil then
        self.layer.callback(self.layer.type, self.layer.select_num)
    end
    ex.AudioManager:playEffect("music/clan-tec.mp3")

    -- self:closeWindow(0, nil)
end


return FettersCastSoulCtr
