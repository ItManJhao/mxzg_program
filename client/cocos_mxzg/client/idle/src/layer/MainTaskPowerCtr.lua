local MainTaskPowerCtr = class("MainTaskPowerCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local MainTaskPowerLayer = class("MainTaskPowerLayer", require("src.comp.LuaLayerBase"))


function MainTaskPowerLayer:onCreate()
	--self:addBlackBackground()

end


-----------------------------------------------------------------------------
function MainTaskPowerCtr:onCreate()
	self:setCCBIPath("ccbi/MainTaskPowerLayer.ccbi")
	self:setIsSingle(false)
end


function MainTaskPowerCtr:getLayerClass()
	return MainTaskPowerLayer
end

function MainTaskPowerCtr:openWindow()
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initDone()
end

function MainTaskPowerCtr:initDone()


    -- 从新排放位置
    self.layer.spr_bg:setPosition(self.layer.spr_bg:getPositionX() - 100, 110 )
    self.layer.label_1:setPosition(self.layer.spr_bg:getPositionX() + 20, self.layer.spr_bg:getPositionY() + self.layer.spr_bg:getContentSize().height - 30  )
    self.layer.label_2:setPosition(self.layer.spr_bg:getPositionX() + 20,self.layer.spr_bg:getPositionY() + self.layer.spr_bg:getContentSize().height - 40 )
    self.layer.label_3:setPosition(self.layer.spr_bg:getPositionX() + 20,self.layer.spr_bg:getPositionY() + self.layer.spr_bg:getContentSize().height - 130  )
    self.layer.label_4:setPosition(self.layer.spr_bg:getPositionX() + 20,self.layer.spr_bg:getPositionY() + self.layer.spr_bg:getContentSize().height - 140  )
    
    -- 创建两个富文本
    
    local label1 = require("src.comp.RichTextEx"):create()
	:setFontSize(18)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setAnchorTextShadow(true)
    :setWrapMode(1)
    
    local label2 = require("src.comp.RichTextEx"):create()
	:setFontSize(18)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setAnchorTextShadow(true)
    :setWrapMode(1)
    
    label1:setPosition(self.layer.spr_bg:getPositionX() + self.layer.spr_bg:getContentSize().width - 60 , self.layer.spr_bg:getPositionY() + self.layer.spr_bg:getContentSize().height - 90 )
    label2:setPosition(self.layer.spr_bg:getPositionX() + self.layer.spr_bg:getContentSize().width - 60 , self.layer.spr_bg:getPositionY() + self.layer.spr_bg:getContentSize().height - 200)
    

    local label_1_str = ex.Tools:getLang(41192)
    if ex.Player.pub_task.high == 1 then 
        label_1_str = ex.Tools:getLang(41193)
    end 

    local label_2_str = ex.Tools:getLang(41192)
    if ex.Player.pub_task.luxury == 1 then 
        label_2_str = ex.Tools:getLang(41193)
    end 

	label1:setXmlTextLua(label_1_str)
    label2:setXmlTextLua(label_2_str)

    label1:setCallback(handler(self, self.openRichTextUrl))
    label2:setCallback(handler(self, self.openRichTextUrl))

    self.layer:addChild(label1)    
    self.layer:addChild(label2)    

    self.layer.label_1:setString(ex.Tools:getLang(41188))
    self.layer.label_2:setString(ex.Tools:getLang(41189))
    self.layer.label_3:setString(ex.Tools:getLang(41190))
    self.layer.label_4:setString(ex.Tools:getLang(41191))
    

end


function MainTaskPowerCtr:openRichTextUrl(url)
    if string.len(url) <= 0 then
        return
    end
    require("src.layer.MainTaskCtr"):instance():closeWindow()

    self:closeWindow(0, nil)

    local backToLayer =  function ( layer )
        require("src.layer.MainTaskCtr"):instance():openWindow()
    end
    local params = {}
    params.backToLayer = backToLayer
    ex.JumpManager:jumpByAtom(url, params)
end

return MainTaskPowerCtr


