-- 活动（梦境秘宝，活动70）
local PROMSecretTreasureLayer = class("PROMSecretTreasureLayer", require("src.layer.promotion.PromotionBaseLayer"))
local PromotionCell = require("src.layer.promotion.PromotionCell")
local sfc = cc.SpriteFrameCache:getInstance()
local cell_size = PromotionCell:createWithCCBIFile("ccbi/PromotionCell.ccbi"):getContentSize()

function PROMSecretTreasureLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:resetScaleAtWidth(true)
    self:addPlist()
    self:initEventListen()
    self.vec_reddot = {}

    self.layer_promotion = self
    self.node_banner2:setZOrder(100)

    self:initView()
    
    self:onCreateDone()
end

function PROMSecretTreasureLayer:onCreateDone()
    ex.Tools:setLabelOffset(self.lbl_time_tip, self.lbl_time)
    self:addTimer("timer", 1000, handler(self, self.updateTimer), true)
    self:updateTimer()
    self.node_banner2:setPositionY(self:getTopY() - 83)
end

function PROMSecretTreasureLayer:onExit()
    self:removeTimerByName("timer")
    self:removeRedDotList()
end

function PROMSecretTreasureLayer:updateTimer()
    local is_open = cfg.funcopen["act_secret_treasure"].isVisible()
    if is_open ~= true then
        cfg.funcopen["main_city"].open()
        return
    end

    local data = ex.Player.promotion_data:getPromotion70Data()
    if data == nil then
        return
    end

    self.lbl_time:setString(ex.Tools:formatTime5(data.end_time - ex.Game:getServerTime()))
end

function PROMSecretTreasureLayer:onEventLayerExit()
    self.super.onEventLayerExit(self)
end



function PROMSecretTreasureLayer:initEventListen()
    self:addEvent(EVENT.SECRET_TREASURE.EVENT_REWARD_SELECT, handler(self, self.undateBanner))
    self:addEvent(EVENT.SECRET_TREASURE.EVENT_GAME_RESET, handler(self, self.undateBanner))
end


function PROMSecretTreasureLayer:addPlist()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/promotion-tab-icon-2.plist")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/promotion-banner-5.plist")
end

function PROMSecretTreasureLayer:initView()
    self:resetTabView()
    self:fitSelfViewSize()
    self.top_menu:setLocalZOrder(100)
    self.btn_back:registerScriptTapHandler(handler(self, self.onBack))

    
end

-- 界面适配
function PROMSecretTreasureLayer:fitSelfViewSize()
    local pos_y = ex.p.height - 170 * ex.s.global_scale - require("src.model.Game"):instance():getNotchHeight()
    self.top_menu:setPositionY(pos_y)

    local top_bg_size = self.spr_top_bg:getContentSize()
    local win_size = cc.Director:getInstance():getWinSize()
    local top_height = self.scroll_view:getPositionY()
    if (ex.p.height - top_height) > top_bg_size.height then
        self.spr_top_bg:setScaleY((ex.p.height - top_height) / top_bg_size.height)
    end

    if ex.p.width > top_bg_size.width then
        self.spr_top_bg:setScaleX(ex.p.width / top_bg_size.width)
    end
end


function PROMSecretTreasureLayer:removeRedDotList()
    	-- 移除红点节点
	local reddot_manager = ex.RedDotManager
	for k,v in pairs(self.vec_reddot) do
		 reddot_manager:setStickNode(k, NULL)
    end
    self.vec_reddot = {}
end

