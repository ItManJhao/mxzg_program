-- 功能预告弹框
local PROM66Ctr = class("PROM66Ctr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PROM66Layer = class("PROM66Layer", require("src.comp.EventLayerAdaptiveWidthFull"))

function PROM66Layer:onCreate()
    self:addBlackBackground()
end

function PROM66Layer:showLayerData(data)
    self:reorderChild(self.menu, 99)
    -- 功能预告的pageView,根据配置preview_images字段去加图片到里面
    self.page_view = ccui.PageView:create()
    self.page_view:setContentSize(ex.p.width, ex.p.height)
    self.page_view:setTouchEnabled(true)
    self.page_view:setPosition(cc.p(0, 0))
    self:addChild(self.page_view)

    local previews = data.preview_images or {}
    local indexOffsetX = 20
    local indexWith = #previews * 12 + (#previews - 1) * indexOffsetX

    for i = 1, #previews do
        local previewStr = previews[i]
        local preview = cc.Sprite:create(string.format("ccbi-res/%s", previewStr))
        if preview then
            preview:setPosition(self.page_view:getContentSize().width * 0.5, self.page_view:getContentSize().height * 0.5)

            local layout = ccui.Layout:create()
            layout:setContentSize(self.page_view:getContentSize().width, self.page_view:getContentSize().height)
            layout:setPosition(self.page_view:getContentSize().width / 2, self.page_view:getContentSize().height / 2)
            layout:addChild(preview)
            self.page_view:addPage(layout)
            if #previews > 1 then
                -- pageview的小圆点
                local index_gray = cc.Sprite:createWithSpriteFrameName("other/page-index-gray.png")
                if index_gray then
                    index_gray:setPosition(cc.p(ex.p.width / 2 - indexWith / 2 + (i - 1) * (12 + indexOffsetX) + 6, 140))
                    self:addChild(index_gray)
                end
            end
        end
    end

    if #previews > 1 then
        -- pageview的发光小圆点
        self.index_light = cc.Sprite:createWithSpriteFrameName("other/page-index-light.png")
        if self.index_light then
            self.index_light:setPosition(cc.p(ex.p.width / 2 - indexWith / 2 + 6, 140))
            self:addChild(self.index_light)
        end
    end

    self.page_view:setCurrentPageIndex(0)
    self.page_view:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    self.page_view:addEventListener(
        function(sender, event)
            local page = self.page_view:getCurPageIndex()
            if self.index_light then
                self.index_light:setPositionX(ex.p.width / 2 - indexWith / 2 + page * (12 + indexOffsetX) + 6)
            end
        end
    )
end

---------------------------------------------------------------------------------------------------------------------------------------

function PROM66Ctr:onCreate()
    self:setCCBIPath("ccbi/PROM66Layer.ccbi")
    self:setIsSingle(false)
end

function PROM66Ctr:getLayerClass()
    return PROM66Layer
end

function PROM66Ctr:openWindow()
    if self:isOpened() then
        return
    end
    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/main-city.plist")

    self:loadLayer()
    self:open()
    self:initData()
end

function PROM66Ctr:btnClose(tag, pSender)
    if self.closeCallback then
        self.closeCallback()
    end
    self:closeWindow()
end

function PROM66Ctr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.onBtnClose))
    self.layer.btn_award:registerScriptTapHandler(handler(self, self.onBtnAward))
    ex.RedDotManager:setStickNode(RedDotType.ZCJ_DHZC_GNYG_MRJL, self.layer.btn_award)

    local config = ex.Player.promotion_data.promotion66_config
    local aConfig
    if config and #config > 0 then
        aConfig = config[1]
        if not aConfig or not aConfig.reward then
            return
        end
    end

    self.layer:showLayerData(aConfig)
end

function PROM66Ctr:onBtnClose()
    self:closeWindow(nil, self.layer)
end

function PROM66Ctr:onBtnAward()
    local config = ex.Player.promotion_data.promotion66_config
    if config and #config > 0 then
        local aConfig = config[1]
        if not aConfig or not aConfig.reward then
            return
        end
    end

    require("src.layer.promotion.PROM66DailyAwardCtr"):instance():openWindow()
end

return PROM66Ctr
