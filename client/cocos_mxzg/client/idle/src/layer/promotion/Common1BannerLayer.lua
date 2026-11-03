--[[
    func: 第一号横幅层
    author:徐东浩
    time:2019-10-21 14:30:45
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local Common1BannerLayer = class("Common1BannerLayer", require("src.comp.EventLayer"))
local CommonUIHelper = require("src.layer.promotion.CommonUIHelper")

function Common1BannerLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.timer_name = "cbl_timer"
    self.Owner = nil
    self.ui_layout_arg = nil
    self.data = nil             -- 不可修改
    self.banner_id = 0

    self.lbl_time = cpp.RichTextEx:createWithXMLLua("")
	self.lbl_time:setFontSize(36)
	self.lbl_time:setScale(0.5)
	self.lbl_time:setFontFace(FONT_DEFAULT_NAME_BOLD)
	self.lbl_time:setFontColor("#ffffff")
	self.lbl_time:setAnchorTextShadow(false)
	-- self.lbl_time:ignoreContentAdaptWithSize(false)
	-- self.lbl_time:setWrapMode(1)
	self.lbl_time:setAnchorPoint(ex.a.right_center)
    self.lbl_time:setPosition(ex.Tools:getAbsolutePosition(cc.p(5, 0), CommonUIDefine.UIDefine.ComponentOriginType.RIGHT_TOP, self.time_node))
    self.lbl_time:setLocalZOrder(10)
	self.time_node:addChild(self.lbl_time)
end

function Common1BannerLayer:onCreateDone(owner, ui_layout_arg, data, banner_id)
    self.Owner = owner
    self.ui_layout_arg = ui_layout_arg
    self.data = data
    self.banner_id = banner_id

    -- 加载窗体定制内容
    CommonUIHelper:ParseWinLayoutArgs(self.ui_layout_arg, self, data)

    self:refresh()

    self:addTimer(self.timer_name, 1000, handler(self, self.updateCDTime), true)
end

function Common1BannerLayer:refresh()
    -- self.spr_banner:setSpriteFrame(string.format("promotion/spr-banner-%d.png", self.banner_id))
    ex.Tools:setSpriteFrame(self.spr_banner, string.format("promotion/spr-banner-%d.png", self.banner_id))
    self:updateCDTime()
end

function Common1BannerLayer:updateCDTime()
    if self.data == nil then
        return
    end

    local remain_time = self.data.end_time - ex.Game:getServerTime()

    if ex.Game:getServerTime()  <  self.data.start_time then 
		self.lbl_time:setXmlTextLua(ex.Tools:getLang(41052));
		return 
	end 

	if remain_time < 0 then 
        self.lbl_time:setXmlTextLua(ex.Tools:getLang(41053));
    
        self:removeTimerByName(self.timer_name)
		return
    end

    local d, h, m, s = ex.Tools:formatTime(math.max(remain_time, 0))
    if remain_time > 86400 then
        self.lbl_time:setXmlTextLua(string.format(ex.Tools:getLang(41130), d))
    else
        self.lbl_time:setXmlTextLua(string.format(ex.Tools:getLang(41129), h, m, s))
    end
end

return Common1BannerLayer