-- 刷新顶部标签栏
function PROMSecretTreasureLayer:resetTabView()
    if not self.menu then
        self.menu = require("src.comp.menu.UIMenuGeneral"):create()
        self.menu:setPosition(cc.p(0, 0))
        self.menu:setSwallowsTouches(false)
        self.menu:setTouchCallback(handler(self, self.onSelect))
        self.scroll_view:getContainer():addChild(self.menu)
        self.scroll_view:setLocalZOrder(100)
    end

    -- self.vec_reddot = {}
    self:removeRedDotList()

    self.menu:removeAllChildren()
	self.cells = {}
    local margin = 10
	local index = 0
    local view_size = cc.size(ex.p.width, cell_size.height)
	self.scroll_view:setViewSize(view_size)
    self.scroll_view:setPosition(ex.p.width * 0.5 - view_size.width * 0.5, self.layer_promotion:getBottomY() + 126)
    local vec_idx = ex.Player.promotion_data:getPromotionByType(PromotionPageType.SECRET_TREASURE_ACTIVITY)
    if vec_idx and #vec_idx > 0 then
        for k, v in ipairs(vec_idx) do
            local cell = PromotionCell:createWithCCBIFile("ccbi/PromotionCell.ccbi")
            cell:setPosition(margin + index * cell_size.width, 0)
            cell.idx = v.idx
            self.menu:addChild(cell)
            table.insert(self.cells, cell)
            
            local icon = 200
            if v ~= nil then
                icon = v.icon
            end
            
            -- local frame = sfc:getSpriteFrame(string.format("promotion/icon-%d-1.png", icon))
            -- cell.spr_icon1:setSpriteFrame(frame)
            -- frame = sfc:getSpriteFrame(string.format("promotion/icon-%d-2.png", icon))
            -- cell.spr_icon2:setSpriteFrame(frame)

            ex.Tools:setSpriteFrame(cell.spr_icon1, string.format("promotion/icon-%d-1.png", icon))
            ex.Tools:setSpriteFrame(cell.spr_icon2, string.format("promotion/icon-%d-2.png", icon))
            
            cell.spr_icon1:setPositionX(cell_size.width * 0.5)
            cell.spr_icon2:setPositionX(cell_size.width * 0.5)

            if index == 0 then
                cell:setSelected(true)
                self.select_idx = v.idx
                self:resetSelectLayer(self.select_idx)
            else
                cell:setSelected(false)
            end
           
            --设置红点节点
            if v.reddot ~= "" then
                self.vec_reddot[v.reddot] = cell
                -- ex.RedDotManager:setStickNode(reddot, cell)
                ex.RedDotManager:setStickNode(v.reddot, cell)
            end

            index = index + 1
        end
    end

    local width = index * cell_size.width + margin * 2
    width = math.max(width , view_size.width)
    self.scroll_view:setContentSize(cc.size(width, cell_size.height))
    self.scroll_view:setContentOffset(cc.p(0, 0))
end

function PROMSecretTreasureLayer:getBottomY()
    return 900 * self:getScaleY()
end

function PROMSecretTreasureLayer:getMainSceneBottomY()
	return ex.MainSceneCtr:getBottomHeight() + 10
end

function PROMSecretTreasureLayer:getTopY()
    return self.scroll_view:getPositionY()
end

function PROMSecretTreasureLayer:resetSelectLayer(idx)
    local config = ex.Player.promotion_data:getPromotionConfigByIdx(idx)
    if not config then
        return
    end

    self.idx = idx
    self.select_idx = idx
    
    self:undateBanner()
    -- self.node_banner:setPosition(self.spr_banner:getPosition())

    if self.cur_layer ~= nil then
        self.cur_layer:removeFromParent()
        self.cur_layer = nil
    end


    self.menu:unselectAll()
	local children = self.menu:getChildren()
	for i,v in ipairs(children) do
		if v.idx == self.idx then
			v:setSelected(true)
		end
    end
    

    local layer = nil
    if idx == 801 then
        layer = require("src.layer.promotion.PROMSecretTreasureGameLayer"):createWithCCBIFile("ccbi/PROMSecretTreasureGameLayer.ccbi")
        layer:resetBg(ex.p.width, self:getBottomY() + 64)
        layer:setPosition(0, self:getBottomY() - layer:getContentSize().height)
        self:addChild(layer)
    elseif idx == 802 then
        layer = require("src.layer.promotion.PROMSecretTreasureBuyLayer"):createWithCCBIFile("ccbi/PROMSecretTreasureBuyLayer.ccbi")
        self:addChild(layer)
    elseif idx == 803 then
        layer = require("src.layer.promotion.PROMSecretTreasureTaskLayer"):createWithCCBIFile("ccbi/PROMSecretTreasureTaskLayer.ccbi")
        self:addChild(layer)
    end

    self.cur_layer = layer

    layer.layer_promotion = self
	if layer.onCreateDone then
		layer:onCreateDone()
    end
end

function PROMSecretTreasureLayer:undateBanner()
    local config = ex.Player.promotion_data:getPromotionConfigByIdx(self.idx)
    if not config then
        return
    end

    local temp_config = clone(config)

    if self.idx == 801 then
         local choose_rewards = ex.Player.promotion_data.promotion70_choose_rewards
        if choose_rewards and #choose_rewards > 0 then
            temp_config.banner_plist = "ccbi-res/promotion-banner-5.plist"
            temp_config.icon = 802
        end
    end
   
    self:addBannerImage(temp_config)
end

------------------------------- 点击事件 -------------------------------

-- 返回
function PROMSecretTreasureLayer:onBack(tag, pSender)
    ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
end

function PROMSecretTreasureLayer:onSelect(tag, pSender)
	if self.select_idx == pSender.idx then
        return
    end

    ex.AudioManager:playEffect("music/button-click.mp3")

	self.menu:unselectAll()
	for i,v in ipairs(self.cells) do
		if v ~= pSender then
			v:setSelected(false) 
		end
	end

    self.select_idx = pSender.idx
	pSender:setSelected(true)

	if self.cur_layer ~= nil then
		self.cur_layer:removeFromParent()
		self.cur_layer = nil
	end

    self:resetSelectLayer(self.select_idx)
end


return PROMSecretTreasureLayer
