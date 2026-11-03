--[[
* @Description: 端午节活动总界面
* @Author: 熊梦
* @Date: 2020-06-13 17:45:00
* ]]

local PROMDragonBoatLayer = class("PROMDragonBoatLayer", require("src.layer.promotion.PromotionBaseLayer"))
-----------------------------------------------------------------------
function PROMDragonBoatLayer:onCreateDone()
	self:setAutoClose(false)
    self:setSwallowTouches(false)
  
    self.node_up:setScaleX(ex.s.global_scale)
    self.node_up:setPositionY(self.node_up:getPositionY() - require("src.model.Game"):instance():getNotchHeight())

	--self.node_up:setScaleY(self.layer_promotion:getTopY() / self.spr_bg2:getContentSize().height)
	--self.node_bg:setScale(ex.s.global_scale)
    --self.node_up:setPosition(0, self.layer_promotion:getTopY() - 10)
    
    self.selected_type = 1
    
    for i=1,3 do
        local btn_tab = self["btn_activity"..i]
        if btn_tab then
            btn_tab:setContentSize(cc.size(214, 54))
        end
    end

    self.lbl_time = cpp.RichTextEx:createWithXMLLua("")
	self.lbl_time:setFontSize(36)
	self.lbl_time:setScale(0.5)
	self.lbl_time:setFontFace(FONT_DEFAULT_NAME_BOLD)
	self.lbl_time:setFontColor("#ffffff")
	self.lbl_time:setAnchorTextShadow(false)
	self.lbl_time:setAnchorPoint(ex.a.center)
    self.lbl_time:setPosition(ex.Tools:getAbsolutePosition(cc.p(0, 0), CommonUIDefine.UIDefine.ComponentOriginType.LEFT_BOTTOM, self.node_cd))
    self.lbl_time:setLocalZOrder(10)
    self.node_cd:addChild(self.lbl_time)
    
    self.promotion_id = 64
    self.time_info = ex.Player.promotion_data:getPromotionDatas(self.promotion_id)

    self:onChangeLayer()
    self:addTimer("adv_note_timer", 1000, handler(self, self.updateCDTime), true)
    self:updateCDTime()

    self:addRedDotNode(RedDotType.ZCJ_DHZC_PFHD_DWHD_LZRW, self.btn_activity1)
end

function PROMDragonBoatLayer:updateCDTime()
	local remain_time = self.time_info.end_time - ex.Game:getServerTime()

	if ex.Game:getServerTime()  <  self.time_info.start_time then 
		self.lbl_time:setXmlTextLua(ex.Tools:getLang(41052));
		return 
	end 

	if remain_time < 0 then 
		self.lbl_time:setXmlTextLua(ex.Tools:getLang(41053));

        self:removeTimerByName("colorful_timer")
        
        ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
		return
	end

	if remain_time > 86400 then
		local remainder = math.fmod( remain_time, 86400)
        self.lbl_time:setXmlTextLua(string.format(ex.Tools:getLang(3906),
			math.floor(remain_time / 86400),
			math.floor(remainder / 3600),
			math.floor(remainder / 60 % 60)))
    else
        self.lbl_time:setXmlTextLua(string.format(ex.Tools:getLang(41129), 
            math.floor(remain_time / 3600),
            math.floor(remain_time / 60 % 60),
            math.floor(remain_time % 60)))
    end
end

function PROMDragonBoatLayer:onChangeLayer(tag)
    if self.selected_type == tag then
        return
    end
    self.selected_type = tag
    self:updateTitle()
    self:updateLayerType()
end

function PROMDragonBoatLayer:updateTitle()
    if self.selected_type == nil then
        self.selected_type = 1
    end

    for i=1,3 do
        local btn_tab = self["btn_activity"..i]
        if i ~= self.selected_type then
            self["lib_activity_name"..i]:setColor(cc.c3b(178,140,90))
            self["lib_activity_name"..i]:enableOutline(cc.c3b(87,56,29),0)
        else
            local pos = cc.p(btn_tab:getParent():getPositionX() + btn_tab:getPositionX(), 
                            btn_tab:getParent():getPositionY() + btn_tab:getPositionY())
            self.spr_select:setPosition(pos)
            self["lib_activity_name"..i]:setColor(cc.c3b(253,228,181))
            self["lib_activity_name"..i]:enableOutline(cc.c3b(87,56,29),2)
        end
    end
end

function PROMDragonBoatLayer:updateLayerType()
    if self.selected_type == nil then
        return
    end

    if self.cur_layer ~= nil then
        self.cur_layer:removeFromParent()
        self.cur_layer = nil
    end

    local layer = nil
    if self.selected_type == 1 then
        layer = require("src.layer.promotion.PROMDragonBoatTaksLayer"):createWithCCBIFile("ccbi/PROMDragonBoatTaksLayer.ccbi")
        self:addChild(layer)
    elseif self.selected_type == 2 then
        layer = require("src.layer.promotion.PROMDragonBoatGameLayer"):createWithCCBIFile("ccbi/PROMDragonBoatGameLayer.ccbi")
        self:addChild(layer)
    elseif self.selected_type == 3 then
        layer = require("src.layer.promotion.PROMDragonBoatGiftLayer"):createWithCCBIFile("ccbi/PROMDragonBoatGiftLayer.ccbi")
        self:addChild(layer)
    end

    self.cur_layer = layer

end

return PROMDragonBoatLayer
