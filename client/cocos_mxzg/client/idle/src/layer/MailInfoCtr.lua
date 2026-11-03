local MailInfoCtr = class("MailInfoCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local MailInfoLayer = class("MailInfoLayer", require("src.comp.LuaLayerBase"))

function MailInfoLayer:onCreate()
	self:addBlackBackground()
	local win_size = cc.Director:getInstance():getWinSize();
	local height = Maths.min(self:getContentSize().height, win_size.height);
	self:setScale(height / self:getContentSize().height);
	self.lbl_mail_title:setString(ex.Tools:getLang(5789))
	self.lbl_mail_title:setColor(cc.c3b(122,71,45))
	self.lbl_day:setColor(cc.c3b(122,71,45))
	self.lbl_title:setColor(cc.c3b(122,71,45))
	local faceFont = FONT_DEFAULT_NAME_BOLD
    local languageConfig = cfg.languagetype.languagetype[ex.Player.server_lang]
    if languageConfig and languageConfig.font then
        faceFont = languageConfig.font
    end
    local t = self.lbl_title:getTTFConfig()
	t.fontName = faceFont
	self.lbl_title:setTTFConfig(t)

    local item_size = cc.size(104 * 0.75 + 15, 104 * 0.75 + 15)
    self.scroll_view.margin = 2.5
	self.scroll_view:setItemSize(item_size)
	
	local view_size = self.scroll_view_text:getViewSize()
	self.lbl_content = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(40)
	:setFontFace(faceFont)
	:setFontColor("#7A473A")
	:setScale(0.5)
	:setAnchorTextShadow(true)
	:ignoreContentAdaptWithSize(false)
	:setWrapMode(1)
	:setContentSize(cc.size(view_size.width  / 0.5, view_size.height / 0.5))
	:setPosition(cc.p(view_size.width * 0.5, view_size.height))
	:setAnchorPoint(ex.a.top_center)
	-- self.scroll_view_text:addChild(self.lbl_content)
	self:addChild(self.lbl_content)
end

-----------------------------------------------------------------------------
function MailInfoCtr:onCreate()
	self:setCCBIPath("ccbi/MailInfoLayer.ccbi")
	self:setIsSingle(false)
end

function MailInfoCtr:getLayerClass()
	return MailInfoLayer
end

function MailInfoCtr:getMailInfoLayer()
	return self.layer
end

function MailInfoCtr:openWindow(mail_id)
	if self:isOpened() then
		return
	end

	local mail_data = ex.Player.mail_data:getMailData(mail_id)
	if not mail_data then
		return
	end

	self:loadLayer()
	self:open()
	self:initDone(mail_id)
end

function MailInfoCtr:initDone(mail_id)
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	
	self.layer.btn_reward:setLabelSize(50)
	self.layer.btn_reward:registerScriptTapHandler(handler(self, self.onReward))
	
	self:updateLayer(mail_id)
end

function MailInfoCtr:updateLayer(mail_id)
	local mail_data = ex.Player.mail_data:getMailData(mail_id)
	if not mail_data then
		self:closeWindow(0, nil)
	end
--获取时间，然后判断是否以读取文件
	self.layer.lbl_day:setString(ex.StringUtil.convertToHowLong(cpp.Game:instance():getServerTime() - mail_data.time).."前")
	if mail_data.is_read==0 then
		if mail_data.is_receive==0 and table.nums(mail_data.vec_reward>0) then
			self.layer.spr_mail_icon:setSpriteFrame("mail/spr-mail-reward-unopen.png")
        else
            self.layer.spr_mail_icon:setSpriteFrame("mail/spr-mail-unopen.png")
		end
	else
        if mail_data.is_receive == 0 and table.nums(mail_data.vec_reward) > 0 then
            self.layer.spr_mail_icon:setSpriteFrame("mail/spr-mail-reward-open.png")
        else
            self.layer.spr_mail_icon:setSpriteFrame("mail/spr-mail-open.png")
        end
	end


	self.layer.mail_id = mail_id;
	self.layer.lbl_title:setString(mail_data.str_title)
	self.layer.lbl_content:setXmlTextLua(mail_data.str_content)
	self.layer.lbl_content:formatText()
	self.layer.lbl_content:setPosition(self.layer.scroll_view_text:getPosition())

	local content_size = self.layer.lbl_content:getContentSize()
	content_size.width = content_size.width * self.layer.lbl_content:getScale()
	content_size.height = content_size.height * self.layer.lbl_content:getScale()
	self.layer.scroll_view:setPosition(self.layer.scroll_view_text:getPositionX(),self.layer.scroll_view_text:getPositionY()-content_size.height-80)
	

	-- local view_size = self.layer.scroll_view_text:getViewSize()
	-- if content_size.height > view_size.height then
	-- 	self.layer.lbl_content:setPositionY(content_size.height)
	-- 	self.layer.scroll_view_text:setContentSize(cc.size(view_size.width, content_size.height))
	-- 	self.layer.scroll_view_text:setContentOffset(cc.p(0, view_size.height - content_size.height))
	-- else
	-- 	self.layer.scroll_view_text:setContentSize(view_size)
	-- end

	-- 邮件奖励
	self.layer.scroll_view:getContainer():removeAllChildren()

	local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")
	local UIMenuItemHeroPiece = require("src.comp.menu.UIMenuItemHeroPiece")

    self.layer.scroll_view.createItemFunction = function(data)
		local item = nil
		if ex.Player.backpack_data:isPiece(data.item_type) then
			item = UIMenuItemHeroPiece:createWithData(data.item_type)
			item:setNum(data.item_num)
		else
			item = UIMenuItemBackpack:createWithData(data.item_type, data.item_num)
		end
        item:setScale(0.75)
		item:registerScriptTapHandler(handler(self, self.onItemInfo))
		
		if mail_data.is_receive ~= 0 then
			item:setGrayed()
	  	end

        return item
	end
    self.layer.scroll_view:reloadData(mail_data.vec_reward)
	
	if #mail_data.vec_reward <= 0 then
		self.layer.btn_reward:setVisible(false)
	elseif mail_data.is_receive ~= 0 then
		self.layer.btn_reward:setVisible(true)
		self.layer.btn_reward:setLabelText(ex.Tools:getLang(47756))
		self:changeSprite("button/btn-green-1.png")
	else
		self.layer.btn_reward:setVisible(true)
		self.layer.btn_reward:setLabelText(ex.Tools:getLang(47695))
		self:changeSprite("button/btn-orange-1.png")
	end
end

function MailInfoCtr:changeSprite(str_btn_name)
	self.layer.btn_reward:setNormalImage(cc.Sprite:createWithSpriteFrameName(str_btn_name))
	self.layer.btn_reward:setSelectedImage(cc.Sprite:createWithSpriteFrameName(str_btn_name))	
end

function MailInfoCtr:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function MailInfoCtr:onReward(tag, pSender)
	local mail_data = ex.Player.mail_data:getMailData(self.layer.mail_id)
	if not mail_data then
		self:closeWindow(0, nil)
	end

	if mail_data.is_receive ~= 0 then
		-- 删除
		local req_delete = Mail_pb.GReqDealWithMail()
		req_delete.type = 2
		req_delete.mail_id = mail_data.mail_id
		NetManager:sendMessage(ProtocolID.GReqDealWithMail, req_delete)

		ex.Player.mail_data:delMailData(mail_data.mail_id)
		require("src.layer.MailCtr"):instance():updateLayer()
		self:closeWindow(0, nil)
		return
	else
		-- 领取
		local req_reward = Mail_pb.GReqDealWithMail()
		req_reward.type = 1
		req_reward.mail_id = mail_data.mail_id
		NetManager:sendMessage(ProtocolID.GReqDealWithMail, req_reward)
		mail_data.is_receive = 1

		require("src.layer.MailCtr"):instance():updateLayer()
		
		-- require("src.layer.ItemRewardCtr"):instance():openWindow(mail_data.vec_reward)
		-- for k,v in pairs(mail_data.vec_reward) do
		-- 	ex.Player:addItem(v.item_type, v.item_num)
		-- end
		
		NetManager:sendMessage(ProtocolID.GReqBackPackList)
	end

	self:updateLayer(mail_data.mail_id)
end

return MailInfoCtr
