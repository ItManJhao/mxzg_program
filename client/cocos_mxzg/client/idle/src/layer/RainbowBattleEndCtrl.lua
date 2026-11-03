local RainbowBattleEndCtrl = class("RainbowBattleEndCtrl", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local RainbowBattleEndLayer = class("RainbowBattleEndLayer", require("src.comp.EventLayer"))

local RewardPosition = {
	[1] = {{x = 0, y = 68}},
	[2] = {{x = -60, y = 68},{x = 60, y = 68}},
	[3] = {{x = -120, y = 68},{x = 0, y = 68},{x = 120, y = 68}},
}

function RainbowBattleEndLayer:onCreate()
	self:setAutoClose(true)
	self:addBlackBackground()

	self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)
end

function RainbowBattleEndLayer:refreshTitle(rainbow_type)
	ex.Tools:setSpriteFrame(self.spr_title, string.format("rainbow/title-%d.png", rainbow_type))
end

function RainbowBattleEndLayer:refreshAddition(attr)
	for i=1, 2 do
        self["node_attr_"..i]:setVisible(i <= #attr)
        if i <= #attr then
            self["lbl_attr_name_"..i]:setString(ex.Tools:getLang(122000 + attr[i].attr).."：")

            self["lbl_attr_value_"..i]:setString(string.format("+%s", ex.StringUtil.formatAttrNum(ex.Tools:getLang(2160000 + attr[i].attr), attr[i].value)))
        end
    end
end


-----------------------------------------------------------------------------
function RainbowBattleEndCtrl:onCreate()
	self:setCCBIPath("ccbi/RainbowBattleEndLayer.ccbi")
	self:setIsSingle(false)

	self.data = {}
	self.rainbow_type = 1
	self.config = nil	-- rainbow表配置
end

function RainbowBattleEndCtrl:getLayerClass()
	return RainbowBattleEndLayer
end

function RainbowBattleEndCtrl:getRainbowBattleEndLayer()
	return self.layer
end

function RainbowBattleEndCtrl:openWindow(data, rainbow_type)
	if self:isOpened() or data == nil then
		return
	end

	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/rainbow.plist")
    
	self.data = data
	self.rainbow_type = rainbow_type
	self.config = cfg.rainbow.rainbow[self.rainbow_type]

	self:loadLayer()
	self:open()
	self:initData()
end

function RainbowBattleEndCtrl:initData()
	self.layer.btn_report:registerScriptTapHandler(handler(self, self.onBattleDetail))

	self.layer:refreshTitle(self.rainbow_type)
	self.layer:refreshAddition(self.config.attr)

    ex.AudioManager:playEffect("music/battle-end-1.mp3")
end

function RainbowBattleEndCtrl:onceAnim(pos, str_spr, str_plist, str_png)
	local spr_effectOnce = cc.Sprite:createWithSpriteFrameName(str_spr)
    spr_effectOnce:setScale(1.35)
    spr_effectOnce:setPosition(pos)
    self.layer.scroll_view:getContainer():addChild(spr_effectOnce)

    local action = cpp.ActionFactory:createLuaAnimate(str_plist, str_png, 0.05)
    spr_effectOnce:runAction(cc.Sequence:create(action, cc.CallFunc:create(function()
    	spr_effectOnce:setVisible(false)
    end)))
end

function RainbowBattleEndCtrl:onBattleDetail(tag, pSender)
	require("src.layer.BattleDetailCtr"):instance():openWindow(self.data.log)
end

return RainbowBattleEndCtrl
