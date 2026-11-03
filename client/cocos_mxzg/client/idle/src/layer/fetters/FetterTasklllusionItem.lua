--[[
* @Description: 羁绊幻化-任务
* @Author: 熊梦
* @Date: 2020-07-21 11:07:00
* ]]

local FetterTasklllusionItem = class("FetterTasklllusionItem", require("src.comp.EventLayer"))

function FetterTasklllusionItem:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
	self.btn_submit:registerScriptTapHandler(handler(self,self.onSubmit))
	--self.btn_goto:registerScriptTapHandler(handler(self,self.onGoto))

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


function FetterTasklllusionItem:getProgress(idx)
	for i,v in ipairs(ex.Player.fetter_data.fetterIllusionTaskInfo) do
		if v.task_id == idx then	
			return v.process
		end
	end
	return 0
end

function FetterTasklllusionItem:getStatus(idx)
	for i,v in ipairs(ex.Player.fetter_data.fetterIllusionTaskInfo) do
		if v.task_id == idx and v.had_reward == true then	
			return 1
		end
	end
	return 0
end

function FetterTasklllusionItem:reset(data)
	self.data = data

	local progress = self:getProgress(self.data.idx)
	local status = self:getStatus(self.data.idx)
	
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

	self.can = false
	if progress >= self.data.task.target then
		self.can = true
	end

	print("=====================",status,self.data.idx)
	if status == 1 then
		self.btn_submit:setVisible(false)
		self.btn_goto:setVisible(false)
		self.spr_clear:setVisible(true)
		ex.Tools:addRedPoint(self.btn_submit,false)
	else
		self.btn_submit:setVisible(self.can )
		self.btn_goto:setVisible(not self.can )
		self.spr_clear:setVisible(false)
		ex.Tools:addRedPoint(self.btn_submit,self.can)
	end

end

function FetterTasklllusionItem:onItem(tag,pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

-- function FetterTasklllusionItem:onGoto(tag,pSender)
-- 	ex.JumpManager:jumpByAtom(tostring(self.data.jump_info.event_arg))
-- end

function FetterTasklllusionItem:onSubmit(tag,pSender)
	if self.can then
		local req = Fetter_pb.GReqFashionTaskGet()
		req.task_id = self.data.idx
		NetManager:sendMessage(ProtocolID.GReqFashionTaskGet, req)
	else
		ex.MessageView:add(ex.Tools:getLang(self.data.jump_info.no_jump_hint))
	end
end

return FetterTasklllusionItem
