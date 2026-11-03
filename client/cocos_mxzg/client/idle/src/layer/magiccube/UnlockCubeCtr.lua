local UnlockCubeCtr = class("UnlockCubeCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local UnlockCubeLayer = class("UnlockCubeLayer", require("src.comp.EventLayerAdaptiveWidth"))
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

--------------------------------------------

function UnlockCubeLayer:onCreate()
    self:addBlackBackground()
    self:registerBtnEvent()
    self:createRich()
end

function UnlockCubeLayer:updateView(data)
    self:updateRich(data)
    local has_num = ex.Player:getItemNum(data.cost[1].item_type)
    self.lbl_num:setString(has_num)
    self.spr_icon:setSpriteFrame(string.format("backpack/%s.png",data.cost[1].item_type))
end

function UnlockCubeLayer:updateRich(data)
    local cost_num = data.cost[1].item_num
    local item_type = data.cost[1].item_type
    local cube_num = data.idx
    local str = string.format(ex.Tools:getLang(77314),cost_num,item_type,cube_num)

    self.rich_text:setXmlTextLua(str)
end

function UnlockCubeLayer:createRich()
    self.rich_text = cpp.RichTextEx:createWithXMLLua("")
    :setFontSize(24)
    :setFontFace(FONT_DEFAULT_NAME_BOLD)
    :setFontColor("#7A472D")
    :setAnchorTextShadow(true)
    :ignoreContentAdaptWithSize(true)
    :setWrapMode(1)
    --:setContentSize(400, 48)
    :setAnchorPoint(ex.a.top_center)
    :setName("lbl_count_left")
    self.node_rich:addChild(self.rich_text)
    self.rich_text:setPosition(0,0)

end


function UnlockCubeLayer:registerBtnEvent()

    self.btn_close:registerScriptTapHandler(handler(self,self.onClose))
    self.btn_cannel:registerScriptTapHandler(handler(self,self.onClose))
    self.btn_enter:registerScriptTapHandler(handler(self,self.onCommit))
end

function UnlockCubeLayer:onCommit(tag,pSender)
    local item_type = self.data.cost[1].item_type
    local has_num = ex.Player:getItemNum(item_type)
    local need_num = self.data.cost[1].item_num
    if has_num >= need_num then 
        print(self.__cname,"send proto ")

        local proto = TweakCube_pb.GReqTrenchOpen()
        NetManager:sendMessage(ProtocolID.GReqTrenchOpen)
    else
        ex.MessageView:add(ex.Tools:getLang(77317))
    end 
    UnlockCubeCtr:instance():closeWindow()
end

function UnlockCubeLayer:onClose(tag,pSender)
    UnlockCubeCtr:instance():closeWindow()
end

-----------------------------------------------------------------------------
function UnlockCubeCtr:onCreate()
	self:setCCBIPath("ccbi/UnlockCubeLayer.ccbi")
	self:setIsSingle(false)
end

function UnlockCubeCtr:getLayerClass()
	return UnlockCubeLayer
end

function UnlockCubeCtr:getUnlockCubeLayer()
	return self.layer
end

function UnlockCubeCtr:openWindow(data)
	if self:isOpened() then
		return
	end
	local sfc = cc.SpriteFrameCache:getInstance()
    -- sfc:addSpriteFrames("ccbi-res/achievement.plist")
    -- sfc:addSpriteFrames("ccbi-res/box-effect.plist")
    --sfc:addSpriteFrames("ccbi-res/runes.plist")

	self:loadLayer()
    self:open()
    self.layer.data = data
    self.layer:updateView(data)
end

return UnlockCubeCtr
