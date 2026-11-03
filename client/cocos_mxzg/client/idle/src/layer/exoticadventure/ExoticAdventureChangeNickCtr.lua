--[[
* @Description: 异界冒险-船长室-修改昵称
* @Author: 熊梦
* @Date: 2020-07-27 18:00:00
* ]]
local ExoticAdventureChangeNickCtr = class("ExoticAdventureChangeNickCtr",require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ExoticAdventureChangeNickLayer = class("ExoticAdventureChangeNickLayer",require("src.comp.EventLayerAdaptiveWidth"))

local max_length = cfg.system.spacetime_name_max / 2
function ExoticAdventureChangeNickLayer:onCreate()
    self:addBlackBackground()
    self:registerBtnEvent()
    self:inidata()
end

function ExoticAdventureChangeNickLayer:inidata(  )
	-- ex.Player.exotic_adventure_data.level = data.level 			--舰队等级
	-- ex.Player.exotic_adventure_data.exp = data.exp 				--舰队经验
	-- ex.Player.exotic_adventure_data.nick = data.nick 				--舰队名字
	-- ex.Player.exotic_adventure_data.durability = data.durability 	--耐久度
	-- ex.Player.exotic_adventure_data.skill_num = data.skill_num 	--剩余科技点
	-- ex.Player.exotic_adventure_data.skill = data.skill				--科技信息

	self.edit_box = ccui.EditBox:create(cc.size(self.spr_input_bg:getContentSize().width * self.spr_input_bg:getScaleX() - 10,
													 self.spr_input_bg:getContentSize().height * self.spr_input_bg:getScaleY()),
													 "other/spr-null.png", 1)  --输入框尺寸，背景图片
    self.edit_box:setPosition(cc.p(self.spr_input_bg:getPositionX() + 5, self.spr_input_bg:getPositionY()))
    self.edit_box:setAnchorPoint(cc.p(0.5, 0.5))
	self.edit_box:setMaxLength(50)
	self.edit_box:setName("Change_Nick")
    self.edit_box:setFontSize(26)
    self.edit_box:setFontColor(cc.WHITE)
    self.edit_box:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND) --输入键盘返回类型，done，send，go等
    self.edit_box:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE) --输入模型，如整数类型，URL，电话号码等，会检测是否符合
    self.edit_box:setPlaceholderFontSize(26)
	self.edit_box:setPlaceHolder(ex.Tools:getLang(76557)) 
	self.edit_box:registerScriptEditBoxHandler(handler(self, self.editboxHandle)) --输入框的事件，主要有光标移进去，光标移出来，以及输入内容改变等
	self.node_bg:addChild(self.edit_box, 9999)

	
	self:addEvent(EVENT.EXOTICADVENTURE.UPDATA_NICK,handler(self,self.updataNick))
end

function ExoticAdventureChangeNickLayer:updataNick( )
	ExoticAdventureChangeNickCtr:instance():closeWindow()
end

-- 关闭按钮
function ExoticAdventureChangeNickLayer:registerBtnEvent( )
	local ctr = ExoticAdventureChangeNickCtr:instance()
	self.btn_close:registerScriptTapHandler(handler(ctr, ctr.closeWindow))
end

function ExoticAdventureChangeNickLayer:editboxHandle(event, sender)
	if event == "began" then 
		-- sender:selectedAll()
	elseif event == "ended" then 
		local str = sender:getText()
		local length = math.floor(max_length * 4)
		str = cpp.StringUtil:cutNameWithLength(str, length, 2, 4)
		print("str_name", str)
    	sender:setText(str)

	elseif event == "changed" then

	end
end

function ExoticAdventureChangeNickLayer:onSendNick(tag , pSender)

	local str_chat_text = self.edit_box:getText()
	local str_tmp = string.gsub(str_chat_text, " ", "")
    local str_tmp = string.gsub(str_tmp, "\n", "")
    if string.len(str_tmp) <= 0 then
		ex.MessageView:add(ex.Tools:getLang(41025))
		self.edit_box:setText("")
        return
    end
	
	if self.edit_box:getText() == "" then
		ex.MessageView:add(ex.Tools:getLang(4608))
	else
		local req = SpaceTimeAdventure_pb.GReqModifyName()
		req.name = self.edit_box:getText()
		NetManager:sendMessage(ProtocolID.GReqModifyName, req)
		self.edit_box:setText("")
	end
end

-----------------------------------------------------------------------------
function ExoticAdventureChangeNickCtr:onCreate()
	self:setCCBIPath("ccbi/ExoticAdventureChangeNickLayer.ccbi")
	self:setIsSingle(false)
end

function ExoticAdventureChangeNickCtr:getLayerClass()
	return ExoticAdventureChangeNickLayer
end

function ExoticAdventureChangeNickCtr:openWindow()
	if self:isOpened() then
		return
	end
	self:loadLayer()
	self:open()
end

function ExoticAdventureChangeNickCtr:initData()

end

return ExoticAdventureChangeNickCtr
