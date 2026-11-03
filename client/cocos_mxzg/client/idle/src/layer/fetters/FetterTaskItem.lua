local FetterTaskItem = class("FetterTaskItem", require("src.comp.EventLayer"))

function FetterTaskItem:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
	self.btn_submit:registerScriptTapHandler(handler(self,self.onSubmit))
	self.btn_goto:registerScriptTapHandler(handler(self,self.onGoto))

	self.btn_goto:setName("fetter_task_go")

	local lbl_goto = cc.Label:createWithTTF(ex.Tools:getLang(47627), FONT_DEFAULT_NAME_BOLD, 20)
	lbl_goto:enableOutline(cc.c3b(141,90,62), 1)
	self.btn_goto:addChild(lbl_goto)
	lbl_goto:setPosition(self.btn_goto:getContentSize().width / 2 ,self.btn_goto:getContentSize().height / 2)

	local lbl_submit = cc.Label:createWithTTF(ex.Tools:getLang(47695), FONT_DEFAULT_NAME_BOLD, 20)
	lbl_submit:enableOutline(cc.c3b(141,90,62), 1)
	self.btn_submit:addChild(lbl_submit)
	lbl_submit:setPosition(self.btn_submit:getContentSize().width / 2 ,self.btn_submit:getContentSize().height / 2)

	self.lbl_name = cpp.RichTextEx:createWithXMLLua("")
	self.lbl_name:setFontSize(40)
	self.lbl_name:setScale(0.5)
	self.lbl_name:setFontFace(FONT_DEFAULT_NAME_BOLD)
	self.lbl_name:setFontColor("#7A472D")
	self.lbl_name:setAnchorTextShadow(false)
	self.lbl_name:setAnchorPoint(ex.a.left_center)
    self.lbl_name:setPosition(cc.p(24, 93))
    self.lbl_name:setLocalZOrder(10)
    self:addChild(self.lbl_name)
end

function FetterTaskItem:reset(data)
	self.data = data
	
	local progress = ex.Player.fetter_data.vip:getProgress(self.data.idx) or 0
	local status = ex.Player.fetter_data.vip:getStatus(self.data.idx) or 1
	
	local str = ex.Tools:taskString(self.data.lang, self.data.task.target, self.data.task.condition, self.data.task.subCondition)
	-- dump(data)
	str = str..string.format("(%s/%s)", ex.StringUtil.getScientificNumber(math.min(progress, self.data.task.target)), ex.StringUtil.getScientificNumber(self.data.task.target))
	self.lbl_name:setXmlTextLua(str)

	local x,y = self.item_node:getPosition()
	local item = self.menu:getChildByName("item")
	if item ~= nil then 
		item:removeFromParent()
		item = nil 
	end

	-- dump(data.reward, "FetterTaskItem:reset")
	if self.data.reward ~= "" and self.data.reward ~= nil then 
		item = ex.Tools:createBackpackItem(self.data.reward[1].item_type, self.data.reward[1].item_num)
		self.menu:addChild(item)	
		item:setPosition(x,y)
		item:setScale(0.6)
		item:registerScriptTapHandler(handler(self, self.onItem))
	end

	self.can = progress >= self.data.task.target and status == 0

	self.btn_submit:setVisible(self.can or (status == 0 and self.data.jump_info.event_type ~= 1))
	self.btn_goto:setVisible(not self.can and status == 0 and self.data.jump_info.event_type == 1)
	self.spr_clear:setVisible(status ~= 0)

	ex.Tools:addRedPoint(self.btn_submit,self.can)
end


-- 羁绊幻化
function FetterTaskItem:resetWithLlusion(data)
	self.data = data
	
	local progress = ex.Player.fetter_data.vip:getProgress(self.data.idx) or 0
	local status = ex.Player.fetter_data.vip:getStatus(self.data.idx) or 1
	
	local str = ex.Tools:taskString(self.data.lang, self.data.task.target, self.data.task.condition, self.data.task.subCondition)
	-- dump(data)
	str = str..string.format("(%s/%s)", ex.StringUtil.getScientificNumber(math.min(progress, self.data.task.target)), ex.StringUtil.getScientificNumber(self.data.task.target))
	self.lbl_name:setXmlTextLua(str)

	local x,y = self.item_node:getPosition()
	local item = self.menu:getChildByName("item")
	if item ~= nil then 
		item:removeFromParent()
		item = nil 
	end

	-- dump(data.reward, "FetterTaskItem:reset")
	if self.data.reward ~= "" and self.data.reward ~= nil then 
		item = ex.Tools:createBackpackItem(self.data.reward[1].item_type, self.data.reward[1].item_num)
		self.menu:addChild(item)	
		item:setPosition(x,y)
		item:setScale(0.6)
		item:registerScriptTapHandler(handler(self, self.onItem))
	end

	self.can = progress >= self.data.task.target and status == 0

	self.btn_submit:setVisible(self.can or (status == 0 and self.data.jump_info.event_type ~= 1))
	self.btn_goto:setVisible(not self.can and status == 0 and self.data.jump_info.event_type == 1)
	self.spr_clear:setVisible(status ~= 0)

	ex.Tools:addRedPoint(self.btn_submit,self.can)

end


function FetterTaskItem:onItem(tag,pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

function FetterTaskItem:onGoto(tag,pSender)
	-- dump(self.data)
	ex.JumpManager:jumpByAtom(tostring(self.data.jump_info.event_arg))
end

function FetterTaskItem:onSubmit(tag,pSender)
	if self.can then
		local req_reward = Fetter_pb.GReqFetterReward()
		req_reward.idx = self.data.idx
		NetManager:sendMessage(ProtocolID.GReqFetterReward, req_reward)
	else
		ex.MessageView:add(ex.Tools:getLang(self.data.jump_info.no_jump_hint))
	end
end

return FetterTaskItem
