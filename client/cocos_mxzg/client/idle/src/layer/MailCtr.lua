local MailCtr = class("MailCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local MailLayer = class("MailLayer", require("src.comp.EventLayerAdaptiveWidth"))
local MailCell = class("MailCell", require("src.comp.LuaLayerBase"))

function MailCell:onCreate()
	self:setAutoClose(false)
    self:setSwallowTouches(false)
    self.lbl_title:setColor(cc.c3b(122,71,45))
    local faceFont = FONT_DEFAULT_NAME_BOLD
    local languageConfig = cfg.languagetype.languagetype[ex.Player.server_lang]
    if languageConfig and languageConfig.font then
        faceFont = languageConfig.font
    end
    local t = self.lbl_title:getTTFConfig()
	t.fontName = faceFont
	self.lbl_title:setTTFConfig(t)

    self.lbl_time:setColor(cc.c3b(122,71,45))
end

function MailCell:initData(data)
    if data == nil then
        return
    end
    self.data_time=data

    self.mail_id = data.mail_id

    self.lbl_title:setString(data.str_title)
    if data.is_read == 0 then
        self.lbl_reward:setString(ex.Tools:getLang(47755))
        self.lbl_reward:setColor(cc.c3b(222,21,3))
        if data.is_receive == 0 and table.nums(data.vec_reward) > 0 then
            self.spr_mail_icon:setSpriteFrame("mail/spr-mail-reward-unopen.png")
        else
            self.spr_mail_icon:setSpriteFrame("mail/spr-mail-unopen.png")
        end
    else
        self.lbl_reward:setString(ex.Tools:getLang(47613))
        self.lbl_reward:setColor(cc.c3b(33,154,0)) 
        if data.is_receive == 0 and table.nums(data.vec_reward) > 0 then
            self.spr_mail_icon:setSpriteFrame("mail/spr-mail-reward-open.png")
        else
            self.spr_mail_icon:setSpriteFrame("mail/spr-mail-open.png")
        end
    end
    self.lbl_time:setString(ex.StringUtil.convertToHowLong(cpp.Game:instance():getServerTime() - data.time)..ex.Tools:getLang(5795))
    
end
function MailLayer:onCreate()
    self:addBlackBackground()

   
	self.btn_delete_read:setLabelText(ex.Tools:getLang(47752))
    self.btn_reward_all:setLabelText(ex.Tools:getLang(47179))
    
    self.scroll_view:setItemType(1)
    self.scroll_view:setItemSize(cc.size(480, 117))

    self:addEvent(EVENT.MAIL.UPDATE, function()
        self.scroll_view:reloadData(ex.Player.mail_data.data)
    end)
end

-----------------------------------------------------------------------------
function MailCtr:onCreate()
	self:setCCBIPath("ccbi/MailLayer.ccbi")
	self:setIsSingle(false)
end

function MailCtr:getLayerClass()
	return MailLayer
end

function MailCtr:getMailLayer()
	return self.layer
end

function MailCtr:openWindow()
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initDone()
end

function MailCtr:initDone()

    ex.Player.mail_data:sortMailIsRead()
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.onBtnClose))
	
	self.layer.btn_delete_read:registerScriptTapHandler(handler(self, self.onDeleteAll))
	self.layer.btn_reward_all:registerScriptTapHandler(handler(self, self.onRewardAll))
    
	self:updateLayer()
end

function MailCtr:updateLayer()
	if not self:getLayer() then
		return
    end
    
    table.sort(ex.Player.mail_data.data, function(a, b)
        return a.time > b.time
    end)

    -- ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_YJ, false)
    self.layer.scroll_view.createItemFunction = function(data, scale)
        -- 创建ccbi cell
        local cell_layer = MailCell:createWithCCBIFile("ccbi/MailCell.ccbi")
        cell_layer:setIgnoreAnchorPointForPosition(false)
        cell_layer:setAnchorPoint(0.5, 0.5)

        cell_layer:initData(data)

        return cell_layer
    end
    self.layer.scroll_view.nodeTouched = function(tag, cell)
        local mail_id = cell.mail_id
    
        local mail_data = ex.Player.mail_data:getMailData(mail_id)
        if not mail_data then
            return
        end
    
        if cell.spr_reddot ~= nil then
            cell.spr_reddot:setVisible(false)
        end
    
        mail_data.is_read = 1
        local req_read = Mail_pb.GReqDealWithMail()
        req_read.type = 0
        req_read.mail_id = mail_data.mail_id
        NetManager:sendMessage(ProtocolID.GReqDealWithMail, req_read)
        
        ex.Player.mail_data:checkRedDot()
        require("src.layer.MailInfoCtr"):instance():openWindow(mail_id)
    
        cell:initData(mail_data)

	    ex.Player.mail_data:sortMailIsRead()

        self:updateLayer()
    end
    self.layer.scroll_view:reloadData(ex.Player.mail_data.data)
end

function MailCtr:onDeleteAll()

    NetManager:sendMessage(ProtocolID.GReqDeleteAllMail)

    -- for i=#ex.Player.mail_data.data,1,-1 do
    --     local v = ex.Player.mail_data.data[i]
    --     if v.is_read and (v.is_receive == 1 or table.nums(v.vec_reward) <= 0) then
    --         -- 删除
    --         local req_delete = Mail_pb.GReqDealWithMail()
    --         req_delete.type = 2
    --         req_delete.mail_id = v.mail_id
    --         NetManager:sendMessage(ProtocolID.GReqDealWithMail, req_delete)
    --         table.remove(ex.Player.mail_data.data, i)
    --     end
    -- end

    -- -- 邮件
    -- NetManager:sendMessage(ProtocolID.GReqMailList)
    
    -- self:updateLayer()
end

function MailCtr:onRewardAll()


	NetManager:sendMessage(ProtocolID.GReqReceiveAllMail)


    -- local vec_reward = {}
    -- for i=#ex.Player.mail_data.data,1,-1 do
    --     local v = ex.Player.mail_data.data[i]
    --     if (v.is_receive == 0 and table.nums(v.vec_reward) > 0) then
    --         -- 标记为已读
    --         local req_read = Mail_pb.GReqDealWithMail()
    --         req_read.type = 0
    --         req_read.mail_id = v.mail_id
    --         NetManager:sendMessage(ProtocolID.GReqDealWithMail, req_read)

    --         -- 领取
    --         local req_reward = Mail_pb.GReqDealWithMail()
    --         req_reward.type = 1
    --         req_reward.mail_id = v.mail_id
    --         NetManager:sendMessage(ProtocolID.GReqDealWithMail, req_reward)

    --         TableEx.mergeTables(vec_reward, v.vec_reward) 
    --         v.is_read = 1
    --         v.is_receive = 1
    --     end
    -- end
    -- self:updateLayer()

    -- for k,v in pairs(vec_reward) do
    --     ex.Player:addItem(v.item_type, v.item_num)
    -- end

    -- -- 合并奖励
    -- vec_reward = TableEx.mergeTableValue(vec_reward, "item_type", function(v1, v2)
    -- 	v1.item_num = v1.item_num + v2.item_num
	-- end)

	-- dump(vec_reward)

	-- 邮件
	-- NetManager:sendMessage(ProtocolID.GReqMailList)

    -- if table.nums(vec_reward) > 0 then
    --     require("src.layer.ItemRewardCtr"):instance():openWindow(vec_reward)
    -- end
end

function MailCtr:onBtnClose(tag, pSender)
    ex.Player.mail_data:checkRedDot()
    self:closeWindow(nil, self.layer)
end

return MailCtr
