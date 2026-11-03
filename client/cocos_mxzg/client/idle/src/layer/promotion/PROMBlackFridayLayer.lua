--[[
* @Description: 黑色星期五
* @Author: 熊梦
* @Date: 2020-11-17 1:26:00
* ]]
local PROMBlackFridayLayer = class("PROMBlackFridayLayer", require("src.layer.promotion.PromotionBaseLayer"))
local PromotionCell = require("src.layer.promotion.PromotionCell")
local sfc = cc.SpriteFrameCache:getInstance()
local cell_size = PromotionCell:createWithCCBIFile("ccbi/PromotionCell.ccbi"):getContentSize()

function PROMBlackFridayLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:resetScaleAtWidth(true)
    self:addPlist()
    self.vec_reddot = {}

    self.layer_promotion = self

    self:initView()
end

function PROMBlackFridayLayer:onExit()
    self:removeRedDotList()
end

function PROMBlackFridayLayer:onEventLayerExit()
    self.super.onEventLayerExit(self)
end

function PROMBlackFridayLayer:addPlist()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/promotion-tab-icon-2.plist")
end

function PROMBlackFridayLayer:initView()
    self:resetTabView()
    self:fitSelfViewSize()
    self.top_menu:setLocalZOrder(100)
    self.btn_back:registerScriptTapHandler(handler(self, self.onBack))
end

-- 界面适配
function PROMBlackFridayLayer:fitSelfViewSize()
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

function PROMBlackFridayLayer:removeRedDotList()
    -- 移除红点节点
    local reddot_manager = ex.RedDotManager
    for k, v in pairs(self.vec_reddot) do
        reddot_manager:setStickNode(k, NULL)
    end
    self.vec_reddot = {}
end

-- 刷新顶部标签栏
function PROMBlackFridayLayer:resetTabView()
    if not self.menu then
        self.menu = require("src.comp.menu.UIMenuGeneral"):create()
        self.menu:setPosition(cc.p(0, 0))
        self.menu:setSwallowsTouches(false)
        self.menu:setTouchCallback(handler(self, self.onSelect))
        self.scroll_view:getContainer():addChild(self.menu)
        self.scroll_view:setLocalZOrder(100)
    end

    self:removeRedDotList()

    self.menu:removeAllChildren()
    self.cells = {}
    local margin = 10
    local index = 0
    local view_size = cc.size(ex.p.width, cell_size.height)
    self.scroll_view:setViewSize(view_size)
    self.scroll_view:setPosition(ex.p.width * 0.5 - view_size.width * 0.5, self.layer_promotion:getBottomY() + 126)
    local vec_idx = ex.Player.promotion_data:getPromotionByType(PromotionPageType.BLACK_FRIDAY_ACTIVITY)
    local first_cell
    local select_cell


    if vec_idx and #vec_idx > 0 then
        for k, v in ipairs(vec_idx) do
            local is_open = true
            if v.checkopen and v.checkopen ~= "" and self[v.checkopen] then
                is_open = self[v.checkopen]()
            end

            if is_open then
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
                    first_cell = cell
                end

                if self.select_idx and self.select_idx == index then
                    select_cell = cell
                    cell:setSelected(true)
                    self.select_idx = v.idx
                    self:resetSelectLayer(self.select_idx)
                else
                    cell:setSelected(false)
                end
                
                --设置红点节点
                if v.reddot ~= "" then
                    self.vec_reddot[v.reddot] = cell
                    print(self.__cname , v.reddot,v.idx)
                    ex.RedDotManager:setStickNode(v.reddot, cell)
                end

                index = index + 1
            end
        end
    end

      if first_cell and not select_cell then
        first_cell:setSelected(true)
        self.select_idx = first_cell.idx
        self:resetSelectLayer(self.select_idx)
    elseif not first_cell and not select_cell then
        cfg.funcopen["main_city"].open()
        return
    end

    local width = index * cell_size.width + margin * 2
    width = math.max(width, view_size.width)
    self.scroll_view:setContentSize(cc.size(width, cell_size.height))
    self.scroll_view:setContentOffset(cc.p(0, 0))
end

function PROMBlackFridayLayer:getBottomY()
    return 900 * self:getScaleY()
end

function PROMBlackFridayLayer:getTopY()
    return self.scroll_view:getPositionY()
end

function PROMBlackFridayLayer:resetSelectLayer(idx)
    local config = ex.Player.promotion_data:getPromotionConfigByIdx(idx)
    if not config then
        return
    end

    self.idx = idx
    self.select_idx = idx

    if self.cur_layer ~= nil then
        self.cur_layer:removeFromParent()
        self.cur_layer = nil
    end

    self.menu:unselectAll()
    local children = self.menu:getChildren()
    for i, v in ipairs(children) do
        if v.idx == self.idx then
            v:setSelected(true)
        end
    end

    local layer = nil
    if idx == 1301 then
         layer = require("src.layer.promotion.PROMBlackFridayWantedLayer"):createWithCCBIFile("ccbi/PROMBlackFridayWantedLayer.ccbi")
         self:addChild(layer)
    elseif idx == 1302 then
        layer = require("src.layer.promotion.PROMBlackFridayCannibalismLayer"):createWithCCBIFile("ccbi/PROMBlackFridayCannibalismLayer.ccbi")
        self:addChild(layer)
    elseif idx == 1303 then
        layer = require("src.layer.promotion.PROMBlackFridayDiscountLayer"):createWithCCBIFile("ccbi/PROMBlackFridayDiscountLayer.ccbi")
        self:addChild(layer)
    elseif idx == 1304 then
        layer = require("src.layer.promotion.PROMBlackFridayHeroRankLayer"):createWithCCBIFile("ccbi/PROMBlackFridayHeroRankLayer.ccbi")
        self:addChild(layer)
    end

    self.cur_layer = layer

    layer.layer_promotion = self
    if layer.onCreateDone then
         layer:onCreateDone()
    end
end

------------------------------- 点击事件 -------------------------------

-- 返回
function PROMBlackFridayLayer:onBack(tag, pSender)
    ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
end

function PROMBlackFridayLayer:onSelect(tag, pSender)
    if self.select_idx == pSender.idx then
        return
    end

    ex.AudioManager:playEffect("music/button-click.mp3")

    self.menu:unselectAll()
    for i, v in ipairs(self.cells) do
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

function PROMBlackFridayLayer:checkPromotionIs82Open()
    return ex.Player.promotion_data:checkPromotionIs82Open()
end

function PROMBlackFridayLayer:checkPromotionIs81Open()
    return ex.Player.promotion_data:checkPromotionIs81Open()
end

function PROMBlackFridayLayer:checkPromotionIs83Open()
    return ex.Player.promotion_data:checkPromotionIs83Open()
end

function PROMBlackFridayLayer:checkPromotionIs92Open()
    return ex.Player.promotion_data:checkPromotionIs92Open()
end

return PROMBlackFridayLayer
